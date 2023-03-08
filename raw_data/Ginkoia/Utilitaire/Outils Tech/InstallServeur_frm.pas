unit InstallServeur_frm;

interface

uses
   SevenZip, UInstall, UBase,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Buttons, StdCtrls, ComCtrls, Registry, StdActns, IniFiles, UVersion,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, DateUtils,
  IdAntiFreezeBase, IdAntiFreeze;

type
   TFrm_InstallServeur = class(TForm)
      Edit1: TEdit;
      Label1: TLabel;
      SpeedButton1: TSpeedButton;
      OD: TOpenDialog;
      pg: TPageControl;
      dez: TTabSheet;
      inst: TTabSheet;
      Pb1: TProgressBar;
      SpeedButton2: TSpeedButton;
      Lab_Etat: TLabel;
      Label2: TLabel;
      CB_MAG: TComboBox;
      cb_poste: TComboBox;
      Label3: TLabel;
      SpeedButton3: TSpeedButton;
    edt_DirGinkoia: TEdit;
    Label4: TLabel;
    cmd_DirGinkoia: TBitBtn;
    Lab_Maj: TLabel;
    edt_Lame: TEdit;
    IdHTTP: TIdHTTP;
    Lab_DL: TLabel;
    IdAntiFreeze1: TIdAntiFreeze;
      procedure SpeedButton1Click(Sender: TObject);
      procedure Edit1Change(Sender: TObject);
      procedure SpeedButton2Click(Sender: TObject);
      procedure CB_MAGClick(Sender: TObject);
      procedure SpeedButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmd_DirGinkoiaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure IdHTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
   private
    { Déclarations privées }
    FMax : Cardinal;
    FStartDate : TDateTime;
   public
    { Déclarations publiques }
      Install: TInstall;
      procedure OnZipProgress(Sender: TObject; Percent: Integer);
      procedure OnMagasin(Sender: TObject; Magasin: string);
      procedure OnPoste(Sender: TObject; Poste: string);
      PROCEDURE OnPatch(Sender: TObject; Action: string; actu, max: Integer) ;
   end;

var
   Frm_InstallServeur: TFrm_InstallServeur;

implementation

{$R *.DFM}

procedure TFrm_InstallServeur.SpeedButton1Click(Sender: TObject);
var
  FS : TFileStream;
  sTmpDir : String;
  sFileName : String;
begin
  pg.Enabled := False;
  try
    // Si lien HTTP
    if Pos('http://', Lowercase(edit1.Text)) = 1 then
    begin
      Lab_DL.Visible := True;
      sTmpDir := ExtractFilePath(Application.ExeName) + '\tmp\';
      ForceDirectories(sTmpdir);
      sFileName := Copy(Edit1.Text, LastDelimiter('/',Edit1.Text) + 1, Length(Edit1.Text));
      FS := TFileStream.Create(sTmpDir + sFileName,fmCreate);
      IdHTTP.Get(Edit1.text,FS);
      Showmessage('Telechargement fini');
      Edit1.Text := sTmpDir + sFileName;
    end
    else
     // Sinon on utilise le fonctionnement standard
     if od.Execute then
        Edit1.text := od.filename;
  finally
    Lab_DL.Visible := False;
    pg.Enabled := True;
  end;
end;

procedure TFrm_InstallServeur.cmd_DirGinkoiaClick(Sender: TObject);
var
  bf : TBrowseForFolder;
begin
  bf := TBrowseForFolder.Create(Self);
  try
    bf.Caption := 'Sélectionner le répertoire ginkoia';
    bf.BrowseOptions := [bifNoTranslateTargets,bifNewDialogStyle]; // bifShareable
    if bf.Execute then
      edt_DirGinkoia.Text := IncludeTrailingPathDelimiter(bf.Folder);
  finally
    bf.Free;
  end;
end;

procedure TFrm_InstallServeur.Edit1Change(Sender: TObject);
begin
   if fileexists(edit1.text) then
   begin
      pg.ActivePage := dez;
      Pb1.Position := 0;
      Lab_Etat.Caption := '';
      pg.visible := true;
   end
   else
      pg.visible := false;
end;

procedure TFrm_InstallServeur.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  With TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Install.ini') do
  try
    WriteString('GK','PATH',edt_DirGinkoia.Text);
    WriteString('LAME','PATH',edt_Lame.Text);
  finally
    Free;
  end;
end;

procedure TFrm_InstallServeur.FormCreate(Sender: TObject);
var
  Reg : TRegistry;
begin
  Caption := Caption + ' ' +  GetNumVersionSoft;

  Reg := TRegistry.Create;
  Try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.Access := KEY_WOW64_32KEY or KEY_QUERY_VALUE;
    If Reg.OpenKeyReadOnly('\SOFTWARE\GINKOIA') then
    Begin
      edt_DirGinkoia.Text := IncludeTrailingPathDelimiter(Reg.ReadString('InstallDir'));
    End
    Else begin
      edt_DirGinkoia.Text := 'c:\ginkoia\';
    end;
  Finally
    Reg.Free;
  End;

  With TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Install.ini') do
  try
     edt_Lame.Text := ReadString('LAME','PATH','http://lame2.no-ip.com/maj/');
  finally
    Free;
  end;

end;

procedure TFrm_InstallServeur.IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
Var
  ElapsedTime : Cardinal;
