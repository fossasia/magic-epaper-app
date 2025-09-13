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
