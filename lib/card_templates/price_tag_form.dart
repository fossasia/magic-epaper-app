import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:magicepaperapp/card_templates/util/image_picker_util.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/native_canvas/native_canvas_editor.dart';
import 'package:magicepaperapp/card_templates/price_tag_card_widget.dart';
import 'package:magicepaperapp/card_templates/price_tag_model.dart';
import 'package:magicepaperapp/util/page_route_util.dart';
import 'package:magicepaperapp/util/template_util.dart';
import 'package:magicepaperapp/card_templates/util/responsive_layout_util.dart';
import 'package:magicepaperapp/card_templates/util/barcode_scanner_util.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

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
  final _productDescriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _currencyController = TextEditingController();
  final _quantityController = TextEditingController();
  final _barcodeController = TextEditingController();

  final Map<String, FocusNode> _fieldFocusNodes = {
    'productName': FocusNode(),
    'productDescription': FocusNode(),
    'price': FocusNode(),
    'quantity': FocusNode(),
    'barcode': FocusNode(),
  };

  File? _productImage;
  Currency? _selectedCurrency;
  bool _isGenerating = false;

  late PriceTagModel _data;

  @override
  void initState() {
    super.initState();
    _data = PriceTagModel(
      productName: '',
      productDescription: '',
      price: '',
      currency: '',
      quantity: '',
      barcodeData: '',
    );

    _productNameController.addListener(_updatePreview);
    _productDescriptionController.addListener(_updatePreview);
    _priceController.addListener(_updatePreview);
    _currencyController.addListener(_updatePreview);
    _quantityController.addListener(_updatePreview);
    _barcodeController.addListener(_updatePreview);
  }

  @override
  void dispose() {
    _productNameController.removeListener(_updatePreview);
    _productDescriptionController.removeListener(_updatePreview);
    _priceController.removeListener(_updatePreview);
    _currencyController.removeListener(_updatePreview);
    _quantityController.removeListener(_updatePreview);
    _barcodeController.removeListener(_updatePreview);

    _productNameController.dispose();
    _productDescriptionController.dispose();
    _priceController.dispose();
    _currencyController.dispose();
    _quantityController.dispose();
    _barcodeController.dispose();

    for (final node in _fieldFocusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _updatePreview() {
    setState(() {
      _data = PriceTagModel(
        productName: _productNameController.text,
        productDescription: _productDescriptionController.text,
        price: _priceController.text,
        currency: _selectedCurrency?.symbol ?? '',
        quantity: _quantityController.text,
        barcodeData: _barcodeController.text,
        productImage: _productImage,
      );
    });
  }

  Future<void> _pickProductImage() async {
    final picked = await pickAndEditImage(context);
    if (picked != null && mounted) {
      _productImage = picked;
      _updatePreview();
    }
  }

  void _openCurrencyPicker() {
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      onSelect: (Currency currency) {
        _selectedCurrency = currency;
        _currencyController.text = '${currency.symbol}  ${currency.code}';
      },
    );
  }

  void _handleEditRequest(String elementId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      if (elementId == 'productImage') {
        _pickProductImage();
        return;
      }
      _fieldFocusNodes[elementId]?.requestFocus();
    });
  }

  Future<void> _scanBarcode() async {
    final code = await scanCode(context);
    if (!mounted) return;
    if (code != null && code.isNotEmpty) {
      _barcodeController.text = code;
    }
  }

  void _submitForm() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isGenerating = true;
    });

    try {
      final List<LayerSpec> layers = [];

      final layoutParams =
          ResponsiveLayoutUtil.getPriceTagLayout(widget.width, widget.height);

      if (_productImage != null) {
        layers.add(LayerSpec.widget(
          widget: ClipRRect(
            borderRadius: BorderRadius.circular(Dimens.radiusM),
            child: Image.file(_productImage!,
                width: 200, height: 160, fit: BoxFit.cover),
          ),
          offset: layoutParams.productImageOffset,
          scale: layoutParams.productImageScale,
          kind: LayerKind.image,
          elementId: 'productImage',
        ));
      }

      if (_data.productName.isNotEmpty) {
        layers.add(LayerSpec.text(
          text: _data.productName,
          textStyle: TextStyle(
              fontSize: layoutParams.productNameFontSize,
              fontWeight: FontWeight.bold),
          backgroundColor: colorWhite,
          textColor: colorBlack,
          textAlign: TextAlign.center,
          offset: layoutParams.productNameOffset,
          scale: layoutParams.productNameScale,
          elementId: 'productName',
        ));
        if (_data.productDescription.isNotEmpty) {
          layers.add(LayerSpec.text(
            text: _data.productDescription,
            textStyle: TextStyle(
              fontSize: layoutParams.productDescriptionFontSize,
              fontWeight: FontWeight.normal,
            ),
            backgroundColor: colorWhite,
            textColor: colorBlack,
            textAlign: TextAlign.center,
            offset: layoutParams.productDescriptionOffset,
            scale: layoutParams.productDescriptionScale,
            elementId: 'productDescription',
          ));
        }
      }

      if (_data.price.isNotEmpty || _data.currency.isNotEmpty) {
        layers.add(LayerSpec.text(
          text: '${_data.currency} ${_data.price}',
          textStyle: TextStyle(
              fontSize: layoutParams.priceFontSize,
              fontWeight: FontWeight.bold),
          backgroundColor: colorWhite,
          textColor: Colors.red,
          textAlign: TextAlign.center,
          offset: layoutParams.priceOffset,
          scale: layoutParams.priceScale,
          followCanvasTheme: false,
          elementId: 'price',
        ));
      }

      if (_data.quantity.isNotEmpty) {
        layers.add(LayerSpec.text(
          text: _data.quantity,
          textStyle: TextStyle(fontSize: layoutParams.quantityFontSize),
          backgroundColor: colorWhite,
          textColor: colorBlack,
          textAlign: TextAlign.center,
          offset: layoutParams.quantityOffset,
          scale: layoutParams.quantityScale,
          elementId: 'quantity',
        ));
      }

      if (_data.barcodeData.isNotEmpty) {
        layers.add(LayerSpec.widget(
          widget: BarcodeWidget(
            style: const TextStyle(color: colorBlack),
            padding: const EdgeInsets.all(Dimens.spacingXxs),
            backgroundColor: colorWhite,
            barcode: Barcode.code128(),
            data: _data.barcodeData,
            width: layoutParams.barcodeSize.width,
            height: layoutParams.barcodeSize.height,
          ),
          offset: layoutParams.barcodeOffset,
          scale: layoutParams.barcodeScale,
          kind: LayerKind.barcode,
          elementId: 'barcode',
        ));
      }

      final Object? result = await Navigator.of(context).push<Object>(
        buildOpaqueSlideRoute(
          NativeCanvasEditor(
            width: widget.width,
            height: widget.height,
            initialLayers: layers,
          ),
        ),
      );

      if (!mounted) return;
      if (result is Uint8List) {
        Navigator.of(context)
          ..pop()
          ..pop(result);
      } else if (result is String) {
        _handleEditRequest(result);
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
      showBackButton: true,
      titleWidget: Text(
        appLocalizations.priceTagGenerator,
        style: const TextStyle(
          fontSize: Dimens.fontSizeXxl,
          fontWeight: FontWeight.bold,
          color: colorWhite,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(Dimens.spacingL, Dimens.spacingL,
              Dimens.spacingL, Dimens.spacingL),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  appLocalizations.previewPriceTag,
                  style: const TextStyle(
                    fontSize: Dimens.fontSizeL,
                    fontWeight: FontWeight.bold,
                    color: colorBlack,
                  ),
                ),
              ),
              const SizedBox(height: Dimens.spacingM),
              PriceTagCardWidget(data: _data),
              const SizedBox(height: Dimens.spacingXl),
              const Divider(height: 1, color: grey500),
              const SizedBox(height: Dimens.spacingXl),
              Card(
                color: colorWhite,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.radiusXl),
                  side: BorderSide(color: grey300, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.spacingXl),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.local_offer_outlined,
                                color: colorAccent, size: Dimens.iconSizeM),
                            const SizedBox(width: Dimens.spacingS),
                            Text(
                              appLocalizations.productDetails,
                              style: const TextStyle(
                                fontSize: Dimens.fontSizeXl,
                                fontWeight: FontWeight.bold,
                                color: colorBlack,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimens.spacingSm),
                        Text(
                          appLocalizations.priceTagDescription,
                          style: TextStyle(fontSize: 13, color: grey600),
                        ),
                        const SizedBox(height: Dimens.spacingXl),
                        _buildProductImageSection(),
                        const SizedBox(height: Dimens.spacingXl),
                        _buildTextFormField(
                          controller: _productNameController,
                          focusNode: _fieldFocusNodes['productName'],
                          label: appLocalizations.productName,
                          hint: appLocalizations.productNameHint,
                          icon: Icons.inventory_2_outlined,
                        ),
                        const SizedBox(height: Dimens.spacingM),
                        _buildTextFormField(
                          controller: _productDescriptionController,
                          focusNode: _fieldFocusNodes['productDescription'],
                          label: 'Description',
                          hint: '',
                          icon: Icons.description_outlined,
                          maxLines: 2,
                          maxLength: 60,
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildTextFormField(
                                controller: _currencyController,
                                label: appLocalizations.currency,
                                hint: appLocalizations.currencyHint,
                                icon: Icons.currency_exchange_outlined,
                                readOnly: true,
                                onTap: _openCurrencyPicker,
                              ),
                            ),
                            const SizedBox(width: Dimens.spacingM),
                            Expanded(
                              flex: 1,
                              child: _buildTextFormField(
                                controller: _priceController,
                                focusNode: _fieldFocusNodes['price'],
                                label: appLocalizations.price,
                                hint: appLocalizations.priceHint,
                                icon: Icons.payments_outlined,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTextFormField(
                          controller: _quantityController,
                          focusNode: _fieldFocusNodes['quantity'],
                          label: appLocalizations.quantitySize,
                          hint: appLocalizations.quantitySizeHint,
                          icon: Icons.straighten_outlined,
                        ),
                        const SizedBox(height: Dimens.spacingL),
                        _buildTextFormField(
                          controller: _barcodeController,
                          focusNode: _fieldFocusNodes['barcode'],
                          label: appLocalizations.barcodeData,
                          hint: appLocalizations.barcodeDataHint,
                          icon: Icons.qr_code_scanner_outlined,
                          maxLength: 80,
                          onScan: _scanBarcode,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Dimens.spacingXxl),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isGenerating ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimary.withValues(
                        alpha: _isGenerating ? 0.49 : 1.0),
                    foregroundColor:
                        colorWhite.withValues(alpha: _isGenerating ? 0.7 : 1.0),
                    elevation: _isGenerating ? 0 : 2,
                    shadowColor: colorPrimary.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimens.radiusM),
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
                                    AlwaysStoppedAnimation<Color>(colorWhite),
                              ),
                            ),
                            const SizedBox(width: Dimens.spacingM),
                            Text(
                              appLocalizations.generatingPriceTag,
                              style: const TextStyle(
                                  fontSize: Dimens.fontSizeL,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.local_offer, size: 18),
                            const SizedBox(width: Dimens.spacingS),
                            Text(
                              appLocalizations.generatePriceTag,
                              style: const TextStyle(
                                  fontSize: Dimens.fontSizeL,
                                  fontWeight: FontWeight.bold),
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
    VoidCallback? onScan,
    int? maxLength = 25,
    bool readOnly = false,
    VoidCallback? onTap,
    FocusNode? focusNode,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: colorPrimary,
          selectionColor: colorPrimary.withValues(alpha: 0.2),
          selectionHandleColor: colorPrimary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: colorPrimary,
          hoverColor: colorPrimary.withValues(alpha: 0.1),
        ),
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        readOnly: readOnly,
        onTap: onTap,
        showCursor: onTap != null ? false : null,
        style: const TextStyle(
          fontSize: Dimens.fontSizeL,
          color: colorBlack,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: colorPrimary,
        decoration: InputDecoration(
          counterText: '',
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: colorAccent, size: Dimens.iconSizeM),
          suffixIcon: onScan != null
              ? IconButton(
                  tooltip: appLocalizations.scanBarcodeTooltip,
                  icon: const Icon(Icons.qr_code_scanner, color: colorAccent),
                  onPressed: onScan,
                )
              : onTap != null
                  ? const Icon(Icons.arrow_drop_down, color: colorAccent)
                  : null,
          labelStyle: TextStyle(
            color: colorBlack.withValues(alpha: 0.7),
            fontSize: Dimens.fontSizeM,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: grey500,
            fontSize: Dimens.fontSizeM,
            fontWeight: FontWeight.w400,
          ),
          floatingLabelStyle: const TextStyle(
            color: colorPrimary,
            fontSize: Dimens.fontSizeM,
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusM),
            borderSide: BorderSide(color: grey300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusM),
            borderSide: BorderSide(color: grey300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusM),
            borderSide: const BorderSide(color: colorPrimary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusM),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusM),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: Dimens.spacingL, vertical: 14),
          filled: true,
          fillColor: grey50,
        ),
      ),
    );
  }

  Widget _buildProductImageSection() {
    return Card(
      color: grey50,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusM),
        side: BorderSide(color: grey300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.image_outlined, color: colorAccent, size: 18),
                const SizedBox(width: Dimens.spacingS),
                Text(
                  appLocalizations.productImageIn,
                  style: const TextStyle(
                    fontSize: Dimens.fontSizeM,
                    fontWeight: FontWeight.w600,
                    color: colorBlack,
                  ),
                ),
                const Spacer(),
                if (_productImage != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.spacingS,
                        vertical: Dimens.spacingXs),
                    decoration: BoxDecoration(
                      color: colorPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimens.radiusXl),
                    ),
                    child: Text(
                      appLocalizations.selected,
                      style: const TextStyle(
                        fontSize: Dimens.fontSizeS,
                        color: colorPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Dimens.spacingM),
            InkWell(
              onTap: _pickProductImage,
              borderRadius: BorderRadius.circular(Dimens.radiusM),
              splashColor: colorAccent.withValues(alpha: 0.1),
              highlightColor: colorAccent.withValues(alpha: 0.05),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimens.spacingL),
                decoration: BoxDecoration(
                  color: colorWhite,
                  borderRadius: BorderRadius.circular(Dimens.radiusM),
                  border: Border.all(
                    color: _productImage != null ? colorPrimary : grey300,
                    width: _productImage != null ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: grey100,
                        borderRadius: BorderRadius.circular(Dimens.radiusM),
                        border: Border.all(
                          color: _productImage != null
                              ? colorPrimary.withValues(alpha: 0.3)
                              : grey300,
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
                                      borderRadius:
                                          BorderRadius.circular(Dimens.radiusM),
                                    ),
                                    padding:
                                        const EdgeInsets.all(Dimens.spacingXxs),
                                    child: const Icon(
                                      Icons.check,
                                      size: 12,
                                      color: colorWhite,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Icon(
                              Icons.add_photo_alternate,
                              size: 28,
                              color: grey400,
                            ),
                    ),
                    const SizedBox(width: Dimens.spacingL),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _productImage != null
                                ? appLocalizations.productImageSelected
                                : appLocalizations.selectProductImage,
                            style: TextStyle(
                              fontSize: Dimens.fontSizeM,
                              fontWeight: FontWeight.w600,
                              color: _productImage != null
                                  ? colorPrimary
                                  : colorBlack,
                            ),
                          ),
                          const SizedBox(height: Dimens.spacingXs),
                          Text(
                            _productImage != null
                                ? appLocalizations.tapToChangeImage
                                : appLocalizations.chooseImageFromGallery,
                            style: TextStyle(
                              fontSize: Dimens.fontSizeS,
                              color: grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(Dimens.spacingS),
                      decoration: BoxDecoration(
                        color: _productImage != null
                            ? colorPrimary.withValues(alpha: 0.1)
                            : grey100,
                        borderRadius: BorderRadius.circular(Dimens.radiusRound),
                      ),
                      child: Icon(
                        _productImage != null
                            ? Icons.edit
                            : Icons.photo_library,
                        color: _productImage != null ? colorPrimary : grey400,
                        size: Dimens.iconSizeS,
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
