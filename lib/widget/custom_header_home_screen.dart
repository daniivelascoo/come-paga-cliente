import 'package:flutter/material.dart';

class CustomHeaderHomeScreen extends StatelessWidget {
  const CustomHeaderHomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 7 / 100,
        ),
        GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: const Padding(
                padding: EdgeInsets.all(7), child: Icon(Icons.person)),
          ),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 79 / 100,
            height: 40,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: const UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: const UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: Colors.white)),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: IconTheme(
                          data: IconThemeData(color: Colors.grey.shade500),
                          child: const Icon(Icons.search)),
                      hintText: 'Search restaurant...',
                    ),
                  )),
            ))
      ],
    );
  }
}
