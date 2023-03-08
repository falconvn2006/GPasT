unit WKData;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, Data.Bind.Components, Data.Bind.ObjectScope,
  REST.Client, Data.Bind.DBScope, Data.Bind.DBXScope, REST.Response.Adapter,
  Datasnap.Provider, Vcl.ExtCtrls, System.JSON;

type
  TWk_Data = class(TDataModule)
    Wk_Connect: TFDConnection;
    Wk_PgDriverLink: TFDPhysPgDriverLink;
    Wk_Transaction: TFDTransaction;
    Wk_QryAux1: TFDQuery;
    Wk_DSP_aux1: TDataSetProvider;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    ParamsAdapter1: TParamsAdapter;
    RESTResponseDataSetAdapter2: TRESTResponseDataSetAdapter;
    RESTResponse1: TRESTResponse;
    TmCeps: TTimer;
    procedure TmCepsTimer(Sender: TObject);
  private
    function GetPessoas(IdPessoa: String): TJSONArray;
    { Private declarations }
  public
    { Public declarations }
    function wkconecta(conect :boolean; var msgerro : string) : boolean;
    function wkAbreTransacao(var msgerro : string) : boolean;
    function wkComita(var msgerro : string) : boolean;
    function wkRollBack(var msgerro : string) : boolean;

    function wkGetPessoas(IdPessoa:String) : TJSONArray;
    function wkIncluiPessoa(JPessoa: TJSONArray) : TJSONArray;
    function wkAlteraPessoa(JPessoa: TJSONArray) : TJSONArray;
    function wkDeletaPessoa(IdPessoa:String) : Boolean;

//    function GetPessoa()


  end;

Type
  TPessoa = class
    private
      FIdPessoa   :Int64;
      Fflnatureza  :integer;
      Fdsdocumento :String;
      Fnmprimeiro  :String;
      Fnmsegundo   :String;
      Fdtregistro  :TDate;
    public
      property IdPessoa    : int64   read FIdPessoa     write FIdPessoa;
      property flnatureza  : integer read Fflnatureza   write Fflnatureza;
      property dsdocumento : String  read Fdsdocumento  write Fdsdocumento;
      property nmprimeiro  : String  read Fnmprimeiro   write Fnmprimeiro;
      property nmsegundo   : String  read Fnmsegundo    write Fnmsegundo;
      property dtregistro  : TDate   read Fdtregistro    write Fdtregistro;
 //     Destructor Destroy; override;
  end;
var
  Wk_Data: TWk_Data;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TWk_Data }


{ TWk_Data }

function TWk_Data.GetPessoas(IdPessoa:String): TJSONArray;
var msgerro : string;
    I : Integer;
    field_name,Columnname,ColumnValue : String;
    jsobj : TJsonObject;
    jsa : TJsonArray;
    jsp : TJsonPair;
begin

  if wkconecta(true,msgerro)then
  begin
    Wk_QryAux1.Close;
    Wk_QryAux1.SQL.Clear;
    Wk_QryAux1.SQL.Add('Select idpessoa, flnatureza, dsdocumento, ');
    Wk_QryAux1.SQL.Add('       nmprimeiro, nmsegundo,dtregistro ');
    Wk_QryAux1.SQL.Add('  From pessoal');

    if IdPessoa <> '' then
      Wk_QryAux1.SQL.Add(' where idpessoa = '+IdPessoa);

    Wk_QryAux1.Open;
    jsa := TJSONARRAY.Create;
    while not Wk_QryAux1.eof do
    begin
      for I := 0 to Wk_QryAux1.FieldDefs.Count-1 do
      begin
        ColumnName  := Wk_QryAux1.FieldDefs[I].Name;
        ColumnValue := Wk_QryAux1.FieldByName(ColumnName).AsString;
        jsobj.AddPair(TJSONPair.Create(TJSONString.Create( ColumnName),TJSONString.Create(ColumnValue)));
        jsa.AddElement(jsobj);
      end;
      Wk_QryAux1.Next;
    end;
    result :=  jsa;
  end
  else
  begin
    ColumnName  := 'Erro';
    ColumnValue := msgerro;
    jsobj.AddPair(TJSONPair.Create(TJSONString.Create( ColumnName),TJSONString.Create(ColumnValue)));
    jsa.AddElement(jsobj);
  end;