begin
  if AWorkMode=wmRead then //Uniquement pendant la réception de données
  begin
    if FMax > 0 then
    begin
      ElapsedTime := SecondsBetween(Now,FStartDate); //Calculer le temps de téléchargement
      if ElapsedTime>0 then
        Lab_DL.Caption := Format('%3.2f%s - %8.2fk/s',[(AWorkCount * 100 / FMax),'%',(AWorkCount/1024/ElapsedTime)]);
    end;
  end;
  Application.ProcessMessages;

end;

procedure TFrm_InstallServeur.IdHTTPWorkBegin(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  if AWorkMode = wmRead then
  begin
    FMax := AWorkCountMax;
    FStartDate := Now;
  end;
  Application.ProcessMessages;
end;

procedure TFrm_InstallServeur.SpeedButton2Click(Sender: TObject);
var
   BaseTest: TBaseTest;
begin
  if trim(edt_DirGinkoia.Text) = '' then
  begin
    ShowMessage('Veuillez sélectionner le répertoire d''installation de ginkoia');
    Exit;
  end;

   screen.cursor := crHourGlass;
   Enabled := false;
   try
      Edit1.enabled := false;
      {}
      SpeedButton1.enabled := false;
      Lab_Etat.Caption := 'Extraction des données'; Lab_Etat.Update;
      LoadSevenZipDLL;
      SevenZipExtractArchive(application.Handle,
                              edit1.text,
                              '"*.*"',
                              True,
                              '1082',
                              True,
                              edt_DirGinkoia.Text, // 'C:\Ginkoia\',
                              True);

      UnloadSevenZipDLL;
      Lab_Etat.Caption := 'Référencement de la base'; Lab_Etat.Update;
      {}
      Install := TInstall.create(self);
      Install.Disk := edt_DirGinkoia.Text[1];
      Install.DirGinkoia := edt_DirGinkoia.Text;
      Install.DirBase := edt_DirGinkoia.Text + 'data\';
      Install.Referencement(edt_DirGinkoia.Text + 'data\ginkoia.ib');  // 'c:\ginkoia\data\
      {}
      Install.SetPathBPL;
//      Lab_Etat.Caption := 'Fabrication de la base test, patience ...'; Lab_Etat.Update;
//      BaseTest := TBaseTest.Create(self);
//      BaseTest.Creation;
//      BaseTest.free;
      {}
      install.Connexion(edt_DirGinkoia.Text + 'data\ginkoia.ib'); // c:\ginkoia\data\

      Install.OnNotifyMagasin := OnMagasin;
      Install.OnNotifyPoste := OnPoste;
      CB_MAG.Items.Clear;
      Install.ListeMagasin;
      CB_MAG.ItemIndex := 0;
      cb_Poste.Clear;
      if cb_Mag.ItemIndex > -1 then
         Install.ListePoste(cb_Mag.Items[cb_Mag.ItemIndex]);

      pg.ActivePage := inst;
   finally
      screen.cursor := crDefault;
      Enabled := true;
   end;
end;

procedure TFrm_InstallServeur.OnZipProgress(Sender: TObject;
   Percent: Integer);
begin
   Pb1.Position := Percent;
   Application.ProcessMessages;
end;

procedure TFrm_InstallServeur.OnMagasin(Sender: TObject; Magasin: string);
begin
   CB_MAG.Items.add(Magasin);
end;

procedure TFrm_InstallServeur.OnPoste(Sender: TObject; Poste: string);
begin
   cb_poste.Items.add(Poste);
   if poste = 'SERVEUR' then
      cb_Poste.ItemIndex := cb_poste.Items.count - 1;
end;

procedure TFrm_InstallServeur.CB_MAGClick(Sender: TObject);
begin
   cb_Poste.Clear;
   if cb_Mag.ItemIndex > -1 then
      Install.ListePoste(cb_Mag.Items[cb_Mag.ItemIndex]);
end;

procedure TFrm_InstallServeur.SpeedButton3Click(Sender: TObject);
{}
var
  PatchScript : TPatchScript ;
{}
begin
   if (cb_Mag.ItemIndex > -1) and
      (cb_poste.ItemIndex > -1) then
   begin
      screen.cursor := crHourGlass;
      try
         Install.SetPathBPL;
         Install.CreerINIServeur(cb_Mag.items[cb_Mag.itemindex], cb_Poste.items[cb_Poste.itemindex]);
         Install.free;
         {}
         PatchScript := TPatchScript.create(self) ;
         PatchScript.DirGinkoia := IncludeTrailingPathDelimiter(edt_DirGinkoia.Text);
         PatchScript.DirBase := PatchScript.DirGinkoia + 'data\';
         PAtchScript.Lame := edt_Lame.Text;
         PatchScript.Connexion(PatchScript.DirBase + 'ginkoia.ib',true); // c:\ginkoia\data\
         PatchScript.ActionProgress := OnPatch ;
         PatchScript.Script ;
         PatchScript.Patch ;
         PatchScript.free ;
         {}
      finally
         screen.cursor := crDefault;
      end;
      application.MessageBox('Merci pour votre patience', 'Fin', MB_OK);
      Close;
   end;
end;

procedure TFrm_InstallServeur.OnPatch(Sender: TObject; Action: string;
  actu, max: Integer);
begin
   pb1.Max := max ;
   Pb1.Position := actu;
   Lab_Etat.Caption := Action ; Lab_Etat.Update;
   Application.ProcessMessages;
end;

end.

