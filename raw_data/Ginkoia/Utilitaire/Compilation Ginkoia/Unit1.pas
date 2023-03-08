unit Unit1;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Registry, Forms,
  FileCtrl, Dialogs, StdCtrls, Math, Mask, IniFiles, ExtCtrls, uDefs, StrUtils,
  ComCtrls, Buttons, Menus, LaunchProcess;

type
  TReturn = (rOk, rNok, rWrongParam);

  TFrm_Main = class(TForm)
    Memo: TMemo;
    Panel: TPanel;
    cb_debug: TCheckBox;
    cb: TCheckBox;
    Button1: TButton;
    Btn_GenerateVersion: TButton;
    EditVersion: TEdit;
    Lab_Version: TLabel;
    Chk_SignerExecutable: TCheckBox;
    Chk_SHA256: TCheckBox;
    Chk_URLServeurHorodatage: TCheckBox;
    Chk_DetailsSignature: TCheckBox;
    Chk_trad: TCheckBox;
    feCompilation: TEdit;
    EditURLServeurHorodatage: TEdit;
    EditCertificat: TEdit;
    FileOpenDialog1: TFileOpenDialog;
    Button2: TButton;
    procedure AlgolStdFrmCreate(Sender: TObject);
    procedure AlgolStdFrmDestroy(Sender: TObject);
    procedure Btn_GenerateVersionClick(Sender: TObject);
    procedure Chk_SignerExecutableClick(Sender: TObject);
    procedure EditCertificatChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    _sMotDePasseCertificat: string;
    function ListeDCP(aDebug: boolean): TstringList;
    function ChercheChaine(var f: file; S: string): boolean;
    function FindString(var stFile: TFileStream; sFind: string): boolean;
    function GetVersionBase(aVersion: string): TVersion;
    function GetFileListFromDPR(sFileName: string): TstringList;
    function FindInDfm(var lst: TstringList; sObjName, sPropName, sChangeText: string; bInsert: boolean = false): boolean;
    procedure AddToMemo(Mm: TMemo; sText: string);
    function TraitementCertificat(const aFichier: string; aSilent, aSign: boolean; aPassword, aCertificat, aURLServeurHorodatage: string; aCheckURL, aDetail, aSHA256: boolean): boolean;
    function SignerFichier(const aFichier, aCertificat, aMotDePasse, aURLServeurHorodatage: string; aSilent, aCheckURL, aDetail, aSHA256: boolean): boolean;
    procedure readIni;
    procedure saveIni;
    function doVersion(aSilent, aDebug, aTrad, aClean: boolean; aVersion, aCompileFile: string; aSign: boolean; aPassword, aCertificat, aURLServeurHorodatage: string; aCheckURL, aDetail, aSHA256: boolean): boolean;
    procedure Auto;
    procedure ShowHelp;
    procedure Log(aSilent: boolean; aTxt: string);
    procedure Return(aSilent: boolean; aCode: TReturn);
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

var
  Frm_Main: TFrm_Main;

implementation

uses
  UnitMotDePasseCertificat, NetEncoding;
{$R *.DFM}

function TFrm_Main.ListeDCP(aDebug: boolean): TstringList;
var
  f: TSearchRec;
begin
  result := TstringList.create;
  if FindFirst('C:\Developpement\Paquets standards\*.dcp', faAnyFile, f) = 0 then
  begin
    repeat
      if (f.Name <> '.') and (f.Name <> '..') then
      begin
        result.add(changefileext(f.Name, ''));
        if aDebug then
        begin
          Memo.lines.add('C:\Developpement\Paquets standards\*.dcp  ' + f.Name);
        end;
      end
    until FindNext(f) <> 0;
  end;
  FindClose(f);
  if FindFirst('C:\Developpement\Ginkoia\source\Paquets\*.dcp', faAnyFile, f) = 0 then
  begin
    repeat
      if (f.Name <> '.') and (f.Name <> '..') then
      begin
        result.add(changefileext(f.Name, ''));
        if aDebug then
        begin
          Memo.lines.add('C:\Developpement\Ginkoia\source\Paquets\*.dcp  ' + f.Name);
        end;
      end;
    until FindNext(f) <> 0;
  end;
  FindClose(f);
  if FindFirst('C:\Developpement\Ginkoia\source\Caisse\Paquets\*.dcp', faAnyFile, f) = 0 then
  begin
    repeat
      if (f.Name <> '.') and (f.Name <> '..') then
      begin
        result.add(changefileext(f.Name, ''));
        if aDebug then
        begin
          Memo.lines.add('C:\Developpement\Ginkoia\source\Caisse\Paquets\*.dcp  ' + f.Name);
        end;
      end;
    until FindNext(f) <> 0;
  end;
  FindClose(f);
end;

procedure TFrm_Main.Log(aSilent: boolean; aTxt: string);
begin
  if aSilent then
    Writeln(AnsiToUtf8('Log ' + aTxt))
  else
    AddToMemo(Memo, aTxt);
end;

procedure TFrm_Main.readIni;
var
  ini: TIniFile;
