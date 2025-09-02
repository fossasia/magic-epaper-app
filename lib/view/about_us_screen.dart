import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/orientation_util.dart';
import 'package:magicepaperapp/util/url_util.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

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
    return CommonScaffold(
      index: 3,
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 1),
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
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
                            fontSize: 12,
                          ),
                          softWrap: true,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                appLocalizations.developedBy,
                                style: GoogleFonts.sora(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: GestureDetector(
                                onTap: () => openUrl(context,
                                    'https://github.com/fossasia/magic-epaper-app/graphs/contributors'),
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
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 1,
                        color: Colors.grey,
                        offset: Offset(0, 1),
                      )
                    ],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 12.0),
                        child: Text(
                          appLocalizations.contactWithUs,
                          style: GoogleFonts.sora(
                            fontSize: 16,
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
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          appLocalizations.githubSubtitle,
                          style: GoogleFonts.sora(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                          softWrap: true,
                        ),
                        onTap: () => openUrl(context,
                            'https://github.com/fossasia/magic-epaper-app'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 1,
                        color: Colors.grey,
                        offset: Offset(0, 1),
                      )
                    ],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          appLocalizations.license,
                          style: GoogleFonts.sora(
                            fontSize: 18,
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
                          appLocalizations.license,
                          style: GoogleFonts.sora(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          appLocalizations.licenseSubtitle,
                          style: GoogleFonts.sora(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                          softWrap: true,
                        ),
                        onTap: () => openUrl(context,
                            'https://github.com/fossasia/magic-epaper-app/blob/main/LICENSE.md'),
                      ),
                      // ListTile(
                      //   leading: Image.asset('assets/icons/book.png', height: 40),
                      //   title: Text(
                      //     'Library Licenses',
                      //     style: GoogleFonts.sora(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w500,
                      //         color: Colors.black),
                      //   ),
                      //   subtitle: Text(
                      //     'Check third-party libs used on Badge Magic.',
                      //     style: GoogleFonts.sora(
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.w500,
                      //         color: Colors.grey),
                      //   ),
                      //   onTap: () => showLicenseDialog(context),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      title: appLocalizations.appName,
    );
  }
}
