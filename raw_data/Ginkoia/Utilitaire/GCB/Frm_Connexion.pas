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
    dbnvgrNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    lbl4: TLabel;
    dbedtCON_ID: TDBEdit;
    dbedtCON_ID1: TDBEdit;
    dbedtCON_ID2: TDBEdit;
    dbedtCON_SERVER: TDBEdit;
    dbchkCON_FAV: TDBCheckBox;
    Qliste: TFDQuery;
    QlisteCON_ID: TFDAutoIncField;
    QlisteCON_NOM: TWideStringField;
    QlisteCON_SERVER: TWideStringField;
    QlisteCON_PATH: TWideStringField;
    QlisteCON_FAV: TIntegerField;
    btn1: TBitBtn;
    procedure qlisteAfterInsert(DataSet: TDataSet);
    procedure btn1Click(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure FormCreate(Sender: TObject);
  private
    FColumnIndex : integer;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmConnexion: TfrmConnexion;

implementation

USes UCommun,UDataMod{, Frm_Main}, Frm_WsDabases;

{$R *.dfm}

procedure TfrmConnexion.btn1Click(Sender: TObject);
begin
    Application.CreateForm(TForm_WSDATABASES,Form_WSDATABASES);
    Form_WSDATABASES.ShowModal;
    Qliste.Close;
    Qliste.open;
end;

procedure TfrmConnexion.DBGrid1TitleClick(Column: TColumn);
begin
  if DBGrid1.DataSource.DataSet is TDataSet then
  with TFDmemTable(DBGrid1.DataSource.DataSet) do
  begin
    If FColumnIndex>=0 then
      DBGrid1.Columns[FColumnIndex].title.Font.Style :=
      DBGrid1.Columns[FColumnIndex].title.Font.Style - [fsBold];

    Column.title.Font.Style := Column.title.Font.Style + [fsBold];
    if (FColumnIndex=Column.Index)
      then
          begin
              if IndexFieldNames = Column.FieldName+':A' then
                 IndexFieldNames := Column.FieldName+':D'
              else
                IndexFieldNames := Column.FieldName+':A';
          end
      else IndexFieldNames := Column.FieldName+':A';
    FColumnIndex := Column.Index;
  end;
end;

procedure TfrmConnexion.FormCreate(Sender: TObject);
begin
    FColumnIndex:=-1;
    DBGrid1.Columns[0].Width:=300;
    DBGrid1.Columns[1].Width:=300;
end;

procedure TfrmConnexion.qlisteAfterInsert(DataSet: TDataSet);
begin
     TFDQUery(DataSet).FieldByName('CON_FAV').asinteger:=0;
end;

end.
