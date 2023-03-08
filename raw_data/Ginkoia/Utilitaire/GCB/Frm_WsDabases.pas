unit Frm_WsDabases;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, System.Json, Vcl.ExtCtrls, Vcl.Menus,
  Vcl.ComCtrls;

type
  TForm_WSDATABASES = class(TForm)
    DBGrid1: TDBGrid;
    FDMemTable1: TFDMemTable;
    DataSource1: TDataSource;
    FDMemTable1GROUPE: TStringField;
    FDMemTable1DOSSIER: TStringField;
    FDMemTable1LAME: TStringField;
    FDMemTable1GINKOIA: TStringField;
    FDMemTable1MONITOR: TStringField;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    FDMemTable1ETAT: TSmallintField;
    pmenu: TPopupMenu;
    mpajouter: TMenuItem;
    N1: TMenuItem;
    Monitoring1: TMenuItem;
    VMONITORLASTREPLIC1: TMenuItem;
    SETSTATISTICSLOG1: TMenuItem;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    FDMemTable1LASTUPDATE: TStringField;
    cbGRP: TComboBox;
    edtURL: TEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    N2: TMenuItem;
    outimporter1: TMenuItem;
    procedure BitBtn1Click(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure FormCreate(Sender: TObject);
    procedure mpajouterClick(Sender: TObject);
    procedure DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VMONITORLASTREPLIC1Click(Sender: TObject);
    procedure SETSTATISTICSLOG1Click(Sender: TObject);
    procedure outimporter1Click(Sender: TObject);
  private
    FColumnIndex : integer;
    procedure Parse_Json_Datas(astr:string);
    procedure GetDatabases;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form_WSDATABASES: TForm_WSDATABASES;

implementation

{$R *.dfm}

Uses UCommun, UDataMod;


procedure TForm_WSDATABASES.BitBtn1Click(Sender: TObject);
begin
     GetDatabases;
end;

procedure TForm_WSDATABASES.DBGrid1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Pt: TPoint;
  Coord: TGridCoord;
begin
  if (Button = mbRight) then
    begin
        if FDMemTable1.RecordCount>0 then
          begin
              if (FDMemTable1.FieldByName('ETAT').asinteger=128) then
                begin
                    mpajouter.Enabled:=true;
                    GetCursorPos(Pt);
                    pmenu.Popup(pt.X,pt.Y);
                end;
              if (FDMemTable1.FieldByName('ETAT').asinteger=0) then
                begin
                    mpajouter.Enabled:=false;
                    GetCursorPos(Pt);
                    pmenu.Popup(pt.X,pt.Y);
                end;
          end;
    end;
end;

procedure TForm_WSDATABASES.DBGrid1TitleClick(Column: TColumn);
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

procedure TForm_WSDATABASES.FormCreate(Sender: TObject);
begin
    FColumnIndex:=-1;
end;

procedure TForm_WSDATABASES.GetDatabases;
var idhttp:TIdHttp;
    Ts : TStringList;
    resultat:string;
begin
    // est-ce qu'il y a des nettoyages à faire ?
    idhttp:=TidHttp.Create(Self);
    Ts := TStringList.Create;
    try
      try
       Ts.Add(Format('grp=%s',[CBGRP.Text]));
       idhttp.Request.ContentType := 'application/x-www-form-urlencoded';
       resultat:=idhttp.Post(EdtUrl.Text, Ts);
       // ****************************************//
       if Length(resultat)>0 then
         begin
              // Il faut Parser le truc   et mettre ca dans MemTable
              Parse_Json_Datas(resultat);
              //
         end;
      except On E:Exception do
          // rien
          // result:='';
      end;
    finally
      Ts.free;
      idHttp.Free;
    end;
end;


procedure TForm_WSDATABASES.mpajouterClick(Sender: TObject);
var i:integer;
begin
   FDMemTable1.DisableControls;
   if DBGrid1.SelectedRows.Count > 0 then
      begin
          with DBGrid1.DataSource.DataSet do
            begin
                for i := 0 to DBGrid1.SelectedRows.Count-1 do
                begin
                    GotoBookmark(Pointer(DBGrid1.SelectedRows.Items[i]));
                    if (FDMemTable1.FieldByName('ETAT').asinteger=128) then
                    begin
                        // faut ajouter à chaud dans CONNEXION ? / VJETON ? / VMONITOR ?
                        // Showmessage('à Faire');
                        DataMod.AddDBConnexions(FDMemTable1);
                        FDMemTable1.Edit;
                        FDMemTable1.FieldByName('ETAT').Asinteger := DataMod.DB_In_Connexions(FDMemTable1);
                        FDMemTable1.post;
                    end;
                end;
            end;
      end;
   FDMemTable1.EnableControls;
end;

procedure TForm_WSDATABASES.outimporter1Click(Sender: TObject);
var i:integer;
begin
   FDMemTable1.DisableControls;
   FDMemTable1.First;
   while not(FDMemTable1.eof) do
      begin
        DataMod.AddDBConnexions(FDMemTable1);
        FDMemTable1.Edit;
        FDMemTable1.FieldByName('ETAT').Asinteger := DataMod.DB_In_Connexions(FDMemTable1);
        FDMemTable1.post;
        FDMemTable1.Next;
      end;
   FDMemTable1.EnableControls;
end;

procedure TForm_WSDATABASES.Parse_Json_Datas(astr:string);
var  LJsonArr   : TJSONArray;
  LJsonValue : TJSONValue;
  LItem     : TJSONValue;

begin
   LJsonArr    := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(aStr),0) as TJSONArray;
   FDMemTable1.DisableControls;
   FDMemTable1.close;
   FDMemTable1.Open;
   for LJsonValue in LJsonArr do
   begin
      FDMemTable1.Append;
      for LItem in TJSONArray(LJsonValue) do
        begin
            FDMemTable1.FieldByName(TJSONPair(LItem).JsonString.Value).AsString:=TJSONPair(LItem).JsonValue.Value;
        end;
      Label1.Caption:=Format('Dernière Récupération Maintenance : %s',[FDMemTable1.FieldByName('LASTUPDATE').Asstring]);
      Label1.Refresh;
      FDMemTable1.post;
   end;
   //---------------------------------------------------------------------------
   FDMemTable1.First;
   While not(FDMemTable1.eof) do
    begin
        FDMemTable1.Edit;
        FDMemTable1.FieldByName('ETAT').Asinteger := DataMod.DB_In_Connexions(FDMemTable1);
        FDMemTable1.post;
        FDMemTable1.Next;
    end;
   FDMemTable1.EnableControls;
end;


procedure TForm_WSDATABASES.SETSTATISTICSLOG1Click(Sender: TObject);
// var ATS:TThreadScript;
begin
//    ATS:=TThreadScript.Create(FDMemTable1.FieldByName('LAME').AsString,FDMemTable1.FieldByName('MONITOR').AsString,'LOG',nil);
//    ATS.Resume;
end;

procedure TForm_WSDATABASES.VMONITORLASTREPLIC1Click(Sender: TObject);
begin
    //



    //
end;

end.
