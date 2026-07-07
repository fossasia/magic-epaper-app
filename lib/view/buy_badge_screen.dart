import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/util/orientation_util.dart';
import 'package:magicepaperapp/util/url_util.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

class BuyBadgeScreen extends StatefulWidget {
  const BuyBadgeScreen({super.key});

  @override
  State<BuyBadgeScreen> createState() => _BuyBadgeScreenState();
}

class _BuyBadgeScreenState extends State<BuyBadgeScreen> {
  @override
  void initState() {
    setPortraitOrientation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return CommonScaffold(
      index: 6,
      body: SingleChildScrollView(
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
                      const SizedBox(height: Dimens.spacingXl),
                      Text(
                        appLocalizations.buyBadgeDescription,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.sora(
                          wordSpacing: 3,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: Dimens.fontSizeM,
                        ),
                        softWrap: true,
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
                    )
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
                        appLocalizations.links,
                        style: GoogleFonts.sora(
                          fontSize: Dimens.fontSizeL,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.language,
                        size: 40,
                        color: Colors.red,
                      ),
                      title: Text(
                        appLocalizations.fossasiaWebsite,
                        style: GoogleFonts.sora(
                          fontSize: Dimens.fontSizeL,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        appLocalizations.visitFossasiaForFutureBadgeOrders,
                        style: GoogleFonts.sora(
                          fontSize: Dimens.fontSizeS,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                        softWrap: true,
                      ),
                      onTap: () => openUrl(context, 'https://fossasia.com/'),
                    ),
                    ListTile(
                      leading: Image.asset(
                        ImageAssets.githubIcon,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                      title: Text(
                        appLocalizations.hardwareRepository,
                        style: GoogleFonts.sora(
                          fontSize: Dimens.fontSizeL,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        appLocalizations
                            .checkOutBadgePrototypesAndHardwareDesigns,
                        style: GoogleFonts.sora(
                          fontSize: Dimens.fontSizeS,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                        softWrap: true,
                      ),
                      onTap: () => openUrl(context,
                          'https://github.com/fossasia/magic-epaper-hardware'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      title: appLocalizations.getBadge,
    );
  }
}
