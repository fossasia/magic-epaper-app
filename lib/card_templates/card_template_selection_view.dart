import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/template_model.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/string_constants.dart';
import 'package:magicepaperapp/card_templates/employee_id_form.dart';
import 'package:magicepaperapp/card_templates/price_tag_form.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

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
      toolbarHeight: 85,
      titleWidget: const Padding(
        padding: EdgeInsets.fromLTRB(5, 16, 16, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringConstants.cardTemplates,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              StringConstants.chooseTemplateSubtitle,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 24, 16.0, 16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
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
        title: StringConstants.employeeIdCardTitle,
        description: StringConstants.employeeIdCardDescription,
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
        title: StringConstants.shopPriceTagTitle,
        description: StringConstants.shopPriceTagDescription,
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
        title: StringConstants.entryPassTagTitle,
        description: StringConstants.entryPassTagDescription,
        icon: Icons.card_membership_outlined,
        color: Colors.orange,
        isEnabled: false,
        onTap: (context) => _showComingSoonDialog(context),
      ),
      TemplateItem(
        title: StringConstants.eventBadgeTitle,
        description: StringConstants.eventBadgeDescription,
        icon: Icons.person_outline,
        color: Colors.purple,
        isEnabled: false,
        onTap: (context) => _showComingSoonDialog(context),
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
          borderRadius: BorderRadius.circular(12),
          splashColor:
              template.isEnabled ? colorAccent.withValues(alpha: 0.2) : null,
          child: Card(
            color: Colors.white,
            elevation: template.isEnabled ? 2 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: template.isEnabled
                    ? Colors.grey.shade300
                    : Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: template.isEnabled ? Colors.white : Colors.grey.shade50,
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
                          size: 32,
                          color:
                              template.isEnabled ? template.color : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 40,
                          // color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                template.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: template.isEnabled
                                      ? colorBlack
                                      : Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: isCompactHeight ? 2 : 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          template.description,
                          style: TextStyle(
                            fontSize: 10,
                            color: template.isEnabled
                                ? Colors.grey.shade600
                                : Colors.grey.shade500,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: isCompactHeight ? 2 : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!template.isEnabled) ...[
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.orange.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              StringConstants.comingSoon,
                              style: TextStyle(
                                fontSize: 10,
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

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: colorAccent, size: 24),
              SizedBox(width: 12),
              Text(
                StringConstants.comingSoon,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            StringConstants.comingSoonMessage,
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                backgroundColor: colorAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(StringConstants.ok),
            ),
          ],
        );
      },
    );
  }
}
