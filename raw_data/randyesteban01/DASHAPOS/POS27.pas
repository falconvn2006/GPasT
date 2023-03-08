unit POS27;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, StdCtrls, DBCtrls, Buttons, ExtCtrls;

type
  TfrmSerie = class(TForm)
    pBottom: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    pTop: TPanel;
    DBText1: TDBText;
    DBText2: TDBText;
    Label2: TLabel;
    DBText3: TDBText;
    Label3: TLabel;
    dbGSerie: TDBGrid;
    dsMantSerie: TDataSource;
    btprior: TSpeedButton;
    btnext: TSpeedButton;
    lSerializado: TLabel;
    Panel1: TPanel;
    procedure btpriorClick(Sender: TObject);
    procedure btnextClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dsMantSerieDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSerie: TfrmSerie;

implementation

uses POS00,POS01;

{$R *.dfm}

procedure TfrmSerie.btpriorClick(Sender: TObject);
begin
  with frmMain.QDetalle do
  begin
    DisableControls;
    Prior;
    EnableControls;
  end;
end;

procedure TfrmSerie.btnextClick(Sender: TObject);
begin
  with frmMain.QDetalle do
  begin
    DisableControls;
    Next;
    EnableControls;
  end;
end;

procedure TfrmSerie.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f11 then btpriorClick(Self);
  if key = vk_f12 then btnextClick(Self);
end;

procedure TfrmSerie.dsMantSerieDataChange(Sender: TObject; Field: TField);
begin
  if frmMain.QDetallepro_serializado.AsString = 'S' then
     lSerializado.Caption := 'Serializado'
  else
     lSerializado.Caption := '';
  dbGSerie.Enabled := frmMain.QDetallepro_serializado.AsString = 'S';
end;

end.
