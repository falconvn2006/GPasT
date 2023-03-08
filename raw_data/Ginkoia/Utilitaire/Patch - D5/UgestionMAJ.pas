//$Log:
// 1    Utilitaires1.0         19/09/2016 10:08:39    Ludovic MASSE   
//$
//$NoKeywords$
//
unit UgestionMAJ;

interface

uses
   cregroupe_frm,
   UChxPlage,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   ComCtrls, StdCtrls, Db, dxmdaset, MemDataX, ExtCtrls, Spin, Menus, Grids,
   wwdbdatetimepicker, wwDBDateTimePickerRv;

type
   Tfrm_gestionMAJ = class(TForm)
      DataX: TDataBaseX;
      clients: TMemDataX;
      clientsid: TIntegerField;
      clientssite: TStringField;
      clientsnom: TStringField;
      clientsversion: TIntegerField;
      clientspatch: TIntegerField;
      clientsversion_max: TIntegerField;
      clientsspe_patch: TIntegerField;
      clientsspe_fait: TIntegerField;
      clientsbckok: TDateTimeField;
      clientsdernbck: TDateTimeField;
      clientsresbck: TStringField;
      clientsblockmaj: TIntegerField;
      Panel1: TPanel;
      pb: TProgressBar;
      Label1: TLabel;
      pc: TPageControl;
      Tab_client: TTabSheet;
      groupe: TMemDataX;
      groupegrp_id: TIntegerField;
      groupegrp_nom: TStringField;
      grpliaison: TMemDataX;
      grpliaisongpl_id: TIntegerField;
      grpliaisongpl_grpid: TIntegerField;
      grpliaisongpl_cltid: TIntegerField;
      grpliaisongpl_type: TIntegerField;
      versions: TMemDataX;
      versionsid: TIntegerField;
      versionsversion: TStringField;
      versionsnomversion: TStringField;
      versionsPatch: TIntegerField;
      pop1: TPopupMenu;
      Dtacherlegroupe1: TMenuItem;
      Tab_Parversion: TTabSheet;
      clientsnompournous: TStringField;
      histo: TMemDataX;
      histoid: TIntegerField;
      histoid_cli: TIntegerField;
      histoladate: TDateTimeField;
      histoaction: TIntegerField;
      histoactionstr: TStringField;
      histoval1: TIntegerField;
      histoval2: TIntegerField;
      histoval3: TIntegerField;
      histostr1: TStringField;
      histostr2: TStringField;
      histostr3: TStringField;
      Clt_amaj: TTabSheet;
      Label14: TLabel;
      Label15: TLabel;
      maj_ver: TEdit;
      Maj_vera: TEdit;
      tab_patch: TTabSheet;
      patch_ver: TEdit;
      patch_actu: TSpinEdit;
      patch_encours: TSpinEdit;
      patch_pass: TSpinEdit;
      Label16: TLabel;
      Label17: TLabel;
      Label18: TLabel;
      Label19: TLabel;
      Label20: TLabel;
      patch_devrais: TSpinEdit;
      Tab_version: TTabSheet;
      Label21: TLabel;
      Label22: TLabel;
      ver_inter: TEdit;
      ver_patch: TSpinEdit;
      Histoplt: TMemDataX;
      Histopltid: TIntegerField;
      Histopltid_cli: TIntegerField;
      Histopltladate: TDateTimeField;
      Histopltaction: TIntegerField;
      Histopltactionstr: TStringField;
      Histopltval1: TIntegerField;
      Histopltval2: TIntegerField;
      Histopltval3: TIntegerField;
      Histopltstr1: TStringField;
      Histopltstr2: TStringField;
      Histopltstr3: TStringField;
      Histopltfait: TIntegerField;
      tab_prob: TTabSheet;
      clientsdernbckok: TIntegerField;
      plage: TMemDataX;
      plageplg_id: TIntegerField;
      plageplg_datedeb: TDateTimeField;
      plageplg_datefin: TDateTimeField;
      plageplg_cltid: TIntegerField;
      plageplg_versionmax: TIntegerField;
      tab_echeance: TTabSheet;
      Panel2: TPanel;
      TTW_Clt: TTreeView;
      Panel3: TPanel;
      Button1: TButton;
      Button3: TButton;
      Button2: TButton;
      Panel4: TPanel;
      Ed_Ident: TEdit;
      Label13: TLabel;
      Label2: TLabel;
      ed_nom: TEdit;
      ed_site: TEdit;
      Label3: TLabel;
      Label4: TLabel;
      ed_ver: TEdit;
      SePver: TSpinEdit;
      Label5: TLabel;
      Label24: TLabel;
      ed_verprev: TEdit;
      Label25: TLabel;
      ed_dateprev: TEdit;
      Cb_ver: TComboBox;
      Label6: TLabel;
      Label23: TLabel;
      Label7: TLabel;
      se_ptc: TSpinEdit;
      Label8: TLabel;
      sp_ptp: TSpinEdit;
      cb_blk: TCheckBox;
      Button13: TButton;
      Label9: TLabel;
      Label10: TLabel;
      Ed_bckok: TEdit;
      Ed_derbck: TEdit;
      Label11: TLabel;
      Label12: TLabel;
      ed_result: TEdit;
      Button5: TButton;
      Button6: TButton;
      Panel5: TPanel;
      TTW_Version: TTreeView;
      Panel6: TPanel;
      sg: TStringGrid;
      Panel7: TPanel;
      Button4: TButton;
      Panel8: TPanel;
      Panel9: TPanel;
      Button7: TButton;
      TTW_AMAJ: TTreeView;
      Panel10: TPanel;
      Panel11: TPanel;
      Button8: TButton;
      TTW_Patch: TTreeView;
      Panel12: TPanel;
      TTW_Ver: TTreeView;
      Panel13: TPanel;
      Panel14: TPanel;
      TTW_Prob: TTreeView;
      Button11: TButton;
      Button12: TButton;
      Panel15: TPanel;
      TTW_ECH: TTreeView;
      TAB_MAJ: TTabSheet;
      mem_maj: TMemDataX;
      mem_majnomversion: TStringField;
      mem_majnompournous: TStringField;
      mem_majnom: TStringField;
      mem_majladate: TDateTimeField;
      Panel16: TPanel;
      depuis: TLabel;
      Chp_Datedeb: TwwDBDateTimePickerRv;
      Label26: TLabel;
      Chp_Datefin: TwwDBDateTimePickerRv;
      Button9: TButton;
      Panel17: TPanel;
      Panel18: TPanel;
      TTW_maj: TTreeView;
      Cb_PriseEnCompte: TCheckBox;
      clientsbasepantin: TIntegerField;
      clientsPriseencompte: TIntegerField;
      procedure clientsLoad(Sender: TObject; Max, Actu: Integer);
      procedure FormCreate(Sender: TObject);
      procedure FormPaint(Sender: TObject);
      procedure FormActivate(Sender: TObject);
      procedure Button1Click(Sender: TObject);
      procedure TTW_CltDragOver(Sender, Source: TObject; X, Y: Integer;
         State: TDragState; var Accept: Boolean);
      procedure TTW_CltDragDrop(Sender, Source: TObject; X, Y: Integer);
      procedure TTW_CltMouseDown(Sender: TObject; Button: TMouseButton;
         Shift: TShiftState; X, Y: Integer);
      procedure Button2Click(Sender: TObject);
      procedure Dtacherlegroupe1Click(Sender: TObject);
      procedure Button3Click(Sender: TObject);
      procedure pcChange(Sender: TObject);
      procedure Button4Click(Sender: TObject);
      procedure Button6Click(Sender: TObject);
      procedure Button5Click(Sender: TObject);
      procedure Cb_verChange(Sender: TObject);
      procedure sp_ptpChange(Sender: TObject);
      procedure TTW_CltChange(Sender: TObject; Node: TTreeNode);
      procedure cb_blkClick(Sender: TObject);
      procedure Button7Click(Sender: TObject);
      procedure TTW_AMAJChange(Sender: TObject; Node: TTreeNode);
      procedure Button8Click(Sender: TObject);
      procedure ttw_patchChange(Sender: TObject; Node: TTreeNode);
      procedure TTW_VerChange(Sender: TObject; Node: TTreeNode);
      procedure Button12Click(Sender: TObject);
      procedure Button11Click(Sender: TObject);
      procedure Button13Click(Sender: TObject);
      procedure Button9Click(Sender: TObject);
      procedure Cb_PriseEnCompteClick(Sender: TObject);
   private
    { Déclarations privées }
      first: boolean;
      LastTTN: TTreeNode;
      procedure rempliTTW_ECH;
   public
    { Déclarations publiques }
   end;

