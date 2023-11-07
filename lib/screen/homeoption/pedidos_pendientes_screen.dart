import 'dart:typed_data';

import 'package:comepaga/model/delivery/pedido.dart';
import 'package:comepaga/model/delivery/reparto.dart';
import 'package:comepaga/model/user/repartidor.dart';
import 'package:comepaga/screen/args/home_screen_args.dart';
import 'package:comepaga/screen/args/pedidos_pendientes_args.dart';
import 'package:comepaga/screen/args/reparto_screen_args.dart';
import 'package:comepaga/service/call_service.dart';
import 'package:comepaga/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/restaurant/restaurante.dart';

class PedidosPendientesScreen extends StatefulWidget {
  const PedidosPendientesScreen({super.key});

  @override
  State<PedidosPendientesScreen> createState() =>
      _PedidosPendientesScreenState();
}

class _PedidosPendientesScreenState extends State<PedidosPendientesScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as PedidosPendientesArgs;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.popAndPushNamed(context, 'home',
                  arguments: HomeScreenArgs(user: args.repartidor));
            }
          },
          backgroundColor: Colors.grey.shade300.withOpacity(0.7),
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        backgroundColor: AppTheme.primaryColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            color: Colors.white,
            child: Stack(
              children: [
                Positioned(
                  top: 25,
                  right: 15,
                  child: IconButton(
                      onPressed: () {
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.refresh_outlined,
                        size: 33,
                        color: Colors.red,
                      )),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 30, top: 60),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Search restaurants...',
                        icon: Icon(
                          Icons.search,
                          color: Colors.red,
                          size: 30,
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                  ),
                ),
              ],
            ),
          ),
          toolbarHeight: 100,
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: FutureBuilder<List<Pedido>>(
              future: getAllPedidos(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 50),
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Center(
                            child: Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    height: 125,
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: FutureBuilder<ImageProvider>(
                                        future: getRestaurantImg(
                                            data[index].restauranteId),
                                        builder: ((context, snapshot) {
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
                                                  color: AppTheme.primaryColor),
                                            );
                                          }
                                        })),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    height: 125,
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data[index].ubicacionReparto ??
                                              'Error',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: const [
                                            Icon(
                                              Icons.pedal_bike,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              '30 min',
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                        Text(
                                          formatDate(data[index].fechaEntrega!),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              if (args.repartidor.pedidoId !=
                                                  null) {
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: ((context) =>
                                                      AlertDialog(
                                                        content: const Text(
                                                            "You can't accept this Order. You have one in process!"),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                'Ok',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ))
                                                        ],
                                                      )),
                                                );
                                              } else {
                                                CallService<Reparto> service =
                                                    CallService(
                                                        uri: 'pedido',
                                                        fromJson:
                                                            Reparto.fromJson);
                                                service
                                                    .put(
                                                        '/${data[index].id}/repartidor',
                                                        args.repartidor)
                                                    .then((value) {
                                                  if (value == null) {
                                                    showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: ((context) =>
                                                          AlertDialog(
                                                            content: const Text(
                                                                "An error has occurred. Try later!"),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Ok',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey),
                                                                  ))
                                                            ],
                                                          )),
                                                    );
                                                  } else {
                                                    CallService<Repartidor>
                                                        repServ = CallService(
                                                            uri: 'usuario',
                                                            fromJson: Repartidor
                                                                .fromJson);

                                                    repServ
                                                        .get({}, '/${args.repartidor.nombreUsuario}').then(
                                                            (repartidor) {
                                                      if (repartidor != null) {
                                                        Navigator.popAndPushNamed(
                                                            context, 'reparto',
                                                            arguments:
                                                                RepartoScreenArgs(
                                                                    repartidor,
                                                                    value));
                                                      }
                                                    });
                                                  }
                                                });
                                              }
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    const MaterialStatePropertyAll(
                                                        AppTheme.green),
                                                fixedSize:
                                                    MaterialStatePropertyAll(
                                                        Size.fromWidth(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.3))),
                                            child: const Text('Accept'))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 40,
                            ),
                        itemCount: data.length),
                  );
                } else {
                  return const Image(
                      image: AssetImage('assets/loading_icon_red_orange.gif'));
                }
              }),
        ));
  }

  Future<List<Pedido>> getAllPedidos() async {
    List<Pedido> pedidos = [];
    CallService<Pedido> service =
        CallService(uri: 'pedido', fromJson: Pedido.fromJson);

    pedidos = await service.getAll({}, '');

    return pedidos;
  }

  Future<ImageProvider> getRestaurantImg(String? restaurantId) async {
    CallService<Restaurante> service = CallService<Restaurante>(
        uri: 'restaurante', fromJson: Restaurante.fromJson);
    List<int>? response = await service.getFile('/$restaurantId/img');

    if (response == null) return const AssetImage('assets/ComeYPaga.png');

    Uint8List img = Uint8List.fromList(response);
    return MemoryImage(img);
  }

  String formatDate(DateTime date) {
    return DateFormat('hh:mm, dd/MM/yyyy')
        .format(date); // Imprime la fecha y hora formateada
  }
}
