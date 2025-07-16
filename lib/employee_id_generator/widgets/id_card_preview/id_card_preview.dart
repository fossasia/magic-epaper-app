import 'package:flutter/material.dart';
import 'package:magic_epaper_app/constants/color_constants.dart';
import 'package:magic_epaper_app/constants/string_constants.dart';
import 'package:magic_epaper_app/employee_id_generator/controller/employee_id_controller.dart';
import 'package:magic_epaper_app/employee_id_generator/widgets/id_card_preview/card_details_row.dart';

class IdCardPreview extends StatelessWidget {
  final EmployeeIdController controller;

  const IdCardPreview({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: colorAccent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: colorAccent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
            ),
            child: Column(
              children: [
                Text(
                  controller.companyController.text.isNotEmpty
                      ? controller.companyController.text
                      : StringConstants.companyNamePlaceholder,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  StringConstants.employeeIdCard,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: controller.profileImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              controller.profileImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.person,
                            size: 40, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CardDetailRow(
                          label: StringConstants.nameLabel,
                          value: controller.nameController.text,
                        ),
                        CardDetailRow(
                          label: StringConstants.idLabel,
                          value: controller.idController.text,
                        ),
                        CardDetailRow(
                          label: StringConstants.designationLabel,
                          value: controller.designationController.text,
                        ),
                        CardDetailRow(
                          label: StringConstants.departmentLabel,
                          value: controller.departmentController.text,
                        ),
                        CardDetailRow(
                          label: StringConstants.emailLabel,
                          value: controller.emailController.text,
                        ),
                        CardDetailRow(
                          label: StringConstants.phoneLabel,
                          value: controller.phoneController.text,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
