unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, System.Json,
    Datasnap.DSServer, Datasnap.DSAuth, DataSnap.DSProviderDataModuleAdapter,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Phys.PGDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  Datasnap.Provider, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Comp.UI, Vcl.Forms, IPPeerClient, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, REST.Response.Adapter, Datasnap.DBClient,
  untThreadEnderecoIntegracao;

type
  TServerMethods1 = class(TDSServerModule)
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    FDConnection1: TFDConnection;
    qryPessoa: TFDQuery;
    dspPessoa: TDataSetProvider;
    qryEndereco: TFDQuery;
    mtListaTemporaria: TFDMemTable;
    mtListaTemporariaflnatureza: TIntegerField;
    mtListaTemporariadsdocumento: TStringField;
    mtListaTemporarianmprimeiro: TStringField;
    mtListaTemporarianmsegundo: TStringField;
    mtListaTemporariadscep: TStringField;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    RESTResponse1: TRESTResponse;
    RESTRequest1: TRESTRequest;
    RESTClient1: TRESTClient;
    ClientDataSet1: TClientDataSet;
    ClientDataSet1cep: TWideStringField;
    ClientDataSet1logradouro: TWideStringField;
    ClientDataSet1complemento: TWideStringField;
    ClientDataSet1bairro: TWideStringField;
    ClientDataSet1localidade: TWideStringField;
    ClientDataSet1uf: TWideStringField;
    ClientDataSet1ibge: TWideStringField;
    ClientDataSet1gia: TWideStringField;
    ClientDataSet1ddd: TWideStringField;
    ClientDataSet1siafi: TWideStringField;
    procedure DSServerModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    threadMonitor: TfThreadEnderecoIntegracao;
    procedure Insert(flnatureza: integer; dsdocumento, nmprimeiro,
      nmsegundo, dscep: string; dtregistro: TDateTime);
    procedure Update(idPessoa, flnatureza: integer;
      dsdocumento, nmprimeiro, nmsegundo, dscep: string; dtregistro: TDateTime);
    procedure Delete(idPessoa: integer);
    procedure GerarListaTemporaria(sPathFile: string);
    procedure CadastramentoEmLote(sPathFile: string);
    procedure EnderecoIntegracao;
  end;

var
  DMServerMethodsUnit1: TServerMethods1;

implementation

{$R *.dfm}

uses System.StrUtils;

procedure TServerMethods1.Update(idpessoa, flnatureza: integer;
  dsdocumento, nmprimeiro, nmsegundo, dscep: string; dtregistro: TDateTime);
begin
  try
    qryPessoa.Close;
    qryPessoa.SQL.Clear;
    qryPessoa.SQL.Add('UPDATE pessoa ');
    qryPessoa.SQL.Add('SET flnatureza = ' + IntToStr(flnatureza));
    qryPessoa.SQL.Add('    ,dsdocumento = ' + QuotedStr(dsdocumento));
    qryPessoa.SQL.Add('    ,nmprimeiro = ' + QuotedStr(nmprimeiro));
    qryPessoa.SQL.Add('    ,nmsegundo = ' + QuotedStr(nmsegundo));
    qryPessoa.SQL.Add('    ,dtregistro = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', now)));
    qryPessoa.SQL.Add('WHERE idPessoa = ' + IntToStr(idPessoa));
    qryPessoa.ExecSQL;

    qryPessoa.Close;
    qryPessoa.SQL.Clear;
    qryPessoa.SQL.Add('UPDATE endereco ');
    qryPessoa.SQL.Add('SET dscep = ' + QuotedStr(dscep));
    qryPessoa.SQL.Add('WHERE idPessoa = ' + IntToStr(idPessoa));
    qryPessoa.ExecSQL;
  except
    on E:Exception do
    begin
      raise;
    end;
  end;
end;

procedure TServerMethods1.CadastramentoEmLote(sPathFile: string);
var
  LQuery: TFDQuery;
begin
  GerarListaTemporaria(sPathFile);
  LQuery := TFDQuery.Create(Self);
  mtListaTemporaria.DisableControls;
  FDConnection1.StartTransaction;

  try
    try
      LQuery.Connection := FDConnection1;

      LQuery.SQL.Add(' with nova_pessoa as ( ');
      LQuery.SQL.Add(' insert into pessoa (flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) ');
      LQuery.SQL.Add(' values (:flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, :dtregistro) ');
      LQuery.SQL.Add(' returning idpessoa ) ');
      LQuery.SQL.Add(' insert into endereco(idpessoa, dscep) ');
      LQuery.SQL.Add(' select idpessoa, :dscep from nova_pessoa; ');

      LQuery.Params.ArraySize := mtListaTemporaria.RecordCount;

      mtListaTemporaria.First;
      while not mtListaTemporaria.Eof do
      begin
        LQuery.ParamByName('flnatureza').AsIntegers[Pred(mtListaTemporaria.RecNo)] := mtListaTemporariaflnatureza.AsInteger;
        LQuery.ParamByName('dsdocumento').AsStrings[Pred(mtListaTemporaria.RecNo)] := mtListaTemporariadsdocumento.AsString;
        LQuery.ParamByName('nmprimeiro').AsStrings[Pred(mtListaTemporaria.RecNo)] := mtListaTemporarianmprimeiro.AsString;
        LQuery.ParamByName('nmsegundo').AsStrings[Pred(mtListaTemporaria.RecNo)] := mtListaTemporarianmsegundo.AsString;
        LQuery.ParamByName('dtregistro').AsDateTimes[Pred(mtListaTemporaria.RecNo)] := now;
        LQuery.ParamByName('dscep').AsStrings[Pred(mtListaTemporaria.RecNo)] := mtListaTemporariadscep.AsString;
        mtListaTemporaria.Next;
      end;

      if (LQuery.Params.ArraySize > 0) then
      begin
        LQuery.Execute(LQuery.Params.ArraySize, 0);
      end;

      if FDConnection1.InTransaction then
        FDConnection1.Commit;

      qryPessoa.Close;
      qryPessoa.Open();
      qryPessoa.FetchAll;
    except
      on E:Exception do
      begin
        if FDConnection1.InTransaction then
          FDConnection1.Rollback;
        raise;
      end;
    end;
  finally
    mtListaTemporaria.EnableControls;
    LQuery.Free;
  end;
