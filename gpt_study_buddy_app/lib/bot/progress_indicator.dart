import 'package:flutter/material.dart';

class AnimatedLinearProgressIndicator extends StatelessWidget {
  const AnimatedLinearProgressIndicator({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: 10,
        width: constraints.maxWidth,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5),
              ),
              width: constraints.maxWidth * progress,
            ),
          ],
        ),
      );
    });
  }
}
