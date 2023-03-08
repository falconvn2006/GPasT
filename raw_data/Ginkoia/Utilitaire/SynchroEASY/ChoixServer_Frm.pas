unit ChoixServer_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, dxGDIPlusClasses, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Buttons,uThreadDB;

CONST CST_ERROR = 'ERREUR';

type
  TForm_ChoixServer = class(TForm)
    Panel3: TPanel;
    Image2: TImage;
    Label9: TLabel;
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    memTable: TFDMemTable;
    ds: TDataSource;
    BVALIDER: TBitBtn;
    memTableNOM: TStringField;
    memTableCHEMIN: TStringField;
    memTableID: TIntegerField;
    memTableETAT: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure BVALIDERClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);

  private
    FSynchroPaths : TSynchroPaths;
    FSYNCHRO_NB_Default     : string;
    FSYNCHRO_NB             : string;
    FFileSize_Server_NB     : Int64;
    FFileExist_Server_NB    : Boolean;
    FFileDateTime_Server_NB : TDateTime;
    FFileExistVersion_ZIP   : boolean;
    procedure Get_FileAttributes();
    function Get_FileDateTime(const FileTime: TFileTime):TDateTime;
    procedure FitGrid(Grid: TDBGrid);
    procedure SelectionServeur();
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure Remplissage();
    property SynchroPaths : TSynchroPaths read FSynchroPaths write FSynchroPaths;
    property SYNCHRO_NB             : string     read FSYNCHRO_NB;
    property FileSize_Server_NB     : Int64      read FFileSize_Server_NB;
    property FileExist_Server_NB    : boolean    read FFileExist_Server_NB;
    property FileDateTime_Server_NB : TDateTime  read FFileDateTime_Server_NB;
    property FileExistVersion_ZIP   : Boolean    read FFileExistVersion_ZIP;
    property SYNCHRO_NB_Default     : string     write FSYNCHRO_NB_Default;
  end;

var
  Form_ChoixServer: TForm_ChoixServer;

implementation

{$R *.dfm}


function TForm_ChoixServer.Get_FileDateTime(const FileTime: TFileTime):TDateTime;
var SystemTime, LocalTime: TSystemTime;
begin
    if not FileTimeToSystemTime(FileTime, SystemTime) then
      RaiseLastOSError;
    if not SystemTimeToTzSpecificLocalTime(nil, SystemTime, LocalTime) then
      RaiseLastOSError;
    result:= SystemTimeToDateTime(LocalTime);
 end;


procedure TForm_ChoixServer.Get_FileAttributes();
var info: TWin32FileAttributeData;
begin
   FFileSize_Server_NB := -1;

   if NOT GetFileAttributesEx(PWideChar(FSYNCHRO_NB), GetFileExInfoStandard, @info) then
      EXIT;

  FFileSize_Server_NB := Int64(info.nFileSizeLow) or Int64(info.nFileSizeHigh shl 32);
  FFileExist_Server_NB  := FileExists(FSYNCHRO_NB);
  FFileDateTime_Server_NB := Get_FileDateTime(info.ftLastWriteTime);
end;


procedure TForm_ChoixServer.BVALIDERClick(Sender: TObject);
begin
  SelectionServeur();
end;

procedure TForm_ChoixServer.SelectionServeur();
var vVERSION_ZIP:string;
begin
   FSYNCHRO_NB  := memTable.FieldByName('CHEMIN').asstring;
   vVERSION_ZIP := IncludeTrailingPathDelimiter(ExtractFilePath(FSYNCHRO_NB))+ 'VERSION.ZIP';
   Get_FileAttributes();
   FFileExistVersion_ZIP := FileExists(vVERSION_ZIP);
   if FFileExist_Server_NB
      then Close
      else
        begin
          memTable.Edit;
          memTable.FieldByName('ETAT').asstring := CST_ERROR;
          memTable.Post;
        end;
end;


procedure TForm_ChoixServer.DBGrid1DblClick(Sender: TObject);
var i:integer;
    mouseInGrid : TPoint;
    Coord: TGridCoord;
begin
     If TDBGrid(Sender).DataSource.Dataset.IsEmpty then exit;
     mouseInGrid := TDBGrid(Sender).ScreenToClient(Mouse.CursorPos) ;
     Coord := TDBGrid(Sender).MouseCoord(mouseInGrid.X, mouseInGrid.Y);
     if (Coord.X=-1) or (Coord.Y=-1) then exit;

     SelectionServeur();
end;

procedure TForm_ChoixServer.FitGrid(Grid: TDBGrid);
const C_Add=10;
var
  ds: TDataSet;
  i: Integer;
  w: Integer;
  a: Array of Integer;
begin
  ds := Grid.DataSource.DataSet;
  if Assigned(ds) then
  begin
    ds.DisableControls;
    try
      ds.First;
      SetLength(a, Grid.Columns.Count);
      while not ds.Eof do
      begin
        for I := 0 to Grid.Columns.Count - 1 do
        begin
          if Assigned(Grid.Columns[i].Field) then
          begin
            w :=  Grid.Canvas.TextWidth(ds.FieldByName(Grid.Columns[i].Field.FieldName).DisplayText);
            if a[i] < w  then
               a[i] := w ;
          end;
        end;
        ds.Next;
      end;
      for I := 0 to Grid.Columns.Count - 1 do
        Grid.Columns[i].Width := a[i] + C_Add;
    finally
      ds.EnableControls;
    end;
  end;
end;

(*
procedure TForm_ChoixServer.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
Var
  w : Integer;
begin
  w := 5+DBGrid1.Canvas.TextExtent(Column.Field.DisplayText).cx;
  if w>column.Width then Column.Width := w;
end;

procedure TForm_ChoixServer.FormActivate(Sender: TObject);
var i:integer;
begin
  for I := 0 to DBGrid1.Columns.Count - 1 do
    DBGrid1.Columns[i].Width := 5 + DBGrid1.Canvas.TextWidth(DBGrid1.Columns[i].title.caption)
end;
*)

procedure TForm_ChoixServer.FormCreate(Sender: TObject);
begin
   FSYNCHRO_NB_Default  := '';
   FSYNCHRO_NB          := '';
   FFileSize_Server_NB  := 0;
   FFileExist_Server_NB := False;
end;

procedure TForm_ChoixServer.Remplissage();
var i:integer;
begin
    memTable.Close;
    memTable.open;
    For i:= Low(FSynchroPaths) to High(FSynchroPaths) do
       begin
          if FSynchroPaths[i].Enable then
            begin
              memTable.Append();
              memTable.FieldByName('ID').asinteger := i;
              memTable.FieldByName('NOM').asstring := FSynchroPaths[i].Nom;
              memTable.FieldByName('CHEMIN').asstring := FSynchroPaths[i].Path;
              if UpperCase(FSynchroPaths[i].Path) = UpperCase(FSYNCHRO_NB_Default)
                then
                  begin
                     memTable.FieldByName('ETAT').asstring := CST_ERROR;
                  end;
              memTable.Post;
            end;
       end;
   // FitGrid(DBGrid1);
   // AutoSelect...
   if memTable.RecordCount>0 then
      begin
        memTable.First;
        while not(memTable.eof) do
          begin
             if memTable.FieldByName('ETAT').asstring<>CST_ERROR
               then
                 begin
                    break;
                 end;
             memTable.Next;
          end;

      end;
end;


end.
