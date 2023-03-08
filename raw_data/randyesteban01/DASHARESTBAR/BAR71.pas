unit BAR71;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, OCXFISLib_TLB, DateUtils;

type
  TfrmCierreJornadaFiscal = class(TForm)
    btclose: TSpeedButton;
    btimprimir: TSpeedButton;
    rbperiodo: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    fecha1: TDateTimePicker;
    fecha2: TDateTimePicker;
    cbtipo: TRadioGroup;
    rbrango: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure btcloseClick(Sender: TObject);
    procedure btimprimirClick(Sender: TObject);
    procedure cbtipoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCierreJornadaFiscal: TfrmCierreJornadaFiscal;

implementation

{$R *.dfm}

procedure TfrmCierreJornadaFiscal.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCierreJornadaFiscal.btimprimirClick(Sender: TObject);
var
  err, dias, cant : integer;
  arch : textfile;
  puerto, ano1, mes1, dia1, ano2, mes2, dia2, vfecha1, vfecha2 : string;
  DriverFiscal1 : TDriverFiscal;
  desde, hasta : integer;
begin
  if MessageDlg('Está seguro que desea cerrar el la Jornada Fiscal?', mtConfirmation, [mbyes, mbno], 0) = mrYes then
  begin
    AssignFile(arch, 'puerto.ini');
    reset(arch);
    readln(arch, puerto);
    closefile(arch);

    if cbtipo.ItemIndex = 0 then
    begin
      DriverFiscal1 := TDriverFiscal.Create(Self);
      DriverFiscal1.SerialNumber := '27-0163848-435';

      err := DriverFiscal1.IF_OPEN(puerto, 9600);
      err := DriverFiscal1.IF_WRITE('@DailyCloseZ|P');
      err := DriverFiscal1.IF_CLOSE;
      
      DriverFiscal1.Destroy;
    end
    else if cbtipo.ItemIndex = 1 then
    begin
      ano1 := inttostr(YearOf(fecha1.Date));
      mes1 := FormatFloat('00', MonthOf(fecha1.Date));
      dia1 := FormatFloat('00', DayOf(fecha1.Date));

      ano2 := inttostr(YearOf(fecha2.Date));
      mes2 := FormatFloat('00', MonthOf(fecha2.Date));
      dia2 := FormatFloat('00', DayOf(fecha2.Date));

      vfecha1 := dia1+mes1+ano1;
      vfecha2 := dia2+mes2+ano2;

      DriverFiscal1 := TDriverFiscal.Create(Self);
      DriverFiscal1.SerialNumber := '27-0163848-435';

      err := DriverFiscal1.IF_OPEN(puerto, 9600);
      err := DriverFiscal1.IF_WRITE('@DailyCloseByDate|'+vfecha1+'|'+vfecha2+'|F|P');
      err := DriverFiscal1.IF_WRITE('@GetNextDailyCloseReportData');

      dias := DaysBetween(fecha1.Date, fecha2.Date);
      cant := 1;
      while (cant <= dias+1) do
      begin
        err  := DriverFiscal1.IF_WRITE('@GetNextDailyCloseReportData');
        cant := cant + 1;
      end;
      err := DriverFiscal1.IF_WRITE('@CloseDailyCloseReport');
      err := DriverFiscal1.IF_CLOSE;

      DriverFiscal1.Destroy;
    end
    else if cbtipo.ItemIndex = 2 then
    begin
      DriverFiscal1 := TDriverFiscal.Create(Self);
      DriverFiscal1.SerialNumber := '27-0163848-435';

      desde := strtoint(edit1.text);
      hasta := strtoint(edit2.text);

      err := DriverFiscal1.IF_OPEN(puerto, 9600);
      err := DriverFiscal1.IF_WRITE('@DailyCloseByNumber|'+inttostr(desde)+'|'+inttostr(hasta)+'|R|P');

      dias := hasta - desde;
      cant := 1;
      while (cant <= dias+1) do
      begin
        err := DriverFiscal1.IF_WRITE('@GetNextDailyCloseReportData');
        desde := desde + 1;
        cant := cant + 1;
      end;
      err := DriverFiscal1.IF_WRITE('@CloseDailyCloseReport');

      err := DriverFiscal1.IF_CLOSE;

      DriverFiscal1.Destroy;
    end;
  end;


end;

procedure TfrmCierreJornadaFiscal.cbtipoClick(Sender: TObject);
begin
  rbperiodo.Visible := cbtipo.ItemIndex = 1;
  rbrango.Visible   := cbtipo.ItemIndex = 2;
end;

procedure TfrmCierreJornadaFiscal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := cafree;
end;

procedure TfrmCierreJornadaFiscal.FormCreate(Sender: TObject);
begin
  btclose.Caption    := 'F1'+#13+'SALIR';
  btimprimir.Caption := 'F2'+#13+'IMPRIMIR';
  fecha1.Date := date;
  fecha2.Date := date;
end;

procedure TfrmCierreJornadaFiscal.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(self);
  if key = vk_f2 then btimprimirClick(self);
end;

end.
