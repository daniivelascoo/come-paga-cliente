import 'dart:typed_data';

import 'package:comepaga/model/restaurant/plato.dart';
import 'package:comepaga/model/restaurant/plato_pedido.dart';
import 'package:comepaga/screen/args/order_resume_screen_args.dart';
import 'package:comepaga/screen/args/restaurant_menu_screen_args.dart';
import 'package:comepaga/service/call_service.dart';
import 'package:comepaga/theme/app_theme.dart';
import 'package:comepaga/utils/memory.dart';
import 'package:flutter/material.dart';

import '../../model/restaurant/restaurante.dart';

class RestaurantMenuScreen extends StatefulWidget {
  const RestaurantMenuScreen({super.key});

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  CallService<Restaurante> restauranteService =
      CallService(uri: 'restaurante', fromJson: Restaurante.fromJson);
  CallService<Plato> platoService =
      CallService(uri: 'plato', fromJson: Plato.fromJson);
  List<PlatoPedido> platosPedidos = [];
  double total = 0.0;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as RestaurantMenuScreenArgs;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 200,
        flexibleSpace: SizedBox(
          height: 400,
          child: FutureBuilder<ImageProvider>(
            future: getRestaurantImg(args.restaurante.nombre),
            builder:
                (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
              if (snapshot.hasData) {
                return FadeInImage(
                  fit: BoxFit.cover,
                  image:
                      snapshot.data ?? const AssetImage('assets/ComeYPaga.png'),
                  placeholder:
                      const AssetImage('assets/loading_icon_red_orange.gif'),
                );
              } else {
                return const Image(
                    image: AssetImage('assets/loading_icon_red_orange.gif'));
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.arrow_back_ios_new),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      backgroundColor: Colors.grey[350],
      body: Stack(children: [
        FutureBuilder<List<Plato?>>(
          future: getPlatosByRestaurant(args.restaurante),
          builder:
              (BuildContext context, AsyncSnapshot<List<Plato?>> snapshot) {
            if (snapshot.hasData) {
              List<Plato?> platos = snapshot.data!;
              return ListView.separated(
                itemCount: platos.length,
                itemBuilder: (BuildContext context, int index) {
                  Plato? plato = platos[index];

                  return Container(
                    padding: const EdgeInsets.only(top: 20),
                    width: double.infinity,
                    child: SizedBox(
                      height: plato!.descripcion.length * 2 > 125
                          ? plato.descripcion.length * 2
                          : 125,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                platosPedidos[index].cantidad > 0
                                    ? '${platosPedidos[index].cantidad}x ${plato.nombre} ${platosPedidos[index].cantidad * plato.precio} €'
                                    : plato.nombre,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 220,
                                child: Text(
                                  plato.descripcion,
                                  overflow: TextOverflow.visible,
                                  maxLines: null,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      platosPedidos[index].incrementCantidad();
                                      if (platosPedidos[index].cantidad < 21) {
                                        total += plato.precio;
                                      }
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (platosPedidos[index].cantidad > 0) {
                                        total -= plato.precio;
                                      }
                                      platosPedidos[index].decrementCantidad();
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.remove),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    indent: 50,
                    endIndent: 50,
                    thickness: 1,
                    color: Colors.black,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ));
            }
          },
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: ElevatedButton(
              onPressed: () {
                Memory.restaurante = args.restaurante;
                Memory.basket = platosPedidos
                    .where((element) => element.cantidad > 0)
                    .toList();
                Navigator.popAndPushNamed(context, 'order_resume',
                    arguments:
                        OrderResumeScreenArgs(args.cliente, 'Restaurant', args.restaurante));
                setState(() {});
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width * 0.55, 40)),
              ),
              child: Text(
                'Go To Confirm $total €',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<List<Plato?>> getPlatosByRestaurant(Restaurante restaurante) async {
    List<Plato?> platos = [];
    for (String? platoId in restaurante.platosCreados) {
      Plato? plato = await getPlatoById(platoId);
      if (plato != null) {
        platos.add(plato);
      }
    }
    return platos;
  }

  Future<Plato?> getPlatoById(String? id) async {
    Plato? plato = await platoService.get({}, '/$id');
    if (plato != null) {
      platosPedidos.add(PlatoPedido(plato: plato.id!, cantidad: 0));
    }
    return plato;
  }

  Future<ImageProvider> getRestaurantImg(String restaurantId) async {
    List<int>? response =
        await restauranteService.getFile('/$restaurantId/img');
    if (response == null) {
      return const AssetImage('assets/ComeYPaga.png');
    }
    Uint8List img = Uint8List.fromList(response);
    return MemoryImage(img);
  }
}