end;


procedure TWk_Data.TmCepsTimer(Sender: TObject);
begin
//
end;

function TWk_Data.wkAbreTransacao(var msgerro : string): boolean;
begin
  try
    if Wk_Connect.State = csDisconnected then
       wkconecta(true, msgerro);

    Wk_Connect.StartTransaction;

  except
    on E: Exception do
    begin
        IF msgErro = '' THEN
          msgErro := 'Ocorreu erro na tentativa de abrir a transação: '+ E.Message;
    end;
  end;
end;

function TWk_Data.wkAlteraPessoa(JPessoa: TJSONArray): TJSONArray;
var i : Integer;
    field_name,Columnname,ColumnValue : String;
    jsobj : TJsonObject;
    jsa : TJsonArray;
    jsp : TJsonPair;
    msgerro : String;
begin
  for i := 0 to JPessoa.Size - 1 do
  begin
    if wkconecta(True,msgerro) then
    begin
      try
        wkAbreTransacao(msgerro);
        Wk_QryAux1.close;
        Wk_QryAux1.sql.Clear;
        Wk_QryAux1.Sql.Add('update pessoal set flnatureza = '+
                            TJSONObject(JPessoa.Get(i)).Get('flnatureza').
                            JsonValue.AsType<String>);

        Wk_QryAux1.Sql.Add(' ,dsdocumento = '+
                                quotedstr(TJSONObject(JPessoa.Get(i)).
                                     Get('flnatureza').JsonValue.AsType<String>));

        Wk_QryAux1.Sql.Add(' ,nmprimeiro = '+
                                quotedstr(TJSONObject(JPessoa.Get(i)).
                                     Get('nmprimeiro').JsonValue.AsType<String>));

        Wk_QryAux1.Sql.Add(' ,nmsegundo = '+
                                quotedstr(TJSONObject(JPessoa.Get(i)).
                                     Get('nmsegundo').JsonValue.AsType<String>));

        Wk_QryAux1.Sql.Add(' ,dtregistro = '+
                                quotedstr(TJSONObject(JPessoa.Get(i)).
                                     Get('dtregistro').JsonValue.AsType<String>));

        Wk_QryAux1.Sql.Add(' where idpessoa = '+ TJSONObject(JPessoa.Get(i)).Get('idpessoa').
                            JsonValue.AsType<String>);

        Wk_QryAux1.ExecSQL;
        wkComita(msgerro);
        result := wkGetPessoas( TJSONObject(JPessoa.Get(i)).Get('idpessoa').
                            JsonValue.AsType<String>);
      except
        on E: Exception do
        begin
           ColumnName  := 'Erro';
           ColumnValue := E.Message;
           jsobj.AddPair(TJSONPair.Create(TJSONString.Create( ColumnName),TJSONString.Create(ColumnValue)));
           jsa.AddElement(jsobj);
           result := jsa;
        end;
      end;
    end
    else
    begin
      ColumnName  := 'Erro';
      ColumnValue := msgerro;
      jsobj.AddPair(TJSONPair.Create(TJSONString.Create( ColumnName),TJSONString.Create(ColumnValue)));
      jsa.AddElement(jsobj);
      result := jsa;
    end;

  end;

end;

function TWk_Data.wkComita(var msgerro: string): boolean;
begin
  try
    result := true;
    Wk_Connect.Commit;
  except
    on E: Exception do
    begin
      result := False;
      msgerro := 'Ocorreu erro na tentativa de comitar os dados: '+ E.Message;
    end;
  end;
end;

function TWk_Data.wkconecta(conect: boolean; var msgerro: string): boolean;
begin

  try
    result := true;
    Wk_Connect.Connected := conect;
  except
    on E: Exception do
    begin
      result := False;
      if conect then
        msgErro := 'Ocorreu erro na tentativa de conexão: '+ E.Message
      else
        msgErro := 'Banco não foi desconectado';

    end;
  end;

end;

