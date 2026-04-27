// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'Magic ePaper';

  @override
  String get aboutUsDescription =>
      'Magic ePaper — це додаток, розроблений для керування та оновлення дисплеїв ePaper. Мета полягає в тому, щоб надати інструменти для налаштування та передачі зображень, тексту та шаблонів на екрани ePaper за допомогою NFC. Передача даних зі смартфона на обладнання ePaper здійснюється бездротовим шляхом через NFC. Проєкт побудований на основі спеціальної прошивки та драйверів дисплея для безперебійного зв\'язку та ефективного рендерингу зображень.';

  @override
  String get developedBy => 'Розроблено';

  @override
  String get fossasiaContributors => 'Учасники FOSSASIA';

  @override
  String get contactWithUs => 'Зв\'яжіться з нами';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle =>
      'Зробіть форк репозиторію та надішліть зміни або повідомте про нові проблеми.';

  @override
  String get license => 'Ліцензія';

  @override
  String get licenseSubtitle =>
      'Ознайомтеся з умовами ліцензії Apache License 2.0, що використовуються в Magic ePaper.';

  @override
  String get createTransfer => 'Створення та передача зображень';

  @override
  String get ndefScreen => 'Ndef';

  @override
  String get selectDisplayType => 'Оберіть тип дисплея ePaper';

  @override
  String get settings => 'Налаштування';

  @override
  String get aboutUs => 'Про нас';

  @override
  String get other => 'Інше';

  @override
  String get getBadge => 'Отримати значок';

  @override
  String get feedbackBugReports => 'Відгуки / Звіти про помилки';

  @override
  String get continueButton => 'Продовжити';

  @override
  String get noImageSelectedFeedback => 'Спочатку імпортуйте зображення!';

  @override
  String get adjustButtonLabel => 'Налаштувати';

  @override
  String get importImageButtonLabel => 'Імпорт';

  @override
  String get openEditor => 'Створити';

  @override
  String get importStartingImageFeedback => 'Імпортуйте зображення, щоб почати';

  @override
  String get transferButtonLabel => 'Передати';

  @override
  String get filterScreenTitle => 'Виберіть фільтр';

  @override
  String get scanningForNfcTag => 'Пошук NFC-мітки...';

  @override
  String get scanningForNfcTagToWrite => 'Пошук NFC-мітки для запису...';

  @override
  String get scanningForNfcTagToClear => 'Пошук NFC-мітки для очищення...';

  @override
  String get scanningTagForVerification => 'Сканування мітки для перевірки...';

  @override
  String get errorCreatingTextRecord => 'Помилка створення текстового запису: ';

  @override
  String get errorCreatingUrlRecord => 'Помилка створення URL-запису: ';

  @override
  String get errorCreatingWifiRecord => 'Помилка створення запису WiFi: ';

  @override
  String get errorCreatingMultipleRecords =>
      'Помилка створення кількох записів: ';

  @override
  String get pleaseEnterAtLeastOneRecord =>
      'Будь ласка, введіть принаймні один запис';

  @override
  String get tagType => 'Тип мітки: ';

  @override
  String get tagId => 'ID мітки: ';

  @override
  String get ndefAvailable => 'NDEF доступний: ';

  @override
  String get ndefWritable => 'NDEF доступний для запису: ';

  @override
  String get unknown => 'Невідомо';

  @override
  String get textCannotBeEmpty => 'Текст не може бути порожнім';

  @override
  String get urlCannotBeEmpty => 'URL не може бути порожнім';

  @override
  String get wifiSsidCannotBeEmpty => 'SSID WiFi не може бути порожнім';

  @override
  String get defaultLanguage => 'uk';

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
  String get unknownNull => 'Невідомо (null)';

  @override
  String get unknownType => 'Невідомий тип: ';

  @override
  String get textPrefix => 'Текст: ';

  @override
  String get textSuffix => ' (Мова: ';

  @override
  String get uriPrefix => 'URI: ';

  @override
  String get mimePrefix => 'MIME: ';

  @override
  String get absoluteUriPrefix => 'Абсолютний URI: ';

  @override
  String get rawPrefix => 'Необроблені дані: ';

  @override
  String get emptyPayload => 'Порожнє корисне навантаження';

  @override
  String get binaryDataPrefix => 'Двійкові дані (';

  @override
  String get binaryDataSuffix => ' байт): ';

  @override
  String get errorDecodingRecord => 'Помилка декодування запису: ';

  @override
  String get noNdefRecordsFound => 'Записи NDEF не знайдено';

  @override
  String get recordPrefix => 'Запис ';

  @override
  String get recordSuffix => ':';

  @override
  String get tnfLabel => 'TNF: ';

  @override
  String get typeLabel => 'Тип: ';

  @override
  String get payloadSizeLabel => 'Розмір корисного навантаження: ';

  @override
  String get bytesLabel => ' байт';

  @override
  String get contentLabel => 'Вміст: ';

  @override
  String get rawPayloadLabel => 'Необроблене корисне навантаження: ';

  @override
  String get nullPayload => 'null';

  @override
  String get closingParenthesis => ')';

  @override
  String get closingParenthesisNewline => ')\n';

  @override
  String get scanYourNfcTag => 'Відскануйте свою NFC-мітку';

  @override
  String get scanYourNfcTagToWrite => 'Відскануйте NFC-мітку для запису';

  @override
  String get scanYourNfcTagToClear => 'Відскануйте NFC-мітку для очищення';

  @override
  String get scanTagToVerifyContent => 'Відскануйте мітку для перевірки вмісту';

  @override
  String get tagIsNotNdefCompatible => 'Мітка не сумісна з NDEF';

  @override
  String get tagDoesNotSupportNdef => 'Мітка не підтримує NDEF';

  @override
  String get tagIsNotWritable => 'Мітка недоступна для запису';

  @override
  String get tagDoesNotSupportNdefCannotClear =>
      'Мітка не підтримує NDEF, очищення неможливе';

  @override
  String get tagIsNotWritableCannotClear =>
      'Мітка недоступна для запису, очищення неможливе';

  @override
  String get readOperationCompleted => 'Операцію читання завершено';

  @override
  String get writeOperationCompleted => 'Операцію запису завершено';

  @override
  String get clearOperationCompleted => 'Операцію очищення завершено';

  @override
  String get ndefRecordsFound => 'Знайдено записи NDEF: ';

  @override
  String get theTagIsEmpty => 'Мітка порожня';

  @override
  String get record => 'Запис ';

  @override
  String get type => 'Тип: ';

  @override
  String get tnf => 'TNF: ';

  @override
  String get content => 'Вміст: ';

  @override
  String get noRecordsToWrite => 'Немає записів для запису';

  @override
  String get ndefRecordsWrittenSuccessfully => 'Записи NDEF успішно записані';

  @override
  String get recordsWritten => 'Записано записів: ';

  @override
  String get writtenRecord => 'Записаний запис ';

  @override
  String get tagClearedSuccessfully => 'Мітку успішно очищено';

  @override
  String get method => 'Метод: ';

  @override
  String get tagIsNowReadyForNewData => 'Тепер мітка готова для нових даних';

  @override
  String get emptyTextRecord => 'Порожній текстовий запис';

  @override
  String get emptyNdefRecord => 'Порожній запис NDEF';

  @override
  String get minimalSpaceCharacter => 'Мінімальний символ пробілу';

  @override
  String get emptyRecordList => 'Порожній список записів';

  @override
  String get allClearingMethodsFailed =>
      'Усі методи очищення завершилися невдало: ';

  @override
  String get verificationResults => 'Результати перевірки:';

  @override
  String get recordsFound => 'Знайдено записи: ';

  @override
  String get noNdefRecordsFoundOnTag => 'На мітці не знайдено записів NDEF';

  @override
  String get theTagIsEmptyCleared => 'Мітка порожня/очищена';

  @override
  String get errorReadingTag => 'Помилка під час читання мітки: ';

  @override
  String get errorWritingToTag => 'Помилка під час запису на мітку: ';

  @override
  String get errorClearingTag => 'Помилка під час очищення мітки: ';

  @override
  String get verificationError => 'Помилка перевірки: ';

  @override
  String get holdTagCloseAndTryAgain =>
      '. Тримайте мітку близько і спробуйте знову';

  @override
  String get tryHoldingTagCloser => '. Спробуйте піднести мітку ближче';

  @override
  String get tryMovingTagCloser => '. Спробуйте присунути мітку ближче';

  @override
  String get method1EmptyTextRecordFailed =>
      'Метод 1 (порожній текстовий запис) не вдався: ';

  @override
  String get method2EmptyNdefRecordFailed =>
      'Метод 2 (порожній запис NDEF) не вдався: ';

  @override
  String get method3MinimalRecordFailed =>
      'Метод 3 (мінімальний запис) не вдався: ';

  @override
  String get method4EmptyListFailed => 'Метод 4 (порожній список) не вдався: ';

  @override
  String get errorFinishingNfcSession =>
      'Помилка під час завершення сеансу NFC: ';

  @override
  String get secondaryCleanupAlsoFailed =>
      'Вторинне очищення також не вдалося: ';

  @override
  String get multipleTagsFoundPleaseSelectOne =>
      'Знайдено кілька міток, будь ласка, виберіть одну';

  @override
  String get scanYourNfcTagDefault => 'Відскануйте свою NFC-мітку';

  @override
  String get readNdefTags => 'Зчитати мітки NDEF';

  @override
  String get reading => 'Читання...';

  @override
  String get readNfcTag => 'Прочитати NFC-мітку';

  @override
  String get verify => 'Перевірити';

  @override
  String get clearing => 'Очищення...';

  @override
  String get clearNfcTag => 'Очистити NFC-мітку';

  @override
  String get monospaceFontFamily => 'monospace';

  @override
  String get nfcStatus => 'Статус NFC';

  @override
  String get refreshNfcStatus => 'Оновити статус NFC';

  @override
  String get writeNdefRecords => 'Записати записи NDEF';

  @override
  String get textRecord => 'Текстовий запис';

  @override
  String get enterTextToWriteToNfcTag =>
      'Введіть текст для запису на NFC-мітку';

  @override
  String get writing => 'Запис...';

  @override
  String get writeText => 'Записати текст';

  @override
  String get urlRecord => 'Запис URL';

  @override
  String get enterUrl => 'Введіть URL';

  @override
  String get writeUrl => 'Записати URL';

  @override
  String get wifiRecord => 'Запис WiFi';

  @override
  String get wifiNetworkNameSsid => 'Назва мережі WiFi (SSID)';

  @override
  String get wifiPassword => 'Пароль WiFi';

  @override
  String get writeWifi => 'Записати WiFi';

  @override
  String get writeAllRecords => 'Записати всі записи';

  @override
  String get writeAllNonEmptyFieldsDescription =>
      'Записати всі непусті поля на NFC-мітку одночасно';

  @override
  String get writeMultipleRecords => 'Записати кілька записів';

  @override
  String get readOperationFailed => 'Операція читання не вдалася';

  @override
  String get tagReadSuccessfully => 'Мітку успішно прочитано';

  @override
  String get verificationFailed => 'Перевірка не вдалася';

  @override
  String get tagVerifiedSuccessfully => 'Мітку успішно перевірено';

  @override
  String get clearNfcTagConfirmation =>
      'Ви впевнені, що хочете очистити цю NFC-мітку? Цю дію неможливо скасувати.';

  @override
  String get clearOperationFailed => 'Операція очищення не вдалася';

  @override
  String get writeOperationFailed => 'Операція запису не вдалася';

  @override
  String get dataWrittenSuccessfully => 'Дані успішно записані';

  @override
  String get nfcNotAvailable => 'NFC недоступний';

  @override
  String get enableNfcMessage =>
      'Будь ласка, увімкніть NFC у налаштуваннях вашого пристрою, щоб використовувати цю функцію.';

  @override
  String get cancel => 'Скасувати';

  @override
  String get confirm => 'Підтвердити';

  @override
  String get error => 'Помилка';

  @override
  String get successfully => 'успішно';

  @override
  String get language => 'Мова';

  @override
  String get loading => 'Завантаження...';

  @override
  String get exportXbm => 'Експорт XBM';

  @override
  String get exportingXbm => 'Експорт файлів XBM...';

  @override
  String get fullRefresh => 'Повне оновлення';

  @override
  String get fullRefreshSelected => 'Вибрано повне оновлення';

  @override
  String get waveformSelected => 'Вибрано';

  @override
  String get barcode => 'Штрих-код';

  @override
  String get library => 'Бібліотека';

  @override
  String get templates => 'Шаблони';

  @override
  String get barcodeGenerator => 'Генератор штрих-кодів';

  @override
  String get barcodeData => 'Дані штрих-коду';

  @override
  String get barcodeDataHint => 'Введіть номер штрих-коду або SKU';

  @override
  String get characters => 'Символи';

  @override
  String get scanBarcode => 'Сканувати штрих-код';

  @override
  String get barcodeFormat => 'Формат штрих-коду';

  @override
  String get enterOrScanBarcodeData =>
      'Введіть або відскануйте дані штрих-коду';

  @override
  String get invalidBarcode => 'Недійсний штрих-код';

  @override
  String get invalidCharacter => 'Неприпустимий символ';

  @override
  String get supportedCharacters => 'Підтримувані символи:';

  @override
  String get pleaseCheckBarcodeRules =>
      'Будь ласка, перевірте правила для штрих-кодів.';

  @override
  String get dataTooShort => 'Дані занадто короткі. Мінімальна довжина для';

  @override
  String get dataTooLong => 'Дані занадто довгі. Максимальна довжина для';

  @override
  String get isText => 'становить';

  @override
  String get pointCameraAtBarcode =>
      'Наведіть камеру на штрих-код для сканування';

  @override
  String get generateImage => 'Згенерувати зображення';

  @override
  String get exportFailed => 'Помилка експорту';

  @override
  String get exportedXbmFiles => 'Файл(и) XBM експортовано до MagicEpaper/XBM/';

  @override
  String get exported => 'Експортовано';

  @override
  String get xbmFilesToMagicEpaper => 'Файл(и) XBM до MagicEpaper/XBM/';

  @override
  String get floydSteinberg => 'Класичний';

  @override
  String get stucki => 'Різкий';

  @override
  String get atkinson => 'Вінтаж';

  @override
  String get falseFloydSteinberg => 'Простий';

  @override
  String get halftone => 'Газета';

  @override
  String get threshold => 'Постеризація';

  @override
  String get colorHalftone => 'Кольорова газета';

  @override
  String get searchingForDevice => 'Пошук пристрою';

  @override
  String get displayRefreshing => 'Оновлення дисплея';

  @override
  String get transferComplete => 'Передачу завершено!';

  @override
  String get writingToEpaper => 'Запис на ePaper';

  @override
  String get pleaseBringPhoneClose =>
      'Будь ласка, піднесіть телефон до пристрою Magic ePaper';

  @override
  String get keepPhoneClose => 'Тримайте телефон близько!';

  @override
  String get displayRefreshingMessage =>
      'Дисплей оновлюється. Будь ласка, тримайте телефон біля пристрою, доки зображення не з\'явиться повністю.';

  @override
  String get transferFailed => 'Передача не вдалася';

  @override
  String get deviceConnectionTimeout =>
      'Час очікування підключення до пристрою минув. Будь ласка, спробуйте піднести телефон ближче до пристрою та повторіть спробу.';

  @override
  String get connectionLostDuringTransfer =>
      'Зв\'язок було втрачено під час передачі. Будь ласка, тримайте телефон близько до пристрою та повторіть спробу.';

  @override
  String get done => 'Готово';

  @override
  String get close => 'Закрити';

  @override
  String get processingImage => 'Обробка зображення...';

  @override
  String get readyToFlash => 'Готово до прошивки';

  @override
  String get imageProcessedSuccessfully => 'Зображення успішно оброблено.';

  @override
  String get tapBelowAndHold =>
      'Натисніть нижче та тримайте телефон біля дисплея.';

  @override
  String get startFlashing => 'Почати прошивку';

  @override
  String get flashing => 'Прошивка...';

  @override
  String get keepPhoneStill => 'Тримайте телефон нерухомо.';

  @override
  String get success => 'Успіх!';

  @override
  String get transferCompleteMessage => 'Передачу завершено!';

  @override
  String get unknownErrorOccurred => 'Сталася невідома помилка.';

  @override
  String get resultsCleared => 'Результати очищено';

  @override
  String get clearResults => 'Очистити результати';

  @override
  String get vCardContact => 'Контакт vCard';

  @override
  String get writingVCard => 'Запис vCard...';

  @override
  String get writeVCard => 'Записати vCard';

  @override
  String get firstName => 'Ім\'я';

  @override
  String get lastName => 'Прізвище';

  @override
  String get organization => 'Організація';

  @override
  String get title => 'Посада';

  @override
  String get mobileNumber => 'Мобільний номер';

  @override
  String get emailAddress => 'Електронна адреса';

  @override
  String get streetAddress => 'Адреса (вулиця)';

  @override
  String get city => 'Місто';

  @override
  String get zipCode => 'Поштовий індекс';

  @override
  String get country => 'Країна';

  @override
  String get website => 'Вебсайт';

  @override
  String get noSavedImagesYet => 'Поки немає збережених зображень';

  @override
  String get saveImagesFromEditor =>
      'Зберігайте зображення з редактора або імпортуйте нові';

  @override
  String get enterWifiSSID => 'Введіть SSID WiFi';

  @override
  String get enterWifiPassword => 'Введіть пароль WiFi';

  @override
  String get writeMultiple => 'Записати декілька';

  @override
  String get searchImages => 'Пошук зображень...';

  @override
  String get filter => 'Фільтр:';

  @override
  String get all => 'Усі';

  @override
  String get imported => 'Імпортовані';

  @override
  String get editor => 'Редактор';

  @override
  String get imageLibrary => 'Бібліотека зображень';

  @override
  String get selectImagesToDelete => 'Виберіть зображення для видалення';

  @override
  String get delete => 'Видалити';

  @override
  String get deleteMode => 'Режим видалення';

  @override
  String get deleteImage => 'Видалити зображення';

  @override
  String get thisActionCannotBeUndone => 'Цю дію неможливо скасувати';

  @override
  String get filterLabel => 'Фільтр:';

  @override
  String get areYouSureDeleteImage =>
      'Ви впевнені, що хочете видалити це зображення? Цю дію неможливо скасувати.';

  @override
  String get deleteMultipleImages => 'Видалити кілька зображень';

  @override
  String get imagesSelected => 'зображень вибрано';

  @override
  String get imagesSelectedForDeletion => 'зображень вибрано для видалення';

  @override
  String areYouSureDeleteMultipleImages(Object count) {
    return 'Ви впевнені, що хочете видалити ці $count зображень? Цю дію неможливо скасувати.';
  }

  @override
  String get areYouSureDeleteSingleImage =>
      'Ви впевнені, що хочете видалити це зображення? Цю дію неможливо скасувати.';

  @override
  String get deleteAll => 'Видалити всі';

  @override
  String get renameImage => 'Перейменувати зображення';

  @override
  String get enterNewNameForImage => 'Введіть нове ім\'я для вашого зображення';

  @override
  String get imageName => 'Ім\'я зображення';

  @override
  String get enterImageName => 'Введіть ім\'я зображення...';

  @override
  String get rename => 'Перейменувати';

  @override
  String get imageProperties => 'Властивості зображення';

  @override
  String get created => 'Створено';

  @override
  String get source => 'Джерело:';

  @override
  String get epdModel => 'Модель EPD:';

  @override
  String get transferToEpaper => 'Передати на ePaper';

  @override
  String get saveImage => 'Зберегти зображення';

  @override
  String get saveFilteredImageToLibrary =>
      'Збережіть відфільтроване зображення до бібліотеки';

  @override
  String get filterApplied => 'Застосований фільтр:';

  @override
  String get save => 'Зберегти';

  @override
  String get noImagesMatchSearch =>
      'Жодне зображення не відповідає вашому пошуку';

  @override
  String get vCardDataCannotBeEmpty => 'Дані vCard не можуть бути порожніми';

  @override
  String get renamingImage => 'Перейменування зображення...';

  @override
  String get imageRenamedTo => 'Зображення перейменовано на \"';

  @override
  String get failedToRenameImage => 'Не вдалося перейменувати зображення: ';

  @override
  String get deletingImage => 'Видалення зображення...';

  @override
  String get imageDeleted => 'Зображення \"';

  @override
  String get deleted => '\" видалено';

  @override
  String get failedToDeleteImage => 'Не вдалося видалити зображення: ';

  @override
  String get deletingImages => 'Видалення ';

  @override
  String get images => ' зображень...';

  @override
  String get failedToDeleteImages => 'Не вдалося видалити зображення: ';

  @override
  String get imagesDeletedSuccessfully => ' зображень успішно видалено';

  @override
  String get imageDeletedSuccessfully => 'Зображення успішно видалено';

  @override
  String get failedToLoadImageData =>
      'Не вдалося завантажити дані зображення для \"';

  @override
  String get failedToDecodeImage => 'Не вдалося декодувати зображення \"';

  @override
  String get failedToTransfer => 'Не вдалося передати \"';

  @override
  String get savingImage => 'Збереження зображення...';

  @override
  String get imageSavedToLibrary => 'Зображення збережено до бібліотеки!';

  @override
  String get failedToSaveImage => 'Не вдалося зберегти зображення: ';

  @override
  String get errorCreatingVCardRecord => 'Помилка створення запису vCard: ';

  @override
  String get nfcIsDisabledPleaseEnableIt =>
      'NFC вимкнено. Будь ласка, увімкніть його.';

  @override
  String get thisDeviceDoesNotSupportNfc => 'Цей пристрій не підтримує NFC.';

  @override
  String get bringPhoneNearMagicEpaperHardware =>
      'Піднесіть телефон до обладнання Magic ePaper';

  @override
  String get tagDetectedInitializing => 'Мітку виявлено! Ініціалізація...';

  @override
  String get enablingEnergyHarvesting => 'Увімкнення збору енергії...';

  @override
  String get processingImageData => 'Обробка даних зображення...';

  @override
  String get refreshingDisplay => 'Оновлення дисплея...';

  @override
  String get notMagicEpaperHardware => 'Не є обладнанням Magic ePaper';

  @override
  String get errorCheckingMessage => 'Помилка перевірки повідомлення: ';

  @override
  String get timeoutWaitingForI2cMessage =>
      'Час очікування повідомлення I2C минув';

  @override
  String get writingChunk => 'Запис фрагмента ';

  @override
  String get transferredSuccessfully => 'Успішно передано.';

  @override
  String get waitingForNfcTag => 'Очікування NFC-мітки...';

  @override
  String get gotTag => 'Мітку знайдено!';

  @override
  String get frame => 'Кадр ';

  @override
  String get couldNotOpenLink => 'Не вдалося відкрити посилання.';

  @override
  String get errorOccurredWhileOpeningLink =>
      'Сталася помилка під час відкриття посилання.';

  @override
  String get errorCreatingAppRecord => 'Помилка створення запису програми: ';

  @override
  String get appCannotBeEmpty => 'Програма не може бути порожньою';

  @override
  String get invalidPackageName => 'Недійсна назва пакета';

  @override
  String get writeAppLauncherData => 'Записати дані запуску програми';

  @override
  String get writeAppLauncher => 'Записати запуск програми';

  @override
  String get searchApps => 'Пошук програм...';

  @override
  String get customPackageName => 'Власна назва пакета';

  @override
  String get enterPackageName => 'Введіть назву пакета...';

  @override
  String get noAppsFound => 'Програми не знайдено';

  @override
  String get selectApplication => 'Виберіть програму';

  @override
  String get errorLoadingApps => 'Помилка завантаження програм: ';

  @override
  String get add => 'Додати';

  @override
  String get readNfcTags => 'Зчитати мітки NFC';

  @override
  String get writeNfcTags => 'Записати мітки NFC';

  @override
  String get nfcIsReadyToUse =>
      'NFC готовий до використання. Ви можете читати та записувати NFC-мітки.';

  @override
  String get deviceDoesNotSupportNfc =>
      'Цей пристрій не підтримує функцію NFC.';

  @override
  String get pleaseEnableNfcInSettings =>
      'Будь ласка, увімкніть NFC у налаштуваннях вашого пристрою для продовження.';

  @override
  String get nfcIsNowEnabledAndReady =>
      'NFC тепер увімкнено та готовий до використання!';

  @override
  String get nfcHasBeenDisabled =>
      'NFC було вимкнено. Будь ласка, увімкніть його, щоб продовжити використання функцій NFC.';

  @override
  String get nfcIsNotSupportedOnDevice =>
      'NFC не підтримується на цьому пристрої.';

  @override
  String get arduinoExport => 'Експорт для Arduino';

  @override
  String get exportXmbFilesForArduino => 'Експорт файлів XMB для Arduino';

  @override
  String get cardTemplates => 'Шаблони карток';

  @override
  String get chooseTemplateSubtitle => 'Виберіть шаблон, щоб почати';

  @override
  String get employeeIdCardTitle => 'Посвідчення співробітника';

  @override
  String get employeeIdCardDescription =>
      'Створюйте професійні посвідчення для співробітників';

  @override
  String get shopPriceTagTitle => 'Цінник для магазину';

  @override
  String get shopPriceTagDescription =>
      'Створюйте привабливі цінники для ваших товарів';

  @override
  String get entryPassTagTitle => 'Вхідний квиток';

  @override
  String get entryPassTagDescription =>
      'Генеруйте вхідні квитки для заходів і закладів';

  @override
  String get eventBadgeTitle => 'Бейдж для заходу';

  @override
  String get eventBadgeDescription =>
      'Створюйте персоналізовані бейджі та іменні картки для заходів';

  @override
  String get comingSoon => 'Незабаром';

  @override
  String get comingSoonMessage =>
      'Цей шаблон наразі перебуває в розробці та незабаром буде доступний.';

  @override
  String get ok => 'ОК';

  @override
  String get defaultCompanyName => 'Назва компанії';

  @override
  String get nameLabel => 'Ім\'я';

  @override
  String get positionLabel => 'Посада';

  @override
  String get divisionLabel => 'Відділ';

  @override
  String get idLabel => 'ID';

  @override
  String get emptyFieldPlaceholder => 'Не вказано';

  @override
  String get productImage => 'Зображення товару';

  @override
  String get productName => 'Назва товару';

  @override
  String get sizeQuantity => 'Розмір/Кількість';

  @override
  String get defaultCurrency => '₴';

  @override
  String get defaultPrice => '0.00';

  @override
  String get price => 'Ціна';

  @override
  String get quantitySize => 'Кількість/Розмір';

  @override
  String get quantitySizeHint =>
      'Введіть розмір/кількість (напр., 750 мл, 2 кг, Великий)';

  @override
  String get namePrefix => 'Ім\'я: ';

  @override
  String get positionPrefix => 'Посада: ';

  @override
  String get divisionPrefix => 'Відділ: ';

  @override
  String get idPrefix => 'ID: ';

  @override
  String get employeeIdCard => 'Посвідчення співробітника';

  @override
  String get fillDetailsToCreateId =>
      'Заповніть дані нижче, щоб створити посвідчення співробітника';

  @override
  String get idCardDetails => 'Дані посвідчення';

  @override
  String get companyName => 'Назва компанії';

  @override
  String get enterCompanyName => 'Введіть назву компанії';

  @override
  String get pleaseEnterCompanyName => 'Будь ласка, введіть назву компанії';

  @override
  String get name => 'Ім\'я';

  @override
  String get enterEmployeeName => 'Введіть ім\'я співробітника';

  @override
  String get pleaseEnterName => 'Будь ласка, введіть ім\'я';

  @override
  String get position => 'Посада';

  @override
  String get enterJobPosition => 'Введіть посаду';

  @override
  String get pleaseEnterPosition => 'Будь ласка, введіть посаду';

  @override
  String get division => 'Відділ';

  @override
  String get enterDepartment => 'Введіть відділ';

  @override
  String get pleaseEnterDivision => 'Будь ласка, введіть відділ';

  @override
  String get idNumber => 'Номер ID';

  @override
  String get enterUniqueId => 'Введіть унікальний ID';

  @override
  String get pleaseEnterIdNumber => 'Будь ласка, введіть номер ID';

  @override
  String get qrCodeData => 'Дані QR-коду';

  @override
  String get enterQrCodeData => 'Введіть дані QR-коду';

  @override
  String get pleaseEnterQrCodeData => 'Будь ласка, введіть дані QR-коду';

  @override
  String get generatingIdCard => 'Створення посвідчення...';

  @override
  String get generateIdCard => 'Згенерувати посвідчення';

  @override
  String get profilePhoto => 'Фото профілю';

  @override
  String get selected => 'Вибрано';

  @override
  String get photoSelected => 'Фото вибрано';

  @override
  String get selectProfilePhoto => 'Виберіть фото профілю';

  @override
  String get tapToChangePhoto => 'Натисніть, щоб змінити фото';

  @override
  String get tapToSelectFromGallery => 'Натисніть, щоб вибрати з галереї';

  @override
  String get priceTagGenerator => 'Генератор цінників';

  @override
  String get priceTagDescription =>
      'Створюйте професійні цінники для ваших товарів';

  @override
  String get productDetails => 'Деталі товару';

  @override
  String get productNameHint => 'Введіть назву товару (напр., iPhone 15 Pro)';

  @override
  String get pleaseEnterProductName => 'Будь ласка, введіть назву товару';

  @override
  String get currency => 'Валюта';

  @override
  String get currencyHint => '₴';

  @override
  String get required => 'Обов\'язково';

  @override
  String get priceHint => '999.99';

  @override
  String get pleaseEnterPrice => 'Будь ласка, введіть ціну';

  @override
  String get pleaseEnterQuantitySize =>
      'Будь ласка, введіть кількість або розмір';

  @override
  String get pleaseEnterBarcodeData => 'Будь ласка, введіть дані штрих-коду';

  @override
  String get generatingPriceTag => 'Створення цінника...';

  @override
  String get generatePriceTag => 'Згенерувати цінник';

  @override
  String get productImageIn => 'Зображення товару';

  @override
  String get productImageSelected => 'Зображення товару вибрано';

  @override
  String get selectProductImage => 'Виберіть зображення товару';

  @override
  String get tapToChangeImage => 'Натисніть, щоб змінити зображення';

  @override
  String get chooseImageFromGallery => 'Виберіть зображення з галереї';

  @override
  String get processingImages => 'Обробка зображень...';

  @override
  String get refreshModeInfo => 'Інформація про режим оновлення';

  @override
  String get fullRefreshInfo => 'Повне оновлення';

  @override
  String get fullRefreshDescription =>
      'Повністю оновлює весь дисплей, очищаючи всі пікселі та перемальовуючи зображення. Це забезпечує найкращу якість зображення та контрастність, але займає більше часу.';

  @override
  String get partialRefreshInfo => 'Часткове оновлення (Waveforms)';

  @override
  String get partialRefreshDescription =>
      'Оновлює лише змінені пікселі з використанням оптимізованих сигналів. Це швидше, ніж повне оновлення, але з часом може призвести до появи «привидів» (ghosting) або зниження контрастності.';

  @override
  String get longPressForInfo =>
      'Утримуйте для отримання додаткової інформації';
}
