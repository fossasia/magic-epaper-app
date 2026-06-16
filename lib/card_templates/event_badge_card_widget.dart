import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/event_badge_model.dart';
import 'package:magicepaperapp/card_templates/util/template_card_preview.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class EventBadgeCardWidget extends StatelessWidget {
  final EventBadgeModel data;

  const EventBadgeCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return TemplateCardPreview(
      title: data.eventName,
      titlePlaceholder: appLocalizations.eventName,
      fields: [
        TemplateInfoField(
            appLocalizations.attendeeNamePrefix, data.attendeeName),
        TemplateInfoField(appLocalizations.rolePrefix, data.role),
        TemplateInfoField(
            appLocalizations.organizationPrefix, data.organization),
        TemplateInfoField(appLocalizations.ticketIdPrefix, data.ticketId),
      ],
      qrData: data.qrData,
      photo: data.profileImage,
    );
  }
}
