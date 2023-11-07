import 'dart:typed_data';

import 'package:comepaga/model/delivery/pedido.dart';
import 'package:comepaga/model/delivery/reparto.dart';
import 'package:comepaga/model/restaurant/plato.dart';
import 'package:comepaga/model/restaurant/restaurante.dart';
import 'package:comepaga/model/user/repartidor.dart';
import 'package:comepaga/screen/args/home_screen_args.dart';
import 'package:comepaga/screen/args/pedidos_pendientes_args.dart';
import 'package:comepaga/screen/args/reparto_screen_args.dart';
import 'package:comepaga/service/call_service.dart';
import 'package:comepaga/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/restaurant/plato_pedido.dart';

class RepartoScreen extends StatefulWidget {
  const RepartoScreen({super.key});

  @override
  State<RepartoScreen> createState() => _RepartoScreenState();
}

class _RepartoScreenState extends State<RepartoScreen> {
  String? _groupvalue = '1';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as RepartoScreenArgs;

    return WillPopScope(
        onWillPop: () async {
          Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false,
              arguments: HomeScreenArgs(user: args.repartidor));
          return true;
        },
        child: Scaffold(
          backgroundColor: AppTheme.primaryColor,
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.grey.shade300,
            title: const Text('Current delivery'),
          ),
          body: args.repartidor.pedidoId == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "You don't have any assigned orders!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                      Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            const Image(
                                image: AssetImage('assets/ComeYPaga.png')),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, 'pedidos_pendientes', (route) => false,
                                      arguments: PedidosPendientesArgs(args.repartidor));
                                },
                                style: ButtonStyle(
                                    fixedSize: MaterialStatePropertyAll(Size(
                                        MediaQuery.of(context).size.width * 0.7,
                                        40)),
                                    shadowColor: const MaterialStatePropertyAll(
                                        Colors.black),
                                    foregroundColor:
                                        const MaterialStatePropertyAll(
                                            Colors.white),
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.grey.shade300.withOpacity(0.8))),
                                child: const Text(
                                  'Get an order',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )),
                          ]),
                    ],
                  ),
                )
              : FutureBuilder(
                  future:
                      getReparto(args.reparto, args.repartidor.nombreUsuario!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Reparto reparto = snapshot.data!;

                      return Center(
                          child: Container(
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.03),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.height * 0.03,
                              child: FutureBuilder<ImageProvider>(
                                  future:
                                      getRestaurantImgByRerarto(reparto.id!),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Image(
                                        fit: BoxFit.cover,
                                        image: snapshot.data ??
                                            const AssetImage(
                                                'assets/ComeYPaga.png'),
                                      );
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.red,
                                        ),
                                      );
                                    }
                                  }),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              height: MediaQuery.of(context).size.height * 0.45,
                              width: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.height * 0.03,
                              child: Scrollbar(
                                interactive: true,
                                radius: const Radius.circular(30),
                                thumbVisibility: true,
                                trackVisibility: true,
                                child: ListView(
                                  children: [
                                    FutureBuilder(
                                      future: updateGroupValue(reparto),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          String? groupvalue = snapshot.data!;

                                          return Builder(builder: (context2) {
                                            return Column(
                                              children: [
                                                ListTile(
                                                  leading: Radio(
                                                      value: '1',
                                                      groupValue: groupvalue,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          (context2 as Element)
                                                              .markNeedsBuild();
                                                          groupvalue = value;
                                                          updatePedidoStatus(
                                                              reparto.id!,
                                                              groupvalue!);
                                                        });
                                                      }),
                                                  title:
                                                      const Text('In process'),
                                                ),
                                                ListTile(
                                                  leading: Radio(
                                                      value: '2',
                                                      groupValue: groupvalue,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          (context2 as Element)
                                                              .markNeedsBuild();
                                                          groupvalue = value;
                                                          updatePedidoStatus(
                                                              reparto.id!,
                                                              groupvalue!);
                                                        });
                                                      }),
                                                  title: const Text('Cast in'),
                                                ),
                                              ],
                                            );
                                          });
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    ),
                                    const Divider(
                                      thickness: 2,
                                      indent: 20,
                                      endIndent: 20,
                                    ),
                                    FutureBuilder<Pedido?>(
                                        future: getPedidoByReparto(reparto.id!),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            Pedido pedido = snapshot.data!;

                                            return getResumeLine(
                                                'Deadline',
                                                formatDate(
                                                    pedido.fechaEntrega!));
                                          } else {
                                            return getDefaultLoader();
                                          }
                                        }),
                                    FutureBuilder<double>(
                                        future: calculateTotalByReparto(
                                            reparto.id!),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            double total = snapshot.data!;

                                            return getResumeLine('Price',
                                                '${total.toString()} €');
                                          } else {
                                            return getDefaultLoader();
                                          }
                                        }),
                                    FutureBuilder<Pedido?>(
                                        future: getPedidoByReparto(reparto.id!),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            Pedido pedido = snapshot.data!;

                                            return getResumeLine('Location',
                                                pedido.ubicacionReparto!);
                                          } else {
                                            return getDefaultLoader();
                                          }
                                        }),
                                    FutureBuilder<Pedido?>(
                                        future: getPedidoByReparto(reparto.id!),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            Pedido pedido = snapshot.data!;

                                            return getResumeLine(
                                                'Date Order',
                                                formatDate(
                                                    pedido.fechaInicio!));
                                          } else {
                                            return getDefaultLoader();
                                          }
                                        }),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      updatePedidoStatus(reparto.id!, '-1');
                                      setState(() {});
                                    },
                                    child: const Text('Late')),
                                ElevatedButton(
                                  onPressed: () {
                                    updatePedidoStatus(reparto.id!, '3');
                                    args.repartidor.pedidoId = null;
                                    updateRepartidor(args.repartidor);
                                    Navigator.pop(context);
                                  },
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          AppTheme.green)),
                                  child: const Text('Delivered'),
                                )
                              ],
                            )
                          ],
                        ),
                      ));
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey.shade300,
                        ),
                      );
                    }
                  }),
        ));
  }

  Widget getResumeLine(String title, String body) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(body),
      ),
    );
  }

  Future<Pedido?> getPedidoByReparto(String id) async {
    CallService<Pedido> service =
        CallService(uri: 'pedido', fromJson: Pedido.fromJson);

    return await service.get({}, '/$id/pedido');
  }

  Widget getDefaultLoader() {
    return ListTile(
      title: Container(
        margin:
            EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.45),
        child: LinearProgressIndicator(
          minHeight: 10,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade300),
        ),
      ),
      subtitle: Container(
        margin: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.35, left: 10),
        child: LinearProgressIndicator(
          minHeight: 10,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade300),
        ),
      ),
    );
  }

  Future<ImageProvider> getRestaurantImgByRerarto(String id) async {
    Pedido? pedido = await getPedidoByReparto(id);

    if (pedido == null) return const AssetImage('assets/ComeYPaga.png');

    CallService<Restaurante> resService =
        CallService(uri: 'restaurante', fromJson: Restaurante.fromJson);

    List<int>? response =
        await resService.getFile('/${pedido.restauranteId}/img');

    if (response == null) return const AssetImage('assets/ComeYPaga.png');

    Uint8List img = Uint8List.fromList(response);
    return MemoryImage(img);
  }

  Future<Reparto?> getReparto(Reparto? reparto, String id) async {
    if (reparto != null) return reparto;

    CallService<Reparto> service =
        CallService(uri: 'pedido', fromJson: Reparto.fromJson);

    Reparto? res = await service.get({}, '/$id/reparto');

    return res;
  }

  String formatDate(DateTime date) {
    return DateFormat('hh:mm, dd/MM/yyyy')
        .format(date); // Imprime la fecha y hora formateada
  }

  Future<double> calculateTotalByReparto(String id) async {
    Pedido? pedido = await getPedidoByReparto(id);
    double total = 0.0;

    if (pedido == null) return total;

    CallService<Plato> service =
        CallService(uri: 'plato', fromJson: Plato.fromJson);
    await Future.forEach(pedido.platosPedidos!, (element) async {
      Plato? plato = await service.get({}, '/${element.plato}');

      if (plato != null) total += plato.precio * element.cantidad;
    });

    if (total <= 10) total += 3;
    return total;
  }

  Future<void> updatePedidoStatus(String id, String status) async {
    Pedido? pedido = await getPedidoByReparto(id);

    if (pedido != null) {
      CallService<Pedido> service =
          CallService(uri: 'pedido', fromJson: Pedido.fromJson);

      String realStatus = '0.33';
      switch (status) {
        case '1':
          realStatus = '0.33';
          break;
        case '2':
          realStatus = '0.66';
          break;
        case '3':
          realStatus = '1';
          break;
        case '-1':
          realStatus = '-1';
          break;
      }

      pedido.codigoEstadoPedido = realStatus;
      await service.put('/${pedido.id}', pedido);
    }
  }

  void updateRepartidor(Repartidor repartidor) {
    CallService<Repartidor> service =
        CallService(uri: 'usuario', fromJson: Repartidor.fromJson);
    service.put('/${repartidor.nombreUsuario}/repartidor', repartidor);
  }

  Future<String?> updateGroupValue(Reparto reparto) async {
    Pedido? pedido = await getPedidoByReparto(reparto.id!);

    switch (pedido?.codigoEstadoPedido) {
      case '0.33':
        return '1';
      case '0.66':
        return '2';
      case '-1':
        return '-1';
    }
  }
}
