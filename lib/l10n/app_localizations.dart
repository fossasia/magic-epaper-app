import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('id'),
    Locale('ja'),
    Locale('nb'),
    Locale('nb', 'NO'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Magic ePaper'**
  String get appName;

  /// No description provided for @aboutUsDescription.
  ///
  /// In en, this message translates to:
  /// **'Magic ePaper is an app designed to control and update ePaper displays. The goal is to provide tools for customizing and transferring images, text, and patterns to ePaper screens using NFC. Data transfer from the smartphone to the ePaper hardware is done wirelessly via NFC. The project is built on top of custom firmware and display drivers for seamless communication and efficient image rendering.'**
  String get aboutUsDescription;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed by'**
  String get developedBy;

  /// No description provided for @fossasiaContributors.
  ///
  /// In en, this message translates to:
  /// **'FOSSASIA contributors'**
  String get fossasiaContributors;

  /// No description provided for @contactWithUs.
  ///
  /// In en, this message translates to:
  /// **'Contact With Us'**
  String get contactWithUs;

  /// No description provided for @github.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get github;

  /// No description provided for @githubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fork the repo and push changes or submit new issues.'**
  String get githubSubtitle;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @licenseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check Apache License 2.0 terms used on Magic ePaper.'**
  String get licenseSubtitle;

  /// No description provided for @createTransfer.
  ///
  /// In en, this message translates to:
  /// **'Create & Transfer Images'**
  String get createTransfer;

  /// No description provided for @ndefScreen.
  ///
  /// In en, this message translates to:
  /// **'Ndef'**
  String get ndefScreen;

  /// No description provided for @selectDisplayType.
  ///
  /// In en, this message translates to:
  /// **'Select your ePaper display type'**
  String get selectDisplayType;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @getBadge.
  ///
  /// In en, this message translates to:
  /// **'Get Badge'**
  String get getBadge;

  /// No description provided for @feedbackBugReports.
  ///
  /// In en, this message translates to:
  /// **'Feedback/Bug Reports'**
  String get feedbackBugReports;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @noImageSelectedFeedback.
  ///
  /// In en, this message translates to:
  /// **'Import an image first!'**
  String get noImageSelectedFeedback;

  /// No description provided for @adjustButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Adjust'**
  String get adjustButtonLabel;

  /// No description provided for @importImageButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importImageButtonLabel;

  /// No description provided for @openEditor.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get openEditor;

  /// No description provided for @importStartingImageFeedback.
  ///
  /// In en, this message translates to:
  /// **'Import an image to begin'**
  String get importStartingImageFeedback;

  /// No description provided for @transferButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transferButtonLabel;

  /// No description provided for @filterScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a Filter'**
  String get filterScreenTitle;

  /// No description provided for @scanningForNfcTag.
  ///
  /// In en, this message translates to:
  /// **'Scanning for NFC tag...'**
  String get scanningForNfcTag;

  /// No description provided for @scanningForNfcTagToWrite.
  ///
  /// In en, this message translates to:
  /// **'Scanning for NFC tag to write...'**
  String get scanningForNfcTagToWrite;

  /// No description provided for @scanningForNfcTagToClear.
  ///
  /// In en, this message translates to:
  /// **'Scanning for NFC tag to clear...'**
  String get scanningForNfcTagToClear;

  /// No description provided for @scanningTagForVerification.
  ///
  /// In en, this message translates to:
  /// **'Scanning tag for verification...'**
  String get scanningTagForVerification;

  /// No description provided for @errorCreatingTextRecord.
  ///
  /// In en, this message translates to:
  /// **'Error creating text record: '**
  String get errorCreatingTextRecord;

  /// No description provided for @errorCreatingUrlRecord.
  ///
  /// In en, this message translates to:
  /// **'Error creating URL record: '**
  String get errorCreatingUrlRecord;

  /// No description provided for @errorCreatingWifiRecord.
  ///
  /// In en, this message translates to:
  /// **'Error creating WiFi record: '**
  String get errorCreatingWifiRecord;

  /// No description provided for @errorCreatingMultipleRecords.
  ///
  /// In en, this message translates to:
  /// **'Error creating multiple records: '**
  String get errorCreatingMultipleRecords;

  /// No description provided for @pleaseEnterAtLeastOneRecord.
  ///
  /// In en, this message translates to:
  /// **'Please enter at least one record'**
  String get pleaseEnterAtLeastOneRecord;

  /// No description provided for @tagType.
  ///
  /// In en, this message translates to:
  /// **'Tag Type: '**
  String get tagType;

  /// No description provided for @tagId.
  ///
  /// In en, this message translates to:
  /// **'Tag ID: '**
  String get tagId;

  /// No description provided for @ndefAvailable.
  ///
  /// In en, this message translates to:
  /// **'NDEF Available: '**
  String get ndefAvailable;

  /// No description provided for @ndefWritable.
  ///
  /// In en, this message translates to:
  /// **'NDEF Writable: '**
  String get ndefWritable;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @textCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Text cannot be empty'**
  String get textCannotBeEmpty;

  /// No description provided for @urlCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'URL cannot be empty'**
  String get urlCannotBeEmpty;

  /// No description provided for @wifiSsidCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'WiFi SSID cannot be empty'**
  String get wifiSsidCannotBeEmpty;

  /// No description provided for @defaultLanguage.
  ///
  /// In en, this message translates to:
  /// **'en'**
  String get defaultLanguage;

  /// No description provided for @httpsPrefix.
  ///
  /// In en, this message translates to:
  /// **'https://'**
  String get httpsPrefix;

  /// No description provided for @httpPrefix.
  ///
  /// In en, this message translates to:
  /// **'http://'**
  String get httpPrefix;

  /// No description provided for @wifiConfigFormat.
  ///
  /// In en, this message translates to:
  /// **'WIFI:S:'**
  String get wifiConfigFormat;

  /// No description provided for @wifiConfigSuffix.
  ///
  /// In en, this message translates to:
  /// **';;'**
  String get wifiConfigSuffix;

  /// No description provided for @wifiPasswordPrefix.
  ///
  /// In en, this message translates to:
  /// **';T:WPA;P:'**
  String get wifiPasswordPrefix;

  /// No description provided for @emptySpace.
  ///
  /// In en, this message translates to:
  /// **' '**
  String get emptySpace;

  /// No description provided for @unknownNull.
  ///
  /// In en, this message translates to:
  /// **'Unknown (null)'**
  String get unknownNull;

  /// No description provided for @unknownType.
  ///
  /// In en, this message translates to:
  /// **'Unknown type: '**
  String get unknownType;

  /// No description provided for @textPrefix.
  ///
  /// In en, this message translates to:
  /// **'Text: '**
  String get textPrefix;

  /// No description provided for @textSuffix.
  ///
  /// In en, this message translates to:
  /// **' (Language: '**
  String get textSuffix;

  /// No description provided for @uriPrefix.
  ///
  /// In en, this message translates to:
  /// **'URI: '**
  String get uriPrefix;

  /// No description provided for @mimePrefix.
  ///
  /// In en, this message translates to:
  /// **'MIME: '**
  String get mimePrefix;

  /// No description provided for @absoluteUriPrefix.
  ///
  /// In en, this message translates to:
  /// **'Absolute URI: '**
  String get absoluteUriPrefix;

  /// No description provided for @rawPrefix.
  ///
  /// In en, this message translates to:
  /// **'Raw: '**
  String get rawPrefix;

  /// No description provided for @emptyPayload.
  ///
  /// In en, this message translates to:
  /// **'Empty payload'**
  String get emptyPayload;

  /// No description provided for @binaryDataPrefix.
  ///
  /// In en, this message translates to:
  /// **'Binary data ('**
  String get binaryDataPrefix;

  /// No description provided for @binaryDataSuffix.
  ///
  /// In en, this message translates to:
  /// **' bytes): '**
  String get binaryDataSuffix;

  /// No description provided for @errorDecodingRecord.
  ///
  /// In en, this message translates to:
  /// **'Error decoding record: '**
  String get errorDecodingRecord;

  /// No description provided for @noNdefRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No NDEF records found'**
  String get noNdefRecordsFound;

  /// No description provided for @recordPrefix.
  ///
  /// In en, this message translates to:
  /// **'Record '**
  String get recordPrefix;

  /// No description provided for @recordSuffix.
  ///
  /// In en, this message translates to:
  /// **':'**
  String get recordSuffix;

  /// No description provided for @tnfLabel.
  ///
  /// In en, this message translates to:
  /// **'TNF: '**
  String get tnfLabel;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type: '**
  String get typeLabel;

  /// No description provided for @payloadSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Payload Size: '**
  String get payloadSizeLabel;

  /// No description provided for @bytesLabel.
  ///
  /// In en, this message translates to:
  /// **' bytes'**
  String get bytesLabel;

  /// No description provided for @contentLabel.
  ///
  /// In en, this message translates to:
  /// **'Content: '**
  String get contentLabel;

  /// No description provided for @rawPayloadLabel.
  ///
  /// In en, this message translates to:
  /// **'Raw Payload: '**
  String get rawPayloadLabel;

  /// No description provided for @nullPayload.
  ///
  /// In en, this message translates to:
  /// **'null'**
  String get nullPayload;

  /// No description provided for @closingParenthesis.
  ///
  /// In en, this message translates to:
  /// **')'**
  String get closingParenthesis;

  /// No description provided for @closingParenthesisNewline.
  ///
  /// In en, this message translates to:
  /// **')\n'**
  String get closingParenthesisNewline;

  /// No description provided for @scanYourNfcTag.
  ///
  /// In en, this message translates to:
  /// **'Scan your NFC tag'**
  String get scanYourNfcTag;

  /// No description provided for @scanYourNfcTagToWrite.
  ///
  /// In en, this message translates to:
  /// **'Scan your NFC tag to write'**
  String get scanYourNfcTagToWrite;

  /// No description provided for @scanYourNfcTagToClear.
  ///
  /// In en, this message translates to:
  /// **'Scan your NFC tag to clear'**
  String get scanYourNfcTagToClear;

  /// No description provided for @scanTagToVerifyContent.
  ///
  /// In en, this message translates to:
  /// **'Scan tag to verify content'**
  String get scanTagToVerifyContent;

  /// No description provided for @tagIsNotNdefCompatible.
  ///
  /// In en, this message translates to:
  /// **'Tag is not NDEF compatible'**
  String get tagIsNotNdefCompatible;

  /// No description provided for @tagDoesNotSupportNdef.
  ///
  /// In en, this message translates to:
  /// **'Tag does not support NDEF'**
  String get tagDoesNotSupportNdef;

  /// No description provided for @tagIsNotWritable.
  ///
  /// In en, this message translates to:
  /// **'Tag is not writable'**
  String get tagIsNotWritable;

  /// No description provided for @tagDoesNotSupportNdefCannotClear.
  ///
  /// In en, this message translates to:
  /// **'Tag does not support NDEF, cannot clear'**
  String get tagDoesNotSupportNdefCannotClear;

  /// No description provided for @tagIsNotWritableCannotClear.
  ///
  /// In en, this message translates to:
  /// **'Tag is not writable, cannot clear'**
  String get tagIsNotWritableCannotClear;

  /// No description provided for @readOperationCompleted.
  ///
  /// In en, this message translates to:
  /// **'Read operation completed'**
  String get readOperationCompleted;

  /// No description provided for @writeOperationCompleted.
  ///
  /// In en, this message translates to:
  /// **'Write operation completed'**
  String get writeOperationCompleted;

  /// No description provided for @clearOperationCompleted.
  ///
  /// In en, this message translates to:
  /// **'Clear operation completed'**
  String get clearOperationCompleted;

  /// No description provided for @ndefRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'NDEF records found: '**
  String get ndefRecordsFound;

  /// No description provided for @theTagIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'The tag is empty'**
  String get theTagIsEmpty;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record '**
  String get record;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type: '**
  String get type;

  /// No description provided for @tnf.
  ///
  /// In en, this message translates to:
  /// **'TNF: '**
  String get tnf;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content: '**
  String get content;

  /// No description provided for @noRecordsToWrite.
  ///
  /// In en, this message translates to:
  /// **'No records to write'**
  String get noRecordsToWrite;

  /// No description provided for @ndefRecordsWrittenSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'NDEF records written successfully'**
  String get ndefRecordsWrittenSuccessfully;

  /// No description provided for @recordsWritten.
  ///
  /// In en, this message translates to:
  /// **'Records written: '**
  String get recordsWritten;

  /// No description provided for @writtenRecord.
  ///
  /// In en, this message translates to:
  /// **'Written record '**
  String get writtenRecord;

  /// No description provided for @tagClearedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Tag cleared successfully'**
  String get tagClearedSuccessfully;

  /// No description provided for @method.
  ///
  /// In en, this message translates to:
  /// **'Method: '**
  String get method;

  /// No description provided for @tagIsNowReadyForNewData.
  ///
  /// In en, this message translates to:
  /// **'Tag is now ready for new data'**
  String get tagIsNowReadyForNewData;

  /// No description provided for @emptyTextRecord.
  ///
  /// In en, this message translates to:
  /// **'Empty text record'**
  String get emptyTextRecord;

  /// No description provided for @emptyNdefRecord.
  ///
  /// In en, this message translates to:
  /// **'Empty NDEF record'**
  String get emptyNdefRecord;

  /// No description provided for @minimalSpaceCharacter.
  ///
  /// In en, this message translates to:
  /// **'Minimal space character'**
  String get minimalSpaceCharacter;

  /// No description provided for @emptyRecordList.
  ///
  /// In en, this message translates to:
  /// **'Empty record list'**
  String get emptyRecordList;

  /// No description provided for @allClearingMethodsFailed.
  ///
  /// In en, this message translates to:
  /// **'All clearing methods failed: '**
  String get allClearingMethodsFailed;

  /// No description provided for @verificationResults.
  ///
  /// In en, this message translates to:
  /// **'Verification Results:'**
  String get verificationResults;

  /// No description provided for @recordsFound.
  ///
  /// In en, this message translates to:
  /// **'Records found: '**
  String get recordsFound;

  /// No description provided for @noNdefRecordsFoundOnTag.
  ///
  /// In en, this message translates to:
  /// **'No NDEF records found on tag'**
  String get noNdefRecordsFoundOnTag;

  /// No description provided for @theTagIsEmptyCleared.
  ///
  /// In en, this message translates to:
  /// **'The tag is empty/cleared'**
  String get theTagIsEmptyCleared;

  /// No description provided for @errorReadingTag.
  ///
  /// In en, this message translates to:
  /// **'Error reading tag: '**
  String get errorReadingTag;

  /// No description provided for @errorWritingToTag.
  ///
  /// In en, this message translates to:
  /// **'Error writing to tag: '**
  String get errorWritingToTag;

  /// No description provided for @errorClearingTag.
  ///
  /// In en, this message translates to:
  /// **'Error clearing tag: '**
  String get errorClearingTag;

  /// No description provided for @verificationError.
  ///
  /// In en, this message translates to:
  /// **'Verification error: '**
  String get verificationError;

  /// No description provided for @holdTagCloseAndTryAgain.
  ///
  /// In en, this message translates to:
  /// **'. Hold tag close and try again'**
  String get holdTagCloseAndTryAgain;

  /// No description provided for @tryHoldingTagCloser.
  ///
  /// In en, this message translates to:
  /// **'. Try holding tag closer'**
  String get tryHoldingTagCloser;

  /// No description provided for @tryMovingTagCloser.
  ///
  /// In en, this message translates to:
  /// **'. Try moving tag closer'**
  String get tryMovingTagCloser;

  /// No description provided for @method1EmptyTextRecordFailed.
  ///
  /// In en, this message translates to:
  /// **'Method 1 (empty text record) failed: '**
  String get method1EmptyTextRecordFailed;

  /// No description provided for @method2EmptyNdefRecordFailed.
  ///
  /// In en, this message translates to:
  /// **'Method 2 (empty NDEF record) failed: '**
  String get method2EmptyNdefRecordFailed;

  /// No description provided for @method3MinimalRecordFailed.
  ///
  /// In en, this message translates to:
  /// **'Method 3 (minimal record) failed: '**
  String get method3MinimalRecordFailed;

  /// No description provided for @method4EmptyListFailed.
  ///
  /// In en, this message translates to:
  /// **'Method 4 (empty list) failed: '**
  String get method4EmptyListFailed;

  /// No description provided for @errorFinishingNfcSession.
  ///
  /// In en, this message translates to:
  /// **'Error finishing NFC session: '**
  String get errorFinishingNfcSession;

  /// No description provided for @secondaryCleanupAlsoFailed.
  ///
  /// In en, this message translates to:
  /// **'Secondary cleanup also failed: '**
  String get secondaryCleanupAlsoFailed;

  /// No description provided for @multipleTagsFoundPleaseSelectOne.
  ///
  /// In en, this message translates to:
  /// **'Multiple tags found, please select one'**
  String get multipleTagsFoundPleaseSelectOne;

  /// No description provided for @scanYourNfcTagDefault.
  ///
  /// In en, this message translates to:
  /// **'Scan your NFC tag'**
  String get scanYourNfcTagDefault;

  /// No description provided for @readNdefTags.
  ///
  /// In en, this message translates to:
  /// **'Read NDEF Tags'**
  String get readNdefTags;

  /// No description provided for @reading.
  ///
  /// In en, this message translates to:
  /// **'Reading...'**
  String get reading;

  /// No description provided for @readNfcTag.
  ///
  /// In en, this message translates to:
  /// **'Read NFC Tag'**
  String get readNfcTag;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @clearing.
  ///
  /// In en, this message translates to:
  /// **'Clearing...'**
  String get clearing;

  /// No description provided for @clearNfcTag.
  ///
  /// In en, this message translates to:
  /// **'Clear NFC Tag'**
  String get clearNfcTag;

  /// No description provided for @monospaceFontFamily.
  ///
  /// In en, this message translates to:
  /// **'monospace'**
  String get monospaceFontFamily;

  /// No description provided for @nfcStatus.
  ///
  /// In en, this message translates to:
  /// **'NFC Status'**
  String get nfcStatus;

  /// No description provided for @refreshNfcStatus.
  ///
  /// In en, this message translates to:
  /// **'Refresh NFC Status'**
  String get refreshNfcStatus;

  /// No description provided for @writeNdefRecords.
  ///
  /// In en, this message translates to:
  /// **'Write NDEF Records'**
  String get writeNdefRecords;

  /// No description provided for @textRecord.
  ///
  /// In en, this message translates to:
  /// **'Text Record'**
  String get textRecord;

  /// No description provided for @enterTextToWriteToNfcTag.
  ///
  /// In en, this message translates to:
  /// **'Enter text to write to NFC tag'**
  String get enterTextToWriteToNfcTag;

  /// No description provided for @writing.
  ///
  /// In en, this message translates to:
  /// **'Writing...'**
  String get writing;

  /// No description provided for @writeText.
  ///
  /// In en, this message translates to:
  /// **'Write Text'**
  String get writeText;

  /// No description provided for @urlRecord.
  ///
  /// In en, this message translates to:
  /// **'URL Record'**
  String get urlRecord;

  /// No description provided for @enterUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter URL'**
  String get enterUrl;

  /// No description provided for @writeUrl.
  ///
  /// In en, this message translates to:
  /// **'Write URL'**
  String get writeUrl;

  /// No description provided for @wifiRecord.
  ///
  /// In en, this message translates to:
  /// **'WiFi Record'**
  String get wifiRecord;

  /// No description provided for @wifiNetworkNameSsid.
  ///
  /// In en, this message translates to:
  /// **'WiFi Network Name (SSID)'**
  String get wifiNetworkNameSsid;

  /// No description provided for @wifiPassword.
  ///
  /// In en, this message translates to:
  /// **'WiFi Password'**
  String get wifiPassword;

  /// No description provided for @writeWifi.
  ///
  /// In en, this message translates to:
  /// **'Write WiFi'**
  String get writeWifi;

  /// No description provided for @writeAllRecords.
  ///
  /// In en, this message translates to:
  /// **'Write All Records'**
  String get writeAllRecords;

  /// No description provided for @writeAllNonEmptyFieldsDescription.
  ///
  /// In en, this message translates to:
  /// **'Write all non-empty fields to the NFC tag at once'**
  String get writeAllNonEmptyFieldsDescription;

  /// No description provided for @writeMultipleRecords.
  ///
  /// In en, this message translates to:
  /// **'Write Multiple Records'**
  String get writeMultipleRecords;

  /// No description provided for @readOperationFailed.
  ///
  /// In en, this message translates to:
  /// **'Read operation failed'**
  String get readOperationFailed;

  /// No description provided for @tagReadSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Tag read successfully'**
  String get tagReadSuccessfully;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verificationFailed;

  /// No description provided for @tagVerifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Tag verified successfully'**
  String get tagVerifiedSuccessfully;

  /// No description provided for @clearNfcTagConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear this NFC tag? This action cannot be undone.'**
  String get clearNfcTagConfirmation;

  /// No description provided for @clearOperationFailed.
  ///
  /// In en, this message translates to:
  /// **'Clear operation failed'**
  String get clearOperationFailed;

  /// No description provided for @writeOperationFailed.
  ///
  /// In en, this message translates to:
  /// **'Write operation failed'**
  String get writeOperationFailed;

  /// No description provided for @dataWrittenSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Data written successfully'**
  String get dataWrittenSuccessfully;

  /// No description provided for @nfcNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'NFC Not Available'**
  String get nfcNotAvailable;

  /// No description provided for @enableNfcMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enable NFC in your device settings to use this feature.'**
  String get enableNfcMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @successfully.
  ///
  /// In en, this message translates to:
  /// **'successfully'**
  String get successfully;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @exportXbm.
  ///
  /// In en, this message translates to:
  /// **'Export XBM'**
  String get exportXbm;

  /// No description provided for @fullRefresh.
  ///
  /// In en, this message translates to:
  /// **'Full Refresh'**
  String get fullRefresh;

  /// No description provided for @fullRefreshSelected.
  ///
  /// In en, this message translates to:
  /// **'Full Refresh Selected'**
  String get fullRefreshSelected;

  /// No description provided for @waveformSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get waveformSelected;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @templates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get templates;

  /// No description provided for @barcodeGenerator.
  ///
  /// In en, this message translates to:
  /// **'Barcode Generator'**
  String get barcodeGenerator;

  /// No description provided for @barcodeData.
  ///
  /// In en, this message translates to:
  /// **'Barcode Data'**
  String get barcodeData;

  /// No description provided for @barcodeDataHint.
  ///
  /// In en, this message translates to:
  /// **'Enter barcode number or SKU'**
  String get barcodeDataHint;

  /// No description provided for @characters.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get characters;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scanBarcode;

  /// No description provided for @barcodeFormat.
  ///
  /// In en, this message translates to:
  /// **'Barcode Format'**
  String get barcodeFormat;

  /// No description provided for @enterOrScanBarcodeData.
  ///
  /// In en, this message translates to:
  /// **'Enter or scan barcode data'**
  String get enterOrScanBarcodeData;

  /// No description provided for @invalidBarcode.
  ///
  /// In en, this message translates to:
  /// **'Invalid Barcode'**
  String get invalidBarcode;

  /// No description provided for @invalidCharacter.
  ///
  /// In en, this message translates to:
  /// **'Invalid character'**
  String get invalidCharacter;

  /// No description provided for @supportedCharacters.
  ///
  /// In en, this message translates to:
  /// **'Supported characters are'**
  String get supportedCharacters;

  /// No description provided for @pleaseCheckBarcodeRules.
  ///
  /// In en, this message translates to:
  /// **'Please check the barcode rules.'**
  String get pleaseCheckBarcodeRules;

  /// No description provided for @dataTooShort.
  ///
  /// In en, this message translates to:
  /// **'Data is too short. Minimum length for'**
  String get dataTooShort;

  /// No description provided for @dataTooLong.
  ///
  /// In en, this message translates to:
  /// **'Data is too long. Maximum length for'**
  String get dataTooLong;

  /// No description provided for @isText.
  ///
  /// In en, this message translates to:
  /// **'is'**
  String get isText;

  /// No description provided for @pointCameraAtBarcode.
  ///
  /// In en, this message translates to:
  /// **'Point camera at barcode to scan'**
  String get pointCameraAtBarcode;

  /// No description provided for @generateImage.
  ///
  /// In en, this message translates to:
  /// **'Generate Image'**
  String get generateImage;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// No description provided for @exportedXbmFiles.
  ///
  /// In en, this message translates to:
  /// **'Exported XBM file(s) to MagicEpaper/XBM/'**
  String get exportedXbmFiles;

  /// No description provided for @exported.
  ///
  /// In en, this message translates to:
  /// **'Exported'**
  String get exported;

  /// No description provided for @xbmFilesToMagicEpaper.
  ///
  /// In en, this message translates to:
  /// **'XBM file(s) to MagicEpaper/XBM/'**
  String get xbmFilesToMagicEpaper;

  /// No description provided for @floydSteinberg.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get floydSteinberg;

  /// No description provided for @stucki.
  ///
  /// In en, this message translates to:
  /// **'Sharp'**
  String get stucki;

  /// No description provided for @atkinson.
  ///
  /// In en, this message translates to:
  /// **'Vintage'**
  String get atkinson;

  /// No description provided for @falseFloydSteinberg.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get falseFloydSteinberg;

  /// No description provided for @halftone.
  ///
  /// In en, this message translates to:
  /// **'Newspaper'**
  String get halftone;

  /// No description provided for @threshold.
  ///
  /// In en, this message translates to:
  /// **'Posterize'**
  String get threshold;

  /// No description provided for @colorHalftone.
  ///
  /// In en, this message translates to:
  /// **'Color Newspaper'**
  String get colorHalftone;

  /// No description provided for @searchingForDevice.
  ///
  /// In en, this message translates to:
  /// **'Searching for Device'**
  String get searchingForDevice;

  /// No description provided for @displayRefreshing.
  ///
  /// In en, this message translates to:
  /// **'Display Refreshing'**
  String get displayRefreshing;

  /// No description provided for @transferComplete.
  ///
  /// In en, this message translates to:
  /// **'Transfer complete!'**
  String get transferComplete;

  /// No description provided for @writingToEpaper.
  ///
  /// In en, this message translates to:
  /// **'Writing to ePaper'**
  String get writingToEpaper;

  /// No description provided for @pleaseBringPhoneClose.
  ///
  /// In en, this message translates to:
  /// **'Please bring your phone close to the Magic ePaper device'**
  String get pleaseBringPhoneClose;

  /// No description provided for @keepPhoneClose.
  ///
  /// In en, this message translates to:
  /// **'Keep your phone close!'**
  String get keepPhoneClose;

  /// No description provided for @displayRefreshingMessage.
  ///
  /// In en, this message translates to:
  /// **'The display is refreshing. Please keep your phone near the device until the image appears completely.'**
  String get displayRefreshingMessage;

  /// No description provided for @transferFailed.
  ///
  /// In en, this message translates to:
  /// **'Transfer Failed'**
  String get transferFailed;

  /// No description provided for @deviceConnectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Device connection timed out. Please try bringing your phone closer to the device and try again.'**
  String get deviceConnectionTimeout;

  /// No description provided for @connectionLostDuringTransfer.
  ///
  /// In en, this message translates to:
  /// **'Connection was lost during transfer. Please keep your phone close to the device and try again.'**
  String get connectionLostDuringTransfer;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @processingImage.
  ///
  /// In en, this message translates to:
  /// **'Processing Image...'**
  String get processingImage;

  /// No description provided for @readyToFlash.
  ///
  /// In en, this message translates to:
  /// **'Ready to Flash'**
  String get readyToFlash;

  /// No description provided for @imageProcessedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Image processed successfully.'**
  String get imageProcessedSuccessfully;

  /// No description provided for @tapBelowAndHold.
  ///
  /// In en, this message translates to:
  /// **'Tap below and hold your phone near the display.'**
  String get tapBelowAndHold;

  /// No description provided for @startFlashing.
  ///
  /// In en, this message translates to:
  /// **'Start Flashing'**
  String get startFlashing;

  /// No description provided for @flashing.
  ///
  /// In en, this message translates to:
  /// **'Flashing...'**
  String get flashing;

  /// No description provided for @keepPhoneStill.
  ///
  /// In en, this message translates to:
  /// **'Keep your phone still.'**
  String get keepPhoneStill;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @transferCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Transfer complete!'**
  String get transferCompleteMessage;

  /// No description provided for @unknownErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get unknownErrorOccurred;

  /// No description provided for @resultsCleared.
  ///
  /// In en, this message translates to:
  /// **'Results cleared'**
  String get resultsCleared;

  /// No description provided for @clearResults.
  ///
  /// In en, this message translates to:
  /// **'Clear Results'**
  String get clearResults;

  /// No description provided for @vCardContact.
  ///
  /// In en, this message translates to:
  /// **'vCard Contact'**
  String get vCardContact;

  /// No description provided for @writingVCard.
  ///
  /// In en, this message translates to:
  /// **'Writing vCard...'**
  String get writingVCard;

  /// No description provided for @writeVCard.
  ///
  /// In en, this message translates to:
  /// **'Write vCard'**
  String get writeVCard;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @organization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get organization;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @streetAddress.
  ///
  /// In en, this message translates to:
  /// **'Street Address'**
  String get streetAddress;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @zipCode.
  ///
  /// In en, this message translates to:
  /// **'Zip Code'**
  String get zipCode;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @noSavedImagesYet.
  ///
  /// In en, this message translates to:
  /// **'No saved images yet'**
  String get noSavedImagesYet;

  /// No description provided for @saveImagesFromEditor.
  ///
  /// In en, this message translates to:
  /// **'Save images from the editor or import new ones'**
  String get saveImagesFromEditor;

  /// No description provided for @enterWifiSSID.
  ///
  /// In en, this message translates to:
  /// **'Enter WiFi SSID'**
  String get enterWifiSSID;

  /// No description provided for @enterWifiPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter WiFi password'**
  String get enterWifiPassword;

  /// No description provided for @writeMultiple.
  ///
  /// In en, this message translates to:
  /// **'Write Multiple'**
  String get writeMultiple;

  /// No description provided for @searchImages.
  ///
  /// In en, this message translates to:
  /// **'Search images...'**
  String get searchImages;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter:'**
  String get filter;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @imported.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get imported;

  /// No description provided for @editor.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get editor;

  /// No description provided for @imageLibrary.
  ///
  /// In en, this message translates to:
  /// **'Image Library'**
  String get imageLibrary;

  /// No description provided for @selectImagesToDelete.
  ///
  /// In en, this message translates to:
  /// **'Select Images to Delete'**
  String get selectImagesToDelete;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteMode.
  ///
  /// In en, this message translates to:
  /// **'Delete Mode'**
  String get deleteMode;

  /// No description provided for @deleteImage.
  ///
  /// In en, this message translates to:
  /// **'Delete Image'**
  String get deleteImage;

  /// No description provided for @thisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get thisActionCannotBeUndone;

  /// No description provided for @filterLabel.
  ///
  /// In en, this message translates to:
  /// **'Filter:'**
  String get filterLabel;

  /// No description provided for @areYouSureDeleteImage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this image? This action cannot be undone.'**
  String get areYouSureDeleteImage;

  /// No description provided for @deleteMultipleImages.
  ///
  /// In en, this message translates to:
  /// **'Delete Multiple Images'**
  String get deleteMultipleImages;

  /// No description provided for @imagesSelected.
  ///
  /// In en, this message translates to:
  /// **'image(s) selected'**
  String get imagesSelected;

  /// No description provided for @imagesSelectedForDeletion.
  ///
  /// In en, this message translates to:
  /// **'image(s) selected for deletion'**
  String get imagesSelectedForDeletion;

  /// No description provided for @areYouSureDeleteMultipleImages.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete these {count} images? This action cannot be undone.'**
  String areYouSureDeleteMultipleImages(Object count);

  /// No description provided for @areYouSureDeleteSingleImage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this image? This action cannot be undone.'**
  String get areYouSureDeleteSingleImage;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// No description provided for @renameImage.
  ///
  /// In en, this message translates to:
  /// **'Rename Image'**
  String get renameImage;

  /// No description provided for @enterNewNameForImage.
  ///
  /// In en, this message translates to:
  /// **'Enter a new name for your image'**
  String get enterNewNameForImage;

  /// No description provided for @imageName.
  ///
  /// In en, this message translates to:
  /// **'Image Name'**
  String get imageName;

  /// No description provided for @enterImageName.
  ///
  /// In en, this message translates to:
  /// **'Enter image name...'**
  String get enterImageName;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @imageProperties.
  ///
  /// In en, this message translates to:
  /// **'Image Properties'**
  String get imageProperties;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source:'**
  String get source;

  /// No description provided for @epdModel.
  ///
  /// In en, this message translates to:
  /// **'EPD Model:'**
  String get epdModel;

  /// No description provided for @transferToEpaper.
  ///
  /// In en, this message translates to:
  /// **'Transfer to ePaper'**
  String get transferToEpaper;

  /// No description provided for @saveImage.
  ///
  /// In en, this message translates to:
  /// **'Save Image'**
  String get saveImage;

  /// No description provided for @saveFilteredImageToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Save your filtered image to the library'**
  String get saveFilteredImageToLibrary;

  /// No description provided for @filterApplied.
  ///
  /// In en, this message translates to:
  /// **'Filter Applied:'**
  String get filterApplied;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @noImagesMatchSearch.
  ///
  /// In en, this message translates to:
  /// **'No images match your search'**
  String get noImagesMatchSearch;

  /// No description provided for @vCardDataCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'VCard data cannot be empty'**
  String get vCardDataCannotBeEmpty;

  /// No description provided for @renamingImage.
  ///
  /// In en, this message translates to:
  /// **'Renaming image...'**
  String get renamingImage;

  /// No description provided for @imageRenamedTo.
  ///
  /// In en, this message translates to:
  /// **'Image renamed to \"'**
  String get imageRenamedTo;

  /// No description provided for @failedToRenameImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to rename image: '**
  String get failedToRenameImage;

  /// No description provided for @deletingImage.
  ///
  /// In en, this message translates to:
  /// **'Deleting image...'**
  String get deletingImage;

  /// No description provided for @imageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Image \"'**
  String get imageDeleted;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'\" deleted'**
  String get deleted;

  /// No description provided for @failedToDeleteImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete image: '**
  String get failedToDeleteImage;

  /// No description provided for @deletingImages.
  ///
  /// In en, this message translates to:
  /// **'Deleting '**
  String get deletingImages;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **' image(s)...'**
  String get images;

  /// No description provided for @failedToDeleteImages.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete images: '**
  String get failedToDeleteImages;

  /// No description provided for @imagesDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **' images deleted successfully'**
  String get imagesDeletedSuccessfully;

  /// No description provided for @imageDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Image deleted successfully'**
  String get imageDeletedSuccessfully;

  /// No description provided for @failedToLoadImageData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image data for \"'**
  String get failedToLoadImageData;

  /// No description provided for @failedToDecodeImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to decode image \"'**
  String get failedToDecodeImage;

  /// No description provided for @failedToTransfer.
  ///
  /// In en, this message translates to:
  /// **'Failed to transfer \"'**
  String get failedToTransfer;

  /// No description provided for @savingImage.
  ///
  /// In en, this message translates to:
  /// **'Saving image...'**
  String get savingImage;

  /// No description provided for @imageSavedToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Image saved to library!'**
  String get imageSavedToLibrary;

  /// No description provided for @failedToSaveImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to save image: '**
  String get failedToSaveImage;

  /// No description provided for @errorCreatingVCardRecord.
  ///
  /// In en, this message translates to:
  /// **'Error creating vCard record: '**
  String get errorCreatingVCardRecord;

  /// No description provided for @nfcIsDisabledPleaseEnableIt.
  ///
  /// In en, this message translates to:
  /// **'NFC is disabled. Please enable it.'**
  String get nfcIsDisabledPleaseEnableIt;

  /// No description provided for @thisDeviceDoesNotSupportNfc.
  ///
  /// In en, this message translates to:
  /// **'This device does not support NFC.'**
  String get thisDeviceDoesNotSupportNfc;

  /// No description provided for @bringPhoneNearMagicEpaperHardware.
  ///
  /// In en, this message translates to:
  /// **'Bring your phone near to the Magic ePaper Hardware'**
  String get bringPhoneNearMagicEpaperHardware;

  /// No description provided for @tagDetectedInitializing.
  ///
  /// In en, this message translates to:
  /// **'Tag detected! Initializing...'**
  String get tagDetectedInitializing;

  /// No description provided for @enablingEnergyHarvesting.
  ///
  /// In en, this message translates to:
  /// **'Enabling energy harvesting...'**
  String get enablingEnergyHarvesting;

  /// No description provided for @processingImageData.
  ///
  /// In en, this message translates to:
  /// **'Processing image data...'**
  String get processingImageData;

  /// No description provided for @refreshingDisplay.
  ///
  /// In en, this message translates to:
  /// **'Refreshing display...'**
  String get refreshingDisplay;

  /// No description provided for @notMagicEpaperHardware.
  ///
  /// In en, this message translates to:
  /// **'Not a Magic ePaper Hardware'**
  String get notMagicEpaperHardware;

  /// No description provided for @errorCheckingMessage.
  ///
  /// In en, this message translates to:
  /// **'Error checking message: '**
  String get errorCheckingMessage;

  /// No description provided for @timeoutWaitingForI2cMessage.
  ///
  /// In en, this message translates to:
  /// **'Timeout waiting for I2C message'**
  String get timeoutWaitingForI2cMessage;

  /// No description provided for @writingChunk.
  ///
  /// In en, this message translates to:
  /// **'Writing chunk '**
  String get writingChunk;

  /// No description provided for @transferredSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Transferred successfully.'**
  String get transferredSuccessfully;

  /// No description provided for @waitingForNfcTag.
  ///
  /// In en, this message translates to:
  /// **'Waiting for NFC tag...'**
  String get waitingForNfcTag;

  /// No description provided for @gotTag.
  ///
  /// In en, this message translates to:
  /// **'Got a tag!'**
  String get gotTag;

  /// No description provided for @frame.
  ///
  /// In en, this message translates to:
  /// **'Frame '**
  String get frame;

  /// No description provided for @couldNotOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link.'**
  String get couldNotOpenLink;

  /// No description provided for @errorOccurredWhileOpeningLink.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while opening the link.'**
  String get errorOccurredWhileOpeningLink;

  /// No description provided for @errorCreatingAppRecord.
  ///
  /// In en, this message translates to:
  /// **'Error creating app record: '**
  String get errorCreatingAppRecord;

  /// No description provided for @appCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'App cannot be empty'**
  String get appCannotBeEmpty;

  /// No description provided for @invalidPackageName.
  ///
  /// In en, this message translates to:
  /// **'Invalid package name'**
  String get invalidPackageName;

  /// No description provided for @writeAppLauncherData.
  ///
  /// In en, this message translates to:
  /// **'Write App Launcher Data'**
  String get writeAppLauncherData;

  /// No description provided for @writeAppLauncher.
  ///
  /// In en, this message translates to:
  /// **'Write App Launcher'**
  String get writeAppLauncher;

  /// No description provided for @searchApps.
  ///
  /// In en, this message translates to:
  /// **'Search apps...'**
  String get searchApps;

  /// No description provided for @customPackageName.
  ///
  /// In en, this message translates to:
  /// **'Custom Package Name'**
  String get customPackageName;

  /// No description provided for @enterPackageName.
  ///
  /// In en, this message translates to:
  /// **'Enter package name...'**
  String get enterPackageName;

  /// No description provided for @noAppsFound.
  ///
  /// In en, this message translates to:
  /// **'No apps found'**
  String get noAppsFound;

  /// No description provided for @selectApplication.
  ///
  /// In en, this message translates to:
  /// **'Select Application'**
  String get selectApplication;

  /// No description provided for @errorLoadingApps.
  ///
  /// In en, this message translates to:
  /// **'Error loading apps: '**
  String get errorLoadingApps;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @readNfcTags.
  ///
  /// In en, this message translates to:
  /// **'Read NFC Tags'**
  String get readNfcTags;

  /// No description provided for @writeNfcTags.
  ///
  /// In en, this message translates to:
  /// **'Write NFC Tags'**
  String get writeNfcTags;

  /// No description provided for @nfcIsReadyToUse.
  ///
  /// In en, this message translates to:
  /// **'NFC is ready to use. You can read and write NFC tags.'**
  String get nfcIsReadyToUse;

  /// No description provided for @deviceDoesNotSupportNfc.
  ///
  /// In en, this message translates to:
  /// **'This device does not support NFC functionality.'**
  String get deviceDoesNotSupportNfc;

  /// No description provided for @pleaseEnableNfcInSettings.
  ///
  /// In en, this message translates to:
  /// **'Please enable NFC in your device settings to continue.'**
  String get pleaseEnableNfcInSettings;

  /// No description provided for @nfcIsNowEnabledAndReady.
  ///
  /// In en, this message translates to:
  /// **'NFC is now enabled and ready to use!'**
  String get nfcIsNowEnabledAndReady;

  /// No description provided for @nfcHasBeenDisabled.
  ///
  /// In en, this message translates to:
  /// **'NFC has been disabled. Please enable it to continue using NFC features.'**
  String get nfcHasBeenDisabled;

  /// No description provided for @nfcIsNotSupportedOnDevice.
  ///
  /// In en, this message translates to:
  /// **'NFC is not supported on this device.'**
  String get nfcIsNotSupportedOnDevice;

  /// No description provided for @arduinoExport.
  ///
  /// In en, this message translates to:
  /// **'Arduino Export'**
  String get arduinoExport;

  /// No description provided for @exportXmbFilesForArduino.
  ///
  /// In en, this message translates to:
  /// **'Export XMB files for Arduino'**
  String get exportXmbFilesForArduino;

  /// No description provided for @cardTemplates.
  ///
  /// In en, this message translates to:
  /// **'Card Templates'**
  String get cardTemplates;

  /// No description provided for @chooseTemplateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a template to get started'**
  String get chooseTemplateSubtitle;

  /// No description provided for @employeeIdCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee ID Card'**
  String get employeeIdCardTitle;

  /// No description provided for @employeeIdCardDescription.
  ///
  /// In en, this message translates to:
  /// **'Create professional employee identification cards'**
  String get employeeIdCardDescription;

  /// No description provided for @shopPriceTagTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop Price Tag'**
  String get shopPriceTagTitle;

  /// No description provided for @shopPriceTagDescription.
  ///
  /// In en, this message translates to:
  /// **'Design attractive price tags for your products'**
  String get shopPriceTagDescription;

  /// No description provided for @entryPassTagTitle.
  ///
  /// In en, this message translates to:
  /// **'Entry Pass Tag'**
  String get entryPassTagTitle;

  /// No description provided for @entryPassTagDescription.
  ///
  /// In en, this message translates to:
  /// **'Generate entry passes for events and venues'**
  String get entryPassTagDescription;

  /// No description provided for @eventBadgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Badge'**
  String get eventBadgeTitle;

  /// No description provided for @eventBadgeDescription.
  ///
  /// In en, this message translates to:
  /// **'Create personalized event badges and name tags'**
  String get eventBadgeDescription;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @comingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'This template is currently under development and will be available soon.'**
  String get comingSoonMessage;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @defaultCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get defaultCompanyName;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @positionLabel.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get positionLabel;

  /// No description provided for @divisionLabel.
  ///
  /// In en, this message translates to:
  /// **'Division'**
  String get divisionLabel;

  /// No description provided for @idLabel.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get idLabel;

  /// No description provided for @emptyFieldPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get emptyFieldPlaceholder;

  /// No description provided for @productImage.
  ///
  /// In en, this message translates to:
  /// **'Product Image'**
  String get productImage;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @sizeQuantity.
  ///
  /// In en, this message translates to:
  /// **'Size/Quantity'**
  String get sizeQuantity;

  /// No description provided for @defaultCurrency.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get defaultCurrency;

  /// No description provided for @defaultPrice.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get defaultPrice;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @quantitySize.
  ///
  /// In en, this message translates to:
  /// **'Quantity/Size'**
  String get quantitySize;

  /// No description provided for @quantitySizeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter size/quantity (e.g., 750ml, 2kg, Large)'**
  String get quantitySizeHint;

  /// No description provided for @namePrefix.
  ///
  /// In en, this message translates to:
  /// **'Name: '**
  String get namePrefix;

  /// No description provided for @positionPrefix.
  ///
  /// In en, this message translates to:
  /// **'Position: '**
  String get positionPrefix;

  /// No description provided for @divisionPrefix.
  ///
  /// In en, this message translates to:
  /// **'Division: '**
  String get divisionPrefix;

  /// No description provided for @idPrefix.
  ///
  /// In en, this message translates to:
  /// **'ID: '**
  String get idPrefix;

  /// No description provided for @employeeIdCard.
  ///
  /// In en, this message translates to:
  /// **'Employee ID Card'**
  String get employeeIdCard;

  /// No description provided for @fillDetailsToCreateId.
  ///
  /// In en, this message translates to:
  /// **'Fill in the details below to create your employee ID card'**
  String get fillDetailsToCreateId;

  /// No description provided for @idCardDetails.
  ///
  /// In en, this message translates to:
  /// **'ID Card Details'**
  String get idCardDetails;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @enterCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Enter company name'**
  String get enterCompanyName;

  /// No description provided for @pleaseEnterCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Please enter company name'**
  String get pleaseEnterCompanyName;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterEmployeeName.
  ///
  /// In en, this message translates to:
  /// **'Enter employee name'**
  String get enterEmployeeName;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter name'**
  String get pleaseEnterName;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @enterJobPosition.
  ///
  /// In en, this message translates to:
  /// **'Enter job position'**
  String get enterJobPosition;

  /// No description provided for @pleaseEnterPosition.
  ///
  /// In en, this message translates to:
  /// **'Please enter position'**
  String get pleaseEnterPosition;

  /// No description provided for @division.
  ///
  /// In en, this message translates to:
  /// **'Division'**
  String get division;

  /// No description provided for @enterDepartment.
  ///
  /// In en, this message translates to:
  /// **'Enter department'**
  String get enterDepartment;

  /// No description provided for @pleaseEnterDivision.
  ///
  /// In en, this message translates to:
  /// **'Please enter division'**
  String get pleaseEnterDivision;

  /// No description provided for @idNumber.
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get idNumber;

  /// No description provided for @enterUniqueId.
  ///
  /// In en, this message translates to:
  /// **'Enter unique ID'**
  String get enterUniqueId;

  /// No description provided for @pleaseEnterIdNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter ID number'**
  String get pleaseEnterIdNumber;

  /// No description provided for @qrCodeData.
  ///
  /// In en, this message translates to:
  /// **'QR Code Data'**
  String get qrCodeData;

  /// No description provided for @enterQrCodeData.
  ///
  /// In en, this message translates to:
  /// **'Enter QR code data'**
  String get enterQrCodeData;

  /// No description provided for @pleaseEnterQrCodeData.
  ///
  /// In en, this message translates to:
  /// **'Please enter QR code data'**
  String get pleaseEnterQrCodeData;

  /// No description provided for @generatingIdCard.
  ///
  /// In en, this message translates to:
  /// **'Generating ID Card...'**
  String get generatingIdCard;

  /// No description provided for @generateIdCard.
  ///
  /// In en, this message translates to:
  /// **'Generate ID Card'**
  String get generateIdCard;

  /// No description provided for @profilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profilePhoto;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @photoSelected.
  ///
  /// In en, this message translates to:
  /// **'Photo selected'**
  String get photoSelected;

  /// No description provided for @selectProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Select Profile Photo'**
  String get selectProfilePhoto;

  /// No description provided for @tapToChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to change photo'**
  String get tapToChangePhoto;

  /// No description provided for @tapToSelectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Tap to select from gallery'**
  String get tapToSelectFromGallery;

  /// No description provided for @priceTagGenerator.
  ///
  /// In en, this message translates to:
  /// **'Price Tag Generator'**
  String get priceTagGenerator;

  /// No description provided for @priceTagDescription.
  ///
  /// In en, this message translates to:
  /// **'Create professional price tags for your products'**
  String get priceTagDescription;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// No description provided for @productNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter product name (e.g., iPhone 15 Pro)'**
  String get productNameHint;

  /// No description provided for @pleaseEnterProductName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a product name'**
  String get pleaseEnterProductName;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @currencyHint.
  ///
  /// In en, this message translates to:
  /// **'₹'**
  String get currencyHint;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @priceHint.
  ///
  /// In en, this message translates to:
  /// **'999.99'**
  String get priceHint;

  /// No description provided for @pleaseEnterPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter price'**
  String get pleaseEnterPrice;

  /// No description provided for @pleaseEnterQuantitySize.
  ///
  /// In en, this message translates to:
  /// **'Please enter quantity or size'**
  String get pleaseEnterQuantitySize;

  /// No description provided for @pleaseEnterBarcodeData.
  ///
  /// In en, this message translates to:
  /// **'Please enter barcode data'**
  String get pleaseEnterBarcodeData;

  /// No description provided for @generatingPriceTag.
  ///
  /// In en, this message translates to:
  /// **'Generating Price Tag...'**
  String get generatingPriceTag;

  /// No description provided for @generatePriceTag.
  ///
  /// In en, this message translates to:
  /// **'Generate Price Tag'**
  String get generatePriceTag;

  /// No description provided for @productImageIn.
  ///
  /// In en, this message translates to:
  /// **'Product Image'**
  String get productImageIn;

  /// No description provided for @productImageSelected.
  ///
  /// In en, this message translates to:
  /// **'Product Image Selected'**
  String get productImageSelected;

  /// No description provided for @selectProductImage.
  ///
  /// In en, this message translates to:
  /// **'Select Product Image'**
  String get selectProductImage;

  /// No description provided for @tapToChangeImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to change image'**
  String get tapToChangeImage;

  /// No description provided for @chooseImageFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose image from gallery'**
  String get chooseImageFromGallery;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'he',
        'hi',
        'id',
        'ja',
        'nb',
        'pt',
        'ru',
        'uk',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'nb':
      {
        switch (locale.countryCode) {
          case 'NO':
            return AppLocalizationsNbNo();
        }
        break;
      }
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'nb':
      return AppLocalizationsNb();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
