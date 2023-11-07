import 'package:comepaga/utils/constants.dart';
import 'package:flutter/material.dart';

class LoginTitle extends StatelessWidget {
  const LoginTitle({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> splitTitle = Constants.comeyPagaTitle.split(' ');

    return SizedBox(
      height: MediaQuery.of(context).size.height * 20 / 100,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width - 310),
              child: Text(
                splitTitle[0],
                style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.w900),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width - 320),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    splitTitle[1],
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    splitTitle[2],
                    style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ]),
    );
  }
}
