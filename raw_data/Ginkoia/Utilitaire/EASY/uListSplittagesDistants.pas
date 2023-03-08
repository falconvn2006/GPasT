unit uListSplittagesDistants;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,System.Json,IdHTTP,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ComCtrls, uDownloadHTTP,
  Vcl.ExtCtrls, Vcl.Buttons,Winapi.ShellAPI,uSevenZip,System.IOUtils;

type
  TFrm_SplittagesDistants = class(TForm)
    mtSplits: TFDMemTable;
    mtSplitsdossier: TStringField;
    mtSplitsfilename: TStringField;
    mtSplitsfilesize: TLargeintField;
    mtSplitssplittype: TStringField;
    mtSplitsfilelastmodified: TStringField;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    ProgressBar1: TProgressBar;
    Bdownload: TButton;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    sb_status: TStatusBar;
    Button1: TButton;
    procedure RecupClick(Sender: TObject);
    procedure BdownloadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FUrl         : string;
    FNomPourNous : string;
    FAutoClose   : boolean;
    FInstallDB   : boolean;
    FDatabaseFile : string;
    FLocalDir    : string;
    FLocalFile   : string;
    FUnzip       : boolean;
    FSizeItem    : Integer;
    FThread : TDownloadThread;
    procedure Parse_Json_Datas(astr:string);
    procedure GetSplittagesDistants;
    procedure LanceThread();
    procedure Un7zSplitFile(zipFullFname:string);
    procedure MoveIBFile();

    { Déclarations privées }
  public
    property NomPourNous : string  read FNomPourNous write FNomPourNous;
    property AutoClose   : Boolean read FAutoClose   write FAutoClose;
    property Unzip       : Boolean read FUnzip       write Funzip;
    property LocalFile   : string  read FLocalFile   write FLocalFile;
    property SizeItem    : Integer read FSizeItem    write FSizeItem;
    property InstallDB   : boolean read FInstallDB   write FInstallDB;
    property DataBaseFile: string  read FDatabaseFile write FDataBaseFile;
    { Déclarations publiques }
  end;
  function ProgressCallback(sender: Pointer; total: boolean; value: int64): HRESULT; stdcall;

var
  Frm_SplittagesDistants: TFrm_SplittagesDistants;

implementation

{$R *.dfm}

function ProgressCallback(sender: Pointer; total: boolean; value: int64): HRESULT; stdcall;
 begin
   if total
    then
        begin
            Frm_SplittagesDistants.ProgressBar1.Max := 1000;
            Frm_SplittagesDistants.SizeItem    := value;
        end
    else
        begin
          if (Frm_SplittagesDistants.SizeItem)<>0
            then Frm_SplittagesDistants.ProgressBar1.Position := Round(value*1000/Frm_SplittagesDistants.SizeItem)
            else Frm_SplittagesDistants.ProgressBar1.Position := 0;
        end;
   Application.ProcessMessages;
   Result := S_OK;
 end;



procedure TFrm_SplittagesDistants.LanceThread();
begin
  try
    FThread := TDownloadThread.Create(FURL, FLocalFile, '', '', '', ProgressBar1);
    while WaitForSingleObject(FThread.Handle, 100) = WAIT_TIMEOUT do
      Application.ProcessMessages();

    if Unzip
     then
        begin
          Un7zSplitFile(FLocalFile);
        end;

    Bdownload.Enabled := (TDownloadThread(FThread).ReturnValue=mrOK);
    ProgressBar1.Position:=ProgressBar1.Max;
  finally
    FreeAndNil(FThread);
  end;
end;

procedure TFrm_SplittagesDistants.RecupClick(Sender: TObject);
begin
    GetSplittagesDistants;
end;

procedure TFrm_SplittagesDistants.BdownloadClick(Sender: TObject);
begin
   Bdownload.Enabled := false;
   ProgressBar1.Position:=0;
   FLocalFile     :=  FlocalDir + mtSplits.FieldByName('filename').AsString;
   FUrl :=
    {
    Format('http://easy-ftp.ginkoia.net/download_split.php?dossier=%s&filename=%s',[
    mtSplits.FieldByName('dossier').AsString,
    mtSplits.FieldByName('filename').AsString
      ]);
    }
    Format('http://easy-ftp.ginkoia.net/%s/%s',[
    mtSplits.FieldByName('dossier').AsString,
    mtSplits.FieldByName('filename').AsString
      ]);

   if FileExists(FLocalFile)
      then DeleteFile(FLocalFile);
   LanceThread();

   If (FInstallDB) and (FDatabaseFile<>'') and (not(FileExists(FDatabaseFile)))
     then
        begin
           MoveIBFile();
        end;

   ModalResult := mrOK;
   If AutoClose
     then Close;
