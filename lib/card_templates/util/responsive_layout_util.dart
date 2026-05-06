import 'dart:io';
import 'package:flutter/material.dart';

class ResponsiveLayoutUtil {
  static EmployeeIdLayoutParams getEmployeeIdLayout(int width, int height) {
    final displayKey = '${width}x$height';
    switch (displayKey) {
      case '416x240':
        return EmployeeIdLayoutParams.display416x240();
      case '320x240':
        return EmployeeIdLayoutParams.display320x240();
      case '250x122':
        return EmployeeIdLayoutParams.display250x122();
      case '296x128':
        return EmployeeIdLayoutParams.display296x128();
      case '264x176':
        return EmployeeIdLayoutParams.display264x176();
      case '400x300':
        return EmployeeIdLayoutParams.display400x300();
      case '800x480':
        return EmployeeIdLayoutParams.display800x480();
      case '880x528':
        return EmployeeIdLayoutParams.display880x528();
      default:
        return EmployeeIdLayoutParams.display416x240();
    }
  }

  static PriceTagLayoutParams getPriceTagLayout(int width, int height) {
    final displayKey = '${width}x$height';
    switch (displayKey) {
      case '416x240':
        return PriceTagLayoutParams.display416x240();
      case '320x240':
        return PriceTagLayoutParams.display320x240();
      case '250x122':
        return PriceTagLayoutParams.display250x122();
      case '296x128':
        return PriceTagLayoutParams.display296x128();
      case '264x176':
        return PriceTagLayoutParams.display264x176();
      case '400x300':
        return PriceTagLayoutParams.display400x300();
      case '800x480':
        return PriceTagLayoutParams.display800x480();
      case '880x528':
        return PriceTagLayoutParams.display880x528();
      default:
        return PriceTagLayoutParams.display416x240();
    }
  }

  static EventBadgeLayoutParams getEventBadgeLayout(int width, int height) {
    final displayKey = '${width}x$height';
    switch (displayKey) {
      case '416x240':
        return EventBadgeLayoutParams.display416x240();
      case '320x240':
        return EventBadgeLayoutParams.display320x240();
      case '250x122':
        return EventBadgeLayoutParams.display250x122();
      case '296x128':
        return EventBadgeLayoutParams.display296x128();
      case '264x176':
        return EventBadgeLayoutParams.display264x176();
      case '400x300':
        return EventBadgeLayoutParams.display400x300();
      case '800x480':
        return EventBadgeLayoutParams.display800x480();
      case '880x528':
        return EventBadgeLayoutParams.display880x528();
      default:
        return EventBadgeLayoutParams.display416x240();
    }
  }

  static EntryPassTagLayoutParams getEntryPassTagLayout(int width, int height) {
    final displayKey = '${width}x$height';
    switch (displayKey) {
      case '416x240':
        return EntryPassTagLayoutParams.display416x240();
      case '320x240':
        return EntryPassTagLayoutParams.display320x240();
      case '250x122':
        return EntryPassTagLayoutParams.display250x122();
      case '296x128':
        return EntryPassTagLayoutParams.display296x128();
      case '264x176':
        return EntryPassTagLayoutParams.display264x176();
      case '400x300':
        return EntryPassTagLayoutParams.display400x300();
      case '800x480':
        return EntryPassTagLayoutParams.display800x480();
      case '880x528':
        return EntryPassTagLayoutParams.display880x528();
      default:
        return EntryPassTagLayoutParams.display416x240();
    }
  }

