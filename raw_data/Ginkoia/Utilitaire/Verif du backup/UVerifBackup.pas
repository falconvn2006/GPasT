unit UVerifBackup;

interface

uses
    XMLCursor,
    StdXML_TLB,
   IniFiles,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Menus, ExtCtrls, StdCtrls, IBDatabase, Db, IBCustomDataSet, IBQuery,
   ScktComp;

type
   TRechBase = class(TThread)
   private
        { Déclarations privées }
      RepRech: string;
      RepCible: string;
      FicRech: string;
      ListeBase: TStringList;
      Cherche: string;
      procedure EcritCherche;
      procedure Ajoute;
   protected
      procedure Execute; override;
   public
      Path: string;
      constructor Create(Liste: TstringList; RepRech, RepCible, FicRech: string);
      destructor Destroy; override;
   end;

   TFrm_VerifBackup = class(TForm)
      MainMenu1: TMainMenu;
      Fichier1: TMenuItem;
      Repderecherche1: TMenuItem;
      Fichierrecherch1: TMenuItem;
      N1: TMenuItem;
      Quiter1: TMenuItem;
      Rpertoirecible1: TMenuItem;
      Tim_Travail: TTimer;
      Pan_Travail: TPanel;
      Lb: TListBox;
      Panel1: TPanel;
      Button1: TButton;
      Button2: TButton;
      Data: TIBDatabase;
      Tran: TIBTransaction;
      QryBase: TIBQuery;
      QryResultBackup: TIBQuery;
      QryBaseBAS_ID: TIntegerField;
      QryBaseBAS_NOM: TIBStringField;
      QryBaseBAS_IDENT: TIBStringField;
      QryResultBackupDOS_NOM: TIBStringField;
      QryResultBackupDOS_STRING: TIBStringField;
      QryResultBackupDOS_FLOAT: TFloatField;
      QrySociete: TIBQuery;
      QrySocieteSOC_NOM: TIBStringField;
      LbProb: TListBox;
      Splitter1: TSplitter;
      Client: TClientSocket;
      Serveur1: TMenuItem;
      Port1: TMenuItem;
      qry: TIBQuery;
      QryResultBackupDOS_ID: TIntegerField;
      Lab: TLabel;
      Lab2: TLabel;
      Lab3: TLabel;
      Label1: TLabel;
      Label2: TLabel;
      Sauve: TButton;
      SD: TSaveDialog;
      procedure Quiter1Click(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure Repderecherche1Click(Sender: TObject);
      procedure Fichierrecherch1Click(Sender: TObject);
      procedure Rpertoirecible1Click(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure Tim_TravailTimer(Sender: TObject);
      procedure Button1Click(Sender: TObject);
      procedure Button2Click(Sender: TObject);
      procedure ClientConnect(Sender: TObject;
         Socket: TCustomWinSocket);
      procedure ClientDisconnect(Sender: TObject;
         Socket: TCustomWinSocket);
      procedure ClientError(Sender: TObject; Socket: TCustomWinSocket;
         ErrorEvent: TErrorEvent; var ErrorCode: Integer);
      procedure ClientRead(Sender: TObject; Socket: TCustomWinSocket);
      procedure Serveur1Click(Sender: TObject);
      procedure Port1Click(Sender: TObject);
      procedure LbDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
         State: TOwnerDrawState);
      procedure SauveClick(Sender: TObject);
   private
        { Déclarations privées }
      procedure SauveIni;
   public
        { Déclarations publiques }
      EnvoieStr: string;
      RecuStr: string;
      Fini: Boolean;

      RepRech: string;
      RepCible: string;
      FicRech: string;
      Serveur: string;
      Port: string;
      SauveList: Boolean;
      ListeBase: TStringList;
      BaseAjout: TStringList;
      Fin: Boolean;
      Plusdeclient: Boolean;
      procedure AjoutBase(Path: string);
      procedure Traitement(Num: Integer);
   end;

var
   Frm_VerifBackup: TFrm_VerifBackup;

implementation
{$R *.DFM}
uses
   UChxString;

procedure TFrm_VerifBackup.Quiter1Click(Sender: TObject);
begin
   Close;
end;

procedure TFrm_VerifBackup.FormCreate(Sender: TObject);
var
   ini: TIniFile;
begin
   Pan_Travail.Caption := 'Attente ...';
   Fin := True;
   ini := TiniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
   try
      RepRech := Ini.ReadString('FICHIERS', 'REPERTOIRE', 'D:\EAI\');
      FicRech := Ini.ReadString('FICHIERS', 'FICHIER', 'GINKOIA.GDB');
      RepCible := Ini.ReadString('FICHIERS', 'REP_CIBLE', 'DATA');
      Serveur := Ini.ReadString('SERVEUR', 'SERVEUR', 'LiveUpdate.Algol.Fr');
      Port := Ini.ReadString('SERVEUR', 'PORT', '31415');
   finally
      ini.free;
   end;
   ListeBase := TstringList.Create;
   try
      if fileexists(ChangeFileExt(Application.ExeName, '.BASES')) then
         ListeBase.LoadFromFile(ChangeFileExt(Application.ExeName, '.BASES'));
   except
   end;
   BaseAjout := TstringList.Create;
   SauveList := false;
end;

procedure TFrm_VerifBackup.Repderecherche1Click(Sender: TObject);
var
   Frm_ChxString: TFrm_ChxString;
begin
   Application.CreateForm(TFrm_ChxString, Frm_ChxString);
   try
      Frm_ChxString.Edit1.Text := RepRech;
      Frm_ChxString.Caption := 'Répertoire de recherche';
      if Frm_ChxString.ShowModal = MrOk then
      begin
         RepRech := Frm_ChxString.Edit1.Text;
         if RepRech[Length(RepRech)] <> '\' then
            RepRech := RepRech + '\';
         SauveIni;
      end;
   finally
      Frm_ChxString.Release;
   end;
end;

procedure TFrm_VerifBackup.SauveIni;
var
   ini: TIniFile;
begin
   ini := TiniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
   try
      Ini.WriteString('FICHIERS', 'REPERTOIRE', RepRech);
      Ini.WriteString('FICHIERS', 'FICHIER', FicRech);
      Ini.WriteString('FICHIERS', 'REP_CIBLE', RepCible);
      Ini.WriteString('SERVEUR', 'SERVEUR', Serveur);
      Ini.WriteString('SERVEUR', 'PORT', Port);
   finally
      ini.free;
   end;
end;

procedure TFrm_VerifBackup.Fichierrecherch1Click(Sender: TObject);
var
   Frm_ChxString: TFrm_ChxString;
begin
   Application.CreateForm(TFrm_ChxString, Frm_ChxString);
   try
      Frm_ChxString.Edit1.Text := FicRech;
      Frm_ChxString.Caption := 'Fichier recherché';
      if Frm_ChxString.ShowModal = MrOk then
      begin
         FicRech := Uppercase(Frm_ChxString.Edit1.Text);
         SauveIni;
      end;
   finally
      Frm_ChxString.Release;
   end;
end;

procedure TFrm_VerifBackup.Rpertoirecible1Click(Sender: TObject);
var
   Frm_ChxString: TFrm_ChxString;
begin
   Application.CreateForm(TFrm_ChxString, Frm_ChxString);
   try
      Frm_ChxString.Edit1.Text := RepCible;
      Frm_ChxString.Caption := 'Répertoire cible';
      if Frm_ChxString.ShowModal = MrOk then
      begin
         RepCible := Uppercase(Frm_ChxString.Edit1.Text);
         SauveIni;
      end;
   finally
      Frm_ChxString.Release;
   end;
end;

procedure TFrm_VerifBackup.FormDestroy(Sender: TObject);
begin
   if SauveList then
      ListeBase.SaveToFile(ChangeFileExt(Application.ExeName, '.BASES'));
   ListeBase.Free;
   BaseAjout.free;
end;

{ TRechBase }

constructor TRechBase.Create(Liste: TstringList; RepRech, RepCible, FicRech: string);
var
   s: string;
   i: integer;
begin
   inherited create(true);
   Frm_VerifBackup.Fin := False;
   FreeOnTerminate := true;
   Self.RepRech := RepRech;
   Self.RepCible := RepCible;
   Self.FicRech := FicRech;
   ListeBase := TstringList.Create;
   for i := 0 to Liste.Count - 1 do
   begin
      S := trim(Liste[i]);
      if Pos(';', S) > 0 then
      begin
         S := Copy(S, 1, Pos(';', S) - 1);
         ListeBase.Add(S);
      end;
   end;
end;

destructor TRechBase.Destroy;
begin
   ListeBase.Free;
   Frm_VerifBackup.Fin := True;
   inherited;
end;

procedure TRechBase.Ajoute;
begin
   if ListeBase.IndexOf(Path) < 0 then
      Frm_VerifBackup.AjoutBase(Path);
end;

procedure TRechBase.Execute;

   procedure recherche(Dem: string; OK: Boolean);
   var
      F: TSearchRec;
      Attr: Integer;
   begin
      Cherche := Dem;
      Synchronize(EcritCherche);
      if Ok then
         Attr := FaAnyFile
      else
         Attr := FaDirectory;

      if FindFirst(Dem + '*.*', Attr, F) = 0 then
      begin
         repeat
            if (f.name <> '.') and (F.Name <> '..') then
            begin
               if (f.Attr and faDirectory) = faDirectory then
               begin
                  if (Uppercase(F.Name) <> 'BATCH') and
                     (Uppercase(F.Name) <> 'EXTRACT') and
                     (Uppercase(F.Name) <> 'LOG') and
                     (Uppercase(F.Name) <> 'XML') then
                  begin
                     if (RepCible = '') or (Uppercase(F.Name) = RepCible) then
                        Recherche(Dem + F.Name + '\', true)
                     else
                        Recherche(Dem + F.Name + '\', False);
                  end;
               end
               else if ok then
               begin
                  if uppercase(F.Name) = FicRech then
                  begin
                     Path := Uppercase(Dem + F.Name);
                     synchronize(Ajoute);
                  end;
               end;
            end;
         until findnext(F) <> 0;
      end;
      FindClose(F);
   end;

begin
   recherche(RepRech, False);
   Cherche := '';
   Synchronize(EcritCherche);
end;

procedure TFrm_VerifBackup.AjoutBase(Path: string);
begin
   if fileexists(Path) then
      BaseAjout.Add(Path);
end;

procedure TFrm_VerifBackup.Tim_TravailTimer(Sender: TObject);
var
   i: integer;
begin
   if fini then
   begin
      if BaseAjout.Count > 0 then
      begin
         Tim_Travail.Enabled := False;
         while BaseAjout.Count > 0 do
         begin
            if trim(BaseAjout[0]) <> '' then
            begin
               i := ListeBase.Add(BaseAjout[0] + ';;\');
               SauveList := true;
            end
            else
               i := -1;
            BaseAjout.Delete(0);
            if i <> -1 then
            begin
               Traitement(i);
               application.processmessages;
            end;
         end;
         Tim_Travail.Enabled := True;
            //
      end
      else if Fin then
      begin
         Tim_Travail.Enabled := False;
         Pan_Travail.Caption := 'Traitement terminé';
      end;
   end;
end;

procedure TFrm_VerifBackup.Button1Click(Sender: TObject);
begin
   if fin then
      Close;
end;

procedure TFrm_VerifBackup.Button2Click(Sender: TObject);

   procedure listedesbases;
      procedure traite(Version, fichier: string);
      var
         Document: IXMLCursor;
         PassXML: IXMLCursor;
         PassXML2: IXMLCursor;
         Base: string;
      begin
         Document := TXMLCursor.Create;
         Document.Load(Fichier);
         PassXML := Document.Select('DataSource');
         while not PassXML.eof do
         begin
            PassXML2 := PassXML.Select('Params');
            PassXML2 := PassXML2.Select('Param');
            base := '';
            while not PassXML2.eof do
            begin
               if PassXML2.GetValue('Name') = 'SERVER NAME' then
               begin
                  base := PassXML2.GetValue('Value');
                  BREAK;
               end;
               PassXML2.next;
            end;
            if pos(':', base) > 2 then
               base := copy(base, pos(':', base) + 1, 255);
            if base <> '' then
               AjoutBase(base);
            PassXML.next;
         end;
         PassXML2 := nil;
         PassXML := nil;
         Document := nil;
      end;

   var
      f: tsearchrec;
   begin
      if FindFirst('D:\Eai\*.*', faanyfile, f) = 0 then
      begin
         repeat
            if (Copy(f.name, 1, 1) = 'V') and ((f.attr and faDirectory) = faDirectory) then
            begin
               if FileExists('D:\Eai\' + f.name + '\DelosQPMAgent.Databases.xml') then
               begin
                  Traite(f.name, 'D:\Eai\' + f.name + '\DelosQPMAgent.Databases.xml');
               end;
            end;
         until Findnext(f) <> 0;
      end;
   end;

var
   rech: TRechBase;
   i: Integer;
begin
   fini := true;


   Plusdeclient := False;
   rech := TRechBase.create(ListeBase, RepRech, RepCible, FicRech);
   rech.Resume;
   i := 0;
   while i < ListeBase.Count do
   begin
      Traitement(i);
      while BaseAjout.Count > 0 do
      begin
         if trim(BaseAjout[0]) <> '' then
         begin
            ListeBase.Add(BaseAjout[0] + ';;\');
            SauveList := true;
         end;
         BaseAjout.Delete(0);
      end;
      inc(i);
      Application.ProcessMessages;
   end;
   if not fin then
   begin
      Tim_Travail.Enabled := true;
   end
   else
      Pan_Travail.Caption := 'Traitement terminé';
end;

procedure TFrm_VerifBackup.Traitement(Num: Integer);
var
   Path: string;
   S1: string;
   LesMags: string;
   S: string;
   S_: string;

   LeNum, Num1, Num2: Double;
   Res, Res1, Res2: string;
   Dt, dt1, dt2: string;
   Date1, Date2: TDateTime;
begin
   try
      S := ListeBase[num];
      Data.Close;
      Path := Copy(S, 1, Pos(';', S) - 1);
      delete(S, 1, pos(';', S));
      LesMags := Copy(S, 1, Pos('\', S) - 1);
      delete(S, 1, pos('\', S));
      Label1.Caption := 'Verif base ' + Path;
      Data.DatabaseName := Path;
      try
         Data.Open;
      except
         Label1.Caption := 'Probleme base ' + Path;
         EXIT;
      end;
      Application.processmessages;
      QryBase.Open;
      QryBase.First;
      Application.processmessages;
      S1 := '';
      while not QryBase.Eof do
      begin
         Label2.Caption := '1 ' + QryBaseBAS_NOM.AsString; Label2.Update;
         if S1 = '' then
            S1 := QryBaseBAS_NOM.AsString
         else
            S1 := S1 + ';' + QryBaseBAS_NOM.AsString;
         QryBase.Next;
      end;
      if trim(S) = '' then
      begin
         QrySociete.Open;
         S := QrySocieteSOC_NOM.AsString;
         QrySociete.Close;
      end;
      Label2.Caption := '2 '; Label2.Update;
      RecuStr := '';
      Fini := false;
      LesMags := S1;
      EnvoieStr := LesMags + '\' + S;
      if not Plusdeclient then
      begin
         Lab3.Caption := Serveur + ' ' + Port;
         Client.Port := StrToInt(Port);
         Client.Host := Serveur;
         Client.Open;
         Label2.Caption := '3 '; Label2.Update;
         while not Fini do Application.processMessages;
         Client.Close;
      end;
      Label2.Caption := '4 '; Label2.Update;
      if (RecuStr <> '') and (RecuStr <> 'OK') then
         S := RecuStr;
      ListeBase[num] := Path + ';' + LesMags + '\' + S;
      SauveList := true;
      Application.processmessages;
      QryResultBackup.ParamByName('NOM').AsString := 'REPLICATION';
      QryResultBackup.Open;
      Label2.Caption := '5 '; Label2.Update;
      try
         if QryResultBackup.Isempty then
         begin
            Qry.sql.clear;
            Qry.sql.Add('INSERT INTO GENDOSSIER (DOS_ID,DOS_NOM,DOS_STRING,DOS_FLOAT)');
            Qry.sql.Add('values (Gen_Id(General_Id,1),''REPLICATION'',''OUI'',1)');
            Qry.ExecSQL;
            Qry.sql.clear;
            Qry.sql.Add('INSERT INTO K (K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,KSE_DELETE_ID,K_DELETED,KSE_UPDATE_ID,K_UPDATED,KSE_LOCK_ID,KMA_LOCK_ID)');
            Qry.sql.Add('VALUES (Gen_Id(General_Id,0),-101,-11111338,Gen_Id(General_Id,0),1,-1,-1,Current_date,0,''12/30/1899'',0,Current_date,0,0)');
            Qry.ExecSQL;
            Qry.transaction.commit;
         end
         else if (QryResultBackupDOS_STRING.AsString <> 'OUI') or
            (QryResultBackupDOS_FLOAT.AsFloat <> 1) then
         begin
            Qry.sql.clear;
            Qry.sql.Add('Update GENDOSSIER');
            Qry.sql.Add('   Set DOS_STRING = ''OUI'', DOS_FLOAT=1');
            Qry.sql.Add(' Where DOS_ID = ' + Inttostr(QryResultBackupDOS_ID.AsInteger));
            Qry.ExecSQL;
            Qry.sql.clear;
            Qry.sql.Add('Update K SET K_VERSION = GEN_ID(GENERAL_ID,1) WHERE K_ID = ' + Inttostr(QryResultBackupDOS_ID.AsInteger));
            Qry.ExecSQL;
         end;
      finally
         QryResultBackup.Close;
      end;
      Label2.Caption := '6 '; Label2.Update;
      if tran.Active = false then
         QryBase.Open;
      QryBase.First;
      while not QryBase.Eof do
      begin
         Label2.Caption := '7 '; Label2.Update;
         Application.processmessages;
         QryResultBackup.ParamByName('NOM').AsString := 'B-' + QryBaseBAS_ID.AsString;
         QryResultBackup.Open;
         try
            if QryResultBackup.IsEmpty then
            begin
               Lb.items.AddObject(Format('Client %-20.20s Base %-20.20s Pas de backup', [S, QryBaseBAS_NOM.AsString]), pointer(-10));
               if (Copy(trim(QryBaseBAS_NOM.AsString), 1, 3) <> 'NB_') and
                  (Copy(trim(QryBaseBAS_NOM.AsString), 1, 3) <> 'NB-') and
                  (Copy(trim(QryBaseBAS_NOM.AsString), 1, 4) <> 'NB1_') and
                  (Copy(trim(QryBaseBAS_NOM.AsString), 1, 4) <> 'NB2_') then
                  LbProb.items.Add(Format('Client %-20.20s Base %-20.20s Pas de backup', [S, QryBaseBAS_NOM.AsString]));
            end
            else
            begin
               QryResultBackup.First;
               res1 := QryResultBackupDOS_STRING.AsString;
               Num1 := QryResultBackupDOS_FLOAT.AsFloat;
               if pos('-', res1) > 0 then
               begin
                  Dt1 := trim(Copy(res1, 1, pos('-', res1) - 1));
                  delete(res1, 1, pos('-', res1));
                  res1 := trim(res1);
               end
               else
               begin
                  Dt1 := trim(res1);
                  delete(dt1, length(dt1), 1);
                  dt1 := trim(dt1);
                  res1 := trim(res1);
                  delete(res1, 1, Length(res1) - 4);
               end;

               if Dt1 = '' then
                  Application.MessageBox(Pchar(res1), 'Problème', Mb_OK);

               Delete(res1, 1, Pos('-', res1));
               res1 := trim(res1);

               QryResultBackup.Next;
               if QryResultBackup.Eof then
               begin
                  res2 := '';
                  dt2 := '';
                  Num2 := -1;
               end
               else
               begin
                  res2 := QryResultBackupDOS_STRING.AsString;
                  Num2 := QryResultBackupDOS_FLOAT.AsFloat;
                  if pos('-', res2) > 0 then
                  begin
                     Dt2 := trim(Copy(res2, 1, pos('-', res2) - 1));
                     delete(res2, 1, pos('-', res2));
                     res2 := trim(res2);
                  end
                  else
                  begin
                     Dt2 := trim(res2);
                     delete(dt2, length(dt2), 1);
                     dt2 := trim(dt2);
                     res2 := trim(res2);
                     delete(res2, 1, Length(res2) - 4);
                  end;
               end;
                    // 11 / 03 / 03 22: 57: 01 - 0
               ShortDateFormat := 'DD/MM/YY';
               Date1 := StrTodateTime(Dt1);
               if Dt2 <> '' then
               begin
                  Date2 := StrTodateTime(Dt2);
                  if Date2 > date1 then
                  begin
                     LeNum := Num1; Num1 := Num2; Num2 := LeNum;
                     dt := dt1; dt1 := dt2; dt2 := dt;
                     Res := Res1; Res1 := Res2; Res2 := Res;
                  end;
               end;

               if Num1 = 1 then
               begin
                  S_ := trim(dt1);
                  S_ := Copy(S_, 1, pos(' ', S_) - 1);
                  if res1 = '0' then
                     Lb.items.AddObject(Format('Client %-20.20s Base %-20.20s - %s  OK', [S, QryBaseBAS_NOM.AsString, dt1]), pointer(0))
                  else
                     Lb.items.AddObject(Format('Client %-20s Base %-20.20s - %s  OK mais pas renomé ', [S, QryBaseBAS_NOM.AsString, dt1]), pointer(1));
                  if (Copy(trim(QryBaseBAS_NOM.AsString), 1, 3) <> 'NB_') and
                     (Copy(trim(QryBaseBAS_NOM.AsString), 1, 3) <> 'NB-') and
                     (Copy(trim(QryBaseBAS_NOM.AsString), 1, 4) <> 'NB1_') and
                     (Copy(trim(QryBaseBAS_NOM.AsString), 1, 4) <> 'NB2_') then
                  begin
                     if StrToDate(S_) + 10 < Date then
                     begin
                        if res1 = '0' then
                           LbProb.items.Add(Format('Client %-20.20s Base %-20.20s - %s  OK', [S, QryBaseBAS_NOM.AsString, dt1]))
                        else
                           LbProb.items.Add(Format('Client %-20s Base %-20.20s - %s  OK mais pas renomé ', [S, QryBaseBAS_NOM.AsString, dt1]));
                     end;
                  end;
               end
               else
               begin
                  LbProb.items.Add(Format('Client %-20.20s Base %-20.20s - %s  PAS OK', [S, QryBaseBAS_NOM.AsString, dt1]));
                  if res1 = '2' then
                     Lb.items.AddObject(Format('Client %-20.20s Base %-20.20s - %s  restore ok mais base mauvaise', [S, QryBaseBAS_NOM.AsString, dt1]), pointer(2))
                  else if res1 = '3' then
                     Lb.items.AddObject(Format('Client %-20.20s Base %-20.20s - %s  Pas de Restore', [S, QryBaseBAS_NOM.AsString, dt1]), pointer(3))
                  else
                     Lb.items.AddObject(Format('Client %-20.20s Base %-20.20s - %s  Pas de Backup', [S, QryBaseBAS_NOM.AsString, dt1]), pointer(4));
               end;

               if Num2 <> -1 then
               begin
                  if Num2 = 1 then
                  begin
                     if res2 = '0' then
                        Lb.items.AddObject(Format('Client %-20.20s Base %-20.20s - %s  OK', [S, QryBaseBAS_NOM.AsString, dt2]), pointer(10))
                     else
                        Lb.items.Addobject(Format('Client %-20.20s Base %-20.20s - %s  OK mais pas renomé', [S, QryBaseBAS_NOM.AsString, dt2]), pointer(10));
                  end
                  else
                  begin
                     if res1 = '2' then
                        Lb.items.AddObject(Format('Client %-20.20s Base %-20.20s - %s  restore ok mais base mauvaise', [S, QryBaseBAS_NOM.AsString, dt2]), pointer(10))
                     else if res1 = '3' then
                        Lb.items.AddObject(Format('Client %-20.20s Base %-20.20s - %s  Pas de Restore', [S, QryBaseBAS_NOM.AsString, dt2]), pointer(10))
                     else
                        Lb.items.Addobject(Format('Client %-20.20s Base %-20.20s - %s  Pas de Backup', [S, QryBaseBAS_NOM.AsString, dt2]), pointer(10));
                  end;
               end;
            end;
         finally
            QryResultBackup.Close; ;
         end;
         Label2.Caption := '8 '; Label2.Update;
         QryResultBackup.ParamByName('NOM').AsString := 'T-' + QryBaseBAS_ID.AsString;
         QryResultBackup.Open;
         try
            if not QryResultBackup.IsEmpty then
            begin
               if QryResultBackupDOS_FLOAT.AsFloat < 1 then
               begin
                  LbProb.items.Add(Format('Client %-20.20s Base %-20.20s - %s  Prob Calc Trigger',
                     [S, QryBaseBAS_NOM.AsString, QryResultBackupDOS_STRING.AsString]));

               end;
            end;
         finally
            QryResultBackup.Close;
         end;
         QryBase.Next;
      end;
      Label2.Caption := '9 '; Label2.Update;
      QryBase.Close;
      Data.Close;
      Label1.Caption := '';
   except
      raise;
   end;
end;

procedure TFrm_VerifBackup.ClientConnect(Sender: TObject;
   Socket: TCustomWinSocket);
begin
   Socket.SendText('@@@;' + EnvoieStr);
end;

procedure TFrm_VerifBackup.ClientDisconnect(Sender: TObject;
   Socket: TCustomWinSocket);
begin
   Fini := true;
end;

procedure TFrm_VerifBackup.ClientError(Sender: TObject;
   Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
   var ErrorCode: Integer);
begin
   Lab2.caption := 'Err :' + Inttostr(ErrorCode);
   ErrorCode := 0;
   Plusdeclient := true;
   fini := true;
end;

procedure TFrm_VerifBackup.ClientRead(Sender: TObject;
   Socket: TCustomWinSocket);
begin
   RecuStr := Socket.ReceiveText;
   Socket.close;
   fini := true;
end;

procedure TFrm_VerifBackup.Serveur1Click(Sender: TObject);
var
   Frm_ChxString: TFrm_ChxString;
begin
   Application.CreateForm(TFrm_ChxString, Frm_ChxString);
   try
      Frm_ChxString.Edit1.Text := Serveur;
      Frm_ChxString.Caption := 'Serveur du LiveUpdate';
      if Frm_ChxString.ShowModal = MrOk then
      begin
         Serveur := Uppercase(Frm_ChxString.Edit1.Text);
         SauveIni;
      end;
   finally
      Frm_ChxString.Release;
   end;
end;

procedure TFrm_VerifBackup.Port1Click(Sender: TObject);
var
   Frm_ChxString: TFrm_ChxString;
begin
   Application.CreateForm(TFrm_ChxString, Frm_ChxString);
   try
      Frm_ChxString.Edit1.Text := Port;
      Frm_ChxString.Caption := 'Port du LiveUpdate';
      if Frm_ChxString.ShowModal = MrOk then
      begin
         Port := Uppercase(Frm_ChxString.Edit1.Text);
         SauveIni;
      end;
   finally
      Frm_ChxString.Release;
   end;
end;

procedure TFrm_VerifBackup.LbDrawItem(Control: TWinControl; Index: Integer;
   Rect: TRect; State: TOwnerDrawState);
var
   i: integer;
   s: string;
begin
   if Index < lb.items.Count then
   begin
      i := integer(lb.items.objects[Index]);
      if i = 10 then
      begin
         lb.canvas.font.color := clblack;
         lb.canvas.brush.color := ClWhite;
      end
      else if i = -10 then
      begin
         lb.canvas.font.color := clSilver;
         lb.canvas.brush.color := ClWhite;
      end
      else if i in [0, 1] then
      begin
         S := lb.items[Index];
         delete(s, 1, length('Client                      Base                      - '));
         S := trim(S);
         S := Copy(S, 1, pos(' ', S) - 1);
         if StrToDate(S) + 4 < Date then
         begin
            lb.canvas.font.color := clBlack;
            lb.canvas.brush.color := ClRed;
         end
         else
         begin
            lb.canvas.font.color := clBlack;
            lb.canvas.brush.color := ClLime;
         end;
      end
      else
      begin
         lb.canvas.font.color := clMaroon;
         lb.canvas.brush.color := ClWhite;
      end;
      lb.canvas.TextRect(Rect, Rect.left, rect.top, lb.items[Index]);
   end;
end;

procedure TRechBase.EcritCherche;
begin
   Frm_VerifBackup.Lab.Caption := Cherche;
   Frm_VerifBackup.Lab.Update;
end;

procedure TFrm_VerifBackup.SauveClick(Sender: TObject);
begin
   if sd.execute then
   begin
      LbProb.Items.SaveToFile(sd.filename);
   end;
end;

end.

