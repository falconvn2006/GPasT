unit untAgendarPedido;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, cxLookAndFeelPainters, StdCtrls, cxButtons, ExtCtrls,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxScheduler3Painter, cxStyles,
  cxGraphics, cxEdit, cxScheduler, cxSchedulerStorage,
  cxSchedulerCustomControls, cxSchedulerCustomResourceView, cxSchedulerDayView,
  cxSchedulerDateNavigator, cxSchedulerHolidays, cxSchedulerTimeGridView,
  cxSchedulerUtils, cxSchedulerWeekView, cxSchedulerYearView,
  cxSchedulerGanttView, cxControls, DB, DBTables, rxMemTable,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxDBData,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridLevel,
  cxClasses, cxGridCustomView, cxGrid, cxSchedulerDBStorage, Wwdatsrc,
  IBCustomDataSet, IBQuery, cxCheckBox;

type
  TfrmAgendarPedido = class(TForm)
    pnlTitulo: TPanel;
    Panel2: TPanel;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    mmAgendas: TMemoryTable;
    dtsSelecionados: TDataSource;
    mmAgendasID: TIntegerField;
    mmAgendasNOMEPERFIL: TStringField;
    mmAgendasDATAMELHORDIA: TDateField;
    mmAgendasHORAMELHORDIA: TTimeField;
    mmAgendasDATAAGENDA: TDateField;
    mmAgendasHORAAGENDA: TTimeField;
    Panel1: TPanel;
    cxScheduler1: TcxScheduler;
    grdPainel: TcxGrid;
    grdPainelDBTableView1: TcxGridDBTableView;
    grdPainelLevel1: TcxGridLevel;
    mmAgendasTEMPOAGENDA: TTimeField;
    mmAgendasACOMPANHANTES: TIntegerField;
    grdPainelDBTableView1ID: TcxGridDBColumn;
    grdPainelDBTableView1NOMEPERFIL: TcxGridDBColumn;
    grdPainelDBTableView1DATAMELHORDIA: TcxGridDBColumn;
    grdPainelDBTableView1HORAMELHORDIA: TcxGridDBColumn;
    grdPainelDBTableView1DATAAGENDA: TcxGridDBColumn;
    grdPainelDBTableView1HORAAGENDA: TcxGridDBColumn;
    grdPainelDBTableView1TEMPOAGENDA: TcxGridDBColumn;
    grdPainelDBTableView1ACOMPANHANTES: TcxGridDBColumn;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    qryAgenda: TIBQuery;
    qryAgendaINICIO: TDateTimeField;
    qryAgendaFINAL: TDateTimeField;
    qryAgendaTIPO: TIntegerField;
    qryAgendaNOMEACAO: TMemoField;
    qryAgendaOPCOES: TIntegerField;
    qryAgendaCODIGO: TIntegerField;
    qryAgendaDATA: TDateField;
    qryAgendaHORA: TTimeField;
    qryAgendaIDPEDIDOAGENDA: TIntegerField;
    qryAgendaIDPERFIL: TIntegerField;
    qryAgendaCODIGOPRODUTO: TIntegerField;
    qryAgendaDESCRICAO: TMemoField;
    qryAgendaDATAFIM: TDateField;
    qryAgendaHORAFIM: TTimeField;
    qryAgendaCOR: TIntegerField;
    qryAgendaSITUACAO: TIntegerField;
    qryAgendaMOTIVOCANCELAMENTO: TIBStringField;
    qryAgendaCAPTION: TIBStringField;
    qryAgendaNOMESITUACAO: TIBStringField;
    dtsAgenda: TwwDataSource;
    cxSchedulerDBStorage1: TcxSchedulerDBStorage;
    qryPainel: TIBQuery;
    dtsPainel: TDataSource;
    qryPainelID: TIntegerField;
    qryPainelCODIGOPERFIL: TIntegerField;
    qryPainelNOMEPERFIL: TIBStringField;
    qryPainelDATAMELHORDIA: TDateField;
    qryPainelHORAMELHORDIA: TTimeField;
    qryPainelQTDEACOMPANHANTES: TIntegerField;
    Label3: TLabel;
    ComboBox1: TComboBox;
    Splitter1: TSplitter;
    PopupMenu1: TPopupMenu;
    AgendarAqui1: TMenuItem;
    mmAgendasAGENDAR: TBooleanField;
    grdPainelDBTableView1Column1: TcxGridDBColumn;
    procedure FormShow(Sender: TObject);
    procedure qryPainelAfterOpen(DataSet: TDataSet);
    procedure qryAgendaBeforeOpen(DataSet: TDataSet);
    procedure ComboBox1Change(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure cxScheduler1DblClick(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure qryPainelBeforeOpen(DataSet: TDataSet);
    procedure mmAgendasAfterScroll(DataSet: TDataSet);
    procedure AgendarAqui1Click(Sender: TObject);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP;
    procedure FormCreate(Sender: TObject); // e esta tb
    //FIM BOTÃO HELP
  private
    vTempoPerfil: TTime;
//    vTempoMinimoAgenda: TTime;
    vHoraInicioExpediente: TTime;
    vHoraFimExpediente: TTime;
    vCorCancelada: Integer;
    vCorConfirmada: Integer;
    vCorFinalizada: Integer;
    vCorAgendaPedido: Integer;
    vCorAgendaTrabalho: Integer;
    { Private declarations }
  public
    CodigoPedido, vQtdMaximaClientesHorario: Integer;
    DataEvento: TDate;
    FlexibilidadeAgendamento: TTime;
    { Public declarations }
  end;

var
  frmAgendarPedido: TfrmAgendarPedido;

implementation

uses untDados, funcao, versao;

const
   cCaption = 'AGENDAR PEDIDO';

{$R *.dfm}

//BOTÃO HELP
procedure TfrmAgendarPedido.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmAgendarPedido.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmAgendarPedido.AgendarAqui1Click(Sender: TObject);
begin
  mmAgendas.Edit;
  mmAgendasDATAAGENDA.AsDateTime := cxScheduler1.SelStart;
  mmAgendasHORAAGENDA.AsDateTime := cxScheduler1.SelStart;
  mmAgendasAGENDAR.AsBoolean     := True;
  mmAgendas.Post;

  mmAgendas.Next;
end;

procedure TfrmAgendarPedido.ComboBox1Change(Sender: TObject);
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

procedure TfrmAgendarPedido.cxButton2Click(Sender: TObject);
var
//  i : Integer;
  vTextoAgenda: String;
  vHoraFimCalc: TTime;
  cQtdPessoasPedido : Integer;
begin

  Dados.Geral3.Close;
  Dados.Geral3.SQL.Text := 'SELECT COUNT(DISTINCT a.codigoperfil) as qtd FROM tabacompanhantespedidoagenda a WHERE a.codigopedido=0'+IntToStr(CodigoPedido);
  Dados.Geral3.Open;
  cQtdPessoasPedido := Dados.Geral3.FieldByName('qtd').AsInteger;

  mmAgendas.First;
  while not mmAgendas.Eof do
  begin
    vHoraFimCalc := mmAgendasHORAAGENDA.AsDateTime + mmAgendasTEMPOAGENDA.AsDateTime;
    Dados.Geral3.Sql.Text := 'select COUNT(DISTINCT a.codigoperfil) as qtd from tabagenda ag '#13+
    ' inner join tabpedidoagendamento p on ag.idpedidoagenda = p.codigo '#13+
    ' inner join tabacompanhantespedidoagenda a on p.codigo = a.codigopedido '#13+
     'where COALESCE(ag.idpedidoagenda,0) > 0 and Coalesce(AG.situacao,1) <> 2 '#13+
     '  and ((ag.data = :data) and ((:horainicio + 1 between ag.hora and ag.horafim) '#13+
     '   or (:horafim between ag.hora and ag.horafim))) ';
    Dados.Geral3.ParamByName('data').AsDateTime       := mmAgendasDATAAGENDA.AsDateTime;
    Dados.Geral3.ParamByName('horainicio').AsDateTime := mmAgendasHORAAGENDA.AsDateTime + FlexibilidadeAgendamento;
    Dados.Geral3.ParamByName('horafim').AsDateTime    := vHoraFimCalc - FlexibilidadeAgendamento;
    Dados.Geral3.Open;

    if (Dados.Geral3.FieldByName('qtd').AsInteger > vQtdMaximaClientesHorario) or
       ((Dados.Geral3.FieldByName('qtd').AsInteger > 0) and (cQtdPessoasPedido > vQtdMaximaClientesHorario)) then
    begin
      application.MessageBox(Pchar('Já existe agenda para a data '+
                             FormatDateTime('dd/MM/yyyy', mmAgendasDATAAGENDA.AsDateTime)+
                             ' de '+ FormatDateTime('hh:mm:ss', mmAgendasHORAAGENDA.AsDateTime)+
                             ' à '+ FormatDateTime('hh:mm:ss', vHoraFimCalc)+'.'#13+
                             'Não é permitido agendar para esse pedido nessas condições.'),'Erro!',MB_OK+MB_ICONERROR);
      Abort;
    end;
    mmAgendas.Next;
  end;

  Dados.Geral3.Sql.Text := 'select A.ID, e.nome as nomeEvento,pr.nome,tc.nome as nomeTipoConvidado,'#13+
   '          p.dataevento, '#13+
   '          p.HoraEvendo, '#13+
   '          a.codigoperfil, '#13+
   '          a.datamelhordia, '#13+
   '          a.horamelhordia, '#13+
   '          Case when a.id = 1 then  '#13+
   '             (select Count(a.id) from tabacompanhantespedidoagenda a where p.codigo = a.codigopedido and a.tipoagendamento = 2) '#13+
   '          else 0 end as QtdeAcompanhantes, coalesce(a.idevento,0) as idevento '#13+
   '     from tabpedidoagendamento p  '#13+
   '     left join tabacompanhantespedidoagenda a on p.codigo = a.codigopedido '#13+
   '     left join tabevento e on p.codigoevento = e.codigo '#13+
   '     left join tabperfil pr on a.codigoperfil = pr.codigo '#13+
   '     left join tabtipoconvidado tc on a.codigotipoconvidado = tc.codigo '#13+
   '    where a.tipoagendamento = 1 '#13+
   '     and p.codigo = '+IntToStr(CodigoPedido)+#13+
   '    order by a.id ';
  Dados.Geral3.Open;

  if Dados.Geral3.IsEmpty then
  begin
    application.MessageBox('Não Existe Perfil Definido com Tipo de Agendamento "NOVA AGENDA"!','Erro!',MB_OK+MB_ICONERROR);
    Abort;
  end;

  while not Dados.Geral3.Eof do
  begin

    if not mmAgendas.Locate('ID',Dados.Geral3.FieldByName('ID').AsInteger, []) then
    begin
      Dados.Geral3.Next;
      Continue;
    end;

    if not mmAgendasAGENDAR.AsBoolean then
    begin
      Dados.Geral3.Next;
      Continue;
    end;

    vTextoAgenda := 'Agendado para '+Dados.Geral3.FieldByName('nome').Text;
    if Dados.Geral3.FieldByName('QtdeAcompanhantes').AsInteger > 0 then
    begin
      vTextoAgenda := vTextoAgenda +#13'Acompanhado de:';

      Dados.Geral2.Sql.Text := 'select '#13+
        '         pr.nome as nomeperfil, '#13+
        '         tc.nome as nomeTipoConvidado '#13+
        '    from tabpedidoagendamento p '#13+
        '    left join tabacompanhantespedidoagenda a on p.codigo = a.codigopedido '#13+
        '    left join tabperfil pr on a.codigoperfil = pr.codigo '#13+
        '    left join tabtipoconvidado tc on a.codigotipoconvidado = tc.codigo '#13+
        '   where a.tipoagendamento = 2 '#13+
        '     and p.codigo = '+IntToStr(CodigoPedido)+#13+
        '   order by a.id';
      Dados.Geral2.Open;

      while not Dados.Geral2.Eof do
      begin
        vTextoAgenda := vTextoAgenda + #13 + Dados.Geral2.FieldByName('nomeperfil').Text;
        Dados.Geral2.Next;
      end;
    end;
    vTextoAgenda := vTextoAgenda +#13'Pedido de Agenda:'+IntToStr(CodigoPedido);

    dados.Agendar(CodigoPedido,
                  Dados.Geral3.FieldByName('codigoperfil').AsInteger,
                  0,
                  mmAgendasDATAAGENDA.AsDateTime,
                  mmAgendasDATAAGENDA.AsDateTime,
                  mmAgendasHORAAGENDA.AsDateTime,
                  mmAgendasHORAAGENDA.AsDateTime + mmAgendasTEMPOAGENDA.AsDateTime,
                  vTextoAgenda,
                  Dados.Geral3.FieldByName('idevento').AsInteger);

    Dados.Geral3.Next;
  end;

  application.MessageBox('Agendado com Sucesso!','Terminado!',MB_OK+MB_ICONEXCLAMATION);

  Close;

end;

procedure TfrmAgendarPedido.cxButton3Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmAgendarPedido.cxScheduler1DblClick(Sender: TObject);
begin
  AgendarAqui1Click(Self)
end;

procedure TfrmAgendarPedido.FormCreate(Sender: TObject);
begin
  Caption := CaptionTela(cCaption);
end;

procedure TfrmAgendarPedido.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;

  vTempoPerfil := Dados.ValorConfig('cadastro_pedido_agenda','TEMPOPORPERFIL',StrToTime('00:30:00'),tcHora).vcTime;

  vHoraInicioExpediente   := Dados.ValorConfig('frmAgenda','HORAINICIOEXPEDIENTE',StrToTime('08:00:00'),tcHora).vcTime;

  vHoraFimExpediente      := Dados.ValorConfig('frmAgenda','HORAFIMEXPEDIENTE',StrToTime('18:00:00'),tcHora).vcTime;

  vCorCancelada           := Dados.ValorConfig('frmAgenda','CORAGENDACANCELADA',ColorToRGB(clRed),tcCor).vcCor;

  vCorConfirmada          := Dados.ValorConfig('frmAgenda','CORAGENDACONFIRMADA',ColorToRGB(clYellow),tcCor).vcCor;

  vCorFinalizada          := Dados.ValorConfig('frmAgenda','CORAGENDAFINALIZADA',ColorToRGB(clGreen),tcCor).vcCor;

  vCorAgendaPedido        := Dados.ValorConfig('frmAgenda','CORAGENDAPEDIDO',ColorToRGB(clAqua),tcCor).vcCor;

  vCorAgendaTrabalho      := Dados.ValorConfig('frmAgenda','CORAGENDATRABALHO',ColorToRGB(clSilver),tcCor).vcCor;

  cxScheduler1.OptionsView.WorkStart := vHoraInicioExpediente;
  cxScheduler1.OptionsView.WorkFinish := vHoraFimExpediente;

  mmAgendas.Close;
  mmAgendas.EmptyTable;
  mmAgendas.Open;   

  qryPainel.Close;
  qryPainel.Open;

  qryAgenda.Close;
  qryAgenda.Open;

  pnlTitulo.Caption := 'AGENDAR PEDIDO ('+IntToStr(CodigoPedido)+')';

end;

procedure TfrmAgendarPedido.mmAgendasAfterScroll(DataSet: TDataSet);
begin
//  if mmAgendasDATAAGENDA.Value > 0 then
//    cxScheduler1.GoToDate(mmAgendasDATAAGENDA.AsDateTime);
end;

procedure TfrmAgendarPedido.qryAgendaBeforeOpen(DataSet: TDataSet);
begin
  QryAgenda.ParamByName('CORAGENDACANCELADA').AsInteger := vCorCancelada;
  QryAgenda.ParamByName('CORCONFIRMADA').AsInteger := vCorConfirmada;
  QryAgenda.ParamByName('CORFINALIZADA').AsInteger := vCorFinalizada;
  QryAgenda.ParamByName('CORAGENDAPEDIDO').AsInteger := vCorAgendaPedido;
  QryAgenda.ParamByName('CORAGENDATRABALHO').AsInteger := vCorAgendaTrabalho;
  QryAgenda.ParamByName('DATAEVENTO').AsDate := DataEvento;
end;

procedure TfrmAgendarPedido.qryPainelAfterOpen(DataSet: TDataSet);
var
  i: integer;
begin

  if not mmAgendas.Active then
    mmAgendas.Open;

  while not qryPainel.Eof do
  begin
    mmAgendas.Insert;
    mmAgendasID.AsInteger := qryPainelID.AsInteger;
    mmAgendasNOMEPERFIL.Text := qryPainelNOMEPERFIL.Text;
    mmAgendasDATAMELHORDIA.AsDateTime := qryPainelDATAMELHORDIA.AsDateTime;
    mmAgendasHORAMELHORDIA.AsDateTime := qryPainelHORAMELHORDIA.AsDateTime;
    mmAgendasACOMPANHANTES.AsInteger  := qryPainelQTDEACOMPANHANTES.AsInteger;
    for i := 0 to qryPainelQTDEACOMPANHANTES.AsInteger do
      mmAgendasTEMPOAGENDA.AsDateTime := mmAgendasTEMPOAGENDA.AsDateTime + vTempoPerfil;
    mmAgendasDATAAGENDA.AsDateTime := qryPainelDATAMELHORDIA.AsDateTime;
    mmAgendasHORAAGENDA.AsDateTime := qryPainelHORAMELHORDIA.AsDateTime;
    mmAgendas.Post;
    qryPainel.Next;
  end;

  grdPainelDBTableView1.DataController.DataSource := dtsSelecionados;
end;

procedure TfrmAgendarPedido.qryPainelBeforeOpen(DataSet: TDataSet);
begin
  qryPainel.ParamByName('PEDIDO').AsInteger := CodigoPedido;
end;

end.
