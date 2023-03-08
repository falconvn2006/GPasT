unit Control.Endereco;

interface

uses Classes, SysUtils, DAO.DM, FireDAC.Comp.Client, DBClient, DB, Forms,
  FireDAC.Stan.Param, Vcl.ComCtrls, Model.Endereco, Model.Endereco.Integracao;

type
  TCtrlEndereco = class(TObject)
  private
    DM: TDM;
    function GerarID: Integer;
    function TabelaExiste: Boolean;
  public
    Barra: TProgressBar;
    constructor Create;

    procedure CriarTabela;
    function Inserir(Endereco: TEndereco): Integer;
    procedure Alterar(Endereco: TEndereco; Integracao: TEnderecoIntegracao);
    procedure Excluir(idEndereco: Integer);
    procedure Pesquisar(idPessoa: Integer; CD: TClientDataSet);
    procedure CarregarDados(idEndereco: Integer; Endereco: TEndereco);
  end;

implementation

{ TCtrlEndereco }

uses Control.Endereco.Integracao;

procedure TCtrlEndereco.Alterar(Endereco: TEndereco;
  Integracao: TEnderecoIntegracao);
var
  MsgErro: string;
  Qry: TFDQuery;
  MotorIntegracao: TCtrlIntegracao;
begin
  Qry := TFDQuery.Create(nil);
  MotorIntegracao := TCtrlIntegracao.Create;
  try
    with Qry do
    begin
      Connection := DM.Conexao;
      Connection.StartTransaction;
      SQL.Clear;
      SQL.ADD(' UPDATE ENDERECO SET                          ');
      SQL.ADD('    IDENDERECO = :IDENDERECO,                ');
      SQL.ADD('    IDPESSOA = :IDPESSOA,                    ');
      SQL.ADD('    DSCEP = :DSCEP                           ');
      SQL.ADD(' WHERE                                       ');
      SQL.ADD('     (IDENDERECO = :IDENDERECO)              ');
      SQL.ADD(' ;                                           ');
      ParamByName('IDENDERECO').AsInteger := Endereco.idEndereco;
      ParamByName('IDPESSOA').AsInteger := Endereco.idPessoa;
      ParamByName('DSCEP').AsString := Endereco.DsCEP;
      try
        Prepare;
        ExecSQL;
        Connection.Commit;

        MotorIntegracao.Alterar(Integracao);

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
    FreeAndNil(MotorIntegracao);
  end;
end;

procedure TCtrlEndereco.CarregarDados(idEndereco: Integer; Endereco: TEndereco);
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
      SQL.ADD(' SELECT                                              ');
      SQL.ADD('    IDENDERECO ,                                     ');
      SQL.ADD('    IDPESSOA,                                        ');
      SQL.ADD('    DSCEP                                            ');
      SQL.ADD(' FROM                                                ');
      SQL.ADD('     ENDERECO                                        ');
      SQL.ADD(' WHERE                                               ');
      SQL.ADD('     (IDENDERECO = :IDENDERECO)                      ');
      SQL.ADD(' ORDER BY IDENDERECO;                                ');
      ParamByName('IDENDERECO').AsInteger := idEndereco;
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

      Endereco.idEndereco := FieldByName('IDENDERECO').AsInteger;
      Endereco.idPessoa := FieldByName('IDPESSOA').AsInteger;
      Endereco.DsCEP := FieldByName('DSCEP').AsString
    end;
  finally
    FreeAndNil(Qry);
  end;

end;

constructor TCtrlEndereco.Create;
begin
  Self.DM := TDM.oDM;
  if (not TabelaExiste) then
  begin
    CriarTabela;
  end;
end;

