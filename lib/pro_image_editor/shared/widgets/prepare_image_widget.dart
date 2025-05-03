import 'package:flutter/material.dart';

/// A widget that displays a loading screen with a progress indicator and a
/// message.
///
/// Used to inform the user that the editor is preparing a demo image.
///
/// The UI consists of:
/// - A circular progress indicator.
/// - A message prompting the user to wait, styled with white text on a dark
/// background.
class PrepareImageWidget extends StatelessWidget {
  /// Creates a [PrepareImageWidget].
  ///
  /// The widget is stateless and serves as a loading screen
  /// with a progress indicator and a message.
  const PrepareImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: Color.fromARGB(255, 19, 21, 22),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.white,
            ),
            SizedBox(height: 24), // Spacing between the widgets
            Text(
              'Please wait...\nThe editor is preparing the demo image',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
