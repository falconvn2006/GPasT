unit ChxMagasin_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLstBox, LMDBaseControl, LMDBaseGraphicControl, LMDBaseGraphicButton, LMDCustomSpeedButton,
  LMDSpeedButton, RzLabel, ExtCtrls, RzPanel, IniFiles;

type
  TFrm_ChxMagasin = class(TForm)
    Pan_fenetre: TRzPanel;
    Pan_decision: TRzPanel;
    Pan_ok: TRzPanel;
    Pan_annuler: TRzPanel;
    Nbt_Annuler: TLMDSpeedButton;
    Chk_Choix: TRzEditListBox;
    Nbt_Ok: TLMDSpeedButton;
    Pan_titre: TRzPanel;
    Lab_Fusion: TRzLabel;
    procedure FormShow(Sender: TObject);
    procedure Nbt_AnnulerClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Nbt_OkClick(Sender: TObject);
    procedure Chk_ChoixDblClick(Sender: TObject);
    procedure Chk_ChoixKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Déclarations privées }
    Iselect    : Integer;
    ListeMag   : TStringList;
    CheminMag  : TStringList;
    procedure chargeIni(Chemin : string);
    procedure ChargeDatabase(CheminBase : string);
    procedure SelectedMagasin;
  public
    { Déclarations publiques }
  end;

var
  Frm_ChxMagasin: TFrm_ChxMagasin;

implementation

uses
  Main_Dm,
  Main_Frm;

{$R *.dfm}

procedure TFrm_ChxMagasin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //libération de la mémoire
  ListeMag.Free;
end;

procedure TFrm_ChxMagasin.FormShow(Sender: TObject);
begin
  //affichage de la fenetre au centre de l'ecran
  Self.Top  := (Screen.Height-Height) div 2;
  Self.Left := (Screen.Width-Width)   div 2;

  //Je vais chercher si le fichier Ini exist
  try
    if not DirectoryExists('c:\Ginkoia\') then
    begin
      //si le dossier ginkoia sur le disque c exist pas on va chercher sur le d
      if not DirectoryExists('d:\Ginkoia\') then
      begin
        ShowMessage('Dossier d''installation de Ginkoia est Introuvable');
        Self.Close;
      end else
      begin
        //charge le bon chemin pour connecter la base de donnée
        ChargeDatabase('d:\Ginkoia\');
        //dossier sur D:\ trouver on charge l'ini
        chargeIni('d:\Ginkoia\ginkoia.ini');
      end;
    end else
      begin
        //charge le bon chemin pour connecter la base de donnée
        ChargeDatabase('c:\Ginkoia\');
        //dossier sur C:\ trouver on charge l'ini
        chargeIni('c:\Ginkoia\ginkoia.ini');
      end;
  except on e:Exception do
    begin
      ShowMessage(e.Message);
    end;
  end;

end;

procedure TFrm_ChxMagasin.Nbt_AnnulerClick(Sender: TObject);
begin
  //clique on quitte le programme
  Self.Close;
end;

procedure TFrm_ChxMagasin.Nbt_OkClick(Sender: TObject);
begin
  //selection du magasin
  SelectedMagasin;
end;

procedure TFrm_ChxMagasin.SelectedMagasin;
begin
  //on a selectionner un magasin on affiche la form principal
  if Chk_Choix.ItemIndex <> -1 then
  begin
    //on affiche la form principal
    Self.Hide;
    TFrm_Main.ExecuteFRM_Main(True,ListeMag.ValueFromIndex[Chk_Choix.ItemIndex]);
  end;
end;

procedure TFrm_ChxMagasin.ChargeDatabase(CheminBase: string);
begin
  //chargement du chemin de la base de donnée et connection
  Dm_Main.IbC_Database.Path := CheminBase+'data\ginkoia.ib';
  try
    Dm_Main.IbC_Database.Connect;
    Dm_Main.IbC_Database.KeepConnection := True;
  except on e:Exception do
    begin
      //si erreur de connection on affiche l'erreur puis on ferme le programme
      MessageDlg(e.Message,mtError,mbOKCancel,0);
      Self.Close;
    end;
  end;
end;

procedure TFrm_ChxMagasin.chargeIni(Chemin : string);
var
 FicIni     : TIniFile;
 IniChemin  : string;
 NbLigneSec : Integer;
 i          : Integer;
begin
  try
    ListeMag := TStringList.Create;
    //procedure qui permet de charger le fichier ini
    FicIni := TIniFile.Create(Chemin);
    //une fois le fichier ini ouvert on fait le traitement  de remplissage de la TlistBox
    FicIni.ReadSectionValues('NOMMAGS', ListeMag);
    //nettoie items
    for I := 0 to ListeMag.Count-1 do
    begin
      Chk_Choix.Add(ListeMag.ValueFromIndex[i]);
    end;
  finally
    FicIni.Free;
  end;
end;

procedure TFrm_ChxMagasin.Chk_ChoixDblClick(Sender: TObject);
begin
    SelectedMagasin;
end;

procedure TFrm_ChxMagasin.Chk_ChoixKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  //touche entrée
  if Key = VK_RETURN then
  begin
    SelectedMagasin;
  end;
end;

end.
