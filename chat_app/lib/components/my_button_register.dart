import 'package:flutter/material.dart';

class MyButtonRegister extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final Color color;

  const MyButtonRegister({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.app_registration,
            ), 
            SizedBox(width: 12), 
            Text(text),
          ],
        ),
      ),
    );
  }
}
