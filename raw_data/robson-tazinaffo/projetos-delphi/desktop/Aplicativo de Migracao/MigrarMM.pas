unit MigrarMM;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Buttons, DB, IBDatabase, ADODB, IBCustomDataSet,
    IBQuery, ComCtrls, Grids, DBGrids, ActnList, ExtCtrls, DateUtils,
  System.Actions;

type
    Tf_principal = class(TForm)
        od_token: TOpenDialog;
        Dados_db: TADOConnection;
        ibTabelas: TIBQuery;
        sqlTabelas: TADOQuery;
        Btn_migrar: TBitBtn;
        StatusBar1: TStatusBar;
        ProgressBar1: TProgressBar;
        sqlTMP: TADOQuery;
        SqlClientes: TADOQuery;
        sqlMarcas: TADOQuery;
        sqlSecoes: TADOQuery;
        sqlProdutos: TADOQuery;
        sqlProdutosPreco: TADOQuery;
        sqlProdutoEstoque: TADOQuery;
    sqlOp: TADOQuery;
        sqlVendedores: TADOQuery;
        sqlMovimD: TADOQuery;
        sqlReceber: TADOQuery;
        sqlCentroC: TADOQuery;
        sqlPLanCn: TADOQuery;
        sqlPagar: TADOQuery;
        sqlIncluiCidades: TADOQuery;
        ibTmp: TIBQuery;
        qry_evitaSecDup: TADOQuery;
        sqlEtiquetas: TADOQuery;
        sqlEvitaProdDup: TADOQuery;
        sqlProxProd: TADOQuery;
        qry_buscaSec: TADOQuery;
    qry_buscaCliente: TADOQuery;
    chk_vendedores: TCheckBox;
    chk_Vendas: TCheckBox;
    chk_Receber: TCheckBox;
    chk_CentroDeCusto: TCheckBox;
    chk_PlanodeContas: TCheckBox;
    chk_Pagar: TCheckBox;
    chk_ItensDaVenda: TCheckBox;
    chk_Fornecedor: TCheckBox;
    sqlFornecedores: TADOQuery;
    mmStatusMigracao: TMemo;
    sqlNCM: TADOQuery;
    chk_comprasc: TCheckBox;
    chk_comprasd: TCheckBox;
    sqlComprasd: TADOQuery;
    sqlComprasc: TADOQuery;
    sqlAcertaProdutos: TADOQuery;
    chk_AcertaCliente: TCheckBox;
    sqlAcertaFornecedores: TADOQuery;
    chk_AcertaOP: TCheckBox;
    sqlTrbprd: TADOQuery;
    Acertoostoken: TBitBtn;
    sqlBuscaos: TADOQuery;
    sqlItensos: TADOQuery;
    sqlAcertaProduto2: TADOQuery;
    chk_AcertaProd2: TCheckBox;
    sqlAcertaClientes: TADOQuery;
    sqlAcertaCliente2: TADOQuery;
    ActionList1: TActionList;
    SAIR: TAction;
    chk_OPCabecalho: TCheckBox;
    sqlMovimC: TADOQuery;
    chk_OPMateriaPrima: TCheckBox;
    sqlItensOP: TADOQuery;
    chk_OPServico: TCheckBox;
    sqlServicoOP: TADOQuery;
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    Label1: TLabel;
    chk_AcertaProdutos: TCheckBox;
    sqlAcertaProdutos2: TADOQuery;
    BancoToken: TIBDatabase;
    IBTransaction1: TIBTransaction;
    RG_Receber: TRadioGroup;
    RG_Pagar: TRadioGroup;
    GroupBox1: TGroupBox;
    chk_Produtos: TCheckBox;
    chk_Secoes: TCheckBox;
    chk_Marcas: TCheckBox;
    GroupBox2: TGroupBox;
    chk_Cidades: TCheckBox;
    chk_Clientes: TCheckBox;
    sqlAcertaSexo: TADOQuery;
    chk_Precos: TCheckBox;
    chk_Estoque: TCheckBox;
    chk_InsereKaredx: TCheckBox;
    grp1: TGroupBox;
    ServerFB: TEdit;
    btn_BancoAntigo: TBitBtn;
    grp2: TGroupBox;
    btn_conectaLck: TBitBtn;
    ServerSQL: TComboBox;
    Label2: TLabel;
    Database_name: TEdit;
    Label3: TLabel;
    btnConectaIB: TBitBtn;
        procedure btn_BancoAntigoClick(Sender: TObject);
        procedure BancoTokenAfterConnect(Sender: TObject);
        procedure BancoTokenAfterDisconnect(Sender: TObject);
        procedure btn_conectaLckClick(Sender: TObject);
        procedure Btn_migrarClick(Sender: TObject);
        procedure Dados_dbAfterConnect(Sender: TObject);
        procedure Button1Click(Sender: TObject);
    procedure AcertoostokenClick(Sender: TObject);
    procedure SAIRExecute(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    function Convertehoradecimalparadatetime(hora:String): TdateTime;
    procedure chk_ReceberClick(Sender: TObject);
    procedure chk_PagarClick(Sender: TObject);
    procedure btnConectaIBClick(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    f_principal: Tf_principal;

implementation


{$R *.dfm}

uses fFuncoes;

{
procedure Tf_principal.InstanciasInstaladas;
begin
  Dim registro As Microsoft.Win32.RegistryKey
  registro = My.Computer.Registry.LocalMachine.OpenSubKey("SOFTWARE\Microsoft\Microsoft SQL Server", False)

//  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server

  Dim instancias() As String
  instancias = CType(registro.GetValue("InstalledInstances"), String())

  Return instancias

end;
}


procedure Tf_principal.btn_BancoAntigoClick(Sender: TObject);
begin
    if Trim(ServerFB.Text) = '' then begin
       ShowMessage('O caminho do banco de dados Firebird deve ser informado!');
       btnConectaIB.SetFocus;
       exit;
    end;

    if BancoToken.Connected then begin
        btn_BancoAntigo.Font.Color := clWindowText;
        btn_BancoAntigo.caption := 'Conectar';
        BancoToken.Connected := False;
        BancoToken.Close;
        exit;
    end;

    try
       BancoToken.Close;
//       BancoToken.DatabaseName := 'Localhost:' + Trim(od_token.FileName);
       BancoToken.DatabaseName := Trim(ServerFB.Text);
       BancoToken.Open;
       BancoToken.Connected := True;
       Btn_migrar.Enabled := true;
       btn_BancoAntigo.Font.Color := clRed;
       btn_BancoAntigo.caption := 'Desconectar';
    except on E: Exception do begin
       ServerFB.Clear;
       btn_BancoAntigo.Font.Color := clWindowText;
       btn_BancoAntigo.caption := 'Conectar';
       ShowMessage('Erro de Conexão com banco JNP!' + E.Message);
       Btn_migrar.Enabled := False;
       exit;
       end;
    End;


end;

procedure Tf_principal.BancoTokenAfterConnect(Sender: TObject);
begin
    btn_BancoAntigo.Caption := 'Desconecta Banco Token';
    if BancoToken.Connected and Dados_db.Connected then
        Btn_migrar.Enabled := true
    else
        Btn_migrar.Enabled := False;

end;

procedure Tf_principal.BancoTokenAfterDisconnect(Sender: TObject);
begin
    btn_BancoAntigo.Caption := 'Conecta Banco Token';
end;

procedure Tf_principal.btn_conectaLckClick(Sender: TObject);
begin
    if Dados_db.Connected then begin
        btn_conectaLck.Font.Color := clWindowText;
        btn_conectaLck.caption := 'Conectar';
        Dados_db.Close;
        exit;
    end;

    try
        Dados_db.Close;
        Dados_db.ConnectionString :=
//            'Provider=SQLOLEDB.1;Password=99951629;Persist Security Info=True;User ID=sa;Initial Catalog=dados_db;Data Source=.';
//            'Provider=SQLOLEDB.1;Password=99951629;Persist Security Info=True;User ID=sa;Initial Catalog=dados_db;Data Source=' + Trim(ServerSQL.Text);
            'Provider=SQLOLEDB.1;Password=99951629;Persist Security Info=True;User ID=sa;Initial Catalog=' + Trim(Database_name.Text) + ';Data Source=' + Trim(ServerSQL.Text);
        Dados_db.Open;
        btn_conectaLck.Font.Color := clRed;
        btn_conectaLck.caption := 'Desconectar';
    except on E: Exception do begin
       btn_conectaLck.Font.Color := clWindowText;
       btn_conectaLck.caption := 'Conectar';
       ShowMessage('Erro de Conexão com banco SQL Server!' + E.Message);
       Btn_migrar.Enabled := False;
       exit;
       end;
    End;


end;

procedure Tf_principal.Btn_migrarClick(Sender: TObject);
var
    ProximoCli, i, CodVenda, item, minutostrabalhados: Integer;
    Codigo_sec, DocOk, Doc, GELADO1, horastrabalhadas: string;
    MARCA, PLC, CC: INTEGER;
    Entrada, Saida, Devolucao, Estoque, valorminven, valormincustoven: Real;
    hora1, hora2 :TDateTime;
    AtualizaCodigo_cid: Boolean;
    MostraMensagem: Boolean; // Para debugar em um determinado local
begin
    if (not BancoToken.Connected) or (not Dados_db.Connected) then begin
        ShowMessage('Tem de conectar aos bancos Token e Lck Primeiro ...');
        exit;
    end;

    MostraMensagem := True;
    AtualizaCodigo_cid := False;
    Btn_migrar.Enabled := False;

    if chk_Clientes.Checked then begin

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('select * from cidades_tb');
        sqlTMP.Open;

        if sqlTMP.RecordCount < 2 then begin
            ShowMessage('Execute o "SETUP DE CIDADES" antes de migrar os clientes...');
            btn_BancoAntigoClick(Self);
            btn_conectaLckClick(Self);
            exit;
        end;


        sqlTMP.Close;
        sqlTMP.SQL.Clear;
        sqlTMP.SQL.Add(' if dbo.func_obj_existente(''RetiraAcento'') = 1 begin ');
        sqlTMP.SQL.Add(' drop function RetiraAcento ');
        sqlTMP.SQL.Add(' end ');
        sqlTMP.ExecSQL;

        sqlTMP.Close;
        sqlTMP.SQL.Clear;
        sqlTMP.SQL.Add(' Create function dbo.RetiraAcento(@Texto varchar(1000) ) ');
        sqlTMP.SQL.Add(' Returns varchar(1000) as ');
        sqlTMP.SQL.Add(' begin ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''á'',''a'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''é'',''e'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''É'',''E'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''í'',''i'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''ó'',''o'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''ú'',''u'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''à'',''a'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''è'',''e'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''ì'',''i'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''ò'',''o'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''ù'',''u'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''â'',''a'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''ê'',''e'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''î'',''i'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''ô'',''o'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''û'',''u'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''ä'',''a'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''ë'',''e'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''ï'',''i'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''ö'',''o'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''ü'',''u'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''ã'',''a'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''õ'',''o'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''ñ'',''n'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''ç'',''c'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Á'',''A'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''É'',''E'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Í'',''I'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Ó'',''O'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Ú'',''U'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''À'',''A'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''È'',''E'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Ì'',''I'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Ò'',''O'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Ù'',''U'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Â'',''A'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Ê'',''E'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Î'',''I'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Ô'',''O'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Û'',''U'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Ä'',''A'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Ë'',''E'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Ï'',''I'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Ö'',''O'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Ü'',''U'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Ã'',''A'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Õ'',''O'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Ñ'',''N'')  ');
        sqlTMP.SQL.Add(' 	set @Texto = replace(@Texto COLLATE Latin1_General_BIN,''Ç'',''C'')  ');
        sqlTMP.SQL.Add(' ');
        sqlTMP.SQL.Add(' 	return @Texto ');
        sqlTMP.SQL.Add(' end ');
        sqlTMP.ExecSQL;


        Btn_Migrar.Caption := 'Migrando Clientes';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select count(1) as Nro from Clientes ');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select * from Clientes where CLAVE > 1 ');
        ibTabelas.Open;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Delete From Clientes_tb where codigo_cli > 1');
        sqlTMP.ExecSql;

        ProximoCli := 0;
        ibTabelas.First;
        while not ibTabelas.Eof do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'Cliente: ' +
                ibTabelas.FieldByName('CLAVE').AsString + '-' +
                ibTabelas.FieldByName('NOMBRE').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;

            if ibTabelas.FieldByName('CLAVE').AsInteger > ProximoCli then
                ProximoCli := ibTabelas.FieldByName('CLAVE').AsInteger;

            // Campos
           sqlClientes.Parameters.ParamByName('Codigo_cli').Value    := ibTabelas.FieldByName('CLAVE').AsInteger;
            sqlClientes.Parameters.ParamByName('Nome_cli').Value     := AnsiToAscii(padr(ibTabelas.FieldByName('NOMBRE').AsString, 40));
            sqlClientes.Parameters.ParamByName('Endereco_cli').Value :=
                padr(AnsiToAscii(Trim(ibTabelas.FieldByName('CALLE').AsString))+','+Trim(ibTabelas.FieldByName('NUMERO').AsString), 50);
            sqlClientes.Parameters.ParamByName('Cidade_cli').Value   := AnsiToAscii(padr(ibTabelas.FieldByName('LOCALIDAD').AsString, 35));  // SEM ACENTUACAO
            sqlClientes.Parameters.ParamByName('UF_cli').Value       := padr(ibTabelas.FieldByName('ESTADO').AsString, 2);
            sqlClientes.Parameters.ParamByName('CEP_cli').Value      := copy(padr(ibTabelas.FieldByName('CP').AsString, 10),1,2) +'.'+ copy(padr(ibTabelas.FieldByName('CP').AsString, 10),3,3) +'-'+copy(padr(ibTabelas.FieldByName('CP').AsString, 10),6,3);
            sqlClientes.Parameters.ParamByName('BAIRRO_cli').Value   := AnsiToAscii(padr(ibTabelas.FieldByName('COLONIA').AsString, 30));
            sqlClientes.Parameters.ParamByName('Pai_cli').Value      := AnsiToAscii(padr(ibTabelas.FieldByName('NOMEPAI').AsString,30));
            sqlClientes.Parameters.ParamByName('Mae_cli').Value      := AnsiToAscii(padr(ibTabelas.FieldByName('NOMEMAE').AsString,30));
            sqlClientes.Parameters.ParamByName('NomeConj_cli').Value := AnsiToAscii(padr(ibTabelas.FieldByName('CONJUGE').AsString,30));
            {nao tem
            sqlClientes.Parameters.ParamByName('Email_cli').Value :=
                padr(ibTabelas.FieldByName('EMAIL').AsString, 18);
            }
            sqlClientes.Parameters.ParamByName('LimiteCred_cli').Value   := ibTabelas.FieldByName('LIMITECREDITO').AsFloat;
            sqlClientes.Parameters.ParamByName('CpfCgc_cli').Value       := padr(ibTabelas.FieldByName('RFC').AsString, 18);
            sqlClientes.Parameters.ParamByName('RgInsc_cli').Value       := padr(ibTabelas.FieldByName('RGIE').AsString, 20);
            sqlClientes.Parameters.ParamByName('nomeFantasia_cli').Value := AnsiToAscii(padr(ibTabelas.FieldByName('APELIDO').AsString, 40));
             //data do cadastro DtCadastro_cli
            sqlClientes.Parameters.ParamByName('DtCadastro_cli').Value := Now;

            if ibTabelas.FieldByName('ESTATUS').AsString = 'I' then BEGIN
                sqlClientes.Parameters.ParamByName('Bloqueado_cli').Value := 'S'
            END else BEGIN
                sqlClientes.Parameters.ParamByName('Bloqueado_cli').Value := 'N';
            end;

            sqlClientes.Parameters.ParamByName('ClienteInativo_cli').Value  := 'N';
            sqlClientes.Parameters.ParamByName('UserName_usr').Value        := 'MIGR***';
            sqlClientes.Parameters.ParamByName('DtUltAlteracao_cli').Value  := NOW;
            sqlClientes.Parameters.ParamByName('tipocliente_cli').Value     := 'N';
            sqlClientes.Parameters.ParamByName('GeraCreditoIcms_cli').Value := 'N';
            sqlClientes.Parameters.ParamByName('Pessoa_cli').Value          := 'F';
            sqlClientes.Parameters.ParamByName('Codigo_emp').Value          := 1;
            SqlClientes.Parameters.ParamByName('Observacoes_cli').Value := Trim(ibTabelas.fieldbyname('OBSERVACOES').AsString)
                                                                           +#13+#10+Trim(ibTabelas.fieldbyname('MOTIVOBLOQ').AsString);
            SqlClientes.Parameters.ParamByName('PessoaContato_cli').Value   := ibTabelas.fieldbyname('CONTACTO').AsString;
            SqlClientes.Parameters.ParamByName('RazaoTrab_cli').Value       := ibTabelas.fieldbyname('CONTATO').AsString;

            if Year(ibTabelas.FieldByName('ANIVERSARIO').AsDateTime) > 1900 then begin
                  SqlClientes.Parameters.ParamByName('Nasc_cli').Value      := ibTabelas.FieldByName('ANIVERSARIO').AsDateTime;
            end else begin
                  SqlClientes.Parameters.ParamByName('Nasc_cli').Value      := NULL;
            end;

            sqlClientes.Parameters.ParamByName('TipoAdmCard_cli').Value       := '1';
            sqlClientes.Parameters.ParamByName('AdmCardIniciaDia_cli').Value  := 1;
            sqlClientes.Parameters.ParamByName('AdmCardFechaDia_cli').Value   := 1;
            sqlClientes.Parameters.ParamByName('AdmCardRecebeDia_cli').Value  := 1;
            sqlClientes.Parameters.ParamByName('SomenteVendaVista_cli').Value := 'N';
            sqlClientes.Parameters.ParamByName('TaxaAdmCartao_cli').Value     := 0;
            sqlClientes.Parameters.ParamByName('DiasAdmCartao_cli').Value     := 0;

            sqlClientes.Parameters.ParamByName('Fone1_cli').Value             := padr(ibTabelas.FieldByName('TELEFONO').AsString,16);
            sqlClientes.Parameters.ParamByName('Fone2_cli').Value             := padr(ibTabelas.FieldByName('TELEFONO2').AsString,16);
            sqlClientes.Parameters.ParamByName('Celular_cli').Value           := padr(ibTabelas.FieldByName('CELULAR').AsString,16);
            sqlClientes.Parameters.ParamByName('Fax_cli').value               := padr(ibTabelas.FieldByName('FAX').AsString, 16);
            sqlClientes.Parameters.ParamByName('Sexo_cli').Value              := '';


            sqlClientes.ExecSql;
            // Fim Campos
            ibTabelas.Next;
        end;

        // Acerta nome das cidades e insere codigo da cidade
        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('update clientes_tb set cidade_cli = null where rtrim(cidade_cli) = '''' ');
        sqlTMP.Sql.Add('update clientes_tb set cidade_cli = ''SAO JOAQUIM DA BARRA'' where rtrim(cidade_cli) = ''SOAJOAQUIM DA BARRA'' ');
        sqlTMP.Sql.Add('update clientes_tb set cidade_cli = ''SAO JOAQUIM DA BARRA'' where rtrim(cidade_cli) = ''S. JOAQUIM DA BARRA'' ');
        sqlTMP.Sql.Add('update clientes_tb set cidade_cli = ''SAO JOAQUIM DA BARRA'' where rtrim(cidade_cli) = ''SAO  JOAQUIM DA BARRA'' ');
        sqlTMP.Sql.Add('update clientes_tb set cidade_cli = ''SAO JOAQUIM DA BARRA'' where rtrim(cidade_cli) = ''SAO JOAQUM DA BARRA'' ');
        sqlTMP.Sql.Add('update clientes_tb set cidade_cli = ''SAO JOAQUIM DA BARRA'' where rtrim(cidade_cli) = ''SOAJOAQUIM DA BARRA'' ');
        sqlTMP.Sql.Add('update clientes_tb set cidade_cli = ''SAO JOAQUIM DA BARRA'' where rtrim(cidade_cli) = ''SAO JOAQUIM DA BARRA'' ');
        sqlTMP.ExecSQL;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('update clientes_tb set codigo_cid = cid.codigo_cid ');
        sqlTMP.Sql.Add('from clientes_tb cli ');
        sqlTMP.Sql.Add('LEFT OUTER  join cidades_tb cid on (cli.cidade_cli = cid.Nome_cid) ');
        sqlTMP.ExecSQL;
        // ***********************************************************************************

        chk_Clientes.Checked := false;
        mmStatusMigracao.Lines.Add('CLIENTES OK');
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end; // Fim da migração de Clientes

    if chk_Secoes.Checked then begin
        //********** SECOES *************//
        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('update parametros_tb set  niveissec_par = 1');
        sqlTMP.ExecSql;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Delete From produtos_tb ');
        sqlTMP.ExecSql;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Delete From secoes_tb');
        sqlTMP.ExecSql;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('SELECT * FROM DEPARTAMENTOS ');
        ibTabelas.Open;

        if ibTabelas.RecordCount > 0 then begin
            ibTabelas.First;
            while not ibTabelas.Eof do begin
                ProgressBar1.Position := ProgressBar1.Position + 1;
                Codigo_sec := formatFloat('000',ibTabelas.FieldByName('CLAVE').AsINteger);
                StatusBar1.Panels[0].Text := 'SEÇAO : ' + Codigo_sec;
                application.ProcessMessages;
                StatusBar1.Refresh;
                // Campos
                sqlSecoes.Parameters.ParamByName('Codigo_sec').Value := Codigo_sec;
                if UpperCase(trim(padr(ibTabelas.FieldByName('NOMBRE').AsString, 15))) = 'DEFAULT' then
                    sqlSecoes.Parameters.ParamByName('Descricao_sec').Value := 'PADRAO'
                else
                    sqlSecoes.Parameters.ParamByName('Descricao_sec').Value := trim(padr(ibTabelas.FieldByName('NOMBRE').AsString, 15));
                sqlSecoes.Parameters.ParamByName('UltimaGravacao_sec').Value := Now;
                sqlSecoes.Parameters.ParamByName('UserName_usr').Value := 'MIGR***';
                sqlSecoes.ExecSql;
                // Fim Campos
                ibTabelas.Next;
            end;
        end else begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            Codigo_sec := formatFloat('000',1);
            StatusBar1.Panels[0].Text := 'SEÇAO : ' + Codigo_sec;
            application.ProcessMessages;
            StatusBar1.Refresh;
            // Campos
            sqlSecoes.Parameters.ParamByName('Codigo_sec').Value := Codigo_sec;
            sqlSecoes.Parameters.ParamByName('Descricao_sec').Value := 'PADRAO';
            sqlSecoes.Parameters.ParamByName('UltimaGravacao_sec').Value := Now;
            sqlSecoes.Parameters.ParamByName('UserName_usr').Value := 'MIGR***';
            sqlSecoes.ExecSql;
        end;

        chk_Secoes.Checked := false;
        //ShowMessage('SECOES OK');
        mmStatusMigracao.Lines.Add('SECOES OK');
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end; //Fim migracao secoes...

    if chk_Marcas.Checked then begin
        //************** MARCAS *********************************//
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Migrando Marcas';

        ProgressBar1.Max := 100;
        ProgressBar1.Position := 0;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('SELECT DISTINCT marca FROM PRODUTOS where not marca is null');
        ibTabelas.Open;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Delete From marcas_tb');
        sqlTMP.ExecSql;

        marca := 1;
        while not ibTabelas.Eof do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'Marca : ' + ibTabelas.FieldByName('MARCA').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;

            // Campos
            sqlMarcas.Parameters.ParamByName('Codigo_mar').Value := marca;
            sqlMarcas.Parameters.ParamByName('Descricao_mar').Value := padr(ibTabelas.FieldByName('marca').AsString, 20);
            sqlMarcas.Parameters.ParamByName('UltimaGravacao_mar').Value := Now;
            sqlMarcas.Parameters.ParamByName('UserName_usr').Value := 'MIGR***';
            sqlMarcas.ExecSql;
            // Fim Campos

            ibTabelas.Next;
            marca := marca + 1;
        end;
        chk_Marcas.Checked := false;
        //ShowMessage('MARCAS OK');
        mmStatusMigracao.Lines.Add('MARCAS OK');
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;//Fim migrcao marcas....


    if chk_Produtos.Checked then begin

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Select * from secoes_tb');
        sqlTMP.Open;

        if sqlTMP.RecordCount = 0 then begin
           ShowMessage('Não pode migrar produtos sem pelo menos uma seção cadastrada!');
           chk_Produtos.Checked := False;
           chk_Secoes.Checked := True;
           exit;
        end;

        /// ***********************  PRODUTOS
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Migrando Produtos';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select count(1) as Nro from ARTICULOS ');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select  *  from ARTICULOS ');
        ibTabelas.Open;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Delete From ProdutosPreco_tb ');
        sqlTMP.ExecSql;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Delete From EstoquePorLocal_tb ');
        sqlTMP.ExecSql;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Delete From Produtos_tb ');
        sqlTMP.ExecSql;

        ProgressBar1.Position := 0;
        ibTabelas.First;
        while not ibTabelas.Eof do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'Produto: ' + ibTabelas.FieldByName('DESC_LARGA').AsString + ' - '
                   + ibTabelas.FieldByName('CLAVE').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;

            // Campos
            sqlProdutos.Parameters.ParamByName('Codigo_prd').Value := ibTabelas.FieldByName('CLAVE').AsInteger;
            sqlProdutos.Parameters.ParamByName('CodFabricante_prd').value := '';
            sqlProdutos.Parameters.ParamByName('Descricao_prd').Value := padr(ibTabelas.FieldByName('DESC_LARGA').AsString, 50);

            //colocando secoes nos produtos
            Codigo_Sec := FormatFloat('000',ibTabelas.FieldByName('DEPARTAMENTO').AsInteger);

            qry_buscaSec.Close;
            qry_buscaSec.Parameters.ParamByName('Codigo_sec').value := Codigo_sec;
            qry_buscaSec.Open;

            if qry_buscasec.RecordCount > 0 then begin
                sqlProdutos.Parameters.ParamByName('Codigo_sec').value := Codigo_sec;
            end else
                sqlProdutos.Parameters.ParamByName('Codigo_sec').value := NULL;
            //fim secao produtos

            sqlProdutos.Parameters.ParamByName('Ean_prd').value := '';
            sqlProdutos.Parameters.ParamByName('Unidade_prd').value := 'UN';
            sqlProdutos.Parameters.ParamByName('UserName_usr').value := 'MIGR***';
            sqlProdutos.Parameters.ParamByName('UltimaGravacao_prd').value := NOW;
            sqlProdutos.Parameters.ParamByName('Moeda_prd').value := 'R';

            {
            //produto é balanca
            if ibTabelas.FieldByName('PESAVEL').AsString = 'SIM' then begin
              try
                  sqlProdutos.Parameters.ParamByName('Balanca_prd').value := 'S';
                  sqlProdutos.Parameters.ParamByName('PesoUnidade_prd').value := 'P';
                  sqlProdutos.Parameters.ParamByName('CodigoBal_prd').value := (((ibTabelas.FieldByName('EAN1').AsInteger)/100)-20000);
              except
                  sqlProdutos.Parameters.ParamByName('CodigoBal_prd').value := 0;
                  sqlProdutos.Parameters.ParamByName('Balanca_prd').value := 'N';
                  sqlProdutos.Parameters.ParamByName('PesoUnidade_prd').value := 'U';
              end;
            end else begin
              sqlProdutos.Parameters.ParamByName('CodigoBal_prd').value := 0;
              sqlProdutos.Parameters.ParamByName('Balanca_prd').value := 'N';
              sqlProdutos.Parameters.ParamByName('PesoUnidade_prd').value := 'U';
            end;
            //fim produto é balança
            }

            sqlProdutos.Parameters.ParamByName('Validade_prd').value := 0;

            {
            //***********************************************************inicia produtos gelados

                GELADO1 := ibTabelas.FieldByName('EAN1').AsString;
                for i := 1 to 1 do begin
                   try
                      if (GELADO1[i] = '.') then begin
                          sqlProdutos.Parameters.ParamByName('DifGelado_prd').value := 'S';
                      end else begin
                          sqlProdutos.Parameters.ParamByName('DifGelado_prd').value := 'N';
                      end;
                   except
                          sqlProdutos.Parameters.ParamByName('DifGelado_prd').value := 'N';
                   end;
                end;

            //*********************************fim produtos gelados
            }

            sqlProdutos.Parameters.ParamByName('caracTecnica_prd').value := '';
            sqlProdutos.Parameters.ParamByName('Comissao_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('DescricaoRed_prd').value :=
                padr(ibTabelas.FieldByName('DESC_CORTA').AsString, 30);
            sqlProdutos.Parameters.ParamByName('CodigoST_prd').value := null;
            sqlProdutos.Parameters.ParamByName('ApresentacaoEmbalagem_prd').value := ' ';
            sqlProdutos.Parameters.ParamByName('PerICMS_prd').value := NULL;
            sqlProdutos.Parameters.ParamByName('PerIPI_prd').value := NULL;
            sqlProdutos.Parameters.ParamByName('PermiteDecimal_prd').value := 'S';
            sqlProdutos.Parameters.ParamByName('TipodeCorrecao_prd').value := NULL;
            sqlProdutos.Parameters.ParamByName('quantporemb_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('ProdutoInativo_prd').value := 'N';
            sqlProdutos.Parameters.ParamByName('ProdutoehCelular_prd').value := 'N';
            sqlProdutos.Parameters.ParamByName('GarantiaemDias_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('GarantiaemKmHoras_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('SemiNovo_prd').value := 'N';
            sqlProdutos.Parameters.ParamByName('TipoTrib_prd').value := ' ';
            sqlProdutos.Parameters.ParamByName('SubstituicaoTrib_prd').value := 'N';
            sqlProdutos.Parameters.ParamByName('produtoehchipGSM_prd').value := 'N';
            sqlProdutos.Parameters.ParamByName('Codigo_for').value := NULL;
            sqlProdutos.Parameters.ParamByName('ABCFARMA_prd').value := NULL;
            sqlProdutos.Parameters.ParamByName('Sagra_prd').value := NULL;
            sqlProdutos.Parameters.ParamByName('UnidadeCompra_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('Codigo_lab').value := NULL;
            sqlProdutos.Parameters.ParamByName('Generico_prd').value := 'N';
            sqlProdutos.Parameters.ParamByName('AtualizaPelaABCFarma_prd').value := 'N';
            sqlProdutos.Parameters.ParamByName('AtualizaPelaSagra_prd').value := 'N';
            sqlProdutos.Parameters.ParamByName('codigo_cor').value := NULL;
            sqlProdutos.Parameters.ParamByName('codigo_col').value := NULL;
            sqlProdutos.Parameters.ParamByName('codigo_tam').value := NULL;

            // informa a marca do produto
            {
            sqlTMP.Close;
            sqlTMP.Parameters.ParamByName('Descricao_mar').value := ibTabelas.FieldByName('Marca').AsString;
            sqlTMP.Open;
            if sqlTmp.RecordCount > 0 then
                sqlProdutos.Parameters.ParamByName('codigo_mar').value := sqlTMP.FieldByName('Codigo_mar').AsInteger
            else
                sqlProdutos.Parameters.ParamByName('codigo_mar').value := Null;
            }
            //fim marca produto

            sqlProdutos.Parameters.ParamByName('descricao2_prd').value :=
                padr(ibTabelas.FieldByName('DESC_CORTA').AsString, 50);
            sqlProdutos.Parameters.ParamByName('DtCadastro_prd').value := NOW;
            sqlProdutos.Parameters.ParamByName('ProdutoOuServico_prd').value := 'P';
            sqlProdutos.Parameters.ParamByName('observacoes_prd').value := ' ';
            sqlProdutos.Parameters.ParamByName('PrecoMontagem_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('ProdutoBaixarEstoque_prd').value := NULL;
            sqlProdutos.Parameters.ParamByName('Altura_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('Largura_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('PerAcrescPerda_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('ProdutoPermiteAparelhamento_prd').value := 'N';
            sqlProdutos.Parameters.ParamByName('PerAcrescDescFinanceiro_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('ClassFiscal_prd').value := Padr(Trim(ibTabelas.FieldByName('CODNCM').AsString),10);
            //padr(ibTabelas.FieldByName('NCM').AsString, 10);
            sqlProdutos.Parameters.ParamByName('codigo_tpp').value := NULL;
            sqlProdutos.Parameters.ParamByName('PontuacaoMarka_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('tipoprod_prd').value := NULL;
            sqlProdutos.Parameters.ParamByName('pesoprod_prd').value := NULL;
            sqlProdutos.Parameters.ParamByName('Comprimento_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('PerComissaoVendedor01_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('PerComissaoVendedor02_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('PerComissaoVendedor03_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('PerComissaoSupervisor01_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('PerComissaoSupervisor02_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('PerComissaoSupervisor03_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('PerMargemIva_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('AplicReducaoComissao_prd').value := 'N';
            sqlProdutos.Parameters.ParamByName('perRedIcms_prd').value := 0;
            sqlProdutos.Parameters.ParamByName('CodigoSTPisCof_prd').value := '99';
            sqlProdutos.Parameters.ParamByName('SubstituicaoTributaria_prd').value := 'N';
            sqlProdutos.Parameters.ParamByName('tipoprodsr_prd').Value := Padr(Trim(ibTabelas.FieldByName('PROSERV').AsString),1);
            sqlProdutos.ExecSql;
            // Fim Campos
            ibTabelas.Next;
        end;
        chk_Produtos.Checked := false;
        mmStatusMigracao.Lines.Add('PRODUTOS OK');
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    if chk_Precos.Checked then begin
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Migrando PREÇOS';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select count(1) as Nro from ARTICULOS ');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select  *  from ARTICULOS ');
        ibTabelas.Open;

        ProgressBar1.Position := 0;
        ibTabelas.First;
        while not ibTabelas.Eof do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'Preco:' +
                ibTabelas.FieldByName('CLAVE').AsString + ' - ' +
                ibTabelas.FieldByName('DESC_LARGA').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;

            // Campos
            sqlProdutosPreco.Parameters.ParamByName('Codigo_prd').Value :=
                ibTabelas.FieldByName('CLAVE').AsInteger;
            sqlProdutosPreco.Parameters.ParamByName('codigo_emp').Value := 1;
            sqlProdutosPreco.Parameters.ParamByName('PrecoCompra_prd').Value :=
                ibTabelas.FieldByName('COSTOREAL').AsFloat;
            sqlProdutosPreco.Parameters.ParamByName('PrecoCusto_prd').Value :=
                ibTabelas.FieldByName('COSTOREAL').AsFloat;
            sqlProdutosPreco.Parameters.ParamByName('PrecoVenda_prd').Value :=
                ibTabelas.FieldByName('PRECIO2').AsFloat;
            sqlProdutosPreco.Parameters.ParamByName('PrecoVendaPrazo_prd').Value := 0;
            sqlProdutosPreco.Parameters.ParamByName('PrecoPromocao_prd').Value := 0;
            sqlProdutosPreco.Parameters.ParamByName('PromocaoIni_prd').Value :=
                NULL;
            sqlProdutosPreco.Parameters.ParamByName('PromocaoFim_prd').Value :=
                NULL;
            sqlProdutosPreco.Parameters.ParamByName('PrimeiraCompra_prd').Value :=
                NULL;
            sqlProdutosPreco.Parameters.ParamByName('UltimaCompra_prd').Value :=
                NULL;
            sqlProdutosPreco.Parameters.ParamByName('UltimaVenda_prd').Value :=
                NULL;
            sqlProdutosPreco.Parameters.ParamByName('Precovendaatacado_prd').Value
                := 0;
            sqlProdutosPreco.Parameters.ParamByName('DescMax_prd').Value := 0;
            sqlProdutosPreco.Parameters.ParamByName('AcrescGelado_prd').Value := 0;
            sqlProdutosPreco.Parameters.ParamByName('AcrescHorario_prd').Value := 0;

            sqlProdutosPreco.ExecSql;
            // Fim Campos

            ibTabelas.Next;
        end;
        chk_Precos.Checked := false;
        mmStatusMigracao.Lines.Add('PRECOS OK');
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    if chk_Estoque.Checked then begin
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Migrando ESTOQUE';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select count(1) as Nro from ARTICULOS ');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select  *  from ARTICULOS ');
        ibTabelas.Open;

        ProgressBar1.Position := 0;
        ibTabelas.First;
        while not ibTabelas.Eof do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'Estoque:' +
                ibTabelas.FieldByName('CLAVE').AsString +
                ibTabelas.FieldByName('DESC_LARGA').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;

            // Campos
            sqlProdutoEstoque.Parameters.ParamByName('Codigo_prd').Value := ibTabelas.FieldByName('CLAVE').AsInteger;
            sqlProdutoEstoque.Parameters.ParamByName('Codigo_lce').Value := 1;
            sqlProdutoEstoque.Parameters.ParamByName('EstAnt_prd').Value := 0;

{                ibTmp.Close;
            ibTmp.Sql.Clear;
            ibTmp.Sql.Add('select  sum(b.qtd_pedida) Qtdade from entsai a, entsai2 B, produtos c ');
            ibTmp.Sql.Add('where b.codprod = '+ ibTabelas.FieldByName('CODIGOI').AsString);
            ibTmp.Sql.Add('and a.data >= ''1901-01-01'' ');
            ibTmp.Sql.Add('and a.data <= ''2999-12-31'' ');
            ibTmp.Sql.Add('and a.codigoi = b.pedido   ');
            ibTmp.Sql.Add('and b.codprod = c.codigoi  ');
            ibTmp.Open;
            Entrada := ibTmp.FieldByName('Qtdade').AsFloat;

            ibTmp.Close;
            ibTmp.Sql.Clear;
            ibTmp.Sql.Add('select sum(S2.qtde) qtdade from vendas2 S2, vendas S ');
            ibTmp.Sql.Add('where S2.produto = '+ ibTabelas.FieldByName('CODIGOI').AsString);
            ibTmp.Sql.Add('and S.data >= ''1901-01-01'' ');
            ibTmp.Sql.Add('and S.data <= ''2999-12-31'' ');
            ibTmp.Sql.Add('AND S2.codvenda = S.CODIGOI  ');
            ibTmp.Sql.Add('and s.obs <> ''Orcamento''  ');
            ibTmp.Open;
            Saida := ibTmp.FieldByName('Qtdade').AsFloat;

            ibTmp.Close;
            ibTmp.Sql.Clear;
            ibTmp.Sql.Add('select sum(b.qtde) Qtdade from vendas a, vendas2 b ');
            ibTmp.Sql.Add('where b.produto = '+ ibTabelas.FieldByName('CODIGOI').AsString);
            ibTmp.Sql.Add('and a.data>=''1901-01-01'' ');
            ibTmp.Sql.Add('and a.data<=''2999-12-31'' ');
            ibTmp.Sql.Add('and a.codigoi = b.codvenda ');
            ibTmp.Sql.Add('and a.devoluc =''*''    ');
            ibTmp.Open;
            Devolucao := ibTmp.FieldByName('Qtdade').AsFloat;

            Estoque := ((Entrada - Saida)+ Devolucao);
}
            sqlProdutoEstoque.Parameters.ParamByName('EstAtu_prd').Value := ibTabelas.FieldByName('EXISTMATRIZ').AsInteger;
            sqlProdutoEstoque.Parameters.ParamByName('EstoqueMin_prd').Value := 0;
            sqlProdutoEstoque.Parameters.ParamByName('EstoqueMax_prd').Value := 0;
            sqlProdutoEstoque.Parameters.ParamByName('DiasMax_prd').Value := 0;
            sqlProdutoEstoque.Parameters.ParamByName('DiasMin_prd').Value := 0;
            sqlProdutoEstoque.Parameters.ParamByName('QtdeReservada_prd').Value := 0;
            sqlProdutoEstoque.Parameters.ParamByName('QtdeCondicional_prd').Value := 0;
            sqlProdutoEstoque.Parameters.ParamByName('QtdeEmOS_prd').Value := 0;
            sqlProdutoEstoque.Parameters.ParamByName('Codigo_loc').Value := null;
            sqlProdutoEstoque.Parameters.ParamByName('QtdInventario_prd').Value := null;

            sqlProdutoEstoque.ExecSql;
            // Fim Campos
            ibTabelas.Next;
        end;
        chk_Estoque.Checked := false;
        mmStatusMigracao.Lines.Add('ESTOQUE OK');
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    if chk_vendedores.Checked then begin
        //************** VENDEDORES  *********************************//
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Migrando Vendedores';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select count(1) as Nro from PRESTADORES ');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('SELECT * FROM PRESTADORES ');
        ibTabelas.Open;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Delete From Vendedores_tb ');
        sqlTMP.ExecSql;

        while not ibTabelas.Eof do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'Vendedor:' +
                ibTabelas.FieldByName('NOMBRE').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;

            // Campos
            sqlVendedores.Parameters.ParamByName('Codigo_ven').Value := ibTabelas.FieldByName('CLAVE').AsInteger;
            sqlVendedores.Parameters.ParamByName('Nome_ven').Value := ibTabelas.FieldByName('NOMBRE').AsString;
            sqlVendedores.Parameters.ParamByName('Endereco_ven').Value := ibTabelas.FieldByName('CALLE').AsString;
            sqlVendedores.Parameters.ParamByName('Bairro_ven').Value := ibTabelas.FieldByName('COLONIA').AsString;
            sqlVendedores.Parameters.ParamByName('Cidade_ven').Value := ibTabelas.FieldByName('LOCALIDAD').AsString;
            sqlVendedores.Parameters.ParamByName('Cep_ven').Value := ibTabelas.FieldByName('CP').AsString;
            sqlVendedores.Parameters.ParamByName('UF_ven').Value := ibTabelas.FieldByName('ESTADO').AsString;
            sqlVendedores.Parameters.ParamByName('Fone1_ven').Value := ibTabelas.FieldByName('TELEFONO').AsString;
            sqlVendedores.Parameters.ParamByName('Fone2_ven').Value := NULL;
            sqlVendedores.Parameters.ParamByName('Fone3_ven').Value := NULL;
            sqlVendedores.Parameters.ParamByName('Fax_ven').Value := ibTabelas.FieldByName('FAX').AsString;
            sqlVendedores.Parameters.ParamByName('Celular_ven').Value := NULL;
            sqlVendedores.Parameters.ParamByName('Celular2_ven').Value := NULL;
            sqlVendedores.Parameters.ParamByName('Nasc_ven').Value := ibTabelas.FieldByName('ANIVER').AsDateTime;
            sqlVendedores.Parameters.ParamByName('CPF_ven').Value := ibTabelas.FieldByName('RFC').AsString;
            sqlVendedores.Parameters.ParamByName('Email_ven').Value := ibTabelas.FieldByName('ECORREO').AsString;
            sqlVendedores.Parameters.ParamByName('ValorHora_ven').Value := ibTabelas.FieldByName('VALORHORA').AsFloat;
            sqlVendedores.Parameters.ParamByName('ValorHoraCusto_ven').Value := ibTabelas.FieldByName('CUSTOHORA').AsFloat;
            sqlVendedores.Parameters.ParamByName('UserName_usr').Value := 'MIGR***';
            sqlVendedores.Parameters.ParamByName('UltimaGravacao_ven').Value := Now;
            sqlVendedores.Parameters.ParamByName('RecebeComissao_ven').Value := 'S';
            sqlVendedores.Parameters.ParamByName('VendedorAtivo_ven').Value := 'S';
            sqlVendedores.ExecSql;
            // Fim Campos
            ibTabelas.Next;
        end;
        mmStatusMigracao.Lines.Add('VENDEDORES OK');
        chk_vendedores.Checked := false;
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    if chk_Fornecedor.Checked then begin
        //************** FORNECEDORES  *********************************//
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Migrando FORNECEDORES';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select count(1) as Nro from PROVEEDORES ');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('SELECT * FROM PROVEEDORES ');
        ibTabelas.Open;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Delete From FORNECEDOR_TB ');
        sqlTMP.ExecSql;

        ProgressBar1.Position := 0;
        ibTabelas.First;
        while not ibTabelas.Eof do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'FORNECEDOR:' +
                ibTabelas.FieldByName('CLAVE').AsString+' - '+
                ibTabelas.FieldByName('NOMBRE').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;

            // Campos
            sqlFornecedores.Parameters.ParamByName('Codigo_for').Value := ibTabelas.FieldByName('CLAVE').AsInteger;
            sqlFornecedores.Parameters.ParamByName('razao_for').Value := trim(padr(ibTabelas.FieldByName('NOMBREFISCAL').AsString, 40));
            sqlFornecedores.Parameters.ParamByName('fantasia_for').Value := trim(padr(ibTabelas.FieldByName('NOMBRE').AsString, 40));
            sqlFornecedores.Parameters.ParamByName('CgcCpf_for').Value := padr(trim(ibTabelas.FieldByName('RFC').AsString),18);
            sqlFornecedores.Parameters.ParamByName('InscRg_for').Value := ibTabelas.FieldByName('IERG').AsString;
            sqlFornecedores.Parameters.ParamByName('Endereco_for').Value := trim(padr(Trim(ibTabelas.FieldByName('CALLE').AsString)+','+
            Trim(ibTabelas.FieldByName('NUMERO').AsString), 35));
            sqlFornecedores.Parameters.ParamByName('Bairro_for').Value := trim(padr(ibTabelas.FieldByName('COLONIA').AsString, 30));
            sqlFornecedores.Parameters.ParamByName('Cidade_for').Value := ibTabelas.FieldByName('LOCALIDAD').AsString;
            sqlFornecedores.Parameters.ParamByName('Cep_for').Value := ibTabelas.FieldByName('CP').AsString;
            sqlFornecedores.Parameters.ParamByName('UF_for').Value := ibTabelas.FieldByName('ESTADO').AsString;
            sqlFornecedores.Parameters.ParamByName('Fone1_for').Value := trim(padr(ibTabelas.FieldByName('TELEFONO').AsString, 16));
            sqlFornecedores.Parameters.ParamByName('Fone2_for').Value := trim(padr(ibTabelas.FieldByName('TELEFONO2').AsString, 16));
            sqlFornecedores.Parameters.ParamByName('Fax_for').Value := trim(padr(ibTabelas.FieldByName('FAX').AsString, 16));
            sqlFornecedores.Parameters.ParamByName('Observ_for').Value := trim(Padr('CONT.'+Trim(ibTabelas.FieldByName('ENCARGADO').AsString)+
            Trim(ibTabelas.FieldByName('CALLE').AsString)+','+Trim(ibTabelas.FieldByName('NUMERO').AsString)+
            ' '+Trim(ibTabelas.FieldByName('OBSERVACAO').AsString), 300));
            sqlFornecedores.Parameters.ParamByName('Email_for').Value := PADR(Trim(ibTabelas.FieldByName('ECORREO').AsString),40);
            sqlFornecedores.Parameters.ParamByName('HomePage_for').Value := PADR(Trim(ibTabelas.FieldByName('HOMEPAGE').AsString),50);
            sqlFornecedores.Parameters.ParamByName('UserName_usr').value := 'MIGR***';
            sqlFornecedores.Parameters.ParamByName('UltimaGravacao_for').value := Now;
            sqlFornecedores.ExecSql;
            // Fim Campos

            ibTabelas.Next;
        end;
        chk_Fornecedor.Checked := false;
        mmStatusMigracao.Lines.Add('FORNECEDORES OK');
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    if chk_CentroDeCusto.Checked then begin
        //**************  CENTROC_TB *********************************//
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Migrando CENTROS DE CUSTO';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select count(1) as Nro from CENTROCUSTO ');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('SELECT *  FROM CENTROCUSTO');
        ibTabelas.Open;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Delete From CENTROC_TB ');
        sqlTMP.ExecSql;

        while not ibTabelas.Eof do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'Centro Custo:' +
                ibTabelas.FieldByName('NOMBRE').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;

            // Campos
            sqlCentroC.Parameters.ParamByName('Codigo_cnc').Value :=
                FormatFloat('000',
                ibTabelas.FieldByName('CLAVE').AsInteger);
            sqlCentroC.Parameters.ParamByName('Descricao_Cnc').Value :=
                trim(padr(ibTabelas.FieldByName('NOMBRE').AsString, 35));
            sqlCentroC.Parameters.ParamByName('UserName_usr').Value := 'MIGR***';
            sqlCentroC.Parameters.ParamByName('UltimaGravacao_cnc').Value := Now;
            sqlCentroC.ExecSql;
            // Fim Campos

            ibTabelas.Next;
        end;
        mmStatusMigracao.Lines.Add('CENTRO DE CUSTO OK');
        chk_CentroDeCusto.Checked := false;
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    if chk_PlanodeContas.Checked then begin
        //**************  plancn_tb *********************************//
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Migrando PLANO DE CONTAS';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select count(1) as Nro from CTBPLANOCONTAS ');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('SELECT *  FROM CTBPLANOCONTAS');
        ibTabelas.Open;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Delete From plancn_tb ');
        sqlTMP.ExecSql;

        while not ibTabelas.Eof do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'Plano de Contas:' +
                ibTabelas.FieldByName('DESCRICAO').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;

            // Campos
            IF Length(ibTabelas.FieldByName('CONTAMSK').AsString) = 1 then begin
              sqlPlanCN.Parameters.ParamByName('Codigo_plc').Value := FormatFloat('000', ibTabelas.FieldByName('CONTAMSK').AsInteger);
            end else if Length(ibTabelas.FieldByName('CONTAMSK').AsString) = 3 then begin
              sqlPlanCN.Parameters.ParamByName('Codigo_plc').Value :=
              FormatFloat('000',StrToInt(Copy(ibTabelas.FieldByName('CONTAMSK').AsString,1,1)))
              +'.'+FormatFloat('000', StrToInt(Copy(ibTabelas.FieldByName('CONTAMSK').AsString,3,1)));
            end else if Length(ibTabelas.FieldByName('CONTAMSK').AsString) = 6 then Begin
              sqlPlanCN.Parameters.ParamByName('Codigo_plc').Value :=
              FormatFloat('000', StrToInt(Copy(ibTabelas.FieldByName('CONTAMSK').AsString,1,1)))
              +'.'+FormatFloat('000', StrToInt(Copy(ibTabelas.FieldByName('CONTAMSK').AsString,3,1)))
              +'.'+FormatFloat('000', StrToInt(Copy(ibTabelas.FieldByName('CONTAMSK').AsString,5,2)));
            end else if Length(ibTabelas.FieldByName('CONTAMSK').AsString) = 9 then begin
              sqlPlanCN.Parameters.ParamByName('Codigo_plc').Value :=
              FormatFloat('000', StrToInt(Copy(ibTabelas.FieldByName('CONTAMSK').AsString,1,1)))
              +'.'+FormatFloat('000', StrToInt(Copy(ibTabelas.FieldByName('CONTAMSK').AsString,3,1)))
              +'.'+FormatFloat('000', StrToInt(Copy(ibTabelas.FieldByName('CONTAMSK').AsString,5,2)))
              +'.'+FormatFloat('000', StrToInt(Copy(ibTabelas.FieldByName('CONTAMSK').AsString,8,2)));
            end else if Length(ibTabelas.FieldByName('CONTAMSK').AsString) = 14 then begin
              sqlPlanCN.Parameters.ParamByName('Codigo_plc').Value :=
              FormatFloat('000', StrToInt(Copy(ibTabelas.FieldByName('CONTAMSK').AsString,1,1)))
              +'.'+FormatFloat('000', StrToInt(Copy(ibTabelas.FieldByName('CONTAMSK').AsString,3,1)))
              +'.'+FormatFloat('000', StrToInt(Copy(ibTabelas.FieldByName('CONTAMSK').AsString,5,2)))
              +'.'+FormatFloat('000', StrToInt(Copy(ibTabelas.FieldByName('CONTAMSK').AsString,8,2)))
              +'.'+FormatFloat('000', StrToInt(Copy(ibTabelas.FieldByName('CONTAMSK').AsString,12,3)));
            end;


            {
            FOR  I = 1 TO Length(ibTabelas.FieldByName('CONTAMSK').AsString)
            end;

            if ibTabelas.FieldByName('CONTAMSK').AsInteger < 1000 then begin
                sqlPlanCN.Parameters.ParamByName('Codigo_plc').Value := FormatFloat('000', ibTabelas.FieldByName('CODIGOI').AsInteger);
            end else begin
//                sqlPlanCN.Parameters.ParamByName('Codigo_plc').Value := FormatFloat('000', (ibTabelas.FieldByName('CODIGOI').AsInteger - 500));
            end;
            }

            sqlPlanCN.Parameters.ParamByName('Descricao_plc').Value :=
                trim(padr(ibTabelas.FieldByName('DESCRICAO').AsString, 40));
            sqlPlanCN.Parameters.ParamByName('UserName_usr').Value := 'MIGR***';
            sqlPlanCN.Parameters.ParamByName('UltimaGravacao_plc').Value := Now;
            sqlPlanCN.ExecSql;
            // Fim Campos

            ibTabelas.Next;
        end;
        mmStatusMigracao.Lines.Add('PLANO DE CONTAS OK');
        chk_PlanodeContas.Checked := false;
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    if chk_Receber.Checked then begin
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Migrando RECEBER';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select count(1) as Nro from xcobrar');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select * from xcobrar order by clave');
        ibTabelas.Open;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Delete From Receber_tb');
        sqlTMP.ExecSql;

        ProgressBar1.Position := 0;
        ibTabelas.First;
        while not ibTabelas.Eof do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'Receber:' +
               ibTabelas.FieldByName('CLAVE').AsString + '-CLIENTE: ' +
               ibTabelas.FieldByName('CLIENTE').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;

            //ABERTOS ************************************************************
            if (RG_Receber.ItemIndex = 0) or (RG_Receber.ItemIndex = 2) then begin
                if (ibTabelas.FieldByName('CLIENTE').AsString <> '') and (ibTabelas.FieldByName('ESTATUS').AsString = 'A') THEN BEGIN


                    // Descomentar esta linha somente quando for Debugar paa encontrar algum erro
                    if MostraMensagem = True then begin
                       ShowMessage('Somente os em Aberto...' +#13+ 'Comentar este código depois');
                       MostraMensagem := False;
                    end;


                    // INICIO CAMPOS
                    sqlReceber.Parameters.ParamByName('Parcela_rec').Value := 1;
                    sqlReceber.Parameters.ParamByName('TotParcela_rec').Value := 1;
                    sqlReceber.Parameters.ParamByName('TipoVenda_rec').Value := 'P';

                    // COLOCA CLIENTE
                    sqlTMP.Close;
                    sqlTMP.Sql.Clear;
                    sqlTMP.Sql.Add('select codigo_cli From Clientes_tb where codigo_cli = '+ ibTabelas.FieldByName('CLIENTE').AsString);
                    sqlTMP.Open;

                    if sqlTMP.RecordCount > 0 then begin
                      sqlReceber.Parameters.ParamByName('Codigo_cli').Value := ibTabelas.FieldByName('CLIENTE').AsInteger;
                    end else begin
                      ibTabelas.Next;
                    end;

//                    sqlReceber.Parameters.ParamByName('Cupom_mvc').Value := Null;
                    if ibTabelas.FieldByName('VENTA').AsInteger > 0 then
                        sqlReceber.Parameters.ParamByName('Cupom_mvc').Value := ibTabelas.FieldByName('VENTA').AsInteger
                    else
                        sqlReceber.Parameters.ParamByName('Cupom_mvc').Value := Null;

                    sqlReceber.Parameters.ParamByName('DataMov_rec').Value := ibTabelas.FieldByName('DATALAN').AsDateTime;
//                    sqlReceber.Parameters.ParamByName('Valor_rec').Value := ibTabelas.FieldByName('IMPORTE').AsFloat - ibTabelas.FieldByName('PAGADO').AsFloat;
                    sqlReceber.Parameters.ParamByName('Valor_rec').Value := ibTabelas.FieldByName('IMPORTE').AsFloat;

                    if Year(ibTabelas.FieldByName('PROXIMOPAGO').AsDateTime) > 1900 then begin
                          sqlReceber.Parameters.ParamByName('Vencto_rec').Value := ibTabelas.FieldByName('PROXIMOPAGO').AsDateTime;
                    end else begin
                          sqlReceber.Parameters.ParamByName('Vencto_rec').Value := '1900-01-01';
                    end;

                    sqlReceber.Parameters.ParamByName('Observ_rec').Value := PADR(
                        'CHAVE: '+TRIM(ibTabelas.FieldByName('CLAVE').AsString) +'-'+
                        TRIM(ibTabelas.FieldByName('OBSERVACAO').AsString) +'-'+
                        TRIM(ibTabelas.FieldByName('DOCUMENTO').AsString+'ESTATUS: '+
                        TRIM(ibTabelas.FieldByName('ESTATUS').AsString)),255);
                    sqlReceber.Parameters.ParamByName('DataPgto_rec').Value := Null;
                    sqlReceber.Parameters.ParamByName('ValorPago_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('TipoPgto_rec').Value := 'CRD';
                    sqlReceber.Parameters.ParamByName('CpfCgc_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('Codigo_bco').Value := 0;
                    sqlReceber.Parameters.ParamByName('Agencia_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('Conta_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('Cheque_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('TipoCartao_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('Codigo_ven').Value := Null;
                    sqlReceber.Parameters.ParamByName('Codigo_dvc').Value := Null;
                    sqlReceber.Parameters.ParamByName('BancoBoleto_rec').Value := Null;
                    sqlReceber.Parameters.ParamByName('Desconto_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('NossoNumero_rec').Value := Null;
                    sqlReceber.Parameters.ParamByName('UserName_usr').Value := 'MIGR***';
                    sqlReceber.Parameters.ParamByName('UltimoAcesso_rec').Value := Now;
                    sqlReceber.Parameters.ParamByName('Autorizacao_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Emitente_rec').Value := '';
                    sqlReceber.Parameters.ParamByName('NumeroBoleto_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('dt1aCarta_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('dt2aCarta_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('codigo_os').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Codigo_prd').Value := NULL;
                    sqlReceber.Parameters.ParamByName('NumeroHexa_hxa').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Acrescimo_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('Fatura_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Codigo_rma').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Codigo_trn').Value := NULL;
                    sqlReceber.Parameters.ParamByName('tipoBaixa_rec').Value := Null;
                    sqlReceber.Parameters.ParamByName('Baixa_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('venctAnterior_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('codigo_con').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Codigo_cxr').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Terminal_cxr').Value := 1;
                    sqlReceber.Parameters.ParamByName('Codigo_mvb').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Codigo_pcr').Value := NULL;
                    sqlReceber.Parameters.ParamByName('venctoOriginal_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('ValorOriginal_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('NumeroDuplicata_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('NumeroFatura_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Pedidos_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Devolucoes_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Faturas_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('ExportarArquivoRemessa_rec').Value :=NULL;
                    sqlReceber.Parameters.ParamByName('codigo_rep').Value := NULL;
                    sqlReceber.Parameters.ParamByName('ValorCheque_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('OrdensServico_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Codigo_emp').Value := 1;
                    sqlReceber.Parameters.ParamByName('DataDevCheque_rec').Value := null;
                    sqlReceber.Parameters.ParamByName('codigo_bxr').Value := NULL;
                    sqlReceber.Parameters.ParamByName('TaxaAdmCartao_rec').Value := 0;
                    sqlReceber.ExecSql;

                    //SE PAGO PARCIAL INCLUI TITULO COMO PAGO DO VALOR PAGO.
                    IF (ibTabelas.FieldByName('PAGADO').AsFloat > 0) THEN BEGIN

                        // INICIO CAMPOS
                        sqlReceber.Parameters.ParamByName('Parcela_rec').Value := 1;
                        sqlReceber.Parameters.ParamByName('TotParcela_rec').Value := 1;
                        sqlReceber.Parameters.ParamByName('TipoVenda_rec').Value := 'P';

                        // COLOCA CLIENTE
                        sqlTMP.Close;
                        sqlTMP.Sql.Clear;
                        sqlTMP.Sql.Add('select codigo_cli From Clientes_tb where codigo_cli = '+ ibTabelas.FieldByName('CLIENTE').AsString);
                        sqlTMP.Open;

                        if sqlTMP.RecordCount > 0 then begin
                          sqlReceber.Parameters.ParamByName('Codigo_cli').Value := ibTabelas.FieldByName('CLIENTE').AsInteger;
                        end else begin
                          ibTabelas.Next;
                        end;

//                        sqlReceber.Parameters.ParamByName('Cupom_mvc').Value := Null;
                        if ibTabelas.FieldByName('VENTA').AsInteger > 0 then
                            sqlReceber.Parameters.ParamByName('Cupom_mvc').Value := ibTabelas.FieldByName('VENTA').AsInteger
                        else
                            sqlReceber.Parameters.ParamByName('Cupom_mvc').Value := Null;

                        sqlReceber.Parameters.ParamByName('DataMov_rec').Value := ibTabelas.FieldByName('DATALAN').AsDateTime;
                        sqlReceber.Parameters.ParamByName('Valor_rec').Value := ibTabelas.FieldByName('IMPORTE').AsFloat - ibTabelas.FieldByName('PAGADO').AsFloat;

                        if Year(ibTabelas.FieldByName('PROXIMOPAGO').AsDateTime) > 1900 then begin
                              sqlReceber.Parameters.ParamByName('Vencto_rec').Value := ibTabelas.FieldByName('PROXIMOPAGO').AsDateTime;
                        end else begin
                              sqlReceber.Parameters.ParamByName('Vencto_rec').Value := '1900-01-01';
                        end;

                        sqlReceber.Parameters.ParamByName('Observ_rec').Value := PADR(
                            'CHAVE: '+TRIM(ibTabelas.FieldByName('CLAVE').AsString) +'-'+
                            TRIM(ibTabelas.FieldByName('OBSERVACAO').AsString) +'-'+
                            TRIM(ibTabelas.FieldByName('DOCUMENTO').AsString+'ESTATUS: '+
                            TRIM(ibTabelas.FieldByName('ESTATUS').AsString)) + ' - TP: PARCIAL',255);


                        //COLOCA TITULO COMO JÁ PAGO
                        if Year(ibTabelas.FieldByName('FECHA').AsDateTime) > 1900 then begin
                              sqlReceber.Parameters.ParamByName('DataPgto_rec').Value := ibTabelas.FieldByName('FECHA').AsDateTime;
                        end else begin
                              sqlReceber.Parameters.ParamByName('DataPgto_rec').Value := '1900-01-01';
                        end;

                        sqlReceber.Parameters.ParamByName('ValorPago_rec').Value := ibTabelas.FieldByName('PAGADO').AsFloat;
                        //FIM COLOCA TITULO COMO JÁ PAGO

                        sqlReceber.Parameters.ParamByName('TipoPgto_rec').Value := 'CRD';
                        sqlReceber.Parameters.ParamByName('CpfCgc_rec').Value := 0;
                        sqlReceber.Parameters.ParamByName('Codigo_bco').Value := 0;
                        sqlReceber.Parameters.ParamByName('Agencia_rec').Value := 0;
                        sqlReceber.Parameters.ParamByName('Conta_rec').Value := 0;
                        sqlReceber.Parameters.ParamByName('Cheque_rec').Value := 0;
                        sqlReceber.Parameters.ParamByName('TipoCartao_rec').Value := 0;
                        sqlReceber.Parameters.ParamByName('Codigo_ven').Value := Null;
                        sqlReceber.Parameters.ParamByName('Codigo_dvc').Value := Null;
                        sqlReceber.Parameters.ParamByName('BancoBoleto_rec').Value := Null;
                        sqlReceber.Parameters.ParamByName('Desconto_rec').Value := 0;
                        sqlReceber.Parameters.ParamByName('NossoNumero_rec').Value := Null;
                        sqlReceber.Parameters.ParamByName('UserName_usr').Value := 'MIGR***';
                        sqlReceber.Parameters.ParamByName('UltimoAcesso_rec').Value := Now;
                        sqlReceber.Parameters.ParamByName('Autorizacao_rec').Value := NULL;
                        sqlReceber.Parameters.ParamByName('Emitente_rec').Value := '';
                        sqlReceber.Parameters.ParamByName('NumeroBoleto_rec').Value := 0;
                        sqlReceber.Parameters.ParamByName('dt1aCarta_rec').Value := NULL;
                        sqlReceber.Parameters.ParamByName('dt2aCarta_rec').Value := NULL;
                        sqlReceber.Parameters.ParamByName('codigo_os').Value := NULL;
                        sqlReceber.Parameters.ParamByName('Codigo_prd').Value := NULL;
                        sqlReceber.Parameters.ParamByName('NumeroHexa_hxa').Value := NULL;
                        sqlReceber.Parameters.ParamByName('Acrescimo_rec').Value := 0;
                        sqlReceber.Parameters.ParamByName('Fatura_rec').Value := NULL;
                        sqlReceber.Parameters.ParamByName('Codigo_rma').Value := NULL;
                        sqlReceber.Parameters.ParamByName('Codigo_trn').Value := NULL;
                        sqlReceber.Parameters.ParamByName('tipoBaixa_rec').Value := Null;
                        sqlReceber.Parameters.ParamByName('Baixa_rec').Value := NULL;
                        sqlReceber.Parameters.ParamByName('venctAnterior_rec').Value := NULL;
                        sqlReceber.Parameters.ParamByName('codigo_con').Value := NULL;
                        sqlReceber.Parameters.ParamByName('Codigo_cxr').Value := NULL;
                        sqlReceber.Parameters.ParamByName('Terminal_cxr').Value := 1;
                        sqlReceber.Parameters.ParamByName('Codigo_mvb').Value := NULL;
                        sqlReceber.Parameters.ParamByName('Codigo_pcr').Value := NULL;
                        sqlReceber.Parameters.ParamByName('venctoOriginal_rec').Value := NULL;
                        sqlReceber.Parameters.ParamByName('ValorOriginal_rec').Value := NULL;
                        sqlReceber.Parameters.ParamByName('NumeroDuplicata_rec').Value := NULL;
                        sqlReceber.Parameters.ParamByName('NumeroFatura_rec').Value := NULL;
                        sqlReceber.Parameters.ParamByName('Pedidos_rec').Value := NULL;
                        sqlReceber.Parameters.ParamByName('Devolucoes_rec').Value := NULL;
                        sqlReceber.Parameters.ParamByName('Faturas_rec').Value := NULL;
                        sqlReceber.Parameters.ParamByName('ExportarArquivoRemessa_rec').Value :=NULL;
                        sqlReceber.Parameters.ParamByName('codigo_rep').Value := NULL;
                        sqlReceber.Parameters.ParamByName('ValorCheque_rec').Value := 0;
                        sqlReceber.Parameters.ParamByName('OrdensServico_rec').Value := NULL;
                        sqlReceber.Parameters.ParamByName('Codigo_emp').Value := 1;
                        sqlReceber.Parameters.ParamByName('DataDevCheque_rec').Value := null;
                        sqlReceber.Parameters.ParamByName('codigo_bxr').Value := NULL;
                        sqlReceber.Parameters.ParamByName('TaxaAdmCartao_rec').Value := 0;
                        sqlReceber.ExecSql;
                        //FIM CAMPOS
                    end;
                end;
            end;

            //FECHADO/PAGOS *********************************
            if (RG_Receber.ItemIndex = 1) or (RG_Receber.ItemIndex = 2) then begin
//                if (ibTabelas.FieldByName('CLIENTE').AsString <> '') and ((ibTabelas.FieldByName('ESTATUS').AsString = 'C') OR (ibTabelas.FieldByName('ESTATUS').AsString = 'P')) THEN BEGIN
                if (ibTabelas.FieldByName('CLIENTE').AsInteger > 0) and (Trim(ibTabelas.FieldByName('ESTATUS').AsString) <> 'A') THEN BEGIN

                    // Descomentar esta linha somente quando for Debugar paa encontrar algum erro
//                    if MostraMensagem = True then begin
//                       ShowMessage('Somente Já Pagos...' +#13+ 'Comentar este código depois');
//                       MostraMensagem := False;
//                    end;

                    // INICIO CAMPOS
                    sqlReceber.Parameters.ParamByName('Parcela_rec').Value := 1;
                    sqlReceber.Parameters.ParamByName('TotParcela_rec').Value := 1;
                    sqlReceber.Parameters.ParamByName('TipoVenda_rec').Value := 'P';

                    // COLOCA CLIENTE
                    sqlTMP.Close;
                    sqlTMP.Sql.Clear;
                    sqlTMP.Sql.Add('select codigo_cli From Clientes_tb where codigo_cli = '+ ibTabelas.FieldByName('CLIENTE').AsString);
                    sqlTMP.Open;

                    if sqlTMP.RecordCount > 0 then begin
                      sqlReceber.Parameters.ParamByName('Codigo_cli').Value := ibTabelas.FieldByName('CLIENTE').AsInteger;
                    end else begin
                      ibTabelas.Next;
                    end;

//                    sqlReceber.Parameters.ParamByName('Cupom_mvc').Value := Null;
                    if ibTabelas.FieldByName('VENTA').AsInteger > 0 then
                        sqlReceber.Parameters.ParamByName('Cupom_mvc').Value := ibTabelas.FieldByName('VENTA').AsInteger
                    else
                        sqlReceber.Parameters.ParamByName('Cupom_mvc').Value := Null;

                    sqlReceber.Parameters.ParamByName('DataMov_rec').Value := ibTabelas.FieldByName('DATALAN').AsDateTime;
//                    sqlReceber.Parameters.ParamByName('Valor_rec').Value := ibTabelas.FieldByName('IMPORTE').AsFloat - ibTabelas.FieldByName('PAGADO').AsFloat;
                    sqlReceber.Parameters.ParamByName('Valor_rec').Value := ibTabelas.FieldByName('IMPORTE').AsFloat;

                    if Year(ibTabelas.FieldByName('PROXIMOPAGO').AsDateTime) > 1900 then begin
                          sqlReceber.Parameters.ParamByName('Vencto_rec').Value := ibTabelas.FieldByName('PROXIMOPAGO').AsDateTime;
                    end else begin
                          sqlReceber.Parameters.ParamByName('Vencto_rec').Value := '1900-01-01';
                    end;

                    sqlReceber.Parameters.ParamByName('Observ_rec').Value := PADR(
                        'CHAVE: '+TRIM(ibTabelas.FieldByName('CLAVE').AsString) +'-'+
                        TRIM(ibTabelas.FieldByName('OBSERVACAO').AsString) +'-'+
                        TRIM(ibTabelas.FieldByName('DOCUMENTO').AsString+'ESTATUS: '+
                        TRIM(ibTabelas.FieldByName('ESTATUS').AsString)),255);

                    //COLOCA TITULO COMO JÁ PAGO
                    if Year(ibTabelas.FieldByName('FECHA').AsDateTime) > 1900 then begin
                          sqlReceber.Parameters.ParamByName('DataPgto_rec').Value := ibTabelas.FieldByName('FECHA').AsDateTime;
                    end else begin
                          sqlReceber.Parameters.ParamByName('DataPgto_rec').Value := '1900-01-01';
                    end;

{                    IF (ibTabelas.FieldByName('PAGADO').AsFloat > 0.01) THEN BEGIN
                      sqlReceber.Parameters.ParamByName('ValorPago_rec').Value := ibTabelas.FieldByName('PAGADO').AsFloat;
                    END ELSE BEGIN
                      sqlReceber.Parameters.ParamByName('ValorPago_rec').Value := 0.01;
                    end;
}

                     sqlReceber.Parameters.ParamByName('ValorPago_rec').Value := ibTabelas.FieldByName('PAGADO').AsFloat;
                    //FIM COLOCA TITULO COMO JÁ PAGO

                    sqlReceber.Parameters.ParamByName('TipoPgto_rec').Value := 'CRD';
                    sqlReceber.Parameters.ParamByName('CpfCgc_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('Codigo_bco').Value := 0;
                    sqlReceber.Parameters.ParamByName('Agencia_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('Conta_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('Cheque_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('TipoCartao_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('Codigo_ven').Value := Null;
                    sqlReceber.Parameters.ParamByName('Codigo_dvc').Value := Null;
                    sqlReceber.Parameters.ParamByName('BancoBoleto_rec').Value := Null;
                    sqlReceber.Parameters.ParamByName('Desconto_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('NossoNumero_rec').Value := Null;
                    sqlReceber.Parameters.ParamByName('UserName_usr').Value := 'MIGR***';
                    sqlReceber.Parameters.ParamByName('UltimoAcesso_rec').Value := Now;
                    sqlReceber.Parameters.ParamByName('Autorizacao_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Emitente_rec').Value := '';
                    sqlReceber.Parameters.ParamByName('NumeroBoleto_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('dt1aCarta_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('dt2aCarta_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('codigo_os').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Codigo_prd').Value := NULL;
                    sqlReceber.Parameters.ParamByName('NumeroHexa_hxa').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Acrescimo_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('Fatura_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Codigo_rma').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Codigo_trn').Value := NULL;
                    sqlReceber.Parameters.ParamByName('tipoBaixa_rec').Value := Null;
                    sqlReceber.Parameters.ParamByName('Baixa_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('venctAnterior_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('codigo_con').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Codigo_cxr').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Terminal_cxr').Value := 1;
                    sqlReceber.Parameters.ParamByName('Codigo_mvb').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Codigo_pcr').Value := NULL;
                    sqlReceber.Parameters.ParamByName('venctoOriginal_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('ValorOriginal_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('NumeroDuplicata_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('NumeroFatura_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Pedidos_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Devolucoes_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Faturas_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('ExportarArquivoRemessa_rec').Value :=NULL;
                    sqlReceber.Parameters.ParamByName('codigo_rep').Value := NULL;
                    sqlReceber.Parameters.ParamByName('ValorCheque_rec').Value := 0;
                    sqlReceber.Parameters.ParamByName('OrdensServico_rec').Value := NULL;
                    sqlReceber.Parameters.ParamByName('Codigo_emp').Value := 1;
                    sqlReceber.Parameters.ParamByName('DataDevCheque_rec').Value := null;
                    sqlReceber.Parameters.ParamByName('codigo_bxr').Value := NULL;
                    sqlReceber.Parameters.ParamByName('TaxaAdmCartao_rec').Value := 0;
                    sqlReceber.ExecSql;
                end;
            end;
            // Fim Campos
            ibTabelas.Next;
        end;
        mmStatusMigracao.Lines.Add('RECEBER OK');
        chk_Receber.Checked := false;
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    if chk_Pagar.Checked then begin
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Migrando PAGAR';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select count(1) as Nro from XPAGAR ');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select * from XPAGAR order by Clave');
        ibTabelas.Open;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Delete From PAGAR_tb');
        sqlTMP.ExecSql;

        ProgressBar1.Position := 0;
        ibTabelas.First;
        while not ibTabelas.Eof do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'Docto:' +
                ibTabelas.FieldByName('CLAVE').AsString + 'FORNECEDOR: '+
                ibTabelas.FieldByName('PROVEEDOR').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;

            //ABERTOS ******************************
            if (RG_Pagar.ItemIndex = 1) or (RG_Pagar.ItemIndex = 2) then begin
                if (ibTabelas.FieldByName('PROVEEDOR').AsString <> '') and (ibTabelas.FieldByName('ESTATUS').AsString = 'A') THEN BEGIN

                    sqlPagar.Parameters.ParamByName('Parcela_pag').value := 1;
                    sqlPagar.Parameters.ParamByName('TotalParc_pag').value := 1;
                    if Year(ibTabelas.FieldByName('PROXIMOPAGO').AsDateTime) > 1900 then begin
                          sqlPagar.Parameters.ParamByName('Vencto_pag').value := ibTabelas.FieldByName('PROXIMOPAGO').AsDateTime;
                    end else begin
                          sqlPagar.Parameters.ParamByName('Vencto_pag').value := '1900-01-01';
                    end;

                    //FORNECEDOR
                    sqlTMP.Close;
                    sqlTMP.SQL.Clear;
                    sqlTMP.SQL.Add('SELECT CODIGO_FOR FROM Fornecedor_tb WHERE Codigo_for = '+ibTabelas.FieldByName('PROVEEDOR').AsString);
                    sqlTMP.Open;

                    IF sqlTMP.RecordCount > 0 THEN BEGIN
                      sqlPagar.Parameters.ParamByName('Codigo_for').value := ibTabelas.FieldByName('PROVEEDOR').AsInteger;
                    End ELSE BEGIN
                      sqlPagar.Parameters.ParamByName('Codigo_for').value := NULL;
                    end;
                    //FIM FORNECEDOR

                    sqlPagar.Parameters.ParamByName('Codigo_cmp').value := null;
                    sqlPagar.Parameters.ParamByName('Datamov_pag').value := ibTabelas.FieldByName('DATALAN').AsDateTime;
                    sqlPagar.Parameters.ParamByName('Valor_pag').value := ibTabelas.FieldByName('IMPORTE').AsFloat - ibTabelas.FieldByName('PAGADO').AsFloat;

                    sqlPagar.Parameters.ParamByName('Observ_pag').value := PADR(
                        TRIM(ibTabelas.FieldByName('OBSERVACAO').AsString) + _ENTER +
                        TRIM(ibTabelas.FieldByName('DOCUMENTO').AsString),255);

                    sqlPagar.Parameters.ParamByName('Datapgto_pag').value := null;
                    sqlPagar.Parameters.ParamByName('Valorpago_pag').value := 0;

                    sqlPagar.Parameters.ParamByName('Codigo_plc').value := NULL;
                    sqlPagar.Parameters.ParamByName('Desconto_pag').value := 0;

                    //CENTRO CUSTO
                    sqlTMP.Close;
                    sqlTMP.SQL.Clear;
                    sqlTMP.SQL.Add('SELECT * FROM CENTROC_TB WHERE CODIGO_CNC = '+FormatFloat('000', ibTabelas.FieldByName('CENTROCUSTO').AsInteger));
                    sqlTMP.Open;

                    IF sqlTMP.RecordCount > 0 THEN BEGIN
                      sqlPagar.Parameters.ParamByName('Codigo_cnc').value := FormatFloat('000', ibTabelas.FieldByName('CENTROCUSTO').AsInteger);
                    End ELSE BEGIN
                      sqlPagar.Parameters.ParamByName('Codigo_cnc').value := NULL;
                    end;
                    //FIM CENTRO CUSTO

                    sqlPagar.Parameters.ParamByName('UserName_usr').value := 'MIGR***';
                    sqlPagar.Parameters.ParamByName('UltimaGravacao_pag').value := Now;
                    sqlPagar.Parameters.ParamByName('NotaFiscal_pag').value := null;
                    sqlPagar.Parameters.ParamByName('Duplicata_pag').value := TRIM(ibTabelas.FieldByName('CLAVE').AsString);
                    sqlPagar.Parameters.ParamByName('Codigo_con').value := null;
                    sqlPagar.Parameters.ParamByName('Cheque_pag').value := 0;
                    sqlPagar.Parameters.ParamByName('Acrescimo_pag').value := 0;
                    sqlPagar.Parameters.ParamByName('PgtoTesouraria_pag').value := 'N';
                    sqlPagar.Parameters.ParamByName('Codigo_rma').value := null;
                    sqlPagar.Parameters.ParamByName('NroConhecimento_pag').value := null;
                    sqlPagar.Parameters.ParamByName('Codigo_emp').value := 1;
                    sqlPagar.Parameters.ParamByName('Credito_pag').value := 0;
                    sqlPagar.Parameters.ParamByName('CodigoBaixa_pag').value := null;
                    sqlPagar.Parameters.ParamByName('TipoBaixa_pag').value := null;
                    sqlPagar.Parameters.ParamByName('CODIGO_PCC').value := null;
                    sqlPagar.ExecSql;
                    // Fim Campos

                    //SE PAGO PARCIAL INCLUI TITULO COMO PAGO DO VALOR PAGO.
                    IF (ibTabelas.FieldByName('PAGADO').AsFloat > 0) THEN BEGIN
                      //incio campos
                      sqlPagar.Parameters.ParamByName('Parcela_pag').value := 1;
                      sqlPagar.Parameters.ParamByName('TotalParc_pag').value := 1;
                      if Year(ibTabelas.FieldByName('PROXIMOPAGO').AsDateTime) > 1900 then begin
                            sqlPagar.Parameters.ParamByName('Vencto_pag').value := ibTabelas.FieldByName('PROXIMOPAGO').AsDateTime;
                      end else begin
                            sqlPagar.Parameters.ParamByName('Vencto_pag').value := '1900-01-01';
                      end;

                      //FORNECEDOR
                      sqlTMP.Close;
                      sqlTMP.SQL.Clear;
                      sqlTMP.SQL.Add('SELECT CODIGO_FOR FROM Fornecedor_tb WHERE Codigo_for = '+ibTabelas.FieldByName('PROVEEDOR').AsString);
                      sqlTMP.Open;

                      IF sqlTMP.RecordCount > 0 THEN BEGIN
                        sqlPagar.Parameters.ParamByName('Codigo_for').value := ibTabelas.FieldByName('PROVEEDOR').AsInteger;
                      End ELSE BEGIN
                        sqlPagar.Parameters.ParamByName('Codigo_for').value := NULL;
                      end;
                      //FIM FORNECEDOR

                      sqlPagar.Parameters.ParamByName('Codigo_cmp').value := null;
                      sqlPagar.Parameters.ParamByName('Datamov_pag').value := ibTabelas.FieldByName('DATALAN').AsDateTime;
                      sqlPagar.Parameters.ParamByName('Valor_pag').value := ibTabelas.FieldByName('IMPORTE').AsFloat;

                      sqlPagar.Parameters.ParamByName('Observ_pag').value := PADR(
                          TRIM(ibTabelas.FieldByName('OBSERVACAO').AsString) + _ENTER + 'Documento: '+
                          TRIM(ibTabelas.FieldByName('DOCUMENTO').AsString)+ _ENTER + 'ESTATUS: '+
                          TRIM(ibTabelas.FieldByName('ESTATUS').AsString),255);

                      //COLOCA TITULO COMO JÁ PAGO
                      if Year(ibTabelas.FieldByName('FECHA').AsDateTime) > 1900 then begin
                            sqlPagar.Parameters.ParamByName('Datapgto_pag').value := ibTabelas.FieldByName('FECHA').AsDateTime;
                      end else begin
                            sqlPagar.Parameters.ParamByName('Datapgto_pag').value := '1900-01-01';
                      end;

                      sqlPagar.Parameters.ParamByName('Valorpago_pag').value := ibTabelas.FieldByName('PAGADO').AsFloat;
                      //FIM COLOCA TITULO COMO JÁ PAGO

                      sqlPagar.Parameters.ParamByName('Codigo_plc').value := NULL;
                      sqlPagar.Parameters.ParamByName('Desconto_pag').value := 0;

                      //CENTRO CUSTO
                      sqlTMP.Close;
                      sqlTMP.SQL.Clear;
                      sqlTMP.SQL.Add('SELECT * FROM CENTROC_TB WHERE CODIGO_CNC = '+FormatFloat('000', ibTabelas.FieldByName('CENTROCUSTO').AsInteger));
                      sqlTMP.Open;

                      IF sqlTMP.RecordCount > 0 THEN BEGIN
                        sqlPagar.Parameters.ParamByName('Codigo_cnc').value := FormatFloat('000', ibTabelas.FieldByName('CENTROCUSTO').AsInteger);
                      End ELSE BEGIN
                        sqlPagar.Parameters.ParamByName('Codigo_cnc').value := NULL;
                      end;
                      //FIM CENTRO CUSTO

                      sqlPagar.Parameters.ParamByName('UserName_usr').value := 'MIGR***';
                      sqlPagar.Parameters.ParamByName('UltimaGravacao_pag').value := Now;
                      sqlPagar.Parameters.ParamByName('NotaFiscal_pag').value := null;
                      sqlPagar.Parameters.ParamByName('Duplicata_pag').value := TRIM(ibTabelas.FieldByName('CLAVE').AsString);
                      sqlPagar.Parameters.ParamByName('Codigo_con').value := null;
                      sqlPagar.Parameters.ParamByName('Cheque_pag').value := 0;
                      sqlPagar.Parameters.ParamByName('Acrescimo_pag').value := 0;
                      sqlPagar.Parameters.ParamByName('PgtoTesouraria_pag').value := 'N';
                      sqlPagar.Parameters.ParamByName('Codigo_rma').value := null;
                      sqlPagar.Parameters.ParamByName('NroConhecimento_pag').value := null;
                      sqlPagar.Parameters.ParamByName('Codigo_emp').value := 1;
                      sqlPagar.Parameters.ParamByName('Credito_pag').value := 0;
                      sqlPagar.Parameters.ParamByName('CodigoBaixa_pag').value := null;
                      sqlPagar.Parameters.ParamByName('TipoBaixa_pag').value := null;
                      sqlPagar.Parameters.ParamByName('CODIGO_PCC').value := null;
                      sqlPagar.ExecSql;
                      // Fim Campos
                    end;
                end;
            end;

            //FECHADO/CANCELADO *********************************
            if (RG_Pagar.ItemIndex = 1) or (RG_Pagar.ItemIndex = 2) then begin

                //Pagar fechado ou cancelado
                if (ibTabelas.FieldByName('PROVEEDOR').AsString <> '') and ((ibTabelas.FieldByName('ESTATUS').AsString = 'C') or (ibTabelas.FieldByName('ESTATUS').AsString = 'P')) THEN BEGIN
                    sqlPagar.Parameters.ParamByName('Parcela_pag').value := 1;
                    sqlPagar.Parameters.ParamByName('TotalParc_pag').value := 1;
                    if Year(ibTabelas.FieldByName('PROXIMOPAGO').AsDateTime) > 1900 then begin
                          sqlPagar.Parameters.ParamByName('Vencto_pag').value := ibTabelas.FieldByName('PROXIMOPAGO').AsDateTime;
                    end else begin
                          sqlPagar.Parameters.ParamByName('Vencto_pag').value := '1900-01-01';
                    end;

                    //FORNECEDOR
                    sqlTMP.Close;
                    sqlTMP.SQL.Clear;
                    sqlTMP.SQL.Add('SELECT CODIGO_FOR FROM Fornecedor_tb WHERE Codigo_for = '+ibTabelas.FieldByName('PROVEEDOR').AsString);
                    sqlTMP.Open;

                    IF sqlTMP.RecordCount > 0 THEN BEGIN
                      sqlPagar.Parameters.ParamByName('Codigo_for').value := ibTabelas.FieldByName('PROVEEDOR').AsInteger;
                    End ELSE BEGIN
                      sqlPagar.Parameters.ParamByName('Codigo_for').value := NULL;
                    end;
                    //FIM FORNECEDOR

                    sqlPagar.Parameters.ParamByName('Codigo_cmp').value := null;
                    sqlPagar.Parameters.ParamByName('Datamov_pag').value := ibTabelas.FieldByName('DATALAN').AsDateTime;
                    sqlPagar.Parameters.ParamByName('Valor_pag').value := ibTabelas.FieldByName('IMPORTE').AsFloat;

                    sqlPagar.Parameters.ParamByName('Observ_pag').value := PADR(
                        TRIM(ibTabelas.FieldByName('OBSERVACAO').AsString) + _ENTER + 'Documento: '+
                        TRIM(ibTabelas.FieldByName('DOCUMENTO').AsString)+ _ENTER + 'ESTATUS: '+
                        TRIM(ibTabelas.FieldByName('ESTATUS').AsString),255);

                    //COLOCA TITULO COMO JÁ PAGO
                    if Year(ibTabelas.FieldByName('FECHA').AsDateTime) > 1900 then begin
                          sqlPagar.Parameters.ParamByName('Datapgto_pag').value := ibTabelas.FieldByName('FECHA').AsDateTime;
                    end else begin
                          sqlPagar.Parameters.ParamByName('Datapgto_pag').value := '1900-01-01';
                    end;

                    IF (ibTabelas.FieldByName('PAGADO').AsFloat > 0.01) THEN BEGIN
                      sqlPagar.Parameters.ParamByName('Valorpago_pag').value := ibTabelas.FieldByName('PAGADO').AsFloat;
                    END ELSE BEGIN
                      sqlPagar.Parameters.ParamByName('Valorpago_pag').value := 0.01;
                    end;
                    //FIM COLOCA TITULO COMO JÁ PAGO

                    sqlPagar.Parameters.ParamByName('Codigo_plc').value := NULL;
                    sqlPagar.Parameters.ParamByName('Desconto_pag').value := 0;

                    //CENTRO CUSTO
                    sqlTMP.Close;
                    sqlTMP.SQL.Clear;
                    sqlTMP.SQL.Add('SELECT * FROM CENTROC_TB WHERE CODIGO_CNC = '+FormatFloat('000', ibTabelas.FieldByName('CENTROCUSTO').AsInteger));
                    sqlTMP.Open;

                    IF sqlTMP.RecordCount > 0 THEN BEGIN
                      sqlPagar.Parameters.ParamByName('Codigo_cnc').value := FormatFloat('000', ibTabelas.FieldByName('CENTROCUSTO').AsInteger);
                    End ELSE BEGIN
                      sqlPagar.Parameters.ParamByName('Codigo_cnc').value := NULL;
                    end;
                    //FIM CENTRO CUSTO

                    sqlPagar.Parameters.ParamByName('UserName_usr').value := 'MIGR***';
                    sqlPagar.Parameters.ParamByName('UltimaGravacao_pag').value := Now;
                    sqlPagar.Parameters.ParamByName('NotaFiscal_pag').value := null;
                    sqlPagar.Parameters.ParamByName('Duplicata_pag').value := TRIM(ibTabelas.FieldByName('CLAVE').AsString);
                    sqlPagar.Parameters.ParamByName('Codigo_con').value := null;
                    sqlPagar.Parameters.ParamByName('Cheque_pag').value := 0;
                    sqlPagar.Parameters.ParamByName('Acrescimo_pag').value := 0;
                    sqlPagar.Parameters.ParamByName('PgtoTesouraria_pag').value := 'N';
                    sqlPagar.Parameters.ParamByName('Codigo_rma').value := null;
                    sqlPagar.Parameters.ParamByName('NroConhecimento_pag').value := null;
                    sqlPagar.Parameters.ParamByName('Codigo_emp').value := 1;
                    sqlPagar.Parameters.ParamByName('Credito_pag').value := 0;
                    sqlPagar.Parameters.ParamByName('CodigoBaixa_pag').value := null;
                    sqlPagar.Parameters.ParamByName('TipoBaixa_pag').value := null;
                    sqlPagar.Parameters.ParamByName('CODIGO_PCC').value := null;
                    sqlPagar.ExecSql;
                    // Fim Campos
                end;
            end;
            ibTabelas.Next;
        end;
        mmStatusMigracao.Lines.Add('PAGAR OK');
        chk_Pagar.Checked := false;
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    if chk_Vendas.Checked then begin
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Migrando Vendas (Cab) ';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select count(1) as Nro from VENTAS');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select * from VENTAS WHERE TIPO <> ''D'' AND TIPO <> ''P'' ');
        ibTabelas.Open;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Delete From Movimc_tb ');
        sqlTMP.ExecSql;

        ProgressBar1.Position := 0;
        ibTabelas.First;
        while not ibTabelas.Eof do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'Venda :' +
                ibTabelas.FieldByName('CLAVE').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;

            qry_buscaCliente.Close;
            qry_buscaCliente.Parameters.ParamByName('Codigo_cli').Value := ibTabelas.FieldByName('CLIENTE').AsInteger;
            qry_buscaCliente.Open;

            if qry_buscaCliente.FieldByName('Codigo_cli').AsInteger > 0 then begin
                // Campos
                sqlMovimC.Parameters.ParamByName('Cupom_mvc').Value := ibTabelas.FieldByName('CLAVE').AsInteger;
                sqlMovimC.Parameters.ParamByName('Data_mvc').Value := ibTabelas.FieldByName('FECHA').AsDateTime;
                if not ibTabelas.FieldByName('CLIENTE').IsNull then
                    sqlMovimC.Parameters.ParamByName('Codigo_cli').Value := ibTabelas.FieldByName('CLIENTE').AsInteger
                else
                    sqlMovimC.Parameters.ParamByName('Codigo_cli').Value := Null;

                sqlMovimC.Parameters.ParamByName('UserName_usr').Value := 'MIGR***';
                sqlMovimC.Parameters.ParamByName('UltimoAcesso_mvc').Value := FormatDateTime('dd/mm/yy',NOW);
                sqlMovimC.Parameters.ParamByName('Codigo_ven').Value := NULL;
                sqlMovimC.Parameters.ParamByName('Codigo_agv').Value := null;
                sqlMovimC.Parameters.ParamByName('TipoVenda_mvc').Value := 'P';
                sqlMovimC.Parameters.ParamByName('Descricaokdx_mvc').Value := '';
                sqlMovimC.Parameters.ParamByName('TotalProdutos_mvc').Value := ibTabelas.FieldByName('TOTAL').AsFloat;
                sqlMovimC.Parameters.ParamByName('Desconto_mvc').Value := 0;
                sqlMovimC.Parameters.ParamByName('Acrescimo_mvc').Value := 0;
                sqlMovimC.Parameters.ParamByName('Codigo_os').Value := null;
                sqlMovimC.Parameters.ParamByName('Codigo_plp').Value := null;
                sqlMovimC.Parameters.ParamByName('Codigo_trc').Value := null;
                sqlMovimC.Parameters.ParamByName('NroNotaFiscal_nfc').Value := null;
                sqlMovimC.Parameters.ParamByName('JaFoiProCaixa_mvc').Value := 'S';
                sqlMovimC.Parameters.ParamByName('Observacao_mvc').Value := ' ';
                sqlMovimC.Parameters.ParamByName('TipoPreco_mvc').Value := 'V';
                sqlMovimC.Parameters.ParamByName('CupomFechado_mvc').Value := 'S';
                sqlMovimC.Parameters.ParamByName('Terminal_mvc').Value := 1;
                sqlMovimC.Parameters.ParamByName('Codigo_vei').Value := NULL;
                sqlMovimC.Parameters.ParamByName('TipoVeiculo_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('DescricaoVei_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('Kmvei_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('PlacaVei_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('Anovei_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('AbertaouFechada_mvc').Value := 'F';
                sqlMovimC.Parameters.ParamByName('TipoOS_mvc').Value := 'S';
                sqlMovimC.Parameters.ParamByName('autorizadoPor_mvc').Value := ' ';
                sqlMovimC.Parameters.ParamByName('FinalizadaPor_mvc').Value := ' ';
                sqlMovimC.Parameters.ParamByName('chapa_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('DataExecucao_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('Garantia_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('Chassi_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('DefeitoReclamado_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('Fone1_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('AcrescDescFormPgto_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('NroCupomFiscal_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('CpfCnpj_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('NomeCliente_mvc').Value := padr(ibTabelas.FIeldByName('NomeCli').AsString , 40);
                sqlMovimC.Parameters.ParamByName('NumeroFatura_rec').Value := NULL;
                sqlMovimC.Parameters.ParamByName('TotalReceberOld_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('Hora_mvc').Value := '00:00';
                sqlMovimC.Parameters.ParamByName('Codigo_cnv').Value := NULL;
                sqlMovimC.Parameters.ParamByName('VendaConferidaTotal_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('requisicoes_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('TrocoEmDIN_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('TrocoEmCHV_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('TrocoEmCHP_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('TrocoEmCTV_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('TrocoPara_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('Codigo_cxr').Value := NULL;
                sqlMovimC.Parameters.ParamByName('TipoVendaTelefonia_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('Codigo_emp').Value := 1;
                sqlMovimC.Parameters.ParamByName('Codigo_nfc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('MovimentoOld_mvc').Value := NULL;
                sqlMovimC.Parameters.ParamByName('TitulosAltConvPedNF_mvc').Value := NULL;
                //Fim Campos
                sqlMovimC.ExecSQL;
            end;
            ibTabelas.Next;
        end;
        mmStatusMigracao.Lines.Add('VENDAS OK');
        chk_Vendas.Checked := false;
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    if chk_ItensDaVenda.Checked then begin
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Migrando Vendas (Det) ';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select count(1) as Nro from VENTASDET ');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add(' SELECT * FROM VENTASDET DET ');
        ibTabelas.Sql.Add(' LEFT OUTER JOIN VENTAS VEN ON(DET.VENTA = VEN.CLAVE) ');
        ibTabelas.Sql.Add(' WHERE VEN.TIPO <> ''D'' AND VEN.TIPO <> ''P'' ');
        ibTabelas.Open;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Alter Table Kardex_Tb Disable trigger trg_kardex_insert');
        sqlTMP.ExecSql;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Delete From MovimD_tb ');
        sqlTMP.ExecSql;

        ibTabelas.First;
        ProgressBar1.Position := 0;
        while (not ibTabelas.Eof) do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'Venda:' +
                ibTabelas.FieldByName('VENTA').AsString + ' - Produto: ' +
                ibTabelas.FieldByName('ARTICULO').AsString+'-'+
                ibTabelas.FieldByName('DESC_LARGA').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;

            CodVenda := ibTabelas.FieldByName('VENTA').AsInteger;
            item := 1;
            while (not ibTabelas.Eof) AND (ibTabelas.FieldByName('VENTA').AsInteger = CodVenda) do begin
                // Campos

                    sqlMovimD.Parameters.ParamByName('Cupom_mvc').Value := CODVENDA;
                    sqlMovimD.Parameters.ParamByName('NroItem_mvd').Value := item;

                    sqlEvitaProdDup.Close;
                    sqlEvitaProdDup.Parameters.ParamByName('Codigo_prd').value := ibTabelas.FieldByName('ARTICULO').AsInteger;
                    sqlEvitaProdDup.Open;

                    if sqlEvitaProdDup.FieldByName('Codigo_prd').AsInteger > 0 then
                        sqlMovimD.Parameters.ParamByName('Codigo_prd').Value := ibTabelas.FieldByName('ARTICULO').AsInteger
                    else
                        sqlMovimD.Parameters.ParamByName('Codigo_prd').Value := 1;

                    sqlMovimD.Parameters.ParamByName('Quant_mvd').Value := ibTabelas.FieldByName('CANTIDAD').AsFloat;
                    sqlMovimD.Parameters.ParamByName('PrecoVenda_prd').Value := (ibTabelas.FieldByName('PRECIO').AsFloat - ibTabelas.FieldByName('DESCUENTO').AsFloat);
                    sqlMovimD.Parameters.ParamByName('PrecoCusto_prd').Value := ibTabelas.FieldByName('PRECIOCOSTO').AsFloat;
                    sqlMovimD.Parameters.ParamByName('EntregaFutura_mvd').Value :='N';
                    sqlMovimD.Parameters.ParamByName('QuandoBaixaEstoque_Mvd').Value:= 'V';
                    sqlMovimD.Parameters.ParamByName('QuantJaRetirada_mvd').Value := ibTabelas.FieldByName('CANTIDAD').AsFloat;
                    sqlMovimD.Parameters.ParamByName('DescricaoPrd_Mvd').Value := padr(ibTabelas.FieldByName('DESC_LARGA').AsString, 50);
                    sqlMovimD.Parameters.ParamByName('Desconto_Mvd').Value := ibTabelas.FieldByName('DESCUENTO').AsFloat;
                    sqlMovimD.Parameters.ParamByName('Acrescimo_Mvd').Value := 0;
                    sqlMovimD.Parameters.ParamByName('QuantDev_mvd').Value := 0;
                    sqlMovimD.Parameters.ParamByName('Celular_Mvd').Value := '';
                    sqlMovimD.Parameters.ParamByName('Fidelizado_Mvd').Value := 0;
                    sqlMovimD.Parameters.ParamByName('Codigo_cmp').Value := NULL;
                    sqlMovimD.Parameters.ParamByName('Codigo_pcl').Value := NULL;
                    sqlMovimD.Parameters.ParamByName('Valor_vlc').Value := 0;
                    sqlMovimD.Parameters.ParamByName('Desconto_vlc').Value := 0;
                    sqlMovimD.Parameters.ParamByName('hexa_mvd').Value := '';
                    sqlMovimD.Parameters.ParamByName('DescAcresGeral_mvd').Value :=0;
                    sqlMovimD.Parameters.ParamByName('DescontoGeralCaixa_mvd').Value:= 0;
                    sqlMovimD.Parameters.ParamByName('VendaVista_mvd').Value := (ibTabelas.FieldByName('PRECIO').AsFloat - ibTabelas.FieldByName('DESCUENTO').AsFloat);
                    sqlMovimD.Parameters.ParamByName('VendaPrazo_mvd').Value := (ibTabelas.FieldByName('PRECIO').AsFloat - ibTabelas.FieldByName('DESCUENTO').AsFloat);
                    sqlMovimD.Parameters.ParamByName('Codigo_ven').Value := null;
                    sqlMovimD.Parameters.ParamByName('ProdutoOuServico_mvd').Value:='P';
                    sqlMovimD.Parameters.ParamByName('ProdutoBaixarEstoque_prd').Value :=NULL;
                    sqlMovimD.Parameters.ParamByName('Altura_mvd').Value := 0;
                    sqlMovimD.Parameters.ParamByName('Largura_mvd').Value := 0;
                    sqlMovimD.Parameters.ParamByName('Comprimento_mvd').Value := 0;
                    sqlMovimD.Parameters.ParamByName('quantM3_mvd').Value := 0;
                    sqlMovimD.Parameters.ParamByName('ValorAparelhamento_mvd').Value:= 0;
                    sqlMovimD.Parameters.ParamByName('ProdutoComReceita_mvd').Value:= 'N';
                    sqlMovimD.Parameters.ParamByName('ComissaoVendedor_mvd').Value := 0;
                    sqlMovimD.Parameters.ParamByName('ComissaoSupervisor_mvd').Value := 0;
                    sqlMovimD.Parameters.ParamByName('UnidadesConferidos_mvc').Value := NULL;
                    sqlMovimD.Parameters.ParamByName('ValorMargemAparelho_vlc').Value := 0;
                    sqlMovimD.ExecSql;
                    // Fim Campos
                ibTabelas.Next;
            end;
        end;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Alter Table Kardex_Tb Enable trigger trg_kardex_insert');
        sqlTMP.ExecSql;

        mmStatusMigracao.Lines.Add('ITENS DE VENDA OK');
        chk_ItensDaVenda.Checked := false;
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    if chk_OPCabecalho.Checked then begin
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Migrando OPCabecalho';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select count(1) as Nro from OP ');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select * from OP order by Clave');
        ibTabelas.Open;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('delete From os_tb');
        sqlTMP.ExecSql;

        ProgressBar1.Position := 0;
        ibTabelas.First;
        while not ibTabelas.Eof do begin
          ProgressBar1.Position := ProgressBar1.Position + 1;
          StatusBar1.Panels[0].Text := 'OP:' +
              ibTabelas.FieldByName('CLAVE').AsString + 'Cliente: '+
              ibTabelas.FieldByName('CLIENTE').AsString;
          application.ProcessMessages;
          StatusBar1.Refresh;
          //if (ibTabelas.FieldByName('ESTATUS').AsInteger <> 3) then begin
            sqlOp.Parameters.ParamByName('Codigo_os').Value := ibTabelas.FieldByName('CLAVE').AsInteger;
            sqlOp.Parameters.ParamByName('Cupom_mvc').Value := ibTabelas.FieldByName('CLAVE').AsInteger;

            If (ibTabelas.FieldByName('ESTATUS').AsInteger = 2) THEN BEGIN
                sqlOp.Parameters.ParamByName('situacao_os').Value := 'T';
            end ELSE if (ibTabelas.FieldByName('ESTATUS').AsInteger = 0) then BEGIN
                sqlOp.Parameters.ParamByName('situacao_os').Value := 'A';
            end else begin
                sqlOp.Parameters.ParamByName('situacao_os').Value := 'T';
            end;

            sqlOp.Parameters.ParamByName('Codigo_cli').Value := ibTabelas.FieldByName('CLIENTE').AsInteger;
            sqlOp.Parameters.ParamByName('ValorServicos_os').Value := ibTabelas.FieldByName('TOTALFUV').AsFloat;
            sqlOp.Parameters.ParamByName('ValorPecas_os').Value := ibTabelas.FieldByName('TOTALMPV').AsFloat;
            sqlOp.Parameters.ParamByName('PrevistoPara_os').Value := ibTabelas.FieldByName('FECHA_PREVISAO').AsDateTime;
            sqlOp.Parameters.ParamByName('UltimaGravacao_os').Value := NOW;
            sqlOp.Parameters.ParamByName('UserName_usr').Value := 'MIGR****';
            sqlOp.Parameters.ParamByName('Observacao_os').Value := PADR(TRIM(ibTabelas.FieldByName('OBS1').AsString)+' '+
            TRIM(ibTabelas.FieldByName('OBS2').AsString)+' '+
            TRIM(ibTabelas.FieldByName('OBS3').AsString)+' '+
            TRIM(ibTabelas.FieldByName('OBS4').AsString)+' ',300);
            sqlOp.Parameters.ParamByName('UsuarioAbertura_usr').Value := 'MIGR***';
            sqlOp.Parameters.ParamByName('DataAbertura_os').Value := ibTabelas.FieldByName('FECHA_CAP').AsDateTime;
            sqlOp.Parameters.ParamByName('DataPrevisao_os').Value := ibTabelas.FieldByName('FECHA_PREVISAO').AsDateTime;
            sqlOp.Parameters.ParamByName('DataConclusao_os').Value := ibTabelas.FieldByName('FECHA_ULTMOV').AsDateTime;
            sqlOp.Parameters.ParamByName('Historico_os').Value := NULL;
            sqlOp.Parameters.ParamByName('TotalCustoServico').Value := ibTabelas.FieldByName('TOTALFUV').AsFloat;
            sqlOp.Parameters.ParamByName('TotalCustoProduto').Value := ibTabelas.FieldByName('TOTALMPV').AsFloat;
            sqlOp.ExecSQL;
          //end;
          ibTabelas.Next;
        end;
        mmStatusMigracao.Lines.Add('OPCabecalho OK');
        chk_OPCabecalho.Checked := false;
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    if chk_OPMateriaPrima.Checked then begin
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Migrando OP Materia Prima ';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select count(1) as Nro from OPMA ');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select * from OPMA order by OP');
        ibTabelas.Open;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Delete From ItensOs_tb ');
        sqlTMP.ExecSql;

        ibTabelas.First;
        ProgressBar1.Position := 0;
        while (not ibTabelas.Eof) do begin
            CodVenda := ibTabelas.FieldByName('OP').AsInteger;
            while (not ibTabelas.Eof) AND
                  (ibTabelas.FieldByName('OP').AsInteger = CodVenda) do begin
                  ProgressBar1.Position := ProgressBar1.Position + 1;
                  StatusBar1.Panels[0].Text := 'OP MateriaP:' +
                      ibTabelas.FieldByName('OP').AsString + ' - Produto: ' +
                      ibTabelas.FieldByName('ARTICULO').AsString+'-'+
                      ibTabelas.FieldByName('DESCRICAO').AsString;
                  application.ProcessMessages;
                  StatusBar1.Refresh;

                  // Campos
                  sqlItensOP.Parameters.ParamByName('Codigo_os').Value := CODVENDA;

                  sqlEvitaProdDup.Close;
                  sqlEvitaProdDup.Parameters.ParamByName('Codigo_prd').value := ibTabelas.FieldByName('ARTICULO').AsInteger;
                  sqlEvitaProdDup.Open;

                  if sqlEvitaProdDup.FieldByName('Codigo_prd').AsInteger > 0 then
                      sqlItensOP.Parameters.ParamByName('Codigo_prd').Value := ibTabelas.FieldByName('ARTICULO').AsInteger
                  else
                      sqlItensOP.Parameters.ParamByName('Codigo_prd').Value := 1;

                  sqlItensOP.Parameters.ParamByName('Quant_ito').Value := ibTabelas.FieldByName('CANTIDAD').AsFloat;
                  sqlItensOP.Parameters.ParamByName('Valor_ito').Value := ibTabelas.FieldByName('PRECIOCOSTO').AsFloat;
                  sqlItensOP.Parameters.ParamByName('CustoProduto_ito').Value := ibTabelas.FieldByName('PRECIO').AsFloat;
                  sqlItensOP.Parameters.ParamByName('DescricaoPrd_ito').Value :=padr(ibTabelas.FieldByName('DESCRICAO').AsString, 50);
                  sqlItensOP.Parameters.ParamByName('codigo_ven').Value := NULL;
                  sqlItensOP.ExecSql;
                    // Fim Campos
                ibTabelas.Next;
            end;
        end;
        mmStatusMigracao.Lines.Add('MATERIA PRIMA OP OK');
        chk_OPMateriaPrima.Checked := false;
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    if chk_OPServico.Checked then begin
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Migrando OP Servicos ';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select count(1) as Nro from OPFU ');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select * from OPFU order by OP');
        ibTabelas.Open;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Delete From ServicoOs_tb ');
        sqlTMP.ExecSql;

{        //insere cadastro de GR Serviço
        sqlTMP.Close;
        sqlTMP.SQL.Clear;
        sqlTMP.SQL.Add('insert into GruposServicos_tb( ');
        sqlTMP.SQL.Add('Codigo_gsr ,Descricao_gsr ,UserName_usr ,UltimaGravacao_gsr ');
        sqlTMP.SQL.Add(')values( ');
        sqlTMP.SQL.Add(' ''001'' ,''Servicos'' ,''Migr***'' ,GETDATE() ) ');
        sqltmp.ExecSQL;
        //isere cadastro de servoco
        sqlTMP.Close;
        sqlTMP.SQL.Clear;
        sqlTMP.SQL.Add('set identity_insert Servicos_tb on ');
        sqlTMP.SQL.Add('insert into Servicos_tb (');
        sqlTMP.SQL.Add('Codigo_srv ,Descricao_srv ,PrecoCusto_srv ,PrecoVenda_srv ,PrecoVendaPrazo_srv ,PrecoPromocao_srv ,MinutosDura_srv ,Username_usr ');
        sqlTMP.SQL.Add(',UltimaGravacao_srv ,promocaoIni_srv ,promocaoFim_srv ,Codigo_gsr ,ListServ_srv ');
        sqlTMP.SQL.Add(')values(');
        sqlTMP.SQL.Add('1,''SERVICO'',0,0,0,0,0,''Migr***'',GETDATE(),null,null,''001'',0 ) ');
        sqlTMP.SQL.Add('set identity_insert Servicos_tb on');
        sqlTMP.ExecSQL;
 }
        ibTabelas.First;
        ProgressBar1.Position := 0;
        while (not ibTabelas.Eof) do begin
            CodVenda := ibTabelas.FieldByName('OP').AsInteger;
            while (not ibTabelas.Eof) AND
                  (ibTabelas.FieldByName('OP').AsInteger = CodVenda) do begin
                  ProgressBar1.Position := ProgressBar1.Position + 1;
                  StatusBar1.Panels[0].Text := 'OP Servico:' +
                      ibTabelas.FieldByName('OP').AsString + ' - Produto: ' +
                      ibTabelas.FieldByName('CODPREST').AsString+'-'+
                      ibTabelas.FieldByName('NOMEPREST').AsString;
                  application.ProcessMessages;
                  StatusBar1.Refresh;

                  // Campos
                  sqlServicoOP.Parameters.ParamByName('Codigo_os').Value := CODVENDA;
                  sqlServicoOP.Parameters.ParamByName('Codigo_srv').Value := 1;
                  sqlServicoOP.Parameters.ParamByName('Codigo_ven').Value := ibTabelas.FieldByName('CODPREST').AsInteger;

                  hora1 := Convertehoradecimalparadatetime(ibTabelas.FieldByName('HORA1').AsString);
                  hora2 := Convertehoradecimalparadatetime(ibTabelas.FieldByName('HORA2').AsString);

                  sqlServicoOP.Parameters.ParamByName('DataPeriodo1_os').Value := hora1;
                  sqlServicoOP.Parameters.ParamByName('DataPeriodoFim1_os').Value := hora2;

                  //FAZER VALOR SERVICO OS
                  //busca valor do minuto do vendedor
                  sqlTMP.Close;
                  sqlTMP.SQL.Clear;
                  sqlTMP.SQL.Add('select valorhora_ven ,ValorHoraCusto_ven from Vendedores_tb where codigo_ven = '+trim(ibTabelas.FieldByName('CODPREST').AsString));
                  sqlTMP.Open;
                  valorminven := (sqlTMP.fieldbyname('valorhora_ven').AsFloat / 60);
                  valormincustoven := (sqlTMP.fieldbyname('ValorHoraCusto_ven').AsFloat / 60);

                  horastrabalhadas := Tempo(hora1,hora2);
                  horastrabalhadas := copy(horastrabalhadas,1,5);
                  minutostrabalhados := HoraParaMinutos(horastrabalhadas);

                  sqlServicoOP.Parameters.ParamByName('ValorServicos_os').Value := valorminven * minutostrabalhados;
                  //FAZER VALRO CUSTO SERVICO OS
                  sqlServicoOP.Parameters.ParamByName('CustoServico_os').Value := valormincustoven * minutostrabalhados;

                  sqlServicoOP.ExecSql;
                    // Fim Campos
                ibTabelas.Next;
            end;
        end;
        mmStatusMigracao.Lines.Add('SERVICO OP OK');
        chk_OPServico.Checked := false;
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    if chk_Cidades.Checked then begin
        StatusBar1.Panels[0].Text := 'Aguarde os CODIGOS DAS CIDADES estão sendo atualizados...';
        application.ProcessMessages;
        StatusBar1.Refresh;
        AtualizaCodigo_cid := False;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('select * from cidades_tb');
        sqlTMP.Open;

        if sqlTMP.RecordCount < 2 then begin
            mmStatusMigracao.Lines.Add('CIDADES NÀO CADASTRADAS...');
            ShowMessage('Rode o "SETUP DE CIDADES" antes...');
            exit;
        end;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('select * from clientes_tb');
        sqlTMP.Sql.Add('where rtrim(Cidade_cli) <> '''' ');
        sqlTMP.Open;

        if sqlTMP.RecordCount > 1 then begin
            sqlTMP.Close;
            sqlTMP.Sql.Clear;
            sqlTMP.Sql.Add('            update clientes_tb  ');
            sqlTMP.Sql.Add('            set clientes_tb.codigo_cid = cid.codigo_cid  ');
            sqlTMP.Sql.Add('            from clientes_tb  ');
            sqlTMP.Sql.Add('            left outer join cidades_tb cid on ( dbo.RetiraAcento(rtrim(clientes_tb.cidade_cli)) = rtrim(cid.Nome_cid)) ');
            sqlTMP.ExecSql;
            AtualizaCodigo_cid := True;
       end;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('select * from fornecedor_tb');
        sqlTMP.Sql.Add('where rtrim(cidade_for) <> '''' ');
        sqlTMP.Open;

        if sqlTMP.RecordCount > 0 then begin
            sqlTMP.Close;
            sqlTMP.Sql.Clear;
            sqlTMP.Sql.Add('            update fornecedor_tb  ');
            sqlTMP.Sql.Add('            set fornecedor_tb.codigo_cid = cid.codigo_cid  ');
            sqlTMP.Sql.Add('            from fornecedor_tb  ');
            sqlTMP.Sql.Add('            left outer join cidades_tb cid on ( dbo.RetiraAcento(rtrim(fornecedor_tb.cidade_for)) = rtrim(cid.Nome_cid)) ');
            sqlTMP.ExecSql;
            AtualizaCodigo_cid := True;
        end;

        chk_Cidades.Checked := false;
        if AtualizaCodigo_cid = True then begin
            StatusBar1.Panels[0].Text := 'Cidades atualizadas com sucesso.';
            application.ProcessMessages;
            StatusBar1.Refresh;
            mmStatusMigracao.Lines.Add('CODIGO DE CIDADES OK');
            ProgressBar1.Position := 0;
            Btn_migrar.Enabled := True;
            Btn_Migrar.Caption := 'Migrar';
        end;
    end;

    if chk_InsereKaredx.Checked then begin
        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('Alter Table Kardex_Tb Enable trigger trg_kardex_insert');
        sqlTMP.ExecSql;

        sqlTMP.Close;
        sqlTMP.Sql.Clear;
        sqlTMP.Sql.Add('insert into DADOS_DB..Kardex_tb ');
        sqlTMP.Sql.Add('(Codigo_prd');
        sqlTMP.Sql.Add(',DataEmissao_kdx');
        sqlTMP.Sql.Add(',UserName_usr      ');
        sqlTMP.Sql.Add(',Historico_kdx    ');
        sqlTMP.Sql.Add(',SaldoAnt_kdx    ');
        sqlTMP.Sql.Add(',DebCred_kdx     ');
        sqlTMP.Sql.Add(',Quant_kdx       ');
        sqlTMP.Sql.Add(',Cupom_mvc       ');
        sqlTMP.Sql.Add(',Codigo_cmp      ');
        sqlTMP.Sql.Add(',Codigo_dvf       ');
        sqlTMP.Sql.Add(',Codigo_dvc       ');
        sqlTMP.Sql.Add(',Codigo_rtc       ');
        sqlTMP.Sql.Add(',Codigo_ven       ');
        sqlTMP.Sql.Add(',Codigo_trn       ');
        sqlTMP.Sql.Add(',codigo_ome       ');
        sqlTMP.Sql.Add(',Codigo_lce  )  ');
        sqlTMP.Sql.Add('select       ');
        sqlTMP.Sql.Add('Codigo_prd ');
        sqlTMP.Sql.Add(',getdate() ');
        sqlTMP.Sql.Add(',''MIGR***'' ');
        sqlTMP.Sql.Add(',''MIGRACAO DOS DADOS'' ');
        sqlTMP.Sql.Add(',0 ');
        sqlTMP.Sql.Add(',''E'' ');
        sqlTMP.Sql.Add(',ESTATU_PRD ');
        sqlTMP.Sql.Add(',NULL ');
        sqlTMP.Sql.Add(',null ');
        sqlTMP.Sql.Add(',null ');
        sqlTMP.Sql.Add(',null ');
        sqlTMP.Sql.Add(',Null ');
        sqlTMP.Sql.Add(',Null ');
        sqlTMP.Sql.Add(',Null');
        sqlTMP.Sql.Add(',Null');
        sqlTMP.Sql.Add(',1');
        sqlTMP.Sql.Add('from DADOS_DB..EstoquePorLocal_tb');
        sqlTMP.ExecSQL;
        chk_InsereKaredx.Checked := false;

        mmStatusMigracao.Lines.Add('KARDEX OK');
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    // Acertando Clientes
    if chk_AcertaCliente.Checked then begin
        // Acertando clientes
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Acertando Clientes';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('SELECT count(1) as Nro FROM clientes');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('SELECT * FROM clientes');
        ibTabelas.Open;

        ProgressBar1.Position := 0;
        ibTabelas.First;
        while not ibTabelas.Eof do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'Cliente:' +
                ibTabelas.FieldByName('CLAVE').AsString+' - '+
                ibTabelas.FieldByName('NOMBRE').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;

            // Campos
            sqlAcertaClientes.Parameters.ParamByName('Fone1_cli').value := padr(TRIM(ibTabelas.FieldByName('TELEFONO').AsString), 16);
            sqlAcertaClientes.Parameters.ParamByName('Fone2_cli').value := padr(TRIM(ibTabelas.FieldByName('TELEFONO2').AsString), 16);
            sqlAcertaClientes.Parameters.ParamByName('Fax_cli').value := padr(TRIM(ibTabelas.FieldByName('FAX').AsString), 16);
            sqlAcertaClientes.Parameters.ParamByName('Celular_cli').value := padr(TRIM(ibTabelas.FieldByName('CELULAR').AsString), 16);
            sqlAcertaClientes.Parameters.ParamByName('Codigo_cli').Value := ibTabelas.FieldByName('CLAVE').AsInteger;
            //Fim de campos

            sqlAcertaClientes.ExecSql;

            ibTabelas.Next;
        end;

        sqlAcertaCliente2.ExecSQL;

        chk_AcertaCliente.Checked := false;
        mmStatusMigracao.Lines.Add('Acerto de CLIENTES OK');
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    if chk_AcertaProdutos.Checked then begin
        // Acertando clientes
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Acertando Produtos';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('SELECT count(1) as Nro FROM CODIGOS');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('SELECT * FROM CODIGOS');
        ibTabelas.Open;

        ProgressBar1.Position := 0;
        ibTabelas.First;
        while not ibTabelas.Eof do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'Produto Clave:' +
                ibTabelas.FieldByName('ARTICULO').AsString+' - CODIGO BARRAS'+
                ibTabelas.FieldByName('CODIGO').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;

            // Campos
            sqlAcertaProdutos2.Parameters.ParamByName('caracTecnica_prd').value := tRIM(ibTabelas.FieldByName('CODIGO').AsString);
            sqlAcertaProdutos2.Parameters.ParamByName('Codigo_prd').value       := ibTabelas.FieldByName('ARTICULO').AsInteger;
            //Fim de campos

            sqlAcertaProdutos2.ExecSql;
            ibTabelas.Next;
        end;
        chk_AcertaCliente.Checked := false;
        mmStatusMigracao.Lines.Add('Acerto de PRODUTOS OK');
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    if chk_Comprasc.Checked then begin
      //************** COMPRAS  *********************************//
      Btn_migrar.Enabled := False;
      Btn_Migrar.Caption := 'Migrando compras';

      ibTabelas.Close;
      ibTabelas.Sql.Clear;
      ibTabelas.Sql.Add('select count(1) as Nro from entsai where fornec <> 0 ');
      ibTabelas.Open;
      ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

      ibTabelas.Close;
      ibTabelas.Sql.Clear;
      ibTabelas.Sql.Add('select * from entsai where fornec <> 0 ');
      ibTabelas.Open;

      sqlTMP.Close;
      sqlTMP.Sql.Clear;
      sqlTMP.Sql.Add('Delete From comprasc_tb ');
      sqlTMP.ExecSql;
      ProgressBar1.Position := 0;

      while not ibTabelas.Eof do begin
        if (ibTabelas.FieldByName('fornec').AsInteger <> 34) and
           (ibTabelas.FieldByName('fornec').AsInteger <> 200) and
           (ibTabelas.FieldByName('fornec').AsInteger <> 21) then begin
              ProgressBar1.Position := ProgressBar1.Position + 1;
              StatusBar1.Panels[0].Text := 'Compras: ' +
                  ibTabelas.FieldByName('Codigoi').AsString + ' - item - ' +
                  ibTabelas.FieldByName('codigoi').AsString + ' - For: ' +
                  ibTabelas.FieldByName('fornec').AsString;
              application.ProcessMessages;
              StatusBar1.Refresh;

              // Campos
                sqlComprasc.Parameters.ParamByName('Codigo_cmp').Value := ibTabelas.FieldByName('Codigoi').AsInteger;
                sqlComprasc.Parameters.ParamByName('Codigo_emp').Value := 1;
                sqlComprasc.Parameters.ParamByName('NotaFiscal_cmp').Value := 0;
                sqlComprasc.Parameters.ParamByName('Emissao_cmp').Value := ibTabelas.FieldByName('DATA').AsDateTime;
                sqlComprasc.Parameters.ParamByName('Entrada_cmp').Value := ibTabelas.FieldByName('DATA').AsDateTime;
                sqlComprasc.Parameters.ParamByName('UserName_usr').Value := 'MIGR****';
                sqlComprasc.Parameters.ParamByName('UltimaGravacao_cmp').Value := Now;
                sqlComprasc.Parameters.ParamByName('DescricaoKdx_cmp').Value := 'MIGR****';
                sqlComprasc.Parameters.ParamByName('Codigo_for').Value := ibTabelas.FieldByName('FORNEC').AsInteger;
                sqlComprasc.Parameters.ParamByName('TotalCompra_cmp').Value := 1;
                //ibTabelas.FieldByName('NUMNOT').AsFloat;
                sqlComprasc.Parameters.ParamByName('TotalCusto_cmp').Value := ibTabelas.FieldByName('VLTOTAL').AsFloat;
                sqlComprasc.Parameters.ParamByName('observacao_cmp').Value := 'MIGRAÇÃO';
                sqlComprasc.ExecSQL;
        end;
            ibTabelas.Next;
      end;
      chk_Comprasc.Checked := False;
      mmStatusMigracao.Lines.Add('COMPRASC OK');
      ProgressBar1.Position := 0;
      Btn_migrar.Enabled := True;
      Btn_Migrar.Caption := 'Migrar';
    end;

    if chk_Comprasd.Checked then begin
    //************** COMPRAS  *********************************//
      Btn_migrar.Enabled := False;
      Btn_Migrar.Caption := 'Migrando compras';


      ibTabelas.Close;
      ibTabelas.Sql.Clear;
      ibTabelas.Sql.Add('select count(1) as Nro from entsai2 ');
      ibTabelas.Sql.Add('where codprod in ( select codigoi from produtos) ');
      ibTabelas.Sql.Add('and pedido in (select codigoi from entsai) ');
      ibTabelas.Open;
      ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

      ibTabelas.Close;
      ibTabelas.Sql.Clear;
      ibTabelas.Sql.Add('select * from entsai2 es2 ');
      ibTabelas.Sql.Add('inner join entsai es on(es2.pedido = es.codigoi) ');
      ibTabelas.Sql.Add('where codprod in ( select codigoi from produtos) ');
      ibTabelas.Sql.Add('and pedido in (select codigoi from entsai) ');
      ibTabelas.Open;

      sqlTMP.Close;
      sqlTMP.Sql.Clear;
      sqlTMP.Sql.Add('Delete From comprasd_tb ');
      sqlTMP.ExecSql;
      ProgressBar1.Position := 0;

      sqlTMP.Close;
      sqlTMP.Sql.Clear;
      sqlTMP.Sql.Add('Alter Table Kardex_Tb Disable trigger trg_kardex_insert');
      sqlTMP.ExecSql;

      sqlTMP.Close;
      sqlTMP.Sql.Clear;
      sqlTMP.Sql.Add('Alter Table Comprasd_Tb Disable trigger trg_atualizaEstoqueApagaItensCompra');
      sqlTMP.ExecSql;

      sqlTMP.Close;
      sqlTMP.Sql.Clear;
      sqlTMP.Sql.Add('Alter Table Comprasd_Tb Disable trigger trg_atualizaEstoqueIncluiItensCompra');
      sqlTMP.ExecSql;

      sqlTMP.Close;
      sqlTMP.Sql.Clear;
      sqlTMP.Sql.Add('Alter Table Comprasd_Tb Disable trigger trg_atualizaEstoqueIncluiItensCompraOLD');
      sqlTMP.ExecSql;

      sqlTMP.Close;
      sqlTMP.Sql.Clear;
      sqlTMP.Sql.Add('Alter Table Comprasd_Tb Disable trigger trg_atualizaEstoqueApagaItensCompraOLD');
      sqlTMP.ExecSql;

      sqlTMP.Close;
      sqlTMP.Sql.Clear;
      sqlTMP.Sql.Add('Alter Table Comprasd_Tb Disable trigger trg_IncluiHexasIncluiItensCompra');
      sqlTMP.ExecSql;


      sqlTMP.Close;
      sqlTMP.Sql.Clear;
      sqlTMP.Sql.Add('Alter Table Comprasd_Tb Disable trigger trg_ExcluiHexasExcluiItensCompra');
      sqlTMP.ExecSql;

      while not ibTabelas.Eof do begin
        if   (ibTabelas.FieldByName('fornec').AsInteger > 0) and
             (ibTabelas.FieldByName('fornec').AsInteger <> 34) and
             (ibTabelas.FieldByName('fornec').AsInteger <> 200) and
             (ibTabelas.FieldByName('fornec').AsInteger <> 21) then begin
              ProgressBar1.Position := ProgressBar1.Position + 1;
              StatusBar1.Panels[0].Text := 'Item: ' +
                  ibTabelas.FieldByName('codigoi').AsString + ' - Pedido - ' +
                  ibTabelas.FieldByName('pedido').AsString + ' - Pro: ' +
                  ibTabelas.FieldByName('codprod').AsString;
              application.ProcessMessages;
              StatusBar1.Refresh;

              // Campos
              sqlComprasd.Parameters.ParamByName('Codigo_cmp').Value := ibTabelas.FieldByName('pedido').AsInteger;
              sqlComprasd.Parameters.ParamByName('Codigo_prd').Value := ibTabelas.FieldByName('codprod').AsInteger;
              sqlComprasd.Parameters.ParamByName('Quant_cmd').Value := ibTabelas.FieldByName('qtd_pedida').AsFloat;
              sqlComprasd.Parameters.ParamByName('Valor_cmd').Value := ibTabelas.FieldByName('vlunit').AsFloat;
              sqlComprasd.Parameters.ParamByName('QuantPorEmb_cmd').Value := 0;
              sqlComprasd.Parameters.ParamByName('AtualizarPrecoVenda_cmd').Value := 'N';
              sqlComprasd.Parameters.ParamByName('Descricao_cmd').Value := ibTabelas.FieldByName('DSPRODUTO').AsString;
              sqlComprasd.ExecSQL;
        end;
            ibTabelas.Next;
      end;
      chk_comprasd.Checked := False;

      sqlTMP.Close;
      sqlTMP.Sql.Clear;
      sqlTMP.Sql.Add('Alter Table Kardex_Tb Enable trigger trg_kardex_insert');
      sqlTMP.ExecSql;

      sqlTMP.Close;
      sqlTMP.Sql.Clear;
      sqlTMP.Sql.Add('Alter Table Comprasd_Tb Enable trigger trg_atualizaEstoqueApagaItensCompra');
      sqlTMP.ExecSql;

      sqlTMP.Close;
      sqlTMP.Sql.Clear;
      sqlTMP.Sql.Add('Alter Table Comprasd_Tb Enable trigger trg_atualizaEstoqueIncluiItensCompra');
      sqlTMP.ExecSql;

      sqlTMP.Close;
      sqlTMP.Sql.Clear;
      sqlTMP.Sql.Add('Alter Table Comprasd_Tb Enable trigger trg_atualizaEstoqueIncluiItensCompraOLD');
      sqlTMP.ExecSql;

      sqlTMP.Close;
      sqlTMP.Sql.Clear;
      sqlTMP.Sql.Add('Alter Table Comprasd_Tb Enable trigger trg_atualizaEstoqueApagaItensCompraOLD');
      sqlTMP.ExecSql;

      sqlTMP.Close;
      sqlTMP.Sql.Clear;
      sqlTMP.Sql.Add('Alter Table Comprasd_Tb Enable trigger trg_IncluiHexasIncluiItensCompra');
      sqlTMP.ExecSql;


      sqlTMP.Close;
      sqlTMP.Sql.Clear;
      sqlTMP.Sql.Add('Alter Table Comprasd_Tb Enable trigger trg_ExcluiHexasExcluiItensCompra');
      sqlTMP.ExecSql;

      mmStatusMigracao.Lines.Add('COMPRASD OK');
      ProgressBar1.Position := 0;
      Btn_migrar.Enabled := True;
      Btn_Migrar.Caption := 'Migrar';
    end;

    // Acertando e-mail de fornecedor
    if chk_AcertaProd2.Checked then begin
        // Acertando e-mail de fornecedor
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Acertando e-mail de Forn.';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('SELECT count(1) as Nro FROM FORNECEDORES');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('SELECT * FROM FORNECEDORES');
        ibTabelas.Open;

        ProgressBar1.Position := 0;
        ibTabelas.First;
        while not ibTabelas.Eof do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'FORNECEDOR:' +
                ibTabelas.FieldByName('NOME').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;

            // Campos
            sqlAcertaFornecedores.Parameters.ParamByName('Email_for').value := padr(ibTabelas.FieldByName('EMAIL').AsString, 40);
            sqlAcertaFornecedores.Parameters.ParamByName('Codigo_for').Value := ibTabelas.FieldByName('CODIGOI').AsInteger;
            //Fim de campos

            sqlAcertaFornecedores.ExecSql;

            ibTabelas.Next;
        end;
        chk_AcertaProd2.Checked := false;

        mmStatusMigracao.Lines.Add('Acerto de Fornecedores OK');
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;


    if chk_AcertaProd2.Checked then begin
        // Acertando trib de produtos
        Btn_migrar.Enabled := False;
        Btn_Migrar.Caption := 'Acertando Produtos.';

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select count(1) as Nro from produtos ');
        ibTabelas.Open;
        ProgressBar1.Max := ibTabelas.FieldByName('Nro').AsInteger;

        ibTabelas.Close;
        ibTabelas.Sql.Clear;
        ibTabelas.Sql.Add('Select  *  from produtos');
        ibTabelas.Open;

        ProgressBar1.Position := 0;
        ibTabelas.First;
        while not ibTabelas.Eof do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'Produto: ' + ibTabelas.FieldByName('DESCRICAO').AsString + ' - '
                   + ibTabelas.FieldByName('CodigoI').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;

            // Campos
            //Verifica se o produto é inativo
            if  (ibTabelas.FieldByName('Grupo').AsString  = '2') then begin
                sqlAcertaProduto2.Parameters.ParamByName('Codigo_prd').value := ibTabelas.FieldByName('CodigoI').AsInteger;
                sqlAcertaProduto2.ExecSql;
            end;
            //fim campos

            ibTabelas.Next;
        end;
        chk_AcertaOP.Checked := false;

        mmStatusMigracao.Lines.Add('Acerto de Produtos OK');
        ProgressBar1.Position := 0;
        Btn_migrar.Enabled := True;
        Btn_Migrar.Caption := 'Migrar';
    end;

    {
    sqlTMP.Close;
    sqlTMP.Sql.Clear;
    sqlTMP.Sql.Add('update produtos_tb set descricao_prd = ''PRODUTO SEM DESCRICAO NO SAG'' where Codigo_prd = 252 ');
    sqlTMP.ExecSQL;

    sqlTMP.Close;
    sqlTMP.Sql.Clear;
    sqlTMP.Sql.Add('DELETE FROM ESTOQUEPORLOCAL_TB FROM ESTOQUEPORLOCAL_TB LEFT OUTER JOIN PRODUTOS_TB ON ');
    sqlTMP.Sql.Add(' (PRODUTOS_TB.CODIGO_PRD = ESTOQUEPORLOCAL_TB.CODIGO_PRD) WHERE LTRIM(RTRIM(PRODUTOS_TB.DESCRICAO_PRD)) = ''''  ');
    sqlTMP.ExecSql;

    sqlTMP.Close;
    sqlTMP.Sql.Clear;
    sqlTMP.Sql.Add('DELETE FROM ProdutosPreco_tb FROM ProdutosPreco_tb LEFT OUTER JOIN PRODUTOS_TB ON ');
    sqlTMP.Sql.Add(' (PRODUTOS_TB.CODIGO_PRD = ProdutosPreco_tb.CODIGO_PRD) WHERE LTRIM(RTRIM(PRODUTOS_TB.DESCRICAO_PRD)) = ''''  ');
    sqlTMP.ExecSql;

    sqlTMP.Close;
    sqlTMP.Sql.Clear;
    sqlTMP.Sql.Add('DELETE FROM Kardex_tb FROM Kardex_tb LEFT OUTER JOIN PRODUTOS_TB ON ');
    sqlTMP.Sql.Add(' (PRODUTOS_TB.CODIGO_PRD = Kardex_tb.CODIGO_PRD) WHERE LTRIM(RTRIM(PRODUTOS_TB.DESCRICAO_PRD)) = ''''  ');
    sqlTMP.ExecSql;

    sqlTMP.Close;
    sqlTMP.Sql.Clear;
    sqlTMP.Sql.Add('delete from produtos_tb where ltrim(rtrim(descricao_prd)) = '''' ');
    sqlTMP.ExecSQL;
}
    mmStatusMigracao.Lines.Add('MIGRAÇÃO FINALIZADA COM SUCESSO');

end;

procedure Tf_principal.Dados_dbAfterConnect(Sender: TObject);
begin
    if BancoToken.Connected and Dados_db.Connected then
        Btn_migrar.Enabled := true
    else
        Btn_migrar.Enabled := False;

end;

procedure Tf_principal.Button1Click(Sender: TObject);
begin
    ibTmp.Close;
    ibTmp.SQL.Clear;
    ibTmp.SQL.Add('update clientes set dataNasc = :Data where codigoi = 2');
    ibTmp.ParamByName('Data').Value := strtodate('01/01/0200');
    ibTmp.ExecSQL;
    IBTransaction1.Commit;

end;

procedure Tf_principal.AcertoostokenClick(Sender: TObject);
var
    item : Integer;
begin
        Btn_Migrar.Caption := 'Acertando OS';

        sqlBuscaos.Close;
        sqlBuscaos.Sql.Clear;
        sqlBuscaos.SQL.Add(' select count(1) as Nro from os_tb os left outer join itensos_tb ios on(os.Codigo_os = ios.Codigo_os) ');
        sqlBuscaos.SQL.Add(' left outer join ServicoOs_tb sos on(os.Codigo_os = sos.Codigo_os) ');
        sqlBuscaos.SQL.Add(' where os.Cupom_mvc is not null and os.situacao_os = ''T'' ');
        sqlBuscaos.Open;
        ProgressBar1.Max := sqlBuscaos.FieldByName('Nro').AsInteger;

        sqlBuscaos.Close;
        sqlBuscaos.Sql.Clear;
        sqlBuscaos.SQL.Add(' select * from os_tb os left outer join itensos_tb ios on(os.Codigo_os = ios.Codigo_os) ');
        sqlBuscaos.SQL.Add(' left outer join ServicoOs_tb sos on(os.Codigo_os = sos.Codigo_os) ');
        sqlBuscaos.SQL.Add(' where os.Cupom_mvc is not null and os.situacao_os = ''T'' ');
        sqlBuscaos.Open;
        item := 0;
        while not sqlBuscaos.Eof do begin
            ProgressBar1.Position := ProgressBar1.Position + 1;
            StatusBar1.Panels[0].Text := 'Cod OS: ' +
                sqlBuscaos.FieldByName('Codigo_os').AsString;
            application.ProcessMessages;
            StatusBar1.Refresh;
            item := item + 1;

            // Campos
                try
                    sqlMovimD.Parameters.ParamByName('Cupom_mvc').Value := sqlBuscaos.FieldByName('Cupom_mvc').AsInteger;
                    sqlMovimD.Parameters.ParamByName('NroItem_mvd').Value := item;

                    if (sqlBuscaos.FieldByName('Codigo_prd').AsString <> '') then begin

                    {    sqlMovimD.Parameters.ParamByName('Codigo_prd').Value := sqlBuscaos.FieldByName('Codigo_prd').AsInteger;
                        sqlMovimD.Parameters.ParamByName('Quant_mvd').Value := sqlBuscaos.FieldByName('Quant_ito').AsFloat;

                        sqlMovimD.Parameters.ParamByName('PrecoVenda_prd').Value := sqlBuscaos.FieldByName('Valor_ito').AsFloat;
                        sqlMovimD.Parameters.ParamByName('PrecoCusto_prd').Value := sqlBuscaos.FieldByName('CustoProduto_ito').AsFloat;
                        sqlMovimD.Parameters.ParamByName('EntregaFutura_mvd').Value :='N';
                        sqlMovimD.Parameters.ParamByName('QuandoBaixaEstoque_Mvd').Value:= 'V';
                        sqlMovimD.Parameters.ParamByName('QuantJaRetirada_mvd').Value := sqlBuscaos.FieldByName('Quant_ito').AsFloat;
                        sqlTMP.Close;
                        sqlTMP.SQL.Clear;
                        sqlTMP.SQL.Add('select * from produtos_tb where codigo_prd = '+ sqlBuscaos.FieldByName('Codigo_prd').AsString);
                        sqlTMP.Open;

                        sqlMovimD.Parameters.ParamByName('DescricaoPrd_Mvd').Value :=padr(sqlTMP.FieldByName('Descricao_prd').AsString, 50);
                        sqlMovimD.Parameters.ParamByName('Desconto_Mvd').Value := 0;
                        sqlMovimD.Parameters.ParamByName('Acrescimo_Mvd').Value := 0;
                        sqlMovimD.Parameters.ParamByName('QuantDev_mvd').Value := 0;
                        sqlMovimD.Parameters.ParamByName('Celular_Mvd').Value := '';
                        sqlMovimD.Parameters.ParamByName('Fidelizado_Mvd').Value := 0;
                        sqlMovimD.Parameters.ParamByName('Codigo_cmp').Value := NULL;
                        sqlMovimD.Parameters.ParamByName('Codigo_pcl').Value := NULL;
                        sqlMovimD.Parameters.ParamByName('Valor_vlc').Value := 0;
                        sqlMovimD.Parameters.ParamByName('Desconto_vlc').Value := 0;
                        sqlMovimD.Parameters.ParamByName('hexa_mvd').Value := '';
                        sqlMovimD.Parameters.ParamByName('DescAcresGeral_mvd').Value :=0;
                        sqlMovimD.Parameters.ParamByName('DescontoGeralCaixa_mvd').Value:= 0;
                        sqlMovimD.Parameters.ParamByName('VendaVista_mvd').Value :=sqlBuscaos.FieldByName('Valor_ito').AsFloat;
                        sqlMovimD.Parameters.ParamByName('VendaPrazo_mvd').Value :=sqlBuscaos.FieldByName('Valor_ito').AsFloat;
                        sqlMovimD.Parameters.ParamByName('Codigo_ven').Value := null;
                        sqlMovimD.Parameters.ParamByName('ProdutoOuServico_mvd').Value:='P';
                        sqlMovimD.Parameters.ParamByName('ProdutoBaixarEstoque_prd').Value :=NULL;
                        sqlMovimD.Parameters.ParamByName('Altura_mvd').Value := 0;
                        sqlMovimD.Parameters.ParamByName('Largura_mvd').Value := 0;
                        sqlMovimD.Parameters.ParamByName('Comprimento_mvd').Value := 0;
                        sqlMovimD.Parameters.ParamByName('quantM3_mvd').Value := 0;
                        sqlMovimD.Parameters.ParamByName('ValorAparelhamento_mvd').Value:= 0;
                        sqlMovimD.Parameters.ParamByName('ProdutoComReceita_mvd').Value:= 'N';
                        sqlMovimD.Parameters.ParamByName('ComissaoVendedor_mvd').Value := 0;
                        sqlMovimD.Parameters.ParamByName('ComissaoSupervisor_mvd').Value := 0;
                        sqlMovimD.Parameters.ParamByName('UnidadesConferidos_mvc').Value := NULL;
                        sqlMovimD.Parameters.ParamByName('ValorMargemAparelho_vlc').Value := 0;
                        sqlMovimD.ExecSql;
                    }
                    end else begin
                    sqlItensos.Parameters.ParamByName('Codigo_os').Value := sqlBuscaos.FieldByName('Codigo_os').AsInteger;
                          if (sqlBuscaos.FieldByName('Codigo_srv').AsString = '1') then begin
                              sqlMovimD.Parameters.ParamByName('Codigo_prd').Value := 7258;
                              sqlItensos.Parameters.ParamByName('Codigo_prd').Value := 7258;
                          end else if (sqlBuscaos.FieldByName('Codigo_srv').AsString = '2') then begin
                              sqlMovimD.Parameters.ParamByName('Codigo_prd').Value := 8760;
                              sqlItensos.Parameters.ParamByName('Codigo_prd').Value := 8760;
                          end else if (sqlBuscaos.FieldByName('Codigo_srv').AsString = '3') then begin
                              sqlMovimD.Parameters.ParamByName('Codigo_prd').Value := 9493;
                              sqlItensos.Parameters.ParamByName('Codigo_prd').Value := 9493;
                          end else if (sqlBuscaos.FieldByName('Codigo_srv').AsString = '4') then begin
                              sqlMovimD.Parameters.ParamByName('Codigo_prd').Value := 8740;
                              sqlItensos.Parameters.ParamByName('Codigo_prd').Value := 8740;
                          end;

                          sqlMovimD.Parameters.ParamByName('Quant_mvd').Value := sqlBuscaos.FieldByName('Quant_os').AsFloat;
                          sqlItensos.Parameters.ParamByName('Quant_ito').Value := sqlBuscaos.FieldByName('Quant_os').AsFloat;
                          sqlMovimD.Parameters.ParamByName('PrecoVenda_prd').Value :=sqlBuscaos.FieldByName('ValorServicos_os').AsFloat;
                          sqlItensos.Parameters.ParamByName('Valor_ito').Value :=sqlBuscaos.FieldByName('ValorServicos_os').AsFloat;
                          sqlMovimD.Parameters.ParamByName('PrecoCusto_prd').Value :=sqlBuscaos.FieldByName('CustoServico_os').AsFloat;
                          sqlItensos.Parameters.ParamByName('CustoProduto_ito').Value :=sqlBuscaos.FieldByName('CustoServico_os').AsFloat;

                          sqlItensos.Parameters.ParamByName('Estoquista_usr').Value := 'MIGR***';
                          sqlItensos.Parameters.ParamByName('Solicitante_usr').Value := 'MIGR***';

                          sqlMovimD.Parameters.ParamByName('EntregaFutura_mvd').Value :='N';
                          sqlMovimD.Parameters.ParamByName('QuandoBaixaEstoque_Mvd').Value:= 'V';
                          sqlMovimD.Parameters.ParamByName('QuantJaRetirada_mvd').Value := sqlBuscaos.FieldByName('Quant_os').AsFloat;

                          sqlTMP.Close;
                          sqlTMP.SQL.Clear;
                          sqlTMP.SQL.Add('select * from servicos_tb where Codigo_srv = '+ sqlBuscaos.FieldByName('Codigo_srv').AsString);
                          sqlTMP.Open;

                          sqlMovimD.Parameters.ParamByName('DescricaoPrd_Mvd').Value := padr(sqlTMP.FieldByName('Descricao_srv').AsString, 50);
                          sqlMovimD.Parameters.ParamByName('Desconto_Mvd').Value := 0;
                          sqlMovimD.Parameters.ParamByName('Acrescimo_Mvd').Value := 0;
                          sqlMovimD.Parameters.ParamByName('QuantDev_mvd').Value := 0;
                          sqlMovimD.Parameters.ParamByName('Celular_Mvd').Value := '';
                          sqlMovimD.Parameters.ParamByName('Fidelizado_Mvd').Value := 0;
                          sqlMovimD.Parameters.ParamByName('Codigo_cmp').Value := NULL;
                          sqlMovimD.Parameters.ParamByName('Codigo_pcl').Value := NULL;
                          sqlMovimD.Parameters.ParamByName('Valor_vlc').Value := 0;
                          sqlMovimD.Parameters.ParamByName('Desconto_vlc').Value := 0;
                          sqlMovimD.Parameters.ParamByName('hexa_mvd').Value := '';
                          sqlMovimD.Parameters.ParamByName('DescAcresGeral_mvd').Value :=0;
                          sqlMovimD.Parameters.ParamByName('DescontoGeralCaixa_mvd').Value:= 0;
                          sqlMovimD.Parameters.ParamByName('VendaVista_mvd').Value :=sqlBuscaos.FieldByName('ValorServicos_os').AsFloat;
                          sqlMovimD.Parameters.ParamByName('VendaPrazo_mvd').Value :=sqlBuscaos.FieldByName('ValorServicos_os').AsFloat;
                          sqlMovimD.Parameters.ParamByName('Codigo_ven').Value := null;
                          sqlMovimD.Parameters.ParamByName('ProdutoOuServico_mvd').Value:='P';
                          sqlMovimD.Parameters.ParamByName('ProdutoBaixarEstoque_prd').Value :=NULL;
                          sqlMovimD.Parameters.ParamByName('Altura_mvd').Value := 0;
                          sqlMovimD.Parameters.ParamByName('Largura_mvd').Value := 0;
                          sqlMovimD.Parameters.ParamByName('Comprimento_mvd').Value := 0;
                          sqlMovimD.Parameters.ParamByName('quantM3_mvd').Value := 0;
                          sqlMovimD.Parameters.ParamByName('ValorAparelhamento_mvd').Value:= 0;
                          sqlMovimD.Parameters.ParamByName('ProdutoComReceita_mvd').Value:= 'N';
                          sqlMovimD.Parameters.ParamByName('ComissaoVendedor_mvd').Value := 0;
                          sqlMovimD.Parameters.ParamByName('ComissaoSupervisor_mvd').Value := 0;
                          sqlMovimD.Parameters.ParamByName('UnidadesConferidos_mvc').Value := NULL;
                          sqlMovimD.Parameters.ParamByName('ValorMargemAparelho_vlc').Value := 0;
                          sqlItensos.ExecSQL;
                          sqlMovimD.ExecSql;
                    end;
                except
                end;
            sqlBuscaos.Next;
        end;

        mmStatusMigracao.Lines.Add('OS ACERTADAS');
end;

procedure Tf_principal.SAIRExecute(Sender: TObject);
begin
  CLOSE;
end;

procedure Tf_principal.BitBtn1Click(Sender: TObject);
var
  HORA, MINUTODEC , i : Integer;
  MINUTO : Real;
  AntesVirgula : Boolean;
  Periodo : TDateTime;
  s : string;
begin
    Label1.Caption := Edit1.Text;
end;

function Tf_principal.Convertehoradecimalparadatetime(
  hora: String): TDateTime;
var
  HORAint, MINUTODEC , i : Integer;
  MINUTO : Real;
  AntesVirgula : Boolean;
  Periodo : TTime;
  s : string;
begin
    AntesVirgula := True;
    s := hora;
    HORAint := StrToInt(COPY(s,1, Pos(',',s)-1 ));
    MINUTODEC := StrToInt(COPY(s,Pos(',',s)+1,2));

    MINUTO :=  MINUTODEC*60/100;
    MINUTODEC := ROUND(MINUTO);

    Periodo := EncodeTime(HORAint,MINUTODEC,0,0);

    if HORAint > 9 then
      Periodo := Periodo+9;

    result := StrToDateTime('01/01/1900 '+timetostr(Periodo));
end;

procedure Tf_principal.chk_ReceberClick(Sender: TObject);
begin
   if chk_Receber.Checked = True then begin
      RG_Receber.ItemIndex := 0;
      RG_Receber.Enabled := True;
   end else if chk_Receber.Checked = False then begin
      RG_Receber.Enabled := False;
      RG_Receber.ItemIndex := 2;
   end;

end;

procedure Tf_principal.chk_PagarClick(Sender: TObject);
begin
   if chk_Pagar.Checked = True then begin
      RG_Pagar.Enabled := True;
   end else if chk_Pagar.Checked = False then begin
      RG_Pagar.Enabled := False;
      RG_Pagar.ItemIndex := 2;
   end;

end;

procedure Tf_principal.btnConectaIBClick(Sender: TObject);
begin
    ServerFB.Clear;
    if od_token.Execute then begin
       ServerFB.Text := 'Localhost:' + Trim(od_token.FileName);
    end;

end;

end.



