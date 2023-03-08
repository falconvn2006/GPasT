unit uModulo;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.SqlExpr, Vcl.Forms, Vcl.Dialogs,
  Data.DBXFirebird, System.IniFiles, Data.FMTBcd, Datasnap.DBClient,
  Datasnap.Provider;

type
  Tdm = class(TDataModule)
    conexao: TSQLConnection;
    SqlConsulta: TSQLQuery;
    SqlAux: TSQLQuery;
    SqlAux2: TSQLQuery;
    SqlProduto: TSQLQuery;
    sdsemp: TSQLDataSet;
    dspemp: TDataSetProvider;
    dsemp: TDataSource;
    tbemp: TClientDataSet;
    tbempEMPRESA: TStringField;
    tbempCARTEIRA: TStringField;
    tbempCODCED: TStringField;
    tbempDIGCODCED: TStringField;
    tbempCODBAN: TStringField;
    tbempCODAGE: TStringField;
    tbempDIGAGE: TStringField;
    tbempDIGCONT: TStringField;
    tbempNUMCONT: TStringField;
    tbempNOME: TStringField;
    tbempCRIA_MENU: TIntegerField;
    tbempRAZAO_SOCIAL: TStringField;
    tbempENDERECO: TStringField;
    tbempNUMERO: TIntegerField;
    tbempBAIRRO: TStringField;
    tbempCIDADE: TStringField;
    tbempESTADO: TStringField;
    tbempCEP: TStringField;
    tbempFONE: TStringField;
    tbempFONE2: TStringField;
    tbempCNPJ: TStringField;
    tbempINSC: TStringField;
    tbempCAMINHO_LOGO: TStringField;
    sdsconsulta1: TSQLDataSet;
    dspconsulta1: TDataSetProvider;
    dspesqcad: TDataSource;
    cdspesqcad: TClientDataSet;
    sdsusuario: TSQLDataSet;
    dspusuario: TDataSetProvider;
    dsusuario: TDataSource;
    tbusuario: TClientDataSet;
    tbusuarioUSU_CODIGO: TIntegerField;
    tbusuarioUSU_NOME: TStringField;
    tbusuarioUSU_SENHA: TStringField;
    tbusuarioUSU_GERENTE: TStringField;
    tbusuarioNCARTAO: TStringField;
    tbusuarioNCAIXA: TStringField;
    tbusuarioFUNCIONARIO: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    Procedure ExecutarScript;
    function ExisteCampo(const pTabela, pCampo: String): Boolean;
    function ExisteTabela(const pTabela: String): Boolean;
    function ExisteProcedure(const pProcedure: String): Boolean;
    function ExisteTrigger(const pTrigger: String): Boolean;
    procedure ExecutaScriptDireto(sScript: String);
  public
    { Public declarations }
    FiniParam  : TIniFile;
    FGrupo, FSubGrupo,FIdToken: String;
    FiErro: Integer;
    sMsgErro,FVrFuncao,FRedeAdquirente,FcodCaixa,FSerieNfce : string;
    FCancelar,FPagamentoOk : Boolean;
    FHomologaTEF: Boolean;
    sCodProd : string;
    procedure ConectarBancodeDados;
  end;

var
     iEmpresa : Integer = 0;
  dm: Tdm;

implementation
uses uMensagem, uFuncoes, UTransacao;


{$R *.dfm}

procedure Tdm.ConectarBancodeDados;
var
  vArquivo: String;
  vArquivoIni : TIniFile;
begin
     vArquivo := ExtractFilePath(Application.ExeName) + 'servidorBalanca.ini';

     if not FileExists(vArquivo) then
     begin
          try
               Application.CreateForm(tFrMensagem,FrMensagem);
               FrMensagem.sMensagem := 'Não foi possível conectar no banco de dados.'+#13+
                                       'Arquivo de configuração "servidorBalanca.ini" não encontrado na pasta do sistema.';
               FrMensagem.pnlMensagem.Font.Size := 20;
               FrMensagem.ShowModal();
          finally
               FreeAndNil(FrMensagem);

          end;

          Application.Terminate;
          Exit;
     end;

     try
          if Parametro('TRUNCAR_ARRENDONDAR') = 'T' then
               FVrFuncao := 'F_TRUNCAR'
          else
               FVrFuncao := 'F_ARREDONDAR';

          Conexao.ConnectionName := 'Bitbyte_server';
          Conexao.LoadParamsOnConnect := false;
          Conexao.LoadParamsFromIniFile (vArquivo);
          Conexao.LoginPrompt:=false;
          Conexao.Open;

     except
     on e:Exception do
          begin
               try
                    Application.CreateForm(tFrMensagem,FrMensagem);
                    FrMensagem.sMensagem := 'Não foi possível conectar no banco de dados.'+#13+
                                       'Erro ao Conectar no banco de dados.';
                    FrMensagem.pnlMensagem.Font.Size := 20;
                    FrMensagem.ShowModal();
               finally
                    FreeAndNil(FrMensagem);
               end;

             Application.Terminate;
             Exit;
          end;
     end;
