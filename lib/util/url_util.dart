import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';

Future<void> openUrl(BuildContext context, String url) async {
  final l = AppLocalizations.of(context)!;
  try {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.couldNotOpenLink)),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.errorOccurredWhileOpeningLink)),
    );
  }
}
