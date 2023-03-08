unit untAgenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPC, cxControls, cxSchedulerStorage,
  cxSchedulerDBStorage, DBCtrls, StdCtrls, cxButtons, ExtCtrls,
  wwdbdatetimepicker, RxLookup, dxGDIPlusClasses, dxSkinscxScheduler3Painter,
  cxStyles, cxGraphics, cxEdit, cxScheduler, cxSchedulerCustomControls,
  cxSchedulerCustomResourceView, cxSchedulerDayView, cxSchedulerDateNavigator,
  cxSchedulerHolidays, cxSchedulerTimeGridView, cxSchedulerUtils,
  cxSchedulerWeekView, cxSchedulerYearView, cxSchedulerGanttView, cxCustomData,
  cxFilter, cxData, cxDataStorage, DB, cxDBData, cxCheckBox, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxGridCustomView, cxGrid, Wwdatsrc, IBCustomDataSet, IBQuery, IBUpdateSQL,
  wwDialog, wwrcdvw, cxDBLookupComboBox, cxShellComboBox, dxPSGlbl, dxPSUtl,
  dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider,
  dxPSFillPatterns, dxPSEdgePatterns, dxPSCore, dxPScxCommon, dxPScxGrid6Lnk,
   ShellAPI,cxGridExportLink, Mask, wwdbedit, Wwdotdot, Wwdbcomb, cxContainer,
  cxTextEdit, cxMemo;

