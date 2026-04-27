// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Magic ePaper';

  @override
  String get aboutUsDescription =>
      'Magic ePaper ist eine App, die zur Steuerung und Aktualisierung von ePaper-Displays entwickelt wurde. Das Ziel ist es, Werkzeuge für die Anpassung und Übertragung von Bildern, Text und Mustern auf ePaper-Bildschirme über NFC bereitzustellen. Die Datenübertragung vom Smartphone zur ePaper-Hardware erfolgt drahtlos über NFC. Das Projekt basiert auf benutzerdefinierter Firmware und Display-Treibern für nahtlose Kommunikation und effizientes Bild-Rendering.';

  @override
  String get developedBy => 'Entwickelt von';

  @override
  String get fossasiaContributors => 'Mitwirkende von FOSSASIA';

  @override
  String get contactWithUs => 'Kontaktiere uns';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle =>
      'Forke das Repo und pushe Änderungen oder reiche neue Issues ein.';

  @override
  String get license => 'Lizenz';

  @override
  String get licenseSubtitle =>
      'Überprüfen Sie die Bedingungen der Apache License 2.0, die bei Magic ePaper verwendet werden.';

  @override
  String get createTransfer => 'Bilder erstellen & übertragen';

  @override
  String get ndefScreen => 'Ndef';

  @override
  String get selectDisplayType => 'Wählen Sie Ihren ePaper-Displaytyp';

  @override
  String get settings => 'Einstellungen';

  @override
  String get aboutUs => 'Über uns';

  @override
  String get other => 'Sonstiges';

  @override
  String get getBadge => 'Abzeichen erhalten';

  @override
  String get feedbackBugReports => 'Feedback / Fehlerberichte';

  @override
  String get continueButton => 'Weiter';

  @override
  String get noImageSelectedFeedback => 'Importieren Sie zuerst ein Bild!';

  @override
  String get adjustButtonLabel => 'Anpassen';

  @override
  String get importImageButtonLabel => 'Importieren';

  @override
  String get openEditor => 'Erstellen';

  @override
  String get importStartingImageFeedback =>
      'Importieren Sie ein Bild, um zu beginnen';

  @override
  String get transferButtonLabel => 'Übertragen';

  @override
  String get filterScreenTitle => 'Wählen Sie einen Filter';

  @override
  String get scanningForNfcTag => 'Suche nach NFC-Tag...';

  @override
  String get scanningForNfcTagToWrite => 'Suche nach NFC-Tag zum Schreiben...';

  @override
  String get scanningForNfcTagToClear => 'Suche nach NFC-Tag zum Löschen...';

  @override
  String get scanningTagForVerification => 'Tag zur Überprüfung scannen...';

  @override
  String get errorCreatingTextRecord =>
      'Fehler beim Erstellen des Textdatensatzes: ';

  @override
  String get errorCreatingUrlRecord =>
      'Fehler beim Erstellen des URL-Datensatzes: ';

  @override
  String get errorCreatingWifiRecord =>
      'Fehler beim Erstellen des WLAN-Datensatzes: ';

  @override
  String get errorCreatingMultipleRecords =>
      'Fehler beim Erstellen mehrerer Datensätze: ';

  @override
  String get pleaseEnterAtLeastOneRecord =>
      'Bitte geben Sie mindestens einen Datensatz ein';

  @override
  String get tagType => 'Tag-Typ: ';

  @override
  String get tagId => 'Tag-ID: ';

  @override
  String get ndefAvailable => 'NDEF verfügbar: ';

  @override
  String get ndefWritable => 'NDEF beschreibbar: ';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get textCannotBeEmpty => 'Text darf nicht leer sein';

  @override
  String get urlCannotBeEmpty => 'URL darf nicht leer sein';

  @override
  String get wifiSsidCannotBeEmpty => 'WLAN-SSID darf nicht leer sein';

  @override
  String get defaultLanguage => 'de';

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
  String get unknownNull => 'Unbekannt (null)';

  @override
  String get unknownType => 'Unbekannter Typ: ';

  @override
  String get textPrefix => 'Text: ';

  @override
  String get textSuffix => ' (Sprache: ';

  @override
  String get uriPrefix => 'URI: ';

  @override
  String get mimePrefix => 'MIME: ';

  @override
  String get absoluteUriPrefix => 'Absolute URI: ';

  @override
  String get rawPrefix => 'Rohdaten: ';

  @override
  String get emptyPayload => 'Leere Nutzdaten';

  @override
  String get binaryDataPrefix => 'Binärdaten (';

  @override
  String get binaryDataSuffix => ' Bytes): ';

  @override
  String get errorDecodingRecord => 'Fehler beim Dekodieren des Datensatzes: ';

  @override
  String get noNdefRecordsFound => 'Keine NDEF-Datensätze gefunden';

  @override
  String get recordPrefix => 'Datensatz ';

  @override
  String get recordSuffix => ':';

  @override
  String get tnfLabel => 'TNF: ';

  @override
  String get typeLabel => 'Typ: ';

  @override
  String get payloadSizeLabel => 'Nutzdatengröße: ';

  @override
  String get bytesLabel => ' Bytes';

  @override
  String get contentLabel => 'Inhalt: ';

  @override
  String get rawPayloadLabel => 'Roh-Nutzdaten: ';

  @override
  String get nullPayload => 'null';

  @override
  String get closingParenthesis => ')';

  @override
  String get closingParenthesisNewline => ')\n';

  @override
  String get scanYourNfcTag => 'Scannen Sie Ihr NFC-Tag';

  @override
  String get scanYourNfcTagToWrite => 'NFC-Tag zum Schreiben scannen';

  @override
  String get scanYourNfcTagToClear => 'NFC-Tag zum Löschen scannen';

  @override
  String get scanTagToVerifyContent =>
      'Tag zur Überprüfung des Inhalts scannen';

  @override
  String get tagIsNotNdefCompatible => 'Tag ist nicht NDEF-kompatibel';

  @override
  String get tagDoesNotSupportNdef => 'Tag unterstützt kein NDEF';

  @override
  String get tagIsNotWritable => 'Tag ist nicht beschreibbar';

  @override
  String get tagDoesNotSupportNdefCannotClear =>
      'Tag unterstützt kein NDEF, Löschen nicht möglich';

  @override
  String get tagIsNotWritableCannotClear =>
      'Tag ist nicht beschreibbar, Löschen nicht möglich';

  @override
  String get readOperationCompleted => 'Lesevorgang abgeschlossen';

  @override
  String get writeOperationCompleted => 'Schreibvorgang abgeschlossen';

  @override
  String get clearOperationCompleted => 'Löschvorgang abgeschlossen';

  @override
  String get ndefRecordsFound => 'NDEF-Datensätze gefunden: ';

  @override
  String get theTagIsEmpty => 'Das Tag ist leer';

  @override
  String get record => 'Datensatz ';

  @override
  String get type => 'Typ: ';

  @override
  String get tnf => 'TNF: ';

  @override
  String get content => 'Inhalt: ';

  @override
  String get noRecordsToWrite => 'Keine Datensätze zum Schreiben';

  @override
  String get ndefRecordsWrittenSuccessfully =>
      'NDEF-Datensätze erfolgreich geschrieben';

  @override
  String get recordsWritten => 'Geschriebene Datensätze: ';

  @override
  String get writtenRecord => 'Geschriebener Datensatz ';

  @override
  String get tagClearedSuccessfully => 'Tag erfolgreich gelöscht';

  @override
  String get method => 'Methode: ';

  @override
  String get tagIsNowReadyForNewData => 'Tag ist nun bereit für neue Daten';

  @override
  String get emptyTextRecord => 'Leerer Textdatensatz';

  @override
  String get emptyNdefRecord => 'Leerer NDEF-Datensatz';

  @override
  String get minimalSpaceCharacter => 'Minimales Leerzeichen';

  @override
  String get emptyRecordList => 'Leere Datensatzliste';

  @override
  String get allClearingMethodsFailed => 'Alle Löschmethoden fehlgeschlagen: ';

  @override
  String get verificationResults => 'Überprüfungsergebnisse:';

  @override
  String get recordsFound => 'Gefundene Datensätze: ';

  @override
  String get noNdefRecordsFoundOnTag =>
      'Keine NDEF-Datensätze auf dem Tag gefunden';

  @override
  String get theTagIsEmptyCleared => 'Das Tag ist leer/gelöscht';

  @override
  String get errorReadingTag => 'Fehler beim Lesen des Tags: ';

  @override
  String get errorWritingToTag => 'Fehler beim Schreiben auf das Tag: ';

  @override
  String get errorClearingTag => 'Fehler beim Löschen des Tags: ';

  @override
  String get verificationError => 'Überprüfungsfehler: ';

  @override
  String get holdTagCloseAndTryAgain =>
      '. Halten Sie das Tag nah heran und versuchen Sie es erneut';

  @override
  String get tryHoldingTagCloser =>
      '. Versuchen Sie, das Tag näher heranzuhalten';

  @override
  String get tryMovingTagCloser =>
      '. Versuchen Sie, das Tag näher heranzubewegen';

  @override
  String get method1EmptyTextRecordFailed =>
      'Methode 1 (leerer Textdatensatz) fehlgeschlagen: ';

  @override
  String get method2EmptyNdefRecordFailed =>
      'Methode 2 (leerer NDEF-Datensatz) fehlgeschlagen: ';

  @override
  String get method3MinimalRecordFailed =>
      'Methode 3 (minimaler Datensatz) fehlgeschlagen: ';

  @override
  String get method4EmptyListFailed =>
      'Methode 4 (leere Liste) fehlgeschlagen: ';

  @override
  String get errorFinishingNfcSession =>
      'Fehler beim Beenden der NFC-Sitzung: ';

  @override
  String get secondaryCleanupAlsoFailed =>
      'Sekundäre Bereinigung ebenfalls fehlgeschlagen: ';

  @override
  String get multipleTagsFoundPleaseSelectOne =>
      'Mehrere Tags gefunden, bitte wählen Sie eines aus';

  @override
  String get scanYourNfcTagDefault => 'Scannen Sie Ihr NFC-Tag';

  @override
  String get readNdefTags => 'NDEF-Tags lesen';

  @override
  String get reading => 'Lese...';

  @override
  String get readNfcTag => 'NFC-Tag lesen';

  @override
  String get verify => 'Überprüfen';

  @override
  String get clearing => 'Lösche...';

  @override
  String get clearNfcTag => 'NFC-Tag löschen';

  @override
  String get monospaceFontFamily => 'monospace';

  @override
  String get nfcStatus => 'NFC-Status';

  @override
  String get refreshNfcStatus => 'NFC-Status aktualisieren';

  @override
  String get writeNdefRecords => 'NDEF-Datensätze schreiben';

  @override
  String get textRecord => 'Textdatensatz';

  @override
  String get enterTextToWriteToNfcTag => 'Text für das NFC-Tag eingeben';

  @override
  String get writing => 'Schreibe...';

  @override
  String get writeText => 'Text schreiben';

  @override
  String get urlRecord => 'URL-Datensatz';

  @override
  String get enterUrl => 'URL eingeben';

  @override
  String get writeUrl => 'URL schreiben';

  @override
  String get wifiRecord => 'WLAN-Datensatz';

  @override
  String get wifiNetworkNameSsid => 'WLAN-Netzwerkname (SSID)';

  @override
  String get wifiPassword => 'WLAN-Passwort';

  @override
  String get writeWifi => 'WLAN schreiben';

  @override
  String get writeAllRecords => 'Alle Datensätze schreiben';

  @override
  String get writeAllNonEmptyFieldsDescription =>
      'Alle nicht leeren Felder gleichzeitig auf das NFC-Tag schreiben';

  @override
  String get writeMultipleRecords => 'Mehrere Datensätze schreiben';

  @override
  String get readOperationFailed => 'Lesevorgang fehlgeschlagen';

  @override
  String get tagReadSuccessfully => 'Tag erfolgreich gelesen';

  @override
  String get verificationFailed => 'Überprüfung fehlgeschlagen';

  @override
  String get tagVerifiedSuccessfully => 'Tag erfolgreich überprüft';

  @override
  String get clearNfcTagConfirmation =>
      'Sind Sie sicher, dass Sie dieses NFC-Tag löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get clearOperationFailed => 'Löschvorgang fehlgeschlagen';

  @override
  String get writeOperationFailed => 'Schreibvorgang fehlgeschlagen';

  @override
  String get dataWrittenSuccessfully => 'Daten erfolgreich geschrieben';

  @override
  String get nfcNotAvailable => 'NFC nicht verfügbar';

  @override
  String get enableNfcMessage =>
      'Bitte aktivieren Sie NFC in Ihren Geräteeinstellungen, um diese Funktion zu nutzen.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get error => 'Fehler';

  @override
  String get successfully => 'erfolgreich';

  @override
  String get language => 'Sprache';

  @override
  String get loading => 'Wird geladen...';

  @override
  String get exportXbm => 'XBM exportieren';

  @override
  String get exportingXbm => 'XBM-Dateien werden exportiert...';

  @override
  String get fullRefresh => 'Vollständige Aktualisierung';

  @override
  String get fullRefreshSelected => 'Vollständige Aktualisierung ausgewählt';

  @override
  String get waveformSelected => 'Ausgewählt';

  @override
  String get barcode => 'Barcode';

  @override
  String get library => 'Bibliothek';

  @override
  String get templates => 'Vorlagen';

  @override
  String get barcodeGenerator => 'Barcode-Generator';

  @override
  String get barcodeData => 'Barcode-Daten';

  @override
  String get barcodeDataHint => 'Barcode-Nummer oder SKU eingeben';

  @override
  String get characters => 'Zeichen';

  @override
  String get scanBarcode => 'Barcode scannen';

  @override
  String get barcodeFormat => 'Barcode-Format';

  @override
  String get enterOrScanBarcodeData => 'Barcode-Daten eingeben oder scannen';

  @override
  String get invalidBarcode => 'Ungültiger Barcode';

  @override
  String get invalidCharacter => 'Ungültiges Zeichen';

  @override
  String get supportedCharacters => 'Unterstützte Zeichen sind';

  @override
  String get pleaseCheckBarcodeRules =>
      'Bitte überprüfen Sie die Barcode-Regeln.';

  @override
  String get dataTooShort => 'Daten sind zu kurz. Mindestlänge für';

  @override
  String get dataTooLong => 'Daten sind zu lang. Maximallänge für';

  @override
  String get isText => 'ist';

  @override
  String get pointCameraAtBarcode =>
      'Kamera zum Scannen auf den Barcode richten';

  @override
  String get generateImage => 'Bild generieren';

  @override
  String get exportFailed => 'Export fehlgeschlagen';

  @override
  String get exportedXbmFiles =>
      'Exportierte XBM-Datei(en) nach MagicEpaper/XBM/';

  @override
  String get exported => 'Exportiert';

  @override
  String get xbmFilesToMagicEpaper => 'XBM-Datei(en) nach MagicEpaper/XBM/';

  @override
  String get floydSteinberg => 'Klassisch';

  @override
  String get stucki => 'Scharf';

  @override
  String get atkinson => 'Vintage';

  @override
  String get falseFloydSteinberg => 'Einfach';

  @override
  String get halftone => 'Zeitung';

  @override
  String get threshold => 'Tontrennung';

  @override
  String get colorHalftone => 'Farbzeitung';

  @override
  String get searchingForDevice => 'Suche nach Gerät';

  @override
  String get displayRefreshing => 'Display wird aktualisiert';

  @override
  String get transferComplete => 'Übertragung abgeschlossen!';

  @override
  String get writingToEpaper => 'Schreibe auf ePaper';

  @override
  String get pleaseBringPhoneClose =>
      'Bitte halten Sie Ihr Telefon nah an das Magic ePaper-Gerät';

  @override
  String get keepPhoneClose => 'Halten Sie Ihr Telefon nah dran!';

  @override
  String get displayRefreshingMessage =>
      'Das Display wird aktualisiert. Bitte halten Sie Ihr Telefon in der Nähe des Geräts, bis das Bild vollständig erscheint.';

  @override
  String get transferFailed => 'Übertragung fehlgeschlagen';

  @override
  String get deviceConnectionTimeout =>
      'Zeitüberschreitung bei der Geräteverbindung. Bitte versuchen Sie, Ihr Telefon näher an das Gerät zu halten, und versuchen Sie es erneut.';

  @override
  String get connectionLostDuringTransfer =>
      'Verbindung wurde während der Übertragung getrennt. Bitte halten Sie Ihr Telefon in der Nähe des Geräts und versuchen Sie es erneut.';

  @override
  String get done => 'Fertig';

  @override
  String get close => 'Schließen';

  @override
  String get processingImage => 'Bild wird verarbeitet...';

  @override
  String get readyToFlash => 'Bereit zum Flashen';

  @override
  String get imageProcessedSuccessfully => 'Bild erfolgreich verarbeitet.';

  @override
  String get tapBelowAndHold =>
      'Tippen Sie unten und halten Sie Ihr Telefon in die Nähe des Displays.';

  @override
  String get startFlashing => 'Flashen starten';

  @override
  String get flashing => 'Flasht...';

  @override
  String get keepPhoneStill => 'Halten Sie Ihr Telefon ruhig.';

  @override
  String get success => 'Erfolg!';

  @override
  String get transferCompleteMessage => 'Übertragung abgeschlossen!';

  @override
  String get unknownErrorOccurred => 'Ein unbekannter Fehler ist aufgetreten.';

  @override
  String get resultsCleared => 'Ergebnisse gelöscht';

  @override
  String get clearResults => 'Ergebnisse löschen';

  @override
  String get vCardContact => 'vCard-Kontakt';

  @override
  String get writingVCard => 'Schreibe vCard...';

  @override
  String get writeVCard => 'vCard schreiben';

  @override
  String get firstName => 'Vorname';

  @override
  String get lastName => 'Nachname';

  @override
  String get organization => 'Organisation';

  @override
  String get title => 'Titel';

  @override
  String get mobileNumber => 'Handynummer';

  @override
  String get emailAddress => 'E-Mail-Adresse';

  @override
  String get streetAddress => 'Straße und Hausnummer';

  @override
  String get city => 'Stadt';

  @override
  String get zipCode => 'Postleitzahl';

  @override
  String get country => 'Land';

  @override
  String get website => 'Webseite';

  @override
  String get noSavedImagesYet => 'Noch keine gespeicherten Bilder';

  @override
  String get saveImagesFromEditor =>
      'Bilder aus dem Editor speichern oder neue importieren';

  @override
  String get enterWifiSSID => 'WLAN-SSID eingeben';

  @override
  String get enterWifiPassword => 'WLAN-Passwort eingeben';

  @override
  String get writeMultiple => 'Mehrere schreiben';

  @override
  String get searchImages => 'Bilder suchen...';

  @override
  String get filter => 'Filter:';

  @override
  String get all => 'Alle';

  @override
  String get imported => 'Importiert';

  @override
  String get editor => 'Editor';

  @override
  String get imageLibrary => 'Bildbibliothek';

  @override
  String get selectImagesToDelete => 'Bilder zum Löschen auswählen';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteMode => 'Löschmodus';

  @override
  String get deleteImage => 'Bild löschen';

  @override
  String get thisActionCannotBeUndone =>
      'Diese Aktion kann nicht rückgängig gemacht werden';

  @override
  String get filterLabel => 'Filter:';

  @override
  String get areYouSureDeleteImage =>
      'Sind Sie sicher, dass Sie dieses Bild löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get deleteMultipleImages => 'Mehrere Bilder löschen';

  @override
  String get imagesSelected => 'Bild(er) ausgewählt';

  @override
  String get imagesSelectedForDeletion => 'Bild(er) zum Löschen ausgewählt';

  @override
  String areYouSureDeleteMultipleImages(Object count) {
    return 'Sind Sie sicher, dass Sie diese $count Bilder löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get areYouSureDeleteSingleImage =>
      'Sind Sie sicher, dass Sie dieses Bild löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get deleteAll => 'Alle löschen';

  @override
  String get renameImage => 'Bild umbenennen';

  @override
  String get enterNewNameForImage =>
      'Geben Sie einen neuen Namen für Ihr Bild ein';

  @override
  String get imageName => 'Bildname';

  @override
  String get enterImageName => 'Bildnamen eingeben...';

  @override
  String get rename => 'Umbenennen';

  @override
  String get imageProperties => 'Bildeigenschaften';

  @override
  String get created => 'Erstellt';

  @override
  String get source => 'Quelle:';

  @override
  String get epdModel => 'EPD-Modell:';

  @override
  String get transferToEpaper => 'Auf ePaper übertragen';

  @override
  String get saveImage => 'Bild speichern';

  @override
  String get saveFilteredImageToLibrary =>
      'Speichern Sie Ihr gefiltertes Bild in der Bibliothek';

  @override
  String get filterApplied => 'Angewandter Filter:';

  @override
  String get save => 'Speichern';

  @override
  String get noImagesMatchSearch => 'Keine Bilder entsprechen Ihrer Suche';

  @override
  String get vCardDataCannotBeEmpty => 'vCard-Daten dürfen nicht leer sein';

  @override
  String get renamingImage => 'Bild wird umbenannt...';

  @override
  String get imageRenamedTo => 'Bild umbenannt in \"';

  @override
  String get failedToRenameImage => 'Fehler beim Umbenennen des Bildes: ';

  @override
  String get deletingImage => 'Bild wird gelöscht...';

  @override
  String get imageDeleted => 'Bild \"';

  @override
  String get deleted => '\" gelöscht';

  @override
  String get failedToDeleteImage => 'Fehler beim Löschen des Bildes: ';

  @override
  String get deletingImages => 'Lösche ';

  @override
  String get images => ' Bild(er)...';

  @override
  String get failedToDeleteImages => 'Fehler beim Löschen der Bilder: ';

  @override
  String get imagesDeletedSuccessfully => ' Bilder erfolgreich gelöscht';

  @override
  String get imageDeletedSuccessfully => 'Bild erfolgreich gelöscht';

  @override
  String get failedToLoadImageData =>
      'Bilddaten konnten nicht geladen werden für \"';

  @override
  String get failedToDecodeImage => 'Bild konnte nicht dekodiert werden \"';

  @override
  String get failedToTransfer => 'Übertragung fehlgeschlagen \"';

  @override
  String get savingImage => 'Bild wird gespeichert...';

  @override
  String get imageSavedToLibrary => 'Bild in der Bibliothek gespeichert!';

  @override
  String get failedToSaveImage => 'Fehler beim Speichern des Bildes: ';

  @override
  String get errorCreatingVCardRecord =>
      'Fehler beim Erstellen des vCard-Datensatzes: ';

  @override
  String get nfcIsDisabledPleaseEnableIt =>
      'NFC ist deaktiviert. Bitte aktivieren Sie es.';

  @override
  String get thisDeviceDoesNotSupportNfc =>
      'Dieses Gerät unterstützt kein NFC.';

  @override
  String get bringPhoneNearMagicEpaperHardware =>
      'Halten Sie Ihr Telefon in die Nähe der Magic ePaper-Hardware';

  @override
  String get tagDetectedInitializing => 'Tag erkannt! Initialisiere...';

  @override
  String get enablingEnergyHarvesting => 'Energy Harvesting wird aktiviert...';

  @override
  String get processingImageData => 'Bilddaten werden verarbeitet...';

  @override
  String get refreshingDisplay => 'Display wird aktualisiert...';

  @override
  String get notMagicEpaperHardware => 'Keine Magic ePaper-Hardware';

  @override
  String get errorCheckingMessage => 'Fehler beim Überprüfen der Nachricht: ';

  @override
  String get timeoutWaitingForI2cMessage =>
      'Zeitüberschreitung beim Warten auf I2C-Nachricht';

  @override
  String get writingChunk => 'Schreibe Block ';

  @override
  String get transferredSuccessfully => 'Erfolgreich übertragen.';

  @override
  String get waitingForNfcTag => 'Warten auf NFC-Tag...';

  @override
  String get gotTag => 'Tag erhalten!';

  @override
  String get frame => 'Rahmen ';

  @override
  String get couldNotOpenLink => 'Der Link konnte nicht geöffnet werden.';

  @override
  String get errorOccurredWhileOpeningLink =>
      'Beim Öffnen des Links ist ein Fehler aufgetreten.';

  @override
  String get errorCreatingAppRecord =>
      'Fehler beim Erstellen des App-Datensatzes: ';

  @override
  String get appCannotBeEmpty => 'App darf nicht leer sein';

  @override
  String get invalidPackageName => 'Ungültiger Paketname';

  @override
  String get writeAppLauncherData => 'App-Launcher-Daten schreiben';

  @override
  String get writeAppLauncher => 'App-Launcher schreiben';

  @override
  String get searchApps => 'Apps suchen...';

  @override
  String get customPackageName => 'Benutzerdefinierter Paketname';

  @override
  String get enterPackageName => 'Paketnamen eingeben...';

  @override
  String get noAppsFound => 'Keine Apps gefunden';

  @override
  String get selectApplication => 'Anwendung auswählen';

  @override
  String get errorLoadingApps => 'Fehler beim Laden der Apps: ';

  @override
  String get add => 'Hinzufügen';

  @override
  String get readNfcTags => 'NFC-Tags lesen';

  @override
  String get writeNfcTags => 'NFC-Tags schreiben';

  @override
  String get nfcIsReadyToUse =>
      'NFC ist einsatzbereit. Sie können NFC-Tags lesen und schreiben.';

  @override
  String get deviceDoesNotSupportNfc =>
      'Dieses Gerät unterstützt keine NFC-Funktionalität.';

  @override
  String get pleaseEnableNfcInSettings =>
      'Bitte aktivieren Sie NFC in Ihren Geräteeinstellungen, um fortzufahren.';

  @override
  String get nfcIsNowEnabledAndReady =>
      'NFC ist jetzt aktiviert und einsatzbereit!';

  @override
  String get nfcHasBeenDisabled =>
      'NFC wurde deaktiviert. Bitte aktivieren Sie es, um die NFC-Funktionen weiter zu nutzen.';

  @override
  String get nfcIsNotSupportedOnDevice =>
      'NFC wird auf diesem Gerät nicht unterstützt.';

  @override
  String get arduinoExport => 'Arduino-Export';

  @override
  String get exportXmbFilesForArduino => 'XMB-Dateien für Arduino exportieren';

  @override
  String get cardTemplates => 'Karten-Vorlagen';

  @override
  String get chooseTemplateSubtitle => 'Wählen Sie eine Vorlage, um loszulegen';

  @override
  String get employeeIdCardTitle => 'Mitarbeiterausweis';

  @override
  String get employeeIdCardDescription =>
      'Erstellen Sie professionelle Mitarbeiterausweise';

  @override
  String get shopPriceTagTitle => 'Preisschild';

  @override
  String get shopPriceTagDescription =>
      'Gestalten Sie ansprechende Preisschilder für Ihre Produkte';

  @override
  String get entryPassTagTitle => 'Eintrittskarte';

  @override
  String get entryPassTagDescription =>
      'Erstellen Sie Eintrittskarten für Veranstaltungen und Orte';

  @override
  String get eventBadgeTitle => 'Veranstaltungs-Badge';

  @override
  String get eventBadgeDescription =>
      'Erstellen Sie personalisierte Veranstaltungs-Badges und Namensschilder';

  @override
  String get comingSoon => 'Demnächst verfügbar';

  @override
  String get comingSoonMessage =>
      'Diese Vorlage befindet sich derzeit in Entwicklung und wird bald verfügbar sein.';

  @override
  String get ok => 'OK';

  @override
  String get defaultCompanyName => 'Firmenname';

  @override
  String get nameLabel => 'Name';

  @override
  String get positionLabel => 'Position';

  @override
  String get divisionLabel => 'Abteilung';

  @override
  String get idLabel => 'ID';

  @override
  String get emptyFieldPlaceholder => 'Nicht angegeben';

  @override
  String get productImage => 'Produktbild';

  @override
  String get productName => 'Produktname';

  @override
  String get sizeQuantity => 'Größe/Menge';

  @override
  String get defaultCurrency => '€';

  @override
  String get defaultPrice => '0,00';

  @override
  String get price => 'Preis';

  @override
  String get quantitySize => 'Menge/Größe';

  @override
  String get quantitySizeHint => 'Größe/Menge eingeben (z.B. 750ml, 2kg, Groß)';

  @override
  String get namePrefix => 'Name: ';

  @override
  String get positionPrefix => 'Position: ';

  @override
  String get divisionPrefix => 'Abteilung: ';

  @override
  String get idPrefix => 'ID: ';

  @override
  String get employeeIdCard => 'Mitarbeiterausweis';

  @override
  String get fillDetailsToCreateId =>
      'Füllen Sie die untenstehenden Details aus, um Ihren Mitarbeiterausweis zu erstellen';

  @override
  String get idCardDetails => 'Ausweisdetails';

  @override
  String get companyName => 'Firmenname';

  @override
  String get enterCompanyName => 'Firmennamen eingeben';

  @override
  String get pleaseEnterCompanyName => 'Bitte Firmennamen eingeben';

  @override
  String get name => 'Name';

  @override
  String get enterEmployeeName => 'Mitarbeiternamen eingeben';

  @override
  String get pleaseEnterName => 'Bitte Namen eingeben';

  @override
  String get position => 'Position';

  @override
  String get enterJobPosition => 'Berufsposition eingeben';

  @override
  String get pleaseEnterPosition => 'Bitte Position eingeben';

  @override
  String get division => 'Abteilung';

  @override
  String get enterDepartment => 'Abteilung eingeben';

  @override
  String get pleaseEnterDivision => 'Bitte Abteilung eingeben';

  @override
  String get idNumber => 'ID-Nummer';

  @override
  String get enterUniqueId => 'Eindeutige ID eingeben';

  @override
  String get pleaseEnterIdNumber => 'Bitte ID-Nummer eingeben';

  @override
  String get qrCodeData => 'QR-Code-Daten';

  @override
  String get enterQrCodeData => 'QR-Code-Daten eingeben';

  @override
  String get pleaseEnterQrCodeData => 'Bitte QR-Code-Daten eingeben';

  @override
  String get generatingIdCard => 'Ausweis wird generiert...';

  @override
  String get generateIdCard => 'Ausweis generieren';

  @override
  String get profilePhoto => 'Profilfoto';

  @override
  String get selected => 'Ausgewählt';

  @override
  String get photoSelected => 'Foto ausgewählt';

  @override
  String get selectProfilePhoto => 'Profilfoto auswählen';

  @override
  String get tapToChangePhoto => 'Tippen, um Foto zu ändern';

  @override
  String get tapToSelectFromGallery => 'Tippen, um aus Galerie auszuwählen';

  @override
  String get priceTagGenerator => 'Preisschild-Generator';

  @override
  String get priceTagDescription =>
      'Erstellen Sie professionelle Preisschilder für Ihre Produkte';

  @override
  String get productDetails => 'Produktdetails';

  @override
  String get productNameHint => 'Produktname eingeben (z.B. iPhone 15 Pro)';

  @override
  String get pleaseEnterProductName => 'Bitte einen Produktnamen eingeben';

  @override
  String get currency => 'Währung';

  @override
  String get currencyHint => '€';

  @override
  String get required => 'Erforderlich';

  @override
  String get priceHint => '999,99';

  @override
  String get pleaseEnterPrice => 'Bitte Preis eingeben';

  @override
  String get pleaseEnterQuantitySize => 'Bitte Menge oder Größe eingeben';

  @override
  String get pleaseEnterBarcodeData => 'Bitte Barcode-Daten eingeben';

  @override
  String get generatingPriceTag => 'Preisschild wird generiert...';

  @override
  String get generatePriceTag => 'Preisschild generieren';

  @override
  String get productImageIn => 'Produktbild';

  @override
  String get productImageSelected => 'Produktbild ausgewählt';

  @override
  String get selectProductImage => 'Produktbild auswählen';

  @override
  String get tapToChangeImage => 'Tippen, um Bild zu ändern';

  @override
  String get chooseImageFromGallery => 'Bild aus Galerie auswählen';

  @override
  String get processingImages => 'Bilder werden verarbeitet...';

  @override
  String get refreshModeInfo => 'Informationen zum Aktualisierungsmodus';

  @override
  String get fullRefreshInfo => 'Vollständige Aktualisierung';

  @override
  String get fullRefreshDescription =>
      'Aktualisiert das gesamte Display vollständig, indem alle Pixel gelöscht und das Bild neu gezeichnet wird. Dies bietet die beste Bildqualität und den besten Kontrast, dauert jedoch länger.';

  @override
  String get partialRefreshInfo => 'Teilweise Aktualisierung (Wellenformen)';

  @override
  String get partialRefreshDescription =>
      'Aktualisiert nur die geänderten Pixel mithilfe optimierter Wellenformen. Dies ist schneller als eine vollständige Aktualisierung, kann jedoch im Laufe der Zeit zu Ghosting oder verringertem Kontrast führen.';

  @override
  String get longPressForInfo => 'Für weitere Informationen lange drücken';
}
