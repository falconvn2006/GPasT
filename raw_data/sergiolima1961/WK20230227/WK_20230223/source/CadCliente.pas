unit CadCliente;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  Vcl.ExtCtrls,
  Data.DB,
  Vcl.StdCtrls,
  Vcl.Mask,
  Vcl.DBCtrls,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  // Units Necessárias
  FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  Xml.xmldom, Xml.XmlTransform, Xml.XMLIntf, Xml.XMLDoc,
  FireDAC.VCLUI.Wait, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdTelnet, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  IdBaseComponent, IdMessage,

  IdText, IdAttachmentFile, Vcl.ComCtrls, IdCustomTCPServer,
  IdSocksServer, IdHTTP, Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB,
  FireDAC.Stan.StorageJSON  , System.JSON, Vcl.ToolWin, Datasnap.DBClient,
  Datasnap.Provider
   ;






type
  TEnderecoCompleto = record
    CEP, logradouro, complemento, bairro, localidade, uf, unidade,
      IBGE: string end;

  type
    TfCadCliente = class(TForm)
      Svd1: TSaveDialog;
      XMLDocument1: TXMLDocument;
      IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
      IdSMTP: TIdSMTP;
      IdHTTP: TIdHTTP;
      IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    GroupBox2: TGroupBox;
    pnlCadastro: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label14: TLabel;
    Panel1: TPanel;
    Label16: TLabel;
    DBNavigator1: TDBNavigator;
    btn_novo: TButton;
    btn_cancelar: TButton;
    btn_gravar: TButton;
    btn_Editar: TButton;
    btn_Excluir: TButton;
    dbCliente: TDBGrid;
    gb_Endereco: TGroupBox;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Button_Buscar_Cep: TButton;
    Label15: TLabel;
    EdPrimeiro: TEdit;
    qry_vENDERECO_INTEGRACAO: TADOQuery;
    EdSegundo: TEdit;
    EdDOCUMENTO: TEdit;
    EdDATAREGISTRO: TEdit;
    RG_Natureza: TRadioGroup;
    EdIdPessoa: TEdit;
    ds_qry_vENDERECO_INTEGRACAO: TDataSource;
    qry_vENDERECO_INTEGRACAODSCEP: TStringField;
    qry_vENDERECO_INTEGRACAOIDPESSOA: TLargeintField;
    qry_vENDERECO_INTEGRACAONATUREZA: TIntegerField;
    qry_vENDERECO_INTEGRACAODOCUMENTO: TStringField;
    qry_vENDERECO_INTEGRACAOPRIMEIRO: TStringField;
    qry_vENDERECO_INTEGRACAOSEGUNDO: TStringField;
    qry_vENDERECO_INTEGRACAODATAREGISTRO: TDateTimeField;
    qry_vENDERECO_INTEGRACAOIDENDERECO: TLargeintField;
    qry_vENDERECO_INTEGRACAOUF: TStringField;
    qry_vENDERECO_INTEGRACAOCIDADE: TStringField;
    qry_vENDERECO_INTEGRACAOBAIRRO: TStringField;
    qry_vENDERECO_INTEGRACAOLOGRADOURO: TStringField;
    qry_vENDERECO_INTEGRACAOCOMPLEMENTO: TStringField;
    EdDSCEP: TEdit;
    EdLOGRADOURO: TEdit;
    edCOMPLEMENTO: TEdit;
    edCIDADE: TEdit;
    EdBAIRRO: TEdit;
    EdUF: TEdit;
    Qry_Execucao: TADOQuery;
    btnLote: TButton;
    memLista: TMemo;
    LB_dados: TListBox;
    MemMeusArquivos: TMemo;
    ProgressBar1: TProgressBar;
    dsp_vENDERECO_INTEGRACAO: TDataSetProvider;
    cds_vENDERECO_INTEGRACAO: TClientDataSet;
    cds_vENDERECO_INTEGRACAOIDPESSOA: TLargeintField;
    cds_vENDERECO_INTEGRACAOPRIMEIRO: TStringField;
    cds_vENDERECO_INTEGRACAOSEGUNDO: TStringField;
    cds_vENDERECO_INTEGRACAODATAREGISTRO: TDateTimeField;
    cds_vENDERECO_INTEGRACAONATUREZA: TIntegerField;
    cds_vENDERECO_INTEGRACAODOCUMENTO: TStringField;
    cds_vENDERECO_INTEGRACAODSCEP: TStringField;
    cds_vENDERECO_INTEGRACAOLOGRADOURO: TStringField;
    cds_vENDERECO_INTEGRACAOCOMPLEMENTO: TStringField;
    cds_vENDERECO_INTEGRACAOBAIRRO: TStringField;
    cds_vENDERECO_INTEGRACAOIDENDERECO: TLargeintField;
    cds_vENDERECO_INTEGRACAOCIDADE: TStringField;
    cds_vENDERECO_INTEGRACAOUF: TStringField;
      procedure btn_novoClick(Sender: TObject);
      procedure btn_cancelarClick(Sender: TObject);
      procedure btn_gravarClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
      procedure Button_Buscar_CepClick(Sender: TObject);
      procedure btn_EditarClick(Sender: TObject);
      procedure btn_ExcluirClick(Sender: TObject);
      procedure DS_PessoaDataChange(Sender: TObject; Field: TField);
    procedure btnLoteClick(Sender: TObject);
    procedure cds_vENDERECO_INTEGRACAOAfterScroll(DataSet: TDataSet);

    private
      { Private declarations }
    var
      dadosEnderecoCompleto: TEnderecoCompleto;
      sSql : WideString;

    const
      sFrom = 'sergiolima.lima90@gmail.com'; // seu email
      sHost = 'smtp.gmail.com';
      iPort = 587;
      sUserName = ''; // email gmail
      sPassword = ''; // senha app

      procedure ConsultaCEP(CEP: String);
      procedure mensagemAviso(mensagem: string);

    public
      { Public declarations }
    end;

  var
    fCadCliente: TfCadCliente;

