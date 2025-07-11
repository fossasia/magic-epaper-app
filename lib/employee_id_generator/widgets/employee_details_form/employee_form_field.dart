import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magic_epaper_app/constants/color_constants.dart';
import 'package:magic_epaper_app/constants/string_constants.dart';

class EmployeeFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final VoidCallback? onChanged;
  final ValidationType validationType;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const EmployeeFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.onChanged,
    this.validationType = ValidationType.required,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  State<EmployeeFormField> createState() => _EmployeeFormFieldState();
}

class _EmployeeFormFieldState extends State<EmployeeFormField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  String? _validateInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      if (widget.validationType != ValidationType.none) {
        return '${StringConstants.pleaseEnter} ${widget.label.toLowerCase()}';
      }
      return null;
    }

    switch (widget.validationType) {
      case ValidationType.email:
        return _validateEmail(value.trim());
      case ValidationType.phone:
        return _validatePhone(value.trim());
      case ValidationType.required:
      case ValidationType.none:
        return null;
    }
  }

  String? _validateEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return StringConstants.validEmailError;
    }
    return null;
  }

  String? _validatePhone(String phone) {
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length == 10 &&
        RegExp(r'^[6-9]\d{9}$').hasMatch(digitsOnly)) {
      return null;
    }

    if (digitsOnly.length >= 10 && digitsOnly.length <= 15) {
      return null;
    }

    return StringConstants.validPhoneError;
  }

  TextInputType _getKeyboardType() {
    if (widget.keyboardType != null) {
      return widget.keyboardType!;
    }

    switch (widget.validationType) {
      case ValidationType.email:
        return TextInputType.emailAddress;
      case ValidationType.phone:
        return TextInputType.phone;
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    if (widget.inputFormatters != null) {
      return widget.inputFormatters;
    }

    switch (widget.validationType) {
      case ValidationType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ];
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: _getKeyboardType(),
              inputFormatters: _getInputFormatters(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorBlack,
              ),
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: TextStyle(
                  color: _isFocused ? colorAccent : Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    widget.icon,
                    color: _isFocused ? colorAccent : Colors.grey[500],
                    size: 20,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: colorAccent,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              validator: _validateInput,
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum ValidationType {
  none,
  email,
  phone,
  required,
}
