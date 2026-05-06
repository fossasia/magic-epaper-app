import 'dart:io';

class EventBadgeModel {
  final String eventName;
  final String attendeeName;
  final String role;
  final String organization;
  final String qrData;
  final String ticketId;
  final File? profileImage;

  EventBadgeModel({
    required this.eventName,
    required this.attendeeName,
    required this.role,
    required this.organization,
    required this.qrData,
    required this.ticketId,
    this.profileImage,
  });
}
