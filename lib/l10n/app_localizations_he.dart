// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appName => 'Magic ePaper';

  @override
  String get aboutUsDescription =>
      'Magic ePaper היא אפליקציה שנועדה לשלוט ולעדכן תצוגות ePaper. המטרה היא לספק כלים להתאמה אישית והעברת תמונות, טקסט ותבניות למסכי ePaper באמצעות NFC. העברת הנתונים מהסמארטפון לחומרת ה-ePaper נעשית באופן אלחוטי דרך NFC. הפרויקט בנוי על קושחה מותאמת אישית ומנהלי התקן תצוגה לתקשורת חלקה ועיבוד תמונה יעיל.';

  @override
  String get developedBy => 'פותח על ידי';

  @override
  String get fossasiaContributors => 'תורמי FOSSASIA';

  @override
  String get contactWithUs => 'צור איתנו קשר';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle =>
      'פצל (Fork) את המאגר ודחף שינויים או הגש בעיות (issues) חדשות.';

  @override
  String get license => 'רישיון';

  @override
  String get licenseSubtitle =>
      'בדוק את תנאי רישיון Apache 2.0 המשמשים ב-Magic ePaper.';

  @override
  String get createTransfer => 'יצירה והעברת תמונות';

  @override
  String get ndefScreen => 'Ndef';

  @override
  String get selectDisplayType => 'בחר את סוג תצוגת ה-ePaper שלך';

  @override
  String get settings => 'הגדרות';

  @override
  String get aboutUs => 'עלינו';

  @override
  String get other => 'אחר';

  @override
  String get getBadge => 'קבל תג';

  @override
  String get feedbackBugReports => 'משוב / דיווח על באגים';

  @override
  String get continueButton => 'המשך';

  @override
  String get noImageSelectedFeedback => 'ייבא תמונה תחילה!';

  @override
  String get adjustButtonLabel => 'התאם';

  @override
  String get importImageButtonLabel => 'ייבוא';

  @override
  String get openEditor => 'צור';

  @override
  String get importStartingImageFeedback => 'ייבא תמונה כדי להתחיל';

  @override
  String get transferButtonLabel => 'העבר';

  @override
  String get filterScreenTitle => 'בחר מסנן';

  @override
  String get scanningForNfcTag => 'סורק עבור תג NFC...';

  @override
  String get scanningForNfcTagToWrite => 'סורק תג NFC לכתיבה...';

  @override
  String get scanningForNfcTagToClear => 'סורק תג NFC למחיקה...';

  @override
  String get scanningTagForVerification => 'סורק תג לאימות...';

  @override
  String get errorCreatingTextRecord => 'שגיאה ביצירת רשומת טקסט: ';

  @override
  String get errorCreatingUrlRecord => 'שגיאה ביצירת רשומת URL: ';

  @override
  String get errorCreatingWifiRecord => 'שגיאה ביצירת רשומת WiFi: ';

  @override
  String get errorCreatingMultipleRecords => 'שגיאה ביצירת רשומות מרובות: ';

  @override
  String get pleaseEnterAtLeastOneRecord => 'אנא הזן לפחות רשומה אחת לכתיבה';

  @override
  String get tagType => 'סוג תג: ';

  @override
  String get tagId => 'מזהה תג: ';

  @override
  String get ndefAvailable => 'NDEF זמין: ';

  @override
  String get ndefWritable => 'NDEF ניתן לכתיבה: ';

  @override
  String get unknown => 'לא ידוע';

  @override
  String get textCannotBeEmpty => 'הטקסט אינו יכול להיות ריק';

  @override
  String get urlCannotBeEmpty => 'ה-URL אינו יכול להיות ריק';

  @override
  String get wifiSsidCannotBeEmpty => 'ה-SSID של ה-WiFi אינו יכול להיות ריק';

  @override
  String get defaultLanguage => 'he';

  @override
  String get httpsPrefix => 'https://';

  @override
  String get httpPrefix => 'http://';

  @override
  String get wifiConfigFormat => 'WIFI:T:WPA;S:';

  @override
  String get wifiConfigSuffix => ';;';

  @override
  String get wifiPasswordPrefix => ';P:';

  @override
  String get emptySpace => ' ';

  @override
  String get unknownNull => 'לא ידוע (null)';

  @override
  String get unknownType => 'סוג לא ידוע (';

  @override
  String get textPrefix => 'טקסט: \"';

  @override
  String get textSuffix => '\" (שפה: ';

  @override
  String get uriPrefix => 'URI: ';

  @override
  String get mimePrefix => 'MIME: ';

  @override
  String get absoluteUriPrefix => 'URI מוחלט: ';

  @override
  String get rawPrefix => 'גולמי: ';

  @override
  String get emptyPayload => 'מטען (Payload) ריק';

  @override
  String get binaryDataPrefix => 'נתונים בינאריים (';

  @override
  String get binaryDataSuffix => ' בתים): ';

  @override
  String get errorDecodingRecord => 'שגיאה בפענוח רשומה: ';

  @override
  String get noNdefRecordsFound => 'לא נמצאו רשומות NDEF על התג\nהתג ריק.';

  @override
  String get recordPrefix => '📄 רשומה ';

  @override
  String get recordSuffix => ':';

  @override
  String get tnfLabel => '  TNF: ';

  @override
  String get typeLabel => '  סוג: ';

  @override
  String get payloadSizeLabel => '  גודל מטען: ';

  @override
  String get bytesLabel => ' בתים';

  @override
  String get contentLabel => '  תוכן: ';

  @override
  String get rawPayloadLabel => '  מטען גולמי: ';

  @override
  String get nullPayload => 'null';

  @override
  String get closingParenthesis => ')';

  @override
  String get closingParenthesisNewline => ')\n';

  @override
  String get scanYourNfcTag => 'סרוק את תג ה-NFC שלך';

  @override
  String get scanYourNfcTagToWrite => 'סרוק את תג ה-NFC שלך לכתיבה';

  @override
  String get scanYourNfcTagToClear => 'סרוק את תג ה-NFC שלך למחיקה';

  @override
  String get scanTagToVerifyContent => 'סרוק תג לאימות תוכן';

  @override
  String get tagIsNotNdefCompatible => 'התג אינו תואם NDEF';

  @override
  String get tagDoesNotSupportNdef => 'התג אינו תומך ב-NDEF';

  @override
  String get tagIsNotWritable => 'התג אינו ניתן לכתיבה';

  @override
  String get tagDoesNotSupportNdefCannotClear =>
      'התג אינו תומך ב-NDEF - לא ניתן למחוק';

  @override
  String get tagIsNotWritableCannotClear =>
      'התג אינו ניתן לכתיבה - לא ניתן למחוק';

  @override
  String get readOperationCompleted => 'פעולת הקריאה הושלמה';

  @override
  String get writeOperationCompleted => 'פעולת הכתיבה הושלמה';

  @override
  String get clearOperationCompleted => 'פעולת המחיקה הושלמה';

  @override
  String get ndefRecordsFound => 'רשומות NDEF שנמצאו: ';

  @override
  String get theTagIsEmpty => 'התג ריק (אין רשומות NDEF).';

  @override
  String get record => 'רשומה ';

  @override
  String get type => '  סוג: ';

  @override
  String get tnf => '  TNF: ';

  @override
  String get content => '  תוכן: ';

  @override
  String get noRecordsToWrite => 'אין רשומות לכתיבה';

  @override
  String get ndefRecordsWrittenSuccessfully => '✅ רשומות NDEF נכתבו בהצלחה!';

  @override
  String get recordsWritten => 'רשומות שנכתבו: ';

  @override
  String get writtenRecord => 'רשומה שנכתבה ';

  @override
  String get tagClearedSuccessfully => '🗑️ התג נמחק בהצלחה!';

  @override
  String get method => 'שיטה: ';

  @override
  String get tagIsNowReadyForNewData => 'התג מוכן כעת לנתונים חדשים.';

  @override
  String get emptyTextRecord => 'רשומת טקסט ריקה';

  @override
  String get emptyNdefRecord => 'רשומת NDEF ריקה';

  @override
  String get minimalSpaceCharacter => 'תו רווח מינימלי';

  @override
  String get emptyRecordList => 'רשימת רשומות ריקה';

  @override
  String get allClearingMethodsFailed => 'כל שיטות המחיקה נכשלו: ';

  @override
  String get verificationResults => '🔍 תוצאות אימות:';

  @override
  String get recordsFound => 'רשומות שנמצאו: ';

  @override
  String get noNdefRecordsFoundOnTag => '✅ לא נמצאו רשומות NDEF על התג';

  @override
  String get theTagIsEmptyCleared => 'התג ריק (נמחק בהצלחה).';

  @override
  String get errorReadingTag => 'שגיאה בקריאת התג: ';

  @override
  String get errorWritingToTag => 'שגיאה בכתיבה לתג: ';

  @override
  String get errorClearingTag => 'שגיאה במחיקת התג: ';

  @override
  String get verificationError => 'שגיאת אימות: ';

  @override
  String get holdTagCloseAndTryAgain =>
      '\n\nהחזק את התג קרוב לאנטנת ה-NFC ונסה שוב.';

  @override
  String get tryHoldingTagCloser =>
      '\n\nנסה להחזיק את התג קרוב יותר לאנטנת ה-NFC.';

  @override
  String get tryMovingTagCloser => '\n\nנסה לקרב את התג לאנטנת ה-NFC.';

  @override
  String get method1EmptyTextRecordFailed => 'שיטה 1 (רשומת טקסט ריקה) נכשלה: ';

  @override
  String get method2EmptyNdefRecordFailed => 'שיטה 2 (רשומת NDEF ריקה) נכשלה: ';

  @override
  String get method3MinimalRecordFailed => 'שיטה 3 (רשומה מינימלית) נכשלה: ';

  @override
  String get method4EmptyListFailed => 'שיטה 4 (רשימה ריקה) נכשלה: ';

  @override
  String get errorFinishingNfcSession => 'שגיאה בסיום הפעלת NFC: ';

  @override
  String get secondaryCleanupAlsoFailed => 'גם הניקוי המשני נכשל: ';

  @override
  String get multipleTagsFoundPleaseSelectOne => 'נמצאו מספר תגים, אנא בחר אחד';

  @override
  String get scanYourNfcTagDefault => 'סרוק את תג ה-NFC שלך';

  @override
  String get readNdefTags => 'קרא תגי NDEF';

  @override
  String get reading => 'קורא...';

  @override
  String get readNfcTag => 'קרא תג NFC';

  @override
  String get verify => 'אמת';

  @override
  String get clearing => 'מוחק...';

  @override
  String get clearNfcTag => 'מחק תג NFC';

  @override
  String get monospaceFontFamily => 'monospace';

  @override
  String get nfcStatus => 'מצב NFC';

  @override
  String get refreshNfcStatus => 'רענן מצב NFC';

  @override
  String get writeNdefRecords => 'כתוב רשומות NDEF';

  @override
  String get textRecord => 'רשומת טקסט';

  @override
  String get enterTextToWriteToNfcTag => 'הזן טקסט לכתיבה בתג ה-NFC';

  @override
  String get writing => 'כותב...';

  @override
  String get writeText => 'כתוב טקסט';

  @override
  String get urlRecord => 'רשומת URL';

  @override
  String get enterUrl => 'הזן URL (לדוגמה, google.com';

  @override
  String get writeUrl => 'כתוב URL';

  @override
  String get wifiRecord => 'רשומת WiFi';

  @override
  String get wifiNetworkNameSsid => 'שם רשת WiFi (SSID)';

  @override
  String get wifiPassword => 'סיסמת WiFi';

  @override
  String get writeWifi => 'כתוב WiFi';

  @override
  String get writeAllRecords => 'כתוב את כל הרשומות';

  @override
  String get writeAllNonEmptyFieldsDescription =>
      'כתוב את כל השדות שאינם ריקים לתג ה-NFC בבת אחת';

  @override
  String get writeMultipleRecords => 'כתוב מספר רשומות';

  @override
  String get readOperationFailed => 'פעולת הקריאה נכשלה';

  @override
  String get tagReadSuccessfully => 'התג נקרא בהצלחה';

  @override
  String get verificationFailed => 'האימות נכשל';

  @override
  String get tagVerifiedSuccessfully => 'התג אומת בהצלחה';

  @override
  String get clearNfcTagConfirmation =>
      'האם אתה בטוח שברצונך למחוק תג NFC זה? לא ניתן לבטל פעולה זו.';

  @override
  String get clearOperationFailed => 'פעולת המחיקה נכשלה';

  @override
  String get writeOperationFailed => 'פעולת הכתיבה נכשלה';

  @override
  String get dataWrittenSuccessfully => 'הנתונים נכתבו בהצלחה לתג ה-NFC';

  @override
  String get nfcNotAvailable => 'NFC אינו זמין';

  @override
  String get enableNfcMessage =>
      'אנא הפעל NFC בהגדרות המכשיר שלך כדי להשתמש בתכונות הכתיבה.';

  @override
  String get cancel => 'ביטול';

  @override
  String get confirm => 'אישור';

  @override
  String get error => 'שגיאה';

  @override
  String get successfully => 'בהצלחה';

  @override
  String get language => 'שפה';

  @override
  String get loading => 'טוען...';

  @override
  String get exportXbm => 'ייצא XBM';

  @override
  String get exportingXbm => 'מייצא קובצי XBM...';

  @override
  String get fullRefresh => 'רענון מלא';

  @override
  String get fullRefreshSelected => 'נבחר רענון מלא';

  @override
  String get waveformSelected => 'נבחר';

  @override
  String get barcode => 'ברקוד';

  @override
  String get library => 'ספרייה';

  @override
  String get templates => 'תבניות';

  @override
  String get barcodeGenerator => 'מחולל ברקודים';

  @override
  String get barcodeData => 'נתוני ברקוד';

  @override
  String get barcodeDataHint => 'הזן נתוני ברקוד או סרוק';

  @override
  String get characters => 'תווים';

  @override
  String get scanBarcode => 'סרוק ברקוד';

  @override
  String get barcodeFormat => 'פורמט ברקוד';

  @override
  String get enterOrScanBarcodeData => 'הזן או סרוק נתוני ברקוד';

  @override
  String get invalidBarcode => 'ברקוד לא תקין';

  @override
  String get invalidCharacter => 'תו לא תקין';

  @override
  String get supportedCharacters => 'התווים הנתמכים הם';

  @override
  String get pleaseCheckBarcodeRules => 'אנא בדוק את חוקי הברקוד.';

  @override
  String get dataTooShort => 'הנתונים קצרים מדי. האורך המינימלי עבור';

  @override
  String get dataTooLong => 'הנתונים ארוכים מדי. האורך המקסימלי עבור';

  @override
  String get isText => 'הוא';

  @override
  String get pointCameraAtBarcode => 'כוון את המצלמה לברקוד כדי לסרוק';

  @override
  String get generateImage => 'צור תמונה';

  @override
  String get exportFailed => 'הייצוא נכשל';

  @override
  String get exportedXbmFiles => 'קובצי XBM יוצאו אל MagicEpaper/XBM/';

  @override
  String get exported => 'יוצא';

  @override
  String get xbmFilesToMagicEpaper => 'קובצי XBM אל MagicEpaper/XBM/';

  @override
  String get floydSteinberg => 'קלאסי';

  @override
  String get stucki => 'חד';

  @override
  String get atkinson => 'וינטג\'';

  @override
  String get falseFloydSteinberg => 'פשוט';

  @override
  String get halftone => 'עיתון';

  @override
  String get threshold => 'פוסטר';

  @override
  String get colorHalftone => 'עיתון צבעוני';

  @override
  String get searchingForDevice => 'מחפש מכשיר';

  @override
  String get displayRefreshing => 'התצוגה מתרעננת';

  @override
  String get transferComplete => 'ההעברה הושלמה';

  @override
  String get writingToEpaper => 'כותב ל-ePaper';

  @override
  String get pleaseBringPhoneClose =>
      'אנא קרב את הטלפון שלך למכשיר ה-Magic ePaper';

  @override
  String get keepPhoneClose => 'השאר את הטלפון שלך קרוב!';

  @override
  String get displayRefreshingMessage =>
      'התצוגה מתרעננת. אנא השאר את הטלפון קרוב למכשיר עד שהתמונה תופיע במלואה.';

  @override
  String get transferFailed => 'ההעברה נכשלה';

  @override
  String get deviceConnectionTimeout =>
      'זמן החיבור למכשיר פג. אנא נסה לקרב את הטלפון שלך למכשיר ונסה שוב.';

  @override
  String get connectionLostDuringTransfer =>
      'החיבור אבד במהלך ההעברה. אנא השאר את הטלפון קרוב למכשיר ונסה שוב.';

  @override
  String get done => 'סיום';

  @override
  String get close => 'סגור';

  @override
  String get processingImage => 'מעבד תמונה...';

  @override
  String get readyToFlash => 'מוכן לצריבה';

  @override
  String get imageProcessedSuccessfully => 'התמונה עובדה בהצלחה.';

  @override
  String get tapBelowAndHold => 'הקש למטה והחזק את הטלפון קרוב לתצוגה.';

  @override
  String get startFlashing => 'התחל לצרוב';

  @override
  String get flashing => 'צורב...';

  @override
  String get keepPhoneStill => 'החזק את הטלפון יציב.';

  @override
  String get success => 'הצלחה!';

  @override
  String get transferCompleteMessage => 'ההעברה הושלמה!';

  @override
  String get unknownErrorOccurred => 'אירעה שגיאה לא ידועה.';

  @override
  String get resultsCleared => 'התוצאות נוקו';

  @override
  String get clearResults => 'נקה תוצאות';

  @override
  String get vCardContact => 'איש קשר vCard';

  @override
  String get writingVCard => 'כותב vCard...';

  @override
  String get writeVCard => 'כתוב vCard';

  @override
  String get firstName => 'שם פרטי';

  @override
  String get lastName => 'שם משפחה';

  @override
  String get organization => 'ארגון';

  @override
  String get title => 'תואר';

  @override
  String get mobileNumber => 'מספר נייד';

  @override
  String get emailAddress => 'כתובת דוא\"ל';

  @override
  String get streetAddress => 'כתובת רחוב';

  @override
  String get city => 'עיר';

  @override
  String get zipCode => 'מיקוד';

  @override
  String get country => 'מדינה';

  @override
  String get website => 'אתר אינטרנט';

  @override
  String get noSavedImagesYet => 'עדיין אין תמונות שמורות';

  @override
  String get saveImagesFromEditor => 'שמור תמונות מהעורך או ייבא חדשות';

  @override
  String get enterWifiSSID => 'הזן SSID של WiFi';

  @override
  String get enterWifiPassword => 'הזן סיסמת WiFi';

  @override
  String get writeMultiple => 'כתוב מרובים';

  @override
  String get searchImages => 'חפש תמונות...';

  @override
  String get filter => 'מסנן: ';

  @override
  String get all => 'הכל';

  @override
  String get imported => 'מיובא';

  @override
  String get editor => 'עורך';

  @override
  String get imageLibrary => 'ספריית תמונות';

  @override
  String get selectImagesToDelete => 'בחר תמונות למחיקה';

  @override
  String get delete => 'מחק';

  @override
  String get deleteMode => 'מצב מחיקה';

  @override
  String get deleteImage => 'מחק תמונה';

  @override
  String get thisActionCannotBeUndone => 'לא ניתן לבטל פעולה זו';

  @override
  String get filterLabel => 'מסנן:';

  @override
  String get areYouSureDeleteImage =>
      'האם אתה בטוח שברצונך למחוק תמונה זו? לא ניתן לבטל פעולה זו.';

  @override
  String get deleteMultipleImages => 'מחק מספר תמונות';

  @override
  String get imagesSelected => 'תמונות נבחרו';

  @override
  String get imagesSelectedForDeletion => 'תמונות נבחרו למחיקה';

  @override
  String areYouSureDeleteMultipleImages(Object count) {
    return 'האם אתה בטוח שברצונך למחוק את $count התמונות הללו? לא ניתן לבטל פעולה זו.';
  }

  @override
  String get areYouSureDeleteSingleImage =>
      'האם אתה בטוח שברצונך למחוק תמונה זו? לא ניתן לבטל פעולה זו.';

  @override
  String get deleteAll => 'מחק הכל';

  @override
  String get renameImage => 'שנה שם תמונה';

  @override
  String get enterNewNameForImage => 'הזן שם חדש לתמונה שלך';

  @override
  String get imageName => 'שם התמונה';

  @override
  String get enterImageName => 'הזן שם תמונה...';

  @override
  String get rename => 'שנה שם';

  @override
  String get imageProperties => 'מאפייני תמונה';

  @override
  String get created => 'נוצר';

  @override
  String get source => 'מקור:';

  @override
  String get epdModel => 'דגם EPD:';

  @override
  String get transferToEpaper => 'העבר ל-ePaper';

  @override
  String get saveImage => 'שמור תמונה';

  @override
  String get saveFilteredImageToLibrary => 'שמור את התמונה המסוננת שלך לספרייה';

  @override
  String get filterApplied => 'מסנן הופעל:';

  @override
  String get save => 'שמור';

  @override
  String get noImagesMatchSearch => 'אין תמונות התואמות לחיפוש שלך';

  @override
  String get vCardDataCannotBeEmpty => 'נתוני ה-vCard אינם יכולים להיות ריקים';

  @override
  String get renamingImage => 'משנה שם תמונה...';

  @override
  String get imageRenamedTo => 'שם התמונה שונה ל-\"';

  @override
  String get failedToRenameImage => 'שינוי שם התמונה נכשל: ';

  @override
  String get deletingImage => 'מוחק תמונה...';

  @override
  String get imageDeleted => 'תמונה \"';

  @override
  String get deleted => '\" נמחקה';

  @override
  String get failedToDeleteImage => 'מחיקת התמונה נכשלה: ';

  @override
  String get deletingImages => 'מוחק ';

  @override
  String get images => ' תמונות...';

  @override
  String get failedToDeleteImages => 'מחיקת התמונות נכשלה: ';

  @override
  String get imagesDeletedSuccessfully => ' תמונות נמחקו בהצלחה';

  @override
  String get imageDeletedSuccessfully => 'התמונה נמחקה בהצלחה';

  @override
  String get failedToLoadImageData => 'טעינת נתוני התמונה נכשלה עבור \"';

  @override
  String get failedToDecodeImage => 'פענוח התמונה נכשל \"';

  @override
  String get failedToTransfer => 'ההעברה נכשלה עבור \"';

  @override
  String get savingImage => 'שומר תמונה...';

  @override
  String get imageSavedToLibrary => 'התמונה נשמרה בספרייה!';

  @override
  String get failedToSaveImage => 'שמירת התמונה נכשלה: ';

  @override
  String get errorCreatingVCardRecord => 'שגיאה ביצירת רשומת vCard: ';

  @override
  String get nfcIsDisabledPleaseEnableIt => 'NFC מושבת. אנא הפעל אותו.';

  @override
  String get thisDeviceDoesNotSupportNfc => 'מכשיר זה אינו תומך ב-NFC.';

  @override
  String get bringPhoneNearMagicEpaperHardware =>
      'קרב את הטלפון לחומרת ה-Magic ePaper';

  @override
  String get tagDetectedInitializing => 'התג זוהה! מאתחל...';

  @override
  String get enablingEnergyHarvesting =>
      'מפעיל קצירת אנרגיה (Energy Harvesting)...';

  @override
  String get processingImageData => 'מעבד נתוני תמונה...';

  @override
  String get refreshingDisplay => 'התצוגה מתרעננת...';

  @override
  String get notMagicEpaperHardware => 'זוהי לא חומרת Magic ePaper';

  @override
  String get errorCheckingMessage => 'שגיאה בבדיקת ההודעה: ';

  @override
  String get timeoutWaitingForI2cMessage => 'פסק זמן בהמתנה להודעת I2C';

  @override
  String get writingChunk => 'כותב מקטע ';

  @override
  String get transferredSuccessfully => 'הועבר בהצלחה.';

  @override
  String get waitingForNfcTag => 'ממתין לתג NFC...';

  @override
  String get gotTag => 'נמצא תג!';

  @override
  String get frame => 'מסגרת ';

  @override
  String get couldNotOpenLink => 'לא ניתן לפתוח את הקישור.';

  @override
  String get errorOccurredWhileOpeningLink => 'אירעה שגיאה בעת פתיחת הקישור.';

  @override
  String get errorCreatingAppRecord => 'שגיאה ביצירת רשומת אפליקציה: ';

  @override
  String get appCannotBeEmpty => 'האפליקציה אינה יכולה להיות ריקה';

  @override
  String get invalidPackageName => 'שם חבילה לא תקין';

  @override
  String get writeAppLauncherData => 'כתוב נתוני מפעיל אפליקציות';

  @override
  String get writeAppLauncher => 'כתוב מפעיל אפליקציות';

  @override
  String get searchApps => 'חפש אפליקציות...';

  @override
  String get customPackageName => 'שם חבילה מותאם אישית';

  @override
  String get enterPackageName => 'הזן שם חבילה...';

  @override
  String get noAppsFound => 'לא נמצאו אפליקציות';

  @override
  String get selectApplication => 'בחר אפליקציה';

  @override
  String get errorLoadingApps => 'שגיאה בטעינת אפליקציות: ';

  @override
  String get add => 'הוסף';

  @override
  String get readNfcTags => 'קרא תגי NFC';

  @override
  String get writeNfcTags => 'כתוב תגי NFC';

  @override
  String get nfcIsReadyToUse =>
      'NFC מוכן לשימוש. אתה יכול לקרוא ולכתוב תגי NFC.';

  @override
  String get deviceDoesNotSupportNfc => 'מכשיר זה אינו תומך בפונקציונליות NFC.';

  @override
  String get pleaseEnableNfcInSettings =>
      'אנא הפעל NFC בהגדרות המכשיר שלך כדי להמשיך.';

  @override
  String get nfcIsNowEnabledAndReady => 'NFC מופעל כעת ומוכן לשימוש!';

  @override
  String get nfcHasBeenDisabled =>
      'NFC הושבת. אנא הפעל אותו כדי להמשיך להשתמש בתכונות NFC.';

  @override
  String get nfcIsNotSupportedOnDevice => 'NFC אינו נתמך במכשיר זה.';

  @override
  String get arduinoExport => 'ייצוא Arduino';

  @override
  String get exportXmbFilesForArduino => 'ייצא קובצי XMB עבור Arduino';

  @override
  String get cardTemplates => 'תבניות כרטיסים';

  @override
  String get chooseTemplateSubtitle => 'בחר תבנית כדי להתחיל';

  @override
  String get employeeIdCardTitle => 'כרטיס זיהוי עובד';

  @override
  String get employeeIdCardDescription => 'צור כרטיסי זיהוי מקצועיים לעובדים';

  @override
  String get shopPriceTagTitle => 'תג מחיר לחנות';

  @override
  String get shopPriceTagDescription => 'עצב תגי מחיר אטרקטיביים למוצרים שלך';

  @override
  String get entryPassTagTitle => 'תג אישור כניסה';

  @override
  String get entryPassTagDescription => 'הפק אישורי כניסה לאירועים ומקומות';

  @override
  String get eventBadgeTitle => 'תג אירוע';

  @override
  String get eventBadgeDescription => 'צור תגי אירוע ותגי שם מותאמים אישית';

  @override
  String get comingSoon => 'בקרוב';

  @override
  String get comingSoonMessage =>
      'תבנית זו נמצאת כעת בפיתוח ותהיה זמינה בקרוב.';

  @override
  String get ok => 'אישור';

  @override
  String get defaultCompanyName => 'שם החברה';

  @override
  String get nameLabel => 'שם';

  @override
  String get positionLabel => 'תפקיד';

  @override
  String get divisionLabel => 'מחלקה';

  @override
  String get idLabel => 'מזהה';

  @override
  String get emptyFieldPlaceholder => 'לא צוין';

  @override
  String get productImage => 'תמונת מוצר';

  @override
  String get productName => 'Product Name';

  @override
  String get sizeQuantity => 'גודל/כמות';

  @override
  String get defaultCurrency => '₪';

  @override
  String get defaultPrice => '0.00';

  @override
  String get price => 'מחיר';

  @override
  String get quantitySize => 'Quantity/Size';

  @override
  String get quantitySizeHint =>
      'הזן גודל/כמות (לדוגמה, 750 מ\"ל, 2 ק\"ג, גדול)';

  @override
  String get namePrefix => 'שם: ';

  @override
  String get positionPrefix => 'תפקיד: ';

  @override
  String get divisionPrefix => 'מחלקה: ';

  @override
  String get idPrefix => 'מזהה: ';

  @override
  String get employeeIdCard => 'כרטיס זיהוי עובד';

  @override
  String get fillDetailsToCreateId =>
      'מלא את הפרטים להלן כדי ליצור את כרטיס זיהוי העובד שלך';

  @override
  String get idCardDetails => 'פרטי כרטיס זיהוי';

  @override
  String get companyName => 'Company Name';

  @override
  String get enterCompanyName => 'הזן שם חברה';

  @override
  String get pleaseEnterCompanyName => 'אנא הזן שם חברה';

  @override
  String get name => 'Name';

  @override
  String get enterEmployeeName => 'הזן שם עובד';

  @override
  String get pleaseEnterName => 'אנא הזן שם';

  @override
  String get position => 'Position';

  @override
  String get enterJobPosition => 'הזן תפקיד';

  @override
  String get pleaseEnterPosition => 'אנא הזן תפקיד';

  @override
  String get division => 'Division';

  @override
  String get enterDepartment => 'הזן מחלקה';

  @override
  String get pleaseEnterDivision => 'אנא הזן מחלקה';

  @override
  String get idNumber => 'ID Number';

  @override
  String get enterUniqueId => 'הזן מזהה ייחודי';

  @override
  String get pleaseEnterIdNumber => 'אנא הזן מספר מזהה';

  @override
  String get qrCodeData => 'QR Code Data';

  @override
  String get enterQrCodeData => 'הזן נתוני קוד QR';

  @override
  String get pleaseEnterQrCodeData => 'אנא הזן נתוני קוד QR';

  @override
  String get generatingIdCard => 'מייצר כרטיס זיהוי...';

  @override
  String get generateIdCard => 'צור כרטיס זיהוי';

  @override
  String get profilePhoto => 'Profile Photo';

  @override
  String get selected => 'נבחר';

  @override
  String get photoSelected => 'תמונה נבחרה';

  @override
  String get selectProfilePhoto => 'בחר תמונת פרופיל';

  @override
  String get tapToChangePhoto => 'הקש כדי לשנות תמונה';

  @override
  String get tapToSelectFromGallery => 'הקש כדי לבחור מהגלריה';

  @override
  String get priceTagGenerator => 'מחולל תגי מחיר';

  @override
  String get priceTagDescription => 'צור תגי מחיר מקצועיים למוצרים שלך';

  @override
  String get productDetails => 'Product Details';

  @override
  String get productNameHint => 'הזן שם מוצר (לדוגמה, iPhone 15 Pro)';

  @override
  String get pleaseEnterProductName => 'אנא הזן שם מוצר';

  @override
  String get currency => 'מטבע';

  @override
  String get currencyHint => '₪';

  @override
  String get required => 'חובה';

  @override
  String get priceHint => '999.99';

  @override
  String get pleaseEnterPrice => 'אנא הזן מחיר';

  @override
  String get pleaseEnterQuantitySize => 'אנא הזן כמות או גודל';

  @override
  String get pleaseEnterBarcodeData => 'אנא הזן נתוני ברקוד';

  @override
  String get generatingPriceTag => 'מייצר תג מחיר...';

  @override
  String get generatePriceTag => 'צור תג מחיר';

  @override
  String get productImageIn => 'תמונת מוצר';

  @override
  String get productImageSelected => 'תמונת מוצר נבחרה';

  @override
  String get selectProductImage => 'בחר תמונת מוצר';

  @override
  String get tapToChangeImage => 'הקש כדי לשנות תמונה';

  @override
  String get chooseImageFromGallery => 'בחר תמונה מהגלריה';

  @override
  String get processingImages => 'מעבד תמונות...';

  @override
  String get refreshModeInfo => 'מידע על מצב רענון';

  @override
  String get fullRefreshInfo => 'רענון מלא';

  @override
  String get fullRefreshDescription =>
      'מרענן לחלוטין את כל התצוגה על ידי ניקוי כל הפיקסלים וציור מחדש של התמונה. פעולה זו מספקת את איכות התמונה והניגודיות הטובות ביותר, אך אורכת יותר זמן.';

  @override
  String get partialRefreshInfo => 'רענון חלקי (צורות גל)';

  @override
  String get partialRefreshDescription =>
      'מעדכן רק את הפיקסלים שהשתנו באמצעות צורות גל ממוטבות. זה מהיר יותר מרענון מלא, אך עלול לגרום לצלליות (Ghosting) או להפחתת הניגודיות לאורך זמן.';

  @override
  String get longPressForInfo => 'לחיצה ארוכה למידע נוסף';
}
