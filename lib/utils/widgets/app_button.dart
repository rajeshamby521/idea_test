import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? padding;
  final List<Color>? gradientColors;
  final bool isGradient;

  const AppButton(
      {Key? key,
      required this.onPressed,
      required this.child,
      this.height = 20,
      this.borderRadius = 30,
      this.padding = 5,
      this.gradientColors,
      this.isGradient = false,
      this.width = 100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: isGradient
                      ? gradientColors!
                      : [
                          Theme.of(context).primaryColor
                          //add more colors
                        ])),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(padding!)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius!))),
                textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600))),
            child: child,
          ),
        ),
      ),
    );
  }
}