end;

procedure TServerMethods1.Delete(idPessoa: integer);
begin
  try
    qryPessoa.Close;
    qryPessoa.SQL.Clear;
    qryPessoa.SQL.Add('DELETE from pessoa ');
    qryPessoa.SQL.Add('WHERE idPessoa = ' + IntToStr(idPessoa));
    qryPessoa.ExecSQL;
  except
    on E:Exception do
    begin
      raise;
    end;
  end;
end;

procedure TServerMethods1.DSServerModuleCreate(Sender: TObject);
var
  sCaminhoLibpq: string;
begin
  sCaminhoLibpq := (ExtractFilePath(Application.ExeName));
  FDPhysPgDriverLink1.VendorLib := sCaminhoLibpq+'bin\libpq.dll';
end;

procedure TServerMethods1.EnderecoIntegracao;
begin
  qryEndereco.Open;
  threadMonitor := TfThreadEnderecoIntegracao.Create(true);
  threadMonitor.QryEndereco := qryEndereco;

  threadMonitor.ClientDataSet := ClientDataSet1;
  threadMonitor.RESTResponseDataSetAdapter := RESTResponseDataSetAdapter1;
  threadMonitor.RESTRequest := RESTRequest1;
  threadMonitor.FDConnection := FDConnection1;
  threadMonitor.Start;
end;

procedure TServerMethods1.Insert(flnatureza: integer; dsdocumento,
  nmprimeiro, nmsegundo, dscep: string; dtregistro: TDateTime);
var
  idpessoa: string;
begin
  try
    qryPessoa.Close;
    qryPessoa.SQL.Clear;
    qryPessoa.SQL.Add('INSERT INTO pessoa ');
    qryPessoa.SQL.Add(' (flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) ');
    qryPessoa.SQL.Add(' VALUES ( ');
    qryPessoa.SQL.Add(IntToStr(flnatureza));
    qryPessoa.SQL.Add(', ' + QuotedStr(dsdocumento));
    qryPessoa.SQL.Add(', ' + QuotedStr(nmprimeiro));
    qryPessoa.SQL.Add(', ' + QuotedStr(nmsegundo));
    qryPessoa.SQL.Add(', ' + QuotedStr(FormatDateTime('yyyy-mm-dd', now)));
    qryPessoa.SQL.Add(' )');
    qryPessoa.ExecSQL;

    qryPessoa.Close;
    qryPessoa.SQL.Clear;
    qryPessoa.SQL.Add('SELECT currval(pg_get_serial_sequence('
                      + QuotedStr('pessoa') + ',' + QuotedStr('idpessoa') + ')) as idpessoa ;');
    qryPessoa.Open;
    idpessoa := qryPessoa.FieldByName('idpessoa').AsString;

    qryPessoa.Close;
    qryPessoa.SQL.Clear;
    qryPessoa.SQL.Add('INSERT INTO endereco ');
    qryPessoa.SQL.Add(' (idpessoa, dscep) ');
    qryPessoa.SQL.Add(' VALUES ( ');
    qryPessoa.SQL.Add(idpessoa);
    qryPessoa.SQL.Add(', ' + QuotedStr(dscep));
    qryPessoa.SQL.Add(' )');
    qryPessoa.ExecSQL;
  except
    on E:Exception do
    begin
      raise;
    end;
  end;
end;

procedure TServerMethods1.GerarListaTemporaria(sPathFile: string);
var
  LListaClientes, LCliente: TStringList;
  LLine: string;
begin
  mtListaTemporaria.Close;
  mtListaTemporaria.Open;
  mtListaTemporaria.DisableControls;

  LListaClientes := TStringList.Create;
  LCliente := TStringList.Create;
  try
    LListaClientes.LoadFromFile(sPathFile);
    for LLine in LListaClientes do
    begin
      LCliente.StrictDelimiter := True;
      LCliente.CommaText := LLine;
      mtListaTemporaria.Append;
      mtListaTemporariaflnatureza.AsInteger := LCliente[0].ToInteger;
      mtListaTemporariadsdocumento.AsString := LCliente[1];
      mtListaTemporarianmprimeiro.AsString := LCliente[2];
      mtListaTemporarianmsegundo.AsString := LCliente[3];
      mtListaTemporariadscep.AsString := LCliente[4];
      mtListaTemporaria.Post;
    end;
  finally
    LCliente.Free;
    LListaClientes.Free;
    mtListaTemporaria.EnableControls;
  end;
end;

end.

