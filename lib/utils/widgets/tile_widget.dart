import 'package:flutter/material.dart';


class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.title,
    this.extent,
    required this.image,
    required this.onPressed,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final String title;
  final String image;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final child = GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(15),
        height: extent,
        decoration: BoxDecoration(
            color: backgroundColor??const Color(0xFFE9DCCC), // border color
            shape: BoxShape.circle),
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(image),
              FittedBox(child: Text(title)),
            ],
          ),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Expanded(child: child);
  }
}
