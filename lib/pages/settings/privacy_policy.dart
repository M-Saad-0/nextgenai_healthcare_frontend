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
          text: TextSpan(
            style: const TextStyle(color: Colors.black87, fontSize: 16),
            children: [
              const TextSpan(
                text: 'We prioritize your privacy and take strong measures to safeguard your personal and financial data.\n\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: '• ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: 'Our ',
              ),
              const TextSpan(
                text: 'Chatbot ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: 'feature runs entirely ',
              ),
              const TextSpan(
                text: 'locally on your device. ',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const TextSpan(
                text: 'We do ',
              ),
              const TextSpan(
                text: 'not store or transmit any of your chat conversations.\n\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: '• Symptom-Based Diagnosis ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: 'is processed completely ',
              ),
              const TextSpan(
                text: 'offline ',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const TextSpan(
                text: 'to protect your privacy.\n\n',
              ),
              const TextSpan(
                text: '• Your Stripe account ID ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: 'is securely stored in our backend database with strong encryption and access control.\n\n',
              ),
              const TextSpan(
                text: '• Sensitive data like login sessions and preferences ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: 'are stored using Hive in secure device storage and are protected with OS-level app sandboxing.\n\n',
              ),
              const TextSpan(
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
