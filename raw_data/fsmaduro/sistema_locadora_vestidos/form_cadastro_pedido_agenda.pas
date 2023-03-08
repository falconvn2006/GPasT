unit form_cadastro_pedido_agenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, wwdbedit, Wwdotdot,
  Wwdbcomb, dxGDIPlusClasses, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPC, cxControls, wwdbdatetimepicker, RxLookup,
  cxLookAndFeelPainters, Grids, Wwdbigrd, Wwdbgrid, ppComm, ppRelatv, ppDB,
  ppDBPipe, cxContainer, cxEdit, cxGroupBox, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxDBLookupComboBox, cxButtonEdit, Menus, cxButtons, cxDropDownEdit;

type
  Tcadastro_pedido_agenda = class(TForm)
    Panel2: TPanel;
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    btn_excluir: TSpeedButton;
    btn_pesquisar: TSpeedButton;
    btn_novo: TSpeedButton;
    dtsPedido: TDataSource;
    qryPedido: TIBQuery;
    udpPedido: TIBUpdateSQL;
    cxPageControl1: TcxPageControl;
    cxTabSheet2: TcxTabSheet;
    cxTabSheet3: TcxTabSheet;
    dtsPessoaManequim: TDataSource;
    qryPessoaManequim: TIBQuery;
    qryPessoaManequimDESCRICAO: TIBStringField;
    qryPessoaManequimVALOR: TIBBCDField;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    DBCheckBox1: TDBCheckBox;
    wwDBDateTimePicker2: TwwDBDateTimePicker;
    Label2: TLabel;
    wwDBDateTimePicker3: TwwDBDateTimePicker;
    wwDBDateTimePicker4: TwwDBDateTimePicker;
    Label3: TLabel;
    wwDBDateTimePicker5: TwwDBDateTimePicker;
    wwDBDateTimePicker6: TwwDBDateTimePicker;
    Label4: TLabel;
    wwDBDateTimePicker7: TwwDBDateTimePicker;
    DBCheckBox2: TDBCheckBox;
    wwDBDateTimePicker8: TwwDBDateTimePicker;
    Label5: TLabel;
    wwDBDateTimePicker9: TwwDBDateTimePicker;
    wwDBDateTimePicker10: TwwDBDateTimePicker;
    Label6: TLabel;
    wwDBDateTimePicker11: TwwDBDateTimePicker;
    wwDBDateTimePicker12: TwwDBDateTimePicker;
    Label7: TLabel;
    wwDBDateTimePicker13: TwwDBDateTimePicker;
    DBCheckBox3: TDBCheckBox;
    wwDBDateTimePicker14: TwwDBDateTimePicker;
    Label8: TLabel;
    wwDBDateTimePicker15: TwwDBDateTimePicker;
    wwDBDateTimePicker16: TwwDBDateTimePicker;
    Label9: TLabel;
    wwDBDateTimePicker17: TwwDBDateTimePicker;
    wwDBDateTimePicker18: TwwDBDateTimePicker;
    Label10: TLabel;
    wwDBDateTimePicker19: TwwDBDateTimePicker;
    DBCheckBox4: TDBCheckBox;
    wwDBDateTimePicker20: TwwDBDateTimePicker;
    Label11: TLabel;
    wwDBDateTimePicker21: TwwDBDateTimePicker;
    wwDBDateTimePicker22: TwwDBDateTimePicker;
    Label13: TLabel;
    wwDBDateTimePicker23: TwwDBDateTimePicker;
    wwDBDateTimePicker24: TwwDBDateTimePicker;
    Label14: TLabel;
    wwDBDateTimePicker25: TwwDBDateTimePicker;
    DBCheckBox5: TDBCheckBox;
    wwDBDateTimePicker26: TwwDBDateTimePicker;
    Label15: TLabel;
    wwDBDateTimePicker27: TwwDBDateTimePicker;
    wwDBDateTimePicker28: TwwDBDateTimePicker;
    Label16: TLabel;
    wwDBDateTimePicker29: TwwDBDateTimePicker;
    wwDBDateTimePicker30: TwwDBDateTimePicker;
    Label18: TLabel;
    wwDBDateTimePicker31: TwwDBDateTimePicker;
    DBCheckBox6: TDBCheckBox;
    wwDBDateTimePicker32: TwwDBDateTimePicker;
    Label19: TLabel;
    wwDBDateTimePicker33: TwwDBDateTimePicker;
    wwDBDateTimePicker34: TwwDBDateTimePicker;
    Label20: TLabel;
    wwDBDateTimePicker35: TwwDBDateTimePicker;
    wwDBDateTimePicker36: TwwDBDateTimePicker;
    Label21: TLabel;
    wwDBDateTimePicker37: TwwDBDateTimePicker;
    DBCheckBox7: TDBCheckBox;
    wwDBDateTimePicker38: TwwDBDateTimePicker;
    Label22: TLabel;
    wwDBDateTimePicker39: TwwDBDateTimePicker;
    wwDBDateTimePicker40: TwwDBDateTimePicker;
    Label23: TLabel;
    wwDBDateTimePicker41: TwwDBDateTimePicker;
    wwDBDateTimePicker42: TwwDBDateTimePicker;
    Label24: TLabel;
    wwDBDateTimePicker43: TwwDBDateTimePicker;
    cxTabSheet4: TcxTabSheet;
    qryPedidoCODIGO: TIntegerField;
    qryPedidoCODIGOEVENTO: TIntegerField;
    qryPedidoDATAEVENTO: TDateField;
    qryPedidoHORAEVENDO: TTimeField;
    qryPedidoDSP_SEGUNDA: TIntegerField;
    qryPedidoDSP_SEG_H1_I: TTimeField;
    qryPedidoDSP_SEG_H1_F: TTimeField;
    qryPedidoDSP_SEG_H2_I: TTimeField;
    qryPedidoDSP_SEG_H2_F: TTimeField;
    qryPedidoDSP_SEG_H3_I: TTimeField;
    qryPedidoDSP_SEG_H3_F: TTimeField;
    qryPedidoDSP_TERCA: TIntegerField;
    qryPedidoDSP_TER_H1_I: TTimeField;
    qryPedidoDSP_TER_H1_F: TTimeField;
    qryPedidoDSP_TER_H2_I: TTimeField;
    qryPedidoDSP_TER_H2_F: TTimeField;
    qryPedidoDSP_TER_H3_I: TTimeField;
    qryPedidoDSP_TER_H3_F: TTimeField;
    qryPedidoDSP_QUARTA: TIntegerField;
    qryPedidoDSP_QUA_H1_I: TTimeField;
    qryPedidoDSP_QUA_H1_F: TTimeField;
    qryPedidoDSP_QUA_H2_I: TTimeField;
    qryPedidoDSP_QUA_H2_F: TTimeField;
    qryPedidoDSP_QUA_H3_I: TTimeField;
    qryPedidoDSP_QUA_H3_F: TTimeField;
    qryPedidoDSP_QUINTA: TIntegerField;
    qryPedidoDSP_QUI_H1_I: TTimeField;
    qryPedidoDSP_QUI_H1_F: TTimeField;
    qryPedidoDSP_QUI_H2_I: TTimeField;
    qryPedidoDSP_QUI_H2_F: TTimeField;
    qryPedidoDSP_QUI_H3_I: TTimeField;
    qryPedidoDSP_QUI_H3_F: TTimeField;
    qryPedidoDSP_SEXTA: TIntegerField;
    qryPedidoDSP_SEX_H1_I: TTimeField;
    qryPedidoDSP_SEX_H1_F: TTimeField;
    qryPedidoDSP_SEX_H2_I: TTimeField;
    qryPedidoDSP_SEX_H2_F: TTimeField;
    qryPedidoDSP_SEX_H3_I: TTimeField;
    qryPedidoDSP_SEX_H3_F: TTimeField;
    qryPedidoDSP_SABADO: TIntegerField;
    qryPedidoDSP_SAB_H1_I: TTimeField;
    qryPedidoDSP_SAB_H1_F: TTimeField;
    qryPedidoDSP_SAB_H2_I: TTimeField;
    qryPedidoDSP_SAB_H2_F: TTimeField;
    qryPedidoDSP_SAB_H3_I: TTimeField;
    qryPedidoDSP_SAB_H3_F: TTimeField;
    qryPedidoDSP_DOMINGO: TIntegerField;
    qryPedidoDSP_DOM_H1_I: TTimeField;
    qryPedidoDSP_DOM_H1_F: TTimeField;
    qryPedidoDSP_DOM_H2_I: TTimeField;
    qryPedidoDSP_DOM_H2_F: TTimeField;
    qryPedidoDSP_DOM_H3_I: TTimeField;
    qryPedidoDSP_DOM_H3_F: TTimeField;
    qryPedidoSITUACAO: TIntegerField;
    qryPedidoDATACADASTRO: TDateField;
    qryPedidoVERSAO: TIntegerField;
    qryPedidoCODIGOUSUARIO: TIntegerField;
    qryPerfil: TIBQuery;
    qryPerfilCODIGO: TIntegerField;
    qryPerfilNOME: TIBStringField;
    dtsPerfil: TDataSource;
    dtsEvento: TDataSource;
    qryEvento: TIBQuery;
    IntegerField1: TIntegerField;
    IBStringField1: TIBStringField;
    qryAcompanhantes: TIBQuery;
    udpAcompanhantes: TIBUpdateSQL;
    qryTipoConvidado: TIBQuery;
    IntegerField15: TIntegerField;
    IBStringField2: TIBStringField;
    dtsTipoConvidado: TDataSource;
    qryAcompanhantesCODIGOPEDIDO: TIntegerField;
    qryAcompanhantesID: TIntegerField;
    qryAcompanhantesCODIGOPERFIL: TIntegerField;
    qryAcompanhantesCODIGOTIPOCONVIDADO: TIntegerField;
    dtsAcompanhantes: TDataSource;
    cxGrid1DBTableView1CODIGOPERFIL: TcxGridDBColumn;
    cxGrid1DBTableView1CODIGOTIPOCONVIDADO: TcxGridDBColumn;
    cxGrid1DBTableView1Column1: TcxGridDBColumn;
    cxGrid1DBTableView1Column2: TcxGridDBColumn;
    qryUsuario: TIBQuery;
    qryUsuarioCODIGO: TIntegerField;
    qryUsuarioUSERNAME: TIBStringField;
    dtsUsuario: TDataSource;
    qryPedidoNomeUsuario: TStringField;
    PopupMenu1: TPopupMenu;
    Configuraes1: TMenuItem;
    Panel4: TPanel;
    cxGroupBox1: TcxGroupBox;
    cxGroupBox4: TcxGroupBox;
    qryPessoaManequimOBSERVACAO: TIBStringField;
    wwDBGrid2: TwwDBGrid;
    qryAcompanhantesTIPOAGENDAMENTO: TIntegerField;
    qryAcompanhantesDATAMELHORDIA: TDateField;
    qryAcompanhantesHORAMELHORDIA: TTimeField;
    cxGrid1DBTableView1TIPOAGENDAMENTO: TcxGridDBColumn;
    cxGrid1DBTableView1DATAMELHORDIA: TcxGridDBColumn;
    cxGrid1DBTableView1HORAMELHORDIA: TcxGridDBColumn;
    tbmTipoAgendamento: TIBQuery;
    dtsTipoAgendamento: TDataSource;
    tbmTipoAgendamentoID: TIntegerField;
    tbmTipoAgendamentoNOME: TIBStringField;
    qryAcompanhantesOBSERVACOES: TIBStringField;
    cxButton5: TcxButton;
    qryPedidoCONTATO: TIBStringField;
    qryPedidoTELEFONECONTATO: TIBStringField;
    qryPedidoEMAILCONTATO: TIBStringField;
    qryPedidoHORARIOEVENTO: TIntegerField;
    qryPedidoLOCALEVENTO: TIBStringField;
    Panel6: TPanel;
    edtCodigo: TDBEdit;
    lblCodigo: TLabel;
    wwDBDateTimePicker1: TwwDBDateTimePicker;
    Label1: TLabel;
    DBEdit5: TDBEdit;
    Label12: TLabel;
    DBEdit24: TDBEdit;
    Label17: TLabel;
    DBEdit6: TDBEdit;
    cxPageControl2: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    lbPreferncias: TListBox;
    cxTabSheet5: TcxTabSheet;
    DBMemo1: TDBMemo;
    pnlProdutosCompativeis: TPanel;
    Panel5: TPanel;
    Panel7: TPanel;
    Label26: TLabel;
    cxButton2: TcxButton;
    qryPedidoNOMEDIASEMANA: TStringField;
    qryPedidoHORACADASTRO: TTimeField;
    wwDBDateTimePicker44: TwwDBDateTimePicker;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Panel8: TPanel;
    Exigencia1: TcxButton;
    Cor1: TcxButton;
    Estilo1: TcxButton;
    Marca1: TcxButton;
    Acessrios1: TcxButton;
    Pea1: TcxButton;
    cxGroupBox2: TcxGroupBox;
    cxGrid2: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    qryOutrosEventos: TIBQuery;
    updOutrosEventos: TIBUpdateSQL;
    qryOutrosEventosCODIGO: TIntegerField;
    qryOutrosEventosID: TIntegerField;
    qryOutrosEventosCODIGOEVENTO: TIntegerField;
    qryOutrosEventosDATAEVENTO: TDateField;
    qryOutrosEventosHORARIOEVENTO: TIntegerField;
    qryOutrosEventosLOCALEVENTO: TIBStringField;
    dtsOutrosEventos: TDataSource;
    cxGridDBTableView1ID: TcxGridDBColumn;
    cxGridDBTableView1CODIGOEVENTO: TcxGridDBColumn;
    cxGridDBTableView1DATAEVENTO: TcxGridDBColumn;
    cxGridDBTableView1HORARIOEVENTO: TcxGridDBColumn;
    cxGridDBTableView1LOCALEVENTO: TcxGridDBColumn;
    qryOutrosEventosNOMEDIASEMANA: TStringField;
    cxGridDBTableView1Column1: TcxGridDBColumn;
    cxGroupBox3: TcxGroupBox;
    Panel1: TPanel;
    Label40: TLabel;
    Label36: TLabel;
    RxDBLookupCombo1: TRxDBLookupCombo;
    SpeedButton3: TSpeedButton;
    wwDBDateTimePicker45: TwwDBDateTimePicker;
    Label38: TLabel;
    DBEdit3: TDBEdit;
    Label31: TLabel;
    wwDBComboBox1: TwwDBComboBox;
    Label30: TLabel;
    DBMemo2: TDBMemo;
    Label29: TLabel;
    Panel3: TPanel;
    Label41: TLabel;
    Label25: TLabel;
    DBEdit16: TDBEdit;
    Label27: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Label28: TLabel;
    qryTipoHorario: TIBQuery;
    dtsTipoHorario: TDataSource;
    qryTipoHorarioID: TIntegerField;
    qryTipoHorarioNOME: TIBStringField;
    qryAcompanhantesIDEVENTO: TIntegerField;
    cxGrid1DBTableView1Column3: TcxGridDBColumn;
    qryOutrosEventosNOMEEVENTO: TIBStringField;
    qryAcompanhantesNOMEEVENTO: TStringField;
    cxGrid1DBTableView1Column4: TcxGridDBColumn;
    qryAcompanhantesDATAEVENTO: TDateField;
    cxGrid1DBTableView1Column5: TcxGridDBColumn;
    edtInicioAgenda: TwwDBDateTimePicker;
    edtFimAgenda: TwwDBDateTimePicker;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryPedidoAfterPost(DataSet: TDataSet);
    procedure qryPedidoBeforeDelete(DataSet: TDataSet);
    procedure qryPedidoBeforePost(DataSet: TDataSet);
    procedure qryPedidoNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsPedidoStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure qryAcompanhantesNewRecord(DataSet: TDataSet);
    procedure qryAcompanhantesBeforePost(DataSet: TDataSet);
    procedure cxGrid1DBTableView1Column1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxGrid1DBTableView1Column2PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure qryPedidoAfterScroll(DataSet: TDataSet);
    procedure cxGrid1Enter(Sender: TObject);
    procedure qryPedidoBeforeOpen(DataSet: TDataSet);
    procedure Configuraes1Click(Sender: TObject);
    procedure Pea1Click(Sender: TObject);
    procedure qryAcompanhantesAfterScroll(DataSet: TDataSet);
    procedure cxButton5Click(Sender: TObject);
    procedure qryAcompanhantesCODIGOPERFILValidate(Sender: TField);
    procedure cxButton2Click(Sender: TObject);
    procedure DBEdit2Exit(Sender: TObject);
    procedure qryPedidoCalcFields(DataSet: TDataSet);
    procedure cxButton5Exit(Sender: TObject);
    procedure qryOutrosEventosNewRecord(DataSet: TDataSet);
    procedure qryOutrosEventosBeforePost(DataSet: TDataSet);
    procedure qryOutrosEventosCalcFields(DataSet: TDataSet);
    procedure cxGrid2Enter(Sender: TObject);
    procedure cxPageControl1Change(Sender: TObject);
    procedure pnlProdutosCompativeisDblClick(Sender: TObject);
    procedure qryAcompanhantesCalcFields(DataSet: TDataSet);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    NomeMenu: String;
    vConfigTempoAgendaPessoa: TTime;
    vConfigFlaxibilidadeAgenda: TTime;
    vQtdMaximaClientesHorario : Integer;
    procedure CarregaConfiguracoes();
    procedure CarregarDadosPerfil(Codigo: Integer);
    procedure CalculaProdutosCompativeis();
    { Private declarations }
  public
    pubCodigo: integer;
    pubNovoPedido: Boolean;
    cHorarioInicio, cHorarioFim : TDateTime;

    { Public declarations }
  end;

