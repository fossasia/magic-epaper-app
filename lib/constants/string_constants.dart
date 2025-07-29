class StringConstants {
  static const String appName = 'Magic epaper';

  static const String aboutUsDescription =
      'Magic ePaper is an app designed to control and update ePaper displays.'
      'The goal is to provide tools for customizing and transferring images, text, and patterns to ePaper screens using NFC.'
      'Data transfer from the smartphone to the ePaper hardware is done wirelessly via NFC. The project is built on top of custom firmware and display drivers for seamless communication and efficient image rendering.';
  static const String developedBy = 'Developed by';
  static const String fossasiaContributors = 'FOSSASIA contributors';
  static const String contactWithUs = 'Contact With Us';
  static const String github = 'GitHub';
  static const String githubSubtitle =
      'Fork the repo and push changes or submit new issues.';
  static const String license = 'License';
  static const String licenseSubtitle =
      'Check Apache License 2.0 terms used on Magic ePaper.';
  static const String selectDisplay = 'Select Display';
  static const String ndefScreen = 'Ndef';
  static const String selectDisplayType = 'Select your ePaper display type';
  static const String settings = 'Settings';
  static const String aboutUs = 'About Us';
  static const String other = 'Other';
  static const String buyBadge = 'Buy Badge';
  static const String feedbackBugReports = 'Feedback/Bug Reports';
  static const String continueButton = 'Continue';
  static const String noImageSelectedFeedback = 'Import an image first!';
  static const String adjustButtonLabel = 'Adjust';
  static const String importImageButtonLabel = 'Import New';
  static const String openEditor = 'Open Editor';
  static const String importStartingImageFeedback = "Import an image to begin";
  static const String transferButtonLabel = 'Transfer';
  static const String filterScreenTitle = 'Select a Filter';

  static const String scanningForNfcTag = 'Scanning for NFC tag...';
  static const String scanningForNfcTagToWrite =
      'Scanning for NFC tag to write...';
  static const String scanningForNfcTagToClear =
      'Scanning for NFC tag to clear...';
  static const String scanningTagForVerification =
      'Scanning tag for verification...';
  static const String errorCreatingTextRecord = 'Error creating text record: ';
  static const String errorCreatingUrlRecord = 'Error creating URL record: ';
  static const String errorCreatingWifiRecord = 'Error creating WiFi record: ';
  static const String errorCreatingMultipleRecords =
      'Error creating multiple records: ';
  static const String pleaseEnterAtLeastOneRecord =
      'Please enter at least one record to write';
  static const String tagType = 'Tag Type: ';
  static const String tagId = 'Tag ID: ';
  static const String ndefAvailable = 'NDEF Available: ';
  static const String ndefWritable = 'NDEF Writable: ';
  static const String unknown = 'Unknown';
  static const String textCannotBeEmpty = 'Text cannot be empty';
  static const String urlCannotBeEmpty = 'URL cannot be empty';
  static const String wifiSsidCannotBeEmpty = 'WiFi SSID cannot be empty';
  static const String defaultLanguage = 'en';
  static const String httpsPrefix = 'https://';
  static const String httpPrefix = 'http://';
  static const String wifiConfigFormat = 'WIFI:T:WPA;S:';
  static const String wifiConfigSuffix = ';;';
  static const String wifiPasswordPrefix = ';P:';
  static const String emptySpace = ' ';
  static const String unknownNull = 'Unknown (null)';
  static const String unknownType = 'Unknown (';
  static const String textPrefix = 'Text: "';
  static const String textSuffix = '" (Language: ';
  static const String uriPrefix = 'URI: ';
  static const String mimePrefix = 'MIME: ';
  static const String absoluteUriPrefix = 'Absolute URI: ';
  static const String rawPrefix = 'Raw: ';
  static const String emptyPayload = 'Empty payload';
  static const String binaryDataPrefix = 'Binary data (';
  static const String binaryDataSuffix = ' bytes): ';
  static const String errorDecodingRecord = 'Error decoding record: ';
  static const String noNdefRecordsFound =
      'No NDEF records found on tag\nThe tag is empty.';
  static const String recordPrefix = '📄 Record ';
  static const String recordSuffix = ':';
  static const String tnfLabel = '  TNF: ';
  static const String typeLabel = '  Type: ';
  static const String payloadSizeLabel = '  Payload Size: ';
  static const String bytesLabel = ' bytes';
  static const String contentLabel = '  Content: ';
  static const String rawPayloadLabel = '  Raw Payload: ';
  static const String nullPayload = 'null';
  static const String closingParenthesis = ')';
  static const String closingParenthesisNewline = ')\n';
  static const String scanYourNfcTag = 'Scan your NFC tag';
  static const String scanYourNfcTagToWrite = 'Scan your NFC tag to write';
  static const String scanYourNfcTagToClear = 'Scan your NFC tag to clear';
  static const String scanTagToVerifyContent = 'Scan tag to verify content';
  static const String tagIsNotNdefCompatible = 'Tag is not NDEF compatible';
  static const String tagDoesNotSupportNdef = 'Tag does not support NDEF';
  static const String tagIsNotWritable = 'Tag is not writable';
  static const String tagDoesNotSupportNdefCannotClear =
      'Tag does not support NDEF - cannot clear';
  static const String tagIsNotWritableCannotClear =
      'Tag is not writable - cannot clear';
  static const String readOperationCompleted = 'Read operation completed';
  static const String writeOperationCompleted = 'Write operation completed';
  static const String clearOperationCompleted = 'Clear operation completed';
  static const String ndefRecordsFound = 'NDEF Records found: ';
  static const String theTagIsEmpty = 'The tag is empty (no NDEF records).';
  static const String record = 'Record ';
  static const String type = '  Type: ';
  static const String tnf = '  TNF: ';
  static const String content = '  Content: ';
  static const String noRecordsToWrite = 'No records to write';
  static const String ndefRecordsWrittenSuccessfully =
      '✅ NDEF records written successfully!';
  static const String recordsWritten = 'Records written: ';
  static const String writtenRecord = 'Written Record ';
  static const String tagClearedSuccessfully = '🗑️ Tag cleared successfully!';
  static const String method = 'Method: ';
  static const String tagIsNowReadyForNewData =
      'Tag is now ready for new data.';
  static const String emptyTextRecord = 'empty text record';
  static const String emptyNdefRecord = 'empty NDEF record';
  static const String minimalSpaceCharacter = 'minimal space character';
  static const String emptyRecordList = 'empty record list';
  static const String allClearingMethodsFailed =
      'All clearing methods failed: ';
  static const String verificationResults = '🔍 VERIFICATION RESULTS:';
  static const String recordsFound = 'Records Found: ';
  static const String noNdefRecordsFoundOnTag =
      '✅ No NDEF records found on tag';
  static const String theTagIsEmptyCleared =
      'The tag is empty (cleared successfully).';
  static const String errorReadingTag = 'Error reading tag: ';
  static const String errorWritingToTag = 'Error writing to tag: ';
  static const String errorClearingTag = 'Error clearing tag: ';
  static const String verificationError = 'Verification Error: ';
  static const String holdTagCloseAndTryAgain =
      '\n\nHold the tag close to the NFC antenna and try again.';
  static const String tryHoldingTagCloser =
      '\n\nTry holding the tag closer to the NFC antenna.';
  static const String tryMovingTagCloser =
      '\n\nTry moving the tag closer to the NFC antenna.';
  static const String method1EmptyTextRecordFailed =
      'Method 1 (empty text record) failed: ';
  static const String method2EmptyNdefRecordFailed =
      'Method 2 (empty NDEF record) failed: ';
  static const String method3MinimalRecordFailed =
      'Method 3 (minimal record) failed: ';
  static const String method4EmptyListFailed = 'Method 4 (empty list) failed: ';
  static const String errorFinishingNfcSession =
      'Error finishing NFC session: ';
  static const String secondaryCleanupAlsoFailed =
      'Secondary cleanup also failed: ';
  static const String multipleTagsFoundPleaseSelectOne =
      'Multiple tags found, please select one';
  static const String scanYourNfcTagDefault = 'Scan your NFC tag';
  static const String readNdefTags = 'Read NDEF Tags';
  static const String reading = 'Reading...';
  static const String readNfcTag = 'Read NFC Tag';
  static const String verify = 'Verify';
  static const String clearing = 'Clearing...';
  static const String clearNfcTag = 'Clear NFC Tag';
  static const String monospaceFontFamily = 'monospace';
  static const String nfcStatus = 'NFC Status';
  static const String refreshNfcStatus = 'Refresh NFC Status';
  static const String writeNdefRecords = 'Write NDEF Records';
  static const String textRecord = 'Text Record';
  static const String enterTextToWriteToNfcTag =
      'Enter text to write to NFC tag';
  static const String writing = 'Writing...';
  static const String writeText = 'Write Text';
  static const String urlRecord = 'URL Record';
  static const String enterUrl = 'Enter URL (e.g., google.com';
  static const String writeUrl = 'Write URL';
  static const String wifiRecord = 'WiFi Record';
  static const String wifiNetworkNameSsid = 'WiFi Network Name (SSID)';
  static const String wifiPassword = 'WiFi Password';
  static const String writeWifi = 'Write WiFi';
  static const String writeAllRecords = 'Write All Records';
  static const String writeAllNonEmptyFieldsDescription =
      'Write all non-empty fields above as multiple NDEF records';
  static const String writeMultipleRecords = 'Write Multiple Records';
  static const String readOperationFailed = 'Read operation failed';
  static const String tagReadSuccessfully = 'Tag read successfully';
  static const String verificationFailed = 'Verification failed';
  static const String tagVerifiedSuccessfully = 'Tag verified successfully';
  static const String clearNfcTagConfirmation =
      'Are you sure you want to clear this NFC tag? This action cannot be undone.';
  static const String clearOperationFailed = 'Clear operation failed';
  static const String writeOperationFailed = 'Write operation failed';
  static const String dataWrittenSuccessfully =
      'Data written successfully to NFC tag';
  static const String nfcNotAvailable = 'NFC Not Available';
  static const String enableNfcMessage =
      'Please enable NFC in your device settings to use write features.';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String error = 'Error';
  static const String successfully = 'successfully';
  static const String selectApplication = 'Select Application';
  static const String writeAppLauncher = 'Write App Launcher';
  static const String noAppsFound = 'No apps found';
  static const String searchApps = 'Search apps...';
  static const String errorCreatingAppRecord = 'Error creating app launch record: ';
  static const String appCannotBeEmpty = 'App cannot be empty';
  static const String writeAppLauncherData = 'Write App Launcher Data';
  static const String customPackageName = 'Custom Package Name';
  static const String enterPackageName = 'Enter package name (e.g., com.example.app)';
  static const String invalidPackageName = 'Invalid package name format';
}
