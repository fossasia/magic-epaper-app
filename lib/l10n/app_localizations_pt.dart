// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Magic ePaper';

  @override
  String get aboutUsDescription =>
      'O Magic ePaper é um aplicativo desenvolvido para controlar e atualizar telas ePaper. O objetivo é fornecer ferramentas para personalizar e transferir imagens, texto e padrões para telas ePaper usando NFC. A transferência de dados do smartphone para o hardware ePaper é feita sem fio via NFC. O projeto é construído sobre firmware e drivers de tela personalizados para comunicação contínua e renderização eficiente de imagens.';

  @override
  String get developedBy => 'Desenvolvido por';

  @override
  String get fossasiaContributors => 'Contribuidores FOSSASIA';

  @override
  String get contactWithUs => 'Fale Conosco';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle =>
      'Faça um fork do repositório e envie alterações ou relate novos problemas.';

  @override
  String get license => 'Licença';

  @override
  String get licenseSubtitle =>
      'Verifique os termos da Licença Apache 2.0 usados no Magic ePaper.';

  @override
  String get createTransfer => 'Criar e Transferir Imagens';

  @override
  String get ndefScreen => 'Ndef';

  @override
  String get selectDisplayType => 'Selecione o tipo de tela ePaper';

  @override
  String get settings => 'Configurações';

  @override
  String get aboutUs => 'Sobre Nós';

  @override
  String get other => 'Outros';

  @override
  String get getBadge => 'Obter Emblema';

  @override
  String get feedbackBugReports => 'Feedback/Relatórios de Erros';

  @override
  String get continueButton => 'Continuar';

  @override
  String get noImageSelectedFeedback => 'Importe uma imagem primeiro!';

  @override
  String get adjustButtonLabel => 'Ajustar';

  @override
  String get importImageButtonLabel => 'Importar';

  @override
  String get openEditor => 'Criar';

  @override
  String get importStartingImageFeedback => 'Importe uma imagem para começar';

  @override
  String get transferButtonLabel => 'Transferir';

  @override
  String get filterScreenTitle => 'Selecione um Filtro';

  @override
  String get scanningForNfcTag => 'Buscando tag NFC...';

  @override
  String get scanningForNfcTagToWrite => 'Buscando tag NFC para gravar...';

  @override
  String get scanningForNfcTagToClear => 'Buscando tag NFC para limpar...';

  @override
  String get scanningTagForVerification => 'Lendo tag para verificação...';

  @override
  String get errorCreatingTextRecord => 'Erro ao criar registro de texto: ';

  @override
  String get errorCreatingUrlRecord => 'Erro ao criar registro de URL: ';

  @override
  String get errorCreatingWifiRecord => 'Erro ao criar registro Wi-Fi: ';

  @override
  String get errorCreatingMultipleRecords =>
      'Erro ao criar múltiplos registros: ';

  @override
  String get pleaseEnterAtLeastOneRecord =>
      'Por favor, insira pelo menos um registro';

  @override
  String get tagType => 'Tipo de Tag: ';

  @override
  String get tagId => 'ID da Tag: ';

  @override
  String get ndefAvailable => 'NDEF Disponível: ';

  @override
  String get ndefWritable => 'NDEF Gravável: ';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get textCannotBeEmpty => 'O texto não pode estar vazio';

  @override
  String get urlCannotBeEmpty => 'A URL não pode estar vazia';

  @override
  String get wifiSsidCannotBeEmpty => 'O SSID do Wi-Fi não pode estar vazio';

  @override
  String get defaultLanguage => 'pt';

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
  String get unknownNull => 'Desconhecido (nulo)';

  @override
  String get unknownType => 'Tipo desconhecido: ';

  @override
  String get textPrefix => 'Texto: ';

  @override
  String get textSuffix => ' (Idioma: ';

  @override
  String get uriPrefix => 'URI: ';

  @override
  String get mimePrefix => 'MIME: ';

  @override
  String get absoluteUriPrefix => 'URI Absoluto: ';

  @override
  String get rawPrefix => 'Bruto: ';

  @override
  String get emptyPayload => 'Carga útil vazia';

  @override
  String get binaryDataPrefix => 'Dados binários (';

  @override
  String get binaryDataSuffix => ' bytes): ';

  @override
  String get errorDecodingRecord => 'Erro ao decodificar registro: ';

  @override
  String get noNdefRecordsFound => 'Nenhum registro NDEF encontrado';

  @override
  String get recordPrefix => 'Registro ';

  @override
  String get recordSuffix => ':';

  @override
  String get tnfLabel => 'TNF: ';

  @override
  String get typeLabel => 'Tipo: ';

  @override
  String get payloadSizeLabel => 'Tamanho da Carga: ';

  @override
  String get bytesLabel => ' bytes';

  @override
  String get contentLabel => 'Conteúdo: ';

  @override
  String get rawPayloadLabel => 'Carga Bruta: ';

  @override
  String get nullPayload => 'nulo';

  @override
  String get closingParenthesis => ')';

  @override
  String get closingParenthesisNewline => ')\n';

  @override
  String get scanYourNfcTag => 'Aproxime sua tag NFC';

  @override
  String get scanYourNfcTagToWrite => 'Aproxime sua tag NFC para gravar';

  @override
  String get scanYourNfcTagToClear => 'Aproxime sua tag NFC para limpar';

  @override
  String get scanTagToVerifyContent =>
      'Aproxime a tag para verificar o conteúdo';

  @override
  String get tagIsNotNdefCompatible => 'A tag não é compatível com NDEF';

  @override
  String get tagDoesNotSupportNdef => 'A tag não suporta NDEF';

  @override
  String get tagIsNotWritable => 'A tag não é gravável';

  @override
  String get tagDoesNotSupportNdefCannotClear =>
      'A tag não suporta NDEF, não é possível limpar';

  @override
  String get tagIsNotWritableCannotClear =>
      'A tag não é gravável, não é possível limpar';

  @override
  String get readOperationCompleted => 'Operação de leitura concluída';

  @override
  String get writeOperationCompleted => 'Operação de gravação concluída';

  @override
  String get clearOperationCompleted => 'Operação de limpeza concluída';

  @override
  String get ndefRecordsFound => 'Registros NDEF encontrados: ';

  @override
  String get theTagIsEmpty => 'A tag está vazia';

  @override
  String get record => 'Registro ';

  @override
  String get type => 'Tipo: ';

  @override
  String get tnf => 'TNF: ';

  @override
  String get content => 'Conteúdo: ';

  @override
  String get noRecordsToWrite => 'Não há registros para gravar';

  @override
  String get ndefRecordsWrittenSuccessfully =>
      'Registros NDEF gravados com sucesso';

  @override
  String get recordsWritten => 'Registros gravados: ';

  @override
  String get writtenRecord => 'Registro gravado ';

  @override
  String get tagClearedSuccessfully => 'Tag limpa com sucesso';

  @override
  String get method => 'Método: ';

  @override
  String get tagIsNowReadyForNewData =>
      'A tag agora está pronta para novos dados';

  @override
  String get emptyTextRecord => 'Registro de texto vazio';

  @override
  String get emptyNdefRecord => 'Registro NDEF vazio';

  @override
  String get minimalSpaceCharacter => 'Caractere de espaço mínimo';

  @override
  String get emptyRecordList => 'Lista de registros vazia';

  @override
  String get allClearingMethodsFailed =>
      'Todos os métodos de limpeza falharam: ';

  @override
  String get verificationResults => 'Resultados da Verificação:';

  @override
  String get recordsFound => 'Registros encontrados: ';

  @override
  String get noNdefRecordsFoundOnTag =>
      'Nenhum registro NDEF encontrado na tag';

  @override
  String get theTagIsEmptyCleared => 'A tag está vazia/limpa';

  @override
  String get errorReadingTag => 'Erro ao ler a tag: ';

  @override
  String get errorWritingToTag => 'Erro ao gravar na tag: ';

  @override
  String get errorClearingTag => 'Erro ao limpar a tag: ';

  @override
  String get verificationError => 'Erro de verificação: ';

  @override
  String get holdTagCloseAndTryAgain =>
      '. Mantenha a tag próxima e tente novamente';

  @override
  String get tryHoldingTagCloser => '. Tente manter a tag mais próxima';

  @override
  String get tryMovingTagCloser => '. Tente aproximar a tag';

  @override
  String get method1EmptyTextRecordFailed =>
      'Método 1 (registro de texto vazio) falhou: ';

  @override
  String get method2EmptyNdefRecordFailed =>
      'Método 2 (registro NDEF vazio) falhou: ';

  @override
  String get method3MinimalRecordFailed =>
      'Método 3 (registro mínimo) falhou: ';

  @override
  String get method4EmptyListFailed => 'Método 4 (lista vazia) falhou: ';

  @override
  String get errorFinishingNfcSession => 'Erro ao finalizar a sessão NFC: ';

  @override
  String get secondaryCleanupAlsoFailed =>
      'A limpeza secundária também falhou: ';

  @override
  String get multipleTagsFoundPleaseSelectOne =>
      'Múltiplas tags encontradas, por favor selecione uma';

  @override
  String get scanYourNfcTagDefault => 'Aproxime sua tag NFC';

  @override
  String get readNdefTags => 'Ler Tags NDEF';

  @override
  String get reading => 'Lendo...';

  @override
  String get readNfcTag => 'Ler Tag NFC';

  @override
  String get verify => 'Verificar';

  @override
  String get clearing => 'Limpando...';

  @override
  String get clearNfcTag => 'Limpar Tag NFC';

  @override
  String get monospaceFontFamily => 'monospace';

  @override
  String get nfcStatus => 'Status do NFC';

  @override
  String get refreshNfcStatus => 'Atualizar Status do NFC';

  @override
  String get writeNdefRecords => 'Gravar Registros NDEF';

  @override
  String get textRecord => 'Registro de Texto';

  @override
  String get enterTextToWriteToNfcTag =>
      'Insira o texto para gravar na tag NFC';

  @override
  String get writing => 'Gravando...';

  @override
  String get writeText => 'Gravar Texto';

  @override
  String get urlRecord => 'Registro de URL';

  @override
  String get enterUrl => 'Insira a URL';

  @override
  String get writeUrl => 'Gravar URL';

  @override
  String get wifiRecord => 'Registro Wi-Fi';

  @override
  String get wifiNetworkNameSsid => 'Nome da Rede Wi-Fi (SSID)';

  @override
  String get wifiPassword => 'Senha do Wi-Fi';

  @override
  String get writeWifi => 'Gravar Wi-Fi';

  @override
  String get writeAllRecords => 'Gravar Todos os Registros';

  @override
  String get writeAllNonEmptyFieldsDescription =>
      'Gravar todos os campos não vazios na tag NFC de uma vez';

  @override
  String get writeMultipleRecords => 'Gravar Múltiplos Registros';

  @override
  String get readOperationFailed => 'Falha na operação de leitura';

  @override
  String get tagReadSuccessfully => 'Tag lida com sucesso';

  @override
  String get verificationFailed => 'Falha na verificação';

  @override
  String get tagVerifiedSuccessfully => 'Tag verificada com sucesso';

  @override
  String get clearNfcTagConfirmation =>
      'Tem certeza de que deseja limpar esta tag NFC? Esta ação não pode ser desfeita.';

  @override
  String get clearOperationFailed => 'Falha na operação de limpeza';

  @override
  String get writeOperationFailed => 'Falha na operação de gravação';

  @override
  String get dataWrittenSuccessfully => 'Dados gravados com sucesso';

  @override
  String get nfcNotAvailable => 'NFC Indisponível';

  @override
  String get enableNfcMessage =>
      'Por favor, ative o NFC nas configurações do seu dispositivo para usar este recurso.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get error => 'Erro';

  @override
  String get successfully => 'com sucesso';

  @override
  String get language => 'Idioma';

  @override
  String get loading => 'Carregando...';

  @override
  String get exportXbm => 'Exportar XBM';

  @override
  String get exportingXbm => 'Exportando arquivos XBM...';

  @override
  String get fullRefresh => 'Atualização Completa';

  @override
  String get fullRefreshSelected => 'Atualização Completa Selecionada';

  @override
  String get waveformSelected => 'Selecionado';

  @override
  String get barcode => 'Código de Barras';

  @override
  String get library => 'Biblioteca';

  @override
  String get templates => 'Modelos';

  @override
  String get barcodeGenerator => 'Gerador de Código de Barras';

  @override
  String get barcodeData => 'Dados do Código de Barras';

  @override
  String get barcodeDataHint => 'Insira o número do código de barras ou SKU';

  @override
  String get characters => 'Caracteres';

  @override
  String get scanBarcode => 'Escanear Código de Barras';

  @override
  String get barcodeFormat => 'Formato do Código de Barras';

  @override
  String get enterOrScanBarcodeData =>
      'Insira ou escaneie os dados do código de barras';

  @override
  String get invalidBarcode => 'Código de Barras Inválido';

  @override
  String get invalidCharacter => 'Caractere inválido';

  @override
  String get supportedCharacters => 'Os caracteres suportados são';

  @override
  String get pleaseCheckBarcodeRules =>
      'Por favor, verifique as regras do código de barras.';

  @override
  String get dataTooShort =>
      'Os dados são muito curtos. Comprimento mínimo para';

  @override
  String get dataTooLong =>
      'Os dados são muito longos. Comprimento máximo para';

  @override
  String get isText => 'é';

  @override
  String get pointCameraAtBarcode =>
      'Aponte a câmera para o código de barras para escanear';

  @override
  String get generateImage => 'Gerar Imagem';

  @override
  String get exportFailed => 'Falha na exportação';

  @override
  String get exportedXbmFiles =>
      'Arquivo(s) XBM exportado(s) para MagicEpaper/XBM/';

  @override
  String get exported => 'Exportado';

  @override
  String get xbmFilesToMagicEpaper => 'Arquivo(s) XBM para MagicEpaper/XBM/';

  @override
  String get floydSteinberg => 'Clássico';

  @override
  String get stucki => 'Nítido';

  @override
  String get atkinson => 'Vintage';

  @override
  String get falseFloydSteinberg => 'Simples';

  @override
  String get halftone => 'Jornal';

  @override
  String get threshold => 'Posterizar';

  @override
  String get colorHalftone => 'Jornal Colorido';

  @override
  String get searchingForDevice => 'Procurando Dispositivo';

  @override
  String get displayRefreshing => 'Atualizando a Tela';

  @override
  String get transferComplete => 'Transferência concluída!';

  @override
  String get writingToEpaper => 'Gravando no ePaper';

  @override
  String get pleaseBringPhoneClose =>
      'Por favor, aproxime o seu telefone do dispositivo Magic ePaper';

  @override
  String get keepPhoneClose => 'Mantenha o telefone próximo!';

  @override
  String get displayRefreshingMessage =>
      'A tela está sendo atualizada. Por favor, mantenha o telefone próximo ao dispositivo até que a imagem apareça completamente.';

  @override
  String get transferFailed => 'Falha na Transferência';

  @override
  String get deviceConnectionTimeout =>
      'O tempo de conexão com o dispositivo esgotou. Tente aproximar o telefone do dispositivo e tente novamente.';

  @override
  String get connectionLostDuringTransfer =>
      'A conexão foi perdida durante a transferência. Mantenha o telefone próximo ao dispositivo e tente novamente.';

  @override
  String get done => 'Concluído';

  @override
  String get close => 'Fechar';

  @override
  String get processingImage => 'Processando Imagem...';

  @override
  String get readyToFlash => 'Pronto para Gravar';

  @override
  String get imageProcessedSuccessfully => 'Imagem processada com sucesso.';

  @override
  String get tapBelowAndHold =>
      'Toque abaixo e mantenha o telefone perto da tela.';

  @override
  String get startFlashing => 'Iniciar Gravação';

  @override
  String get flashing => 'Gravando...';

  @override
  String get keepPhoneStill => 'Mantenha o telefone imóvel.';

  @override
  String get success => 'Sucesso!';

  @override
  String get transferCompleteMessage => 'Transferência concluída!';

  @override
  String get unknownErrorOccurred => 'Ocorreu um erro desconhecido.';

  @override
  String get resultsCleared => 'Resultados limpos';

  @override
  String get clearResults => 'Limpar Resultados';

  @override
  String get vCardContact => 'Contato vCard';

  @override
  String get writingVCard => 'Gravando vCard...';

  @override
  String get writeVCard => 'Gravar vCard';

  @override
  String get firstName => 'Nome';

  @override
  String get lastName => 'Sobrenome';

  @override
  String get organization => 'Organização';

  @override
  String get title => 'Cargo';

  @override
  String get mobileNumber => 'Número de Celular';

  @override
  String get emailAddress => 'Endereço de E-mail';

  @override
  String get streetAddress => 'Endereço';

  @override
  String get city => 'Cidade';

  @override
  String get zipCode => 'CEP';

  @override
  String get country => 'País';

  @override
  String get website => 'Site';

  @override
  String get noSavedImagesYet => 'Nenhuma imagem salva ainda';

  @override
  String get saveImagesFromEditor => 'Salve imagens do editor ou importe novas';

  @override
  String get enterWifiSSID => 'Insira o SSID do Wi-Fi';

  @override
  String get enterWifiPassword => 'Insira a senha do Wi-Fi';

  @override
  String get writeMultiple => 'Gravar Múltiplos';

  @override
  String get searchImages => 'Pesquisar imagens...';

  @override
  String get filter => 'Filtro:';

  @override
  String get all => 'Todos';

  @override
  String get imported => 'Importado';

  @override
  String get editor => 'Editor';

  @override
  String get imageLibrary => 'Biblioteca de Imagens';

  @override
  String get selectImagesToDelete => 'Selecionar Imagens para Excluir';

  @override
  String get delete => 'Excluir';

  @override
  String get deleteMode => 'Modo de Exclusão';

  @override
  String get deleteImage => 'Excluir Imagem';

  @override
  String get thisActionCannotBeUndone => 'Esta ação não pode ser desfeita';

  @override
  String get filterLabel => 'Filtro:';

  @override
  String get areYouSureDeleteImage =>
      'Tem certeza de que deseja excluir esta imagem? Esta ação não pode ser desfeita.';

  @override
  String get deleteMultipleImages => 'Excluir Múltiplas Imagens';

  @override
  String get imagesSelected => 'imagem(ns) selecionada(s)';

  @override
  String get imagesSelectedForDeletion =>
      'imagem(ns) selecionada(s) para exclusão';

  @override
  String areYouSureDeleteMultipleImages(Object count) {
    return 'Tem certeza de que deseja excluir estas $count imagens? Esta ação não pode ser desfeita.';
  }

  @override
  String get areYouSureDeleteSingleImage =>
      'Tem certeza de que deseja excluir esta imagem? Esta ação não pode ser desfeita.';

  @override
  String get deleteAll => 'Excluir Tudo';

  @override
  String get renameImage => 'Renomear Imagem';

  @override
  String get enterNewNameForImage => 'Insira um novo nome para sua imagem';

  @override
  String get imageName => 'Nome da Imagem';

  @override
  String get enterImageName => 'Insira o nome da imagem...';

  @override
  String get rename => 'Renomear';

  @override
  String get imageProperties => 'Propriedades da Imagem';

  @override
  String get created => 'Criado';

  @override
  String get source => 'Fonte:';

  @override
  String get epdModel => 'Modelo EPD:';

  @override
  String get transferToEpaper => 'Transferir para ePaper';

  @override
  String get saveImage => 'Salvar Imagem';

  @override
  String get saveFilteredImageToLibrary =>
      'Salvar a imagem com filtro na biblioteca';

  @override
  String get filterApplied => 'Filtro Aplicado:';

  @override
  String get save => 'Salvar';

  @override
  String get noImagesMatchSearch => 'Nenhuma imagem corresponde à sua pesquisa';

  @override
  String get vCardDataCannotBeEmpty =>
      'Os dados do vCard não podem estar vazios';

  @override
  String get renamingImage => 'Renomeando imagem...';

  @override
  String get imageRenamedTo => 'Imagem renomeada para \"';

  @override
  String get failedToRenameImage => 'Falha ao renomear a imagem: ';

  @override
  String get deletingImage => 'Excluindo imagem...';

  @override
  String get imageDeleted => 'Imagem \"';

  @override
  String get deleted => '\" excluída';

  @override
  String get failedToDeleteImage => 'Falha ao excluir a imagem: ';

  @override
  String get deletingImages => 'Excluindo ';

  @override
  String get images => ' imagem(ns)...';

  @override
  String get failedToDeleteImages => 'Falha ao excluir as imagens: ';

  @override
  String get imagesDeletedSuccessfully => ' imagens excluídas com sucesso';

  @override
  String get imageDeletedSuccessfully => 'Imagem excluída com sucesso';

  @override
  String get failedToLoadImageData =>
      'Falha ao carregar dados da imagem para \"';

  @override
  String get failedToDecodeImage => 'Falha ao decodificar a imagem \"';

  @override
  String get failedToTransfer => 'Falha ao transferir \"';

  @override
  String get savingImage => 'Salvando imagem...';

  @override
  String get imageSavedToLibrary => 'Imagem salva na biblioteca!';

  @override
  String get failedToSaveImage => 'Falha ao salvar a imagem: ';

  @override
  String get errorCreatingVCardRecord => 'Erro ao criar registro vCard: ';

  @override
  String get nfcIsDisabledPleaseEnableIt =>
      'O NFC está desativado. Por favor, ative-o.';

  @override
  String get thisDeviceDoesNotSupportNfc => 'Este dispositivo não suporta NFC.';

  @override
  String get bringPhoneNearMagicEpaperHardware =>
      'Aproxime o telefone do Hardware Magic ePaper';

  @override
  String get tagDetectedInitializing => 'Tag detectada! Inicializando...';

  @override
  String get enablingEnergyHarvesting => 'Ativando captação de energia...';

  @override
  String get processingImageData => 'Processando dados da imagem...';

  @override
  String get refreshingDisplay => 'Atualizando a tela...';

  @override
  String get notMagicEpaperHardware => 'Não é um Hardware Magic ePaper';

  @override
  String get errorCheckingMessage => 'Erro ao verificar mensagem: ';

  @override
  String get timeoutWaitingForI2cMessage =>
      'Tempo limite esgotado ao aguardar mensagem I2C';

  @override
  String get writingChunk => 'Gravando bloco (chunk) ';

  @override
  String get transferredSuccessfully => 'Transferido com sucesso.';

  @override
  String get waitingForNfcTag => 'Aguardando tag NFC...';

  @override
  String get gotTag => 'Tag encontrada!';

  @override
  String get frame => 'Quadro ';

  @override
  String get couldNotOpenLink => 'Não foi possível abrir o link.';

  @override
  String get errorOccurredWhileOpeningLink =>
      'Ocorreu um erro ao tentar abrir o link.';

  @override
  String get errorCreatingAppRecord =>
      'Erro ao criar o registro do aplicativo: ';

  @override
  String get appCannotBeEmpty => 'O aplicativo não pode estar vazio';

  @override
  String get invalidPackageName => 'Nome do pacote inválido';

  @override
  String get writeAppLauncherData => 'Gravar Dados do Lançador de Apps';

  @override
  String get writeAppLauncher => 'Gravar Lançador de Apps';

  @override
  String get searchApps => 'Pesquisar aplicativos...';

  @override
  String get customPackageName => 'Nome do Pacote Personalizado';

  @override
  String get enterPackageName => 'Insira o nome do pacote...';

  @override
  String get noAppsFound => 'Nenhum aplicativo encontrado';

  @override
  String get selectApplication => 'Selecionar Aplicativo';

  @override
  String get errorLoadingApps => 'Erro ao carregar aplicativos: ';

  @override
  String get add => 'Adicionar';

  @override
  String get readNfcTags => 'Ler Tags NFC';

  @override
  String get writeNfcTags => 'Gravar Tags NFC';

  @override
  String get nfcIsReadyToUse =>
      'O NFC está pronto para uso. Você pode ler e gravar tags NFC.';

  @override
  String get deviceDoesNotSupportNfc =>
      'Este dispositivo não suporta a funcionalidade NFC.';

  @override
  String get pleaseEnableNfcInSettings =>
      'Por favor, ative o NFC nas configurações do seu dispositivo para continuar.';

  @override
  String get nfcIsNowEnabledAndReady =>
      'O NFC agora está ativado e pronto para uso!';

  @override
  String get nfcHasBeenDisabled =>
      'O NFC foi desativado. Ative-o para continuar usando os recursos NFC.';

  @override
  String get nfcIsNotSupportedOnDevice =>
      'O NFC não é suportado neste dispositivo.';

  @override
  String get arduinoExport => 'Exportação para Arduino';

  @override
  String get exportXmbFilesForArduino => 'Exportar arquivos XMB para Arduino';

  @override
  String get cardTemplates => 'Modelos de Cartões';

  @override
  String get chooseTemplateSubtitle => 'Escolha um modelo para começar';

  @override
  String get employeeIdCardTitle => 'Crachá de Funcionário';

  @override
  String get employeeIdCardDescription =>
      'Crie crachás de identificação profissional para os funcionários';

  @override
  String get shopPriceTagTitle => 'Etiqueta de Preço de Loja';

  @override
  String get shopPriceTagDescription =>
      'Crie etiquetas de preço atraentes para os seus produtos';

  @override
  String get entryPassTagTitle => 'Etiqueta de Passe de Entrada';

  @override
  String get entryPassTagDescription =>
      'Gere passes de entrada para eventos e locais';

  @override
  String get eventBadgeTitle => 'Crachá de Evento';

  @override
  String get eventBadgeDescription =>
      'Crie crachás de evento e etiquetas de nome personalizados';

  @override
  String get comingSoon => 'Em Breve';

  @override
  String get comingSoonMessage =>
      'Este modelo está atualmente em desenvolvimento e estará disponível em breve.';

  @override
  String get ok => 'OK';

  @override
  String get defaultCompanyName => 'Nome da Empresa';

  @override
  String get nameLabel => 'Nome';

  @override
  String get positionLabel => 'Cargo';

  @override
  String get divisionLabel => 'Divisão';

  @override
  String get idLabel => 'ID';

  @override
  String get emptyFieldPlaceholder => 'Não especificado';

  @override
  String get productImage => 'Imagem do Produto';

  @override
  String get productName => 'Nome do Produto';

  @override
  String get sizeQuantity => 'Tamanho/Quantidade';

  @override
  String get defaultCurrency => 'R\$';

  @override
  String get defaultPrice => '0,00';

  @override
  String get price => 'Preço';

  @override
  String get quantitySize => 'Quantidade/Tamanho';

  @override
  String get quantitySizeHint =>
      'Insira o tamanho/quantidade (ex: 750ml, 2kg, Grande)';

  @override
  String get namePrefix => 'Nome: ';

  @override
  String get positionPrefix => 'Cargo: ';

  @override
  String get divisionPrefix => 'Divisão: ';

  @override
  String get idPrefix => 'ID: ';

  @override
  String get employeeIdCard => 'Crachá de Funcionário';

  @override
  String get fillDetailsToCreateId =>
      'Preencha os detalhes abaixo para criar seu crachá de funcionário';

  @override
  String get idCardDetails => 'Detalhes do Crachá';

  @override
  String get companyName => 'Nome da Empresa';

  @override
  String get enterCompanyName => 'Insira o nome da empresa';

  @override
  String get pleaseEnterCompanyName => 'Por favor, insira o nome da empresa';

  @override
  String get name => 'Nome';

  @override
  String get enterEmployeeName => 'Insira o nome do funcionário';

  @override
  String get pleaseEnterName => 'Por favor, insira o nome';

  @override
  String get position => 'Cargo';

  @override
  String get enterJobPosition => 'Insira o cargo';

  @override
  String get pleaseEnterPosition => 'Por favor, insira o cargo';

  @override
  String get division => 'Divisão';

  @override
  String get enterDepartment => 'Insira o departamento';

  @override
  String get pleaseEnterDivision => 'Por favor, insira a divisão';

  @override
  String get idNumber => 'Número de ID';

  @override
  String get enterUniqueId => 'Insira o ID exclusivo';

  @override
  String get pleaseEnterIdNumber => 'Por favor, insira o número de ID';

  @override
  String get qrCodeData => 'Dados do QR Code';

  @override
  String get enterQrCodeData => 'Insira os dados do QR Code';

  @override
  String get pleaseEnterQrCodeData => 'Por favor, insira os dados do QR Code';

  @override
  String get generatingIdCard => 'Gerando Crachá...';

  @override
  String get generateIdCard => 'Gerar Crachá';

  @override
  String get profilePhoto => 'Foto de Perfil';

  @override
  String get selected => 'Selecionado';

  @override
  String get photoSelected => 'Foto selecionada';

  @override
  String get selectProfilePhoto => 'Selecionar Foto de Perfil';

  @override
  String get tapToChangePhoto => 'Toque para alterar a foto';

  @override
  String get tapToSelectFromGallery => 'Toque para selecionar da galeria';

  @override
  String get priceTagGenerator => 'Gerador de Etiqueta de Preço';

  @override
  String get priceTagDescription =>
      'Crie etiquetas de preço profissionais para seus produtos';

  @override
  String get productDetails => 'Detalhes do Produto';

  @override
  String get productNameHint => 'Insira o nome do produto (ex: iPhone 15 Pro)';

  @override
  String get pleaseEnterProductName => 'Por favor, insira um nome de produto';

  @override
  String get currency => 'Moeda';

  @override
  String get currencyHint => 'R\$';

  @override
  String get required => 'Obrigatório';

  @override
  String get priceHint => '999,99';

  @override
  String get pleaseEnterPrice => 'Por favor, insira o preço';

  @override
  String get pleaseEnterQuantitySize =>
      'Por favor, insira a quantidade ou o tamanho';

  @override
  String get pleaseEnterBarcodeData =>
      'Por favor, insira os dados do código de barras';

  @override
  String get generatingPriceTag => 'Gerando Etiqueta de Preço...';

  @override
  String get generatePriceTag => 'Gerar Etiqueta de Preço';

  @override
  String get productImageIn => 'Imagem do Produto';

  @override
  String get productImageSelected => 'Imagem do Produto Selecionada';

  @override
  String get selectProductImage => 'Selecionar Imagem do Produto';

  @override
  String get tapToChangeImage => 'Toque para alterar a imagem';

  @override
  String get chooseImageFromGallery => 'Escolha a imagem da galeria';

  @override
  String get processingImages => 'Processando imagens...';

  @override
  String get refreshModeInfo => 'Informações do Modo de Atualização';

  @override
  String get fullRefreshInfo => 'Atualização Completa';

  @override
  String get fullRefreshDescription =>
      'Atualiza completamente a tela inteira, limpando todos os pixels e redesenhando a imagem. Isso oferece a melhor qualidade de imagem e contraste, mas leva mais tempo para ser concluído.';

  @override
  String get partialRefreshInfo => 'Atualização Parcial (Waveforms)';

  @override
  String get partialRefreshDescription =>
      'Atualiza apenas os pixels alterados usando formas de onda otimizadas. Isso é mais rápido do que a atualização completa, mas pode resultar em efeito fantasma (ghosting) ou redução de contraste com o tempo.';

  @override
  String get longPressForInfo =>
      'Pressione e segure para obter mais informações';
}
