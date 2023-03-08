unit uDM;

interface

uses
    System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
    FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
    Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
    FireDAC.Stan.ExprFuncs,

    System.IOUtils, System.Notification, REST.Types, Data.Bind.Components,
    Data.Bind.ObjectScope, REST.Client, FireDAC.Stan.Param, FireDAC.DatS,
    FireDAC.DApt.Intf, REST.Response.Adapter, FireDAC.Comp.DataSet, FireDAC.DApt

    ,FMX.Forms
    ,FMX.Layouts
    ,FMX.Dialogs

    ;

type
  TTablesMobile =
  (
    tmPESSOA        , //MOB001
    tmPEDIDO        , //MOB009
    tmITEM_PEDIDO     //MOB010
  );

    TDM = class(TDataModule)
    conn: TFDConnection;
    qryAuxiliar: TFDQuery;
    qryCarregaDados: TFDQuery;
    qryTempLocal: TFDQuery;
    qryTemporaria: TFDQuery;
    qryParametros: TFDQuery;
    QryPessoa: TFDQuery;
    QryCadastro: TFDQuery;
    RestReq: TRESTRequest;
    RestConnection: TRESTClient;
        procedure connBeforeConnect(Sender: TObject);
        procedure DataModuleCreate(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
        function Converte_Valor(valor : string) : double;
        procedure AbrirCadastro;

    end;

var
    DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

{$Region 'Metodos Diversos'}

procedure TDM.AbrirCadastro;
const
  LSQL =
    'SELECT                                        ' +
    '  *                                           ' +
    'FROM                                          ' +
    '  TB_CADASTROSUS                              ' +
    '  ORDER BY CAD_ID                             '
    ;

begin
    with QryCadastro do
    begin
        Active := False;
        SQL.Clear;
        SQL.Text := LSQL;
        Active := True;
    end;

end;




function TDM.Converte_Valor(valor : string) : double;
var
        retorno : double;
begin
        valor := StringReplace(valor, 'R$', '', [rfReplaceAll]);
        valor := StringReplace(valor, ' ', '', [rfReplaceAll]);
        valor := StringReplace(valor, '.', '', [rfReplaceAll]);
        valor := StringReplace(valor, ',', '', [rfReplaceAll]);

        Result := strtofloat(valor) / 100;
end;










{$EndRegion'}

{$Region 'Metodos Conexao'}

procedure TDM.connBeforeConnect(Sender: TObject);
begin
    conn.Params.Values['Database'] := '';

{$IF DEFINED(IOS) OR DEFINED(ANDROID)}
    conn.Params.Values['DriverID'] := 'SQLite';
    conn.Params.Values['OpenMode'] := 'ReadWrite';
    conn.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath,'Vacinacao.db');
{$ENDIF}

{$IFDEF MSWINDOWS}
    conn.Params.Values['Database'] :=
     'F:\Cursos\Univesp\14 Bimestre\DISCIPLINAS\PROJETO INTEGRADOR VI - PEC006\Aplicativo\Delphi\banco\Cotacao.db';
    conn.Params.Values['Protocol'] := 'TCPIP';
{$ENDIF}


end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin

    try
        conn.Connected := True;
    except
        on E: Exception do
        begin
            raise Exception.Create('Erro de conexão com o banco de dados!');
        end;
    end;

end;


{$EndRegion'}



end.