type
  TfrmAgenda = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Label27: TLabel;
    Label38: TLabel;
    Label1: TLabel;
    cbPerfil: TRxDBLookupCombo;
    edtDtInicial: TwwDBDateTimePicker;
    edtDtFinal: TwwDBDateTimePicker;
    cxButton1: TcxButton;
    btnLimpar: TcxButton;
    Panel2: TPanel;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    cxButton5: TcxButton;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    DBText1: TDBText;
    cxButton6: TcxButton;
    cxButton7: TcxButton;
    cxButton4: TcxButton;
    cxSchedulerDBStorage1: TcxSchedulerDBStorage;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    cxScheduler1: TcxScheduler;
    grdPainel: TcxGrid;
    grdPainelDBTableView1: TcxGridDBTableView;
    grdPainelLevel1: TcxGridLevel;
    qryAgenda: TIBQuery;
    dtsAgenda: TwwDataSource;
    Label2: TLabel;
    cbProduto: TRxDBLookupCombo;
    cxButton8: TcxButton;
    cxButton9: TcxButton;
    Panel7: TPanel;
    PopupMenu1: TPopupMenu;
    Configuraes1: TMenuItem;
    dtsPerfil: TDataSource;
    qryPerfil: TIBQuery;
    qryPerfilCODIGO: TIntegerField;
    qryPerfilNOME: TIBStringField;
    qryProduto: TIBQuery;
    dtsProduto: TDataSource;
    qryProdutoCODIGO: TIntegerField;
    qryProdutoDESCRICAO: TIBStringField;
    ComboBox1: TComboBox;
    Label3: TLabel;
    dxCompPrinterGrid: TdxComponentPrinter;
    dxCompPrinterCntLinkCnt: TdxGridReportLink;
    SaveDialog2: TSaveDialog;
    cxButton11: TcxButton;
    cxButton12: TcxButton;
    cxButton13: TcxButton;
    cmbTipoAgenda: TwwDBComboBox;
    Label4: TLabel;
    btnAbrirPedido: TcxButton;
    cxButton10: TcxButton;
    grdPainelDBTableView1INICIO: TcxGridDBColumn;
    grdPainelDBTableView1FINAL: TcxGridDBColumn;
    grdPainelDBTableView1NOMESITUACAO: TcxGridDBColumn;
    grdPainelDBTableView1DATAEVENTO: TcxGridDBColumn;
    grdPainelDBTableView1CAPTION: TcxGridDBColumn;
    grdPainelDBTableView1CODIGO: TcxGridDBColumn;
    grdPainelDBTableView1IDPEDIDOAGENDA: TcxGridDBColumn;
    cxButton14: TcxButton;
    cxMemo1: TcxMemo;
    qryAgendaCODIGO: TIntegerField;
    qryAgendaIDPEDIDOAGENDA: TIntegerField;
    qryAgendaINICIO: TDateTimeField;
    qryAgendaFINAL: TDateTimeField;
    qryAgendaTIPO: TIntegerField;
    qryAgendaNOMEACAO: TMemoField;
    qryAgendaOPCOES: TIntegerField;
    qryAgendaCOR: TIntegerField;
    qryAgendaNOMESITUACAO: TIBStringField;
    qryAgendaDATA: TDateField;
    qryAgendaCODIGOCONTRATO: TIntegerField;
    qryAgendaCAPTION2: TIBStringField;
    qryAgendaCAPTION3: TMemoField;
    qryAgendaCAPTION: TMemoField;
    chbNaoCanceladas: TCheckBox;
    procedure qryAgendaBeforeOpen(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure cxScheduler1EventSelectionChanged(Sender: TcxCustomScheduler;
      AEvent: TcxSchedulerControlEvent);
    procedure cxButton8Click(Sender: TObject);
    procedure cxButton9Click(Sender: TObject);
    procedure cxButton10Click(Sender: TObject);
    procedure cxButton4Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure cxButton7Click(Sender: TObject);
    procedure cxButton6Click(Sender: TObject);
    procedure cxButton11Click(Sender: TObject);
    procedure cxButton12Click(Sender: TObject);
    procedure cxButton13Click(Sender: TObject);
    procedure btnAbrirPedidoClick(Sender: TObject);
    procedure qryAgendaAfterScroll(DataSet: TDataSet);
    procedure cxScheduler1DblClick(Sender: TObject);
    procedure cxButton14Click(Sender: TObject);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    vTempoMinimoAgenda: TTime;
    vHoraInicioExpediente: TTime;
    vHoraFimExpediente: TTime;
    vCorCancelada: Integer;
    vCorConfirmada: Integer;
    vCorFinalizada: Integer;
    vCorAgendaPedido: Integer;
    vCorAgendaTrabalho: Integer;
    procedure CarregaConfiguracoes();
    function Filtro(): String;
    { Private declarations }
  public
    { Public declarations }
    cConfirmarHorario : Boolean;
    cDataHoraInicio, cDataHoraFim : TDateTime;

  end;

var
  frmAgenda: TfrmAgenda;

implementation

uses untDados, untCadastroAgenda, untArarasAgenda, untAtendimento,
  form_cadastro_pedido_agenda, untARARA, untContrato, versao, funcao;

const
   cCaption = 'AGENDA';

{$R *.dfm}

//BOTÃO HELP
procedure TfrmAgenda.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmAgenda.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmAgenda.btnLimparClick(Sender: TObject);
begin
  cbPerfil.KeyValue := -1;
  cbProduto.KeyValue := -1;
  edtDtInicial.Text := '';
  edtDtFinal.Text := '';
end;

procedure TfrmAgenda.CarregaConfiguracoes();
begin
  vHoraInicioExpediente   := Dados.Config(frmAgenda,'HORAINICIOEXPEDIENTE','Hora de Início do Expediente de Atendimento Diário',
                                    'Informe a Hora que o expediente de trabalho é iniciado diáriamente para demontração resumida do calendário.',
                                    StrToTime('08:00:00'),tcHora).vcTime;

  vHoraFimExpediente      := Dados.Config(frmAgenda,'HORAFIMEXPEDIENTE','Hora de Termino do Expediente de Atendimento Diário',
                                    'Informe a Hora que o expediente de trabalho é temina diáriamente para demontração resumida do calendário.',
                                    StrToTime('18:00:00'),tcHora).vcTime;

  vTempoMinimoAgenda      := Dados.Config(frmAgenda,'TEMPOMINIMO','Tempo Mímimo Gasto para cada Agenda',
                                    'Informe o tempo mínimo que cada agenda deve conter.',StrToTime('00:30:00'),
                                    tcHora).vcTime;

  vCorCancelada           := Dados.Config(frmAgenda,'CORAGENDACANCELADA','Cor para Agenda Cancelada',
                                    'Defina a Cor de Demonstração da Agenda Cancelada.',ColorToRGB(clRed),
                                    tcCor).vcCor;

  vCorConfirmada          := Dados.Config(frmAgenda,'CORAGENDACONFIRMADA','Cor para Agenda Confirmada',
                                    'Defina a Cor de Demonstração da Agenda Confirmada.',ColorToRGB(clYellow),
                                    tcCor).vcCor;

  vCorFinalizada          := Dados.Config(frmAgenda,'CORAGENDAFINALIZADA','Cor para Agenda Finalizada',
                                    'Defina a Cor de Demonstração da Agenda Finalizada.',ColorToRGB(clGreen),
                                    tcCor).vcCor;

  vCorAgendaPedido        := Dados.Config(frmAgenda,'CORAGENDAPEDIDO','Cor para Agenda Em Aberto de Pedido de Agendamento',
                                    'Defina a Cor de Demonstração da Agenda Em Aberto proveniente de Pedido de Agendamento.',ColorToRGB(clAqua),
                                    tcCor).vcCor;

  vCorAgendaTrabalho      := Dados.Config(frmAgenda,'CORAGENDATRABALHO','Cor para Agenda Em Aberto de Trabalho',
                                    'Defina a Cor de Demonstração da Agenda Em Aberto de Trabalho não proveniente de Pedido de Agendamento.',ColorToRGB(clSilver),
                                    tcCor).vcCor;

  cxScheduler1.OptionsView.WorkStart := vHoraInicioExpediente;
  cxScheduler1.OptionsView.WorkFinish := vHoraFimExpediente;
end;

procedure TfrmAgenda.ComboBox1Change(Sender: TObject);
begin
  Case ComboBox1.ItemIndex of
    0: cxScheduler1.viewDay.Active := true;
    1: cxScheduler1.ViewWeeks.Active := true;
    2: cxScheduler1.ViewWeek.Active := true;
    3: cxScheduler1.ViewYear.Active := true;
    4: cxScheduler1.ViewGantt.Active := true;
    5: cxScheduler1.ViewTimeGrid.Active := true;
  End;
end;

procedure TfrmAgenda.Configuraes1Click(Sender: TObject);
begin
  dados.ShowConfig(frmAgenda);
  CarregaConfiguracoes();
end;

procedure TfrmAgenda.cxButton10Click(Sender: TObject);
begin
  If Application.FindComponent('frmCadastroAgenda') = Nil then
         Application.CreateForm(TfrmCadastroAgenda, frmCadastroAgenda);

  frmCadastroAgenda.ReAgendar := False;

  cDataHoraInicio := cxScheduler1.SelStart;
  cDataHoraFim := cxScheduler1.SelFinish;

  frmCadastroAgenda.edtData.Date := cDataHoraInicio;
  frmCadastroAgenda.edtHora.Time := cDataHoraInicio;
  frmCadastroAgenda.edtHoraFim.Time := cDataHoraFim;  

  frmCadastroAgenda.ShowModal;

  qryAgenda.close;
  qryAgenda.Open;
end;

procedure TfrmAgenda.cxButton11Click(Sender: TObject);
begin

  if Application.FindComponent('frmAtendimento') = nil then
         Application.CreateForm(TfrmAtendimento, frmAtendimento);

  frmAtendimento.CodigoAgenda := qryAgendaCODIGO.AsInteger;
  frmAtendimento.cTipoAgenda := qryAgendaTIPO.AsInteger;
  frmAtendimento.ShowModal;

end;

procedure TfrmAgenda.cxButton12Click(Sender: TObject);
begin
  cDataHoraInicio := cxScheduler1.SelStart;
  cDataHoraFim := cxScheduler1.SelFinish;

  frmAgenda.Close;
end;

procedure TfrmAgenda.cxButton13Click(Sender: TObject);
begin

  try

    if Assigned(cadastro_pedido_agenda) then
      FreeAndNil(cadastro_pedido_agenda);

    If Application.FindComponent('cadastro_pedido_agenda') = Nil then
           Application.CreateForm(Tcadastro_pedido_agenda, cadastro_pedido_agenda);

    cadastro_pedido_agenda.pubNovoPedido := True;

    if StrToTime(TimeToStr(cxScheduler1.SelStart)) > 0 then
      cadastro_pedido_agenda.cHorarioInicio := cxScheduler1.SelStart;

    if StrToTime(TimeToStr(cxScheduler1.SelFinish)) > 0 then
      cadastro_pedido_agenda.cHorarioFim := cxScheduler1.SelFinish;


    cadastro_pedido_agenda.cxPageControl1.ActivePage := cadastro_pedido_agenda.cxTabSheet4;

    cadastro_pedido_agenda.Show;
  finally

  end;
end;

procedure TfrmAgenda.cxButton14Click(Sender: TObject);
begin

  if qryAgendaCODIGOCONTRATO.AsInteger > 0 then
  begin
    If Application.FindComponent('frmContrato') = Nil then
           Application.CreateForm(TfrmContrato, frmContrato);


    With frmContrato do
    begin
      Show;

      qryContrato.Close;
      qryContrato.ParamByName('CODIGO').AsInteger := qryAgendaCODIGOCONTRATO.AsInteger;
      qryContrato.Open;
    end;

  end;
end;

procedure TfrmAgenda.btnAbrirPedidoClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_pedido_agenda') = Nil then
         Application.CreateForm(Tcadastro_pedido_agenda, cadastro_pedido_agenda);

  cadastro_pedido_agenda.pubCodigo := qryAgendaIDPEDIDOAGENDA.AsInteger;

  cadastro_pedido_agenda.Show;
end;

procedure TfrmAgenda.cxButton1Click(Sender: TObject);
begin
  qryAgenda.close;
  qryAgenda.Open;
end;

procedure TfrmAgenda.cxButton2Click(Sender: TObject);
begin
  dxCompPrinterGrid.CurrentLink.Component := grdPainel;

  dxCompPrinterGrid.Preview(True,dxCompPrinterCntLinkCnt);
end;

procedure TfrmAgenda.cxButton3Click(Sender: TObject);
var
  sPath : string;
begin
  sPath := '';
  if SaveDialog2.Execute then
    sPath := SaveDialog2.FileName;

  if sPath <> '' then
  begin
    if pos('.xls', sPath) > 0 then
      ExportGridToExcel(sPath, grdPainel, True, True, True)
    else if pos('.xml', sPath) > 0 then
      ExportGridToXML(sPath, grdPainel, True, True)
    else if pos('.html', sPath) > 0 then
      ExportGridToHTML(sPath, grdPainel, True, True)
    else if pos('.txt', sPath) > 0 then
      ExportGridToText(sPath, grdPainel, True, True);

    ShellExecute(0, 'open', PChar(sPath), nil, nil, SW_SHOW);
  end;

end;

procedure TfrmAgenda.cxButton4Click(Sender: TObject);
begin
  If Application.FindComponent('frmCadastroAgenda') = Nil then
         Application.CreateForm(TfrmCadastroAgenda, frmCadastroAgenda);

  frmCadastroAgenda.ReAgendar := True;
  frmCadastroAgenda.CodigoAgenda := qryAgendaCODIGO.AsInteger;
  frmCadastroAgenda.PedidoAgenda := qryAgendaIDPEDIDOAGENDA.AsInteger;
  frmCadastroAgenda.ShowModal;

  qryAgenda.close;
  qryAgenda.Open;
end;

procedure TfrmAgenda.cxButton5Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmAgenda.cxButton6Click(Sender: TObject);
var
  iNovoCodigo: integer;
begin
  Dados.Geral3.Sql.Text := 'Select a.codigo, ac.id, a.idperfil  '+
      '   from tabagenda a '+
      '   left join tabacompanhantespedidoagenda ac on a.idpedidoagenda = ac.codigopedido and a.idperfil = ac.codigoperfil'+
      '  where a.codigo = '+IntToStr(qryAgendaCODIGO.AsInteger)+
      '  order by a.codigo';
  Dados.Geral3.Open;

  dados.Geral.SQL.Text := 'Select a.codigo from tabarara a '+
     ' where a.codigoagenda = '+IntToStr(qryAgendaCODIGO.AsInteger)+
     ' and a.codigoperfil = '+IntToStr(Dados.Geral3.FieldByName('idperfil').AsInteger);
  Dados.Geral.Open;

  if Dados.Geral.IsEmpty then
  begin
    Dados.Geral.SQL.Text := 'select max(codigo) as XCod from tabarara';
    Dados.Geral.Open;
    iNovoCodigo := Dados.Geral.FieldByName('XCod').AsInteger + 1;

    Dados.Geral.SQL.Text := 'insert into tabarara (CODIGO,DATAREGISTRO,CODIGOAGENDA,CODIGOPERFIL) values ('+
        intTostr(iNovoCodigo)+', '+
        'current_date, '+
        IntToStr(qryAgendaCODIGO.AsInteger)+', '+
        IntToStr(Dados.Geral3.FieldByName('idperfil').AsInteger)+')';
    Dados.Geral.ExecSql;
    Dados.Geral.Transaction.CommitRetaining;
  end;

  if Dados.Geral3.FieldByName('id').AsInteger = 1 then
  begin
    Dados.Geral3.Sql.Text := 'Select a.codigo, ac.id, ac.codigoperfil '+
        '   from tabagenda a '+
        '   left join tabacompanhantespedidoagenda ac on a.idpedidoagenda = ac.codigopedido and a.idperfil <> ac.codigoperfil'+
        '  where a.codigo = '+IntToStr(qryAgendaCODIGO.AsInteger)+
        '    and ac.tipoagendamento <> 1 '+
        '  order by a.codigo';
    Dados.Geral3.Open;

    while not Dados.Geral3.Eof do
    begin
      dados.Geral.SQL.Text := 'Select a.codigo from tabarara a '+
         ' where a.codigoagenda = '+IntToStr(qryAgendaCODIGO.AsInteger)+
         ' and a.codigoperfil = '+IntToStr(Dados.Geral3.FieldByName('codigoperfil').AsInteger);
      Dados.Geral.Open;

      if Dados.Geral.IsEmpty then
      begin
        Dados.Geral.SQL.Text := 'select max(codigo) as XCod from tabarara';
        Dados.Geral.Open;
        iNovoCodigo := Dados.Geral.FieldByName('XCod').AsInteger + 1;

        Dados.Geral.SQL.Text := 'insert into tabarara (CODIGO,DATAREGISTRO,CODIGOAGENDA,CODIGOPERFIL) values ('+
            intTostr(iNovoCodigo)+', '+
            'current_date, '+
            IntToStr(qryAgendaCODIGO.AsInteger)+', '+
            IntToStr(Dados.Geral3.FieldByName('codigoperfil').AsInteger)+')';
        Dados.Geral.ExecSql;
        Dados.Geral.Transaction.CommitRetaining;
      end;

      Dados.Geral3.Next;
    end;
  end;

  dados.Geral.Close;
  dados.Geral.SQL.Text := 'Select a.codigo '+
                          '  from TABARARA a '+
                          ' where a.codigoagenda =0'+qryAgendaCODIGO.Text;
  dados.Geral.Open;

  dados.Geral.Last;
  dados.Geral.First;

  if dados.Geral.RecordCount = 1 then
  begin
    If Application.FindComponent('frmARARA') = Nil then
      FreeAndNil(frmARARA);
    Application.CreateForm(TfrmARARA, frmARARA);

    frmARARA.vCodigo := dados.Geral.FieldByName('codigo').AsInteger;

    frmARARA.ShowModal;
  end
  else
  begin
    If Application.FindComponent('frmArarasAgenda') = Nil then
           Application.CreateForm(TfrmArarasAgenda, frmArarasAgenda);

    frmArarasAgenda.vCodigo := qryAgendaCODIGO.AsInteger;

    frmArarasAgenda.ShowModal;
  end;

end;

procedure TfrmAgenda.cxButton7Click(Sender: TObject);
begin
  if Application.MessageBox('Deseja Realmente Finalizar a Agenda?','Finalizar Agenda',MB_YESNO+MB_ICONQUESTION) = IDYES THEN
  begin
    dados.FinalizarAgenda(qryAgendaCODIGO.AsInteger);
    qryAgenda.close;
    qryAgenda.Open;
  end;
end;

procedure TfrmAgenda.cxButton8Click(Sender: TObject);
begin
  if Application.MessageBox('Deseja Realmente Confirmar a Agenda?','Confirmação de Agenda',MB_YESNO+MB_ICONQUESTION) = IDYES THEN
  begin
    dados.ConfirmarAgenda(qryAgendaCODIGO.AsInteger);
    qryAgenda.close;
    qryAgenda.Open;
  end;
end;

procedure TfrmAgenda.cxButton9Click(Sender: TObject);
var
  vMotivo: String;
begin
  if Application.MessageBox('Deseja Realmente Cancelar a Agenda?','Cancelamento de Agenda',MB_YESNO+MB_ICONQUESTION) = IDYES THEN
  begin
    vMotivo := Dados.DigitarValor('Informe o Motivo do Cancelamento da Agenda.');
    if vMotivo = '' then
    begin
      application.messagebox('Motivo é Obrigatório para Cancelamento de Agenda','Motivo não Informado',MB_OK+MB_ICONEXCLAMATION);
      Abort;
    end;
    dados.CancelarAgenda(qryAgendaCODIGO.AsInteger,vMotivo);
    qryAgenda.close;
    qryAgenda.Open;
  end;
end;

procedure TfrmAgenda.cxScheduler1DblClick(Sender: TObject);
var
  cCodigoContrato : Integer;
begin

  if cxScheduler1.SelectedEventCount > 0 then
  begin

    if qryAgendaIDPEDIDOAGENDA.AsInteger > 0 then
      btnAbrirPedido.Click
    else
    begin

      Dados.Geral.Close;
      Dados.Geral.SQL.Text := 'SELECT CODIGO FROM TABMOVIMENTACAOCONTRATO WHERE CODIGOREGISTRO =0'+qryAgendaCODIGO.Text;
      Dados.Geral.Open;

      if not Dados.Geral.IsEmpty then
      begin

        cCodigoContrato := Dados.Geral.FieldByName('CODIGO').AsInteger;

        if Application.FindComponent('frmContrato') = Nil then
          Application.CreateForm(TfrmContrato, frmContrato);

        frmContrato.Show;

        frmContrato.qryContrato.Close;
        frmContrato.qryContrato.ParamByName('CODIGO').AsInteger := cCodigoContrato;
        frmContrato.qryContrato.Open;

      end;

    end;
  
  end
  else
  begin
    cxScheduler1.viewDay.Active := true;
    cxScheduler1.DateNavigator.Date :=  cxScheduler1.SelStart;
    ComboBox1.ItemIndex := 0;
  end;
end;

procedure TfrmAgenda.cxScheduler1EventSelectionChanged(
  Sender: TcxCustomScheduler; AEvent: TcxSchedulerControlEvent);
begin
  try
    qryAgenda.Locate('CODIGO', AEvent.ID, []);
  except
  end;
end;

procedure TfrmAgenda.FormCreate(Sender: TObject);
begin
  CarregaConfiguracoes();

  cConfirmarHorario := False;

  CarregarImagem(Image1,'topo_painel.png');
  Caption := CaptionTela(cCaption);
end;

procedure TfrmAgenda.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryPerfil.Close;
    qryPerfil.Open;

    qryProduto.Close;
    qryProduto.Open;

    btnLimparClick(self);

    if edtDtInicial.Date = 0 then
    begin
      edtDtInicial.Date := Date;
      edtDtFinal.Date := Date+7;
      cxButton1Click(SELF);
    end;

    Panel4.Enabled := not cConfirmarHorario;
    cxButton12.Visible := cConfirmarHorario;

    ComboBox1.OnChange := ComboBox1Change;

  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmAgenda.qryAgendaAfterScroll(DataSet: TDataSet);
begin
  btnAbrirPedido.Enabled := qryAgendaIDPEDIDOAGENDA.AsInteger > 0;

  cxMemo1.Text := qryAgendaCAPTION.AsString;
end;

procedure TfrmAgenda.qryAgendaBeforeOpen(DataSet: TDataSet);
begin
  QryAgenda.ParamByName('CORAGENDACANCELADA').AsInteger := vCorCancelada;
  QryAgenda.ParamByName('CORCONFIRMADA').AsInteger := vCorConfirmada;
  QryAgenda.ParamByName('CORFINALIZADA').AsInteger := vCorFinalizada;
  QryAgenda.ParamByName('CORAGENDAPEDIDO').AsInteger := vCorAgendaPedido;
  QryAgenda.ParamByName('CORAGENDATRABALHO').AsInteger := vCorAgendaTrabalho;

  QryAgenda.SQL.Strings[QryAgenda.SQL.IndexOf('--where')+1] := Filtro();

//  QryAgenda.SQL.SaveToFile('C:\Temp_Ath\SQL\QryAgenda.SQL');
end;

function TfrmAgenda.Filtro(): String;
var
  vFiltro : String;
//  vCampoData : String;
begin
  if cbPerfil.KeyValue > 0 then
    vFiltro := vFiltro + ' and a.idperfil = '+VarToStr(cbPerfil.KeyValue);

  if cbProduto.KeyValue > 0 then
    vFiltro := vFiltro + ' and a.codigoproduto = '+VarToStr(cbProduto.KeyValue);

  if (edtDtInicial.Text <> '') and (edtDtFinal.Text <> '') then
  begin
    vFiltro := vFiltro + ' and (('+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))+' between a.data and a.datafim)'+
                         ' or ('+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date))+' between a.data and a.datafim)'+
                         ' or (a.data between '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))+' and '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date))+'))'
  end
  else if (edtDtInicial.Text <> '')  then
    vFiltro := vFiltro + ' and '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtInicial.Date))+' between a.data and a.datafim'
  else if (edtDtFinal.Text <> '')  then
    vFiltro := vFiltro + ' and '+QuotedStr(FormatDateTime('mm/dd/yyyy', edtDtFinal.Date))+' between a.data and a.datafim';

  if cmbTipoAgenda.ItemIndex = 0 then
    vFiltro := vFiltro + ' and COALESCE(IDPEDIDOAGENDA,0) <> 0'
  else
  if cmbTipoAgenda.ItemIndex = 1 then
    vFiltro := vFiltro + ' and COALESCE(IDPEDIDOAGENDA,0) = 0';

  if chbNaoCanceladas.checked then
    vFiltro := vFiltro + ' and coalesce(A.SITUACAO, 1) <> 2';


  result := vFiltro;
end;

end.
