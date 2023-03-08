unit BAR22;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, DB, ADODB, StdCtrls, Mask, DBCtrls;

type
  TfrmActAreas = class(TForm)
    Panel1: TPanel;
    btclose: TSpeedButton;
    btpost: TSpeedButton;
    Panel2: TPanel;
    Panel3: TPanel;
    QAreas: TADOQuery;
    dsAreas: TDataSource;
    Label1: TLabel;
    DBEdit2: TDBEdit;
    QAreasAreaID: TAutoIncField;
    QAreasNombre: TWideStringField;
    Label2: TLabel;
    dbcbbCombox: TDBComboBox;
    QAreasPrecio: TStringField;
    procedure btcloseClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btpostClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure QAreasBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    Grabo : Integer;
  end;

var
  frmActAreas: TfrmActAreas;

implementation

uses BAR04;

{$R *.dfm}

procedure TfrmActAreas.btcloseClick(Sender: TObject);
begin
  QAreas.Cancel;
  Grabo := 0;
  Close;
end;

procedure TfrmActAreas.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(vk_return) then
  begin
    perform(wm_nextdlgctl, 0, 0);
    key := #0;
  end;
end;

procedure TfrmActAreas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then btpostClick(Self);
end;

procedure TfrmActAreas.btpostClick(Sender: TObject);
begin
  QAreas.Post;
  QAreas.UpdateBatch;
  Grabo := 1;
  Close;
end;

procedure TfrmActAreas.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btpost.Caption  := 'F2'+#13+'GRABAR';
end;

procedure TfrmActAreas.QAreasBeforePost(DataSet: TDataSet);
begin
IF QAreas.State IN [dsInsert] then begin
DM.Query1.Close;
DM.Query1.SQL.Clear;
DM.Query1.SQL.Add('SELECT ISNULL(MAX(AREAID),0)+1 ID FROM AREAS');
DM.Query1.Open;
QAreasAreaID.Value := DM.Query1.FIELDBYNAME('ID').Value;
DM.Query1.Close;
end;
end;

end.
