// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appName => 'Magic ePaper';

  @override
  String get aboutUsDescription =>
      'Magic ePaper er en app designet for å kontrollere og oppdatere ePaper-skjermer. Målet er å tilby verktøy for å tilpasse og overføre bilder, tekst og mønstre til ePaper-skjermer ved hjelp av NFC. Dataoverføring fra smarttelefonen til ePaper-maskinvaren gjøres trådløst via NFC. Prosjektet bygger på tilpasset fastvare og skjermdrivere for sømløs kommunikasjon og effektiv bildegjengivelse.';

  @override
  String get developedBy => 'Utviklet av';

  @override
  String get fossasiaContributors => 'FOSSASIA-bidragsytere';

  @override
  String get contactWithUs => 'Kontakt oss';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle =>
      'Fork repoet og push endringer eller send inn nye problemer (issues).';

  @override
  String get license => 'Lisens';

  @override
  String get licenseSubtitle =>
      'Sjekk vilkårene for Apache License 2.0 som brukes på Magic ePaper.';

  @override
  String get createTransfer => 'Opprett og overfør bilder';

  @override
  String get ndefScreen => 'Ndef';

  @override
  String get selectDisplayType => 'Velg din ePaper-skjermtype';

  @override
  String get settings => 'Innstillinger';

  @override
  String get aboutUs => 'Om oss';

  @override
  String get other => 'Annet';

  @override
  String get getBadge => 'Få merke';

  @override
  String get feedbackBugReports => 'Tilbakemelding/Feilrapporter';

  @override
  String get continueButton => 'Fortsett';

  @override
  String get noImageSelectedFeedback => 'Importer et bilde først!';

  @override
  String get adjustButtonLabel => 'Juster';

  @override
  String get importImageButtonLabel => 'Importer';

  @override
  String get openEditor => 'Opprett';

  @override
  String get importStartingImageFeedback => 'Importer et bilde for å begynne';

  @override
  String get transferButtonLabel => 'Overfør';

  @override
  String get filterScreenTitle => 'Velg et filter';

  @override
  String get scanningForNfcTag => 'Søker etter NFC-brikke...';

  @override
  String get scanningForNfcTagToWrite =>
      'Søker etter NFC-brikke for skriving...';

  @override
  String get scanningForNfcTagToClear =>
      'Søker etter NFC-brikke for sletting...';

  @override
  String get scanningTagForVerification => 'Skanner brikke for verifisering...';

  @override
  String get errorCreatingTextRecord => 'Feil ved oppretting av tekstpost: ';

  @override
  String get errorCreatingUrlRecord => 'Feil ved oppretting av URL-post: ';

  @override
  String get errorCreatingWifiRecord => 'Feil ved oppretting av WiFi-post: ';

  @override
  String get errorCreatingMultipleRecords =>
      'Feil ved oppretting av flere poster: ';

  @override
  String get pleaseEnterAtLeastOneRecord => 'Vennligst skriv inn minst én post';

  @override
  String get tagType => 'Brikketype: ';

  @override
  String get tagId => 'Brikke-ID: ';

  @override
  String get ndefAvailable => 'NDEF tilgjengelig: ';

  @override
  String get ndefWritable => 'NDEF skrivbar: ';

  @override
  String get unknown => 'Ukjent';

  @override
  String get textCannotBeEmpty => 'Tekst kan ikke være tom';

  @override
  String get urlCannotBeEmpty => 'URL kan ikke være tom';

  @override
  String get wifiSsidCannotBeEmpty => 'WiFi SSID kan ikke være tom';

  @override
  String get defaultLanguage => 'nb';

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
  String get unknownNull => 'Ukjent (null)';

  @override
  String get unknownType => 'Ukjent type: ';

  @override
  String get textPrefix => 'Tekst: ';

  @override
  String get textSuffix => ' (Språk: ';

  @override
  String get uriPrefix => 'URI: ';

  @override
  String get mimePrefix => 'MIME: ';

  @override
  String get absoluteUriPrefix => 'Absolutt URI: ';

  @override
  String get rawPrefix => 'Rådata: ';

  @override
  String get emptyPayload => 'Tom nyttelast (payload)';

  @override
  String get binaryDataPrefix => 'Binærdata (';

  @override
  String get binaryDataSuffix => ' byte): ';

  @override
  String get errorDecodingRecord => 'Feil ved dekoding av post: ';

  @override
  String get noNdefRecordsFound => 'Ingen NDEF-poster funnet';

  @override
  String get recordPrefix => 'Post ';

  @override
  String get recordSuffix => ':';

  @override
  String get tnfLabel => 'TNF: ';

  @override
  String get typeLabel => 'Type: ';

  @override
  String get payloadSizeLabel => 'Størrelse på nyttelast: ';

  @override
  String get bytesLabel => ' byte';

  @override
  String get contentLabel => 'Innhold: ';

  @override
  String get rawPayloadLabel => 'Rå nyttelast: ';

  @override
  String get nullPayload => 'null';

  @override
  String get closingParenthesis => ')';

  @override
  String get closingParenthesisNewline => ')\n';

  @override
  String get scanYourNfcTag => 'Skann NFC-brikken din';

  @override
  String get scanYourNfcTagToWrite => 'Skann NFC-brikken din for å skrive';

  @override
  String get scanYourNfcTagToClear => 'Skann NFC-brikken din for å slette';

  @override
  String get scanTagToVerifyContent =>
      'Skann brikken for å verifisere innholdet';

  @override
  String get tagIsNotNdefCompatible => 'Brikken er ikke NDEF-kompatibel';

  @override
  String get tagDoesNotSupportNdef => 'Brikken støtter ikke NDEF';

  @override
  String get tagIsNotWritable => 'Brikken er ikke skrivbar';

  @override
  String get tagDoesNotSupportNdefCannotClear =>
      'Brikken støtter ikke NDEF, kan ikke slette';

  @override
  String get tagIsNotWritableCannotClear =>
      'Brikken er ikke skrivbar, kan ikke slette';

  @override
  String get readOperationCompleted => 'Leseoperasjon fullført';

  @override
  String get writeOperationCompleted => 'Skriveoperasjon fullført';

  @override
  String get clearOperationCompleted => 'Sletteoperasjon fullført';

  @override
  String get ndefRecordsFound => 'NDEF-poster funnet: ';

  @override
  String get theTagIsEmpty => 'Brikken er tom';

  @override
  String get record => 'Post ';

  @override
  String get type => 'Type: ';

  @override
  String get tnf => 'TNF: ';

  @override
  String get content => 'Innhold: ';

  @override
  String get noRecordsToWrite => 'Ingen poster å skrive';

  @override
  String get ndefRecordsWrittenSuccessfully => 'NDEF-poster skrevet vellykket';

  @override
  String get recordsWritten => 'Poster skrevet: ';

  @override
  String get writtenRecord => 'Skrevet post ';

  @override
  String get tagClearedSuccessfully => 'Brikken ble slettet';

  @override
  String get method => 'Metode: ';

  @override
  String get tagIsNowReadyForNewData => 'Brikken er nå klar for nye data';

  @override
  String get emptyTextRecord => 'Tom tekstpost';

  @override
  String get emptyNdefRecord => 'Tom NDEF-post';

  @override
  String get minimalSpaceCharacter => 'Minimalt mellomromstegn';

  @override
  String get emptyRecordList => 'Tom postliste';

  @override
  String get allClearingMethodsFailed => 'Alle slettemetoder mislyktes: ';

  @override
  String get verificationResults => 'Verifiseringsresultater:';

  @override
  String get recordsFound => 'Poster funnet: ';

  @override
  String get noNdefRecordsFoundOnTag => 'Ingen NDEF-poster funnet på brikken';

  @override
  String get theTagIsEmptyCleared => 'Brikken er tom/slettet';

  @override
  String get errorReadingTag => 'Feil ved lesing av brikke: ';

  @override
  String get errorWritingToTag => 'Feil ved skriving til brikke: ';

  @override
  String get errorClearingTag => 'Feil ved sletting av brikke: ';

  @override
  String get verificationError => 'Verifiseringsfeil: ';

  @override
  String get holdTagCloseAndTryAgain => '. Hold brikken nær og prøv igjen';

  @override
  String get tryHoldingTagCloser => '. Prøv å holde brikken nærmere';

  @override
  String get tryMovingTagCloser => '. Prøv å flytte brikken nærmere';

  @override
  String get method1EmptyTextRecordFailed =>
      'Metode 1 (tom tekstpost) mislyktes: ';

  @override
  String get method2EmptyNdefRecordFailed =>
      'Metode 2 (tom NDEF-post) mislyktes: ';

  @override
  String get method3MinimalRecordFailed =>
      'Metode 3 (minimal post) mislyktes: ';

  @override
  String get method4EmptyListFailed => 'Metode 4 (tom liste) mislyktes: ';

  @override
  String get errorFinishingNfcSession => 'Feil ved avslutning av NFC-økt: ';

  @override
  String get secondaryCleanupAlsoFailed =>
      'Sekundær opprydding mislyktes også: ';

  @override
  String get multipleTagsFoundPleaseSelectOne =>
      'Flere brikker funnet, vennligst velg én';

  @override
  String get scanYourNfcTagDefault => 'Skann NFC-brikken din';

  @override
  String get readNdefTags => 'Les NDEF-brikker';

  @override
  String get reading => 'Leser...';

  @override
  String get readNfcTag => 'Les NFC-brikke';

  @override
  String get verify => 'Verifiser';

  @override
  String get clearing => 'Sletter...';

  @override
  String get clearNfcTag => 'Slett NFC-brikke';

  @override
  String get monospaceFontFamily => 'monospace';

  @override
  String get nfcStatus => 'NFC-status';

  @override
  String get refreshNfcStatus => 'Oppdater NFC-status';

  @override
  String get writeNdefRecords => 'Skriv NDEF-poster';

  @override
  String get textRecord => 'Tekstpost';

  @override
  String get enterTextToWriteToNfcTag =>
      'Skriv inn tekst for å skrive til NFC-brikken';

  @override
  String get writing => 'Skriver...';

  @override
  String get writeText => 'Skriv tekst';

  @override
  String get urlRecord => 'URL-post';

  @override
  String get enterUrl => 'Skriv inn URL';

  @override
  String get writeUrl => 'Skriv URL';

  @override
  String get wifiRecord => 'WiFi-post';

  @override
  String get wifiNetworkNameSsid => 'WiFi-nettverksnavn (SSID)';

  @override
  String get wifiPassword => 'WiFi-passord';

  @override
  String get writeWifi => 'Skriv WiFi';

  @override
  String get writeAllRecords => 'Skriv alle poster';

  @override
  String get writeAllNonEmptyFieldsDescription =>
      'Skriv alle felt som ikke er tomme til NFC-brikken på én gang';

  @override
  String get writeMultipleRecords => 'Skriv flere poster';

  @override
  String get readOperationFailed => 'Leseoperasjon mislyktes';

  @override
  String get tagReadSuccessfully => 'Brikke lest vellykket';

  @override
  String get verificationFailed => 'Verifisering mislyktes';

  @override
  String get tagVerifiedSuccessfully => 'Brikke verifisert vellykket';

  @override
  String get clearNfcTagConfirmation =>
      'Er du sikker på at du vil slette denne NFC-brikken? Denne handlingen kan ikke angres.';

  @override
  String get clearOperationFailed => 'Sletteoperasjon mislyktes';

  @override
  String get writeOperationFailed => 'Skriveoperasjon mislyktes';

  @override
  String get dataWrittenSuccessfully => 'Data skrevet vellykket';

  @override
  String get nfcNotAvailable => 'NFC ikke tilgjengelig';

  @override
  String get enableNfcMessage =>
      'Vennligst aktiver NFC i enhetsinnstillingene dine for å bruke denne funksjonen.';

  @override
  String get cancel => 'Avbryt';

  @override
  String get confirm => 'Bekreft';

  @override
  String get error => 'Feil';

  @override
  String get successfully => 'vellykket';

  @override
  String get language => 'Språk';

  @override
  String get loading => 'Laster inn...';

  @override
  String get exportXbm => 'Eksporter XBM';

  @override
  String get exportingXbm => 'Eksporterer XBM-filer...';

  @override
  String get fullRefresh => 'Full oppdatering';

  @override
  String get fullRefreshSelected => 'Full oppdatering valgt';

  @override
  String get waveformSelected => 'Valgt';

  @override
  String get barcode => 'Strekkode';

  @override
  String get library => 'Bibliotek';

  @override
  String get templates => 'Maler';

  @override
  String get barcodeGenerator => 'Strekkodegenerator';

  @override
  String get barcodeData => 'Strekkodedata';

  @override
  String get barcodeDataHint => 'Skriv inn strekkodenummer eller SKU';

  @override
  String get characters => 'Tegn';

  @override
  String get scanBarcode => 'Skann strekkode';

  @override
  String get barcodeFormat => 'Strekkodeformat';

  @override
  String get enterOrScanBarcodeData => 'Skriv inn eller skann strekkodedata';

  @override
  String get invalidBarcode => 'Ugyldig strekkode';

  @override
  String get invalidCharacter => 'Ugyldig tegn';

  @override
  String get supportedCharacters => 'Støttede tegn er';

  @override
  String get pleaseCheckBarcodeRules => 'Vennligst sjekk strekkodereglene.';

  @override
  String get dataTooShort => 'Dataene er for korte. Minimumslengde for';

  @override
  String get dataTooLong => 'Dataene er for lange. Maksimumslengde for';

  @override
  String get isText => 'er';

  @override
  String get pointCameraAtBarcode => 'Pek kameraet mot strekkoden for å skanne';

  @override
  String get generateImage => 'Generer bilde';

  @override
  String get exportFailed => 'Eksport mislyktes';

  @override
  String get exportedXbmFiles => 'Eksporterte XBM-fil(er) til MagicEpaper/XBM/';

  @override
  String get exported => 'Eksportert';

  @override
  String get xbmFilesToMagicEpaper => 'XBM-fil(er) til MagicEpaper/XBM/';

  @override
  String get floydSteinberg => 'Klassisk';

  @override
  String get stucki => 'Skarp';

  @override
  String get atkinson => 'Vintage';

  @override
  String get falseFloydSteinberg => 'Enkel';

  @override
  String get halftone => 'Avis';

  @override
  String get threshold => 'Plakat';

  @override
  String get colorHalftone => 'Fargeavis';

  @override
  String get searchingForDevice => 'Søker etter enhet';

  @override
  String get displayRefreshing => 'Skjermen oppdateres';

  @override
  String get transferComplete => 'Overføring fullført!';

  @override
  String get writingToEpaper => 'Skriver til ePaper';

  @override
  String get pleaseBringPhoneClose =>
      'Vennligst hold telefonen din nær Magic ePaper-enheten';

  @override
  String get keepPhoneClose => 'Hold telefonen i nærheten!';

  @override
  String get displayRefreshingMessage =>
      'Skjermen oppdateres. Vennligst hold telefonen i nærheten av enheten til bildet vises helt.';

  @override
  String get transferFailed => 'Overføring mislyktes';

  @override
  String get deviceConnectionTimeout =>
      'Tidsavbrudd for enhetstilkobling. Prøv å holde telefonen nærmere enheten og prøv igjen.';

  @override
  String get connectionLostDuringTransfer =>
      'Tilkoblingen ble brutt under overføringen. Hold telefonen nær enheten og prøv igjen.';

  @override
  String get done => 'Ferdig';

  @override
  String get close => 'Lukk';

  @override
  String get processingImage => 'Behandler bilde...';

  @override
  String get readyToFlash => 'Klar til å overføre';

  @override
  String get imageProcessedSuccessfully => 'Bildet ble behandlet vellykket.';

  @override
  String get tapBelowAndHold =>
      'Trykk nedenfor og hold telefonen nær skjermen.';

  @override
  String get startFlashing => 'Start overføring (Flashing)';

  @override
  String get flashing => 'Overfører...';

  @override
  String get keepPhoneStill => 'Hold telefonen i ro.';

  @override
  String get success => 'Suksess!';

  @override
  String get transferCompleteMessage => 'Overføring fullført!';

  @override
  String get unknownErrorOccurred => 'En ukjent feil oppstod.';

  @override
  String get resultsCleared => 'Resultater slettet';

  @override
  String get clearResults => 'Slett resultater';

  @override
  String get vCardContact => 'vCard-kontakt';

  @override
  String get writingVCard => 'Skriver vCard...';

  @override
  String get writeVCard => 'Skriv vCard';

  @override
  String get firstName => 'Fornavn';

  @override
  String get lastName => 'Etternavn';

  @override
  String get organization => 'Organisasjon';

  @override
  String get title => 'Tittel';

  @override
  String get mobileNumber => 'Mobilnummer';

  @override
  String get emailAddress => 'E-postadresse';

  @override
  String get streetAddress => 'Gateadresse';

  @override
  String get city => 'By';

  @override
  String get zipCode => 'Postnummer';

  @override
  String get country => 'Land';

  @override
  String get website => 'Nettsted';

  @override
  String get noSavedImagesYet => 'Ingen lagrede bilder ennå';

  @override
  String get saveImagesFromEditor =>
      'Lagre bilder fra redigeringsprogrammet eller importer nye';

  @override
  String get enterWifiSSID => 'Skriv inn WiFi SSID';

  @override
  String get enterWifiPassword => 'Skriv inn WiFi-passord';

  @override
  String get writeMultiple => 'Skriv flere';

  @override
  String get searchImages => 'Søk i bilder...';

  @override
  String get filter => 'Filter:';

  @override
  String get all => 'Alle';

  @override
  String get imported => 'Importert';

  @override
  String get editor => 'Redigering';

  @override
  String get imageLibrary => 'Bildebibliotek';

  @override
  String get selectImagesToDelete => 'Velg bilder som skal slettes';

  @override
  String get delete => 'Slett';

  @override
  String get deleteMode => 'Slettemodus';

  @override
  String get deleteImage => 'Slett bilde';

  @override
  String get thisActionCannotBeUndone => 'Denne handlingen kan ikke angres';

  @override
  String get filterLabel => 'Filter:';

  @override
  String get areYouSureDeleteImage =>
      'Er du sikker på at du vil slette dette bildet? Denne handlingen kan ikke angres.';

  @override
  String get deleteMultipleImages => 'Slett flere bilder';

  @override
  String get imagesSelected => 'bilde(r) valgt';

  @override
  String get imagesSelectedForDeletion => 'bilde(r) valgt for sletting';

  @override
  String areYouSureDeleteMultipleImages(Object count) {
    return 'Er du sikker på at du vil slette disse $count bildene? Denne handlingen kan ikke angres.';
  }

  @override
  String get areYouSureDeleteSingleImage =>
      'Er du sikker på at du vil slette dette bildet? Denne handlingen kan ikke angres.';

  @override
  String get deleteAll => 'Slett alle';

  @override
  String get renameImage => 'Gi bildet nytt navn';

  @override
  String get enterNewNameForImage => 'Skriv inn et nytt navn for bildet ditt';

  @override
  String get imageName => 'Bildenavn';

  @override
  String get enterImageName => 'Skriv inn bildenavn...';

  @override
  String get rename => 'Gi nytt navn';

  @override
  String get imageProperties => 'Bildeegenskaper';

  @override
  String get created => 'Opprettet';

  @override
  String get source => 'Kilde:';

  @override
  String get epdModel => 'EPD-modell:';

  @override
  String get transferToEpaper => 'Overfør til ePaper';

  @override
  String get saveImage => 'Lagre bilde';

  @override
  String get saveFilteredImageToLibrary =>
      'Lagre det filtrerte bildet ditt i biblioteket';

  @override
  String get filterApplied => 'Filter brukt:';

  @override
  String get save => 'Lagre';

  @override
  String get noImagesMatchSearch => 'Ingen bilder samsvarer med søket ditt';

  @override
  String get vCardDataCannotBeEmpty => 'VCard-data kan ikke være tomme';

  @override
  String get renamingImage => 'Gir bildet nytt navn...';

  @override
  String get imageRenamedTo => 'Bildet har fått nytt navn til \"';

  @override
  String get failedToRenameImage => 'Kunne ikke gi bildet nytt navn: ';

  @override
  String get deletingImage => 'Sletter bilde...';

  @override
  String get imageDeleted => 'Bildet \"';

  @override
  String get deleted => '\" ble slettet';

  @override
  String get failedToDeleteImage => 'Kunne ikke slette bilde: ';

  @override
  String get deletingImages => 'Sletter ';

  @override
  String get images => ' bilde(r)...';

  @override
  String get failedToDeleteImages => 'Kunne ikke slette bilder: ';

  @override
  String get imagesDeletedSuccessfully => ' bilder ble slettet';

  @override
  String get imageDeletedSuccessfully => 'Bildet ble slettet';

  @override
  String get failedToLoadImageData => 'Kunne ikke laste inn bildedata for \"';

  @override
  String get failedToDecodeImage => 'Kunne ikke dekode bilde \"';

  @override
  String get failedToTransfer => 'Kunne ikke overføre \"';

  @override
  String get savingImage => 'Lagrer bilde...';

  @override
  String get imageSavedToLibrary => 'Bildet ble lagret i biblioteket!';

  @override
  String get failedToSaveImage => 'Kunne ikke lagre bildet: ';

  @override
  String get errorCreatingVCardRecord => 'Feil ved oppretting av vCard-post: ';

  @override
  String get nfcIsDisabledPleaseEnableIt =>
      'NFC er deaktivert. Vennligst aktiver det.';

  @override
  String get thisDeviceDoesNotSupportNfc => 'Denne enheten støtter ikke NFC.';

  @override
  String get bringPhoneNearMagicEpaperHardware =>
      'Hold telefonen nær Magic ePaper-maskinvaren';

  @override
  String get tagDetectedInitializing => 'Brikke oppdaget! Initialiserer...';

  @override
  String get enablingEnergyHarvesting =>
      'Aktiverer energihøsting (Energy Harvesting)...';

  @override
  String get processingImageData => 'Behandler bildedata...';

  @override
  String get refreshingDisplay => 'Oppdaterer skjermen...';

  @override
  String get notMagicEpaperHardware => 'Ikke Magic ePaper-maskinvare';

  @override
  String get errorCheckingMessage => 'Feil ved sjekking av melding: ';

  @override
  String get timeoutWaitingForI2cMessage =>
      'Tidsavbrudd under venting på I2C-melding';

  @override
  String get writingChunk => 'Skriver blokk (chunk) ';

  @override
  String get transferredSuccessfully => 'Overført vellykket.';

  @override
  String get waitingForNfcTag => 'Venter på NFC-brikke...';

  @override
  String get gotTag => 'Fikk en brikke!';

  @override
  String get frame => 'Ramme ';

  @override
  String get couldNotOpenLink => 'Kunne ikke åpne lenken.';

  @override
  String get errorOccurredWhileOpeningLink =>
      'Det oppstod en feil under åpning av lenken.';

  @override
  String get errorCreatingAppRecord => 'Feil ved oppretting av app-post: ';

  @override
  String get appCannotBeEmpty => 'Appen kan ikke være tom';

  @override
  String get invalidPackageName => 'Ugyldig pakkenavn';

  @override
  String get writeAppLauncherData => 'Skriv app-starter data';

  @override
  String get writeAppLauncher => 'Skriv app-starter';

  @override
  String get searchApps => 'Søk i apper...';

  @override
  String get customPackageName => 'Tilpasset pakkenavn';

  @override
  String get enterPackageName => 'Skriv inn pakkenavn...';

  @override
  String get noAppsFound => 'Ingen apper funnet';

  @override
  String get selectApplication => 'Velg applikasjon';

  @override
  String get errorLoadingApps => 'Feil ved innlasting av apper: ';

  @override
  String get add => 'Legg til';

  @override
  String get readNfcTags => 'Les NFC-brikker';

  @override
  String get writeNfcTags => 'Skriv NFC-brikker';

  @override
  String get nfcIsReadyToUse =>
      'NFC er klar til bruk. Du kan lese og skrive NFC-brikker.';

  @override
  String get deviceDoesNotSupportNfc =>
      'Denne enheten støtter ikke NFC-funksjonalitet.';

  @override
  String get pleaseEnableNfcInSettings =>
      'Vennligst aktiver NFC i enhetsinnstillingene dine for å fortsette.';

  @override
  String get nfcIsNowEnabledAndReady => 'NFC er nå aktivert og klar til bruk!';

  @override
  String get nfcHasBeenDisabled =>
      'NFC har blitt deaktivert. Vennligst aktiver det for å fortsette å bruke NFC-funksjoner.';

  @override
  String get nfcIsNotSupportedOnDevice => 'NFC støttes ikke på denne enheten.';

  @override
  String get arduinoExport => 'Arduino-eksport';

  @override
  String get exportXmbFilesForArduino => 'Eksporter XMB-filer for Arduino';

  @override
  String get cardTemplates => 'Kortmaler';

  @override
  String get chooseTemplateSubtitle => 'Velg en mal for å komme i gang';

  @override
  String get employeeIdCardTitle => 'Ansatt ID-kort';

  @override
  String get employeeIdCardDescription =>
      'Lag profesjonelle ID-kort for ansatte';

  @override
  String get shopPriceTagTitle => 'Butikkprislapp';

  @override
  String get shopPriceTagDescription =>
      'Design attraktive prislapper for produktene dine';

  @override
  String get entryPassTagTitle => 'Inngangspass-brikke';

  @override
  String get entryPassTagDescription =>
      'Generer inngangspass for arrangementer og arenaer';

  @override
  String get eventBadgeTitle => 'Arrangementsmerke';

  @override
  String get eventBadgeDescription =>
      'Lag personlige arrangementsmerker og navneskilt';

  @override
  String get comingSoon => 'Kommer snart';

  @override
  String get comingSoonMessage =>
      'Denne malen er under utvikling og vil snart være tilgjengelig.';

  @override
  String get ok => 'OK';

  @override
  String get defaultCompanyName => 'Firmanavn';

  @override
  String get nameLabel => 'Navn';

  @override
  String get positionLabel => 'Stilling';

  @override
  String get divisionLabel => 'Avdeling';

  @override
  String get idLabel => 'ID';

  @override
  String get emptyFieldPlaceholder => 'Ikke spesifisert';

  @override
  String get productImage => 'Produktbilde';

  @override
  String get productName => 'Produktnavn';

  @override
  String get sizeQuantity => 'Størrelse/Antall';

  @override
  String get defaultCurrency => 'kr';

  @override
  String get defaultPrice => '0,00';

  @override
  String get price => 'Pris';

  @override
  String get quantitySize => 'Antall/Størrelse';

  @override
  String get quantitySizeHint =>
      'Angi størrelse/antall (f.eks. 750ml, 2kg, Stor)';

  @override
  String get namePrefix => 'Navn: ';

  @override
  String get positionPrefix => 'Stilling: ';

  @override
  String get divisionPrefix => 'Avdeling: ';

  @override
  String get idPrefix => 'ID: ';

  @override
  String get employeeIdCard => 'Ansatt ID-kort';

  @override
  String get fillDetailsToCreateId =>
      'Fyll inn detaljene nedenfor for å lage ansatt-ID-kortet';

  @override
  String get idCardDetails => 'ID-kortdetaljer';

  @override
  String get companyName => 'Firmanavn';

  @override
  String get enterCompanyName => 'Skriv inn firmanavn';

  @override
  String get pleaseEnterCompanyName => 'Vennligst skriv inn firmanavn';

  @override
  String get name => 'Navn';

  @override
  String get enterEmployeeName => 'Skriv inn ansattnavn';

  @override
  String get pleaseEnterName => 'Vennligst skriv inn navn';

  @override
  String get position => 'Stilling';

  @override
  String get enterJobPosition => 'Skriv inn stillingstittel';

  @override
  String get pleaseEnterPosition => 'Vennligst skriv inn stilling';

  @override
  String get division => 'Avdeling';

  @override
  String get enterDepartment => 'Skriv inn avdeling';

  @override
  String get pleaseEnterDivision => 'Vennligst skriv inn avdeling';

  @override
  String get idNumber => 'ID-nummer';

  @override
  String get enterUniqueId => 'Skriv inn unik ID';

  @override
  String get pleaseEnterIdNumber => 'Vennligst skriv inn ID-nummer';

  @override
  String get qrCodeData => 'QR-kodedata';

  @override
  String get enterQrCodeData => 'Skriv inn QR-kodedata';

  @override
  String get pleaseEnterQrCodeData => 'Vennligst skriv inn QR-kodedata';

  @override
  String get generatingIdCard => 'Genererer ID-kort...';

  @override
  String get generateIdCard => 'Generer ID-kort';

  @override
  String get profilePhoto => 'Profilbilde';

  @override
  String get selected => 'Valgt';

  @override
  String get photoSelected => 'Bilde valgt';

  @override
  String get selectProfilePhoto => 'Velg profilbilde';

  @override
  String get tapToChangePhoto => 'Trykk for å endre bilde';

  @override
  String get tapToSelectFromGallery => 'Trykk for å velge fra galleri';

  @override
  String get priceTagGenerator => 'Prislappgenerator';

  @override
  String get priceTagDescription =>
      'Lag profesjonelle prislapper for produktene dine';

  @override
  String get productDetails => 'Produktdetaljer';

  @override
  String get productNameHint => 'Skriv inn produktnavn (f.eks. iPhone 15 Pro)';

  @override
  String get pleaseEnterProductName => 'Vennligst skriv inn et produktnavn';

  @override
  String get currency => 'Valuta';

  @override
  String get currencyHint => 'kr';

  @override
  String get required => 'Påkrevd';

  @override
  String get priceHint => '999,00';

  @override
  String get pleaseEnterPrice => 'Vennligst skriv inn pris';

  @override
  String get pleaseEnterQuantitySize =>
      'Vennligst skriv inn antall eller størrelse';

  @override
  String get pleaseEnterBarcodeData => 'Vennligst skriv inn strekkodedata';

  @override
  String get generatingPriceTag => 'Genererer prislapp...';

  @override
  String get generatePriceTag => 'Generer prislapp';

  @override
  String get productImageIn => 'Produktbilde';

  @override
  String get productImageSelected => 'Produktbilde valgt';

  @override
  String get selectProductImage => 'Velg produktbilde';

  @override
  String get tapToChangeImage => 'Trykk for å endre bilde';

  @override
  String get chooseImageFromGallery => 'Velg bilde fra galleri';

  @override
  String get processingImages => 'Behandler bilder...';

  @override
  String get refreshModeInfo => 'Informasjon om oppdateringsmodus';

  @override
  String get fullRefreshInfo => 'Full oppdatering';

  @override
  String get fullRefreshDescription =>
      'Oppdaterer hele skjermen fullstendig ved å fjerne alle piksler og tegne bildet på nytt. Dette gir best bildekvalitet og kontrast, men tar lengre tid å fullføre.';

  @override
  String get partialRefreshInfo => 'Delvis oppdatering (Bølgeformer)';

  @override
  String get partialRefreshDescription =>
      'Oppdaterer bare endrede piksler ved bruk av optimaliserte bølgeformer (waveforms). Dette er raskere enn full oppdatering, men kan føre til innbrenning (ghosting) eller redusert kontrast over tid.';

  @override
  String get longPressForInfo => 'Langt trykk for mer informasjon';
}
