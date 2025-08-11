import 'package:flutter/material.dart';

import 'package:magicepaperapp/ndef_screen/models/v_card_data.dart';

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
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
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
                  decoration: const InputDecoration(
                    labelText: 'Organization',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _mobileNumberController,
            decoration: const InputDecoration(
              labelText: 'Mobile Number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _streetController,
            decoration: const InputDecoration(
              labelText: 'Street Address',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.home),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _zipCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Zip Code',
                    border: OutlineInputBorder(),
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
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _websiteController,
                  decoration: const InputDecoration(
                    labelText: 'Website',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.web),
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
