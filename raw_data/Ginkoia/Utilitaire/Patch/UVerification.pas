//$Log:
// 30   Utilitaires1.29        12/09/2016 13:56:02    Ludovic MASSE   CDC -
//      D?m?nagement de Yellis
// 29   Utilitaires1.28        26/06/2013 16:08:42    Thierry Fleisch Ajout du
//      syst?me de kill d'application externe
// 28   Utilitaires1.27        05/04/2012 17:02:06    Florent CHEVILLON Ajout
//      logs et tests modifs zip
// 27   Utilitaires1.26        12/09/2011 15:58:54    Thierry Fleisch
//      Correction probl?me d'activation et d?sativation de Syncweb dans
//      v?rification et patch.exe
// 26   Utilitaires1.25        06/12/2010 15:39:21    Sandrine MEDEIROS
//      correction les proc du GUID ne passent pas !!!! ==> Grille de taille
//      Sp2000
// 25   Utilitaires1.24        20/10/2010 10:43:59    Sandrine MEDEIROS maj
//      sandrine pour la lame6 et lame7
// 24   Utilitaires1.23        26/02/2010 09:33:19    Lionel ABRY    
//      remplacement du Tbackground par un rzBackGround :
//      Le Tbackground ne compile plus, m?me en renseignant les chemins dans le
//      dproj
// 23   Utilitaires1.22        16/02/2010 16:34:55    Lionel ABRY     Migration
//      et correction probl?me Uppercase
// 22   Utilitaires1.21        17/12/2007 15:53:55    Sandrine MEDEIROS Gestion
//      dans le patch de la creation de GENERATOR, INDEX, TRIGGER si d?ja
//      existant =+> pb du RAZ
// 21   Utilitaires1.20        17/09/2007 12:42:08    pascal          modifs
//      divers
// 20   Utilitaires1.19        26/04/2007 17:31:02    pascal         
//      correction pascal rendu par sandrine
// 19   Utilitaires1.18        26/04/2007 17:26:48    Sandrine MEDEIROS Pb de
//      communication Maj + backup + launcher
// 18   Utilitaires1.17        12/03/2007 16:06:05    Sandrine MEDEIROS Erreur
//      sur EGAL et DIFF sur la var2
// 17   Utilitaires1.16        05/02/2007 11:12:21    pascal         
//      Changement pour les spatch sp?cifique avec le GUID comme nom de
//      repertoire
// 16   Utilitaires1.15        05/02/2007 11:02:22    pascal         
//      Correction merdouille de stan
// 15   Utilitaires1.14        31/01/2007 16:13:42    pascal          Modif
//      pour alg et zip avec log
// 14   Utilitaires1.13        31/01/2007 16:09:10    pascal          modif
//      pour zip et alg
// 13   Utilitaires1.12        31/01/2007 15:50:42    Sandrine MEDEIROS Modif
//      de XML=ADD pour faire sur la place un traite(Valeur)
// 12   Utilitaires1.11        20/12/2006 08:25:51    pascal          divers
//      modif
// 11   Utilitaires1.10        05/10/2006 15:37:57    pascal          probl?me
//      sur le format de la date des backups
// 10   Utilitaires1.9         21/07/2006 10:37:51    pascal          divers
//      correction
// 9    Utilitaires1.8         19/05/2006 10:05:28    pascal          Divers
//      modif pour rendre le patching plus sur
// 8    Utilitaires1.7         21/04/2006 12:29:55    pascal         
//      Modification pour emp?cher les exe de ce mettre ? jour avant les
//      scripts
// 7    Utilitaires1.6         25/01/2006 14:59:03    pascal         
//      corrections divers sur les probl?mes relev?s
// 6    Utilitaires1.5         08/08/2005 09:05:15    pascal         
//      Modifications suites aux demandes de st?phane
// 5    Utilitaires1.4         04/07/2005 10:15:00    pascal         
//      Modification pour ?viter que le client download plusieur fois les patch
// 4    Utilitaires1.3         30/05/2005 08:57:04    pascal          Divers
//      modification de "Look" suite aux demandes de Herv?.A
// 3    Utilitaires1.2         23/05/2005 17:02:33    pascal          Permettre
//      de lancer l'utilitaire manuellement dans le cas d'un poste avec une
//      r?plication manuelle
// 2    Utilitaires1.1         20/05/2005 11:20:59    pascal          Ajout de
//      petites options
// 1    Utilitaires1.0         12/05/2005 16:50:23    pascal          
//$
//$NoKeywords$
//

unit UVerification;

interface

uses
   XMLCursor,
   StdXML_TLB,
   MSXML2_TLB,
   Upost,
   Xml_Unit,
   IcXMLParser,
   registry,
   UMapping,
   UmakePatch,
   cstlaunch,
   variants,
   forms, windows, sysutils,
   filectrl, IBSQL, IpUtils, IpSock, IpHttp, IpHttpClientGinkoia,
   IBDatabase, Db, IBCustomDataSet, IBQuery, Controls, ComCtrls, StdCtrls,
   Classes, VCLUnZip, VCLZip, RzBckgnd, TlHelp32,uKillApp;

type
   TMonXML2 = class(TXMLCursor)
   end;
   TFrm_Verification = class(TForm)
      data: TIBDatabase;
      IBQue_Base: TIBQuery;
      IBQue_BaseBAS_NOM: TIBStringField;
      IBQue_Soc: TIBQuery;
      Que_Version: TIBQuery;
      Que_VersionVER_VERSION: TIBStringField;
      tran: TIBTransaction;
      IBQue_Connexion: TIBQuery;
      IBQue_ConnexionCON_TYPE: TIntegerField;
      IBQue_ConnexionCON_NOM: TIBStringField;
      IBQue_ConnexionCON_TEL: TIBStringField;
      IBQue_SocSOC_NOM: TIBStringField;
      pb: TProgressBar;
      Http1: TIpHttpClientGinkoia;
      Pb2: TProgressBar;
      Fic: TLabel;
      SQL: TIBSQL;
      Last_bckok: TIBQuery;
      Last_bckokDOS_STRING: TIBStringField;
      Last_bck: TIBQuery;
      Last_bckDOS_STRING: TIBStringField;
      IBQue_BaseBAS_ID: TIntegerField;
      Les_BD: TIBQuery;
      Les_BDREP_PLACEBASE: TIBStringField;
      Les_BDREP_PLACEEAI: TIBStringField;
      //Background5: TBackground; lab : migration
      Que_Exists: TIBQuery;
      Que_ExistsNB: TIntegerField;
      Que_GUIDBASE: TIBQuery;
      Que_GUIDBASEBAS_GUID: TIBStringField;
      IBQue_Param: TIBQuery;
      IBQue_ParamPRM_STRING: TIBStringField;
      Que_Url: TIBQuery;
      Que_UrlLAU_ID: TIntegerField;
      Que_UrlREP_ID: TIntegerField;
      Que_UrlREP_URLDISTANT: TIBStringField;
      Zip: TVCLZip;
    RzBackground: TRzBackground;
      procedure FormCreate(Sender: TObject);
      procedure FormPaint(Sender: TObject);
      procedure Http1Progress(Sender: TObject; Actuel, Maximum: Integer);
   private
    { Déclarations privées }
      first: Boolean;
      Ginkoia: string;
      VersionEnCours: string;
      Base: string;
      Soc: string;
      BasePrinc: string;
      function Lesfichier(Path: string; var Lataille: Integer): TStringList;
      function LeGuid: string;
      function Traitement_BATCH(LeFichier: string; Log: TstringList; LogName: string): Boolean;
      procedure AjouteNoeud(Xml: TMonXML2; Noeud: string; Place: Integer;
         Valeur: string);
      function ChercheMaxVal(Noeuds: IXMLDOMNodeList; NoeudFils,
         TAG: string): string;
      function ChercheMinVal(Noeuds: IXMLDOMNodeList; NoeudFils,
         TAG: string): string;
      function ChercheVal(Noeuds: IXMLDOMNodeList; TAG: string): string;
      function Existes(Noeuds: IXMLDOMNodeList; NoeudFils, TAG,
         Valeur: string): Integer;
      function Existe(Noeuds: IXMLDOMNodeList; TAG, Valeur: string): Boolean;
      procedure RemplaceVal(Noeuds: IXMLDOMNodeList; TAG, Valeur: string);
      procedure Fait_un_zip(le_zip: string);
      procedure Fait_un_alg(le_alg: string);
   public
      Automatique: boolean;
      BackupOk: boolean;
    { Déclarations publiques }
      function Connexion: boolean;
      function Verifielaversion: Boolean;
      procedure MetAJourlaversion;
      procedure de_a_version(var Dep, Arr: string);
      function traitechaine(S: string): string;
      procedure MAJplante(S: string);
      function Script(base, S: string): Boolean;
      function NetoyageDesConneriesAStan (test:boolean) : boolean;
      procedure verification_des_batch;
   end;

var
   Frm_Verification: TFrm_Verification;

{
Actions
  1 : création
  2 : Maj version
  3 : recup de Maj pour un fichier
  4 : script passé
  5 : script planté
  6 : Maj fichier planté
  7 : Scrip Perso OK
  8 : Scrip Perso planté
  10 : majplanté
}

implementation
var
   Lapplication: string;
   AppliTourne: boolean;
   AppliArret: boolean;
const
   _launcher = 'LE LAUNCHER';
   _ginkoia = 'GINKOIA';
   _Caisse = 'CAISSEGINKOIA';
   _TPE = 'SERVEUR DE TPE';
   _PICCO = 'PICCOLINK';
   _SCRIPT = 'SCRIPT';
   _PICCOBATCH = 'PICCOBATCH';
   cUrl_Yellis = 'ginkoia.yellis.net';
   // FTH 12/09/2011 Utilise Killprocess au lieu de Enumwindows
   _SYNCWEB = 'syncweb.exe';

{$R *.DFM}
{
const
   launcher = 'LE LAUNCHER';
   ginkoia = 'GINKOIA';
   Caisse = 'CAISSEGINKOIA';
   TPE = 'SERVEUR DE TPE';
   PICCO = 'PICCOLINK';
}

function Enumerate2(hwnd: HWND; Param: LPARAM): Boolean; stdcall; far;
var
   lpClassName: array[0..999] of Char;
   lpClassName2: array[0..999] of Char;
begin
   result := true;
   Windows.GetClassName(hWnd, lpClassName, 500);
   if Uppercase(StrPas(lpClassName)) = 'TAPPLICATION' then
   begin
      Windows.GetWindowText(hWnd, lpClassName2, 500);
      if Uppercase(StrPas(lpClassName2)) = Lapplication then
      begin
         AppliTourne := True;
         result := False;
      end;
   end;
end;

function Enumerate(hwnd: HWND; Param: LPARAM): Boolean; stdcall; far;
var
   lpClassName: array[0..999] of Char;
   lpClassName2: array[0..999] of Char;
   Handle: DWORD;
begin
   result := true;
   Windows.GetClassName(hWnd, lpClassName, 500);
   if Uppercase(StrPas(lpClassName)) = 'TAPPLICATION' then
   begin
      Windows.GetWindowText(hWnd, lpClassName2, 500);
      if Uppercase(StrPas(lpClassName2)) = Lapplication then
      begin
         GetWindowThreadProcessId(hWnd, @Handle);
         TerminateProcess(OpenProcess(PROCESS_ALL_ACCESS, False, Handle), 0);
         AppliArret := true;
         result := False;
      end;
   end;
end;

function KillProcess(const ProcessName : string) : boolean;
var ProcessEntry32 : TProcessEntry32;
    HSnapShot : THandle;
    HProcess : THandle;
