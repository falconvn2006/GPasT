unit Split_frm;

interface

uses
   UPost,
   Lames_frm,
   chxSender_frm,
   ComObj,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, CheckLst, ExtCtrls, IpUtils, IpSock, IpHttp,
   IpHttpClientGinkoia, Buttons, ComCtrls, IniFiles;

type
   TFrm_Split = class(TForm)
      Bevel1: TBevel;
      lab_eai: TLabel;
      Lab_version: TLabel;
      Label5: TLabel;
      Label6: TLabel;
      LAB_ETATPRIN: TLabel;
      Lb_Site: TCheckListBox;
      ed_Chemin: TEdit;
      Http: TIpHttpClientGinkoia;
      Lab_Site: TLabel;
      Lab_DATABASE: TLabel;
      BitBtn1: TBitBtn;
      BitBtn2: TBitBtn;
      LAB_ETAT: TLabel;
    Memo1: TMemo;
    Tim_ProgZip: TTimer;
    ProgressZip: TProgressBar;
    Memo2: TMemo;
      procedure Lb_SiteClickCheck(Sender: TObject);
      procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Tim_ProgZipTimer(Sender: TObject);
   private
      function ValueTag(s, tag: string): string;
      function Attente(theid: string): boolean;
      //Fonction de lecture d'une valeur dans le fichier Ini
      FUNCTION LecteurValeurIni(AFileIni,ASection,AIdent,ADefault:String):String;

    { Déclarations privées }
   public
    { Déclarations publiques }
      base: string;
      plagePantin,
         nompournous, clt_machine, clt_centrale: string;
      PlaceInstall: string;
      EAI: string;
      InstanceEAI:String;
      NomVersion: string;
      IdVersion: string;
      LaDatabase: string;
      thelasterror: string;
      recup: boolean;
      function execute: Tmodalresult;
   end;

var
   Frm_Split: TFrm_Split;

implementation
uses
   UCst;

{$R *.DFM}

{ TFrm_Split }

function TFrm_Split.ValueTag(s, tag: string): string;
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

type
   TUneBase = class
      BAS_ID, BAS_NOM, BAS_PLAGE, BAS_IDENT: string;
      BAS_GUID: string;
      BAS_SENDER: string;

      nompournous, clt_machine, clt_centrale: string;
   end;

function TFrm_Split.execute: Tmodalresult;
var
   req: string;
   s, s1: string;
   version: string;
   tc: tconnexion;
   res: TstringList;
   i: integer;
   TUB: TUneBase;

   
