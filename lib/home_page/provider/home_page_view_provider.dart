import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idea_test/subscriptions/view/subscription_view.dart';
import 'package:idea_test/utils/constants/app_assets.dart';


final homePageProvider = ChangeNotifierProvider<HomePageViewProvider>(
    (ref) => HomePageViewProvider());

class HomePageViewProvider extends ChangeNotifier {
  List<Map<String, dynamic>> data = [];

  Future<void> onInit() async {
    data.addAll([
      {"icon_url": AppAssets.home, "name": "toy"},
      {"icon_url": AppAssets.home, "name": "fake Data"},
      {"icon_url": AppAssets.home, "name": "Idea  App test"},
      {"icon_url": AppAssets.home, "name": "data fake"},
      {"icon_url": AppAssets.home, "name": "fake files"},
      {"icon_url": AppAssets.home, "name": "Data"},
      {"icon_url": AppAssets.home, "name": "name1"},
      {"icon_url": AppAssets.home, "name": "Long Text Data"},
      {"icon_url": AppAssets.home, "name": "fake"},
      {"icon_url": AppAssets.home, "name": "Long Data"},
      {"icon_url": AppAssets.home, "name": "Long Data"},
      {"icon_url": AppAssets.home, "name": "Random"},
    ]);

  }

  onCategory(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SubscriptionView()));
  }
}