  // Common helper for profile image scaling differences between display types
  static Widget buildProfileImageClip(File imageFile, double scale) {
    // The base 200 size is multiplied by the scale directly here
    // rather than using LayerSpec.scale which can cause editing transform issues
    final double size = 200 * scale;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.file(
        imageFile,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

class EmployeeIdLayoutParams {
  final double profileImageScale;
  final Offset profileImageOffset;
  final double companyNameFontSize;
  final double companyNameScale;
  final Offset companyNameOffset;
  final double textFieldFontSize;
  final double textFieldScale;
  final Map<String, Offset> textOffsets;
  final double qrCodeScale;
  final Offset qrCodeOffset;
  final Size qrCodeSize;

  const EmployeeIdLayoutParams({
    required this.profileImageScale,
    required this.profileImageOffset,
    required this.companyNameFontSize,
    required this.companyNameScale,
    required this.companyNameOffset,
    required this.textFieldFontSize,
    required this.textFieldScale,
    required this.textOffsets,
    required this.qrCodeScale,
    required this.qrCodeOffset,
    required this.qrCodeSize,
  });

  factory EmployeeIdLayoutParams.display416x240() {
    return const EmployeeIdLayoutParams(
      profileImageScale: 5.4,
      profileImageOffset: Offset(-132, -60),
      companyNameFontSize: 50,
      companyNameScale: 1.0,
      companyNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'name': Offset(55, -50),
        'position': Offset(55, -15),
        'division': Offset(55, 20),
        'idNumber': Offset(55, 55),
      },
      qrCodeScale: 6,
      qrCodeOffset: Offset(-130, 55),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EmployeeIdLayoutParams.display320x240() {
    return const EmployeeIdLayoutParams(
      profileImageScale: 6,
      profileImageOffset: Offset(-130, -70),
      companyNameFontSize: 50,
      companyNameScale: 1.0,
      companyNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'name': Offset(55, -50),
        'position': Offset(55, -15),
        'division': Offset(55, 20),
        'idNumber': Offset(55, 55),
      },
      qrCodeScale: 7,
      qrCodeOffset: Offset(-125, 70),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EmployeeIdLayoutParams.display250x122() {
    return const EmployeeIdLayoutParams(
      profileImageScale: 4.5,
      profileImageOffset: Offset(-132, -55),
      companyNameFontSize: 50,
      companyNameScale: 1.0,
      companyNameOffset: Offset(55, -75),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'name': Offset(55, -40),
        'position': Offset(55, -5),
        'division': Offset(55, 30),
        'idNumber': Offset(55, 65),
      },
      qrCodeScale: 5,
      qrCodeOffset: Offset(-130, 45),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EmployeeIdLayoutParams.display296x128() {
    return const EmployeeIdLayoutParams(
      profileImageScale: 3.75,
      profileImageOffset: Offset(-145, -45),
      companyNameFontSize: 50,
      companyNameScale: 1.0,
      companyNameOffset: Offset(55, -70),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'name': Offset(55, -40),
        'position': Offset(55, -5),
        'division': Offset(55, 30),
        'idNumber': Offset(55, 65),
      },
      qrCodeScale: 5,
      qrCodeOffset: Offset(-138, 35),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EmployeeIdLayoutParams.display264x176() {
    return const EmployeeIdLayoutParams(
      profileImageScale: 6,
      profileImageOffset: Offset(-130, -70),
      companyNameFontSize: 50,
      companyNameScale: 1.0,
      companyNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'name': Offset(55, -50),
        'position': Offset(55, -15),
        'division': Offset(55, 20),
        'idNumber': Offset(55, 55),
      },
      qrCodeScale: 7,
      qrCodeOffset: Offset(-125, 60),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EmployeeIdLayoutParams.display400x300() {
    return const EmployeeIdLayoutParams(
      profileImageScale: 6,
      profileImageOffset: Offset(-130, -70),
      companyNameFontSize: 50,
      companyNameScale: 1.0,
      companyNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'name': Offset(55, -50),
        'position': Offset(55, -15),
        'division': Offset(55, 20),
        'idNumber': Offset(55, 55),
      },
      qrCodeScale: 7,
      qrCodeOffset: Offset(-125, 60),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EmployeeIdLayoutParams.display800x480() {
    return const EmployeeIdLayoutParams(
      profileImageScale: 5.5,
      profileImageOffset: Offset(-130, -65),
      companyNameFontSize: 50,
      companyNameScale: 1.0,
      companyNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'name': Offset(55, -50),
        'position': Offset(55, -15),
        'division': Offset(55, 20),
        'idNumber': Offset(55, 55),
      },
      qrCodeScale: 7,
      qrCodeOffset: Offset(-125, 50),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EmployeeIdLayoutParams.display880x528() {
    return const EmployeeIdLayoutParams(
      profileImageScale: 5.5,
      profileImageOffset: Offset(-130, -65),
      companyNameFontSize: 50,
      companyNameScale: 1.0,
      companyNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'name': Offset(55, -50),
        'position': Offset(55, -15),
        'division': Offset(55, 20),
        'idNumber': Offset(55, 55),
      },
      qrCodeScale: 7,
      qrCodeOffset: Offset(-125, 50),
      qrCodeSize: Size(60, 60),
    );
  }
}

class EventBadgeLayoutParams {
  final double profileImageScale;
  final Offset profileImageOffset;
  final double eventNameFontSize;
  final double eventNameScale;
  final Offset eventNameOffset;
  final double textFieldFontSize;
  final double textFieldScale;
  final Map<String, Offset> textOffsets;
  final double dividerScale;
  final Offset dividerOffset;
  final Size dividerSize;
  final double qrCodeScale;
  final Offset qrCodeOffset;
  final Size qrCodeSize;

  const EventBadgeLayoutParams({
    required this.profileImageScale,
    required this.profileImageOffset,
    required this.eventNameFontSize,
    required this.eventNameScale,
    required this.eventNameOffset,
    required this.textFieldFontSize,
    required this.textFieldScale,
    required this.textOffsets,
    required this.dividerScale,
    required this.dividerOffset,
    required this.dividerSize,
    required this.qrCodeScale,
    required this.qrCodeOffset,
    required this.qrCodeSize,
  });

  static const EventBadgeLayoutParams _base = EventBadgeLayoutParams(
    profileImageScale: 5.0,
    profileImageOffset: Offset(-135, -55),
    eventNameFontSize: 48,
    eventNameScale: 1.0,
    eventNameOffset: Offset(55, -88),
    textFieldFontSize: 16,
    textFieldScale: 0.75,
    textOffsets: {
      'attendeeName': Offset(55, -45),
      'role': Offset(55, -15),
      'organization': Offset(55, 25),
      'ticketId': Offset(55, 50),
    },
    dividerScale: 1.0,
    dividerOffset: Offset(55, 5),
    dividerSize: Size(220, 2),
    qrCodeScale: 5.5,
    qrCodeOffset: Offset(-135, 35),
    qrCodeSize: Size(60, 60),
  );

  static Offset _scaleOffset(
      Offset offset, double widthScale, double heightScale) {
    return Offset(offset.dx * widthScale, offset.dy * heightScale);
  }

  static EventBadgeLayoutParams _scaled(double widthScale, double heightScale) {
    return EventBadgeLayoutParams(
      profileImageScale: _base.profileImageScale * widthScale,
      profileImageOffset:
          _scaleOffset(_base.profileImageOffset, widthScale, heightScale),
      eventNameFontSize: _base.eventNameFontSize,
      eventNameScale: _base.eventNameScale * widthScale,
      eventNameOffset:
          _scaleOffset(_base.eventNameOffset, widthScale, heightScale),
      textFieldFontSize: _base.textFieldFontSize,
      textFieldScale: _base.textFieldScale * widthScale,
      textOffsets: {
        'attendeeName': _scaleOffset(
            _base.textOffsets['attendeeName']!, widthScale, heightScale),
        'role':
            _scaleOffset(_base.textOffsets['role']!, widthScale, heightScale),
        'organization': _scaleOffset(
            _base.textOffsets['organization']!, widthScale, heightScale),
        'ticketId': _scaleOffset(
            _base.textOffsets['ticketId']!, widthScale, heightScale),
      },
      dividerScale: _base.dividerScale * widthScale,
      dividerOffset: _scaleOffset(_base.dividerOffset, widthScale, heightScale),
      dividerSize: Size(
        _base.dividerSize.width * widthScale,
        _base.dividerSize.height,
      ),
      qrCodeScale: _base.qrCodeScale * widthScale,
      qrCodeOffset: _scaleOffset(_base.qrCodeOffset, widthScale, heightScale),
      qrCodeSize: Size(
        _base.qrCodeSize.width * widthScale,
        _base.qrCodeSize.height * widthScale,
      ),
    );
  }

  factory EventBadgeLayoutParams.display416x240() {
    return _scaled(1.0, 1.0);
  }

  factory EventBadgeLayoutParams.display320x240() {
    return _scaled(0.769, 1.0);
  }

  factory EventBadgeLayoutParams.display250x122() {
    return _scaled(0.601, 0.508);
  }

  factory EventBadgeLayoutParams.display296x128() {
    return _scaled(0.712, 0.533);
  }

  factory EventBadgeLayoutParams.display264x176() {
    return _scaled(0.635, 0.733);
  }

  factory EventBadgeLayoutParams.display400x300() {
    return _scaled(0.962, 1.25);
  }

  factory EventBadgeLayoutParams.display800x480() {
    return _scaled(1.923, 2.0);
  }

  factory EventBadgeLayoutParams.display880x528() {
    return _scaled(2.115, 2.2);
  }
}

class EntryPassTagLayoutParams {
  final double profileImageScale;
  final Offset profileImageOffset;
  final double venueNameFontSize;
  final double venueNameScale;
  final Offset venueNameOffset;
  final double textFieldFontSize;
  final double textFieldScale;
  final Map<String, Offset> textOffsets;
  final double qrCodeScale;
  final Offset qrCodeOffset;
  final Size qrCodeSize;

  const EntryPassTagLayoutParams({
    required this.profileImageScale,
    required this.profileImageOffset,
    required this.venueNameFontSize,
    required this.venueNameScale,
    required this.venueNameOffset,
    required this.textFieldFontSize,
    required this.textFieldScale,
    required this.textOffsets,
    required this.qrCodeScale,
    required this.qrCodeOffset,
    required this.qrCodeSize,
  });

  static const EntryPassTagLayoutParams _base = EntryPassTagLayoutParams(
    profileImageScale: 5.0,
    profileImageOffset: Offset(-135, -55),
    venueNameFontSize: 50,
    venueNameScale: 1.0,
    venueNameOffset: Offset(55, -88),
    textFieldFontSize: 16,
    textFieldScale: 0.75,
    textOffsets: {
      'visitorName': Offset(55, -50),
      'passType': Offset(55, -20),
      'validDate': Offset(55, 10),
      'passId': Offset(55, 40),
    },
    qrCodeScale: 5.5,
    qrCodeOffset: Offset(-135, 35),
    qrCodeSize: Size(60, 60),
  );

  static Offset _scaleOffset(
      Offset offset, double widthScale, double heightScale) {
    return Offset(offset.dx * widthScale, offset.dy * heightScale);
  }

  static EntryPassTagLayoutParams _scaled(
      double widthScale, double heightScale) {
    return EntryPassTagLayoutParams(
      profileImageScale: _base.profileImageScale * widthScale,
      profileImageOffset:
          _scaleOffset(_base.profileImageOffset, widthScale, heightScale),
      venueNameFontSize: _base.venueNameFontSize,
      venueNameScale: _base.venueNameScale * widthScale,
      venueNameOffset:
          _scaleOffset(_base.venueNameOffset, widthScale, heightScale),
      textFieldFontSize: _base.textFieldFontSize,
      textFieldScale: _base.textFieldScale * widthScale,
      textOffsets: {
        'visitorName': _scaleOffset(
            _base.textOffsets['visitorName']!, widthScale, heightScale),
        'passType': _scaleOffset(
            _base.textOffsets['passType']!, widthScale, heightScale),
        'validDate': _scaleOffset(
            _base.textOffsets['validDate']!, widthScale, heightScale),
        'passId':
            _scaleOffset(_base.textOffsets['passId']!, widthScale, heightScale),
      },
      qrCodeScale: _base.qrCodeScale * widthScale,
      qrCodeOffset: _scaleOffset(_base.qrCodeOffset, widthScale, heightScale),
      qrCodeSize: Size(
        _base.qrCodeSize.width * widthScale,
        _base.qrCodeSize.height * widthScale,
      ),
    );
  }

  factory EntryPassTagLayoutParams.display416x240() {
    return _scaled(1.0, 1.0);
  }

  factory EntryPassTagLayoutParams.display320x240() {
    return _scaled(0.769, 1.0);
  }

  factory EntryPassTagLayoutParams.display250x122() {
    return _scaled(0.601, 0.508);
  }

  factory EntryPassTagLayoutParams.display296x128() {
    return _scaled(0.712, 0.533);
  }

  factory EntryPassTagLayoutParams.display264x176() {
    return _scaled(0.635, 0.733);
  }

  factory EntryPassTagLayoutParams.display400x300() {
    return _scaled(0.962, 1.25);
  }

  factory EntryPassTagLayoutParams.display800x480() {
    return _scaled(1.923, 2.0);
  }

  factory EntryPassTagLayoutParams.display880x528() {
    return _scaled(2.115, 2.2);
  }
}

class PriceTagLayoutParams {
  final double productImageScale;
  final Offset productImageOffset;
  final double productNameFontSize;
  final double productNameScale;
  final Offset productNameOffset;
  final double productDescriptionFontSize;
  final double productDescriptionScale;
  final Offset productDescriptionOffset;
  final double priceFontSize;
  final double priceScale;
  final Offset priceOffset;
  final double quantityFontSize;
  final double quantityScale;
  final Offset quantityOffset;
  final double barcodeScale;
  final Offset barcodeOffset;
  final Size barcodeSize;

  const PriceTagLayoutParams({
    required this.productImageScale,
    required this.productImageOffset,
    required this.productNameFontSize,
    required this.productNameScale,
    required this.productNameOffset,
    required this.productDescriptionFontSize,
    required this.productDescriptionScale,
    required this.productDescriptionOffset,
    required this.priceFontSize,
    required this.priceScale,
    required this.priceOffset,
    required this.quantityFontSize,
    required this.quantityScale,
    required this.quantityOffset,
    required this.barcodeScale,
    required this.barcodeOffset,
    required this.barcodeSize,
  });

  factory PriceTagLayoutParams.display416x240() {
    return const PriceTagLayoutParams(
      productImageScale: 5.4,
      productImageOffset: Offset(-132, -60),
      productNameFontSize: 50,
      productNameScale: 1,
      productNameOffset: Offset(50, -75),
      productDescriptionFontSize: 16,
      productDescriptionScale: 0.75,
      productDescriptionOffset: Offset(50, -40),
      priceFontSize: 24,
      priceScale: 1.5,
      priceOffset: Offset(120, 45),
      quantityFontSize: 16,
      quantityScale: 0.75,
      quantityOffset: Offset(120, 85),
      barcodeScale: 12.5,
      barcodeOffset: Offset(-68, 45),
      barcodeSize: Size(240, 120),
    );
  }

  factory PriceTagLayoutParams.display320x240() {
    return const PriceTagLayoutParams(
      productImageScale: 5.4,
      productImageOffset: Offset(-132, -60),
      productNameFontSize: 50,
      productNameScale: 1,
      productNameOffset: Offset(50, -75),
      productDescriptionFontSize: 16,
      productDescriptionScale: 0.75,
      productDescriptionOffset: Offset(50, -40),
      priceFontSize: 24,
      priceScale: 1.5,
      priceOffset: Offset(130, 45),
      quantityFontSize: 16,
      quantityScale: 0.75,
      quantityOffset: Offset(130, 85),
      barcodeScale: 13,
      barcodeOffset: Offset(-58, 45),
      barcodeSize: Size(240, 120),
    );
  }

  factory PriceTagLayoutParams.display250x122() {
    return const PriceTagLayoutParams(
      productImageScale: 4,
      productImageOffset: Offset(-132, -60),
      productNameFontSize: 50,
      productNameScale: 1,
      productNameOffset: Offset(50, -75),
      productDescriptionFontSize: 16,
      productDescriptionScale: 0.75,
      productDescriptionOffset: Offset(50, -50),
      priceFontSize: 24,
      priceScale: 1.5,
      priceOffset: Offset(120, 15),
      quantityFontSize: 16,
      quantityScale: 0.75,
      quantityOffset: Offset(120, 55),
      barcodeScale: 12.5,
      barcodeOffset: Offset(-68, 35),
      barcodeSize: Size(240, 120),
    );
  }

  factory PriceTagLayoutParams.display296x128() {
    return const PriceTagLayoutParams(
      productImageScale: 3.5,
      productImageOffset: Offset(-132, -60),
      productNameFontSize: 50,
      productNameScale: 1,
      productNameOffset: Offset(50, -65),
      productDescriptionFontSize: 16,
      productDescriptionScale: 0.75,
      productDescriptionOffset: Offset(50, -45),
      priceFontSize: 24,
      priceScale: 1.5,
      priceOffset: Offset(120, 15),
      quantityFontSize: 16,
      quantityScale: 0.75,
      quantityOffset: Offset(120, 55),
      barcodeScale: 11.5,
      barcodeOffset: Offset(-68, 25),
      barcodeSize: Size(240, 120),
    );
  }

  factory PriceTagLayoutParams.display264x176() {
    return const PriceTagLayoutParams(
      productImageScale: 5.4,
      productImageOffset: Offset(-132, -60),
      productNameFontSize: 50,
      productNameScale: 1,
      productNameOffset: Offset(50, -75),
      productDescriptionFontSize: 16,
      productDescriptionScale: 0.75,
      productDescriptionOffset: Offset(50, -40),
      priceFontSize: 24,
      priceScale: 1.5,
      priceOffset: Offset(130, 45),
      quantityFontSize: 16,
      quantityScale: 0.75,
      quantityOffset: Offset(130, 85),
      barcodeScale: 13,
      barcodeOffset: Offset(-58, 45),
      barcodeSize: Size(240, 120),
    );
  }

  factory PriceTagLayoutParams.display400x300() {
    return const PriceTagLayoutParams(
      productImageScale: 5.4,
      productImageOffset: Offset(-132, -60),
      productNameFontSize: 50,
      productNameScale: 1,
      productNameOffset: Offset(50, -75),
      productDescriptionFontSize: 16,
      productDescriptionScale: 0.75,
      productDescriptionOffset: Offset(50, -40),
      priceFontSize: 24,
      priceScale: 1.5,
      priceOffset: Offset(130, 45),
      quantityFontSize: 16,
      quantityScale: 0.75,
      quantityOffset: Offset(130, 85),
      barcodeScale: 13,
      barcodeOffset: Offset(-58, 45),
      barcodeSize: Size(240, 120),
    );
  }

  factory PriceTagLayoutParams.display800x480() {
    return const PriceTagLayoutParams(
      productImageScale: 5.4,
      productImageOffset: Offset(-132, -60),
      productNameFontSize: 50,
      productNameScale: 1,
      productNameOffset: Offset(50, -75),
      productDescriptionFontSize: 16,
      productDescriptionScale: 0.75,
      productDescriptionOffset: Offset(50, -40),
      priceFontSize: 24,
      priceScale: 1.5,
      priceOffset: Offset(130, 45),
      quantityFontSize: 16,
      quantityScale: 0.75,
      quantityOffset: Offset(130, 85),
      barcodeScale: 13,
      barcodeOffset: Offset(-58, 45),
      barcodeSize: Size(240, 120),
    );
  }

  factory PriceTagLayoutParams.display880x528() {
    return const PriceTagLayoutParams(
      productImageScale: 20,
      productImageOffset: Offset(-165, 310),
      productNameFontSize: 90,
      productNameScale: 4.0,
      productNameOffset: Offset(-200, -200),
      productDescriptionFontSize: 36,
      productDescriptionScale: 1.7,
      productDescriptionOffset: Offset(-200, -140),
      priceFontSize: 50,
      priceScale: 8,
      priceOffset: Offset(145, -280),
      quantityFontSize: 80,
      quantityScale: 2.0,
      quantityOffset: Offset(-100, -240),
      barcodeScale: 28,
      barcodeOffset: Offset(165, 220),
      barcodeSize: Size(440, 220),
    );
  }
}