end;

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
     FiniParam := TIniFile.Create('c:\ParamBBi\ParamBBi.ini');
     ConectarBancodeDados;

     ExecutarScript;
end;


function Tdm.ExisteCampo(const pTabela, pCampo: String): Boolean;
begin
     Result := False;

     SqlConsulta.Close;
     SqlConsulta.SQL.Text := 'SELECT RDB$RELATION_FIELDS.* FROM RDB$RELATION_FIELDS'+
                        ' WHERE RDB$RELATION_NAME = '''+ pTabela + ''' and ' +
                        ' RDB$RELATION_FIELDS.RDB$FIELD_NAME = ''' + pCampo + '''';
     SqlConsulta.Open;

     if SqlConsulta.RecordCount > 0 then
          Result := True;
end;

Procedure Tdm.ExecutarScript;
var
  trans: TTransacao;
  vDESCRICAO : string;
begin
     trans := TTransacao.Create(dm.conexao);

     try
          if not ExisteCampo('TBVENDA', 'NSU' ) then
          begin
               trans.Limpar;
               trans.Adicionar('ALTER TABLE TBVENDA ADD NSU VARCHAR(50)');
               trans.Executar;
          end;

          (**************************************************************************
           Responsável: Gustavo  Data: 29/01/2020
           Motivo: Tabela para verificar a conexao banco de dados
          **************************************************************************)
          if not ExisteTabela('TBCONEXAOBD') then
          begin
               trans.Limpar;
               trans.Adicionar('CREATE TABLE TBCONEXAOBD ('+
                    ' CODIGO    INTEGER NOT NULL,'+
                    ' ID_CAIXA  INTEGER,'+
                    ' DATA_HORA TIMESTAMP '+
                    ')');
               trans.Executar;

               trans.Limpar;
               trans.Adicionar('ALTER TABLE TBCONEXAOBD'+
                          ' ADD CONSTRAINT PK_TBCONEXAOBD'+
                          ' PRIMARY KEY (CODIGO)');
               trans.Executar;

          end;

          // criar parametro da impressão do tef

          if Parametro('IMPRIME_VIA_REDUZIDA_TEF') = '0' then
          begin
               vDESCRICAO := 'Para imprimir a via reduzida do Tef ';

               trans.Limpar;
               trans.Adicionar('INSERT INTO TBPARAMETRO (PARAMETRO, TIPO, TIPO_SN,'+
               ' VALOR, GRUPO, DESCRICAO, PALAVRA_CHAVE'+
               ') VALUES ('+
               QuotedStr('IMPRIME_VIA_REDUZIDA_TEF') +
               ', ' + QuotedStr('S') +
               ', ' + QuotedStr('S') +
               ', ' + QuotedStr('S') +
               ', ' + QuotedStr('AUTO PAGAMENTO') +
               ', ' + QuotedStr(vDESCRICAO) +
               ', ' + QuotedStr('IMPRIME VIA REDUZIDA TEF') +
               ')');

               trans.Executar;
          end;

          (**************************************************************************
           Responsável: Gustavo  Data: 13/04/2020
           Motivo: Tabela para verificar a conexao banco de dados
          **************************************************************************)
          if not ExisteTabela('TBVENDATEMPORARIA') then
          begin
               trans.Limpar;
               trans.Adicionar('CREATE TABLE TBVENDATEMPORARIA ('+
                    ' CAIXA_MICRO       INTEGER NOT NULL,'+
                    ' SEQ_iTEM          INTEGER NOT NULL,'+
                    ' ID_CAIXA_OPERADOR INTEGER NOT NULL,'+
                    ' CODPROD           VARCHAR(06),   ' +
                    ' DESCRICAO         VARCHAR(255),  '+
                    ' UNMED             VARCHAR(5),    '+
                    ' QTD               NUMERIC(15,3), '+
                    ' VR_UNIT           NUMERIC(15,2), '+
                    ' VR_TOTAL          NUMERIC(15,2) '+
                    ')');
               trans.Executar;

               trans.Limpar;
               trans.Adicionar('ALTER TABLE TBVENDATEMPORARIA'+
                          ' ADD CONSTRAINT PK_TBVENDATEMPORARIA'+
                          ' PRIMARY KEY (CAIXA_MICRO,SEQ_iTEM,ID_CAIXA_OPERADOR)');
               trans.Executar;

          end;

          (**************************************************************************
          Responsável: luiz - Data: 10/08/2015
          Motivo: Imprime os produtos vendidos no fechamento do caixa.
          **************************************************************************)
          
          if not ExisteCampo('TBPARAMETRO', 'FECH_IMPR_PROD_CANCELADOS' ) then
          begin
               trans := TTransacao.Create(dm.conexao);

               trans.Limpar;
               trans.Adicionar('ALTER TABLE TBPARAMETRO ADD FECH_IMPR_PROD_CANCELADOS CHAR(1)');
               trans.Executar;

               trans.Limpar;
               trans.Adicionar('update TBPARAMETRO set FECH_IMPR_PROD_CANCELADOS = ''N''');
               trans.Executar;

               FreeAndNil(trans);
          end;

          (*********************************************************************
          Responsável: Marcel - 28/09/2022
          Motivo: Calcular valor dos proutos pela quantidade de produtos do
          mesmo subgrupo.
               Parametro('VALOR_POR_SUBGRUPO') = 'S'
               tbsubgru.utiliza_valor_subgrupo = 'S'
          *********************************************************************)
          if not ExisteProcedure('SP_CALCULA_VALOR_QTD_VT') then
          begin
               ExecutaScriptDireto(
                    'create or alter procedure SP_CALCULA_VALOR_QTD_VT ('+                             #13 +
                    '     CAIXA_MICRO integer,'+                                                       #13 +
                    '     ID_CAIXA_OPERADOR integer,'+                                                 #13 +
                    '     CODPROD varchar(6),'+                                                        #13 +
                    '     IGNORE_SEQ_ITEM integer)'+                                                   #13 +
                    ' as'+                                                                             #13 +
                    ' declare variable QTD_VALOR double precision;'+                                   #13 +
                    ' declare variable CODSUBGRUPO varchar(5);'+                                       #13 +
                    ' begin'+                                                                          #13 +
                    '     select tbsubgru.codigo'+                                                     #13 +
                    '     from tbsubgru'+                                                              #13 +
                    '     inner join tbprod on tbsubgru.codigo = tbprod.subgrupo'+                     #13 +
                    '     where tbsubgru.utiliza_valor_subgrupo = ''S'''+                              #13 +
                    '     and tbprod.codigo = :codprod'+                                               #13 +
                    '     into :codsubgrupo;'+                                                         #13 +
                    ' '+                                                                               #13 +
                    '     if (coalesce(:codsubgrupo,'''') <> '''') then'+                              #13 +
                    '     begin'+                                                                      #13 +
                    '         select first 1 tbsubgrupo_valores.valor'+                                #13 +
                    '         from tbvendatemporaria'+                                                 #13 +
                    '         inner join tbprod on'+                                                   #13 +
                    '             tbvendatemporaria.codprod = tbprod.codigo and'+                      #13 +
                    '             tbprod.subgrupo = :codsubgrupo'+                                     #13 +
                    '         inner join tbsubgrupo_valores on'+                                       #13 +
                    '             tbsubgrupo_valores.cod_subgrupo = tbprod.subgrupo'+                  #13 +
                    '         where tbvendatemporaria.caixa_micro = :caixa_micro'+                     #13 +
                    '         and tbvendatemporaria.id_caixa_operador = :id_caixa_operador'+           #13 +
                    '         and tbvendatemporaria.seq_item <> :ignore_seq_item'+                     #13 +
                    '         group by tbsubgrupo_valores.valor, tbsubgrupo_valores.qtd_ate'+          #13 +
                    '         having sum(tbvendatemporaria.qtd) <= tbsubgrupo_valores.qtd_ate'+        #13 +
                    '         order by tbsubgrupo_valores.qtd_ate'+                                    #13 +
                    '         into :qtd_valor;'+                                                       #13 +
                    ' '+                                                                               #13 +
                    '         if (coalesce(:qtd_valor, 0) = 0) then'+                                  #13 +
                    '         begin'+                                                                  #13 +
                    '             select first 1 valor'+                                               #13 +
                    '             from tbsubgrupo_valores'+                                            #13 +
                    '             where cod_subgrupo = :codsubgrupo'+                                  #13 +
                    '             order by qtd_ate desc'+                                              #13 +
                    '             into :qtd_valor;'+                                                   #13 +
                    '         end'+                                                                    #13 +
                    ' '+                                                                               #13 +
                    '         execute statement ''alter trigger trg_calcula_valor_qtd_vt inactive'';'+ #13 +
                    ' '+                                                                               #13 +
                    '         update tbvendatemporaria set'+                                           #13 +
                    '             tbvendatemporaria.vr_unit = :qtd_valor,'+                            #13 +
                    '             tbvendatemporaria.vr_total = :qtd_valor * tbvendatemporaria.qtd'+    #13 +
                    '         where tbvendatemporaria.codprod in ('+                                   #13 +
                    '             select tbvendatemporaria.codprod'+                                   #13 +
                    '             from tbvendatemporaria'+                                             #13 +
                    '             inner join tbprod on'+                                               #13 +
                    '                 tbvendatemporaria.codprod = tbprod.codigo and'+                  #13 +
                    '                 tbprod.subgrupo = :codsubgrupo and'+                             #13 +
                    '                 tbvendatemporaria.caixa_micro = :caixa_micro and'+               #13 +
                    '                 tbvendatemporaria.id_caixa_operador = :id_caixa_operador and'+   #13 +
                    '                 tbvendatemporaria.seq_item <> :ignore_seq_item'+                 #13 +
                    '         )'+                                                                      #13 +
                    '         and tbvendatemporaria.caixa_micro = :caixa_micro'+                       #13 +
                    '         and tbvendatemporaria.id_caixa_operador = :id_caixa_operador'+           #13 +
                    '         and tbvendatemporaria.seq_item <> :ignore_seq_item;'+                    #13 +
                    ' '+                                                                               #13 +
                    '         execute statement ''alter trigger trg_calcula_valor_qtd_vt active'';'+   #13 +
                    '     end'+                                                                        #13 +
                    ' end');
          end;

          if not ExisteTrigger('TRG_CALCULA_VALOR_QTD_VT') and ExisteProcedure('SP_CALCULA_VALOR_QTD_VT') then
          begin
               ExecutaScriptDireto(
                    'CREATE OR ALTER TRIGGER TRG_CALCULA_VALOR_QTD_VT FOR TBVENDATEMPORARIA'+                                                     #13 +
                    ' ACTIVE AFTER INSERT OR UPDATE OR DELETE POSITION 1'+                                                                        #13 +
                    ' AS'+                                                                                                                        #13 +
                    ' begin'+                                                                                                                     #13 +
                    '     if ((select valor from tbparametro where parametro = ''VALOR_POR_SUBGRUPO'') = ''S'') then'+                            #13 +
                    '     begin'+                                                                                                                 #13 +
                    '         if (inserting) then'+                                                                                               #13 +
                    '             execute procedure sp_calcula_valor_qtd_vt(new.caixa_micro, new.id_caixa_operador, new.codprod, 0);'+            #13 +
                    '         else'+                                                                                                              #13 +
                    '         if ((updating) and (coalesce(new.qtd, 0) <> coalesce(old.qtd, 0))) then'+                                           #13 +
                    '             execute procedure sp_calcula_valor_qtd_vt('+                                                                    #13 +
                    '                 coalesce(new.caixa_micro, old.caixa_micro),'+                                                               #13 +
                    '                 coalesce(new.id_caixa_operador, old.id_caixa_operador),'+                                                   #13 +
                    '                 coalesce(new.codprod, old.codprod),'+                                                                       #13 +
                    '                 0);'+                                                                                                       #13 +
                    '         else'+                                                                                                              #13 +
                    '         if (deleting) then'+                                                                                                #13 +
                    '             execute procedure sp_calcula_valor_qtd_vt(old.caixa_micro, old.id_caixa_operador, old.codprod, old.seq_item);'+ #13 +
                    '     end'+                                                                                                                   #13 +
                    ' end');
          end;

     finally
          FreeAndNil(trans);
     end;
