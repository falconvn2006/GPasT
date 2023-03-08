unit UnitPrincipale;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, ExtCtrls, RzPanel, DB, ADODB,UnitThread, StdCtrls,
  ComCtrls, IB_Components, IBODataset, wwDialog, wwidlg, wwLookupDialogRv,
  RzLabel, Mask, wwdbedit, Wwdotdot, Wwdbcomb, wwDBComboBoxRv, RzEdit, RzDBEdit,
  RzDBBnEd, RzDBButtonEditRv, DBClient, dxCntner, dxTL, dxDBCtrl, dxDBGrid;

type
  TFrm_Principale = class(TForm)
    Pan_fond: TRzPanel;
    Pan_Cmd: TRzPanel;
    Tim_Refresh: TTimer;
    Btn_Start: TButton;
    Btn_Stop: TButton;
    Btn_Quit: TButton;
    PgB_Traitement: TProgressBar;
    Lab_Cpt: TLabel;
    Lab_NbMat: TLabel;
    Pan_Haut: TRzPanel;
    Pan_Titre: TRzPanel;
    Lab_Titre: TRzLabel;
    Lab_BdDSource: TLabel;
    Chp_BdDSource: TEdit;
    OD_BdDSource: TOpenDialog;
    Btn_BdDSource: TButton;
    Pan_Info: TRzPanel;
    Lab_Info: TRzLabel;
    Pan_Grille: TRzPanel;
    StringGrid1: TStringGrid;
    Lab_BdDGinkoia: TLabel;
    Chp_BdDGinkoia: TEdit;
    Btn_BdDGinkoia: TButton;
    Ginkoia: TIB_Connection;
    procedure Tim_RefreshTimer(Sender: TObject);
    procedure Btn_StartClick(Sender: TObject);
    procedure Btn_StopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Btn_QuitClick(Sender: TObject);
    procedure Btn_BdDSourceClick(Sender: TObject);
    procedure Btn_BdDGinkoiaClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_Principale: TFrm_Principale;
  Transpo       : TTranspoThread;

implementation
{$R *.dfm}

procedure TFrm_Principale.Btn_BdDGinkoiaClick(Sender: TObject);
begin
  OD_BdDSource.Filter     := 'fichier ib|*.ib';
  OD_BdDSource.FileName   := Chp_BdDGinkoia.Text;
  OD_BdDSource.Execute;
  Chp_BdDGinkoia.Text     := OD_BdDSource.FileName;
  Ginkoia.Connected       := False;
  Ginkoia.DatabaseName    := Chp_BdDGinkoia.Text;
  Ginkoia.Connected       := True;
end;

procedure TFrm_Principale.Btn_BdDSourceClick(Sender: TObject);
begin
  OD_BdDSource.Filter             := 'fichier csv|*.csv';
  OD_BdDSource.FileName           := Application.ExeName;
  OD_BdDSource.Execute;
  Chp_BdDSource.Text              := OD_BdDSource.FileName;
  ChemSource                      := Chp_BdDSource.Text;
end;

procedure TFrm_Principale.Btn_QuitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_Principale.Btn_StartClick(Sender: TObject);
begin
  //Contrôle les connections aux bases de données
  if (Not FileExists(ChemSource)) then
    Begin
      MessageDlg('Problème d''accès au fichier csv',mtInformation,[mbOK],0);
      exit;
    End;
  if (Not Ginkoia.Connected) then
    Begin
      MessageDlg('Aucune base de données n''est connectée.',mtInformation,[mbOK],0);
      exit;
    End;
  Btn_Start.enabled := False;
  Btn_Quit.enabled  := False;
  Stop              := False;
  Start             := True;
  Btn_Stop.enabled  := True;
end;

procedure TFrm_Principale.Btn_StopClick(Sender: TObject);
begin
  Btn_Stop.enabled  := False;
  Stop              := True;
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
  DecimalSeparator   := '.';
  LibInfo            := 'Cliquez sur Start pour commencer la transpo';
  ChemSource         := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  Chp_BdDSource.Text := ChemSource;
end;

procedure TFrm_Principale.Tim_RefreshTimer(Sender: TObject);
begin
  //Réinitialisation une fois le traitement terminé
  if (NbLigne=-1) then
    Begin
      NbLigne           := 0;
      Btn_Stop.enabled  := False;
      Stop              := False;
      Start             := False;
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
