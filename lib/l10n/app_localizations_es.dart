// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Magic ePaper';

  @override
  String get aboutUsDescription =>
      'Magic ePaper es una aplicación diseñada para controlar y actualizar pantallas ePaper. El objetivo es proporcionar herramientas para personalizar y transferir imágenes, texto y patrones a pantallas ePaper mediante NFC. La transferencia de datos desde el teléfono inteligente al hardware ePaper se realiza de forma inalámbrica a través de NFC. El proyecto se basa en un firmware personalizado y controladores de pantalla para una comunicación fluida y una renderización de imágenes eficiente.';

  @override
  String get developedBy => 'Desarrollado por';

  @override
  String get fossasiaContributors => 'Colaboradores de FOSSASIA';

  @override
  String get contactWithUs => 'Contáctanos';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle =>
      'Haz un fork del repositorio y envía cambios o reporta nuevos problemas.';

  @override
  String get license => 'Licencia';

  @override
  String get licenseSubtitle =>
      'Consulta los términos de la Licencia Apache 2.0 utilizados en Magic ePaper.';

  @override
  String get createTransfer => 'Crear y Transferir Imágenes';

  @override
  String get ndefScreen => 'Ndef';

  @override
  String get selectDisplayType => 'Selecciona tu tipo de pantalla ePaper';

  @override
  String get settings => 'Ajustes';

  @override
  String get aboutUs => 'Sobre Nosotros';

  @override
  String get other => 'Otros';

  @override
  String get getBadge => 'Obtener Insignia';

  @override
  String get feedbackBugReports => 'Comentarios/Reportes de Errores';

  @override
  String get continueButton => 'Continuar';

  @override
  String get noImageSelectedFeedback => '¡Importa una imagen primero!';

  @override
  String get adjustButtonLabel => 'Ajustar';

  @override
  String get importImageButtonLabel => 'Importar';

  @override
  String get openEditor => 'Crear';

  @override
  String get importStartingImageFeedback => 'Importa una imagen para comenzar';

  @override
  String get transferButtonLabel => 'Transferir';

  @override
  String get filterScreenTitle => 'Selecciona un Filtro';

  @override
  String get scanningForNfcTag => 'Buscando etiqueta NFC...';

  @override
  String get scanningForNfcTagToWrite =>
      'Buscando etiqueta NFC para escribir...';

  @override
  String get scanningForNfcTagToClear => 'Buscando etiqueta NFC para borrar...';

  @override
  String get scanningTagForVerification =>
      'Escaneando etiqueta para verificación...';

  @override
  String get errorCreatingTextRecord => 'Error al crear registro de texto: ';

  @override
  String get errorCreatingUrlRecord => 'Error al crear registro de URL: ';

  @override
  String get errorCreatingWifiRecord => 'Error al crear registro WiFi: ';

  @override
  String get errorCreatingMultipleRecords =>
      'Error al crear múltiples registros: ';

  @override
  String get pleaseEnterAtLeastOneRecord =>
      'Por favor ingresa al menos un registro';

  @override
  String get tagType => 'Tipo de Etiqueta: ';

  @override
  String get tagId => 'ID de Etiqueta: ';

  @override
  String get ndefAvailable => 'NDEF Disponible: ';

  @override
  String get ndefWritable => 'NDEF Escribible: ';

  @override
  String get unknown => 'Desconocido';

  @override
  String get textCannotBeEmpty => 'El texto no puede estar vacío';

  @override
  String get urlCannotBeEmpty => 'La URL no puede estar vacía';

  @override
  String get wifiSsidCannotBeEmpty => 'El SSID de WiFi no puede estar vacío';

  @override
  String get defaultLanguage => 'es';

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
  String get unknownNull => 'Desconocido (nulo)';

  @override
  String get unknownType => 'Tipo desconocido: ';

  @override
  String get textPrefix => 'Texto: ';

  @override
  String get textSuffix => ' (Idioma: ';

  @override
  String get uriPrefix => 'URI: ';

  @override
  String get mimePrefix => 'MIME: ';

  @override
  String get absoluteUriPrefix => 'URI Absoluta: ';

  @override
  String get rawPrefix => 'Crudo: ';

  @override
  String get emptyPayload => 'Carga útil vacía';

  @override
  String get binaryDataPrefix => 'Datos binarios (';

  @override
  String get binaryDataSuffix => ' bytes): ';

  @override
  String get errorDecodingRecord => 'Error al decodificar registro: ';

  @override
  String get noNdefRecordsFound => 'No se encontraron registros NDEF';

  @override
  String get recordPrefix => 'Registro ';

  @override
  String get recordSuffix => ':';

  @override
  String get tnfLabel => 'TNF: ';

  @override
  String get typeLabel => 'Tipo: ';

  @override
  String get payloadSizeLabel => 'Tamaño de Carga Útil: ';

  @override
  String get bytesLabel => ' bytes';

  @override
  String get contentLabel => 'Contenido: ';

  @override
  String get rawPayloadLabel => 'Carga Útil Cruda: ';

  @override
  String get nullPayload => 'nulo';

  @override
  String get closingParenthesis => ')';

  @override
  String get closingParenthesisNewline => ')\n';

  @override
  String get scanYourNfcTag => 'Escanea tu etiqueta NFC';

  @override
  String get scanYourNfcTagToWrite => 'Escanea tu etiqueta NFC para escribir';

  @override
  String get scanYourNfcTagToClear => 'Escanea tu etiqueta NFC para borrar';

  @override
  String get scanTagToVerifyContent =>
      'Escanea la etiqueta para verificar contenido';

  @override
  String get tagIsNotNdefCompatible => 'La etiqueta no es compatible con NDEF';

  @override
  String get tagDoesNotSupportNdef => 'La etiqueta no soporta NDEF';

  @override
  String get tagIsNotWritable => 'La etiqueta no es escribible';

  @override
  String get tagDoesNotSupportNdefCannotClear =>
      'La etiqueta no soporta NDEF, no se puede borrar';

  @override
  String get tagIsNotWritableCannotClear =>
      'La etiqueta no es escribible, no se puede borrar';

  @override
  String get readOperationCompleted => 'Operación de lectura completada';

  @override
  String get writeOperationCompleted => 'Operación de escritura completada';

  @override
  String get clearOperationCompleted => 'Operación de borrado completada';

  @override
  String get ndefRecordsFound => 'Registros NDEF encontrados: ';

  @override
  String get theTagIsEmpty => 'La etiqueta está vacía';

  @override
  String get record => 'Registro ';

  @override
  String get type => 'Tipo: ';

  @override
  String get tnf => 'TNF: ';

  @override
  String get content => 'Contenido: ';

  @override
  String get noRecordsToWrite => 'No hay registros para escribir';

  @override
  String get ndefRecordsWrittenSuccessfully =>
      'Registros NDEF escritos exitosamente';

  @override
  String get recordsWritten => 'Registros escritos: ';

  @override
  String get writtenRecord => 'Registro escrito ';

  @override
  String get tagClearedSuccessfully => 'Etiqueta borrada exitosamente';

  @override
  String get method => 'Método: ';

  @override
  String get tagIsNowReadyForNewData =>
      'La etiqueta ahora está lista para nuevos datos';

  @override
  String get emptyTextRecord => 'Registro de texto vacío';

  @override
  String get emptyNdefRecord => 'Registro NDEF vacío';

  @override
  String get minimalSpaceCharacter => 'Carácter de espacio mínimo';

  @override
  String get emptyRecordList => 'Lista de registros vacía';

  @override
  String get allClearingMethodsFailed =>
      'Todos los métodos de borrado fallaron: ';

  @override
  String get verificationResults => 'Resultados de Verificación:';

  @override
  String get recordsFound => 'Registros encontrados: ';

  @override
  String get noNdefRecordsFoundOnTag =>
      'No se encontraron registros NDEF en la etiqueta';

  @override
  String get theTagIsEmptyCleared => 'La etiqueta está vacía/borrada';

  @override
  String get errorReadingTag => 'Error al leer etiqueta: ';

  @override
  String get errorWritingToTag => 'Error al escribir en la etiqueta: ';

  @override
  String get errorClearingTag => 'Error al borrar etiqueta: ';

  @override
  String get verificationError => 'Error de verificación: ';

  @override
  String get holdTagCloseAndTryAgain =>
      '. Mantén la etiqueta cerca e inténtalo de nuevo';

  @override
  String get tryHoldingTagCloser => '. Intenta mantener la etiqueta más cerca';

  @override
  String get tryMovingTagCloser => '. Intenta acercar la etiqueta';

  @override
  String get method1EmptyTextRecordFailed =>
      'El Método 1 (registro de texto vacío) falló: ';

  @override
  String get method2EmptyNdefRecordFailed =>
      'El Método 2 (registro NDEF vacío) falló: ';

  @override
  String get method3MinimalRecordFailed =>
      'El Método 3 (registro mínimo) falló: ';

  @override
  String get method4EmptyListFailed => 'El Método 4 (lista vacía) falló: ';

  @override
  String get errorFinishingNfcSession => 'Error al finalizar la sesión NFC: ';

  @override
  String get secondaryCleanupAlsoFailed =>
      'La limpieza secundaria también falló: ';

  @override
  String get multipleTagsFoundPleaseSelectOne =>
      'Múltiples etiquetas encontradas, por favor selecciona una';

  @override
  String get scanYourNfcTagDefault => 'Escanea tu etiqueta NFC';

  @override
  String get readNdefTags => 'Leer Etiquetas NDEF';

  @override
  String get reading => 'Leyendo...';

  @override
  String get readNfcTag => 'Leer Etiqueta NFC';

  @override
  String get verify => 'Verificar';

  @override
  String get clearing => 'Borrando...';

  @override
  String get clearNfcTag => 'Borrar Etiqueta NFC';

  @override
  String get monospaceFontFamily => 'monospace';

  @override
  String get nfcStatus => 'Estado NFC';

  @override
  String get refreshNfcStatus => 'Actualizar Estado NFC';

  @override
  String get writeNdefRecords => 'Escribir Registros NDEF';

  @override
  String get textRecord => 'Registro de Texto';

  @override
  String get enterTextToWriteToNfcTag =>
      'Ingresa texto para escribir en la etiqueta NFC';

  @override
  String get writing => 'Escribiendo...';

  @override
  String get writeText => 'Escribir Texto';

  @override
  String get urlRecord => 'Registro URL';

  @override
  String get enterUrl => 'Ingresar URL';

  @override
  String get writeUrl => 'Escribir URL';

  @override
  String get wifiRecord => 'Registro WiFi';

  @override
  String get wifiNetworkNameSsid => 'Nombre de Red WiFi (SSID)';

  @override
  String get wifiPassword => 'Contraseña WiFi';

  @override
  String get writeWifi => 'Escribir WiFi';

  @override
  String get writeAllRecords => 'Escribir Todos los Registros';

  @override
  String get writeAllNonEmptyFieldsDescription =>
      'Escribe todos los campos no vacíos en la etiqueta NFC a la vez';

  @override
  String get writeMultipleRecords => 'Escribir Múltiples Registros';

  @override
  String get readOperationFailed => 'Falló la operación de lectura';

  @override
  String get tagReadSuccessfully => 'Etiqueta leída exitosamente';

  @override
  String get verificationFailed => 'Verificación fallida';

  @override
  String get tagVerifiedSuccessfully => 'Etiqueta verificada exitosamente';

  @override
  String get clearNfcTagConfirmation =>
      '¿Estás seguro de que quieres borrar esta etiqueta NFC? Esta acción no se puede deshacer.';

  @override
  String get clearOperationFailed => 'Falló la operación de borrado';

  @override
  String get writeOperationFailed => 'Falló la operación de escritura';

  @override
  String get dataWrittenSuccessfully => 'Datos escritos exitosamente';

  @override
  String get nfcNotAvailable => 'NFC No Disponible';

  @override
  String get enableNfcMessage =>
      'Por favor activa el NFC en los ajustes de tu dispositivo para usar esta función.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get error => 'Error';

  @override
  String get successfully => 'exitosamente';

  @override
  String get language => 'Idioma';

  @override
  String get loading => 'Cargando...';

  @override
  String get exportXbm => 'Exportar XBM';

  @override
  String get exportingXbm => 'Exportando archivos XBM...';

  @override
  String get fullRefresh => 'Refresco Completo';

  @override
  String get fullRefreshSelected => 'Refresco Completo Seleccionado';

  @override
  String get waveformSelected => 'Seleccionado';

  @override
  String get barcode => 'Código de Barras';

  @override
  String get library => 'Biblioteca';

  @override
  String get templates => 'Plantillas';

  @override
  String get barcodeGenerator => 'Generador de Códigos de Barras';

  @override
  String get barcodeData => 'Datos del Código de Barras';

  @override
  String get barcodeDataHint => 'Ingresa número de código de barras o SKU';

  @override
  String get characters => 'Caracteres';

  @override
  String get scanBarcode => 'Escanear Código de Barras';

  @override
  String get barcodeFormat => 'Formato de Código de Barras';

  @override
  String get enterOrScanBarcodeData =>
      'Ingresa o escanea datos del código de barras';

  @override
  String get invalidBarcode => 'Código de Barras Inválido';

  @override
  String get invalidCharacter => 'Carácter inválido';

  @override
  String get supportedCharacters => 'Los caracteres compatibles son';

  @override
  String get pleaseCheckBarcodeRules =>
      'Por favor revisa las reglas del código de barras.';

  @override
  String get dataTooShort =>
      'Los datos son demasiado cortos. La longitud mínima para';

  @override
  String get dataTooLong =>
      'Los datos son demasiado largos. La longitud máxima para';

  @override
  String get isText => 'es';

  @override
  String get pointCameraAtBarcode =>
      'Apunta la cámara al código de barras para escanear';

  @override
  String get generateImage => 'Generar Imagen';

  @override
  String get exportFailed => 'La exportación falló';

  @override
  String get exportedXbmFiles =>
      'Archivo(s) XBM exportado(s) a MagicEpaper/XBM/';

  @override
  String get exported => 'Exportado';

  @override
  String get xbmFilesToMagicEpaper => 'Archivo(s) XBM a MagicEpaper/XBM/';

  @override
  String get floydSteinberg => 'Clásico';

  @override
  String get stucki => 'Nítido';

  @override
  String get atkinson => 'Vintage';

  @override
  String get falseFloydSteinberg => 'Simple';

  @override
  String get halftone => 'Periódico';

  @override
  String get threshold => 'Posterizar';

  @override
  String get colorHalftone => 'Periódico en Color';

  @override
  String get searchingForDevice => 'Buscando Dispositivo';

  @override
  String get displayRefreshing => 'Refrescando Pantalla';

  @override
  String get transferComplete => '¡Transferencia completa!';

  @override
  String get writingToEpaper => 'Escribiendo en ePaper';

  @override
  String get pleaseBringPhoneClose =>
      'Por favor acerca tu teléfono al dispositivo Magic ePaper';

  @override
  String get keepPhoneClose => '¡Mantén tu teléfono cerca!';

  @override
  String get displayRefreshingMessage =>
      'La pantalla se está refrescando. Por favor mantén tu teléfono cerca del dispositivo hasta que la imagen aparezca por completo.';

  @override
  String get transferFailed => 'Transferencia Fallida';

  @override
  String get deviceConnectionTimeout =>
      'Se agotó el tiempo de conexión del dispositivo. Por favor intenta acercar tu teléfono al dispositivo e inténtalo de nuevo.';

  @override
  String get connectionLostDuringTransfer =>
      'Se perdió la conexión durante la transferencia. Por favor mantén tu teléfono cerca del dispositivo e inténtalo de nuevo.';

  @override
  String get done => 'Hecho';

  @override
  String get close => 'Cerrar';

  @override
  String get processingImage => 'Procesando Imagen...';

  @override
  String get readyToFlash => 'Listo para Flashear';

  @override
  String get imageProcessedSuccessfully => 'Imagen procesada exitosamente.';

  @override
  String get tapBelowAndHold =>
      'Toca abajo y mantén tu teléfono cerca de la pantalla.';

  @override
  String get startFlashing => 'Comenzar Flasheo';

  @override
  String get flashing => 'Flasheando...';

  @override
  String get keepPhoneStill => 'Mantén tu teléfono quieto.';

  @override
  String get success => '¡Éxito!';

  @override
  String get transferCompleteMessage => '¡Transferencia completa!';

  @override
  String get unknownErrorOccurred => 'Ocurrió un error desconocido.';

  @override
  String get resultsCleared => 'Resultados borrados';

  @override
  String get clearResults => 'Borrar Resultados';

  @override
  String get vCardContact => 'Contacto vCard';

  @override
  String get writingVCard => 'Escribiendo vCard...';

  @override
  String get writeVCard => 'Escribir vCard';

  @override
  String get firstName => 'Nombre';

  @override
  String get lastName => 'Apellido';

  @override
  String get organization => 'Organización';

  @override
  String get title => 'Título';

  @override
  String get mobileNumber => 'Número de Móvil';

  @override
  String get emailAddress => 'Correo Electrónico';

  @override
  String get streetAddress => 'Dirección';

  @override
  String get city => 'Ciudad';

  @override
  String get zipCode => 'Código Postal';

  @override
  String get country => 'País';

  @override
  String get website => 'Sitio Web';

  @override
  String get noSavedImagesYet => 'Aún no hay imágenes guardadas';

  @override
  String get saveImagesFromEditor =>
      'Guarda imágenes desde el editor o importa nuevas';

  @override
  String get enterWifiSSID => 'Ingresa el SSID de WiFi';

  @override
  String get enterWifiPassword => 'Ingresa la contraseña de WiFi';

  @override
  String get writeMultiple => 'Escribir Múltiples';

  @override
  String get searchImages => 'Buscar imágenes...';

  @override
  String get filter => 'Filtro:';

  @override
  String get all => 'Todo';

  @override
  String get imported => 'Importado';

  @override
  String get editor => 'Editor';

  @override
  String get imageLibrary => 'Biblioteca de Imágenes';

  @override
  String get selectImagesToDelete => 'Seleccionar Imágenes para Eliminar';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteMode => 'Modo Eliminar';

  @override
  String get deleteImage => 'Eliminar Imagen';

  @override
  String get thisActionCannotBeUndone => 'Esta acción no se puede deshacer';

  @override
  String get filterLabel => 'Filtro:';

  @override
  String get areYouSureDeleteImage =>
      '¿Estás seguro de que quieres eliminar esta imagen? Esta acción no se puede deshacer.';

  @override
  String get deleteMultipleImages => 'Eliminar Múltiples Imágenes';

  @override
  String get imagesSelected => 'imagen(es) seleccionada(s)';

  @override
  String get imagesSelectedForDeletion =>
      'imagen(es) seleccionada(s) para eliminar';

  @override
  String areYouSureDeleteMultipleImages(Object count) {
    return '¿Estás seguro de que quieres eliminar estas $count imágenes? Esta acción no se puede deshacer.';
  }

  @override
  String get areYouSureDeleteSingleImage =>
      '¿Estás seguro de que quieres eliminar esta imagen? Esta acción no se puede deshacer.';

  @override
  String get deleteAll => 'Eliminar Todo';

  @override
  String get renameImage => 'Renombrar Imagen';

  @override
  String get enterNewNameForImage => 'Ingresa un nuevo nombre para tu imagen';

  @override
  String get imageName => 'Nombre de Imagen';

  @override
  String get enterImageName => 'Ingresar nombre de imagen...';

  @override
  String get rename => 'Renombrar';

  @override
  String get imageProperties => 'Propiedades de Imagen';

  @override
  String get created => 'Creado';

  @override
  String get source => 'Fuente:';

  @override
  String get epdModel => 'Modelo EPD:';

  @override
  String get transferToEpaper => 'Transferir a ePaper';

  @override
  String get saveImage => 'Guardar Imagen';

  @override
  String get saveFilteredImageToLibrary =>
      'Guarda tu imagen filtrada en la biblioteca';

  @override
  String get filterApplied => 'Filtro Aplicado:';

  @override
  String get save => 'Guardar';

  @override
  String get noImagesMatchSearch => 'Ninguna imagen coincide con tu búsqueda';

  @override
  String get vCardDataCannotBeEmpty =>
      'Los datos de la vCard no pueden estar vacíos';

  @override
  String get renamingImage => 'Renombrando imagen...';

  @override
  String get imageRenamedTo => 'Imagen renombrada a \"';

  @override
  String get failedToRenameImage => 'Error al renombrar imagen: ';

  @override
  String get deletingImage => 'Eliminando imagen...';

  @override
  String get imageDeleted => 'Imagen \"';

  @override
  String get deleted => '\" eliminada';

  @override
  String get failedToDeleteImage => 'Error al eliminar imagen: ';

  @override
  String get deletingImages => 'Eliminando ';

  @override
  String get images => ' imagen(es)...';

  @override
  String get failedToDeleteImages => 'Error al eliminar imágenes: ';

  @override
  String get imagesDeletedSuccessfully => ' imágenes eliminadas exitosamente';

  @override
  String get imageDeletedSuccessfully => 'Imagen eliminada exitosamente';

  @override
  String get failedToLoadImageData => 'Error al cargar datos de imagen para \"';

  @override
  String get failedToDecodeImage => 'Error al decodificar imagen \"';

  @override
  String get failedToTransfer => 'Error al transferir \"';

  @override
  String get savingImage => 'Guardando imagen...';

  @override
  String get imageSavedToLibrary => '¡Imagen guardada en la biblioteca!';

  @override
  String get failedToSaveImage => 'Error al guardar imagen: ';

  @override
  String get errorCreatingVCardRecord => 'Error al crear registro vCard: ';

  @override
  String get nfcIsDisabledPleaseEnableIt =>
      'El NFC está desactivado. Por favor actívalo.';

  @override
  String get thisDeviceDoesNotSupportNfc => 'Este dispositivo no soporta NFC.';

  @override
  String get bringPhoneNearMagicEpaperHardware =>
      'Acerca tu teléfono al Hardware Magic ePaper';

  @override
  String get tagDetectedInitializing => '¡Etiqueta detectada! Inicializando...';

  @override
  String get enablingEnergyHarvesting =>
      'Habilitando recolección de energía...';

  @override
  String get processingImageData => 'Procesando datos de imagen...';

  @override
  String get refreshingDisplay => 'Refrescando pantalla...';

  @override
  String get notMagicEpaperHardware => 'No es un Hardware Magic ePaper';

  @override
  String get errorCheckingMessage => 'Error al verificar mensaje: ';

  @override
  String get timeoutWaitingForI2cMessage =>
      'Se agotó el tiempo de espera del mensaje I2C';

  @override
  String get writingChunk => 'Escribiendo fragmento ';

  @override
  String get transferredSuccessfully => 'Transferido exitosamente.';

  @override
  String get waitingForNfcTag => 'Esperando etiqueta NFC...';

  @override
  String get gotTag => '¡Etiqueta encontrada!';

  @override
  String get frame => 'Fotograma ';

  @override
  String get couldNotOpenLink => 'No se pudo abrir el enlace.';

  @override
  String get errorOccurredWhileOpeningLink =>
      'Ocurrió un error al abrir el enlace.';

  @override
  String get errorCreatingAppRecord =>
      'Error al crear registro de aplicación: ';

  @override
  String get appCannotBeEmpty => 'La aplicación no puede estar vacía';

  @override
  String get invalidPackageName => 'Nombre de paquete inválido';

  @override
  String get writeAppLauncherData =>
      'Escribir Datos del Lanzador de Aplicaciones';

  @override
  String get writeAppLauncher => 'Escribir Lanzador de Aplicaciones';

  @override
  String get searchApps => 'Buscar aplicaciones...';

  @override
  String get customPackageName => 'Nombre de Paquete Personalizado';

  @override
  String get enterPackageName => 'Ingresa el nombre del paquete...';

  @override
  String get noAppsFound => 'No se encontraron aplicaciones';

  @override
  String get selectApplication => 'Seleccionar Aplicación';

  @override
  String get errorLoadingApps => 'Error al cargar aplicaciones: ';

  @override
  String get add => 'Agregar';

  @override
  String get readNfcTags => 'Leer Etiquetas NFC';

  @override
  String get writeNfcTags => 'Escribir Etiquetas NFC';

  @override
  String get nfcIsReadyToUse =>
      'NFC está listo para usar. Puedes leer y escribir etiquetas NFC.';

  @override
  String get deviceDoesNotSupportNfc =>
      'Este dispositivo no soporta la funcionalidad NFC.';

  @override
  String get pleaseEnableNfcInSettings =>
      'Por favor activa el NFC en los ajustes de tu dispositivo para continuar.';

  @override
  String get nfcIsNowEnabledAndReady =>
      '¡El NFC ahora está activado y listo para usar!';

  @override
  String get nfcHasBeenDisabled =>
      'El NFC ha sido desactivado. Por favor actívalo para continuar usando las funciones NFC.';

  @override
  String get nfcIsNotSupportedOnDevice =>
      'El NFC no es compatible con este dispositivo.';

  @override
  String get arduinoExport => 'Exportar para Arduino';

  @override
  String get exportXmbFilesForArduino => 'Exportar archivos XMB para Arduino';

  @override
  String get cardTemplates => 'Plantillas de Tarjetas';

  @override
  String get chooseTemplateSubtitle => 'Elige una plantilla para comenzar';

  @override
  String get employeeIdCardTitle => 'Tarjeta de Identificación de Empleado';

  @override
  String get employeeIdCardDescription =>
      'Crea tarjetas de identificación profesionales para empleados';

  @override
  String get shopPriceTagTitle => 'Etiqueta de Precio para Tienda';

  @override
  String get shopPriceTagDescription =>
      'Diseña etiquetas de precio atractivas para tus productos';

  @override
  String get entryPassTagTitle => 'Pase de Entrada';

  @override
  String get entryPassTagDescription =>
      'Genera pases de entrada para eventos y lugares';

  @override
  String get eventBadgeTitle => 'Insignia de Evento';

  @override
  String get eventBadgeDescription =>
      'Crea insignias y etiquetas de nombre personalizadas para eventos';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get comingSoonMessage =>
      'Esta plantilla se encuentra actualmente en desarrollo y estará disponible pronto.';

  @override
  String get ok => 'Aceptar';

  @override
  String get defaultCompanyName => 'Nombre de la Empresa';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get positionLabel => 'Puesto';

  @override
  String get divisionLabel => 'División';

  @override
  String get idLabel => 'ID';

  @override
  String get emptyFieldPlaceholder => 'No especificado';

  @override
  String get productImage => 'Imagen del Producto';

  @override
  String get productName => 'Nombre del Producto';

  @override
  String get sizeQuantity => 'Tamaño/Cantidad';

  @override
  String get defaultCurrency => '\$';

  @override
  String get defaultPrice => '0.00';

  @override
  String get price => 'Precio';

  @override
  String get quantitySize => 'Cantidad/Tamaño';

  @override
  String get quantitySizeHint =>
      'Ingresa el tamaño/cantidad (ej. 750ml, 2kg, Grande)';

  @override
  String get namePrefix => 'Nombre: ';

  @override
  String get positionPrefix => 'Puesto: ';

  @override
  String get divisionPrefix => 'División: ';

  @override
  String get idPrefix => 'ID: ';

  @override
  String get employeeIdCard => 'Tarjeta de Identificación de Empleado';

  @override
  String get fillDetailsToCreateId =>
      'Completa los detalles a continuación para crear tu tarjeta de identificación de empleado';

  @override
  String get idCardDetails => 'Detalles de la Tarjeta';

  @override
  String get companyName => 'Nombre de la Empresa';

  @override
  String get enterCompanyName => 'Ingresa el nombre de la empresa';

  @override
  String get pleaseEnterCompanyName =>
      'Por favor ingresa el nombre de la empresa';

  @override
  String get name => 'Nombre';

  @override
  String get enterEmployeeName => 'Ingresa el nombre del empleado';

  @override
  String get pleaseEnterName => 'Por favor ingresa el nombre';

  @override
  String get position => 'Puesto';

  @override
  String get enterJobPosition => 'Ingresa el puesto de trabajo';

  @override
  String get pleaseEnterPosition => 'Por favor ingresa el puesto';

  @override
  String get division => 'División';

  @override
  String get enterDepartment => 'Ingresa el departamento';

  @override
  String get pleaseEnterDivision => 'Por favor ingresa la división';

  @override
  String get idNumber => 'Número de ID';

  @override
  String get enterUniqueId => 'Ingresa un ID único';

  @override
  String get pleaseEnterIdNumber => 'Por favor ingresa el número de ID';

  @override
  String get qrCodeData => 'Datos del Código QR';

  @override
  String get enterQrCodeData => 'Ingresa los datos del código QR';

  @override
  String get pleaseEnterQrCodeData =>
      'Por favor ingresa los datos del código QR';

  @override
  String get generatingIdCard => 'Generando Tarjeta de Identificación...';

  @override
  String get generateIdCard => 'Generar Tarjeta';

  @override
  String get profilePhoto => 'Foto de Perfil';

  @override
  String get selected => 'Seleccionado';

  @override
  String get photoSelected => 'Foto seleccionada';

  @override
  String get selectProfilePhoto => 'Seleccionar Foto de Perfil';

  @override
  String get tapToChangePhoto => 'Toca para cambiar la foto';

  @override
  String get tapToSelectFromGallery => 'Toca para seleccionar de la galería';

  @override
  String get priceTagGenerator => 'Generador de Etiquetas de Precio';

  @override
  String get priceTagDescription =>
      'Crea etiquetas de precio profesionales para tus productos';

  @override
  String get productDetails => 'Detalles del Producto';

  @override
  String get productNameHint =>
      'Ingresa nombre del producto (ej. iPhone 15 Pro)';

  @override
  String get pleaseEnterProductName =>
      'Por favor ingresa un nombre para el producto';

  @override
  String get currency => 'Moneda';

  @override
  String get currencyHint => '€';

  @override
  String get required => 'Obligatororio';

  @override
  String get priceHint => '999.99';

  @override
  String get pleaseEnterPrice => 'Por favor ingresa el precio';

  @override
  String get pleaseEnterQuantitySize =>
      'Por favor ingresa la cantidad o el tamaño';

  @override
  String get pleaseEnterBarcodeData =>
      'Por favor ingresa los datos del código de barras';

  @override
  String get generatingPriceTag => 'Generando Etiqueta de Precio...';

  @override
  String get generatePriceTag => 'Generar Etiqueta de Precio';

  @override
  String get productImageIn => 'Imagen del Producto';

  @override
  String get productImageSelected => 'Imagen del Producto Seleccionada';

  @override
  String get selectProductImage => 'Seleccionar Imagen del Producto';

  @override
  String get tapToChangeImage => 'Toca para cambiar la imagen';

  @override
  String get chooseImageFromGallery => 'Elige una imagen de la galería';

  @override
  String get processingImages => 'Procesando imágenes...';

  @override
  String get refreshModeInfo => 'Información sobre el Modo de Refresco';

  @override
  String get fullRefreshInfo => 'Refresco Completo';

  @override
  String get fullRefreshDescription =>
      'Refresca por completo toda la pantalla limpiando todos los píxeles y volviendo a dibujar la imagen. Esto proporciona la mejor calidad de imagen y contraste, pero tarda más en completarse.';

  @override
  String get partialRefreshInfo => 'Refresco Parcial (Formas de Onda)';

  @override
  String get partialRefreshDescription =>
      'Actualiza solo los píxeles cambiados utilizando formas de onda optimizadas. Es más rápido que el refresco completo, pero puede provocar imágenes fantasma o reducción de contraste con el tiempo.';

  @override
  String get longPressForInfo => 'Mantén presionado para más información';
}