var
   frm_gestionMAJ: Tfrm_gestionMAJ;

implementation

{$R *.DFM}

function trouvettn(ttn: ttreenode; valeur: string): Integer;
var
   i: integer;
begin
   result := -1;
   for i := 0 to ttn.Count - 1 do
      if ttn[i].Text = valeur then
      begin
         result := i;
         BREAK;
      end;
end;

procedure Tfrm_gestionMAJ.clientsLoad(Sender: TObject; Max, Actu: Integer);
begin
   pb.position := actu;
   pb.max := max;
   if actu = max then pb.position := 0
end;

procedure Tfrm_gestionMAJ.FormCreate(Sender: TObject);
begin
   first := true;
   pc.activepage := Tab_client;
end;

procedure Tfrm_gestionMAJ.FormPaint(Sender: TObject);
var
   ttn: TTreeNode;
   ttn2: TTreeNode;
   i: integer;
   j: integer;
   ok: boolean;
begin
   if first then
   begin
      first := false;
      update;
      plage.open;
      clients.open;
      groupe.open;
      grpliaison.open;
      groupe.first;
      versions.open;
      versions.first;
      while not versions.eof do
      begin
         Cb_ver.items.Add(versionsnomversion.asString);
         versions.next;
      end;

      TTW_clt.items.BeginUpdate;
      TTW_clt.FullExpand;
      pb.max := groupe.RecordCount;
      while not groupe.eof do
      begin
         pb.position := pb.position + 1;
         ttn := nil;
         for i := 0 to TTW_clt.items.count - 1 do
         begin
            if Integer(TTW_clt.items[i].Data) = groupegrp_id.AsInteger then
            begin
               ttn := TTW_clt.items[i];
               BREAK;
            end;
         end;
         if ttn = nil then
         begin
            i := groupegrp_id.AsInteger;
            ttn := TTW_clt.items.Addobject(nil, groupegrp_nom.AsString, pointer(i));
         end
         else ttn.Text := groupegrp_nom.AsString;

         // rechercher si le groupe appartient à un méta groupe
         if grpliaison.trouve(grpliaisongpl_cltid, groupegrp_id.AsString) then
         begin
            repeat
               if grpliaisongpl_type.AsInteger = 0 then
               begin
                  // appartient à un méta groupe recherche si le groupe père existe
                  ttn2 := nil;
                  for i := 0 to TTW_clt.items.count - 1 do
                  begin
                     if Integer(TTW_clt.items[i].Data) = grpliaisongpl_grpid.AsInteger then
                     begin
                        ttn2 := TTW_clt.items[i];
                        BREAK;
                     end;
                  end;
                  if ttn2 = nil then
                  begin
                     // on pret cré le groupe
                     i := grpliaisongpl_grpid.AsInteger;
                     ttn2 := TTW_clt.items.Addobject(nil, '', pointer(i));
                  end;
                  ttn.MoveTo(ttn2, naAddChild);
                  // ne peux pas appartenir a deux méta groupe
                  BREAK;
               end;
            until not grpliaison.trouveSuivant(grpliaisongpl_cltid, groupegrp_id.AsString);
         end;
         groupe.next;
      end;

      // on ajoute les clients au noeud
      clients.first;
      pb.position := 0;
      pb.Max := clients.RecordCount;
      while not clients.Eof do
      begin
         pb.position := pb.position + 1;
         // on recherche les liaison parent
         ok := false;
         if grpliaison.trouve(grpliaisongpl_cltid, clientsid.AsString) then
         begin
            repeat
               if grpliaisongpl_type.AsInteger = 1 then
               begin
                  ok := true;
                 // on cherche le nodes
                  for i := 0 to TTW_clt.items.count - 1 do
                  begin
                     if Integer(TTW_clt.items[i].Data) = grpliaisongpl_grpid.AsInteger then
                     begin
                        j := -clientsid.AsInteger;
                        TTW_clt.items.AddChildObject(TTW_clt.items[i], clientsnom.AsString, pointer(j));
                        if clientsnompournous.AsString = '' then
                        begin
                           clients.edit;
                           clientsnompournous.AsString := TTW_clt.items[i].Text;
                           clients.Post;
                        end;
                     end;
                  end;
               end;
            until not grpliaison.trouvesuivant(grpliaisongpl_cltid, clientsid.AsString);
         end;
         if not ok then
         begin
            // ajout dans le groupe, pas de groupe
            i := -clientsid.AsInteger;
            TTW_clt.items.AddChildObject(TTW_clt.items[0], clientsnom.AsString, pointer(i));
         end;
         if clientsversion.AsInteger = 0 then
         begin
            histo.ParamByName('idcli').AsInteger := clientsid.AsInteger;
            histo.open;
            if histo.trouve(histoaction, '1') then
            begin
               if versions.trouve(versionsversion, histostr1.AsString) then
               begin
                  clients.edit;
                  clientsversion.AsInteger := versionsid.AsInteger;
                  clients.post;
               end;
            end;
            histo.close;
         end;
         clients.next;
      end;
      pb.position := 0;
      clients.validation;
      TTW_clt.AlphaSort;
      TTW_clt.FullCollapse;
      TTW_clt.items.EndUpdate;
   end;