end;

function Tdm.ExisteTabela(const pTabela: String): Boolean;
begin
     Result := False;
     try
          SqlConsulta.Close;
          SqlConsulta.SQL.Text := ' SELECT COUNT(*) QTDE  FROM RDB$RELATIONS WHERE RDB$RELATION_NAME= ''' + pTabela + '''' ;
          SqlConsulta.Open;

          if SqlConsulta.fieldByName('qtde').AsInteger > 0 then
               Result := True;
     except
          Result := False;
     end;
end;

function Tdm.ExisteProcedure(const pProcedure: String): Boolean;
begin
     SqlConsulta.Close;
     SqlConsulta.SQL.Text := 'select rdb$procedure_name from rdb$procedures'+
          ' where rdb$procedure_name = '+ QuotedStr(pProcedure);
     SqlConsulta.Open;

     Result := not SqlConsulta.IsEmpty;
end;

function Tdm.ExisteTrigger(const pTrigger: String): Boolean;
begin
     SqlConsulta.Close;
     SqlConsulta.SQL.Text := 'select rdb$trigger_name from rdb$triggers'+
          ' where rdb$trigger_name = '+ QuotedStr(pTrigger);
     SqlConsulta.Open;

     Result := not SqlConsulta.IsEmpty;
end;

procedure Tdm.ExecutaScriptDireto(sScript: String);
var
     t : TTransactionDesc;
begin
     t.IsolationLevel:= xilREADCOMMITTED;
     dm.conexao.StartTransaction(t);
     dm.conexao.ExecuteDirect(sScript);
     dm.conexao.Commit(t);
end;

end.
