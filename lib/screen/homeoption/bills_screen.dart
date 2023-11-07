import 'package:comepaga/model/delivery/factura.dart';
import 'package:comepaga/screen/args/bill_resume_screen_args.dart';
import 'package:comepaga/screen/args/bills_screen_args.dart';
import 'package:comepaga/screen/args/home_screen_args.dart';
import 'package:comepaga/service/call_service.dart';
import 'package:comepaga/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/constants.dart';

class BillsScreen extends StatelessWidget {
  final CallService<Factura> service =
      CallService(uri: 'pedido', fromJson: Factura.fromJson);

  BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as BillsScreenArgs;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, 'home',
              arguments: HomeScreenArgs(user: args.cliente));
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.home, color: Colors.white,),
      ),
      backgroundColor: Colors.grey.shade300,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primaryColor,
        title: const Center(child: Text('Your bills')),
        elevation: 1,
      ),
      body: FutureBuilder<List<Factura>>(
        future: getFacturas(args.cliente.nombreUsuario!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var format = DateFormat(Constants.defaultDateFormat);
            List<Factura> facturas = snapshot.data!;

            return ListView.separated(
                itemBuilder: (context, index) => ListTile(
                      title: Text(format.format(facturas[index].fecha)),
                      trailing: const Icon(
                        Icons.arrow_right,
                        color: AppTheme.primaryColor,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, 'bill_resume',
                            arguments: BillResumeScreenArgs(facturas[index], args.cliente));
                      },
                    ),
                separatorBuilder: (context, index) => const Divider(color: Colors.black, endIndent: 10, indent: 10,),
                itemCount: facturas.length);
          } else if (snapshot.hasError) {
            return const Center(
              child: Image(image: AssetImage('assets/ComeYPaga.png')),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<Factura>> getFacturas(String userId) async {
    List<Factura> facturas = await service.getAll({}, '/$userId/facturas');

    return facturas;
  }
}
