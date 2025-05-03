import 'package:flutter/widgets.dart';

/// Represents an example item with a name, path, icon, and associated page.
///
/// This class is typically used to define examples in an application, where
/// each example has:
/// - A [path]: The navigation route or identifier for the example.
/// - A [name]: A user-friendly name for the example.
/// - An [icon]: An icon representing the example.
/// - A [page]: The widget representing the content of the example.
class Example {
  /// Creates an instance of [Example].
  ///
  /// All fields are required.
  const Example({
    required this.path,
    required this.name,
    required this.icon,
    required this.page,
  });

  /// The navigation route or identifier for the example.
  final String path;

  /// The user-friendly name of the example.
  final String name;

  /// The icon representing the example.
  final IconData icon;

  /// The widget representing the content of the example.
  final Widget page;
}