function TWk_Data.wkDeletaPessoa(IdPessoa: String): Boolean;
 var
    field_name,Columnname,ColumnValue : String;
    jsobj : TJsonObject;
    jsa : TJsonArray;
    jsp : TJsonPair;
    msgerro : String;
begin
  if wkconecta(True,msgerro) then
  begin
    try
      wkAbreTransacao(msgerro);
      Wk_QryAux1.close;
      Wk_QryAux1.sql.Clear;
      Wk_QryAux1.Sql.Add(' delete from endereco ');
      Wk_QryAux1.Sql.Add(' where idpessoa = '+ IdPessoa);

      Wk_QryAux1.ExecSQL;

      Wk_QryAux1.close;
      Wk_QryAux1.sql.Clear;
      Wk_QryAux1.Sql.Add(' delete from pessoal ');
      Wk_QryAux1.Sql.Add(' where idpessoa = '+ IdPessoa);

      Wk_QryAux1.ExecSQL;


      wkComita(msgerro);

      result := True;
    except
      on E: Exception do
      begin
         Result := False;
         ColumnName  := 'Erro';
         ColumnValue := E.Message;
        
      end;
    end;
  end;
end;

function TWk_Data.wkGetPessoas(IdPessoa: String): TJSONArray;
begin

end;

function TWk_Data.wkIncluiPessoa(JPessoa: TJSONArray): TJSONArray;
var i : Integer;
    field_name,Columnname,ColumnValue : String;
    jsobj : TJsonObject;
    jsa : TJsonArray;
    jsp : TJsonPair;
    msgerro : String;
    sIDPessoa :String;
begin
  for i := 0 to JPessoa.Size - 1 do
  begin
    if wkconecta(True,msgerro) then
    begin
      try
        wkAbreTransacao(msgerro);
        Wk_QryAux1.close;
        Wk_QryAux1.sql.Clear;
        Wk_QryAux1.Sql.Add('insert into pessoal (flnatureza,dsdocumento,nmprimeiro');
        Wk_QryAux1.Sql.Add('                    ,nmsegundo,dtregistro) values (');

        Wk_QryAux1.Sql.Add(TJSONObject(JPessoa.Get(i)).Get('flnatureza').
                            JsonValue.AsType<String>+',');

        Wk_QryAux1.Sql.Add(quotedstr(TJSONObject(JPessoa.Get(i)).
                                 Get('dsdocumento').JsonValue.AsType<String>));

        Wk_QryAux1.Sql.Add(quotedstr(TJSONObject(JPessoa.Get(i)).
                                 Get('nmprimeiro').JsonValue.AsType<String>));

        Wk_QryAux1.Sql.Add(quotedstr(TJSONObject(JPessoa.Get(i)).
                                 Get('nmsegundo').JsonValue.AsType<String>));

        Wk_QryAux1.Sql.Add(quotedstr(TJSONObject(JPessoa.Get(i)).
                                 Get('dtregistro').JsonValue.AsType<String>));

        Wk_QryAux1.Sql.Add(' returning id_pessoa ');
        Wk_QryAux1.ExecSQL;

        wkComita(msgerro);
        sIDPessoa := Wk_QryAux1.FieldByName('id_pessoa').AsString;
        result := wkGetPessoas(sIDPessoa);
      except
        on E: Exception do
        begin
           ColumnName  := 'Erro';
           ColumnValue := E.Message;
           jsobj.AddPair(TJSONPair.Create(TJSONString.Create( ColumnName),TJSONString.Create(ColumnValue)));
           jsa.AddElement(jsobj);
           result := jsa;
        end;
      end;
    end
    else
    begin
      ColumnName  := 'Erro';
      ColumnValue := msgerro;
      jsobj.AddPair(TJSONPair.Create(TJSONString.Create( ColumnName),TJSONString.Create(ColumnValue)));
      jsa.AddElement(jsobj);
      result := jsa;
    end;

  end;

end;

function TWk_Data.wkRollBack(var msgerro: string): boolean;
begin
  try
    result := true;
    Wk_Connect.Rollback;
  except
    on E: Exception do
    begin
      result := False;
      msgerro := 'Ocorreu erro na tentativa de realizar o rollback: '+ E.Message;
    end;
  end;

end;

{ TCliente }


end.
