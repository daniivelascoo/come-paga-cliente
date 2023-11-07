import 'dart:typed_data';

import 'package:comepaga/model/delivery/pedido.dart';
import 'package:comepaga/model/restaurant/plato.dart';
import 'package:comepaga/model/restaurant/restaurante.dart';
import 'package:comepaga/model/user/cliente.dart';
import 'package:comepaga/model/user/ubicacion.dart';
import 'package:comepaga/screen/args/bills_screen_args.dart';
import 'package:comepaga/screen/args/order_resume_screen_args.dart';
import 'package:comepaga/screen/args/orders_screen_args.dart';
import 'package:comepaga/screen/args/restaurantes_screen_args.dart';
import 'package:comepaga/screen/log_up_screen.dart';
import 'package:comepaga/service/call_service.dart';
import 'package:comepaga/theme/app_theme.dart';
import 'package:comepaga/utils/cookie_config.dart';
import 'package:comepaga/utils/memory.dart';
import 'package:comepaga/widget/custom_drawer_list_title.dart';
import 'package:comepaga/widget/custom_home_option.dart';
import 'package:flutter/material.dart';
import 'package:bottom_drawer/bottom_drawer.dart';

import '../../model/restaurant/plato_pedido.dart';
import '../../widget/custom_header_home_screen.dart';

class ClienteHomeScreen extends StatefulWidget {
  final Cliente user;

  const ClienteHomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ClienteHomeScreen> createState() => _ClienteHomeScreenState();
}

class _ClienteHomeScreenState extends State<ClienteHomeScreen> {
  num _expander = 4;
  IconData _expanderIcon = Icons.keyboard_arrow_up_outlined;
  Widget _expanderBody = const Text('Swipe To see your orders!');
  CallService<Restaurante> resService = CallService<Restaurante>(
      uri: 'restaurante', fromJson: Restaurante.fromJson);

