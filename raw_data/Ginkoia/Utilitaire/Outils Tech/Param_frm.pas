unit Param_frm;

interface

uses
   UPost,
   Sites_frm,
   Societe_frm,
   Magasin_frm,
   Poste_frm,
   ComObj,
   Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
   Buttons, ExtCtrls, IpUtils, IpSock, IpHttp, IpHttpClientGinkoia, Db,
   dxmdaset, Spin, Dialogs;

type
   Tfrm_param = class(TForm)
      lab_eai: TLabel;
      Lab_version: TLabel;
      Lab_DATABASE: TLabel;
      Http: TIpHttpClientGinkoia;
      MemD_Soc: TdxMemData;
      MemD_SocStatut: TIntegerField;
      MemD_SocSOC_ID: TIntegerField;
      MemD_SocSOC_NOM: TStringField;
      MemD_SocSOC_CLOTURE: TDateField;
      Bevel5: TBevel;
      Bevel4: TBevel;
      Label11: TLabel;
      Label12: TLabel;
      SpeedButton2: TSpeedButton;
      SpeedButton3: TSpeedButton;
      Label15: TLabel;
      Label16: TLabel;
      SpeedButton4: TSpeedButton;
      SpeedButton5: TSpeedButton;
      SpeedButton6: TSpeedButton;
      SpeedButton7: TSpeedButton;
      Label17: TLabel;
      Label18: TLabel;
      SpeedButton8: TSpeedButton;
      SpeedButton9: TSpeedButton;
      LB_NomSite: TComboBox;
      Lb_NomSoc: TComboBox;
      LB_NomMag: TComboBox;
      Lb_Postes: TListBox;
      MemD_Mag: TdxMemData;
      MemD_MagStatut: TIntegerField;
      MemD_MagMAG_ID: TIntegerField;
      MemD_MagMAG_IDENT: TStringField;
      MemD_MagMAG_NOM: TStringField;
      MemD_MagMAG_SOCID: TIntegerField;
      MemD_MagMAG_IDENTCOURT: TStringField;
      MemD_Postes: TdxMemData;
      MemD_PostesStatut: TIntegerField;
      MemD_PostesPOS_ID: TIntegerField;
      MemD_PostesPOS_NOM: TStringField;
      MemD_PostesPOS_MAGID: TIntegerField;
      MemD_Bases: TdxMemData;
      MemD_Basesstatut: TIntegerField;
      MemD_BasesBAS_ID: TIntegerField;
      MemD_BasesBAS_NOM: TStringField;
      MemD_BasesBAS_IDENT: TStringField;
      MemD_BasesBAS_JETON: TIntegerField;
      MemD_BasesBAS_PLAGE: TStringField;
      MemD_BasesBAS_SENDER: TStringField;
      MemD_BasesBAS_GUID: TStringField;
      MemD_BasesBAS_CENTRALE: TStringField;
      MemD_BasesBAS_NOMPOURNOUS: TStringField;
      BitBtn1: TBitBtn;
      BitBtn2: TBitBtn;
      SpeedButton1: TSpeedButton;
      SpeedButton10: TSpeedButton;
      SpeedButton11: TSpeedButton;
      SpeedButton12: TSpeedButton;
      MemD_BasesBAS_DEBUT: TIntegerField;
      MemD_BasesBAS_FIN: TIntegerField;
      lab_machine: TLabel;
      procedure Lb_NomSocChange(Sender: TObject);
      procedure LB_NomMagChange(Sender: TObject);
      procedure SpeedButton2Click(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure SpeedButton3Click(Sender: TObject);
      procedure SpeedButton1Click(Sender: TObject);
      procedure SpeedButton4Click(Sender: TObject);
      procedure SpeedButton5Click(Sender: TObject);
      procedure SpeedButton10Click(Sender: TObject);
      procedure SpeedButton7Click(Sender: TObject);
      procedure SpeedButton6Click(Sender: TObject);
      procedure SpeedButton11Click(Sender: TObject);
      procedure SpeedButton8Click(Sender: TObject);
      procedure SpeedButton9Click(Sender: TObject);
      procedure SpeedButton12Click(Sender: TObject);
      procedure BitBtn1Click(Sender: TObject);
   private
      function ValueTag(s, tag: string): string;
    { Private declarations }
   public
    { Public declarations }
      DatabaseName: string;
      LaDatabase: string;
      LeSite: string;
      version: string;
      Idversion: string;
      NomVersion: string;
      EAI: string;
      genid: Integer;
      clt_machine: string;
      LaMachine: string;
      function execute: Tmodalresult;
   end;

var
   frm_param: Tfrm_param;

implementation
uses
   UCst;

{$R *.DFM}

{ Tfrm_param }

function Tfrm_param.ValueTag(s, tag: string): string;
var
   t, at: string;
   i: integer;
begin
   t := '<' + tag + '>';
   at := '</' + tag + '>';
   if pos(t, s) > 0 then
   begin
      i := pos(t, s) + LENGTH(t);
      result := copy(s, pos(t, s) + LENGTH(t), pos(at, s) - i);
   end
   else
      result := '';
end;

const
   lesplace: array[1..20] of string = ('192.168.0.11', '192.168.0.12', '192.168.0.13', '192.168.0.14', '192.168.0.15', '192.168.0.16', '192.168.0.17','192.168.0.118','192.168.0.119','192.168.13.20', 'GSA-LAME1', 'GSA-LAME2', 'GSA-LAME3', 'GSA-LAME4', 'GSA-LAME5', 'GSA-LAME6', 'GSA-LAME7', 'GSA-LAME8', 'GSA-LAME9', 'SYMREPLIC1');
   lesMachine: array[1..20] of string = ('http://lame1.no-ip.com/', 'http://lame2.no-ip.com/', 'http://lame3.no-ip.com/', 'http://lame4.no-ip.com/', 'http://lame5.no-ip.com/', 'http://lame6.no-ip.org/', 'http://lame7.no-ip.org/','http://lame8.no-ip.org/','http://lame9.no-ip.org/','http://192.168.13.20/',
      'http://lame1.no-ip.com/', 'http://lame2.no-ip.com/', 'http://lame3.no-ip.com/', 'http://lame4.no-ip.com/', 'http://lame5.no-ip.com/','http://lame6.no-ip.org/','http://lame7.no-ip.org/','http://lame8.no-ip.org/','http://lame9.no-ip.org/','http://192.168.13.20/');

function Tfrm_param.execute: Tmodalresult;
var
   tc: Tconnexion;
   res: TStringList;
   S: string;
   s1: string;
   s2: string;
   req: string;
   i: Integer;
   deb, fin: string;
begin
   tc := Tconnexion.create;
   req := URL + 'Qry?';
   clt_machine := '';
   LaMachine := '';
   if copy(DatabaseName, 1, 2) = '\\' then
   begin
      clt_machine := DatabaseName;
      delete(clt_machine, 1, 2);
      clt_machine := Copy(clt_machine, 1, pos('\', clt_machine) - 1);
      LaMachine := clt_machine;
      for i := 1 to Length(lesplace) do
      begin
         if clt_machine = lesplace[i] then
         begin
            clt_machine := lesMachine[i];
            BREAK;
         end;
      end;

      LaDatabase := DatabaseName;
      delete(LaDatabase, 1, 2);
      if pos('$', LaDatabase) > 0 then
      begin
         LaDatabase[pos('$', LaDatabase)] := ':';
         LaDatabase[pos('\', LaDatabase)] := ':';
      end
      else
      begin
         i := pos('\', LaDatabase);
         insert(':'+LecteurLame+':', LaDatabase, i);
      end;
   end
   else
      LaDatabase := DatabaseName;
   req := req + 'BASE=' + LaDatabase + '&';
   s := req + 'QRY=Select Ver_version from genversion Order by ver_date desc';
   s := s + '&COUNT=1';
   s := traitechaine(s);
   if Http.oldGetWaitTimeOut(s, 30000) then
   begin
      s := Http.AsString(s);
      version := ValueTag(s, 'VER_VERSION');
   end;
   if trim(clt_machine) = '' then
      lab_machine.Caption := '(Pas de machine) Base :' + DatabaseName
   else
      lab_machine.Caption := 'Machine d''installation :' + clt_machine;
   res := tc.Select('select id, nomversion, EAI from version where version.version="' + version + '"');
   NomVersion := tc.UneValeur(res, 'nomversion');
   Lab_version.caption := 'Version: ' + NomVersion;
   EAI := tc.UneValeur(res, 'EAI');
   idversion := tc.UneValeur(res, 'id');
   lab_eai.caption := 'EAI: ' + EAI;
   tc.FreeResult(res);

   s := req + 'QRY=select SOC_ID, SOC_NOM, SOC_CLOTURE ';
   s := S + ' from gensociete join k on (k_id=soc_id and k_enabled=1) ';
   s := S + ' where soc_id<>0 ';
   s := traitechaine(s);
   if Http.oldGetWaitTimeOut(s, 30000) then
   begin
      s := Http.AsString(s);
      MemD_Soc.Close;
      MemD_Soc.Open;
      Lb_NomSoc.Items.clear;
      while pos('<ENR>', s) > 0 do
      begin
         delete(s, 1, pos('<ENR>', s) + length('<ENR>') - 1);
         s1 := copy(s, 1, pos('</ENR>', s) - 1);
         delete(s, 1, pos('</ENR>', s) + length('</ENR>') - 1);
         MemD_Soc.Insert;
         MemD_SocStatut.AsInteger := 0;
         MemD_SocSOC_ID.AsString := ValueTag(s1, 'SOC_ID');
         MemD_SocSOC_NOM.AsString := ValueTag(s1, 'SOC_NOM');
         MemD_SocSOC_CLOTURE.AsString := ValueTag(s1, 'SOC_CLOTURE');
         Lb_NomSoc.Items.AddObject(ValueTag(s1, 'SOC_NOM'), pointer(MemD_SocSOC_ID.AsInteger));
         MemD_Soc.Post;
      end;
   end;
   Lb_NomSoc.ItemIndex := 0;

   s := req + 'QRY=select MAG_ID, MAG_IDENT, MAG_NOM, MAG_SOCID, MAG_IDENTCOURT ';
   s := S + ' from genmagasin join k on (mag_id=k_id and k_enabled=1) ';
   s := S + ' where mag_id<>0 ';
   s := traitechaine(s);
   if Http.oldGetWaitTimeOut(s, 30000) then
   begin
      s := Http.AsString(s);
      LB_NomMag.Items.Clear;
      MemD_Mag.close;
      MemD_Mag.Open;
      while pos('<ENR>', s) > 0 do
      begin
         delete(s, 1, pos('<ENR>', s) + length('<ENR>') - 1);
         s1 := copy(s, 1, pos('</ENR>', s) - 1);
         delete(s, 1, pos('</ENR>', s) + length('</ENR>') - 1);
         MemD_Mag.Insert;
         MemD_MagStatut.AsInteger := 0;
         MemD_MagMAG_ID.AsString := ValueTag(s1, 'MAG_ID');
         MemD_MagMAG_IDENT.AsString := ValueTag(s1, 'MAG_IDENT');
         MemD_MagMAG_NOM.AsString := ValueTag(s1, 'MAG_NOM');
         MemD_MagMAG_SOCID.AsString := ValueTag(s1, 'MAG_SOCID');
         MemD_MagMAG_IDENTCOURT.AsString := ValueTag(s1, 'MAG_IDENTCOURT');
         if Lb_NomSoc.ItemIndex > -1 then
            if MemD_MagMAG_SOCID.AsInteger = Integer(Lb_NomSoc.items.Objects[Lb_NomSoc.ItemIndex]) then
               LB_NomMag.Items.AddObject(ValueTag(s1, 'MAG_NOM'), pointer(MemD_MagMAG_ID.AsInteger));
         MemD_Mag.Post;
      end;
   end;
   LB_NomMag.ItemIndex := 0;

   s := req + 'QRY=select POS_ID, POS_NOM, POS_MAGID ';
   s := s + ' from genposte join k on (k_id=pos_id and k_enabled=1) ';
   s := s + ' where pos_id<>0 ';
   s := traitechaine(s);
   if Http.oldGetWaitTimeOut(s, 30000) then
   begin
      s := Http.AsString(s);
      Lb_Postes.Items.Clear;
      MemD_Postes.close;
      MemD_Postes.Open;
      while pos('<ENR>', s) > 0 do
      begin
         delete(s, 1, pos('<ENR>', s) + length('<ENR>') - 1);
         s1 := copy(s, 1, pos('</ENR>', s) - 1);
         delete(s, 1, pos('</ENR>', s) + length('</ENR>') - 1);
         MemD_Postes.Insert;
         MemD_PostesStatut.AsInteger := 0;
         MemD_PostesPOS_ID.AsString := ValueTag(s1, 'POS_ID');
         MemD_PostesPOS_NOM.AsString := ValueTag(s1, 'POS_NOM');
         MemD_PostesPOS_MAGID.AsString := ValueTag(s1, 'POS_MAGID');
         if LB_NomMag.ItemIndex > -1 then
            if MemD_PostesPOS_MAGID.AsInteger = Integer(LB_NomMag.items.Objects[LB_NomMag.ItemIndex]) then
               Lb_Postes.Items.AddObject(ValueTag(s1, 'POS_NOM'), pointer(MemD_PostesPOS_ID.AsInteger));
         MemD_Postes.Post;
      end;
   end;
   Lb_Postes.ItemIndex := 0;

   s := req + 'QRY=Select BAS_ID, BAS_NOM, BAS_PLAGE, BAS_IDENT, BAS_GUID, BAS_SENDER, BAS_JETON, BAS_CENTRALE, BAS_NOMPOURNOUS ';
   s := s + ' from genbases join k on (k_id=bas_id and k_enabled=1)';
   s := s + ' where bas_id<>0';
   s := s + ' Order by bas_ident';
   s := traitechaine(s);
   if Http.oldGetWaitTimeOut(s, 30000) then
   begin
      s := Http.AsString(s);
      MemD_Bases.close;
      MemD_Bases.open;
      LB_NomSite.Items.Clear;
      while pos('<ENR>', s) > 0 do
      begin
         delete(s, 1, pos('<ENR>', s) + length('<ENR>') - 1);
         s1 := copy(s, 1, pos('</ENR>', s) - 1);
         delete(s, 1, pos('</ENR>', s) + length('</ENR>') - 1);
         MemD_Bases.Insert;
         MemD_Basesstatut.AsInteger := 0;
         MemD_BasesBAS_ID.AsString := ValueTag(s1, 'BAS_ID');
         MemD_BasesBAS_NOM.AsString := ValueTag(s1, 'BAS_NOM');
         MemD_BasesBAS_IDENT.AsString := ValueTag(s1, 'BAS_IDENT');
         MemD_BasesBAS_JETON.AsString := ValueTag(s1, 'BAS_JETON');
         MemD_BasesBAS_PLAGE.AsString := ValueTag(s1, 'BAS_PLAGE');
         MemD_BasesBAS_SENDER.AsString := ValueTag(s1, 'BAS_SENDER');
         MemD_BasesBAS_GUID.AsString := ValueTag(s1, 'BAS_GUID');
         MemD_BasesBAS_CENTRALE.AsString := ValueTag(s1, 'BAS_CENTRALE');
         MemD_BasesBAS_NOMPOURNOUS.AsString := ValueTag(s1, 'BAS_NOMPOURNOUS');
         if MemD_BasesBAS_IDENT.AsString = '0' then
         begin
            res := tc.Select('select site from clients where clt_GUID="' + MemD_BasesBAS_GUID.AsString + '"');
            if tc.recordCount(res) > 0 then
            begin
               LeSite := tc.UneValeur(res, 'site');
            end;
            tc.FreeResult(res);
         end;
         s2 := ValueTag(s1, 'BAS_PLAGE');
         while not (s2[1] in ['0'..'9']) do
            delete(s2, 1, 1);
         deb := '';
         while (s2[1] in ['0'..'9']) do
         begin
            deb := deb + s2[1];
            delete(s2, 1, 1);
         end;
         while not (s2[1] in ['0'..'9']) do
            delete(s2, 1, 1);
         fin := '';
         while (s2[1] in ['0'..'9']) do
         begin
            fin := fin + s2[1];
            delete(s2, 1, 1);
         end;
         MemD_BasesBAS_DEBUT.AsString := Deb;
         MemD_BasesBAS_FIN.AsString := fin;
         LB_NomSite.Items.AddObject(MemD_BasesBAS_NOM.AsString, Pointer(MemD_BasesBAS_ID.AsInteger));
         MemD_Bases.Post;
      end;
      LB_NomSite.ItemIndex := 0;
      MemD_Bases.First;
      Lab_DATABASE.caption := 'Client: ' + MemD_BasesBAS_CENTRALE.AsString + ' : ' + MemD_BasesBAS_NOMPOURNOUS.AsString;
   end;
   tc.free;
   result := MrCancel;
   if pos('.', version) = 0 then
      application.MessageBox('Pas de version, impossible de continuer', '  Erreur', Mb_Ok)
   else if Strtoint(Copy(version, 1, pos('.', version) - 1)) < 6 then
      application.MessageBox('Ce programme ne tourne que sur les versions 6.1 et suppérieure, impossible de continuer', '  Erreur', Mb_Ok)
   else
      result := ShowModal;
end;

procedure Tfrm_param.Lb_NomSocChange(Sender: TObject);
begin
   LB_NomMag.Items.clear;
   if Lb_NomSoc.ItemIndex > -1 then
   begin
      MemD_Mag.First;
      while not MemD_Mag.eof do
      begin
         if (MemD_MagMAG_SOCID.AsInteger = Integer(Lb_NomSoc.items.Objects[Lb_NomSoc.ItemIndex])) and
            (MemD_MagStatut.AsInteger <> -1) then
            LB_NomMag.Items.AddObject(MemD_MagMAG_NOM.AsString, Pointer(MemD_MagMAG_ID.AsInteger));
         MemD_Mag.Next;
      end;
      LB_NomMag.itemindex := 0;
   end;
   LB_NomMagChange(nil);
end;

procedure Tfrm_param.LB_NomMagChange(Sender: TObject);
begin
   Lb_Postes.Items.clear;
   if LB_NomMag.ItemIndex > -1 then
   begin
      MemD_Postes.first;
      while not MemD_Postes.Eof do
      begin
         if (MemD_PostesPOS_MAGID.AsInteger = Integer(LB_NomMag.Items.Objects[LB_NomMag.ItemIndex])) and
            (MemD_PostesStatut.AsInteger <> -1) then
            Lb_Postes.Items.AddObject(MemD_PostesPOS_NOM.AsString, Pointer(MemD_PostesPOS_ID.AsInteger));
         MemD_Postes.Next;
      end;
      Lb_Postes.ItemIndex := 0;
   end;
end;

procedure Tfrm_param.SpeedButton2Click(Sender: TObject);
var
   Frm_Sites: TFrm_Sites;
   fin: integer;
   deb: Integer;
   id: Integer;
   ok: Boolean;
   ctrl, npn: string;
begin
   // Création
   Application.CreateForm(TFrm_Sites, Frm_Sites);
   deb := 0;
   fin := 50;
   repeat
      repeat
         ok := true;
         MemD_Bases.first;
         while not MemD_Bases.eof do
         begin
            try
               if (deb >= MemD_BasesBAS_DEBUT.AsInteger) and (deb < MemD_BasesBAS_FIN.AsInteger) then
               begin
                  deb := MemD_BasesBAS_FIN.AsInteger;
                  fin := deb + 40;
                  ok := false;
                  BREAK;
               end;
            except
            end;
            MemD_Bases.Next;
         end;
      until ok;

      MemD_Bases.first;
      while not MemD_Bases.eof do
      begin
         try
            if (fin >= MemD_BasesBAS_DEBUT.AsInteger) and (fin < MemD_BasesBAS_FIN.AsInteger) then
            begin
               deb := MemD_BasesBAS_FIN.AsInteger;
               fin := deb + 40;
               ok := false;
               BREAK;
            end;
         except
         end;
         MemD_Bases.Next;
      end;
      
   until ok;

   MemD_Bases.first;
   ctrl := MemD_BasesBAS_CENTRALE.AsString;
   npn := MemD_BasesBAS_NOMPOURNOUS.AsString;

   id := -1;
   repeat
      id := id + 1;
      MemD_Bases.first;
      while not MemD_Bases.eof do
      begin
         try
            if id = MemD_BasesBAS_IDENT.AsInteger then
               BREAK;
         except
         end;
         MemD_Bases.Next;
      end;
   until (MemD_Bases.IsEmpty) or (Inttostr(id) <> MemD_BasesBAS_IDENT.AsString);
   Frm_Sites.ed_PLage.Text := '[' + Inttostr(deb) + 'M_' + Inttostr(fin) + 'M]';
   Frm_Sites.ed_Ident.Text := Inttostr(id);
   Frm_Sites.ed_Nom.Text := '';
   repeat
      if Frm_Sites.ShowModal = MrOk then
      begin
         if trim(Frm_Sites.ed_Nom.Text) = '' then
            application.MessageBox('Le nom du site doit être remplit', ' Erreur', Mb_OK)
         else
         begin
            ok := True;
            MemD_Bases.first;
            while not MemD_Bases.eof do
            begin
               if Frm_Sites.ed_Ident.Text = MemD_BasesBAS_IDENT.AsString then
               begin
                  application.MessageBox('L''identifiant du site existe déjà', ' Erreur', Mb_OK);
                  ok := false;
                  BREAK;
               end;
               if Frm_Sites.ed_Nom.text = MemD_BasesBAS_NOM.AsString then
               begin
                  application.MessageBox('Le nom du site existe déjà', ' Erreur', Mb_OK);
                  ok := false;
                  BREAK;
               end;
               MemD_Bases.Next;
            end;
            if ok then
            begin
              // Création
               MemD_Bases.Insert;
               MemD_Basesstatut.AsInteger := 1;
               MemD_BasesBAS_ID.AsInteger := GenId; inc(GenId);
               MemD_BasesBAS_NOM.AsString := Frm_Sites.ed_Nom.text;
               MemD_BasesBAS_IDENT.AsString := Frm_Sites.ed_Ident.text;
               MemD_BasesBAS_JETON.AsInteger := Frm_Sites.SpinEdit1.Value;
               MemD_BasesBAS_PLAGE.AsString := Frm_Sites.ed_PLage.Text;
               MemD_BasesBAS_SENDER.AsString := Frm_Sites.ed_Nom.text;
               MemD_BasesBAS_GUID.AsString := CreateClassID;
               MemD_BasesBAS_DEBUT.AsInteger := deb ;
               MemD_BasesBAS_FIN.AsInteger := fin ;
               MemD_BasesBAS_CENTRALE.AsString := ctrl;
               MemD_BasesBAS_NOMPOURNOUS.AsString := npn;
               MemD_Bases.Post;
               LB_NomSite.Items.AddObject(MemD_BasesBAS_NOM.AsString, Pointer(MemD_BasesBAS_ID.AsInteger));
               LB_NomSite.ItemIndex := LB_NomSite.Items.count - 1;
               BREAK;
            end;
         end;
      end
      else
         BREAK;
   until false;
   Frm_Sites.release;
end;

procedure Tfrm_param.FormCreate(Sender: TObject);
begin
   genid := 1;
end;

procedure Tfrm_param.SpeedButton3Click(Sender: TObject);
begin
   if application.messagebox('Supprimer le site', 'ATTENTION', Mb_YESNO or MB_DEFBUTTON2) = MrYes then
   begin
      MemD_Bases.first;
      while MemD_BasesBAS_ID.AsInteger <> Integer(LB_NomSite.Items.Objects[LB_NomSite.ItemIndex]) do
         MemD_Bases.Next;
      if MemD_Basesstatut.AsInteger = 1 then
         MemD_Bases.Delete
      else
      begin
         MemD_Bases.edit;
         MemD_Basesstatut.AsInteger := -1;
         MemD_Bases.Post;
      end;
      LB_NomSite.Items.Delete(LB_NomSite.ItemIndex);
   end;
end;

procedure Tfrm_param.SpeedButton1Click(Sender: TObject);
var
   Frm_Sites: TFrm_Sites;
   i: integer;
begin
   Application.CreateForm(TFrm_Sites, Frm_Sites);
   MemD_Bases.first;
   while MemD_BasesBAS_ID.AsInteger <> Integer(LB_NomSite.Items.Objects[LB_NomSite.ItemIndex]) do
      MemD_Bases.Next;
   Frm_Sites.ed_PLage.Text := MemD_BasesBAS_PLAGE.AsString;
   Frm_Sites.ed_Ident.Text := MemD_BasesBAS_IDENT.AsString;
   Frm_Sites.ed_Nom.Text := MemD_BasesBAS_NOM.AsString;
   Frm_Sites.SpinEdit1.Value := MemD_BasesBAS_JETON.AsInteger;
   if Frm_Sites.ShowModal = MrOk then
   begin
      // Modification
      if MemD_Basesstatut.AsInteger = 1 then
      begin
         MemD_Bases.Edit;
         MemD_BasesBAS_NOM.AsString := Frm_Sites.ed_Nom.text;
         MemD_BasesBAS_IDENT.AsString := Frm_Sites.ed_Ident.text;
         MemD_BasesBAS_PLAGE.AsString := Frm_Sites.ed_PLage.Text;
         MemD_BasesBAS_SENDER.AsString := Frm_Sites.ed_Nom.text;
         MemD_BasesBAS_JETON.AsInteger := Frm_Sites.SpinEdit1.Value;
         MemD_Bases.Post;
      end
      else
      begin
         if (MemD_BasesBAS_NOM.AsString <> Frm_Sites.ed_Nom.text) or
            (MemD_BasesBAS_IDENT.AsString <> Frm_Sites.ed_Ident.text) or
            (MemD_BasesBAS_PLAGE.AsString <> Frm_Sites.ed_PLage.Text) or
            (MemD_BasesBAS_JETON.AsInteger <> Frm_Sites.SpinEdit1.Value) then
         begin
            MemD_Bases.Edit;
            MemD_Basesstatut.AsInteger := 2;
            MemD_BasesBAS_NOM.AsString := Frm_Sites.ed_Nom.text;
            MemD_BasesBAS_IDENT.AsString := Frm_Sites.ed_Ident.text;
            MemD_BasesBAS_PLAGE.AsString := Frm_Sites.ed_PLage.Text;
            MemD_BasesBAS_SENDER.AsString := Frm_Sites.ed_Nom.text;
            MemD_BasesBAS_JETON.AsInteger := Frm_Sites.SpinEdit1.Value;
            MemD_Bases.Post;
         end;
      end;
      i := LB_NomSite.ItemIndex;
      LB_NomSite.Items[LB_NomSite.ItemIndex] := MemD_BasesBAS_NOM.AsString;
      LB_NomSite.ItemIndex := i;
   end;
   Frm_Sites.release;
end;

procedure Tfrm_param.SpeedButton4Click(Sender: TObject);
var
   Frm_Societe: TFrm_Societe;
begin
   Application.CreateForm(TFrm_Societe, Frm_Societe);
   Frm_Societe.ed_Nom.text := '';
   Frm_Societe.Edt_Date.DateTime := Date;
   repeat
      if Frm_Societe.ShowModal = MrOk then
      begin
         MemD_Soc.first;
         while not MemD_Soc.eof do
         begin
            if MemD_SocSOC_NOM.AsString = Frm_Societe.ed_Nom.text then
            begin
               Application.MessageBox('Une société du même nom existe déjà', ' Erreur ', Mb_Ok);
               BREAK;
            end;
            MemD_Soc.Next;
         end;
         if MemD_SocSOC_NOM.AsString <> Frm_Societe.ed_Nom.text then
         begin
            MemD_Soc.Insert;
            MemD_SocSOC_ID.AsInteger := GenId; inc(GenId);
            MemD_SocSOC_NOM.AsString := Frm_Societe.ed_Nom.text;
            MemD_SocSOC_CLOTURE.AsDateTime := Frm_Societe.Edt_Date.DateTime;
            MemD_Socstatut.AsInteger := 1;
            MemD_Soc.Post;
            Lb_NomSoc.Items.AddObject(MemD_SocSOC_NOM.AsString, Pointer(MemD_SocSOC_ID.AsInteger));
            Lb_NomSoc.ItemIndex := Lb_NomSoc.Items.count - 1;
            Lb_NomSocChange(nil);
            BREAK;
         end;
      end
      else
         BREAK;
   until false;
   Frm_Societe.release;
end;

procedure Tfrm_param.SpeedButton5Click(Sender: TObject);
begin
   if application.messagebox('Supprimer la société', 'ATTENTION', Mb_YESNO or MB_DEFBUTTON2) = MrYes then
   begin
      MemD_Soc.first;
      while not MemD_Soc.eof do
      begin
         if MemD_SocSOC_ID.AsInteger = Integer(Lb_NomSoc.items.objects[Lb_NomSoc.ItemIndex]) then
            BREAK;
         MemD_Soc.Next;
      end;
      MemD_Mag.first;
      while not MemD_Mag.Eof do
      begin
         if (MemD_Magstatut.AsInteger <> -1) and (MemD_MagMAG_SOCID.AsInteger = MemD_SocSOC_ID.AsInteger) then
         begin
            application.messagebox('Impossible de supprimer une société avec des magasins existants', 'ATTENTION', Mb_ok);
            BREAK;
         end;
         MemD_Mag.Next;
      end;
      if (MemD_Magstatut.AsInteger = -1) or
         (MemD_MagMAG_SOCID.AsInteger <> MemD_SocSOC_ID.AsInteger) then
      begin
         if MemD_Socstatut.AsInteger = 1 then
            MemD_Soc.Delete
         else
         begin
            MemD_Soc.edit;
            MemD_SocStatut.AsInteger := -1;
            MemD_Soc.Post;
         end;
         Lb_NomSoc.Items.Delete(Lb_NomSoc.ItemIndex);
         Lb_NomSocChange(nil);
      end;
   end;
end;

procedure Tfrm_param.SpeedButton10Click(Sender: TObject);
var
   Frm_Societe: TFrm_Societe;
   i: integer;
begin
   MemD_Soc.first;
   while not MemD_Soc.eof do
   begin
      if MemD_SocSOC_ID.AsInteger = Integer(Lb_NomSoc.items.objects[Lb_NomSoc.ItemIndex]) then
         BREAK;
      MemD_Soc.Next;
   end;
   Application.CreateForm(TFrm_Societe, Frm_Societe);
   Frm_Societe.ed_Nom.Text := MemD_SocSOC_NOM.AsString;
   Frm_Societe.Edt_Date.DateTime := MemD_SocSOC_CLOTURE.AsDateTime;
   if Frm_Societe.ShowModal = mrok then
   begin
      if (Frm_Societe.ed_Nom.Text <> MemD_SocSOC_NOM.AsString) or
         (Frm_Societe.Edt_Date.DateTime <> MemD_SocSOC_CLOTURE.AsDateTime) then
      begin
         MemD_Soc.Edit;
         MemD_SocSOC_NOM.AsString := Frm_Societe.ed_Nom.Text;
         MemD_SocSOC_CLOTURE.AsDateTime := Frm_Societe.Edt_Date.DateTime;
         if MemD_Socstatut.AsInteger <> 1 then
            MemD_Socstatut.AsInteger := 2;
         MemD_Soc.Post;
         i := Lb_NomSoc.ItemIndex;
         Lb_NomSoc.items[Lb_NomSoc.ItemIndex] := MemD_SocSOC_NOM.AsString;
         Lb_NomSoc.ItemIndex := i;
      end;
   end;
   Frm_Societe.release;
end;

procedure Tfrm_param.SpeedButton7Click(Sender: TObject);
var
   frm_magasin: Tfrm_magasin;
begin
   Application.createform(Tfrm_magasin, frm_magasin);
   MemD_Soc.First;
   while not MemD_Soc.Eof do
   begin
      frm_magasin.Lb_Soc.Items.AddObject(MemD_SocSOC_NOM.AsString, Pointer(MemD_SocSOC_ID.AsInteger));
      if MemD_SocSOC_ID.AsInteger = Integer(Lb_NomSoc.items.Objects[Lb_NomSoc.itemIndex]) then
         frm_magasin.Lb_Soc.ItemIndex := frm_magasin.Lb_Soc.items.count - 1;
      MemD_Soc.Next;
   end;
   frm_magasin.ed_Nom.text := '';
   frm_magasin.ed_Ident.text := '';
   repeat
      if frm_magasin.ShowModal = mrok then
      begin
         MemD_Mag.first;
         while not MemD_Mag.Eof do
         begin
            if MemD_MagMAG_NOM.AsString = frm_magasin.ed_Nom.text then
            begin
               application.messagebox('Un Magasin de ce nom existe déjà', ' Erreur', Mb_OK);
               BREAK;
            end;
            MemD_Mag.next;
         end;
         if MemD_MagMAG_NOM.AsString <> frm_magasin.ed_Nom.text then
         begin
            MemD_Mag.Insert;
            MemD_MagStatut.AsInteger := 1;
            MemD_MagMAG_ID.AsInteger := GenId; inc(GenId);
            MemD_MagMAG_IDENT.AsString := frm_magasin.ed_Ident.text;
            MemD_MagMAG_NOM.AsString := frm_magasin.ed_Nom.text;
            MemD_MagMAG_SOCID.AsInteger := Integer(frm_magasin.Lb_Soc.items.Objects[frm_magasin.Lb_Soc.itemIndex]);
            MemD_MagMAG_IDENTCOURT.AsString := frm_magasin.ed_Ident.text;
            MemD_Mag.Post;
            if MemD_MagMAG_SOCID.AsInteger = Integer(Lb_NomSoc.items.Objects[Lb_NomSoc.itemIndex]) then
            begin
               LB_NomMag.items.AddObject(MemD_MagMAG_NOM.AsString, Pointer(MemD_MagMAG_ID.AsInteger));
               LB_NomMag.itemIndex := LB_NomMag.items.count - 1;
            end;
            LB_NomMagChange(nil);
            BREAK;
         end;
      end
      else BREAK;
   until false;
   frm_magasin.release;
end;

procedure Tfrm_param.SpeedButton6Click(Sender: TObject);
begin
   if application.messagebox('Supprimer le magasin', 'ATTENTION', Mb_YESNO or MB_DEFBUTTON2) = MrYes then
   begin
      MemD_Postes.first;
      while not MemD_Postes.Eof do
      begin
         if MemD_PostesPOS_MAGID.AsInteger = Integer(LB_NomMag.items.Objects[LB_NomMag.itemIndex]) then
         begin
            application.messagebox('Impossible de supprimer un magasin avec des postes existants', 'ATTENTION', Mb_ok);
            BREAK;
         end;
         MemD_Postes.Next;
      end;
      if MemD_PostesPOS_MAGID.AsInteger <> Integer(LB_NomMag.items.Objects[LB_NomMag.itemIndex]) then
      begin
         if MemD_Postesstatut.AsInteger = 1 then
            MemD_Postes.Delete
         else
         begin
            MemD_Postes.edit;
            MemD_PostesStatut.AsInteger := -1;
            MemD_Postes.Post;
         end;
         LB_NomMag.Items.Delete(LB_NomMag.ItemIndex);
         LB_NomMagChange(nil);
      end;
   end;
end;

procedure Tfrm_param.SpeedButton11Click(Sender: TObject);
var
   frm_magasin: Tfrm_magasin;
   i: Integer;
begin
   MemD_Mag.first;
   while not MemD_Mag.eof do
   begin
      if MemD_MagMAG_ID.AsInteger = Integer(LB_NomMag.items.Objects[LB_NomMag.itemIndex]) then
         BREAK;
      MemD_Mag.Next;
   end;
   Application.CreateForm(Tfrm_magasin, frm_magasin);
   frm_magasin.ed_Nom.text := MemD_MagMAG_NOM.AsString;
   frm_magasin.ed_Ident.text := MemD_MagMAG_IDENTCOURT.AsString;
   MemD_Soc.First;
   while not MemD_Soc.Eof do
   begin
      frm_magasin.Lb_Soc.Items.AddObject(MemD_SocSOC_NOM.AsString, Pointer(MemD_SocSOC_ID.AsInteger));
      if MemD_MagMAG_SOCID.AsInteger = MemD_SocSOC_ID.AsInteger then
         frm_magasin.Lb_Soc.ItemIndex := frm_magasin.Lb_Soc.items.count - 1;
      MemD_Soc.Next;
   end;
   if frm_magasin.ShowModal = MrOk then
   begin
      if (frm_magasin.ed_Nom.text <> MemD_MagMAG_NOM.AsString) or
         (frm_magasin.ed_Ident.text <> MemD_MagMAG_IDENTCOURT.AsString) or
         (Integer(frm_magasin.Lb_Soc.items.objects[frm_magasin.Lb_Soc.ItemIndex]) <> MemD_MagMAG_SOCID.AsInteger) then
      begin
         MemD_Mag.edit;
         MemD_MagMAG_NOM.AsString := frm_magasin.ed_Nom.text;
         MemD_MagMAG_IDENT.AsString := frm_magasin.ed_Ident.text;
         MemD_MagMAG_IDENTCOURT.AsString := frm_magasin.ed_Ident.text;
         MemD_MagMAG_SOCID.AsInteger := Integer(frm_magasin.Lb_Soc.items.objects[frm_magasin.Lb_Soc.ItemIndex]);
         if MemD_MagStatut.AsInteger <> 1 then
            MemD_MagStatut.AsInteger := 2;
         MemD_Mag.Post;
         if MemD_MagMAG_SOCID.AsInteger = Integer(Lb_NomSoc.items.objects[Lb_NomSoc.ItemIndex]) then
         begin
            i := LB_NomMag.ItemIndex;
            LB_NomMag.Items[LB_NomMag.ItemIndex] := MemD_MagMAG_NOM.AsString;
            LB_NomMag.ItemIndex := i;
         end
         else
            LB_NomMag.Items.delete(LB_NomMag.ItemIndex);
      end;
   end;
   frm_magasin.release;
end;

procedure Tfrm_param.SpeedButton8Click(Sender: TObject);
var
   frm_poste: Tfrm_poste;
begin
   application.createform(Tfrm_poste, frm_poste);
   frm_poste.ed_Nom.text := '';
   repeat
      if frm_poste.ShowModal = MrOk then
      begin
         MemD_Postes.first;
         while not MemD_Postes.eof do
         begin
            if (MemD_PostesPOS_NOM.AsString = frm_poste.ed_Nom.text) and
               (MemD_PostesPOS_MAGID.AsInteger = Integer(LB_NomMag.Items.Objects[LB_NomMag.ItemIndex])) then
            begin
               Application.messagebox('Un poste de ce nom existe déjà', ' Erreur', Mb_OK);
               BREAK;
            end;
            MemD_Postes.next;
         end;
         if (MemD_PostesPOS_NOM.AsString <> frm_poste.ed_Nom.text) or
            (MemD_PostesPOS_MAGID.AsInteger <> Integer(LB_NomMag.Items.Objects[LB_NomMag.ItemIndex])) then
         begin
            MemD_Postes.insert;
            MemD_PostesStatut.AsInteger := 1;
            MemD_PostesPOS_ID.AsInteger := GenId; inc(GenId);
            MemD_PostesPOS_NOM.AsString := frm_poste.ed_Nom.text;
            MemD_PostesPOS_MAGID.AsInteger := Integer(LB_NomMag.Items.Objects[LB_NomMag.ItemIndex]);
            MemD_Postes.post;
            Lb_Postes.items.AddObject(MemD_PostesPOS_NOM.AsString, pointer(MemD_PostesPOS_ID.AsInteger));
            BREAK;
         end;
      end
      else BREAK;
   until false;
   frm_poste.release;
end;

procedure Tfrm_param.SpeedButton9Click(Sender: TObject);
begin
   if application.messagebox('Supprimer le poste', 'ATTENTION', Mb_YESNO or MB_DEFBUTTON2) = MrYes then
   begin
      MemD_Postes.First;
      while not MemD_Postes.eof do
      begin
         if MemD_PostesPOS_ID.AsInteger = Integer(lb_postes.items.Objects[lb_postes.itemindex]) then
            BREAK;
         MemD_Postes.Next;
      end;
      if MemD_Postesstatut.AsInteger = 1 then
         MemD_Postes.Delete
      else
      begin
         MemD_Postes.edit;
         MemD_PostesStatut.AsInteger := -1;
         MemD_Postes.Post;
      end;
      lb_postes.items.delete(lb_postes.itemindex);
   end;
end;

procedure Tfrm_param.SpeedButton12Click(Sender: TObject);
var
   frm_poste: Tfrm_poste;
   i: integer;
begin
   MemD_Postes.First;
   while not MemD_Postes.eof do
   begin
      if MemD_PostesPOS_ID.AsInteger = Integer(lb_postes.items.Objects[lb_postes.itemindex]) then
         BREAK;
      MemD_Postes.Next;
   end;
   application.createform(Tfrm_poste, frm_poste);
   frm_poste.ed_Nom.text := MemD_PostesPOS_NOM.AsString;
   if frm_poste.ShowModal = MrOk then
   begin
      if (MemD_PostesPOS_NOM.AsString <> frm_poste.ed_Nom.text) then
      begin
         MemD_Postes.edit;
         if MemD_PostesStatut.AsInteger <> 1 then
            MemD_PostesStatut.AsInteger := 2;
         MemD_PostesPOS_NOM.AsString := frm_poste.ed_Nom.text;
         MemD_Postes.post;
         i := lb_postes.itemindex;
         Lb_Postes.items[lb_postes.itemindex] := MemD_PostesPOS_NOM.AsString;
         lb_postes.itemindex := i;
      end;
   end;
   frm_poste.release;
end;

procedure Tfrm_param.BitBtn1Click(Sender: TObject);
var
   req: string;
   s: string;
   id: string;
   adrid: string;
   tc: tconnexion;
begin
 //
 //
 // Gestion MemD_Bases
   Enabled := False;
   try
      MemD_Bases.First;
      req := URL + 'Qry?';
      req := req + 'BASE=' + LaDatabase + '&';
      while not MemD_Bases.Eof do
      begin
        {
         1 --> création
         2 --> Modification
        -1 --> Suppression
        {}
         if MemD_Basesstatut.AsInteger = 1 then // Création
         begin
            s := req + 'QRY=select ID from PR_NEWK(''GENBASES'')';
            s := traitechaine(s);
            Http.oldGetWaitTimeOut(s, 30000);
            s := Http.AsString(s);
            id := ValueTag(s, 'ID');
            s := req + 'SPE=EXEC&QRY=Insert Into GENBASES (BAS_ID, BAS_NOM, BAS_IDENT, BAS_JETON,' +
               'BAS_PLAGE, BAS_SENDER, BAS_GUID, BAS_CENTRALE, BAS_NOMPOURNOUS) VALUES (' +
               ID + ',' + Quotedstr(MemD_BasesBAS_NOM.AsString) + ',' + Quotedstr(MemD_BasesBAS_IDENT.AsString) + ',' +
               Quotedstr(MemD_BasesBAS_JETON.AsString) + ',' + Quotedstr(MemD_BasesBAS_PLAGE.AsString) + ',' +
               Quotedstr(MemD_BasesBAS_SENDER.AsString) + ',' + Quotedstr(MemD_BasesBAS_GUID.AsString) + ',' +
               Quotedstr(MemD_BasesBAS_CENTRALE.AsString) + ',' + Quotedstr(MemD_BasesBAS_NOMPOURNOUS.AsString) + ')';
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);
            s := req + 'SPE=EXEC&QRY=Execute procedure PR_INITBASE(' + ID + ',' +
               QuotedStr(clt_machine) + ',' + QuotedStr(EAI) + ')';
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);

            tc := tconnexion.Create;
            tc.insert('INSERT INTO clients (' +
               'site,nom,version,' +
               'nompournous,basepantin,clt_machine,' +
               'clt_centrale,clt_GUID)' +
               ' VALUES (' +
               '"' + LeSite + '","' + MemD_BasesBAS_NOM.AsString + '",' + IdVersion + ',' +
               '"' + MemD_BasesBAS_NOMPOURNOUS.AsString + '",0,"' + LaMachine + '",' +
               '"' + MemD_BasesBAS_CENTRALE.AsString + '","' + MemD_BasesBAS_GUID.AsString + '")');
            tc.free;

         end
         else if MemD_Basesstatut.AsInteger = 2 then
         begin
            s := req + 'SPE=EXEC&QRY=UPDATE K SET K_VERSION=GEN_ID(GENERAL_ID,1) ' +
               'Where K_ID=' + MemD_BasesBAS_ID.AsString;
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);
            s := req + 'SPE=EXEC&QRY=Update GENBASES Set ' +
               'BAS_NOM=' + Quotedstr(MemD_BasesBAS_NOM.AsString) +
               ', BAS_IDENT=' + Quotedstr(MemD_BasesBAS_IDENT.AsString) +
               ', BAS_JETON=' + MemD_BasesBAS_JETON.AsString +
               ', BAS_PLAGE=' + Quotedstr(MemD_BasesBAS_PLAGE.AsString) +
               ', BAS_SENDER=' + Quotedstr(MemD_BasesBAS_SENDER.AsString) +
               ', BAS_GUID=' + Quotedstr(MemD_BasesBAS_GUID.AsString) +
               ', BAS_CENTRALE=' + Quotedstr(MemD_BasesBAS_CENTRALE.AsString) +
               ', BAS_NOMPOURNOUS=' + Quotedstr(MemD_BasesBAS_NOMPOURNOUS.AsString) +
               '  WHERE BAS_ID=' + MemD_BasesBAS_ID.AsString;
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);
         end
         else if MemD_Basesstatut.AsInteger = -1 then
         begin
            s := req + 'SPE=EXEC&QRY=UPDATE K SET K_ENABLED=0, K_VERSION=GEN_ID(GENERAL_ID,1) ' +
               '  Where K_ID=' + MemD_BasesBAS_ID.AsString;
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);
         end;
         MemD_Bases.next;
      end;
      MemD_Soc.first;
      while not MemD_Soc.eof do
      begin
         if MemD_Socstatut.AsInteger = 1 then // Création
         begin
            s := req + 'QRY=select ID from PR_NEWK(''GENSOCIETE'')';
            s := traitechaine(s);
            Http.oldGetWaitTimeOut(s, 30000);
            s := Http.AsString(s);
            id := ValueTag(s, 'ID');
            s := req + 'SPE=EXEC&QRY=' +
               'INSERT INTO GENSOCIETE (SOC_ID,SOC_NOM,SOC_CLOTURE,' +
               'SOC_SSID) VALUES (' +
               ID + ',' + QuotedStr(MemD_SocSOC_NOM.AsString) + ',' +
               QuotedStr(FormatDateTime('MM/DD/YYYY', MemD_SocSOC_CLOTURE.AsDateTime)) + ',0)';
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);
            MemD_Mag.First;
            while not MemD_Mag.Eof do
            begin
               if MemD_MagMAG_SOCID.AsInteger = MemD_SocSOC_ID.AsInteger then
               begin
                  MemD_Mag.Edit;
                  MemD_MagMAG_SOCID.AsString := ID;
                  MemD_Mag.Post;
               end;
               MemD_Mag.next;
            end;
         end
         else if MemD_Socstatut.AsInteger = 2 then // Modification
         begin
            s := req + 'SPE=EXEC&QRY=UPDATE K SET K_VERSION=GEN_ID(GENERAL_ID,1) ' +
               '  Where K_ID=' + MemD_SocSOC_ID.AsString;
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);

            s := req + 'SPE=EXEC&QRY=' +
               'UPDATE GENSOCIETE SET SOC_NOM=' + QuotedStr(MemD_SocSOC_NOM.AsString) +
               ', SOC_CLOTURE=' + QuotedStr(FormatDateTime('MM/DD/YYYY', MemD_SocSOC_CLOTURE.AsDateTime)) +
               '  Where SOC_ID=' + MemD_SocSOC_ID.AsString;
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);
         end
         else if MemD_Socstatut.AsInteger = -1 then // Suppression
         begin
            s := req + 'SPE=EXEC&QRY=UPDATE K SET K_ENABLED=0, K_VERSION=GEN_ID(GENERAL_ID,1) ' +
               '  Where K_ID=' + MemD_SocSOC_ID.AsString;
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);
         end;
         MemD_Soc.Next;
      end;
      MemD_Mag.First;
      while not MemD_Mag.EOF do
      begin
         if MemD_Magstatut.AsInteger = 1 then // Création
         begin
            s := req + 'QRY=select ID from PR_NEWK(''GENADRESSE'')';
            s := traitechaine(s);
            Http.oldGetWaitTimeOut(s, 30000);
            s := Http.AsString(s);
            adrid := ValueTag(s, 'ID');
            s := req + 'SPE=EXEC&QRY=' +
               'INSERT INTO GENADRESSE (ADR_ID, ADR_VILID) VALUES (' + AdrID + ',0)';
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);
            s := req + 'QRY=select ID from PR_NEWK(''GENMAGASIN'')';
            s := traitechaine(s);
            Http.oldGetWaitTimeOut(s, 30000);
            s := Http.AsString(s);
            id := ValueTag(s, 'ID');
            s := req + 'SPE=EXEC&QRY=' +
               'INSERT INTO GENMAGASIN (MAG_ID, MAG_IDENT, MAG_NOM,' +
               'MAG_SOCID, MAG_ADRID, MAG_TVTID,' +
               'MAG_IDENTCOURT, MAG_MTAID, MAG_ENSEIGNE) VALUES (' +
               ID + ',' + QuotedStr(MemD_MagMAG_IDENT.AsString) + ',' + QuotedStr(MemD_MagMAG_NOM.AsString) + ',' +
               MemD_MagMAG_SOCID.AsString + ',' + adrid + ',0,' +
               QuotedStr(MemD_MagMAG_IDENTCOURT.AsString) + ',0,'+QuotedStr(MemD_MagMAG_NOM.AsString)+')';
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);
            s := req + 'SPE=EXEC&QRY=' +
               'EXECUTE PROCEDURE PR_INTITIALISEMAG (' + ID + ')';
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);
            MemD_Postes.first;
            while not MemD_Postes.Eof do
            begin
               if MemD_PostesPOS_MAGID.AsInteger = MemD_MagMAG_ID.AsInteger then
               begin
                  MemD_Postes.Edit;
                  MemD_PostesPOS_MAGID.AsString := ID;
                  MemD_Postes.Post;
               end;
               MemD_Postes.Next;
            end;
         end
         else if MemD_Magstatut.AsInteger = 2 then // Modif
         begin
            s := req + 'SPE=EXEC&QRY=UPDATE K SET K_VERSION=GEN_ID(GENERAL_ID,1) ' +
               '  Where K_ID=' + MemD_MagMAG_ID.AsString;
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);
            s := req + 'SPE=EXEC&QRY=' +
               'UPDATE GENMAGASIN SET ' +
               ' MAG_IDENT=' + QuotedStr(MemD_MagMAG_IDENT.AsString) + ', ' +
               ' MAG_NOM=' + QuotedStr(MemD_MagMAG_NOM.AsString) + ', ' +
               ' MAG_SOCID=' + MemD_MagMAG_SOCID.AsString + ', ' +
               ' MAG_IDENTCOURT=' + QuotedStr(MemD_MagMAG_IDENTCOURT.AsString) +
               '  WHERE MAG_ID=' + MemD_MagMAG_ID.AsString;
            Application.MessageBox(pchar(s), 'avant', mb_ok);
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);
            s := Http.AsString(traitechaine(s));
            Application.MessageBox(pchar(s), 'apres', mb_ok);
         end
         else if MemD_Magstatut.AsInteger = -1 then // Sup
         begin
            s := req + 'SPE=EXEC&QRY=UPDATE K SET K_ENABLED=0, K_VERSION=GEN_ID(GENERAL_ID,1) ' +
               '  Where K_ID=' + MemD_MagMAG_ID.AsString;
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);
         end;
         MemD_Mag.Next;
      end;
      MemD_Postes.first;
      while not MemD_Postes.eof do
      begin
         if MemD_PostesStatut.AsInteger = 1 then // création
         begin
            s := req + 'QRY=select ID from PR_NEWK(''GENPOSTE'')';
            s := traitechaine(s);
            Http.oldGetWaitTimeOut(s, 30000);
            s := Http.AsString(s);
            id := ValueTag(s, 'ID');
            s := req + 'SPE=EXEC&QRY=' +
               'INSERT INTO GENPOSTE (POS_ID, POS_NOM, POS_MAGID) VALUES (' +
               ID + ',' + QuotedStr(MemD_PostesPOS_NOM.AsString) + ',' + MemD_PostesPOS_MAGID.AsString + ')';
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);
         end
         else if MemD_PostesStatut.AsInteger = 2 then // Modif
         begin
            s := req + 'SPE=EXEC&QRY=UPDATE K SET K_VERSION=GEN_ID(GENERAL_ID,1) ' +
               '  Where K_ID=' + MemD_PostesPOS_ID.AsString;
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);
            s := req + 'SPE=EXEC&QRY=' +
               'UPDATE GENPOSTE SET ' +
               ' POS_NOM=' + QuotedStr(MemD_PostesPOS_NOM.AsString) + ', ' +
               ' POS_MAGID=' + MemD_PostesPOS_MAGID.AsString +
               ' WHERE POS_ID=' + MemD_PostesPOS_ID.AsString;
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);
         end
         else if MemD_PostesStatut.AsInteger = -1 then // Supp
         begin
            s := req + 'SPE=EXEC&QRY=UPDATE K SET K_ENABLED=0, K_VERSION=GEN_ID(GENERAL_ID,1) ' +
               '  Where K_ID=' + MemD_PostesPOS_ID.AsString;
            Http.oldGetWaitTimeOut(traitechaine(s), 30000);
         end;
         MemD_Postes.Next;
      end;
   finally
      Enabled := True;
   end;
end;

end.

