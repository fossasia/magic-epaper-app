import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/pro_image_editor/features/movable_background_image.dart';
import 'package:magicepaperapp/card_templates/price_tag_card_widget.dart';
import 'package:magicepaperapp/card_templates/price_tag_model.dart';
import 'package:magicepaperapp/util/template_util.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

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
  bool _isGenerating = false;

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

    setState(() {
      _isGenerating = true;
    });

    try {
      final List<LayerSpec> layers = [];

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
            style: const TextStyle(color: Colors.black),
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
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      index: -1,
      toolbarHeight: 85,
      titleWidget: Padding(
        padding: const EdgeInsets.fromLTRB(5, 16, 16, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalizations.priceTagGenerator,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              appLocalizations.priceTagDescription,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 14, 16.0, 16.0),
          child: Column(
            children: [
              PriceTagCardWidget(data: _data),
              const SizedBox(height: 20),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 20),
              Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.local_offer_outlined,
                                color: colorAccent, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              appLocalizations.productDetails,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorBlack,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildProductImageSection(),
                        const SizedBox(height: 20),
                        _buildTextFormField(
                          controller: _productNameController,
                          label: appLocalizations.productName,
                          hint: appLocalizations.productNameHint,
                          icon: Icons.inventory_2_outlined,
                          validator: (value) => value?.isEmpty ?? true
                              ? appLocalizations.pleaseEnterProductName
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildTextFormField(
                                controller: _currencyController,
                                label: appLocalizations.currency,
                                hint: appLocalizations.currencyHint,
                                icon: Icons.currency_exchange_outlined,
                                validator: (value) => value?.isEmpty ?? true
                                    ? appLocalizations.required
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: _buildTextFormField(
                                controller: _priceController,
                                label: appLocalizations.price,
                                hint: appLocalizations.priceHint,
                                icon: Icons.attach_money_outlined,
                                keyboardType: TextInputType.number,
                                validator: (value) => value?.isEmpty ?? true
                                    ? appLocalizations.pleaseEnterPrice
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _quantityController,
                          label: appLocalizations.quantitySize,
                          hint: appLocalizations.quantitySizeHint,
                          icon: Icons.straighten_outlined,
                          validator: (value) => value?.isEmpty ?? true
                              ? appLocalizations.pleaseEnterQuantitySize
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _barcodeController,
                          label: appLocalizations.barcodeData,
                          hint: appLocalizations.barcodeDataHint,
                          icon: Icons.qr_code_scanner_outlined,
                          validator: (value) => value?.isEmpty ?? true
                              ? appLocalizations.pleaseEnterBarcodeData
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isGenerating ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        colorPrimary.withAlpha(_isGenerating ? 125 : 255),
                    foregroundColor:
                        Colors.white.withAlpha(_isGenerating ? 178 : 255),
                    elevation: _isGenerating ? 0 : 2,
                    shadowColor: colorPrimary.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: _isGenerating
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              appLocalizations.generatingPriceTag,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.local_offer, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              appLocalizations.generatePriceTag,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: colorPrimary,
          selectionColor: colorPrimary.withOpacity(0.2),
          selectionHandleColor: colorPrimary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: colorPrimary,
          hoverColor: colorPrimary.withOpacity(0.1),
        ),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(
          fontSize: 16,
          color: colorBlack,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: colorPrimary,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: colorAccent, size: 20),
          labelStyle: TextStyle(
            color: colorBlack.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          floatingLabelStyle: const TextStyle(
            color: colorPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: colorPrimary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }

  Widget _buildProductImageSection() {
    return Card(
      color: Colors.grey.shade50,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.image_outlined, color: colorAccent, size: 18),
                const SizedBox(width: 8),
                Text(
                  appLocalizations.productImageIn,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorBlack,
                  ),
                ),
                const Spacer(),
                if (_productImage != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      appLocalizations.selected,
                      style: const TextStyle(
                        fontSize: 12,
                        color: colorPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickProductImage,
              borderRadius: BorderRadius.circular(8),
              splashColor: colorAccent.withOpacity(0.1),
              highlightColor: colorAccent.withOpacity(0.05),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _productImage != null
                        ? colorPrimary
                        : Colors.grey.shade300,
                    width: _productImage != null ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _productImage != null
                              ? colorPrimary.withOpacity(0.3)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: _productImage != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: Image.file(
                                    _productImage!,
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: colorPrimary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(2),
                                    child: const Icon(
                                      Icons.check,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Icon(
                              Icons.add_photo_alternate,
                              size: 28,
                              color: Colors.grey.shade400,
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _productImage != null
                                ? appLocalizations.productImageSelected
                                : appLocalizations.selectProductImage,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _productImage != null
                                  ? colorPrimary
                                  : colorBlack,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _productImage != null
                                ? appLocalizations.tapToChangeImage
                                : appLocalizations.chooseImageFromGallery,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _productImage != null
                            ? colorPrimary.withOpacity(0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        _productImage != null
                            ? Icons.edit
                            : Icons.photo_library,
                        color: _productImage != null
                            ? colorPrimary
                            : Colors.grey.shade400,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
