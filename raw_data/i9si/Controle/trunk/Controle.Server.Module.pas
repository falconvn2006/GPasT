unit Controle.Server.Module;

interface

uses
  Classes, SysUtils, uniGUIServer, uniGUIMainModule, uniGUIApplication, uIdCustomHTTPServer,
  uniGUITypes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.Oracle, FireDAC.Phys.OracleDef,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
   Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient, uniGUIBaseClasses, uniGUIClasses ;

type
  TTipoRecebeCallBack = (snNulo, snConcorda, snNaoConcorda, snExpirou);

type
  TControleServerModule = class(TUniGUIServerModule)
    procedure UniGUIServerModuleCreate(Sender: TObject);
    procedure UniGUIServerModuleHTTPCommand(ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo; var Handled: Boolean);
  private
//    function ConverterDataGerencianet(dataGerencianet: string): TDateTime;
    { Private declarations }

  protected
    procedure FirstInit; override;
  public
    { Public declarations }
    RecebeCallBack: TTipoRecebeCallBack;
  end;

function ControleServerModule: TControleServerModule;

implementation

{$R *.dfm}

uses
  UniGUIVars, uniGUIDialogs, Winapi.ActiveX,

    //classes para gerencianet
  System.RegularExpressions, System.math,
     Controle.Main.Module, ExtPascal, Vcl.Forms,
  Winapi.Windows, REST.Client;


function ControleServerModule: TControleServerModule;
begin
  Result:=TControleServerModule(UniGUIServerInstance);
end;

procedure TControleServerModule.FirstInit;
begin
  InitServerModule(Self);
end;

procedure TControleServerModule.UniGUIServerModuleCreate(Sender: TObject);
begin
  try
    MimeTable.AddMimeType('woff', 'application/font', False);
    MimeTable.AddMimeType('woff2', 'application/font', False);
    MimeTable.AddMimeType('ttf', 'application/font', False);

    //-----PERMITIR DONWLOAD E ARQUIVOS DE DOCUMENTOS---////
    MimeTable.AddMimeType('doc', 'application/text', False);
    MimeTable.AddMimeType('rtf', 'application/text', False);
    MimeTable.AddMimeType('docx', 'application/text', False);
    MimeTable.AddMimeType('txt', 'application/text', False);
    MimeTable.AddMimeType('pdf', 'application/text', False);
    MimeTable.AddMimeType('xls', 'application/text', False);
    MimeTable.AddMimeType('xlsx', 'application/text', False);
    MimeTable.AddMimeType('xlr', 'application/text', False);

    //-----PERMITIR DOWNLOAD DE ARQUIVOS DE REMESSA------///
    MimeTable.AddMimeType('crm', 'application/text', False);
    MimeTable.AddMimeType('rem', 'application/text', False);
    MimeTable.AddMimeType('cr0', 'application/text', False);
    MimeTable.AddMimeType('cr1', 'application/text', False);
    MimeTable.AddMimeType('cr2', 'application/text', False);
    MimeTable.AddMimeType('cr3', 'application/text', False);
    MimeTable.AddMimeType('cr4', 'application/text', False);
    MimeTable.AddMimeType('cr5', 'application/text', False);
    MimeTable.AddMimeType('cr6', 'application/text', False);
    MimeTable.AddMimeType('cr7', 'application/text', False);
    MimeTable.AddMimeType('cr8', 'application/text', False);
    MimeTable.AddMimeType('cr9', 'application/text', False);
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Erro: ' + E.Message + 'Class Name: ' + E.ClassName), 'Atenção!', mb_ok + mb_iconerror);
    end;
  end;
end;

procedure TControleServerModule.UniGUIServerModuleHTTPCommand(
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo;
  var Handled: Boolean);
var
  RC : TRESTClient;
begin
  RC := TRESTClient.Create(nil);
  try
    if ARequestInfo.URI='/data/testawhatsapp/true' then
    begin
      // DO YOUR REST STUFF
      AResponseInfo.ResponseNo := 200;
      RecebeCallBack := snConcorda;
      AResponseInfo.WriteContent;
      Handled := True;
    end;

    if ARequestInfo.URI='/data/testawhatsapp/false' then
    begin
      // DO YOUR REST STUFF
      AResponseInfo.ResponseNo := 200;
      RecebeCallBack := snNaoConcorda;
      AResponseInfo.WriteContent;
      Handled := True;
    end;
  finally
    RC.Free;
  end;

end;

{function TUniServerModule.GerencianetConnect_Server(conta_bancaria_id: integer): Boolean;
var
  TipoAmbiente : String;
begin
  try
    // Seleciona a conta bancaria para obter os dados do gerencianet
    // Modificar quando for emitir boletos/carnes de outro banco?
    CdsAx4.Close;
    QryAx4.Parameters.Clear;
    QryAx4.SQL.Clear;
    QryAx4.SQL.Add('SELECT ctb.id,');
    QryAx4.SQL.Add('       ctb.descricao,');
    QryAx4.SQL.Add('       pes.nome_fantasia,');
    QryAx4.SQL.Add('       ctb.gerencianet_client_id,');
    QryAx4.SQL.Add('       ctb.gerencianet_client_secret,');
    QryAx4.SQL.Add('       ctb.gerencianet_tipoambiente TipoAmbiente');
    QryAx4.SQL.Add('  FROM conta_bancaria ctb');
    QryAx4.SQL.Add('  LEFT JOIN banco ban');
    QryAx4.SQL.Add('    ON ban.id = ctb.banco_id');
    QryAx4.SQL.Add(' INNER JOIN pessoa pes');
    QryAx4.SQL.Add('    ON pes.id = ban.id');
    QryAx4.SQL.Add(' WHERE ctb.id = :id');
    QryAx4.Parameters.ParamByName('id').Value := conta_bancaria_id;
    CdsAx4.Open;

    EnableService('GerenciaNet.dll');

    if CdsAx4.FieldByName('TipoAmbiente').AsString = 'H' then
      TipoAmbiente := 'sandbox'
    else if CdsAx4.FieldByName('TipoAmbiente').AsString = 'P' then
      TipoAmbiente := 'API';

    ConfigureService(ToPAnsiChar(trim(CdsAx4.FieldByName('gerencianet_client_id').AsString)),
                     ToPAnsiChar(trim(CdsAx4.FieldByName('gerencianet_client_secret').AsString)),
                     ToPAnsiChar(TipoAmbiente),
                     'config.json',
                     '');

    if GerenciaNetAuthorize() = 'Connected' then
      Result := True
    else
      Result := False;
  Except
    on e:exception do
    begin
      Result := False;

    end;
  end;
end;   }


initialization
  RegisterServerModuleClass(TControleServerModule);
end.