begin
   tc := Tconnexion.create;
   req := URL + 'Qry?';
   if copy(base, 1, 2) = '\\' then
   begin
      LaDatabase := base;
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
      LaDatabase := base;
   req := req + 'BASE=' + LaDatabase + '&';
   s := req + 'QRY=Select Ver_version from genversion Order by ver_date desc';
   s := s + '&COUNT=1';
   s := traitechaine(s);
   if Http.oldGetWaitTimeOut(s, 30000) then
   begin
      s := Http.AsString(s);
      version := ValueTag(s, 'VER_VERSION');
   end;
   res := tc.Select('select id, nomversion, EAI from version where version.version="' + version + '"');
   if tc.recordCount(res) > 0 then
   begin
      IdVersion := tc.UneValeur(res, 'id');
      NomVersion := tc.UneValeur(res, 'nomversion');
      Lab_version.caption := 'Version: ' + NomVersion;
      EAI :=  tc.UneValeur(res, 'EAI');
      lab_eai.caption := 'EAI: ' + EAI;
   end
   else NomVersion := '';
   tc.FreeResult(res);

   s := req + 'QRY=Select BAS_ID, BAS_NOM, BAS_PLAGE, BAS_IDENT, BAS_GUID, BAS_SENDER';
   s := s + ' from genbases join k on (k_id=bas_id and k_enabled=1)';
   s := s + ' where bas_id<>0';
   s := s + ' Order by bas_ident';
   s := traitechaine(s);
   if Http.oldGetWaitTimeOut(s, 30000) then
   begin
      s := Http.AsString(s);
      while pos('<ENR>', s) > 0 do
      begin
         delete(s, 1, pos('<ENR>', s) + length('<ENR>') - 1);
         s1 := copy(s, 1, pos('</ENR>', s) - 1);
         delete(s, 1, pos('</ENR>', s) + length('</ENR>') - 1);


         TUB := TUneBase.create;
         TUB.BAS_ID := valueTag(s1, 'BAS_ID');
         TUB.BAS_NOM := valueTag(s1, 'BAS_NOM');
         TUB.BAS_PLAGE := valueTag(s1, 'BAS_PLAGE');
         TUB.BAS_IDENT := valueTag(s1, 'BAS_IDENT');
         TUB.BAS_GUID := valueTag(s1, 'BAS_GUID');
         TUB.BAS_SENDER := valueTag(s1, 'BAS_SENDER');
         Lb_Site.Items.AddObject(TUB.BAS_NOM + '  -->  ' + TUB.BAS_SENDER, TUB);
         if TUB.BAS_IDENT = '0' then
         begin
            plagePantin := TUB.BAS_PLAGE;
            res := tc.select('select nompournous, clt_machine, clt_centrale from clients where clt_GUID="' + TUB.BAS_GUID + '"');
            if tc.recordCount(res) > 0 then
            begin
               nompournous := tc.UneValeur(res, 'nompournous');
               InstanceEAI :=  nompournous+'Bin';
               lab_eai.caption := 'EAI: ' + InstanceEAI;
               clt_machine := tc.UneValeur(res, 'clt_machine');
               clt_centrale := tc.UneValeur(res, 'clt_centrale');
               memo2.Lines.Insert(0,clt_machine);
               for i := 1 to Length(lesplace) do
               begin
                  if clt_machine = lesplace[i] then
                  begin
                     PlaceInstall := lesMachine[i];
                     BREAK;
                  end;
               end;
            end;
            tc.FreeResult(res);
         end;
      end;
      Lab_Site.caption := 'URL: ' + PlaceInstall;
      Lab_DATABASE.caption := 'Client: ' + clt_centrale + ' : ' + nompournous;
      ed_Chemin.text := nompournous;
   end;
   tc.free;
   result := MrCancel;
   if pos('.', version) = 0 then
      application.MessageBox('Pas de version, impossible de continuer', '  Erreur', Mb_Ok)
   else if Strtoint(Copy(version, 1, pos('.', version) - 1)) < 5 then
      application.MessageBox('Ce programme ne tourne que sur les versions 5.2 et suppérieure, impossible de continuer', '  Erreur', Mb_Ok)
   else
   begin
      result := ShowModal;
   end;
end;

procedure TFrm_Split.FormCreate(Sender: TObject);
begin
  //LecteurLame := LecteurValeurIni(IncludeTrailingPathDelimiter(ExtractFilePath(paramstr(0)))+'InstallClient.ini','GENERAL','LecteurLame','F');

{$IFDEF DEBUG}
  memo1.Visible := True;
 {$ENDIF}
end;

procedure TFrm_Split.Lb_SiteClickCheck(Sender: TObject);
var
   chxSender: Tfrm_chxSender;
   TUB: TUneBase;
   frm_lames: Tfrm_lames;
   i: Integer;