end;



procedure TFrm_SplittagesDistants.MoveIBFile();
var vIBFile:string;
    searchResult: TSearchRec;
    i:Integer;
begin
    i:=0;
    if findfirst(IncludeTrailingPathDelimiter(FLocalDir)+'*.ib', faAnyFile, searchResult) = 0 then
      begin
        repeat
           vIBFile := IncludeTrailingPathDelimiter(FLocalDir) + searchResult.Name;
           Inc(i);
        until FindNext(searchResult) <> 0;
      end;
    if (i=0) then
      begin
        exit;
      end;
    if (i>1) then
      begin
        exit;
      end;
    TFile.Move(vIBFile,DatabaseFile);
end;


procedure TFrm_SplittagesDistants.Un7zSplitFile(zipFullFname:string);
var outDir:string;
begin
    with CreateInArchive(CLSID_CFormat7z) do
    begin
      SetPassword('ch@mon1x');
      OpenFile(zipFullFname);

      SetProgressCallback(ProgressBar1, ProgressCallback);
      outDir := FlocalDir;
      ExtractTo(outDir);
    end;
end;



procedure TFrm_SplittagesDistants.BitBtn1Click(Sender: TObject);
begin
   TBitBtn(Sender).Enabled:=false;
   GetSplittagesDistants;
   TBitBtn(Sender).Enabled:=true;
end;

procedure TFrm_SplittagesDistants.Button1Click(Sender: TObject);
begin
    ShellExecute(Application.Handle,
               PChar('explore'),
               PChar(FlocalDir),
               nil,
               nil,
               SW_SHOWNORMAL);
end;

procedure TFrm_SplittagesDistants.FormCreate(Sender: TObject);
begin
  FThread := nil;
  FNompourNous  := '';
  FAutoClose    := false;
  FUnzip        := false;
  FInstallDB    := false;
  FDatabaseFile := '';
  FlocalDir     := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ 'split\';
  Label1.Caption := Format('Répertoire local des splits : %s',[FlocalDir]);
end;

procedure TFrm_SplittagesDistants.FormShow(Sender: TObject);
begin
  GetSplittagesDistants;
end;

procedure TFrm_SplittagesDistants.GetSplittagesDistants;
var json : string;
    IdHTTP: TIdHTTP;
    vUrl : Widestring;
begin
  IdHTTP        := TIdHTTP.Create;
  json          := '';
  try
    vUrl := 'http://easy-ftp.ginkoia.net/list_splits.php';
    if NomPourNous<>''
      then vUrl := vUrl + '?dossier='+ LowerCase(NomPourNous);
    json := IdHTTP.Get(vUrl);
  finally
    IdHTTP.Free;
  end;
  // On parse maintenant
  Parse_Json_Datas(json);
end;

procedure TFrm_SplittagesDistants.Parse_Json_Datas(astr:string);
var  vJSONScenario: TJSONValue;
     LJsonArr   : TJSONArray;
     LJsonValue : TJSONValue;
     LItem     : TJSONValue;
     vItem     : string;
begin
   try
     vJSONScenario :=  TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(aStr),0);
     if vJSONScenario<>nil then
      begin
        try
          LJsonArr    := vJSONScenario as TJSONArray;
          mtSplits.DisableControls;
          vItem:='';
          If mtSplits.RecordCount<>0
           then vItem:= mtSplits.FieldByName('filename').AsVariant;
          mtSplits.close;
          mtSplits.Open;
          for LJsonValue in LJsonArr do
           begin
              mtSplits.Append;
              for LItem in TJSONArray(LJsonValue) do
                begin
                    mtSplits.FieldByName(TJSONPair(LItem).JsonString.Value).AsString:=TJSONPair(LItem).JsonValue.Value;
                end;
              // Label1.Caption:=Format('Dernière Récupération Maintenance : %s',[FDMemTable1.FieldByName('LASTUPDATE').Asstring]);
              // Label1.Refresh;
              mtSplits.post;
           end;
           If not(mtSplits.Locate('filename',vItem,[]))
            then mtSplits.First;
           mtSplits.EnableControls;
         finally
          vJSONScenario.DisposeOf;
         end;
      end;
   Except
     //
   end;
end;



end.
