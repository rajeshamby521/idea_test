import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:idea_test/home_page/provider/home_page_view_provider.dart';
import 'package:idea_test/utils/widgets/tile_widget.dart';

import '../../utils/commons.dart';
import '../../utils/constants/app_strings.dart';

class HomePageView extends ConsumerStatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends ConsumerState<HomePageView> {
  @override
  void initState() {
    ref.read(homePageProvider).onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        const Color(0xFFF8EBD8).withOpacity(0.72),
        const Color(0xFFF8EBD8)
      ])),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                 Text(
                  AppStrings.homeViewQ,
                  style: Commons().theme.primaryTextTheme.displayLarge,
                ),
                SingleChildScrollView(
                  child: Center(
                    child: StaggeredGrid.count(
                      crossAxisCount: 3,
                      children: List.generate(
                          ref.watch(homePageProvider).data.length, (index) {
                        final data = ref.watch(homePageProvider).data[index];
                        String name = data["name"];
                        return Tile(
                            image: data["icon_url"],
                            title: data["name"],
                            extent: ((name.length) * 22),
                            onPressed: () {
                              if (kDebugMode) {
                                ref.read(homePageProvider).onCategory(context);
                              }
                            });
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
