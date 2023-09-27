import 'package:flutter/material.dart';

class RetryWidget extends StatelessWidget {
  const RetryWidget({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
            'Failed to fetch data',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Retry',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }
}
