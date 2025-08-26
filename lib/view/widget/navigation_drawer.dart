import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
//import 'package:share_plus/share_plus.dart';
import 'package:magicepaperapp/util/url_util.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: drawerHeaderTitle,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
              child: Center(
                child: Text(
                  appLocalizations.appName,
                  style: const TextStyle(
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
            title: appLocalizations.selectDisplay,
            routeName: '/',
          ),
          _buildListTile(
            index: 1,
            icon: Icons.nfc,
            title: appLocalizations.ndefScreen,
            routeName: '/ndefScreen',
          ),
          _buildListTile(
            index: 2,
            icon: Icons.settings,
            title: appLocalizations.settings,
            routeName: '/settings',
          ),
          _buildListTile(
            index: 3,
            icon: Icons.people,
            title: appLocalizations.aboutUs,
            routeName: '/aboutUs',
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: Text(
              appLocalizations.other,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          _buildListTile(
            index: 5,
            icon: Icons.shopping_cart,
            title: appLocalizations.buyBadge,
            routeName: '/buyBadge',
            externalLink: 'https://fossasia.com/',
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
            index: 6,
            icon: Icons.bug_report,
            title: appLocalizations.feedbackBugReports,
            routeName: '/feedback',
            externalLink: 'https://github.com/fossasia/magic-epaper-app/issues',
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
        Navigator.pop(context);
        if (externalLink != null) {
          openUrl(context, externalLink);
        } else if (shareText != null) {
          //SharePlus.instance.share(ShareParams(text: shareText));
        } else {
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
