//$Log:
// 2    Utilitaires1.1         26/09/2006 11:02:52    pascal          rendu des
//      modifs
// 1    Utilitaires1.0         25/11/2005 08:09:38    pascal          
//$
//$NoKeywords$
//
unit Split_frm;

interface

uses
   ChxSender_frm,
   XMLCursor,
   StdXML_TLB,
   inifiles,
   FileUtil,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   ChxSociete_frm, StdCtrls, ExtCtrls, Buttons, CheckLst, Db,
   IBCustomDataSet, IBQuery, IBDatabase;

type
   TuneBase = class
      ID: Integer;
      Nom: string;
      Plage: string;
      Sender: string;
      IDENT: Integer;
   end;

   TFrm_split = class(Tfrm_ChxSociete)
      SpeedButton1: TSpeedButton;
      OD: TOpenDialog;
      lab_eai: TLabel;
      Lab_version: TLabel;
      Label4: TLabel;
      cb_site: TComboBox;
      Lb_Site: TCheckListBox;
      Label5: TLabel;
      Label6: TLabel;
      LeChemin: TEdit;
      LAB_ETAT: TLabel;
      data: TIBDatabase;
      Tran: TIBTransaction;
      qry: TIBQuery;
      Label7: TLabel;
      ed_database: TEdit;
      procedure Edit1Change(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure Lb_SiteClickCheck(Sender: TObject);
      procedure OKBtnClick(Sender: TObject);
      procedure cb_siteChange(Sender: TObject);
      procedure SpeedButton1Click(Sender: TObject);
   private
    { Déclarations privées }
   public
    { Déclarations publiques }
      LesBases: TList;
      EAI: string;
      LaVersion: string;
      plagePantin: string;
      LesReplication: TstringList;
      Rep_Site: string;
      procedure BasesClear;
   end;

var
   Frm_split: TFrm_split;

implementation
{$R *.DFM}
uses
   UInsCltPrin;

procedure TFrm_split.BasesClear;
var
   i: integer;
begin
   for i := 0 to LesBases.count - 1 do
      TuneBase(LesBases[i]).free;
end;

procedure TFrm_split.Edit1Change(Sender: TObject);
var
   version: string;
   tb: TuneBase;
   i: Integer;
   LesVersion: TstringList;
   s: string;
begin
   BasesClear;
   data.close;
   data.DatabaseName := edit1.text;
   data.open;
   qry.sql.clear;
   qry.sql.add('Select Ver_version');
   qry.sql.add('from genversion');
   qry.sql.add('Order by ver_date desc');
   qry.Open;
   qry.first;
   version := qry.Fields[0].asString;
   qry.close;
   qry.sql.clear;
   qry.sql.Add('Select BAS_ID, BAS_NOM, BAS_PLAGE, BAS_IDENT');
   qry.sql.Add('from genbases join k on (k_id=bas_id and k_enabled=1)');
   qry.sql.Add('where bas_id<>0');
   qry.sql.Add('Order by bas_ident');
   qry.Open;
   qry.first;
   while not qry.eof do
   begin
      if qry.fields[3].AsInteger = 0 then
      begin
         plagePantin := qry.fields[2].AsString;
      end
      else
      begin
         tb := TuneBase.create;
         tb.ID := qry.fields[0].AsInteger;
         tb.Nom := qry.fields[1].AsString;
         tb.Plage := qry.fields[2].AsString;
         tb.IDENT := qry.fields[3].AsInteger;
         tb.Sender := '';
         lesbases.add(tb);
      end;
      qry.Next;

   end;
   data.close;
   Lb_Site.Items.clear;
   for i := 0 to lesBases.count - 1 do
      Lb_Site.Items.AddObject(TuneBase(LesBases[i]).Nom, LesBases[i]);

   LesVersion := TstringList.Create;
   LesVersion.loadfromfile(ChangeFileExt(application.exename, '.ver'));
   for i := 0 to LesVersion.Count - 1 do
   begin
      S := LesVersion[i];
      delete(S, 1, pos(';', s));
      S := Copy(S, 1, pos(';', s) - 1);
      if S = version then
      begin
         S := LesVersion[i];
         LaVersion := Copy(S, 1, pos(';', S) - 1);
         delete(S, 1, pos(';', s));
         delete(S, 1, pos(';', s));
         Eai := S;
         BREAK;
      end;
   end;
   LesVersion.free;
   Lab_eai.caption := 'EAI : ' + eai;
   Lab_version.caption := 'VERSION : ' + LaVersion;
end;

procedure TFrm_split.FormCreate(Sender: TObject);
var
   i: Integer;
begin
   inherited;
   LesBases := Tlist.create;
   lab_etat.caption := '';
   LesReplication := TstringList.Create;
   LesReplication.loadfromfile(ChangeFileExt(application.exename, '.rep'));
   cb_site.items.clear;
   for i := 0 to LesReplication.count - 1 do
   begin
      cb_site.items.Add(Copy(LesReplication[i], 1, Pos(';', LesReplication[i]) - 1));
   end;
   cb_site.ItemIndex := 0;
   cb_siteChange(nil);
end;

procedure TFrm_split.FormDestroy(Sender: TObject);
begin
   LesReplication.free;
   BasesClear;
   LesBases.free;
   inherited;
end;

procedure TFrm_split.Lb_SiteClickCheck(Sender: TObject);
var
   tb: TuneBase;
   Frm_ChxSender: TFrm_ChxSender;
begin
   tb := TuneBase(Lb_Site.Items.Objects[Lb_Site.ItemIndex]);
   if lb_site.Checked[Lb_Site.ItemIndex] then
   begin
      application.createform(TFrm_ChxSender, Frm_ChxSender);
      Frm_ChxSender.Edit1.text := tb.Sender;
      if Frm_ChxSender.ShowModal = MrOk then
      begin
         tb.Sender := Frm_ChxSender.Edit1.text;
      end;
      Lb_Site.Items[lb_site.ItemIndex] := tb.Nom + ' -> ' + tb.Sender;
      Frm_ChxSender.release;
   end
   else
      Lb_Site.Items[lb_site.ItemIndex] := tb.Nom;
end;

procedure TFrm_split.OKBtnClick(Sender: TObject);
var
   Rep_Dest, Chemin: string;
   ini: tinifile;
   i, j: integer;
   s: string;
   tb: TuneBase;
   PassXML: IXMLCursor;
   tsl: tstringlist;
   nomlog: string;
begin
   ini := tinifile.Create(Changefileext(application.exename, '.ini'));
   Chemin := ini.readstring('DEFAULT', 'CHEMIN', '\\Liveup\liveupdate\');
   ini.free;
   nomlog := Changefileext(application.exename, '.log');
   tsl := tstringlist.create;
   tsl.add('debut ' + datetimetostr(now)); tsl.savetofile(nomlog);
   try
      Rep_Dest := IncludeTrailingBackslash(LeChemin.text);
      if (not FileExists(Chemin + 'EAIGENE\EAI\SharedPortal\Monitoring\Available.gif')) or
         (not FileExists(Chemin + Eai + '\DelosQPMAgent.Providers.xml')) then
      begin
         Application.MessageBox('LES EAI NE SONT PAS PRESENT', 'IMPOSSIBLE', MB_OK);
         EXIT;
      end;
      if (not FileExists(Chemin + LaVersion + '\script.scr')) then
      begin
         Application.MessageBox('La version n''existe pas', 'Erreur', mb_ok);
         EXIT;
      end;
      tsl.add('creation du rep origine ' + datetimetostr(now)); tsl.savetofile(nomlog);
      ForceDirectories(Rep_Dest);
      ForceDirectories(Rep_Dest + 'origine');
   // Copie des Eai
      tsl.add('copie des eai ' + datetimetostr(now)); tsl.savetofile(nomlog);
      Lab_Etat.Caption := 'Copie des EAI'; Lab_Etat.Update;
      S := Chemin + 'EAIGENE\EAI\';
      Frm_InstCltMain.Copier(S, Rep_Dest + 'origine\EAI\');
      S := Chemin + Eai + '\';
      Frm_InstCltMain.Copier(S, Rep_Dest + 'origine\EAI\');
   // Copie de la version de départ
      tsl.add('copie de la version ' + datetimetostr(now)); tsl.savetofile(nomlog);
      Lab_Etat.Caption := 'Copie de la version'; Lab_Etat.Update;
      Frm_InstCltMain.Copier(Chemin + LaVersion + '\', Rep_Dest + 'origine\');

      tsl.add('copie de la base origine ' + datetimetostr(now)); tsl.savetofile(nomlog);
      Lab_Etat.Caption := 'Copie de ' + edit1.text + ' vers ' + Rep_Dest + 'GINKOIA.IB';
      Lab_Etat.Update;
      CopyFile(Pchar(edit1.text), Pchar(Rep_Dest + 'GINKOIA.IB'), False);
      Lab_Etat.Caption := '';
      Lab_Etat.Update;

      for i := 0 to lb_site.items.count - 1 do
      begin
         if lb_site.Checked[i] then
         begin
            tsl.add('Gestion du site '+lb_site.items[i]+'  '+ datetimetostr(now)); tsl.savetofile(nomlog);
            tb := TuneBase(lb_site.items.Objects[i]);
            tsl.add('copy des fichiers '+datetimetostr(now)); tsl.savetofile(nomlog);
            Lab_Etat.Caption := 'Copie des fichier pour la base ' + tb.Nom; Lab_Etat.Update;
            Frm_InstCltMain.Copier(Rep_Dest + 'origine\', Rep_Dest + tb.nom + '\');
            ForceDirectories(Rep_Dest + tb.nom + '\DATA\');
            tsl.add('copy de la base '+datetimetostr(now)); tsl.savetofile(nomlog);
            Lab_Etat.Caption := 'Copie de la base ' + tb.nom; Lab_Etat.Update;
            CopyFile(Pchar(Rep_Dest + 'GINKOIA.IB'), Pchar(Rep_Dest + tb.nom + '\DATA\GINKOIA.IB'), False);
            tsl.add('Param de la base '+datetimetostr(now)); tsl.savetofile(nomlog);
            Lab_Etat.Caption := 'Paramètrage de la base ' + tb.nom; Lab_Etat.Update;
            Frm_InstCltMain.Data.close ;
            Frm_InstCltMain.Data.DatabaseName := Rep_Dest + tb.nom + '\DATA\GINKOIA.IB';
            Frm_InstCltMain.Data.Open;
            Frm_InstCltMain.tran.Active := true;
            Frm_InstCltMain.IBQue_ModifParam.ParamByName('ID').AsString := Inttostr(tb.IDENT);
            Frm_InstCltMain.IBQue_ModifParam.ExecSQL;
            Frm_InstCltMain.Commit;
            Frm_InstCltMain.Recup_Generateur(PlagePantin, tb.Plage, tb.IDENT, Rep_Dest + tb.nom + '\EAI', tb.sender, ed_database.text,
               Rep_Dest + tb.nom + '\EAI\', Rep_Site, Eai);

            tsl.add('Creation de ginkoia.ini '+datetimetostr(now)); tsl.savetofile(nomlog);
            Lab_Etat.Caption := 'Creation de Ginkoia.ini pour la base ' + tb.nom; Lab_Etat.Update;
            ini := tinifile.create(Rep_Dest + tb.nom + '\GINKOIA.INI');
            ini.writeString('GENERAL', 'Tip_Main_ShowAtStartup', 'False');
            ini.writeString('DATABASE', 'PATH0', 'C:\Ginkoia\data\Ginkoia.IB');
            ini.writeString('DATABASE', 'PATH1', 'C:\Ginkoia\test\test.IB');
            ini.writeString('NOMMAGS', 'MAG0', ' ');
            ini.writeString('NOMMAGS', 'MAG1', 'MAGASIN TEST');
            ini.writeString('NOMPOSTE', 'POSTE0', ' ');
            ini.writeString('NOMPOSTE', 'POSTE1', 'POSTE TEST');
            ini.writeString('NOMBASES', 'ITEM0', ' ');
            ini.writeString('NOMBASES', 'ITEM1', 'DOSSIER TEST');
            ini.writeString('CONNEXION', 'NOM', ' ');
            ini.writeString('CONNEXION', 'TEL', ' ');
            ini.writeString('CONNEXION', 'NOM_2', ' ');
            ini.writeString('CONNEXION', 'TEL_2', ' ');

            S := Rep_Site + Eai + '/DelosQPMAgent.dll/ping';
            ini.writeString('PING', 'URL', S);
            ini.writeString('PING', 'STOP', '0');
            ini.writeString('PING', 'CONNECT', '0');
            S := 'http://localhost:668/DelosEAIBin/DelosQPMAgent.dll/Push';
            ini.writeString('PUSH', 'URL', S);
            ini.writeString('PUSH', 'USERNAME', '');
            ini.writeString('PUSH', 'PASSWORD', '');

            tsl.add('Modif des XML '+datetimetostr(now)); tsl.savetofile(nomlog);
            Lab_Etat.Caption := 'Modification des xml pour la base ' + tb.nom; Lab_Etat.Update;
            tsl.add('Creation de provider '+datetimetostr(now)); tsl.savetofile(nomlog);
            PassXML := TXMLCursor.Create;
            PassXML.Load(Rep_Dest + 'origine\EAI\DelosQpmAgent.Providers.xml');

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
            tsl.add('Creation de subscription '+datetimetostr(now)); tsl.savetofile(nomlog);
            PassXML := TXMLCursor.Create;
            PassXML.Load(Rep_Dest + 'origine\EAI\DelosQpmAgent.Subscriptions.xml');
            PassXML := PassXML.Select('Subscription');
            J := 0;
            while not PassXML.Eof do
            begin
               ini.writeString('PULL', 'PROVIDER' + Inttostr(J), PassXML.GetValue('Subscription'));
               inc(J);
               PassXML.next;
            end;
            PassXML := nil;
            Ini.free;
            Data.close;
         end;
      end;
   // On nétoie
      tsl.add('suppression des temps '+datetimetostr(now)); tsl.savetofile(nomlog);
      Lab_Etat.Caption := 'suppression des fichiers temporaires '; Lab_Etat.Update;
      Frm_InstCltMain.Suprimer(Rep_Dest + 'Origine\');
      Lab_Etat.Caption := ''; Lab_Etat.Update;
      tsl.add('fini ' + datetimetostr(now)); tsl.savetofile(nomlog);
      tsl.free;
      application.MessageBox('Découpage terminée', 'Avertissement', Mb_Ok);
   except
      tsl.add('erreur ' + datetimetostr(now)); tsl.savetofile(nomlog);
      tsl.free;
      raise;
   end;
end;

procedure TFrm_split.cb_siteChange(Sender: TObject);
var
   s: string;
   i: integer;
begin
   S := CB_Site.text + ';';
   for i := 0 to LesReplication.count - 1 do
   begin
      if pos(S, LesReplication[i]) = 1 then
      begin
         S := LesReplication[i];
         Delete(S, 1, Pos(';', S));
         Rep_Site := S;
      end;
   end;
end;

procedure TFrm_split.SpeedButton1Click(Sender: TObject);
begin
   inherited;
   if od.Execute then
      edit1.text := od.filename;
end;

end.