var
  cadastro_pedido_agenda: Tcadastro_pedido_agenda;

implementation

uses untPesquisa, untDados, form_cadastro_perfil, form_cadastro_Evento,
  form_cadastro_Tipo_Convidado, form_inserir_manequim,
  form_inserir_preferencias, form_cadastro_prospect, untAgendarPedido, Funcao,
  untConsultaProdutos, versao;

{$R *.dfm}


//BOTÃO HELP
procedure Tcadastro_pedido_agenda.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin 
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tcadastro_pedido_agenda.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
begin 
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0;
    ControleVersao.ShowAlteracoes(self.Name);
  end
  else
    inherited;
end;
//FIM BOTÃO HELP

procedure Tcadastro_pedido_agenda.CalculaProdutosCompativeis();
begin
  Dados.Geral.SQL.Text :=
     'select count(*) xCont '+
     '  from tabprodutos p '+
     ' where (Select resultado from PROC_PRODUTO_COMPATIVEL_PEDIDO(p.codigo,:codigopedido,:codigoperfil,:ID)) = 1';
  Dados.Geral.ParamByName('codigopedido').AsInteger := qryPedidoCODIGO.AsInteger;
  Dados.Geral.ParamByName('codigoperfil').AsInteger := qryAcompanhantesCODIGOPERFIL.AsInteger;
  Dados.Geral.ParamByName('ID').AsInteger := qryAcompanhantesID.AsInteger;

  Dados.Geral.Open;
  pnlProdutosCompativeis.Caption := IntToStr(Dados.Geral.Fields[0].AsInteger)+' PRODUTOS COMPATÍVEIS';
