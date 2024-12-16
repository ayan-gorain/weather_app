import 'package:flutter/material.dart';

class Additional extends StatelessWidget {
  final IconData icon;
  final String lebeel;
  final String number;
   Additional({super.key,required this.icon,required this.lebeel,required this.number});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon),
        SizedBox(height: 5),
        Text(
          lebeel,
        ),
        SizedBox(height: 5),
        Text(
          number,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
