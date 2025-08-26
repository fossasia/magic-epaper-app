import 'package:flutter/material.dart';
import 'package:magicepaperapp/ndef_screen/models/v_card_data.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

class VCardFormWidget extends StatefulWidget {
  final VCardData? initialData;
  final Function(VCardData) onVCardChanged;

  const VCardFormWidget({
    super.key,
    this.initialData,
    required this.onVCardChanged,
  });

  @override
  State<VCardFormWidget> createState() => _VCardFormWidgetState();
}

class _VCardFormWidgetState extends State<VCardFormWidget> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _organizationController;
  late TextEditingController _titleController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _emailController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _zipCodeController;
  late TextEditingController _countryController;
  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.initialData?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: widget.initialData?.lastName ?? '');
    _organizationController =
        TextEditingController(text: widget.initialData?.organization ?? '');
    _titleController =
        TextEditingController(text: widget.initialData?.title ?? '');
    _mobileNumberController =
        TextEditingController(text: widget.initialData?.mobileNumber ?? '');
    _emailController =
        TextEditingController(text: widget.initialData?.emailAddress ?? '');
    _streetController =
        TextEditingController(text: widget.initialData?.street ?? '');
    _cityController =
        TextEditingController(text: widget.initialData?.city ?? '');
    _zipCodeController =
        TextEditingController(text: widget.initialData?.zipCode ?? '');
    _countryController =
        TextEditingController(text: widget.initialData?.country ?? '');
    _websiteController =
        TextEditingController(text: widget.initialData?.website ?? '');

    _firstNameController.addListener(_notifyParent);
    _lastNameController.addListener(_notifyParent);
    _organizationController.addListener(_notifyParent);
    _titleController.addListener(_notifyParent);
    _mobileNumberController.addListener(_notifyParent);
    _emailController.addListener(_notifyParent);
    _streetController.addListener(_notifyParent);
    _cityController.addListener(_notifyParent);
    _zipCodeController.addListener(_notifyParent);
    _countryController.addListener(_notifyParent);
    _websiteController.addListener(_notifyParent);
  }

  void _notifyParent() {
    widget.onVCardChanged(VCardData(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      organization: _organizationController.text,
      title: _titleController.text,
      mobileNumber: _mobileNumberController.text,
      emailAddress: _emailController.text,
      street: _streetController.text,
      city: _cityController.text,
      zipCode: _zipCodeController.text,
      country: _countryController.text,
      website: _websiteController.text,
    ));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _organizationController.dispose();
    _titleController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: appLocalizations.firstName,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: appLocalizations.lastName,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _organizationController,
                  decoration: InputDecoration(
                    labelText: appLocalizations.organization,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.business),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: appLocalizations.title,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _mobileNumberController,
            decoration: InputDecoration(
              labelText: appLocalizations.mobileNumber,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: appLocalizations.emailAddress,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _streetController,
            decoration: InputDecoration(
              labelText: appLocalizations.streetAddress,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.home),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: appLocalizations.city,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _zipCodeController,
                  decoration: InputDecoration(
                    labelText: appLocalizations.zipCode,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(
                    labelText: appLocalizations.country,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _websiteController,
                  decoration: InputDecoration(
                    labelText: appLocalizations.website,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.web),
                  ),
                  keyboardType: TextInputType.url,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
