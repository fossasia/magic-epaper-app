import 'package:flutter/material.dart';

/// A widget that displays a centered "Example not found" message.
///
/// This widget is useful as a placeholder for screens or routes
/// that have not been implemented yet or when content is unavailable.
class NotFoundExample extends StatefulWidget {
  /// Creates a `NotFoundExample` widget.
  const NotFoundExample({super.key});

  @override
  State<NotFoundExample> createState() => _NotFoundExampleState();
}

class _NotFoundExampleState extends State<NotFoundExample> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Example not found',
          style: TextStyle(
            fontSize: 20,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
