import 'package:flutter/material.dart';

class BorrowingPolicyPage extends StatelessWidget {
  const BorrowingPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rent & Safety Policy')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RichText(
          text: TextSpan(
            style:  TextStyle( fontSize: 16, color:Theme.of(context).colorScheme.onSurface),
            children: [
              const TextSpan(
                text: 'To protect both borrowers and lenders, we enforce strict rules regarding non-returned, damaged, or stolen items.\n\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: '• Report System: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: 'Each item has a ',
              ),
              const TextSpan(
                text: 'Report User ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: 'button that opens your email to send complaints directly to our support team.\n\n',
              ),
              const TextSpan(
                text: '• Complaint Review: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: 'We respond within ',
              ),
              const TextSpan(
                text: '72 hours ',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const TextSpan(
                text: 'and may request more details from both parties.\n\n',
              ),
              const TextSpan(
                text: '• If Seller is Guilty:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '  - Stripe payouts may be frozen\n'),
              const TextSpan(text: '  - Account may be permanently suspended or deleted\n'),
              const TextSpan(text: '  - May be reported to local authorities for fraud or theft\n\n'),
              const TextSpan(
                text: '• If Customer is Guilty:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '  - Account may be suspended or deleted\n'),
              const TextSpan(text: '  - Serious cases may be reported to the police\n\n'),
              const TextSpan(
                text: 'We aim to ensure a safe, fair platform for everyone. Violations are taken seriously and acted upon promptly.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
