import 'dart:io';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/employee_id_model.dart';
import 'package:magicepaperapp/card_templates/entry_pass_tag_model.dart';
import 'package:magicepaperapp/card_templates/event_badge_model.dart';
import 'package:magicepaperapp/card_templates/price_tag_model.dart';
import 'package:magicepaperapp/card_templates/util/responsive_layout_util.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/template_util.dart';

AppLocalizations get _l10n => getIt.get<AppLocalizations>();

List<LayerSpec> buildEmployeeIdLayers({
  required EmployeeIdModel data,
  required int width,
  required int height,
  File? photo,
}) {
  final layers = <LayerSpec>[];
  final layout = ResponsiveLayoutUtil.getEmployeeIdLayout(width, height);

  if (photo != null) {
    layers.add(LayerSpec.widget(
      widget: ClipOval(
        child: Image.file(photo, width: 200, height: 200, fit: BoxFit.cover),
      ),
      offset: layout.profileImageOffset,
      scale: layout.profileImageScale,
      kind: LayerKind.image,
      elementId: 'profileImage',
    ));
  }

  if (data.companyName.isNotEmpty) {
    layers.add(LayerSpec.text(
      textStyle: TextStyle(
        fontSize: layout.companyNameFontSize,
        fontWeight: FontWeight.bold,
        color: colorBlack,
      ),
      text: data.companyName,
      textAlign: TextAlign.center,
      offset: layout.companyNameOffset,
      scale: layout.companyNameScale,
      followCanvasTheme: true,
      elementId: 'companyName',
    ));
  }

  if (data.name.isNotEmpty) {
    layers.add(LayerSpec.text(
      text: '${_l10n.namePrefix}${data.name}',
      textStyle: TextStyle(fontSize: layout.textFieldFontSize),
      textAlign: TextAlign.left,
      offset: layout.textOffsets['name']!,
      scale: layout.textFieldScale,
      followCanvasTheme: true,
      elementId: 'name',
    ));
  }

  if (data.position.isNotEmpty) {
    layers.add(LayerSpec.text(
      text: '${_l10n.positionPrefix}${data.position}',
      textStyle: TextStyle(fontSize: layout.textFieldFontSize),
      textAlign: TextAlign.left,
      offset: layout.textOffsets['position']!,
      scale: layout.textFieldScale,
      followCanvasTheme: true,
      elementId: 'position',
    ));
  }

  if (data.division.isNotEmpty) {
    layers.add(LayerSpec.text(
      text: '${_l10n.divisionPrefix}${data.division}',
      textStyle: TextStyle(fontSize: layout.textFieldFontSize),
      textAlign: TextAlign.left,
      offset: layout.textOffsets['division']!,
      scale: layout.textFieldScale,
      followCanvasTheme: true,
      elementId: 'division',
    ));
  }

  if (data.idNumber.isNotEmpty) {
    layers.add(LayerSpec.text(
      text: '${_l10n.idPrefix}${data.idNumber}',
      textStyle: TextStyle(fontSize: layout.textFieldFontSize),
      textAlign: TextAlign.left,
      offset: layout.textOffsets['idNumber']!,
      scale: layout.textFieldScale,
      followCanvasTheme: true,
      elementId: 'idNumber',
    ));
  }

  if (data.qrData.isNotEmpty) {
    layers.add(_qrLayer(
      data.qrData,
      layout.qrCodeSize,
      layout.qrCodeOffset,
      layout.qrCodeScale,
    ));
  }

  return layers;
}

