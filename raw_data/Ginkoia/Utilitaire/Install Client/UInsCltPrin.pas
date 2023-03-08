//$Log:
// 12   Utilitaires1.11        03/08/2007 08:35:14    pascal          Modif
//      divers
// 11   Utilitaires1.10        04/06/2007 14:08:22    pascal         
//      correction d'un mode des g?n?rateurs
// 10   Utilitaires1.9         05/10/2006 15:36:14    pascal          Modif
//      pour g?rer l'envois au lames
// 9    Utilitaires1.8         26/09/2006 11:02:54    pascal          rendu des
//      modifs
// 8    Utilitaires1.7         17/08/2006 09:03:16    pascal          erreur de
//      typo
// 7    Utilitaires1.6         17/08/2006 08:56:13    pascal          divers
//      correction (prob client)
// 6    Utilitaires1.5         04/08/2006 11:46:30    Sandrine MEDEIROS Test
//      sur la verion sup ? la 5.2 erron?
// 5    Utilitaires1.4         25/01/2006 14:57:01    pascal          -
//      Correction sur l'initialisation des mags et soci?t?s 
//      - Initialisation des clients
//      - Initialisation des donn?es de location
//      pour palier ? la transpo
// 4    Utilitaires1.3         22/11/2005 12:34:56    pascal          modif
//      divers
// 3    Utilitaires1.2         02/05/2005 16:56:31    pascal          Ajout du
//      VAD dans les modes de r?glement
// 2    Utilitaires1.1         28/04/2005 10:17:37    pascal         
//      Modification pour cr?er les encaissements sur les mag venant d'une
//      transpo husky
// 1    Utilitaires1.0         27/04/2005 15:53:36    pascal          
//$
//$NoKeywords$
//

unit UInsCltPrin;

interface

uses
   UCrc,
   ZLIBEX,
   UInstCltCst,
   Ginkoiaresstr,
   Creation_frm,
   ChxCfg_frm,
   Umapping,
   XMLCursor,
   StdXML_TLB,
   FileUtil,
   Split_frm,
   UInsCltCfg, inifiles, UWizard,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Menus, StdCtrls, Db, IBCustomDataSet, IBQuery, IBDatabase, IBSQL,
   IpUtils, IpSock, IpHttp, IpHttpClientGinkoia, Sock;

