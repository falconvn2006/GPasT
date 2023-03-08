unit Control.Pessoa;

interface

uses Classes, SysUtils, DAO.DM, Model.Pessoa, FireDAC.Comp.Client, DBClient, DB,
  FireDAC.Stan.Param, Vcl.ComCtrls, Model.Endereco, Control.Endereco.Integracao,
  Model.Endereco.Integracao;

type
  TCtrlPessoa = class(TObject)
  private
    DM: TDM;
    function GerarID: Integer;
    function TabelaExiste: Boolean;
  public
    Barra: TProgressBar;
    constructor Create;

    procedure CriarTabela;
    function Inserir(Pessoa: TPessoa; Endereco: TEndereco): Integer;
    procedure Alterar(Pessoa: TPessoa; Endereco: TEndereco;
      Integracao: TEnderecoIntegracao);
    procedure Excluir(idPessoa: Integer);
    procedure Pesquisar(ChaveBusca: string; CD: TClientDataSet);
    procedure CarregarDados(ID: Integer; Pessoa: TPessoa);
  end;

implementation

uses Forms, Control.Endereco;

{ TCtrlPessoa }

constructor TCtrlPessoa.Create;
begin
  Self.DM := TDM.oDM;
  if (not TabelaExiste) then
  begin
    CriarTabela;
  end;
end;

