import 'dart:ui';
import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/auth/onboarding_page.dart';
import 'package:next_gen_ai_healthcare/pages/auth/welcome_page.dart';
import 'package:next_gen_ai_healthcare/pages/home/home_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const SplashLoadingScreen();
        } else if (state is AuthLoadingSuccess) {
          return NavigationMainPage(user: state.user);
        } else if (state is GoogleAuthCnicPhoneState) {
          return const CnicPhoneForm();
        } else if (state is AuthCredentialsState) {
          return const WelcomePage();
        } else {
          return const OnboardingPage();
        }
      },
    );
  }
}

class SplashLoadingScreen extends StatefulWidget {
  const SplashLoadingScreen({super.key});

  @override
  State<SplashLoadingScreen> createState() => _SplashLoadingScreenState();
}

class _SplashLoadingScreenState extends State<SplashLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward()..addListener((){setState(() {});});

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/logo_splash.png',
                  height: 180,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 150,
              child: LinearProgressIndicator(
                color: Theme.of(context).primaryColor,
                value: _fadeAnimation.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CnicPhoneForm extends StatefulWidget {
  const CnicPhoneForm({
    super.key,
  });

  @override
  State<CnicPhoneForm> createState() => _CnicPhoneFormState();
}

class _CnicPhoneFormState extends State<CnicPhoneForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    cnicController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthBloc>().state as GoogleAuthCnicPhoneState;
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: const AlignmentDirectional(20, -0.6),
            child: Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
            child: Container(),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  margin: const EdgeInsets.all(5),
                  duration: const Duration(milliseconds: 350),
                  padding: const EdgeInsets.all(16),
                  height: 330,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: cnicController,
                              decoration: const InputDecoration(
                                labelText: 'CNIC',
                                hintText: 'Enter 13-digit CNIC',
                                prefixIcon: Icon(Icons.credit_card),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 13,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'CNIC is required';
                                }
                                if (value.length != 13) {
                                  return 'CNIC must be 13 digits';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                hintText: '03XXXXXXXXX',
                                prefixIcon: Icon(Icons.phone),
                              ),
                              keyboardType: TextInputType.phone,
                              maxLength: 11,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phone number is required';
                                }
                                if (!RegExp(r'^03\d{9}$').hasMatch(value)) {
                                  return 'Invalid phone number';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  String raw =
                                      cnicController.text.replaceAll("-", "");
                                  if (raw.length >= 13) {
                                    cnicController.text =
                                        '${raw.substring(0, 5)}-${raw.substring(5, 12)}-${raw.substring(12)}';
                                  }

                                  User updatedUser = state.user.copyWith(
                                    cnic: cnicController.text,
                                    phoneNumber: phoneController.text,
                                  );

                                  context.read<AuthBloc>().add(
                                        GoogleAuthCnicPhoneRequired(
                                            user: updatedUser),
                                      );
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
