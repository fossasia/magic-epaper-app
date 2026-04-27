// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Magic ePaper';

  @override
  String get aboutUsDescription =>
      'Magic ePaper — это приложение, предназначенное для управления и обновления экранов ePaper. Цель состоит в том, чтобы предоставить инструменты для настройки и передачи изображений, текста и шаблонов на экраны ePaper с использованием NFC. Передача данных со смартфона на оборудование ePaper осуществляется по беспроводной сети через NFC. Проект построен на основе пользовательской прошивки и драйверов дисплея для бесперебойной связи и эффективного рендеринга изображений.';

  @override
  String get developedBy => 'Разработано';

  @override
  String get fossasiaContributors => 'Участники FOSSASIA';

  @override
  String get contactWithUs => 'Свяжитесь с нами';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle =>
      'Сделайте форк репозитория и отправьте изменения или сообщите о новых проблемах.';

  @override
  String get license => 'Лицензия';

  @override
  String get licenseSubtitle =>
      'Ознакомьтесь с условиями лицензии Apache License 2.0, используемыми в Magic ePaper.';

  @override
  String get createTransfer => 'Создание и передача изображений';

  @override
  String get ndefScreen => 'Ndef';

  @override
  String get selectDisplayType => 'Выберите тип экрана ePaper';

  @override
  String get settings => 'Настройки';

  @override
  String get aboutUs => 'О нас';

  @override
  String get other => 'Другое';

  @override
  String get getBadge => 'Получить значок';

  @override
  String get feedbackBugReports => 'Отзывы / Отчеты об ошибках';

  @override
  String get continueButton => 'Продолжить';

  @override
  String get noImageSelectedFeedback => 'Сначала импортируйте изображение!';

  @override
  String get adjustButtonLabel => 'Настроить';

  @override
  String get importImageButtonLabel => 'Импорт';

  @override
  String get openEditor => 'Создать';

  @override
  String get importStartingImageFeedback =>
      'Импортируйте изображение, чтобы начать';

  @override
  String get transferButtonLabel => 'Передать';

  @override
  String get filterScreenTitle => 'Выберите фильтр';

  @override
  String get scanningForNfcTag => 'Поиск NFC-метки...';

  @override
  String get scanningForNfcTagToWrite => 'Поиск NFC-метки для записи...';

  @override
  String get scanningForNfcTagToClear => 'Поиск NFC-метки для очистки...';

  @override
  String get scanningTagForVerification => 'Сканирование метки для проверки...';

  @override
  String get errorCreatingTextRecord =>
      'Ошибка при создании текстовой записи: ';

  @override
  String get errorCreatingUrlRecord => 'Ошибка при создании URL-записи: ';

  @override
  String get errorCreatingWifiRecord => 'Ошибка при создании записи WiFi: ';

  @override
  String get errorCreatingMultipleRecords =>
      'Ошибка при создании нескольких записей: ';

  @override
  String get pleaseEnterAtLeastOneRecord =>
      'Пожалуйста, введите хотя бы одну запись';

  @override
  String get tagType => 'Тип метки: ';

  @override
  String get tagId => 'ID метки: ';

  @override
  String get ndefAvailable => 'Доступен NDEF: ';

  @override
  String get ndefWritable => 'Доступна запись NDEF: ';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get textCannotBeEmpty => 'Текст не может быть пустым';

  @override
  String get urlCannotBeEmpty => 'URL не может быть пустым';

  @override
  String get wifiSsidCannotBeEmpty => 'SSID WiFi не может быть пустым';

  @override
  String get defaultLanguage => 'ru';

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
  String get unknownNull => 'Неизвестно (null)';

  @override
  String get unknownType => 'Неизвестный тип: ';

  @override
  String get textPrefix => 'Текст: ';

  @override
  String get textSuffix => ' (Язык: ';

  @override
  String get uriPrefix => 'URI: ';

  @override
  String get mimePrefix => 'MIME: ';

  @override
  String get absoluteUriPrefix => 'Абсолютный URI: ';

  @override
  String get rawPrefix => 'Необработанные данные: ';

  @override
  String get emptyPayload => 'Пустая полезная нагрузка';

  @override
  String get binaryDataPrefix => 'Двоичные данные (';

  @override
  String get binaryDataSuffix => ' байт): ';

  @override
  String get errorDecodingRecord => 'Ошибка декодирования записи: ';

  @override
  String get noNdefRecordsFound => 'Записи NDEF не найдены';

  @override
  String get recordPrefix => 'Запись ';

  @override
  String get recordSuffix => ':';

  @override
  String get tnfLabel => 'TNF: ';

  @override
  String get typeLabel => 'Тип: ';

  @override
  String get payloadSizeLabel => 'Размер полезной нагрузки: ';

  @override
  String get bytesLabel => ' байт';

  @override
  String get contentLabel => 'Содержимое: ';

  @override
  String get rawPayloadLabel => 'Необработанная полезная нагрузка: ';

  @override
  String get nullPayload => 'null';

  @override
  String get closingParenthesis => ')';

  @override
  String get closingParenthesisNewline => ')\n';

  @override
  String get scanYourNfcTag => 'Отсканируйте вашу NFC-метку';

  @override
  String get scanYourNfcTagToWrite => 'Отсканируйте NFC-метку для записи';

  @override
  String get scanYourNfcTagToClear => 'Отсканируйте NFC-метку для очистки';

  @override
  String get scanTagToVerifyContent =>
      'Отсканируйте метку для проверки содержимого';

  @override
  String get tagIsNotNdefCompatible => 'Метка не совместима с NDEF';

  @override
  String get tagDoesNotSupportNdef => 'Метка не поддерживает NDEF';

  @override
  String get tagIsNotWritable => 'Метка недоступна для записи';

  @override
  String get tagDoesNotSupportNdefCannotClear =>
      'Метка не поддерживает NDEF, очистка невозможна';

  @override
  String get tagIsNotWritableCannotClear =>
      'Метка недоступна для записи, очистка невозможна';

  @override
  String get readOperationCompleted => 'Операция чтения завершена';

  @override
  String get writeOperationCompleted => 'Операция записи завершена';

  @override
  String get clearOperationCompleted => 'Операция очистки завершена';

  @override
  String get ndefRecordsFound => 'Найдены записи NDEF: ';

  @override
  String get theTagIsEmpty => 'Метка пуста';

  @override
  String get record => 'Запись ';

  @override
  String get type => 'Тип: ';

  @override
  String get tnf => 'TNF: ';

  @override
  String get content => 'Содержимое: ';

  @override
  String get noRecordsToWrite => 'Нет записей для записи';

  @override
  String get ndefRecordsWrittenSuccessfully => 'Записи NDEF успешно записаны';

  @override
  String get recordsWritten => 'Записано записей: ';

  @override
  String get writtenRecord => 'Записана запись ';

  @override
  String get tagClearedSuccessfully => 'Метка успешно очищена';

  @override
  String get method => 'Метод: ';

  @override
  String get tagIsNowReadyForNewData => 'Теперь метка готова для новых данных';

  @override
  String get emptyTextRecord => 'Пустая текстовая запись';

  @override
  String get emptyNdefRecord => 'Пустая запись NDEF';

  @override
  String get minimalSpaceCharacter => 'Минимальный символ пробела';

  @override
  String get emptyRecordList => 'Пустой список записей';

  @override
  String get allClearingMethodsFailed =>
      'Все методы очистки завершились неудачно: ';

  @override
  String get verificationResults => 'Результаты проверки:';

  @override
  String get recordsFound => 'Найдены записи: ';

  @override
  String get noNdefRecordsFoundOnTag => 'На метке не найдены записи NDEF';

  @override
  String get theTagIsEmptyCleared => 'Метка пуста/очищена';

  @override
  String get errorReadingTag => 'Ошибка при чтении метки: ';

  @override
  String get errorWritingToTag => 'Ошибка при записи на метку: ';

  @override
  String get errorClearingTag => 'Ошибка при очистке метки: ';

  @override
  String get verificationError => 'Ошибка проверки: ';

  @override
  String get holdTagCloseAndTryAgain =>
      '. Держите метку близко и попробуйте снова';

  @override
  String get tryHoldingTagCloser => '. Попробуйте поднести метку ближе';

  @override
  String get tryMovingTagCloser => '. Попробуйте придвинуть метку ближе';

  @override
  String get method1EmptyTextRecordFailed =>
      'Метод 1 (пустая текстовая запись) не удался: ';

  @override
  String get method2EmptyNdefRecordFailed =>
      'Метод 2 (пустая запись NDEF) не удался: ';

  @override
  String get method3MinimalRecordFailed =>
      'Метод 3 (минимальная запись) не удался: ';

  @override
  String get method4EmptyListFailed => 'Метод 4 (пустой список) не удался: ';

  @override
  String get errorFinishingNfcSession => 'Ошибка при завершении сеанса NFC: ';

  @override
  String get secondaryCleanupAlsoFailed =>
      'Вторичная очистка также не удалась: ';

  @override
  String get multipleTagsFoundPleaseSelectOne =>
      'Найдено несколько меток, пожалуйста, выберите одну';

  @override
  String get scanYourNfcTagDefault => 'Отсканируйте вашу NFC-метку';

  @override
  String get readNdefTags => 'Чтение меток NDEF';

  @override
  String get reading => 'Чтение...';

  @override
  String get readNfcTag => 'Прочитать NFC-метку';

  @override
  String get verify => 'Проверить';

  @override
  String get clearing => 'Очистка...';

  @override
  String get clearNfcTag => 'Очистить NFC-метку';

  @override
  String get monospaceFontFamily => 'monospace';

  @override
  String get nfcStatus => 'Статус NFC';

  @override
  String get refreshNfcStatus => 'Обновить статус NFC';

  @override
  String get writeNdefRecords => 'Запись записей NDEF';

  @override
  String get textRecord => 'Текстовая запись';

  @override
  String get enterTextToWriteToNfcTag =>
      'Введите текст для записи на NFC-метку';

  @override
  String get writing => 'Запись...';

  @override
  String get writeText => 'Записать текст';

  @override
  String get urlRecord => 'Запись URL';

  @override
  String get enterUrl => 'Введите URL';

  @override
  String get writeUrl => 'Записать URL';

  @override
  String get wifiRecord => 'Запись WiFi';

  @override
  String get wifiNetworkNameSsid => 'Имя сети WiFi (SSID)';

  @override
  String get wifiPassword => 'Пароль WiFi';

  @override
  String get writeWifi => 'Записать WiFi';

  @override
  String get writeAllRecords => 'Записать все записи';

  @override
  String get writeAllNonEmptyFieldsDescription =>
      'Записать все непустые поля на NFC-метку одновременно';

  @override
  String get writeMultipleRecords => 'Запись нескольких записей';

  @override
  String get readOperationFailed => 'Операция чтения не удалась';

  @override
  String get tagReadSuccessfully => 'Метка успешно прочитана';

  @override
  String get verificationFailed => 'Проверка не удалась';

  @override
  String get tagVerifiedSuccessfully => 'Метка успешно проверена';

  @override
  String get clearNfcTagConfirmation =>
      'Вы уверены, что хотите очистить эту NFC-метку? Это действие нельзя отменить.';

  @override
  String get clearOperationFailed => 'Операция очистки не удалась';

  @override
  String get writeOperationFailed => 'Операция записи не удалась';

  @override
  String get dataWrittenSuccessfully => 'Данные успешно записаны';

  @override
  String get nfcNotAvailable => 'NFC недоступен';

  @override
  String get enableNfcMessage =>
      'Пожалуйста, включите NFC в настройках вашего устройства, чтобы использовать эту функцию.';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get error => 'Ошибка';

  @override
  String get successfully => 'успешно';

  @override
  String get language => 'Язык';

  @override
  String get loading => 'Загрузка...';

  @override
  String get exportXbm => 'Экспорт XBM';

  @override
  String get exportingXbm => 'Экспорт файлов XBM...';

  @override
  String get fullRefresh => 'Полное обновление';

  @override
  String get fullRefreshSelected => 'Выбрано полное обновление';

  @override
  String get waveformSelected => 'Выбрано';

  @override
  String get barcode => 'Штрихкод';

  @override
  String get library => 'Библиотека';

  @override
  String get templates => 'Шаблоны';

  @override
  String get barcodeGenerator => 'Генератор штрихкодов';

  @override
  String get barcodeData => 'Данные штрихкода';

  @override
  String get barcodeDataHint => 'Введите номер штрихкода или SKU';

  @override
  String get characters => 'Символы';

  @override
  String get scanBarcode => 'Сканировать штрихкод';

  @override
  String get barcodeFormat => 'Формат штрихкода';

  @override
  String get enterOrScanBarcodeData =>
      'Введите или отсканируйте данные штрихкода';

  @override
  String get invalidBarcode => 'Неверный штрихкод';

  @override
  String get invalidCharacter => 'Недопустимый символ';

  @override
  String get supportedCharacters => 'Поддерживаемые символы:';

  @override
  String get pleaseCheckBarcodeRules =>
      'Пожалуйста, проверьте правила для штрихкодов.';

  @override
  String get dataTooShort => 'Данные слишком короткие. Минимальная длина для';

  @override
  String get dataTooLong => 'Данные слишком длинные. Максимальная длина для';

  @override
  String get isText => 'равна';

  @override
  String get pointCameraAtBarcode =>
      'Наведите камеру на штрихкод для сканирования';

  @override
  String get generateImage => 'Сгенерировать изображение';

  @override
  String get exportFailed => 'Ошибка экспорта';

  @override
  String get exportedXbmFiles =>
      'Файл(ы) XBM экспортированы в MagicEpaper/XBM/';

  @override
  String get exported => 'Экспортировано';

  @override
  String get xbmFilesToMagicEpaper => 'Файл(ы) XBM в MagicEpaper/XBM/';

  @override
  String get floydSteinberg => 'Классический';

  @override
  String get stucki => 'Резкий';

  @override
  String get atkinson => 'Винтаж';

  @override
  String get falseFloydSteinberg => 'Простой';

  @override
  String get halftone => 'Газета';

  @override
  String get threshold => 'Постеризация';

  @override
  String get colorHalftone => 'Цветная газета';

  @override
  String get searchingForDevice => 'Поиск устройства';

  @override
  String get displayRefreshing => 'Обновление дисплея';

  @override
  String get transferComplete => 'Передача завершена!';

  @override
  String get writingToEpaper => 'Запись на ePaper';

  @override
  String get pleaseBringPhoneClose =>
      'Пожалуйста, поднесите телефон к устройству Magic ePaper';

  @override
  String get keepPhoneClose => 'Держите телефон близко!';

  @override
  String get displayRefreshingMessage =>
      'Дисплей обновляется. Пожалуйста, держите телефон рядом с устройством, пока изображение не появится полностью.';

  @override
  String get transferFailed => 'Передача не удалась';

  @override
  String get deviceConnectionTimeout =>
      'Время ожидания подключения к устройству истекло. Пожалуйста, попробуйте поднести телефон ближе к устройству и повторите попытку.';

  @override
  String get connectionLostDuringTransfer =>
      'Связь была потеряна во время передачи. Пожалуйста, держите телефон близко к устройству и повторите попытку.';

  @override
  String get done => 'Готово';

  @override
  String get close => 'Закрыть';

  @override
  String get processingImage => 'Обработка изображения...';

  @override
  String get readyToFlash => 'Готово к прошивке';

  @override
  String get imageProcessedSuccessfully => 'Изображение успешно обработано.';

  @override
  String get tapBelowAndHold =>
      'Нажмите ниже и держите телефон рядом с дисплеем.';

  @override
  String get startFlashing => 'Начать прошивку';

  @override
  String get flashing => 'Прошивка...';

  @override
  String get keepPhoneStill => 'Держите телефон неподвижно.';

  @override
  String get success => 'Успех!';

  @override
  String get transferCompleteMessage => 'Передача завершена!';

  @override
  String get unknownErrorOccurred => 'Произошла неизвестная ошибка.';

  @override
  String get resultsCleared => 'Результаты очищены';

  @override
  String get clearResults => 'Очистить результаты';

  @override
  String get vCardContact => 'Контакт vCard';

  @override
  String get writingVCard => 'Запись vCard...';

  @override
  String get writeVCard => 'Записать vCard';

  @override
  String get firstName => 'Имя';

  @override
  String get lastName => 'Фамилия';

  @override
  String get organization => 'Организация';

  @override
  String get title => 'Должность';

  @override
  String get mobileNumber => 'Мобильный номер';

  @override
  String get emailAddress => 'Адрес электронной почты';

  @override
  String get streetAddress => 'Адрес (улица)';

  @override
  String get city => 'Город';

  @override
  String get zipCode => 'Почтовый индекс';

  @override
  String get country => 'Страна';

  @override
  String get website => 'Веб-сайт';

  @override
  String get noSavedImagesYet => 'Пока нет сохраненных изображений';

  @override
  String get saveImagesFromEditor =>
      'Сохраняйте изображения из редактора или импортируйте новые';

  @override
  String get enterWifiSSID => 'Введите SSID WiFi';

  @override
  String get enterWifiPassword => 'Введите пароль WiFi';

  @override
  String get writeMultiple => 'Записать несколько';

  @override
  String get searchImages => 'Поиск изображений...';

  @override
  String get filter => 'Фильтр:';

  @override
  String get all => 'Все';

  @override
  String get imported => 'Импортированные';

  @override
  String get editor => 'Редактор';

  @override
  String get imageLibrary => 'Библиотека изображений';

  @override
  String get selectImagesToDelete => 'Выберите изображения для удаления';

  @override
  String get delete => 'Удалить';

  @override
  String get deleteMode => 'Режим удаления';

  @override
  String get deleteImage => 'Удалить изображение';

  @override
  String get thisActionCannotBeUndone => 'Это действие нельзя отменить';

  @override
  String get filterLabel => 'Фильтр:';

  @override
  String get areYouSureDeleteImage =>
      'Вы уверены, что хотите удалить это изображение? Это действие нельзя отменить.';

  @override
  String get deleteMultipleImages => 'Удалить несколько изображений';

  @override
  String get imagesSelected => 'изображений выбрано';

  @override
  String get imagesSelectedForDeletion => 'изображений выбрано для удаления';

  @override
  String areYouSureDeleteMultipleImages(Object count) {
    return 'Вы уверены, что хотите удалить эти $count изображений? Это действие нельзя отменить.';
  }

  @override
  String get areYouSureDeleteSingleImage =>
      'Вы уверены, что хотите удалить это изображение? Это действие нельзя отменить.';

  @override
  String get deleteAll => 'Удалить все';

  @override
  String get renameImage => 'Переименовать изображение';

  @override
  String get enterNewNameForImage => 'Введите новое имя для вашего изображения';

  @override
  String get imageName => 'Имя изображения';

  @override
  String get enterImageName => 'Введите имя изображения...';

  @override
  String get rename => 'Переименовать';

  @override
  String get imageProperties => 'Свойства изображения';

  @override
  String get created => 'Создано';

  @override
  String get source => 'Источник:';

  @override
  String get epdModel => 'Модель EPD:';

  @override
  String get transferToEpaper => 'Передать на ePaper';

  @override
  String get saveImage => 'Сохранить изображение';

  @override
  String get saveFilteredImageToLibrary =>
      'Сохраните отфильтрованное изображение в библиотеку';

  @override
  String get filterApplied => 'Примененный фильтр:';

  @override
  String get save => 'Сохранить';

  @override
  String get noImagesMatchSearch =>
      'Нет изображений, соответствующих вашему поиску';

  @override
  String get vCardDataCannotBeEmpty => 'Данные vCard не могут быть пустыми';

  @override
  String get renamingImage => 'Переименование изображения...';

  @override
  String get imageRenamedTo => 'Изображение переименовано в \"';

  @override
  String get failedToRenameImage => 'Не удалось переименовать изображение: ';

  @override
  String get deletingImage => 'Удаление изображения...';

  @override
  String get imageDeleted => 'Изображение \"';

  @override
  String get deleted => '\" удалено';

  @override
  String get failedToDeleteImage => 'Не удалось удалить изображение: ';

  @override
  String get deletingImages => 'Удаление ';

  @override
  String get images => ' изображений...';

  @override
  String get failedToDeleteImages => 'Не удалось удалить изображения: ';

  @override
  String get imagesDeletedSuccessfully => ' изображений успешно удалено';

  @override
  String get imageDeletedSuccessfully => 'Изображение успешно удалено';

  @override
  String get failedToLoadImageData =>
      'Не удалось загрузить данные изображения для \"';

  @override
  String get failedToDecodeImage => 'Не удалось декодировать изображение \"';

  @override
  String get failedToTransfer => 'Не удалось передать \"';

  @override
  String get savingImage => 'Сохранение изображения...';

  @override
  String get imageSavedToLibrary => 'Изображение сохранено в библиотеку!';

  @override
  String get failedToSaveImage => 'Не удалось сохранить изображение: ';

  @override
  String get errorCreatingVCardRecord => 'Ошибка при создании записи vCard: ';

  @override
  String get nfcIsDisabledPleaseEnableIt =>
      'NFC отключен. Пожалуйста, включите его.';

  @override
  String get thisDeviceDoesNotSupportNfc =>
      'Это устройство не поддерживает NFC.';

  @override
  String get bringPhoneNearMagicEpaperHardware =>
      'Поднесите телефон к оборудованию Magic ePaper';

  @override
  String get tagDetectedInitializing => 'Метка обнаружена! Инициализация...';

  @override
  String get enablingEnergyHarvesting => 'Включение сбора энергии...';

  @override
  String get processingImageData => 'Обработка данных изображения...';

  @override
  String get refreshingDisplay => 'Обновление дисплея...';

  @override
  String get notMagicEpaperHardware => 'Не является оборудованием Magic ePaper';

  @override
  String get errorCheckingMessage => 'Ошибка проверки сообщения: ';

  @override
  String get timeoutWaitingForI2cMessage => 'Тайм-аут ожидания сообщения I2C';

  @override
  String get writingChunk => 'Запись фрагмента ';

  @override
  String get transferredSuccessfully => 'Успешно передано.';

  @override
  String get waitingForNfcTag => 'Ожидание NFC-метки...';

  @override
  String get gotTag => 'Метка найдена!';

  @override
  String get frame => 'Кадр ';

  @override
  String get couldNotOpenLink => 'Не удалось открыть ссылку.';

  @override
  String get errorOccurredWhileOpeningLink =>
      'Произошла ошибка при открытии ссылки.';

  @override
  String get errorCreatingAppRecord => 'Ошибка создания записи приложения: ';

  @override
  String get appCannotBeEmpty => 'Приложение не может быть пустым';

  @override
  String get invalidPackageName => 'Неверное имя пакета';

  @override
  String get writeAppLauncherData => 'Записать данные запуска приложения';

  @override
  String get writeAppLauncher => 'Записать запуск приложения';

  @override
  String get searchApps => 'Поиск приложений...';

  @override
  String get customPackageName => 'Пользовательское имя пакета';

  @override
  String get enterPackageName => 'Введите имя пакета...';

  @override
  String get noAppsFound => 'Приложения не найдены';

  @override
  String get selectApplication => 'Выберите приложение';

  @override
  String get errorLoadingApps => 'Ошибка загрузки приложений: ';

  @override
  String get add => 'Добавить';

  @override
  String get readNfcTags => 'Чтение NFC-меток';

  @override
  String get writeNfcTags => 'Запись NFC-меток';

  @override
  String get nfcIsReadyToUse =>
      'NFC готов к использованию. Вы можете читать и записывать NFC-метки.';

  @override
  String get deviceDoesNotSupportNfc =>
      'Это устройство не поддерживает функцию NFC.';

  @override
  String get pleaseEnableNfcInSettings =>
      'Пожалуйста, включите NFC в настройках вашего устройства для продолжения.';

  @override
  String get nfcIsNowEnabledAndReady =>
      'NFC теперь включен и готов к использованию!';

  @override
  String get nfcHasBeenDisabled =>
      'NFC был отключен. Пожалуйста, включите его, чтобы продолжить использование функций NFC.';

  @override
  String get nfcIsNotSupportedOnDevice =>
      'NFC не поддерживается на этом устройстве.';

  @override
  String get arduinoExport => 'Экспорт для Arduino';

  @override
  String get exportXmbFilesForArduino => 'Экспорт файлов XMB для Arduino';

  @override
  String get cardTemplates => 'Шаблоны карточек';

  @override
  String get chooseTemplateSubtitle => 'Выберите шаблон, чтобы начать';

  @override
  String get employeeIdCardTitle => 'Удостоверение сотрудника';

  @override
  String get employeeIdCardDescription =>
      'Создавайте профессиональные удостоверения для сотрудников';

  @override
  String get shopPriceTagTitle => 'Ценник для магазина';

  @override
  String get shopPriceTagDescription =>
      'Разрабатывайте привлекательные ценники для ваших товаров';

  @override
  String get entryPassTagTitle => 'Входной билет';

  @override
  String get entryPassTagDescription =>
      'Создавайте входные билеты для мероприятий и заведений';

  @override
  String get eventBadgeTitle => 'Бейдж для мероприятия';

  @override
  String get eventBadgeDescription =>
      'Создавайте персонализированные бейджи и именные карточки для мероприятий';

  @override
  String get comingSoon => 'Скоро';

  @override
  String get comingSoonMessage =>
      'Этот шаблон в настоящее время находится в разработке и скоро будет доступен.';

  @override
  String get ok => 'ОК';

  @override
  String get defaultCompanyName => 'Название компании';

  @override
  String get nameLabel => 'Имя';

  @override
  String get positionLabel => 'Должность';

  @override
  String get divisionLabel => 'Отдел';

  @override
  String get idLabel => 'ID';

  @override
  String get emptyFieldPlaceholder => 'Не указано';

  @override
  String get productImage => 'Изображение товара';

  @override
  String get productName => 'Название товара';

  @override
  String get sizeQuantity => 'Размер/Количество';

  @override
  String get defaultCurrency => '₽';

  @override
  String get defaultPrice => '0.00';

  @override
  String get price => 'Цена';

  @override
  String get quantitySize => 'Количество/Размер';

  @override
  String get quantitySizeHint =>
      'Введите размер/количество (напр., 750 мл, 2 кг, Большой)';

  @override
  String get namePrefix => 'Имя: ';

  @override
  String get positionPrefix => 'Должность: ';

  @override
  String get divisionPrefix => 'Отдел: ';

  @override
  String get idPrefix => 'ID: ';

  @override
  String get employeeIdCard => 'Удостоверение сотрудника';

  @override
  String get fillDetailsToCreateId =>
      'Заполните данные ниже, чтобы создать удостоверение сотрудника';

  @override
  String get idCardDetails => 'Данные удостоверения';

  @override
  String get companyName => 'Название компании';

  @override
  String get enterCompanyName => 'Введите название компании';

  @override
  String get pleaseEnterCompanyName => 'Пожалуйста, введите название компании';

  @override
  String get name => 'Имя';

  @override
  String get enterEmployeeName => 'Введите имя сотрудника';

  @override
  String get pleaseEnterName => 'Пожалуйста, введите имя';

  @override
  String get position => 'Должность';

  @override
  String get enterJobPosition => 'Введите должность';

  @override
  String get pleaseEnterPosition => 'Пожалуйста, введите должность';

  @override
  String get division => 'Отдел';

  @override
  String get enterDepartment => 'Введите отдел';

  @override
  String get pleaseEnterDivision => 'Пожалуйста, введите отдел';

  @override
  String get idNumber => 'Номер ID';

  @override
  String get enterUniqueId => 'Введите уникальный ID';

  @override
  String get pleaseEnterIdNumber => 'Пожалуйста, введите номер ID';

  @override
  String get qrCodeData => 'Данные QR-кода';

  @override
  String get enterQrCodeData => 'Введите данные QR-кода';

  @override
  String get pleaseEnterQrCodeData => 'Пожалуйста, введите данные QR-кода';

  @override
  String get generatingIdCard => 'Создание удостоверения...';

  @override
  String get generateIdCard => 'Сгенерировать удостоверение';

  @override
  String get profilePhoto => 'Фото профиля';

  @override
  String get selected => 'Выбрано';

  @override
  String get photoSelected => 'Фото выбрано';

  @override
  String get selectProfilePhoto => 'Выберите фото профиля';

  @override
  String get tapToChangePhoto => 'Нажмите, чтобы изменить фото';

  @override
  String get tapToSelectFromGallery => 'Нажмите, чтобы выбрать из галереи';

  @override
  String get priceTagGenerator => 'Генератор ценников';

  @override
  String get priceTagDescription =>
      'Создавайте профессиональные ценники для ваших товаров';

  @override
  String get productDetails => 'Сведения о товаре';

  @override
  String get productNameHint =>
      'Введите название товара (напр., iPhone 15 Pro)';

  @override
  String get pleaseEnterProductName => 'Пожалуйста, введите название товара';

  @override
  String get currency => 'Валюта';

  @override
  String get currencyHint => '₽';

  @override
  String get required => 'Обязательно';

  @override
  String get priceHint => '999.99';

  @override
  String get pleaseEnterPrice => 'Пожалуйста, введите цену';

  @override
  String get pleaseEnterQuantitySize =>
      'Пожалуйста, введите количество или размер';

  @override
  String get pleaseEnterBarcodeData => 'Пожалуйста, введите данные штрихкода';

  @override
  String get generatingPriceTag => 'Создание ценника...';

  @override
  String get generatePriceTag => 'Сгенерировать ценник';

  @override
  String get productImageIn => 'Изображение товара';

  @override
  String get productImageSelected => 'Изображение товара выбрано';

  @override
  String get selectProductImage => 'Выберите изображение товара';

  @override
  String get tapToChangeImage => 'Нажмите, чтобы изменить изображение';

  @override
  String get chooseImageFromGallery => 'Выберите изображение из галереи';

  @override
  String get processingImages => 'Обработка изображений...';

  @override
  String get refreshModeInfo => 'Информация о режиме обновления';

  @override
  String get fullRefreshInfo => 'Полное обновление';

  @override
  String get fullRefreshDescription =>
      'Полностью обновляет весь дисплей, очищая все пиксели и перерисовывая изображение. Это обеспечивает наилучшее качество изображения и контрастность, но занимает больше времени.';

  @override
  String get partialRefreshInfo => 'Частичное обновление (Waveforms)';

  @override
  String get partialRefreshDescription =>
      'Обновляет только измененные пиксели с использованием оптимизированных сигналов. Это быстрее полного обновления, но со временем может привести к появлению «призраков» или снижению контрастности.';

  @override
  String get longPressForInfo =>
      'Удерживайте для получения дополнительной информации';
}