end;

procedure Tcadastro_pedido_agenda.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Tcadastro_pedido_agenda.Configuraes1Click(Sender: TObject);
begin
  dados.ShowConfig(cadastro_pedido_agenda);
  CarregaConfiguracoes();
end;

procedure Tcadastro_pedido_agenda.cxButton2Click(Sender: TObject);
var
  cAutomatico : Boolean;
//var
//  vTempoAgenda: TTime;
//  i : Integer;
//  vTextoAgenda: String;
begin

  cAutomatico := False;

  if qryPedido.State in [dsEdit, dsInsert] then
     qryPedido.Post;

  if qryAcompanhantes.State in [dsEdit, dsInsert] then
     qryAcompanhantes.Post;


  Dados.Geral.SQL.Text := 'select * '+
                          '  from tabpedidoagendamento p '+
                          '  left join tabacompanhantespedidoagenda a on p.codigo = a.codigopedido '+
                          ' where a.tipoagendamento = 1 '+
                          '   and p.codigo = '+IntToStr(qryPedidoCODIGO.AsInteger)+
                          '   and Exists(Select ag.codigo from tabagenda ag where ag.idpedidoagenda = p.codigo and ag.idperfil = a.codigoperfil and ag.situacao <> 2)';

  Dados.Geral.Open;

  if not Dados.Geral.IsEmpty then
  begin
    application.MessageBox('Pedido Já Agendado!','Agendamento',MB_OK+MB_ICONEXCLAMATION);
    Abort;
  end;

  If Application.FindComponent('frmAgendarPedido') = Nil then
    FreeAndNil(frmAgendarPedido);
  Application.CreateForm(TfrmAgendarPedido, frmAgendarPedido);

  frmAgendarPedido.CodigoPedido := qryPedidoCODIGO.AsInteger;
  frmAgendarPedido.DataEvento   := qryPedidoDATAEVENTO.AsDateTime;
  frmAgendarPedido.vQtdMaximaClientesHorario := vQtdMaximaClientesHorario;
  frmAgendarPedido.FlexibilidadeAgendamento := vConfigFlaxibilidadeAgenda;

  if (pubNovoPedido) and (cHorarioInicio > 0) then
  begin

    Dados.Geral.Close;
    Dados.Geral.SQL.Text := 'select count(1) as qtdNovaAgenda from TABACOMPANHANTESPEDIDOAGENDA '+
                            ' where CODIGOPEDIDO =0'+qryPedidoCODIGO.Text +
                            '  and tipoagendamento = 1 ';
    Dados.Geral.Open;

    if Dados.Geral.FieldByName('qtdNovaAgenda').AsInteger = 1 then
      cAutomatico := True
    else
      cAutomatico := False;
  end;


  if not cAutomatico then
    frmAgendarPedido.ShowModal
  else
  begin

    try

      frmAgendarPedido.Show;

      frmAgendarPedido.WindowState := wsMinimized;

      with frmAgendarPedido do
      begin

        mmAgendas.Edit;
        mmAgendasDATAAGENDA.AsDateTime := edtInicioAgenda.DateTime;
        mmAgendasHORAAGENDA.AsDateTime := edtInicioAgenda.DateTime;
        mmAgendasTEMPOAGENDA.AsDateTime := edtFimAgenda.DateTime - edtInicioAgenda.DateTime;
        mmAgendasAGENDAR.AsBoolean     := True;
        mmAgendas.Post;

        cxButton2.Click;

      end;

    finally
      frmAgendarPedido.Close;
    end;

  end;
  

