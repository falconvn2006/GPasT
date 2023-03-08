//$Log:
// 1    Utilitaires1.0         01/10/2012 16:06:34    Loic G          
//$
//$NoKeywords$
//

unit UgesPantin;

interface

uses
   UPost,
   UCrePtcVersion,
   UChxClient,
   XMLCursor,
   StdXML_TLB,
   umakepatch,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Buttons, StdCtrls, Db, dxmdaset, MemDataX, ComCtrls, IBCustomDataSet,
   IBQuery, IBDatabase;

type
   TForm1 = class(TForm)
      Label1: TLabel;
      Edit1: TEdit;
      Button1: TButton;
      SpeedButton1: TSpeedButton;
      OD: TOpenDialog;
      Bdx: TDataBaseX;
      Version: TMemDataX;
      Versionid: TIntegerField;
      Versionversion: TStringField;
      Versionnomversion: TStringField;
      fichiers: TMemDataX;
      fichiersid_ver: TIntegerField;
      fichiersfichier: TStringField;
      fichierscrc: TStringField;
      fichiersid_fic: TIntegerField;
      Label2: TLabel;
      VersionPatch: TIntegerField;
      PB2: TProgressBar;
      PB3: TProgressBar;
      Lab_rep: TLabel;
      Lab_fic: TLabel;
      base: TIBDatabase;
      tran: TIBTransaction;
      IBQue_Soc: TIBQuery;
      IBQue_SocSOC_NOM: TIBStringField;
      IBQue_Base: TIBQuery;
      IBQue_BaseBAS_NOM: TIBStringField;
      Que_Version: TIBQuery;
      Que_VersionVER_VERSION: TIBStringField;
      clients: TMemDataX;
      clientssite: TStringField;
      clientsnom: TStringField;
      clientsversion: TIntegerField;
      clientspatch: TIntegerField;
      clientsversion_max: TIntegerField;
      clientsid: TIntegerField;
      clientsspe_patch: TIntegerField;
      clientsspe_fait: TIntegerField;
      clientsbckok: TDateTimeField;
      clientsdernbck: TDateTimeField;
      clientsresbck: TStringField;
      clientsblockmaj: TIntegerField;
      Histo: TMemDataX;
      Histoid_cli: TIntegerField;
      Histoaction: TIntegerField;
      Histoactionstr: TStringField;
      Histoval1: TIntegerField;
      Histoval2: TIntegerField;
      Histoval3: TIntegerField;
      Histostr1: TStringField;
      Histostr2: TStringField;
      Histostr3: TStringField;
      Histoid: TIntegerField;
      Histoladate: TDateTimeField;
      groupe: TMemDataX;
      groupegrp_id: TIntegerField;
      groupegrp_nom: TStringField;
      grpliaison: TMemDataX;
      grpliaisongpl_id: TIntegerField;
      grpliaisongpl_grpid: TIntegerField;
      grpliaisongpl_cltid: TIntegerField;
      grpliaisongpl_type: TIntegerField;
      Button3: TButton;
      Button4: TButton;
      clientsnompournous: TStringField;
      clientsdernbckok: TIntegerField;
      IBQue_BaseBAS_IDENT: TIBStringField;
      clientsbasepantin: TIntegerField;
      Pb: TProgressBar;
    Button2: TButton;
      procedure SpeedButton1Click(Sender: TObject);
      procedure Button1Click(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure fichiersValidate(Sender: TObject; Max, Actu: Integer);
      procedure Button3Click(Sender: TObject);
      procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
   private
      function Lesfichier(Path: string; var Lataille: Integer): TStringList;
    { Déclarations privées }
   public
    { Déclarations publiques }
   end;

var
   Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
   if od.execute then
      edit1.text := IncludeTrailingBackslash(ExtractFilePath(od.filename));
end;

function traiteversion(S: string): string;
var
   S1: string;
begin
   result := '';
   while pos('.', S) > 0 do
   begin
      S1 := Copy(S, 1, pos('.', S));
      delete(S, 1, pos('.', S));
      while (Length(S1) > 2) and (S1[1] = '0') do delete(S1, 1, 1);
      result := result + S1;
   end;
   S1 := S;
   while (Length(S1) > 1) and (S1[1] = '0') do delete(S1, 1, 1);
   result := result + S1;
end;

function TForm1.Lesfichier(Path: string; var Lataille: Integer): TStringList;

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

procedure TForm1.Button1Click(Sender: TObject);
var
   tsl: tstringlist;
   i: integer;
   s: string;
   id: Integer;
   tslSrc: TstringList;
   ver: string;
   Taille: Integer;
   CRC: string;
   tc: Tconnexion;
   tc_ver: Tstringlist;
 //  tc_fic: Tstringlist;
begin
   Screen.Cursor := CrHourGlass;
   Tc := Tconnexion.create;
   try
      Tsl := TStringList.Create;
      try
         Tsl.LoadFromFile(edit1.text + 'SCRIPT.SCR');
         i := tsl.count - 1;
         while Copy(tsl[i], 1, 9) <> '<RELEASE>' do
            dec(i);
         S := Tsl[i];
         delete(S, 1, 9);
         S := traiteversion(S);
      finally
         tsl.free;
      end;
      Ver := copy(edit1.text, 1, length(edit1.text) - 1);
      while pos('\', ver) > 0 do
         delete(ver, 1, pos('\', ver));
      ver := uppercase(ver);

      tc_ver := tc.Select('Select * from version where version.version = "' + S+'"');
      if tc.recordCount(tc_ver) = 0 then
      begin
         id := tc.insert('insert into version (version, nomversion,Patch) values ("' + S + '","' + Ver + '",0)');
      end
      else
         id := tc.UneValeurEntiere(tc_ver, 'id');

      tc.FreeResult(tc_ver);
      tc.ordre ('delete from fichiers where id_ver='+InttoStr(id)) ;
      tslSrc := Lesfichier(edit1.text, Taille);
      PB.position := 0;
      PB.max := tslSrc.count;
      for i := 0 to tslSrc.count - 1 do
      begin
         PB.position := PB.position + 1;
         S := Uppercase(tslSrc[i]);

         if (extractfileext(s) <> '.SCR') and
            (extractfileext(s) <> '.ALG') then
         begin
            Label2.caption := S; Label2.Update;
            CRC := Inttostr(FileCRC32(edit1.text + S));
            tc.ordre ('insert into fichiers (id_ver,fichier,crc) values ('+InttoStr(id)+','''+S+''',"'+CRC+'") on duplicate KEY update crc="'+CRC+'"') ;
         end;
      end;
      PB.position := 0;
      Label2.caption := 'Enregistrement'; Label2.Update;
      fichiers.Validation;
      PB.position := 0;
      Label2.caption := ''; Label2.Update;
      fichiers.close;
      tslSrc.Free;
   finally
      Tc.free;
      Screen.Cursor := CrDefault;
   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   Label2.caption := '';
   Lab_fic.caption := '';
   Lab_rep.caption := '';
end;

procedure TForm1.fichiersValidate(Sender: TObject; Max, Actu: Integer);
begin
   PB.max := max;
   PB.position := actu;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
   CrePtcVersion: TCrePtcVersion;
begin
   application.createform(TCrePtcVersion, CrePtcVersion);
   try
      CrePtcVersion.execute;
   finally
      CrePtcVersion.release;
   end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
   ChxClient: TChxClient;
begin
   application.CreateForm(TChxClient, ChxClient);
   try
      ChxClient.execute;
   finally
      ChxClient.release;
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   ChxClient: TChxClient;
begin
   application.CreateForm(TChxClient, ChxClient);
   try
      ChxClient.executeFic;
   finally
      ChxClient.release;
   end;
end;

end.

