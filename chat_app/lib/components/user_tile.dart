import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final Color color;
  final void Function()? onTap;
  
  const UserTile({
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
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 11),
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 9.5),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Icon(
                Icons.person,
                size: 25,
                ),
            ),
            SizedBox(width: 16,),
            Text(
              text,
              style: TextStyle(
                fontSize: 17,
              ),
              ),
          ],
        ),
      ),
    );
  }
}