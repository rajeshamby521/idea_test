import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idea_test/utils/app_theme/app_theme.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'home_page/view/home_page_view.dart';
import 'utils/commons.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await InAppPurchase.instance.restorePurchases();
  runApp(const ProviderScope(child: MyApp()));
}



class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseInAppMessaging messagingInstance = FirebaseInAppMessaging.instance;


  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      theme: AppTheme().lightThemeData(context),
      home: const HomePageView(),
    );
  }
}

