//$Log:
// 5    Utilitaires1.4         23/09/2010 09:20:35    Florent CHEVILLON Ajout
//      du /DEBUG pour afficher les traces
// 4    Utilitaires1.3         08/07/2010 17:22:46    Florent CHEVILLON
//      Migration et modification suite demande JML (install nouvelle version
//      d'OCS)
// 3    Utilitaires1.2         26/09/2006 11:02:54    pascal          rendu des
//      modifs
// 2    Utilitaires1.1         22/08/2006 10:40:09    pascal          Sup des
//      fichiers pour ?viter les prob
// 1    Utilitaires1.0         06/07/2006 08:39:10    pascal          
//$
//$NoKeywords$
//

UNIT UInstOCS;

INTERFACE

USES
  registry,
  rxFileUtil,
  inifiles,
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ZipMstr,
  ExtCtrls,
  ComCtrls,
  StdCtrls,
  DFClasses,
  Db,
  IBCustomDataSet,
  IBQuery,
  IBDatabase,
  RzBckgnd;

TYPE
  TBaseInfo = RECORD
    sBase: STRING;
    sMag: STRING;
  END;

TYPE
  TFrm_InstOCS = CLASS(TForm)
    Zip: TZipMaster;
    Label1: TLabel;
    pb: TProgressBar;
    data: TIBDatabase;
    tran: TIBTransaction;
    qry: TIBQuery;
    RzBackground1: TRzBackground;
    PROCEDURE InstallOCS();
    PROCEDURE MajLabels();
    PROCEDURE DelEveryThing;
    PROCEDURE ZipTotalProgress(Sender: TObject; TotalSize: Int64;
      PerCent: Integer);
  PRIVATE
    { Déclarations privées }
  PUBLIC
    { Déclarations publiques }
  END;

VAR
  Frm_InstOCS: TFrm_InstOCS;

FUNCTION OcsIsInstall: boolean;
FUNCTION GetBaseInfo(VAR ABaseInfo: TBaseInfo): boolean;

IMPLEMENTATION

{$R *.DFM}

FUNCTION OcsIsInstall: boolean;
VAR
  reg: TRegistry;
BEGIN
  reg := TRegistry.create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', false);
  result := reg.ReadString('OCS-Inst') <> '';
  IF result THEN
  BEGIN
    reg.closekey;
    reg.OpenKey('SOFTWARE\Algol\ginkoia', true);
    result := reg.ReadString('OCS-Inst-Ver') = '2';
  END;
  reg.free;
END;

FUNCTION GetBaseInfo(VAR ABaseInfo: TBaseInfo): boolean;
VAR
  sPathIni: STRING;
  bIniTrouve: Boolean;
  fFicIni: TIniFile;

BEGIN
  Result := False;

  // Init variables
  sPathIni := '';
  ABaseInfo.sBase := '';
  ABaseInfo.sMag := '';

  sPathIni := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName));
  IF FileExists(sPathIni + 'ginkoia.ini') THEN
  BEGIN
    sPathIni := sPathIni + 'ginkoia.ini';
    bIniTrouve := True;
  END ELSE IF FileExists(sPathIni + 'caisseginkoia.ini') THEN
  BEGIN
    sPathIni := sPathIni + 'caisseginkoia.ini';
    bIniTrouve := True;
  END
  ELSE BEGIN
    bIniTrouve := False;
  END;

  IF bIniTrouve THEN
  BEGIN

    fFicIni := tinifile.Create(sPathIni);

    ABaseInfo.sBase := fFicIni.ReadString('DATABASE', 'PATH0', '');
    ABaseInfo.sMag := fFicIni.ReadString('NOMMAGS', 'MAG0', '');

    IF ABaseInfo.sBase = '' THEN
    BEGIN
      ABaseInfo.sBase := fFicIni.ReadString('DATABASE', 'PATH1', '');
      ABaseInfo.sMag := fFicIni.ReadString('NOMMAGS', 'MAG1', '');
    END;

    IF ABaseInfo.sBase = '' THEN
    BEGIN
      ABaseInfo.sBase := fFicIni.ReadString('DATABASE', 'PATH2', '');
      ABaseInfo.sMag := fFicIni.ReadString('NOMMAGS', 'MAG2', '');
    END;

    IF ABaseInfo.sBase <> '' THEN
    BEGIN
      if FileExists(ABaseInfo.sBase) then
      begin
        Result := True;
      end;
    END;
  END;

