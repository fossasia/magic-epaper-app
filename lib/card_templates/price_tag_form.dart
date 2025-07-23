import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:magic_epaper_app/constants/color_constants.dart';
import 'package:magic_epaper_app/pro_image_editor/features/movable_background_image.dart';
import 'package:magic_epaper_app/card_templates/price_tag_card_widget.dart';
import 'package:magic_epaper_app/card_templates/price_tag_model.dart';
import 'package:magic_epaper_app/util/template_util.dart';

class PriceTagForm extends StatefulWidget {
  final int width;
  final int height;

  const PriceTagForm({super.key, required this.width, required this.height});

  @override
  State<PriceTagForm> createState() => _PriceTagFormState();
}

class _PriceTagFormState extends State<PriceTagForm> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _currencyController = TextEditingController();
  final _quantityController = TextEditingController();
  final _barcodeController = TextEditingController();

  File? _productImage;
  final ImagePicker _picker = ImagePicker();

  late PriceTagModel _data;

  @override
  void initState() {
    super.initState();
    _data = PriceTagModel(
      productName: '',
      price: '',
      currency: '',
      quantity: '',
      barcodeData: '',
    );

    _productNameController.addListener(_updatePreview);
    _priceController.addListener(_updatePreview);
    _currencyController.addListener(_updatePreview);
    _quantityController.addListener(_updatePreview);
    _barcodeController.addListener(_updatePreview);
  }

  @override
  void dispose() {
    _productNameController.removeListener(_updatePreview);
    _priceController.removeListener(_updatePreview);
    _currencyController.removeListener(_updatePreview);
    _quantityController.removeListener(_updatePreview);
    _barcodeController.removeListener(_updatePreview);

    _productNameController.dispose();
    _priceController.dispose();
    _currencyController.dispose();
    _quantityController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _updatePreview() {
    setState(() {
      _data = PriceTagModel(
        productName: _productNameController.text,
        price: _priceController.text,
        currency: _currencyController.text,
        quantity: _quantityController.text,
        barcodeData: _barcodeController.text,
        productImage: _productImage,
      );
    });
  }

  Future<void> _pickProductImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _productImage = File(picked.path);
        _updatePreview();
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() != true) return;

    final List<LayerSpec> layers = [];

    // Product image layer
    if (_productImage != null) {
      layers.add(LayerSpec.widget(
        widget: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(_productImage!,
              width: 200, height: 160, fit: BoxFit.cover),
        ),
        offset: const Offset(-90, 160),
        scale: 10,
        rotation: -1.57,
      ));
    }

    // Product name (max 2 lines) - at center
    if (_data.productName.isNotEmpty) {
      layers.add(LayerSpec.text(
        text: _data.productName,
        textStyle: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        textColor: Colors.black,
        textAlign: TextAlign.center,
        offset: const Offset(-100, -100),
        scale: 2,
        rotation: -1.57,
      ));
    }

    // Price line
    if (_data.price.isNotEmpty || _data.currency.isNotEmpty) {
      layers.add(LayerSpec.text(
        text: '${_data.currency} ${_data.price}',
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        textColor: Colors.red,
        textAlign: TextAlign.center,
        offset: const Offset(80, -140),
        scale: 4,
        rotation: -1.57,
      ));
    }

    // Quantity
    if (_data.quantity.isNotEmpty) {
      layers.add(LayerSpec.text(
        text: _data.quantity,
        textStyle: const TextStyle(fontSize: 40),
        backgroundColor: Colors.white,
        textColor: Colors.black,
        textAlign: TextAlign.center,
        offset: const Offset(-50, -120),
        scale: 1,
        rotation: -1.57,
      ));
    }

    if (_data.barcodeData.isNotEmpty) {
      layers.add(LayerSpec.widget(
        widget: BarcodeWidget(
          padding: const EdgeInsets.all(10),
          backgroundColor: colorWhite,
          barcode: Barcode.code128(),
          data: _data.barcodeData,
          width: 240,
          height: 120,
        ),
        offset: const Offset(90, 120),
        scale: 15,
        rotation: -1.57,
      ));
    }

    final Uint8List? bytes = await Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(
        builder: (context) => MovableBackgroundImageExample(
          width: widget.width,
          height: widget.height,
          initialLayers: layers,
        ),
      ),
    );

    if (bytes != null) {
      Navigator.of(context)
        ..pop()
        ..pop(bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Price Tag Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PriceTagCardWidget(data: _data),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _productNameController,
                    decoration:
                        const InputDecoration(labelText: 'Product Name'),
                    validator: (val) =>
                        val!.isEmpty ? 'Enter product name' : null,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _currencyController,
                          decoration:
                              const InputDecoration(labelText: 'Currency'),
                          validator: (val) => val!.isEmpty ? 'Currency' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                          validator: (val) => val!.isEmpty ? 'Price' : null,
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                        labelText: 'Quantity (e.g. 750 ml)'),
                    validator: (val) => val!.isEmpty ? 'Quantity' : null,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _pickProductImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Select Product Image'),
                  ),
                  TextFormField(
                    controller: _barcodeController,
                    decoration:
                        const InputDecoration(labelText: 'Barcode Data'),
                    validator: (val) => val!.isEmpty ? 'Barcode data' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Generate Price Tag'),
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
