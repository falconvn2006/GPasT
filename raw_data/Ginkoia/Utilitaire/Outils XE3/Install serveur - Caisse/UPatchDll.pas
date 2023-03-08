unit UPatchDll;

interface

uses Winapi.Windows, Winapi.Messages, SysUtils, System.Variants, System.Classes, System.Types,
  System.IOUtils,IniFiles, Dialogs, StrUtils ,
  //Début Uses Perso
  uFunctions,
  uRessourcestr,
  uSevenZip,
  uLameFileparser,
  uDownloadfromlame,
  uPatchScript,
  uInstallbase,
  uBasetest,
  registry,
  ShlObj,
  Main_Dm,
  ShellAPI,
  RegExpr,
  Informations,
  uToolsXE,
  //Fin Uses Perso
  Vcl.Forms, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Controls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  Vcl.CheckLst;

resourcestring
  { Déclaration des ressources String }
  RS_VERSION_DLL_IB     = 'Version d''InterBase :'#13#10'%s';
  RS_CHEMIN_IB          = 'Chemin du service InterBase :'#13#10'%s';
  RS_SERVICE_EXISTE_PAS = 'Le service n''existe pas.';
const
  SERVICE_IBXE          = 'IBS_gds_db';
  RECUP_CHEMIN          = '^"(.+)"|^(\S+)';

Type

  TPatchDll = class
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  published
    { Déclarations published }
  end;

  Function  VerifDll(LunchInstall : Boolean = False) : Boolean;
  procedure InstallPatch;
  procedure LunchVerif(Auto : Boolean = True);
  procedure DelAppli(DirZip : string);

var
  vVersionInterBase:  TInfoSurExe;
  vInfoService:       TInfoSurService;
  sCheminInterBase:   String;
  sCheminBDD:         String;
  ExprRegServ:        TRegExpr;
  FileInstallBase:    String;

implementation

{ TPatchDll }

procedure InstallPatch;
var
  ResPatch : TResourceStream;
  Reg      : TRegistry;
  sDir     : string;
  Iinstal  : Integer;
begin
  //PatchXE5 Install
  ResPatch := TResourceStream.Create(HInstance, 'PATCH5', RT_RCDATA);
  try
    try
      sDir := ExtractFilePath(Application.ExeName);
      ResPatch.SaveToFile(sDir+'PatchXE5.exe');
      Iinstal := ExecuteAndWait(SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe', '/c "' +  sDir + Format('PatchXE5.exe"',[sDir]));

      if Iinstal <> -1 then
      begin
        ShowMessage('Installation Abandonnée');
      end else
      begin
        if VerifDll(False) then
          ShowMessage('Installation ok')
        else
          ShowMessage('Il y a eu une erreur dans l''installation du patch')
      end;
    Except on E:Exception do
      begin
        raise Exception.Create('Mise à jour de la base de registre Erreur -> ' + E.Message);
      end;
    end;

  finally
    ResPatch.Free;
  end;
end;

function VerifDll(LunchInstall : Boolean = False) : Boolean;
var
  Reg           : TRegistry;
  sDirInterbase, sVersion : String;
  oMsg : TForm;
begin
  //Function
  Result := False;

  Reg := TRegistry.Create(KEY_READ or KEY_WOW64_32KEY);
  Try
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.KeyExists('\Software\Borland\Interbase\Servers\gds_db') then
      begin
        reg.OpenKey('\Software\Borland\Interbase\Servers\gds_db',False);
        sDirInterbase := reg.ReadString('ServerDirectory');
        sDirInterbase := sDirInterbase + '\gds32.dll';
      end;
    Except on E:Exception do
    begin
        raise Exception.Create('Lecture de la base de registre Erreur -> ' + E.Message);
     end;
    end;
  Finally
    Reg.Free;
  End;

  if FileExists(sDirInterbase) then
  begin
    vVersionInterBase := InfoSurExe(sDirInterbase);
    sVersion          := vVersionInterBase.FileVersion;

    if sVersion = 'WI-V10.0.5.595' then
    begin
      //Version Ok
      Result := True;
    end else
    begin
      if LunchInstall then
      begin
        //Lunch Interbase patch Install
        oMsg := CreateMessageDialog('Vous ne disposez pas de la dernière version d''interbase.'#13#10'Voulez-vous installer le patch5 d''interbase', mtConfirmation, [mbOk, mbCancel]);
        oMsg.Position := poOwnerFormCenter;
        oMsg.FormStyle := fsStayOnTop;
        if oMsg.ShowModal = mrOk then
          InstallPatch;

        oMsg.Release;
      end else
      begin
        ShowMessage('Vous ne disposez pas de la dernière version d''interbase');
      end;
    end;

  end;
end;

{ TPatchDll }

procedure LunchVerif(Auto : Boolean = True);
var
  Reg      : TRegistry;
  sDir     : string;
  Iinstal  : Integer;
begin
  //Lunch Verification.exe
  //Seek in registry base
  try

    Reg := TRegistry.Create(KEY_READ or KEY_WOW64_32KEY);
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.KeyExists('\SOFTWARE\Wow6432Node\Algol\Ginkoia') then
      begin
        Reg.OpenKey('\SOFTWARE\Wow6432Node\Algol\Ginkoia', False);
        sDir := Reg.ReadString('BASE0');
        sDir := AnsiLeftStr(sDir, 11);

        if Auto then
          ShellExecute(HInstance,'open',PChar(sDir+VERIFICATION), ' AUTO',nil,SW_SHOWNORMAL)
        else
          ShellExecute(HInstance,'open',PChar(sDir+VERIFICATION), nil,nil,SW_SHOWNORMAL);

      end else
      begin
        ShowMessage('Erreur, vérifier que Ginkoia à été correctement installé');
        Exit;
      end;
    except on e:Exception do
      begin
        raise Exception.Create('Erreur dans la lecture de la base de registre -> ' + e.Message);
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure DelAppli(DirZip : string);
var
  TabFile   : array of string;
  FileToDel : TextFile;
begin

  try
    try
      if FileExists(DirZip) then
      begin
//        AssignFile(FileToDel, DirZip);
        DeleteFile(DirZip);
      end;
    except on E : Exception do
      begin
        ShowMessage(e.Message);
      end;
    end;
  finally

  end;

//  if FileExists(DirZip) then
//    DelFile(DirZip);
end;

end.


