import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final String imagePath;
  final VoidCallback onTap;
  final List<Color> gradient;

  const CustomCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.imagePath,
      required this.onTap,
      required this.description,
      required this.gradient});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
              blurRadius: 0.5,
              offset: const Offset(0, 0.5),
            ),
          ],
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style:  TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white.withValues(alpha: 0.8))),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(description,
                        style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.white))
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Icon(
                      icon,
                      size: 45,
                      color: Colors.white,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