implementation

{$R *.dfm}

uses
  Main,
  System.RegularExpressions, DM_Atualiza;

procedure TfCadCliente.btn_novoClick(Sender: TObject);
begin
  //
   EdPrimeiro.Text       := EmptyStr;
   EdSegundo.Text        := EmptyStr;
   EdDOCUMENTO.Text      := EmptyStr;
   EdDATAREGISTRO.Text   :=  FormatDateTIME('DD/MM/YYYY',NOW);
   RG_Natureza.ItemIndex := 0;
   EdIdPessoa.Text       := EmptyStr;
   //
   EdDSCEP.Text          := EmptyStr;
   EdBAIRRO.Text         := EmptyStr;
   EdLOGRADOURO.Text     := EmptyStr;
   edCOMPLEMENTO.Text    := EmptyStr;
   edCIDADE.Text         := EmptyStr;
   EdUF.Text             := EmptyStr;

  //
  btn_novo.Enabled       := false;
  btn_Editar.Enabled     := (btn_novo.Enabled);
  btn_Excluir.Enabled    := (btn_novo.Enabled);
  btn_gravar.Enabled     := not(btn_novo.Enabled);
  btn_cancelar.Enabled   := not(btn_novo.Enabled);
  DBNavigator1.Enabled   := (btn_novo.Enabled);
  DBNavigator1.Tag       := btn_novo.Tag;
  //
  dbCliente.Enabled    := btn_novo.Enabled;
  gb_Endereco.Enabled  := not(btn_novo.Enabled);
  pnlCadastro.Enabled  := not(btn_novo.Enabled);
end;

procedure TfCadCliente.btn_cancelarClick(Sender: TObject);
begin
  btn_novo.Enabled       := true;
  DBNavigator1.Enabled   := (btn_novo.Enabled);
  btn_Editar.Enabled     := (btn_novo.Enabled);
  btn_Excluir.Enabled    := (btn_novo.Enabled);
  btn_gravar.Enabled     := not(btn_novo.Enabled);
  btn_cancelar.Enabled   := not(btn_novo.Enabled);
  //
  dbCliente.Enabled    := btn_novo.Enabled;
  gb_Endereco.Enabled  := not(btn_novo.Enabled);
  pnlCadastro.Enabled  := not(btn_novo.Enabled);
  //
  dbCliente.Tag        :=  qry_vENDERECO_INTEGRACAOIDPESSOA.Value;
  cds_vENDERECO_INTEGRACAO.Active := false;
  cds_vENDERECO_INTEGRACAO.Active := true ;
  cds_vENDERECO_INTEGRACAO.Locate('IDPESSOA',dbCliente.Tag,[]);

end;