procedure TCtrlEndereco.CriarTabela;
var
  Qry: TFDQuery;
  MsgErro: string;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := DM.Conexao;
    Qry.Connection.Commit;
    Qry.SQL.Clear;
    Qry.SQL.ADD(' CREATE TABLE ENDERECO (                                    ');
    Qry.SQL.ADD('     IDENDERECO BIGINT NOT NULL,                            ');
    Qry.SQL.ADD('     IDPESSOA BIGINT NOT NULL,                              ');
    Qry.SQL.ADD('     DSCEP VARCHAR(15) DEFAULT NULL,                        ');
    Qry.SQL.ADD('     CONSTRAINT ENDERECO_PK PRIMARY KEY (IDENDERECO),       ');
    Qry.SQL.ADD('     CONSTRAINT ENDERECO_FK_PESSOA FOREIGN KEY (IDPESSOA)   ');
    Qry.SQL.ADD('             REFERENCES PESSOA(IDPESSOA) ON DELETE CASCADE  ');
    Qry.SQL.ADD('     );                                                     ');
    try
      Qry.Prepare;
      Qry.ExecSQL;
    except
      on E: Exception do
      begin
        MsgErro := 'Criar Automaticamente Tabela [ENDERECO] Falhou:';
        raise Exception.Create(MsgErro + #13 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

procedure TCtrlEndereco.Excluir(idEndereco: Integer);
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
      SQL.ADD(' DELETE FROM ENDERECO WHERE (IDENDERECO = :IDENDERECO); ');
      ParamByName('IDENDERECO').AsInteger := idEndereco;
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

function TCtrlEndereco.GerarID: Integer;
var
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := DM.Conexao;
    Qry.Connection.Commit;
    Qry.SQL.Clear;
    Qry.SQL.ADD(' SELECT                                            ');
    Qry.SQL.ADD('    (COALESCE(MAX(IDENDERECO),0) + 1) AS NOVOID    ');
    Qry.SQL.ADD(' FROM ENDERECO;                                    ');
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

function TCtrlEndereco.Inserir(Endereco: TEndereco): Integer;
var
  MsgErro: string;
  Qry: TFDQuery;
  MotorIntegracao: TCtrlIntegracao;
  Integracao: TEnderecoIntegracao;
begin
  Qry := TFDQuery.Create(nil);
  MotorIntegracao := TCtrlIntegracao.Create;
  Integracao := TEnderecoIntegracao.Create;
  try
    with Qry do
    begin
      Connection := DM.Conexao;
      Connection.StartTransaction;
      SQL.Clear;
      SQL.ADD(' INSERT INTO ENDERECO (   ');
      SQL.ADD('    IDENDERECO ,          ');
      SQL.ADD('    IDPESSOA,             ');
      SQL.ADD('    DSCEP                 ');
      SQL.ADD(' ) VALUES (               ');
      SQL.ADD('    :IDENDERECO ,         ');
      SQL.ADD('    :IDPESSOA,            ');
      SQL.ADD('    :DSCEP                ');
      SQL.ADD(' );                       ');
      Endereco.idEndereco := GerarID;
      ParamByName('IDENDERECO').AsInteger := Endereco.idEndereco;
      ParamByName('IDPESSOA').AsInteger := Endereco.idPessoa;
      ParamByName('DSCEP').AsString := Endereco.DsCEP;
      try
        Prepare;
        ExecSQL;
        Connection.Commit;

        Integracao.idEndereco := Endereco.idEndereco;

        MotorIntegracao.Inserir(Integracao);

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
    FreeAndNil(MotorIntegracao);
    FreeAndNil(Integracao);
  end;
  Result := Endereco.idEndereco;
end;

procedure TCtrlEndereco.Pesquisar(idPessoa: Integer; CD: TClientDataSet);
var
  Qry: TFDQuery;
  Endereco: TEndereco;
  Integracao: TEnderecoIntegracao;
begin
  Qry := TFDQuery.Create(nil);
  Endereco := TEndereco.Create;
  Integracao := TEnderecoIntegracao.Create;
  try
    with Qry do
    begin
      Connection := DM.Conexao;
      Connection.Commit;
      SQL.Clear;
      SQL.ADD(' SELECT                                  ');
      SQL.ADD('     E.IDPESSOA,                         ');
      SQL.ADD('     E.DSCEP,                            ');
      SQL.ADD('     I.IDENDERECO,                       ');
      SQL.ADD('     I.DSUF,                             ');
      SQL.ADD('     I.NMCIDADE,                         ');
      SQL.ADD('     I.NMBAIRRO,                         ');
      SQL.ADD('     I.NMLOGRADOURO,                     ');
      SQL.ADD('     I.DSCOMPLEMENTO                     ');
      SQL.ADD(' FROM                                    ');
      SQL.ADD('     ENDERECO E                          ');
      SQL.ADD('       /*  INNER JOIN */                 ');
      SQL.ADD('         LEFT  JOIN                      ');
      SQL.ADD('     ENDERECO_INTEGRACAO  I              ');
      SQL.ADD('       ON (E.IDENDERECO = I.IDENDERECO)  ');
      SQL.ADD(' WHERE                                   ');
      SQL.ADD('     (E.IDPESSOA = :IDPESSOA)            ');
      SQL.ADD(' ORDER BY IDENDERECO;                    ');
      ParamByName('IDPESSOA').AsInteger := idPessoa;
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
      CD.FieldDefs.ADD('DSCEP', ftString, 15);
      CD.FieldDefs.ADD('IDENDERECO', ftInteger);
      CD.FieldDefs.ADD('DSUF', ftString, 50);
      CD.FieldDefs.ADD('NMCIDADE', ftString, 100);
      CD.FieldDefs.ADD('NMBAIRRO', ftString, 50);
      CD.FieldDefs.ADD('NMLOGRADOURO', ftString, 100);
      CD.FieldDefs.ADD('DSCOMPLEMENTO', ftString, 100);
      CD.CreateDataSet;

      CD.FieldByName('IDPESSOA').Visible := False;
      CD.FieldByName('IDENDERECO').Visible := False;
      CD.FieldByName('DSCOMPLEMENTO').Visible := False;
      CD.FieldByName('DSCEP').DisplayWidth := 16;
      CD.FieldByName('DSUF').DisplayWidth := 30;
      CD.FieldByName('NMCIDADE').DisplayWidth := 30;
      CD.FieldByName('NMBAIRRO').DisplayWidth := 30;
      CD.FieldByName('NMLOGRADOURO').DisplayWidth := 30;
      CD.FieldByName('DSCEP').DisplayLabel := 'CEP';
      CD.FieldByName('NMCIDADE').DisplayLabel := 'CIDADE';
      CD.FieldByName('NMBAIRRO').DisplayLabel := 'BAIRRO';
      CD.FieldByName('NMLOGRADOURO').DisplayLabel := 'LOGRADOURO';

      CD.Open;
      CD.DisableControls;

      if (Assigned(Barra)) then
      begin
        Barra.Position := 1;
        Barra.Max := Qry.RecordCount;
      end;

      while (not(Qry.Eof)) do
      begin
        with Endereco, Integracao do
        begin
          Endereco.idEndereco := Qry.FieldByName('IDENDERECO').AsInteger;
          idPessoa := Qry.FieldByName('IDPESSOA').AsInteger;
          DsCEP := Qry.FieldByName('DSCEP').AsString;
          DsUF := Qry.FieldByName('DSUF').AsString;
          NmCidade := Qry.FieldByName('NMCIDADE').AsString;
          NmBairro := Qry.FieldByName('NMBAIRRO').AsString;
          NmLogradouro := Qry.FieldByName('NMLOGRADOURO').AsString;
          DsComplemento := Qry.FieldByName('DSCOMPLEMENTO').AsString;

          CD.Append;
          CD.FieldByName('IDENDERECO').AsInteger := Endereco.idEndereco;
          CD.FieldByName('IDPESSOA').AsInteger := idPessoa;
          CD.FieldByName('DSCEP').AsString := DsCEP;
          CD.FieldByName('DSUF').AsString := DsUF;
          CD.FieldByName('NMCIDADE').AsString := NmCidade;
          CD.FieldByName('NMBAIRRO').AsString := NmBairro;
          CD.FieldByName('NMLOGRADOURO').AsString := NmLogradouro;
          CD.FieldByName('DSCOMPLEMENTO').AsString := DsComplemento;
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
    FreeAndNil(Endereco);
    FreeAndNil(Integracao);
  end;
end;

function TCtrlEndereco.TabelaExiste: Boolean;
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
    Qry.ParamByName('TABELA').AsString := 'ENDERECO';
    Qry.Prepare;
    Qry.Open;

    Result := (Qry.FieldByName('QTDE').AsInteger > 0);
  finally
    FreeAndNil(Qry);
  end;
end;

end.
