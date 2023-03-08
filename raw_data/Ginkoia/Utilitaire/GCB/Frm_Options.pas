unit Frm_Options;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, Menus,
  DBCtrls, Grids, DBGrids, ComCtrls, Mask, ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,DateUtils;

Const start=2011;

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
    dbedtSCT_REFERENCE2: TDBEdit;
    cbb1: TComboBox;
    Qliste: TFDQuery;
    QlisteSCT_ID: TFDAutoIncField;
    QlisteSCT_ERROR: TIntegerField;
    QlisteSCT_QUERY: TWideMemoField;
    QlisteSCT_INFO: TWideMemoField;
    QlisteSCT_SOLUTION: TWideMemoField;
    QlisteSCT_NBRESULT: TIntegerField;
    QlisteSCT_REFERENCE: TWideStringField;
    QlisteSCT_CHECK: TIntegerField;
    QlisteSCT_VERSION: TWideStringField;
    QlisteSCT_NOM: TWideStringField;
    dbcbbSCT_COMPARATEUR: TDBComboBox;
    QlisteSCT_COMPARATEUR: TWideStringField;
    Panel1: TPanel;
    Label1: TLabel;
    QlisteSCT_TYPE: TIntegerField;
    cbx_Type: TComboBox;
    dbchkSCT_EXPORT: TDBCheckBox;
    QlisteSCT_EXPORT: TIntegerField;
    procedure qlisteAfterInsert(DataSet: TDataSet);
    procedure cbFClick(Sender: TObject);
    procedure cbVClick(Sender: TObject);
    procedure qlisteAfterScroll(DataSet: TDataSet);
    procedure cbb1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure QlisteAfterEdit(DataSet: TDataSet);
    procedure QlisteAfterPost(DataSet: TDataSet);
    procedure dbmmoSCT_QUERYKeyPress(Sender: TObject; var Key: Char);
    procedure dbmmoSCT_QUERY2KeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbx_TypeChange(Sender: TObject);
  private
    { Déclarations privées }
    procedure ActiveDesactiveCheckBox(DataSet: TDataSet);
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

procedure TFormOptions.cbFClick(Sender: TObject);
var temp:string;
    i:integer;
    AComponent:TComponent;