//  if dtsPedido.State in [dsEdit, dsInsert] then
//  begin
//    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
//                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
//       qryPedido.Post
//    else
//    begin
//      application.MessageBox('Para efetuar o Agendamento o Pedido deve ser Salvo!!','Erro!',MB_OK+MB_ICONERROR);
//      Abort;
//    end;
//  end;
//
//  Dados.Geral3.Sql.Text := 'select e.nome as nomeEvento,pr.nome,tc.nome as nomeTipoConvidado,'#13+
//   '          p.dataevento, '#13+
//   '          p.HoraEvendo, '#13+
//   '          a.codigoperfil, '#13+
//   '          a.datamelhordia, '#13+
//   '          a.horamelhordia, '#13+
//   '          Case when a.id = 1 then  '#13+
//   '             (select Count(a.id) from tabacompanhantespedidoagenda a where p.codigo = a.codigopedido and a.tipoagendamento = 2) '#13+
//   '          else 0 end as QtdeAcompanhantes '#13+
//   '     from tabpedidoagendamento p  '#13+
//   '     left join tabacompanhantespedidoagenda a on p.codigo = a.codigopedido '#13+
//   '     left join tabevento e on p.codigoevento = e.codigo '#13+
//   '     left join tabperfil pr on a.codigoperfil = pr.codigo '#13+
//   '     left join tabtipoconvidado tc on a.codigotipoconvidado = tc.codigo '#13+
//   '    where a.tipoagendamento = 1 '#13+
//   '     and p.codigo = '+IntToStr(qryPedidoCODIGO.AsInteger)+#13+
//   '    order by a.id ';
//  Dados.Geral3.Open;
//
//  if Dados.Geral3.IsEmpty then
//  begin
//    application.MessageBox('Não Existe Perfil Definido com Tipo de Agendamento "NOVA AGENDA"!','Erro!',MB_OK+MB_ICONERROR);
//    Abort;
//  end;
//
//  while not Dados.Geral3.Eof do
//  begin
//    vTempoAgenda := vConfigTempoAgendaPessoa;
//
//    vTextoAgenda := 'Agendado para '+Dados.Geral3.FieldByName('nome').Text+#13+
//                    'Evento: '+Dados.Geral3.FieldByName('nomeEvento').Text+#13+
//                    'Tipo de Convidado: '+Dados.Geral3.FieldByName('nomeTipoConvidado').Text+#13+
//                    'Data: '+FormatDateTime('dd/MM/yyyy',Dados.Geral3.FieldByName('dataevento').AsDateTime)+
//                    ' Hora: '+FormatDateTime('hh:mm',Dados.Geral3.FieldByName('HoraEvendo').AsDateTime);
//
//    if Dados.Geral3.FieldByName('QtdeAcompanhantes').AsInteger > 0 then
//    begin
//      vTextoAgenda := vTextoAgenda +#13'Acompanhado de:';
//      for i := 1 to Dados.Geral3.FieldByName('QtdeAcompanhantes').AsInteger do
//        vTempoAgenda := vTempoAgenda + vConfigTempoAgendaPessoa;
//
//      Dados.Geral2.Sql.Text := 'select '#13+
//        '         pr.nome as nomeperfil, '#13+
//        '         tc.nome as nomeTipoConvidado '#13+
//        '    from tabpedidoagendamento p '#13+
//        '    left join tabacompanhantespedidoagenda a on p.codigo = a.codigopedido '#13+
//        '    left join tabperfil pr on a.codigoperfil = pr.codigo '#13+
//        '    left join tabtipoconvidado tc on a.codigotipoconvidado = tc.codigo '#13+
//        '   where a.tipoagendamento = 2 '#13+
//        '     and p.codigo = '+IntToStr(qryPedidoCODIGO.AsInteger)+#13+
//        '   order by a.id';
//      Dados.Geral2.Open;
//
//      while not Dados.Geral2.Eof do
//      begin
//        vTextoAgenda := vTextoAgenda + #13 + Dados.Geral2.FieldByName('nomeperfil').Text+' - '+Dados.Geral2.FieldByName('nomeTipoConvidado').Text;
//        Dados.Geral2.Next;
//      end;
//    end;
//
//    dados.Agendar(qryPedidoCODIGO.AsInteger,
//                  Dados.Geral3.FieldByName('codigoperfil').AsInteger,
//                  0,
//                  Dados.Geral3.FieldByName('datamelhordia').AsDateTime,
//                  Dados.Geral3.FieldByName('datamelhordia').AsDateTime,
//                  Dados.Geral3.FieldByName('horamelhordia').AsDateTime,
//                  Dados.Geral3.FieldByName('horamelhordia').AsDateTime + vTempoAgenda,
//                  vTextoAgenda);
//
//    Dados.Geral3.Next;
//  end;
//
//  application.MessageBox('Agendado com Sucesso!','Terminado!',MB_OK+MB_ICONEXCLAMATION);

