import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/util/orientation_util.dart';
import 'package:magicepaperapp/util/url_util.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    setPortraitOrientation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return CommonScaffold(
      index: 5,
      titleWidget: Text(
        AppLocalizations.of(context)!.appName,
        style: const TextStyle(color: Colors.white),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Dimens.spacingS),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimens.radiusL),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 1),
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimens.spacingL),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Center(
                          child: Image.asset(
                            ImageAssets.tempIcon,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          appLocalizations.aboutUsDescription,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.sora(
                            wordSpacing: 3,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: Dimens.fontSizeS,
                          ),
                          softWrap: true,
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                appLocalizations.developedBy,
                                style: GoogleFonts.sora(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontSize: Dimens.fontSizeS,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: Dimens.spacingMd),
                            Flexible(
                              child: GestureDetector(
                                onTap: () => openUrl(
                                  context,
                                  'https://github.com/fossasia/magic-epaper-app/graphs/contributors',
                                ),
                                child: Text(
                                  appLocalizations.fossasiaContributors,
                                  style: GoogleFonts.sora(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                    decoration: TextDecoration.underline,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: Dimens.spacingMd),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 1,
                        color: Colors.grey,
                        offset: Offset(0, 1),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(Dimens.radiusS),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: Dimens.spacingM, top: Dimens.spacingM),
                        child: Text(
                          appLocalizations.contactWithUs,
                          style: GoogleFonts.sora(
                            fontSize: Dimens.fontSizeL,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Image.asset(
                          ImageAssets.githubIcon,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                        title: Text(
                          appLocalizations.github,
                          style: GoogleFonts.sora(
                            fontSize: Dimens.fontSizeL,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          appLocalizations.githubSubtitle,
                          style: GoogleFonts.sora(
                            fontSize: Dimens.fontSizeS,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                          softWrap: true,
                        ),
                        onTap: () => openUrl(
                          context,
                          'https://github.com/fossasia/magic-epaper-app',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Dimens.spacingMd),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 1,
                        color: Colors.grey,
                        offset: Offset(0, 1),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(Dimens.radiusS),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(Dimens.spacingM),
                        child: Text(
                          appLocalizations.license,
                          style: GoogleFonts.sora(
                            fontSize: Dimens.fontSizeXl,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Image.asset(
                          ImageAssets.badgeIcon,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                        title: Text(
                          appLocalizations.appLicense,
                          style: GoogleFonts.sora(
                            fontSize: Dimens.fontSizeL,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          appLocalizations.licenseSubtitle,
                          style: GoogleFonts.sora(
                            fontSize: Dimens.fontSizeS,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                          softWrap: true,
                        ),
                        onTap: () => openUrl(
                          context,
                          'https://github.com/fossasia/magic-epaper-app/blob/main/LICENSE.md',
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.article_outlined,
                          size: 40,
                          color: Colors.grey,
                        ),
                        title: Text(
                          appLocalizations.openSourceLicenses,
                          style: GoogleFonts.sora(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          appLocalizations.openSourceLicensesSubtitle,
                          style: GoogleFonts.sora(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                          softWrap: true,
                        ),
                        onTap: () => showLicensePage(
                          context: context,
                          applicationName: appLocalizations.appName,
                          applicationIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              ImageAssets.appIcon,
                              height: 64,
                              fit: BoxFit.contain,
                            ),
                          ),
                          applicationLegalese:
                              appLocalizations.openSourceLicensesLegalese,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
