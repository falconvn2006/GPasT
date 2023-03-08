//$Log:
// 5    Utilitaires1.4         05/10/2006 15:36:14    pascal          Modif
//      pour g?rer l'envois au lames
// 4    Utilitaires1.3         26/09/2006 11:02:52    pascal          rendu des
//      modifs
// 3    Utilitaires1.2         17/08/2006 08:48:17    pascal          modif
//      divers
// 2    Utilitaires1.1         25/01/2006 14:57:00    pascal          -
//      Correction sur l'initialisation des mags et soci?t?s 
//      - Initialisation des clients
//      - Initialisation des donn?es de location
//      pour palier ? la transpo
// 1    Utilitaires1.0         25/11/2005 08:09:38    pascal          
//$
//$NoKeywords$
//
unit Creation_frm;

interface

uses
   fileutil,
   UInstCltCst,
   ChxSociete_frm,
   ChxSite_frm,
   ChxMag_frm,
   ChxPoste_frm,
   XMLCursor,
   StdXML_TLB,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, Spin, CheckLst, ExtCtrls, Buttons, Db, IBCustomDataSet,
   IBQuery, IBDatabase, ApFolderDlg;

type
   TFrm_Creation = class(TForm)
      Label1: TLabel;
      Ed_BD: TEdit;
      SpeedButton1: TSpeedButton;
      Label2: TLabel;
      ED_RepDest: TEdit;
      LB_Version: TComboBox;
      Label3: TLabel;
      Label4: TLabel;
      LB_Site: TComboBox;
      Label6: TLabel;
      Label7: TLabel;
      Ed_NomClt: TEdit;
      Label8: TLabel;
      Ed_IdCourt: TEdit;
      Bevel1: TBevel;
      Label9: TLabel;
      Bevel2: TBevel;
      Bevel3: TBevel;
      Label10: TLabel;
      LB_Groupe: TCheckListBox;
      Lab_Eai: TLabel;
      Bevel4: TBevel;
      Label11: TLabel;
      LB_NomSite: TComboBox;
      Label12: TLabel;
      SpeedButton2: TSpeedButton;
      Label13: TLabel;
      SE_Jeton: TSpinEdit;
      Label14: TLabel;
      SE_NoteBook: TSpinEdit;
      CB_CaisseAuto: TCheckBox;
      SpeedButton3: TSpeedButton;
      Label15: TLabel;
      Bevel5: TBevel;
      Label16: TLabel;
      Lb_NomSoc: TComboBox;
      SpeedButton4: TSpeedButton;
      SpeedButton5: TSpeedButton;
      SpeedButton6: TSpeedButton;
      SpeedButton7: TSpeedButton;
      LB_NomMag: TComboBox;
      Label17: TLabel;
      Label18: TLabel;
      Lb_Postes: TListBox;
      SpeedButton8: TSpeedButton;
      SpeedButton9: TSpeedButton;
      BBtn_OK: TBitBtn;
      BBtn_Cancel: TBitBtn;
      OD: TOpenDialog;
      Data: TIBDatabase;
      Tran: TIBTransaction;
      Qry: TIBQuery;
      SpeedButton10: TSpeedButton;
      OD_Fold: TApFolderDialog;
      Cbt_Copie: TCheckBox;
      Cb_Centrale: TComboBox;
    Label5: TLabel;
      procedure SpeedButton1Click(Sender: TObject);
      procedure Ed_BDChange(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure LB_NomSiteChange(Sender: TObject);
      procedure Lb_NomSocChange(Sender: TObject);
      procedure LB_NomMagChange(Sender: TObject);
      procedure SpeedButton4Click(Sender: TObject);
      procedure SpeedButton2Click(Sender: TObject);
      procedure SpeedButton7Click(Sender: TObject);
      procedure LB_VersionChange(Sender: TObject);
      procedure LB_SiteChange(Sender: TObject);
      procedure ED_RepDestChange(Sender: TObject);
      procedure Ed_NomCltChange(Sender: TObject);
      procedure Ed_IdCourtChange(Sender: TObject);
      procedure SE_JetonChange(Sender: TObject);
      procedure SE_NoteBookChange(Sender: TObject);
      procedure CB_CaisseAutoClick(Sender: TObject);
      procedure LB_GroupeClickCheck(Sender: TObject);
      procedure SpeedButton8Click(Sender: TObject);
      procedure SpeedButton3Click(Sender: TObject);
      procedure SpeedButton5Click(Sender: TObject);
      procedure SpeedButton6Click(Sender: TObject);
      procedure SpeedButton9Click(Sender: TObject);
      procedure SpeedButton10Click(Sender: TObject);
      procedure Cb_CentraleChange(Sender: TObject);
      procedure Cbt_CopieClick(Sender: TObject);
   private
    { Déclarations privées }
   public
    { Déclarations publiques }
      Install: TUneInstall;
      LesVersion: TstringList;
      LesReplication: TstringList;
      procedure Initialise;
      function loadxml(fichier: string; Labase: string): boolean;
      function LoadDocument(fichier: string): Integer;
   end;

var
   Frm_Creation: TFrm_Creation;

implementation

{$R *.DFM}

procedure TFrm_Creation.SpeedButton1Click(Sender: TObject);
begin
   if od.Execute then
      Ed_BD.Text := Od.filename;
end;

procedure TFrm_Creation.Ed_BDChange(Sender: TObject);
var
   Ts: TUnSite;
   Tsoc: TSociete;
   Tmag: TMagasin;
   Tpos: Tposte;
   i: integer;
   tstr: TstringList;
   Tud: TunDroit;
   Fichier: string;
begin
   if fileexists(ed_bd.text) then
   begin
      if copy(ed_bd.text, 1, 2) = '\\' then
      begin
         ForceDirectories('C:\temp');
         CopyFile(Pchar(ed_bd.text), 'C:\temp\ginkoia.ib', false);
         Fichier := 'C:\temp\ginkoia.ib';
      end
      else
         Fichier := ed_bd.text;
      if Install.BD_ref <> Uppercase(ed_bd.text) then
      begin
         Install.BD_ref := Uppercase(ed_bd.text);
         Install.Clear;
         tstr := TstringList.Create;
         tstr.loadfromfile(ChangeFileExt(application.exename, '.grp'));
         for i := 0 to tstr.count - 1 do
         begin
            Tud := TunDroit.Create;
            Install.LesDroits.add(tud);
            tud.Nom := Copy(tstr[i], 1, Pos(';', tstr[i]) - 1);
            tud.Actif := Copy(tstr[i], Pos(';', tstr[i]) + 1, 1) = '1';
         end;
         tstr.free;

         // chargement
         Data.Close;
         Data.DatabaseName := Fichier;
         Data.Open;
         tran.Active := true;
         Qry.sql.Clear;
         Qry.sql.Add('select BAS_NOM, BAS_IDENT, BAS_PLAGE, BAS_JETON, BAS_ID');
         Qry.sql.Add('from genBases');
         Qry.sql.Add('Where Bas_Id<>0');
         Qry.sql.Add('Order By Bas_Ident');
         Qry.Open;
         Qry.First;
         while not Qry.Eof do
         begin
            if qry.fieldbyname('BAS_IDENT').AsString <> '0' then
            begin
               Ts := TUnSite.Create;
               Install.LesSites.Add(TS);
               ts.Nom := qry.fieldbyname('BAS_NOM').AsString; ;
               ts.Existe := true;
               TS.VraiNom := qry.fieldbyname('BAS_NOM').AsString;
               TS.Ident := qry.fieldbyname('BAS_IDENT').AsString;
               TS.PLage := qry.fieldbyname('BAS_PLAGE').AsString;
               TS.Jetons := qry.fieldbyname('BAS_JETON').AsInteger;
               TS.NoteBook := 0;
               TS.id := qry.fieldbyname('BAS_ID').AsInteger;
               TS.CA := FALSE;
            end;
            Qry.Next;
         end;
         Qry.close;
         Qry.Sql.Clear;
         Qry.sql.Add('select SOC_ID, SOC_NOM, MAG_ID, MAG_NOM, POS_ID, POS_NOM, PRM_INTEGER');
         Qry.sql.Add('from gensociete Join k on (k_id=soc_id and k_enabled=1)');
         Qry.sql.Add('                Join genmagasin Join k on (k_id=MAG_id and k_enabled=1)');
         Qry.sql.Add('                  on (Mag_socid = soc_id)');
         Qry.sql.Add('                Join genPoste Join k on (k_id=Pos_id and k_enabled=1)');
         Qry.sql.Add('                  on (pos_magid=mag_id)');
         Qry.sql.Add('                Left Join GENPARAM Join k on (k_id=PRM_id and k_enabled=1)');
         Qry.sql.Add('                 on (PRM_CODE=90 and PRM_MAGID=MAG_ID)');
         Qry.sql.Add('Where Pos_ID<>0');
         Qry.sql.Add('Order by SOC_ID, MAG_ID, POS_ID');
         Tsoc := nil;
         Tmag := nil;
         Qry.Open;
         Qry.First;
         while not Qry.eof do
         begin
            if (Tsoc = nil) or (Tsoc.ID <> Qry.FieldByName('SOC_ID').Asinteger) then
            begin
               Tsoc := TSociete.Create;
               Install.LesSociete.Add(Tsoc);
               Tsoc.Existe := true;
               Tsoc.Nom := Qry.FieldByName('SOC_NOM').AsString;
               Tsoc.ID := Qry.FieldByName('SOC_ID').AsInteger;
            end;
            if (Tmag = nil) or (Tmag.ID <> Qry.FieldByName('MAG_ID').Asinteger) then
            begin
               Tmag := TMagasin.Create;
               Tsoc.LesMagasins.Add(TMag);
               Tmag.Existe := true;
               Tmag.Id := Qry.FieldByName('MAG_ID').Asinteger;
               Tmag.nom := Qry.FieldByName('MAG_NOM').AsString;
               Tmag.Location := Qry.FieldByName('PRM_INTEGER').Asinteger = 1;
               Tmag.IdCourt := '';
            end;
            Tpos := Tposte.Create;
            Tmag.LesPostes.Add(Tpos);
            tpos.nom := Qry.FieldByName('POS_NOM').AsString;
            tpos.ID := Qry.FieldByName('POS_ID').AsInteger;
            tpos.Existe := True;
            Qry.Next;
         end;
         QRY.Close;
         data.close;
         LB_NomSite.items.Clear;
         for i := 0 to Install.LesSites.count - 1 do
            LB_NomSite.items.AddObject(Install.Sites[i].Nom, Install.Sites[i]);
         if LB_NomSite.items.Count > 0 then
            LB_NomSite.ItemIndex := 0;
         LB_NomSiteChange(nil);
         Lb_NomSoc.items.Clear;
         for i := 0 to Install.LesSociete.count - 1 do
            Lb_NomSoc.items.AddObject(Install.Societes[i].Nom, Install.Societes[i]);
         if Lb_NomSoc.items.Count > 0 then
            Lb_NomSoc.ItemIndex := 0;
         Lb_NomSocChange(nil);
         LB_SiteChange(nil);
      end;
   end;
end;

procedure TFrm_Creation.FormCreate(Sender: TObject);
begin
   Install := TUneInstall.Create;
end;

procedure TFrm_Creation.FormDestroy(Sender: TObject);
begin
   Install.free;
end;

procedure TFrm_Creation.Initialise;
var
   ts: TstringList;
   i: integer;
   Tud: TunDroit;
begin
   ts := TstringList.Create;
   ts.loadfromfile(ChangeFileExt(application.exename, '.grp'));
   for i := 0 to ts.count - 1 do
   begin
      Tud := TunDroit.Create;
      Install.LesDroits.add(tud);
      tud.Nom := Copy(ts[i], 1, Pos(';', ts[i]) - 1);
      tud.Actif := Copy(ts[i], Pos(';', ts[i]) + 1, 1) = '1';
   end;
   ts.free;
   LesVersion := TstringList.Create;
   LesVersion.loadfromfile(ChangeFileExt(application.exename, '.ver'));
   LesReplication := TstringList.Create;
   LesReplication.loadfromfile(ChangeFileExt(application.exename, '.rep'));
   LB_Version.items.clear;
   for i := 0 to LesVersion.count - 1 do
   begin
      LB_Version.items.Add(Copy(LesVersion[i], 1, Pos(';', LesVersion[i]) - 1));
   end;
   LB_Version.itemindex := 0;
   LB_VersionChange(nil);
   LB_Site.items.clear;
   for i := 0 to LesReplication.count - 1 do
   begin
      LB_Site.items.Add(Copy(LesReplication[i], 1, Pos(';', LesReplication[i]) - 1));
   end;
   LB_Site.ItemIndex := 0;
   LB_Groupe.Items.clear;
   for i := 0 to install.LesDroits.count - 1 do
   begin
      LB_Groupe.Items.AddObject(install.Droits[i].Nom, install.Droits[i]);
      if Install.Droits[i].Actif then
         LB_Groupe.Checked[LB_Groupe.items.Count - 1] := true;
   end;

   Cb_Centrale.items.clear;
   Cb_Centrale.items.LoadFromFile(ChangeFileExt(application.exename, '.cnt'));
   Cb_Centrale.itemindex := 0;
   Cb_CentraleChange(nil);
   Cbt_CopieClick(nil);
end;

procedure TFrm_Creation.LB_NomSiteChange(Sender: TObject);
begin
   if LB_NomSite.ItemIndex >= 0 then
   begin
      SE_Jeton.Value := TUnSite(LB_NomSite.Items.Objects[LB_NomSite.ItemIndex]).Jetons;
      SE_NoteBook.Value := TUnSite(LB_NomSite.Items.Objects[LB_NomSite.ItemIndex]).NoteBook;
      CB_CaisseAuto.Checked := TUnSite(LB_NomSite.Items.Objects[LB_NomSite.ItemIndex]).CA;
      if TUnSite(LB_NomSite.Items.Objects[LB_NomSite.ItemIndex]).Existe then
      begin
         SE_Jeton.enabled := false;
         SE_NoteBook.enabled := false;
         CB_CaisseAuto.enabled := false;
      end
      else
      begin
         SE_Jeton.enabled := True;
         SE_NoteBook.enabled := True;
         CB_CaisseAuto.enabled := True;
      end;
   end;
end;

procedure TFrm_Creation.Lb_NomSocChange(Sender: TObject);
var
   i: integer;
begin
   LB_NomMag.Items.Clear;
   if Lb_NomSoc.ItemIndex >= 0 then
   begin
      for i := 0 to TSociete(Lb_NomSoc.items.Objects[Lb_NomSoc.ItemIndex]).LesMagasins.Count - 1 do
      begin
         LB_NomMag.Items.AddObject(TSociete(Lb_NomSoc.items.Objects[Lb_NomSoc.ItemIndex]).Magasins[i].nom, TSociete(Lb_NomSoc.items.Objects[Lb_NomSoc.ItemIndex]).Magasins[i]);
      end;
      LB_NomMag.ItemIndex := 0;
   end;
   LB_NomMagChange(nil);
end;

procedure TFrm_Creation.LB_NomMagChange(Sender: TObject);
var
   i: integer;
begin
   Lb_Postes.Items.Clear;
   if LB_NomMag.ItemIndex >= 0 then
   begin
      for i := 0 to TMagasin(LB_NomMag.items.Objects[LB_NomMag.ItemIndex]).LesPostes.Count - 1 do
      begin
         Lb_Postes.Items.AddObject(TMagasin(LB_NomMag.items.Objects[LB_NomMag.ItemIndex]).Postes[i].nom, TMagasin(LB_NomMag.items.Objects[LB_NomMag.ItemIndex]).Postes[i]);
      end;
   end
end;

procedure TFrm_Creation.SpeedButton4Click(Sender: TObject);
var
   frm_ChxSociete: Tfrm_ChxSociete;
   tsoc: TSociete;
begin
   application.createform(Tfrm_ChxSociete, frm_ChxSociete);
   if frm_ChxSociete.showmodal = mrok then
   begin
      tsoc := TSociete.Create;
      tsoc.Nom := frm_ChxSociete.edit1.text;
      tsoc.Existe := false;
      tsoc.ID := -1;
      Install.LesSociete.add(tsoc);
      Lb_NomSoc.items.AddObject(tsoc.nom, tsoc);
      Lb_NomSoc.ItemIndex := Lb_NomSoc.items.count - 1;
      Lb_NomSocChange(nil);
   end;
   frm_ChxSociete.release;
end;

procedure TFrm_Creation.SpeedButton2Click(Sender: TObject);
var
   frm_ChxSite: Tfrm_ChxSite;
   Tsit: TUnSite;
begin
   Application.CreateForm(Tfrm_ChxSite, frm_ChxSite);
   if frm_ChxSite.showmodal = mrok then
   begin
      Tsit := TUnSite.create;
      Install.LesSites.add(Tsit);
      tsit.VraiNom := '';
      tsit.Ident := '';
      tsit.PLage := '';
      tsit.Existe := false;
      tsit.id := -1;
      tsit.Nom := frm_ChxSite.Ed_nom.text;
      tsit.Jetons := frm_ChxSite.Se_jet.value;
      tsit.NoteBook := frm_ChxSite.Se_nb.value;
      tsit.CA := frm_ChxSite.Cb_secour.Checked;
      LB_NomSite.items.AddObject(tsit.nom, tsit);
      LB_NomSite.ItemIndex := LB_NomSite.items.count - 1;
      LB_NomSiteChange(nil);
   end;
   frm_ChxSite.release;
end;

procedure TFrm_Creation.SpeedButton7Click(Sender: TObject);
var
   frm_ChxMag: Tfrm_ChxMag;
   tsoc: TSociete;
   Tmag: TMagasin;
begin
   application.CreateForm(Tfrm_ChxMag, frm_ChxMag);
   if frm_ChxMag.ShowModal = mrok then
   begin
      tsoc := TSociete(Lb_NomSoc.items.Objects[Lb_NomSoc.itemIndex]);
      Tmag := TMagasin.create;
      tsoc.LesMagasins.add(Tmag);
      tmag.Existe := false;
      tmag.nom := frm_ChxMag.ed_nom.text;
      tmag.IdCourt := frm_ChxMag.Ed_Ident.text;
      tmag.Location := frm_ChxMag.cb_location.checked;
      tmag.ID := -1;
      LB_NomMag.Items.AddObject(tmag.nom, tmag);
      LB_NomMag.ItemIndex := LB_NomMag.Items.Count - 1;
      LB_NomMagChange(nil);
   end;
   frm_ChxMag.release;
end;

procedure TFrm_Creation.LB_VersionChange(Sender: TObject);
var
   S: string;
   i: integer;
begin
   S := LB_Version.text + ';';
   for i := 0 to LesVersion.count - 1 do
   begin
      if pos(S, LesVersion[i]) = 1 then
      begin
         S := LesVersion[i];
         Delete(S, 1, Pos(';', S));
         Delete(S, 1, Pos(';', S));
         Lab_Eai.Caption := S;
         Install.Version := LB_Version.text;
         install.Eai := S;
      end;
   end;
end;

function TFrm_Creation.LoadDocument(fichier: string): Integer;
var
   i: integer;
begin
   if not loadxml(fichier, '') then
      result := MrCancel
   else
   begin
      ed_bd.text := install.BD_ref;
      ED_RepDest.text := install.Rep_Dest;
      Ed_NomClt.text := install.Nom_Clt;
      Ed_IdCourt.text := install.Id_court;
      LB_NomSite.items.Clear;
      for i := 0 to Install.LesSites.count - 1 do
         LB_NomSite.items.AddObject(Install.Sites[i].Nom, Install.Sites[i]);
      if LB_NomSite.items.Count > 0 then
         LB_NomSite.ItemIndex := 0;
      LB_NomSiteChange(nil);
      Lb_NomSoc.items.Clear;
      for i := 0 to Install.LesSociete.count - 1 do
         Lb_NomSoc.items.AddObject(Install.Societes[i].Nom, Install.Societes[i]);
      if Lb_NomSoc.items.Count > 0 then
         Lb_NomSoc.ItemIndex := 0;
      Lb_NomSocChange(nil);
      LB_VersionChange(nil);

      Cb_Centrale.items.clear;
      Cb_Centrale.items.LoadFromFile(ChangeFileExt(application.exename, '.cnt'));
      if Cb_Centrale.items.IndexOf(Install.Centrale) > -1 then
         Cb_Centrale.ItemIndex := Cb_Centrale.items.IndexOf(Install.Centrale);
      Cb_CentraleChange(nil);
      Cbt_Copie.Checked := Install.Copie;

      result := ShowModal;
   end;
end;

procedure TFrm_Creation.LB_SiteChange(Sender: TObject);
var
   S: string;
   i: integer;
begin
   S := LB_Site.text + ';';
   for i := 0 to LesReplication.count - 1 do
   begin
      if pos(S, LesReplication[i]) = 1 then
      begin
         S := LesReplication[i];
         Delete(S, 1, Pos(';', S));
         install.Rep_Site := S;
      end;
   end;
end;


procedure TFrm_Creation.ED_RepDestChange(Sender: TObject);
begin
   install.Rep_Dest := ED_RepDest.Text;
end;

procedure TFrm_Creation.Ed_NomCltChange(Sender: TObject);
begin
   install.Nom_Clt := Ed_NomClt.Text;
end;

procedure TFrm_Creation.Ed_IdCourtChange(Sender: TObject);
begin
   install.Id_court := Ed_IdCourt.text;
end;

procedure TFrm_Creation.SE_JetonChange(Sender: TObject);
begin
   if LB_NomSite.ItemIndex >= 0 then
   begin
      try
         TUnSite(LB_NomSite.items.Objects[LB_NomSite.ItemIndex]).Jetons := SE_Jeton.Value;
      except
         TUnSite(LB_NomSite.items.Objects[LB_NomSite.ItemIndex]).Jetons := 0;
      end;
   end;
end;

procedure TFrm_Creation.SE_NoteBookChange(Sender: TObject);
begin
   if LB_NomSite.ItemIndex >= 0 then
   begin
      try
         TUnSite(LB_NomSite.items.Objects[LB_NomSite.ItemIndex]).NoteBook := SE_NoteBook.Value;
      except
         TUnSite(LB_NomSite.items.Objects[LB_NomSite.ItemIndex]).NoteBook := 0;
      end;
   end;
end;

procedure TFrm_Creation.CB_CaisseAutoClick(Sender: TObject);
begin
   if LB_NomSite.ItemIndex >= 0 then
   begin
      TUnSite(LB_NomSite.items.Objects[LB_NomSite.ItemIndex]).CA := CB_CaisseAuto.Checked;
   end;
end;

procedure TFrm_Creation.LB_GroupeClickCheck(Sender: TObject);
begin
   TunDroit(Lb_Groupe.items.Objects[Lb_Groupe.ItemIndex]).Actif := Lb_Groupe.Checked[Lb_Groupe.ItemIndex];
end;

procedure TFrm_Creation.SpeedButton8Click(Sender: TObject);
var
   frm_ChxPoste: Tfrm_ChxPoste;
   tpos: tposte;
   tmag: tmagasin;
begin
   Application.createform(Tfrm_ChxPoste, frm_ChxPoste);
   if frm_ChxPoste.ShowModal = mrOk then
   begin
      tmag := tmagasin(LB_NomMag.items.Objects[LB_NomMag.itemIndex]);
      tpos := tposte.create;
      tpos.nom := frm_ChxPoste.Edit1.text;
      tpos.Existe := false;
      tpos.id := -1;
      tmag.LesPostes.add(tpos);
      Lb_Postes.items.AddObject(tpos.nom, tpos);
   end;
   frm_ChxPoste.release;
end;

function TFrm_Creation.loadxml(fichier, Labase: string): boolean;
var
   Document: IXMLCursor;
   Base: IXMLCursor;
   Mag: IXMLCursor;
   Post: IXMLCursor;
   i: integer;
   tsit: TUnSite;
   Tmag: TMagasin;
   Tsoc: TSociete;
   tpos: Tposte;
   S: string;
begin
   Initialise;
   Document := TXMLCursor.Create;
   Document.Load(fichier);
   Document.First;
   result := false;
   if Document.GetValue('VER_XML') = '' then
      Application.MessageBox('Ancienne version de fichier d''installation, Impossible de le charger', ' Désolé', mb_Ok)
   else
   begin
      install.BD_ref := Document.GetValue('LABASE');
      if labase <> '' then
         install.Rep_Dest := LaBase
      else
         install.Rep_Dest := Document.GetValue('LEREP');
      install.Version := Document.GetValue('VERSION');
      install.Eai := Document.GetValue('VERSIONEAI');
      install.Rep_Site := Document.GetValue('PANTIN');
      install.Nom_Clt := Document.GetValue('NOM');
      install.Id_court := Document.GetValue('IDCOURT');
      install.Centrale := Document.GetValue('CENTRALE');
      install.Copie := Document.GetValue('COPIE') = 'OUI';
      for i := 0 to install.LesDroits.count - 1 do
      begin
         S := install.Droits[i].Nom;
         while pos(' ', S) > 0 do
            S[pos(' ', S)] := '_';
         if Document.GetValue(S) = '1' then
            install.Droits[i].Actif := true
         else
            install.Droits[i].Actif := false;
      end;
      Base := Document.Select('BASES');
      if base.count > 0 then
      begin
         Base := Base.Select('BASE');
         while not Base.eof do
         begin
            tsit := TUnSite.create;
            install.LesSites.add(Tsit);
            tsit.Nom := Base.GetValue('NOM');
            tsit.Jetons := Strtoint(Base.GetValue('JETONS'));
            tsit.NoteBook := Strtoint(Base.GetValue('NOTEBOOK'));
            tsit.CA := Base.GetValue('SECOUR') = 'OUI';
            tsit.VraiNom := Base.GetValue('VRAINOM');
            tsit.Ident := Base.GetValue('IDENT');
            tsit.PLage := Base.GetValue('PLAGE');
            if Base.GetValue('ID') = '-1' then
            begin
               tsit.id := -1;
               tsit.Existe := false;
            end
            else
            begin
               tsit.id := Strtoint(Base.GetValue('ID'));
               tsit.Existe := true;
            end;
            Base.Next;
         end;
      end;
      Document.First;
      Base := Document.Select('SOCIETES');
      if Base.Count > 0 then
      begin
         Base := Base.select('SOCIETE');
         while not base.eof do
         begin
            TSoc := TSociete.create;
            Install.LesSociete.Add(Tsoc);
            tsoc.Nom := base.GetValue('NOM');
            if base.GetValue('ID') = '-1' then
            begin
               tsoc.Existe := false;
               tsoc.id := -1;
            end
            else
            begin
               tsoc.Existe := true;
               tsoc.id := StrToInt(base.GetValue('ID'));
            end;
            Mag := Base.select('MAGASINS');
            if mag.count > 0 then
            begin
               mag := mag.select('MAGASIN');
               while not mag.eof do
               begin
                  Tmag := TMagasin.create;
                  tsoc.LesMagasins.add(tmag);
                  tmag.nom := Mag.getvalue('NOM');
                  tmag.IdCourt := Mag.getvalue('IDCOURT');
                  tmag.Location := Mag.getvalue('LOCATION') = 'OUI';
                  if Mag.getvalue('ID') = '-1' then
                  begin
                     tMag.Existe := false;
                     tMag.id := -1;
                  end
                  else
                  begin
                     tMag.Existe := true;
                     tMag.id := strtoint(Mag.getvalue('ID'));
                  end;
                  Post := Mag.select('POSTES');
                  if post.count > 0 then
                  begin
                     post := post.select('POSTE');
                     while not post.eof do
                     begin
                        tpos := tposte.create;
                        tmag.LesPostes.add(tpos);
                        tpos.nom := post.getvalue('NOM');
                        tpos.id := Strtoint(post.getvalue('ID'));
                        tpos.Existe := tpos.id <> -1;
                        post.next;
                     end;
                  end;
                  post := nil;
                  mag.next;
               end;
            end;
            mag := nil;
            base.next;
         end;
      end;
      Base := nil;
      result := true;
   end;
   Document := nil;
end;

procedure TFrm_Creation.SpeedButton3Click(Sender: TObject);
var
   Tsit: TUnSite;
begin
   tsit := TUnSite(LB_NomSite.items.Objects[LB_NomSite.itemIndex]);
   if not tsit.Existe then
   begin
      LB_NomSite.items.delete(LB_NomSite.itemIndex);
      install.LesSites.delete(install.LesSites.IndexOf(Tsit));
      tsit.free;
      LB_NomSiteChange(nil);
   end;
end;

procedure TFrm_Creation.SpeedButton5Click(Sender: TObject);
var
   Tsoc: TSociete;
begin
   tsoc := tsociete(Lb_NomSoc.items.Objects[Lb_NomSoc.itemIndex]);
   if not tsoc.Existe then
   begin
      Lb_NomSoc.items.delete(Lb_NomSoc.itemIndex);
      Install.LesSociete.delete(install.LesSociete.IndexOf(tsoc));
      tsoc.free;
      Lb_NomSocChange(nil);
   end;
end;

procedure TFrm_Creation.SpeedButton6Click(Sender: TObject);
var
   tsoc: TSociete;
   tmag: TMagasin;
begin
   tsoc := tsociete(Lb_NomSoc.items.Objects[Lb_NomSoc.itemIndex]);
   tmag := TMagasin(LB_NomMag.items.Objects[LB_NomMag.itemIndex]);
   if not tmag.Existe then
   begin
      LB_NomMag.items.delete(LB_NomMag.itemIndex);
      tsoc.LesMagasins.delete(tsoc.LesMagasins.Indexof(tmag));
      tmag.free;
      Lb_NomSocChange(nil);
   end;
end;

procedure TFrm_Creation.SpeedButton9Click(Sender: TObject);
var
   tmag: TMagasin;
   tpos: tposte;
begin
   tmag := TMagasin(LB_NomMag.items.Objects[LB_NomMag.itemIndex]);
   tpos := TPoste(Lb_Postes.items.Objects[Lb_Postes.itemIndex]);
   if not tpos.existe then
   begin
      Lb_Postes.items.delete(Lb_Postes.itemIndex);
      tmag.LesPostes.delete(tmag.LesPostes.IndexOf(Tpos));
      Tpos.free;
      LB_NomMagChange(nil);
   end;
end;

procedure TFrm_Creation.SpeedButton10Click(Sender: TObject);
begin
   OD_Fold.InitialDir := install.Rep_Dest;
   if OD_Fold.Execute then
   begin
      ED_RepDest.Text := OD_Fold.FolderName;
      install.Rep_Dest := ED_RepDest.Text;
   end;
   show;
end;

procedure TFrm_Creation.Cb_CentraleChange(Sender: TObject);
begin
   Install.Centrale := Cb_Centrale.text;
end;

procedure TFrm_Creation.Cbt_CopieClick(Sender: TObject);
begin
   Install.Copie := Cbt_Copie.Checked;
end;

end.