END;

FUNCTION enleveblc(s: STRING): STRING;
BEGIN
  WHILE pos(' ', S) > 0 DO
    s[pos(' ', S)] := '_';
  result := S;
END;

PROCEDURE TFrm_InstOCS.DelEveryThing;
VAR
  srFic: TSearchRec;
BEGIN
  ForceDirectories('C:\ocs-ng');
  IF FindFirst('C:\ocs-ng\*.*', faAnyFile, srFic) = 0 THEN
  BEGIN
    REPEAT
      IF srFic.Attr AND faDirectory <> faDirectory THEN
      BEGIN
        FileSetAttr('C:\ocs-ng\' + srFic.name, faArchive);
        DeleteFile('C:\ocs-ng\' + srFic.name);
      END;
    UNTIL FindNext(srFic) <> 0;
  END;
  FindClose(srFic);
END;

PROCEDURE TFrm_InstOCS.InstallOCS;
VAR
  stBase: TBaseInfo;

  CENTRALE, VIL_NOM, NOMPOURNOUS: STRING;
  BASGUID, BASNOM: STRING;

  tsl: tStringList;
  reg: TRegistry;
BEGIN
  // Met tous les fichiers avec l'attribut A
  DelEveryThing;

  // Lecture de l'ini
  IF NOT GetBaseInfo(stBase) THEN
  BEGIN
    Close;
    Exit;
  END;

  // Connexion à la base
  Data.DatabaseName := stBase.sBase;
  Data.Open;

  // Récup des infos pour le label
  Qry.sql.clear;
  Qry.sql.add('select BAS_CENTRALE, VIL_NOM, BAS_NOMPOURNOUS, BAS_NOM, BAS_GUID');
  Qry.sql.add('from genbases join genparambase on (par_string=BAS_ident), ');
  Qry.sql.add('     genmagasin join genadresse on (adr_id=mag_adrid) ');
  Qry.sql.add('                join genville on (vil_id=adr_vilid) ');
  Qry.sql.add('where par_nom=''IDGENERATEUR'' ');
  Qry.sql.add('and mag_nom=' + quotedstr(stBase.sMag));
  Qry.Open;
  CENTRALE := Qry.fields[0].AsString;
  VIL_NOM := Qry.fields[1].AsString;
  NOMPOURNOUS := Qry.fields[2].AsString;
  BASNOM := Qry.fields[3].AsString;
  BASGUID := Qry.fields[4].AsString;

  // Infos erronées, on ne fait rien
  IF (centrale = '') OR (NOMPOURNOUS = '') THEN
  BEGIN
    Qry.Close;
    Data.Close;
    close;
    EXIT;
  END;

  IF VIL_NOM = '' THEN
    VIL_NOM := 'Ville_non_renseignee';

  // Extraction du zip
  zip.ZipFileName := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName)) + 'BPL\ocs-ng.zip';
  zip.Extract;

  // Création du label
  tsl := tstringlist.create;
  tsl.add(enleveblc(NOMPOURNOUS + '_' + VIL_NOM + '_' + CENTRALE + '_' + BASNOM));
  tsl.savetofile('c:\ocs-ng\label');
  tsl.clear;
  tsl.add('[OCS Inventory Agent]');
  tsl.add('TAG=' + enleveblc(NOMPOURNOUS + '_' + VIL_NOM + '_' + CENTRALE + '_' + BASNOM));
  tsl.add('Nom_du_Client=' + enleveblc(NOMPOURNOUS));
  tsl.add('ville=' + enleveblc(VIL_NOM));
  tsl.add('GUID=' + enleveblc(BASGUID));
  tsl.add('Emplacement=');
  tsl.add('Date_de_Mise_En_Service=00/00/0000');
  tsl.savetofile('c:\ocs-ng\admininfo.conf');
  tsl.free;

  // Sauvegarde de l'install
  reg := TRegistry.create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', false);
  reg.WriteString('OCS-Inst', 'c:\ocs-ng\194.206.223.10.exe /DEBUG');
  reg.closekey;
  reg.OpenKey('SOFTWARE\Algol\ginkoia', true);
  reg.WriteString('OCS-Inst-Ver', '2');
  reg.free;

  Qry.Close;
  Data.Close;
  close;
