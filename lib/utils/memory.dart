import 'package:comepaga/model/restaurant/plato_pedido.dart';

import '../model/restaurant/restaurante.dart';

class Memory {
  static List<PlatoPedido> basket = [];
  static List<PlatoPedido> deletedPlatos = [];
  static Restaurante? restaurante;
  static removeDeletedFromBasket() {
    for (var element in deletedPlatos) {
      basket.remove(element);
    }

    deletedPlatos.clear();
  }
}
