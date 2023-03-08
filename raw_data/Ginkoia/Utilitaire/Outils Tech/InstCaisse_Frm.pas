unit InstCaisse_Frm;

interface

uses
   UInstall,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, ExtCtrls, Buttons, IniFiles, registry, StdActns, uVersion,
   uLogfile;

type
  TFrm_InstCaisse = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Lb_Magasin: TComboBox;
    Lb_Poste: TComboBox;
    Panel: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Edt_Base: TEdit;
    Lab_Base: TLabel;
    Nbt_Base: TBitBtn;
    Nbt_Connexion: TBitBtn;
    edt_Serveur: TEdit;
    Lab_serveur: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Lb_MagasinClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Nbt_ConnexionClick(Sender: TObject);
    procedure Nbt_BaseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  public
    first: Boolean;
    Install: TInstall;
    NomDuPoste: string;
    procedure Initialisation;
    procedure OnMagasin(Sender: TObject; Magasin: string);
    procedure OnPoste(Sender: TObject; Poste: string);
  end;

var
   Frm_InstCaisse: TFrm_InstCaisse;

implementation

{$R *.DFM}

procedure TFrm_InstCaisse.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Tlogfile.Reset ;
end;

procedure TFrm_InstCaisse.FormCreate(Sender: TObject);
var
  Reg : TRegistry;
begin

  Tlogfile.InitLog(False); // en mode LILO
  

  Caption := Caption + ' ' +  GetNumVersionSoft;


  Install := TInstall.Create(Self);

  Reg := TRegistry.Create;
  Try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.Access := KEY_WOW64_32KEY or KEY_QUERY_VALUE;
    If Reg.OpenKeyReadOnly('\SOFTWARE\GINKOIA') then
      Edt_Base.Text := IncludeTrailingPathDelimiter(Reg.ReadString('InstallDir')) + 'data\';
  Finally
    Reg.Free;
  End;

  if Trim(Edt_Base.Text) = '' then
    With TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Install.ini') do
    try
      Install.DirGinkoia := IncludeTrailingPathDelimiter( ReadString('GK','PATH',''));
      Install.DirBase := IncludeTrailingPathDelimiter( Install.DirGinkoia) + 'data\';
    finally
      Free;
    end;
  //  Install.Serveur := 'Pascal_Fix';
//  first := true;
end;

procedure TFrm_InstCaisse.FormDestroy(Sender: TObject);
begin
  Install.Ferme;
  Install.free;
end;

procedure TFrm_InstCaisse.FormPaint(Sender: TObject);
begin
//  if first then
//  begin
//     first := false;
//     Update;
//     Initialisation;
//  end;
end;

procedure TFrm_InstCaisse.Initialisation;
begin
  Screen.Cursor := CrHourGlass;
  try
     Tlogfile.Addline (Datetimetostr(Now)+' Serveur de la base de données : '+IncludeTrailingPathDelimiter(Edt_Serveur.Text));
     Tlogfile.Addline(Datetimetostr(Now)+' Chemin d''installation de Ginkoia : '+IncludeTrailingPathDelimiter(Edt_Base.Text));
     Install.DirGinkoia := IncludeTrailingPathDelimiter(Edt_Base.Text);
     Install.DirBase := Install.DirGinkoia + 'data\';
     Install.Serveur := edt_serveur.Text ;  // ajouté par RD le 18/01
     Install.GetMagasinSurServeur;
     NomDuPoste := Install.GetNomPoste;
     Install.OuvreServeur;
     Install.OnNotifyMagasin := OnMagasin;
     Install.OnNotifyPoste := OnPoste;
     Lb_Magasin.Clear;
     Install.ListeMagasin;
     Lb_Poste.Clear;
     if Lb_Magasin.ItemIndex > -1 then
        Install.ListePoste(Lb_Magasin.Items[Lb_Magasin.ItemIndex]);
     Tlogfile.Addline (Datetimetostr(Now)+' Base connectée');
        
     Showmessage('Base connectée') ;   
  finally
     Screen.Cursor := CrDefault;
  end;
end;

procedure TFrm_InstCaisse.Lb_MagasinClick(Sender: TObject);
begin
  Lb_Poste.Clear;
  if Lb_Magasin.ItemIndex > -1 then
     Install.ListePoste(Lb_Magasin.Items[Lb_Magasin.ItemIndex]);
end;

procedure TFrm_InstCaisse.Nbt_BaseClick(Sender: TObject);
var
  bf : TBrowseForFolder;
begin
  bf := TBrowseForFolder.Create(Self);
  try
    bf.Caption := 'Sélectionner le répertoire d''installation de ginkoia';
    bf.BrowseOptions := [bifNoTranslateTargets,bifNewDialogStyle]; // bifShareable
    if bf.Execute then
      Edt_Base.Text := IncludeTrailingPathDelimiter(bf.Folder);
  finally
    bf.Free;
  end;
end;

procedure TFrm_InstCaisse.Nbt_ConnexionClick(Sender: TObject);
var sTest : string ;
begin
  if (trim(Edt_Base.Text) <> '') then //and (trim(edt_serveur.Text) <>'') then
  begin
    sTest := IncludeTrailingBackslash(edt_base.text)+'DATA\GINKOIA.IB' ;
    if FileExists(sTest) = false then
     begin
       Showmessage('Le chemin d''installation de ginkoia n''est pas valide') ;
       exit ;
     end;
    
    Initialisation;
  end;
end;

procedure TFrm_InstCaisse.OnMagasin(Sender: TObject; Magasin: string);
begin
  Lb_Magasin.Items.add(Magasin);
  if Magasin = Install.MagasinSurServeur then
     Lb_Magasin.ItemIndex := Lb_Magasin.Items.count - 1;
end;

procedure TFrm_InstCaisse.OnPoste(Sender: TObject; Poste: string);
begin
  Lb_poste.Items.add(Poste);
  if NomDuPoste = Poste then
     Lb_Poste.ItemIndex := Lb_poste.Items.count - 1;
end;

procedure TFrm_InstCaisse.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrm_InstCaisse.SpeedButton2Click(Sender: TObject);
var sFile : string ;
begin
  if (Lb_Magasin.ItemIndex > -1) and
     (Lb_poste.ItemIndex > -1) then
  begin
    Tlogfile.Addline (Datetimetostr(Now)+' Magasin : '+lb_Magasin.Text);
    Tlogfile.Addline (Datetimetostr(Now)+' Poste   : '+lb_Poste.Text);    
    Install.SetPathBPL ;
    Install.CreerIniPoste(Lb_Magasin.items[Lb_Magasin.itemindex],Lb_Poste.items[Lb_Poste.itemindex]) ;
    Install.CreerIconPoste ;
    Tlogfile.Addline(Datetimetostr(Now)+' Fin de l''installation') ;
    sFile := IncludeTrailingBackslash(Extractfilepath(paramstr(0))) ; 
    sFile := sFile+'InstalPoste.txt' ;
    Tlogfile.SaveToFile(sFile) ; 
    Close ;
  end;
end;

end.


