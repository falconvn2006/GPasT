unit Controle.Operacoes.TituloReceber.Documentos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Operacoes, Data.Win.ADODB,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, uniGUIBaseClasses,
  uniImageList, uniBitBtn, uniSpeedButton, uniLabel, uniButton, uniPanel,
  uniBasicGrid, uniDBGrid, uniFileUpload, uniSweetAlert;

type
  TControleOperacoesTituloReceberDocumentos = class(TControleOperacoes)
    BotaoApagarImagem: TUniButton;
    ButtonImportaImagem: TUniButton;
    GrdResultado: TUniDBGrid;
    UniFileUploadDocumento: TUniFileUpload;
    UniSweetConfirmaExclusao: TUniSweetAlert;
    procedure ButtonImportaImagemClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniFileUploadDocumentoCompleted(Sender: TObject;
      AStream: TFileStream);
    procedure GrdResultadoCellClick(Column: TUniDBGridColumn);
    procedure BotaoApagarImagemClick(Sender: TObject);
    procedure UniSweetConfirmaExclusaoConfirm(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleOperacoesTituloReceberDocumentos: TControleOperacoesTituloReceberDocumentos;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Server.Module, Controle.Impressao.Documento,
  Controle.Main, Controle.Funcoes;

function ControleOperacoesTituloReceberDocumentos: TControleOperacoesTituloReceberDocumentos;
begin
  Result := TControleOperacoesTituloReceberDocumentos(ControleMainModule.GetFormInstance(TControleOperacoesTituloReceberDocumentos));
end;

procedure TControleOperacoesTituloReceberDocumentos.BotaoApagarImagemClick(
  Sender: TObject);
  var
    tit_id : integer;
begin
  inherited; //Assinatura_
  if Copy(ControleMainModule.CdsListaArquivosDESCRICAO.AsString,1,11) = 'Assinatura_' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não é permitido apagar o recibo com a assinatura do cliente.');
    Exit;
  end;


  if ControleMainModule.CdsListaArquivos.RecordCount > 0 then
    UniSweetConfirmaExclusao.show
  else
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não há registro para serem excluidos!');
end;

procedure TControleOperacoesTituloReceberDocumentos.ButtonImportaImagemClick(
  Sender: TObject);
begin
  inherited;

  if controlemain.LimitePlanoHD = true then
  begin

    Try
      with UniFileUploadDocumento do
      begin
        MaxAllowedSize := 5000000;
        Execute;
      // UniMainModule.CarregaListaDeArquivos(titulo_id);
      end;
    Except
      on e:Exception do
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(e.Message));
      end;
    end;
  end;

end;

procedure TControleOperacoesTituloReceberDocumentos.UniFileUploadDocumentoCompleted(
  Sender: TObject; AStream: TFileStream);
var
  DestName: string;
  DestFolder: string;
begin
  Try
    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\') then
    begin
      CreateDir(ControleServerModule.StartPath+'UploadFolder\');
    end;

    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema) then
    begin
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema);
    end;

    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                          'Titulo') then
    begin
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                          'Titulo');
    end;

    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                          'Titulo\' + IntToStr(ControleMainModule.titulo_id_m)) then
    begin
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                          'Titulo\' + IntToStr(ControleMainModule.titulo_id_m));
    end;

    // Criando a pasta no servidor, caso nao exista
    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                         'Titulo\' + IntToStr(ControleMainModule.titulo_id_m) + '\Documento\') then
    begin
     CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
               'Titulo\' + IntToStr(ControleMainModule.titulo_id_m) + '\Documento\');
    end;

    // Criando a pasta no servidor, caso nao exista
    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                         'Titulo\' + IntToStr(ControleMainModule.titulo_id_m) + '\Documento\Receber\') then
    begin
     CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
               'Titulo\' + IntToStr(ControleMainModule.titulo_id_m) + '\Documento\Receber\');
    end;

    // Caso não consiga fazer o upload, alterar para esse abaixo e comentar o outro
    DestFolder      := ControleServerModule.StartPath + 'UploadFolder\' + ControleMainModule.FSchema + '\' + 'Titulo\' + InttoStr(ControleMainModule.titulo_id_m) +'\Documento\Receber\';
    DestName        := DestFolder + ExtractFileName(TimeToStr(Time()) +'_'+ UniFileUploadDocumento.FileName);
    CopyFile(PChar(AStream.FileName), PChar(DestName), False);
    ControleMainModule.URL_LOGO_MAIN_MODULE        := DestName;

    Prompt('Digite a descrição',
           UniFileUploadDocumento.FileName,
           mtConfirmation,
           mbOKCancel,
           ControleMainModule.ConfirmaSalvarDocumento);
  Except
    on e:exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(e.Message));
    end;
  End;
end;

procedure TControleOperacoesTituloReceberDocumentos.GrdResultadoCellClick(
  Column: TUniDBGridColumn);
begin
  inherited;
  if Column.FieldName = 'CAMINHO' then
  begin
    ControleImpressaoDocumento.UniURLFrame1.URL := ControleMainModule.CdsListaArquivosCAMINHO.AsString;
    ControleImpressaoDocumento.ShowModal;
  end;
end;

procedure TControleOperacoesTituloReceberDocumentos.UniFormShow(
  Sender: TObject);
begin
  inherited;
  if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                        'Titulo\') then
  begin
    CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                        'Titulo\');
  end;

  //controleOperacoesTitulosCarne.showModal;
  ControleMainModule.CarregaListaDeArquivos(ControleMainModule.titulo_id_m,
                                       'TITULO');
end;

procedure TControleOperacoesTituloReceberDocumentos.UniSweetConfirmaExclusaoConfirm(
  Sender: TObject);
var
  tit_id : integer;
begin
  inherited;

  tit_id := ControleMainModule.CdsListaArquivos.FieldByName('tabela_id').AsInteger;
  ControleMainModule.ApagarDocumento('documentos',
                                      ControleMainModule.CdsListaArquivos.FieldByName('id').AsInteger);
  ControleMainModule.CdsListaArquivos.Refresh;

  if ControleMainModule.CdsListaArquivos.RecordCount = 0 then
    ControleMainModule.TituloPossuiAnexo(tit_id,
                                    'N');
end;

end.
