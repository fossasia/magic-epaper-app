import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magicepaperapp/constants/asset_paths.dart';
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
    return CommonScaffold(
      index: 5,
      body: SingleChildScrollView(
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
                      const SizedBox(height: 20),
                      Text(
                        'Thank you for your interest in the FOSSASIA Badges. Currently the Magic ePaper Badge is still in prototype stage. You can order in future on FOSSASIA.com. In the meantime please check out our prototypes on the Git repository.',
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.sora(
                          wordSpacing: 3,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        softWrap: true,
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
                        'Links',
                        style: GoogleFonts.sora(
                          fontSize: 16,
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
                        'FOSSASIA Website',
                        style: GoogleFonts.sora(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Visit fossasia.com for future badge orders',
                        style: GoogleFonts.sora(
                          fontSize: 12,
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
                        'Hardware Repository',
                        style: GoogleFonts.sora(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Check out our badge prototypes and hardware designs',
                        style: GoogleFonts.sora(
                          fontSize: 12,
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
      title: 'Get Badge',
    );
  }
}
