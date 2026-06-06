import 'dart:io';

class EntryPassTagModel {
  final String venueName;
  final String visitorName;
  final String passType;
  final String validDate;
  final String passId;
  final String qrData;
  final File? profileImage;

  EntryPassTagModel({
    required this.venueName,
    required this.visitorName,
    required this.passType,
    required this.validDate,
    required this.passId,
    required this.qrData,
    this.profileImage,
  });
}
