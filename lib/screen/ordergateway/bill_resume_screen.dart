import 'package:comepaga/model/delivery/plato_factura.dart';
import 'package:comepaga/screen/args/bill_resume_screen_args.dart';
import 'package:comepaga/screen/args/restaurantes_screen_args.dart';
import 'package:comepaga/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/constants.dart';

class BillResumeScreen extends StatelessWidget {
  const BillResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as BillResumeScreenArgs;
    var format = DateFormat(Constants.defaultDateFormat);
    final platos = args.factura.platosFactura;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey.shade300,
        title: Text('Bill of ${format.format(args.factura.fecha)}'),
      ),
      backgroundColor: AppTheme.primaryColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade300.withOpacity(0.7),
        onPressed: () {
          Navigator.popUntil(context, (route) => route.settings.name == 'home');
        },
        child: const Icon(Icons.home),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
                Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: getLines(platos, context),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, 'restaurants',
                        (route) => route.settings.name == 'home',
                        arguments:
                            RestaurantesScreenArgs(usuario: args.client));
                  },
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(AppTheme.green)),
                  child: const Text('Start Ordering'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getLines(List<PlatoFactura> platos, BuildContext context) {
    List<Widget> lines = [];

    lines.add(Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: const Text(
                'Plato',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.06,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.14,
              child: const Text(
                'Amount',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.10,
              child: const Text(
                'Cost',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        )
      ],
    ));

    for (int index = 0; index < platos.length; index++) {
      lines.add(
        Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(platos[index].nombre),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.10,
                  child: Text(platos[index].cantidad.toString()),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.10,
                  child: Text('${platos[index].total.toString()}€'),
                )
              ],
            ),
            index == platos.length - 1 ? const SizedBox() : const Divider()
          ],
        ),
      );
    }

    return lines;
  }
}
