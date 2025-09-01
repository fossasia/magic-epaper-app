import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/string_constants.dart';
//import 'package:share_plus/share_plus.dart';
import 'package:magicepaperapp/util/url_util.dart';
import 'package:magicepaperapp/view/widget/configurable_epd_dialog.dart';
import 'package:magicepaperapp/util/epd/configurable_editor.dart';
import 'package:magicepaperapp/view/image_editor.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  final int selectedIndex;

  const AppDrawer({super.key, required this.selectedIndex});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.selectedIndex;
  }

  void updateSelectedIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _showArduinoExportDialog() async {
    final configurable = ConfigurableEpd(
      modelId: 'NA',
      width: 400,
      height: 300,
      colors: [Colors.white, Colors.black, Colors.red],
    );
    final result = await showDialog<CustomEpdConfig>(
      context: context,
      builder: (context) => ConfigurableEpdDialog(
        initialWidth: configurable.width,
        initialHeight: configurable.height,
        initialColors: List<Color>.from(configurable.colors),
      ),
    );
    if (result != null) {
      final customEpd = ConfigurableEpd(
        width: result.width,
        height: result.height,
        colors: result.colors,
        modelId: result.presetName,
      );
      if (mounted) {
        try {
          context.read<ColorPaletteProvider>().updateColors(customEpd.colors);
        } catch (e) {
          debugPrint('ColorPaletteProvider not available: $e');
        }
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageEditor(
              isExportOnly: true,
              device: customEpd,
            ),
          ),
        );
      }
    }
  }

  void _showArduinoHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 8),
            Text('Arduino Export'),
          ],
        ),
        content: const Text(
          'This feature allows you to export your ePaper display designs as XMB files for use with Arduino projects.\n\n'
          'Configure your custom ePaper display dimensions and color palette, then export your designs as XMB files that can be loaded onto Arduino-compatible ePaper displays.\n\n'
          'Perfect for creating custom badges, signs, and displays for your Arduino projects!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showArduinoExportDialog();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: drawerHeaderTitle,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const AspectRatio(
            aspectRatio: 16 / 9,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: colorAccent,
              ),
              child: Center(
                child: Text(
                  StringConstants.appName,
                  style: TextStyle(
                      color: drawerHeaderTitle,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          _buildListTile(
            index: 0,
            icon: Icons.edit,
            title: 'Create & Transfer Image',
            routeName: '/',
          ),
          _buildListTile(
            index: 1,
            icon: Icons.nfc,
            title: 'Read NFC Tags',
            routeName: '/nfcReadScreen',
          ),
          _buildListTile(
            index: 2,
            icon: Icons.nfc_outlined,
            title: 'Write NFC Tags',
            routeName: '/nfcWriteScreen',
          ),
          _buildListTile(
            index: 3,
            icon: Icons.settings,
            title: StringConstants.settings,
            routeName: '/settings',
          ),
          _buildListTile(
            index: 4,
            icon: Icons.people,
            title: StringConstants.aboutUs,
            routeName: '/aboutUs',
          ),
          _buildListTileWithTooltip(
            index: 5,
            icon: Icons.code,
            title: 'Arduino Export',
            subtitle: 'Export XMB files for Arduino',
            routeName: '/arduinoExport',
            isCustomAction: true,
            showHelp: true,
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: Text(
              StringConstants.other,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          _buildListTile(
            index: 6,
            icon: Icons.shopping_cart,
            title: 'Get Badge',
            routeName: '/buyBadge',
          ),
          //TODO after adding app to the appstore
          // _buildListTile(
          //   index: 4,
          //   icon: Icons.share,
          //   title: 'Share',
          //   routeName: '/share',
          //   shareText:
          //       'Badge Magic is an app to control LED name badges. This app provides features to portray names, graphics and simple animations on LED badges.You can also download it from below link https://play.google.com/store/apps/details?id=org.fossasia.badgemagic',
          // ),
          // _buildListTile(
          //   index: 8,
          //   icon: Icons.star,
          //   title: 'Rate Us',
          //   routeName: '/rateUs',
          //   externalLink: Platform.isIOS
          //       ? 'https://apps.apple.com/us/app/badge-magic/id6740176888?action=write-review'
          //       : 'https://play.google.com/store/apps/details?id=org.fossasia.badgemagic',
          // ),
          _buildListTile(
            index: 7,
            icon: Icons.bug_report,
            title: StringConstants.feedbackBugReports,
            routeName: '/feedback',
            externalLink: 'https://github.com/fossasia/magic-epaper-app/issues',
          ),
          _buildListTile(
            index: 8,
            icon: Icons.article,
            title: 'Privacy Policy',
            routeName: '/feedback',
            externalLink: 'https://badgemagic.fossasia.org/privacy/',
          ),
          //TODO after adding privacy policy
          // _buildListTile(
          //   index: 10,
          //   assetIcon: "assets/icons/r_insurance.png",
          //   title: 'Privacy Policy',
          //   routeName: '/privacyPolicy',
          //   externalLink: 'https://badgemagic.fossasia.org/privacy/',
          // ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required int index,
    IconData? icon,
    String? assetIcon,
    required String title,
    required String routeName,
    String? externalLink,
    String? shareText,
    bool isCustomAction = false,
  }) {
    return ListTile(
      dense: true,
      leading: icon != null
          ? Icon(
              icon,
              color: currentIndex == index ? colorAccent : colorBlack,
            )
          : Image.asset(
              assetIcon!,
              height: 18,
              color: currentIndex == index ? colorAccent : colorBlack,
            ),
      title: Text(
        title,
        style: TextStyle(
          color: currentIndex == index ? colorAccent : colorBlack,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      selected: currentIndex == index,
      selectedTileColor: dividerColor,
      onTap: () {
        updateSelectedIndex(index);

        if (isCustomAction) {
          _showArduinoExportDialog();
        } else if (externalLink != null) {
          Navigator.pop(context);
          openUrl(context, externalLink);
        } else if (shareText != null) {
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
            context,
            routeName,
            (route) => route.isFirst,
          );
        }
      },
    );
  }

  Widget _buildListTileWithTooltip({
    required int index,
    IconData? icon,
    String? assetIcon,
    required String title,
    String? subtitle,
    required String routeName,
    String? externalLink,
    String? shareText,
    bool isCustomAction = false,
    bool showHelp = false,
  }) {
    return ListTile(
      dense: true,
      leading: icon != null
          ? Icon(
              icon,
              color: currentIndex == index ? colorAccent : colorBlack,
            )
          : Image.asset(
              assetIcon!,
              height: 18,
              color: currentIndex == index ? colorAccent : colorBlack,
            ),
      title: Text(
        title,
        style: TextStyle(
          color: currentIndex == index ? colorAccent : colorBlack,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: currentIndex == index
                    ? colorAccent.withOpacity(0.7)
                    : Colors.grey[600],
                fontSize: 12,
              ),
            )
          : null,
      trailing: showHelp
          ? IconButton(
              icon: Icon(
                Icons.help_outline,
                size: 18,
                color: Colors.grey[600],
              ),
              onPressed: _showArduinoHelpDialog,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            )
          : null,
      selected: currentIndex == index,
      selectedTileColor: dividerColor,
      onTap: () {
        updateSelectedIndex(index);

        if (isCustomAction) {
          _showArduinoExportDialog();
        } else if (externalLink != null) {
          Navigator.pop(context);
          openUrl(context, externalLink);
        } else if (shareText != null) {
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
            context,
            routeName,
            (route) => route.isFirst,
          );
        }
      },
    );
  }
}
