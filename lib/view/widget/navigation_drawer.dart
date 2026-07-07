import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:magicepaperapp/util/app_logger.dart';
import 'package:magicepaperapp/util/epd/configurable_editor.dart';
import 'package:magicepaperapp/util/url_util.dart';
import 'package:magicepaperapp/view/image_editor.dart';
import 'package:magicepaperapp/view/widget/configurable_epd_dialog.dart';
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
      colors: [colorWhite, colorBlack, Colors.red],
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
          AppLogger.warning('ColorPaletteProvider not available: $e');
        }

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ImageEditor(isExportOnly: true, device: customEpd),
          ),
        );
      }
    }
  }

  void _showArduinoHelpDialog() {
    final appLocalizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.blue),
            const SizedBox(width: Dimens.spacingS),
            Text(appLocalizations.arduinoExport),
          ],
        ),
        content: Text(appLocalizations.arduinoExportHelp),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(appLocalizations.gotIt),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showArduinoExportDialog();
            },
            child: Text(appLocalizations.continueButton),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: drawerHeaderTitle,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: colorAccent),
              child: Center(
                child: Text(
                  appLocalizations.appName,
                  style: const TextStyle(
                    color: drawerHeaderTitle,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          _buildListTile(
            index: 0,
            icon: Icons.edit,
            title: appLocalizations.createTransfer,
            routeName: '/',
          ),
          _buildListTile(
            index: 1,
            icon: Icons.nfc,
            title: appLocalizations.readNfcTags,
            routeName: '/nfcReadScreen',
          ),
          _buildListTile(
            index: 2,
            icon: Icons.nfc_outlined,
            title: appLocalizations.writeNfcTags,
            routeName: '/nfcWriteScreen',
          ),
          _buildListTileWithTooltip(
            index: 3,
            icon: Icons.code,
            title: appLocalizations.arduinoExport,
            routeName: '/arduinoExport',
            isCustomAction: true,
            showHelp: true,
          ),
          _buildListTile(
            index: 4,
            icon: Icons.settings,
            title: appLocalizations.settings,
            routeName: '/settings',
          ),
          _buildListTile(
            index: 5,
            icon: Icons.people,
            title: appLocalizations.aboutUs,
            routeName: '/aboutUs',
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 18.0, vertical: Dimens.spacingMd),
            child: Text(
              appLocalizations.other,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: Dimens.fontSizeM,
              ),
            ),
          ),
          _buildListTile(
            index: 6,
            icon: Icons.shopping_cart,
            title: appLocalizations.getBadge,
            routeName: '/buyBadge',
          ),
          _buildListTile(
            index: 7,
            icon: Icons.bug_report,
            title: appLocalizations.feedbackBugReports,
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
          ? Icon(icon, color: currentIndex == index ? colorAccent : colorBlack)
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
          fontSize: Dimens.fontSizeM,
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
          ? Icon(icon, color: currentIndex == index ? colorAccent : colorBlack)
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
          fontSize: Dimens.fontSizeM,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: currentIndex == index
                    ? colorAccent.withValues(alpha: 0.7)
                    : grey600,
                fontSize: Dimens.fontSizeS,
              ),
            )
          : null,
      trailing: showHelp
          ? IconButton(
              icon: Icon(Icons.help_outline, size: 18, color: grey600),
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