begin
  Result := False;

  HSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if HSnapShot = 0 then exit;

  ProcessEntry32.dwSize := sizeof(ProcessEntry32);
  if Process32First(HSnapShot, ProcessEntry32) then
  repeat
    if CompareText(ProcessEntry32.szExeFile, ProcessName) = 0 then
    begin
      HProcess := OpenProcess(PROCESS_TERMINATE, False, ProcessEntry32.th32ProcessID);
      if HProcess <> 0 then
      begin
        Result := TerminateProcess(HProcess, 0);
        CloseHandle(HProcess);
      end;
      Break;
    end;
  until not Process32Next(HSnapShot, ProcessEntry32);

  CloseHandle(HSnapshot);
end;

procedure TFrm_Verification.FormCreate(Sender: TObject);
var
   reg: TRegistry;
   s: string;
begin
   fic.caption := '';
   BackupOk := true;
   reg := TRegistry.Create;
   try
      reg.access := Key_Read;
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      s := '';
      reg.OpenKey('SOFTWARE\Algol\Ginkoia', False);
      S := reg.ReadString('Base0');
   finally
      reg.free;
   end;
   BasePrinc := S;
   data.dataBaseName := BasePrinc;
   first := true;
   Ginkoia := S;
   while Ginkoia[length(Ginkoia)] <> '\' do
      delete(ginkoia, length(Ginkoia), 1);
   delete(ginkoia, length(Ginkoia), 1);
   while Ginkoia[length(Ginkoia)] <> '\' do
      delete(ginkoia, length(Ginkoia), 1);
   if not (Fileexists(Ginkoia + 'ginkoia.ini')) then
      Ginkoia := 'C:\GINKOIA\';
   if not (Fileexists(Ginkoia + 'ginkoia.ini')) then
      Ginkoia := 'D:\GINKOIA\';
   if not (Fileexists(Ginkoia + 'ginkoia.ini')) then
      Ginkoia := IncludeTrailingBackslash(extractFilePath(application.exename));
   Automatique := true;
   ForceDirectories(GINKOIA + 'liveupdate\');
end;

function TFrm_Verification.Connexion: boolean;
begin
   if UnPing('http://lame2.no-ip.com/MajBin/DelosQPMAgent.dll/Ping') then
      result := true
   else
      result := false;
end;

function TFrm_Verification.Lesfichier(Path: string; var Lataille: Integer): TStringList;

   procedure liste(PO, path: string);
   var
      f: TSearchRec;
   begin
      if findfirst(path + '*.*', FaAnyfile, F) = 0 then
      begin
         repeat
            if (f.name <> '.') and (f.name <> '..') then
            begin
               if f.attr and faDirectory = faDirectory then
               begin
                  Liste(Po + f.name + '\', path + f.name + '\');
               end
               else
               begin
                  result.add(Uppercase(Po + f.name));
                  LaTaille := LaTaille + f.size;
               end;
            end;
         until findnext(f) <> 0;
      end;
      findclose(f);
   end;

begin
   Lataille := 0;
   result := tstringlist.create;
   liste('', IncludeTrailingBackslash(path));
end;

function TFrm_Verification.LeGuid: string;
begin
   Que_Exists.Open;
   IBQue_Base.open;
      // recherche du GUID
   if Que_ExistsNB.AsInteger > 0 then
   begin
        // recupération du GUID dans GENBASE
      Que_GUIDBASE.ParamByName('BASID').AsInteger := IBQue_BaseBAS_ID.AsInteger;
      Que_GUIDBASE.Open;
      result := Que_GUIDBASEBAS_GUID.AsString;
      Que_GUIDBASE.Close;
      if result = '' then
      begin
         // Cas du passage de version
         IBQue_Param.parambyname('magid').AsInteger := IBQue_BaseBAS_ID.AsInteger;
         IBQue_Param.Open;
         result := IBQue_ParamPRM_STRING.AsString;
         IBQue_Param.Close;
      end;
   end
   else
   begin
      // recupération du GUID dans GENPARAM
      IBQue_Param.parambyname('magid').AsInteger := IBQue_BaseBAS_ID.AsInteger;
      IBQue_Param.Open;
      result := IBQue_ParamPRM_STRING.AsString;
      IBQue_Param.Close;
   end;
   Que_Exists.close;
end;

function TFrm_Verification.Verifielaversion: Boolean;
var
   idver: Integer;
   Patch: integer;
   NomVerprev,
      NomVer: string;
   S, S1: string;
   CRC: string;
   Fich: string;
   j: integer;
   i: integer;
   LeScript: Tstringlist;
   idbase: string;
   LesBases: TstringList;
   Nomrecup: string;

   BaseEnCours: string;
   ARecup: boolean;
   tsl: tstringlist;
   oksql, oksqlspe: boolean;
   GUID: string;

   tc: tconnexion;
   Tc_R: TstringList;
   Tc_Fic: TstringList;
   Tc_Prev: TstringList;
   tc_vprev: TstringList;
   i_fic: integer;

   DateActuel: TDateTime;
   DateMAJDeb: TDateTime;
   DateMAJFin: TDateTime;
   Hour, Min, Sec, MSec: Word;

   VersionAFaire: string;

   reg: TRegistry;
   LesEai: TstringList;
   lurl: string;
   Xml: TmonXML;
   Pass: TIcXMLElement;
   elem: TIcXMLElement;

   procedure recup_version;
   begin
      ForceDirectories(GINKOIA + 'liveupdate\');
      VersionAFaire := 'PatchGin' + NomVer + '-' + NomVerprev;
      // on recup le crc
      Nomrecup := 'http://' + cUrl_Yellis + '/MAJ/' + VersionAFaire + '.TXT';
      if Http1.GetWaitTimeOut(Nomrecup, 30000) then
      begin
         Http1.SaveToFile(Nomrecup, GINKOIA + 'liveupdate\' + VersionAFaire + '.TXT');
         tsl := tstringlist.create;
         tsl.loadfromfile(GINKOIA + 'liveupdate\' + VersionAFaire + '.TXT');
         if tsl.count > 1 then CRC := tsl[1] else crc := '';
         tsl.free;
         if FileExists(GINKOIA + 'liveupdate\' + VersionAFaire + '.EXE') then
         begin
            // test du crc
            if CRC <> IntToStr(FileCRC32(GINKOIA + 'liveupdate\' + VersionAFaire + '.EXE')) then
            begin
               deletefile(GINKOIA + 'liveupdate\' + VersionAFaire + '.EXE');
            end;
         end;
      end;

      if not FileExists(GINKOIA + 'liveupdate\' + VersionAFaire + '.EXE') then
      begin
         Nomrecup := 'http://' + cUrl_Yellis + '/MAJ/' + VersionAFaire + '.EXE';
         if Http1.GetWaitTimeOut(Nomrecup, 30000) then
         begin
            Http1.SaveToFile(Nomrecup, GINKOIA + 'liveupdate\' + VersionAFaire + '.EXE');
            if CRC <> IntToStr(FileCRC32(GINKOIA + 'liveupdate\' + VersionAFaire + '.EXE')) then
            begin
               deletefile(GINKOIA + 'liveupdate\' + VersionAFaire + '.EXE');
            end
            else
            begin
              // Ajout test après quelques secondes si l'antivirus l'aurait pas supprimée
              Sleep(2000);
              if not FileExists(GINKOIA + 'liveupdate\' + VersionAFaire + '.EXE') then
              begin
                 tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                    'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                    '15, "Version supprimée par antivirus","' + VersionAFaire + '","","")');
              end
              else begin
               tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                  'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                  '15, "Recupération de la version","' + VersionAFaire + '","","")');
              end;
            end;


         end;
      end;
   end;

begin
   ForceDirectories(GINKOIA + 'liveupdate\');
   if not Automatique then
      MapGinkoia.verifencours := true;
   // vérification de la connexion internet
   result := true;
   if Connexion then
   begin
      data.DatabaseName := BasePrinc;
      Tc := Tconnexion.create;
      Que_Version.Open;
      VersionEnCours := Que_VersionVER_VERSION.AsString;
      Que_Version.Close;

      IBQue_Base.Open;
      GUID := LeGuid;

      Base := IBQue_BaseBAS_NOM.AsString;
      idbase := IBQue_BaseBAS_ID.AsString;
      IBQue_Base.Close;

      LesBases := TstringList.Create;
      LesEai := TstringList.Create;
      Les_BD.paramByName('BASID').AsString := idbase;
      Les_BD.Open;
      while not Les_BD.Eof do
      begin
         LesBases.Add(Les_BDREP_PLACEBASE.AsString);
         LesEai.Add(Les_BDREP_PLACEEAI.AsString);
         Les_BD.next;
      end;
      Les_BD.Close;

      IBQue_Soc.Open;
      Soc := IBQue_SocSOC_NOM.AsString;
      IBQue_Soc.Close;
      data.close;
      Tc_R := tc.Select('Select * from version where version = "' + VersionEnCours + '"');
      if tc.recordCount(Tc_R) = 0 then
      begin
         idver := 0;
         Patch := 0;
         NomVer := '';
      end
      else
      begin
         idver := Strtoint(tc.UneValeur(tc_R, 'id'));
         Patch := Strtoint(tc.UneValeur(tc_R, 'Patch'));
         NomVer := tc.UneValeur(tc_R, 'nomversion');
      end;
      tc.FreeResult(tc_r);
      if trim(GUID) <> '' then
      begin
         tc_r := tc.select('select * from clients where clt_GUID="' + GUID + '"');
         if tc.recordCount(tc_r) = 0 then
         begin
           // plus de création par le client
         end
         else
         begin
            if tc.UneValeurEntiere(tc_r, 'version') <> idver then
            begin
            // le client n'est pas dans la version de yellis, MAJ du site yellis
               tc.ordre('UPDATE clients set version=' + inttostr(idver) + ', patch=0 where id=' + tc.UneValeur(tc_r, 'id'));
               tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                  'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                  '2, "Maj de la version par le client","","","")');
               tstringlist(tc_r.objects[tc_r.indexof('patch')]).strings[0] := '0' ;                  
            end;
            //Marquage du dernier Backup
            Last_bckok.ParamByName('DOS').AsString := 'B-' + idbase;
            Last_bckok.Open;
            if not Last_bckok.isempty then
            begin
               S := copy(Last_bckokDOS_STRING.AsString, 1, 19);
               tc.ordre('Update clients set bckok="' + tc.DateTime(Strtodatetime(S)) + '" where id=' + tc.UneValeur(tc_r, 'id'));
            end;
            Last_bckok.Close;
            Last_bck.ParamByName('DOS').AsString := 'B-' + idbase;
            Last_bck.Open;
            if not Last_bck.Eof then
            begin
               S := Last_bckDOS_STRING.AsString;
               Last_bck.next;
               if not Last_bck.eof then
               begin
                  S1 := Last_bckDOS_STRING.AsString;
                  if Strtodatetime(copy(S1, 1, 19)) > Strtodatetime(copy(S, 1, 19)) then
                     S := S1;
               end;
               s1 := 'Update clients set dernbck="' + tc.DateTime(Strtodatetime(Copy(S, 1, 19))) + '" ';
               delete(S, 1, 20);
               if pos('-', S) > 0 then
                  delete(S, 1, pos('-', S));
               S := trim(S);
               if s = '0' then
               begin
                  s1 := s1 + ', resbck="Pas de prob", dernbckok=1';
                  BackupOk := true;
               end
               else if s = '1' then
               begin
                  s1 := s1 + ', resbck="Base non renomée", dernbckok=1';
                  BackupOk := true;
               end
               else if s = '2' then
               begin
                  s1 := s1 + ', resbck="Restore OK mais base mauvaise", dernbckok=0';
                  BackupOk := false;
               end
               else if s = '3' then
               begin
                  s1 := s1 + ', resbck="Pas de restore", dernbckok=0';
                  BackupOk := false;
               end
               else if s = '4' then
               begin
                  s1 := s1 + ', resbck="Pas de backup", dernbckok=0';
                  BackupOk := false;
               end
               else if s = '5' then
               begin
                  s1 := s1 + ', resbck="Pas de place", dernbckok=0';
                  BackupOk := false;
               end
               else
               begin
                  s1 := s1 + ', resbck="Pas d''identification", dernbckok=1';
                  BackupOk := true;
               end;
               tc.ordre(S1 + ' where id=' + tc.UneValeur(tc_r, 'id'));
            end;
            Last_bck.Close;
            if idver <> 0 then
            begin
               if Automatique and (tc.UneValeurEntiere(tc_r, 'blockmaj') <> 0) then
               begin
                 // la demande de MAJ est bloquée
               end
               else
               begin
                  oksql := true;
                  oksqlspe := true;
                  if (paramcount > 0) and (Uppercase(paramstr(1)) = 'RAZ') then
                     tstringlist(tc_r.objects[tc_r.indexof('patch')]).strings[0] := '0';
                  if Patch > tc.UneValeurEntiere(tc_r, 'patch') then
                  begin
                     for i := tc.UneValeurEntiere(tc_r, 'patch') + 1 to Patch do
                     begin
                        Fich := GINKOIA + 'A_Patch\';
                        ForceDirectories(GINKOIA + 'A_Patch\');
                        Nomrecup := traitechaine('http://lame2.no-ip.com/maj/patch/' + NomVer + '/script' + Inttostr(i) + '.SQL');
                        if Http1.GetWaitTimeOut(Nomrecup, 30000) then
                        begin
                           fic.caption := 'Passage du script ' + Inttostr(i) + ' en cours'; fic.update;
                           Http1.SaveToFile(Nomrecup,
                              GINKOIA + 'A_Patch\script' + Inttostr(i) + '.SQL');
                        // Passer le script
                           LeScript := tstringlist.create;
                           LeScript.loadfromfile(GINKOIA + 'A_Patch\script' + Inttostr(i) + '.SQL');
                           S := LeScript.Text;
                           LeScript.free;
                           BaseEnCours := '';
                           while s <> '' do
                           begin
                              if pos('<---->', S) > 0 then
                              begin
                                 S1 := trim(Copy(S, 1, pos('<---->', S) - 1));
                                 Delete(S, 1, pos('<---->', S) + 5);
                              end
                              else
                              begin
                                 S1 := trim(S);
                                 S := '';
                              end;
                              if s1 <> '' then
                              begin
                                 for j := 0 to LesBases.count - 1 do
                                 begin
                                    if fileexists(LesBases[j]) then
                                    begin
                                       BaseEnCours := LesBases[j];
                                       oksql := Script(LesBases[j], S1);
                                       if not oksql then BREAK;
                                    end;
                                 end;
                              end;
                           end;
                     //
                           if oksql then
                           begin
                              tc.ordre('update clients set patch=' + Inttostr(i) + ' where id=' + tc.UneValeur(tc_r, 'id'));
                              tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                                 'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                                 '4, "script' + Inttostr(i) + '.SQL","' + BaseEnCours + '","","")');
                           // dévalider les scripts mal passés
                              tc.ordre('update histo set fait=1 where action=5 and id_cli=' + tc.UneValeur(tc_r, 'id'));
                           end
                           else
                           begin
                              tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                                 'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                                 '5, "script' + Inttostr(i) + '.SQL","' + BaseEnCours + '","Problème","")');
                              BREAK;
                           end;
                        end
                        else
                        begin
                           oksql := false;
                           BREAK;
                        end;
                     end;
                  end;

                  if tc.UneValeurEntiere(tc_r, 'spe_patch') > tc.UneValeurEntiere(tc_r, 'spe_fait') then
                  begin
                     for i := tc.UneValeurEntiere(tc_r, 'spe_fait') + 1 to tc.UneValeurEntiere(tc_r, 'spe_patch') do
                     begin
                        Fich := GINKOIA + 'A_Patch\';
                        ForceDirectories(GINKOIA + 'A_Patch\');
                        Nomrecup := traitechaine('http://lame2.no-ip.com/maj/patch/' + GUID + '/script' + Inttostr(i) + '.SQL');
                        if Http1.GetWaitTimeOut(Nomrecup, 30000) then
                        begin
                           fic.caption := 'Passage du script ' + Inttostr(i) + ' en cours'; fic.update;
                           Http1.SaveToFile(Nomrecup,
                              GINKOIA + 'A_Patch\script' + Inttostr(i) + '.SQL');
                        // Passer le script
                           LeScript := tstringlist.create;
                           LeScript.loadfromfile(GINKOIA + 'A_Patch\script' + Inttostr(i) + '.SQL');
                           S := LeScript.Text;
                           LeScript.free;
                           while s <> '' do
                           begin
                              if pos('<---->', S) > 0 then
                              begin
                                 S1 := trim(Copy(S, 1, pos('<---->', S) - 1));
                                 Delete(S, 1, pos('<---->', S) + 5);
                              end
                              else
                              begin
                                 S1 := trim(S);
                                 S := '';
                              end;
                              if s1 <> '' then
                              begin
                                 BaseEnCours := BasePrinc;
                                 oksqlspe := script(BasePrinc, s1);
                                 if not oksqlspe then BREAK;
                              end;
                           end;
                        //
                           if oksqlspe then
                           begin
                              tc.ordre('update clients set spe_fait=' + Inttostr(i) + ' where id=' + tc.UneValeur(tc_r, 'id'));
                              tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                                 'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                                 '7, "script' + Inttostr(i) + '.SQL","' + BaseEnCours + '","","")');
                           // dévalider les scripts mal passés
                              tc.ordre('update histo set fait=1 where action=8 and id_cli=' + tc.UneValeur(tc_r, 'id'));
                           end
                           else
                           begin
                              tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                                 'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                                 '8, "script' + Inttostr(i) + '.SQL","' + BaseEnCours + '","Problème","")');
                              BREAK;
                           end;
                        end
                        else
                        begin
                           oksqlspe := false;
                           BREAK;
                        end;
                     end;
                  end;

                  if oksql and oksqlspe then
                     Tc_Fic := tc.select('Select * from fichiers Where id_ver = ' + Inttostr(idver))
                  else // toujours recup verification.exe ;
                     Tc_Fic := tc.select('Select * from fichiers Where fichier="VERIFICATION.EXE" and id_ver = ' + Inttostr(idver));

                  pb.position := 0;
                  pb.Max := tc.recordCount(Tc_Fic);
                  for i_fic := 0 to tc.recordCount(Tc_Fic) - 1 do
                  begin
                     S := Ginkoia + tc.UneValeur(Tc_Fic, 'fichier', i_fic);
                     CRC := IntToStr(FileCRC32(S));
                     try
                        pb.position := pb.position + 1;
                     except
                     end;
                     if CRC <> tc.UneValeur(Tc_Fic, 'crc', i_fic) then
                     begin
                        ARecup := true;
                        if FileExists(GINKOIA + 'A_MAJ\' + tc.UneValeur(Tc_Fic, 'fichier', i_fic)) then
                        begin
                           CRC := IntToStr(FileCRC32(GINKOIA + 'A_MAJ\' + tc.UneValeur(Tc_Fic, 'fichier', i_fic)));
                           if CRC = tc.UneValeur(Tc_Fic, 'crc', i_fic) then
                              ARecup := False;
                        end;
                        if Arecup then
                        begin
                           fic.caption := 'récupération de ' + tc.UneValeur(Tc_Fic, 'fichier', i_fic);
                           Fich := GINKOIA + 'A_MAJ\' + tc.UneValeur(Tc_Fic, 'fichier', i_fic);
                           ForceDirectories(extractfilepath(fich));
                           Nomrecup := traitechaine('http://lame2.no-ip.com/maj/' + NomVer + '/' + tc.UneValeur(Tc_Fic, 'fichier', i_fic));
                           if not Http1.GetWaitTimeOut(Nomrecup, 30000) then
                              EXIT;
                           Http1.SaveToFile(Nomrecup, Fich);
                           try
                              pb2.position := 0;
                           except
                           end;
                           CRC := IntToStr(FileCRC32(Fich));
                           if CRC = tc.UneValeur(Tc_Fic, 'crc', i_fic) then
                              tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                                 'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                                 '3, "' + tc.UneValeur(Tc_Fic, 'fichier', i_fic) + '","OK","","")')
                           else
                           begin
                              deletefile(Fich);
                           end;
                        end;
                     end;
                  end;
                  tc.FreeResult(Tc_Fic);
               end;
            end;

            // tester si le client doit être mise à jour
            if Automatique then
            begin
               if idver <> 0 then
               begin
                  // dois-je récupérer une version
                  VersionAFaire := '';
                  if tc.UneValeurEntiere(Tc_R, 'version_max') > idver then
                  begin
                     tc_vprev := tc.select('select * from version where id =' + tc.UneValeur(Tc_R, 'version_max'));
                     NomVerprev := tc.UneValeur(tc_vprev, 'nomversion');
                     tc.FreeResult(tc_vprev);
                     recup_version;
                  end
                  else
                  begin
                     Tc_Prev := tc.select('select * from plageMAJ where plg_cltid = ' + tc.UneValeur(tc_r, 'id'));
                     if (tc.recordCount(Tc_Prev) > 0) and (tc.UneValeurEntiere(tc_prev, 'plg_versionmax') > idver) then
                     begin
                        tc_vprev := tc.select('select * from version where id =' + tc.UneValeur(tc_prev, 'plg_versionmax'));
                        NomVerprev := tc.UneValeur(tc_vprev, 'nomversion');
                        tc.FreeResult(tc_vprev);
                        recup_version;
                     end;
                     tc.FreeResult(Tc_Prev);
                  end;

                  if (VersionAFaire <> '') and
                     FileExists(GINKOIA + 'liveupdate\' + VersionAFaire + '.EXE') then
                  begin
                     // deux cas
                     // La MAJ est demandé
                     if tc.UneValeurEntiere(Tc_R, 'version_max') > idver then
                     begin
                        tsl := tstringlist.create;
                        tsl.add(GINKOIA + 'liveupdate\' + VersionAFaire + '.EXE');
                        tsl.savetofile(GINKOIA + 'liveupdate\amaj.txt');
                        tsl.free;
                     end
                     else
                     begin
                        // la MAJ est prévue
                        Tc_Prev := tc.select('select * from plageMAJ where plg_cltid = ' + tc.UneValeur(tc_r, 'id'));
                        DateActuel := Date;
                        DecodeTime(Time, Hour, Min, Sec, MSec);
                        if hour >= 19 then
                           DateActuel := DateActuel + 1;
                        S := tc.UneValeur(Tc_Prev, 'plg_datedeb');
                        if pos('-', S) > 0 then
                        begin
                           if Copy(S, 9, 2) = '00' then
                              DateMAJDeb := 0
                           else
                              DateMAJDeb := Strtodate(Copy(S, 9, 2) + '/' + Copy(S, 6, 2) + '/' + Copy(S, 1, 4) + Copy(S, 11, 255));
                        end
                        else
                           DateMAJDeb := Strtodate(S);
                        S := tc.UneValeur(Tc_Prev, 'plg_datefin');
                        if pos('-', S) > 0 then
                        begin
                           if Copy(S, 9, 2) = '00' then
                              DateMAJFin := 0
                           else
                              DateMAJFin := Strtodate(Copy(S, 9, 2) + '/' + Copy(S, 6, 2) + '/' + Copy(S, 1, 4) + Copy(S, 11, 255));
                        end
                        else
                           DateMAJFin := Strtodate(S);

                        if (DateMAJFin <= DateActuel) and
                           (DateMAJDeb >= DateActuel) then
                        begin
                           tsl := tstringlist.create;
                           tsl.add(GINKOIA + 'liveupdate\' + VersionAFaire + '.EXE');
                           tsl.savetofile(GINKOIA + 'liveupdate\amaj.txt');
                           tsl.free;
                           // et on update la fiche client
                           tc.ordre('Update clients set bckok="' + S + '" where id=' + tc.UneValeur(tc_r, 'id'));
                           tc.ordre('update clients set version_max=' + tc.UneValeur(tc_prev, 'plg_versionmax') +
                              ' where id=' + tc.UneValeur(tc_r, 'id'));
                        end;
                        tc.FreeResult(Tc_Prev);
                     end;
                  end;
               end;
            end;
         end;
         // vérification des spécifiques
         tc_prev := tc.select('select * from specifique where spe_fait=0 and spe_cltid=' + tc.UneValeur(tc_r, 'id'));
         if tc.recordCount(tc_prev) > 0 then
         begin
            tsl := tstringlist.create;
            for i := 0 to tc.recordCount(tc_prev) - 1 do
            begin
               // récupération du fichier dans A_MAJ\LIVEUPDATE
               S := tc.UneValeur(tc_prev, 'spe_fichier', i);
               Nomrecup := traitechaine('http://lame2.no-ip.com/maj/' + s);
               if Http1.GetWaitTimeOut(Nomrecup, 30000) then
               begin
                  Http1.SaveToFile(Nomrecup, GINKOIA + 'LIVEUPDATE\' + s);
                  tsl.add(GINKOIA + 'liveupdate\' + s);
                  tsl.savetofile(GINKOIA + 'liveupdate\amaj.txt');
                  tc.ordre('update specifique set spe_fait=1, spe_date="' + tc.DateTime(now) + '" where spe_id=' + tc.UneValeur(tc_prev, 'spe_id', i));
               end;
            end;
            tsl.free;
         end;
         tc.freeresult(tc_prev);
         tc.FreeResult(tc_r);

         //
         for i := 0 to LesEai.count - 1 do
         begin
            data.close;
            data.DatabaseName := LesBases[i];
            data.open;
            tran.Active := true;
            IBQue_Base.Open;
            GUID := LeGuid;
            data.close;
            if trim(GUID) <> '' then
            begin
               tc_r := tc.select('select * from clients where clt_GUID="' + GUID + '"');
               if tc.recordCount(tc_r) <> 0 then
               begin
                  // recherche de l'url ;
                  Tc_Prev := tc.select('select * from lesurl where UCASE(url_machine)="' + uppercase(tc.UneValeur(tc_r, 'clt_machine')) +
                     '" and UCASE(url_centrale)="' + uppercase(tc.UneValeur(tc_r, 'clt_centrale')) + '"');
                  if tc.recordCount(Tc_Prev) = 0 then
                  begin
                     tc.FreeResult(Tc_Prev);
                     Tc_Prev := tc.select('select * from lesurl where UCASE(url_machine)="' + uppercase(tc.UneValeur(tc_r, 'clt_machine')) + '"');
                  end;
                  if tc.recordCount(Tc_Prev) <> 0 then
                  begin
                     lurl := tc.UneValeur(Tc_Prev, 'url_url');
                     data.DatabaseName := BasePrinc;
                     data.open;
                     tran.Active := true;
                     IBQue_Base.open;
                     Que_Url.ParamByName('BASID').AsInteger := IBQue_BaseBAS_ID.AsInteger;
                     Que_Url.Open;
                     while not Que_Url.eof do
                     begin
                        S := uppercase(Que_UrlREP_URLDISTANT.AsString);
                        if Copy(S, 1, length(lurl)) <> uppercase(lurl) then
                        begin
                           Xml := TmonXML.Create;
                           xml.LoadFromFile(LesEai[i] + 'DelosQPMAgent.Providers.xml');
                           Pass := Xml.find('/Providers/Provider');
                           while pass <> nil do
                           begin
                              elem := pass.GetFirstChild;
                              while (elem <> nil) and (elem.getname <> 'URL') do
                                 elem := elem.NextSibling;
                              if elem <> nil then
                              begin
                                 s := elem.GetFirstNode.GetValue;
                                 delete(s, 1, pos('//', S) + 1);
                                 delete(s, 1, pos('/', S));
                                 S := lurl + s;
                                 elem.GetFirstNode.SetValue(S);
                              end;
                              pass := pass.NextSibling;
                           end;
                           xml.SaveToFile(LesEai[i] + 'DelosQPMAgent.Providers.xml');

                           xml.LoadFromFile(LesEai[i] + 'DelosQPMAgent.Subscriptions.xml');
                           Pass := Xml.find('/Subscriptions/Subscription');
                           while pass <> nil do
                           begin
                              elem := pass.GetFirstChild;
                              while (elem <> nil) and (elem.getname <> 'URL') do
                                 elem := elem.NextSibling;
                              if elem <> nil then
                              begin
                                 s := elem.GetFirstNode.GetValue;
                                 delete(s, 1, pos('//', S) + 1);
                                 delete(s, 1, pos('/', S));
                                 S := lurl + s;
                                 elem.GetFirstNode.SetValue(S);
                              end;
                              pass := pass.NextSibling;
                           end;
                           xml.SaveToFile(LesEai[i] + 'DelosQPMAgent.Subscriptions.xml');

                           xml.LoadFromFile(LesEai[i] + 'DelosQPMAgent.InitParams.xml');
                           Pass := Xml.find('/InitParams/QPM');
                           elem := pass.GetFirstChild;
                           while (elem <> nil) do
                           begin
                              if elem.GetFirstNode <> nil then
                              begin
                                 s := elem.GetFirstNode.GetValue;
                                 if uppercase(copy(s, 1, 7)) = 'HTTP://' then
                                 begin
                                    delete(s, 1, pos('//', S) + 1);
                                    delete(s, 1, pos('/', S));
                                    S := lurl + s;
                                    elem.GetFirstNode.SetValue(S);
                                 end;
                              end;
                              elem := elem.NextSibling;
                           end;
                           xml.SaveToFile(LesEai[i] + 'DelosQPMAgent.InitParams.xml');
                           xml.free;

                           S := Que_UrlREP_URLDISTANT.AsString;
                           delete(s, 1, pos('//', S) + 1);
                           delete(s, 1, pos('/', S));
                           S := lurl + s;
                           sql.sql.text := 'update k set k_version=gen_id(general_id,1) where k_id=' + Que_UrlREP_ID.AsString;
                           sql.ExecQuery;
                           sql.sql.text := 'update genreplication set REP_URLDISTANT = ''' + S + ''' where REP_ID=' + Que_UrlREP_ID.AsString;
                           sql.ExecQuery;
                           tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                              'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                              '25, "MAJ des EAI","' + s + '","","")');
                        end;
                        Que_Url.Next;
                     end;
                     Que_Url.close;
                     if tran.InTransaction then
                        tran.Commit;
                     data.close;
                  end;
                  tc.FreeResult(Tc_Prev);
               end;
               tc.FreeResult(tc_r);
            end;
            data.close;
         end;
      end;
      tc.free;
      LesBases.free;
      LesEai.free;
      Close;

      reg := TRegistry.Create;
      try
         Reg.RootKey := HKEY_LOCAL_MACHINE;
         reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False);
         S := reg.ReadString('GinkoRep');
         if s = '' then
         begin
            reg.WriteString('GinkoRep', Ginkoia + 'GinkoRep.exe ' + Ginkoia);
         end;
      finally
         reg.free;
      end;
   end
   else
      result := false;
   if not Automatique then
      MapGinkoia.verifencours := false;
end;

procedure TFrm_Verification.FormPaint(Sender: TObject);
begin
   if first then
   begin
      first := false;
      Update;
      RzBackground.Invalidate;

      // pour copier le rep documents
      verification_des_batch;

      if not Automatique then
         EXIT;
      MapGinkoia.Verifencours := true;
      application.ProcessMessages;
      try
         try
            if paramcount = 0 then
            begin
               Verifielaversion;
            end
            else if Uppercase(paramstr(1)) = 'MAJ' then
            begin
               MetAJourlaversion;
            end
            else if Uppercase(paramstr(1)) = 'AUTO' then
            begin
               Verifielaversion;
               MetAJourlaversion;
            end
            else if Uppercase(paramstr(1)) = 'RAZ' then
            begin
               Verifielaversion;
            end
            else if Uppercase(paramstr(1)) = 'ZIP' then
            begin
               Fait_un_zip(paramstr(2)) ;
            end
            else if Uppercase(paramstr(1)) = 'ALG' then
            begin
               Fait_un_alg(paramstr(2)) ;
            end
         except
         end;
      finally
         MapGinkoia.Verifencours := false;
         close;
      end;
   end;
end;

procedure TFrm_Verification.Http1Progress(Sender: TObject; Actuel, Maximum: Integer);
begin
   try
      pb2.Max := Maximum;
      pb2.Position := Actuel;
   except
   end;
end;

procedure TFrm_Verification.MetAJourlaversion;
var
   Fich: string;
   j: integer;
   i: integer;
   k: integer;
   ListMaj: Tstringlist;
   Sauve: tstringlist;
   LeLauncher: Boolean;
   LeSyncWeb: Boolean;
   Base: string;
   LesEai: TstringList;
   idbase: string;
   s: string;
   Handle: Integer;
   tsl: tstringlist;
   tc: Tconnexion;
   t_clt: tstringlist;
   GUID: string;
   LesBases: TstringList;
   f: tsearchrec;

   Dois_relance_le_launcher: Boolean;
   Dois_relance_SYNCWEB: Boolean;
begin
   Dois_relance_le_launcher := false;
   LeLauncher := false;
   Dois_relance_SYNCWEB := false;
   LeSyncWeb := false;
   if not Automatique then
      MapGinkoia.verifencours := true;
   // si le backup était lancé (ce qui ne devrait pas être le cas, attendre qu'il soit fini !
   While MapGinkoia.Backup do
   BEGIN
   	  Sleep(5*60*1000);
   END;

   ListMaj := Lesfichier(GINKOIA + 'A_MAJ\', i);
   if (ListMaj.count > 0) or (NetoyageDesConneriesAStan (true)) then
   begin

      tc := Tconnexion.create;
      IBQue_Base.Open;
      Base := IBQue_BaseBAS_NOM.AsString;
      idbase := IBQue_BaseBAS_ID.AsString;
      IBQue_Base.Close;

      LesBases := TstringList.Create;
      LesEai := TstringList.Create;
      Les_BD.paramByName('BASID').AsString := idbase;
      Les_BD.Open;
      while not Les_BD.Eof do
      begin
         LesBases.Add(Les_BDREP_PLACEBASE.AsString);
         LesEai.Add(Les_BDREP_PLACEEAI.AsString);
         Les_BD.next;
      end;
      Les_BD.Close;
      data.close;

      fic.caption := 'Arret des applications en cours'; fic.update;

      Lapplication := _ginkoia;
      EnumWindows(@Enumerate, 0);
      sleep(100);
      Lapplication := _Caisse;
      EnumWindows(@Enumerate, 0);
      sleep(100);
      Lapplication := _PICCO;
      EnumWindows(@Enumerate, 0);
      sleep(100);
      Lapplication := _TPE;
      EnumWindows(@Enumerate, 0);
      sleep(100);
      AppliArret := False;
      Lapplication := _launcher;
      EnumWindows(@Enumerate, 0);
      LeLauncher := AppliArret;
      sleep(100);
      Lapplication := _PICCOBATCH;
      EnumWindows(@Enumerate, 0);
      sleep(100);
      Lapplication := _SCRIPT;
      EnumWindows(@Enumerate, 0);

      sleep(100);
//      AppliArret := False;
//      Lapplication := _SYNCWEB;
      AppliArret := KillProcess(_SYNCWEB);
//      EnumWindows(@Enumerate, 0);
      LeSyncWeb := AppliArret;

      sleep(5000);
      Dois_relance_le_launcher := true;
      Dois_relance_SYNCWEB := true;

      {$REGION 'Arret des applications externe via le fichier KLaunch.app'}
      KillApp.Load;
      for i := 0 to KillApp.Count - 1 do
        KillProcess(KillApp.List[i]);
      {$ENDREGION}

      NetoyageDesConneriesAStan (false) ;
      
      Sauve := tstringlist.create;
      pb.position := 0;
      pb.max := ListMaj.count;
      for i := 0 to ListMaj.count - 1 do
      begin
         if uppercase(Ginkoia + ListMaj[i]) = uppercase(Application.exename) then
         begin
            // ne pas essayer de ce mettre a jour soit même
            continue;
         end;
         try
            pb.position := pb.position + 1;
         except
         end;
         fic.caption := 'Maj de ' + ListMaj[i]; fic.Update;
         Fich := Ginkoia + 'SVE_NOW\' + ListMaj[i];
         ForceDirectories(extractfilepath(Fich));
         CopyFile(Pchar(Ginkoia + ListMaj[i]), Pchar(fich), False);
         Sauve.Add(ListMaj[i]);
         if pos('\EAI\', Uppercase(Ginkoia + ListMaj[i])) > 0 then
         begin
            for k := 0 to LesEai.count - 1 do
            begin
               S := ListMaj[i];
               delete(s, 1, 4);
               ForceDirectories(extractfilepath(LesEai[k] + S));
               if not CopyFile(Pchar(GINKOIA + 'A_MAJ\' + ListMaj[i]), Pchar(LesEai[k] + S), false) then
               begin
                  if Connexion then
                  begin
                     data.dataBaseName := BasePrinc;
                     data.open;
                     IBQue_Base.Open;
                     GUID := LeGuid;
                     Base := IBQue_BaseBAS_NOM.AsString;
                     data.Close;
                     if trim(GUID) <> '' then
                     begin
                        t_Clt := tc.select('select * from clients where clt_GUID="' + GUID + '"');
                        IBQue_Base.Close;
                        tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                           'values (' + tc.UneValeur(t_Clt, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                           '6, "Problème de MAJ d''un fichier","' + LesEai[k] + S + '","' + VersionEnCours + '","")');
                        tc.FreeResult(t_clt);
                     end;
                  end;
               end;
            end;
         end
         else
         begin
            ForceDirectories(extractfilepath(Ginkoia + ListMaj[i]));
            if not CopyFile(Pchar(GINKOIA + 'A_MAJ\' + ListMaj[i]), Pchar(Ginkoia + ListMaj[i]), false) then
            begin
               for j := 0 to sauve.count - 1 do
                  CopyFile(Pchar(Ginkoia + 'SVE_NOW\' + Sauve[i]), Pchar(Ginkoia + Sauve[i]), False);
               if Connexion then
               begin
                  data.dataBaseName := BasePrinc;
                  data.open;
                  IBQue_Base.Open;
                  GUID := LeGuid;
                  Base := IBQue_BaseBAS_NOM.AsString;
                  data.Close;
                  if trim(GUID) <> '' then
                  begin
                     t_Clt := tc.select('select * from clients where clt_GUID="' + GUID + '"');
                     IBQue_Base.Close;
                     tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                        'values (' + tc.UneValeur(t_Clt, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                        '6, "Problème de MAJ d''un fichier","' + ListMaj[i] + '","' + VersionEnCours + '","")');
                     tc.FreeResult(t_clt);
                  end;
               end;
               break;
            end
            else
            begin
               Handle := FileOpen(Pchar(Ginkoia + ListMaj[i]), fmOpenReadWrite);
               FileSetDate(Handle, DateTimeToFileDate(now));
               FileClose(Handle);
            end;
         end;
         deletefile(Pchar(GINKOIA + 'A_MAJ\' + ListMaj[i]));
      end;
      LesBases.free;
      LesEai.free;
      tc.free;
      for j := 0 to sauve.count - 1 do
         deletefile(Pchar(Ginkoia + 'SVE_NOW\' + Sauve[j]));
      Sauve.free;
   end;

   ListMaj.free;
   if not Automatique then
      MapGinkoia.verifencours := false
   else
   begin
      if FileExists(Ginkoia + 'liveupdate\amaj.txt') then
      begin
         tsl := tstringlist.create;
         tsl.loadfromfile(Ginkoia + 'liveupdate\amaj.txt');
         while tsl.count > 0 do
         begin
            S := tsl[0];
            while tsl.indexof(s) > -1 do
               tsl.delete(tsl.indexof(s));
            tsl.savetofile(Ginkoia + 'liveupdate\amaj.txt');
            if uppercase(ExtractFileExt(s)) = '.EXE' then
            begin
               s := s + ' AUTO';
               winexec(pchar(s), 0);
            end
            else if uppercase(ExtractFileExt(s)) = '.ZIP' then
            begin
               zip.DestDir := Ginkoia + 'LiveUpdate\' + ChangeFileExt(s, '') + '\';
               zip.ZipName := S;
               zip.unzip;
               if findfirst(Ginkoia + 'LiveUpdate\' + ChangeFileExt(s, '') + '\*.alg', faAnyFile, f) = 0 then
                  Traitement_BATCH(Ginkoia + 'LiveUpdate\' + ChangeFileExt(s, '') + '\' + f.Name, nil, '');
               findclose(f);
            end
            else if uppercase(ExtractFileExt(s)) = '.ALG' then
            begin
              // language macro
               Traitement_BATCH(s, nil, '');
            end;
         end;
         tsl.free;
      end;
   end;
   if Dois_relance_le_launcher and LeLauncher then
   begin
      WinExec(Pchar(Ginkoia + 'LaunchV7.exe'), 0);
   end;

   if Dois_relance_SYNCWEB and LeSyncWeb then
   begin
      WinExec(Pchar(Ginkoia + 'FluxWeb\SyncWeb.exe AUTO'), 0);
   end;
end;

function TFrm_Verification.traitechaine(S: string): string;
var
   kk: Integer;
begin
   while pos(' ', S) > 0 do
   begin
      kk := pos(' ', S);
      delete(S, kk, 1);
      Insert('%20', S, kk);
   end;
   result := S;
end;

procedure TFrm_Verification.de_a_version(var Dep, Arr: string);
var
   base: string;
   soc: string;
   tsl: tstringlist;
   GUID: string;
   tc: tconnexion;
   T_Clt: tstringlist;
   T_Ver: tstringlist;
begin
   // recherche du GUID
   Tc := Tconnexion.create;
   IBQue_Base.Open;
   GUID := trim(LeGuid);
   tsl := tstringlist.create;
   Base := IBQue_BaseBAS_NOM.AsString;
   IBQue_Base.Close;
   IBQue_Soc.Open;
   Soc := IBQue_SocSOC_NOM.AsString;
   IBQue_Soc.Close;
   data.close;
   tsl.add('Nom de la base ' + Base);
   if trim(GUID) <> '' then
   begin
      T_Clt := tc.Select('Select * from clients where clt_GUID="' + GUID + '"');
      tsl.add('Version du client ' + tc.UneValeur(T_Clt, 'version'));
      T_Ver := tc.select('Select * from version where id = ' + tc.UneValeur(T_Clt, 'version'));
      if tc.recordCount(T_Ver) = 0 then
         Dep := ''
      else
         Dep := Uppercase(tc.UneValeur(T_Ver, 'nomversion'));
      tsl.add('Nom de la version  ' + tc.UneValeur(T_Ver, 'nomversion'));
      tsl.add('Version à passer ' + tc.UneValeur(T_Clt, 'version_max'));
      tc.FreeResult(T_Ver);
      T_Ver := tc.select('Select * from version where id = ' + tc.UneValeur(T_Clt, 'version_max'));
      if tc.recordCount(T_Ver) = 0 then
         Arr := ''
      else
         Arr := Uppercase(tc.UneValeur(T_Ver, 'nomversion'));
      tsl.add('Nom de la version  ' + tc.UneValeur(T_Ver, 'nomversion'));
      tc.FreeResult(T_Ver);
      tc.FreeResult(T_Clt);
   end;
   tsl.savetofile(changefileext(application.exename, '.txt'));
   tsl.free;
   tc.free;
end;

procedure TFrm_Verification.MAJplante(S: string);
var
   GUID: string;
   t_Clt: Tstringlist;
   tc: tconnexion;
begin
   try
      tc := tconnexion.create;
      IBQue_Base.Open;
      GUID := LeGuid;
      Base := IBQue_BaseBAS_NOM.AsString;
      data.Close;
      if trim(GUID) <> '' then
      begin
         t_Clt := tc.select('select * from clients where clt_GUID="' + GUID + '"');
         IBQue_Base.Close;
         tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
            'values (' + tc.UneValeur(t_Clt, 'id') + ', "' + tc.DateTime(Now) + '", ' +
            '10, "MAJ plantée","' + S + '","","")');
         tc.FreeResult(t_clt);
      end;
      tc.free;
   except
   end;
end;

function TFrm_Verification.Script(base, S: string): Boolean;
begin
   result := true;
   try
      S := trim(s);
      data.close;
      data.databasename := base;
      data.open;
      tran.Active := true;
      Sql.SQL.Text := S;
      Sql.ExecQuery;
      if Sql.Transaction.InTransaction then
         Sql.Transaction.Commit;
      data.close;
   except
      if Sql.Transaction.InTransaction then
         Sql.Transaction.rollback;
      tran.Active := true;
      //lab 1213 :  UpperCAse sur le texte à comparer et non sur tout le script pour éviter certains bugs
      //S := UpperCase(S);
      // gestion des GENERATOR déja existants
   	 IF UPPERCASE(copy(S, 1, length('CREATE GENERATOR'))) = 'CREATE GENERATOR' then
   	 begin
       result := True;
   	 end
     // gestion des TRIGGER déja existants
     ELSE IF UPPERCASE(Copy(S, 1, length('CREATE TRIGGER'))) = 'CREATE TRIGGER' then
     begin
       result := True;
     end
     // gestion des INDEX déja existants
     ELSE IF UPPERCASE(Copy(S, 1, length('CREATE INDEX'))) = 'CREATE INDEX' then
     begin
       result := True;
     end
     // gestion des PROCEDURE déja existance
     ELSE if UPPERCASE(Copy(S, 1, length('CREATE PROCEDURE'))) = 'CREATE PROCEDURE' then
     begin
         delete(s, 1, 6);
         S := 'ALTER' + S;
         try
            Sql.SQL.Text := S;
            Sql.ExecQuery;
            if Sql.Transaction.InTransaction then
               Sql.Transaction.Commit;
            data.close;
         except
            result := false;
         end;
      end
      else
       	 result := false;
   END;
end;

procedure Detruit(src: string);
var
   f: tsearchrec;
begin
   if src[length(src)] <> '\' then
      src := src + '\';
   if findfirst(src + '*.*', faanyfile, f) = 0 then
   begin
      repeat
         if (f.name <> '.') and (f.name <> '..') then
         begin
            if f.Attr and faDirectory = 0 then
            begin
               fileSetAttr(src + f.Name, 0);
               deletefile(src + f.Name);
            end
            else
               Detruit(Src + f.name);
         end;
      until findnext(f) <> 0;
   end;
   findclose(f);
   RemoveDir(Src);
end;

function TFrm_Verification.Traitement_BATCH(LeFichier: string;
   Log: TstringList; LogName: string): Boolean;
var
   PassTsl: TstringList;
   Tsl: TstringList;
   LesVar: TstringList;
   LesVal: TstringList;
   LaPille: TstringList;
   Ordre: string;
   MarqueurEai: Integer;
   EaiEnCours: Integer;
   XML: TMonXML2;
   PathOrdre: string;
   PathEAI: string;
   i: Integer;
   S: string;
   LeTemps: Dword;
   Temps: Dword;
   timeout: Boolean;

   NoeudsEnCours: IXMLDOMNodeList;
   NoeudConcerne: string;
   ValeurEnCours: Integer;
   MarqueurNoeuds: Integer;

   LesEai: tstringlist;

   function LeTimeOut: boolean;
   begin
      result := false;
      if timeout then
      begin
         if GetTickCount > LeTemps then
         begin
            result := true;
         end;
      end;
   end;

   function remplacer(S: string; Cherche: string; Valeur: string): string;
   var
      j: Integer;
   begin
      while Pos(Cherche, S) > 0 do
      begin
         j := Pos(Cherche, S);
         if j > 0 then
         begin
            delete(S, j, length(cherche));
            Insert(valeur, S, J);
         end;
      end;
      result := S;
   end;

   function Traite(S: string): string;
   var
      i: integer;
   begin
      S := remplacer(S, '[GINKOIA]', Ginkoia);
      S := remplacer(S, '[ACTUEL]', PathOrdre);
      S := remplacer(S, '[EAI]', PathEAI);
      for i := 0 to lesVar.count - 1 do
      begin
         S := remplacer(S, lesVar[i], LesVal[i]);
      end;
      result := s;
   end;

   function PositionsurNoeuds(Placedunoeud: string): IXMLDOMNodeList;
   var
      i: Integer;
      ok: Boolean;
      SousNoeud: string;
   begin
      Xml.First;
      result := Xml.Get_CurrentNodeList;
      while (Placedunoeud <> '') do
      begin
         if Pos('/', Placedunoeud) > 0 then
         begin
            SousNoeud := Copy(Placedunoeud, 1, Pos('/', Placedunoeud) - 1);
            delete(Placedunoeud, 1, Pos('/', Placedunoeud));
         end
         else
         begin
            SousNoeud := Placedunoeud;
            Placedunoeud := '';
         end;
         i := 0;
         Ok := false;
         while i < result.Get_length do
         begin
            if result.Item[i].Get_nodeName = SousNoeud then
            begin
               result := result.Item[i].Get_childNodes;
               ok := true;
               BREAK;
            end;
            Inc(i);
         end;
         if not ok then
         begin
            Result := nil;
            BREAK;
         end;
      end;
   end;

   function TraiteVal(S: string): string;

   var
      Ordre: string;
      SSOrdre: string;
      PlaceduNoeud: string;
      Noeuds: IXMLDOMNodeList;
      NoeudFils: string;
      TAG: string;
      Place: string;
      reg: tregistry;
      Var1: string;
   begin
      result := '';
      if pos('=', S) > 0 then
      begin
         Ordre := Copy(S, 1, pos('=', S) - 1);
         delete(S, 1, pos('=', S));
         if Ordre = 'REGLIT' then
         begin
            SSOrdre := Traite(Copy(S, 1, Pos(';', S) - 1));
            delete(S, 1, pos(';', S));
            reg := tregistry.Create(Key_READ);
            try
               Var1 := Copy(SSOrdre, 1, pos('\', SSOrdre));
               delete(SSOrdre, 1, pos('\', SSOrdre));
               if Var1 = 'HKEY_LOCAL_MACHINE\' then
                  reg.RootKey := HKEY_LOCAL_MACHINE
               else if Var1 = 'HKEY_CLASSES_ROOT\' then
                  reg.RootKey := HKEY_CLASSES_ROOT
               else if Var1 = 'HKEY_CURRENT_USER\' then
                  reg.RootKey := HKEY_CURRENT_USER
               else if Var1 = 'HKEY_USERS\' then
                  reg.RootKey := HKEY_USERS
               else if Var1 = 'HKEY_CURRENT_CONFIG\' then
                  reg.RootKey := HKEY_CURRENT_CONFIG;
               if reg.OpenKey(SSOrdre, True) then
               begin
                  S := traite(S);
                  result := reg.ReadString(S);
                  reg.closeKey;
               end;
            finally
               reg.free;
            end;
         end
         else if Ordre = 'POS' then
         begin
            SSOrdre := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            S := traite(S);
            SSOrdre := traite(SSOrdre);
            result := Inttostr(Pos(SSOrdre, S));
         end
         else if Ordre = 'ADD' then
         begin
            SSOrdre := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            S := traite(S);
            SSOrdre := traite(SSOrdre);
            result := Inttostr(StrToInt(S) + StrToInt(SSOrdre));
         end
         else if Ordre = 'COPY' then
         begin
            SSOrdre := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            Place := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            SSOrdre := traite(SSOrdre);
            S := Traite(S);
            Place := traite(Place);
            result := Copy(SSOrdre, StrToInt(Place), StrToInt(s));
         end
         else if Ordre = 'DELETE' then
         begin
            SSOrdre := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            Place := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            SSOrdre := traite(SSOrdre);
            Place := traite(Place);
            S := Traite(S);
            Delete(SSOrdre, StrToInt(Place), StrToInt(s));
            result := SSOrdre;
         end
         else if Ordre = 'CONCAT' then
         begin
            SSOrdre := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            SSOrdre := traite(SSOrdre);
            S := Traite(S);
            result := SSOrdre + S;
         end
         else if Ordre = 'XML' then
         begin
            Xml.First;
            SSOrdre := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            if SSOrdre = 'GETVALEUR' then
            begin
               result := ChercheVal(NoeudsEnCours.item[ValeurEnCours].Get_childNodes, S);
            end
            else if SSOrdre = 'EXISTES' then
            begin
               Placedunoeud := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
               Noeuds := PositionsurNoeuds(Placedunoeud);
               if Noeuds <> nil then
               begin
                  NoeudFils := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
                  TAG := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
                  result := Inttostr(Existes(Noeuds, NoeudFils, Tag, Traite(S)));
               end;
            end
            else if SSOrdre = 'MINVALUE' then
            begin
               Placedunoeud := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
               Noeuds := PositionsurNoeuds(Placedunoeud);
               if Noeuds <> nil then
               begin
                  NoeudFils := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
                  result := ChercheMinVal(Noeuds, NoeudFils, S);
               end;
            end
            else if SSOrdre = 'MAXVALUE' then
            begin
               Placedunoeud := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
               Noeuds := PositionsurNoeuds(Placedunoeud);
               if Noeuds <> nil then
               begin
                  NoeudFils := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
                  result := ChercheMaxVal(Noeuds, NoeudFils, S);
               end;
            end;
         end;
      end
      else
         result := S;
   end;

   function TraiteOrdre(Ordre: string; Valeur: string; I: Integer): Integer;
   var
      s: string;
      SSOrdre: string;
      j: Integer;
      Noeud: string;
      Place: Integer;
      Var1: string;
      Var2: string;

      MonPathExtract: string;

      reg: tregistry;
   begin
      if (ordre <> '') and (Ordre[1] <> ';') then
      begin
         S := Valeur;
         if ORDRE = 'REGADD' then
         begin
            SSOrdre := Traite(Copy(S, 1, Pos(';', S) - 1));
            delete(S, 1, pos(';', S));
            reg := tregistry.Create(Key_ALL_ACCESS);
            try
               Var1 := Copy(SSOrdre, 1, pos('\', SSOrdre));
               delete(SSOrdre, 1, pos('\', SSOrdre));
               if Var1 = 'HKEY_LOCAL_MACHINE\' then
                  reg.RootKey := HKEY_LOCAL_MACHINE
               else if Var1 = 'HKEY_CLASSES_ROOT\' then
                  reg.RootKey := HKEY_CLASSES_ROOT
               else if Var1 = 'HKEY_CURRENT_USER\' then
                  reg.RootKey := HKEY_CURRENT_USER
               else if Var1 = 'HKEY_USERS\' then
                  reg.RootKey := HKEY_USERS
               else if Var1 = 'HKEY_CURRENT_CONFIG\' then
                  reg.RootKey := HKEY_CURRENT_CONFIG;
               if reg.OpenKey(SSOrdre, True) then
               begin
                  SSOrdre := traite(Copy(S, 1, Pos(';', S) - 1));
                  delete(S, 1, pos(';', S));
                  S := traite(S);
                  reg.WriteString(SSOrdre, S);
                  reg.closeKey;
               end;
            finally
               reg.free;
            end;
            inc(i);
         end
         else if ORDRE = 'REGSUP' then
         begin
            SSOrdre := Traite(Copy(S, 1, Pos(';', S) - 1));
            delete(S, 1, pos(';', S));
            reg := tregistry.Create(Key_ALL_ACCESS);
            try
               Var1 := Copy(SSOrdre, 1, pos('\', SSOrdre));
               delete(SSOrdre, 1, pos('\', SSOrdre));
               if Var1 = 'HKEY_LOCAL_MACHINE\' then
                  reg.RootKey := HKEY_LOCAL_MACHINE
               else if Var1 = 'HKEY_CLASSES_ROOT\' then
                  reg.RootKey := HKEY_CLASSES_ROOT
               else if Var1 = 'HKEY_CURRENT_USER\' then
                  reg.RootKey := HKEY_CURRENT_USER
               else if Var1 = 'HKEY_USERS\' then
                  reg.RootKey := HKEY_USERS
               else if Var1 = 'HKEY_CURRENT_CONFIG\' then
                  reg.RootKey := HKEY_CURRENT_CONFIG;
               if reg.OpenKey(SSOrdre, True) then
               begin
                  S := traite(S);
                  reg.DeleteValue(S);
                  reg.closeKey;
               end;
            finally
               reg.free;
            end;
            inc(i);
         end
         else if ORDRE = 'REGSUPCLEF' then
         begin
            SSOrdre := Traite(Copy(S, 1, Pos(';', S) - 1));
            delete(S, 1, pos(';', S));
            reg := tregistry.Create(Key_ALL_ACCESS);
            try
               Var1 := Copy(SSOrdre, 1, pos('\', SSOrdre));
               delete(SSOrdre, 1, pos('\', SSOrdre));
               if Var1 = 'HKEY_LOCAL_MACHINE\' then
                  reg.RootKey := HKEY_LOCAL_MACHINE
               else if Var1 = 'HKEY_CLASSES_ROOT\' then
                  reg.RootKey := HKEY_CLASSES_ROOT
               else if Var1 = 'HKEY_CURRENT_USER\' then
                  reg.RootKey := HKEY_CURRENT_USER
               else if Var1 = 'HKEY_USERS\' then
                  reg.RootKey := HKEY_USERS
               else if Var1 = 'HKEY_CURRENT_CONFIG\' then
                  reg.RootKey := HKEY_CURRENT_CONFIG;
               S := traite(S);
               reg.DeleteKey(S);
            finally
               reg.free;
            end;
            inc(i);
         end
         else if ORDRE = 'SUPDIR' then
         begin
            S := traite(S);
            Detruit(S);
            inc(i);
         end
         else if ORDRE = 'UNZIP' then
         begin
            S := traite(S);
            zip.ZipName := S;
            MonPathExtract := S;
            while pos('\', MonPathExtract) > 0 do
               delete(MonPathExtract, 1, pos('\', MonPathExtract));
            MonPathExtract := Ginkoia + 'LiveUpdate\' + ChangeFileExt(MonPathExtract, '') + '\';
            zip.DestDir := MonPathExtract;
            zip.unzip;
            inc(i);
         end
         else if ORDRE = 'COMMANDE' then
         begin
            S := traite(S);
            if Fileexists(S) then
            begin
               if not Traitement_BATCH(S, Log, LogName) then
               begin
                  result := 99999;
                  EXIT;
               end;
            end;
            inc(i);
         end
         else if Ordre = 'CALL' then
         begin
            J := 0;
            while (j < tsl.count) and (tsl[j] <> 'BCL=' + S) do
               Inc(j);
            if j < tsl.count then
            begin
               LaPille.Add(Inttostr(i));
               i := J;
            end;
         end
         else if Ordre = 'RETURN' then
         begin
            if LaPille.count > 0 then
            begin
               S := LaPille[LaPille.Count - 1];
               LaPille.Delete(LaPille.Count - 1);
               I := StrToInt(S);
            end;
            inc(i);
         end
         else if ordre = 'TOUT_NOEUD' then
         begin
            if S = 'END' then
            begin
               if NoeudsEnCours <> nil then
               begin
                  inc(ValeurEnCours);
                  while (ValeurEnCours < NoeudsEnCours.Get_length) and
                     (NoeudsEnCours.item[ValeurEnCours].Get_nodeName <> NoeudConcerne) do
                     inc(ValeurEnCours);
                  if ValeurEnCours >= NoeudsEnCours.Get_length then
                     NoeudsEnCours := nil;
                  if NoeudsEnCours <> nil then
                  begin
                     i := MarqueurNoeuds;
                  end;
               end;
               Inc(i);
            end
            else
            begin
               SSOrdre := Copy(S, 1, Pos(';', S) - 1);
               delete(S, 1, pos(';', S));
               NoeudsEnCours := PositionsurNoeuds(SSOrdre);
               NoeudConcerne := S;
               MarqueurNoeuds := i;
               if NoeudsEnCours <> nil then
               begin
                  ValeurEnCours := 0;
                  while (ValeurEnCours < NoeudsEnCours.Get_length) and
                     (NoeudsEnCours.item[ValeurEnCours].Get_nodeName <> NoeudConcerne) do
                     inc(ValeurEnCours);
                  if ValeurEnCours >= NoeudsEnCours.Get_length then
                     NoeudsEnCours := nil;
               end;
               if NoeudsEnCours = nil then
               begin
                  while tsl[i] <> 'TOUT_NOEUD=END' do
                     Inc(i);
               end;
               inc(i);
            end;
         end
         else if ordre = 'RENAME' then
         begin
            SSOrdre := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, pos(';', S));
            S := traite(S);
            SSOrdre := traite(SSOrdre);
            RenameFile(SSOrdre, S);
            Inc(i);
         end
            {
            ELSE IF ORDRE = 'SCRIPT' THEN
            BEGIN
                S := Traite(S);
                IbScript.Sql.Loadfromfile(S);
                IF NOT tran.InTransaction THEN
                    tran.StartTransaction;
                IbScript.Execute;
                IF tran.InTransaction THEN
                    tran.commit;
                Inc(i);
            END
            }
         else if ORDRE = 'EXECUTE' then
         begin
            S := Traite(S);
            Winexec(PChar(S), 0);
            inc(i);
         end
         else if ORDRE = 'STOP' then
         begin
            Lapplication := S;
            EnumWindows(@Enumerate, 0);
            Lapplication := S;
            EnumWindows(@Enumerate, 0);
            inc(i);
         end
         else if ORDRE = 'TIMEOUT' then
         begin
            timeout := true;
            temps := StrToInt(S);
            inc(i);
         end
         else if ORDRE = 'STOPTIMEOUT' then
         begin
            timeout := False;
            inc(i);
         end
         else if ORDRE = 'DELAY' then
         begin
            LeTemps := StrToInt(S);
            LeTemps := GetTickCount + LeTemps;
            while GetTickCount < LeTemps do
            begin
               Sleep(1000);
               Application.processMessages;
            end;
            inc(i);
         end
         else if ORDRE = 'SUPPRIME' then
         begin
            S := traite(S);
            FileSetAttr(Pchar(S), 0);
            DeleteFile(S);
            Inc(i);
         end
         else if ORDRE = 'ATTENTE' then
         begin
            SSOrdre := Copy(S, 1, Pos('=', S) - 1);
            delete(S, 1, pos('=', S));
            if SSOrdre = 'FIN' then
            begin
               LeTemps := GetTickCount + Temps;
               repeat
                  AppliTourne := False;
                  Lapplication := uppercase(S);
                  EnumWindows(@Enumerate2, 0);
                  if LeTimeOut then
                  begin
                     result := 99999;
                     EXIT;
                  end;
                  Sleep(250);
               until not (AppliTourne);
            end
            else if SSOrdre = 'DEBUT' then
            begin
               LeTemps := GetTickCount + Temps;
               repeat
                  AppliTourne := False;
                  Lapplication := uppercase(S);
                  EnumWindows(@Enumerate2, 0);
                  if LeTimeOut then
                  begin
                     result := 99999;
                     EXIT;
                  end;
                  sleep(250);
               until AppliTourne;
            end
            else if SSOrdre = 'FILEEXISTS' then
            begin
               S := traite(S);
               LeTemps := GetTickCount + Temps;
               while not Fileexists(S) do
               begin
                  sleep(1000);
                  if LeTimeOut then
                  begin
                     result := 99999;
                     EXIT;
                  end;
               end;
            end
            else if SSOrdre = 'MAPSTART' then
            begin
               S := uppercase(s);
               if S = 'GINKOIA' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.Ginkoia do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'CAISSE' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.Caisse do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'LAUNCHER' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.Launcher do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'BACKUP' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.Backup do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'LIVEUPDATE' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.LiveUpdate do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'MAJAUTO' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.MajAuto do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'PARAMGINKOIA' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.ParamGinkoia do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'PING' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.Ping do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'PINGSTOP' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.PingStop do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'SCRIPT' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.Script do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'SCRIPTOK' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.ScriptOK do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end;
            end
            else if SSOrdre = 'MAPSTOP' then
            begin
               S := uppercase(s);
               if S = 'GINKOIA' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.Ginkoia do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'CAISSE' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.Caisse do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'LAUNCHER' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.Launcher do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'BACKUP' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.Backup do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'LIVEUPDATE' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.LiveUpdate do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'MAJAUTO' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.MajAuto do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'PARAMGINKOIA' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.ParamGinkoia do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'PING' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.Ping do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'PINGSTOP' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.PingStop do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'SCRIPT' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.Script do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'SCRIPTOK' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.ScriptOK do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end;
            end;
            Inc(i);
         end
         else if Ordre = 'TOUT_EAI' then
         begin
            ssOrdre := S;
            if ssOrdre = 'BEGIN' then
            begin
               MarqueurEai := i;
               EaiEnCours := 0;
               PathEAI := LesEai[EaiEnCours];
            end
            else if ssOrdre = 'END' then
            begin
               inc(EaiEnCours);
               if EaiEnCours < LesEai.Count then
               begin
                  PathEAI := LesEai[EaiEnCours];
                  i := MarqueurEai;
               end;
            end;
            inc(i);
         end
         else if ordre = 'XML' then
         begin
            ssOrdre := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            if ssOrdre = 'SETVALEUR' then
            begin
               Noeud := Copy(S, 1, Pos(';', S) - 1);
               delete(S, 1, Pos(';', S));
               Noeud := traite(Noeud);
               S := traite(S);
               RemplaceVal(NoeudsEnCours.item[ValeurEnCours].Get_childNodes, Noeud, S);
            end
            else if ssOrdre = 'LOAD' then
            begin
               PassTsl := TstringList.Create;
               if log <> nil then
               begin
                  Log.Add('Load XML ' + Traite(S)); Log.SaveToFile(LogName);
               end;
               PassTsl.loadFromFile(Traite(S));
               if log <> nil then
               begin
                  Log.Add('Parsing de ' + Traite(S)); Log.SaveToFile(LogName);
               end;
               Xml.LoadXML(PassTsl.Text);
               if log <> nil then
               begin
                  Log.Add('Parsing OK '); Log.SaveToFile(LogName);
               end;
               NoeudsEnCours := XML.Get_CurrentNodeList;
            end
            else if ssOrdre = 'SAVE' then
            begin
               xml.Save(traite(s));
            end
            else if ssOrdre = 'ADD' then
            begin
               Xml.First;
               Noeud := Copy(S, 1, Pos(';', S) - 1);
               delete(S, 1, Pos(';', S));
               Place := StrtoInt(traite(Copy(S, 1, Pos(';', S) - 1)));
               delete(S, 1, Pos(';', S));
               S := Traite(S);
               AjouteNoeud(Xml, Noeud, Place, S);
            end;
            inc(i)
         end
         else if ordre = 'GOTO' then
         begin
            j := 0;
            while j < tsl.count do
            begin
               if Uppercase(tsl.Names[j]) = 'BCL' then
               begin
                  SSOrdre := Copy(tsl[j], Pos('=', tsl[j]) + 1, Length(tsl[j]));
                  if SSOrdre = S then
                  begin
                     I := J;
                     BREAK;
                  end;
               end;
               Inc(j);
            end;
            Inc(i);
         end
         else if Copy(Ordre, 1, 2) = '$$' then
         begin
              // Variable ;
            j := LesVar.IndexOf(Ordre);
            if j = -1 then
            begin
               J := LesVar.Add(Ordre);
               LesVal.Add('');
            end;
            LesVal[j] := TraiteVal(S);
            Inc(i);
         end
         else if Ordre = 'SI' then
         begin
            SSOrdre := Copy(S, 1, Pos(')', S));
            Delete(S, 1, Pos(')', S));
            Delete(S, 1, Pos(';', S));
            if Copy(SSOrdre, 1, Pos('(', SSOrdre)) = 'DIFF(' then
            begin
               delete(SSOrdre, 1, Pos('(', SSOrdre));
               Var1 := Copy(SSOrdre, 1, Pos(';', SSOrdre) - 1);
               delete(SSOrdre, 1, Pos(';', SSOrdre));
               Var2 := Copy(SSOrdre, 1, Pos(')', SSOrdre) - 1);
               if Copy(var1, 1, 2) = '$$' then
                  Var1 := Traite(Var1);
               if Copy(var2, 1, 2) = '$$' then
                  Var2 := Traite(Var2);
               if Var1 <> var2 then
               begin
                  Ordre := Copy(S, 1, pos('=', S) - 1);
                  delete(S, 1, Pos('=', S));
                  I := TraiteOrdre(Ordre, S, i);
               end
               else
                  Inc(i);
            end
            else if Copy(SSOrdre, 1, Pos('(', SSOrdre)) = 'EGAL(' then
            begin
               delete(SSOrdre, 1, Pos('(', SSOrdre));
               Var1 := Copy(SSOrdre, 1, Pos(';', SSOrdre) - 1);
               delete(SSOrdre, 1, Pos(';', SSOrdre));
               Var2 := Copy(SSOrdre, 1, Pos(')', SSOrdre) - 1);
               if Copy(var1, 1, 2) = '$$' then
                  Var1 := Traite(Var1);
               if Copy(var2, 1, 2) = '$$' then
                  Var2 := Traite(Var2);
               if Var1 = var2 then
               begin
                  Ordre := Copy(S, 1, pos('=', S) - 1);
                  delete(S, 1, Pos('=', S));
                  I := TraiteOrdre(Ordre, S, i);
               end
               else
                  Inc(i);
            end;
         end
         else
         begin
            inc(i);
         end;
      end
      else
         inc(i);
      result := i;
   end;

begin
   data.DatabaseName := BasePrinc;
   IBQue_Base.Open;
   LesEai := TstringList.Create;
   Les_BD.paramByName('BASID').AsString := IBQue_BaseBAS_ID.AsString;
   Les_BD.Open;
   while not Les_BD.Eof do
   begin
      LesEai.Add(Les_BDREP_PLACEEAI.AsString);
      Les_BD.next;
   end;
   Les_BD.Close;
   IBQue_Base.close;
   data.close;

   Tsl := TstringList.Create;
   LesVar := TstringList.Create;
   LesVal := TstringList.Create;
   LaPille := TstringList.Create;
   XML := TMonXML2.Create;

   if log <> nil then
   begin
      Log.Add('Ouverture de ' + LeFichier); Log.SaveToFile(LogName);
   end;
   tsl.LoadFromFile(LeFichier);
   i := 0;
   TimeOut := false;
   PathOrdre := IncludeTrailingBackslash(ExtractFilePath(LeFichier));
   Temps := 0;

   MarqueurEai := -1;
   MarqueurNoeuds := -1;
   application.ProcessMessages;
   try
      Pb2.Max := tsl.count;
      Pb2.position := i + 1;
   except
   end;
   while i < tsl.count do
   begin
      Ordre := Uppercase(trim(tsl.Names[i]));
      if log <> nil then
      begin
         Log.Add('Execute ' + tsl[i]); Log.SaveToFile(LogName);
      end;
      try
         Pb2.Max := tsl.count;
         Pb2.position := i + 1;
      except
      end;
      S := trim(Copy(tsl[i], Pos('=', tsl[i]) + 1, Length(tsl[i])));
      i := TraiteOrdre(Ordre, S, i);
   end;
   if log <> nil then
   begin
      Log.Add('Fin du fichier '); Log.SaveToFile(LogName);
   end;
   result := i <> 99999;
   XML.free;
   LesVar.free;
   LesVal.free;
   Tsl.free;
   LaPille.free;
   leseai.free;
end;

procedure TFrm_Verification.AjouteNoeud(Xml: TMonXML2; Noeud: string;
   Place: Integer; Valeur: string);
var
   Actu: string;
   S: string;
   Node: IXMLDOMNode;
   ok: Boolean;
   NodeAjout: TMonXml2;
   i: Integer;
begin
   NodeAjout := TMonXml2.Create;
   try
      NodeAjout.LoadXML(Valeur);
      NodeAjout.First;
      S := Noeud;
      if Pos('/', S) > 0 then
      begin
         Actu := Copy(S, 1, Pos('/', S) - 1);
         delete(S, 1, Pos('/', S));
      end
      else
      begin
         Actu := S;
         S := '';
      end;
      Xml.First;
      while not Xml.EOF do
      begin
         if Xml.Get_CurrentNode.Get_nodeName = Actu then
         begin
            Node := xml.Get_CurrentNode;
            ok := true;
            while (S <> '') and ok do
            begin
               if Pos('/', S) > 0 then
               begin
                  Actu := Copy(S, 1, Pos('/', S) - 1);
                  delete(S, 1, Pos('/', S));
               end
               else
               begin
                  Actu := S;
                  S := '';
               end;
               ok := false;
               for i := 0 to Node.childNodes.length - 1 do
               begin
                  if Node.childNodes.Item[i].Get_nodeName = Actu then
                  begin
                     Ok := true;
                     Node := Node.childNodes.Item[i];
                     BREAK;
                  end;
               end;
            end;
            if ok then
            begin
              // Mon Node contient le Noeud en question
               if Place <= 0 then
               begin
                  Node.insertBefore(NodeAjout.Get_CurrentNode, Node.childNodes.Item[0]);
               end
               else if Place >= Node.childNodes.Get_length then
               begin
                  Node.appendChild(NodeAjout.Get_CurrentNode);
               end
               else
               begin
                  Node.insertBefore(NodeAjout.Get_CurrentNode, Node.childNodes.Item[Place - 1]);
               end;
            end;
            BREAK;
         end;
         Xml.Next;
      end;
   finally
      NodeAjout.free;
   end;
end;

function TFrm_Verification.ChercheMaxVal(Noeuds: IXMLDOMNodeList;
   NoeudFils, TAG: string): string;
var
   i: integer;
   S: string;
   d, d1: double;
   code: Integer;
begin
   result := '';
   for i := 0 to Noeuds.Get_length - 1 do
   begin
      if Noeuds.item[i].Get_nodeName = NoeudFils then
      begin
         S := ChercheVal(Noeuds.item[i].childNodes, Tag);
         if result = '' then
            result := S
         else if (S <> '') then
         begin
            Val(S, D, Code);
            d1 := 0;
            if code = 0 then
               Val(result, D1, Code);
            if code = 0 then
            begin
               if d1 < d then
                  result := S;
            end
            else
            begin
               if (result < S) then
                  result := S;
            end;
         end;
      end;
   end;
end;

function TFrm_Verification.ChercheMinVal(Noeuds: IXMLDOMNodeList;
   NoeudFils, TAG: string): string;
var
   i: integer;
   S: string;
   code: Integer;
   D, d1: Double;
begin
   result := '';
   for i := 0 to Noeuds.Get_length - 1 do
   begin
      if Noeuds.item[i].Get_nodeName = NoeudFils then
      begin
         S := ChercheVal(Noeuds.item[i].childNodes, Tag);
         if result = '' then
            result := S
         else if (S <> '') then
         begin
            Val(S, D, Code);
            d1 := 0;
            if code = 0 then
               Val(result, D1, Code);
            if code = 0 then
            begin
               if d1 > d then
                  result := S;
            end
            else
            begin
               if (result > S) then
                  result := S;
            end;
         end;
      end;
   end;
end;

function TFrm_Verification.ChercheVal(Noeuds: IXMLDOMNodeList;
   TAG: string): string;
var
   i: integer;
begin
   result := '';
   for i := 0 to Noeuds.Get_length - 1 do
   begin
      if Noeuds.item[i].Get_nodeName = Tag then
      begin
         if Noeuds.item[i].childNodes.Get_length < 1 then
            result := ''
         else if Noeuds.item[i].childNodes.item[0].Get_nodeValue <> Null then
            result := Noeuds.item[i].childNodes.item[0].Get_nodeValue;
         BREAK;
      end;
   end;
end;

function TFrm_Verification.Existe(Noeuds: IXMLDOMNodeList; TAG,
   Valeur: string): Boolean;
var
   i: integer;
begin
   result := false;
   for i := 0 to Noeuds.Get_length - 1 do
   begin
      if Noeuds.item[i].Get_nodeName = Tag then
      begin
         if Noeuds.item[i].childNodes.item[0].Get_nodeValue = Valeur then
            result := true;
         BREAK;
      end;
   end;
end;

function TFrm_Verification.Existes(Noeuds: IXMLDOMNodeList; NoeudFils, TAG,
   Valeur: string): Integer;
var
   i: integer;
begin
   result := -1;
   for i := 0 to Noeuds.Get_length - 1 do
   begin
      if Noeuds.item[i].Get_nodeName = NoeudFils then
      begin
         if Existe(Noeuds.item[i].childNodes, Tag, Valeur) then
         begin
            result := I + 1;
            BREAK;
         end;
      end;
   end;
end;

procedure TFrm_Verification.RemplaceVal(Noeuds: IXMLDOMNodeList; TAG,
   Valeur: string);
var
   i: integer;
begin
   for i := 0 to Noeuds.Get_length - 1 do
   begin
      if Noeuds.item[i].Get_nodeName = Tag then
      begin
         if Noeuds.item[i].childNodes.Get_length = 0 then
            Noeuds.item[i].Set_text(Valeur)
         else
            Noeuds.item[i].childNodes.item[0].Set_nodeValue(Valeur);
         BREAK;
      end;
   end;
end;

Function TFrm_Verification.NetoyageDesConneriesAStan  (test:boolean) : boolean;
var
   F: Tsearchrec;
begin
   result := false ;
   try
      if FindFirst(ginkoia + '*.bpl', faanyfile, f) = 0 then
      begin
         repeat
            if (f.name <> '.') and (f.name <> '..') then
            begin
               if (f.Attr and faDirectory = 0) and (uppercase(Extractfileext(f.Name)) = '.BPL') then
               begin
                  result := true ;
                  IF test then BREAK ;
                  fileSetAttr(ginkoia + f.Name, 0);
                  deletefile(ginkoia + f.Name);
               end;
            end;
         until findnext(f) <> 0;
      end;
      findclose(f);
   except
   end;
end;

procedure TFrm_Verification.verification_des_batch;
var
   S: string;
   S1: string;
   S2, S3, S4: string;
   SS: string;
   i: integer;
   F: TSearchRec;
   tsl: tstringlist;
   prem: boolean;
begin
   try
      S := ExtractFileDrive(paramstr(0));
      S := Copy(S, 1, 1) + ':\GINKOIA\BATCH\';
      if FindFirst(S + '*.bat', faanyfile, f) = 0 then
      begin
         repeat
            if Uppercase(extractfileext(F.Name)) = '.BAT' then
            begin
               fileSetAttr(S + f.Name, 0);
               tsl := tstringlist.Create;
               tsl.LoadFromFile(S + f.Name);
               prem := true; SS := '';
               for i := 0 to tsl.count - 1 do
               begin
                  S1 := tsl[i];
                  if prem and (Pos('CMDSYNC.EXE', Uppercase(S1)) > 0) then
                  begin
                     prem := false;
                  // découpon en 4 partie
                     S2 := Copy(S1, 1, Pos('CMDSYNC.EXE', Uppercase(S1)) + 11);
                  // s2 -> \\serveur\c\ginkoia\filesync\cmdsync.exe
                     delete(S1, 1, Pos('CMDSYNC.EXE', Uppercase(S1)) + 11);
                     S3 := trim(Copy(S1, 1, Pos(' ', S1)));
                  // S3 -> "\\serveur\c\ginkoia\bpl"
                     Delete(S1, 1, Pos(' ', S1));
                     S4 := trim(Copy(S1, 1, Pos(' ', S1)));
                  // S4 -> "*.*"
                     Delete(S1, 1, Pos(' ', S1));
                  // S1 = "d:\ginkoia\bpl" /S
                     if pos('/S', S1) > 0 then
                        S1 := trim(Copy(S1, 1, pos('/S', S1) - 1));
                     if pos('/D', S1) > 0 then
                        S1 := trim(Copy(S1, 1, pos('/D', S1) - 1));
                        // S1 = "d:\ginkoia\bpl"
                     SS := trim(S2) + ' ';
                        // SS -> \\serveur\c\ginkoia\filesync\cmdsync.exe
                     while pos('"', S3) > 0 do
                        delete(S3, pos('"', S3), 1);
                     S3 := Uppercase(S3);
                     S3 := Copy(S3, 1, pos('GINKOIA', S3) + 6);
                     S3 := S3 + '\DOCUMENTS';
                     SS := SS + '"' + S3 + '" "*.*" ';
                        // SS -> \\serveur\c\ginkoia\filesync\cmdsync.exe "\\serveur\c\ginkoia\images" "*.*"
                     S3 := Uppercase(S1);
                     while pos('"', S3) > 0 do
                        delete(S3, pos('"', S3), 1);
                     S3 := Copy(S3, 1, pos('GINKOIA', S3) + 6);
                     S3 := S3 + '\DOCUMENTS';
                     SS := SS + '"' + S3 + '" /D';
                  // SS -> \\serveur\c\ginkoia\filesync\cmdsync.exe "\\serveur\c\ginkoia\images" "*.*" "d:\ginkoia\images" /S
                  end;
                  if pos('DOCUMENTS', Uppercase(TSL[I])) > 0 then
                  begin
                     SS := '';
                     BREAK;
                  end;
               end;
               if ss <> '' then
                  tsl.insert(2, SS);
               Filesetattr(S + f.Name, 0);
               try
                  tsl.SaveToFile(S + f.Name);
               except end;
               tsl.free;
            end;
         until findnext(f) <> 0
      end;
      findclose(f);
   except
   end;
end;

procedure TFrm_Verification.Fait_un_alg(le_alg: string);
var
  s : string ;
  log:tstringlist ;
begin
   s := changefileext(le_alg,'.log') ;
   log:=tstringlist.create ;
   Traitement_BATCH(le_alg, log, s);
   log.SaveToFile (s) ;
   log.free ;
end;

procedure TFrm_Verification.Fait_un_zip(le_zip: string);
var
   F: TSearchRec;
  s : string ;
  log:tstringlist ;
begin
   zip.DestDir := Ginkoia + 'LiveUpdate\' + ChangeFileExt(extractfilename(le_zip), '') + '\';
   zip.ZipName := le_zip;
   zip.unzip;
   s := changefileext(le_zip,'.log') ;
   log:=tstringlist.create ;
   if findfirst(Ginkoia + 'LiveUpdate\' + ChangeFileExt(extractfilename(le_zip), '') + '\*.alg', faAnyFile, f) = 0 then
      Traitement_BATCH(Ginkoia + 'LiveUpdate\' + ChangeFileExt(extractfilename(le_zip), '') + '\' + f.Name, log, s);
   findclose(f);
   log.SaveToFile (s) ;
   log.free ;
end;

end.

