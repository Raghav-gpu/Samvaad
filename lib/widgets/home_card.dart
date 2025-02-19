import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;

  const HomeCard(
      {super.key, required this.color, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: color,
        elevation: 40,
        shadowColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
            height: 200,
            width: 183,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      shadows: [
                        Shadow(
                            color: Colors.black,
                            offset: Offset(1, 1),
                            blurRadius: 100)
                      ],
                      color: Colors.black,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_outward,
                      color: Colors.black,
                    )
                  ],
                ),
                const Spacer(),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            )));
  }
}
