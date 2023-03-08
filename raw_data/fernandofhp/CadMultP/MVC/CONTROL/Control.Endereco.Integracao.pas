unit Control.Endereco.Integracao;

interface

uses Classes, SysUtils, DAO.DM, Model.Endereco.Integracao, FireDAC.Comp.Client,
  DBClient, DB, FireDAC.Stan.Param, Vcl.ComCtrls;

type

  TCtrlIntegracao = class(TObject)
  private
    DM: TDM;
    function TabelaExiste: Boolean;
  public
    Barra: TProgressBar;
    constructor Create;
    procedure CriarTabela;
    function Inserir(Integracao: TEnderecoIntegracao): Integer;
    procedure Alterar(Integracao: TEnderecoIntegracao);
    procedure CarregarDados(idEndereco: Integer;
      Integracao: TEnderecoIntegracao);
  end;

implementation

{ TCtrlIntegracao }

procedure TCtrlIntegracao.Alterar(Integracao: TEnderecoIntegracao);
var
  MsgErro: string;
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    with Qry do
    begin
      Connection := DM.Conexao;
      Connection.StartTransaction;
      SQL.Clear;
      SQL.ADD(' UPDATE ENDERECO_INTEGRACAO SET          ');
      SQL.ADD('    DSUF = :DSUF,                        ');
      SQL.ADD('    NMCIDADE = :NMCIDADE,                ');
      SQL.ADD('    NMBAIRRO = :NMBAIRRO,                ');
      SQL.ADD('    NMLOGRADOURO = :NMLOGRADOURO,        ');
      SQL.ADD('    DSCOMPLEMENTO = :DSCOMPLEMENTO       ');
      SQL.ADD(' WHERE                                   ');
      SQL.ADD('     (IDENDERECO = :IDENDERECO)          ');
      SQL.ADD(' ;                                       ');
      ParamByName('IDENDERECO').AsInteger := Integracao.idEndereco;
      ParamByName('DSUF').AsString := Integracao.DsUF;
      ParamByName('NMCIDADE').AsString := Integracao.NmCidade;
      ParamByName('NMBAIRRO').AsString := Integracao.NmBairro;
      ParamByName('NMLOGRADOURO').AsString := Integracao.NmLogradouro;
      ParamByName('DSCOMPLEMENTO').AsString := Integracao.DsComplemento;
      try
        Prepare;
        ExecSQL;
        Connection.Commit;
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
  end;
end;

procedure TCtrlIntegracao.CarregarDados(idEndereco: Integer;
  Integracao: TEnderecoIntegracao);
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
      SQL.ADD('    IDENDERECO,                                      ');
      SQL.ADD('    DSUF ,                                           ');
      SQL.ADD('    NMCIDADE,                                        ');
      SQL.ADD('    NMBAIRRO,                                        ');
      SQL.ADD('    NMLOGRADOURO,                                    ');
      SQL.ADD('    DSCOMPLEMENTO                                    ');
      SQL.ADD(' FROM                                                ');
      SQL.ADD('     ENDERECO_INTEGRACAO                             ');
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

      Integracao.idEndereco := FieldByName('IDENDERECO').AsInteger;
    end;
  finally
    FreeAndNil(Qry);
  end;

end;

constructor TCtrlIntegracao.Create;
begin
  Self.DM := TDM.oDM;
  if (not TabelaExiste) then
  begin
    CriarTabela;
  end;
end;

procedure TCtrlIntegracao.CriarTabela;
var
  Qry: TFDQuery;
  MsgErro: string;
begin
  Qry := TFDQuery.Create(nil);
  try
    with Qry do
    begin
      Connection := DM.Conexao;
      Connection.Commit;
      SQL.Clear;
      SQL.ADD(' CREATE TABLE ENDERECO_INTEGRACAO (                         ');
      SQL.ADD('     IDENDERECO BIGINT NOT NULL,                            ');
      SQL.ADD('     DSUF VARCHAR(50) DEFAULT NULL,                         ');
      SQL.ADD('     NMCIDADE VARCHAR(100) DEFAULT NULL,                    ');
      SQL.ADD('     NMBAIRRO VARCHAR(50) DEFAULT NULL,                     ');
      SQL.ADD('     NMLOGRADOURO VARCHAR(100) DEFAULT NULL,                ');
      SQL.ADD('     DSCOMPLEMENTO VARCHAR (100) DEFAULT NULL,              ');
      SQL.ADD('     CONSTRAINT ENDERECOINTEGRACAO_PK                       ');
      SQL.ADD('          PRIMARY KEY (IDENDERECO),                         ');
      SQL.ADD('     CONSTRAINT ENDERECOINTEGRACAO_FK_ENDERECO              ');
      SQL.ADD('          FOREIGN KEY (IDENDERECO)                          ');
      SQL.ADD('          REFERENCES ENDERECO(IDENDERECO) ON DELETE CASCADE ');
      SQL.ADD(' );                                                         ');
    end;
    try
      Qry.Prepare;
      Qry.ExecSQL;
    except
      on E: Exception do
      begin
        MsgErro := 'Criar Automaticamente Tabela [ENDERECO_INTEGRACAO] Falhou:';
        raise Exception.Create(MsgErro + #13 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

function TCtrlIntegracao.Inserir(Integracao: TEnderecoIntegracao): Integer;
var
  MsgErro: string;
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    with Qry do
    begin
      Connection := DM.Conexao;
      Connection.StartTransaction;
      SQL.Clear;
      SQL.ADD(' INSERT INTO ENDERECO_INTEGRACAO (   ');
      SQL.ADD('    IDENDERECO                       ');
      SQL.ADD(' ) VALUES (                          ');
      SQL.ADD('    :IDENDERECO                      ');
      SQL.ADD(' );                                  ');
      ParamByName('IDENDERECO').AsInteger := Integracao.idEndereco;
      try
        Prepare;
        ExecSQL;
        Connection.Commit;
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
  end;
  Result := Integracao.idEndereco;
end;

function TCtrlIntegracao.TabelaExiste: Boolean;
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
    Qry.ParamByName('TABELA').AsString := 'ENDERECO_INTEGRACAO';
    Qry.Prepare;
    Qry.Open;

    Result := (Qry.FieldByName('QTDE').AsInteger > 0);
  finally
    FreeAndNil(Qry);
  end;
end;

end.