end;

procedure Tcadastro_pedido_agenda.cxButton5Click(Sender: TObject);
begin

  if qryAcompanhantes.State in [dsEdit,dsInsert] then
    qryAcompanhantes.Post;

  if qryAcompanhantesCODIGOPERFIL.AsInteger = 0 then
  begin
    application.MessageBox('Perfil Não Informado!!','Erro!',MB_OK+MB_ICONERROR);
    Abort;
  end;

  If Application.FindComponent('inserir_manequim') = Nil then
    Application.CreateForm(Tinserir_manequim, inserir_manequim);

  inserir_manequim._Finalidade := tfmPerfil;

  inserir_manequim._codigo := qryAcompanhantesCODIGOPERFIL.AsInteger;
  inserir_manequim._codigoPedido := 0;
//  inserir_manequim._codigoPedido := qryPedidoCODIGO.AsInteger;

  inserir_manequim.ShowModal;

  CarregarDadosPerfil(qryAcompanhantesCODIGOPERFIL.AsInteger);

  CalculaProdutosCompativeis();

  Pea1.SetFocus;

end;

procedure Tcadastro_pedido_agenda.cxButton5Exit(Sender: TObject);
begin
  Pea1.SetFocus;
end;

procedure Tcadastro_pedido_agenda.cxGrid1DBTableView1Column1PropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  SpeedButton7Click(self);
end;

procedure Tcadastro_pedido_agenda.cxGrid1DBTableView1Column2PropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  SpeedButton6Click(self);
end;

procedure Tcadastro_pedido_agenda.cxGrid1Enter(Sender: TObject);
begin
  if qryPedido.State in [dsInsert, dsEdit] then
    qryPedido.Post;
    
  if qryAcompanhantes.IsEmpty then
    qryAcompanhantes.Append;
end;

procedure Tcadastro_pedido_agenda.cxGrid2Enter(Sender: TObject);
begin
  if qryPedido.State in [dsInsert, dsEdit] then
    qryPedido.Post;
    
  if qryOutrosEventos.IsEmpty then
    qryOutrosEventos.Append;
end;

