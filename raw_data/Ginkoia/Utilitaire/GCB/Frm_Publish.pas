unit Frm_Publish;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.ExtCtrls, Vcl.Buttons,System.JSON, ShellApi,   System.IOUtils;

type
  TPublish_Frm = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ECurrentVersion: TEdit;
    ECurrentUrl: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    Label4: TLabel;
    eNextVersion: TEdit;
    BFERMER: TBitBtn;
    BitBtn1: TBitBtn;
    Label5: TLabel;
    eLocalPath: TEdit;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    eInfoFileURL: TEdit;
    Label8: TLabel;
    eInfoFilePath: TEdit;
    Bevel1: TBevel;
    Label1: TLabel;
    eNewDBLocalfile: TEdit;
    Label6: TLabel;
    eNewURL: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure eNextVersionChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BFERMERClick(Sender: TObject);
  private
    procedure ParseJson(jsonFile:string);
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Publish_Frm: TPublish_Frm;

implementation

{$R *.dfm}

Uses UCommun, UDataMod;

procedure TPublish_Frm.BFERMERClick(Sender: TObject);
begin
    Close;
end;

procedure TPublish_Frm.BitBtn1Click(Sender: TObject);
var
  jo: TJSONObject;
  jp: TJSONPair;
  Lines: TStrings;
  LJSONObj: TJSONObject;
  vOldJson : TStrings;
  vExeVersion : string;
  vExeUrl     : string;

begin
    // Publication
    if (CompareVersion(eNextVersion.Text,ECurrentVersion.Text)<=0) then exit;

    try
      vOldJson :=  TStringList.Create;
      vOldJson.LoadFromFile(eInfoFilePath.text);
      LJsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(vOldJson.Text),0) as TJSONObject;
      if LJsonObj<>nil then
          begin
             // Pour l'Exe
             vExeVersion := (LJsonObj.Get('exe_version').JsonValue).Value;
             vExeUrl     := (LJsonObj.Get('exe_url').JsonValue).Value;
          end;

         Lines := TStringList.Create;
         // Modification dans la base
         DataMod.SetVersionDB_GCB(eNextVersion.Text);

         // Copy du fichier s3db
         TFile.Copy(PChar(eLocalPath.Text),PChar(eNewDBLocalfile.text),true);
         //----------------------------------------
         jo := TJSONObject.Create;
         jp := TJSONPair.Create('dbversion', TJSONString.Create(eNextVersion.Text));
         jo.AddPair(jp);

         jo.AddPair(TJSONPair.Create('url', TJSONString.Create(eNewURL.Text)));

         // --------------------------------------------------------------------
         // recup de l'exe version et du chemin dans le fichier eInfoFilePath.text
         //---------------------------------------------------------------------
         jo.AddPair(TJSONPair.Create('exe_version',vExeVersion));
         jo.AddPair(TJSONPair.Create('exe_url',vExeUrl));
         //---------------------------------------------------------------------

         Lines.Add(jo.ToString);
         Lines.SaveToFile(eInfoFilePath.text);
    finally
         vOldJson.Free;
         Lines.Free
    end;
end;

procedure TPublish_Frm.eNextVersionChange(Sender: TObject);
begin
    if Publish_Frm.Active then
      begin
          eNewDBLocalfile.Text := LocalPath + 'gcb_db_version_' + StringReplace(Tedit(Sender).Text,'.','',[rfReplaceAll]) +  '.zip';
          eNewURL.Text         := UrlPath + 'gcb_db_version_' + StringReplace(Tedit(Sender).Text,'.','',[rfReplaceAll]) +  '.zip';
      end;
     BitBtn1.Enabled:=(CompareVersion(Tedit(Sender).Text,ECurrentVersion.Text)>0);
end;



procedure TPublish_Frm.FormCreate(Sender: TObject);
begin
      // InformationsFileUrl;
      eInfoFileURL.Text  := UrlPath + InformationsFile ;
      eInfoFilePath.Text := LocalPath + InformationsFile;

      // Analyse du fichier json dispo sur
      //
      ParseJson(eInfoFilePath.Text);

end;



procedure TPublish_Frm.ParseJson(jsonFile:string);
var  LJSONObj: TJSONObject;
     json:string;
begin
    json:=LoadFileToStr(jsonFile);
    LJsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(json),0) as TJSONObject;
    try
       if LJsonObj<>nil then
          begin
               ECurrentVersion.Text := (LJsonObj.Get('dbversion').JsonValue).Value;
               ECurrentUrl.text     := (LJsonObj.Get('url').JsonValue).Value;
          end;
    Except On e : Exception do
        begin
          ECurrentVersion.Text := '';
          ECurrentUrl.text     := '';
        end;
    end;
end;



end.
