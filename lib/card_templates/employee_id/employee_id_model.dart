import 'dart:io';

class EmployeeIdModel {
  final String companyName;
  final String name;
  final String idNumber;
  final String division;
  final String position;
  final String qrData;
  final File? profileImage;

  EmployeeIdModel({
    required this.companyName,
    required this.name,
    required this.idNumber,
    required this.division,
    required this.position,
    required this.qrData,
    this.profileImage,
  });
}
