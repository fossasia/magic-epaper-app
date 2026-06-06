import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/entry_pass_tag_model.dart';
import 'package:magicepaperapp/card_templates/util/template_card_preview.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

class EntryPassTagCardWidget extends StatelessWidget {
  final EntryPassTagModel data;

  const EntryPassTagCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return TemplateCardPreview(
      title: data.venueName,
      titlePlaceholder: appLocalizations.venueName,
      fields: [
        TemplateInfoField(appLocalizations.visitorNamePrefix, data.visitorName),
        TemplateInfoField(appLocalizations.passTypePrefix, data.passType),
        TemplateInfoField(appLocalizations.validDatePrefix, data.validDate),
        TemplateInfoField(appLocalizations.passIdPrefix, data.passId),
      ],
      qrData: data.qrData,
      photo: data.profileImage,
    );
  }
}
