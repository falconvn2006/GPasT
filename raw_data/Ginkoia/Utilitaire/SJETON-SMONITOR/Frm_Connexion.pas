unit Frm_Connexion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  DB,  StdCtrls, ExtCtrls,   Menus,
  DBCtrls, Grids, DBGrids, Mask, Buttons, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmConnexion = class(TForm)
    pnl1: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    pnl2: TPanel;
    lbl5: TLabel;
    dsliste: TDataSource;
    Label1: TLabel;
    dbnvgrNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    lbl4: TLabel;
    dbedtCON_ID: TDBEdit;
    dbedtCON_ID1: TDBEdit;
    dbedtCON_ID2: TDBEdit;
    dbedtCON_SERVER: TDBEdit;
    dbedtCON_PATH: TDBEdit;
    dbchkCON_FAV: TDBCheckBox;
    Qliste: TFDQuery;
    QlisteCON_ID: TFDAutoIncField;
    QlisteCON_NOM: TWideStringField;
    QlisteCON_SERVER: TWideStringField;
    QlisteCON_PATH: TWideStringField;
    QlisteCON_FAV: TIntegerField;
    QlisteCON_MONITOR: TWideStringField;
    procedure qlisteAfterInsert(DataSet: TDataSet);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmConnexion: TfrmConnexion;

implementation

USes UCommun,UDataMod{, Frm_Main};

{$R *.dfm}

procedure TfrmConnexion.qlisteAfterInsert(DataSet: TDataSet);
begin
     TFDQUery(DataSet).FieldByName('CON_FAV').asinteger:=0;
end;

end.
