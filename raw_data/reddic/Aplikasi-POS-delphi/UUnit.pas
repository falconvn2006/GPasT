unit UUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UMasterData, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, SMDBGrid, RzPanel, RzDBNav, Vcl.StdCtrls, RzLabel,
  Vcl.Mask, RzEdit, RzDBEdit;

type
  TfrmUnit = class(TfrmMasterData)
    FDQuery1UNIT: TWideStringField;
    FDQuery1UNITNAME: TWideStringField;
    RzDBEdit1: TRzDBEdit;
    RzDBEdit2: TRzDBEdit;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmUnit: TfrmUnit;

implementation

{$R *.dfm}

procedure TfrmUnit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  WindowState := wsMinimized;
  frmUnit := Nil;
  Action := caFree;
end;

procedure TfrmUnit.FormCreate(Sender: TObject);
begin
  inherited;
  with FDQuery1 do
    begin
      sql.Clear;
      sql.Add('SELECT * FROM UUNIT');
      Active := True;
    end;
end;

end.
