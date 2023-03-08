unit USupplier;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UMasterData, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, SMDBGrid, RzPanel, RzDBNav, Vcl.StdCtrls, RzDBEdit,
  RzLabel, Vcl.Mask, RzEdit;

type
  TfrmSupplier = class(TfrmMasterData)
    FDQuery1VENDACCOUNT: TWideStringField;
    FDQuery1VENDORNAME: TWideStringField;
    FDQuery1TELEPHONE: TWideStringField;
    FDQuery1FAX: TWideStringField;
    FDQuery1NPWP: TWideStringField;
    FDQuery1CONTACTPERSON: TWideStringField;
    FDQuery1EMAIL: TWideStringField;
    FDQuery1ADDRESS: TWideStringField;
    RzDBEdit1: TRzDBEdit;
    RzDBEdit2: TRzDBEdit;
    RzDBEdit3: TRzDBEdit;
    RzDBEdit4: TRzDBEdit;
    RzDBEdit5: TRzDBEdit;
    RzDBEdit6: TRzDBEdit;
    RzDBEdit7: TRzDBEdit;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    RzLabel4: TRzLabel;
    RzLabel5: TRzLabel;
    RzLabel6: TRzLabel;
    RzLabel7: TRzLabel;
    RzLabel8: TRzLabel;
    RzDBMemo1: TRzDBMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSupplier: TfrmSupplier;

implementation

{$R *.dfm}

procedure TfrmSupplier.FormCreate(Sender: TObject);
begin
  inherited;
  with FDQuery1 do
    begin
      sql.Clear;
      sql.Add('SELECT * FROM VENDOR');
      Active := True;
    end;
end;

procedure TfrmSupplier.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  WindowState := wsMinimized;
  frmSupplier := Nil;
  Action := caFree;
end;

end.
