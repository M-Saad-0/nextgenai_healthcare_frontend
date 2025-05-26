import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/theme_bloc/theme_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/auth/onboarding_page.dart';
import 'package:next_gen_ai_healthcare/pages/auth/splash_page.dart';
import 'package:next_gen_ai_healthcare/pages/settings/privacy_policy.dart';
import 'package:next_gen_ai_healthcare/pages/settings/rent_policy,dart';
import 'package:next_gen_ai_healthcare/widgets/show_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  final User user;
  const SettingsPage({super.key, required this.user});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool logOutLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLogoutState) {
          logOutLoading = false;
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SplashPage()),
            (route) => false,
          );
          showToastMessage("You have been logged out.");
        } else if (state is AuthLogOutLoading) {
          setState(() {
            logOutLoading = true;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.onSecondaryFixedVariant,
                    child: FaIcon(
                      FontAwesomeIcons.brush,
                      color: Theme.of(context).primaryColor,
                    )),
                title: const Text("Change Theme"),
                subtitle: Text(context.read<ThemeBloc>().isDark
                    ? "Dark Mode"
                    : "Light Mode"),
                trailing: Switch(
                    value: context.read<ThemeBloc>().isDark,
                    onChanged: (v) {
                      setState(() {});
                      v
                          ? context
                              .read<ThemeBloc>()
                              .add(ThemeToggleDarkEvent())
                          : context
                              .read<ThemeBloc>()
                              .add(ThemeToggleLightEvent());
                    }),
              ),
              ListTile(
                leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.onSecondaryFixedVariant,
                    child: FaIcon(
                      FontAwesomeIcons.brush,
                      color: Theme.of(context).primaryColor,
                    )),
                title: const Text("Stripe Connect"),
                subtitle: Text("Connect your Stripe account"),
                trailing: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.creditCard,
                    color: widget.user.accountId == null
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                  ),
                  onPressed: widget.user.accountId == null
                      ? () {
                          showToastMessage(
                              "Stripe Connect is not implemented yet.");
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Stripe Connect"),
                              content: const Text(
                                  "Stripe Connect is not implemented yet."),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      Map<String, dynamic> sellerAccount =
                                          await OrderAndPaymentImp()
                                              .createSellerStripeAccount(widget.user.userId);
                                      final onboardingUrl =
                                          sellerAccount['url'];
                                      final accountId =
                                          sellerAccount['accountId'];
                                      User updatedUser = widget.user
                                          .copyWith(accountId: accountId);
                                      AuthenticationImp().saveAccountLocally(
                                          user: updatedUser);
                                      if (await canLaunchUrl(
                                          Uri.parse(onboardingUrl))) {
                                        await launchUrl(
                                            Uri.parse(onboardingUrl),
                                            mode:
                                                LaunchMode.externalApplication);
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"))
                              ],
                            ),
                          );
                        }
                      : () {
                        print(widget.user.accountId);
                          showToastMessage(
                              "You are already connected to Stripe.${widget.user.accountId}");
                        },
                ),
              ),
              ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("LogOut"),
                            content: logOutLoading
                                ? const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        CircularProgressIndicator(),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Logging Out...")
                                      ])
                                : const Text(
                                    "Are you sure you want to logout?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel")),
                              TextButton(
                                  onPressed: () {
                                    context.read<AuthBloc>().add(AuthLogout());
                                  },
                                  child: const Text("LogOut"))
                            ],
                          ));
                },
                leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.onSecondaryFixedVariant,
                    child: Icon(
                      Icons.logout,
                      color: Theme.of(context).primaryColor,
                    )),
                subtitle: const Text("Sign out of your account"),
                title: const Text("Log out"),
                // trailing: const FaIcon(FontAwesomeIcons.brandsFontAwesome),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, createRoute(const PrivacyPolicyPage()));
                },
                leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.onSecondaryFixedVariant,
                    child: FaIcon(
                      FontAwesomeIcons.shieldHalved,
                      color: Theme.of(context).primaryColor,
                    )),
                subtitle: const Text("View our privacy policy"),
                title: const Text("Privacy Policy"),
                // trailing: const FaIcon(FontAwesomeIcons.brandsFontAwesome),
              ),
               ListTile(
                onTap: () {
                  Navigator.push(context, createRoute(const BorrowingPolicyPage()));
                },
                leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.onSecondaryFixedVariant,
                    child: FaIcon(
                      FontAwesomeIcons.scaleBalanced,
                      color: Theme.of(context).primaryColor,
                    )),
                subtitle: const Text("View our rent policy before renting"),
                title: const Text("Rent Policy"),
                // trailing: const FaIcon(FontAwesomeIcons.brandsFontAwesome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
