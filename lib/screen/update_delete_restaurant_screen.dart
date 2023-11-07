import 'dart:typed_data';

import 'package:comepaga/model/restaurant/restaurante.dart';
import 'package:comepaga/screen/args/update_delete_restaurant_screen_args.dart';
import 'package:comepaga/screen/args/update_restaurant_screen_args.dart';
import 'package:comepaga/service/call_service.dart';
import 'package:comepaga/theme/app_theme.dart';
import 'package:flutter/material.dart';

class UpdateDeleteRestaurantScreen extends StatefulWidget {
  const UpdateDeleteRestaurantScreen({super.key});

  @override
  State<UpdateDeleteRestaurantScreen> createState() =>
      _UpdateDeleteRestaurantScreenState();
}

class _UpdateDeleteRestaurantScreenState
    extends State<UpdateDeleteRestaurantScreen> {
  String selectAndDelete = "Select";
  num _mainexpander = 1;
  num _selectionexpander = double.infinity;
  bool _removing = false;
  List<bool> selectedItems = [];
  List<String> toRemove = [];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as UpdateDeleteRestaurantScreenArgs;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Colors.grey.shade300.withOpacity(0.7),
        child: const Icon(Icons.arrow_back_ios_new),
      ),
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        elevation: 10,
        automaticallyImplyLeading: false,
        title: const Text(
          'Restaurants',
          style: TextStyle(color: Colors.black),
        ),
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        flexibleSpace: Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: LayoutBuilder(
              builder: (constext, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15, right: 20),
                      child: GestureDetector(
                        onTap: () {
                          if (selectAndDelete == 'Select') {
                            setState(() {
                              selectAndDelete = 'Delete';
                              _mainexpander = 1.25;
                              _selectionexpander = 5;
                              _removing = true;
                            });
                          } else {
                            removeRestaurants(toRemove).then((value) {
                              setState(() {
                                toRemove.clear();
                                selectedItems.clear();
                                selectAndDelete = 'Select';
                                _selectionexpander = double.infinity;
                                _mainexpander = 1;
                                _removing = false;
                              });
                            });
                          }
                        },
                        child: Text(
                          selectAndDelete,
                          style: const TextStyle(
                              fontSize: 18, color: AppTheme.primaryColor),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: LayoutBuilder(builder: (context, constraint) {
          return FutureBuilder<List<Restaurante>>(
              future: getRestaurants(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Restaurante> restaurantes = snapshot.data!;

                  return ListView.separated(
                      itemCount: restaurantes.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 20,
                        );
                      },
                      itemBuilder: (context, index) {
                        if (selectedItems.length < index + 1) {
                          selectedItems.add(
                              false); // Inicializar con false si el elemento no existe en la lista
                        }

                        return Container(
                          margin: const EdgeInsets.only(
                              left: 25, right: 25, top: 20),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                height: 150,
                                width: constraint.maxWidth / _selectionexpander,
                                child: _removing
                                    ? Checkbox(
                                        activeColor: Colors.grey.shade300,
                                        shape: const CircleBorder(),
                                        checkColor: Colors.black,
                                        value: selectedItems[index],
                                        onChanged: (value) {
                                          if (value == null) return;
                                          setState(() {
                                            if (value) {
                                              toRemove.add(
                                                  restaurantes[index].nombre);
                                            } else {
                                              toRemove.remove(
                                                  restaurantes[index].nombre);
                                            }
                                            selectedItems[index] = value;
                                          });
                                        })
                                    : null,
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                width:
                                    (constraint.maxWidth / _mainexpander) - 50,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 10),
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.5))
                                    ]),
                                child: LayoutBuilder(
                                    builder: (context, constraint) {
                                  return Row(
                                    children: [
                                      SizedBox(
                                        height: 150,
                                        width: constraint.maxWidth * 0.7,
                                        child: FutureBuilder<ImageProvider>(
                                            future: getRestaurantImg(
                                                restaurantes[index].nombre),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          top: 8,
                                                          bottom: 8),
                                                  child: Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .center,
                                                    fit: StackFit.expand,
                                                    children: [
                                                      Image(
                                                          fit: BoxFit.cover,
                                                          image:
                                                              snapshot.data!),
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional
                                                                .center,
                                                        child: Text(
                                                          restaurantes[index]
                                                              .nombre,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: const TextStyle(
                                                              fontSize: 25,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          overflow:
                                                              TextOverflow.fade,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: AppTheme
                                                              .primaryColor),
                                                );
                                              }
                                            }),
                                      ),
                                      SizedBox(
                                        height: 150,
                                        width: constraint.maxWidth * 0.3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(context,
                                                      'update_restaurant',
                                                      arguments:
                                                          UpdateRestaurantScreenArgs(
                                                              restaurantes[
                                                                  index],
                                                              args.administrador));
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: AppTheme.green,
                                                )),
                                            IconButton(
                                                onPressed: () {
                                                  removeRestaurants([
                                                    restaurantes[index].nombre
                                                  ]).then((value) {
                                                    setState(() {});
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.remove_circle,
                                                  color: AppTheme.primaryColor,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              )
                            ],
                          ),
                        );
                      });
                } else {
                  return Center(
                    child:
                        CircularProgressIndicator(color: Colors.grey.shade300),
                  );
                }
              });
        }),
      ),
    );
  }

  Future<List<Restaurante>> getRestaurants() async {
    CallService<Restaurante> service =
        CallService(uri: 'restaurante', fromJson: Restaurante.fromJson);

    List<Restaurante> restaurantes = await service.getAll({}, '');

    return restaurantes;
  }

  Future<void> removeRestaurants(List<String> ids) async {
    CallService<Restaurante> service =
        CallService(uri: 'restaurante', fromJson: Restaurante.fromJson);

    return await Future.forEach(ids, (element) {
      service.delete('/$element');
    });
  }

  Future<ImageProvider> getRestaurantImg(String id) async {
    CallService<Restaurante> service =
        CallService(uri: 'restaurante', fromJson: Restaurante.fromJson);
    List<int>? response = await service.getFile('/$id/img');

    if (response == null) return const AssetImage('assets/ComeYPaga.png');

    Uint8List img = Uint8List.fromList(response);
    return MemoryImage(img);
  }
}
