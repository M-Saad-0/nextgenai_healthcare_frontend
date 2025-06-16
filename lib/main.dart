import 'dart:convert';

import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/hero_bloc/hero_bloc_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/item_request_order_bloc/item_request_order_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/theme_bloc/theme_bloc.dart';
import 'package:next_gen_ai_healthcare/constants/api_key.dart';
import 'package:next_gen_ai_healthcare/fcm_services.dart';
import 'package:next_gen_ai_healthcare/firebase_options.dart';
import 'package:next_gen_ai_healthcare/pages/auth/onboarding_page.dart';
import 'package:next_gen_ai_healthcare/pages/auth/splash_page.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_order_page.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_request_page.dart';
import 'package:next_gen_ai_healthcare/simple_bloc_observer.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  
  // Handle background message
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishing_key;
  await Stripe.instance.applySettings();
  await Hive.initFlutter();
  Hive.registerAdapter(ChatsAdapter());
  Hive.registerAdapter(AiRequestModelAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<Chats>('chats');
  await Hive.openBox<User>('user');
  await Hive.openBox('settings');
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Init local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
await FirebaseMessaging.instance.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);

// print("object");
  runApp(MyApp(
    authentication: AuthenticationImp(),
  ));
}



class MyApp extends StatelessWidget {
  final AuthenticationImp authentication;
  const MyApp({super.key, required this.authentication});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => authentication,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(authentication: authentication)
                ..add(Authenticate())),
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc(LocalThemeData()),
          ),
          // BlocProvider<HeroBlocBloc>(
          //   create: (context) => HeroBlocBloc(
          //     retrieveData: RetrieveDataImp(),
          //   ),
          // ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: themeState.theme,
              home: const SplashPage(),
            );
          },
        ),
      ),
    );
  }
}


/* TODO:
### **Must-Have Features:**  
1. **Item Details Page** – Show item details like name, description, rental price, and availability.  
2. **Search & Filters** – Allow users to search and filter items based on category, availability, or location.  
3. **Borrowing Process Enhancement** – Instead of just marking an item as borrowed, consider:  
   - Request & approval system (so the lender approves before it's marked as borrowed).  
   - Setting rental duration.  
4. **Chat or Messaging System** – So borrowers and lenders can discuss terms.  
5. **Notifications** – Send push notifications when an item request is made, accepted, or due.  
6. **User Profile & History** – Show users their borrowed/lent items, rental history, and profile info.  
7. **Reviews & Ratings** – Let borrowers rate lenders and vice versa for trust-building.  
8. **Payment Integration (Optional)** – If rentals involve payments, integrate a system like Stripe or PayPal.  
9. **Item Return & Completion Flow** – A way for the borrower to confirm the return and the lender to mark it as completed.  

Do any of these sound like something you’d want to add next? 🚀*/