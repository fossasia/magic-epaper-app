import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/employee_id_model.dart';
import 'package:magicepaperapp/card_templates/util/template_card_preview.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

class EmployeeIdCardWidget extends StatelessWidget {
  final EmployeeIdModel data;

  const EmployeeIdCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return TemplateCardPreview(
      title: data.companyName,
      titlePlaceholder: appLocalizations.defaultCompanyName,
      fields: [
        TemplateInfoField(appLocalizations.namePrefix, data.name),
        TemplateInfoField(appLocalizations.positionPrefix, data.position),
        TemplateInfoField(appLocalizations.divisionPrefix, data.division),
        TemplateInfoField(appLocalizations.idPrefix, data.idNumber),
      ],
      qrData: data.qrData,
      photo: data.profileImage,
    );
  }
}
