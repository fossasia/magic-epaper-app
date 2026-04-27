// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Magic ePaper';

  @override
  String get aboutUsDescription =>
      'Magic ePaper adalah aplikasi yang dirancang untuk mengontrol dan memperbarui layar ePaper. Tujuannya adalah menyediakan alat untuk menyesuaikan dan mentransfer gambar, teks, dan pola ke layar ePaper menggunakan NFC. Transfer data dari ponsel cerdas ke perangkat keras ePaper dilakukan secara nirkabel melalui NFC. Proyek ini dibangun di atas firmware kustom dan driver layar untuk komunikasi yang lancar dan rendering gambar yang efisien.';

  @override
  String get developedBy => 'Dikembangkan oleh';

  @override
  String get fossasiaContributors => 'Kontributor FOSSASIA';

  @override
  String get contactWithUs => 'Hubungi Kami';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle =>
      'Fork repo dan push perubahan atau kirim masalah baru.';

  @override
  String get license => 'Lisensi';

  @override
  String get licenseSubtitle =>
      'Periksa syarat Apache License 2.0 yang digunakan pada Magic ePaper.';

  @override
  String get createTransfer => 'Buat & Transfer Gambar';

  @override
  String get ndefScreen => 'Ndef';

  @override
  String get selectDisplayType => 'Pilih jenis layar ePaper Anda';

  @override
  String get settings => 'Pengaturan';

  @override
  String get aboutUs => 'Tentang Kami';

  @override
  String get other => 'Lainnya';

  @override
  String get getBadge => 'Dapatkan Lencana';

  @override
  String get feedbackBugReports => 'Umpan Balik/Laporan Bug';

  @override
  String get continueButton => 'Lanjutkan';

  @override
  String get noImageSelectedFeedback => 'Impor gambar terlebih dahulu!';

  @override
  String get adjustButtonLabel => 'Sesuaikan';

  @override
  String get importImageButtonLabel => 'Impor';

  @override
  String get openEditor => 'Buat';

  @override
  String get importStartingImageFeedback => 'Impor gambar untuk memulai';

  @override
  String get transferButtonLabel => 'Transfer';

  @override
  String get filterScreenTitle => 'Pilih Filter';

  @override
  String get scanningForNfcTag => 'Memindai tag NFC...';

  @override
  String get scanningForNfcTagToWrite => 'Memindai tag NFC untuk ditulis...';

  @override
  String get scanningForNfcTagToClear => 'Memindai tag NFC untuk dihapus...';

  @override
  String get scanningTagForVerification => 'Memindai tag untuk verifikasi...';

  @override
  String get errorCreatingTextRecord => 'Kesalahan membuat catatan teks: ';

  @override
  String get errorCreatingUrlRecord => 'Kesalahan membuat catatan URL: ';

  @override
  String get errorCreatingWifiRecord => 'Kesalahan membuat catatan WiFi: ';

  @override
  String get errorCreatingMultipleRecords =>
      'Kesalahan membuat beberapa catatan: ';

  @override
  String get pleaseEnterAtLeastOneRecord =>
      'Harap masukkan setidaknya satu catatan';

  @override
  String get tagType => 'Jenis Tag: ';

  @override
  String get tagId => 'ID Tag: ';

  @override
  String get ndefAvailable => 'NDEF Tersedia: ';

  @override
  String get ndefWritable => 'NDEF Dapat Ditulis: ';

  @override
  String get unknown => 'Tidak diketahui';

  @override
  String get textCannotBeEmpty => 'Teks tidak boleh kosong';

  @override
  String get urlCannotBeEmpty => 'URL tidak boleh kosong';

  @override
  String get wifiSsidCannotBeEmpty => 'SSID WiFi tidak boleh kosong';

  @override
  String get defaultLanguage => 'id';

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
  String get unknownNull => 'Tidak diketahui (null)';

  @override
  String get unknownType => 'Jenis tidak diketahui: ';

  @override
  String get textPrefix => 'Teks: ';

  @override
  String get textSuffix => ' (Bahasa: ';

  @override
  String get uriPrefix => 'URI: ';

  @override
  String get mimePrefix => 'MIME: ';

  @override
  String get absoluteUriPrefix => 'URI Absolut: ';

  @override
  String get rawPrefix => 'Mentah: ';

  @override
  String get emptyPayload => 'Payload kosong';

  @override
  String get binaryDataPrefix => 'Data biner (';

  @override
  String get binaryDataSuffix => ' byte): ';

  @override
  String get errorDecodingRecord => 'Kesalahan mendekode catatan: ';

  @override
  String get noNdefRecordsFound => 'Tidak ada catatan NDEF yang ditemukan';

  @override
  String get recordPrefix => 'Catatan ';

  @override
  String get recordSuffix => ':';

  @override
  String get tnfLabel => 'TNF: ';

  @override
  String get typeLabel => 'Jenis: ';

  @override
  String get payloadSizeLabel => 'Ukuran Payload: ';

  @override
  String get bytesLabel => ' byte';

  @override
  String get contentLabel => 'Konten: ';

  @override
  String get rawPayloadLabel => 'Payload Mentah: ';

  @override
  String get nullPayload => 'null';

  @override
  String get closingParenthesis => ')';

  @override
  String get closingParenthesisNewline => ')\n';

  @override
  String get scanYourNfcTag => 'Pindai tag NFC Anda';

  @override
  String get scanYourNfcTagToWrite => 'Pindai tag NFC Anda untuk menulis';

  @override
  String get scanYourNfcTagToClear => 'Pindai tag NFC Anda untuk menghapus';

  @override
  String get scanTagToVerifyContent => 'Pindai tag untuk memverifikasi konten';

  @override
  String get tagIsNotNdefCompatible => 'Tag tidak kompatibel dengan NDEF';

  @override
  String get tagDoesNotSupportNdef => 'Tag tidak mendukung NDEF';

  @override
  String get tagIsNotWritable => 'Tag tidak dapat ditulis';

  @override
  String get tagDoesNotSupportNdefCannotClear =>
      'Tag tidak mendukung NDEF, tidak dapat dihapus';

  @override
  String get tagIsNotWritableCannotClear =>
      'Tag tidak dapat ditulis, tidak dapat dihapus';

  @override
  String get readOperationCompleted => 'Operasi baca selesai';

  @override
  String get writeOperationCompleted => 'Operasi tulis selesai';

  @override
  String get clearOperationCompleted => 'Operasi hapus selesai';

  @override
  String get ndefRecordsFound => 'Catatan NDEF ditemukan: ';

  @override
  String get theTagIsEmpty => 'Tag kosong';

  @override
  String get record => 'Catatan ';

  @override
  String get type => 'Jenis: ';

  @override
  String get tnf => 'TNF: ';

  @override
  String get content => 'Konten: ';

  @override
  String get noRecordsToWrite => 'Tidak ada catatan untuk ditulis';

  @override
  String get ndefRecordsWrittenSuccessfully => 'Catatan NDEF berhasil ditulis';

  @override
  String get recordsWritten => 'Catatan ditulis: ';

  @override
  String get writtenRecord => 'Catatan yang ditulis ';

  @override
  String get tagClearedSuccessfully => 'Tag berhasil dihapus';

  @override
  String get method => 'Metode: ';

  @override
  String get tagIsNowReadyForNewData => 'Tag sekarang siap untuk data baru';

  @override
  String get emptyTextRecord => 'Catatan teks kosong';

  @override
  String get emptyNdefRecord => 'Catatan NDEF kosong';

  @override
  String get minimalSpaceCharacter => 'Karakter spasi minimal';

  @override
  String get emptyRecordList => 'Daftar catatan kosong';

  @override
  String get allClearingMethodsFailed => 'Semua metode penghapusan gagal: ';

  @override
  String get verificationResults => 'Hasil Verifikasi:';

  @override
  String get recordsFound => 'Catatan ditemukan: ';

  @override
  String get noNdefRecordsFoundOnTag =>
      'Tidak ada catatan NDEF yang ditemukan pada tag';

  @override
  String get theTagIsEmptyCleared => 'Tag kosong/dihapus';

  @override
  String get errorReadingTag => 'Kesalahan membaca tag: ';

  @override
  String get errorWritingToTag => 'Kesalahan menulis ke tag: ';

  @override
  String get errorClearingTag => 'Kesalahan menghapus tag: ';

  @override
  String get verificationError => 'Kesalahan verifikasi: ';

  @override
  String get holdTagCloseAndTryAgain => '. Pegang tag mendekat dan coba lagi';

  @override
  String get tryHoldingTagCloser => '. Coba pegang tag lebih dekat';

  @override
  String get tryMovingTagCloser => '. Coba gerakkan tag lebih dekat';

  @override
  String get method1EmptyTextRecordFailed =>
      'Metode 1 (catatan teks kosong) gagal: ';

  @override
  String get method2EmptyNdefRecordFailed =>
      'Metode 2 (catatan NDEF kosong) gagal: ';

  @override
  String get method3MinimalRecordFailed => 'Metode 3 (catatan minimal) gagal: ';

  @override
  String get method4EmptyListFailed => 'Metode 4 (daftar kosong) gagal: ';

  @override
  String get errorFinishingNfcSession => 'Kesalahan mengakhiri sesi NFC: ';

  @override
  String get secondaryCleanupAlsoFailed => 'Pembersihan sekunder juga gagal: ';

  @override
  String get multipleTagsFoundPleaseSelectOne =>
      'Ditemukan beberapa tag, harap pilih satu';

  @override
  String get scanYourNfcTagDefault => 'Pindai tag NFC Anda';

  @override
  String get readNdefTags => 'Baca Tag NDEF';

  @override
  String get reading => 'Membaca...';

  @override
  String get readNfcTag => 'Baca Tag NFC';

  @override
  String get verify => 'Verifikasi';

  @override
  String get clearing => 'Menghapus...';

  @override
  String get clearNfcTag => 'Hapus Tag NFC';

  @override
  String get monospaceFontFamily => 'monospace';

  @override
  String get nfcStatus => 'Status NFC';

  @override
  String get refreshNfcStatus => 'Segarkan Status NFC';

  @override
  String get writeNdefRecords => 'Tulis Catatan NDEF';

  @override
  String get textRecord => 'Catatan Teks';

  @override
  String get enterTextToWriteToNfcTag =>
      'Masukkan teks untuk ditulis ke tag NFC';

  @override
  String get writing => 'Menulis...';

  @override
  String get writeText => 'Tulis Teks';

  @override
  String get urlRecord => 'Catatan URL';

  @override
  String get enterUrl => 'Masukkan URL';

  @override
  String get writeUrl => 'Tulis URL';

  @override
  String get wifiRecord => 'Catatan WiFi';

  @override
  String get wifiNetworkNameSsid => 'Nama Jaringan WiFi (SSID)';

  @override
  String get wifiPassword => 'Kata Sandi WiFi';

  @override
  String get writeWifi => 'Tulis WiFi';

  @override
  String get writeAllRecords => 'Tulis Semua Catatan';

  @override
  String get writeAllNonEmptyFieldsDescription =>
      'Tulis semua bidang yang tidak kosong ke tag NFC sekaligus';

  @override
  String get writeMultipleRecords => 'Tulis Beberapa Catatan';

  @override
  String get readOperationFailed => 'Operasi baca gagal';

  @override
  String get tagReadSuccessfully => 'Tag berhasil dibaca';

  @override
  String get verificationFailed => 'Verifikasi gagal';

  @override
  String get tagVerifiedSuccessfully => 'Tag berhasil diverifikasi';

  @override
  String get clearNfcTagConfirmation =>
      'Apakah Anda yakin ingin menghapus tag NFC ini? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get clearOperationFailed => 'Operasi hapus gagal';

  @override
  String get writeOperationFailed => 'Operasi tulis gagal';

  @override
  String get dataWrittenSuccessfully => 'Data berhasil ditulis';

  @override
  String get nfcNotAvailable => 'NFC Tidak Tersedia';

  @override
  String get enableNfcMessage =>
      'Harap aktifkan NFC di pengaturan perangkat Anda untuk menggunakan fitur ini.';

  @override
  String get cancel => 'Batal';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get error => 'Kesalahan';

  @override
  String get successfully => 'berhasil';

  @override
  String get language => 'Bahasa';

  @override
  String get loading => 'Memuat...';

  @override
  String get exportXbm => 'Ekspor XBM';

  @override
  String get exportingXbm => 'Mengekspor file XBM...';

  @override
  String get fullRefresh => 'Penyegaran Penuh';

  @override
  String get fullRefreshSelected => 'Penyegaran Penuh Dipilih';

  @override
  String get waveformSelected => 'Dipilih';

  @override
  String get barcode => 'Barcode';

  @override
  String get library => 'Pustaka';

  @override
  String get templates => 'Template';

  @override
  String get barcodeGenerator => 'Pembuat Barcode';

  @override
  String get barcodeData => 'Data Barcode';

  @override
  String get barcodeDataHint => 'Masukkan nomor barcode atau SKU';

  @override
  String get characters => 'Karakter';

  @override
  String get scanBarcode => 'Pindai Barcode';

  @override
  String get barcodeFormat => 'Format Barcode';

  @override
  String get enterOrScanBarcodeData => 'Masukkan atau pindai data barcode';

  @override
  String get invalidBarcode => 'Barcode Tidak Valid';

  @override
  String get invalidCharacter => 'Karakter tidak valid';

  @override
  String get supportedCharacters => 'Karakter yang didukung adalah';

  @override
  String get pleaseCheckBarcodeRules => 'Harap periksa aturan barcode.';

  @override
  String get dataTooShort => 'Data terlalu pendek. Panjang minimum untuk';

  @override
  String get dataTooLong => 'Data terlalu panjang. Panjang maksimum untuk';

  @override
  String get isText => 'adalah';

  @override
  String get pointCameraAtBarcode => 'Arahkan kamera ke barcode untuk memindai';

  @override
  String get generateImage => 'Buat Gambar';

  @override
  String get exportFailed => 'Ekspor gagal';

  @override
  String get exportedXbmFiles => 'File XBM diekspor ke MagicEpaper/XBM/';

  @override
  String get exported => 'Diekspor';

  @override
  String get xbmFilesToMagicEpaper => 'File XBM ke MagicEpaper/XBM/';

  @override
  String get floydSteinberg => 'Klasik';

  @override
  String get stucki => 'Tajam';

  @override
  String get atkinson => 'Vintage';

  @override
  String get falseFloydSteinberg => 'Sederhana';

  @override
  String get halftone => 'Koran';

  @override
  String get threshold => 'Posterize';

  @override
  String get colorHalftone => 'Koran Berwarna';

  @override
  String get searchingForDevice => 'Mencari Perangkat';

  @override
  String get displayRefreshing => 'Menyegarkan Layar';

  @override
  String get transferComplete => 'Transfer selesai!';

  @override
  String get writingToEpaper => 'Menulis ke ePaper';

  @override
  String get pleaseBringPhoneClose =>
      'Harap dekatkan ponsel Anda ke perangkat Magic ePaper';

  @override
  String get keepPhoneClose => 'Dekatkan ponsel Anda!';

  @override
  String get displayRefreshingMessage =>
      'Layar sedang menyegarkan. Harap dekatkan ponsel Anda ke perangkat sampai gambar muncul sepenuhnya.';

  @override
  String get transferFailed => 'Transfer Gagal';

  @override
  String get deviceConnectionTimeout =>
      'Waktu koneksi perangkat habis. Harap coba dekatkan ponsel Anda ke perangkat dan coba lagi.';

  @override
  String get connectionLostDuringTransfer =>
      'Koneksi terputus selama transfer. Harap dekatkan ponsel Anda ke perangkat dan coba lagi.';

  @override
  String get done => 'Selesai';

  @override
  String get close => 'Tutup';

  @override
  String get processingImage => 'Memproses Gambar...';

  @override
  String get readyToFlash => 'Siap untuk Flash';

  @override
  String get imageProcessedSuccessfully => 'Gambar berhasil diproses.';

  @override
  String get tapBelowAndHold =>
      'Ketuk di bawah dan tahan ponsel Anda di dekat layar.';

  @override
  String get startFlashing => 'Mulai Flashing';

  @override
  String get flashing => 'Flashing...';

  @override
  String get keepPhoneStill => 'Pegang ponsel Anda dengan stabil.';

  @override
  String get success => 'Sukses!';

  @override
  String get transferCompleteMessage => 'Transfer selesai!';

  @override
  String get unknownErrorOccurred => 'Terjadi kesalahan yang tidak diketahui.';

  @override
  String get resultsCleared => 'Hasil dibersihkan';

  @override
  String get clearResults => 'Bersihkan Hasil';

  @override
  String get vCardContact => 'Kontak vCard';

  @override
  String get writingVCard => 'Menulis vCard...';

  @override
  String get writeVCard => 'Tulis vCard';

  @override
  String get firstName => 'Nama Depan';

  @override
  String get lastName => 'Nama Belakang';

  @override
  String get organization => 'Organisasi';

  @override
  String get title => 'Jabatan';

  @override
  String get mobileNumber => 'Nomor Handphone';

  @override
  String get emailAddress => 'Alamat Email';

  @override
  String get streetAddress => 'Alamat Jalan';

  @override
  String get city => 'Kota';

  @override
  String get zipCode => 'Kode Pos';

  @override
  String get country => 'Negara';

  @override
  String get website => 'Situs Web';

  @override
  String get noSavedImagesYet => 'Belum ada gambar yang disimpan';

  @override
  String get saveImagesFromEditor =>
      'Simpan gambar dari editor atau impor gambar baru';

  @override
  String get enterWifiSSID => 'Masukkan SSID WiFi';

  @override
  String get enterWifiPassword => 'Masukkan kata sandi WiFi';

  @override
  String get writeMultiple => 'Tulis Beberapa';

  @override
  String get searchImages => 'Cari gambar...';

  @override
  String get filter => 'Filter:';

  @override
  String get all => 'Semua';

  @override
  String get imported => 'Diimpor';

  @override
  String get editor => 'Editor';

  @override
  String get imageLibrary => 'Pustaka Gambar';

  @override
  String get selectImagesToDelete => 'Pilih Gambar untuk Dihapus';

  @override
  String get delete => 'Hapus';

  @override
  String get deleteMode => 'Mode Hapus';

  @override
  String get deleteImage => 'Hapus Gambar';

  @override
  String get thisActionCannotBeUndone => 'Tindakan ini tidak dapat dibatalkan';

  @override
  String get filterLabel => 'Filter:';

  @override
  String get areYouSureDeleteImage =>
      'Apakah Anda yakin ingin menghapus gambar ini? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get deleteMultipleImages => 'Hapus Beberapa Gambar';

  @override
  String get imagesSelected => 'gambar dipilih';

  @override
  String get imagesSelectedForDeletion => 'gambar dipilih untuk dihapus';

  @override
  String areYouSureDeleteMultipleImages(Object count) {
    return 'Apakah Anda yakin ingin menghapus $count gambar ini? Tindakan ini tidak dapat dibatalkan.';
  }

  @override
  String get areYouSureDeleteSingleImage =>
      'Apakah Anda yakin ingin menghapus gambar ini? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get deleteAll => 'Hapus Semua';

  @override
  String get renameImage => 'Ubah Nama Gambar';

  @override
  String get enterNewNameForImage => 'Masukkan nama baru untuk gambar Anda';

  @override
  String get imageName => 'Nama Gambar';

  @override
  String get enterImageName => 'Masukkan nama gambar...';

  @override
  String get rename => 'Ubah Nama';

  @override
  String get imageProperties => 'Properti Gambar';

  @override
  String get created => 'Dibuat';

  @override
  String get source => 'Sumber:';

  @override
  String get epdModel => 'Model EPD:';

  @override
  String get transferToEpaper => 'Transfer ke ePaper';

  @override
  String get saveImage => 'Simpan Gambar';

  @override
  String get saveFilteredImageToLibrary =>
      'Simpan gambar yang difilter ke pustaka';

  @override
  String get filterApplied => 'Filter Diterapkan:';

  @override
  String get save => 'Simpan';

  @override
  String get noImagesMatchSearch =>
      'Tidak ada gambar yang cocok dengan pencarian Anda';

  @override
  String get vCardDataCannotBeEmpty => 'Data vCard tidak boleh kosong';

  @override
  String get renamingImage => 'Mengubah nama gambar...';

  @override
  String get imageRenamedTo => 'Gambar diubah namanya menjadi \"';

  @override
  String get failedToRenameImage => 'Gagal mengubah nama gambar: ';

  @override
  String get deletingImage => 'Menghapus gambar...';

  @override
  String get imageDeleted => 'Gambar \"';

  @override
  String get deleted => '\" dihapus';

  @override
  String get failedToDeleteImage => 'Gagal menghapus gambar: ';

  @override
  String get deletingImages => 'Menghapus ';

  @override
  String get images => ' gambar...';

  @override
  String get failedToDeleteImages => 'Gagal menghapus gambar: ';

  @override
  String get imagesDeletedSuccessfully => ' gambar berhasil dihapus';

  @override
  String get imageDeletedSuccessfully => 'Gambar berhasil dihapus';

  @override
  String get failedToLoadImageData => 'Gagal memuat data gambar untuk \"';

  @override
  String get failedToDecodeImage => 'Gagal mendekode gambar \"';

  @override
  String get failedToTransfer => 'Gagal mentransfer \"';

  @override
  String get savingImage => 'Menyimpan gambar...';

  @override
  String get imageSavedToLibrary => 'Gambar disimpan ke pustaka!';

  @override
  String get failedToSaveImage => 'Gagal menyimpan gambar: ';

  @override
  String get errorCreatingVCardRecord => 'Kesalahan membuat catatan vCard: ';

  @override
  String get nfcIsDisabledPleaseEnableIt =>
      'NFC dinonaktifkan. Harap aktifkan.';

  @override
  String get thisDeviceDoesNotSupportNfc =>
      'Perangkat ini tidak mendukung NFC.';

  @override
  String get bringPhoneNearMagicEpaperHardware =>
      'Dekatkan ponsel Anda ke Perangkat Keras Magic ePaper';

  @override
  String get tagDetectedInitializing => 'Tag terdeteksi! Menginisialisasi...';

  @override
  String get enablingEnergyHarvesting => 'Mengaktifkan pemanenan energi...';

  @override
  String get processingImageData => 'Memproses data gambar...';

  @override
  String get refreshingDisplay => 'Menyegarkan layar...';

  @override
  String get notMagicEpaperHardware => 'Bukan Perangkat Keras Magic ePaper';

  @override
  String get errorCheckingMessage => 'Kesalahan memeriksa pesan: ';

  @override
  String get timeoutWaitingForI2cMessage => 'Waktu habis menunggu pesan I2C';

  @override
  String get writingChunk => 'Menulis chunk ';

  @override
  String get transferredSuccessfully => 'Berhasil ditransfer.';

  @override
  String get waitingForNfcTag => 'Menunggu tag NFC...';

  @override
  String get gotTag => 'Mendapat tag!';

  @override
  String get frame => 'Bingkai ';

  @override
  String get couldNotOpenLink => 'Tidak dapat membuka tautan.';

  @override
  String get errorOccurredWhileOpeningLink =>
      'Terjadi kesalahan saat membuka tautan.';

  @override
  String get errorCreatingAppRecord => 'Kesalahan membuat catatan aplikasi: ';

  @override
  String get appCannotBeEmpty => 'Aplikasi tidak boleh kosong';

  @override
  String get invalidPackageName => 'Nama paket tidak valid';

  @override
  String get writeAppLauncherData => 'Tulis Data Peluncur Aplikasi';

  @override
  String get writeAppLauncher => 'Tulis Peluncur Aplikasi';

  @override
  String get searchApps => 'Cari aplikasi...';

  @override
  String get customPackageName => 'Nama Paket Kustom';

  @override
  String get enterPackageName => 'Masukkan nama paket...';

  @override
  String get noAppsFound => 'Tidak ada aplikasi yang ditemukan';

  @override
  String get selectApplication => 'Pilih Aplikasi';

  @override
  String get errorLoadingApps => 'Kesalahan memuat aplikasi: ';

  @override
  String get add => 'Tambah';

  @override
  String get readNfcTags => 'Baca Tag NFC';

  @override
  String get writeNfcTags => 'Tulis Tag NFC';

  @override
  String get nfcIsReadyToUse =>
      'NFC siap digunakan. Anda dapat membaca dan menulis tag NFC.';

  @override
  String get deviceDoesNotSupportNfc =>
      'Perangkat ini tidak mendukung fitur NFC.';

  @override
  String get pleaseEnableNfcInSettings =>
      'Harap aktifkan NFC di pengaturan perangkat Anda untuk melanjutkan.';

  @override
  String get nfcIsNowEnabledAndReady =>
      'NFC sekarang diaktifkan dan siap digunakan!';

  @override
  String get nfcHasBeenDisabled =>
      'NFC telah dinonaktifkan. Harap aktifkan untuk terus menggunakan fitur NFC.';

  @override
  String get nfcIsNotSupportedOnDevice =>
      'NFC tidak didukung pada perangkat ini.';

  @override
  String get arduinoExport => 'Ekspor Arduino';

  @override
  String get exportXmbFilesForArduino => 'Ekspor file XMB untuk Arduino';

  @override
  String get cardTemplates => 'Template Kartu';

  @override
  String get chooseTemplateSubtitle => 'Pilih template untuk memulai';

  @override
  String get employeeIdCardTitle => 'Kartu ID Karyawan';

  @override
  String get employeeIdCardDescription =>
      'Buat kartu identitas karyawan profesional';

  @override
  String get shopPriceTagTitle => 'Label Harga Toko';

  @override
  String get shopPriceTagDescription =>
      'Desain label harga yang menarik untuk produk Anda';

  @override
  String get entryPassTagTitle => 'Label Tiket Masuk';

  @override
  String get entryPassTagDescription =>
      'Hasilkan tiket masuk untuk acara dan tempat';

  @override
  String get eventBadgeTitle => 'Lencana Acara';

  @override
  String get eventBadgeDescription =>
      'Buat lencana acara dan label nama yang dipersonalisasi';

  @override
  String get comingSoon => 'Segera Hadir';

  @override
  String get comingSoonMessage =>
      'Template ini sedang dalam pengembangan dan akan segera tersedia.';

  @override
  String get ok => 'OK';

  @override
  String get defaultCompanyName => 'Nama Perusahaan';

  @override
  String get nameLabel => 'Nama';

  @override
  String get positionLabel => 'Jabatan';

  @override
  String get divisionLabel => 'Divisi';

  @override
  String get idLabel => 'ID';

  @override
  String get emptyFieldPlaceholder => 'Tidak ditentukan';

  @override
  String get productImage => 'Gambar Produk';

  @override
  String get productName => 'Nama Produk';

  @override
  String get sizeQuantity => 'Ukuran/Jumlah';

  @override
  String get defaultCurrency => 'Rp';

  @override
  String get defaultPrice => '0';

  @override
  String get price => 'Harga';

  @override
  String get quantitySize => 'Jumlah/Ukuran';

  @override
  String get quantitySizeHint =>
      'Masukkan ukuran/jumlah (misal, 750ml, 2kg, Besar)';

  @override
  String get namePrefix => 'Nama: ';

  @override
  String get positionPrefix => 'Jabatan: ';

  @override
  String get divisionPrefix => 'Divisi: ';

  @override
  String get idPrefix => 'ID: ';

  @override
  String get employeeIdCard => 'Kartu ID Karyawan';

  @override
  String get fillDetailsToCreateId =>
      'Isi detail di bawah ini untuk membuat kartu ID karyawan Anda';

  @override
  String get idCardDetails => 'Detail Kartu ID';

  @override
  String get companyName => 'Nama Perusahaan';

  @override
  String get enterCompanyName => 'Masukkan nama perusahaan';

  @override
  String get pleaseEnterCompanyName => 'Harap masukkan nama perusahaan';

  @override
  String get name => 'Nama';

  @override
  String get enterEmployeeName => 'Masukkan nama karyawan';

  @override
  String get pleaseEnterName => 'Harap masukkan nama';

  @override
  String get position => 'Jabatan';

  @override
  String get enterJobPosition => 'Masukkan posisi pekerjaan';

  @override
  String get pleaseEnterPosition => 'Harap masukkan jabatan';

  @override
  String get division => 'Divisi';

  @override
  String get enterDepartment => 'Masukkan departemen';

  @override
  String get pleaseEnterDivision => 'Harap masukkan divisi';

  @override
  String get idNumber => 'Nomor ID';

  @override
  String get enterUniqueId => 'Masukkan ID unik';

  @override
  String get pleaseEnterIdNumber => 'Harap masukkan nomor ID';

  @override
  String get qrCodeData => 'Data Kode QR';

  @override
  String get enterQrCodeData => 'Masukkan data kode QR';

  @override
  String get pleaseEnterQrCodeData => 'Harap masukkan data kode QR';

  @override
  String get generatingIdCard => 'Menghasilkan Kartu ID...';

  @override
  String get generateIdCard => 'Hasilkan Kartu ID';

  @override
  String get profilePhoto => 'Foto Profil';

  @override
  String get selected => 'Dipilih';

  @override
  String get photoSelected => 'Foto dipilih';

  @override
  String get selectProfilePhoto => 'Pilih Foto Profil';

  @override
  String get tapToChangePhoto => 'Ketuk untuk mengubah foto';

  @override
  String get tapToSelectFromGallery => 'Ketuk untuk memilih dari galeri';

  @override
  String get priceTagGenerator => 'Pembuat Label Harga';

  @override
  String get priceTagDescription =>
      'Buat label harga profesional untuk produk Anda';

  @override
  String get productDetails => 'Detail Produk';

  @override
  String get productNameHint => 'Masukkan nama produk (misal, iPhone 15 Pro)';

  @override
  String get pleaseEnterProductName => 'Harap masukkan nama produk';

  @override
  String get currency => 'Mata Uang';

  @override
  String get currencyHint => 'Rp';

  @override
  String get required => 'Wajib';

  @override
  String get priceHint => '999.000';

  @override
  String get pleaseEnterPrice => 'Harap masukkan harga';

  @override
  String get pleaseEnterQuantitySize => 'Harap masukkan jumlah atau ukuran';

  @override
  String get pleaseEnterBarcodeData => 'Harap masukkan data barcode';

  @override
  String get generatingPriceTag => 'Menghasilkan Label Harga...';

  @override
  String get generatePriceTag => 'Hasilkan Label Harga';

  @override
  String get productImageIn => 'Gambar Produk';

  @override
  String get productImageSelected => 'Gambar Produk Dipilih';

  @override
  String get selectProductImage => 'Pilih Gambar Produk';

  @override
  String get tapToChangeImage => 'Ketuk untuk mengubah gambar';

  @override
  String get chooseImageFromGallery => 'Pilih gambar dari galeri';

  @override
  String get processingImages => 'Memproses gambar...';

  @override
  String get refreshModeInfo => 'Informasi Mode Penyegaran';

  @override
  String get fullRefreshInfo => 'Penyegaran Penuh';

  @override
  String get fullRefreshDescription =>
      'Menyegarkan seluruh tampilan secara penuh dengan menghapus semua piksel dan menggambar ulang gambar. Ini memberikan kualitas dan kontras gambar terbaik tetapi membutuhkan waktu lebih lama untuk selesai.';

  @override
  String get partialRefreshInfo => 'Penyegaran Sebagian (Waveform)';

  @override
  String get partialRefreshDescription =>
      'Hanya memperbarui piksel yang berubah menggunakan bentuk gelombang (waveform) yang dioptimalkan. Ini lebih cepat daripada penyegaran penuh tetapi dapat mengakibatkan ghosting atau pengurangan kontras seiring waktu.';

  @override
  String get longPressForInfo => 'Tekan lama untuk informasi lebih lanjut';
}
