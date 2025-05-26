import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  final String thing;
  final IconData icon;
  const NotFoundPage({required this.thing, super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(
              icon,
              color: Colors.redAccent,
              size: 80,
            ),
            const SizedBox(height: 24),
             Text(
              'No $thing Found',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Sorry, the information you are looking for is not available.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}