end;

procedure Tfrm_gestionMAJ.FormActivate(Sender: TObject);
begin
   if TTW_clt.Items.Count = 0 then
   begin
      TTW_clt.Items.beginUpdate;
      TTW_clt.Items.AddObject(nil, '¤  sans groupe', pointer(0));
      TTW_clt.Items.EndUpdate;
   end;
end;

procedure Tfrm_gestionMAJ.Button1Click(Sender: TObject);
var
   frm_crergroupe: Tfrm_crergroupe;
   i: integer;
begin
   application.createform(Tfrm_crergroupe, frm_crergroupe);
   try
      if frm_crergroupe.showmodal = MrOk then
      begin
         groupe.insert;
         groupegrp_nom.AsString := frm_crergroupe.edit1.text;
         groupe.post;
         groupe.validation;
         groupe.close;
         groupe.open;
         groupe.trouve(groupegrp_nom, frm_crergroupe.edit1.text);
         i := groupegrp_id.AsInteger;
         ttw_clt.items.AddObject(nil, frm_crergroupe.edit1.text, pointer(i));
         ttw_clt.AlphaSort;
      end;
   finally
      frm_crergroupe.release;
   end;
end;

procedure Tfrm_gestionMAJ.TTW_CltDragOver(Sender, Source: TObject; X,
   Y: Integer; State: TDragState; var Accept: Boolean);
begin
   Accept := false;
   if (LastTTN <> nil) and (sender = TTW_CLT) then
   begin
      if Integer(TTW_CLT.GetNodeAt(X, Y).Data) > 0 then
         Accept := true;
   end;
end;

procedure Tfrm_gestionMAJ.TTW_CltDragDrop(Sender, Source: TObject; X,
   Y: Integer);
var
   ttn2: ttreenode;
   ok: boolean;
begin
  // recherche si une liaison existe
   ok := false;
   ttn2 := TTW_CLT.GetNodeAt(X, Y);
   if LastTTN = ttn2 then EXIT;
   if grpliaison.trouve(grpliaisongpl_cltid, Inttostr(Integer(LastTTN.Data))) then
   begin
      repeat
         if grpliaisongpl_type.AsInteger = 0 then
         begin
            ok := true;
            BREAK;
         end;
      until not grpliaison.trouveSuivant(grpliaisongpl_cltid, Inttostr(Integer(LastTTN.Data)));
   end;
   if not ok then
   begin
      grpliaison.Insert;
      grpliaisongpl_grpid.AsInteger := integer(ttn2.Data);
      grpliaisongpl_cltid.AsInteger := integer(LastTTN.Data);
      grpliaisongpl_type.AsInteger := 0;
      grpliaison.Post;
   end
   else
   begin
      if grpliaisongpl_grpid.AsInteger = integer(ttn2.Data) then
         EXIT;
      grpliaison.edit;
      grpliaisongpl_grpid.AsInteger := integer(ttn2.Data);
      grpliaison.Post;
   end;
   button2.enabled := true;
   button3.enabled := true;
   LastTTN.MoveTo(ttn2, naaddchild);
   ttn2.AlphaSort;
end;