List<LayerSpec> buildPriceTagLayers({
  required PriceTagModel data,
  required int width,
  required int height,
  File? photo,
}) {
  final layers = <LayerSpec>[];
  final layout = ResponsiveLayoutUtil.getPriceTagLayout(width, height);

  if (photo != null) {
    layers.add(LayerSpec.widget(
      widget: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        child: Image.file(photo, width: 200, height: 160, fit: BoxFit.cover),
      ),
      offset: layout.productImageOffset,
      scale: layout.productImageScale,
      kind: LayerKind.image,
      elementId: 'productImage',
    ));
  }

  if (data.productName.isNotEmpty) {
    layers.add(LayerSpec.text(
      text: data.productName,
      textStyle: TextStyle(
          fontSize: layout.productNameFontSize, fontWeight: FontWeight.bold),
      backgroundColor: colorWhite,
      textColor: colorBlack,
      textAlign: TextAlign.center,
      offset: layout.productNameOffset,
      scale: layout.productNameScale,
      elementId: 'productName',
    ));
    if (data.productDescription.isNotEmpty) {
      layers.add(LayerSpec.text(
        text: data.productDescription,
        textStyle: TextStyle(
          fontSize: layout.productDescriptionFontSize,
          fontWeight: FontWeight.normal,
        ),
        backgroundColor: colorWhite,
        textColor: colorBlack,
        textAlign: TextAlign.center,
        offset: layout.productDescriptionOffset,
        scale: layout.productDescriptionScale,
        elementId: 'productDescription',
      ));
    }
  }

  if (data.price.isNotEmpty || data.currency.isNotEmpty) {
    layers.add(LayerSpec.text(
      text: '${data.currency} ${data.price}',
      textStyle: TextStyle(
          fontSize: layout.priceFontSize, fontWeight: FontWeight.bold),
      backgroundColor: colorWhite,
      textColor: Colors.red,
      textAlign: TextAlign.center,
      offset: layout.priceOffset,
      scale: layout.priceScale,
      followCanvasTheme: false,
      elementId: 'price',
    ));
  }

  if (data.quantity.isNotEmpty) {
    layers.add(LayerSpec.text(
      text: data.quantity,
      textStyle: TextStyle(fontSize: layout.quantityFontSize),
      backgroundColor: colorWhite,
      textColor: colorBlack,
      textAlign: TextAlign.center,
      offset: layout.quantityOffset,
      scale: layout.quantityScale,
      elementId: 'quantity',
    ));
  }

  if (data.barcodeData.isNotEmpty) {
    layers.add(LayerSpec.widget(
      widget: BarcodeWidget(
        style: const TextStyle(color: colorBlack),
        padding: const EdgeInsets.all(Dimens.spacingXxs),
        backgroundColor: colorWhite,
        barcode: Barcode.code128(),
        data: data.barcodeData,
        width: layout.barcodeSize.width,
        height: layout.barcodeSize.height,
      ),
      offset: layout.barcodeOffset,
      scale: layout.barcodeScale,
      kind: LayerKind.barcode,
      elementId: 'barcode',
    ));
  }

  return layers;
}

List<LayerSpec> buildEventBadgeLayers({
  required EventBadgeModel data,
  required int width,
  required int height,
  File? photo,
}) {
  final layers = <LayerSpec>[];
  final layout = ResponsiveLayoutUtil.getEventBadgeLayout(width, height);

  if (photo != null) {
    layers.add(LayerSpec.widget(
      widget: ClipOval(
        child: Image.file(photo, width: 200, height: 200, fit: BoxFit.cover),
      ),
      offset: layout.profileImageOffset,
      scale: layout.profileImageScale,
      kind: LayerKind.image,
      elementId: 'profileImage',
    ));
  }

  if (data.eventName.isNotEmpty) {
    layers.add(LayerSpec.text(
      textStyle: TextStyle(
        fontSize: layout.eventNameFontSize,
        fontWeight: FontWeight.bold,
        color: colorBlack,
      ),
      text: data.eventName,
      textColor: colorBlack,
      backgroundColor: colorWhite,
      textAlign: TextAlign.center,
      offset: layout.eventNameOffset,
      scale: layout.eventNameScale,
      elementId: 'eventName',
    ));
  }

  _addPrefixedDetail(
      layers,
      data.attendeeName,
      _l10n.attendeeNamePrefix,
      layout.textFieldFontSize,
      layout.textOffsets['attendeeName']!,
      layout.textFieldScale,
      'attendeeName');
  _addPrefixedDetail(
      layers,
      data.role,
      _l10n.rolePrefix,
      layout.textFieldFontSize,
      layout.textOffsets['role']!,
      layout.textFieldScale,
      'role');
  _addPrefixedDetail(
      layers,
      data.organization,
      _l10n.organizationPrefix,
      layout.textFieldFontSize,
      layout.textOffsets['organization']!,
      layout.textFieldScale,
      'organization');
  _addPrefixedDetail(
      layers,
      data.ticketId,
      _l10n.ticketIdPrefix,
      layout.textFieldFontSize,
      layout.textOffsets['ticketId']!,
      layout.textFieldScale,
      'ticketId');

  if (data.qrData.isNotEmpty) {
    layers.add(_qrLayer(
      data.qrData,
      layout.qrCodeSize,
      layout.qrCodeOffset,
      layout.qrCodeScale,
    ));
  }

  return layers;
}

