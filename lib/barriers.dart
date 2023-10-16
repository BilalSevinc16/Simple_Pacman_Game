import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final Color innerColor;
  final Color outerColor;
  final Widget? child;

  const MyBarrier({
    super.key,
    required this.innerColor,
    required this.outerColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(5),
          color: outerColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: innerColor,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