begin
  ini := TIniFile.create(changefileext(Application.exename, '.ini'));
  try
    cb.Checked := (ini.ReadInteger('Version', 'Clean', 0) = 1);
    Chk_trad.Checked := (ini.ReadInteger('Version', 'Trad', 0) = 1);
    cb_debug.Checked := (ini.ReadInteger('Version', 'Debug', 0) = 1);
    EditVersion.text := ini.readString('Version', 'Version', '');
    feCompilation.text := ini.readString('Version', 'Directory', '');
    Chk_SignerExecutable.Checked := (ini.ReadInteger('Version', 'Signature', 0) = 1);
    EditCertificat.text := ini.readString('Paramètres', 'Certificat', '');
    EditURLServeurHorodatage.text := ini.readString('Paramètres', 'URL serveur horodatage', '');
    Chk_URLServeurHorodatage.Checked := (ini.ReadInteger('Paramètres', 'Serveur horodatage', 0) = 1);
    Chk_DetailsSignature.Checked := (ini.ReadInteger('Paramètres', 'Détails signature', 0) = 1);
    Chk_SHA256.Checked := (ini.ReadInteger('Paramètres', 'SHA 256', 0) = 1);
  finally
    ini.Free;
  end;
end;

procedure TFrm_Main.Return(aSilent: boolean; aCode: TReturn);
begin
  if aSilent then
  begin
    Writeln(AnsiToUtf8('Return ' + inttostr(ord(aCode))));
    ExitCode := ord(aCode);
  end;
end;

procedure TFrm_Main.saveIni;
var
  ini: TIniFile;
begin
  ini := TIniFile.create(changefileext(Application.exename, '.ini'));
  try
    ini.WriteInteger('Version', 'Clean', IfThen(cb.Checked, 1));
    ini.WriteInteger('Version', 'Trad', IfThen(Chk_trad.Checked, 1));
    ini.WriteInteger('Version', 'Debug', IfThen(cb_debug.Checked, 1));
    ini.WriteString('Version', 'Version', EditVersion.text);
    ini.WriteString('Version', 'Directory', feCompilation.text);
    ini.WriteInteger('Version', 'Signature', IfThen(Chk_SignerExecutable.Checked, 1));
    ini.WriteString('Paramètres', 'Certificat', EditCertificat.text);
    ini.WriteString('Paramètres', 'URL serveur horodatage', EditURLServeurHorodatage.text);
    ini.WriteInteger('Paramètres', 'Serveur horodatage', IfThen(Chk_URLServeurHorodatage.Checked, 1));
    ini.WriteInteger('Paramètres', 'Détails signature', IfThen(Chk_DetailsSignature.Checked, 1));
    ini.WriteInteger('Paramètres', 'SHA 256', IfThen(Chk_SHA256.Checked, 1));
  finally
    ini.Free;
  end;
end;

function TFrm_Main.ChercheChaine(var f: file; S: string): boolean;
var
  posi: integer;
  ch: char;
begin
  seek(f, 0);
  posi := 1;
  result := false;
  repeat
    BlockRead(f, ch, 1);
    if posi > Length(S) then
    begin
      result := true;
      break;
    end;
    if ch <> #00 then
    begin
      if ch = S[posi] then
        inc(posi)
      else
        posi := 1;
    end;
  until eof(f);
end;

procedure TFrm_Main.Chk_SignerExecutableClick(Sender: TObject);
begin
  Chk_DetailsSignature.Visible := Chk_SignerExecutable.Checked;
  Chk_SHA256.Visible := Chk_SignerExecutable.Checked;
  EditCertificat.Visible := Chk_SignerExecutable.Checked;
  Chk_URLServeurHorodatage.Visible := Chk_SignerExecutable.Checked;
  EditURLServeurHorodatage.Visible := Chk_SignerExecutable.Checked;
end;

function TFrm_Main.doVersion(aSilent, aDebug, aTrad, aClean: boolean; aVersion, aCompileFile: string; aSign: boolean; aPassword, aCertificat, aURLServeurHorodatage: string; aCheckURL, aDetail, aSHA256: boolean): boolean;

  procedure Info(aTxt: string);
  begin
    if aSilent then
      Writeln(AnsiToUtf8(aTxt))
    else
      Showmessage(aTxt);
  end;

var
  i, j, l: integer;
  sDirDCU, sDirVersion, sDirVerBPL, sDirVerMap, sDestDir: string;
  lstCompilation, lstOldScript, lstScript, lstCFG, lstTmp, lstFile: TstringList;
  sLigne, sFileCFG, sFileDest: string;
  sTrad1, sTrad2, sErreur: string;
  FFile: TFileStream;
  VersionBase: TVersion;
  VersionComp: TVersion;
  SearchFile: TSearchRec;
  bFound, bChange: boolean;
