import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/template_model.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/card_templates/employee_id_form.dart';
import 'package:magicepaperapp/card_templates/price_tag_form.dart';
import 'package:magicepaperapp/card_templates/entry_pass_tag_form.dart';
import 'package:magicepaperapp/card_templates/event_badge_form.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class CardTemplateSelectionView extends StatelessWidget {
  final int width;
  final int height;

  const CardTemplateSelectionView({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      index: -1,
      showBackButton: true,
      toolbarHeight: 85,
      titleWidget: Padding(
        padding:
            const EdgeInsets.fromLTRB(5, Dimens.spacingL, Dimens.spacingL, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalizations.cardTemplates,
              style: const TextStyle(
                fontSize: Dimens.fontSizeDisplay,
                fontWeight: FontWeight.bold,
                color: colorWhite,
              ),
            ),
            const SizedBox(height: Dimens.spacingS),
            Text(
              appLocalizations.chooseTemplateSubtitle,
              style: const TextStyle(
                  fontSize: Dimens.fontSizeL, color: colorWhite),
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Dimens.spacingL, Dimens.spacingXxl,
              Dimens.spacingL, Dimens.spacingL),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              childAspectRatio: 0.7,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: _getTemplates().length,
            itemBuilder: (context, index) {
              final template = _getTemplates()[index];
              return _buildTemplateCard(context, template);
            },
          ),
        ),
      ),
    );
  }

  List<TemplateItem> _getTemplates() {
    return [
      TemplateItem(
        title: appLocalizations.employeeIdCardTitle,
        description: appLocalizations.employeeIdCardDescription,
        icon: Icons.badge_outlined,
        color: Colors.blue,
        isEnabled: true,
        onTap: (context) async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  EmployeeIdForm(width: width, height: height),
            ),
          );
        },
      ),
      TemplateItem(
        title: appLocalizations.shopPriceTagTitle,
        description: appLocalizations.shopPriceTagDescription,
        icon: Icons.local_offer_outlined,
        color: Colors.green,
        isEnabled: true,
        onTap: (context) async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PriceTagForm(width: width, height: height),
            ),
          );
        },
      ),
      TemplateItem(
        title: appLocalizations.entryPassTagTitle,
        description: appLocalizations.entryPassTagDescription,
        icon: Icons.card_membership_outlined,
        color: Colors.orange,
        isEnabled: true,
        onTap: (context) async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  EntryPassTagForm(width: width, height: height),
            ),
          );
        },
      ),
      TemplateItem(
        title: appLocalizations.eventBadgeTitle,
        description: appLocalizations.eventBadgeDescription,
        icon: Icons.person_outline,
        color: Colors.purple,
        isEnabled: true,
        onTap: (context) async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  EventBadgeForm(width: width, height: height),
            ),
          );
        },
      ),
    ];
  }

  Widget _buildTemplateCard(BuildContext context, TemplateItem template) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        final isCompactHeight = availableHeight < 220;

        return InkWell(
          onTap: template.isEnabled ? () => template.onTap(context) : null,
          highlightColor:
              template.isEnabled ? colorAccent.withValues(alpha: 0.1) : null,
          borderRadius: BorderRadius.circular(Dimens.radiusXl),
          splashColor:
              template.isEnabled ? colorAccent.withValues(alpha: 0.2) : null,
          child: Card(
            color: colorWhite,
            elevation: template.isEnabled ? 2 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.radiusXl),
              side: BorderSide(
                color: template.isEnabled ? grey300 : grey200,
                width: 1,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.radiusXl),
                color: template.isEnabled ? colorWhite : grey50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: isCompactHeight ? 2 : 3,
                    child: Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: template.isEnabled
                              ? template.color.withValues(alpha: 0.1)
                              : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Icon(
                          template.icon,
                          size: Dimens.iconSizeXl,
                          color: template.isEnabled ? template.color : grey500,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        Dimens.spacingL, 0, Dimens.spacingL, Dimens.spacingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 40,
                          // color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                template.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Dimens.fontSizeM,
                                  color:
                                      template.isEnabled ? colorBlack : grey600,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: isCompactHeight ? 2 : 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimens.spacingS),
                        Text(
                          template.description,
                          style: TextStyle(
                            fontSize: Dimens.fontSizeXs,
                            color: template.isEnabled ? grey600 : grey500,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: isCompactHeight ? 2 : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!template.isEnabled) ...[
                          SizedBox(height: Dimens.spacingS),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimens.spacingS,
                                vertical: Dimens.spacingXs),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(Dimens.radiusXl),
                              border: Border.all(
                                color: Colors.orange.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              appLocalizations.comingSoon,
                              style: TextStyle(
                                fontSize: Dimens.fontSizeXs,
                                fontWeight: FontWeight.w500,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
