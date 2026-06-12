import 'dart:io';

class EventBadgeModel {
  final String eventName;
  final String attendeeName;
  final String role;
  final String organization;
  final String ticketId;
  final String qrData;
  final File? profileImage;

  EventBadgeModel({
    required this.eventName,
    required this.attendeeName,
    required this.role,
    required this.organization,
    required this.ticketId,
    required this.qrData,
    this.profileImage,
  });
}