begin
   if lb_site.Checked[lb_site.ItemIndex] then
   begin
      TUB := TUneBase(lb_site.Items.Objects[lb_site.ItemIndex]);
      if TUB.BAS_IDENT = '0' then
      begin
         Application.CreateForm(Tfrm_lames, frm_lames);
         frm_lames.cb_machine.Text := TUB.clt_machine;
         frm_lames.cb_centrale.Text := TUB.clt_centrale;
         frm_lames.Ed_Client.Text := TUB.nompournous;
         if frm_lames.ShowModal = Mrok then
         begin
            TUB.clt_machine := frm_lames.cb_machine.Text;
            TUB.clt_centrale := frm_lames.cb_centrale.Text;
            TUB.nompournous := frm_lames.Ed_Client.Text;
            lb_site.Items[lb_site.ItemIndex] := TUB.BAS_NOM + ' -> ' + TUB.nompournous;
            nompournous := TUB.nompournous;
            clt_machine := TUB.clt_machine;
            clt_centrale := TUB.clt_centrale;
            for i := 1 to Length(lesplace) do
            begin
               if clt_machine = lesplace[i] then
               begin
                  PlaceInstall := lesMachine[i];
                  BREAK;
               end;
            end;
         end
         else
            lb_site.Checked[lb_site.ItemIndex] := False;
         frm_lames.release;
        // initialisation de nompournous, clt_machine, clt_centrale
        //TUB.nompournous, TUB.clt_machine, TUB.clt_centrale

        //
      end
      else
      begin
         application.createform(Tfrm_chxSender, chxSender);
         chxSender.Lab_Machine.caption := TUneBase(lb_site.Items.Objects[lb_site.ItemIndex]).BAS_NOM;
         chxSender.ed_Sender.Text := TUneBase(lb_site.Items.Objects[lb_site.ItemIndex]).BAS_SENDER;
         if chxSender.ed_Sender.Text = '' then
            chxSender.ed_Sender.Text := TUneBase(lb_site.Items.Objects[lb_site.ItemIndex]).BAS_NOM;
         if chxSender.showmodal = MrOk then
         begin
            TUneBase(lb_site.Items.Objects[lb_site.ItemIndex]).BAS_SENDER := chxSender.ed_Sender.Text;
            lb_site.Items[lb_site.ItemIndex] := TUneBase(lb_site.Items.Objects[lb_site.ItemIndex]).BAS_NOM + ' -> ' + TUneBase(lb_site.Items.Objects[lb_site.ItemIndex]).BAS_SENDER;
         end
         else
            lb_site.Checked[lb_site.ItemIndex] := False;
         chxSender.release;
      end;
   end;
end;

function TFrm_Split.LecteurValeurIni(AFileIni, ASection, AIdent,
  ADefault: String): String;
//Fonction de lecture d'une valeur dans le fichier Ini
Var
  FichierIni  : TIniFile;
begin
  Try
    //Ouverture ou création du fichier ini
    FichierIni  := TIniFile.Create(AFileIni);

    //Lecteur de la valeur
    Result := FichierIni.ReadString(ASection, AIdent, ADefault);
  Finally
    FichierIni.Free;
    FichierIni  := nil;
  End;
end;

procedure TFrm_Split.Tim_ProgZipTimer(Sender: TObject);
begin
if (LAB_ETAT.caption = 'Construction du zip en cours...') then
  Begin
    ProgressZip.Visible  := True;
    if (ProgressZip.Position>99) then
      ProgressZip.Position := 0
    else
      ProgressZip.Position := ProgressZip.Position + 1;
  End
else
  Begin
    ProgressZip.Position := 0;
    ProgressZip.Visible  := False;
  End;
end;

function TFrm_Split.Attente(theid: string): boolean;
var
   req: string;
   s: string;
   s1: string;
   lastmsg: string;
begin
   result := true;
   lastmsg := '';
   req := URL + 'thrd?ID=' + theid + '&';
   while true do
   begin
      s := traitechaine(req + 'WHAT=QUOI');
      if HTTP.OldGetWaitTimeOut(s, 30000) then
      begin
         s1 := Http.AsString(s);
         HTTP.FreeLink(s);
         if ValueTag(s1, 'LASTERROR') <> '' then
         begin

            memo1.lines.add('************ERREUR*************');
            memo1.lines.add(ValueTag(s1, 'LASTERROR'));
            memo1.lines.add(ValueTag(s1, 'LASTTRAITEMENTERROR'));
            memo1.lines.add(ValueTag(s1, 'MSG'));
            memo1.lines.add('************ERREUR*************');

            thelasterror := ValueTag(s1, 'LASTERROR');
            result := false;
            BREAK;
         end;
         if pos('<error>', s1) > 0 then
         begin
            memo1.lines.add(s1);
            thelasterror := ValueTag(s1, 'error');
            result := false;
            BREAK;
         end;
         if ValueTag(s1, 'MSG') <> lastmsg then
         begin
            lastmsg := ValueTag(s1, 'MSG');
            memo1.lines.add(s1);
            lab_etat.caption := lastmsg;
            lab_etat.update;
         end;
         if (ValueTag(s1, 'RESTE') = '0') and (ValueTag(s1, 'ENCOURS') = 'NONE') then
         begin
            lab_etat.caption := '';
            lab_etat.update;
            BREAK;
         end;
      end
      else
      begin
         memo1.lines.add('time out'); 
         thelasterror := ValueTag(s1, 'Time OUT');
         result := false;
         BREAK;
      end;
      Sleep(250);
   end;
