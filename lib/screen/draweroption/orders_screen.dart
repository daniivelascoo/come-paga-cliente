import 'dart:typed_data';

import 'package:comepaga/model/delivery/pedido.dart';
import 'package:comepaga/screen/args/orders_screen_args.dart';
import 'package:comepaga/screen/args/update_pedido_screen_args.dart';
import 'package:comepaga/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../model/restaurant/plato.dart';
import '../../model/restaurant/plato_pedido.dart';
import '../../model/restaurant/restaurante.dart';
import '../../service/call_service.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrdersScreenArgs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Preparing Orders'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: AppTheme.primaryColor,
      body: Container(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<List<Pedido>>(
            future: getPedidosByUser(args.cliente.nombreUsuario),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Pedido> data = snapshot.data!;
                data = data
                    .where((element) => element.codigoEstadoPedido == '0.33')
                    .toList();

                if (data.isNotEmpty) {
                  return ListView.separated(
                      itemCount: data.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 40,
                        );
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'update_order',
                                arguments: UpdatePedidoScreenArgs(data[index]));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 30, right: 30),
                            height: 150,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child:
                                LayoutBuilder(builder: (context, constraint) {
                              return Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 15,
                                        top: 15,
                                        right: 10,
                                        bottom: 15),
                                    height: constraint.maxHeight,
                                    width: constraint.maxWidth / 2,
                                    child: FutureBuilder<ImageProvider>(
                                        future: getRestaurantImg(
                                            data[index].restauranteId ?? ''),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Stack(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              fit: StackFit.expand,
                                              children: [
                                                Image(
                                                    fit: BoxFit.cover,
                                                    image: snapshot.data!),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  child: Text(
                                                    data[index].restauranteId ??
                                                        '',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                )
                                              ],
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
                                    padding: const EdgeInsets.only(
                                        right: 15, top: 10, bottom: 10),
                                    height: constraint.maxHeight,
                                    width: (constraint.maxWidth / 2) - 25,
                                    child: FutureBuilder<List<String>>(
                                      future: getPlatoName(
                                          data[index].platosPedidos ?? []),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          List<String> nombres = snapshot.data!;

                                          return ListView.separated(
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                              itemBuilder: (context, i) {
                                                return Text(
                                                    '${data[index].platosPedidos![i].cantidad} x ${nombres[i]}');
                                              },
                                              itemCount: nombres.length);
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    ),
                                  )
                                ],
                              );
                            }),
                          ),
                        );
                      });
                } else {
                  return const Center(
                    child: Image(image: AssetImage('assets/ComeYPaga.png')),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
            }),
      ),
    );
  }

  Future<List<Pedido>> getPedidosByUser(String? userId) async {
    await Future.delayed(const Duration(seconds: 1));
    CallService<Pedido> service =
        CallService(uri: 'pedido', fromJson: Pedido.fromJson);

    List<Pedido> pedidos = await service.getAll({}, '/$userId');

    return pedidos;
  }

  Future<ImageProvider> getRestaurantImg(String id) async {
    CallService<Restaurante> service =
        CallService(uri: 'restaurante', fromJson: Restaurante.fromJson);
    List<int>? response = await service.getFile('/$id/img');

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
}
