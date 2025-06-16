import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RichText(
          text:  TextSpan(
            style:  TextStyle( fontSize: 16, color:Theme.of(context).colorScheme.onSurface),
            children: const [
               TextSpan(
                text: 'We prioritize your privacy and take strong measures to safeguard your personal and financial data.\n\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
               TextSpan(
                text: '• ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
               TextSpan(
                text: 'Our ',
              ),
               TextSpan(
                text: 'Chatbot ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
               TextSpan(
                text: 'feature runs entirely ',
              ),
               TextSpan(
                text: 'locally on your device. ',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
               TextSpan(
                text: 'We do ',
              ),
               TextSpan(
                text: 'not store or transmit any of your chat conversations.\n\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
               TextSpan(
                text: '• Symptom-Based Diagnosis ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
               TextSpan(
                text: 'is processed completely ',
              ),
               TextSpan(
                text: 'offline ',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
               TextSpan(
                text: 'to protect your privacy.\n\n',
              ),
               TextSpan(
                text: '• Your Stripe account ID ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
               TextSpan(
                text: 'is securely stored in our backend database with strong encryption and access control.\n\n',
              ),
               TextSpan(
                text: '• Sensitive data like login sessions and preferences ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
               TextSpan(
                text: 'are stored using Hive in secure device storage and are protected with OS-level app sandboxing.\n\n',
              ),
               TextSpan(
                text: 'We do not sell, share, or expose your data to advertisers or third parties.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
