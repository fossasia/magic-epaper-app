import 'dart:io';
import 'package:magicepaperapp/card_templates/employee_id_model.dart';
import 'package:magicepaperapp/card_templates/entry_pass_tag_model.dart';
import 'package:magicepaperapp/card_templates/event_badge_model.dart';
import 'package:magicepaperapp/card_templates/price_tag_model.dart';
import 'package:magicepaperapp/card_templates/template_layer_builders.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/template_util.dart';

AppLocalizations get _l10n => getIt.get<AppLocalizations>();

class BulkField {
  final String key;
  final String label;
  final List<String> aliases;
  final bool required;
  final bool isPhoto;
  final bool namesOutput;

  const BulkField({
    required this.key,
    required this.label,
    this.aliases = const [],
    this.required = false,
    this.isPhoto = false,
    this.namesOutput = false,
  });
}

typedef LayersFromRow = List<LayerSpec> Function(
  Map<String, String> row,
  File? photo,
  int width,
  int height,
);

class BulkTemplate {
  final String id;
  final String title;
  final List<BulkField> fields;
  final LayersFromRow buildLayers;
  final bool hasPhoto;

  const BulkTemplate({
    required this.id,
    required this.title,
    required this.fields,
    required this.buildLayers,
    this.hasPhoto = false,
  });

  BulkField get nameField {
    for (final f in fields) {
      if (f.namesOutput) return f;
    }
    return fields.first;
  }
}

BulkTemplate employeeIdBulkTemplate() {
  return BulkTemplate(
    id: 'employee_id',
    title: _l10n.employeeIdCardTitle,
    fields: [
      BulkField(
        key: 'companyName',
        label: _l10n.companyName,
        aliases: const ['company', 'companyname', 'company name', 'employer'],
        required: true,
      ),
      BulkField(
        key: 'name',
        label: _l10n.name,
        aliases: const [
          'name',
          'fullname',
          'full name',
          'employee',
          'employeename'
        ],
        required: true,
        namesOutput: true,
      ),
      BulkField(
        key: 'position',
        label: _l10n.position,
        aliases: const ['position', 'title', 'designation', 'role'],
      ),
      BulkField(
        key: 'division',
        label: _l10n.division,
        aliases: const ['division', 'department', 'dept', 'team'],
      ),
      BulkField(
        key: 'idNumber',
        label: _l10n.idNumber,
        aliases: const ['id', 'idnumber', 'id number', 'employeeid', 'empid'],
      ),
      BulkField(
        key: 'qr',
        label: _l10n.qrCodeData,
        aliases: const ['qr', 'qrcode', 'qr code', 'qrdata', 'url', 'link'],
      ),
      _photoField(),
    ],
    buildLayers: (row, photo, width, height) => buildEmployeeIdLayers(
      data: EmployeeIdModel(
        companyName: row['companyName'] ?? '',
        name: row['name'] ?? '',
        idNumber: row['idNumber'] ?? '',
        division: row['division'] ?? '',
        position: row['position'] ?? '',
        qrData: row['qr'] ?? '',
      ),
      width: width,
      height: height,
      photo: photo,
    ),
    hasPhoto: true,
  );
}

BulkTemplate priceTagBulkTemplate() {
  return BulkTemplate(
    id: 'price_tag',
    title: _l10n.shopPriceTagTitle,
    fields: [
      BulkField(
        key: 'productName',
        label: _l10n.productName,
        aliases: const [
          'product',
          'productname',
          'product name',
          'item',
          'name'
        ],
        required: true,
        namesOutput: true,
      ),
      BulkField(
        key: 'productDescription',
        label: _l10n.productDescription,
        aliases: const ['description', 'desc', 'details', 'productdescription'],
      ),
      BulkField(
        key: 'price',
        label: _l10n.price,
        aliases: const ['price', 'cost', 'amount'],
      ),
      BulkField(
        key: 'currency',
        label: _l10n.currency,
        aliases: const ['currency', 'symbol', 'currencysymbol'],
      ),
      BulkField(
        key: 'quantity',
        label: _l10n.quantitySize,
        aliases: const ['quantity', 'qty', 'size', 'stock'],
      ),
      BulkField(
        key: 'barcode',
        label: _l10n.barcodeData,
        aliases: const ['barcode', 'barcodedata', 'sku', 'ean', 'upc', 'code'],
      ),
      _photoField(),
    ],
    buildLayers: (row, photo, width, height) => buildPriceTagLayers(
      data: PriceTagModel(
        productName: row['productName'] ?? '',
        productDescription: row['productDescription'] ?? '',
        price: row['price'] ?? '',
        currency: row['currency'] ?? '',
        quantity: row['quantity'] ?? '',
        barcodeData: row['barcode'] ?? '',
      ),
      width: width,
      height: height,
      photo: photo,
    ),
    hasPhoto: true,
  );
}

