import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idea_test/utils/constants/app_assets.dart';

import '../../utils/constants/app_strings.dart';
import '../../utils/widgets/app_button.dart';
import '../provider/subscription_provider.dart';
import 'shared/bottom_bar_item.dart';

class SubscriptionView extends ConsumerStatefulWidget {
  const SubscriptionView({Key? key}) : super(key: key);

  @override
  ConsumerState<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends ConsumerState<SubscriptionView> {
  @override
  void initState() {
    ref.read(subscriptionProvider).onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF55FF5D), Color(0xFF00FFC6)],
                      ).createShader(bounds),
                  child: Text(AppStrings.subscribe,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headlineMedium!
                          .copyWith(fontWeight: FontWeight.w600))),
              const SizedBox(
                height: 26,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: AppStrings.skyRocket,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          )),
                  TextSpan(
                      text: AppStrings
                          .yourBusinessWithHundredsOfHighConvertingAds,
                      style: Theme.of(context).textTheme.displaySmall)
                ]),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    color: const Color(0xFF1D1D1F),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                      ref.watch(subscriptionProvider).iconTextList.length,
                      (index) {
                    final data =
                        ref.watch(subscriptionProvider).iconTextList[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Image.asset(
                          data.imagePath!,
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                                children: List.generate(
                                    data.text!.split(" ").length, (index) {
                              final text = data.text!.split(" ")[index];
                              return text == AppStrings.unlimited
                                  ? TextSpan(
                                      text: " $text",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w700))
                                  : TextSpan(
                                      text: " $text",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall);
                            })),
                          ),
                        )
                      ],
                    );
                  }),
                ),
              ),
              ...List.generate(
                ref.watch(subscriptionProvider).products.length,
                (index) {
                  final data = ref.watch(subscriptionProvider).products[index];
                  final provider = ref.watch(subscriptionProvider);
                  bool isBanner =
                      ref.watch(subscriptionProvider).products.isNotEmpty;
                  return ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(30),
                    child: !isBanner
                        ? AppButton(
                            onPressed: () {
                              ref
                                  .read(subscriptionProvider)
                                  .onProductButton(data: data);
                            },
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            isGradient: true,
                            gradientColors: const [
                              Color(0xFF55FF5D),
                              Color(0xFF00FFC6)
                            ],
                            child: Text(ref
                                .watch(subscriptionProvider)
                                .products[index]
                                .price))
                        : Banner(
                            location: BannerLocation.topEnd,
                            message: AppStrings.bestDeal,
                            color: Theme.of(context).colorScheme.primary,
                            child: AppButton(
                                onPressed: () async {
                                  provider.onProductButton(data: data);
                                },
                                height: 56,
                                width: MediaQuery.of(context).size.width,
                                isGradient: true,
                                gradientColors: const [
                                  Color(0xFF55FF5D),
                                  Color(0xFF00FFC6)
                                ],
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: AppStrings.duration,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .displayMedium),
                                    TextSpan(
                                        text: " (only ${data.price}!)",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headlineSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w500))
                                  ]),
                                )),
                          ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            appBottomNavigationBarItem(
                imagePath: AppAssets.ads, label: AppStrings.ads),
            appBottomNavigationBarItem(
                imagePath: AppAssets.subscribe,
                label: AppStrings.subscribe,
                isGradient: true),
            appBottomNavigationBarItem(
                imagePath: AppAssets.settings, label: AppStrings.settings)
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: ref.watch(subscriptionProvider).tabIndex,
          iconSize: 24,
          elevation: 5),
    );
  }
}
