import 'package:flutter/material.dart';

class EmptySearchWidget extends StatelessWidget {
  final String keyword;

  const EmptySearchWidget({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/no_result.png',
              width: 200,
            ),
            const SizedBox(height: 24),
            const Text(
              "Sorry",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "No result match for this keyword",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}