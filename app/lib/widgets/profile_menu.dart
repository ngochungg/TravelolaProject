import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);
  final String icon, text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: const Color(0xFFF5F6F9),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: Colors.pinkAccent,
              width: 22,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Text(
              text,
              style: const TextStyle(color: Colors.grey),
            )),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.pinkAccent,
            ),
          ],
        ),
      ),
    );
  }
}