procedure Tcadastro_pedido_agenda.cxPageControl1Change(Sender: TObject);
begin

  if qryOutrosEventos.State in [dsEdit,dsInsert] then
    qryOutrosEventos.Post;

  qryOutrosEventos.Close;
  qryOutrosEventos.Open;
end;

procedure Tcadastro_pedido_agenda.DBEdit2Exit(Sender: TObject);
begin
  cxPageControl1.ActivePage := cxTabSheet2;
  cxGrid1.SetFocus; 
end;

procedure Tcadastro_pedido_agenda.CarregaConfiguracoes();
begin
  vConfigTempoAgendaPessoa := Dados.Config(cadastro_pedido_agenda,'TEMPOPORPERFIL','Tempo de Atendimento por Perfil',
                                    'Informe o tempo gasto no atendimento por pessoa contida na agenda para que o sistema calcule a hora fim da agenda.',
                                    StrToTime('00:30:00'),tcHora).vcTime;

  vQtdMaximaClientesHorario := Dados.Config(cadastro_pedido_agenda,'QTDCLIENTESPORHORARIO','Quantidade de pessoas por horário',
                                    'Permite criar nova agenda até que se alcance a quantidade de pessoas definida por horário.',
                                    0,tcInteiro).vcInteger;

  vConfigFlaxibilidadeAgenda := Dados.Config(cadastro_pedido_agenda,'FLEXIBILIDADEAGENDA','Flexibilidade para Encaixe em Agendamento',
                                    'Informe o tempo de flexibilidade para encaixe em agendamento já completado pelo limite de pessoas por horário.',
                                    StrToTime('00:05:00'),tcHora).vcTime;

end;


procedure Tcadastro_pedido_agenda.CarregarDadosPerfil(Codigo: Integer);
begin
  if Codigo > 0 then
  begin