BulkTemplate eventBadgeBulkTemplate() {
  return BulkTemplate(
    id: 'event_badge',
    title: _l10n.eventBadgeTitle,
    fields: [
      BulkField(
        key: 'eventName',
        label: _l10n.eventName,
        aliases: const ['event', 'eventname', 'event name'],
        required: true,
      ),
      BulkField(
        key: 'attendeeName',
        label: _l10n.attendeeName,
        aliases: const [
          'name',
          'attendee',
          'attendeename',
          'attendee name',
          'fullname'
        ],
        required: true,
        namesOutput: true,
      ),
      BulkField(
        key: 'role',
        label: _l10n.role,
        aliases: const ['role', 'title', 'designation'],
      ),
      BulkField(
        key: 'organization',
        label: _l10n.organization,
        aliases: const ['org', 'organization', 'organisation', 'company'],
      ),
      BulkField(
        key: 'ticketId',
        label: _l10n.ticketId,
        aliases: const ['ticket', 'ticketid', 'ticket id', 'ticketnumber'],
      ),
      BulkField(
        key: 'qr',
        label: _l10n.qrCodeData,
        aliases: const ['qr', 'qrcode', 'qr code', 'qrdata', 'url', 'link'],
      ),
      _photoField(),
    ],
    buildLayers: (row, photo, width, height) => buildEventBadgeLayers(
      data: EventBadgeModel(
        eventName: row['eventName'] ?? '',
        attendeeName: row['attendeeName'] ?? '',
        role: row['role'] ?? '',
        organization: row['organization'] ?? '',
        ticketId: row['ticketId'] ?? '',
        qrData: row['qr'] ?? '',
      ),
      width: width,
      height: height,
      photo: photo,
    ),
    hasPhoto: true,
  );
}

BulkTemplate entryPassTagBulkTemplate() {
  return BulkTemplate(
    id: 'entry_pass_tag',
    title: _l10n.entryPassTagTitle,
    fields: [
      BulkField(
        key: 'venueName',
        label: _l10n.venueName,
        aliases: const ['venue', 'venuename', 'venue name', 'event'],
        required: true,
      ),
      BulkField(
        key: 'visitorName',
        label: _l10n.visitorName,
        aliases: const [
          'name',
          'visitor',
          'visitorname',
          'visitor name',
          'guest'
        ],
        required: true,
        namesOutput: true,
      ),
      BulkField(
        key: 'passType',
        label: _l10n.passType,
        aliases: const ['type', 'passtype', 'pass type', 'category'],
      ),
      BulkField(
        key: 'validDate',
        label: _l10n.validDate,
        aliases: const ['date', 'validdate', 'valid date', 'validity'],
      ),
      BulkField(
        key: 'passId',
        label: _l10n.passId,
        aliases: const ['passid', 'pass id', 'id', 'passnumber'],
      ),
      BulkField(
        key: 'qr',
        label: _l10n.qrCodeData,
        aliases: const ['qr', 'qrcode', 'qr code', 'qrdata', 'url', 'link'],
      ),
      _photoField(),
    ],
    buildLayers: (row, photo, width, height) => buildEntryPassTagLayers(
      data: EntryPassTagModel(
        venueName: row['venueName'] ?? '',
        visitorName: row['visitorName'] ?? '',
        passType: row['passType'] ?? '',
        validDate: row['validDate'] ?? '',
        passId: row['passId'] ?? '',
        qrData: row['qr'] ?? '',
      ),
      width: width,
      height: height,
      photo: photo,
    ),
    hasPhoto: true,
  );
}

BulkField _photoField() {
  return BulkField(
    key: 'photo',
    label: _l10n.bulkPhotoColumnLabel,
    aliases: const [
      'photo',
      'image',
      'picture',
      'avatar',
      'photourl',
      'imageurl',
      'photolink',
      'headshot',
      'pic'
    ],
    isPhoto: true,
  );
}