procedure TfCadCliente.btn_gravarClick(Sender: TObject);
begin

  try

     dbCliente.Tag :=  cds_vENDERECO_INTEGRACAOIDPESSOA.Value;

     case DBNavigator1.Tag of
     1:begin

          sSql := ''
          +'DECLARE  @IDPESSOA BIGINT = 0, '
          +'        @IDENDERECO BIGINT = 0'
          + ''
          +'BEGIN '
          +'    SELECT @IDPESSOA = :IDPESSOA, '
          +'           @IDENDERECO = :IDENDERECO; '
          +' '
          +'    /*  '
          +'    Pessoa '
          +'    */ '
          +'    INSERT INTO [DBO].[pessoa] '
          +'                ([FLNATUREZA], '
          +'                 [DSDOCUMENTO], '
          +'                 [NMPRIMEIRO], '
          +'                 [NMSEGUNDO], '
          +'                 [DTREGISTRO]) '
          +'         VALUES (:FLNATUREZA, '
          +'                 :DSDOCUMENTO, '
          +'                 :NMPRIMEIRO, '
          +'                 :NMSEGUNDO, '
          +'                 :DTREGISTRO ); '
          +' '
          +'    set @IDPESSOA = @@IDENTITY '
          +'    /* '
          +'      endereço '
          +'    */ '
          +'    INSERT INTO [DBO].[endereco] '
          +'                ([IDPESSOA], '
          +'                 [DSCEP]) '
          +'         VALUES ( @IDPESSOA, '
          +'                 :DSCEP ); '
          +' '
          +'    set @IDENDERECO = @@IDENTITY '
          +'    /*  '
          +'    endereco_integracao '
          +'    */ '
          +'    INSERT INTO [DBO].[endereco_integracao] '
          +'                ([IDENDERECO], '
          +'                 [DSUF], '
          +'                 [NMCIDADE], '
          +'                 [NMBAIRRO], '
          +'                 [NMLOGRADOURO], '
          +'                 [DSCOMPLEMENTO]) '
          +'         VALUES (@IDENDERECO, '
          +'                 :DSUF, '
          +'                 :NMCIDADE, '
          +'                 :NMBAIRRO, '
          +'                 :NMLOGRADOURO, '
          +'                 :DSCOMPLEMENTO ) '
          +'END;';
          //
       end;
     2:begin
          sSql := ''
                +'DECLARE   @IDPESSOA BIGINT = 0, '
                +'        @IDENDERECO BIGINT = 0'
                + ''
                +'BEGIN '
                +'    SELECT @IDPESSOA       = :IDPESSOA, '
                +'           @IDENDERECO     = :IDENDERECO; '
                +' '
                +'    UPDATE [DBO].[pessoa] '
                +'       SET [FLNATUREZA]    = :FLNATUREZA, '
                +'           [DSDOCUMENTO]   = :DSDOCUMENTO, '
                +'           [NMPRIMEIRO]    = :NMPRIMEIRO, '
                +'           [NMSEGUNDO]     = :NMSEGUNDO, '
                +'           [DTREGISTRO]    = :DTREGISTRO '
                +'     WHERE IDPESSOA        = @IDPESSOA '
                +' '
                +'    UPDATE [DBO].[endereco] '
                +'       SET [DSCEP]         = :DSCEP '
                +'     WHERE [IDENDERECO]    = @IDENDERECO '
                +' '
                +'    UPDATE [DBO].[endereco_integracao] '
                +'       SET [DSUF]          = :DSUF, '
                +'           [NMCIDADE]      = :NMCIDADE, '
                +'           [NMBAIRRO]      = :NMBAIRRO, '
                +'           [NMLOGRADOURO]  = :NMLOGRADOURO, '
                +'           [DSCOMPLEMENTO] = :DSCOMPLEMENTO '
                +'     WHERE [IDENDERECO]    = @IDENDERECO '
                +'END';
          //
        end;
     end;

      //
      Qry_Execucao.Close;
      Qry_Execucao.SQL.Text := SSQL;
      //
      Qry_Execucao.Parameters.ParamByName('DSDOCUMENTO').Value   := EdDOCUMENTO.Text;
      Qry_Execucao.Parameters.ParamByName('NMPRIMEIRO').Value    := EdPrimeiro.Text ;
      Qry_Execucao.Parameters.ParamByName('NMSEGUNDO').Value     := EdSegundo.Text;
      Qry_Execucao.Parameters.ParamByName('DTREGISTRO').Value    := StrToDateTime( EdDATAREGISTRO.Text );
      Qry_Execucao.Parameters.ParamByName('FLNATUREZA').Value    := RG_Natureza.ItemIndex ;
      //
      Qry_Execucao.Parameters.ParamByName('DSCEP').Value         := EdDSCEP.Text ;
      Qry_Execucao.Parameters.ParamByName('NMBAIRRO').Value      := EdBAIRRO.Text;
      Qry_Execucao.Parameters.ParamByName('NMLOGRADOURO').Value  := EdLOGRADOURO.Text;
      Qry_Execucao.Parameters.ParamByName('DSCOMPLEMENTO').Value := edCOMPLEMENTO.Text;
      Qry_Execucao.Parameters.ParamByName('NMCIDADE').Value      := edCIDADE.Text;
      Qry_Execucao.Parameters.ParamByName('DSUF').Value          := EdUF.Text;

      Qry_Execucao.Parameters.ParamByName('IDENDERECO').Value    := cds_vENDERECO_INTEGRACAOIDENDERECO.Value;
      Qry_Execucao.Parameters.ParamByName('IDPESSOA').Value      := cds_vENDERECO_INTEGRACAOIDPESSOA.Value;
      //
      Qry_Execucao.ExecSQL;
      //
      cds_vENDERECO_INTEGRACAO.Close;
      cds_vENDERECO_INTEGRACAO.Open;
      cds_vENDERECO_INTEGRACAO.Locate('IDPESSOA',dbCliente.Tag,[]);

     //
 except
    On E: Exception do
    begin
       MessageDlg('Ocorreu um erro.' + #13 +
        'Por favor, entre em contato com o administrador do sistema.', mtError,
        [mbOK], 0);
    end;
  end;
  btn_novo.Enabled     := true;
  btn_Editar.Enabled   := (btn_novo.Enabled);
  btn_Excluir.Enabled  := (btn_novo.Enabled);
  btn_gravar.Enabled   := not(btn_novo.Enabled);
  btn_cancelar.Enabled := not(btn_novo.Enabled);
  DBNavigator1.Enabled := (btn_novo.Enabled);
  //
  dbCliente.Enabled    := btn_novo.Enabled;
  gb_Endereco.Enabled  := not(btn_novo.Enabled);
  pnlCadastro.Enabled  := not(btn_novo.Enabled);
