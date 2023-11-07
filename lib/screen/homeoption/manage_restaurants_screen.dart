import 'package:comepaga/screen/args/create_restaurant_screen_args.dart';
import 'package:comepaga/screen/args/manage_restaurants_screen_args.dart';
import 'package:comepaga/screen/args/update_delete_restaurant_screen_args.dart';
import 'package:comepaga/theme/app_theme.dart';
import 'package:comepaga/widget/custom_home_option.dart';
import 'package:flutter/material.dart';

class ManageRestaurantsScreen extends StatelessWidget {
  const ManageRestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as ManageRestaurantsScreenArgs;

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.home,
          color: AppTheme.primaryColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
            const Image(image: AssetImage('assets/ComeYPaga.png')),
            Wrap(
              runAlignment: WrapAlignment.center,
              spacing: 25,
              runSpacing: 25,
              children: [
                CustomHomeOption(
                    optionImage: const Image(
                        image: AssetImage('assets/create_delete_restaurante.jpg'),),
                    route: 'create_restaurant',
                    args: CreateRestaurantScreenArgs(args.administrador)),
                CustomHomeOption(
                    optionImage: const Image(
                        image: AssetImage('assets/update_restaurant.jpg')),
                    route: 'update_delete_restaurant',
                    args: UpdateDeleteRestaurantScreenArgs(args.administrador)),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
