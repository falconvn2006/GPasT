unit uListGversionsDistants;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,System.Json,IdHTTP,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ComCtrls, uDownloadHTTP,
  Vcl.ExtCtrls, Vcl.Buttons,IdURI;

const CST_URL_DownloadVersion = 'http://easy-ftp.ginkoia.net/download_gversion.php?gversion=%s';
      CST_URL_ListVersions    = 'http://easy-ftp.ginkoia.net/list_gversions.php';

type
  TFrm_GversionsDistants = class(TForm)
    mtGversions: TFDMemTable;
    ds: TDataSource;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    ProgressBar1: TProgressBar;
    Bdownload: TButton;
    BActualiser: TBitBtn;
    mtGversionsfilename: TStringField;
    mtGversionsgversion: TStringField;
    mtGversionsmd5: TStringField;
    mtGversionssize: TLargeintField;
    mtGversionslastmodified: TStringField;
    Label1: TLabel;
    procedure BdownloadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BActualiserClick(Sender: TObject);
  private
    FUrl    : string;
    FLocalFile : string;
    FLocalDir  : string;
    FThread : TDownloadThread;
    procedure Parse_Json_Datas(astr:string);
    procedure GetGversionsDistants;
    procedure LanceThread();
    procedure Actualiser();
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_GversionsDistants: TFrm_GversionsDistants;

implementation

{$R *.dfm}

USes UCommun;

procedure TFrm_GversionsDistants.LanceThread();
begin
  try
    FThread := TDownloadThread.Create(FURL, FLocalFile, '', '', '', ProgressBar1);
    while WaitForSingleObject(FThread.Handle, 100) = WAIT_TIMEOUT do
      Application.ProcessMessages();
    // Non on ne ferme pas
    ProgressBar1.Visible:=false;
    Bdownload.Enabled := (TDownloadThread(FThread).ReturnValue=mrOK);
  finally
    FreeAndNil(FThread);
  end;
end;

procedure TFrm_GversionsDistants.BActualiserClick(Sender: TObject);
begin
  Actualiser();
end;

procedure TFrm_GversionsDistants.BdownloadClick(Sender: TObject);
var vLocalMD5:string;
begin
   Bdownload.Enabled := false;
   FLocalFile    := FLocalDir + mtGversions.FieldByName('filename').AsString;
   FUrl := TIdURI.UrlENcode(Format(CST_URL_DownloadVersion,[mtGversions.FieldByName('filename').AsString]));

   if FileExists(FLocalFile)
    then
      begin
         vLocalMD5 :=  Lowercase(MD5File(FLocalFile));
         If (vLocalMD5<>mtGversions.FieldByName('md5').AsString)
           then
             begin
                DeleteFile(FLocalFile);
                LanceThread();
             end
         else
            begin
              MessageDlg('Vous avez déjà cette version',  mtError, [mbOK], 0);
              Bdownload.Enabled := true;
            end;
      end
      else
       begin
        LanceThread();
      end;
end;

procedure TFrm_GversionsDistants.Actualiser();
begin
    BActualiser.Enabled:=False;
    try
      try
        GetGversionsDistants;
      except
        //
      end;
    finally
      BActualiser.Enabled:=true;
    end;
end;

procedure TFrm_GversionsDistants.FormCreate(Sender: TObject);
begin
  FThread   := nil;
  FLocalDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ 'Gversions\';
  Label1.Caption := Format('Répertoire local des versions : %s',[FLocalDir]);
  Actualiser();
end;

procedure TFrm_GversionsDistants.GetGversionsDistants;
var json : string;
    IdHTTP: TIdHTTP;
begin
  IdHTTP        := TIdHTTP.Create;
  json          := '';
  try
    json := IdHTTP.Get(TIdURI.URLEncode(CST_URL_ListVersions));
  finally
    IdHTTP.Free;
  end;
  Parse_Json_Datas(json);
end;



procedure TFrm_GversionsDistants.Parse_Json_Datas(astr:string);
var  LJsonArr   : TJSONArray;
  LJsonValue : TJSONValue;
  LItem     : TJSONValue;
  vItem     : string;
begin
   LJsonArr    := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(aStr),0) as TJSONArray;
   try
     mtGVersions.DisableControls;
     vItem:='';
     If mtGVersions.RecordCount<>0
      then vItem:= mtGVersions.FieldByName('filename').AsVariant;
     mtGVersions.close;
     mtGVersions.Open;
     for LJsonValue in LJsonArr do
     begin
        mtGVersions.Append;
        for LItem in TJSONArray(LJsonValue) do
          begin
              mtGVersions.FieldByName(TJSONPair(LItem).JsonString.Value).AsString:=TJSONPair(LItem).JsonValue.Value;
          end;
        // Label1.Caption:=Format('Dernière Récupération Maintenance : %s',[FDMemTable1.FieldByName('LASTUPDATE').Asstring]);
        // Label1.Refresh;
        mtGVersions.post;
     end;
   finally
     LJsonArr.DisposeOf;
   end;


   If not(mtGVersions.Locate('filename',vItem,[]))
    then mtGVersions.First;
   mtGVersions.EnableControls;



end;



end.