end;

procedure TfCadCliente.btn_EditarClick(Sender: TObject);
begin
  dbCliente.Enabled      := false;
  btn_novo.Enabled       := dbCliente.Enabled;
  btn_Editar.Enabled     := (btn_novo.Enabled);
  btn_Excluir.Enabled    := (btn_novo.Enabled);
  btn_gravar.Enabled     := not(btn_novo.Enabled);
  btn_cancelar.Enabled   := not(btn_novo.Enabled);
  DBNavigator1.Enabled   := (btn_novo.Enabled);
  DBNavigator1.Tag       := btn_Editar.Tag;
  //
  gb_Endereco.Enabled  := not(btn_novo.Enabled);
  pnlCadastro.Enabled  := not(btn_novo.Enabled);
end;

procedure TfCadCliente.btn_ExcluirClick(Sender: TObject);
begin
  try

      dbCliente.Tag          :=  cds_vENDERECO_INTEGRACAOIDPESSOA.Value;

      if MessageDlg('Confirma a Exclusão ?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = idYes then
       begin
          try
              sSql := ''
                +'DECLARE   @IDPESSOA BIGINT = 0, '
                +'        @IDENDERECO BIGINT = 0'
                + ''
                +'BEGIN '
                +'    SELECT @IDPESSOA = :IDPESSOA, '
                +'           @IDENDERECO = :IDENDERECO; '
                +' '
                +'    DELETE FROM [DBO].[pessoa] '
                +'     WHERE IDPESSOA = @IDPESSOA '
                +' '
                +'    DELETE FROM [DBO].[endereco] '
                +'     WHERE [IDENDERECO] = @IDENDERECO '
                +' '
                +'    DELETE FROM [DBO].[endereco_integracao] '
                +'     WHERE [IDENDERECO] = @IDENDERECO '
                +'END';
                //
              Qry_Execucao.SQL.Text := SSQL;
              //
              Qry_Execucao.Parameters.ParamByName('IDPESSOA').Value := cds_vENDERECO_INTEGRACAOIDPESSOA.Value;
              Qry_Execucao.Parameters.ParamByName('IDENDERECO').Value := cds_vENDERECO_INTEGRACAOIDENDERECO.Value;
              //
              Qry_Execucao.ExecSQL;
          except
            On E: Exception do
            begin
               MessageDlg('Ocorreu um erro.' + #13 +
                  'Por favor, entre em contato com o administrador do sistema.', mtError,
                  [mbOK], 0);
            end;
          end;
       end;
  finally
      btn_novo.Enabled := true;
      btn_Editar.Enabled := (btn_novo.Enabled);
      btn_Excluir.Enabled := (btn_novo.Enabled);
      btn_gravar.Enabled := not(btn_novo.Enabled);
      btn_cancelar.Enabled := not(btn_novo.Enabled);
      DBNavigator1.Enabled := (btn_novo.Enabled);

      cds_vENDERECO_INTEGRACAO.Close;
      cds_vENDERECO_INTEGRACAO.Open;
      cds_vENDERECO_INTEGRACAO.Locate('IDPESSOA',dbCliente.Tag,[]);
  end;
end;

procedure TfCadCliente.btnLoteClick(Sender: TObject);
var
  z,x,i: Integer;
  CAMINHO,svLinha,Files,Registro :WideString;
  Arquivo : TStringList;
  svetor : array[0..7] of string ;

      procedure ListarArquivos( Diretorio: string; Sub:Boolean);
      var
        F: TSearchRec;
        Ret: Integer;
        TempNome: string;

        function TemAtributo(Attr, Val: Integer): Boolean;
        BEGIN
          Result := Attr and Val = Val;
        END;

      begin
        try
            Ret := FindFirst(Diretorio, faAnyFile, F);
            try
              while Ret = 0 do
              begin
                if TemAtributo(F.Attr, faDirectory) then
                begin
                  if (F.Name <> '.') And (F.Name <> '..') then
                    if Sub = True then
                    begin
                      TempNome := Diretorio+'\' + F.Name;
                      ListarArquivos(TempNome, True);
                    end;
                end
                else
                begin
                  memLista.Lines.Add(Diretorio+'\'+F.Name);
                end;
                  Ret := FindNext(F);
              end;
            finally
              begin
                FindClose(F);
              end;
            end;
        except on E: Exception do
          begin
             MessageDlg('Ocorreu um erro.' + #13 +
              'Por favor, entre em contato com o administrador do sistema.', mtError,
              [mbOK], 0);
          end;
        end;
      end;

      procedure ler_json;
      var
        i: Integer;
        vMensagem: string;
        vJsonValue: TJSONArray;
        SLinha :WideString;
        svetor : array[0..6] of string ;
      begin
        vMensagem :=  MemMeusArquivos.Text;
        vMensagem :=  StringReplace( vMensagem , '['  , '' ,[] );
        vMensagem :=  StringReplace( vMensagem , ']'  , '' ,[] );

        vJsonValue := TJSONObject.ParseJSONValue('[' + vMensagem + ']') as TJSONArray;
        x:= 0;
        for i := 0 to Pred(vJsonValue.Size) do
        begin
            SLinha   :=  TJSONObject(  vJsonValue.Get(i)).Get('rg').JsonValue.Value  ;
            SLinha   :=  Concat(slinha,'|',TJSONObject(  vJsonValue.Get(i)).Get('nome').JsonValue.Value  );
            SLinha   :=  Concat(slinha,'|',TJSONObject(  vJsonValue.Get(i)).Get('cep').JsonValue.Value  );
            SLinha   :=  Concat(slinha,'|',TJSONObject(  vJsonValue.Get(i)).Get('endereco').JsonValue.Value ,
                                       #32,TJSONObject(  vJsonValue.Get(i)).Get('numero').JsonValue.Value  );
            SLinha   :=  Concat(slinha,'|',TJSONObject(  vJsonValue.Get(i)).Get('bairro').JsonValue.Value  );
            SLinha   :=  Concat(slinha,'|',TJSONObject(  vJsonValue.Get(i)).Get('cidade').JsonValue.Value  );
            SLinha   :=  Concat(slinha,'|',TJSONObject(  vJsonValue.Get(i)).Get('estado').JsonValue.Value );

            SLinha   :=  Concat(slinha,'|',TJSONObject(  vJsonValue.Get(i)).Get('data_nasc').JsonValue.Value,'|'  );
            LB_dados.Items.Add( SLinha )
        end;
      end;

begin

    try
          Screen.Cursor := crHourGlass;
          btn_novo.Enabled       := false;
          btn_Editar.Enabled     := (btn_novo.Enabled);
          btn_Excluir.Enabled    := (btn_novo.Enabled);
          btn_gravar.Enabled     := not(btn_novo.Enabled);
          btn_cancelar.Enabled   := not(btn_novo.Enabled);
          DBNavigator1.Enabled   := (btn_novo.Enabled);
          DBNavigator1.Tag       := btn_novo.Tag;
          //
          dbCliente.Enabled    := btn_novo.Enabled;
          gb_Endereco.Enabled  := not(btn_novo.Enabled);
          pnlCadastro.Enabled  := not(btn_novo.Enabled);


          sSql := ''
          +'DECLARE  @IDPESSOA BIGINT = 0, '
          +'        @IDENDERECO BIGINT = 0'
          + ''
          +'BEGIN '
          +'    SELECT @IDPESSOA = :IDPESSOA, '
          +'           @IDENDERECO = :IDENDERECO; '
          +' '
          +'    /*  '
          +'    Pessoa '
          +'    */ '
          +'    INSERT INTO [DBO].[pessoa] '
          +'                ([FLNATUREZA], '
          +'                 [DSDOCUMENTO], '
          +'                 [NMPRIMEIRO], '
          +'                 [NMSEGUNDO], '
          +'                 [DTREGISTRO]) '
          +'         VALUES (:FLNATUREZA, '
          +'                 :DSDOCUMENTO, '
          +'                 Upper(:NMPRIMEIRO), '
          +'                 Upper(:NMSEGUNDO), '
          +'                 :DTREGISTRO ); '
          +' '
          +'    set @IDPESSOA = @@IDENTITY '
          +'    /* '
          +'      endereço '
          +'    */ '
          +'    INSERT INTO [DBO].[endereco] '
          +'                ([IDPESSOA], '
          +'                 [DSCEP]) '
          +'         VALUES ( @IDPESSOA, '
          +'                 :DSCEP ); '
          +' '
          +'    set @IDENDERECO = @@IDENTITY '
          +'    /*  '
          +'    endereco_integracao '
          +'    */ '
          +'    INSERT INTO [DBO].[endereco_integracao] '
          +'                ([IDENDERECO], '
          +'                 [DSUF], '
          +'                 [NMCIDADE], '
          +'                 [NMBAIRRO], '
          +'                 [NMLOGRADOURO], '
          +'                 [DSCOMPLEMENTO]) '
          +'         VALUES (@IDENDERECO, '
          +'                 :DSUF, '
          +'                 Upper(:NMCIDADE), '
          +'                 Upper(:NMBAIRRO), '
          +'                 Upper(:NMLOGRADOURO), '
          +'                 :DSCOMPLEMENTO ) '
          +'END;';

          //
            Qry_Execucao.Close;
            Qry_Execucao.SQL.Text := SSQL;
//              ListarArquivos('C:\Fontes\WK_20230223\massadedados\*.*',TRUE );
            LB_dados.Clear;
            MemMeusArquivos.Clear;
            memLista.Lines.Clear;

            CAMINHO := ExtractFileDir(GetCurrentDir);
            CAMINHO := Concat(CAMINHO,'\massadedados\' );
            ListarArquivos(CAMINHO+'*.*',TRUE );

            Arquivo := TStringList.Create(); // Instancia a variavel do tipo TStringList

            ProgressBar1.Position := 0;
            ProgressBar1.Max      := ProgressBar1.Position;

            if memLista.Lines.Count>1 then
              ProgressBar1.Max      := memLista.Lines.Count -1 ;

          //
          try

              if ProgressBar1.Max=0 then exit;

              for I := 0 to memLista.Lines.Count-1 do
              begin
                  ProgressBar1.Position := i;
                  Files := memLista.Lines[i] ;
                  Files := StringReplace( Files , '\*.*'  , '' ,[] )   ;
                  Arquivo.LoadFromFile( Files ); //Carrega o arquivo selecionado
                  MemMeusArquivos.Clear;
                  MemMeusArquivos.Text := Arquivo.Text; // Recebe o texto do arquivo selecionado
                  ler_json ;
                  //
                  for x := 0 to LB_dados.Items.Count-1 do
                  begin

                    svLinha :=   LB_dados.Items[x] ;
                    for z := 0 to 7  do
                    Begin
                         svetor[z] :=  copy( svLinha,1 ,Pos('|', svLinha)-1 ) ;
                         svLinha   :=  StringReplace( svLinha ,svetor[z],'',[]);
                         svLinha   :=  copy( svLinha,2 ,Length(svLinha) ) ;
                    end;
                    {
                      salva dados
                    }
                    //
                    Qry_Execucao.Parameters.ParamByName('DSDOCUMENTO').Value   := svetor[0];
                    Qry_Execucao.Parameters.ParamByName('NMPRIMEIRO').Value    := copy( svetor[1], 1,Pos(#32, svetor[1])-1 ) ;
                    Qry_Execucao.Parameters.ParamByName('NMSEGUNDO').Value     := copy( svetor[1],Pos(#32, svetor[1])+1 ,Length(svetor[1]) ) ;
                    Qry_Execucao.Parameters.ParamByName('DTREGISTRO').Value    := svetor[7];
                    Qry_Execucao.Parameters.ParamByName('FLNATUREZA').Value    := 0 ;
                    //
                    Qry_Execucao.Parameters.ParamByName('DSCEP').Value         := svetor[2];
                    Qry_Execucao.Parameters.ParamByName('NMLOGRADOURO').Value  := svetor[3];
                    Qry_Execucao.Parameters.ParamByName('NMBAIRRO').Value      := svetor[4];
                    Qry_Execucao.Parameters.ParamByName('DSCOMPLEMENTO').Value := #32;
                    Qry_Execucao.Parameters.ParamByName('NMCIDADE').Value      := svetor[5];
                    Qry_Execucao.Parameters.ParamByName('DSUF').Value          := svetor[6];

                    Qry_Execucao.Parameters.ParamByName('IDENDERECO').Value    := 0;
                    Qry_Execucao.Parameters.ParamByName('IDPESSOA').Value      := 0;
                    //
                    Qry_Execucao.ExecSQL;
                  end;
                  LB_dados.Clear;
                  ProgressBar1.Refresh;
                  DeleteFile( Files );
              end;
              //
              if ProgressBar1.Max>1 then
              begin
                cds_vENDERECO_INTEGRACAO.Close;
                //
                Sleep(2000);
                cds_vENDERECO_INTEGRACAO.Open;
                mensagemAviso('Concluido' + #13 + 'Com Sucesso.');
              end;
              ProgressBar1.Max      := 0;
              memLista.Free; //Libera a variavel de memoria
              Arquivo.Free; //Libera a variavel de memoria
             except
                On E: Exception do
               begin
                   btnLote.Enabled := (memLista.Lines.Count>1) ;
                   MessageDlg('Ocorreu um erro.' + #13 +
                    'Por favor, entre em contato com o administrador do sistema.', mtError,
                    [mbOK], 0);
                end;
          end;
    finally
      Screen.Cursor := crHourGlass;
      //
      btn_novo.Enabled       := True;
      btn_Editar.Enabled     := (btn_novo.Enabled);
      btn_Excluir.Enabled    := (btn_novo.Enabled);
      btn_gravar.Enabled     := not(btn_novo.Enabled);
      btn_cancelar.Enabled   := not(btn_novo.Enabled);
      DBNavigator1.Enabled   := (btn_novo.Enabled);
      DBNavigator1.Tag       := btn_novo.Tag;
      //
      dbCliente.Enabled    := btn_novo.Enabled;
      gb_Endereco.Enabled  := not(btn_novo.Enabled);
      pnlCadastro.Enabled  := not(btn_novo.Enabled);
      btnLote.Enabled      := not(btn_novo.Enabled);
      Screen.Cursor := crDefault;

    end;
end;

procedure TfCadCliente.Button_Buscar_CepClick(Sender: TObject);
begin
  try
    if Length(EdDSCEP.Text) <> 9 then
    begin
      mensagemAviso('CEP inválido');
      EdDSCEP.SetFocus;
      exit;
    end;

    try
      dadosEnderecoCompleto.CEP := StringReplace(EdDSCEP.Text, '-', '',[rfReplaceAll, rfIgnoreCase]) ;
      ConsultaCEP(    dadosEnderecoCompleto.CEP );
    except
      mensagemAviso('CEP inválido');
      EdDSCEP.SetFocus;
    end;
  finally
  end;
end;

procedure TfCadCliente.cds_vENDERECO_INTEGRACAOAfterScroll(DataSet: TDataSet);
begin

  Label16.Caption := FormatFloat('0#####', cds_vENDERECO_INTEGRACAO.RecNo) + '/'
    + FormatFloat('0#####', cds_vENDERECO_INTEGRACAO.RecordCount);

    //
    EdPrimeiro.Text       := cds_vENDERECO_INTEGRACAOPRIMEIRO.Value;
    EdSegundo.Text        := cds_vENDERECO_INTEGRACAOSEGUNDO.Value;
    EdDOCUMENTO.Text      := cds_vENDERECO_INTEGRACAODOCUMENTO.Value;
    EdDATAREGISTRO.Text   := FormatDateTIME('DD/MM/YYYY',cds_vENDERECO_INTEGRACAODATAREGISTRO.AsDateTime);
    RG_Natureza.ItemIndex := cds_vENDERECO_INTEGRACAONATUREZA.Value;
    EdIdPessoa.Text       := cds_vENDERECO_INTEGRACAOIDPESSOA.AsString;
    //
    EdDSCEP.Text         := cds_vENDERECO_INTEGRACAODSCEP.Value;
    EdBAIRRO.Text        := cds_vENDERECO_INTEGRACAOBAIRRO.Value;
    EdLOGRADOURO.Text    := cds_vENDERECO_INTEGRACAOLOGRADOURO.Value;
    edCOMPLEMENTO.Text   := cds_vENDERECO_INTEGRACAOCOMPLEMENTO.Value;
    edCIDADE.Text        := cds_vENDERECO_INTEGRACAOCIDADE.Value;
    EdUF.Text            := cds_vENDERECO_INTEGRACAOUF.Value;

end;

procedure TfCadCliente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  cds_vENDERECO_INTEGRACAO.Close;
end;

procedure TfCadCliente.FormCreate(Sender: TObject);
begin

    try
        Screen.Cursor := crHourGlass;
          try
            cds_vENDERECO_INTEGRACAO.close;
            cds_vENDERECO_INTEGRACAO.open;
        except on E: Exception do
          begin
             MessageDlg('Ocorreu um erro.' + #13 +
              'Por favor, entre em contato com o administrador do sistema.', mtError,
              [mbOK], 0);
          end;
        end;
    finally
        Screen.Cursor := crDefault;
        fMain.Caption := fCadCliente.Caption;
        //
        dbCliente.Enabled    := btn_novo.Enabled;
        gb_Endereco.Enabled  := not(btn_novo.Enabled);
        pnlCadastro.Enabled  := not(btn_novo.Enabled);
    end;
end;


procedure TfCadCliente.ConsultaCEP(CEP: String);
var
  tempXML: IXMLNode;
  tempNodePAI: IXMLNode;
  tempNodeFilho: IXMLNode;
  i: integer;
begin

  XMLDocument1.Active := false;
  XMLDocument1.FileName := 'https://viacep.com.br/ws/' + Trim(CEP) + '/xml/';
  XMLDocument1.Active := true;
  tempXML := XMLDocument1.DocumentElement;

  tempNodePAI := tempXML.ChildNodes.FindNode('logradouro');
  for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
  begin
    tempNodeFilho := tempNodePAI.ChildNodes[i];
    dadosEnderecoCompleto.logradouro := tempNodeFilho.Text;
  end;

  tempNodePAI := tempXML.ChildNodes.FindNode('bairro');
  for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
  begin
    tempNodeFilho := tempNodePAI.ChildNodes[i];
    dadosEnderecoCompleto.bairro := tempNodeFilho.Text;
  end;

  tempNodePAI := tempXML.ChildNodes.FindNode('localidade');
  for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
  begin
    tempNodeFilho := tempNodePAI.ChildNodes[i];
    dadosEnderecoCompleto.localidade := tempNodeFilho.Text;
  end;

  tempNodePAI := tempXML.ChildNodes.FindNode('uf');
  for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
  begin
    tempNodeFilho := tempNodePAI.ChildNodes[i];
    dadosEnderecoCompleto.uf := tempNodeFilho.Text;
  end;

  tempNodePAI := tempXML.ChildNodes.FindNode('complemento');
  for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
  begin
    tempNodeFilho := tempNodePAI.ChildNodes[i];
    dadosEnderecoCompleto.complemento := tempNodeFilho.Text;
  end;

  EdLOGRADOURO.Text  := dadosEnderecoCompleto.logradouro;
  edCOMPLEMENTO.Text := dadosEnderecoCompleto.complemento;
  EdUF.Text          := dadosEnderecoCompleto.uf;
  edCIDADE.Text      := dadosEnderecoCompleto.localidade;
  EdBAIRRO.Text      := dadosEnderecoCompleto.bairro;

end;

procedure TfCadCliente.DS_PessoaDataChange(Sender: TObject; Field: TField);
begin
  Label16.Caption := FormatFloat('0#####', cds_vENDERECO_INTEGRACAO.RecNo) + '/'
    + FormatFloat('0######', cds_vENDERECO_INTEGRACAO.RecordCount);
end;

procedure TfCadCliente.mensagemAviso(mensagem: string);
begin
  Application.MessageBox(PChar(mensagem), '', MB_OK + MB_ICONERROR);
end;


end.
