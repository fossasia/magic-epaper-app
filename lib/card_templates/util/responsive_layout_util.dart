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
      barcodeScale: 7,
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
      barcodeScale: 7.5,
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
      barcodeScale: 7,
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
      barcodeScale: 6.5,
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
      barcodeScale: 7.5,
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
      barcodeScale: 7.5,
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
      barcodeScale: 7.5,
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
      barcodeScale: 16,
      barcodeOffset: Offset(165, 220),
      barcodeSize: Size(440, 220),
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
    required this.qrCodeScale,
    required this.qrCodeOffset,
    required this.qrCodeSize,
  });

  factory EventBadgeLayoutParams.display416x240() {
    return const EventBadgeLayoutParams(
      profileImageScale: 5.4,
      profileImageOffset: Offset(-132, -60),
      eventNameFontSize: 50,
      eventNameScale: 1.0,
      eventNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'attendeeName': Offset(55, -50),
        'role': Offset(55, -15),
        'organization': Offset(55, 20),
        'ticketId': Offset(55, 55),
      },
      qrCodeScale: 6,
      qrCodeOffset: Offset(-130, 55),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EventBadgeLayoutParams.display320x240() {
    return const EventBadgeLayoutParams(
      profileImageScale: 6,
      profileImageOffset: Offset(-130, -70),
      eventNameFontSize: 50,
      eventNameScale: 1.0,
      eventNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'attendeeName': Offset(55, -50),
        'role': Offset(55, -15),
        'organization': Offset(55, 20),
        'ticketId': Offset(55, 55),
      },
      qrCodeScale: 7,
      qrCodeOffset: Offset(-125, 70),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EventBadgeLayoutParams.display250x122() {
    return const EventBadgeLayoutParams(
      profileImageScale: 4.5,
      profileImageOffset: Offset(-132, -55),
      eventNameFontSize: 50,
      eventNameScale: 1.0,
      eventNameOffset: Offset(55, -75),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'attendeeName': Offset(55, -40),
        'role': Offset(55, -5),
        'organization': Offset(55, 30),
        'ticketId': Offset(55, 65),
      },
      qrCodeScale: 5,
      qrCodeOffset: Offset(-130, 45),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EventBadgeLayoutParams.display296x128() {
    return const EventBadgeLayoutParams(
      profileImageScale: 3.75,
      profileImageOffset: Offset(-145, -45),
      eventNameFontSize: 50,
      eventNameScale: 1.0,
      eventNameOffset: Offset(55, -70),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'attendeeName': Offset(55, -40),
        'role': Offset(55, -5),
        'organization': Offset(55, 30),
        'ticketId': Offset(55, 65),
      },
      qrCodeScale: 5,
      qrCodeOffset: Offset(-138, 35),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EventBadgeLayoutParams.display264x176() {
    return const EventBadgeLayoutParams(
      profileImageScale: 6,
      profileImageOffset: Offset(-130, -70),
      eventNameFontSize: 50,
      eventNameScale: 1.0,
      eventNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'attendeeName': Offset(55, -50),
        'role': Offset(55, -15),
        'organization': Offset(55, 20),
        'ticketId': Offset(55, 55),
      },
      qrCodeScale: 7,
      qrCodeOffset: Offset(-125, 60),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EventBadgeLayoutParams.display400x300() {
    return const EventBadgeLayoutParams(
      profileImageScale: 6,
      profileImageOffset: Offset(-130, -70),
      eventNameFontSize: 50,
      eventNameScale: 1.0,
      eventNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'attendeeName': Offset(55, -50),
        'role': Offset(55, -15),
        'organization': Offset(55, 20),
        'ticketId': Offset(55, 55),
      },
      qrCodeScale: 7,
      qrCodeOffset: Offset(-125, 60),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EventBadgeLayoutParams.display800x480() {
    return const EventBadgeLayoutParams(
      profileImageScale: 5.5,
      profileImageOffset: Offset(-130, -65),
      eventNameFontSize: 50,
      eventNameScale: 1.0,
      eventNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'attendeeName': Offset(55, -50),
        'role': Offset(55, -15),
        'organization': Offset(55, 20),
        'ticketId': Offset(55, 55),
      },
      qrCodeScale: 7,
      qrCodeOffset: Offset(-125, 50),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EventBadgeLayoutParams.display880x528() {
    return const EventBadgeLayoutParams(
      profileImageScale: 5.5,
      profileImageOffset: Offset(-130, -65),
      eventNameFontSize: 50,
      eventNameScale: 1.0,
      eventNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'attendeeName': Offset(55, -50),
        'role': Offset(55, -15),
        'organization': Offset(55, 20),
        'ticketId': Offset(55, 55),
      },
      qrCodeScale: 7,
      qrCodeOffset: Offset(-125, 50),
      qrCodeSize: Size(60, 60),
    );
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

  factory EntryPassTagLayoutParams.display416x240() {
    return const EntryPassTagLayoutParams(
      profileImageScale: 5.4,
      profileImageOffset: Offset(-132, -60),
      venueNameFontSize: 50,
      venueNameScale: 1.0,
      venueNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'visitorName': Offset(55, -50),
        'passType': Offset(55, -15),
        'validDate': Offset(55, 20),
        'passId': Offset(55, 55),
      },
      qrCodeScale: 6,
      qrCodeOffset: Offset(-130, 55),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EntryPassTagLayoutParams.display320x240() {
    return const EntryPassTagLayoutParams(
      profileImageScale: 6,
      profileImageOffset: Offset(-130, -70),
      venueNameFontSize: 50,
      venueNameScale: 1.0,
      venueNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'visitorName': Offset(55, -50),
        'passType': Offset(55, -15),
        'validDate': Offset(55, 20),
        'passId': Offset(55, 55),
      },
      qrCodeScale: 7,
      qrCodeOffset: Offset(-125, 70),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EntryPassTagLayoutParams.display250x122() {
    return const EntryPassTagLayoutParams(
      profileImageScale: 4.5,
      profileImageOffset: Offset(-132, -55),
      venueNameFontSize: 50,
      venueNameScale: 1.0,
      venueNameOffset: Offset(55, -75),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'visitorName': Offset(55, -40),
        'passType': Offset(55, -5),
        'validDate': Offset(55, 30),
        'passId': Offset(55, 65),
      },
      qrCodeScale: 5,
      qrCodeOffset: Offset(-130, 45),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EntryPassTagLayoutParams.display296x128() {
    return const EntryPassTagLayoutParams(
      profileImageScale: 3.75,
      profileImageOffset: Offset(-145, -45),
      venueNameFontSize: 50,
      venueNameScale: 1.0,
      venueNameOffset: Offset(55, -70),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'visitorName': Offset(55, -40),
        'passType': Offset(55, -5),
        'validDate': Offset(55, 30),
        'passId': Offset(55, 65),
      },
      qrCodeScale: 5,
      qrCodeOffset: Offset(-138, 35),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EntryPassTagLayoutParams.display264x176() {
    return const EntryPassTagLayoutParams(
      profileImageScale: 6,
      profileImageOffset: Offset(-130, -70),
      venueNameFontSize: 50,
      venueNameScale: 1.0,
      venueNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'visitorName': Offset(55, -50),
        'passType': Offset(55, -15),
        'validDate': Offset(55, 20),
        'passId': Offset(55, 55),
      },
      qrCodeScale: 7,
      qrCodeOffset: Offset(-125, 60),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EntryPassTagLayoutParams.display400x300() {
    return const EntryPassTagLayoutParams(
      profileImageScale: 6,
      profileImageOffset: Offset(-130, -70),
      venueNameFontSize: 50,
      venueNameScale: 1.0,
      venueNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'visitorName': Offset(55, -50),
        'passType': Offset(55, -15),
        'validDate': Offset(55, 20),
        'passId': Offset(55, 55),
      },
      qrCodeScale: 7,
      qrCodeOffset: Offset(-125, 60),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EntryPassTagLayoutParams.display800x480() {
    return const EntryPassTagLayoutParams(
      profileImageScale: 5.5,
      profileImageOffset: Offset(-130, -65),
      venueNameFontSize: 50,
      venueNameScale: 1.0,
      venueNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'visitorName': Offset(55, -50),
        'passType': Offset(55, -15),
        'validDate': Offset(55, 20),
        'passId': Offset(55, 55),
      },
      qrCodeScale: 7,
      qrCodeOffset: Offset(-125, 50),
      qrCodeSize: Size(60, 60),
    );
  }

  factory EntryPassTagLayoutParams.display880x528() {
    return const EntryPassTagLayoutParams(
      profileImageScale: 5.5,
      profileImageOffset: Offset(-130, -65),
      venueNameFontSize: 50,
      venueNameScale: 1.0,
      venueNameOffset: Offset(55, -92),
      textFieldFontSize: 16,
      textFieldScale: 0.75,
      textOffsets: {
        'visitorName': Offset(55, -50),
        'passType': Offset(55, -15),
        'validDate': Offset(55, 20),
        'passId': Offset(55, 55),
      },
      qrCodeScale: 7,
      qrCodeOffset: Offset(-125, 50),
      qrCodeSize: Size(60, 60),
    );
  }
}
