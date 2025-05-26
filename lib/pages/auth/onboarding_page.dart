import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/auth/welcome_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingContent> _pages = const [
    _OnboardingContent(
      imagePath: 'assets/images/onboarding_diagnosis.png',
      title: "Smart Health Recommendations",
      description:
          "Get personalized medical advice using our AI-powered symptom checker. Your health journey starts with accurate insights.",
    ),
    _OnboardingContent(
      imagePath: 'assets/images/onboarding_chat.png',
      title: "Chat with Our Health Bot",
      description:
          "Got questions? Our AI chatbot is ready to assist you with medical advice, rental help, and more — anytime, anywhere.",
    ),
    _OnboardingContent(
      imagePath: 'assets/images/onboarding_items.png',
      title: "Rent Medical Equipment Easily",
      description:
          "Your health is our priority. Browse and rent wheelchairs, oxygen cylinders, and more from nearby providers.",
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      context.read<AuthBloc>().add(AuthCredentialsRequired());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => _OnboardingScreen(content: _pages[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                icon: Icon(_currentPage == _pages.length - 1
                    ? Icons.check
                    : Icons.arrow_forward_ios_outlined),
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                label: Text(
                  _currentPage == _pages.length - 1 ? "Get Started" : "Next",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingContent {
  final String imagePath;
  final String title;
  final String description;

  const _OnboardingContent({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class _OnboardingScreen extends StatelessWidget {
  final _OnboardingContent content;
  const _OnboardingScreen({required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Image.asset(content.imagePath, height: 300),
        ),
        const SizedBox(height: 20),
        Text(
          content.title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            content.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

Route createRoute(Widget child, {Offset beginOffset=const Offset(0.0, 10.0)}) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
    return child;
  }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
    // const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.ease;
    var tween = Tween(begin: beginOffset, end: end).chain(CurveTween(curve: curve));
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  });
}


