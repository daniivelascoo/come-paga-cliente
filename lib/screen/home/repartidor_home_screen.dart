import 'dart:typed_data';

import 'package:comepaga/model/delivery/reparto.dart';
import 'package:comepaga/model/user/repartidor.dart';
import 'package:comepaga/screen/args/pedidos_pendientes_args.dart';
import 'package:comepaga/screen/args/reparto_screen_args.dart';
import 'package:comepaga/service/call_service.dart';
import 'package:flutter/material.dart';

import 'package:comepaga/screen/log_up_screen.dart';
import 'package:comepaga/theme/app_theme.dart';
import 'package:comepaga/utils/cookie_config.dart';
import 'package:comepaga/widget/custom_drawer_list_title.dart';
import 'package:comepaga/widget/custom_home_option.dart';
import 'package:intl/intl.dart';

import '../../model/delivery/pedido.dart';
import '../../model/restaurant/plato.dart';
import '../../model/restaurant/restaurante.dart';
import '../../widget/custom_header_home_screen.dart';

class RepartidorHomeScreen extends StatefulWidget {
  final Repartidor user;

  const RepartidorHomeScreen({super.key, required this.user});

  @override
  State<RepartidorHomeScreen> createState() => _RepartidorHomeScreenState();
}

class _RepartidorHomeScreenState extends State<RepartidorHomeScreen> {
  num _expander = 4;
  IconData _expanderIcon = Icons.keyboard_arrow_up_outlined;
  Widget _expanderBody = const Text('Swipe to see your deliverys!');
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 0) {
            setState(() {
              _expander = 4;
              _expanderIcon = Icons.keyboard_arrow_up_outlined;
              _expanderBody = const Text('Swipe to see your deliverys!');
            });
          } else if (details.delta.dy < 0) {
            setState(() {
              _expander = 1.85;
              _expanderIcon = Icons.keyboard_arrow_down_outlined;
              _expanderBody = FutureBuilder<Reparto?>(
                  future: getRepartoByUser(widget.user.nombreUsuario!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text(
                          'Some error has been occurred, try later');
                    } else if (snapshot.hasData) {
                      var reparto = snapshot.data!;

                      return Padding(
                          padding: const EdgeInsets.only(
                              right: 20, left: 20, bottom: 25),
                          child: Column(
                            children: [
                              Stack(children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.19,
                                  child: Scrollbar(
                                    controller: _scrollController,
                                    trackVisibility: true,
                                    thumbVisibility: true,
                                    radius: const Radius.circular(20),
                                    child: ListView(
                                      controller: _scrollController,
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        FutureBuilder<Pedido?>(
                                            future:
                                                getPedidoByReparto(reparto.id!),
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
                                            future:
                                                getPedidoByReparto(reparto.id!),
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
                                            future:
                                                getPedidoByReparto(reparto.id!),
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
                                Positioned(
                                    right: 10,
                                    bottom: 20,
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_forward_ios),
                                      onPressed: () {
                                        _scrollController.animateTo(
                                          _scrollController
                                              .position.maxScrollExtent,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    )),
                                Positioned(
                                    left: 10,
                                    bottom: 20,
                                    child: IconButton(
                                      icon:
                                          const Icon(Icons.arrow_back_ios_new),
                                      onPressed: () {
                                        _scrollController.animateTo(
                                          _scrollController
                                              .position.minScrollExtent,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    ))
                              ]),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.17,
                                child: FutureBuilder(
                                  future: updateGroupValue(reparto),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      String? groupvalue = snapshot.data!;

                                      return Builder(builder: (context) {
                                        return ListView(
                                          children: [
                                            ListTile(
                                              leading: Radio(
                                                  value: '1',
                                                  groupValue: groupvalue,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      (context as Element)
                                                          .markNeedsBuild();
                                                      groupvalue = value;
                                                      updatePedidoStatus(
                                                          reparto.id!,
                                                          groupvalue!);
                                                    });
                                                  }),
                                              title: const Text('In process'),
                                            ),
                                            ListTile(
                                              leading: Radio(
                                                  value: '2',
                                                  groupValue: groupvalue,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      (context as Element)
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
                              )
                            ],
                          ));
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ));
                    }
                  });
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          height: MediaQuery.of(context).size.height / _expander,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                _expanderIcon,
                size: 50,
                color: Colors.grey.shade400,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 2.5,
                ),
                child: SingleChildScrollView(
                  child: _expanderBody,
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25))),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50))),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    Text('@${widget.user.nombreUsuario}')
                  ]),
            ),
            CustomDrawerListTitle(
                onTap: () {
                  var result = widget.user.toJson().map((key, value) =>
                      MapEntry(key.toString(), value?.toString()));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LogUpScreen(
                                initformvalues: result,
                              )));
                },
                label: 'My Information',
                icon: Icons.person),
            CustomDrawerListTitle(
                onTap: () {}, label: 'My Orders', icon: Icons.shopping_basket),
            CustomDrawerListTitle(
                onTap: () {
                  CookieConfig.jar.deleteAll();
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, 'login');
                },
                label: 'Log Out',
                icon: Icons.logout_outlined)
          ],
        ),
      ),
      backgroundColor: AppTheme.primaryColor,
      body: SizedBox(
          child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 6 / 100),
                child: const CustomHeaderHomeScreen()),
            const SizedBox(
              height: 80,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 20,
              spacing: 20,
              children: [
                CustomHomeOption(
                  optionImage: Image.asset('assets/restaurantes.jpg'),
                  route: 'pedidos_pendientes',
                  args: PedidosPendientesArgs(widget.user),
                ),
                CustomHomeOption(
                  optionImage: Image.asset('assets/reparto_imagen.jpg'),
                  route: 'reparto',
                  args: RepartoScreenArgs(widget.user),
                ),
              ],
            ),
            Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                ),
                Image.asset('assets/ComeYPaga.png'),
              ],
            ),
          ],
        ),
      )),
    );
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
      }

      pedido.codigoEstadoPedido = realStatus;
      await service.put('/${pedido.id}', pedido);
    }
  }

  Future<Reparto?> getRepartoByUser(String id) async {
    CallService<Reparto> service =
        CallService(uri: 'pedido', fromJson: Reparto.fromJson);

    Reparto? reparto = await service.get({}, '/$id/reparto');

    return reparto;
  }

  Widget getResumeLine(String title, String body) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.19,
      width: 200,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(body),
        ),
      ),
    );
  }

  Future<Pedido?> getPedidoByReparto(String id) async {
    CallService<Pedido> service =
        CallService(uri: 'pedido', fromJson: Pedido.fromJson);

    return await service.get({}, '/$id/pedido');
  }

  Widget getDefaultLoader() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.19,
      width: 100,
      child: ListTile(
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