type
   TFrm_InstCltMain = class(TForm)
      MM_Prin: TMainMenu;
      Fichier1: TMenuItem;
      N2: TMenuItem;
      Installation1: TMenuItem;
      Crationdunfichierdinstall1: TMenuItem;
      Ouvrirunfichierdinstall1: TMenuItem;
      N3: TMenuItem;
      Installer1: TMenuItem;
      od: TOpenDialog;
      Lab_Etat: TLabel;
      data: TIBDatabase;
      tran: TIBTransaction;
      IBQue_ModifParam: TIBQuery;
      IBQue_Generateur: TIBQuery;
      IBQue_GenerateurNAME: TIBStringField;
      IBQue_Script: TIBQuery;
      IBQue_Champs: TIBQuery;
      IBQue_ChampsCHAMPS: TIBStringField;
      IBQue_Sites: TIBQuery;
      IBQue_SitesBAS_ID: TIntegerField;
      IBQue_SitesBAS_NOM: TIBStringField;
      IBQue_SitesBAS_IDENT: TIBStringField;
      IBQue_SitesBAS_JETON: TIntegerField;
      IBQue_SitesBAS_PLAGE: TIBStringField;
      IBQue_TrouveSite: TIBQuery;
      IntegerField1: TIntegerField;
      IBStringField1: TIBStringField;
      IBStringField2: TIBStringField;
      IntegerField2: TIntegerField;
      IBStringField3: TIBStringField;
      IBSql_Insert: TIBSQL;
      IBQue_NewKey: TIBQuery;
      IBQue_NewKeyNEWKEY: TIntegerField;
      IB_RECH: TIBQuery;
      OdBase: TOpenDialog;
      http: TIpHttpClientGinkoia;
      N4: TMenuItem;
      Configuration1: TMenuItem;
      N1: TMenuItem;
      Splitagedebase1: TMenuItem;
      IB_INITPSEUDOLOCTO: TIBSQL;
      IB_CRERCLTTO: TIBSQL;
      sock: TSock;
      procedure Configuration1Click(Sender: TObject);
      procedure N2Click(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure Crationdunfichierdinstall1Click(Sender: TObject);
      procedure Installer1Click(Sender: TObject);
      procedure Ouvrirunfichierdinstall1Click(Sender: TObject);
      procedure Splitagedebase1Click(Sender: TObject);
   private
      procedure OuvreBase(S: string);
      procedure InitModeEnc(socid, magid: string);
      procedure Envoie_fichier(Adresse, quoi, ou, eai, nomdatabase: string);
    { Déclarations privées }
   public
    { Déclarations publiques }
      Chemin: string;
      LeCrc: string;
      procedure Copier(Src, Dest: string);
      procedure Suprimer(Src: string);
      procedure commit;
      procedure Installation(Fichier, Base: string);
      procedure Recup_Generateur(Plage_pantin, Plage_Magasin: string; NumMagasin: Integer; Path, Sender, Database: string; Eai, Pantin, version: string);
      function insertK(KTB_ID: string): string;
      function NewId: string;
   end;

   TMinRec = record
      Tipe: byte;
      case integer of
         0: (taille: integer; Tipe2: Integer; );
         1: (crc: LongWord);
   end;

   TunBlock = record
      num: integer;
      size: integer;
      buf: array[0..32000] of byte;
   end;

   TNomFich = record
      tipe: integer;
      NomFich: string[255];
      size: integer;
   end;

   TunBuf = record
      tipe: byte;
      case integer of
         0: (
            tipe2: integer;
            size: integer;
            vsize: integer;
            pt: pointer);
         1: (crc: LongWord);
   end;


   TSockSendThread = class(TThread)
   private
      ClientSock: TSock;
   public
      Actu, encours: integer;
      Buf: array[0..64000] of TunBuf;
      constructor Create(Sock: TSock);
      procedure Execute; override;
   end;

   TCrcThread = class(TThread)
   public
      Fich: string;
      Crc: LongWord;
      constructor Create(fichier: string);
      procedure Execute; override;
   end;

var
   Frm_InstCltMain: TFrm_InstCltMain;

implementation

{$R *.DFM}

procedure TFrm_InstCltMain.OuvreBase(S: string);
begin
   if tran.InTransaction then
      tran.commit;
   data.close;
   Data.DatabaseName := S;
   data.Open;
   Tran.Active := true;
end;

procedure TFrm_InstCltMain.commit;
begin
   if tran.InTransaction then
      tran.commit;
   tran.Active := true;
end;

procedure TFrm_InstCltMain.Configuration1Click(Sender: TObject);
var
   ini: tinifile;
   frm_ChxCfg: Tfrm_ChxCfg;
begin
   application.Createform(tfrm_ChxCfg, frm_ChxCfg);
   frm_ChxCfg.edit1.text := Chemin;
   if frm_ChxCfg.ShowModal = MrOk then
   begin
      Chemin := frm_ChxCfg.edit1.text;
      if chemin[length(chemin)] <> '\' then
         chemin := chemin + '\';
      ini := tinifile.Create(Changefileext(application.exename, '.ini'));
      ini.Writestring('DEFAULT', 'CHEMIN', Chemin);
      ini.free;
   end;
   frm_ChxCfg.release;
end;

procedure TFrm_InstCltMain.N2Click(Sender: TObject);
begin
   Close;
end;

procedure TFrm_InstCltMain.FormCreate(Sender: TObject);
var
   tsl: tstringlist;
   ini: tinifile;
begin
   Lab_Etat.Caption := '';
   if http.GetWait('http://replic2.algol.fr/maj/GINKOIA/recupbase.ini') then
   begin
      tsl := tstringlist.create;
      tsl.text := http.AsString('http://replic2.algol.fr/maj/GINKOIA/recupbase.ini');
      tsl.SaveToFile(IncludeTrailingBackslash(ExtractFilePath(application.exename)) + 'RecupBase.ini');
      tsl.free;
   end
   else
   begin
      application.MessageBox('Impossible de récupérer le fichier de définition des générateurs'#13#10 +
         'Vérifier votre connexion à Internet, vous risquez si vous continuez d''endommager la réplication'
         , 'ATTENTION', Mb_Ok);
   end;
   ini := tinifile.Create(Changefileext(application.exename, '.ini'));
   Chemin := ini.readstring('DEFAULT', 'CHEMIN', '\\Liveup\liveupdate\');
   ini.free;
end;

procedure TFrm_InstCltMain.Crationdunfichierdinstall1Click(
   Sender: TObject);
var
   tsl: tstringList;
var
   Frm_Creation: TFrm_Creation;
begin
   application.CreateForm(TFrm_Creation, Frm_Creation);
   Frm_Creation.Initialise;
   if Frm_Creation.ShowModal = mrok then
   begin
      tsl := TStringList.create;
      tsl.Text := Frm_Creation.Install.ToXml('');
      ForceDirectories(IncludeTrailingBackslash(ExtractFilePath(application.exename)) + 'Xml_Client\');
      tsl.savetofile(IncludeTrailingBackslash(ExtractFilePath(application.exename)) + 'Xml_Client\' + Frm_Creation.Install.Nom_Clt + '.XML');
      tsl.free;
   end;
   Frm_Creation.release;
end;

procedure TFrm_InstCltMain.Installer1Click(Sender: TObject);
begin
 //
   if od.execute then
   begin
      Installation(Od.FileName, '');
      application.MessageBox('Installation terminée', 'Avertissement', Mb_Ok);
      close ;
   end;
 //
end;

procedure TFrm_InstCltMain.Copier(Src, Dest: string);
var
   f: TSearchRec;
begin
   ForceDirectories(Dest);
   if FindFirst(src + '*.*', faAnyFile, F) = 0 then
   begin
      repeat
         if (f.name <> '.') and (f.name <> '..') then
         begin
            if (f.attr and Fadirectory) = Fadirectory then
            begin
               Copier(src + f.name + '\', dest + f.name + '\');
            end
            else
            begin
               Lab_Etat.Caption := 'Copie de ' + src + f.name + #10#13 + ' vers ' + dest + f.name;
               Lab_Etat.Update;
               CopyFile(Pchar(src + f.name), Pchar(dest + f.name), False);
            end;
         end;
      until findnext(f) <> 0;
   end;
   findclose(f);
end;

procedure TFrm_InstCltMain.Recup_Generateur(Plage_pantin,
   Plage_Magasin: string; NumMagasin: Integer; Path, Sender, Database: string; Eai, Pantin, version: string);

   procedure transforme(TAG, Valeur: string; var S2: string);
   var
      i: Integer;
   begin
      while pos('<' + TAG + '>', S2) > 0 do
      begin
         i := pos('<' + TAG + '>', S2);
         delete(S2, i, length('<' + TAG + '>'));
         while s2[i] <> '<' do delete(s2, i, 1);
         INSERT('<@@>' + Valeur, S2, I);
      end;
      while pos('<@@>', S2) > 0 do
      begin
         i := pos('<@@>', S2);
         delete(S2, i, length('<@@>'));
         INSERT('<' + TAG + '>', S2, I);
      end;
   end;

   procedure decodeplage(S: string; var Deb, fin: integer);
   begin
      if Pos('[', S) = 1 then
         delete(S, 1, 1);
      deb := Strtoint(copy(S, 1, pos('M', S) - 1));
      if Pos('_', S) > 0 then
         delete(S, 1, pos('_', S))
      else
         delete(S, 1, pos('-', S));
      fin := Strtoint(copy(S, 1, pos('M', S) - 1));
   end;

var
   ini: tinifile;
   deb, fin: Integer;
   deb2, fin2: Integer;
   def: integer;
   minimum: integer;
   num: Integer;
   num2: Integer;
   J: Integer;
   k: Integer;
   S: string;
   Table: string;
   Champs: string;
   Plus: string;
   Pass: string;

   genid: Integer;
   genidpantin: Integer;

   Tsl: TstringList;

   Generateur: string;

begin
   ini := tinifile.create(IncludeTrailingBackslash(ExtractFilePath(application.exename)) + 'RecupBase.ini');
   try
      decodeplage(Plage_Magasin, deb, fin);
      decodeplage(plage_Pantin, deb2, fin2);
      IBQue_Generateur.Open;
      GenIdPantin := 0;
      GenId := 0;
      while not IBQue_Generateur.EOF do
      begin
         Generateur := trim(IBQue_GenerateurNAME.AsString);
         def := ini.readinteger(Generateur, 'Def', 0);
         minimum := ini.readinteger(Generateur, 'Min', -9999);
         if def = 6 then // à 0
         begin
            IBQue_Script.sql.clear;
            IBQue_Script.sql.Add('SET GENERATOR ' + Generateur + ' to 0 ');
            IBQue_Script.ExecSQL;
         end
         else if def = 1 then // plage
         begin
            Num := 0;
            if Uppercase(Generateur) = 'GENERAL_ID' then
            begin // Pantin
               num := 0;
               j := ini.readinteger(Generateur, 'NbTable', 0);
               for j := 1 to j do
               begin
                  S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
                  Table := copy(S, 1, pos(';', S) - 1);
                  Champs := copy(S, pos(';', S) + 1, 255);
                  IBQue_Script.sql.text := 'Select Max(' + Champs + ') from ' + table + ' where ' + Champs + ' between ' + Inttostr(deb2) + '*1000000 and ' + Inttostr(fin2) + '*1000000 ';
                  IBQue_Script.Open;
                  if not (IBQue_Script.fields[0].IsNull) and (IBQue_Script.fields[0].Asinteger > Num) then
                     Num := IBQue_Script.fields[0].Asinteger;
                  IBQue_Script.Close;
               end;
               if num < deb2 * 1000000 then
                  num := deb2 * 1000000;
               if num < minimum then
                  num := minimum;
               genidpantin := Num;
            end;
            if (Uppercase(Generateur) = 'GENERAL_ID') and
               (NumMagasin = 0) then
            begin
               genid := genidpantin;
               IBQue_Script.sql.Text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
               IBQue_Script.ExecSQL;
            end
            else
            begin
               num := 0;
               j := ini.readinteger(Generateur, 'NbTable', 0);
               for j := 1 to j do
               begin
                  S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
                  Table := copy(S, 1, pos(';', S) - 1);
                  Champs := copy(S, pos(';', S) + 1, 255);
                  IBQue_Script.sql.text := 'Select Max(' + Champs + ') from ' + table + ' where ' + Champs + ' between ' + Inttostr(deb) + '*1000000 and ' + Inttostr(fin) + '*1000000 ';
                  IBQue_Script.Open;
                  if not (IBQue_Script.fields[0].IsNull) and (IBQue_Script.fields[0].Asinteger > Num) then
                     Num := IBQue_Script.fields[0].Asinteger;
                  IBQue_Script.Close;
               end;
               if num < deb * 1000000 then
                  num := deb * 1000000;
               if num < minimum then
                  num := minimum;
               IBQue_Script.sql.Text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
               IBQue_Script.ExecSQL;
               if (Uppercase(Generateur) = 'GENERAL_ID') and (NumMagasin <> 0) then
                  genid := Num;
            end;
         end
         else if def = 2 then // magasin+plage
         begin
            num := 0;
            j := ini.readinteger(Generateur, 'NbTable', 0);
            for j := 1 to j do
            begin
               S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
               Table := copy(S, 1, pos(';', S) - 1);
               delete(S, 1, pos(';', S));
               if pos(';', S) > 0 then
               begin
                  Champs := copy(S, 1, pos(';', S) - 1);
                  delete(S, 1, pos(';', S));
                  plus := S;
               end
               else
               begin
                  Champs := S;
                  plus := '';
               end;
               IBQue_Script.sql.text := 'select Max( Cast(f_mid (' + Champs + ',' + InttoStr(Length(Inttostr(NumMagasin)) + 1) + ',12) as integer)) from ' + table + ' where ' + Champs + ' Like ''' + Inttostr(NumMagasin) + '-%'''+
                 'and not '+Champs+' Like ''%R''' ;
               if plus <> '' then
                  IBQue_Script.sql.text := IBQue_Script.sql.text + 'AND ' + Plus;
               IBQue_Script.Open;
               if (not IBQue_Script.eof) and (not IBQue_Script.fields[0].IsNull) and (IBQue_Script.fields[0].Asinteger > Num) then
                  Num := IBQue_Script.fields[0].Asinteger;
               IBQue_Script.Close;
            end;
            if num < minimum then
               num := minimum;
            IBQue_Script.sql.TEXT := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
            IBQue_Script.ExecSQL;
         end
         else if def = 5 then // magasin+(M)+plage
         begin
            num := 0;
            j := ini.readinteger(Generateur, 'NbTable', 0);
            for j := 1 to j do
            begin
               S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
               Table := copy(S, 1, pos(';', S) - 1);
               delete(S, 1, pos(';', S));
               if pos(';', S) > 0 then
               begin
                  Champs := copy(S, 1, pos(';', S) - 1);
                  delete(S, 1, pos(';', S));
                  plus := S;
               end
               else
               begin
                  Champs := S;
                  plus := '';
               end;
               IBQue_Script.sql.text := 'select Max( Cast(f_mid (' + Champs + ',' + InttoStr(Length(Inttostr(NumMagasin)) + 2) + ',12) as integer)) from ' + table + ' where ' + Champs + ' Like ''' + Inttostr(NumMagasin) + '-%'''+
                 'and not '+Champs+' Like ''%R''' ;
               if plus <> '' then
                  IBQue_Script.sql.text := IBQue_Script.sql.text + 'AND ' + Plus;
               IBQue_Script.Open;
               if (not IBQue_Script.eof) and (not IBQue_Script.fields[0].IsNull) and (IBQue_Script.fields[0].Asinteger > Num) then
                  Num := IBQue_Script.fields[0].Asinteger;
               IBQue_Script.Close;
            end;
            if num < minimum then
               num := minimum;
            IBQue_Script.sql.text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
            IBQue_Script.execSql;
         end
         else if def = 3 then // pas de plage
         begin
            num := 0;
            j := ini.readinteger(Generateur, 'NbTable', 0);
            for j := 1 to j do
            begin
               S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
               Table := copy(S, 1, pos(';', S) - 1);
               Champs := copy(S, pos(';', S) + 1, 255);
               IBQue_Script.sql.text := 'Select Max(' + Champs + ') from ' + table;
               IBQue_Script.Open;
               if not (IBQue_Script.fields[0].IsNull) and (IBQue_Script.fields[0].Asinteger > Num) then
                  Num := IBQue_Script.fields[0].Asinteger;
               IBQue_Script.Close;
            end;
            if num < minimum then
               num := minimum;
            IBQue_Script.sql.Text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
            IBQue_Script.execSql;
         end
         else if def = 4 then // Code Barre
         begin
            num := 0;
            j := ini.readinteger(Generateur, 'NbTable', 0);
            for j := 1 to j do
            begin
               S := ini.readString(Generateur, 'Table' + Inttostr(j), '');
               Table := copy(S, 1, pos(';', S) - 1);
               IBQue_Champs.ParamByName('Nom').AsString := Table;
               IBQue_Champs.Open;
               IBQue_Champs.First;
               Pass := IBQue_ChampsCHAMPS.AsString;
               IBQue_Champs.Close;
               delete(S, 1, pos(';', S));
               if pos(';', S) > 0 then
               begin
                  Champs := copy(S, 1, pos(';', S) - 1);
                  delete(S, 1, pos(';', S));
                  plus := S;
               end
               else
               begin
                  Champs := S;
                  plus := '';
               end;
               IBQue_Script.sql.text := 'Select ' + Champs + ' from ' + Table + ' Where ' + Pass + ' = (' +
                  'Select Max(' + Pass + ') from ' + Table + ' Where ' + Pass + ' Between ' + Inttostr(deb) + '*1000000 and ' + Inttostr(fin) + '*1000000 ';
               if plus <> '' then
                  IBQue_Script.sql.Add('AND ' + Plus + ')')
               else
                  IBQue_Script.sql.Add(')');
               try
                  IBQue_Script.Open;
                  Num := 0;
                  if not (IBQue_Script.fields[0].IsNull) then
                  begin
                     S := IBQue_Script.fields[0].AsString;
                     Delete(S, 1, 4);
                     Delete(S, length(S), 1);
                     Val(S, Num2, k);
                     if k = 0 then
                     begin
                        if Num < Num2 then
                           Num := Num2;
                     end;
                  end
                  else
                     Num := 0;
                  IBQue_Script.Close;
               except
                  Num := 0;
               end;
            end;
            if num < minimum then
               num := minimum;
            IBQue_Script.sql.Text := 'SET GENERATOR ' + Generateur + ' to ' + Inttostr(num) + ';';
            IBQue_Script.ExecSQL;
         end;
         IBQue_Generateur.Next;
      end;
      IBQue_Generateur.Close;
      Commit;

      if (NumMagasin <> 0) and (trim(EAI) <> '') then
      begin
         if copy(version, 1, 1) <> 'V' then
            version := 'V' + version;
         ForceDirectories(Path);
         Tsl := TstringList.Create;
         try
            tsl.loadfromfile(EAI + 'DelosQPMAgent.Providers.xml');
            S := Tsl.text;

            transforme('URL', Pantin + version + '/DelosQPMAgent.dll/Batch', S);
            transforme('Sender', Sender, S);
            transforme('Database', Database, S);
            transforme('LAST_VERSION', Inttostr(GenId), S);
            Tsl.Text := S;
            tsl.savetofile(Path + '\DelosQPMAgent.Providers.xml');

            tsl.loadfromfile(EAI + 'DelosQPMAgent.Subscriptions.xml');
            S := Tsl.text;
            transforme('URL', Pantin + version + '/DelosQPMAgent.dll/Extract', S);
            transforme('GetCurrentVersion', Pantin + version + '/DelosQPMAgent.dll/GetCurrentVersion', S);

            transforme('Sender', Sender, S);
            transforme('Database', database, S);
            transforme('LAST_VERSION', Inttostr(genidpantin), S);
            Tsl.Text := S;
            tsl.savetofile(Path + '\DelosQPMAgent.Subscriptions.xml');

            tsl.loadfromfile(EAI + 'DelosQPMAgent.InitParams.xml');
            S := Tsl.text;
            transforme('QPM_BatchException', Pantin + Version + '/DelosQPMAgent.dll/InsertLOG', S);
            transforme('QPM_ExtractException', Pantin + Version + '/DelosQPMAgent.dll/InsertLOG', S);
            transforme('QPM_PullDone', Pantin + Version + '/DelosQPMAgent.dll/InsertLOG', S);
            transforme('QPM_PullException', Pantin + Version + '/DelosQPMAgent.dll/InsertLOG', S);
            transforme('QPM_PushDone', Pantin + Version + '/DelosQPMAgent.dll/InsertLOG', S);
            transforme('QPM_PushException', Pantin + Version + '/DelosQPMAgent.dll/InsertLOG', S);
            Tsl.Text := S;
            tsl.savetofile(Path + '\DelosQPMAgent.InitParams.xml');
         finally
            tsl.free;
         end;
      end;
   finally
      ini.free;
   end;
end;

function TFrm_InstCltMain.insertK(KTB_ID: string): string;
var
   id: string;
begin
   id := NewId;
   with IBSql_Insert.Sql do
   begin
      clear;
      add('INSERT INTO K');
      add('  (K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,KSE_DELETE_ID,K_DELETED,KSE_UPDATE_ID,K_UPDATED,KSE_LOCK_ID,KMA_LOCK_ID)');
      add('VALUES');
      Add('(' + id + ',-101,' + KTB_ID + ',' + id + ',1,-1,-1,Current_timestamp,0,''12/30/1899'',-1,Current_timestamp,0,0);');
   end;
   IBSql_Insert.ExecQuery;
   Commit;
   result := id;
end;

function TFrm_InstCltMain.NewId: string;
begin
   IBQue_NewKey.Prepare;
   IBQue_NewKey.Open;
   result := Inttostr(IBQue_NewKeyNEWKEY.AsInteger);
   IBQue_NewKey.Close;
   IBQue_NewKey.UnPrepare;
end;

procedure TFrm_InstCltMain.InitModeEnc(socid, magid: string);
var
   i: integer;
var
   BQEID: string;
   CFFID: string;

   function insertModeEnc(nom, ident, couleur, RACCOURCI, ouvre, sup, verifi,
      TYPEMOD, TYPETRF, ISODEF, RAPIDO: string): string;
   var
      menid: string;
   begin
      MenID := InsertK(K_MENID);
      result := MenID;
      with IBSql_Insert.Sql do
      begin
         clear;
         Add('INSERT INTO CSHMODEENC');
         Add('(MEN_ID, MEN_MAGID, MEN_NOM, MEN_IDENT, MEN_COULEUR, ' +
            'MEN_RACCOURCI, MEN_COMPTA, MEN_TXCHANGE, MEN_PRECISION,' +
            'MEN_BQEID, MEN_CFFID, MEN_OUVTIROIR, MEN_MONTSUP, MEN_VERIF,' +
            'MEN_FONDVARI, MEN_DETAIL, MEN_DATEECH, MEN_MONTREST, ' +
            'MEN_TYPEMOD, MEN_TYPETRF, MEN_ISODEF, MEN_RAPIDO, ' +
            'MEN_ICONE, MEN_DOC, MEN_TPE, MEN_CFFCENTRAL, ' +
            'MEN_APPLICATION, MEN_REMISEOTO)');
         Add('VALUES');
         Add('(' + menid + ', ' + MagId + ', ' + Quotedstr(Nom) + ', ' + Quotedstr(Ident) + ', ' + Quotedstr(Couleur) + ',' +
            Quotedstr(Raccourci) + ','''', 0, 0,' +
            Bqeid + ',' + Cffid + ',' + ouvre + ',' + Sup + ',' + verifi + ',' +
            ' 0, 0, 0, 0,' +
            TypeMod + ',' + TypeTrf + ',' + QuotedStr(ISODEF) + ',' + RAPIDO + ',' +
            ''''', 0, 0, ' + CFFID + ', 0, 0)');
      end;
      IBSql_Insert.ExecQuery; commit;
   end;

var
   espID: string;
   Medid: string;
const
   L: array[0..14] of string = ('Billet 500 EUR', 'Billet 200 EUR', 'Billet 100 EUR', 'Billet 50 EUR', 'Billet 20 EUR', 'Billet 10 EUR', 'Billet 5 EUR',
      'Pièce 2 EUR', 'Pièce 1 EUR', 'Pièce 50 cts', 'Pièce 20 cts', 'Pièce 10 cts', 'Pièce 5 cts', 'Pièce 2 cts', 'Pièce 1 cts');
   V: array[0..14] of string = ('500', '200', '100', '50', '20', '10', '5', '2', '1', '0.5', '0.2', '0.1', '0.05', '0.02', '0.01');

begin
   with IB_RECH.Sql do
   begin
      Clear;
      Add('SELECT BQE_ID');
      Add('  from CSHBANQUE');
      Add(' Where BQE_SOCID=' + socid);
   end;
   IB_RECH.Open;
   if IB_RECH.IsEmpty then
   begin
      BQEID := InsertK(K_BQE);
      with IBSql_Insert.Sql do
      begin
         clear;
         Add('INSERT INTO CSHBANQUE');
         Add('  (BQE_ID,BQE_NOM,BQE_COMPTA,BQE_SOCID)');
         Add('VALUES');
         Add('  (' + bqeid + ',' + Quotedstr(CstLaBanque) + ','''',' + Socid + ')');
      end;
      IBSql_Insert.ExecQuery; commit;
   end
   else
      BQEID := IB_RECH.fields[0].AsString;
   IB_RECH.Close;

   CFFID := InsertK(K_CFFID);
   with IBSql_Insert.Sql do
   begin
      clear;
      Add('INSERT INTO CSHCOFFRE');
      Add('  (CFF_ID,CFF_MAGID,CFF_NOM,CFF_COMPTA)');
      Add('VALUES');
      Add('  (' + cffid + ',' + MagID + ',' + Quotedstr(CstLeCoffre) + ','''')');
   end;
   IBSql_Insert.ExecQuery; commit;

    //********ESPECE************
   espID := insertModeEnc(CstEspece, CstEspece, '1', '', '1', '1', '1', '4', '1', '', '1');
   for i := 0 to High(L) do
   begin
      Medid := InsertK(K_MEDID);
      with IBSql_Insert.Sql do
      begin
         clear;
         Add('INSERT INTO CSHMODEENCDETAIL');
         Add('  (MED_ID,MED_MENID,MED_LIBELLE,MED_MONTANT)');
         Add('VALUES');
         Add('  (' + medid + ',' + espid + ',' + QuotedStr(L[i]) + ',' + V[i] + ')');
      end;
      IBSql_Insert.ExecQuery; commit;
   end;
   insertModeEnc(CstCheque, CstCheque, '2', 'CHQ', '1', '0', '1', '5', '1', '', '1');
   insertModeEnc(CstCarteBleu, 'CB', '3', '', '1', '0', '0', '5', '1', '', '1');
   insertModeEnc(cstBonAchInt, 'BA INT.', '6', '', '1', '1', '1', '3', '0', '', '0');
   insertModeEnc(cstBonAchExt, 'BA EXT.', '7', '', '1', '0', '1', '5', '0', '', '0');
   insertModeEnc(CstRemiseFidelite, 'REM CF', '8', '', '0', '0', '0', '3', '0', '', '0');
   insertModeEnc(CstCompteClient, 'CPTES CLT', '9', '', '0', '0', '0', '1', '0', '', '0');
   insertModeEnc(CstResteDu, CstResteDu, '10', '', '0', '0', '0', '1', '0', '', '0');
   insertModeEnc(CstAutreCarte, 'AUT. CTES', '11', '', '1', '0', '1', '5', '1', '', '0');
   insertModeEnc(CstVirement, CstVirement, '12', '', '0', '0', '0', '5', '1', '', '0');
   insertModeEnc(CstChequeVacance, 'CHQ VAC.', '13', '', '1', '0', '1', '5', '0', '', '0');
   insertModeEnc('VAD RESERVATION', 'VAD', '3', '', '1', '0', '0', '5', '1', '', '1');
end;

procedure TFrm_InstCltMain.Installation(Fichier, Base: string);
var
   Frm_Creation: TFrm_Creation;
   Install: TUneInstall;
   S1,
      S: string;
   FicBase: string;
   PlagePantin: string;
   NbSites: Integer;
   i, j: integer;
   NomSite: string;
   id: string;
   Ident, Jeton, Plage: string;
   soci, Magi, posi: Integer;
   idsoc, idmag, idposte: string;
   vilid: string;
   adrid: string;
   MGCID: string;
   MCFID: string;
   MCCID: string;
   PRMID: string;
   tsl: tstringlist;
   NomMag: string;
   PlageMagasin: string;
   NumMag: integer;
   ini: tinifile;
   PassXML: IXMLCursor;
   Ver52plus: boolean;
begin
   Application.createform(TFrm_Creation, Frm_Creation);
   Frm_Creation.loadxml(Fichier, Base);
   Install := Frm_Creation.Install;

   if not (FileExists(install.BD_ref)) then
   begin
      Application.MessageBox('La base référence n''existe pas', 'Erreur', mb_ok);
      EXIT;
   end;
   if (not FileExists(Chemin + 'EAIGENE\EAI\SharedPortal\Monitoring\Available.gif')) or
      (not FileExists(Chemin + Install.Eai + '\DelosQPMAgent.Providers.xml')) then
   begin
      chemin := IncludeTrailingBackslash(extractfilepath(application.exename));
   end;
   if (not FileExists(Chemin + 'EAIGENE\EAI\SharedPortal\Monitoring\Available.gif')) or
      (not FileExists(Chemin + Install.Eai + '\DelosQPMAgent.Providers.xml')) then
   begin
      Application.MessageBox('LES EAI NE SONT PAS PRESENT', 'IMPOSSIBLE', MB_OK);
      EXIT;
   end;
   if not FileExists(Chemin + 'EAIGENE\SCRIPT.EXE') then
   begin
      Application.MessageBox('SCRIPT.EXE N''EXISTE PAS', 'IMPOSSIBLE', MB_OK);
      EXIT;
   end;
   if (not FileExists(Chemin + Install.Version + '\script.scr')) then
   begin
      Application.MessageBox('La version n''existe pas', 'Erreur', mb_ok);
      EXIT;
   end;
   install.Rep_Dest := IncludeTrailingBackslash(install.Rep_Dest);
   // Création du répertoire
   ForceDirectories(install.Rep_Dest);
   ForceDirectories(install.Rep_Dest + 'origine');
   // Copie des Eai
   Lab_Etat.Caption := 'Copie des EAI'; Lab_Etat.Update;

   S := Chemin + 'EAIGENE\EAI\';
   Copier(S, install.Rep_Dest + 'origine\EAI\');
   S := Chemin + Install.Eai + '\';
   Copier(S, install.Rep_Dest + 'origine\EAI\');

        // Copie de la version de départ
   Lab_Etat.Caption := 'Copie de la version'; Lab_Etat.Update;
   Copier(Chemin + Install.Version + '\', install.Rep_Dest + 'origine\');

        // Copie de Script.exe
   Lab_Etat.Caption := 'Copie de SCRIPT.EXE'; Lab_Etat.Update;
   CopyFile(Pchar(Chemin + 'EAIGENE\SCRIPT.EXE'), Pchar(install.Rep_Dest + 'SCRIPT.EXE'), False);

        // Copie de la base
   Lab_Etat.Caption := 'Copie de ' + Install.BD_ref + ' vers ' + install.Rep_Dest + 'GINKOIA.IB';
   Lab_Etat.Update;
   CopyFile(Pchar(Install.BD_ref), Pchar(install.Rep_Dest + 'GINKOIA.IB'), False);
   FicBase := install.Rep_Dest + 'GINKOIA.IB';

   Lab_Etat.Caption := '';
   Lab_Etat.Update;

   Lab_Etat.Caption := 'Mise à jour de la base de départ'; Lab_Etat.Update;
   OuvreBase(FicBase);

   IBQue_ModifParam.ParamByName('ID').AsString := '0';
   IBQue_ModifParam.ExecSQL;
   Commit;
   IBQue_Sites.Open;
   IBQue_Sites.First;
   while IBQue_SitesBAS_IDENT.AsString <> '0' do
      IBQue_Sites.next;
   NbSites := IBQue_Sites.recordCount;
   PlagePantin := IBQue_SitesBAS_PLAGE.AsString;
   Recup_Generateur(PlagePantin, PlagePantin, 0, '', '', '', '', '', '');


        // Scripting de la Base
   CopyFile(Pchar(install.Rep_Dest + 'origine\SCRIPT.SCR'), Pchar(install.Rep_Dest + 'SCRIPT.SCR'), False);
   if tran.InTransaction then
      tran.Commit;
   data.close;
   Lab_Etat.Caption := 'Scripting de la base'; Lab_Etat.Update;
   Winexec(Pchar(install.Rep_Dest + 'Script.exe UNEBASE ' + install.Rep_Dest + 'GINKOIA.IB'), 0);
   for i := 1 to 10 do
   begin
      Application.processmessages;
      Sleep(1000);
   end;
   while MapGinkoia.Script do
   begin
      Application.processmessages;
      Sleep(10000);
   end;
   for i := 1 to 10 do
   begin
      Application.processmessages;
      Sleep(1000);
   end;

   data.Open;
   tran.Active := true;
   // test si version 5.2 ou sup
   Ver52plus := false;
   S := install.Version;
   delete(s, 1, 1); // on enlève le V
   S1 := copy(s, 1, pos('.', s) - 1);
   delete(S, 1, pos('.', s));
   if (Strtoint(S1) >= 5) then
   begin
      if (Strtoint(S1) = 5) then
      begin
         S1 := copy(s, 1, pos('.', s) - 1);
         if Strtoint(S1) > 1 then
         begin
            Ver52plus := true;
         end;
      end
      else Ver52plus := true;
   end;
   Lab_Etat.Caption := 'Problème clients'; Lab_Etat.Update;
   IBSql_Insert.sql.text := 'UPDATE CLTCLIENT SET CLT_TOCLTID=0 where CLT_TOCLTID is null';
   IBSql_Insert.ExecQuery;
   commit;
   IBSql_Insert.sql.text := 'UPDATE CLTCLIENT SET CLT_IDTHEO=0 where CLT_IDTHEO is null';
   IBSql_Insert.ExecQuery;
   commit;
   IBSql_Insert.sql.text := 'UPDATE CLTCLIENT SET CLT_TOSUPPLEMENT=0 where CLT_TOSUPPLEMENT is null';
   IBSql_Insert.ExecQuery;
   commit;
   IBSql_Insert.sql.text := 'UPDATE CLTCLIENT SET CLT_NMODIF=0 where CLT_NMODIF is null';
   IBSql_Insert.ExecQuery;
   commit;
   IBSql_Insert.sql.text := 'UPDATE CLTCLIENT SET clt_compta='''' where clt_compta is null';
   IBSql_Insert.ExecQuery;
   commit;
   Lab_Etat.Caption := 'Création des sites'; Lab_Etat.Update;
   for i := 0 to Install.LesSites.count - 1 do
   begin
      Lab_Etat.Caption := 'Création du site ' + Install.Sites[i].Nom; Lab_Etat.Update;
      if not (Install.Sites[i].Existe) then
      begin
         NomSite := 'SERVEUR_' + Install.Sites[i].Nom + '-' + Install.Id_court;
         IBQue_TrouveSite.ParamByName('NOM').AsString := NomSite;
         IBQue_TrouveSite.Open;
         if IBQue_TrouveSite.IsEmpty then
         begin
            Ident := Inttostr(NbSites);
            Jeton := IntToStr(Install.Sites[i].Jetons);
            if NbSites = 0 then
               plage := '[170M_300M]'
            else if NbSites = 1 then
               plage := '[0M_50M]'
            else if NbSites = 2 then
               plage := '[50M_90M]'
            else if NbSites = 3 then
               plage := '[90M_130M]'
            else if NbSites = 4 then
               plage := '[130M_170M]'
            else
            begin
               Plage := '[' + Inttostr((NbSites - 5) * 40 + 300) + 'M_' + Inttostr((NbSites - 4) * 40 + 300) + 'M]';
            end;
            id := insertK(K_Base);
            with IBSql_Insert.Sql do
            begin
               clear;
               Add('INSERT INTO GENBASES');
               Add('  (BAS_ID,BAS_NOM,BAS_IDENT,BAS_JETON,BAS_PLAGE)');
               Add('VALUES');
               Add('  (' + id + ',''' + NomSite + ''',''' + Ident + ''',' + Jeton + ',''' + Plage + ''');');
            end;
            IBSql_Insert.ExecQuery;
            commit;
            if Ver52plus then
            begin
              // appeler la procedure d'initialisation d'une base
               S := install.Rep_Site;
               delete(s, 1, 7); delete(s, length(S), 1);
               IBSql_Insert.sql.text := 'execute procedure PR_INITBASE (' + id + ',''' + s + ''',''' + install.eai + ''')';
               IBSql_Insert.ExecQuery;
               commit;
            end;
            Inc(NbSites);
         end;
         IBQue_TrouveSite.Close;

         if Install.Sites[i].CA then
         begin
            NomSite := 'SERVEUR_' + Install.Sites[i].Nom + '-' + Install.Id_court + '_SEC';
            IBQue_TrouveSite.ParamByName('NOM').AsString := NomSite;
            IBQue_TrouveSite.Open;
            if IBQue_TrouveSite.IsEmpty then
            begin
               Ident := Inttostr(NbSites);
               Jeton := IntToStr(Install.Sites[i].Jetons);
               if NbSites = 0 then
                  plage := '[170M_300M]'
               else if NbSites = 1 then
                  plage := '[0M_50M]'
               else if NbSites = 2 then
                  plage := '[50M_90M]'
               else if NbSites = 3 then
                  plage := '[90M_130M]'
               else if NbSites = 4 then
                  plage := '[130M_170M]'
               else
               begin
                  Plage := '[' + Inttostr((NbSites - 5) * 40 + 300) + 'M_' + Inttostr((NbSites - 4) * 40 + 300) + 'M]';
               end;
               id := insertK(K_Base);
               with IBSql_Insert.Sql do
               begin
                  clear;
                  Add('INSERT INTO GENBASES');
                  Add('  (BAS_ID,BAS_NOM,BAS_IDENT,BAS_JETON,BAS_PLAGE)');
                  Add('VALUES');
                  Add('  (' + id + ',''' + NomSite + ''',''' + Ident + ''',' + Jeton + ',''' + Plage + ''');');
               end;
               IBSql_Insert.ExecQuery;
               commit;
               if Ver52plus then
               begin
                  // appeler la procedure d'initialisation d'une base
                  S := install.Rep_Site;
                  delete(s, 1, 7); delete(s, length(S), 1);
                  IBSql_Insert.sql.text := 'execute procedure PR_INITBASE (' + id + ',''' + s + ''',''' + install.eai + ''')';
                  IBSql_Insert.ExecQuery;
                  commit;
               end;
               Inc(NbSites);
            end;
            IBQue_TrouveSite.Close;
         end;

         for j := 1 to Install.Sites[i].NoteBook do
         begin
            NomSite := 'NB' + Inttostr(j) + '_' + Install.Sites[i].Nom + '-' + Install.Id_court;
            IBQue_TrouveSite.ParamByName('NOM').AsString := NomSite;
            IBQue_TrouveSite.Open;
            if IBQue_TrouveSite.IsEmpty then
            begin
               Ident := Inttostr(NbSites);
               Jeton := '1';
               if NbSites = 0 then
                  plage := '[170M_300M]'
               else if NbSites = 1 then
                  plage := '[0M_50M]'
               else if NbSites = 2 then
                  plage := '[50M_90M]'
               else if NbSites = 3 then
                  plage := '[90M_130M]'
               else if NbSites = 4 then
                  plage := '[130M_170M]'
               else
               begin
                  Plage := '[' + Inttostr((NbSites - 5) * 40 + 300) + 'M_' + Inttostr((NbSites - 4) * 40 + 300) + 'M]';
               end;
               id := insertK(K_Base);
               with IBSql_Insert.Sql do
               begin
                  clear;
                  Add('INSERT INTO GENBASES');
                  Add('  (BAS_ID,BAS_NOM,BAS_IDENT,BAS_JETON,BAS_PLAGE)');
                  Add('VALUES');
                  Add('  (' + id + ',''' + NomSite + ''',''' + Ident + ''',' + Jeton + ',''' + Plage + ''');');
               end;
               IBSql_Insert.ExecQuery;
               commit;
               if Ver52plus then
               begin
                  // appeler la procedure d'initialisation d'une base
                  S := install.Rep_Site;
                  delete(s, 1, 7); delete(s, length(S), 1);
                  IBSql_Insert.sql.text := 'execute procedure PR_INITBASE (' + id + ',''' + s + ''',''' + install.eai + ''')';
                  IBSql_Insert.ExecQuery;
                  commit;
               end;
               Inc(NbSites);
            end;
            IBQue_TrouveSite.Close;
         end;
      end
      else
      begin
         if Ver52plus then
         begin
            S := install.Rep_Site;
            delete(s, 1, 7); delete(s, length(S), 1);
            id := inttostr(Install.Sites[i].id);
            IBSql_Insert.sql.text := 'execute procedure PR_INITBASE (' + id + ',''' + s + ''',''' + install.eai + ''')';
            IBSql_Insert.ExecQuery;
            commit;
         end;
      end;
   end;

   Lab_Etat.Caption := 'Création des Sociétés, magasins et postes'; Lab_Etat.Update;
   for soci := 0 to install.LesSociete.count - 1 do
   begin
      if not (install.Societes[soci].Existe) then
      begin
         Ib_rech.Close;
         with Ib_rech.sql do
         begin
            Clear;
            Add('Select SOC_ID FROM GENSOCIETE JOIN K ON (K_ID=SOC_ID And K_ENABLED=1)');
            Add('Where SOC_NOM = ' + QuotedStr(install.Societes[soci].Nom));
         end;
         Ib_rech.Open;
         if Ib_rech.isempty then
         begin
            idSoc := insertK(K_Soc);
            with IBSql_Insert.Sql do
            begin
               clear;
               Add('INSERT INTO GENSOCIETE');
               Add('  (SOC_ID,SOC_NOM,SOC_FORME,SOC_APE,SOC_RCS,SOC_TVA,SOC_CLOTURE,SOC_DIRIGEANT,SOC_SSID,SOC_FACTOR,SOC_CODEFOURN,SOC_PIEDFACTURE)');
               Add('VALUES');
               Add('  (' + IDSOC + ',' + QuotedStr(install.Societes[soci].Nom) + ','''','''','''','''',null,'''',0,'''','''','''')');
            end;
            IBSql_Insert.ExecQuery;
            commit;
         end
         else idSoc := Ib_rech.fields[0].AsString;
         Ib_rech.close;
      end
      else
         idsoc := Inttostr(install.Societes[soci].ID);
      for magi := 0 to install.Societes[soci].LesMagasins.count - 1 do
      begin
         if not (install.Societes[soci].Magasins[magi].Existe) then
         begin
            Ib_rech.Close;
            with Ib_rech.sql do
            begin
               Clear;
               Add('Select MAG_ID FROM GENMAGASIN JOIN K ON (K_ID=MAG_ID And K_ENABLED=1)');
               Add('Where MAG_NOM = ' + QuotedStr(install.Societes[soci].Magasins[magi].nom));
               Add('  And MAG_SOCID = ' + IdSoc);
            end;
            Ib_rech.Open;
            if Ib_rech.IsEmpty then
            begin
               Ib_rech.Close;
               with Ib_rech.sql do
               begin
                  Clear;
                  Add('Select VIL_ID FROM GENVILLE JOIN K ON (K_ID=VIL_ID And K_ENABLED=1)');
                  Add('Where VIL_ID <> 0');
               end;
               Ib_rech.Open;
               if Ib_rech.IsEmpty then
                  vilid := '0'
               else
                  vilid := Ib_rech.fields[0].asString;
               Ib_rech.close;
               idmag := insertK(K_Mag);
               // Que_Adresse
               adrid := InsertK(K_Adresse);
               with IBSql_Insert.Sql do
               begin
                  clear;
                  Add('INSERT INTO GENADRESSE');
                  Add('  (ADR_ID,ADR_LIGNE,ADR_VILID,ADR_TEL,ADR_FAX,ADR_GSM,ADR_EMAIL,ADR_COMMENT)');
                  Add('VALUES');
                  Add('  (' + Adrid + ','''',' + vilid + ','''','''','''','''','''')');
               end;
               IBSql_Insert.ExecQuery; commit;
               if not (Ver52plus) then
               begin
               // Que_GestionClient
                  MGCID := InsertK(K_GENMAGGESTIONCLT);
                  with IBSql_Insert.Sql do
                  begin
                     clear;
                     Add('INSERT INTO GENMAGGESTIONCLT');
                     Add('    (MGC_ID, MGC_MAGID, MGC_GCLID)');
                     Add('VALUES');
                     Add('    (' + MGCID + ',' + idmag + ', 0)');
                  end;
                  IBSql_Insert.ExecQuery; commit;
                  // Que_GestionCF
                  MCFID := InsertK(K_GENMAGGESTIONCF);
                  with IBSql_Insert.Sql do
                  begin
                     clear;
                     Add('INSERT INTO GENMAGGESTIONCF');
                     Add('  (MCF_ID,MCF_MAGID,MCF_GCFID)');
                     Add('VALUES');
                     Add('  (' + MGCID + ',' + idmag + ',0)');
                  end;
                  IBSql_Insert.ExecQuery; commit;
                  // Que_GestionCltCpt
                  MCCID := InsertK(K_GENMAGGESTIONCLTCPT);
                  with IBSql_Insert.Sql do
                  begin
                     clear;
                     Add('INSERT INTO GENMAGGESTIONCLTCPT');
                     Add('  (MCC_ID,MCC_MAGID,MCC_GCCID)');
                     Add('VALUES');
                     Add('  (' + MCCID + ',' + idmag + ',0)');
                  end;
                  IBSql_Insert.ExecQuery; commit;
                  // Que_GENPARAM
                  PRMID := InsertK(K_GENPARAM);
                  with IBSql_Insert.Sql do
                  begin
                     clear;
                     Add('INSERT INTO GENPARAM');
                     Add('  (PRM_ID,PRM_CODE,PRM_INTEGER,PRM_FLOAT,PRM_STRING,PRM_TYPE,PRM_MAGID,PRM_INFO,PRM_POS)');
                     Add('VALUES');
                     if install.Societes[soci].Magasins[magi].Location then
                        Add('  (' + PRMID + ',90,1,0,''LOCATION'',9,' + idmag + ',''LOCATION'',0)')
                     else
                        Add('  (' + PRMID + ',90,0,0,''LOCATION'',9,' + idmag + ',''LOCATION'',0)');
                  end;
                  IBSql_Insert.ExecQuery; commit;

                  PRMID := InsertK(K_GENPARAM);
                  with IBSql_Insert.Sql do
                  begin
                     clear;
                     Add('INSERT INTO GENPARAM');
                     Add('  (PRM_ID,PRM_CODE,PRM_INTEGER,PRM_FLOAT,PRM_STRING,PRM_TYPE,PRM_MAGID,PRM_INFO,PRM_POS)');
                     Add('VALUES');
                     Add('  (' + PRMID + ',31,3,0,''NIVEAU VERSION UTILISATEUR'',3,' + idmag + ',''NIVEAU VERSION UTILISATEUR'',0)');
                  end;
                  IBSql_Insert.ExecQuery; commit;
               end;

               with IBSql_Insert.Sql do
               begin
                  clear;
                  Add('INSERT INTO GENMAGASIN');
                  Add('  (MAG_ID, MAG_IDENT, MAG_NOM, MAG_SOCID,' +
                     'MAG_ADRID, MAG_TVTID, MAG_TEL, MAG_FAX, ' +
                     'MAG_EMAIL, MAG_SIRET, MAG_CODEADH, MAG_NATURE, ' +
                     'MAG_TRANSFERT, MAG_SS, MAG_HUSKY, MAG_IDENTCOURT, ' +
                     'MAG_COMENT, MAG_ARRONDI, MAG_GCLID, MAG_ENSEIGNE, ' +
                     'MAG_FACID, MAG_LIVID, MAG_COULMAG, MAG_MTAID, ' +
                     'MAG_CLTHABITUEL)');
                  Add('VALUES');
                  Add('  (' + idmag + ',' + QuotedStr(install.Societes[soci].Magasins[magi].IdCourt) + ',' +
                     QuotedStr(install.Societes[soci].Magasins[magi].nom) + ',' + idsoc + ',' +
                     adrid + ',0,'''','''',' +
                     ''''','''','''',1,' +
                     '0,1,0,'''',' +
                     ''''',0,0,' + QuotedStr(install.Societes[soci].Magasins[magi].nom) +
                     ',0,0,0,0,0)');
               end;
               IBSql_Insert.ExecQuery; commit;
               if Ver52plus then
               begin
                  IBSql_Insert.sql.text := 'execute procedure PR_INTITIALISEMAG (' + idmag + ')';
                  IBSql_Insert.ExecQuery; commit;
                  if install.Societes[soci].Magasins[magi].Location then
                  begin
                     IBSql_Insert.sql.text := 'update genparam set PRM_INTEGER=1 where ' +
                        'PRM_CODE=90 and PRM_TYPE=9 and PRM_MAGID=' + idmag;
                     IBSql_Insert.ExecQuery; commit;
                  end;
               end
               else
                  InitModeEnc(idsoc, idmag);
            end
            else
            begin
               idmag := Ib_Rech.fields[0].AsString;
               if Ver52plus then
               begin
                  IBSql_Insert.sql.text := 'execute procedure PR_INTITIALISEMAG (' + idmag + ')';
                  IBSql_Insert.ExecQuery; commit;
                  if install.Societes[soci].Magasins[magi].Location then
                  begin
                     IBSql_Insert.sql.text := 'update genparam set PRM_INTEGER=1 where ' +
                        'PRM_CODE=90 and PRM_TYPE=9 and PRM_MAGID=' + idmag;
                     IBSql_Insert.ExecQuery; commit;
                  end;
               end
               else
               begin
                  IB_RECH.close;
                  with IB_RECH.Sql do
                  begin
                     Clear;
                     Add('SELECT CFF_ID');
                     Add('FROM CSHCOFFRE');
                     Add('WHERE CFF_MAGID =' + idmag);
                  end;
                  IB_RECH.open;
                  if IB_RECH.IsEmpty then
                     InitModeEnc(idsoc, idmag);
               end;
            end;
         end
         else
         begin
            idmag := Inttostr(install.Societes[soci].Magasins[magi].ID);
            if Ver52plus then
            begin
               IBSql_Insert.sql.text := 'execute procedure PR_INTITIALISEMAG (' + idmag + ')';
               IBSql_Insert.ExecQuery; commit;
               if install.Societes[soci].Magasins[magi].Location then
               begin
                  IBSql_Insert.sql.text := 'update genparam set PRM_INTEGER=1 where ' +
                     'PRM_CODE=90 and PRM_TYPE=9 and PRM_MAGID=' + idmag;
                  IBSql_Insert.ExecQuery; commit;
               end;
            end
         end;
         for posi := 0 to install.Societes[soci].Magasins[magi].LesPostes.count - 1 do
         begin
            if not (install.Societes[soci].Magasins[magi].Postes[posi].Existe) then
            begin
               Ib_rech.Close;
               with Ib_rech.sql do
               begin
                  Clear;
                  Add('Select POS_ID FROM GENPOSTE JOIN K ON (K_ID=POS_ID And K_ENABLED=1)');
                  Add('Where POS_NOM = ' + quotedstr(install.Societes[soci].Magasins[magi].Postes[posi].nom));
                  Add('AND POS_MAGID = ' + idmag);
               end;
               Ib_rech.Open;
               if Ib_rech.IsEmpty then
               begin
                  idposte := insertK(K_Poste);
                  with IBSql_Insert.Sql do
                  begin
                     clear;
                     Add('INSERT INTO GENPOSTE');
                     Add('(POS_ID, POS_NOM, POS_INFO, POS_MAGID, POS_COMPTA)');
                     Add('VALUES');
                     Add('(' + idposte + ', ' + quotedstr(install.Societes[soci].Magasins[magi].Postes[posi].nom) + ', '''', ' + idmag + ', '''')');
                  end;
                  IBSql_Insert.ExecQuery; commit;
               end;
            end;
         end;
      end;
   end;

   Lab_Etat.Caption := 'Génération des données de locations'; Lab_Etat.Update;
   // génération des données de locations
   IBSql_Insert.Sql.text := 'DROP PROCEDURE HP_INITPSEUDOLOCTO';
   try
      IBSql_Insert.ExecQuery; commit;
   except end;
   IB_INITPSEUDOLOCTO.ExecQuery; commit;
   IBSql_Insert.Sql.text := 'execute procedure HP_INITPSEUDOLOCTO';
   IBSql_Insert.ExecQuery; commit;
   IBSql_Insert.Sql.text := 'DROP PROCEDURE HP_INITPSEUDOLOCTO';
   IBSql_Insert.ExecQuery; commit;
   IB_CRERCLTTO.ExecQuery; commit;
   IBSql_Insert.Sql.text := 'execute procedure PR_CRERCLTTO';
   IBSql_Insert.ExecQuery; commit;
   IBSql_Insert.Sql.text := 'Drop procedure PR_CRERCLTTO';
   IBSql_Insert.ExecQuery; commit;

   Lab_Etat.Caption := 'Création des Droits'; Lab_Etat.Update;
   for i := 0 to install.LesDroits.count - 1 do
   begin
      if install.Droits[i].Actif then
      begin
         IBSql_Insert.Sql.Text := 'EXECUTE PROCEDURE PR_GRPASSOCIEMAG (0,''' + install.Droits[i].Nom + ''',null)';
         IBSql_Insert.ExecQuery; commit;
      end;
   end;

   IBQue_Sites.Open;
   IBQue_Sites.First;
   tsl := tstringlist.create;
   while not IBQue_Sites.Eof do
   begin
      if IBQue_SitesBAS_IDENT.AsString <> '0' then
      begin
         tsl.Add(IBQue_SitesBAS_NOM.asstring + ';' + IBQue_SitesBAS_PLAGE.AsString + ';' + IBQue_SitesBAS_IDENT.AsString);
      end;
      IBQue_Sites.next
   end;
   IBQue_Sites.close;
   Data.close;
   // Backup/restore

   // Base de pantin
   Lab_Etat.Caption := 'Création de la base pantin'; Lab_Etat.Update;
   ForceDirectories(install.Rep_Dest + '\PANTIN');
   CopyFile(Pchar(install.Rep_Dest + 'GINKOIA.IB'), Pchar(install.Rep_Dest + '\PANTIN\GINKOIA.IB'), False);

   for i := 0 to tsl.count - 1 do
   begin
      S := Tsl[i];
      NomMag := Copy(S, 1, Pos(';', S) - 1);
      delete(S, 1, Pos(';', S));
      PlageMagasin := Copy(S, 1, Pos(';', S) - 1);
      delete(S, 1, Pos(';', S));
      NumMag := StrtoInt(S);

      Lab_Etat.Caption := 'Copie des fichier pour la base ' + NomMag; Lab_Etat.Update;
      Copier(install.Rep_Dest + 'origine\', install.Rep_Dest + NomMag + '\');
      ForceDirectories(install.Rep_Dest + NomMag + '\DATA\');
      Lab_Etat.Caption := 'Copie de la base ' + NomMag; Lab_Etat.Update;
      CopyFile(Pchar(install.Rep_Dest + 'GINKOIA.IB'), Pchar(install.Rep_Dest + NomMag + '\DATA\GINKOIA.IB'), False);
      Lab_Etat.Caption := 'Paramètrage de la base ' + NomMag; Lab_Etat.Update;
      Data.close;
      Data.DatabaseName := install.Rep_Dest + NomMag + '\DATA\GINKOIA.IB';
      Data.Open;
      tran.Active := true;
      IBQue_ModifParam.ParamByName('ID').AsString := Inttostr(NumMag);
      IBQue_ModifParam.ExecSQL;
      Commit;
      Recup_Generateur(PlagePantin, PlageMagasin, nummag, install.Rep_Dest + NomMag + '\EAI', NomMag, Install.Nom_Clt,
         install.Rep_Dest + 'origine\EAI\', install.Rep_Site, Install.Eai);

      Lab_Etat.Caption := 'Creation de Ginkoia.ini pour la base ' + NomMag; Lab_Etat.Update;
      ini := tinifile.create(install.Rep_Dest + NomMag + '\GINKOIA.INI');
      ini.writeString('GENERAL', 'Tip_Main_ShowAtStartup', 'False');
      ini.writeString('DATABASE', 'PATH0', 'C:\Ginkoia\data\Ginkoia.IB');
      ini.writeString('DATABASE', 'PATH1', 'C:\Ginkoia\test\test.IB');
      ini.writeString('NOMMAGS', 'MAG0', ' ');
      ini.writeString('NOMMAGS', 'MAG1', 'MAGASIN TEST');
      ini.writeString('NOMPOSTE', 'POSTE0', ' ');
      ini.writeString('NOMPOSTE', 'POSTE1', 'POSTE TEST');
      ini.writeString('NOMBASES', 'ITEM0', ' ');
      ini.writeString('NOMBASES', 'ITEM1', 'DOSSIER TEST');
      if not Ver52plus then
      begin
         ini.writeString('CONNEXION', 'NOM', ' ');
         ini.writeString('CONNEXION', 'TEL', ' ');
         ini.writeString('CONNEXION', 'NOM_2', ' ');
         ini.writeString('CONNEXION', 'TEL_2', ' ');
         S := Install.Rep_Site + Install.Eai + '/DelosQPMAgent.dll/ping';
         ini.writeString('PING', 'URL', S);
         ini.writeString('PING', 'STOP', '0');
         ini.writeString('PING', 'CONNECT', '0');
         S := 'http://localhost:668/DelosEAIBin/DelosQPMAgent.dll/Push';
         ini.writeString('PUSH', 'URL', S);
         ini.writeString('PUSH', 'USERNAME', '');
         ini.writeString('PUSH', 'PASSWORD', '');

         Lab_Etat.Caption := 'Modification des xml pour la base ' + NomMag; Lab_Etat.Update;
         PassXML := TXMLCursor.Create;
         PassXML.Load(Install.Rep_Dest + 'origine\EAI\DelosQpmAgent.Providers.xml');

         PassXML := PassXML.Select('Provider');
         J := 0;
         while not PassXML.Eof do
         begin
            ini.writeString('PUSH', 'PROVIDER' + Inttostr(J), PassXML.GetValue('Name'));
            inc(J);
            PassXML.next;
         end;
         PassXML := nil;

         S := 'http://localhost:668/DelosEAIBin/DelosQPMAgent.dll/PullSubscription';
         ini.writeString('PULL', 'URL', S);
         ini.writeString('PULL', 'USERNAME', '');
         ini.writeString('PULL', 'PASSWORD', '');
         PassXML := TXMLCursor.Create;
         PassXML.Load(Install.Rep_Dest + 'origine\EAI\DelosQpmAgent.Subscriptions.xml');
         PassXML := PassXML.Select('Subscription');
         J := 0;
         while not PassXML.Eof do
         begin
            ini.writeString('PULL', 'PROVIDER' + Inttostr(J), PassXML.GetValue('Subscription'));
            inc(J);
            PassXML.next;
         end;
         PassXML := nil;
      end;
      Ini.free;

      Data.close;
   end;

   // On nétoie
   Lab_Etat.Caption := 'suppression du script '; Lab_Etat.Update;
   Deletefile(Install.Rep_Dest + 'Script.exe');
   Deletefile(Install.Rep_Dest + 'Script.SCR');
   Lab_Etat.Caption := 'suppression des fichiers temporaires '; Lab_Etat.Update;
   Suprimer(Install.Rep_Dest + 'Origine\');
   Lab_Etat.Caption := ''; Lab_Etat.Update;

   if Install.Copie then
   begin
      S := install.Rep_Site;
      Delete(s, 1, 7);
      if pos('/', S) > 0 then
         S := Copy(s, 1, pos('/', S) - 1);
      S1 := install.eai;
      Delete(S1, length(S1) - 2, 3);
      Envoie_fichier(S,
         install.Rep_Dest + '\PANTIN\GINKOIA.IB',
         'D:\EAI\' + install.centrale + '\' + Install.Nom_Clt + '\GINKOIA.IB',
         S1,
         Install.Nom_Clt);
   end;

   Frm_Creation.release;
end;

procedure TFrm_InstCltMain.Envoie_fichier(Adresse, quoi, ou, eai, nomdatabase: string);
var
   f: file;
   Buf: array[0..64000] of byte;
   Buf2: array[0..64000] of byte;
   newsize: integer;
   lut: integer;
   tmr: TMinRec;
   s: string;
   TUB: TunBuf;
   Tst: TSockSendThread;

   numpaquet: integer;
   nombrepaquet: integer;

begin
//
   Lab_Etat.Caption := 'Envois de la base ' ; Lab_Etat.update ;
   sock.HostName := Adresse ;
   sock.Open ;
   Tst := TSockSendThread.create(sock);

   assignfile(f, quoi);
   reset(f, 1);
   tmr.tipe := 1;
   numpaquet := 1;

   nombrepaquet := (FileSize(f) div 32768);
   if nombrepaquet * 32768 < FileSize(f) then
      inc(nombrepaquet);
   tmr.tipe2 := nombrepaquet;

   S := ou;
   tmr.taille := length(S);
   sock.SendBuf(tmr, sizeof(tmr));
   sock.SendBuf(pointer(S)^, length(s));

   repeat
      Application.processmessages;
      while (tst.encours + 1 = tst.Actu) or
         ((tst.encours = 64000) and (tst.Actu = 0)) do
      begin
         sleep(10);
      end;
      Lab_Etat.Caption := 'Envois de la base ('+inttostr(tst.encours-tst.Actu)+')' ; Lab_Etat.update ;

      blockread(f, Buf, 32768, lut);
      if LUT <> 0 then
      begin
         if (tst.encours - tst.Actu) > 50 then
            ZCompressPass(buf, lut, Buf2, newsize, zcMax)
         else if (tst.encours - tst.Actu) > 20 then
            ZCompressPass(buf, lut, Buf2, newsize, zcDefault)
         else
            ZCompressPass(buf, lut, Buf2, newsize, zcFastest);
         TUB.tipe := 3;
         TUB.tipe2 := numpaquet;
         inc(numpaquet);

         TUB.size := newsize;
         TUB.vsize := lut;
         getmem(TUB.pt, newsize);
         Move(Buf2, TUB.pt^, newsize);
         tst.Buf[tst.encours] := TUB;
         if tst.encours = 64000 then
            tst.encours := 0
         else
            inc(tst.encours);
      end;
   until lut <> 32768;

   CloseFile(f);

   while Tst.encours <> Tst.Actu do
   begin
      sleep(25);
      Application.processmessages;
      Lab_Etat.Caption := 'Envois de la base ('+inttostr(tst.encours-tst.Actu)+')' ; Lab_Etat.update ;
   end;


   Tst.Terminate;
   Lab_Etat.Caption := 'Calcul du CRC ' ; Lab_Etat.Update ;
   S := ou+';'+Inttostr(FileCRC32(quoi));
   Lab_Etat.Caption := 'CRC : '+S ; Lab_Etat.Update ;
   tmr.Tipe := 200;
   tmr.taille := length(S);
   sock.SendBuf(tmr, sizeof(tmr));
   sock.SendBuf(pointer(S)^, length(s));
   Sleep (1000) ;

   while not tst.Terminated do sleep(10);
   tst.free;

   S := ou+';'+eai+';'+nomdatabase ;
   tmr.Tipe := 205;
   tmr.taille := length(S);
   sock.SendBuf(tmr, sizeof(tmr));
   sock.SendBuf(pointer(S)^, length(s));

   sleep(100);
   sock.Close;
   //
end;

procedure TFrm_InstCltMain.Suprimer(Src: string);
var
   f: TSearchRec;
begin
   if FindFirst(src + '*.*', faAnyFile, F) = 0 then
   begin
      repeat
         if (f.name <> '.') and (f.name <> '..') then
         begin
            if (f.attr and Fadirectory) = Fadirectory then
            begin
               Suprimer(src + f.name + '\');
            end
            else
            begin
               Lab_Etat.Caption := 'Suppression de ' + src + f.name;
               Lab_Etat.Update;
               Deletefile(src + f.name);
            end;
         end;
      until findnext(f) <> 0;
   end;
   findclose(f);
   RemoveDir(Src);
end;

procedure TFrm_InstCltMain.Ouvrirunfichierdinstall1Click(Sender: TObject);
var
   Frm_Creation: TFrm_Creation;
   tsl: tstringlist;
begin
   if od.execute then
   begin
      application.CreateForm(TFrm_Creation, Frm_Creation);
      try
         if Frm_Creation.LoadDocument(od.filename) = mrok then
         begin
            tsl := TStringList.create;
            tsl.Text := Frm_Creation.Install.ToXml('');
            tsl.savetofile(od.filename);
            tsl.free;
         end;
      finally
         Frm_Creation.release;
      end;
   end;
end;

procedure TFrm_InstCltMain.Splitagedebase1Click(Sender: TObject);
var
   Frm_split: TFrm_split;
begin
   application.createform(TFrm_split, Frm_split);
   Frm_split.ShowModal;
   Frm_split.release;
   close ;
   Lab_etat.Caption := '';
end;

{ TSockSendThread }

constructor TSockSendThread.Create(Sock: TSock);
begin
   Actu := 0;
   encours := 0;
   inherited create(true);
   clientSock := Sock;
   resume;
end;

procedure TSockSendThread.Execute;
var
   tmr: TMinRec;
begin
   while not Terminated do
   begin
      if actu <> encours then
      begin
         tmr.Tipe := buf[actu].tipe;
         if tmr.Tipe = 99 then
         begin
            tmr.crc := buf[actu].crc;
            ClientSock.SendBuf(tmr, sizeof(tmr));
         end
         else
         begin
            tmr.Tipe2 := buf[actu].tipe2;
            tmr.taille := buf[actu].size;
            ClientSock.SendBuf(tmr, sizeof(tmr));
            if buf[actu].size > 0 then
            begin
               ClientSock.SendBuf(buf[actu].pt^, buf[actu].size);
               freemem(buf[actu].pt, buf[actu].size);
            end;
         end;
         inc(actu);
         if actu > 64000 then
            actu := 0;
      end;
   end;
end;

{ TCrcThread }

constructor TCrcThread.Create(fichier: string);
begin
   inherited create(true);
   fich := fichier;
end;

procedure TCrcThread.Execute;
begin
   Crc := FileCRC32(Fich);
   Terminate;
end;

end.