//    dados.Geral.SQL.Text :=
//      'select '+
//      '  Coalesce(c.endereco,'''')||'',''||Coalesce(p.numero,'''')||'' ''||coalesce(p.complemento,'''')||'' - ''|| '+
//      '  Coalesce(c.bairro,'''')||'' - ''||Coalesce(m.nome,'''')||'' / ''||Coalesce(m.uf,'''')||  '+
//      '  '' - CEP: ''||Coalesce(P.cep,'''') as Endereco, '+
//      '  ''Res.: ''||Coalesce(p.telresidencial,'''')||'' - Cel.: ''||Coalesce(p.telcelular,'''')||'' - Com.: ''||Coalesce(p.telcomercial,'''')|| '+
//      '  '' - WhatsApp.: ''||Coalesce(p.whatsapp,'''')||'' - Rec.: ''||Coalesce(p.telrecado,'''')||'' ''||Coalesce(p.pessoarecado,'''') as Contato, '+
//      '  p.email1, '+
//      '  p.facebook, '+
//      '  p.instagram,'+
//      '  p.outro '+
//      '  from TABPERFIL p  '+
//      '  left join tabcep c on p.cep = c.cep '+
//      '  left join tabmunicipios m on c.codigomunicipio = m.codigo '+
//      ' where p.codigo = '+IntToStr(Codigo);
//    dados.Geral.Open;
//
//    lblEndereco.Caption  := dados.Geral.FieldByName('Endereco').Text;
//    lblContato.Caption   := dados.Geral.FieldByName('Contato').Text;
//    lblEmail.Caption     := dados.Geral.FieldByName('email1').Text;
//    lblFacebook.Caption  := dados.Geral.FieldByName('facebook').Text;
//    lblInstagram.Caption := dados.Geral.FieldByName('instagram').Text;
//    lblOutro.Caption     := dados.Geral.FieldByName('outro').Text;

    dados.Geral.SQL.Text :=
      'SELECT Upper(Trim(Case when pp.tipo = 1 then ''Peça'' '+
      '                       when pp.tipo = 2 then ''Acessórios'' '+
      '                       when pp.tipo = 3 then ''Marca'' '+
      '                       when pp.tipo = 4 then ''Estilo'' '+
      '                       when pp.tipo = 5 then ''Cor'' '+
      '                       when pp.tipo = 6 then ''Exigencia'' else '''' end)||'' - ''|| P.descricao) as Preferencia '+
      '  FROM tabpreferenciaspessoas PP  '+
      '  LEFT JOIN tabpreferencias P ON PP.codigopreferencia = P.codigo '+
      '  WHERE PP.codigopedido = '+ qryPedidoCODIGO.Text +
      '  AND PP.codigopessoa = '+ IntToStr(Codigo) +
      '  AND COALESCE(PP.ID,1) = '+ qryAcompanhantesID.Text +
      '  ORDER BY 1 ';
    dados.Geral.Open;

    lbPreferncias.Clear;
    dados.Geral.First;
    while not dados.Geral.Eof do
    begin
      lbPreferncias.Items.Add(dados.Geral.FieldByName('Preferencia').Text);
      dados.Geral.Next;
    end;

    qryPessoaManequim.Close;
    qryPessoaManequim.ParamByName('CODIGOPERFIL').AsInteger := Codigo;
//    qryPessoaManequim.ParamByName('CODIGOPEDIDO').AsInteger := qryPedidoCODIGO.AsInteger;
    qryPessoaManequim.Open;
  end
  else
  begin
//    lblEndereco.Caption  := '';
//    lblContato.Caption   := '';
//    lblEmail.Caption     := '';
//    lblFacebook.Caption  := '';
//    lblInstagram.Caption := '';
//    lblOutro.Caption     := '';

    lbPreferncias.Clear;

    qryPessoaManequim.Close;
  end;

end;

procedure Tcadastro_pedido_agenda.dtsPedidoStateChange(Sender: TObject);
begin
//  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure Tcadastro_pedido_agenda.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryAcompanhantes.State in [dsInsert, dsEdit] then
       qryAcompanhantes.Post;

     if qryPedido.State in [dsInsert, dsEdit] then
       qryPedido.Post;
  end;
end;

procedure Tcadastro_pedido_agenda.btn_novoClick(Sender: TObject);
begin
  if dtsPedido.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
       qryPedido.Post;
  end;
  qryPedido.Insert;
end;

procedure Tcadastro_pedido_agenda.btn_excluirClick(Sender: TObject);
begin
//  dados.VerificaPermicaoOPBD(NomeMenu, dtsPedido, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryPedido.Delete;
end;

procedure Tcadastro_pedido_agenda.btn_pesquisarClick(Sender: TObject);
begin
//  If Application.FindComponent('frmPesquisa') = Nil then
//    Application.CreateForm(TfrmPesquisa, frmPesquisa);
//
//  untPesquisa.Resultado := 0;
//  untPesquisa.nome_tabela       := 'TABpreferencias';
//  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
////  untPesquisa.Campo_Nome        := edtNome.DataField;
//  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
////  untPesquisa.Nome_Campo_Nome   := lblNome.Caption;
//
//  frmPesquisa.ShowModal;
//
//  if untPesquisa.Resultado <> 0 then
//    qryPedido.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);
//
//  dados.Log(2, 'Código: '+ qryPedidoCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_pedido_agenda.qryAcompanhantesAfterScroll(
  DataSet: TDataSet);
begin
  CarregarDadosPerfil(qryAcompanhantesCODIGOPERFIL.AsInteger);
  CalculaProdutosCompativeis();
end;

procedure Tcadastro_pedido_agenda.qryAcompanhantesBeforePost(DataSet: TDataSet);
begin
  if qryAcompanhantesID.AsInteger = 0 then
  begin
    dados.geral.SQL.text := 'Select max(id) as xid from TABACOMPANHANTESPEDIDOAGENDA where CODIGOPEDIDO = '+qryPedidoCODIGO.Text;
    dados.Geral.Open;
    qryAcompanhantesID.AsInteger := dados.Geral.fieldbyname('xid').Asinteger+1;
  end;
end;

procedure Tcadastro_pedido_agenda.qryAcompanhantesCalcFields(DataSet: TDataSet);
begin

  if not qryOutrosEventos.Active then
    qryOutrosEventos.Open;

  if qryOutrosEventos.Locate('ID',qryAcompanhantesIDEVENTO.AsInteger,[]) then
  begin
    qryAcompanhantesNOMEEVENTO.Text := qryOutrosEventosNOMEEVENTO.Text;
    qryAcompanhantesDATAEVENTO.AsDateTime := qryOutrosEventosDATAEVENTO.AsDateTime;
  end
  else
  begin
    qryAcompanhantesNOMEEVENTO.Text := RxDBLookupCombo1.Text;
    qryAcompanhantesDATAEVENTO.AsDateTime := qryPedidoDATAEVENTO.AsDateTime;
  end;
end;

procedure Tcadastro_pedido_agenda.qryAcompanhantesCODIGOPERFILValidate(
  Sender: TField);
begin
  CarregarDadosPerfil(qryAcompanhantesCODIGOPERFIL.AsInteger);
end;

procedure Tcadastro_pedido_agenda.qryAcompanhantesNewRecord(DataSet: TDataSet);
begin

  qryAcompanhantesCODIGOPEDIDO.Text := qryPedidoCODIGO.Text;
  qryAcompanhantesID.ASInteger := 0;

  dados.geral.SQL.text := 'Select max(id) as xid from TABACOMPANHANTESPEDIDOAGENDA where CODIGOPEDIDO = '+qryPedidoCODIGO.Text;
  dados.Geral.Open;

  if dados.Geral.fieldbyname('xid').Asinteger = 0 then
    qryAcompanhantesTIPOAGENDAMENTO.AsInteger := 1
  else
    qryAcompanhantesTIPOAGENDAMENTO.AsInteger := 2;

end;

procedure Tcadastro_pedido_agenda.qryOutrosEventosBeforePost(DataSet: TDataSet);
begin
  if qryOutrosEventosID.AsInteger = 0 then
  begin
    dados.geral.SQL.text := 'Select max(id) as xid from TABPEDIDOAGENDAMENTOEVENTOS where CODIGO =0'+qryPedidoCODIGO.Text;
    dados.Geral.Open;
    qryOutrosEventosID.AsInteger := dados.Geral.fieldbyname('xid').Asinteger+1;
  end;
end;

procedure Tcadastro_pedido_agenda.qryOutrosEventosCalcFields(DataSet: TDataSet);
begin
  qryOutrosEventosNOMEDIASEMANA.Text := NomeDiaSemana(qryOutrosEventosDATAEVENTO.Text);
end;

procedure Tcadastro_pedido_agenda.qryOutrosEventosNewRecord(DataSet: TDataSet);
begin
  qryOutrosEventosCODIGO.AsInteger := qryPedidoCODIGO.AsInteger;
  qryOutrosEventosID.ASInteger := 0;
end;

procedure Tcadastro_pedido_agenda.qryPedidoAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure Tcadastro_pedido_agenda.qryPedidoAfterScroll(DataSet: TDataSet);
begin

  tbmTipoAgendamento.cLOSE;
  tbmTipoAgendamento.oPEN;

  qryTipoHorario.Close;
  qryTipoHorario.Open;

  qryUsuario.Close;
  qryUsuario.Open;

  qryPerfil.Close;
  qryPerfil.Open;

  qryEvento.Close;
  qryEvento.Open;

  qryTipoConvidado.Close;
  qryTipoConvidado.Open;

  qryAcompanhantes.Close;
  qryAcompanhantes.Open;

  qryOutrosEventos.Close;
  qryOutrosEventos.Open;
end;

procedure Tcadastro_pedido_agenda.qryPedidoBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryPedidoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_pedido_agenda.qryPedidoBeforeOpen(DataSet: TDataSet);
begin
  if pubCodigo > 0 then
    qryPedido.Params[0].AsInteger := pubCodigo
  else
    qryPedido.Params[0].AsInteger := -1;
end;

procedure Tcadastro_pedido_agenda.qryPedidoBeforePost(DataSet: TDataSet);
begin
  IF qryPedidoCODIGO.Value = 0 THEN
    qryPedidoCODIGO.Value := Dados.NovoCodigo('TABPEDIDOAGENDAMENTO');
  if dtsPedido.State = dsInsert then
    dados.Log(3, 'Código: '+ qryPedidoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsPedido.State = dsEdit then
    dados.Log(4, 'Código: '+ qryPedidoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)));

  qryPedidoCODIGOUSUARIO.AsInteger := untDados.CodigoUsuarioCorrente;
  qryPedidoVERSAO.AsInteger := qryPedidoVERSAO.AsInteger + 1;
end;

procedure Tcadastro_pedido_agenda.qryPedidoCalcFields(DataSet: TDataSet);
begin
  qryPedidoNOMEDIASEMANA.Text := NomeDiaSemana(qryPedidoDATAEVENTO.Text);
end;

procedure Tcadastro_pedido_agenda.qryPedidoNewRecord(DataSet: TDataSet);
begin
  qryPedidoCODIGO.Value := 0;
  qryPedidoDATACADASTRO.AsDateTime := Date;
  qryPedidoHORACADASTRO.AsDateTime := Time;
  CarregarDadosPerfil(-1);
end;

procedure Tcadastro_pedido_agenda.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if dtsPedido.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryPedido.Post;
  end;

  if qryAcompanhantes.State in [dsEdit,dsInsert] then
    qryAcompanhantes.Post;

  qryPedido.Close;

  pubCodigo := 0;
  pubNovoPedido := False;

  cHorarioInicio := 0;
  cHorarioFim := 0;
  Label33.Visible         := False;
  edtInicioAgenda.Visible := False;
  Label34.Visible         := False;
  edtFimAgenda.Visible    := False;

end;

procedure Tcadastro_pedido_agenda.FormCreate(Sender: TObject);
begin
  NomeMenu := 'PedidoAgenda';

  cHorarioInicio := 0;
  cHorarioFim := 0;
  Label33.Visible         := False;
  edtInicioAgenda.Visible := False;
  Label34.Visible         := False;
  edtFimAgenda.Visible    := False;
  
  CarregaConfiguracoes();
end;

procedure Tcadastro_pedido_agenda.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try

    qryPedido.Close;
    qryPedido.Open;

    qryOutrosEventos.Close;
    qryOutrosEventos.Open;

    if cHorarioInicio > 0 then
    begin
      Label33.Visible         := True;
      edtInicioAgenda.Visible := True;
      Label34.Visible         := True;
      edtFimAgenda.Visible    := True;

//      edtInicioAgenda.Text := FormatDateTime('DD/MM/YYYY HH:MM:SS',cHorarioInicio);
//      edtFimAgenda.Text    := FormatDateTime('DD/MM/YYYY HH:MM:SS',cHorarioFim);

      edtInicioAgenda.DateTime := cHorarioInicio;
      edtFimAgenda.DateTime    := cHorarioFim;
    end;

    try
      if pubNovoPedido then
        qryPedido.Insert;
    except
    end;
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_pedido_agenda.Pea1Click(Sender: TObject);
begin

  if qryAcompanhantesCODIGOPERFIL.AsInteger = 0 then
  begin
    application.MessageBox('Perfil Não Informado!!','Erro!',MB_OK+MB_ICONERROR);
    Abort;
  end;

  If Application.FindComponent('inserir_preferencias') = Nil then
    Application.CreateForm(Tinserir_preferencias, inserir_preferencias);
    
  inserir_preferencias._Finalidade := tfpPedidoAgenda;

  if (Sender = Pea1) then
    inserir_preferencias._Tipo := 1
  else if (Sender = Acessrios1) then
    inserir_preferencias._Tipo := 2
  else if (Sender = Marca1) then
    inserir_preferencias._Tipo := 3
  else if (Sender = Estilo1) then
    inserir_preferencias._Tipo := 4
  else if (Sender = Cor1) then
    inserir_preferencias._Tipo := 5
  else if (Sender = Exigencia1)then
    inserir_preferencias._Tipo := 6;

  inserir_preferencias._codigo := qryAcompanhantesCODIGOPERFIL.AsInteger;
  inserir_preferencias._codigoPedido := qryPedidoCODIGO.AsInteger;
  inserir_preferencias._id := qryAcompanhantesID.AsInteger;


  inserir_preferencias.ShowModal;

  CarregarDadosPerfil(qryAcompanhantesCODIGOPERFIL.AsInteger);

  CalculaProdutosCompativeis();
end;

procedure Tcadastro_pedido_agenda.pnlProdutosCompativeisDblClick(
  Sender: TObject);
var
  lFrmConsultaProduto: TfrmConsultaProdutos;
begin
  lFrmConsultaProduto := TfrmConsultaProdutos.Create(Self);
  Try
    lFrmConsultaProduto._porPedido := True;
    lFrmConsultaProduto._CodigoPedido := qryPedidoCODIGO.AsInteger;
    lFrmConsultaProduto._IdPed  := qryAcompanhantesID.AsInteger;

    lFrmConsultaProduto.ShowModal;

  Finally
    FreeAndNil(lFrmConsultaProduto);
  End;
  
end;

procedure Tcadastro_pedido_agenda.SpeedButton6Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_tipo_convidado') = Nil then
         Application.CreateForm(tcadastro_tipo_convidado, cadastro_tipo_convidado);

  cadastro_tipo_convidado.ShowModal; //

  qryTipoConvidado.Close;
  qryTipoConvidado.open;
end;

procedure Tcadastro_pedido_agenda.SpeedButton7Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_prospect') = Nil then
         Application.CreateForm(Tcadastro_prospect, cadastro_prospect);

  cadastro_prospect.ShowModal;

  qryPerfil.Close;
  qryPerfil.Open;

  cxGrid1DBTableView1CODIGOPERFIL.EditValue := cadastro_prospect.vCodigoInserido;
end;

procedure Tcadastro_pedido_agenda.SpeedButton3Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_evento') = Nil then
         Application.CreateForm(Tcadastro_evento, cadastro_evento);

  cadastro_evento.ShowModal;
  
  qryEvento.Close;
  qryEvento.open;
end;

procedure Tcadastro_pedido_agenda.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
