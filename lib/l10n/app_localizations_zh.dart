// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Magic ePaper';

  @override
  String get aboutUsDescription =>
      'Magic ePaper 是一款专为控制和更新墨水屏（ePaper）设计的应用程序。其目标是提供使用 NFC 自定义图像、文本及图案并将其传输到墨水屏的工具。智能手机到 ePaper 硬件的数据传输通过 NFC 无线完成。该项目建立在定制固件和显示驱动程序之上，以实现无缝通信和高效的图像渲染。';

  @override
  String get developedBy => '开发者：';

  @override
  String get fossasiaContributors => 'FOSSASIA 贡献者';

  @override
  String get contactWithUs => '联系我们';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle => 'Fork 仓库并推送更改或提交新问题。';

  @override
  String get license => '许可证';

  @override
  String get licenseSubtitle => '查看 Magic ePaper 使用的 Apache License 2.0 条款。';

  @override
  String get createTransfer => '创建与传输图像';

  @override
  String get ndefScreen => 'Ndef';

  @override
  String get selectDisplayType => '选择您的墨水屏类型';

  @override
  String get settings => '设置';

  @override
  String get aboutUs => '关于我们';

  @override
  String get other => '其他';

  @override
  String get getBadge => '获取徽章';

  @override
  String get feedbackBugReports => '反馈/错误报告';

  @override
  String get continueButton => '继续';

  @override
  String get noImageSelectedFeedback => '请先导入图片！';

  @override
  String get adjustButtonLabel => '调整';

  @override
  String get importImageButtonLabel => '导入';

  @override
  String get openEditor => '创建';

  @override
  String get importStartingImageFeedback => '导入图片以开始';

  @override
  String get transferButtonLabel => '传输';

  @override
  String get filterScreenTitle => '选择滤镜';

  @override
  String get scanningForNfcTag => '正在扫描 NFC 标签...';

  @override
  String get scanningForNfcTagToWrite => '正在扫描要写入的 NFC 标签...';

  @override
  String get scanningForNfcTagToClear => '正在扫描要清除的 NFC 标签...';

  @override
  String get scanningTagForVerification => '正在扫描标签以进行验证...';

  @override
  String get errorCreatingTextRecord => '创建文本记录时出错：';

  @override
  String get errorCreatingUrlRecord => '创建 URL 记录时出错：';

  @override
  String get errorCreatingWifiRecord => '创建 WiFi 记录时出错：';

  @override
  String get errorCreatingMultipleRecords => '创建多个记录时出错：';

  @override
  String get pleaseEnterAtLeastOneRecord => '请输入至少一条记录';

  @override
  String get tagType => '标签类型：';

  @override
  String get tagId => '标签 ID：';

  @override
  String get ndefAvailable => 'NDEF 可用：';

  @override
  String get ndefWritable => 'NDEF 可写：';

  @override
  String get unknown => '未知';

  @override
  String get textCannotBeEmpty => '文本不能为空';

  @override
  String get urlCannotBeEmpty => 'URL 不能为空';

  @override
  String get wifiSsidCannotBeEmpty => 'WiFi SSID 不能为空';

  @override
  String get defaultLanguage => 'zh';

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
  String get unknownNull => '未知 (null)';

  @override
  String get unknownType => '未知类型：';

  @override
  String get textPrefix => '文本：';

  @override
  String get textSuffix => ' (语言：';

  @override
  String get uriPrefix => 'URI：';

  @override
  String get mimePrefix => 'MIME：';

  @override
  String get absoluteUriPrefix => '绝对 URI：';

  @override
  String get rawPrefix => '原始数据：';

  @override
  String get emptyPayload => '有效载荷为空';

  @override
  String get binaryDataPrefix => '二进制数据 (';

  @override
  String get binaryDataSuffix => ' 字节)：';

  @override
  String get errorDecodingRecord => '解码记录时出错：';

  @override
  String get noNdefRecordsFound => '未找到 NDEF 记录';

  @override
  String get recordPrefix => '记录 ';

  @override
  String get recordSuffix => '：';

  @override
  String get tnfLabel => 'TNF：';

  @override
  String get typeLabel => '类型：';

  @override
  String get payloadSizeLabel => '有效载荷大小：';

  @override
  String get bytesLabel => ' 字节';

  @override
  String get contentLabel => '内容：';

  @override
  String get rawPayloadLabel => '原始有效载荷：';

  @override
  String get nullPayload => 'null';

  @override
  String get closingParenthesis => ')';

  @override
  String get closingParenthesisNewline => ')\n';

  @override
  String get scanYourNfcTag => '请扫描您的 NFC 标签';

  @override
  String get scanYourNfcTagToWrite => '扫描您的 NFC 标签以写入';

  @override
  String get scanYourNfcTagToClear => '扫描您的 NFC 标签以清除';

  @override
  String get scanTagToVerifyContent => '扫描标签以验证内容';

  @override
  String get tagIsNotNdefCompatible => '标签不兼容 NDEF';

  @override
  String get tagDoesNotSupportNdef => '标签不支持 NDEF';

  @override
  String get tagIsNotWritable => '标签不可写';

  @override
  String get tagDoesNotSupportNdefCannotClear => '标签不支持 NDEF，无法清除';

  @override
  String get tagIsNotWritableCannotClear => '标签不可写，无法清除';

  @override
  String get readOperationCompleted => '读取操作完成';

  @override
  String get writeOperationCompleted => '写入操作完成';

  @override
  String get clearOperationCompleted => '清除操作完成';

  @override
  String get ndefRecordsFound => '找到 NDEF 记录：';

  @override
  String get theTagIsEmpty => '标签为空';

  @override
  String get record => '记录 ';

  @override
  String get type => '类型：';

  @override
  String get tnf => 'TNF：';

  @override
  String get content => '内容：';

  @override
  String get noRecordsToWrite => '没有要写入的记录';

  @override
  String get ndefRecordsWrittenSuccessfully => 'NDEF 记录写入成功';

  @override
  String get recordsWritten => '已写入的记录：';

  @override
  String get writtenRecord => '已写入的记录 ';

  @override
  String get tagClearedSuccessfully => '标签清除成功';

  @override
  String get method => '方法：';

  @override
  String get tagIsNowReadyForNewData => '标签现已准备好接收新数据';

  @override
  String get emptyTextRecord => '空文本记录';

  @override
  String get emptyNdefRecord => '空 NDEF 记录';

  @override
  String get minimalSpaceCharacter => '最小空格字符';

  @override
  String get emptyRecordList => '空记录列表';

  @override
  String get allClearingMethodsFailed => '所有清除方法均失败：';

  @override
  String get verificationResults => '验证结果：';

  @override
  String get recordsFound => '找到的记录：';

  @override
  String get noNdefRecordsFoundOnTag => '标签上未找到 NDEF 记录';

  @override
  String get theTagIsEmptyCleared => '标签为空/已清除';

  @override
  String get errorReadingTag => '读取标签时出错：';

  @override
  String get errorWritingToTag => '写入标签时出错：';

  @override
  String get errorClearingTag => '清除标签时出错：';

  @override
  String get verificationError => '验证错误：';

  @override
  String get holdTagCloseAndTryAgain => '。请将标签靠近并重试';

  @override
  String get tryHoldingTagCloser => '。请尝试将标签靠得更近';

  @override
  String get tryMovingTagCloser => '。请尝试将标签移近';

  @override
  String get method1EmptyTextRecordFailed => '方法 1（空文本记录）失败：';

  @override
  String get method2EmptyNdefRecordFailed => '方法 2（空 NDEF 记录）失败：';

  @override
  String get method3MinimalRecordFailed => '方法 3（最小记录）失败：';

  @override
  String get method4EmptyListFailed => '方法 4（空列表）失败：';

  @override
  String get errorFinishingNfcSession => '结束 NFC 会话时出错：';

  @override
  String get secondaryCleanupAlsoFailed => '二次清理也失败了：';

  @override
  String get multipleTagsFoundPleaseSelectOne => '找到多个标签，请选择一个';

  @override
  String get scanYourNfcTagDefault => '扫描您的 NFC 标签';

  @override
  String get readNdefTags => '读取 NDEF 标签';

  @override
  String get reading => '正在读取...';

  @override
  String get readNfcTag => '读取 NFC 标签';

  @override
  String get verify => '验证';

  @override
  String get clearing => '正在清除...';

  @override
  String get clearNfcTag => '清除 NFC 标签';

  @override
  String get monospaceFontFamily => 'monospace';

  @override
  String get nfcStatus => 'NFC 状态';

  @override
  String get refreshNfcStatus => '刷新 NFC 状态';

  @override
  String get writeNdefRecords => '写入 NDEF 记录';

  @override
  String get textRecord => '文本记录';

  @override
  String get enterTextToWriteToNfcTag => '输入要写入 NFC 标签的文本';

  @override
  String get writing => '正在写入...';

  @override
  String get writeText => '写入文本';

  @override
  String get urlRecord => 'URL 记录';

  @override
  String get enterUrl => '输入 URL';

  @override
  String get writeUrl => '写入 URL';

  @override
  String get wifiRecord => 'WiFi 记录';

  @override
  String get wifiNetworkNameSsid => 'WiFi 网络名称 (SSID)';

  @override
  String get wifiPassword => 'WiFi 密码';

  @override
  String get writeWifi => '写入 WiFi';

  @override
  String get writeAllRecords => '写入所有记录';

  @override
  String get writeAllNonEmptyFieldsDescription => '一次性将所有非空字段写入 NFC 标签';

  @override
  String get writeMultipleRecords => '写入多个记录';

  @override
  String get readOperationFailed => '读取操作失败';

  @override
  String get tagReadSuccessfully => '标签读取成功';

  @override
  String get verificationFailed => '验证失败';

  @override
  String get tagVerifiedSuccessfully => '标签验证成功';

  @override
  String get clearNfcTagConfirmation => '您确定要清除此 NFC 标签吗？此操作无法撤销。';

  @override
  String get clearOperationFailed => '清除操作失败';

  @override
  String get writeOperationFailed => '写入操作失败';

  @override
  String get dataWrittenSuccessfully => '数据写入成功';

  @override
  String get nfcNotAvailable => 'NFC 不可用';

  @override
  String get enableNfcMessage => '请在您的设备设置中启用 NFC 以使用此功能。';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get error => '错误';

  @override
  String get successfully => '成功';

  @override
  String get language => '语言';

  @override
  String get loading => '正在加载...';

  @override
  String get exportXbm => '导出 XBM';

  @override
  String get exportingXbm => '正在导出 XBM 文件...';

  @override
  String get fullRefresh => '全局刷新';

  @override
  String get fullRefreshSelected => '已选择全局刷新';

  @override
  String get waveformSelected => '已选择';

  @override
  String get barcode => '条形码';

  @override
  String get library => '图库';

  @override
  String get templates => '模板';

  @override
  String get barcodeGenerator => '条形码生成器';

  @override
  String get barcodeData => '条形码数据';

  @override
  String get barcodeDataHint => '输入条形码或 SKU';

  @override
  String get characters => '字符';

  @override
  String get scanBarcode => '扫描条形码';

  @override
  String get barcodeFormat => '条形码格式';

  @override
  String get enterOrScanBarcodeData => '输入或扫描条形码数据';

  @override
  String get invalidBarcode => '无效的条形码';

  @override
  String get invalidCharacter => '无效字符';

  @override
  String get supportedCharacters => '支持的字符包括';

  @override
  String get pleaseCheckBarcodeRules => '请检查条形码规则。';

  @override
  String get dataTooShort => '数据太短。最小长度为';

  @override
  String get dataTooLong => '数据太长。最大长度为';

  @override
  String get isText => '是';

  @override
  String get pointCameraAtBarcode => '将相机对准条形码进行扫描';

  @override
  String get generateImage => '生成图像';

  @override
  String get exportFailed => '导出失败';

  @override
  String get exportedXbmFiles => '已将 XBM 文件导出至 MagicEpaper/XBM/';

  @override
  String get exported => '已导出';

  @override
  String get xbmFilesToMagicEpaper => 'XBM 文件至 MagicEpaper/XBM/';

  @override
  String get floydSteinberg => '经典';

  @override
  String get stucki => '锐利';

  @override
  String get atkinson => '复古';

  @override
  String get falseFloydSteinberg => '简单';

  @override
  String get halftone => '报纸';

  @override
  String get threshold => '海报化';

  @override
  String get colorHalftone => '彩色报纸';

  @override
  String get searchingForDevice => '正在搜索设备';

  @override
  String get displayRefreshing => '屏幕正在刷新';

  @override
  String get transferComplete => '传输完成！';

  @override
  String get writingToEpaper => '正在写入墨水屏';

  @override
  String get pleaseBringPhoneClose => '请将手机靠近 Magic ePaper 设备';

  @override
  String get keepPhoneClose => '请保持手机靠近！';

  @override
  String get displayRefreshingMessage => '屏幕正在刷新。请将手机靠近设备，直到图像完全显示。';

  @override
  String get transferFailed => '传输失败';

  @override
  String get deviceConnectionTimeout => '设备连接超时。请尝试将手机更靠近设备，然后重试。';

  @override
  String get connectionLostDuringTransfer => '传输过程中连接丢失。请将手机靠近设备并重试。';

  @override
  String get done => '完成';

  @override
  String get close => '关闭';

  @override
  String get processingImage => '正在处理图像...';

  @override
  String get readyToFlash => '准备好刷入';

  @override
  String get imageProcessedSuccessfully => '图像处理成功。';

  @override
  String get tapBelowAndHold => '点击下方并将手机靠近屏幕。';

  @override
  String get startFlashing => '开始刷入';

  @override
  String get flashing => '正在刷入...';

  @override
  String get keepPhoneStill => '请保持手机静止。';

  @override
  String get success => '成功！';

  @override
  String get transferCompleteMessage => '传输完成！';

  @override
  String get unknownErrorOccurred => '发生未知错误。';

  @override
  String get resultsCleared => '结果已清除';

  @override
  String get clearResults => '清除结果';

  @override
  String get vCardContact => 'vCard 联系人';

  @override
  String get writingVCard => '正在写入 vCard...';

  @override
  String get writeVCard => '写入 vCard';

  @override
  String get firstName => '名字';

  @override
  String get lastName => '姓氏';

  @override
  String get organization => '组织/公司';

  @override
  String get title => '职位';

  @override
  String get mobileNumber => '手机号码';

  @override
  String get emailAddress => '电子邮件地址';

  @override
  String get streetAddress => '街道地址';

  @override
  String get city => '城市';

  @override
  String get zipCode => '邮政编码';

  @override
  String get country => '国家/地区';

  @override
  String get website => '网站';

  @override
  String get noSavedImagesYet => '暂无保存的图像';

  @override
  String get saveImagesFromEditor => '从编辑器保存图像或导入新图像';

  @override
  String get enterWifiSSID => '输入 WiFi SSID';

  @override
  String get enterWifiPassword => '输入 WiFi 密码';

  @override
  String get writeMultiple => '写入多个';

  @override
  String get searchImages => '搜索图像...';

  @override
  String get filter => '滤镜：';

  @override
  String get all => '全部';

  @override
  String get imported => '已导入';

  @override
  String get editor => '编辑器';

  @override
  String get imageLibrary => '图库';

  @override
  String get selectImagesToDelete => '选择要删除的图像';

  @override
  String get delete => '删除';

  @override
  String get deleteMode => '删除模式';

  @override
  String get deleteImage => '删除图像';

  @override
  String get thisActionCannotBeUndone => '此操作无法撤销';

  @override
  String get filterLabel => '滤镜：';

  @override
  String get areYouSureDeleteImage => '您确定要删除此图像吗？此操作无法撤销。';

  @override
  String get deleteMultipleImages => '删除多张图像';

  @override
  String get imagesSelected => '张图像已选中';

  @override
  String get imagesSelectedForDeletion => '张图像被选中待删除';

  @override
  String areYouSureDeleteMultipleImages(Object count) {
    return '您确定要删除这 $count 张图像吗？此操作无法撤销。';
  }

  @override
  String get areYouSureDeleteSingleImage => '您确定要删除此图像吗？此操作无法撤销。';

  @override
  String get deleteAll => '删除全部';

  @override
  String get renameImage => '重命名图像';

  @override
  String get enterNewNameForImage => '为您的图像输入新名称';

  @override
  String get imageName => '图像名称';

  @override
  String get enterImageName => '输入图像名称...';

  @override
  String get rename => '重命名';

  @override
  String get imageProperties => '图像属性';

  @override
  String get created => '创建时间';

  @override
  String get source => '来源：';

  @override
  String get epdModel => 'EPD 型号：';

  @override
  String get transferToEpaper => '传输至墨水屏';

  @override
  String get saveImage => '保存图像';

  @override
  String get saveFilteredImageToLibrary => '将应用了滤镜的图像保存到图库';

  @override
  String get filterApplied => '已应用滤镜：';

  @override
  String get save => '保存';

  @override
  String get noImagesMatchSearch => '没有与您的搜索匹配的图像';

  @override
  String get vCardDataCannotBeEmpty => 'vCard 数据不能为空';

  @override
  String get renamingImage => '正在重命名图像...';

  @override
  String get imageRenamedTo => '图像重命名为 \"';

  @override
  String get failedToRenameImage => '重命名图像失败：';

  @override
  String get deletingImage => '正在删除图像...';

  @override
  String get imageDeleted => '图像 \"';

  @override
  String get deleted => '\" 已删除';

  @override
  String get failedToDeleteImage => '删除图像失败：';

  @override
  String get deletingImages => '正在删除 ';

  @override
  String get images => ' 张图像...';

  @override
  String get failedToDeleteImages => '删除图像失败：';

  @override
  String get imagesDeletedSuccessfully => ' 张图像已成功删除';

  @override
  String get imageDeletedSuccessfully => '图像已成功删除';

  @override
  String get failedToLoadImageData => '无法加载图像数据：\"';

  @override
  String get failedToDecodeImage => '无法解码图像：\"';

  @override
  String get failedToTransfer => '传输失败：\"';

  @override
  String get savingImage => '正在保存图像...';

  @override
  String get imageSavedToLibrary => '图像已保存到图库！';

  @override
  String get failedToSaveImage => '保存图像失败：';

  @override
  String get errorCreatingVCardRecord => '创建 vCard 记录时出错：';

  @override
  String get nfcIsDisabledPleaseEnableIt => 'NFC 已禁用。请启用它。';

  @override
  String get thisDeviceDoesNotSupportNfc => '此设备不支持 NFC。';

  @override
  String get bringPhoneNearMagicEpaperHardware => '将手机靠近 Magic ePaper 硬件';

  @override
  String get tagDetectedInitializing => '检测到标签！正在初始化...';

  @override
  String get enablingEnergyHarvesting => '正在启用能量收集...';

  @override
  String get processingImageData => '正在处理图像数据...';

  @override
  String get refreshingDisplay => '正在刷新屏幕...';

  @override
  String get notMagicEpaperHardware => '不是 Magic ePaper 硬件';

  @override
  String get errorCheckingMessage => '检查消息时出错：';

  @override
  String get timeoutWaitingForI2cMessage => '等待 I2C 消息超时';

  @override
  String get writingChunk => '正在写入数据块 ';

  @override
  String get transferredSuccessfully => '传输成功。';

  @override
  String get waitingForNfcTag => '等待 NFC 标签...';

  @override
  String get gotTag => '找到标签！';

  @override
  String get frame => '帧 ';

  @override
  String get couldNotOpenLink => '无法打开链接。';

  @override
  String get errorOccurredWhileOpeningLink => '打开链接时发生错误。';

  @override
  String get errorCreatingAppRecord => '创建应用记录时出错：';

  @override
  String get appCannotBeEmpty => '应用不能为空';

  @override
  String get invalidPackageName => '无效的包名';

  @override
  String get writeAppLauncherData => '写入应用启动器数据';

  @override
  String get writeAppLauncher => '写入应用启动器';

  @override
  String get searchApps => '搜索应用...';

  @override
  String get customPackageName => '自定义包名';

  @override
  String get enterPackageName => '输入包名...';

  @override
  String get noAppsFound => '未找到应用';

  @override
  String get selectApplication => '选择应用程序';

  @override
  String get errorLoadingApps => '加载应用时出错：';

  @override
  String get add => '添加';

  @override
  String get readNfcTags => '读取 NFC 标签';

  @override
  String get writeNfcTags => '写入 NFC 标签';

  @override
  String get nfcIsReadyToUse => 'NFC 已准备就绪。您可以读取和写入 NFC 标签。';

  @override
  String get deviceDoesNotSupportNfc => '此设备不支持 NFC 功能。';

  @override
  String get pleaseEnableNfcInSettings => '请在您的设备设置中启用 NFC 以继续。';

  @override
  String get nfcIsNowEnabledAndReady => 'NFC 现已启用并准备就绪！';

  @override
  String get nfcHasBeenDisabled => 'NFC 已被禁用。请启用以继续使用 NFC 功能。';

  @override
  String get nfcIsNotSupportedOnDevice => '此设备不支持 NFC。';

  @override
  String get arduinoExport => '导出为 Arduino 代码';

  @override
  String get exportXmbFilesForArduino => '为 Arduino 导出 XMB 文件';

  @override
  String get cardTemplates => '卡片模板';

  @override
  String get chooseTemplateSubtitle => '选择一个模板以开始';

  @override
  String get employeeIdCardTitle => '员工工牌';

  @override
  String get employeeIdCardDescription => '创建专业的员工身份识别卡';

  @override
  String get shopPriceTagTitle => '商店价格标签';

  @override
  String get shopPriceTagDescription => '为您的产品设计吸引人的价格标签';

  @override
  String get entryPassTagTitle => '入场通行证';

  @override
  String get entryPassTagDescription => '生成活动和场地的入场通行证';

  @override
  String get eventBadgeTitle => '活动徽章';

  @override
  String get eventBadgeDescription => '创建个性化的活动徽章和名牌';

  @override
  String get comingSoon => '敬请期待';

  @override
  String get comingSoonMessage => '此模板目前正在开发中，即将推出。';

  @override
  String get ok => '确定';

  @override
  String get defaultCompanyName => '公司名称';

  @override
  String get nameLabel => '姓名';

  @override
  String get positionLabel => '职位';

  @override
  String get divisionLabel => '部门';

  @override
  String get idLabel => '编号';

  @override
  String get emptyFieldPlaceholder => '未指定';

  @override
  String get productImage => '产品图片';

  @override
  String get productName => '产品名称';

  @override
  String get sizeQuantity => '尺寸/数量';

  @override
  String get defaultCurrency => '￥';

  @override
  String get defaultPrice => '0.00';

  @override
  String get price => '价格';

  @override
  String get quantitySize => '数量/尺寸';

  @override
  String get quantitySizeHint => '输入尺寸/数量（例如：750ml，2kg，大号）';

  @override
  String get namePrefix => '姓名：';

  @override
  String get positionPrefix => '职位：';

  @override
  String get divisionPrefix => '部门：';

  @override
  String get idPrefix => '编号：';

  @override
  String get employeeIdCard => '员工工牌';

  @override
  String get fillDetailsToCreateId => '填写以下信息以创建您的员工工牌';

  @override
  String get idCardDetails => '工牌详情';

  @override
  String get companyName => '公司名称';

  @override
  String get enterCompanyName => '输入公司名称';

  @override
  String get pleaseEnterCompanyName => '请输入公司名称';

  @override
  String get name => '姓名';

  @override
  String get enterEmployeeName => '输入员工姓名';

  @override
  String get pleaseEnterName => '请输入姓名';

  @override
  String get position => '职位';

  @override
  String get enterJobPosition => '输入工作职位';

  @override
  String get pleaseEnterPosition => '请输入职位';

  @override
  String get division => '部门';

  @override
  String get enterDepartment => '输入部门';

  @override
  String get pleaseEnterDivision => '请输入部门';

  @override
  String get idNumber => '身份证/工号';

  @override
  String get enterUniqueId => '输入唯一编号';

  @override
  String get pleaseEnterIdNumber => '请输入编号';

  @override
  String get qrCodeData => '二维码数据';

  @override
  String get enterQrCodeData => '输入二维码数据';

  @override
  String get pleaseEnterQrCodeData => '请输入二维码数据';

  @override
  String get generatingIdCard => '正在生成工牌...';

  @override
  String get generateIdCard => '生成工牌';

  @override
  String get profilePhoto => '个人照片';

  @override
  String get selected => '已选择';

  @override
  String get photoSelected => '已选择照片';

  @override
  String get selectProfilePhoto => '选择个人照片';

  @override
  String get tapToChangePhoto => '点击更改照片';

  @override
  String get tapToSelectFromGallery => '点击从相册中选择';

  @override
  String get priceTagGenerator => '价格标签生成器';

  @override
  String get priceTagDescription => '为您的产品创建专业的价格标签';

  @override
  String get productDetails => '产品详情';

  @override
  String get productNameHint => '输入产品名称（例如：iPhone 15 Pro）';

  @override
  String get pleaseEnterProductName => '请输入产品名称';

  @override
  String get currency => '货币';

  @override
  String get currencyHint => '￥';

  @override
  String get required => '必填';

  @override
  String get priceHint => '99.99';

  @override
  String get pleaseEnterPrice => '请输入价格';

  @override
  String get pleaseEnterQuantitySize => '请输入数量或尺寸';

  @override
  String get pleaseEnterBarcodeData => '请输入条形码数据';

  @override
  String get generatingPriceTag => '正在生成价格标签...';

  @override
  String get generatePriceTag => '生成价格标签';

  @override
  String get productImageIn => '产品图片';

  @override
  String get productImageSelected => '已选择产品图片';

  @override
  String get selectProductImage => '选择产品图片';

  @override
  String get tapToChangeImage => '点击更改图片';

  @override
  String get chooseImageFromGallery => '从相册中选择图片';

  @override
  String get processingImages => '正在处理图像...';

  @override
  String get refreshModeInfo => '刷新模式信息';

  @override
  String get fullRefreshInfo => '全局刷新';

  @override
  String get fullRefreshDescription =>
      '通过清除所有像素并重新绘制图像来完全刷新整个显示屏。这能提供最佳的图像质量和对比度，但需要较长的时间完成。';

  @override
  String get partialRefreshInfo => '局部刷新（波形）';

  @override
  String get partialRefreshDescription =>
      '仅使用优化的波形更新更改的像素。这比全局刷新更快，但随着时间的推移可能会导致重影或对比度降低。';

  @override
  String get longPressForInfo => '长按获取更多信息';
}
