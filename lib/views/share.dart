import 'package:flutter/material.dart';
import 'package:magic_epaper_app/nfc_handler.dart';
import 'package:magic_epaper_app/providers/app_state.dart';
import 'package:provider/provider.dart';
class Share extends StatefulWidget {
  const Share({super.key});

  @override
  State<Share> createState() => _ShareState();
}

class _ShareState extends State<Share> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('A random idea:'),
          Text(appState.current.asLowerCase),
          ElevatedButton(
            onPressed: () async {
              try {
                await NfcHandler().nfc_write();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data transfer started!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },

            child: Text('Start transfer'),
          ),
        ],
      ),
    );
  }
}
