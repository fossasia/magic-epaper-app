// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'Magic ePaper';

  @override
  String get aboutUsDescription =>
      'Magic ePaperは、電子ペーパーディスプレイの制御および更新を目的としたアプリです。NFCを使用して、画像、テキスト、パターンを電子ペーパー画面にカスタマイズおよび転送するためのツールを提供することを目的としています。スマートフォンから電子ペーパーハードウェアへのデータ転送は、NFC経由でワイヤレスに行われます。このプロジェクトは、シームレスな通信と効率的な画像レンダリングを実現するため、カスタムファームウェアとディスプレイドライバの上に構築されています。';

  @override
  String get developedBy => '開発者';

  @override
  String get fossasiaContributors => 'FOSSASIA貢献者';

  @override
  String get contactWithUs => 'お問い合わせ';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle => 'リポジトリをフォークして変更をプッシュするか、新しいIssueを送信してください。';

  @override
  String get license => 'ライセンス';

  @override
  String get licenseSubtitle =>
      'Magic ePaperで使用されているApache License 2.0の条項を確認してください。';

  @override
  String get createTransfer => '画像の作成と転送';

  @override
  String get ndefScreen => 'Ndef';

  @override
  String get selectDisplayType => '電子ペーパーのディスプレイタイプを選択';

  @override
  String get settings => '設定';

  @override
  String get aboutUs => 'アプリについて';

  @override
  String get other => 'その他';

  @override
  String get getBadge => 'バッジを取得';

  @override
  String get feedbackBugReports => 'フィードバック/バグ報告';

  @override
  String get continueButton => '次へ';

  @override
  String get noImageSelectedFeedback => 'まず画像をインポートしてください！';

  @override
  String get adjustButtonLabel => '調整';

  @override
  String get importImageButtonLabel => 'インポート';

  @override
  String get openEditor => '作成';

  @override
  String get importStartingImageFeedback => '画像をインポートして開始';

  @override
  String get transferButtonLabel => '転送';

  @override
  String get filterScreenTitle => 'フィルターを選択';

  @override
  String get scanningForNfcTag => 'NFCタグをスキャンしています...';

  @override
  String get scanningForNfcTagToWrite => '書き込み用のNFCタグをスキャンしています...';

  @override
  String get scanningForNfcTagToClear => '消去用のNFCタグをスキャンしています...';

  @override
  String get scanningTagForVerification => '確認のためにタグをスキャンしています...';

  @override
  String get errorCreatingTextRecord => 'テキストレコードの作成エラー: ';

  @override
  String get errorCreatingUrlRecord => 'URLレコードの作成エラー: ';

  @override
  String get errorCreatingWifiRecord => 'WiFiレコードの作成エラー: ';

  @override
  String get errorCreatingMultipleRecords => '複数レコードの作成エラー: ';

  @override
  String get pleaseEnterAtLeastOneRecord => '少なくとも1つのレコードを入力してください';

  @override
  String get tagType => 'タグの種類: ';

  @override
  String get tagId => 'タグID: ';

  @override
  String get ndefAvailable => 'NDEFの利用可否: ';

  @override
  String get ndefWritable => 'NDEFの書き込み可否: ';

  @override
  String get unknown => '不明';

  @override
  String get textCannotBeEmpty => 'テキストを空にすることはできません';

  @override
  String get urlCannotBeEmpty => 'URLを空にすることはできません';

  @override
  String get wifiSsidCannotBeEmpty => 'WiFiのSSIDを空にすることはできません';

  @override
  String get defaultLanguage => 'ja';

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
  String get unknownNull => '不明 (null)';

  @override
  String get unknownType => '不明な種類: ';

  @override
  String get textPrefix => 'テキスト: ';

  @override
  String get textSuffix => ' (言語: ';

  @override
  String get uriPrefix => 'URI: ';

  @override
  String get mimePrefix => 'MIME: ';

  @override
  String get absoluteUriPrefix => '絶対URI: ';

  @override
  String get rawPrefix => '生データ: ';

  @override
  String get emptyPayload => '空のペイロード';

  @override
  String get binaryDataPrefix => 'バイナリデータ (';

  @override
  String get binaryDataSuffix => ' バイト): ';

  @override
  String get errorDecodingRecord => 'レコードのデコードエラー: ';

  @override
  String get noNdefRecordsFound => 'NDEFレコードが見つかりません';

  @override
  String get recordPrefix => 'レコード ';

  @override
  String get recordSuffix => ':';

  @override
  String get tnfLabel => 'TNF: ';

  @override
  String get typeLabel => '種類: ';

  @override
  String get payloadSizeLabel => 'ペイロードサイズ: ';

  @override
  String get bytesLabel => ' バイト';

  @override
  String get contentLabel => '内容: ';

  @override
  String get rawPayloadLabel => '生のペイロード: ';

  @override
  String get nullPayload => 'null';

  @override
  String get closingParenthesis => ')';

  @override
  String get closingParenthesisNewline => ')\n';

  @override
  String get scanYourNfcTag => 'NFCタグをスキャンしてください';

  @override
  String get scanYourNfcTagToWrite => '書き込むNFCタグをスキャンしてください';

  @override
  String get scanYourNfcTagToClear => '消去するNFCタグをスキャンしてください';

  @override
  String get scanTagToVerifyContent => 'タグをスキャンして内容を確認してください';

  @override
  String get tagIsNotNdefCompatible => 'タグはNDEFと互換性がありません';

  @override
  String get tagDoesNotSupportNdef => 'タグはNDEFをサポートしていません';

  @override
  String get tagIsNotWritable => 'タグは書き込み不可能です';

  @override
  String get tagDoesNotSupportNdefCannotClear => 'タグはNDEFをサポートしていないため、消去できません';

  @override
  String get tagIsNotWritableCannotClear => 'タグは書き込み不可能のため、消去できません';

  @override
  String get readOperationCompleted => '読み取り操作が完了しました';

  @override
  String get writeOperationCompleted => '書き込み操作が完了しました';

  @override
  String get clearOperationCompleted => '消去操作が完了しました';

  @override
  String get ndefRecordsFound => '見つかったNDEFレコード: ';

  @override
  String get theTagIsEmpty => 'タグは空です';

  @override
  String get record => 'レコード ';

  @override
  String get type => '種類: ';

  @override
  String get tnf => 'TNF: ';

  @override
  String get content => '内容: ';

  @override
  String get noRecordsToWrite => '書き込むレコードがありません';

  @override
  String get ndefRecordsWrittenSuccessfully => 'NDEFレコードが正常に書き込まれました';

  @override
  String get recordsWritten => '書き込まれたレコード数: ';

  @override
  String get writtenRecord => '書き込まれたレコード ';

  @override
  String get tagClearedSuccessfully => 'タグが正常に消去されました';

  @override
  String get method => 'メソッド: ';

  @override
  String get tagIsNowReadyForNewData => 'タグは新しいデータの準備ができました';

  @override
  String get emptyTextRecord => '空のテキストレコード';

  @override
  String get emptyNdefRecord => '空のNDEFレコード';

  @override
  String get minimalSpaceCharacter => '最小スペース文字';

  @override
  String get emptyRecordList => '空のレコードリスト';

  @override
  String get allClearingMethodsFailed => 'すべての消去メソッドが失敗しました: ';

  @override
  String get verificationResults => '確認結果:';

  @override
  String get recordsFound => '見つかったレコード数: ';

  @override
  String get noNdefRecordsFoundOnTag => 'タグにNDEFレコードが見つかりません';

  @override
  String get theTagIsEmptyCleared => 'タグは空/消去済みです';

  @override
  String get errorReadingTag => 'タグの読み取りエラー: ';

  @override
  String get errorWritingToTag => 'タグの書き込みエラー: ';

  @override
  String get errorClearingTag => 'タグの消去エラー: ';

  @override
  String get verificationError => '確認エラー: ';

  @override
  String get holdTagCloseAndTryAgain => '。タグを近づけて、もう一度お試しください';

  @override
  String get tryHoldingTagCloser => '。タグをもう少し近づけてみてください';

  @override
  String get tryMovingTagCloser => '。タグを近づけて動かしてみてください';

  @override
  String get method1EmptyTextRecordFailed => 'メソッド1（空のテキストレコード）が失敗しました: ';

  @override
  String get method2EmptyNdefRecordFailed => 'メソッド2（空のNDEFレコード）が失敗しました: ';

  @override
  String get method3MinimalRecordFailed => 'メソッド3（最小レコード）が失敗しました: ';

  @override
  String get method4EmptyListFailed => 'メソッド4（空のリスト）が失敗しました: ';

  @override
  String get errorFinishingNfcSession => 'NFCセッションの終了エラー: ';

  @override
  String get secondaryCleanupAlsoFailed => '二次クリーンアップも失敗しました: ';

  @override
  String get multipleTagsFoundPleaseSelectOne => '複数のタグが見つかりました。1つ選択してください';

  @override
  String get scanYourNfcTagDefault => 'NFCタグをスキャンしてください';

  @override
  String get readNdefTags => 'NDEFタグを読み取る';

  @override
  String get reading => '読み取っています...';

  @override
  String get readNfcTag => 'NFCタグを読み取る';

  @override
  String get verify => '確認';

  @override
  String get clearing => '消去しています...';

  @override
  String get clearNfcTag => 'NFCタグを消去する';

  @override
  String get monospaceFontFamily => 'monospace';

  @override
  String get nfcStatus => 'NFCステータス';

  @override
  String get refreshNfcStatus => 'NFCステータスを更新';

  @override
  String get writeNdefRecords => 'NDEFレコードを書き込む';

  @override
  String get textRecord => 'テキストレコード';

  @override
  String get enterTextToWriteToNfcTag => 'NFCタグに書き込むテキストを入力してください';

  @override
  String get writing => '書き込んでいます...';

  @override
  String get writeText => 'テキストを書き込む';

  @override
  String get urlRecord => 'URLレコード';

  @override
  String get enterUrl => 'URLを入力してください';

  @override
  String get writeUrl => 'URLを書き込む';

  @override
  String get wifiRecord => 'WiFiレコード';

  @override
  String get wifiNetworkNameSsid => 'WiFiネットワーク名 (SSID)';

  @override
  String get wifiPassword => 'WiFiパスワード';

  @override
  String get writeWifi => 'WiFiを書き込む';

  @override
  String get writeAllRecords => 'すべてのレコードを書き込む';

  @override
  String get writeAllNonEmptyFieldsDescription =>
      '空でないすべてのフィールドをNFCタグに一度に書き込みます';

  @override
  String get writeMultipleRecords => '複数のレコードを書き込む';

  @override
  String get readOperationFailed => '読み取り操作に失敗しました';

  @override
  String get tagReadSuccessfully => 'タグが正常に読み取られました';

  @override
  String get verificationFailed => '確認に失敗しました';

  @override
  String get tagVerifiedSuccessfully => 'タグが正常に確認されました';

  @override
  String get clearNfcTagConfirmation => '本当にこのNFCタグを消去しますか？この操作は元に戻せません。';

  @override
  String get clearOperationFailed => '消去操作に失敗しました';

  @override
  String get writeOperationFailed => '書き込み操作に失敗しました';

  @override
  String get dataWrittenSuccessfully => 'データが正常に書き込まれました';

  @override
  String get nfcNotAvailable => 'NFCが利用できません';

  @override
  String get enableNfcMessage => 'この機能を使用するには、デバイスの設定でNFCを有効にしてください。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get error => 'エラー';

  @override
  String get successfully => '正常に';

  @override
  String get language => '言語';

  @override
  String get loading => '読み込み中...';

  @override
  String get exportXbm => 'XBMをエクスポート';

  @override
  String get exportingXbm => 'XBMファイルをエクスポートしています...';

  @override
  String get fullRefresh => 'フルリフレッシュ';

  @override
  String get fullRefreshSelected => 'フルリフレッシュが選択されました';

  @override
  String get waveformSelected => '選択済み';

  @override
  String get barcode => 'バーコード';

  @override
  String get library => 'ライブラリ';

  @override
  String get templates => 'テンプレート';

  @override
  String get barcodeGenerator => 'バーコードジェネレーター';

  @override
  String get barcodeData => 'バーコードデータ';

  @override
  String get barcodeDataHint => 'バーコード番号またはSKUを入力してください';

  @override
  String get characters => '文字';

  @override
  String get scanBarcode => 'バーコードをスキャン';

  @override
  String get barcodeFormat => 'バーコード形式';

  @override
  String get enterOrScanBarcodeData => 'バーコードデータを入力またはスキャンしてください';

  @override
  String get invalidBarcode => '無効なバーコード';

  @override
  String get invalidCharacter => '無効な文字';

  @override
  String get supportedCharacters => 'サポートされている文字は以下の通りです：';

  @override
  String get pleaseCheckBarcodeRules => 'バーコードのルールを確認してください。';

  @override
  String get dataTooShort => 'データが短すぎます。最小長は';

  @override
  String get dataTooLong => 'データが長すぎます。最大長は';

  @override
  String get isText => 'です';

  @override
  String get pointCameraAtBarcode => 'カメラをバーコードに向けてスキャンします';

  @override
  String get generateImage => '画像を生成';

  @override
  String get exportFailed => 'エクスポートに失敗しました';

  @override
  String get exportedXbmFiles => 'MagicEpaper/XBM/ にXBMファイルをエクスポートしました';

  @override
  String get exported => 'エクスポート済み';

  @override
  String get xbmFilesToMagicEpaper => 'XBMファイルを MagicEpaper/XBM/ にエクスポート';

  @override
  String get floydSteinberg => 'クラシック';

  @override
  String get stucki => 'シャープ';

  @override
  String get atkinson => 'ヴィンテージ';

  @override
  String get falseFloydSteinberg => 'シンプル';

  @override
  String get halftone => 'ニュースペーパー';

  @override
  String get threshold => 'ポスタライズ';

  @override
  String get colorHalftone => 'カラーニュースペーパー';

  @override
  String get searchingForDevice => 'デバイスを検索しています';

  @override
  String get displayRefreshing => 'ディスプレイを更新しています';

  @override
  String get transferComplete => '転送が完了しました！';

  @override
  String get writingToEpaper => '電子ペーパーに書き込んでいます';

  @override
  String get pleaseBringPhoneClose => 'スマートフォンをMagic ePaperデバイスに近づけてください';

  @override
  String get keepPhoneClose => 'スマートフォンを近づけたままにしてください！';

  @override
  String get displayRefreshingMessage =>
      'ディスプレイを更新しています。画像が完全に表示されるまで、スマートフォンをデバイスの近くに置いてください。';

  @override
  String get transferFailed => '転送に失敗しました';

  @override
  String get deviceConnectionTimeout =>
      'デバイスの接続がタイムアウトしました。スマートフォンをデバイスに近づけて、もう一度お試しください。';

  @override
  String get connectionLostDuringTransfer =>
      '転送中に接続が失われました。スマートフォンをデバイスに近づけて、もう一度お試しください。';

  @override
  String get done => '完了';

  @override
  String get close => '閉じる';

  @override
  String get processingImage => '画像を処理しています...';

  @override
  String get readyToFlash => 'フラッシュの準備完了';

  @override
  String get imageProcessedSuccessfully => '画像が正常に処理されました。';

  @override
  String get tapBelowAndHold => '下をタップし、スマートフォンをディスプレイの近くに保持してください。';

  @override
  String get startFlashing => 'フラッシュを開始';

  @override
  String get flashing => 'フラッシュ中...';

  @override
  String get keepPhoneStill => 'スマートフォンを動かさないでください。';

  @override
  String get success => '成功！';

  @override
  String get transferCompleteMessage => '転送が完了しました！';

  @override
  String get unknownErrorOccurred => '不明なエラーが発生しました。';

  @override
  String get resultsCleared => '結果が消去されました';

  @override
  String get clearResults => '結果を消去する';

  @override
  String get vCardContact => 'vCard連絡先';

  @override
  String get writingVCard => 'vCardを書き込んでいます...';

  @override
  String get writeVCard => 'vCardを書き込む';

  @override
  String get firstName => '名';

  @override
  String get lastName => '姓';

  @override
  String get organization => '組織';

  @override
  String get title => '役職';

  @override
  String get mobileNumber => '携帯電話番号';

  @override
  String get emailAddress => 'メールアドレス';

  @override
  String get streetAddress => '住所（番地など）';

  @override
  String get city => '市区町村';

  @override
  String get zipCode => '郵便番号';

  @override
  String get country => '国';

  @override
  String get website => 'ウェブサイト';

  @override
  String get noSavedImagesYet => '保存された画像はまだありません';

  @override
  String get saveImagesFromEditor => 'エディタから画像を保存するか、新しくインポートしてください';

  @override
  String get enterWifiSSID => 'WiFiのSSIDを入力してください';

  @override
  String get enterWifiPassword => 'WiFiのパスワードを入力してください';

  @override
  String get writeMultiple => '複数を書き込む';

  @override
  String get searchImages => '画像を検索...';

  @override
  String get filter => 'フィルター:';

  @override
  String get all => 'すべて';

  @override
  String get imported => 'インポート済み';

  @override
  String get editor => 'エディタ';

  @override
  String get imageLibrary => '画像ライブラリ';

  @override
  String get selectImagesToDelete => '削除する画像を選択';

  @override
  String get delete => '削除';

  @override
  String get deleteMode => '削除モード';

  @override
  String get deleteImage => '画像を削除';

  @override
  String get thisActionCannotBeUndone => 'この操作は元に戻せません';

  @override
  String get filterLabel => 'フィルター:';

  @override
  String get areYouSureDeleteImage => '本当にこの画像を削除しますか？この操作は元に戻せません。';

  @override
  String get deleteMultipleImages => '複数の画像を削除';

  @override
  String get imagesSelected => '件の画像が選択されました';

  @override
  String get imagesSelectedForDeletion => '件の画像が削除対象として選択されました';

  @override
  String areYouSureDeleteMultipleImages(Object count) {
    return '本当にこれら $count 件の画像を削除しますか？この操作は元に戻せません。';
  }

  @override
  String get areYouSureDeleteSingleImage => '本当にこの画像を削除しますか？この操作は元に戻せません。';

  @override
  String get deleteAll => 'すべて削除';

  @override
  String get renameImage => '画像の名前を変更';

  @override
  String get enterNewNameForImage => '画像の新しい名前を入力してください';

  @override
  String get imageName => '画像名';

  @override
  String get enterImageName => '画像名を入力してください...';

  @override
  String get rename => '名前を変更';

  @override
  String get imageProperties => '画像のプロパティ';

  @override
  String get created => '作成日時';

  @override
  String get source => 'ソース:';

  @override
  String get epdModel => 'EPDモデル:';

  @override
  String get transferToEpaper => '電子ペーパーに転送';

  @override
  String get saveImage => '画像を保存';

  @override
  String get saveFilteredImageToLibrary => 'フィルターされた画像をライブラリに保存します';

  @override
  String get filterApplied => '適用されたフィルター:';

  @override
  String get save => '保存';

  @override
  String get noImagesMatchSearch => '検索条件に一致する画像がありません';

  @override
  String get vCardDataCannotBeEmpty => 'vCardデータは空にできません';

  @override
  String get renamingImage => '画像の名前を変更しています...';

  @override
  String get imageRenamedTo => '画像名が変更されました: \"';

  @override
  String get failedToRenameImage => '画像名の変更に失敗しました: ';

  @override
  String get deletingImage => '画像を削除しています...';

  @override
  String get imageDeleted => '画像 \"';

  @override
  String get deleted => '\" が削除されました';

  @override
  String get failedToDeleteImage => '画像の削除に失敗しました: ';

  @override
  String get deletingImages => '削除しています ';

  @override
  String get images => ' 件の画像...';

  @override
  String get failedToDeleteImages => '画像の削除に失敗しました: ';

  @override
  String get imagesDeletedSuccessfully => ' 件の画像が正常に削除されました';

  @override
  String get imageDeletedSuccessfully => '画像が正常に削除されました';

  @override
  String get failedToLoadImageData => '画像データの読み込みに失敗しました: \"';

  @override
  String get failedToDecodeImage => '画像のデコードに失敗しました: \"';

  @override
  String get failedToTransfer => '転送に失敗しました: \"';

  @override
  String get savingImage => '画像を保存しています...';

  @override
  String get imageSavedToLibrary => '画像がライブラリに保存されました！';

  @override
  String get failedToSaveImage => '画像の保存に失敗しました: ';

  @override
  String get errorCreatingVCardRecord => 'vCardレコードの作成エラー: ';

  @override
  String get nfcIsDisabledPleaseEnableIt => 'NFCが無効になっています。有効にしてください。';

  @override
  String get thisDeviceDoesNotSupportNfc => 'このデバイスはNFCをサポートしていません。';

  @override
  String get bringPhoneNearMagicEpaperHardware =>
      'スマートフォンをMagic ePaperハードウェアに近づけてください';

  @override
  String get tagDetectedInitializing => 'タグを検出しました！初期化しています...';

  @override
  String get enablingEnergyHarvesting => '環境発電を有効にしています...';

  @override
  String get processingImageData => '画像データを処理しています...';

  @override
  String get refreshingDisplay => 'ディスプレイを更新しています...';

  @override
  String get notMagicEpaperHardware => 'Magic ePaperハードウェアではありません';

  @override
  String get errorCheckingMessage => 'メッセージの確認エラー: ';

  @override
  String get timeoutWaitingForI2cMessage => 'I2Cメッセージの待機がタイムアウトしました';

  @override
  String get writingChunk => 'チャンクを書き込んでいます ';

  @override
  String get transferredSuccessfully => '正常に転送されました。';

  @override
  String get waitingForNfcTag => 'NFCタグを待機しています...';

  @override
  String get gotTag => 'タグを取得しました！';

  @override
  String get frame => 'フレーム ';

  @override
  String get couldNotOpenLink => 'リンクを開けませんでした。';

  @override
  String get errorOccurredWhileOpeningLink => 'リンクを開く際にエラーが発生しました。';

  @override
  String get errorCreatingAppRecord => 'アプリレコードの作成エラー: ';

  @override
  String get appCannotBeEmpty => 'アプリは空にできません';

  @override
  String get invalidPackageName => '無効なパッケージ名';

  @override
  String get writeAppLauncherData => 'アプリランチャーデータを書き込む';

  @override
  String get writeAppLauncher => 'アプリランチャーを書き込む';

  @override
  String get searchApps => 'アプリを検索...';

  @override
  String get customPackageName => 'カスタムパッケージ名';

  @override
  String get enterPackageName => 'パッケージ名を入力してください...';

  @override
  String get noAppsFound => 'アプリが見つかりません';

  @override
  String get selectApplication => 'アプリケーションを選択';

  @override
  String get errorLoadingApps => 'アプリの読み込みエラー: ';

  @override
  String get add => '追加';

  @override
  String get readNfcTags => 'NFCタグを読み取る';

  @override
  String get writeNfcTags => 'NFCタグを書き込む';

  @override
  String get nfcIsReadyToUse => 'NFCの準備が完了しました。NFCタグの読み取りと書き込みが可能です。';

  @override
  String get deviceDoesNotSupportNfc => 'このデバイスはNFC機能をサポートしていません。';

  @override
  String get pleaseEnableNfcInSettings => '続行するには、デバイスの設定でNFCを有効にしてください。';

  @override
  String get nfcIsNowEnabledAndReady => 'NFCが有効になり、使用できるようになりました！';

  @override
  String get nfcHasBeenDisabled => 'NFCが無効になりました。NFC機能を引き続き使用するには有効にしてください。';

  @override
  String get nfcIsNotSupportedOnDevice => 'このデバイスではNFCはサポートされていません。';

  @override
  String get arduinoExport => 'Arduinoエクスポート';

  @override
  String get exportXmbFilesForArduino => 'Arduino用のXMBファイルをエクスポート';

  @override
  String get cardTemplates => 'カードテンプレート';

  @override
  String get chooseTemplateSubtitle => '開始するにはテンプレートを選択してください';

  @override
  String get employeeIdCardTitle => '従業員IDカード';

  @override
  String get employeeIdCardDescription => 'プロフェッショナルな従業員IDカードを作成します';

  @override
  String get shopPriceTagTitle => 'ショップの価格タグ';

  @override
  String get shopPriceTagDescription => '商品の魅力的な価格タグをデザインします';

  @override
  String get entryPassTagTitle => '入場パスのタグ';

  @override
  String get entryPassTagDescription => 'イベントや会場の入場パスを生成します';

  @override
  String get eventBadgeTitle => 'イベントバッジ';

  @override
  String get eventBadgeDescription => 'パーソナライズされたイベントバッジとネームタグを作成します';

  @override
  String get comingSoon => '近日公開';

  @override
  String get comingSoonMessage => 'このテンプレートは現在開発中であり、間もなく利用可能になります。';

  @override
  String get ok => 'OK';

  @override
  String get defaultCompanyName => '会社名';

  @override
  String get nameLabel => '名前';

  @override
  String get positionLabel => '役職';

  @override
  String get divisionLabel => '部署';

  @override
  String get idLabel => 'ID';

  @override
  String get emptyFieldPlaceholder => '指定なし';

  @override
  String get productImage => '商品画像';

  @override
  String get productName => '商品名';

  @override
  String get sizeQuantity => 'サイズ/数量';

  @override
  String get defaultCurrency => '¥';

  @override
  String get defaultPrice => '0.00';

  @override
  String get price => '価格';

  @override
  String get quantitySize => '数量/サイズ';

  @override
  String get quantitySizeHint => 'サイズ/数量を入力 (例: 750ml, 2kg, Lサイズ)';

  @override
  String get namePrefix => '名前: ';

  @override
  String get positionPrefix => '役職: ';

  @override
  String get divisionPrefix => '部署: ';

  @override
  String get idPrefix => 'ID: ';

  @override
  String get employeeIdCard => '従業員IDカード';

  @override
  String get fillDetailsToCreateId => '従業員IDカードを作成するには、以下の詳細を入力してください';

  @override
  String get idCardDetails => 'IDカードの詳細';

  @override
  String get companyName => '会社名';

  @override
  String get enterCompanyName => '会社名を入力してください';

  @override
  String get pleaseEnterCompanyName => '会社名を入力してください';

  @override
  String get name => '名前';

  @override
  String get enterEmployeeName => '従業員名を入力してください';

  @override
  String get pleaseEnterName => '名前を入力してください';

  @override
  String get position => '役職';

  @override
  String get enterJobPosition => '役職を入力してください';

  @override
  String get pleaseEnterPosition => '役職を入力してください';

  @override
  String get division => '部署';

  @override
  String get enterDepartment => '部署を入力してください';

  @override
  String get pleaseEnterDivision => '部署を入力してください';

  @override
  String get idNumber => 'ID番号';

  @override
  String get enterUniqueId => '一意のIDを入力してください';

  @override
  String get pleaseEnterIdNumber => 'ID番号を入力してください';

  @override
  String get qrCodeData => 'QRコードデータ';

  @override
  String get enterQrCodeData => 'QRコードデータを入力してください';

  @override
  String get pleaseEnterQrCodeData => 'QRコードデータを入力してください';

  @override
  String get generatingIdCard => 'IDカードを生成しています...';

  @override
  String get generateIdCard => 'IDカードを生成';

  @override
  String get profilePhoto => 'プロフィール写真';

  @override
  String get selected => '選択済み';

  @override
  String get photoSelected => '写真が選択されました';

  @override
  String get selectProfilePhoto => 'プロフィール写真を選択';

  @override
  String get tapToChangePhoto => 'タップして写真を変更';

  @override
  String get tapToSelectFromGallery => 'タップしてギャラリーから選択';

  @override
  String get priceTagGenerator => '価格タグジェネレーター';

  @override
  String get priceTagDescription => '商品のプロフェッショナルな価格タグを作成します';

  @override
  String get productDetails => '商品の詳細';

  @override
  String get productNameHint => '商品名を入力 (例: iPhone 15 Pro)';

  @override
  String get pleaseEnterProductName => '商品名を入力してください';

  @override
  String get currency => '通貨';

  @override
  String get currencyHint => '¥';

  @override
  String get required => '必須';

  @override
  String get priceHint => '999';

  @override
  String get pleaseEnterPrice => '価格を入力してください';

  @override
  String get pleaseEnterQuantitySize => '数量またはサイズを入力してください';

  @override
  String get pleaseEnterBarcodeData => 'バーコードデータを入力してください';

  @override
  String get generatingPriceTag => '価格タグを生成しています...';

  @override
  String get generatePriceTag => '価格タグを生成';

  @override
  String get productImageIn => '商品画像';

  @override
  String get productImageSelected => '商品画像が選択されました';

  @override
  String get selectProductImage => '商品画像を選択';

  @override
  String get tapToChangeImage => 'タップして画像を変更';

  @override
  String get chooseImageFromGallery => 'ギャラリーから画像を選択';

  @override
  String get processingImages => '画像を処理しています...';

  @override
  String get refreshModeInfo => '更新モード情報';

  @override
  String get fullRefreshInfo => 'フルリフレッシュ';

  @override
  String get fullRefreshDescription =>
      'すべてのピクセルをクリアし、画像を再描画してディスプレイ全体を完全に更新します。これにより最高の画質とコントラストが得られますが、完了までに時間がかかります。';

  @override
  String get partialRefreshInfo => '部分リフレッシュ（波形）';

  @override
  String get partialRefreshDescription =>
      '最適化された波形を使用して、変更されたピクセルのみを更新します。これはフルリフレッシュより高速ですが、時間が経つとゴーストが発生したりコントラストが低下したりする可能性があります。';

  @override
  String get longPressForInfo => '長押しで詳細情報を表示';
}
