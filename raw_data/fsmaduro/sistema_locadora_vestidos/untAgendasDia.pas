unit untAgendasDia;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dxGDIPlusClasses, ExtCtrls, Buttons, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxScheduler3Painter, Menus, cxStyles,
  cxGraphics, cxEdit, cxScheduler, cxSchedulerStorage,
  cxSchedulerCustomControls, cxSchedulerCustomResourceView, cxSchedulerDayView,
  cxSchedulerDateNavigator, cxSchedulerHolidays, cxSchedulerTimeGridView,
  cxSchedulerUtils, cxSchedulerWeekView, cxSchedulerYearView,
  cxSchedulerGanttView, DB, Wwdatsrc, IBCustomDataSet, IBQuery,
  cxSchedulerDBStorage, cxControls;

type
  TfrmAgendasDia = class(TForm)
    Panel_btns_cad: TPanel;
    btn_ok: TSpeedButton;
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    cxScheduler1: TcxScheduler;
    cxSchedulerDBStorage1: TcxSchedulerDBStorage;
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
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qryAgendaBeforeOpen(DataSet: TDataSet);
  private
    vHoraInicioExpediente: TTime;
    vHoraFimExpediente: TTime;
    vCorCancelada: Integer;
    vCorConfirmada: Integer;
    vCorFinalizada: Integer;
    vCorAgendaPedido: Integer;
    vCorAgendaTrabalho: Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAgendasDia: TfrmAgendasDia;

implementation

uses untDados;

{$R *.dfm}

procedure TfrmAgendasDia.btn_okClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAgendasDia.FormShow(Sender: TObject);
begin

  vHoraInicioExpediente   := Dados.ValorConfig('frmAgenda','HORAINICIOEXPEDIENTE',StrToTime('08:00:00'),tcHora).vcTime;

  vHoraFimExpediente      := Dados.ValorConfig('frmAgenda','HORAFIMEXPEDIENTE',StrToTime('18:00:00'),tcHora).vcTime;

  vCorCancelada           := Dados.ValorConfig('frmAgenda','CORAGENDACANCELADA',ColorToRGB(clRed),tcCor).vcCor;

  vCorConfirmada          := Dados.ValorConfig('frmAgenda','CORAGENDACONFIRMADA',ColorToRGB(clYellow),tcCor).vcCor;

  vCorFinalizada          := Dados.ValorConfig('frmAgenda','CORAGENDAFINALIZADA',ColorToRGB(clGreen),tcCor).vcCor;

  vCorAgendaPedido        := Dados.ValorConfig('frmAgenda','CORAGENDAPEDIDO',ColorToRGB(clAqua),tcCor).vcCor;

  vCorAgendaTrabalho      := Dados.ValorConfig('frmAgenda','CORAGENDATRABALHO',ColorToRGB(clSilver),tcCor).vcCor;

  cxScheduler1.OptionsView.WorkStart := vHoraInicioExpediente;
  cxScheduler1.OptionsView.WorkFinish := vHoraFimExpediente;

  qryAgenda.Close;
  qryAgenda.Open;
end;

procedure TfrmAgendasDia.qryAgendaBeforeOpen(DataSet: TDataSet);
begin
  QryAgenda.ParamByName('CORAGENDACANCELADA').AsInteger := vCorCancelada;
  QryAgenda.ParamByName('CORCONFIRMADA').AsInteger := vCorConfirmada;
  QryAgenda.ParamByName('CORFINALIZADA').AsInteger := vCorFinalizada;
  QryAgenda.ParamByName('CORAGENDAPEDIDO').AsInteger := vCorAgendaPedido;
  QryAgenda.ParamByName('CORAGENDATRABALHO').AsInteger := vCorAgendaTrabalho;
end;

end.
