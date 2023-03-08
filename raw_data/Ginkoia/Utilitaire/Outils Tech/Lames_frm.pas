unit Lames_frm;

interface

uses
   UCst,
   Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
   Buttons, ExtCtrls, IpUtils, IpSock, IpHttp, IpHttpClientGinkoia,
   IniFiles;

type
   Tfrm_lames = class(TForm)
      Bevel1: TBevel;
      Label1: TLabel;
      Label2: TLabel;
      Label3: TLabel;
      cb_machine: TComboBox;
      cb_centrale: TComboBox;
      Ed_Client: TEdit;
      BitBtn2: TBitBtn;
      BitBtn1: TBitBtn;
      Http: TIpHttpClientGinkoia;
      procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
   private
     FUNCTION LecteurValeurIni(AFileIni,ASection,AIdent,ADefault:String):String;

    { Private declarations }
   public
    { Public declarations }
   end;

var
   frm_lames: Tfrm_lames;

implementation

{$R *.DFM}

procedure Tfrm_lames.BitBtn1Click(Sender: TObject);
var
   tsl: tstringlist;
   s:string ;
begin
  //
   if trim(cb_machine.Text) = '' then
   begin
      application.MessageBox('La machine d''installation est obligatoire', '  Erreur', Mb_ok);
   end
   else if trim(cb_centrale.Text) = '' then
   begin
      application.MessageBox('La centrale est obligatoire', '  Erreur', Mb_ok);
   end
   else if trim(Ed_Client.Text) = '' then
   begin
      application.MessageBox('Le nom du client est obligatoire', '  Erreur', Mb_ok);
   end
   else
   begin
      // vérifier qu'il n'existe pas déjà
      s := URL + 'ChxBase' + '?PATH=' + '\\' + cb_machine.Text + '\'+LecteurLame+'$\EAI\' + cb_centrale.Text + '\' + Ed_Client.Text;
      s := traitechaine(s) ;
      Http.OldGetWaitTimeOut(s, 30000);
      tsl := tstringlist.create;
      tsl.Text := Http.AsString(s);
      if tsl.Count > 1 then
      begin
         application.MessageBox('Le client existe déjà', '  Erreur', Mb_ok);
      end
      else
         modalresult := MrOk;
      tsl.free;
   end;
end;

procedure Tfrm_lames.FormCreate(Sender: TObject);
VAR
  sListFilePath : String;
begin
  sListFilePath := ExtractFilePath(paramStr(0)) + 'ListeMachine.lst';
  if FileExists(ExtractFilePath(paramStr(0)) + 'ListeMachine.lst') then
    cb_machine.Items.LoadFromFile(sListFilePath);

  //LecteurLame := LecteurValeurIni(IncludeTrailingPathDelimiter(ExtractFilePath(paramstr(0)))+'InstallClient.ini','GENERAL','LecteurLame','F');
end;

function Tfrm_lames.LecteurValeurIni(AFileIni, ASection, AIdent,
  ADefault: String): String;
Var
  FichierIni  : TIniFile;
begin
  Try
    //Ouverture ou création du fichier ini
    FichierIni  := TIniFile.Create(AFileIni);

    //Lecteur de la valeur
    Result := FichierIni.ReadString(ASection, AIdent, ADefault);
  Finally
    FichierIni.Free;
    FichierIni  := nil;
  End;
end;

end.

