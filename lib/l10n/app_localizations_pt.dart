// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Magic Epaper';

  @override
  String get aboutUsDescription =>
      'Magic ePaper is an app designed to control and update ePaper displays. The goal is to provide tools for customizing and transferring images, text, and patterns to ePaper screens using NFC. Data transfer from the smartphone to the ePaper hardware is done wirelessly via NFC. The project is built on top of custom firmware and display drivers for seamless communication and efficient image rendering.';

  @override
  String get developedBy => 'Developed by';

  @override
  String get fossasiaContributors => 'FOSSASIA contributors';

  @override
  String get contactWithUs => 'Contact With Us';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle =>
      'Fork the repo and push changes or submit new issues.';

  @override
  String get license => 'License';

  @override
  String get licenseSubtitle =>
      'Check Apache License 2.0 terms used on Magic ePaper.';

  @override
  String get selectDisplay => 'Select Display';

  @override
  String get ndefScreen => 'Ndef';

  @override
  String get selectDisplayType => 'Select your ePaper display type';

  @override
  String get settings => 'Settings';

  @override
  String get aboutUs => 'About Us';

  @override
  String get other => 'Other';

  @override
  String get buyBadge => 'Buy Badge';

  @override
  String get feedbackBugReports => 'Feedback/Bug Reports';

  @override
  String get continueButton => 'Continue';

  @override
  String get noImageSelectedFeedback => 'Import an image first!';

  @override
  String get adjustButtonLabel => 'Adjust';

  @override
  String get importImageButtonLabel => 'Import';

  @override
  String get openEditor => 'Editor';

  @override
  String get importStartingImageFeedback => 'Import an image to begin';

  @override
  String get transferButtonLabel => 'Transfer';

  @override
  String get filterScreenTitle => 'Select a Filter';

  @override
  String get scanningForNfcTag => 'Scanning for NFC tag...';

  @override
  String get scanningForNfcTagToWrite => 'Scanning for NFC tag to write...';

  @override
  String get scanningForNfcTagToClear => 'Scanning for NFC tag to clear...';

  @override
  String get scanningTagForVerification => 'Scanning tag for verification...';

  @override
  String get errorCreatingTextRecord => 'Error creating text record: ';

  @override
  String get errorCreatingUrlRecord => 'Error creating URL record: ';

  @override
  String get errorCreatingWifiRecord => 'Error creating WiFi record: ';

  @override
  String get errorCreatingMultipleRecords =>
      'Error creating multiple records: ';

  @override
  String get pleaseEnterAtLeastOneRecord => 'Please enter at least one record';

  @override
  String get tagType => 'Tag Type: ';

  @override
  String get tagId => 'Tag ID: ';

  @override
  String get ndefAvailable => 'NDEF Available: ';

  @override
  String get ndefWritable => 'NDEF Writable: ';

  @override
  String get unknown => 'Unknown';

  @override
  String get textCannotBeEmpty => 'Text cannot be empty';

  @override
  String get urlCannotBeEmpty => 'URL cannot be empty';

  @override
  String get wifiSsidCannotBeEmpty => 'WiFi SSID cannot be empty';

  @override
  String get defaultLanguage => 'en';

  @override
  String get httpsPrefix => 'https://';

  @override
  String get httpPrefix => 'http://';

  @override
  String get wifiConfigFormat => 'WIFI:S:';

  @override
  String get wifiConfigSuffix => ';;';

  @override
  String get wifiPasswordPrefix => ';T:WPA;P:';

  @override
  String get emptySpace => ' ';

  @override
  String get unknownNull => 'Unknown (null)';

  @override
  String get unknownType => 'Unknown type: ';

  @override
  String get textPrefix => 'Text: ';

  @override
  String get textSuffix => ' (Language: ';

  @override
  String get uriPrefix => 'URI: ';

  @override
  String get mimePrefix => 'MIME: ';

  @override
  String get absoluteUriPrefix => 'Absolute URI: ';

  @override
  String get rawPrefix => 'Raw: ';

  @override
  String get emptyPayload => 'Empty payload';

  @override
  String get binaryDataPrefix => 'Binary data (';

  @override
  String get binaryDataSuffix => ' bytes): ';

  @override
  String get errorDecodingRecord => 'Error decoding record: ';

  @override
  String get noNdefRecordsFound => 'No NDEF records found';

  @override
  String get recordPrefix => 'Record ';

  @override
  String get recordSuffix => ':';

  @override
  String get tnfLabel => 'TNF: ';

  @override
  String get typeLabel => 'Type: ';

  @override
  String get payloadSizeLabel => 'Payload Size: ';

  @override
  String get bytesLabel => ' bytes';

  @override
  String get contentLabel => 'Content: ';

  @override
  String get rawPayloadLabel => 'Raw Payload: ';

  @override
  String get nullPayload => 'null';

  @override
  String get closingParenthesis => ')';

  @override
  String get closingParenthesisNewline => ')\n';

  @override
  String get scanYourNfcTag => 'Scan your NFC tag';

  @override
  String get scanYourNfcTagToWrite => 'Scan your NFC tag to write';

  @override
  String get scanYourNfcTagToClear => 'Scan your NFC tag to clear';

  @override
  String get scanTagToVerifyContent => 'Scan tag to verify content';

  @override
  String get tagIsNotNdefCompatible => 'Tag is not NDEF compatible';

  @override
  String get tagDoesNotSupportNdef => 'Tag does not support NDEF';

  @override
  String get tagIsNotWritable => 'Tag is not writable';

  @override
  String get tagDoesNotSupportNdefCannotClear =>
      'Tag does not support NDEF, cannot clear';

  @override
  String get tagIsNotWritableCannotClear => 'Tag is not writable, cannot clear';

  @override
  String get readOperationCompleted => 'Read operation completed';

  @override
  String get writeOperationCompleted => 'Write operation completed';

  @override
  String get clearOperationCompleted => 'Clear operation completed';

  @override
  String get ndefRecordsFound => 'NDEF records found: ';

  @override
  String get theTagIsEmpty => 'The tag is empty';

  @override
  String get record => 'Record ';

  @override
  String get type => 'Type: ';

  @override
  String get tnf => 'TNF: ';

  @override
  String get content => 'Content: ';

  @override
  String get noRecordsToWrite => 'No records to write';

  @override
  String get ndefRecordsWrittenSuccessfully =>
      'NDEF records written successfully';

  @override
  String get recordsWritten => 'Records written: ';

  @override
  String get writtenRecord => 'Written record ';

  @override
  String get tagClearedSuccessfully => 'Tag cleared successfully';

  @override
  String get method => 'Method: ';

  @override
  String get tagIsNowReadyForNewData => 'Tag is now ready for new data';

  @override
  String get emptyTextRecord => 'Empty text record';

  @override
  String get emptyNdefRecord => 'Empty NDEF record';

  @override
  String get minimalSpaceCharacter => 'Minimal space character';

  @override
  String get emptyRecordList => 'Empty record list';

  @override
  String get allClearingMethodsFailed => 'All clearing methods failed: ';

  @override
  String get verificationResults => 'Verification Results:';

  @override
  String get recordsFound => 'Records found: ';

  @override
  String get noNdefRecordsFoundOnTag => 'No NDEF records found on tag';

  @override
  String get theTagIsEmptyCleared => 'The tag is empty/cleared';

  @override
  String get errorReadingTag => 'Error reading tag: ';

  @override
  String get errorWritingToTag => 'Error writing to tag: ';

  @override
  String get errorClearingTag => 'Error clearing tag: ';

  @override
  String get verificationError => 'Verification error: ';

  @override
  String get holdTagCloseAndTryAgain => '. Hold tag close and try again';

  @override
  String get tryHoldingTagCloser => '. Try holding tag closer';

  @override
  String get tryMovingTagCloser => '. Try moving tag closer';

  @override
  String get method1EmptyTextRecordFailed =>
      'Method 1 (empty text record) failed: ';

  @override
  String get method2EmptyNdefRecordFailed =>
      'Method 2 (empty NDEF record) failed: ';

  @override
  String get method3MinimalRecordFailed => 'Method 3 (minimal record) failed: ';

  @override
  String get method4EmptyListFailed => 'Method 4 (empty list) failed: ';

  @override
  String get errorFinishingNfcSession => 'Error finishing NFC session: ';

  @override
  String get secondaryCleanupAlsoFailed => 'Secondary cleanup also failed: ';

  @override
  String get multipleTagsFoundPleaseSelectOne =>
      'Multiple tags found, please select one';

  @override
  String get scanYourNfcTagDefault => 'Scan your NFC tag';

  @override
  String get readNdefTags => 'Read NDEF Tags';

  @override
  String get reading => 'Reading...';

  @override
  String get readNfcTag => 'Read NFC Tag';

  @override
  String get verify => 'Verify';

  @override
  String get clearing => 'Clearing...';

  @override
  String get clearNfcTag => 'Clear NFC Tag';

  @override
  String get monospaceFontFamily => 'monospace';

  @override
  String get nfcStatus => 'NFC Status';

  @override
  String get refreshNfcStatus => 'Refresh NFC Status';

  @override
  String get writeNdefRecords => 'Write NDEF Records';

  @override
  String get textRecord => 'Text Record';

  @override
  String get enterTextToWriteToNfcTag => 'Enter text to write to NFC tag';

  @override
  String get writing => 'Writing...';

  @override
  String get writeText => 'Write Text';

  @override
  String get urlRecord => 'URL Record';

  @override
  String get enterUrl => 'Enter URL';

  @override
  String get writeUrl => 'Write URL';

  @override
  String get wifiRecord => 'WiFi Record';

  @override
  String get wifiNetworkNameSsid => 'WiFi Network Name (SSID)';

  @override
  String get wifiPassword => 'WiFi Password';

  @override
  String get writeWifi => 'Write WiFi';

  @override
  String get writeAllRecords => 'Write All Records';

  @override
  String get writeAllNonEmptyFieldsDescription =>
      'Write all non-empty fields to the NFC tag at once';

  @override
  String get writeMultipleRecords => 'Write Multiple Records';

  @override
  String get readOperationFailed => 'Read operation failed';

  @override
  String get tagReadSuccessfully => 'Tag read successfully';

  @override
  String get verificationFailed => 'Verification failed';

  @override
  String get tagVerifiedSuccessfully => 'Tag verified successfully';

  @override
  String get clearNfcTagConfirmation =>
      'Are you sure you want to clear this NFC tag? This action cannot be undone.';

  @override
  String get clearOperationFailed => 'Clear operation failed';

  @override
  String get writeOperationFailed => 'Write operation failed';

  @override
  String get dataWrittenSuccessfully => 'Data written successfully';

  @override
  String get nfcNotAvailable => 'NFC Not Available';

  @override
  String get enableNfcMessage =>
      'Please enable NFC in your device settings to use this feature.';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get error => 'Error';

  @override
  String get successfully => 'successfully';

  @override
  String get language => 'Language';

  @override
  String get loading => 'Loading...';

  @override
  String get exportXbm => 'Export XBM';

  @override
  String get fullRefresh => 'Full Refresh';

  @override
  String get fullRefreshSelected => 'Full Refresh Selected';

  @override
  String get waveformSelected => 'Selected';

  @override
  String get barcode => 'Barcode';

  @override
  String get library => 'Library';

  @override
  String get templates => 'Templates';

  @override
  String get barcodeGenerator => 'Barcode Generator';

  @override
  String get barcodeData => 'Barcode Data';

  @override
  String get barcodeDataHint => 'Enter barcode data or scan';

  @override
  String get characters => 'Characters';

  @override
  String get scanBarcode => 'Scan Barcode';

  @override
  String get barcodeFormat => 'Barcode Format';

  @override
  String get enterOrScanBarcodeData => 'Enter or scan barcode data';

  @override
  String get invalidBarcode => 'Invalid Barcode';

  @override
  String get invalidCharacter => 'Invalid character';

  @override
  String get supportedCharacters => 'Supported characters are';

  @override
  String get pleaseCheckBarcodeRules => 'Please check the barcode rules.';

  @override
  String get dataTooShort => 'Data is too short. Minimum length for';

  @override
  String get dataTooLong => 'Data is too long. Maximum length for';

  @override
  String get isText => 'is';

  @override
  String get pointCameraAtBarcode => 'Point camera at barcode to scan';

  @override
  String get generateImage => 'Generate Image';

  @override
  String get exportFailed => 'Export failed';

  @override
  String get exportedXbmFiles => 'Exported XBM file(s) to MagicEpaper/XBM/';

  @override
  String get floydSteinberg => 'Classic';

  @override
  String get stucki => 'Sharp';

  @override
  String get atkinson => 'Vintage';

  @override
  String get falseFloydSteinberg => 'Simple';

  @override
  String get halftone => 'Newspaper';

  @override
  String get threshold => 'Posterize';

  @override
  String get colorHalftone => 'Color Newspaper';

  @override
  String get searchingForDevice => 'Searching for Device';

  @override
  String get displayRefreshing => 'Display Refreshing';

  @override
  String get transferComplete => 'Transfer complete!';

  @override
  String get writingToEpaper => 'Writing to E-Paper';

  @override
  String get pleaseBringPhoneClose =>
      'Please bring your phone close to the Magic E-Paper device';

  @override
  String get keepPhoneClose => 'Keep your phone close!';

  @override
  String get displayRefreshingMessage =>
      'The display is refreshing. Please keep your phone near the device until the image appears completely.';

  @override
  String get transferFailed => 'Transfer Failed';

  @override
  String get deviceConnectionTimeout =>
      'Device connection timed out. Please try bringing your phone closer to the device and try again.';

  @override
  String get connectionLostDuringTransfer =>
      'Connection was lost during transfer. Please keep your phone close to the device and try again.';

  @override
  String get done => 'Done';

  @override
  String get close => 'Close';

  @override
  String get processingImage => 'Processing Image...';

  @override
  String get readyToFlash => 'Ready to Flash';

  @override
  String get imageProcessedSuccessfully => 'Image processed successfully.';

  @override
  String get tapBelowAndHold =>
      'Tap below and hold your phone near the display.';

  @override
  String get startFlashing => 'Start Flashing';

  @override
  String get flashing => 'Flashing...';

  @override
  String get keepPhoneStill => 'Keep your phone still.';

  @override
  String get success => 'Success!';

  @override
  String get transferCompleteMessage => 'Transfer complete!';

  @override
  String get unknownErrorOccurred => 'An unknown error occurred.';

  @override
  String get resultsCleared => 'Results cleared';

  @override
  String get clearResults => 'Clear Results';

  @override
  String get vCardContact => 'vCard Contact';

  @override
  String get writingVCard => 'Writing vCard...';

  @override
  String get writeVCard => 'Write vCard';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get organization => 'Organization';

  @override
  String get title => 'Title';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get streetAddress => 'Street Address';

  @override
  String get city => 'City';

  @override
  String get zipCode => 'Zip Code';

  @override
  String get country => 'Country';

  @override
  String get website => 'Website';

  @override
  String get noSavedImagesYet => 'No saved images yet';

  @override
  String get saveImagesFromEditor =>
      'Save images from the editor or import new ones';

  @override
  String get enterWifiSSID => 'Enter WiFi SSID';

  @override
  String get enterWifiPassword => 'Enter WiFi password';

  @override
  String get writeMultiple => 'Write Multiple';

  @override
  String get searchImages => 'Search images...';

  @override
  String get filter => 'Filter:';

  @override
  String get all => 'All';

  @override
  String get imported => 'Imported';

  @override
  String get editor => 'Editor';

  @override
  String get imageLibrary => 'Image Library';

  @override
  String get selectImagesToDelete => 'Select Images to Delete';

  @override
  String get delete => 'Delete';

  @override
  String get deleteMode => 'Delete Mode';

  @override
  String get deleteImage => 'Delete Image';

  @override
  String get thisActionCannotBeUndone => 'This action cannot be undone';

  @override
  String get filterLabel => 'Filter:';

  @override
  String get areYouSureDeleteImage =>
      'Are you sure you want to delete this image? This action cannot be undone.';

  @override
  String get deleteMultipleImages => 'Delete Multiple Images';

  @override
  String get imagesSelected => 'image(s) selected';

  @override
  String get imagesSelectedForDeletion => 'image(s) selected for deletion';

  @override
  String areYouSureDeleteMultipleImages(Object count) {
    return 'Are you sure you want to delete these $count images? This action cannot be undone.';
  }

  @override
  String get areYouSureDeleteSingleImage =>
      'Are you sure you want to delete this image? This action cannot be undone.';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get renameImage => 'Rename Image';

  @override
  String get enterNewNameForImage => 'Enter a new name for your image';

  @override
  String get imageName => 'Image Name';

  @override
  String get enterImageName => 'Enter image name...';

  @override
  String get rename => 'Rename';

  @override
  String get imageProperties => 'Image Properties';

  @override
  String get created => 'Created';

  @override
  String get source => 'Source:';

  @override
  String get epdModel => 'EPD Model:';

  @override
  String get transferToEpaper => 'Transfer to ePaper';

  @override
  String get saveImage => 'Save Image';

  @override
  String get saveFilteredImageToLibrary =>
      'Save your filtered image to the library';

  @override
  String get filterApplied => 'Filter Applied:';

  @override
  String get save => 'Save';

  @override
  String get noImagesMatchSearch => 'No images match your search';

  @override
  String get vCardDataCannotBeEmpty => 'VCard data cannot be empty';

  @override
  String get renamingImage => 'Renaming image...';

  @override
  String get imageRenamedTo => 'Image renamed to \"';

  @override
  String get failedToRenameImage => 'Failed to rename image: ';

  @override
  String get deletingImage => 'Deleting image...';

  @override
  String get imageDeleted => 'Image \"';

  @override
  String get deleted => '\" deleted';

  @override
  String get failedToDeleteImage => 'Failed to delete image: ';

  @override
  String get deletingImages => 'Deleting ';

  @override
  String get images => ' image(s)...';

  @override
  String get failedToDeleteImages => 'Failed to delete images: ';

  @override
  String get imagesDeletedSuccessfully => ' images deleted successfully';

  @override
  String get imageDeletedSuccessfully => 'Image deleted successfully';

  @override
  String get failedToLoadImageData => 'Failed to load image data for \"';

  @override
  String get failedToDecodeImage => 'Failed to decode image \"';

  @override
  String get failedToTransfer => 'Failed to transfer \"';

  @override
  String get savingImage => 'Saving image...';

  @override
  String get imageSavedToLibrary => 'Image saved to library!';

  @override
  String get failedToSaveImage => 'Failed to save image: ';

  @override
  String get errorCreatingVCardRecord => 'Error creating vCard record: ';

  @override
  String get nfcIsDisabledPleaseEnableIt =>
      'NFC is disabled. Please enable it.';

  @override
  String get thisDeviceDoesNotSupportNfc => 'This device does not support NFC.';

  @override
  String get bringPhoneNearMagicEpaperHardware =>
      'Bring your phone near to the Magic Epaper Hardware';

  @override
  String get tagDetectedInitializing => 'Tag detected! Initializing...';

  @override
  String get enablingEnergyHarvesting => 'Enabling energy harvesting...';

  @override
  String get processingImageData => 'Processing image data...';

  @override
  String get refreshingDisplay => 'Refreshing display...';

  @override
  String get notMagicEpaperHardware => 'Not a Magic Epaper Hardware';

  @override
  String get errorCheckingMessage => 'Error checking message: ';

  @override
  String get timeoutWaitingForI2cMessage => 'Timeout waiting for I2C message';

  @override
  String get writingChunk => 'Writing chunk ';

  @override
  String get transferredSuccessfully => 'Transferred successfully.';

  @override
  String get waitingForNfcTag => 'Waiting for NFC tag...';

  @override
  String get gotTag => 'Got a tag!';

  @override
  String get frame => 'Frame ';

  @override
  String get couldNotOpenLink => 'Could not open the link.';

  @override
  String get errorOccurredWhileOpeningLink =>
      'An error occurred while opening the link.';

  @override
  String get errorCreatingAppRecord => 'Error creating app record: ';

  @override
  String get appCannotBeEmpty => 'App cannot be empty';

  @override
  String get invalidPackageName => 'Invalid package name';

  @override
  String get writeAppLauncherData => 'Write App Launcher Data';

  @override
  String get writeAppLauncher => 'Write App Launcher';

  @override
  String get searchApps => 'Search apps...';

  @override
  String get customPackageName => 'Custom Package Name';

  @override
  String get enterPackageName => 'Enter package name...';

  @override
  String get noAppsFound => 'No apps found';

  @override
  String get selectApplication => 'Select Application';

  @override
  String get errorLoadingApps => 'Error loading apps: ';

  @override
  String get add => 'Add';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');
}
