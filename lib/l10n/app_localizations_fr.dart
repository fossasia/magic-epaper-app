// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Magic ePaper';

  @override
  String get aboutUsDescription =>
      'Magic ePaper est une application conçue pour contrôler et mettre à jour les écrans ePaper. L\'objectif est de fournir des outils pour personnaliser et transférer des images, du texte et des motifs vers des écrans ePaper en utilisant le NFC. Le transfert de données du smartphone au matériel ePaper s\'effectue sans fil via NFC. Le projet est basé sur un firmware et des pilotes d\'affichage personnalisés pour une communication fluide et un rendu d\'image efficace.';

  @override
  String get developedBy => 'Développé par';

  @override
  String get fossasiaContributors => 'Contributeurs FOSSASIA';

  @override
  String get contactWithUs => 'Contactez-nous';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle =>
      'Forkez le dépôt et poussez vos modifications ou soumettez de nouveaux problèmes.';

  @override
  String get license => 'Licence';

  @override
  String get licenseSubtitle =>
      'Consultez les conditions de la licence Apache 2.0 utilisées sur Magic ePaper.';

  @override
  String get createTransfer => 'Créer & Transférer des Images';

  @override
  String get ndefScreen => 'Ndef';

  @override
  String get selectDisplayType => 'Sélectionnez votre type d\'écran ePaper';

  @override
  String get settings => 'Paramètres';

  @override
  String get aboutUs => 'À propos de nous';

  @override
  String get other => 'Autre';

  @override
  String get getBadge => 'Obtenir un badge';

  @override
  String get feedbackBugReports => 'Commentaires / Signaler un bug';

  @override
  String get continueButton => 'Continuer';

  @override
  String get noImageSelectedFeedback => 'Importez d\'abord une image !';

  @override
  String get adjustButtonLabel => 'Ajuster';

  @override
  String get importImageButtonLabel => 'Importer';

  @override
  String get openEditor => 'Créer';

  @override
  String get importStartingImageFeedback => 'Importez une image pour commencer';

  @override
  String get transferButtonLabel => 'Transférer';

  @override
  String get filterScreenTitle => 'Sélectionnez un Filtre';

  @override
  String get scanningForNfcTag => 'Recherche d\'un tag NFC...';

  @override
  String get scanningForNfcTagToWrite =>
      'Recherche d\'un tag NFC pour écriture...';

  @override
  String get scanningForNfcTagToClear =>
      'Recherche d\'un tag NFC pour effacement...';

  @override
  String get scanningTagForVerification =>
      'Analyse du tag pour vérification...';

  @override
  String get errorCreatingTextRecord =>
      'Erreur lors de la création de l\'enregistrement texte : ';

  @override
  String get errorCreatingUrlRecord =>
      'Erreur lors de la création de l\'enregistrement URL : ';

  @override
  String get errorCreatingWifiRecord =>
      'Erreur lors de la création de l\'enregistrement WiFi : ';

  @override
  String get errorCreatingMultipleRecords =>
      'Erreur lors de la création de plusieurs enregistrements : ';

  @override
  String get pleaseEnterAtLeastOneRecord =>
      'Veuillez saisir au moins un enregistrement';

  @override
  String get tagType => 'Type de tag : ';

  @override
  String get tagId => 'ID du tag : ';

  @override
  String get ndefAvailable => 'NDEF disponible : ';

  @override
  String get ndefWritable => 'NDEF inscriptible : ';

  @override
  String get unknown => 'Inconnu';

  @override
  String get textCannotBeEmpty => 'Le texte ne peut pas être vide';

  @override
  String get urlCannotBeEmpty => 'L\'URL ne peut pas être vide';

  @override
  String get wifiSsidCannotBeEmpty => 'Le SSID WiFi ne peut pas être vide';

  @override
  String get defaultLanguage => 'fr';

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
  String get unknownNull => 'Inconnu (null)';

  @override
  String get unknownType => 'Type inconnu : ';

  @override
  String get textPrefix => 'Texte : ';

  @override
  String get textSuffix => ' (Langue : ';

  @override
  String get uriPrefix => 'URI : ';

  @override
  String get mimePrefix => 'MIME : ';

  @override
  String get absoluteUriPrefix => 'URI absolu : ';

  @override
  String get rawPrefix => 'Brut : ';

  @override
  String get emptyPayload => 'Charge utile vide';

  @override
  String get binaryDataPrefix => 'Données binaires (';

  @override
  String get binaryDataSuffix => ' octets) : ';

  @override
  String get errorDecodingRecord =>
      'Erreur lors du décodage de l\'enregistrement : ';

  @override
  String get noNdefRecordsFound => 'Aucun enregistrement NDEF trouvé';

  @override
  String get recordPrefix => 'Enregistrement ';

  @override
  String get recordSuffix => ' :';

  @override
  String get tnfLabel => 'TNF : ';

  @override
  String get typeLabel => 'Type : ';

  @override
  String get payloadSizeLabel => 'Taille de la charge utile : ';

  @override
  String get bytesLabel => ' octets';

  @override
  String get contentLabel => 'Contenu : ';

  @override
  String get rawPayloadLabel => 'Charge utile brute : ';

  @override
  String get nullPayload => 'null';

  @override
  String get closingParenthesis => ')';

  @override
  String get closingParenthesisNewline => ')\n';

  @override
  String get scanYourNfcTag => 'Scannez votre tag NFC';

  @override
  String get scanYourNfcTagToWrite => 'Scannez votre tag NFC pour écrire';

  @override
  String get scanYourNfcTagToClear => 'Scannez votre tag NFC pour effacer';

  @override
  String get scanTagToVerifyContent =>
      'Scannez le tag pour vérifier le contenu';

  @override
  String get tagIsNotNdefCompatible => 'Le tag n\'est pas compatible NDEF';

  @override
  String get tagDoesNotSupportNdef => 'Le tag ne prend pas en charge NDEF';

  @override
  String get tagIsNotWritable => 'Le tag n\'est pas inscriptible';

  @override
  String get tagDoesNotSupportNdefCannotClear =>
      'Le tag ne prend pas en charge NDEF, impossible de l\'effacer';

  @override
  String get tagIsNotWritableCannotClear =>
      'Le tag n\'est pas inscriptible, impossible de l\'effacer';

  @override
  String get readOperationCompleted => 'Opération de lecture terminée';

  @override
  String get writeOperationCompleted => 'Opération d\'écriture terminée';

  @override
  String get clearOperationCompleted => 'Opération d\'effacement terminée';

  @override
  String get ndefRecordsFound => 'Enregistrements NDEF trouvés : ';

  @override
  String get theTagIsEmpty => 'Le tag est vide';

  @override
  String get record => 'Enregistrement ';

  @override
  String get type => 'Type : ';

  @override
  String get tnf => 'TNF : ';

  @override
  String get content => 'Contenu : ';

  @override
  String get noRecordsToWrite => 'Aucun enregistrement à écrire';

  @override
  String get ndefRecordsWrittenSuccessfully =>
      'Enregistrements NDEF écrits avec succès';

  @override
  String get recordsWritten => 'Enregistrements écrits : ';

  @override
  String get writtenRecord => 'Enregistrement écrit ';

  @override
  String get tagClearedSuccessfully => 'Tag effacé avec succès';

  @override
  String get method => 'Méthode : ';

  @override
  String get tagIsNowReadyForNewData =>
      'Le tag est maintenant prêt pour de nouvelles données';

  @override
  String get emptyTextRecord => 'Enregistrement texte vide';

  @override
  String get emptyNdefRecord => 'Enregistrement NDEF vide';

  @override
  String get minimalSpaceCharacter => 'Caractère d\'espace minimal';

  @override
  String get emptyRecordList => 'Liste d\'enregistrements vide';

  @override
  String get allClearingMethodsFailed =>
      'Toutes les méthodes d\'effacement ont échoué : ';

  @override
  String get verificationResults => 'Résultats de la vérification :';

  @override
  String get recordsFound => 'Enregistrements trouvés : ';

  @override
  String get noNdefRecordsFoundOnTag =>
      'Aucun enregistrement NDEF trouvé sur le tag';

  @override
  String get theTagIsEmptyCleared => 'Le tag est vide/effacé';

  @override
  String get errorReadingTag => 'Erreur lors de la lecture du tag : ';

  @override
  String get errorWritingToTag => 'Erreur lors de l\'écriture sur le tag : ';

  @override
  String get errorClearingTag => 'Erreur lors de l\'effacement du tag : ';

  @override
  String get verificationError => 'Erreur de vérification : ';

  @override
  String get holdTagCloseAndTryAgain =>
      '. Maintenez le tag proche et réessayez';

  @override
  String get tryHoldingTagCloser => '. Essayez de tenir le tag plus près';

  @override
  String get tryMovingTagCloser => '. Essayez de rapprocher le tag';

  @override
  String get method1EmptyTextRecordFailed =>
      'La méthode 1 (enregistrement texte vide) a échoué : ';

  @override
  String get method2EmptyNdefRecordFailed =>
      'La méthode 2 (enregistrement NDEF vide) a échoué : ';

  @override
  String get method3MinimalRecordFailed =>
      'La méthode 3 (enregistrement minimal) a échoué : ';

  @override
  String get method4EmptyListFailed => 'La méthode 4 (liste vide) a échoué : ';

  @override
  String get errorFinishingNfcSession =>
      'Erreur lors de la fin de la session NFC : ';

  @override
  String get secondaryCleanupAlsoFailed =>
      'Le nettoyage secondaire a également échoué : ';

  @override
  String get multipleTagsFoundPleaseSelectOne =>
      'Plusieurs tags trouvés, veuillez en sélectionner un';

  @override
  String get scanYourNfcTagDefault => 'Scannez votre tag NFC';

  @override
  String get readNdefTags => 'Lire les tags NDEF';

  @override
  String get reading => 'Lecture...';

  @override
  String get readNfcTag => 'Lire le tag NFC';

  @override
  String get verify => 'Vérifier';

  @override
  String get clearing => 'Effacement...';

  @override
  String get clearNfcTag => 'Effacer le tag NFC';

  @override
  String get monospaceFontFamily => 'monospace';

  @override
  String get nfcStatus => 'Statut NFC';

  @override
  String get refreshNfcStatus => 'Actualiser le statut NFC';

  @override
  String get writeNdefRecords => 'Écrire des enregistrements NDEF';

  @override
  String get textRecord => 'Enregistrement Texte';

  @override
  String get enterTextToWriteToNfcTag =>
      'Entrez le texte à écrire sur le tag NFC';

  @override
  String get writing => 'Écriture...';

  @override
  String get writeText => 'Écrire du texte';

  @override
  String get urlRecord => 'Enregistrement URL';

  @override
  String get enterUrl => 'Entrez l\'URL';

  @override
  String get writeUrl => 'Écrire l\'URL';

  @override
  String get wifiRecord => 'Enregistrement WiFi';

  @override
  String get wifiNetworkNameSsid => 'Nom du réseau WiFi (SSID)';

  @override
  String get wifiPassword => 'Mot de passe WiFi';

  @override
  String get writeWifi => 'Écrire le WiFi';

  @override
  String get writeAllRecords => 'Écrire tous les enregistrements';

  @override
  String get writeAllNonEmptyFieldsDescription =>
      'Écrire tous les champs non vides sur le tag NFC en une seule fois';

  @override
  String get writeMultipleRecords => 'Écrire plusieurs enregistrements';

  @override
  String get readOperationFailed => 'L\'opération de lecture a échoué';

  @override
  String get tagReadSuccessfully => 'Tag lu avec succès';

  @override
  String get verificationFailed => 'La vérification a échoué';

  @override
  String get tagVerifiedSuccessfully => 'Tag vérifié avec succès';

  @override
  String get clearNfcTagConfirmation =>
      'Êtes-vous sûr de vouloir effacer ce tag NFC ? Cette action est irréversible.';

  @override
  String get clearOperationFailed => 'L\'opération d\'effacement a échoué';

  @override
  String get writeOperationFailed => 'L\'opération d\'écriture a échoué';

  @override
  String get dataWrittenSuccessfully => 'Données écrites avec succès';

  @override
  String get nfcNotAvailable => 'NFC non disponible';

  @override
  String get enableNfcMessage =>
      'Veuillez activer le NFC dans les paramètres de votre appareil pour utiliser cette fonctionnalité.';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get error => 'Erreur';

  @override
  String get successfully => 'avec succès';

  @override
  String get language => 'Langue';

  @override
  String get loading => 'Chargement...';

  @override
  String get exportXbm => 'Exporter en XBM';

  @override
  String get exportingXbm => 'Exportation des fichiers XBM...';

  @override
  String get fullRefresh => 'Rafraîchissement Complet';

  @override
  String get fullRefreshSelected => 'Rafraîchissement complet sélectionné';

  @override
  String get waveformSelected => 'Sélectionné';

  @override
  String get barcode => 'Code-barres';

  @override
  String get library => 'Bibliothèque';

  @override
  String get templates => 'Modèles';

  @override
  String get barcodeGenerator => 'Générateur de code-barres';

  @override
  String get barcodeData => 'Données du code-barres';

  @override
  String get barcodeDataHint => 'Entrez le numéro du code-barres ou le SKU';

  @override
  String get characters => 'Caractères';

  @override
  String get scanBarcode => 'Scanner le code-barres';

  @override
  String get barcodeFormat => 'Format du code-barres';

  @override
  String get enterOrScanBarcodeData =>
      'Entrez ou scannez les données du code-barres';

  @override
  String get invalidBarcode => 'Code-barres invalide';

  @override
  String get invalidCharacter => 'Caractère invalide';

  @override
  String get supportedCharacters => 'Les caractères pris en charge sont';

  @override
  String get pleaseCheckBarcodeRules =>
      'Veuillez vérifier les règles du code-barres.';

  @override
  String get dataTooShort =>
      'Les données sont trop courtes. Longueur minimale pour';

  @override
  String get dataTooLong =>
      'Les données sont trop longues. Longueur maximale pour';

  @override
  String get isText => 'est';

  @override
  String get pointCameraAtBarcode =>
      'Pointez la caméra vers le code-barres pour scanner';

  @override
  String get generateImage => 'Générer l\'image';

  @override
  String get exportFailed => 'L\'exportation a échoué';

  @override
  String get exportedXbmFiles =>
      'Fichier(s) XBM exporté(s) vers MagicEpaper/XBM/';

  @override
  String get exported => 'Exporté';

  @override
  String get xbmFilesToMagicEpaper => 'Fichier(s) XBM vers MagicEpaper/XBM/';

  @override
  String get floydSteinberg => 'Classique';

  @override
  String get stucki => 'Net';

  @override
  String get atkinson => 'Vintage';

  @override
  String get falseFloydSteinberg => 'Simple';

  @override
  String get halftone => 'Journal';

  @override
  String get threshold => 'Postériser';

  @override
  String get colorHalftone => 'Journal Couleur';

  @override
  String get searchingForDevice => 'Recherche de l\'appareil';

  @override
  String get displayRefreshing => 'Rafraîchissement de l\'écran';

  @override
  String get transferComplete => 'Transfert terminé !';

  @override
  String get writingToEpaper => 'Écriture sur l\'ePaper';

  @override
  String get pleaseBringPhoneClose =>
      'Veuillez approcher votre téléphone de l\'appareil Magic ePaper';

  @override
  String get keepPhoneClose => 'Gardez votre téléphone à proximité !';

  @override
  String get displayRefreshingMessage =>
      'L\'écran se rafraîchit. Veuillez garder votre téléphone près de l\'appareil jusqu\'à ce que l\'image apparaisse complètement.';

  @override
  String get transferFailed => 'Échec du transfert';

  @override
  String get deviceConnectionTimeout =>
      'Délai de connexion à l\'appareil dépassé. Veuillez essayer de rapprocher votre téléphone de l\'appareil et réessayer.';

  @override
  String get connectionLostDuringTransfer =>
      'La connexion a été perdue pendant le transfert. Veuillez garder votre téléphone près de l\'appareil et réessayer.';

  @override
  String get done => 'Terminé';

  @override
  String get close => 'Fermer';

  @override
  String get processingImage => 'Traitement de l\'image...';

  @override
  String get readyToFlash => 'Prêt à flasher';

  @override
  String get imageProcessedSuccessfully => 'Image traitée avec succès.';

  @override
  String get tapBelowAndHold =>
      'Appuyez ci-dessous et maintenez votre téléphone près de l\'écran.';

  @override
  String get startFlashing => 'Commencer le flashage';

  @override
  String get flashing => 'Flashage...';

  @override
  String get keepPhoneStill => 'Gardez votre téléphone immobile.';

  @override
  String get success => 'Succès !';

  @override
  String get transferCompleteMessage => 'Transfert terminé !';

  @override
  String get unknownErrorOccurred => 'Une erreur inconnue s\'est produite.';

  @override
  String get resultsCleared => 'Résultats effacés';

  @override
  String get clearResults => 'Effacer les résultats';

  @override
  String get vCardContact => 'Contact vCard';

  @override
  String get writingVCard => 'Écriture de la vCard...';

  @override
  String get writeVCard => 'Écrire la vCard';

  @override
  String get firstName => 'Prénom';

  @override
  String get lastName => 'Nom';

  @override
  String get organization => 'Organisation';

  @override
  String get title => 'Titre';

  @override
  String get mobileNumber => 'Numéro de mobile';

  @override
  String get emailAddress => 'Adresse e-mail';

  @override
  String get streetAddress => 'Adresse (rue)';

  @override
  String get city => 'Ville';

  @override
  String get zipCode => 'Code postal';

  @override
  String get country => 'Pays';

  @override
  String get website => 'Site web';

  @override
  String get noSavedImagesYet => 'Aucune image enregistrée pour le moment';

  @override
  String get saveImagesFromEditor =>
      'Enregistrez des images depuis l\'éditeur ou importez-en de nouvelles';

  @override
  String get enterWifiSSID => 'Entrez le SSID WiFi';

  @override
  String get enterWifiPassword => 'Entrez le mot de passe WiFi';

  @override
  String get writeMultiple => 'Écrire plusieurs';

  @override
  String get searchImages => 'Rechercher des images...';

  @override
  String get filter => 'Filtre :';

  @override
  String get all => 'Tout';

  @override
  String get imported => 'Importé';

  @override
  String get editor => 'Éditeur';

  @override
  String get imageLibrary => 'Bibliothèque d\'images';

  @override
  String get selectImagesToDelete => 'Sélectionner les images à supprimer';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteMode => 'Mode suppression';

  @override
  String get deleteImage => 'Supprimer l\'image';

  @override
  String get thisActionCannotBeUndone => 'Cette action est irréversible';

  @override
  String get filterLabel => 'Filtre :';

  @override
  String get areYouSureDeleteImage =>
      'Êtes-vous sûr de vouloir supprimer cette image ? Cette action est irréversible.';

  @override
  String get deleteMultipleImages => 'Supprimer plusieurs images';

  @override
  String get imagesSelected => 'image(s) sélectionnée(s)';

  @override
  String get imagesSelectedForDeletion =>
      'image(s) sélectionnée(s) pour la suppression';

  @override
  String areYouSureDeleteMultipleImages(Object count) {
    return 'Êtes-vous sûr de vouloir supprimer ces $count images ? Cette action est irréversible.';
  }

  @override
  String get areYouSureDeleteSingleImage =>
      'Êtes-vous sûr de vouloir supprimer cette image ? Cette action est irréversible.';

  @override
  String get deleteAll => 'Tout supprimer';

  @override
  String get renameImage => 'Renommer l\'image';

  @override
  String get enterNewNameForImage => 'Entrez un nouveau nom pour votre image';

  @override
  String get imageName => 'Nom de l\'image';

  @override
  String get enterImageName => 'Entrez le nom de l\'image...';

  @override
  String get rename => 'Renommer';

  @override
  String get imageProperties => 'Propriétés de l\'image';

  @override
  String get created => 'Créé';

  @override
  String get source => 'Source :';

  @override
  String get epdModel => 'Modèle EPD :';

  @override
  String get transferToEpaper => 'Transférer vers l\'ePaper';

  @override
  String get saveImage => 'Enregistrer l\'image';

  @override
  String get saveFilteredImageToLibrary =>
      'Enregistrez votre image filtrée dans la bibliothèque';

  @override
  String get filterApplied => 'Filtre appliqué :';

  @override
  String get save => 'Enregistrer';

  @override
  String get noImagesMatchSearch =>
      'Aucune image ne correspond à votre recherche';

  @override
  String get vCardDataCannotBeEmpty =>
      'Les données vCard ne peuvent pas être vides';

  @override
  String get renamingImage => 'Renommage de l\'image...';

  @override
  String get imageRenamedTo => 'Image renommée en \"';

  @override
  String get failedToRenameImage => 'Échec du renommage de l\'image : ';

  @override
  String get deletingImage => 'Suppression de l\'image...';

  @override
  String get imageDeleted => 'Image \"';

  @override
  String get deleted => '\" supprimée';

  @override
  String get failedToDeleteImage => 'Échec de la suppression de l\'image : ';

  @override
  String get deletingImages => 'Suppression de ';

  @override
  String get images => ' image(s)...';

  @override
  String get failedToDeleteImages => 'Échec de la suppression des images : ';

  @override
  String get imagesDeletedSuccessfully => ' images supprimées avec succès';

  @override
  String get imageDeletedSuccessfully => 'Image supprimée avec succès';

  @override
  String get failedToLoadImageData =>
      'Échec du chargement des données de l\'image pour \"';

  @override
  String get failedToDecodeImage => 'Échec du décodage de l\'image \"';

  @override
  String get failedToTransfer => 'Échec du transfert de \"';

  @override
  String get savingImage => 'Enregistrement de l\'image...';

  @override
  String get imageSavedToLibrary => 'Image enregistrée dans la bibliothèque !';

  @override
  String get failedToSaveImage => 'Échec de l\'enregistrement de l\'image : ';

  @override
  String get errorCreatingVCardRecord =>
      'Erreur lors de la création de l\'enregistrement vCard : ';

  @override
  String get nfcIsDisabledPleaseEnableIt =>
      'Le NFC est désactivé. Veuillez l\'activer.';

  @override
  String get thisDeviceDoesNotSupportNfc =>
      'Cet appareil ne prend pas en charge le NFC.';

  @override
  String get bringPhoneNearMagicEpaperHardware =>
      'Approchez votre téléphone du matériel Magic ePaper';

  @override
  String get tagDetectedInitializing => 'Tag détecté ! Initialisation...';

  @override
  String get enablingEnergyHarvesting =>
      'Activation de la récupération d\'énergie...';

  @override
  String get processingImageData => 'Traitement des données de l\'image...';

  @override
  String get refreshingDisplay => 'Rafraîchissement de l\'écran...';

  @override
  String get notMagicEpaperHardware => 'Ce n\'est pas un matériel Magic ePaper';

  @override
  String get errorCheckingMessage =>
      'Erreur lors de la vérification du message : ';

  @override
  String get timeoutWaitingForI2cMessage =>
      'Délai d\'attente dépassé pour le message I2C';

  @override
  String get writingChunk => 'Écriture du bloc ';

  @override
  String get transferredSuccessfully => 'Transféré avec succès.';

  @override
  String get waitingForNfcTag => 'En attente d\'un tag NFC...';

  @override
  String get gotTag => 'Tag trouvé !';

  @override
  String get frame => 'Cadre ';

  @override
  String get couldNotOpenLink => 'Impossible d\'ouvrir le lien.';

  @override
  String get errorOccurredWhileOpeningLink =>
      'Une erreur s\'est produite lors de l\'ouverture du lien.';

  @override
  String get errorCreatingAppRecord =>
      'Erreur lors de la création de l\'enregistrement de l\'application : ';

  @override
  String get appCannotBeEmpty => 'L\'application ne peut pas être vide';

  @override
  String get invalidPackageName => 'Nom de package invalide';

  @override
  String get writeAppLauncherData =>
      'Écrire les données du lanceur d\'application';

  @override
  String get writeAppLauncher => 'Écrire le lanceur d\'application';

  @override
  String get searchApps => 'Rechercher des applications...';

  @override
  String get customPackageName => 'Nom de package personnalisé';

  @override
  String get enterPackageName => 'Entrez le nom du package...';

  @override
  String get noAppsFound => 'Aucune application trouvée';

  @override
  String get selectApplication => 'Sélectionner une application';

  @override
  String get errorLoadingApps =>
      'Erreur lors du chargement des applications : ';

  @override
  String get add => 'Ajouter';

  @override
  String get readNfcTags => 'Lire les tags NFC';

  @override
  String get writeNfcTags => 'Écrire des tags NFC';

  @override
  String get nfcIsReadyToUse =>
      'Le NFC est prêt à être utilisé. Vous pouvez lire et écrire des tags NFC.';

  @override
  String get deviceDoesNotSupportNfc =>
      'Cet appareil ne prend pas en charge la fonctionnalité NFC.';

  @override
  String get pleaseEnableNfcInSettings =>
      'Veuillez activer le NFC dans les paramètres de votre appareil pour continuer.';

  @override
  String get nfcIsNowEnabledAndReady =>
      'Le NFC est maintenant activé et prêt à l\'emploi !';

  @override
  String get nfcHasBeenDisabled =>
      'Le NFC a été désactivé. Veuillez l\'activer pour continuer à utiliser les fonctionnalités NFC.';

  @override
  String get nfcIsNotSupportedOnDevice =>
      'Le NFC n\'est pas pris en charge sur cet appareil.';

  @override
  String get arduinoExport => 'Exportation Arduino';

  @override
  String get exportXmbFilesForArduino =>
      'Exporter les fichiers XMB pour Arduino';

  @override
  String get cardTemplates => 'Modèles de cartes';

  @override
  String get chooseTemplateSubtitle => 'Choisissez un modèle pour commencer';

  @override
  String get employeeIdCardTitle => 'Carte d\'identité d\'employé';

  @override
  String get employeeIdCardDescription =>
      'Créez des cartes d\'identité professionnelles pour les employés';

  @override
  String get shopPriceTagTitle => 'Étiquette de prix';

  @override
  String get shopPriceTagDescription =>
      'Concevez des étiquettes de prix attrayantes pour vos produits';

  @override
  String get entryPassTagTitle => 'Pass d\'entrée';

  @override
  String get entryPassTagDescription =>
      'Générez des pass d\'entrée pour des événements et des lieux';

  @override
  String get eventBadgeTitle => 'Badge d\'événement';

  @override
  String get eventBadgeDescription =>
      'Créez des badges d\'événement et des étiquettes de nom personnalisés';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get comingSoonMessage =>
      'Ce modèle est actuellement en cours de développement et sera bientôt disponible.';

  @override
  String get ok => 'OK';

  @override
  String get defaultCompanyName => 'Nom de l\'entreprise';

  @override
  String get nameLabel => 'Nom';

  @override
  String get positionLabel => 'Poste';

  @override
  String get divisionLabel => 'Division';

  @override
  String get idLabel => 'ID';

  @override
  String get emptyFieldPlaceholder => 'Non spécifié';

  @override
  String get productImage => 'Image du produit';

  @override
  String get productName => 'Nom du produit';

  @override
  String get sizeQuantity => 'Taille/Quantité';

  @override
  String get defaultCurrency => '€';

  @override
  String get defaultPrice => '0.00';

  @override
  String get price => 'Prix';

  @override
  String get quantitySize => 'Quantité/Taille';

  @override
  String get quantitySizeHint =>
      'Entrez la taille/quantité (ex: 750ml, 2kg, Grand)';

  @override
  String get namePrefix => 'Nom : ';

  @override
  String get positionPrefix => 'Poste : ';

  @override
  String get divisionPrefix => 'Division : ';

  @override
  String get idPrefix => 'ID : ';

  @override
  String get employeeIdCard => 'Carte d\'identité d\'employé';

  @override
  String get fillDetailsToCreateId =>
      'Remplissez les détails ci-dessous pour créer votre carte d\'identité d\'employé';

  @override
  String get idCardDetails => 'Détails de la carte d\'identité';

  @override
  String get companyName => 'Nom de l\'entreprise';

  @override
  String get enterCompanyName => 'Entrez le nom de l\'entreprise';

  @override
  String get pleaseEnterCompanyName =>
      'Veuillez entrer le nom de l\'entreprise';

  @override
  String get name => 'Nom';

  @override
  String get enterEmployeeName => 'Entrez le nom de l\'employé';

  @override
  String get pleaseEnterName => 'Veuillez entrer un nom';

  @override
  String get position => 'Poste';

  @override
  String get enterJobPosition => 'Entrez le poste';

  @override
  String get pleaseEnterPosition => 'Veuillez entrer le poste';

  @override
  String get division => 'Division';

  @override
  String get enterDepartment => 'Entrez le département';

  @override
  String get pleaseEnterDivision => 'Veuillez entrer la division';

  @override
  String get idNumber => 'Numéro d\'ID';

  @override
  String get enterUniqueId => 'Entrez un ID unique';

  @override
  String get pleaseEnterIdNumber => 'Veuillez entrer le numéro d\'ID';

  @override
  String get qrCodeData => 'Données du code QR';

  @override
  String get enterQrCodeData => 'Entrez les données du code QR';

  @override
  String get pleaseEnterQrCodeData => 'Veuillez entrer les données du code QR';

  @override
  String get generatingIdCard => 'Génération de la carte d\'identité...';

  @override
  String get generateIdCard => 'Générer la carte d\'identité';

  @override
  String get profilePhoto => 'Photo de profil';

  @override
  String get selected => 'Sélectionné';

  @override
  String get photoSelected => 'Photo sélectionnée';

  @override
  String get selectProfilePhoto => 'Sélectionner la photo de profil';

  @override
  String get tapToChangePhoto => 'Appuyez pour changer la photo';

  @override
  String get tapToSelectFromGallery =>
      'Appuyez pour sélectionner depuis la galerie';

  @override
  String get priceTagGenerator => 'Générateur d\'étiquette de prix';

  @override
  String get priceTagDescription =>
      'Créez des étiquettes de prix professionnelles pour vos produits';

  @override
  String get productDetails => 'Détails du produit';

  @override
  String get productNameHint => 'Entrez le nom du produit (ex: iPhone 15 Pro)';

  @override
  String get pleaseEnterProductName => 'Veuillez entrer le nom du produit';

  @override
  String get currency => 'Devise';

  @override
  String get currencyHint => '€';

  @override
  String get required => 'Requis';

  @override
  String get priceHint => '999.99';

  @override
  String get pleaseEnterPrice => 'Veuillez entrer le prix';

  @override
  String get pleaseEnterQuantitySize =>
      'Veuillez entrer la quantité ou la taille';

  @override
  String get pleaseEnterBarcodeData =>
      'Veuillez entrer les données du code-barres';

  @override
  String get generatingPriceTag => 'Génération de l\'étiquette de prix...';

  @override
  String get generatePriceTag => 'Générer l\'étiquette de prix';

  @override
  String get productImageIn => 'Image du produit';

  @override
  String get productImageSelected => 'Image du produit sélectionnée';

  @override
  String get selectProductImage => 'Sélectionner l\'image du produit';

  @override
  String get tapToChangeImage => 'Appuyez pour changer l\'image';

  @override
  String get chooseImageFromGallery => 'Choisir une image dans la galerie';

  @override
  String get processingImages => 'Traitement des images...';

  @override
  String get refreshModeInfo => 'Informations sur le mode de rafraîchissement';

  @override
  String get fullRefreshInfo => 'Rafraîchissement Complet';

  @override
  String get fullRefreshDescription =>
      'Rafraîchit complètement tout l\'écran en effaçant tous les pixels et en redessinant l\'image. Cela offre la meilleure qualité d\'image et le meilleur contraste, mais prend plus de temps.';

  @override
  String get partialRefreshInfo => 'Rafraîchissement Partiel (Formes d\'onde)';

  @override
  String get partialRefreshDescription =>
      'Met à jour uniquement les pixels modifiés à l\'aide de formes d\'onde optimisées. C\'est plus rapide qu\'un rafraîchissement complet mais peut entraîner une rémanence (ghosting) ou une réduction du contraste avec le temps.';

  @override
  String get longPressForInfo => 'Appuyez longuement pour plus d\'informations';
}
