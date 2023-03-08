unit Controle.Operacoes.TituloPagar.Documentos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Operacoes,  Data.Win.ADODB,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, uniGUIBaseClasses,
  uniImageList, uniBitBtn, uniSpeedButton, uniLabel, uniButton, uniPanel,
  uniBasicGrid, uniDBGrid, uniFileUpload, uniSweetAlert;

type
  TControleOperacoesTituloPagarDocumentos = class(TControleOperacoes)
    GrdResultado: TUniDBGrid;
    UniFileUploadDocumento: TUniFileUpload;
    BotaoApagarImagem: TUniButton;
    ButtonImportaImagem: TUniButton;
    UniSweetConfirmaExclusao: TUniSweetAlert;
    procedure UniFileUploadDocumentoCompleted(Sender: TObject;
      AStream: TFileStream);
    procedure GrdResultadoCellClick(Column: TUniDBGridColumn);
    procedure ButtonImportaImagemClick(Sender: TObject);
    procedure BotaoApagarImagemClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniSweetConfirmaExclusaoConfirm(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleOperacoesTituloPagarDocumentos: TControleOperacoesTituloPagarDocumentos;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Server.Module, Controle.Impressao.Documento,
  Controle.Main, Controle.Funcoes;

function ControleOperacoesTituloPagarDocumentos: TControleOperacoesTituloPagarDocumentos;
begin
  Result := TControleOperacoesTituloPagarDocumentos(ControleMainModule.GetFormInstance(TControleOperacoesTituloPagarDocumentos));
end;

procedure TControleOperacoesTituloPagarDocumentos.BotaoApagarImagemClick(
  Sender: TObject);
var
  tit_id : integer;
begin
  inherited;
  if ControleMainModule.CdsListaArquivos.RecordCount > 0 then
    UniSweetConfirmaExclusao.show
  else
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não há registro para serem excluidos!');
end;

procedure TControleOperacoesTituloPagarDocumentos.ButtonImportaImagemClick(
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
        ControleMainModule.MensageiroSweetAlerta('Atenção: ', ControleFuncoes.RetiraAspaSimples(E.Message));
      end;
    end;
  end;
end;

procedure TControleOperacoesTituloPagarDocumentos.GrdResultadoCellClick(
  Column: TUniDBGridColumn);
begin
  inherited;
  if Column.FieldName = 'CAMINHO' then
  begin
    ControleImpressaoDocumento.UniURLFrame1.URL := ControleMainModule.CdsListaArquivosCAMINHO.AsString;
    ControleImpressaoDocumento.ShowModal;
  end;
end;

procedure TControleOperacoesTituloPagarDocumentos.UniFileUploadDocumentoCompleted(
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
                          'Titulo\') then
    begin
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                          'Titulo\');
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
                         'Titulo\' + IntToStr(ControleMainModule.titulo_id_m) + '\Documento\Pagar\') then
    begin
     CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
               'Titulo\' + IntToStr(ControleMainModule.titulo_id_m) + '\Documento\Pagar\');
    end;

    // Caso não consiga fazer o upload, alterar para esse abaixo e comentar o outro
    DestFolder      := ControleServerModule.StartPath + 'UploadFolder\' + ControleMainModule.FSchema + '\' + 'Titulo\' + InttoStr(ControleMainModule.titulo_id_m) +'\Documento\Pagar\';
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
      ControleMainModule.MensageiroSweetAlerta('Atenção: ', ControleFuncoes.RetiraAspaSimples(E.Message));
    end;
  End;
end;

procedure TControleOperacoesTituloPagarDocumentos.UniFormShow(Sender: TObject);
begin
  inherited;
  //controleOperacoesTitulosCarne.showModal;
  ControleMainModule.CarregaListaDeArquivos(ControleMainModule.titulo_id_m,
                                       'TITULO');
end;

procedure TControleOperacoesTituloPagarDocumentos.UniSweetConfirmaExclusaoConfirm(
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