procedure Tfrm_gestionMAJ.TTW_CltMouseDown(Sender: TObject;
   Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   LastTTN := TTW_CLT.GetNodeAt(X, Y);
end;

procedure Tfrm_gestionMAJ.Button2Click(Sender: TObject);
begin
   grpliaison.validation;
   button2.enabled := false;
   button3.enabled := false;
end;

procedure Tfrm_gestionMAJ.Dtacherlegroupe1Click(Sender: TObject);
var
   ok: boolean;
begin
   if integer(TTW_Clt.Selected.Data) > 0 then
   begin
      ok := false;
      if grpliaison.trouve(grpliaisongpl_cltid, Inttostr(Integer(TTW_Clt.Selected.Data))) then
      begin
         repeat
            if grpliaisongpl_type.AsInteger = 0 then
            begin
               ok := true;
               BREAK;
            end;
         until not grpliaison.trouveSuivant(grpliaisongpl_cltid, Inttostr(Integer(TTW_Clt.Selected.Data)));
      end;
      if ok then
      begin
         grpliaison.delete;
         TTW_Clt.Selected.MoveTo(TTW_Clt.items[0], naadd);
         TTW_Clt.AlphaSort;
         Button2.enabled := true;
         Button3.enabled := true;
      end;
   end;
end;

procedure Tfrm_gestionMAJ.Button3Click(Sender: TObject);
begin
   Button2.enabled := false;
   Button3.enabled := false;
   grpliaison.close;
   grpliaison.open;
end;

procedure Tfrm_gestionMAJ.pcChange(Sender: TObject);
var
   i: integer;
   j: integer;
   ttn: TTreeNode;
   ttn2: TTreeNode;
begin
   if pc.ActivePage = Tab_Parversion then
   begin
      if TTW_Version.Items.Count = 0 then
      begin
         versions.First;
         pb.Max := versions.recordcount + 1;
         ttn := TTW_Version.Items.AddObject(nil, ' Version non référencée ', pointer(0));
         pb.position := 1;
         if clients.trouve(clientsversion, '0') then
         begin
            repeat
               j := clientsid.AsInteger;
               if clientsnompournous.AsString <> '' then
               begin
                  if trouvettn(ttn, clientsnompournous.AsString) > -1 then
                     ttn2 := ttn[trouvettn(ttn, clientsnompournous.AsString)]
                  else
                     ttn2 := TTW_Version.Items.AddChildObject(ttn, clientsnompournous.AsString, pointer(-1));
                  TTW_Version.Items.AddChildObject(ttn2, clientsnom.AsString, pointer(j));
               end
               else
                  TTW_Version.Items.AddChildObject(ttn, clientsnom.AsString, pointer(j));
            until not clients.trouveSuivant(clientsversion, '0');
         end;
         while not versions.eof do
         begin
            pb.position := pb.position + 1;
            i := versionsid.AsInteger;
            ttn := TTW_Version.Items.AddObject(nil, versionsnomversion.AsString, pointer(i));
            if clients.trouve(clientsversion, Inttostr(i)) then
            begin
               repeat
                  j := clientsid.AsInteger;
                  if clientsnompournous.AsString <> '' then
                  begin
                     if trouvettn(ttn, clientsnompournous.AsString) > -1 then
                        ttn2 := ttn[trouvettn(ttn, clientsnompournous.AsString)]
                     else
                        ttn2 := TTW_Version.Items.AddChildObject(ttn, clientsnompournous.AsString, pointer(-1));
                     TTW_Version.Items.AddChildObject(ttn2, clientsnom.AsString, pointer(j));
                  end
                  else
                     TTW_Version.Items.AddChildObject(ttn, clientsnom.AsString, pointer(j));
               until not clients.trouveSuivant(clientsversion, Inttostr(i));
            end;
            versions.Next;
         end;
         TTW_Version.AlphaSort;
         pb.position := 0;
      end;
   end
   else if pc.ActivePage = Clt_amaj then
   begin
      if TTW_AMAJ.Items.Count = 0 then
      begin
         pb.max := clients.RecordCount;
         clients.first;
         while not clients.eof do
         begin
            pb.position := pb.position + 1;
            if (clientsPriseencompte.AsInteger = 0) and
               (clientsversion_max.AsInteger <> 0) and
               (clientsversion.AsInteger <> clientsversion_max.AsInteger) then
            begin
               ttn := nil;
               for i := 0 to TTW_AMAJ.Items.Count - 1 do
               begin
                  if TTW_AMAJ.Items.Item[i].Text = clientsnompournous.AsString then
                  begin
                     ttn := TTW_AMAJ.Items.Item[i];
                     BREAK;
                  end;
               end;
               if ttn = nil then
               begin
                  ttn := TTW_AMAJ.Items.AddObject(nil, clientsnompournous.AsString, pointer(-1));
               end;
               j := clientsId.asinteger;
               TTW_AMAJ.Items.AddChildObject(ttn, clientsnom.AsString, pointer(j));
            end;
            clients.next;
         end;
         TTW_AMAJ.AlphaSort;
         pb.position := 0;
      end;
   end
   else if pc.ActivePage = tab_patch then
   begin
      if ttw_patch.Items.Count = 0 then
      begin
         pb.max := clients.RecordCount;
         clients.first;
         while not clients.eof do
         begin
            pb.position := pb.position + 1;
            if versions.trouve(versionsid, clientsversion.AsString) then
            begin
               if (clientspatch.AsInteger <> versionsPatch.AsInteger) or
                  (clientsspe_patch.AsInteger <> clientsspe_fait.AsInteger) then
               begin
                  ttn := nil;
                  for i := 0 to ttw_patch.Items.Count - 1 do
                  begin
                     if ttw_patch.Items[i].Text = clientsnompournous.AsString then
                     begin
                        ttn := ttw_patch.Items[i];
                        BREAK;
                     end;
                  end;
                  if ttn = nil then
                  begin
                     ttn := ttw_patch.Items.AddObject(nil, clientsnompournous.AsString, pointer(-1));
                  end;
                  j := clientsId.asinteger;
                  ttw_patch.Items.AddChildObject(ttn, clientsnom.AsString, pointer(j));
               end;
            end;
            clients.next;
         end;
         ttw_patch.AlphaSort;
         pb.position := 0;
      end;
   end
   else if pc.ActivePage = Tab_version then
   begin
      if ttw_ver.Items.Count = 0 then
      begin
         versions.First;
         while not versions.eof do
         begin
            j := versionsid.asinteger;
            ttw_ver.Items.AddObject(nil, versionsnomversion.AsString, pointer(j));
            versions.next;
         end;
      end;
   end
   else if pc.ActivePage = tab_prob then
   begin
      if TTW_Prob.Items.Count = 0 then
      begin
         Histoplt.open;
         if Histoplt.RecordCount = 0 then
            TTW_Prob.Items.AddObject(nil, 'PAS DE PROBLEME', pointer(-1))
         else
         begin
            Histoplt.first;
            while not Histoplt.EOF do
            begin
               if clients.trouve(clientsid, Histopltid_cli.AsString) then
               begin
                  j := Histopltid.asinteger;
                  ttn := TTW_Prob.Items.AddObject(nil, clientsnompournous.AsString, pointer(j));
                  TTW_Prob.Items.AddChildObject(ttn, Histopltladate.AsString, pointer(j));
                  case Histopltaction.Asinteger of
                     5: TTW_Prob.Items.AddChildObject(ttn, 'script planté', pointer(j));
                     6: TTW_Prob.Items.AddChildObject(ttn, 'Maj fichier planté', pointer(j));
                     8: TTW_Prob.Items.AddChildObject(ttn, 'Scrip Perso planté', pointer(j));
                     10: TTW_Prob.Items.AddChildObject(ttn, 'maj planté', pointer(j));
                  end;
                  TTW_Prob.Items.AddChildObject(ttn, Histopltactionstr.AsString, pointer(j));
                  TTW_Prob.Items.AddChildObject(ttn, Histopltstr1.AsString, pointer(j));
               end;
               Histoplt.next;
            end;
         end;
      end;
   end
   else if pc.ActivePage = tab_echeance then
   begin
      rempliTTW_ECH;
   end
end;

procedure Tfrm_gestionMAJ.Button4Click(Sender: TObject);
var
   i: integer;
begin
   if TTW_Version.selected <> nil then
   begin
      histo.parambyname('idcli').asinteger := integer(TTW_Version.selected.data);
      histo.Open;
      Sg.cells[0, 0] := 'Action'; Sg.cells[1, 0] := 'resultat'; Sg.cells[2, 0] := 'Commentaire';
      if histo.recordcount = 0 then
      begin
         sg.RowCount := 2;
         Sg.cells[0, 1] := ''; Sg.cells[1, 1] := ''; Sg.cells[2, 1] := '';
      end
      else
      begin
         sg.RowCount := histo.recordcount + 1;
         histo.first; i := 1;
         while not histo.eof do
         begin
            Sg.cells[0, i] := histoladate.AsString;
            if (histoaction.AsInteger = 3) and (trim(histostr1.AsString) = '') then
            begin
               Sg.cells[1, i] := 'récupération fichier';
               Sg.cells[2, i] := histoactionstr.AsString;
            end
            else
            begin
               Sg.cells[1, i] := histoactionstr.AsString;
               Sg.cells[2, i] := histostr1.AsString;
            end;
            inc(i);
            histo.next;
         end;
      end;
      histo.close;
   end;
end;

procedure Tfrm_gestionMAJ.Button6Click(Sender: TObject);
begin
   clients.validation;
   plage.Validation;
   button5.enabled := false;
   button6.enabled := false;
   TTW_CltChange(nil, TTW_Clt.selected);
end;

procedure Tfrm_gestionMAJ.Button5Click(Sender: TObject);
begin
   clients.close;
   clients.open;
   plage.Close;
   plage.Open;
   button5.enabled := false;
   button6.enabled := false;
   TTW_CltChange(nil, TTW_Clt.selected);
end;

procedure Tfrm_gestionMAJ.Cb_verChange(Sender: TObject);

   procedure traite(ttn: ttreenode; ver: integer);
   var
      j, i: integer;
   begin
      for i := 0 to ttn.Count - 1 do
      begin
         if (ttn[i].HasChildren) then
            traite(ttn[i], ver)
         else
         begin
            j := -integer(ttn[i].Data);
            if Clients.trouve(clientsid, Inttostr(j)) then
            begin
               clients.edit;
               clientsversion_max.AsInteger := versionsid.AsInteger;
               clients.post;
               button5.enabled := true;
               button6.enabled := true;
            end;
         end;
      end;
   end;

begin
   if ed_site.text <> '' then
   begin
      if versions.trouve(versionsnomversion, Cb_ver.text) then
      begin
         if clientsversion_max.AsInteger <> versionsid.AsInteger then
         begin
            clients.edit;
            clientsversion_max.AsInteger := versionsid.AsInteger;
            clients.post;
            button5.enabled := true;
            button6.enabled := true;
         end;
      end;
   end
   else
   begin
      if TTW_Clt.Selected <> nil then
      begin
         if versions.trouve(versionsnomversion, Cb_ver.text) then
         begin
            if application.messageBox('passer le groupe complet dans la version ?', ' Attention', Mb_yesno) = mryes then
            begin
               traite(TTW_Clt.Selected, versionsid.AsInteger);
            end;
         end;
      end;
   end;
end;

procedure Tfrm_gestionMAJ.sp_ptpChange(Sender: TObject);
var
   i: integer;
begin
   if ed_site.text <> '' then
   begin
      i := sp_ptp.Value;
      if clientsspe_patch.AsInteger <> i then
      begin
         clients.edit;
         clientsspe_patch.AsInteger := i;
         clients.post;
         button5.enabled := true;
         button6.enabled := true;
      end;
   end;
end;

procedure Tfrm_gestionMAJ.TTW_CltChange(Sender: TObject; Node: TTreeNode);
var
   i: integer;
begin
   if integer(node.Data) < 0 then
   begin
      i := -integer(node.Data);
      clients.trouve(clientsid, Inttostr(i));
      ed_nom.text := clientsnom.AsString;
      ed_site.text := clientssite.AsString;
      Ed_Ident.text := clientsnompournous.AsString;
      if clientsversion.asinteger <> 0 then
      begin
         versions.trouve(versionsid, Inttostr(clientsversion.asinteger));
         ed_ver.text := versionsnomversion.AsString;
         SePver.Value := versionsPatch.AsInteger;
         if versions.trouve(versionsid, Inttostr(clientsversion_max.asinteger)) then
         begin
            cb_ver.ItemIndex := cb_ver.items.IndexOf(versionsnomversion.AsString);
         end
         else
            cb_ver.ItemIndex := -1;
      end
      else
      begin
         ed_ver.text := ' pas de version valide ';
         SePver.Value := 0;
         cb_ver.itemindex := -1;
      end;
      Cb_PriseEnCompte.Checked := clientsPriseencompte.AsInteger = 1;
      se_ptc.value := clientsspe_fait.Asinteger;
      sp_ptp.value := clientsspe_patch.Asinteger;
      Ed_bckok.text := clientsbckok.AsString;
      Ed_derbck.text := clientsdernbck.AsString;
      ed_result.text := clientsresbck.AsString;
      cb_blk.checked := clientsblockmaj.AsInteger = 1;
      if not plage.trouve(plageplg_cltid, Inttostr(i)) then
      begin
         ed_verprev.text := '';
         ed_dateprev.text := '';
      end
      else
      begin
         if plageplg_datefin.AsDateTime > Now then
         begin
            ed_dateprev.text := plageplg_datedeb.AsString;
            versions.trouve(versionsid, plageplg_versionmax.AsString);
            ed_verprev.text := versionsnomversion.AsString;
         end
         else
         begin
            ed_verprev.text := '';
            ed_dateprev.text := '';
         end;
      end;
   end
   else
   begin
      ed_nom.text := '';
      ed_site.text := '';
      Ed_Ident.text := '';
      ed_ver.text := '';
      SePver.Value := 0;
      cb_ver.itemindex := -1;
      se_ptc.value := 0;
      sp_ptp.value := 0;
      Ed_bckok.text := '';
      Ed_derbck.text := '';
      ed_result.text := '';
      cb_blk.checked := false;
      ed_verprev.text := '';
      ed_dateprev.text := '';
   end;
end;

procedure Tfrm_gestionMAJ.cb_blkClick(Sender: TObject);
begin
   if ed_site.text <> '' then
   begin
      clients.edit;
      if cb_blk.checked then
         clientsblockmaj.AsInteger := 1
      else
         clientsblockmaj.AsInteger := 0;
      clients.post;
      button5.enabled := true;
      button6.enabled := true;
   end;
end;

procedure Tfrm_gestionMAJ.Button7Click(Sender: TObject);
begin
   TTW_AMAJ.Items.Clear;
   pcChange(nil);
end;

procedure Tfrm_gestionMAJ.TTW_AMAJChange(Sender: TObject; Node: TTreeNode);
begin
   maj_ver.text := '';
   Maj_vera.text := '';
   if integer(node.Data) > 0 then
   begin
      if clients.trouve(clientsid, inttostr(integer(node.Data))) then
      begin
         versions.trouve(versionsid, clientsversion.asstring);
         maj_ver.text := versionsnomversion.asstring;
         versions.trouve(versionsid, clientsversion_max.asstring);
         Maj_vera.text := versionsnomversion.asstring;
      end;
   end;
end;

procedure Tfrm_gestionMAJ.Button8Click(Sender: TObject);
begin
   TTW_Patch.Items.Clear;
   pcChange(nil);
end;

procedure Tfrm_gestionMAJ.ttw_patchChange(Sender: TObject;
   Node: TTreeNode);
begin
   patch_ver.text := '';
   patch_actu.Value := 0;
   patch_devrais.Value := 0;
   patch_encours.Value := 0;
   patch_pass.Value := 0;
   if integer(node.Data) > 0 then
   begin
      if clients.trouve(clientsid, inttostr(integer(node.Data))) then
      begin
         versions.trouve(versionsid, clientsversion.asstring);
         patch_ver.text := versionsnomversion.asstring;
         patch_actu.Value := clientspatch.asinteger;
         patch_devrais.Value := versionsPatch.asinteger;
         patch_encours.Value := clientsspe_patch.asinteger;
         patch_pass.Value := clientsspe_fait.asinteger;
      end;
   end;
end;

procedure Tfrm_gestionMAJ.TTW_VerChange(Sender: TObject; Node: TTreeNode);
begin
   if versions.trouve(versionsid, inttostr(integer(node.data))) then
   begin
      ver_inter.text := versionsversion.AsString;
      ver_patch.value := versionsPatch.AsInteger;
   end
   else
   begin
      ver_inter.text := '';
      ver_patch.value := 0;
   end;
end;

procedure Tfrm_gestionMAJ.Button12Click(Sender: TObject);
begin
   TTW_Prob.items.Clear;
   pcChange(nil);
end;

procedure Tfrm_gestionMAJ.Button11Click(Sender: TObject);
begin
   if (TTW_Prob.selected <> nil) and
      (Integer(TTW_Prob.Selected.data) > 0) then
   begin
      Histoplt.trouve(Histopltid, Inttostr(Integer(TTW_Prob.Selected.data)));
      Histoplt.Edit;
      Histopltfait.AsInteger := 1;
      Histoplt.Post;
      Histoplt.Validation;
      TTW_Prob.Items.Delete(TTW_Prob.Selected);
   end;
end;

procedure Tfrm_gestionMAJ.Button13Click(Sender: TObject);
var
   frm_chxplage: Tfrm_chxplage;
   id: integer;

   procedure traite(ttn: ttreenode; ver: integer);
   var
      j, i: integer;
   begin
      for i := 0 to ttn.Count - 1 do
      begin
         if (ttn[i].HasChildren) then
            traite(ttn[i], ver)
         else
         begin
            j := -integer(ttn[i].Data);
            if Clients.trouve(clientsid, Inttostr(j)) then
            begin
               if plage.trouve(plageplg_cltid, clientsid.AsString) then
               begin
                  plage.edit;
                  plageplg_datedeb.AsDateTime := frm_chxplage.Chp_Datedeb.Date;
                  plageplg_datefin.AsDateTime := frm_chxplage.Chp_Datefin.Date;
                  plageplg_versionmax.AsInteger := versionsid.AsInteger;
                  plage.post;
               end
               else
               begin
                  id := plage.NeedID;
                  plage.insert;
                  plageplg_id.AsInteger := Id;
                  plageplg_cltid.AsInteger := clientsid.AsInteger;
                  plageplg_datedeb.AsDateTime := frm_chxplage.Chp_Datedeb.Date;
                  plageplg_datefin.AsDateTime := frm_chxplage.Chp_Datefin.Date;
                  plageplg_versionmax.AsInteger := versionsid.AsInteger;
                  plage.post;
               end;
               button5.enabled := true;
               button6.enabled := true;
            end;
         end;
      end;
   end;

begin
   Application.createform(Tfrm_chxplage, frm_chxplage);
   try
      versions.first;
      while not versions.eof do
      begin
         frm_chxplage.Cb_Version.items.Add(versionsnomversion.asString);
         versions.next;
      end;
      if frm_chxplage.showmodal = MrOk then
      begin
         if versions.trouve(versionsnomversion, frm_chxplage.Cb_Version.text) then
         begin
            if ed_site.text <> '' then
            begin
               if plage.trouve(plageplg_cltid, clientsid.AsString) then
               begin
                  plage.edit;
                  plageplg_datedeb.AsDateTime := frm_chxplage.Chp_Datedeb.Date;
                  plageplg_datefin.AsDateTime := frm_chxplage.Chp_Datefin.Date;
                  plageplg_versionmax.AsInteger := versionsid.AsInteger;
                  plage.post;
               end
               else
               begin
                  id := plage.NeedID;
                  plage.insert;
                  plageplg_id.AsInteger := Id;
                  plageplg_cltid.AsInteger := clientsid.AsInteger;
                  plageplg_datedeb.AsDateTime := frm_chxplage.Chp_Datedeb.Date;
                  plageplg_datefin.AsDateTime := frm_chxplage.Chp_Datefin.Date;
                  plageplg_versionmax.AsInteger := versionsid.AsInteger;
                  plage.post;
               end;
               button5.enabled := true;
               button6.enabled := true;
            end
            else
            begin
               if TTW_Clt.Selected <> nil then
               begin
                  if application.messageBox('passer le groupe complet dans la version ?', ' Attention', Mb_yesno) = mryes then
                  begin
                     traite(TTW_Clt.Selected, versionsid.AsInteger);
                  end;
               end;
            end;
         end;
      end;
   finally
      frm_chxplage.release;
   end;
 //
end;

procedure Tfrm_gestionMAJ.rempliTTW_ECH;
var
   datedeb: Tdate;
   JJ, MM, AA: Word;
   Jour: Integer;
   Ladate,
      DateLund1: Tdate;
   LeJour,
      Sem: string;
   ttn2,
      ttn3,
      ttn: TTreeNode;
   i, j, k: integer;
   LaSem: Integer;
   clt: string;
   Tsl: TstringList;
   LastSem: Integer;
   S: string;
begin
   ttw_ech.Items.Clear;
   Plage.first;
   datedeb := Date + 1200;

   while not plage.eof do
   begin
      Clients.trouve(clientsid, plageplg_cltid.AsString);
      if clientsversion.AsInteger <> plageplg_versionmax.AsInteger then
      begin
         if plageplg_datedeb.AsDatetime < datedeb then
            datedeb := plageplg_datedeb.AsDatetime;
      end;
      plage.next;
   end;
   if datedeb < Date + 1200 then
   begin
      decodeDate(datedeb, AA, MM, JJ);
      // recherche du Lundi de la premiere semaine
      DateLund1 := encodeDate(AA, 1, 4);
      Jour := dayofweek(DateLund1);
      jour := jour - 2;
      if jour < 0 then jour := jour + 7;
      DateLund1 := DateLund1 - Jour;
      plage.First;
      LastSem := trunc(datedeb - DateLund1) div 7;
      while not plage.eof do
      begin
         Clients.trouve(clientsid, plageplg_cltid.AsString);
         versions.trouve(versionsid, plageplg_versionmax.AsString);
         if clientsversion.AsInteger <> plageplg_versionmax.AsInteger then
         begin
            LaSem := trunc(plageplg_datedeb.AsDatetime - DateLund1) div 7 + 1;
            if (LaSem) < 10 then
               Sem := 'Semaine 0' + Inttostr(LaSem)
            else
               Sem := 'Semaine ' + Inttostr(LaSem);
            ttn := nil;
            for i := 0 to TTW_ECH.Items.Count - 1 do
               if Sem = TTW_ECH.Items[i].Text then
               begin
                  ttn := TTW_ECH.Items[i];
                  BREAK;
               end;
            if ttn = nil then
            begin
               if LastSem <> -1 then
               begin
                  for i := LastSem + 1 to LaSem - 1 do
                  begin
                     if (i) < 10 then
                        S := 'Semaine 0' + Inttostr(i)
                     else
                        S := 'Semaine ' + Inttostr(i);
                     TTW_ECH.items.Addobject(nil, S, pointer(i));
                  end;
               end;
               ttn := TTW_ECH.items.Addobject(nil, Sem, pointer(LaSem));
               LastSem := LaSem;
            end;
            jour := DayOfWeek(plageplg_datedeb.AsDatetime);
            jour := jour - 2;
            if jour < 0 then jour := jour + 7;
            Ladate := plageplg_datedeb.AsDatetime;
            while Ladate <= plageplg_datefin.AsDatetime do
            begin
               if jour > 6 then
               begin
                  Inc(LaSem);
                  Dec(jour, 7);
                  if (LaSem) < 10 then
                     Sem := 'Semaine 0' + Inttostr(LaSem)
                  else
                     Sem := 'Semaine ' + Inttostr(LaSem);
                  ttn := nil;
                  for i := 0 to TTW_ECH.Items.Count - 1 do
                     if Sem = TTW_ECH.Items[i].Text then
                     begin
                        ttn := TTW_ECH.Items[i];
                        BREAK;
                     end;
                  if ttn = nil then
                  begin
                     ttn := TTW_ECH.items.Addobject(nil, Sem, pointer(LaSem));
                     LastSem := LaSem;
                  end;
               end;
               LeJour := '';
               case jour of
                  0: LeJour := '1-Lundi';
                  1: LeJour := '2-Mardi';
                  2: LeJour := '3-Mercredi';
                  3: LeJour := '4-Jeudi';
                  4: LeJour := '5-Vendredi';
                  5: LeJour := '6-Samedi';
                  6: LeJour := '7-Dimanche';
               end;
               ttn2 := nil;
               if ladate < Date then
                  LeJour := '******  ' + LeJour;
               for i := 0 to ttn.Count - 1 do
               begin
                  if ttn.item[i].Text = LeJour then
                  begin
                     ttn2 := ttn.item[i];
                     BREAK;
                  end;
               end;
               if ttn2 = nil then
               begin
                  ttn2 := TTW_ECH.items.AddChildobject(ttn, LeJour, pointer(-1));
               end;
               clt := clientsnompournous.AsString + ' -> ' + versionsnomversion.AsString;
               ttn3 := nil;
               for i := 0 to ttn2.Count - 1 do
               begin
                  if ttn2.item[i].Text = Clt then
                  begin
                     ttn3 := ttn2.item[i];
                     BREAK;
                  end;
               end;
               if ttn3 = nil then
                  ttn3 := TTW_ECH.items.AddChildobject(ttn2, clt, pointer(clientsid.AsInteger));

               TTW_ECH.items.AddChildobject(ttn3, clientssite.AsString + ' ' + clientsnom.AsString, pointer(-1));

               ladate := ladate + 1;
               Inc(jour);
            end;
         end;
         plage.next;
      end;

      ttn := TTW_ECH.Items[0];
      Tsl := TstringList.create;
      while ttn <> nil do
      begin
         tsl.clear;
         for j := 0 to ttn.count - 1 do
         begin
            ttn2 := ttn[j];
            for k := 0 to ttn2.count - 1 do
            begin
               ttn3 := ttn2[k];
               ttn3.text := ttn3.text + ' (' + Inttostr(ttn3.count) + ')';
               if tsl.indexof(Inttostr(Integer(ttn2[k].Data))) < 0 then
                  tsl.Add(Inttostr(Integer(ttn2[k].Data)))
            end;
            ttn2.text := ttn2.text + ' (' + Inttostr(ttn2.Count) + ')';
         end;
         if tsl.Count = 0 then
            ttn.text := ttn.text + ' ( VIDE )'
         else
         begin
            ttn.text := ttn.text + ' (' + Inttostr(tsl.Count) + ')';
            Ladate := (Integer(ttn.data) - 1) * 7 + DateLund1 + 6;
            if ladate < Date then
               ttn.text := ttn.text + ' ****** ';
         end;
         ttn := ttn.getNextSibling;
      end;
      tsl.free;
      TTW_ECH.AlphaSort;
   end;
end;

procedure Tfrm_gestionMAJ.Button9Click(Sender: TObject);
var
   i: integer;
   ttn: TTreeNode;
   ttn2: TTreeNode;
begin
   TTW_maj.Items.Clear;
   mem_maj.parambyname('datedeb').AsDate := Chp_Datedeb.Date;
   mem_maj.parambyname('datefin').AsDate := Chp_Datefin.Date;
   mem_maj.Open;
   while not mem_maj.eof do
   begin
      ttn := nil;
      for i := 0 to TTW_maj.Items.Count - 1 do
         if mem_majnompournous.AsString = TTW_maj.Items[i].Text then
         begin
            ttn := TTW_maj.Items[i];
            BREAK;
         end;
      if ttn = nil then
      begin
         ttn := TTW_maj.items.Addobject(nil, mem_majnompournous.AsString, pointer(-1));
      end;
      ttn2 := nil;
      for i := 0 to ttn.Count - 1 do
      begin
         if ttn[i].Text = mem_majnom.AsString then
         begin
            ttn2 := ttn[i];
            BREAK;
         end;
      end;
      if ttn2 = nil then
      begin
         ttn2 := TTW_maj.items.AddChildobject(ttn, mem_majnom.AsString, pointer(-1));
         TTW_maj.items.AddChildobject(ttn2, mem_majladate.AsString, pointer(-1));
         TTW_maj.items.AddChildobject(ttn2, mem_majnomversion.AsString, pointer(-1));
      end;
      mem_maj.next;
   end;
   mem_maj.close;
   ttn := TTW_maj.Items[0];
   while ttn <> nil do
   begin
      if clients.trouve(clientsnompournous, ttn.Text) then
      begin
         repeat
            ttn2 := nil;
            for i := 0 to ttn.count - 1 do
            begin
               if ttn[i].text = clientsnom.AsString then
               begin
                  ttn2 := ttn[i];
                  BREAK;
               end;
            end;
            if ttn2 = nil then
            begin
               TTW_maj.items.AddChildobject(ttn, '**** ' + clientsnom.AsString + ' ****', pointer(-1));
            end;
         until not (clients.trouveSuivant(clientsnompournous, ttn.Text));
      end;
      ttn := ttn.getNextSibling;
   end;
end;

procedure Tfrm_gestionMAJ.Cb_PriseEnCompteClick(Sender: TObject);
var
   i: integer;
begin
   if TTW_Clt.Selected <> nil then
   begin
      if integer(TTW_Clt.Selected.data) < 0 then
      begin
         i := -integer(TTW_Clt.Selected.data);
         clients.trouve(clientsid, Inttostr(i));
         if (Cb_PriseEnCompte.Checked and (clientsPriseencompte.AsInteger = 0)) or
            (not (Cb_PriseEnCompte.Checked) and (clientsPriseencompte.AsInteger = 1)) then
         begin
            clients.edit;
            if Cb_PriseEnCompte.Checked then
               clientsPriseencompte.AsInteger := 1
            else
               clientsPriseencompte.AsInteger := 0;
            clients.post;
            button5.enabled := true;
            button6.enabled := true;
         end;
      end;
   end;
end;

end.

