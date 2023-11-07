import 'package:comepaga/model/delivery/pedido.dart';
import 'package:comepaga/model/restaurant/plato.dart';
import 'package:comepaga/model/restaurant/plato_pedido.dart';
import 'package:comepaga/screen/args/update_pedido_screen_args.dart';
import 'package:flutter/material.dart';

import '../service/call_service.dart';
import '../theme/app_theme.dart';

class UpdateOrderScreen extends StatefulWidget {
  const UpdateOrderScreen({super.key});

  @override
  State<UpdateOrderScreen> createState() => _UpdateOrderScreenState();
}

class _UpdateOrderScreenState extends State<UpdateOrderScreen> {
  List<bool> deleted = [];
  num total = 0;
  bool hasPlus = false;
  bool initValues = true;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as UpdatePedidoScreenArgs;

    if (initValues) {
      for (var _ in args.pedido.platosPedidos!) {
        deleted.add(false);
      }
      var platos = getPlatos(args.pedido.platosPedidos!);

      platos.then((value) {
        for (int i = 0; i < value.length; i++) {
          total += args.pedido.platosPedidos![i].cantidad * value[i].precio;
        }
        updateTotal();
        if (hasPlus) total += 3;

        setState(() {});
      });
      initValues = false;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CallService<Pedido> service =
              CallService(uri: 'pedido', fromJson: Pedido.fromJson);

          service.put('/${args.pedido.id}', args.pedido).then((value) {
            if (value != null) {
              Navigator.pop(context);
            } else {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: ((context) => AlertDialog(
                        content:
                            const Text('Error when trying to modify the order'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Ok',
                                style: TextStyle(color: Colors.grey),
                              ))
                        ],
                      )));
            }
          });
        },
        backgroundColor: Colors.grey.shade300,
        child: const Icon(Icons.check),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.grey.shade300,
          height: MediaQuery.of(context).size.height * 0.1,
          child: LayoutBuilder(builder: (context, constraint) {
            return Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              height: constraint.maxHeight,
              width: constraint.maxWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: $total €',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  hasPlus
                      ? const Text(
                          'Plus: + 3€',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : const SizedBox()
                ],
              ),
            );
          })),
      appBar: AppBar(
        title: Text(
          "Order at ${args.pedido.restauranteId}",
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade300,
        foregroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.separated(
            itemBuilder: (context, index) {
              return FutureBuilder<Plato?>(
                  future: getPlatoById(args.pedido.platosPedidos![index].plato),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Plato plato = snapshot.data!;
                      Color textColor = deleted[index]
                          ? Colors.black.withOpacity(0.5)
                          : Colors.black;

                      return SizedBox(
                        height: plato.descripcion.length * 2 > 175
                            ? plato.descripcion.length * 2
                            : 175,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  args.pedido.platosPedidos![index].cantidad > 0
                                      ? '${args.pedido.platosPedidos![index].cantidad}x ${plato.nombre} ${args.pedido.platosPedidos![index].cantidad * plato.precio} €'
                                      : plato.nombre,
                                  style: TextStyle(
                                      color: textColor,
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
                                      style: TextStyle(color: textColor),
                                    )),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: deleted[index]
                                            ? null
                                            : () {
                                                args.pedido
                                                    .platosPedidos![index]
                                                    .incrementCantidad();
                                                if (args
                                                        .pedido
                                                        .platosPedidos![index]
                                                        .cantidad <
                                                    21) {
                                                  total += plato.precio;
                                                }
                                                updateTotal();
                                                setState(() {});
                                              },
                                        icon: const Icon(Icons.add)),
                                    IconButton(
                                        onPressed: deleted[index]
                                            ? null
                                            : () {
                                                if (args
                                                        .pedido
                                                        .platosPedidos![index]
                                                        .cantidad >
                                                    0) {
                                                  total -= plato.precio;
                                                }
                                                args.pedido
                                                    .platosPedidos![index]
                                                    .decrementCantidad();
                                                updateTotal();
                                                setState(() {});
                                              },
                                        icon: const Icon(Icons.remove)),
                                    IconButton(
                                        onPressed: () {
                                          deleted[index] = !deleted[index];
                                          double price = args
                                                  .pedido
                                                  .platosPedidos![index]
                                                  .cantidad *
                                              plato.precio;
                                          if (deleted[index]) {
                                            total -= price;
                                            args.pedido.platosPedidos!.add(
                                                PlatoPedido(
                                                    plato: plato.id!,
                                                    cantidad: args
                                                        .pedido
                                                        .platosPedidos![index]
                                                        .cantidad));
                                          } else {
                                            total += price;
                                            args.pedido.platosPedidos!
                                                .removeWhere((element) =>
                                                    element.plato == plato.id);
                                          }
                                          updateTotal();
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          deleted[index]
                                              ? Icons.add_circle_outline_sharp
                                              : Icons.remove_circle_outline,
                                          color: deleted[index]
                                              ? AppTheme.green
                                              : AppTheme.primaryColor,
                                        ))
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  });
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: args.pedido.platosPedidos!.length),
      ),
    );
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

  Future<Plato?> getPlatoById(String platosCreado) async {
    CallService<Plato> service =
        CallService(uri: 'plato', fromJson: Plato.fromJson);

    Plato? plato = await service.get({}, '/$platosCreado');

    return plato;
  }

  Future<List<Plato>> getPlatos(List<PlatoPedido> platosPedido) async {
    List<Plato> platos = [];
    CallService<Plato> platoService =
        CallService(uri: 'plato', fromJson: Plato.fromJson);

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
}