begin
  result := false;
  Panel.Enabled := false;
  Btn_GenerateVersion.Enabled := false;
  try
    if aCompileFile = '' then
    begin
      Info('Veuillez sélectionner un fichier de compilation de version');
      Exit;
    end;

    if not FileExists(AnsiDequotedStr(aCompileFile, '"')) then
    begin
      Info('Le fichier n''existe pas');
      Exit;
    end;

    Memo.Clear;

      // Génération des répertoires de destination
    sDirDCU := 'c:\DCU\';
    sDirVersion := 'c:\V' + aVersion + '\';
    sDirVerBPL := 'c:\V' + aVersion + '\BPL\';
    sDirVerMap := 'c:\FichierMap\V' + aVersion + '\';

      // Traitement du numéro de version saisi
    VersionComp.VersionComplet := StringReplace(Trim(aVersion), ' ', '', [rfReplaceAll]);
    VersionComp.VersionVirgul := StringReplace(VersionComp.VersionComplet, '.', ',', [rfReplaceAll]);
    lstTmp := TstringList.create;
    try
      lstTmp.text := StringReplace(VersionComp.VersionComplet, '.', #13#10, [rfReplaceAll]);
      VersionComp.VersionDecoupe.A := lstTmp[0];
      VersionComp.VersionDecoupe.B := lstTmp[1];
      VersionComp.VersionDecoupe.C := lstTmp[2];
      VersionComp.VersionDecoupe.D := lstTmp[3];
      VersionComp.VersionDecoupe.iA := StrToIntDef(lstTmp[0], 0);
      VersionComp.VersionDecoupe.iB := StrToIntDef(lstTmp[1], 0);
      VersionComp.VersionDecoupe.iC := StrToIntDef(lstTmp[2], 0);
      VersionComp.VersionDecoupe.iD := StrToIntDef(lstTmp[3], 0);
    finally
      lstTmp.Free;
    end;

    ForceDirectories(sDirDCU);
    ForceDirectories(sDirVerBPL);
    ForceDirectories(sDirVerMap);

      // Nettoyage des répertoires
    if aClean then
    begin
      with TstringList.create do
      try
        add('Del ' + GAPPPATH + 'deux.txt');
        add('Del C:\dcu\*.dcu');
        add('Del "C:\Developpement\Paquets standards\*.dcp"');
        add('Del "C:\Developpement\Ginkoia\source\Paquets\*.dcp"');
        add('Del "C:\Developpement\Ginkoia\source\Caisse\Paquets\*.dcp"');
        add('dir *.* > "' + GAPPPATH + 'un.txt"');
        add('Copy "' + GAPPPATH + 'un.txt" "' + GAPPPATH + 'deux.txt"');
        Savetofile(GAPPPATH + 'go.bat');

        ExecuteAndWait(GAPPPATH + 'go.bat');
      finally
        Free;
      end;
    end;

      // Récupération du fichier de version et traitement
    lstCompilation := TstringList.create;
    try
      lstCompilation.LoadFromFile(AnsiDequotedStr(aCompileFile, '"'));

      for i := 0 to lstCompilation.Count - 1 do
      begin
        sLigne := Trim(lstCompilation[i]);

          // On ne traite pas les lignes qui commence par des ; ni les vide
        if (Trim(sLigne) = '') or (sLigne[1] = ';') then
          Continue;

        Log(aSilent, 'Traitement : ' + sLigne);

        sDestDir := sDirVersion;
        if Pos(';', sLigne) > 0 then
        begin
          sDestDir := sDirVersion + Copy(sLigne, (Pos(';', sLigne) + 1), Length(sLigne)) + '\';
          if not DirectoryExists(sDestDir) then
            ForceDirectories(sDestDir);
          sLigne := Copy(sLigne, 1, Pos(';', sLigne) - 1);
        end;

        case AnsiIndexStr(UpperCase(ExtractFileExt(sLigne)), ['.DPR', '.SCR']) of // Gestion des DPR
          0:
            begin
                // traitement du fichier de configuration
              sFileCFG := changefileext(sLigne, '.cfg');
              sFileDest := ExtractFilePath(sLigne) + 'dcc32.cfg';

              if FileExists(sFileDest) then
                DeleteFile(sFileDest);

              if FileExists(sFileCFG) then
              begin
                FileSetAttr(sFileCFG, 0);
                  // Copie du fichier xxx.cfg en dcc32.cfg dans le même répertoire
                CopyFile(PChar(sFileCFG), PChar(sFileDest), false);
              end;

              lstCFG := TstringList.create;
              with lstCFG do
              try
                    // chargement du fichier de configuration pour la compilation
                if FileExists(ExtractFilePath(sLigne) + 'dcc32.cfg') then
                  LoadFromFile(ExtractFilePath(sLigne) + 'dcc32.cfg');
                add('-U"C:\DCU"');
                add('-N"C:\DCU"');

                    // récupération de la liste des chemins de compilation
                if FileExists(ExtractFilePath(Application.exename) + 'listedcu.txt') then
                begin
                  lstTmp := TstringList.create;
                  try
                    lstTmp.LoadFromFile(ExtractFilePath(Application.exename) + 'listedcu.txt');
                    for j := 0 to lstTmp.Count - 1 do
                      if (Trim(lstTmp[j]) <> '') then
                        if (lstTmp[j][1] <> ';') then
                          add('-U"' + lstTmp[j] + '"');
                  finally
                    lstTmp.Free;
                  end;
                end;

                    // Récupération de la liste de chemin des ressources
                if FileExists(ExtractFilePath(Application.exename) + 'listressources.txt') then
                begin
                  lstTmp := TstringList.create;
                  try
                    lstTmp.LoadFromFile(ExtractFilePath(Application.exename) + 'listressources.txt');
                    for j := 0 to lstTmp.Count - 1 do
                      if (Trim(lstTmp[j]) <> '') then
                        if (lstTmp[j][1] <> ';') then
                          add('-R"' + lstTmp[j] + '"');
                  finally
                    lstTmp.Free;
                  end;
                end;

                    // Ajout du fichier xxx.dcc s'il existe à la configuration de compilation
                if FileExists(changefileext(sLigne, '.dcc')) then
                begin
                  lstTmp := TstringList.create;
                  try
                    lstTmp.LoadFromFile(changefileext(sLigne, '.dcc'));
                    AddStrings(lstTmp);
                  finally
                    lstTmp.Free;
                  end;
                end;

                for j := Count - 1 downto 0 do
                begin
                  if Copy(Strings[j], 1, 2) = '-E' then
                    Delete(j);
                end;

                add('-E"C:\DCU"');

                    // récupération de la liste des DCP dans différents répertoire
                lstTmp := ListeDCP(aDebug);
                try
                  for j := 0 to lstTmp.Count - 1 do
                  begin
                        // ajout de l'option LU au fichier de confioguration
                    add('-LU' + lstTmp[j]);
                  end;
                finally
                  lstTmp.Free;
                end;

                Savetofile(ExtractFilePath(sLigne) + '\dcc32.cfg');
              finally
                Free;
              end;

              if FileExists(GAPPPATH + ExtractFileName(changefileext(sLigne, '.ico'))) then
              begin
                if FileExists(GAPPPATH + ExtractFileName(changefileext(sLigne, '.res'))) then
                  DeleteFile(GAPPPATH + ExtractFileName(changefileext(sLigne, '.res')));

                lstTmp := TstringList.create;
                try
                  lstTmp.LoadFromFile(GAPPPATH + 'all.rc');
                  lstTmp.text := StringReplace(lstTmp.text, '@ICON@', ExtractFileName(changefileext(sLigne, '.ico')), [rfReplaceAll]);
                  lstTmp.text := StringReplace(lstTmp.text, '@VERSIONV@', VersionComp.VersionVirgul, [rfReplaceAll]);
                  lstTmp.text := StringReplace(lstTmp.text, '@VERSIONP@', VersionComp.VersionComplet, [rfReplaceAll]);
                  lstTmp.Savetofile(GAPPPATH + ExtractFileName(changefileext(sLigne, '.rc')));

                  lstTmp.Clear;
                  lstTmp.add('brcc32 -32 -m -v "' + GAPPPATH + ExtractFileName(changefileext(sLigne, '.rc')) + '"');
                  lstTmp.Savetofile(GAPPPATH + 'go.bat');

                  ExecuteAndWait(GAPPPATH + 'go.bat');

                  if FileExists(GAPPPATH + ExtractFileName(changefileext(sLigne, '.res'))) then
                    CopyFile(PChar(GAPPPATH + ExtractFileName(changefileext(sLigne, '.res'))), PChar(changefileext(sLigne, '.res')), false);

                finally
                  lstTmp.Free;
                end;
              end;

                // récupération de la version de la base de données (Script.scr)
              if VersionBase.VersionComplet = '' then
                VersionBase := GetVersionBase(aVersion);

                // Traitement du fichier DPR
              lstTmp := GetFileListFromDPR(sLigne);
              lstFile := TstringList.create;
              try
                for j := 0 to lstTmp.Count - 1 do
                begin
                  if FileExists(changefileext(ExtractFilePath(sLigne) + lstTmp[j], '.dfm')) then
                  begin

                    lstFile.LoadFromFile(changefileext(ExtractFilePath(sLigne) + lstTmp[j], '.dfm'));
                    bFound := FindInDfm(lstFile, 'AboutDlg_Main', 'CaptionTitle', ' A Propos ... (' + VersionComp.VersionComplet + ')');
                    bFound := FindInDfm(lstFile, 'AboutDlg_Main', 'Version', VersionComp.VersionDecoupe.A + '.' + VersionComp.VersionDecoupe.B) or bFound;
                    bFound := FindInDfm(lstFile, 'Lab_VersionBase', 'Caption', VersionBase.VersionSansZero, true) or bFound;

                    if bFound then
                      lstFile.Savetofile(ExtractFilePath(sLigne) + changefileext(lstTmp[j], '.dfm'));
                  end; // if
                end;
              finally
                lstTmp.Free;
                lstFile.Free;
              end;

                // Compilation du DPR
              DeleteFile(GAPPPATH + 'deux.txt');
              lstTmp := TstringList.create;
              with lstTmp do
              try
                add('CD ' + ExtractFilePath(sLigne));
                add('DCC32 /GD "' + sLigne + '" /E' + sDestDir + ' /B /Q > "' + GAPPPATH + 'un.txt"');
                if FileExists('C:\CodeGear\Composants\JEDI\bin\MakeJclDbg.exe') then
                begin
                  add('C:\CodeGear\Composants\JEDI\bin\MakeJclDbg.exe -e ' + sDestDir + '*.map');
                  add('del ' + sDestDir + '*.map');
                end
                else
                  add('move ' + sDestDir + '*.map ' + sDirVerMap);
                add('copy "' + GAPPPATH + 'un.txt" "' + GAPPPATH + 'deux.txt"');
                Savetofile(GAPPPATH + 'Go.Bat');
                ExecuteAndWait(GAPPPATH + 'Go.Bat');
                LoadFromFile(GAPPPATH + 'deux.txt');
                l := Count - 1;
                bFound := false;
                while (not bFound) and (l >= 0) do
                begin
                  if Pos('lignes', Strings[l]) > 0 then
                    bFound := true;
                  dec(l);
                end;

                if not bFound then
                begin
                  Info('Erreur lors de la compilation de ' + ExtractFileName(sLigne));
                  Memo.lines.AddStrings(lstTmp);
                  Exit;
                end;
                Log(aSilent, 'Compilation terminée.');

                    // Signature de l'application.
                if TraitementCertificat(IncludeTrailingPathDelimiter(sDestDir) + changefileext(ExtractFileName(sLigne), '.exe'), aSilent, aSign, aPassword, aCertificat, aURLServeurHorodatage, aCheckURL, aDetail, aSHA256) then
                  Log(aSilent, 'Signature terminée.');

                    // PDB - Traitement de la traduction : appel de LOCREFRESH.EXE
                if aTrad then
                begin

                  if (Pos('CAISSEGINKOIA.DPR', UpperCase(sLigne)) > 0) or (Pos('GINKOIA.DPR', UpperCase(sLigne)) > 0) then
                  begin
                    Log(aSilent, 'Gestion de la traduction');

                        // CAISSE
                    if Pos('CAISSEGINKOIA.DPR', UpperCase(sLigne)) > 0 then
                    begin
                      sTrad1 := 'C:\Developpement\Ginkoia\UTILITAIRE\Compilation Ginkoia\locrefresh.exe';
                      sTrad2 := '"' + sLigne + '" -action:full -processdpr -pefile:"' + sDestDir + 'CaisseGinkoia.exe' + '" -langdir:"' + ExtractFilePath(sLigne) + 'LANGUE_CAISSE' + '"';

                      sErreur := '';
                      ExecAndWaitProcess(sErreur, sTrad1, sTrad2, true, ExtractFilePath(sTrad1));
                      if sErreur <> '' then
                        Log(aSilent, 'Code de retour Caisse : ' + sErreur);

                    end
                        // GINKOIA
                    else if Pos('GINKOIA.DPR', UpperCase(sLigne)) > 0 then
                    begin
                      sTrad1 := 'C:\Developpement\Ginkoia\UTILITAIRE\Compilation Ginkoia\locrefresh.exe';
                      sTrad2 := '"' + sLigne + '" -action:full -processdpr -pefile:"' + sDestDir + 'Ginkoia.exe' + '" -langdir:"' + ExtractFilePath(sLigne) + 'LANGUE_GINKOIA' + '"';

                      sErreur := '';
                      ExecAndWaitProcess(sErreur, sTrad1, sTrad2, true, ExtractFilePath(sTrad1));
                      if sErreur <> '' then
                        Log(aSilent, 'Code de retour Ginkoia : ' + sErreur);
                    end;

                  end;
                end;

              finally
                Free;
              end;
            end; // 0
            // Gestion du SCR
          1:
            begin
              if UpperCase(ExtractFileName(sLigne)) = 'SCRIPT.SCR' then
              begin
                lstScript := TstringList.create;
                lstScript.LoadFromFile(sLigne);
                try
                  if FileExists(ExtractFilePath(sLigne) + 'SCRIPT.OLD') then
                  begin
                      // un ancien script existe
                    lstOldScript := TstringList.create;
                    try
                        // on charge le fichier
                      lstOldScript.LoadFromFile(ExtractFilePath(sLigne) + 'SCRIPT.OLD');
                      lstOldScript.AddStrings(lstScript);
                      lstScript.text := lstOldScript.text;
                    finally
                      lstOldScript.Free;
                    end;
                  end;
                  lstScript.Savetofile(sDestDir + 'SCRIPT.SCR');
                finally
                  lstScript.Free;
                end;
              end
              else
                CopyFile(PChar(sLigne), PChar(sDestDir + ExtractFileName(sLigne)), false);
            end; // 1
            // gestion des autres cas
        else
          begin
              // Plusieurs fichiers à copier
            if Pos('*', sLigne) > 0 then
            begin
              if FindFirst(sLigne, faAnyFile, SearchFile) = 0 then
              try
                repeat
                  if (SearchFile.Name <> '.') and (SearchFile.Name <> '..') and (SearchFile.attr and faDirectory <> faDirectory) then
                  begin
                        // Si exécutable.
                    if LowerCase(ExtractFileExt(SearchFile.Name)) = '.exe' then
                    begin
                          // Signature de l'application.
                      if TraitementCertificat(ExtractFilePath(sLigne) + SearchFile.Name, aSilent, aSign, aPassword, aCertificat, aURLServeurHorodatage, aCheckURL, aDetail, aSHA256) then
                        Log(aSilent, 'Signature terminée [' + ExtractFilePath(sLigne) + SearchFile.Name + ']');
                    end;

                    CopyFile(PChar(ExtractFilePath(sLigne) + SearchFile.Name), PChar(sDestDir + ExtractFileName(SearchFile.Name)), false);
                    Log(aSilent, '-> ' + SearchFile.Name);
                  end;
                until FindNext(SearchFile) <> 0;
              finally
                FindClose(SearchFile);
              end; // if /try
            end // if
            else // Un seul fichier à copier
            begin
                // Si exécutable.
              if LowerCase(ExtractFileExt(sLigne)) = '.exe' then
              begin
                  // Signature de l'application.
                if TraitementCertificat(sLigne, aSilent, aSign, aPassword, aCertificat, aURLServeurHorodatage, aCheckURL, aDetail, aSHA256) then
                  Log(aSilent, 'Signature terminée [' + sLigne + ']');
              end;

              CopyFile(PChar(sLigne), PChar(sDestDir + ExtractFileName(sLigne)), false);
            end;
          end;
        end; // case

      end; // for i

      Log(aSilent, 'Traitement terminé.');
      result := true;
    finally
      lstCompilation.Free;
    end;
  finally
    Panel.Enabled := true;
    Btn_GenerateVersion.Enabled := true;
  end;
end;

procedure TFrm_Main.EditCertificatChange(Sender: TObject);
begin
  EditCertificat.Hint := EditCertificat.text;
end;

function TFrm_Main.FindInDfm(var lst: TstringList; sObjName, sPropName, sChangeText: string; bInsert: boolean): boolean;
var
  l: integer;
  bFound: boolean;
begin
  l := 0;
  bFound := false;
  while (l <= lst.Count - 1) and (not bFound) do
  begin
    if Pos(UpperCase(sObjName), UpperCase(lst[l])) > 0 then
    begin
      repeat
        if Pos(UpperCase(sPropName), UpperCase(lst[l])) > 0 then
        begin
          lst.ValueFromIndex[l] := QuotedStr(sChangeText);
          bFound := true;
        end
        else
          inc(l);
      until (bFound) or (Pos('END', UpperCase(lst[l])) > 0);

      if bInsert and not bFound then
        if Pos(UpperCase(sPropName), UpperCase(lst[l])) <= 0 then
        begin
          lst.Insert(l, '      Caption = ' + QuotedStr(sChangeText));
          bFound := true;
        end;
    end
    else
      inc(l);
  end; // while
  result := bFound;
end;

function TFrm_Main.FindString(var stFile: TFileStream; sFind: string): boolean;
var
  sBuff: byte;
  bFound: boolean;
  iPos: integer;
begin
  stFile.seek(0, soFromBeginning);
  result := false;
  bFound := false;
  iPos := 1;
  repeat
    repeat
      stFile.Read(sBuff, 1);
    until (Chr(sBuff) = sFind[1]) or (stFile.Position = stFile.Size);

    if Chr(sBuff) = sFind[1] then
    begin
      bFound := true;
      while (stFile.Position <= stFile.Size) and bFound do
      begin
        if Chr(sBuff) <> '' then
        begin
          if sFind[iPos] = Chr(sBuff) then
          begin
            inc(iPos);
            if iPos > Length(sFind) then
            begin
              result := true;
              Exit;
            end;
          end
          else
          begin
            iPos := 1;
            bFound := false;
          end;
        end;
        stFile.Read(sBuff, 1);
      end;
    end;
  until (stFile.Position >= stFile.Size) and not bFound;
end;

function TFrm_Main.GetFileListFromDPR(sFileName: string): TstringList;
var
  i, j: integer;
  lstForm, lstFile: TstringList;
  sTmp: string;
begin
  result := TstringList.create;
  lstFile := TstringList.create;
  lstForm := TstringList.create;

  try
    lstFile.LoadFromFile(sFileName);
      // récupération de la liste des fichiers
    for i := lstFile.Count - 1 downto 0 do
    begin
      if Pos('APPLICATION.CREATEFORM', UpperCase(lstFile[i])) > 0 then
      begin
        sTmp := Copy(lstFile[i], Pos(',', lstFile[i]) + 1, Length(lstFile[i]));
        sTmp := Copy(sTmp, 1, Pos(')', sTmp) - 1);
        lstForm.add(Trim(sTmp));
          // Vu qu'on va lire une deuxieme fois le fichier autant supprimer ce qui ne sert plus
        lstFile.Delete(i);
      end;
    end;

      // récupération de la liste des fichiers .Pas à modifier
    for i := 0 to lstForm.Count - 1 do
    begin
      for j := 0 to lstFile.Count - 1 do
      begin
        if Pos(lstForm[i], lstFile[j]) > 0 then
        begin
          sTmp := lstFile[j];
          Delete(sTmp, 1, Pos('''', lstFile[j]));
          sTmp := Copy(sTmp, 1, Pos('''', sTmp) - 1);
          result.add(sTmp);
          break;
        end;
      end;
    end;
  finally
    lstForm.Free;
    lstFile.Free;
  end;
end;

function TFrm_Main.GetVersionBase(aVersion: string): TVersion;
var
  Fichier: string;
  tsl: TstringList;
  i: integer;
begin
  Fichier := 'C:\V' + aVersion + '\Script.Scr';
  tsl := TstringList.create;
  try
    tsl.LoadFromFile(Fichier);
    i := tsl.Count - 1;
    while Copy(tsl[i], 1, 9) <> '<RELEASE>' do
      dec(i);
    result.VersionComplet := Trim(StringReplace(tsl[i], '<RELEASE>', #0, [rfReplaceAll]));
    result.VersionVirgul := StringReplace(result.VersionComplet, '.', ',', [rfReplaceAll]);
    tsl.text := StringReplace(result.VersionComplet, '.', #13#10, [rfReplaceAll]);
    result.VersionDecoupe.A := inttostr(StrToInt(tsl[0]));
    result.VersionDecoupe.B := inttostr(StrToInt(tsl[1]));
    result.VersionDecoupe.C := inttostr(StrToInt(tsl[2]));
    result.VersionDecoupe.D := inttostr(StrToInt(tsl[3]));
    result.VersionSansZero := result.VersionDecoupe.A + '.' + result.VersionDecoupe.B + '.' + result.VersionDecoupe.C + '.' + result.VersionDecoupe.D;
  finally
    tsl.Free;
  end;
end;

procedure TFrm_Main.Btn_GenerateVersionClick(Sender: TObject);
begin
  doVersion(false, cb_debug.Checked, Chk_trad.Checked, cb.Checked, EditVersion.text, feCompilation.text, Chk_SignerExecutable.Checked, _sMotDePasseCertificat, EditCertificat.text, EditURLServeurHorodatage.text, Chk_URLServeurHorodatage.Checked, Chk_DetailsSignature.Checked, Chk_SHA256.Checked);
end;

procedure TFrm_Main.Button2Click(Sender: TObject);
begin
  if FileOpenDialog1.Execute then
    feCompilation.text := FileOpenDialog1.FileName;
end;

function TFrm_Main.TraitementCertificat(const aFichier: string; aSilent, aSign: boolean; aPassword, aCertificat, aURLServeurHorodatage: string; aCheckURL, aDetail, aSHA256: boolean): boolean;
begin
  result := false;
  if aSign then
  begin
    if not FileExists(aFichier) then
    begin
      Log(aSilent, '# Erreur signature : le fichier à signer [' + aFichier + '] n''existe pas !');
      Exit;
    end;

    if not FileExists(ExtractFilePath(Application.exename) + 'signtool.exe') then
    begin
      Log(aSilent, '# Erreur signature :  l''application [signtool.exe] n''existe pas !');
      Exit;
    end;

    if not FileExists(aCertificat) then
    begin
      Log(aSilent, '# Erreur signature :  le certificat n''existe pas !');
      Exit;
    end;

    if aURLServeurHorodatage = '' then
    begin
      Log(aSilent, '# Erreur signature :  il faut saisir une URL de serveur d''horodatage !');
      Exit;
    end;

      // Si mot de passe pas encore saisie.
    if aPassword = '' then
    begin
        // Si validation.
      if FrmMotDePasseCertificat.ShowModal = mrOk then
        aPassword := FrmMotDePasseCertificat.EditMotDePasse.text
      else
      begin
        Log(aSilent, '# Abandon de la signature de l''exécutable.');
        Exit;
      end;
    end;

      // Signature du fichier.
    result := SignerFichier(aFichier, aCertificat, aPassword, aURLServeurHorodatage, aSilent, aCheckURL, aDetail, aSHA256);
  end;
end;

procedure TFrm_Main.ShowHelp;
{$IFDEF DEBUG}
var
  stop: string;
{$ENDIF}
begin
  Writeln(AnsiToUtf8('  -f "C:\Developpement\Fichiers.txt"'));
  Writeln(AnsiToUtf8('      Lien vers un fichier txt pour la compilation'));
  Writeln(AnsiToUtf8(''));
  Writeln(AnsiToUtf8('  -v 22.1.1.1'));
  Writeln(AnsiToUtf8('      version de ginkoia'));
  Writeln(AnsiToUtf8(''));
  Writeln(AnsiToUtf8('  -d'));
  Writeln(AnsiToUtf8('      si mentionner dans la ligne de commande activation du debug (correspond à la checkbox debug)'));
  Writeln(AnsiToUtf8(''));
  Writeln(AnsiToUtf8('  -s'));
  Writeln(AnsiToUtf8('      si mentionner dans la ligne de commande signer exe (correspond à la checkbox signer les exe)'));
  Writeln(AnsiToUtf8(''));
  Writeln(AnsiToUtf8('  -p'));
  Writeln(AnsiToUtf8('      si -s est mentionner avant correspond au mot de passe du certificat'));
  Writeln(AnsiToUtf8(''));
  Writeln(AnsiToUtf8('  -fc "C:\Developpement\Ginkoia\UTILITAIRE\Compilation Ginkoia\Signer exécutable\Certificat\Ginkoia.pfx"'));
  Writeln(AnsiToUtf8('      si le -s est mentionner avant, correspond au lien du certificat ginkoia (correspond au champ Certificat)'));
  Writeln(AnsiToUtf8(''));
  Writeln(AnsiToUtf8('  -time "http://timestamp.digicert.com/scripts/timestamp.dll"'));
  Writeln(AnsiToUtf8('      si -s est mentionner avant correspond à l’url de la dll d’horodatage'));
  Writeln(AnsiToUtf8(''));
  Writeln(AnsiToUtf8('  -l'));
  Writeln(AnsiToUtf8('      si -s est mentionner permet d’avoir le détail des logs'));
  Writeln(AnsiToUtf8(''));
  Writeln(AnsiToUtf8('  -e'));
  Writeln(AnsiToUtf8('      si -s est mentionner permet d’encrypter en sha256'));
  Writeln(AnsiToUtf8(''));
  Writeln(AnsiToUtf8('  -t'));
  Writeln(AnsiToUtf8('       si mentionner dans la ligne de commande génère les fichiers de traduction'));
{$IFDEF DEBUG}
  Readln(stop);
{$ENDIF}
end;

function TFrm_Main.SignerFichier(const aFichier, aCertificat, aMotDePasse, aURLServeurHorodatage: string; aSilent, aCheckURL, aDetail, aSHA256: boolean): boolean;
var
  sCommande, sErreur, sSortie: string;
begin
  sCommande := 'sign ' + IfThen(aDetail, '/v ') + IfThen(aSHA256, '/fd SHA256') + ' /f "' + aCertificat + '" /p ' + aMotDePasse + IfThen(aCheckURL, ' /t "' + aURLServeurHorodatage + '"') + ' "' + aFichier + '"';

  if ExecAndWaitProcess(sErreur, '"' + ExtractFilePath(Application.exename) + 'signtool.exe"', sCommande, false, ExtractFilePath(Application.exename)) <> 0 then
  begin
    Log(aSilent, '# Erreur signature :' + #13#10#9#9#9 + sErreur);
    result := false;
  end
  else
  begin
    if aDetail then
      Log(aSilent, #13#10 + sSortie);
    result := true;
  end;
end;

procedure TFrm_Main.AddToMemo(Mm: TMemo; sText: string);
begin
  while Mm.lines.Count > 1000 do
    Mm.lines.Delete(0);

  Mm.lines.add(FormatDateTime('[DD/MM/YYYY hh:mm:ss] - ', Now) + sText);
end;

procedure TFrm_Main.AlgolStdFrmCreate(Sender: TObject);
begin
  GAPPPATH := ExtractFilePath(Application.exename);
  readIni;
  _sMotDePasseCertificat := '';
  if ParamCount > 0 then
  begin
    Auto;
    Application.Terminate;
  end;
end;

procedure TFrm_Main.AlgolStdFrmDestroy(Sender: TObject);
begin
  saveIni;
end;

procedure TFrm_Main.Auto;
var
  i: integer;
  bContinue, bDebug, bTrad, bClean, bSign, aCheckURL, bDetail, bSHA256, bHelp: boolean;
  aVersion, aCompileFile, aPassword, aCertificat, aURLServeurHorodatage: string;
  Param: string;
  bDo: boolean;
  ini: TIniFile;
begin
  aVersion := '';
  aCompileFile := '';
  aCertificat := '';
  aURLServeurHorodatage := '';
  bContinue := true;
  bDebug := false;
  bTrad := false;
  bClean := false;
  bSign := false;
  bDetail := false;
  bSHA256 := false;
  bHelp := false;
  aCheckURL := false;
  i := 1;
  while bContinue do
  begin
    Param := ParamStr(i);
    if Param = '-f' then
    begin
      inc(i);
      aCompileFile := ParamStr(i);
    end;
    if Param = '-v' then
    begin
      inc(i);
      aVersion := ParamStr(i);
    end;
    if Param = '-d' then
      bDebug := true;
    if Param = '-s' then
      bSign := true;
    if Param = '-p' then
    begin
      inc(i);
      aPassword := ParamStr(i)
    end;
    if Param = '-fc' then
    begin
      inc(i);
      aCertificat := ParamStr(i);
    end;
    if Param = '-time' then
    begin
      inc(i);
      aURLServeurHorodatage := ParamStr(i);
      aCheckURL := (aURLServeurHorodatage <> '');
    end;
    if Param = '-l' then
      bDetail := true;
    if Param = '-e' then
      bSHA256 := true;
    if Param = '-h' then
      bHelp := true;
    if Param = '-t' then
      bTrad := true;
    inc(i);
    bContinue := i < ParamCount;
  end;

  if bHelp then
  begin
    ShowHelp;
  end
  else
  begin
    bDo := true;
    if (aCompileFile = '') then
    begin
      bDo := false;
      Log(true, 'Fichier de compilation manquant (-f [fileName])');
    end;
    if (aVersion = '') then
    begin
      bDo := false;
      Log(true, 'Pas de numéro de version (-v [NumVersion])');
    end;
    if bSign then
    begin
      if (aPassword = '') then
      begin
        bDo := false;
        Log(true, 'Mot de passe du certificat manquant (-p [Password])');
      end;
      if (aCertificat = '') or ((aCertificat <> '') and (not FileExists(aCertificat))) then
      begin
        bDo := false;
        Log(true, 'Certificat manquant (-fc [FileName])');
      end;
      if (aURLServeurHorodatage = '') then
      begin
        bDo := false;
        Log(true, 'Url de la dll d''horodatage manquante (-time [URL])');
      end;
    end;
    if bDo then
    begin
      if doVersion(true, bDebug, bTrad, bClean, aVersion, aCompileFile, bSign, aPassword, aCertificat, aURLServeurHorodatage, aCheckURL, bDetail, bSHA256) then
        Return(true, rOk)
      else
        Return(true, rNok);

      cb.Checked := bDebug;
      Chk_trad.Checked := bTrad;
      cb.Checked := bClean;
      EditVersion.text := aVersion;
      feCompilation.text := aCompileFile;
      Chk_SignerExecutable.Checked := bSign;
      EditCertificat.text := aCertificat;
      EditURLServeurHorodatage.text := aURLServeurHorodatage;
      Chk_URLServeurHorodatage.Checked := aCheckURL;
      Chk_DetailsSignature.Checked := bDetail;
      Chk_SHA256.Checked := bSHA256;
    end
    else
      Return(true, rWrongParam);
  end;
end;

end.

