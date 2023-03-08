unit UnitPrincipale;

interface

uses
  Windows, SysUtils, Forms, Dialogs, ExtCtrls, Controls, Classes, Grids,
  //Début Uses Perso
  UnitThread,
  //Fin Uses Perso
  StdCtrls, ComCtrls, AdvEdit, AdvEdBtn, AdvDirectoryEdit;

type
  TFrm_Principale = class(TForm)
    Tim_Refresh: TTimer;
    Pan_fond: TPanel;
    Lab_Cpt: TLabel;
    Lab_NbMat: TLabel;
    PgB_Traitement: TProgressBar;
    Pan_Cmd: TPanel;
    Btn_Start: TButton;
    Btn_Stop: TButton;
    Btn_Quit: TButton;
    Pan_Haut: TPanel;
    Lab_BdDSource: TLabel;
    Rgr_Type_Transpo: TRadioGroup;
    Chp_BdDSource: TAdvDirectoryEdit;
    Gbx_Liste_OP: TGroupBox;
    Chk_Vente: TCheckBox;
    Chk_Client: TCheckBox;
    Chk_Location: TCheckBox;
    Gbx_Eram96: TGroupBox;
    Lab_Quantieme: TLabel;
    Lab_NumMagasin: TLabel;
    Ed_Quantieme: TEdit;
    Ed_NumMagasin: TEdit;
    Chk_Header: TCheckBox;
    Pan_Titre: TPanel;
    Lab_Titre: TLabel;
    Pan_Info: TPanel;
    Lab_Info: TLabel;
    Pan_Grille: TPanel;
    StringGrid1: TStringGrid;
    procedure Tim_RefreshTimer(Sender: TObject);
    procedure Btn_StartClick(Sender: TObject);
    procedure Btn_StopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Btn_QuitClick(Sender: TObject);
    procedure Ed_QuantiemeKeyPress(Sender: TObject; var Key: Char);
    procedure Ed_NumMagasinKeyPress(Sender: TObject; var Key: Char);
    //procedure Btn_BdDSourceClick(Sender: TObject);
  private
    { Déclarations privées }
    //procedure UpdateFrm();
  public
    { Déclarations publiques }
    function GetQuantieme:string;
    function GetNumMagasin:string;
    function GetAddHeader:Boolean;
  end;



var
  Frm_Principale: TFrm_Principale;
  Transpo       : TTranspoThread;

implementation
{$R *.dfm}

//procedure TFrm_Principale.Btn_BdDSourceClick(Sender: TObject);
//begin
//  OD_BdDSource.FileName           := Application.ExeName;
//  OD_BdDSource.Execute;
//  Chp_BdDSource.Text              := IncludeTrailingPathDelimiter(extractfilepath(OD_BdDSource.FileName));
//  ChemSource                      := Chp_BdDSource.Text;
//end;

procedure TFrm_Principale.Btn_QuitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_Principale.Btn_StartClick(Sender: TObject);
begin
  //Contrôle les connections aux bases de données
  ChemSource  := Chp_BdDSource.Text + '\';
  if (Not DirectoryExists(ChemSource)) then
    Begin
      MessageDlg('Problème de Connexion, vérifier l''accès aux fichiers csv',mtInformation,[mbOK],0);
      exit;
    End;
  Transpo.SetTypeTranspo(Rgr_Type_Transpo.ItemIndex);

  Transpo.SetDoClient(Chk_Client.Checked);
  Transpo.SetDoVente(Chk_Vente.Checked);
  Transpo.SetDoLocation(Chk_Location.Checked);

  Btn_Start.enabled         := False;
  Btn_Quit.enabled          := False;
  Rgr_Type_Transpo.Enabled  := False;
  StopImport                := False;
  StartImport               := True;
  Btn_Stop.enabled          := True;
end;

procedure TFrm_Principale.Btn_StopClick(Sender: TObject);
begin
  Btn_Stop.enabled  := False;
  StopImport        := True;
end;

procedure TFrm_Principale.Ed_NumMagasinKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(key, ['0'..'9',#8]) then
    key:=#0;

  if (Length(Ed_NumMagasin.Text) >= 2) and (key <> #8) then
    key:=#0;
end;

procedure TFrm_Principale.Ed_QuantiemeKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(key,['0'..'9',#8]) then
    key:=#0;

  if (Length(Ed_Quantieme.Text) >= 3) and (key <> #8) then
    key:=#0;
end;

procedure TFrm_Principale.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  Transpo.Suspend;
end;

procedure TFrm_Principale.FormCreate(Sender: TObject);
begin
  //Start du thread
  Transpo.Resume;

  //Initialisation de variable
  FormatSettings.DecimalSeparator   := '.';
  LibInfo            := 'Cliquez sur Start pour commencer la transpo';
  ChemSource         := ExtractFilePath(Application.ExeName)+'Source\';
  Chp_BdDSource.Text := ChemSource;
end;

function TFrm_Principale.GetAddHeader: Boolean;
begin
  Result := Chk_Header.Checked;
end;

function TFrm_Principale.GetNumMagasin: string;
begin
  Result := Ed_NumMagasin.Text;
end;

function TFrm_Principale.GetQuantieme: string;
begin
  Result := Ed_Quantieme.Text;
end;

procedure TFrm_Principale.Tim_RefreshTimer(Sender: TObject);
begin
  //Réinitialisation une fois le traitement terminé
  if (NbLigne=-1) then
    Begin
      NbLigne           := 0;
      Btn_Stop.enabled  := False;
      StopImport        := False;
      StartImport       := False;
      Btn_Start.enabled := True;
      Btn_Quit.enabled  := True;
    End;

  //Raffraichi l'affichage
  Lab_Info.caption        := LibInfo;
  PgB_Traitement.Min      := 0;
  PgB_Traitement.Max      := NbLigne;
  PgB_Traitement.Position := Compteur;
  Lab_Cpt.caption := IntToStr(Compteur) + ' / ' + IntToStr(NbLigne);

end;

initialization
  Transpo :=  TTranspoThread.Create(true);
finalization
  Transpo.Free;

end.
