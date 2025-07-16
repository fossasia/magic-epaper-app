import 'package:flutter/material.dart';
import 'package:magic_epaper_app/constants/string_constants.dart';
import 'package:magic_epaper_app/employee_id_generator/controller/employee_id_controller.dart';
import 'package:magic_epaper_app/employee_id_generator/widgets/employee_details_form/employee_details_form.dart';
import 'package:magic_epaper_app/employee_id_generator/widgets/generate_button.dart';
import 'package:magic_epaper_app/employee_id_generator/widgets/id_card_preview/id_card_preview.dart';
import 'package:magic_epaper_app/util/epd/epd.dart';
import 'package:magic_epaper_app/constants/color_constants.dart';

class EmployeeIdGeneratorScreen extends StatefulWidget {
  final Epd epd;
  const EmployeeIdGeneratorScreen({super.key, required this.epd});

  @override
  State<EmployeeIdGeneratorScreen> createState() =>
      _EmployeeIdGeneratorScreenState();
}

class _EmployeeIdGeneratorScreenState extends State<EmployeeIdGeneratorScreen>
    with SingleTickerProviderStateMixin {
  late final EmployeeIdController _controller;
  final _formKey = GlobalKey<FormState>();
  final _cardKey = GlobalKey();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = EmployeeIdController();
    _controller.addListener(_onControllerChanged);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  Future<void> _handleGenerateIdCard() async {
    final idCardBytes = await _controller.generateIdCard(
      context,
      _formKey,
      _cardKey,
      widget.epd.height,
      widget.epd.width,
    );
    if (idCardBytes != null) {
      Navigator.pop(context, idCardBytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: colorAccent,
        elevation: 0,
        title: const Text(
          StringConstants.employeeIdGeneratorTitle,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GenerateButton(
              isGenerating: _controller.isGenerating,
              onPressed: _handleGenerateIdCard,
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: widget.epd.height.toDouble(),
                        maxHeight: widget.epd.width.toDouble(),
                      ),
                      child: RepaintBoundary(
                        key: _cardKey,
                        child: IdCardPreview(controller: _controller),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[50],
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: EmployeeDetailsForm(
                          controller: _controller,
                          formKey: _formKey,
                          onChanged: _onControllerChanged,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