begin
     if qliste.State In [dsEdit,dsInsert] then exit;

     Qliste.DisableControls;
     try
        begin
            temp:='';
            for i:=0 to YearOf(Now()) - start + 1  do
              begin
                   AComponent := FindComponent(format('cbf_%d',[i+11])) ;
                   if (AComponent<>nil)
                      then
                        If (TCheckBox(AComponent).Checked)
                            then temp:=temp+'0'
                            else temp:=temp+'_';
              end;


        end;
        Qliste.Close;
        Qliste.SQL.Clear;
        Qliste.SQL.Add('SELECT * FROM SCRCTRL');
        Qliste.SQL.Add(' WHERE SCT_VERSION NOT LIKE '''+ temp +''' ');
        Qliste.SQL.Add(' ORDER BY SCT_NOM');
        Qliste.open;
     finally
       Qliste.EnableControls;
     end;

end;

procedure TFormOptions.cbVClick(Sender: TObject);
var temp:string;
    i:integer;
    AComponent:TComponent;
begin
      if qliste.State In [dsEdit,dsInsert] then
        begin
          temp:='';
          for i:=0 to YearOf(Now()) - start + 1  do
             begin
                 AComponent := FindComponent(format('cbv_%d',[i+11])) ;
                 if (AComponent<>nil)
                    then
                      If (TCheckBox(AComponent).Checked)
                          then temp:=temp+'1'
                          else temp:=temp+'0';
            end;
          qliste.FieldByName('SCT_VERSION').AsString:=temp;
        end;
{
     if qliste.State In [dsBrowse] then
        begin
          temp:=Qliste.FieldByName('SCT_VERSION').AsString;
          for i:=0 to YearOf(Now())- start do
             begin
                 AComponent := FindComponent(format('cbv_%d',[i+11])) ;
                 if (AComponent<>nil)
                    then
                      TCheckBox(AComponent).Checked:=temp[i]='1';
            end;
        end;
     }
end;

procedure TFormOptions.cbx_TypeChange(Sender: TObject);
begin
  if (Qliste.State in [dsEdit,DsInsert]) then
  begin
    Qliste.FieldByName('SCT_TYPE').AsInteger := cbx_Type.ItemIndex;
  end;

end;

procedure TFormOptions.dbmmoSCT_QUERY2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ^A then
  begin
    (Sender as TDBMemo).SelectAll;
    Key := #0;
  end;
end;

procedure TFormOptions.dbmmoSCT_QUERYKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ^A then
  begin
    (Sender as TDBMemo).SelectAll;
    Key := #0;
  end;
end;

procedure TFormOptions.FormCreate(Sender: TObject);
var i:integer;
    ACheckBox:TCheckBox;
begin
    for i:=0 to YearOf(Now())- start + 1  do
       begin
          ACheckBox:=TCheckBox.Create(self);
          ACheckBox.Parent:=tsInfos;
          ACheckBox.Top  := 14 + 23 * (i mod 3);
          ACheckBox.left := 72 + 57 * (i div 3);
          ACheckBox.Name:=format('cbv_%d',[i+11]);
          ACheckBox.Caption:=Format('V %d',[i+11]);
          ACheckBox.OnClick:=cbVClick;
          ACheckBox.Enabled:=false;
       end;

    for i:=0 to YearOf(Now())- start + 1  do
       begin
          ACheckBox:=TCheckBox.Create(self);
          ACheckBox.Checked:=true;
          ACheckBox.Parent:=Panel1;
          ACheckBox.Top  := 14;
          ACheckBox.left := 100 + 57*i;
          ACheckBox.Name:=format('cbf_%d',[i+11]);
          ACheckBox.Caption:=Format('V %d',[i+11]);
          ACheckBox.OnClick:=cbFClick;
          ACheckBox.Enabled:=true;
       end;


    dbedtSCT_REFERENCE2.Visible:=false;
    {IFDEF DEBUG}
    dbedtSCT_REFERENCE2.Visible:=true;
    {ENDIF}
    dbgrd1.Columns[0].Width := 200;

end;

procedure TFormOptions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if qliste.State = dsBrowse then
       begin
           if Key=(VK_DELETE) then Key:= 0;
       end;
end;

procedure TFormOptions.QlisteAfterEdit(DataSet: TDataSet);
begin
     ActiveDesactiveCheckBox(DataSet);
end;

procedure TFormOptions.qlisteAfterInsert(DataSet: TDataSet);
begin
     TFDQUery(DataSet).FieldByName('SCT_ERROR').asinteger:=1;
     ActiveDesactiveCheckBox(DataSet);
end;

procedure TFormOptions.QlisteAfterPost(DataSet: TDataSet);
begin
     ActiveDesactiveCheckBox(DataSet);
end;

procedure TFormOptions.ActiveDesactiveCheckBox(DataSet: TDataSet);
var i:integer;
    AComponent:TComponent;
begin
     for i:=0 to YearOf(Now())- start + 1 do
       begin
           AComponent := FindComponent(format('cbv_%d',[i+11])) ;
           if (AComponent<>nil)
              then
                TCheckBox(AComponent).Enabled:=(Dataset.State) in [dsEdit,DsInsert]
      end;
      cbx_Type.Enabled:=(Dataset.State) in [dsEdit,DsInsert];
end;

procedure TFormOptions.qlisteAfterScroll(DataSet: TDataSet);
var temp:string;
    i:integer;
    AComponent:TComponent;
begin
     if qliste.State In [dsBrowse] then
        begin
             temp:=DataSet.FieldByName('SCT_VERSION').AsString;
             while length(temp)<=(YearOf(Now())- start) + 1 do
              begin
                temp:=temp + '0';
              end;
             for i:=0 to YearOf(Now())- start + 1  do
                 begin
                     AComponent := FindComponent(format('cbv_%d',[i+11])) ;
                     if (AComponent<>nil)
                        then
                          TCheckBox(AComponent).Checked:=temp[i+1]='1';
                end;
             cbb1.ItemIndex:= qliste.FieldByName('SCT_ERROR').Asinteger;

             cbx_Type.ItemIndex := qliste.FieldByName('SCT_TYPE').Asinteger;
        end;
end;

end.