END;

PROCEDURE TFrm_InstOCS.MajLabels;
VAR
  stBase: TBaseInfo;
  CENTRALE, VIL_NOM, NOMPOURNOUS: STRING;
  BASGUID, BASNOM: STRING;
  tsl: tstringlist;

  sLabel : string;

  bReWriteLab : Boolean;

BEGIN
  IF NOT GetBaseInfo(stBase) THEN
  BEGIN
    Close;
    Exit;
  END;

  Data.DatabaseName := stBase.sBase;
  Data.Open;

  qry.sql.clear;
  qry.sql.add('select BAS_CENTRALE, VIL_NOM, BAS_NOMPOURNOUS, BAS_NOM, BAS_GUID');
  qry.sql.add('from genbases join genparambase on (par_string=BAS_ident), ');
  qry.sql.add('     genmagasin join genadresse on (adr_id=mag_adrid) ');
  qry.sql.add('                join genville on (vil_id=adr_vilid) ');
  qry.sql.add('where par_nom=''IDGENERATEUR'' ');
  qry.sql.add('and mag_nom=' + quotedstr(stBase.sMag));
  qry.Open;
  CENTRALE := qry.fields[0].AsString;
  VIL_NOM := qry.fields[1].AsString;
  NOMPOURNOUS := qry.fields[2].AsString;
  BASNOM := qry.fields[3].AsString;
  BASGUID := qry.fields[4].AsString;
  IF (centrale = '') OR (NOMPOURNOUS = '') THEN
  BEGIN
    Qry.Close;
    Data.Close;
    close;
    EXIT;
  END;

  // Construction du label
  IF VIL_NOM = '' THEN
    VIL_NOM := 'Ville_non_renseignee';
  sLabel := EnleveBlc(NOMPOURNOUS + '_' + VIL_NOM + '_' + CENTRALE + '_' + BASNOM);

  tsl := TStringList.Create;
  try
    bReWriteLab := True;
    if FileExists('c:\ocs-ng\label') then
    begin
      tsl.LoadFromFile('c:\ocs-ng\label');
      if tsl[0] = sLabel then
      begin
        // Le label n'a pas changé, on touche pas
        bReWriteLab := False;
      end;
    end;
    if bReWriteLab then
    begin
      tsl.clear;
      tsl.Add(sLabel);
      tsl.savetofile('c:\ocs-ng\label');
      tsl.clear;
      tsl.add('[OCS Inventory Agent]');
      tsl.add('TAG=' + sLabel);
      tsl.add('Nom_du_Client=' + enleveblc(NOMPOURNOUS));
      tsl.add('ville=' + enleveblc(VIL_NOM));
      tsl.add('GUID=' + enleveblc(BASGUID));
      tsl.add('Emplacement=');
      tsl.add('Date_de_Mise_En_Service=00/00/0000');
      tsl.savetofile('c:\ocs-ng\admininfo.conf');
    end;
  finally
    tsl.Free;
  end;
  Qry.Close;
  Data.Close;
  close;

END;

PROCEDURE TFrm_InstOCS.ZipTotalProgress(Sender: TObject; TotalSize: Int64;
  PerCent: Integer);
BEGIN
  Pb.Position := PerCent;
END;

END.

