import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/theme/colors.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem(this.question, this.answer);
}

List<_FaqItem> _buildFaqs(AppLocalizations l) => [
      _FaqItem(l.faqQ1, l.faqA1),
      _FaqItem(l.faqQ2, l.faqA2),
      _FaqItem(l.faqQ3, l.faqA3),
      _FaqItem(l.faqQ4, l.faqA4),
      _FaqItem(l.faqQ5, l.faqA5),
      _FaqItem(l.faqQ6, l.faqA6),
      _FaqItem(l.faqQ7, l.faqA7),
      _FaqItem(l.faqQ8, l.faqA8),
      _FaqItem(l.faqQ9, l.faqA9),
      _FaqItem(l.faqQ10, l.faqA10),
    ];

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final faqs = _buildFaqs(l);
    return CommonScaffold(
      index: 10,
      title: l.faqTitle,
      body: SafeArea(
        top: false,
        bottom: true,
        child: ListView.separated(
          padding: const EdgeInsets.all(Dimens.spacingS),
          itemCount: faqs.length,
          separatorBuilder: (_, __) => const SizedBox(height: Dimens.spacingMd),
          itemBuilder: (context, i) => _FaqTile(item: faqs[i]),
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final _FaqItem item;
  const _FaqTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(Dimens.radiusS),
        boxShadow: const [
          BoxShadow(
            color: grey500,
            offset: Offset(0, 1),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(
          horizontal: Dimens.spacingM,
          vertical: Dimens.spacingS,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          Dimens.spacingM,
          0,
          Dimens.spacingM,
          Dimens.spacingM,
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q: ',
              style: GoogleFonts.sora(
                color: colorAccent,
                fontWeight: FontWeight.w600,
                fontSize: Dimens.fontSizeM,
              ),
            ),
            Expanded(
              child: Text(
                item.question,
                style: GoogleFonts.sora(
                  color: colorAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: Dimens.fontSizeM,
                ),
              ),
            ),
          ],
        ),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A: ',
                style: GoogleFonts.sora(
                  color: colorBlack,
                  fontWeight: FontWeight.w500,
                  fontSize: Dimens.fontSizeS,
                ),
              ),
              Expanded(
                child: Text(
                  item.answer,
                  style: GoogleFonts.sora(
                    color: colorBlack,
                    fontWeight: FontWeight.w400,
                    fontSize: Dimens.fontSizeS,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