procedure TCtrlPessoa.CriarTabela;
var
  Qry: TFDQuery;
  MsgErro: string;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := DM.Conexao;
    Qry.Connection.Commit;
    Qry.SQL.Clear;
    Qry.SQL.ADD(' CREATE TABLE PESSOA (                                  ');
    Qry.SQL.ADD('     IDPESSOA     BIGINT NOT NULL,                      ');
    Qry.SQL.ADD('     FLNATUREZA   INTEGER NOT NULL,                     ');
    Qry.SQL.ADD('     DSDOCUMENTO  VARCHAR(20) NOT NULL,                 ');
    Qry.SQL.ADD('     NMPRIMEIRO   VARCHAR(100) NOT NULL,                ');
    Qry.SQL.ADD('     NMSEGUNDO    VARCHAR(100) NOT NULL,                ');
    Qry.SQL.ADD('     DTREGISTRO   DATE DEFAULT NULL,                    ');
    Qry.SQL.ADD('     CONSTRAINT PESSOA_PK PRIMARY KEY (IDPESSOA)        ');
    Qry.SQL.ADD(' );                                                     ');
    try
      Qry.Prepare;
      Qry.ExecSQL;
    except
      on E: Exception do
      begin
        MsgErro := 'Criar Automaticamente Tabela [PESSOA] Falhou:';
        raise Exception.Create(MsgErro + #13 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

function TCtrlPessoa.GerarID: Integer;
var
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := DM.Conexao;
    Qry.Connection.Commit;
    Qry.SQL.Clear;
    Qry.SQL.ADD(' SELECT                                        ');
    Qry.SQL.ADD('    (COALESCE(MAX(IDPESSOA),0) + 1) AS NOVOID  ');
    Qry.SQL.ADD(' FROM PESSOA;                                  ');
    try
      Qry.Prepare;
      Qry.Open;
      Result := Qry.FieldByName('NOVOID').AsInteger;
    except
      on E: Exception do
      begin
        raise Exception.Create('ERRO AO GERAR NOVO ID');
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

function TCtrlPessoa.Inserir(Pessoa: TPessoa; Endereco: TEndereco): Integer;
var
  MsgErro: string;
  Qry: TFDQuery;
  MotorEndereco: TCtrlEndereco;
begin
  Qry := TFDQuery.Create(nil);
  MotorEndereco := TCtrlEndereco.Create;
  try
    with Qry do
    begin
      Connection := DM.Conexao;
      Connection.StartTransaction;
      SQL.Clear;
      SQL.ADD(' INSERT INTO PESSOA (      ');
      SQL.ADD('     IDPESSOA,             ');
      SQL.ADD('     FLNATUREZA,           ');
      SQL.ADD('     DSDOCUMENTO,          ');
      SQL.ADD('     NMPRIMEIRO,           ');
      SQL.ADD('     NMSEGUNDO,            ');
      SQL.ADD('     DTREGISTRO            ');
      SQL.ADD(' ) VALUES (                ');
      SQL.ADD('     :IDPESSOA,            ');
      SQL.ADD('     :FLNATUREZA,          ');
      SQL.ADD('     :DSDOCUMENTO,         ');
      SQL.ADD('     UPPER(:NMPRIMEIRO),   ');
      SQL.ADD('     UPPER(:NMSEGUNDO),    ');
      SQL.ADD('     :DTREGISTRO           ');
      SQL.ADD(' );                        ');

      Pessoa.idPessoa := GerarID;
      ParamByName('IDPESSOA').AsInteger := Pessoa.idPessoa;
      ParamByName('FLNATUREZA').AsInteger := Pessoa.FlNatureza;
      ParamByName('DSDOCUMENTO').AsString := Pessoa.DsDocumento;
      ParamByName('NMPRIMEIRO').AsString := Pessoa.NmPrimeiro;
      ParamByName('NMSEGUNDO').AsString := Pessoa.NmSegundo;
      ParamByName('DTREGISTRO').AsDate := Pessoa.DtRegistro;

      Endereco.idPessoa := Pessoa.idPessoa;
      // if (Endereco.DsCEP = EmptyStr) then
      // Endereco.DsCEP := '13.560-280'; { CEP PADRAO SAO CARLOS }
      try
        Prepare;
        ExecSQL;
        Connection.Commit;
        { PRIMEIRO ENDEREÇO OBRIGATORIO }
        MotorEndereco.Inserir(Endereco);

      except
        on E: Exception do
        begin
          MsgErro := 'NÃO FOI POSSÍVEL INSERIR OS DADOS:';
          Connection.Rollback;
          raise Exception.Create(MsgErro + sLineBreak + E.Message);
        end;
      end;
    end;
  finally
    FreeAndNil(Qry);
    FreeAndNil(MotorEndereco);
  end;
  Result := Pessoa.idPessoa;
end;

procedure TCtrlPessoa.Alterar(Pessoa: TPessoa; Endereco: TEndereco;
  Integracao: TEnderecoIntegracao);
var
  MsgErro: string;
  Qry: TFDQuery;
  MotorEndereco: TCtrlEndereco;
begin
  Qry := TFDQuery.Create(nil);
  MotorEndereco := TCtrlEndereco.Create;
  try
    with Qry do
    begin
      Connection := DM.Conexao;
      Connection.StartTransaction;
      SQL.Clear;
      SQL.ADD(' UPDATE  PESSOA SET              ');
      SQL.ADD('     FLNATUREZA = :FLNATUREZA,   ');
      SQL.ADD('     DSDOCUMENTO = :DSDOCUMENTO, ');
      SQL.ADD('     NMPRIMEIRO = :NMPRIMEIRO,   ');
      SQL.ADD('     NMSEGUNDO = :NMSEGUNDO,     ');
      SQL.ADD('     DTREGISTRO = :DTREGISTRO    ');
      SQL.ADD(' WHERE                           ');
      SQL.ADD('     (IDPESSOA = :IDPESSOA)      ');
      SQL.ADD(' ;                               ');
      ParamByName('IDPESSOA').AsInteger := Pessoa.idPessoa;
      ParamByName('FLNATUREZA').AsInteger := Pessoa.FlNatureza;
      ParamByName('DSDOCUMENTO').AsString := Pessoa.DsDocumento;
      ParamByName('NMPRIMEIRO').AsString := Pessoa.NmPrimeiro;
      ParamByName('NMSEGUNDO').AsString := Pessoa.NmSegundo;
      ParamByName('DTREGISTRO').AsDate := Pessoa.DtRegistro;
      try
        Prepare;
        ExecSQL;
        Connection.Commit;

        MotorEndereco.Alterar(Endereco, Integracao);
      except
        on E: Exception do
        begin
          MsgErro := 'NÃO FOI POSSÍVEL ALTERAR OS DADOS:';
          Connection.Rollback;
          raise Exception.Create(MsgErro + sLineBreak + E.Message);
        end;
      end;
    end;
  finally
    FreeAndNil(Qry);
    FreeAndNil(MotorEndereco);
  end;
end;

procedure TCtrlPessoa.Excluir(idPessoa: Integer);
var
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    with Qry do
    begin
      Connection := DM.Conexao;
      Connection.StartTransaction;
      SQL.Clear;
      SQL.ADD(' DELETE FROM PESSOA WHERE (IDPESSOA = :IDPESSOA); ');
      ParamByName('IDPESSOA').AsInteger := idPessoa;
      try
        Prepare;
        ExecSQL;
        Connection.Commit;
      except
        on E: Exception do
        begin
          Connection.Rollback;
          raise Exception.Create('NÃO POSSÍVEL ECLUIR:' + #13 + E.Message);
        end;
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

procedure TCtrlPessoa.CarregarDados(ID: Integer; Pessoa: TPessoa);
var
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    with Qry do
    begin
      Connection := DM.Conexao;
      Connection.Commit;
      SQL.Clear;
      SQL.ADD(' SELECT                              ');
      SQL.ADD('     IDPESSOA,                       ');
      SQL.ADD('     FLNATUREZA,                     ');
      SQL.ADD('     DSDOCUMENTO,                    ');
      SQL.ADD('     NMPRIMEIRO,                     ');
      SQL.ADD('     NMSEGUNDO,                      ');
      SQL.ADD('     DTREGISTRO                      ');
      SQL.ADD(' FROM                                ');
      SQL.ADD('     PESSOA                          ');
      SQL.ADD(' WHERE                               ');
      SQL.ADD('     (IDPESSOA = :IDPESSOA)          ');
      SQL.ADD(' ORDER BY IDPESSOA;                  ');
      ParamByName('IDPESSOA').AsInteger := ID;

      try
        Qry.Prepare;
        Qry.Open;
      except
        on E: Exception do
        begin
          raise Exception.Create('ERRO AO CARREGAR DADOS' + sLineBreak +
            E.Message);
        end;
      end;

      Pessoa.idPessoa := FieldByName('IDPESSOA').AsInteger;
      Pessoa.FlNatureza := FieldByName('FLNATUREZA').AsInteger;
      Pessoa.DsDocumento := FieldByName('DSDOCUMENTO').AsString;
      Pessoa.NmPrimeiro := FieldByName('NMPRIMEIRO').AsString;
      Pessoa.NmSegundo := FieldByName('NMSEGUNDO').AsString;
      Pessoa.DtRegistro := FieldByName('DTREGISTRO').AsDateTime;
    end;
  finally
    FreeAndNil(Qry);
  end;

end;

procedure TCtrlPessoa.Pesquisar(ChaveBusca: string; CD: TClientDataSet);
var
  Qry: TFDQuery;
  Pessoa: TPessoa;
begin
  Qry := TFDQuery.Create(nil);

  Pessoa := TPessoa.Create;
  try
    with Qry do
    begin
      Connection := DM.Conexao;
      Connection.Commit;
      SQL.Clear;
      SQL.ADD(' SELECT                                              ');
      SQL.ADD('     IDPESSOA,                                       ');
      SQL.ADD('     FLNATUREZA,                                     ');
      SQL.ADD('     DSDOCUMENTO,                                    ');
      SQL.ADD('     NMPRIMEIRO,                                     ');
      SQL.ADD('     NMSEGUNDO,                                      ');
      SQL.ADD('     DTREGISTRO                                      ');
      SQL.ADD(' FROM                                                ');
      SQL.ADD('     PESSOA                                          ');
      SQL.ADD(' WHERE                                               ');
      SQL.ADD('     (IDPESSOA) = (:IDPESSOA)                        ');
      SQL.ADD('     OR (DSDOCUMENTO = :DSDOCUMENTO)                 ');
      SQL.ADD('     OR (UPPER(NMPRIMEIRO) LIKE UPPER(:NMPRIMEIRO))  ');
      SQL.ADD('     OR (UPPER(NMSEGUNDO) LIKE UPPER(:NMSEGUNDO))    ');
      SQL.ADD(' ORDER BY IDPESSOA;                                  ');
      ParamByName('IDPESSOA').AsInteger := StrToIntDef(ChaveBusca, -1);
      ParamByName('DSDOCUMENTO').AsString := ChaveBusca;
      ParamByName('NMPRIMEIRO').AsString := '%' + ChaveBusca + '%';
      ParamByName('NMSEGUNDO').AsString := '%' + ChaveBusca + '%';

      try
        Qry.Prepare;
        Qry.Open;
        Qry.DisableControls;
      except
        on E: Exception do
        begin
          raise Exception.Create('ERRO AO PESQUISAR' + sLineBreak + E.Message);
        end;
      end;

      Qry.Last;
      Qry.First;

      CD.Close;
      CD.FieldDefs.Clear;
      CD.FieldDefs.ADD('IDPESSOA', ftInteger);
      CD.FieldDefs.ADD('FLNATUREZA', ftInteger);
      CD.FieldDefs.ADD('DSDOCUMENTO', ftString, 20);
      CD.FieldDefs.ADD('NMPRIMEIRO', ftString, 100);
      CD.FieldDefs.ADD('NMSEGUNDO', ftString, 100);
      CD.FieldDefs.ADD('DTREGISTRO', ftDate);
      CD.CreateDataSet;

      CD.FieldByName('IDPESSOA').Visible := False;
      CD.FieldByName('FLNATUREZA').Visible := False;
      CD.FieldByName('NMPRIMEIRO').DisplayWidth := 30;
      CD.FieldByName('NMSEGUNDO').DisplayWidth := 30;
      CD.FieldByName('DSDOCUMENTO').DisplayLabel := 'DS DOCUMENTO';
      CD.FieldByName('NMPRIMEIRO').DisplayLabel := 'PRIMEIRO NOME';
      CD.FieldByName('NMSEGUNDO').DisplayLabel := 'SEGUNDO NOME';
      CD.FieldByName('DTREGISTRO').DisplayLabel := 'DATA DE REGISTRO';

      CD.Open;
      CD.DisableControls;

      if (Assigned(Barra)) then
      begin
        Barra.Position := 1;
        Barra.Max := Qry.RecordCount;
      end;

      while (not(Qry.Eof)) do
      begin
        with Pessoa do
        begin
          idPessoa := Qry.FieldByName('IDPESSOA').AsInteger;
          FlNatureza := Qry.FieldByName('FLNATUREZA').AsInteger;
          DsDocumento := Qry.FieldByName('DSDOCUMENTO').AsString;
          NmPrimeiro := Qry.FieldByName('NMPRIMEIRO').AsString;
          NmSegundo := Qry.FieldByName('NMSEGUNDO').AsString;
          DtRegistro := Qry.FieldByName('DTREGISTRO').AsDateTime;

          CD.Append;
          CD.FieldByName('IDPESSOA').AsInteger := idPessoa;
          CD.FieldByName('FLNATUREZA').AsInteger := FlNatureza;
          CD.FieldByName('DSDOCUMENTO').AsString := DsDocumento;
          CD.FieldByName('NMPRIMEIRO').AsString := NmPrimeiro;
          CD.FieldByName('NMSEGUNDO').AsString := NmSegundo;
          CD.FieldByName('DTREGISTRO').AsDateTime := DtRegistro;
          CD.Post;

          Qry.Next;

          if (Assigned(Barra)) then
          begin
            Barra.Position := Barra.Position + 1;
            Application.ProcessMessages;
          end;
        end;
      end;
      CD.First;
      CD.EnableControls;
    end;
  finally
    FreeAndNil(Qry);
    FreeAndNil(Pessoa);
  end;
end;

function TCtrlPessoa.TabelaExiste: Boolean;
var
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := DM.Conexao;
    Qry.Connection.Commit;
    Qry.SQL.Clear;
    Qry.SQL.ADD(' SELECT COUNT(*) AS QTDE                        ');
    Qry.SQL.ADD(' FROM RDB$RELATIONS                             ');
    Qry.SQL.ADD(' WHERE RDB$FLAGS = 1                            ');
    Qry.SQL.ADD(' AND UPPER(RDB$RELATION_NAME) = UPPER(:TABELA)  ');
    Qry.ParamByName('TABELA').AsString := 'PESSOA';
    Qry.Prepare;
    Qry.Open;

    Result := (Qry.FieldByName('QTDE').AsInteger > 0);
  finally
    FreeAndNil(Qry);
  end;
end;

end.
