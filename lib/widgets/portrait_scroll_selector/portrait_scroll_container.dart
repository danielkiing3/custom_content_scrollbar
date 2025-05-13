import 'package:flutter/material.dart';

class PortraitScrollContainer extends StatelessWidget {
  const PortraitScrollContainer({
    super.key,
    required this.child,
    required this.margin,
    required this.padding,
    required this.height,
    required this.maxHeight,
  });

  final EdgeInsets margin;
  final EdgeInsets padding;
  final double height;
  final double maxHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      // Why center? To respect the constraints I set in the container
      child: Container(
        margin: margin,
        padding: padding,
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(30)),
        height: height,
        child: OverflowBox(alignment: Alignment.topCenter, maxHeight: maxHeight, child: child),
      ),
    );
  }
}
