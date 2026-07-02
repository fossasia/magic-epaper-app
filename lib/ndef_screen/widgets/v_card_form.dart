import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/ndef_screen/models/v_card_data.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.contact_page, color: colorAccent, size: 22),
            const SizedBox(width: Dimens.spacingS),
            Text(
              appLocalizations.vCardContactInformation,
              style: const TextStyle(
                fontSize: Dimens.fontSizeL,
                fontWeight: FontWeight.w600,
                color: colorBlack,
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimens.spacingL),
        _buildSectionContainer(
          title: appLocalizations.personalInformation,
          icon: Icons.person,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _firstNameController,
                    labelText: appLocalizations.firstName,
                    prefixIcon: Icons.person_outline,
                  ),
                ),
                const SizedBox(width: Dimens.spacingM),
                Expanded(
                  child: _buildTextField(
                    controller: _lastNameController,
                    labelText: appLocalizations.lastName,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: Dimens.spacingL),
        _buildSectionContainer(
          title: appLocalizations.workInformation,
          icon: Icons.work,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _organizationController,
                    labelText: appLocalizations.organization,
                    prefixIcon: Icons.business,
                  ),
                ),
                const SizedBox(width: Dimens.spacingM),
                Expanded(
                  child: _buildTextField(
                    controller: _titleController,
                    labelText: appLocalizations.jobTitle,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: Dimens.spacingL),
        _buildSectionContainer(
          title: appLocalizations.contactInformation,
          icon: Icons.contact_phone,
          children: [
            _buildTextField(
              controller: _mobileNumberController,
              labelText: appLocalizations.mobileNumber,
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: Dimens.spacingM),
            _buildTextField(
              controller: _emailController,
              labelText: appLocalizations.emailAddress,
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: Dimens.spacingM),
            _buildTextField(
              controller: _websiteController,
              labelText: appLocalizations.website,
              prefixIcon: Icons.web,
              keyboardType: TextInputType.url,
            ),
          ],
        ),
        const SizedBox(height: Dimens.spacingL),
        _buildSectionContainer(
          title: appLocalizations.addressInformation,
          icon: Icons.location_on,
          children: [
            _buildTextField(
              controller: _streetController,
              labelText: appLocalizations.streetAddress,
              prefixIcon: Icons.home,
            ),
            const SizedBox(height: Dimens.spacingM),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _cityController,
                    labelText: appLocalizations.city,
                  ),
                ),
                const SizedBox(width: Dimens.spacingM),
                Expanded(
                  child: _buildTextField(
                    controller: _zipCodeController,
                    labelText: appLocalizations.zipCode,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.spacingM),
            _buildTextField(
              controller: _countryController,
              labelText: appLocalizations.country,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionContainer({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(Dimens.spacingL),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(Dimens.radiusL),
        border: Border.all(color: mdGrey400.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: colorAccent),
              const SizedBox(width: Dimens.spacingS),
              Text(
                title,
                style: const TextStyle(
                  fontSize: Dimens.fontSizeM,
                  fontWeight: FontWeight.w600,
                  color: colorBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.spacingM),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    IconData? prefixIcon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: Dimens.fontSizeM),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: Dimens.fontSizeM,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: colorAccent, size: Dimens.iconSizeM)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusM),
          borderSide: const BorderSide(color: mdGrey400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusM),
          borderSide: BorderSide(color: mdGrey400.withValues(alpha: 0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusM),
          borderSide: const BorderSide(color: colorAccent, width: 2),
        ),
        filled: true,
        fillColor: colorWhite,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: Dimens.spacingL, vertical: Dimens.spacingM),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
