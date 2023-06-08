import 'package:flutter/material.dart';
import 'package:idea_test/utils/commons.dart';

import '../../../utils/constants/app_strings.dart';

BottomNavigationBarItem appBottomNavigationBarItem(
    {String? imagePath, String? label, bool isGradient = false}) {
  return BottomNavigationBarItem(
    icon: Column(
      children: [
        Image.asset(imagePath ?? ""),
        const SizedBox(
          height: 5,
        ),
        Visibility(
            replacement: Text(label ?? "",
                style: Commons()
                    .theme
                    .bottomNavigationBarTheme
                    .unselectedLabelStyle),
            visible: isGradient,
            child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF55FF5D), Color(0xFF00FFC6)],
                    ).createShader(bounds),
                child: Text(label??"",
                    style: Commons()
                        .theme
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w500))))
      ],
    ),
    label: "",
    backgroundColor: Commons().theme.bottomNavigationBarTheme.backgroundColor,
  );
}
