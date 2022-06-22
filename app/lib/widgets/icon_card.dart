import 'package:flutter/material.dart';

class IconCard extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback press;

  const IconCard(
      {Key? key,
      required this.iconData,
      required this.text,
      required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Column(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                icon: Icon(
                  iconData,
                  size: 30,
                  color: Colors.pink[400],
                ),
                onPressed: press,
              )),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