List<LayerSpec> buildEntryPassTagLayers({
  required EntryPassTagModel data,
  required int width,
  required int height,
  File? photo,
}) {
  final layers = <LayerSpec>[];
  final layout = ResponsiveLayoutUtil.getEntryPassTagLayout(width, height);

  if (photo != null) {
    layers.add(LayerSpec.widget(
      widget: ClipOval(
        child: Image.file(photo, width: 200, height: 200, fit: BoxFit.cover),
      ),
      offset: layout.profileImageOffset,
      scale: layout.profileImageScale,
      kind: LayerKind.image,
      elementId: 'profileImage',
    ));
  }

  if (data.venueName.isNotEmpty) {
    layers.add(LayerSpec.text(
      textStyle: TextStyle(
        fontSize: layout.venueNameFontSize,
        fontWeight: FontWeight.bold,
        color: colorBlack,
      ),
      text: data.venueName,
      textColor: colorBlack,
      backgroundColor: colorWhite,
      textAlign: TextAlign.center,
      offset: layout.venueNameOffset,
      scale: layout.venueNameScale,
      elementId: 'venueName',
    ));
  }

  _addPrefixedDetail(
      layers,
      data.visitorName,
      _l10n.visitorNamePrefix,
      layout.textFieldFontSize,
      layout.textOffsets['visitorName']!,
      layout.textFieldScale,
      'visitorName');
  _addPrefixedDetail(
      layers,
      data.passType,
      _l10n.passTypePrefix,
      layout.textFieldFontSize,
      layout.textOffsets['passType']!,
      layout.textFieldScale,
      'passType');
  _addPrefixedDetail(
      layers,
      data.validDate,
      _l10n.validDatePrefix,
      layout.textFieldFontSize,
      layout.textOffsets['validDate']!,
      layout.textFieldScale,
      'validDate');
  _addPrefixedDetail(
      layers,
      data.passId,
      _l10n.passIdPrefix,
      layout.textFieldFontSize,
      layout.textOffsets['passId']!,
      layout.textFieldScale,
      'passId');

  if (data.qrData.isNotEmpty) {
    layers.add(_qrLayer(
      data.qrData,
      layout.qrCodeSize,
      layout.qrCodeOffset,
      layout.qrCodeScale,
    ));
  }

  return layers;
}

void _addPrefixedDetail(
  List<LayerSpec> layers,
  String value,
  String prefix,
  double fontSize,
  Offset offset,
  double scale,
  String elementId,
) {
  if (value.isEmpty) return;
  layers.add(LayerSpec.text(
    text: '$prefix$value',
    textStyle: TextStyle(fontSize: fontSize),
    textColor: colorBlack,
    backgroundColor: colorWhite,
    textAlign: TextAlign.left,
    offset: offset,
    scale: scale,
    elementId: elementId,
  ));
}

LayerSpec _qrLayer(String qrData, Size size, Offset offset, double scale) {
  return LayerSpec.widget(
    widget: BarcodeWidget(
      padding: const EdgeInsets.all(Dimens.spacingXxs),
      backgroundColor: colorWhite,
      barcode: Barcode.qrCode(),
      data: qrData,
      width: size.width,
      height: size.height,
    ),
    offset: offset,
    scale: scale,
    kind: LayerKind.barcode,
    elementId: 'qr',
  );
}
