// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Magic ePaper';

  @override
  String get aboutUsDescription =>
      'Magic ePaper là ứng dụng được thiết kế để điều khiển và cập nhật màn hình ePaper. Mục tiêu là cung cấp các công cụ để tùy chỉnh và truyền hình ảnh, văn bản và họa tiết sang màn hình ePaper bằng NFC. Việc truyền dữ liệu từ điện thoại thông minh sang phần cứng ePaper được thực hiện không dây qua NFC. Dự án được xây dựng dựa trên phần mềm cơ sở tùy chỉnh và trình điều khiển hiển thị để liên lạc liền mạch và hiển thị hình ảnh hiệu quả.';

  @override
  String get developedBy => 'Được phát triển bởi';

  @override
  String get fossasiaContributors => 'Những người đóng góp cho FOSSASIA';

  @override
  String get contactWithUs => 'Liên hệ với chúng tôi';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle =>
      'Fork repo và đẩy các thay đổi hoặc gửi vấn đề mới.';

  @override
  String get license => 'Giấy phép';

  @override
  String get licenseSubtitle =>
      'Kiểm tra các điều khoản Giấy phép Apache 2.0 được sử dụng trên Magic ePaper.';

  @override
  String get createTransfer => 'Tạo & Truyền Ảnh';

  @override
  String get ndefScreen => 'Ndef';

  @override
  String get selectDisplayType => 'Chọn loại màn hình ePaper của bạn';

  @override
  String get settings => 'Cài đặt';

  @override
  String get aboutUs => 'Về chúng tôi';

  @override
  String get other => 'Khác';

  @override
  String get getBadge => 'Nhận huy hiệu';

  @override
  String get feedbackBugReports => 'Phản hồi / Báo lỗi';

  @override
  String get continueButton => 'Tiếp tục';

  @override
  String get noImageSelectedFeedback => 'Vui lòng nhập một hình ảnh trước!';

  @override
  String get adjustButtonLabel => 'Điều chỉnh';

  @override
  String get importImageButtonLabel => 'Nhập';

  @override
  String get openEditor => 'Tạo';

  @override
  String get importStartingImageFeedback => 'Nhập một hình ảnh để bắt đầu';

  @override
  String get transferButtonLabel => 'Truyền';

  @override
  String get filterScreenTitle => 'Chọn một bộ lọc';

  @override
  String get scanningForNfcTag => 'Đang quét thẻ NFC...';

  @override
  String get scanningForNfcTagToWrite => 'Đang quét thẻ NFC để ghi...';

  @override
  String get scanningForNfcTagToClear => 'Đang quét thẻ NFC để xóa...';

  @override
  String get scanningTagForVerification => 'Đang quét thẻ để xác minh...';

  @override
  String get errorCreatingTextRecord => 'Lỗi khi tạo bản ghi văn bản: ';

  @override
  String get errorCreatingUrlRecord => 'Lỗi khi tạo bản ghi URL: ';

  @override
  String get errorCreatingWifiRecord => 'Lỗi khi tạo bản ghi WiFi: ';

  @override
  String get errorCreatingMultipleRecords => 'Lỗi khi tạo nhiều bản ghi: ';

  @override
  String get pleaseEnterAtLeastOneRecord => 'Vui lòng nhập ít nhất một bản ghi';

  @override
  String get tagType => 'Loại thẻ: ';

  @override
  String get tagId => 'ID thẻ: ';

  @override
  String get ndefAvailable => 'NDEF khả dụng: ';

  @override
  String get ndefWritable => 'NDEF có thể ghi: ';

  @override
  String get unknown => 'Không xác định';

  @override
  String get textCannotBeEmpty => 'Văn bản không được để trống';

  @override
  String get urlCannotBeEmpty => 'URL không được để trống';

  @override
  String get wifiSsidCannotBeEmpty => 'SSID WiFi không được để trống';

  @override
  String get defaultLanguage => 'vi';

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
  String get unknownNull => 'Không xác định (null)';

  @override
  String get unknownType => 'Loại không xác định: ';

  @override
  String get textPrefix => 'Văn bản: ';

  @override
  String get textSuffix => ' (Ngôn ngữ: ';

  @override
  String get uriPrefix => 'URI: ';

  @override
  String get mimePrefix => 'MIME: ';

  @override
  String get absoluteUriPrefix => 'URI tuyệt đối: ';

  @override
  String get rawPrefix => 'Dữ liệu thô: ';

  @override
  String get emptyPayload => 'Payload trống';

  @override
  String get binaryDataPrefix => 'Dữ liệu nhị phân (';

  @override
  String get binaryDataSuffix => ' byte): ';

  @override
  String get errorDecodingRecord => 'Lỗi giải mã bản ghi: ';

  @override
  String get noNdefRecordsFound => 'Không tìm thấy bản ghi NDEF nào';

  @override
  String get recordPrefix => 'Bản ghi ';

  @override
  String get recordSuffix => ':';

  @override
  String get tnfLabel => 'TNF: ';

  @override
  String get typeLabel => 'Loại: ';

  @override
  String get payloadSizeLabel => 'Kích thước payload: ';

  @override
  String get bytesLabel => ' byte';

  @override
  String get contentLabel => 'Nội dung: ';

  @override
  String get rawPayloadLabel => 'Payload thô: ';

  @override
  String get nullPayload => 'null';

  @override
  String get closingParenthesis => ')';

  @override
  String get closingParenthesisNewline => ')\n';

  @override
  String get scanYourNfcTag => 'Quét thẻ NFC của bạn';

  @override
  String get scanYourNfcTagToWrite => 'Quét thẻ NFC của bạn để ghi';

  @override
  String get scanYourNfcTagToClear => 'Quét thẻ NFC của bạn để xóa';

  @override
  String get scanTagToVerifyContent => 'Quét thẻ để xác minh nội dung';

  @override
  String get tagIsNotNdefCompatible => 'Thẻ không tương thích NDEF';

  @override
  String get tagDoesNotSupportNdef => 'Thẻ không hỗ trợ NDEF';

  @override
  String get tagIsNotWritable => 'Thẻ không thể ghi';

  @override
  String get tagDoesNotSupportNdefCannotClear =>
      'Thẻ không hỗ trợ NDEF, không thể xóa';

  @override
  String get tagIsNotWritableCannotClear => 'Thẻ không thể ghi, không thể xóa';

  @override
  String get readOperationCompleted => 'Hoàn tất thao tác đọc';

  @override
  String get writeOperationCompleted => 'Hoàn tất thao tác ghi';

  @override
  String get clearOperationCompleted => 'Hoàn tất thao tác xóa';

  @override
  String get ndefRecordsFound => 'Đã tìm thấy bản ghi NDEF: ';

  @override
  String get theTagIsEmpty => 'Thẻ trống';

  @override
  String get record => 'Bản ghi ';

  @override
  String get type => 'Loại: ';

  @override
  String get tnf => 'TNF: ';

  @override
  String get content => 'Nội dung: ';

  @override
  String get noRecordsToWrite => 'Không có bản ghi nào để ghi';

  @override
  String get ndefRecordsWrittenSuccessfully => 'Ghi bản ghi NDEF thành công';

  @override
  String get recordsWritten => 'Bản ghi đã ghi: ';

  @override
  String get writtenRecord => 'Bản ghi đã ghi ';

  @override
  String get tagClearedSuccessfully => 'Đã xóa thẻ thành công';

  @override
  String get method => 'Phương pháp: ';

  @override
  String get tagIsNowReadyForNewData => 'Thẻ hiện đã sẵn sàng cho dữ liệu mới';

  @override
  String get emptyTextRecord => 'Bản ghi văn bản trống';

  @override
  String get emptyNdefRecord => 'Bản ghi NDEF trống';

  @override
  String get minimalSpaceCharacter => 'Ký tự khoảng trắng tối thiểu';

  @override
  String get emptyRecordList => 'Danh sách bản ghi trống';

  @override
  String get allClearingMethodsFailed =>
      'Tất cả các phương pháp xóa đều thất bại: ';

  @override
  String get verificationResults => 'Kết quả xác minh:';

  @override
  String get recordsFound => 'Bản ghi được tìm thấy: ';

  @override
  String get noNdefRecordsFoundOnTag =>
      'Không tìm thấy bản ghi NDEF nào trên thẻ';

  @override
  String get theTagIsEmptyCleared => 'Thẻ đã trống/được xóa';

  @override
  String get errorReadingTag => 'Lỗi khi đọc thẻ: ';

  @override
  String get errorWritingToTag => 'Lỗi khi ghi vào thẻ: ';

  @override
  String get errorClearingTag => 'Lỗi khi xóa thẻ: ';

  @override
  String get verificationError => 'Lỗi xác minh: ';

  @override
  String get holdTagCloseAndTryAgain => '. Giữ thẻ gần lại và thử lại';

  @override
  String get tryHoldingTagCloser => '. Hãy thử giữ thẻ gần hơn';

  @override
  String get tryMovingTagCloser => '. Hãy thử di chuyển thẻ gần hơn';

  @override
  String get method1EmptyTextRecordFailed =>
      'Phương pháp 1 (bản ghi văn bản trống) thất bại: ';

  @override
  String get method2EmptyNdefRecordFailed =>
      'Phương pháp 2 (bản ghi NDEF trống) thất bại: ';

  @override
  String get method3MinimalRecordFailed =>
      'Phương pháp 3 (bản ghi tối thiểu) thất bại: ';

  @override
  String get method4EmptyListFailed =>
      'Phương pháp 4 (danh sách trống) thất bại: ';

  @override
  String get errorFinishingNfcSession => 'Lỗi khi kết thúc phiên NFC: ';

  @override
  String get secondaryCleanupAlsoFailed => 'Dọn dẹp phụ cũng thất bại: ';

  @override
  String get multipleTagsFoundPleaseSelectOne =>
      'Tìm thấy nhiều thẻ, vui lòng chọn một';

  @override
  String get scanYourNfcTagDefault => 'Quét thẻ NFC của bạn';

  @override
  String get readNdefTags => 'Đọc thẻ NDEF';

  @override
  String get reading => 'Đang đọc...';

  @override
  String get readNfcTag => 'Đọc thẻ NFC';

  @override
  String get verify => 'Xác minh';

  @override
  String get clearing => 'Đang xóa...';

  @override
  String get clearNfcTag => 'Xóa thẻ NFC';

  @override
  String get monospaceFontFamily => 'monospace';

  @override
  String get nfcStatus => 'Trạng thái NFC';

  @override
  String get refreshNfcStatus => 'Làm mới trạng thái NFC';

  @override
  String get writeNdefRecords => 'Ghi bản ghi NDEF';

  @override
  String get textRecord => 'Bản ghi văn bản';

  @override
  String get enterTextToWriteToNfcTag => 'Nhập văn bản để ghi vào thẻ NFC';

  @override
  String get writing => 'Đang ghi...';

  @override
  String get writeText => 'Ghi văn bản';

  @override
  String get urlRecord => 'Bản ghi URL';

  @override
  String get enterUrl => 'Nhập URL';

  @override
  String get writeUrl => 'Ghi URL';

  @override
  String get wifiRecord => 'Bản ghi WiFi';

  @override
  String get wifiNetworkNameSsid => 'Tên mạng WiFi (SSID)';

  @override
  String get wifiPassword => 'Mật khẩu WiFi';

  @override
  String get writeWifi => 'Ghi WiFi';

  @override
  String get writeAllRecords => 'Ghi tất cả bản ghi';

  @override
  String get writeAllNonEmptyFieldsDescription =>
      'Ghi tất cả các trường không trống vào thẻ NFC cùng một lúc';

  @override
  String get writeMultipleRecords => 'Ghi nhiều bản ghi';

  @override
  String get readOperationFailed => 'Thao tác đọc thất bại';

  @override
  String get tagReadSuccessfully => 'Đọc thẻ thành công';

  @override
  String get verificationFailed => 'Xác minh thất bại';

  @override
  String get tagVerifiedSuccessfully => 'Xác minh thẻ thành công';

  @override
  String get clearNfcTagConfirmation =>
      'Bạn có chắc chắn muốn xóa thẻ NFC này không? Hành động này không thể hoàn tác.';

  @override
  String get clearOperationFailed => 'Thao tác xóa thất bại';

  @override
  String get writeOperationFailed => 'Thao tác ghi thất bại';

  @override
  String get dataWrittenSuccessfully => 'Ghi dữ liệu thành công';

  @override
  String get nfcNotAvailable => 'NFC không khả dụng';

  @override
  String get enableNfcMessage =>
      'Vui lòng bật NFC trong cài đặt thiết bị của bạn để sử dụng tính năng này.';

  @override
  String get cancel => 'Hủy';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get error => 'Lỗi';

  @override
  String get successfully => 'thành công';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get loading => 'Đang tải...';

  @override
  String get exportXbm => 'Xuất XBM';

  @override
  String get exportingXbm => 'Đang xuất tệp XBM...';

  @override
  String get fullRefresh => 'Làm mới toàn bộ';

  @override
  String get fullRefreshSelected => 'Đã chọn làm mới toàn bộ';

  @override
  String get waveformSelected => 'Đã chọn';

  @override
  String get barcode => 'Mã vạch';

  @override
  String get library => 'Thư viện';

  @override
  String get templates => 'Mẫu';

  @override
  String get barcodeGenerator => 'Trình tạo mã vạch';

  @override
  String get barcodeData => 'Dữ liệu mã vạch';

  @override
  String get barcodeDataHint => 'Nhập số mã vạch hoặc SKU';

  @override
  String get characters => 'Ký tự';

  @override
  String get scanBarcode => 'Quét mã vạch';

  @override
  String get barcodeFormat => 'Định dạng mã vạch';

  @override
  String get enterOrScanBarcodeData => 'Nhập hoặc quét dữ liệu mã vạch';

  @override
  String get invalidBarcode => 'Mã vạch không hợp lệ';

  @override
  String get invalidCharacter => 'Ký tự không hợp lệ';

  @override
  String get supportedCharacters => 'Các ký tự được hỗ trợ là';

  @override
  String get pleaseCheckBarcodeRules =>
      'Vui lòng kiểm tra các quy tắc mã vạch.';

  @override
  String get dataTooShort => 'Dữ liệu quá ngắn. Độ dài tối thiểu cho';

  @override
  String get dataTooLong => 'Dữ liệu quá dài. Độ dài tối đa cho';

  @override
  String get isText => 'là';

  @override
  String get pointCameraAtBarcode => 'Hướng camera vào mã vạch để quét';

  @override
  String get generateImage => 'Tạo hình ảnh';

  @override
  String get exportFailed => 'Xuất thất bại';

  @override
  String get exportedXbmFiles => 'Đã xuất (các) tệp XBM sang MagicEpaper/XBM/';

  @override
  String get exported => 'Đã xuất';

  @override
  String get xbmFilesToMagicEpaper => '(Các) tệp XBM sang MagicEpaper/XBM/';

  @override
  String get floydSteinberg => 'Cổ điển';

  @override
  String get stucki => 'Sắc nét';

  @override
  String get atkinson => 'Cổ điển';

  @override
  String get falseFloydSteinberg => 'Đơn giản';

  @override
  String get halftone => 'Báo';

  @override
  String get threshold => 'Posterize';

  @override
  String get colorHalftone => 'Báo màu';

  @override
  String get searchingForDevice => 'Đang tìm kiếm thiết bị';

  @override
  String get displayRefreshing => 'Đang làm mới màn hình';

  @override
  String get transferComplete => 'Truyền hoàn tất!';

  @override
  String get writingToEpaper => 'Đang ghi vào ePaper';

  @override
  String get pleaseBringPhoneClose =>
      'Vui lòng đưa điện thoại của bạn đến gần thiết bị Magic ePaper';

  @override
  String get keepPhoneClose => 'Giữ điện thoại của bạn ở gần!';

  @override
  String get displayRefreshingMessage =>
      'Màn hình đang làm mới. Vui lòng giữ điện thoại của bạn gần thiết bị cho đến khi hình ảnh xuất hiện hoàn toàn.';

  @override
  String get transferFailed => 'Truyền thất bại';

  @override
  String get deviceConnectionTimeout =>
      'Hết thời gian kết nối thiết bị. Vui lòng thử đưa điện thoại của bạn đến gần thiết bị hơn và thử lại.';

  @override
  String get connectionLostDuringTransfer =>
      'Mất kết nối trong quá trình truyền. Vui lòng giữ điện thoại của bạn gần thiết bị và thử lại.';

  @override
  String get done => 'Xong';

  @override
  String get close => 'Đóng';

  @override
  String get processingImage => 'Đang xử lý hình ảnh...';

  @override
  String get readyToFlash => 'Sẵn sàng Flash';

  @override
  String get imageProcessedSuccessfully => 'Xử lý hình ảnh thành công.';

  @override
  String get tapBelowAndHold =>
      'Nhấn vào bên dưới và giữ điện thoại của bạn gần màn hình.';

  @override
  String get startFlashing => 'Bắt đầu Flash';

  @override
  String get flashing => 'Đang Flash...';

  @override
  String get keepPhoneStill => 'Giữ yên điện thoại của bạn.';

  @override
  String get success => 'Thành công!';

  @override
  String get transferCompleteMessage => 'Truyền hoàn tất!';

  @override
  String get unknownErrorOccurred => 'Đã xảy ra lỗi không xác định.';

  @override
  String get resultsCleared => 'Đã xóa kết quả';

  @override
  String get clearResults => 'Xóa kết quả';

  @override
  String get vCardContact => 'Danh bạ vCard';

  @override
  String get writingVCard => 'Đang ghi vCard...';

  @override
  String get writeVCard => 'Ghi vCard';

  @override
  String get firstName => 'Tên';

  @override
  String get lastName => 'Họ';

  @override
  String get organization => 'Tổ chức';

  @override
  String get title => 'Chức danh';

  @override
  String get mobileNumber => 'Số điện thoại di động';

  @override
  String get emailAddress => 'Địa chỉ Email';

  @override
  String get streetAddress => 'Địa chỉ đường';

  @override
  String get city => 'Thành phố';

  @override
  String get zipCode => 'Mã bưu chính';

  @override
  String get country => 'Quốc gia';

  @override
  String get website => 'Trang web';

  @override
  String get noSavedImagesYet => 'Chưa có hình ảnh nào được lưu';

  @override
  String get saveImagesFromEditor =>
      'Lưu hình ảnh từ trình chỉnh sửa hoặc nhập ảnh mới';

  @override
  String get enterWifiSSID => 'Nhập SSID WiFi';

  @override
  String get enterWifiPassword => 'Nhập mật khẩu WiFi';

  @override
  String get writeMultiple => 'Ghi nhiều mục';

  @override
  String get searchImages => 'Tìm kiếm hình ảnh...';

  @override
  String get filter => 'Bộ lọc:';

  @override
  String get all => 'Tất cả';

  @override
  String get imported => 'Đã nhập';

  @override
  String get editor => 'Trình chỉnh sửa';

  @override
  String get imageLibrary => 'Thư viện hình ảnh';

  @override
  String get selectImagesToDelete => 'Chọn hình ảnh để xóa';

  @override
  String get delete => 'Xóa';

  @override
  String get deleteMode => 'Chế độ xóa';

  @override
  String get deleteImage => 'Xóa hình ảnh';

  @override
  String get thisActionCannotBeUndone => 'Hành động này không thể hoàn tác';

  @override
  String get filterLabel => 'Bộ lọc:';

  @override
  String get areYouSureDeleteImage =>
      'Bạn có chắc chắn muốn xóa hình ảnh này không? Hành động này không thể hoàn tác.';

  @override
  String get deleteMultipleImages => 'Xóa nhiều hình ảnh';

  @override
  String get imagesSelected => 'hình ảnh đã chọn';

  @override
  String get imagesSelectedForDeletion => 'hình ảnh đã chọn để xóa';

  @override
  String areYouSureDeleteMultipleImages(Object count) {
    return 'Bạn có chắc chắn muốn xóa $count hình ảnh này không? Hành động này không thể hoàn tác.';
  }

  @override
  String get areYouSureDeleteSingleImage =>
      'Bạn có chắc chắn muốn xóa hình ảnh này không? Hành động này không thể hoàn tác.';

  @override
  String get deleteAll => 'Xóa tất cả';

  @override
  String get renameImage => 'Đổi tên hình ảnh';

  @override
  String get enterNewNameForImage => 'Nhập tên mới cho hình ảnh của bạn';

  @override
  String get imageName => 'Tên hình ảnh';

  @override
  String get enterImageName => 'Nhập tên hình ảnh...';

  @override
  String get rename => 'Đổi tên';

  @override
  String get imageProperties => 'Thuộc tính hình ảnh';

  @override
  String get created => 'Đã tạo';

  @override
  String get source => 'Nguồn:';

  @override
  String get epdModel => 'Mô hình EPD:';

  @override
  String get transferToEpaper => 'Truyền sang ePaper';

  @override
  String get saveImage => 'Lưu hình ảnh';

  @override
  String get saveFilteredImageToLibrary =>
      'Lưu hình ảnh đã lọc của bạn vào thư viện';

  @override
  String get filterApplied => 'Bộ lọc đã áp dụng:';

  @override
  String get save => 'Lưu';

  @override
  String get noImagesMatchSearch =>
      'Không có hình ảnh nào khớp với tìm kiếm của bạn';

  @override
  String get vCardDataCannotBeEmpty => 'Dữ liệu VCard không được để trống';

  @override
  String get renamingImage => 'Đang đổi tên hình ảnh...';

  @override
  String get imageRenamedTo => 'Hình ảnh đã được đổi tên thành \"';

  @override
  String get failedToRenameImage => 'Không thể đổi tên hình ảnh: ';

  @override
  String get deletingImage => 'Đang xóa hình ảnh...';

  @override
  String get imageDeleted => 'Đã xóa hình ảnh \"';

  @override
  String get deleted => '\"';

  @override
  String get failedToDeleteImage => 'Không thể xóa hình ảnh: ';

  @override
  String get deletingImages => 'Đang xóa ';

  @override
  String get images => ' hình ảnh...';

  @override
  String get failedToDeleteImages => 'Không thể xóa hình ảnh: ';

  @override
  String get imagesDeletedSuccessfully => ' hình ảnh đã được xóa thành công';

  @override
  String get imageDeletedSuccessfully => 'Xóa hình ảnh thành công';

  @override
  String get failedToLoadImageData => 'Không thể tải dữ liệu hình ảnh cho \"';

  @override
  String get failedToDecodeImage => 'Không thể giải mã hình ảnh \"';

  @override
  String get failedToTransfer => 'Không thể truyền \"';

  @override
  String get savingImage => 'Đang lưu hình ảnh...';

  @override
  String get imageSavedToLibrary => 'Đã lưu hình ảnh vào thư viện!';

  @override
  String get failedToSaveImage => 'Không thể lưu hình ảnh: ';

  @override
  String get errorCreatingVCardRecord => 'Lỗi khi tạo bản ghi vCard: ';

  @override
  String get nfcIsDisabledPleaseEnableIt => 'NFC bị tắt. Vui lòng bật nó lên.';

  @override
  String get thisDeviceDoesNotSupportNfc => 'Thiết bị này không hỗ trợ NFC.';

  @override
  String get bringPhoneNearMagicEpaperHardware =>
      'Đưa điện thoại của bạn lại gần Phần cứng Magic ePaper';

  @override
  String get tagDetectedInitializing => 'Đã phát hiện thẻ! Đang khởi tạo...';

  @override
  String get enablingEnergyHarvesting => 'Đang bật thu thập năng lượng...';

  @override
  String get processingImageData => 'Đang xử lý dữ liệu hình ảnh...';

  @override
  String get refreshingDisplay => 'Đang làm mới màn hình...';

  @override
  String get notMagicEpaperHardware => 'Không phải Phần cứng Magic ePaper';

  @override
  String get errorCheckingMessage => 'Lỗi khi kiểm tra tin nhắn: ';

  @override
  String get timeoutWaitingForI2cMessage => 'Hết thời gian chờ tin nhắn I2C';

  @override
  String get writingChunk => 'Đang ghi đoạn (chunk) ';

  @override
  String get transferredSuccessfully => 'Truyền thành công.';

  @override
  String get waitingForNfcTag => 'Đang đợi thẻ NFC...';

  @override
  String get gotTag => 'Đã nhận được thẻ!';

  @override
  String get frame => 'Khung hình ';

  @override
  String get couldNotOpenLink => 'Không thể mở liên kết.';

  @override
  String get errorOccurredWhileOpeningLink =>
      'Đã xảy ra lỗi trong khi mở liên kết.';

  @override
  String get errorCreatingAppRecord => 'Lỗi khi tạo bản ghi ứng dụng: ';

  @override
  String get appCannotBeEmpty => 'Ứng dụng không được để trống';

  @override
  String get invalidPackageName => 'Tên gói không hợp lệ';

  @override
  String get writeAppLauncherData => 'Ghi dữ liệu trình khởi chạy ứng dụng';

  @override
  String get writeAppLauncher => 'Ghi trình khởi chạy ứng dụng';

  @override
  String get searchApps => 'Tìm kiếm ứng dụng...';

  @override
  String get customPackageName => 'Tên gói tùy chỉnh';

  @override
  String get enterPackageName => 'Nhập tên gói...';

  @override
  String get noAppsFound => 'Không tìm thấy ứng dụng nào';

  @override
  String get selectApplication => 'Chọn ứng dụng';

  @override
  String get errorLoadingApps => 'Lỗi khi tải ứng dụng: ';

  @override
  String get add => 'Thêm';

  @override
  String get readNfcTags => 'Đọc thẻ NFC';

  @override
  String get writeNfcTags => 'Ghi thẻ NFC';

  @override
  String get nfcIsReadyToUse =>
      'NFC đã sẵn sàng để sử dụng. Bạn có thể đọc và ghi thẻ NFC.';

  @override
  String get deviceDoesNotSupportNfc =>
      'Thiết bị này không hỗ trợ chức năng NFC.';

  @override
  String get pleaseEnableNfcInSettings =>
      'Vui lòng bật NFC trong cài đặt thiết bị của bạn để tiếp tục.';

  @override
  String get nfcIsNowEnabledAndReady =>
      'NFC hiện đã được bật và sẵn sàng sử dụng!';

  @override
  String get nfcHasBeenDisabled =>
      'NFC đã bị tắt. Vui lòng bật để tiếp tục sử dụng các tính năng NFC.';

  @override
  String get nfcIsNotSupportedOnDevice =>
      'NFC không được hỗ trợ trên thiết bị này.';

  @override
  String get arduinoExport => 'Xuất Arduino';

  @override
  String get exportXmbFilesForArduino => 'Xuất tệp XMB cho Arduino';

  @override
  String get cardTemplates => 'Mẫu thẻ';

  @override
  String get chooseTemplateSubtitle => 'Chọn một mẫu để bắt đầu';

  @override
  String get employeeIdCardTitle => 'Thẻ ID nhân viên';

  @override
  String get employeeIdCardDescription =>
      'Tạo thẻ nhận dạng nhân viên chuyên nghiệp';

  @override
  String get shopPriceTagTitle => 'Thẻ giá cửa hàng';

  @override
  String get shopPriceTagDescription =>
      'Thiết kế thẻ giá hấp dẫn cho sản phẩm của bạn';

  @override
  String get entryPassTagTitle => 'Thẻ vé vào cửa';

  @override
  String get entryPassTagDescription =>
      'Tạo vé vào cửa cho các sự kiện và địa điểm';

  @override
  String get eventBadgeTitle => 'Huy hiệu sự kiện';

  @override
  String get eventBadgeDescription =>
      'Tạo huy hiệu sự kiện và thẻ tên được cá nhân hóa';

  @override
  String get comingSoon => 'Sắp ra mắt';

  @override
  String get comingSoonMessage =>
      'Mẫu này hiện đang được phát triển và sẽ sớm ra mắt.';

  @override
  String get ok => 'OK';

  @override
  String get defaultCompanyName => 'Tên công ty';

  @override
  String get nameLabel => 'Tên';

  @override
  String get positionLabel => 'Chức vụ';

  @override
  String get divisionLabel => 'Bộ phận';

  @override
  String get idLabel => 'ID';

  @override
  String get emptyFieldPlaceholder => 'Chưa chỉ định';

  @override
  String get productImage => 'Hình ảnh sản phẩm';

  @override
  String get productName => 'Tên sản phẩm';

  @override
  String get sizeQuantity => 'Kích thước/Số lượng';

  @override
  String get defaultCurrency => '₫';

  @override
  String get defaultPrice => '0';

  @override
  String get price => 'Giá';

  @override
  String get quantitySize => 'Số lượng/Kích thước';

  @override
  String get quantitySizeHint =>
      'Nhập kích thước/số lượng (ví dụ: 750ml, 2kg, Lớn)';

  @override
  String get namePrefix => 'Tên: ';

  @override
  String get positionPrefix => 'Chức vụ: ';

  @override
  String get divisionPrefix => 'Bộ phận: ';

  @override
  String get idPrefix => 'ID: ';

  @override
  String get employeeIdCard => 'Thẻ ID nhân viên';

  @override
  String get fillDetailsToCreateId =>
      'Điền các chi tiết bên dưới để tạo thẻ ID nhân viên của bạn';

  @override
  String get idCardDetails => 'Chi tiết thẻ ID';

  @override
  String get companyName => 'Tên công ty';

  @override
  String get enterCompanyName => 'Nhập tên công ty';

  @override
  String get pleaseEnterCompanyName => 'Vui lòng nhập tên công ty';

  @override
  String get name => 'Tên';

  @override
  String get enterEmployeeName => 'Nhập tên nhân viên';

  @override
  String get pleaseEnterName => 'Vui lòng nhập tên';

  @override
  String get position => 'Chức vụ';

  @override
  String get enterJobPosition => 'Nhập vị trí công việc';

  @override
  String get pleaseEnterPosition => 'Vui lòng nhập chức vụ';

  @override
  String get division => 'Bộ phận';

  @override
  String get enterDepartment => 'Nhập phòng ban';

  @override
  String get pleaseEnterDivision => 'Vui lòng nhập bộ phận';

  @override
  String get idNumber => 'Số ID';

  @override
  String get enterUniqueId => 'Nhập ID duy nhất';

  @override
  String get pleaseEnterIdNumber => 'Vui lòng nhập số ID';

  @override
  String get qrCodeData => 'Dữ liệu mã QR';

  @override
  String get enterQrCodeData => 'Nhập dữ liệu mã QR';

  @override
  String get pleaseEnterQrCodeData => 'Vui lòng nhập dữ liệu mã QR';

  @override
  String get generatingIdCard => 'Đang tạo thẻ ID...';

  @override
  String get generateIdCard => 'Tạo thẻ ID';

  @override
  String get profilePhoto => 'Ảnh đại diện';

  @override
  String get selected => 'Đã chọn';

  @override
  String get photoSelected => 'Ảnh đã chọn';

  @override
  String get selectProfilePhoto => 'Chọn ảnh đại diện';

  @override
  String get tapToChangePhoto => 'Nhấn để thay đổi ảnh';

  @override
  String get tapToSelectFromGallery => 'Nhấn để chọn từ thư viện';

  @override
  String get priceTagGenerator => 'Trình tạo thẻ giá';

  @override
  String get priceTagDescription =>
      'Tạo thẻ giá chuyên nghiệp cho sản phẩm của bạn';

  @override
  String get productDetails => 'Chi tiết sản phẩm';

  @override
  String get productNameHint => 'Nhập tên sản phẩm (ví dụ: iPhone 15 Pro)';

  @override
  String get pleaseEnterProductName => 'Vui lòng nhập tên sản phẩm';

  @override
  String get currency => 'Tiền tệ';

  @override
  String get currencyHint => '₫';

  @override
  String get required => 'Bắt buộc';

  @override
  String get priceHint => '999000';

  @override
  String get pleaseEnterPrice => 'Vui lòng nhập giá';

  @override
  String get pleaseEnterQuantitySize =>
      'Vui lòng nhập số lượng hoặc kích thước';

  @override
  String get pleaseEnterBarcodeData => 'Vui lòng nhập dữ liệu mã vạch';

  @override
  String get generatingPriceTag => 'Đang tạo thẻ giá...';

  @override
  String get generatePriceTag => 'Tạo thẻ giá';

  @override
  String get productImageIn => 'Hình ảnh sản phẩm';

  @override
  String get productImageSelected => 'Hình ảnh sản phẩm đã được chọn';

  @override
  String get selectProductImage => 'Chọn hình ảnh sản phẩm';

  @override
  String get tapToChangeImage => 'Nhấn để thay đổi hình ảnh';

  @override
  String get chooseImageFromGallery => 'Chọn hình ảnh từ thư viện';

  @override
  String get processingImages => 'Đang xử lý hình ảnh...';

  @override
  String get refreshModeInfo => 'Thông tin chế độ làm mới';

  @override
  String get fullRefreshInfo => 'Làm mới toàn bộ';

  @override
  String get fullRefreshDescription =>
      'Làm mới hoàn toàn toàn bộ màn hình bằng cách xóa tất cả các pixel và vẽ lại hình ảnh. Điều này mang lại chất lượng hình ảnh và độ tương phản tốt nhất nhưng mất nhiều thời gian hơn để hoàn thành.';

  @override
  String get partialRefreshInfo => 'Làm mới một phần (Dạng sóng)';

  @override
  String get partialRefreshDescription =>
      'Chỉ cập nhật các pixel đã thay đổi bằng cách sử dụng các dạng sóng được tối ưu hóa. Tốc độ này nhanh hơn làm mới toàn bộ nhưng có thể dẫn đến bóng mờ hoặc giảm độ tương phản theo thời gian.';

  @override
  String get longPressForInfo => 'Nhấn và giữ để biết thêm thông tin';
}
