unit POS19;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ToolWin, ComCtrls;

type
  TfrmInformacionNCF = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    lbrnc: TLabel;
    lbrazon: TLabel;
    lbnombre: TLabel;
    lbactividad: TLabel;
    lbdireccion: TLabel;
    lbnumero: TLabel;
    lburbanizacion: TLabel;
    lbtelefono: TLabel;
    lbestatus: TLabel;
    ToolBar1: TToolBar;
    btsalir: TSpeedButton;
    procedure btsalirClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmInformacionNCF: TfrmInformacionNCF;

implementation

uses POS01, POS00;

{$R *.dfm}

procedure TfrmInformacionNCF.btsalirClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmInformacionNCF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then btsalirClick(Self);
end;

procedure TfrmInformacionNCF.FormCreate(Sender: TObject);
begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select rnc_cedula, razon_social, nombre_comercial,');
  dm.Query1.SQL.Add('actividad_economica, direccion, numero, urbanizacion,');
  dm.Query1.SQL.Add('telefono, estatus from rnc');
  dm.Query1.SQL.Add('where rnc_cedula = :rnc');
  dm.Query1.Parameters.ParamByName('rnc').Value := frmMain.QTicketrnc.Value;
  dm.Query1.Open;
  lbrnc.Caption          := frmMain.QTicketrnc.Value;
  lbrazon.Caption        := dm.Query1.FieldByName('razon_social').AsString;
  lbnombre.Caption       := dm.Query1.FieldByName('nombre_comercial').AsString;
  lbactividad.Caption    := dm.Query1.FieldByName('actividad_economica').AsString;
  lbdireccion.Caption    := dm.Query1.FieldByName('direccion').AsString;
  lbnumero.Caption       := dm.Query1.FieldByName('numero').AsString;
  lburbanizacion.Caption := dm.Query1.FieldByName('urbanizacion').AsString;
  lbtelefono.Caption     := dm.Query1.FieldByName('telefono').AsString;
  lbestatus.Caption      := dm.Query1.FieldByName('estatus').AsString;
end;

end.
