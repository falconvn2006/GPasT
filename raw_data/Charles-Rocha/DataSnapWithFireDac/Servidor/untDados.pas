unit untDados;

interface

uses
  System.Classes, System.SysUtils, Vcl.ComCtrls, Vcl.Forms, Vcl.Controls,
  Vcl.ExtCtrls, System.IniFiles, FireDAC.Comp.Client;

type
  TDados = class
  private
    { Private declarations }
    FUrl: string;
    FDataInicio: TDateTime;
    FDataFim: TDateTime;

  protected

  public
    { Public declarations }
    procedure InserirLogDownload;
    function ListarHistoricoDownloads: TFDQuery;

    property Url: string read FUrl write FUrl;
    property DataInicio: TDateTime read FDataInicio write FDataInicio;
    property DataFim: TDateTime read FDataFim write FDataFim;
  end;

implementation

{ TDados }

uses untDM;

procedure TDados.InserirLogDownload;
var
  qryInserir: TFDQuery;
  qryGetMaxCod: TFDQuery;
  iCodigo: Integer;
begin
  qryGetMaxCod := TFDQuery.Create(nil);
  qryGetMaxCod.Connection := DM.FDConnection1;
  qryInserir := TFDQuery.Create(nil);
  qryInserir.Connection := DM.FDConnection1;

  try
    qryGetMaxCod.Close;
    qryGetMaxCod.SQL.Clear;
    qryGetMaxCod.SQL.Add('SELECT MAX(CODIGO) AS CODIGO FROM LOGDOWNLOAD ');
    qryGetMaxCod.Open;

    if qryGetMaxCod.FieldByName('CODIGO').IsNull then
      begin
        iCodigo := 1;
      end
    else
      begin
        iCodigo := qryGetMaxCod.FieldByName('CODIGO').AsInteger + 1;
      end;

    qryInserir.Close;
    qryInserir.SQL.Clear;
    qryInserir.SQL.Add('INSERT INTO LOGDOWNLOAD ');
    qryInserir.SQL.Add('(CODIGO, URL, DATAINICIO, DATAFIM) ');
    qryInserir.SQL.Add('VALUES (:CODIGO, :URL, :DATAINICIO, :DATAFIM) ');
    qryInserir.ParamByName('CODIGO').AsInteger := iCodigo;
    qryInserir.ParamByName('URL').AsString := FUrl;
    qryInserir.ParamByName('DATAINICIO').AsDateTime := FDataInicio;
    qryInserir.ParamByName('DATAFIM').AsDateTime := FDataFim;
    qryInserir.ExecSQL;
  finally
    qryInserir.Free;
    qryGetMaxCod.Free;
  end;
end;

function TDados.ListarHistoricoDownloads: TFDQuery;
var
  qryListarHistorico: TFDQuery;
begin
  qryListarHistorico := TFDQuery.Create(nil);
  qryListarHistorico.Connection := DM.FDConnection1;

  try
    qryListarHistorico.Close;
    qryListarHistorico.SQL.Clear;
    qryListarHistorico.SQL.Add('SELECT * FROM LOGDOWNLOAD ');
    qryListarHistorico.Open;

    Result := qryListarHistorico;
  finally
    //Não necessário, ao instanciar a classe Dados, ao liberá-la, esse objeto será liberado automaticamente
    //qryListarHistorico.Free;
  end;
end;

end.
