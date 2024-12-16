import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class timehourley extends StatelessWidget {
  final String time;
  final IconData icon;
  final String dregee;
  const timehourley({super.key,required this.time,required this.icon,required this.dregee});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(time,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
            SizedBox(height: 8,),
            Icon(icon,size: 32,),
            SizedBox(height: 8,),
            Text(dregee),

          ],
        ),
      ),
    );
  }
}