  @override
  Widget build(BuildContext context) {
    CallService<Restaurante> service = CallService<Restaurante>(
        uri: 'restaurante', fromJson: Restaurante.fromJson);

    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 0) {
            setState(() {
              _expander = 4;
              _expanderIcon = Icons.keyboard_arrow_up_outlined;
              _expanderBody = const Text('Swipe To see your orders!');
            });
          } else if (details.delta.dy < 0) {
            setState(() {
              _expander = 1.85;
              _expanderIcon = Icons.keyboard_arrow_down_outlined;
              _expanderBody = FutureBuilder<List<Pedido>>(
                  future: getPedidoByUser(widget.user.nombreUsuario!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text(
                          'Some error has been occurred, try later');
                    } else if (snapshot.hasData) {
                      var pedidos = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.only(
                            right: 20, left: 20, bottom: 25),
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  color: Colors.grey.shade300,
                                ),
                                height: 225,
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.40,
                                            child: FutureBuilder<ImageProvider>(
                                              future: getRestaurantImg(
                                                  pedidos[index].restauranteId),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<ImageProvider>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  return FadeInImage(
                                                    fit: BoxFit.cover,
                                                    image: snapshot.data ??
                                                        const AssetImage(
                                                            'assets/ComeYPaga.png'),
                                                    placeholder: const AssetImage(
                                                        'assets/loading_icon.gif'),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return const Icon(Icons
                                                      .error); // O cualquier otra representación de error que desees mostrar
                                                } else {
                                                  return const Image(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        'assets/loading_icon.gif'),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          Stack(
                                            alignment:
                                                AlignmentDirectional.topEnd,
                                            children: [
                                              Container(
                                                height: 150,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.40,
                                                color: Colors.grey.shade500,
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 35,
                                                            left: 10,
                                                            right: 10),
                                                    child: FutureBuilder<
                                                        List<String>>(
                                                      future: getPlatoName(
                                                          pedidos[index]
                                                              .platosPedidos!),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          updateStatus(
                                                              pedidos[index]);
                                                          var res =
                                                              snapshot.data!;
                                                          int i = -1;

                                                          return Text(
                                                            pedidos[index]
                                                                .platosPedidos!
                                                                .map((e) {
                                                              i++;
                                                              return '${e.cantidad}x ${res[i]}';
                                                            }).join('\n'),
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                          );
                                                        } else {
                                                          return const Image(
                                                              image: AssetImage(
                                                                  'assets/loading_icon_red_orange.gif'));
                                                        }
                                                      },
                                                    )),
                                              ),
                                              PopupMenuButton<Pedido>(
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                    value: pedidos[index],
                                                    child: const Text('Remove'),
                                                  ),
                                                  PopupMenuItem(
                                                    value: pedidos[index],
                                                    child:
                                                        const Text('Refresh'),
                                                  ),
                                                ],
                                                onSelected: (value) {},
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              getStatusDescription(
                                                  double.tryParse(pedidos[index]
                                                          .codigoEstadoPedido ??
                                                      '0.33')),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            LinearProgressIndicator(
                                              minHeight: 5,
                                              backgroundColor: Colors.grey,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                          Color>(
                                                      AppTheme.primaryColor),
                                              value: pedidos[index]
                                                          .codigoEstadoPedido ==
                                                      '-1'
                                                  ? null
                                                  : double.tryParse(pedidos[
                                                              index]
                                                          .codigoEstadoPedido ??
                                                      '0.33'),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]),
                              );
                            },
                            separatorBuilder: (constext, snapshot) =>
                                const SizedBox(
                                  height: 40,
                                ),
                            itemCount: pedidos.length),
                      );
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
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'orders',
                      arguments: OrdersScreenArgs(widget.user));
                },
                label: 'My Orders',
                icon: Icons.shopping_basket),
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
            DropdownButton<Ubicacion>(
              value: widget.user.ubicacionActual,
              items: buildLocationsDropdown(),
              onChanged: (value) {},
              icon: const Icon(
                Icons.keyboard_arrow_down_outlined,
                color: Colors.black,
              ),
              underline: Container(),
              dropdownColor: Colors.grey.shade300,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            const SizedBox(
              height: 40,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 20,
              spacing: 20,
              children: [
                CustomHomeOption(
                  optionImage: Image.asset('assets/restaurantes.jpg'),
                  route: 'restaurants',
                  args: RestaurantesScreenArgs(usuario: widget.user),
                ),
                CustomHomeOption(
                  optionImage: Image.asset('assets/facturas.jpg'),
                  route: 'bills',
                  args: BillsScreenArgs(widget.user),
                ),
                CustomHomeOption(
                  optionImage: Image.asset('assets/cesta_compra.jpg'),
                  route: 'order_resume',
                  args: OrderResumeScreenArgs(
                      widget.user, 'home', Memory.restaurante),
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

  Future<List<Pedido>> getPedidoByUser(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    CallService<Pedido> service =
        CallService(uri: 'pedido', fromJson: Pedido.fromJson);

    List<Pedido> pedidos = await service.getAll({}, '/$userId');

    return pedidos;
  }

  Future<ImageProvider> getRestaurantImg(String? restaurantId) async {
    List<int>? response = await resService.getFile('/$restaurantId/img');

    if (response == null) return const AssetImage('assets/ComeYPaga.png');

    Uint8List img = Uint8List.fromList(response);
    return MemoryImage(img);
  }

  Future<List<String>> getPlatoName(List<PlatoPedido> pedidos) async {
    CallService<Plato> service =
        CallService(uri: 'plato', fromJson: Plato.fromJson);
    List<String> platos = [];

    await Future.forEach(pedidos, (element) async {
      Plato? plato = await service.get({}, '/${element.plato}');
      if (plato != null) platos.add(plato.nombre);
    });

    return platos;
  }

  Future<void> updateStatus(Pedido? pedido) async {
    while (true) {
      String? status = await getStatus(pedido?.id ?? '');
      setState(() {
        pedido?.codigoEstadoPedido = status;
      });

      await Future.delayed(const Duration(seconds: 10));
    }
  }

  Future<String?> getStatus(String id) async {
    CallService<Pedido> service =
        CallService(uri: 'pedido', fromJson: Pedido.fromJson);

    Pedido? pedido = await service.get({}, '/$id');

    return pedido?.id;
  }

  String getStatusDescription(double? value) {
    if (value == null) return 'Late';

    if (value == 0.33) {
      return 'Preparing';
    } else if (value == 0.66) {
      return 'Delivering';
    } else if (value == 1) {
      return 'Delivered';
    } else {
      return 'Late';
    }
  }

  List<DropdownMenuItem<Ubicacion>> buildLocationsDropdown() {
    Cliente cliente = widget.user;
    List<DropdownMenuItem<Ubicacion>> result = [];

    var actual = DropdownMenuItem<Ubicacion>(
        value: cliente.ubicacionActual,
        child: Text(cliente.ubicacionActual.toString()));

    result.add(actual);

    if (cliente.ubicaciones != null) {
      for (var element in cliente.ubicaciones!) {
        var ubi = DropdownMenuItem<Ubicacion>(
            value: element, child: Text(element.toString()));

        result.add(ubi);
      }
    }

    return result;
  }
}