end;

procedure TFrm_Split.BitBtn1Click(Sender: TObject);
var
   i, j: integer;
   req,
      s: string;
   theid: string;
   tub: TUneBase;
   faireclt: boolean;
   GUID: string;
   tc: tconnexion;
   ok: boolean;

   bDoZip: boolean; // Faire le zip ou pas.
begin
   memo2.Lines.Insert(0,'Debut');
   if ed_Chemin.text = '' then
      application.MessageBox('Saisir un chemin pour l''installation', 'erreur', mb_ok)
   else
   begin
      j := 0;
      faireclt := false;
      for i := 0 to Lb_Site.items.Count - 1 do
         if Lb_Site.Checked[i] then
         begin
            j := 1;
            TUB := TUneBase(Lb_Site.items.Objects[i]);
            if tub.BAS_IDENT <> '0' then
            begin
               faireclt := true;
            end;
         end;
      if j = 0 then
         application.MessageBox('Aucun site de selectionné', 'erreur', mb_ok)
      else
      begin
         screen.cursor := crhourglass;
         try
            LAB_ETATPRIN.caption := 'Initialisation';
            LAB_ETATPRIN.update;
            req := URL + 'thrd?';
            memo2.Lines.Insert(0,req);
            s := traitechaine(req + 'WHAT=ORDRE&QUOI=MD;'+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text);
            memo2.Lines.Insert(0,s);
            HTTP.oldGetWaitTimeOut(s, 3000);
            s := Http.AsString(s);
            memo2.Lines.Insert(0,s);
            theid := ValueTag(s, 'thr');
            req := req + 'ID=' + theid + '&';
            LAB_ETATPRIN.caption := 'Copie de la version';
            LAB_ETATPRIN.update;
            memo2.Lines.Insert(0,'recup = ' + booltostr(recup));
            if recup then
            begin
               memo2.Lines.Insert(0,'recup');
               s := traitechaine(req + 'WHAT=ORDRE&QUOI=MD;'+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\origine');
               memo2.Lines.Insert(0,s);
               HTTP.oldGetWaitTimeOut(s, 3000);
               s := traitechaine(req + 'WHAT=ORDRE&QUOI=COPY;'+LecteurTools+':\TECH\' + EAI + '\DelosQPMAgent.Providers.xml;'+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\origine\DelosQPMAgent.Providers.xml');
               memo2.Lines.Insert(0,s);
               HTTP.OldGetWaitTimeOut(s, 30000);
               s := traitechaine(req + 'WHAT=ORDRE&QUOI=COPY;'+LecteurTools+':\TECH\' + EAI + '\DelosQPMAgent.Subscriptions.xml;'+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\origine\DelosQPMAgent.Subscriptions.xml');
               memo2.Lines.Insert(0,s);
               HTTP.OldGetWaitTimeOut(s, 30000);
               s := traitechaine(req + 'WHAT=ORDRE&QUOI=COPY;'+LecteurTools+':\TECH\' + EAI + '\DelosQPMAgent.Subscriptions.xml;'+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\origine\DelosQPMAgent.InitParams.xml');
               memo2.Lines.Insert(0,s);
               HTTP.OldGetWaitTimeOut(s, 30000);
            end
            else if faireclt then
            begin
               memo2.Lines.Insert(0,'faireclt');
               s := traitechaine(req + 'WHAT=ORDRE&QUOI=COPYALL;'+LecteurTools+':\TECH\EAIGENE\EAI\;'+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\origine\EAI\');
               memo2.Lines.Insert(0,s);
               HTTP.oldGetWaitTimeOut(s, 30000);
               s := traitechaine(req + 'WHAT=ORDRE&QUOI=COPYALL;'+LecteurTools+':\TECH\' + EAI + '\;'+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\origine\EAI\');
               memo2.Lines.Insert(0,s);
               HTTP.OldGetWaitTimeOut(s, 30000);
               s := traitechaine(req + 'WHAT=ORDRE&QUOI=COPYALL;'+LecteurTools+':\EAI\MAJ\' + NomVersion + '\;'+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\origine\');
               memo2.Lines.Insert(0,s);
               HTTP.OldGetWaitTimeOut(s, 30000);
            end;
            s := traitechaine(req + 'WHAT=ORDRE&QUOI=COPY;' + base + ';'+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\GINKOIA.IB');
            memo2.Lines.Insert(0,s);
            HTTP.OldGetWaitTimeOut(s, 30000);
            if not Attente(theid) then
            begin
               Application.MessageBox(pchar(thelasterror), '  Erreur', Mb_OK);
               EXIT;
            end;
         {}
            for i := 0 to Lb_Site.items.Count - 1 do
               if Lb_Site.Checked[i] then
               begin
                  TUB := TUneBase(Lb_Site.items.Objects[i]);
                  LAB_ETATPRIN.caption := 'Creation de ' + tub.BAS_NOM;
                  LAB_ETATPRIN.Update;
                  if not recup and (tub.BAS_IDENT = '0') then
                  begin
                    // Création de la base sur la lame
                     s := URL + 'Qry?' +
                        'BASE='+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\GINKOIA.IB' +
                        '&QRY=Update genparambase Set PAR_STRING=''' + tub.BAS_IDENT + ''' Where PAR_NOM=''IDGENERATEUR''&SPE=EXEC';
                     memo2.Lines.Insert(0,s);
                     s := traitechaine(s);
                     memo2.Lines.Insert(0,s);
                     s := URL + 'recupgene?' + 'ID=' + theid +
                        '&PLAGE_PANTIN=' + plagePantin +
                        '&PLAGE_MAGASIN=' + tub.BAS_PLAGE +
                        '&NUMMAGASIN=' + tub.BAS_IDENT +
                        '&PATH= ' +
                        '&SENDER=' + tub.BAS_SENDER +
                        '&DATABASE=' + nompournous +
                        '&EAI= ' +
                        '&PANTIN=' + PlaceInstall +
                        '&VERSION=' + InstanceEAI +
                        '&DATA='+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\GINKOIA.IB';
                     memo2.Lines.Insert(0,s);
                     s := traitechaine(s);
                     memo2.Lines.Insert(0,s);
                     HTTP.OldGetWaitTimeOut(s, 30000);
                     if not Attente(theid) then
                     begin
                        Application.MessageBox(pchar(thelasterror), '  Erreur', Mb_OK);
                        EXIT;
                     end;
                     s := URL + 'Qry?';
                     memo2.Lines.Insert(0,s);
                     s := s + 'BASE='+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\GINKOIA.IB&';
                     memo2.Lines.Insert(0,s);

                     GUID := CreateClassID;

                     tc := tconnexion.Create;
                     tc.insert('INSERT INTO clients (' +
                        'site,nom,version,' +
                        'nompournous,basepantin,clt_machine,' +
                        'clt_centrale,clt_GUID)' +
                        ' VALUES (' +
                        '"' + tub.nompournous + '","' + tub.BAS_NOM + '",' + IdVersion + ',' +
                        '"' + tub.nompournous + '",1,"' + tub.clt_machine + '",' +
                        '"' + tub.clt_centrale + '","' + GUID + '")');
                     tc.free;

                     s := s + 'SPE=EXEC&QRY=Update GENBASES Set ' +
                        'BAS_GUID=' + Quotedstr(GUID) +
                        ', BAS_CENTRALE=' + Quotedstr(tub.clt_centrale) +
                        ', BAS_NOMPOURNOUS=' + Quotedstr(tub.nompournous) +
                        '  WHERE BAS_ID=' + TUB.BAS_ID;
                     memo2.Lines.Insert(0,s);
                     Http.oldGetWaitTimeOut(traitechaine(s), 30000);

                     s := traitechaine(req + 'WHAT=ORDRE&QUOI=ADD_EAI;' +
                        '\\' + tub.clt_machine + '\EAI\' + Copy(EAI, 1, length(eai) - 3) + ';' +
                        tub.nompournous + ';' +
                        tub.clt_machine + ':'+LecteurLame+':\EAI\' + tub.clt_centrale + '\' + tub.nompournous + '\DATA\GINKOIA.IB');
                     memo2.Lines.Insert(0,s);
                     HTTP.oldGetWaitTimeOut(s, 3000);
                     repeat
                        ok := attente(theid);
                        if not ok then
                        begin
                           if application.messagebox(pchar('Problème de référencement des EAI' + #10#13 + thelasterror + #10#13 + 'Retenter ?'), '  Erreur',
                              mb_YESNO) = mrNo then
                              ok := true
                           else
                              HTTP.oldGetWaitTimeOut(s, 3000);
                        end;
                     until ok;

                     s := traitechaine(req + 'WHAT=ORDRE&QUOI=MD;\\' + tub.clt_machine + '\EAI\' + tub.clt_centrale + '\' + tub.nompournous + '\DATA');
                     memo2.Lines.Insert(0,s);
                     HTTP.oldGetWaitTimeOut(s, 3000);

                     s := traitechaine(req + 'WHAT=ORDRE&QUOI=COPY;' +
                        LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\GINKOIA.IB;' +
                        '\\' + tub.clt_machine + '\EAI\' + tub.clt_centrale + '\' + tub.nompournous + '\DATA\GINKOIA.IB');
                     memo2.Lines.Insert(0,s);
                     HTTP.OldGetWaitTimeOut(s, 30000);
                     if not Attente(theid) then
                     begin
                        Application.MessageBox(pchar(thelasterror), '  Erreur', Mb_OK);
                        EXIT;
                     end;
                  end
                  else
                  begin
                    { }
                     s := traitechaine(req + 'WHAT=ORDRE&QUOI=COPYALL;'+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\origine\;'+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\' + tub.BAS_NOM + '\');
                     memo2.Lines.Insert(0,s);
                     HTTP.OldGetWaitTimeOut(s, 30000);
                     if recup then
                        s := traitechaine(req + 'WHAT=ORDRE&QUOI=COPY;' +
                           LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\GINKOIA.IB;' +
                           LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\' + tub.BAS_NOM + '\GINKOIA.IB')
                     else
                        s := traitechaine(req + 'WHAT=ORDRE&QUOI=COPY;' +
                           LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\GINKOIA.IB;' +
                           LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\' + tub.BAS_NOM + '\DATA\GINKOIA.IB');
                     memo2.Lines.Insert(0,s);
                     HTTP.OldGetWaitTimeOut(s, 30000);
                     if not Attente(theid) then
                     begin
                        Application.MessageBox(pchar(thelasterror), '  Erreur', Mb_OK);
                        EXIT;
                     end;

                     if recup then
                        s := URL + 'Qry?' +
                           'BASE='+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\' + tub.BAS_NOM + '\GINKOIA.IB' +
                           '&QRY=Update genparambase Set PAR_STRING=''' + tub.BAS_IDENT + ''' Where PAR_NOM=''IDGENERATEUR''&SPE=EXEC'
                     else
                        s := URL + 'Qry?' +
                           'BASE='+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\' + tub.BAS_NOM + '\DATA\GINKOIA.IB' +
                           '&QRY=Update genparambase Set PAR_STRING=''' + tub.BAS_IDENT + ''' Where PAR_NOM=''IDGENERATEUR''&SPE=EXEC';
                     s := traitechaine(s);
                     memo2.Lines.Insert(0,s);
                     HTTP.OldGetWaitTimeOut(s, 30000);

                     if recup then
                        s := URL + 'recupgene?' + 'ID=' + theid +
                           '&PLAGE_PANTIN=' + plagePantin +
                           '&PLAGE_MAGASIN=' + tub.BAS_PLAGE +
                           '&NUMMAGASIN=' + tub.BAS_IDENT +
                           '&PATH='+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\' + tub.BAS_NOM + '' +
                           '&SENDER=' + tub.BAS_SENDER +
                           '&DATABASE=' + nompournous +
                           '&EAI='+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\' + tub.BAS_NOM + '\' +
                           '&PANTIN=' + PlaceInstall +
                           '&VERSION=' + InstanceEAI +
                           '&DATA='+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\' + tub.BAS_NOM + '\GINKOIA.IB'
                     else
                        s := URL + 'recupgene?' + 'ID=' + theid +
                           '&PLAGE_PANTIN=' + plagePantin +
                           '&PLAGE_MAGASIN=' + tub.BAS_PLAGE +
                           '&NUMMAGASIN=' + tub.BAS_IDENT +
                           '&PATH='+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\' + tub.BAS_NOM + '\EAI' +
                           '&SENDER=' + tub.BAS_SENDER +
                           '&DATABASE=' + nompournous +
                           '&EAI='+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\' + tub.BAS_NOM + '\EAI\' +
                           '&PANTIN=' + PlaceInstall +
                           '&VERSION=' + InstanceEAI +
                           '&DATA='+LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\' + tub.BAS_NOM + '\DATA\GINKOIA.IB';
                     s := traitechaine(s);
                     memo2.Lines.Insert(0,s);
                     HTTP.OldGetWaitTimeOut(s, 30000);
                     if not Attente(theid) then
                     begin
                        Application.MessageBox(pchar(thelasterror), '  Erreur', Mb_OK);
                        EXIT;
                     end;

                     bDoZip := False;
                     if bDoZipAuto then
                     begin
                       bDoZip := true;
                     end
                     else begin
                       if MessageDlg('Voulez vous zipper ? ',mtInformation,[mbyes,mbNo],0) = mrYes then
                       begin
                         bDoZip := true;
                       end
                       else begin
                         bDoZip := False;
                       end;
                     end;

               {}    //Traitement du zip
                     if bDoZip then
                     begin
                       if recup then
                          s := URL + 'thrd?' + 'ID=' + theid + '&WHAT=ORDRE&QUOI=ZIP_REP;' +
                             LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\' + tub.BAS_NOM + '\;' +
                             LecteurTools+':\TRANSFERTS\BASES\' + tub.BAS_NOM + '.ZIP&OPTION=NOPSW'
                       else
                          s := URL + 'thrd?' + 'ID=' + theid + '&WHAT=ORDRE&QUOI=ZIP_REP;' +
                             LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\' + tub.BAS_NOM + '\;' +
                             LecteurTools+':\TRANSFERTS\BASES\' + tub.BAS_NOM + '.ZIP';
                       s := traitechaine(s);
                       memo2.Lines.Insert(0,s);
                       HTTP.OldGetWaitTimeOut(s, 30000);
                       s := Http.AsString(s);
                       memo1.lines.add(S);
                       if not Attente(theid) then
                       begin
                          Application.MessageBox(pchar(thelasterror), '  Erreur', Mb_OK);
                          EXIT;
                       end;
                     end;

                  end;
               end;

            //Demande de sauvegarde du log de traitement
            if MessageDlg('Save log',mtInformation,[mbyes,mbNo],0) = mrYes then
            begin
              Memo2.Lines.SaveToFile('c:\installclient.log');
              Memo1.Lines.SaveToFile('c:\installclient2.log');
            end;

            //Demande de nettoyage du dossier SPLIT
            if MessageDlg('Nettoyage',mtInformation,[mbyes,mbNo],0) = mrYes then
            begin
              LAB_ETATPRIN.caption := 'Nettoyage';
              LAB_ETATPRIN.update;
              s := URL + 'thrd?' + 'ID=' + theid + '&WHAT=ORDRE&QUOI=DEL_ALL;' +
                 LecteurTools+':\TECH\SPLIT\' + ed_Chemin.text + '\';
              s := traitechaine(s);
              memo2.Lines.Insert(0,s);
              HTTP.OldGetWaitTimeOut(s, 30000);
              if not Attente(theid) then
              begin
                 Application.MessageBox(pchar(thelasterror), '  Erreur', Mb_OK);
                 EXIT;
              end;
            end;

         finally
            screen.cursor := crDefault;
            application.MessageBox('Fin du traitement', 'FIN', MB_Ok);
            Close;
         end;
      end;
   end;
end;

end.

