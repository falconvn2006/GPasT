unit Jetons;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ShellApi, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IniFiles, Vcl.ExtCtrls,
  Data.DB, FireDAC.Comp.DataSet,FireDAC.Comp.Client, Vcl.ComCtrls,
  Vcl.ButtonGroup, Vcl.Buttons, Mainform, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt;

type
    TJeton = class(TForm)
    SpeedButton1: TSpeedButton;
    DBGrid1: TDBGrid;
    ds1: TDataSource;
    FDQuery1: TFDQuery;
    FDQuery1BAS_ID: TIntegerField;
    FDQuery1BAS_IDENT: TStringField;
    FDQuery1BAS_NOM: TStringField;
    FDQuery1BAS_JETON: TIntegerField;
    FDQuery1BAS_PLAGE: TStringField;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
private
    { Déclarations privées}
public
{ Déclarations publiques}
end;

var
    Jeton: TJeton;

implementation

uses Datamod;

{$R *.DFM}

procedure TJeton.FormClose(Sender: TObject; var Action: TCloseAction);
begin
      Action:=caFree;
end;

procedure TJeton.FormCreate(Sender: TObject);
begin
    FDQuery1.Open();
end;

procedure TJeton.SpeedButton1Click(Sender: TObject);
begin
     Close();
end;

end.
