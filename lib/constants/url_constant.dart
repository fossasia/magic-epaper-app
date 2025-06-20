import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await canLaunchUrl(uri)) {
    throw 'Could not launch $url';
  } else {
    await launchUrl(uri);
  }
}
