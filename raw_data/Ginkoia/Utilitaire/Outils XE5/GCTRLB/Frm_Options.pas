unit Frm_Options;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, Menus,
  DBCtrls, Grids, DBGrids, ComCtrls, Mask, ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;


type
  TFormOptions = class(TForm)
    dsliste: TDataSource;
    pnl1: TPanel;
    pnl2: TPanel;
    lbl1: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    pnl3: TPanel;
    pnl4: TPanel;
    lbl8: TLabel;
    lbl2: TLabel;
    dbnvgrNavigator1: TDBNavigator;
    dbgrd1: TDBGrid;
    pgc1: TPageControl;
    tsAnalyse: TTabSheet;
    tsInfos: TTabSheet;
    tsCorrection: TTabSheet;
    dbmmoSCT_QUERY: TDBMemo;
    dbmmoSCT_QUERY1: TDBMemo;
    dbmmoSCT_QUERY2: TDBMemo;
    dbedtSCT_NOM: TDBEdit;
    dbedtSCT_REFERENCE: TDBEdit;
    dbedtSCT_ID: TDBEdit;
    dbchkSCT_CHECK: TDBCheckBox;
    dbedtSCT_REFERENCE1: TDBEdit;
    lbl6: TLabel;
    cbV11: TCheckBox;
    cbV12: TCheckBox;
    cbV13: TCheckBox;
    dbedtSCT_REFERENCE2: TDBEdit;
    cbb1: TComboBox;
    Qliste: TFDQuery;
    QlisteSCT_ID: TFDAutoIncField;
    QlisteSCT_ERROR: TIntegerField;
    QlisteSCT_QUERY: TFDWideMemoField;
    QlisteSCT_INFO: TFDWideMemoField;
    QlisteSCT_SOLUTION: TFDWideMemoField;
    QlisteSCT_NBRESULT: TIntegerField;
    QlisteSCT_REFERENCE: TWideStringField;
    QlisteSCT_CHECK: TIntegerField;
    QlisteSCT_VERSION: TWideStringField;
    QlisteSCT_NOM: TWideStringField;
    procedure qlisteAfterInsert(DataSet: TDataSet);
    procedure cbVClick(Sender: TObject);
    procedure qlisteAfterScroll(DataSet: TDataSet);
    procedure cbb1Change(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FormOptions: TFormOptions;

implementation


USes UCommun,UDataMod, Frm_Main;

{$R *.dfm}

procedure TFormOptions.cbb1Change(Sender: TObject);
begin
     if qliste.State in [dsEdit,DsInsert] then
       begin
          qliste.FieldByName('SCT_ERROR').Asinteger:=cbb1.ItemIndex;
       end;
     if qliste.State In [dsBrowse] then
       begin
          cbb1.ItemIndex:=qliste.FieldByName('SCT_ERROR').Asinteger;
       end;
end;

procedure TFormOptions.cbVClick(Sender: TObject);
var temp:string;
begin
      if qliste.State In [dsEdit,dsInsert] then
        begin
          temp:='';

          If cbV11.Checked
            then temp:='1'
            else temp:='0';

          If cbV12.Checked
            then temp:=temp+'1'
            else temp:=temp+'0';

          If cbV13.Checked
            then temp:=temp+'1'
            else temp:=temp+'0';

          qliste.FieldByName('SCT_VERSION').AsString:=temp;
        end;
     if qliste.State In [dsBrowse] then
        begin
          temp:=Qliste.FieldByName('SCT_VERSION').AsString;
          cbV11.Checked:=(temp[1]='1');
          cbV12.Checked:=(temp[2]='1');
          cbV13.Checked:=(temp[3]='1');
        end;
end;

procedure TFormOptions.qlisteAfterInsert(DataSet: TDataSet);
begin
     TFDQUery(DataSet).FieldByName('SCT_ERROR').asinteger:=1;
end;

procedure TFormOptions.qlisteAfterScroll(DataSet: TDataSet);
var temp:string;
begin
     if qliste.State In [dsBrowse] then
        begin
             temp:=DataSet.FieldByName('SCT_VERSION').AsString;
             cbV11.Checked:=(temp[1]='1');
             cbV12.Checked:=(temp[2]='1');
             cbV13.Checked:=(temp[3]='1');
             cbb1.ItemIndex:= qliste.FieldByName('SCT_ERROR').Asinteger;
        end;
end;

end.
