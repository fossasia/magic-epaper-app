import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magic_epaper_app/card_templates/employee_id_card_widget.dart';
import 'package:magic_epaper_app/card_templates/employee_id_model.dart';
import 'package:magic_epaper_app/pro_image_editor/features/movable_background_image.dart';
import 'package:barcode_widget/barcode_widget.dart';

class EmployeeIdForm extends StatefulWidget {
  final int width;
  final int height;

  const EmployeeIdForm({super.key, required this.width, required this.height});

  @override
  State<EmployeeIdForm> createState() => _EmployeeIdFormState();
}

class _EmployeeIdFormState extends State<EmployeeIdForm> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _divisionController = TextEditingController();
  final _positionController = TextEditingController();
  final _qrDataController = TextEditingController();

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  late EmployeeIdModel _employeeData;

  @override
  void initState() {
    super.initState();
    _employeeData = EmployeeIdModel(
      companyName: '',
      name: '',
      idNumber: '',
      division: '',
      position: '',
      qrData: '',
    );

    _companyNameController.addListener(_updatePreview);
    _nameController.addListener(_updatePreview);
    _idNumberController.addListener(_updatePreview);
    _divisionController.addListener(_updatePreview);
    _positionController.addListener(_updatePreview);
    _qrDataController.addListener(_updatePreview);
  }

  @override
  void dispose() {
    _companyNameController.removeListener(_updatePreview);
    _nameController.removeListener(_updatePreview);
    _idNumberController.removeListener(_updatePreview);
    _divisionController.removeListener(_updatePreview);
    _positionController.removeListener(_updatePreview);
    _qrDataController.removeListener(_updatePreview);

    _companyNameController.dispose();
    _nameController.dispose();
    _idNumberController.dispose();
    _divisionController.dispose();
    _positionController.dispose();
    _qrDataController.dispose();
    super.dispose();
  }

  void _updatePreview() {
    setState(() {
      _employeeData = EmployeeIdModel(
        companyName: _companyNameController.text,
        name: _nameController.text,
        idNumber: _idNumberController.text,
        division: _divisionController.text,
        position: _positionController.text,
        qrData: _qrDataController.text,
        profileImage: _profileImage,
      );
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _updatePreview();
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create a list of LayerSpec objects for each component of the card.
      final List<LayerSpec> layers = [];

      // Company Name Layer (top)
      if (_employeeData.companyName.isNotEmpty) {
        layers.add(LayerSpec(
          widget: Text(
            _employeeData.companyName,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          offset: const Offset(0, -210),
          scale: 10,
        ));
      }

      // Profile Image Layer
      if (_profileImage != null) {
        layers.add(LayerSpec(
          widget: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.file(_profileImage!,
                width: 200, height: 200, fit: BoxFit.cover),
          ),
          offset: const Offset(0, -205),
          scale: 10,
        ));
      }

      if (_employeeData.companyName.isNotEmpty) {
        layers.add(LayerSpec(
          widget: Text(
            _employeeData.companyName,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          offset: const Offset(0, -80),
          scale: 10,
        ));
      }

      // Text Layers
      layers.add(LayerSpec(
        widget: Text(
          'Name: ${_employeeData.name}',
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        offset: const Offset(0, -30),
        scale: 10,
      ));

      layers.add(LayerSpec(
        widget: Text(
          'Position: ${_employeeData.position}',
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        offset: const Offset(0, 0),
        scale: 10,
      ));

      layers.add(LayerSpec(
        widget: Text(
          'Division: ${_employeeData.division}',
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        offset: const Offset(0, 35),
        scale: 12,
      ));

      layers.add(LayerSpec(
        widget: Text(
          'ID: ${_employeeData.idNumber}',
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        offset: const Offset(0, 70),
        scale: 5,
      ));

      // QR Code Layer (bottom, only if qrData is not empty)
      if (_employeeData.qrData.isNotEmpty) {
        layers.add(LayerSpec(
          widget: BarcodeWidget(
            barcode: Barcode.qrCode(),
            data: _employeeData.qrData,
            width: 60,
            height: 60,
          ),
          offset: const Offset(0, 170),
          scale: 8,
        ));
      }

      // Pop the navigation stack and return the list of layers.
      Navigator.of(context).pop(layers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee ID Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            EmployeeIdCardWidget(data: _employeeData),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _companyNameController,
                    decoration:
                        const InputDecoration(labelText: 'Company Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a company name' : null,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a name' : null,
                  ),
                  TextFormField(
                    controller: _idNumberController,
                    decoration: const InputDecoration(labelText: 'ID Number'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter an ID number' : null,
                  ),
                  TextFormField(
                    controller: _divisionController,
                    decoration: const InputDecoration(labelText: 'Division'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a division' : null,
                  ),
                  TextFormField(
                    controller: _positionController,
                    decoration: const InputDecoration(labelText: 'Position'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a position' : null,
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('Select Profile Photo'),
                  ),
                  TextFormField(
                    controller: _qrDataController,
                    decoration:
                        const InputDecoration(labelText: 'QR Code Data'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter QR code data' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Generate ID Card'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
