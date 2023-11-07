import 'package:comepaga/model/delivery/pedido.dart';
import 'package:comepaga/model/restaurant/plato.dart';
import 'package:comepaga/model/restaurant/restaurante.dart';
import 'package:comepaga/screen/args/bills_screen_args.dart';
import 'package:comepaga/screen/args/home_screen_args.dart';
import 'package:comepaga/screen/args/order_resume_screen_args.dart';
import 'package:comepaga/screen/args/restaurant_menu_screen_args.dart';
import 'package:comepaga/screen/args/restaurantes_screen_args.dart';
import 'package:comepaga/screen/home/home_screen.dart';
import 'package:comepaga/service/call_service.dart';
import 'package:comepaga/theme/app_theme.dart';
import 'package:comepaga/utils/memory.dart';
import 'package:flutter/material.dart';

import '../../model/restaurant/plato_pedido.dart';
import '../../model/user/cliente.dart';
import '../../model/user/ubicacion.dart';

class OrderResumeScreen extends StatefulWidget {
  const OrderResumeScreen({super.key});

  @override
  State<OrderResumeScreen> createState() => _OrderResumeScreenState();
}

class _OrderResumeScreenState extends State<OrderResumeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CallService<Plato> platoService =
      CallService(uri: 'plato', fromJson: Plato.fromJson);
  CallService<Pedido> pedidoService =
      CallService(uri: 'pedido', fromJson: Pedido.fromJson);
  double total = 0;
  List<bool> deleted = [];
  bool hasPlus = false;

  @override
  void initState() {
    Memory.basket =
        Memory.basket.where((element) => element.cantidad > 0).toList();
    var platos = getPlatos(Memory.basket);

    platos.then((value) {
      for (int i = 0; i < value.length; i++) {
        total += Memory.basket[i].cantidad * value[i].precio;
      }
      updateTotal();

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as OrderResumeScreenArgs;

    return WillPopScope(
      onWillPop: () async {
        if (args.origin.toLowerCase() == 'home') {
          Navigator.popAndPushNamed(context, 'home',
              arguments: HomeScreenArgs(user: args.cliente));
        } else {
          Navigator.popAndPushNamed(context, 'restaurant_menu',
              arguments: RestaurantMenuScreenArgs(
                  restaurante: Memory.restaurante!, cliente: args.cliente));
        }

        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade300,
          title: Text('Back To ${args.origin}'),
          foregroundColor: Colors.black,
        ),
        body: Memory.basket.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'The basket is empty!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    const Image(image: AssetImage('assets/cesta_vacia.png')),
                    ElevatedButton(
                      onPressed: () {
                        if (args.origin.toLowerCase() == 'restaurant') {
                          Navigator.popUntil(context, (Route<dynamic> route) {
                            // Condición para detener la eliminación de pantallas anteriores
                            return route.settings.name == 'restaurants';
                          });
                        } else {
                          Navigator.popAndPushNamed(context, 'restaurants',
                              arguments: RestaurantesScreenArgs(
                                  usuario: args.cliente));
                        }
                      },
                      style: const ButtonStyle(
                          minimumSize: MaterialStatePropertyAll(Size(200, 50)),
                          backgroundColor:
                              MaterialStatePropertyAll(AppTheme.green)),
                      child: const Text(
                        'Start Ordering',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              )
            : Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: SizedBox(
                      height: double.infinity,
                      child: FutureBuilder<List<Plato>>(
                        future: getPlatos(Memory.basket),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Plato> platos = snapshot.data!;

                            return Column(children: [
                              const Divider(),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .530,
                                child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const Divider(
                                          color: AppTheme.primaryColor,
                                          thickness: 1,
                                          indent: 40,
                                          endIndent: 40,
                                        ),
                                    itemCount: platos.length,
                                    itemBuilder: (context, index) {
                                      Color textColor = deleted[index]
                                          ? Colors.black.withOpacity(0.5)
                                          : Colors.black;
                                      return SizedBox(
                                        height: platos[index]
                                                        .descripcion
                                                        .length *
                                                    2 >
                                                175
                                            ? platos[index].descripcion.length *
                                                2
                                            : 175,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment:
                                                  AlignmentDirectional.topStart,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: Text(
                                                  Memory.basket[index]
                                                              .cantidad >
                                                          0
                                                      ? '${Memory.basket[index].cantidad}x ${platos[index].nombre} ${Memory.basket[index].cantidad * platos[index].precio} €'
                                                      : platos[index].nombre,
                                                  style: TextStyle(
                                                      color: textColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                    width: 220,
                                                    child: Text(
                                                      platos[index].descripcion,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      maxLines: null,
                                                      style: TextStyle(
                                                          color: textColor),
                                                    )),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                        onPressed:
                                                            deleted[index]
                                                                ? null
                                                                : () {
                                                                    Memory
                                                                        .basket[
                                                                            index]
                                                                        .incrementCantidad();
                                                                    if (Memory
                                                                            .basket[index]
                                                                            .cantidad <
                                                                        21) {
                                                                      total += platos[
                                                                              index]
                                                                          .precio;
                                                                    }
                                                                    updateTotal();
                                                                    setState(
                                                                        () {});
                                                                  },
                                                        icon: const Icon(
                                                            Icons.add)),
                                                    IconButton(
                                                        onPressed:
                                                            deleted[index]
                                                                ? null
                                                                : () {
                                                                    if (Memory
                                                                            .basket[index]
                                                                            .cantidad >
                                                                        0) {
                                                                      total -= platos[
                                                                              index]
                                                                          .precio;
                                                                    }
                                                                    Memory
                                                                        .basket[
                                                                            index]
                                                                        .decrementCantidad();
                                                                    updateTotal();
                                                                    setState(
                                                                        () {});
                                                                  },
                                                        icon: const Icon(
                                                            Icons.remove)),
                                                    IconButton(
                                                        onPressed: () {
                                                          deleted[index] =
                                                              !deleted[index];
                                                          double price = Memory
                                                                  .basket[index]
                                                                  .cantidad *
                                                              platos[index]
                                                                  .precio;
                                                          if (deleted[index]) {
                                                            total -= price;
                                                            Memory.deletedPlatos
                                                                .add(Memory
                                                                        .basket[
                                                                    index]);
                                                          } else {
                                                            total += price;
                                                            Memory.deletedPlatos
                                                                .remove(Memory
                                                                        .basket[
                                                                    index]);
                                                          }
                                                          updateTotal();
                                                          setState(() {});
                                                        },
                                                        icon: Icon(
                                                          deleted[index]
                                                              ? Icons
                                                                  .add_circle_outline_sharp
                                                              : Icons
                                                                  .remove_circle_outline,
                                                          color: deleted[index]
                                                              ? AppTheme.green
                                                              : AppTheme
                                                                  .primaryColor,
                                                        ))
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ]);
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else {
                            return const Image(
                                image: AssetImage('assets/loading_cesta.gif'));
                          }
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: DropdownButton<Ubicacion>(
                      value: args.cliente.ubicacionActual,
                      items: buildLocationsDropdown(args.cliente),
                      onChanged: (value) {},
                      icon: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.black,
                      ),
                      underline: Container(),
                      dropdownColor: Colors.grey.shade300,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 1))
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(2)),
                            color: Colors.grey.shade300),
                        height: MediaQuery.of(context).size.height * 0.27,
                        width: MediaQuery.of(context).size.width - 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                                alignment: AlignmentDirectional.topStart,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10),
                                    child: Text(
                                      'Total: $total €',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ))),
                            Container(
                              height: MediaQuery.of(context).size.height * .15,
                              width: MediaQuery.of(context).size.width - 80,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade700,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children:
                                        getResume(args.cliente.ubicacionActual),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional.bottomCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.pedal_bike_outlined),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('30 min')
                                    ],
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Memory.removeDeletedFromBasket();
                                        var p = Pedido(
                                            null,
                                            args.cliente.nombreUsuario,
                                            null,
                                            args.restaurante?.nombre,
                                            '${args.cliente.ubicacionActual!.direccion}, ${args.cliente.ubicacionActual!.localizacion}',
                                            DateTime.now(),
                                            DateTime.now().add(
                                                const Duration(minutes: 30)),
                                            Memory.basket,
                                            null);
                                        Future<Pedido?> pedido =
                                            pedidoService.createWithCookie(
                                                '/${args.cliente.nombreUsuario}',
                                                p);

                                        pedido.then((value) {
                                          if (value == null) {
                                          } else {
                                            int valoration = 0;
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: StatefulBuilder(
                                                    builder: (BuildContext
                                                            context,
                                                        StateSetter setState) {
                                                      return SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            const Text(
                                                                'Rate the restaurant!'),
                                                            Row(
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(
                                                                    valoration >
                                                                            0
                                                                        ? Icons
                                                                            .star
                                                                        : Icons
                                                                            .star_border,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      valoration =
                                                                          1;
                                                                    });
                                                                  },
                                                                ),
                                                                IconButton(
                                                                  icon: Icon(
                                                                    valoration >
                                                                            1
                                                                        ? Icons
                                                                            .star
                                                                        : Icons
                                                                            .star_border,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      valoration =
                                                                          2;
                                                                    });
                                                                  },
                                                                ),
                                                                IconButton(
                                                                  icon: Icon(
                                                                    valoration >
                                                                            2
                                                                        ? Icons
                                                                            .star
                                                                        : Icons
                                                                            .star_border,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      valoration =
                                                                          3;
                                                                    });
                                                                  },
                                                                ),
                                                                IconButton(
                                                                  icon: Icon(
                                                                    valoration >
                                                                            3
                                                                        ? Icons
                                                                            .star
                                                                        : Icons
                                                                            .star_border,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      valoration =
                                                                          4;
                                                                    });
                                                                  },
                                                                ),
                                                                IconButton(
                                                                  icon: Icon(
                                                                    valoration >
                                                                            4
                                                                        ? Icons
                                                                            .star
                                                                        : Icons
                                                                            .star_border,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      valoration =
                                                                          5;
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator
                                                            .pushNamedAndRemoveUntil(
                                                          context,
                                                          'bills',
                                                          (route) =>
                                                              route.settings
                                                                  .name ==
                                                              'home',
                                                          arguments:
                                                              BillsScreenArgs(
                                                                  args.cliente),
                                                        );
                                                      },
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .primaryColor),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        CallService<Restaurante>
                                                            service =
                                                            CallService(
                                                                uri:
                                                                    'restaurante',
                                                                fromJson:
                                                                    Restaurante
                                                                        .fromJson);

                                                        service.get({},
                                                            '/${args.restaurante!.nombre}/rate/$valoration');

                                                        Navigator
                                                            .pushNamedAndRemoveUntil(
                                                          context,
                                                          'bills',
                                                          (route) =>
                                                              route.settings
                                                                  .name ==
                                                              'home',
                                                          arguments:
                                                              BillsScreenArgs(
                                                                  args.cliente),
                                                        );
                                                      },
                                                      child: const Text(
                                                        'Ok',
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        });
                                      },
                                      child: const Text('Confirm'))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  List<DropdownMenuItem<Ubicacion>> buildLocationsDropdown(Cliente cliente) {
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
        deleted.add(false);
      }
    }

    return result;
  }

  Future<List<Plato>> getPlatos(List<PlatoPedido> platosPedido) async {
    List<Plato> platos = [];

    await Future(() async {
      for (var i = 0; i < platosPedido.length; i++) {
        Plato? plato = await platoService.get({}, '/${platosPedido[i].plato}');
        if (plato != null) {
          platos.add(plato);
        }
      }
    });

    return platos;
  }

  void updateTotal() {
    if (total < 10) {
      hasPlus = true;
    } else {
      if (hasPlus) {
        total -= 3;
      }
      hasPlus = false;
    }
  }

  List<Text> getResume(Ubicacion? location) {
    List<Text> resume = [];

    if (hasPlus) {
      resume.add(const Text(
        'Plus for orders under 10€: + 3€',
        style: TextStyle(color: Colors.white),
      ));

      total += 3;
    }

    resume.add(Text(
      'Order cost: $total',
      style: const TextStyle(color: Colors.white),
    ));

    bool hasLocation = location != null;
    resume.add(Text(
      hasLocation
          ? 'Location: ${location.direccion}, ${location.localizacion}'
          : 'Unknown location',
      style: TextStyle(color: hasLocation ? Colors.white : Colors.red),
    ));

    return resume;
  }
}
