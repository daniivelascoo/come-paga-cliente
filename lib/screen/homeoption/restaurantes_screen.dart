import 'dart:io';
import 'dart:typed_data';

import 'package:comepaga/model/restaurant/restaurante.dart';
import 'package:comepaga/screen/args/restaurant_menu_screen_args.dart';
import 'package:comepaga/screen/args/restaurantes_screen_args.dart';
import 'package:comepaga/service/call_service.dart';
import 'package:comepaga/theme/app_theme.dart';
import 'package:comepaga/utils/memory.dart';
import 'package:comepaga/widget/filter_dialog.dart';
import 'package:flutter/material.dart';

class RestaurantesScreen extends StatefulWidget {
  const RestaurantesScreen({super.key});

  @override
  State<RestaurantesScreen> createState() => _RestaurantesScreenState();
}

class _RestaurantesScreenState extends State<RestaurantesScreen> {
  CallService<Restaurante> service = CallService<Restaurante>(
      uri: 'restaurante', fromJson: Restaurante.fromJson);
  Map<String, dynamic> filters = {};
  List<Restaurante> restaurantes = [];

  @override
  void initState() {
    onRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as RestaurantesScreenArgs;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: const Color.fromRGBO(224, 224, 224, 0.6),
        child: const Icon(Icons.arrow_back_ios_new_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
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
                    onPressed: onRefresh,
                    icon: const Icon(
                      Icons.refresh_outlined,
                      size: 33,
                      color: Colors.red,
                    )),
              ),
              const Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 30, top: 60, bottom: 50),
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
              Positioned(
                left: 20,
                bottom: -5,
                child: TextButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FilterDialog(
                            filters: filters,
                            onFinish: onRefresh,
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.list_alt,
                    color: Colors.red,
                    size: 30,
                  ),
                  label: Text(
                    'Filter restaurants (${filters.length})',
                    style: const TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ),
              ),
              Positioned(
                  bottom: -5,
                  right: 40,
                  child: Container(
                    child: filters.isEmpty
                        ? null
                        : Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    filters.clear();
                                    onRefresh();
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                    color: AppTheme.primaryColor,
                                  )),
                              Text('Found: ${restaurantes.length}')
                            ],
                          ),
                  ))
            ],
          ),
        ),
        toolbarHeight: 140,
      ),
      backgroundColor: AppTheme.primaryColor,
      body: restaurantes.isEmpty
          ? SingleChildScrollView(child: Image.asset('assets/ComeYPaga.png'))
          : RefreshIndicator(
              color: AppTheme.primaryColor,
              onRefresh: onRefresh,
              child: ListView.builder(
                  itemCount: restaurantes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, 'restaurant_menu',
                                  arguments: RestaurantMenuScreenArgs(
                                      restaurante: restaurantes[index],
                                      cliente: args.usuario));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0,
                                          5), // Desplazamiento de la sombra en coordenadas (x, y)
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              height: 150,
                              width: 350,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 7, left: 7, bottom: 7),
                                    child: SizedBox(
                                      height: 150,
                                      width: 175,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          FutureBuilder<ImageProvider>(
                                            future: getRestaurantImg(
                                                restaurantes[index].nombre),
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
                                          Align(
                                            alignment:
                                                AlignmentDirectional.center,
                                            child: Text(
                                              restaurantes[index].nombre,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: paintValoration(
                                            restaurantes[index]),
                                      ),
                                      Text(
                                        '${restaurantes[index].categoria} Food',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width:
                                            150, // Ancho específico o ajusta según tus necesidades
                                        child: Text(
                                          restaurantes[index].descripcion,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.attach_money_sharp),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            '€' *
                                                restaurantes[index].precioMedio,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Icon(Icons.pedal_bike_outlined),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text('30 min')
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        )
                      ],
                    );
                  })),
    );
  }

  Future<void> onRefresh() async {
    Map<String, String?> filtersToString = filters.map((key, value) {
      return MapEntry(key, value.toString());
    });

    restaurantes = await service.getAll(filtersToString, null);
    setState(() {});
  }

  Future<ImageProvider> getRestaurantImg(String? restaurantId) async {
    List<int>? response = await service.getFile('/$restaurantId/img');

    if (response == null) return const AssetImage('assets/ComeYPaga.png');

    Uint8List img = Uint8List.fromList(response);
    return MemoryImage(img);
  }

  List<Icon> paintValoration(Restaurante restaurante) {
    List<Icon> icons = [];

    for (int i = 0; i < restaurante.valoracionMedia; i++) {
      icons.add(const Icon(
        Icons.star,
        size: 20,
      ));
    }
    return icons;
  }
}
