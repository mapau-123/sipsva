import 'package:flutter/material.dart';

class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    required this.child,
    this.maxWidth = 1100,
    this.padding = const EdgeInsets.fromLTRB(18, 18, 18, 32),
    super.key,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
