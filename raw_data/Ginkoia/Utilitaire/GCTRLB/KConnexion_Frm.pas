unit KConnexion_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  DB,  StdCtrls, ExtCtrls,   Menus,
  DBCtrls, Grids, DBGrids, Mask, Buttons, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFrm_KConnexion = class(TForm)
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
    QlisteCON_GROUP: TStringField;
    QlisteCON_NOM: TStringField;
    QlisteCON_SERVER: TStringField;
    QlisteCON_DATABASE: TStringField;
    QlisteCON_FAV: TIntegerField;
    procedure qlisteAfterInsert(DataSet: TDataSet);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_KConnexion: TFrm_KConnexion;

implementation

USes UCommun, KManquants_Frm;

{$R *.dfm}

procedure TFrm_KConnexion.qlisteAfterInsert(DataSet: TDataSet);
begin
     TFDQUery(DataSet).FieldByName('CON_FAV').asinteger:=0;
end;

end.
