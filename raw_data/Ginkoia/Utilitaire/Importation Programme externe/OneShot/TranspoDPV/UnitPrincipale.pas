unit UnitPrincipale;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, ExtCtrls, RzPanel, DB, ADODB,UnitThread, StdCtrls,
  ComCtrls, IB_Components, IBODataset, wwDialog, wwidlg, wwLookupDialogRv,
  RzLabel, Mask, wwdbedit, Wwdotdot, Wwdbcomb, wwDBComboBoxRv, RzEdit, RzDBEdit,
  RzDBBnEd, RzDBButtonEditRv;

type
  TFrm_Principale = class(TForm)
    ADOConnection: TADOConnection;
    Pan_fond: TRzPanel;
    Pan_Cmd: TRzPanel;
    Tim_Refresh: TTimer;
    Btn_Start: TButton;
    Btn_Stop: TButton;
    Btn_Quit: TButton;
    PgB_Traitement: TProgressBar;
    Ginkoia: TIB_Connection;
    Lab_Cpt: TLabel;
    Lab_NbMat: TLabel;
    Pan_Haut: TRzPanel;
    Pan_Titre: TRzPanel;
    Lab_Info: TRzLabel;
    Que_Mag: TIBOQuery;
    Que_MagMAG_ID: TIntegerField;
    Que_MagMAG_ENSEIGNE: TStringField;
    LK_MAG: TwwLookupDialogRV;
    Ds_Mag: TDataSource;
    Lab_BdDSource: TLabel;
    Chp_BdDSource: TEdit;
    OD_BdDSource: TOpenDialog;
    Lab_BdDGinkoia: TLabel;
    Btn_BdDSource: TButton;
    Btn_BdDGinkoia: TButton;
    Chp_Mag: TRzDBButtonEditRv;
    Lab_Mag: TLabel;
    Chp_BdDGinkoia: TEdit;
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
  OD_BdDSource.FileName   := Chp_BdDGinkoia.Text;
  OD_BdDSource.Execute;
  Chp_BdDGinkoia.Text     := OD_BdDSource.FileName;
  Ginkoia.Connected       := False;
  Ginkoia.DatabaseName    := Chp_BdDGinkoia.Text;
  Ginkoia.Connected       := True;
end;

procedure TFrm_Principale.Btn_BdDSourceClick(Sender: TObject);
begin
  OD_BdDSource.FileName           := Application.ExeName;
  OD_BdDSource.Execute;
  Chp_BdDSource.Text              := OD_BdDSource.FileName;
  ADOConnection.Connected         := False;
  ADOConnection.ConnectionString  := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+Chp_BdDSource.Text+';Persist Security Info=False';
  ADOConnection.Connected         := True;
end;

procedure TFrm_Principale.Btn_QuitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_Principale.Btn_StartClick(Sender: TObject);
begin
  //Contrôle les connections aux bases de données
  if (Not Ginkoia.Connected) or (Not ADOConnection.Connected) then
    Begin
      MessageDlg('Problème de Connexion, vérifier l''accès aux bases de données',mtInformation,[mbOK],0);
      exit;
    End;
  Btn_Start.enabled := False;
  Btn_Quit.enabled  := False;
  MAGID             := Que_Mag.FieldByName('MAG_ID').asInteger;
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
  Que_Mag.Close;
end;

procedure TFrm_Principale.FormCreate(Sender: TObject);
begin
  //Start du thread
  Transpo.Resume;

  //Initialisation de varialbe
  DecimalSeparator  := '.';
  LibInfo  := 'Cliquez sur Start pour commencer la transpo';
  Que_Mag.Open;
end;

procedure TFrm_Principale.Tim_RefreshTimer(Sender: TObject);
begin
  //Réinitialisation une fois le traitement terminé
  if (NbMat=-1) then
    Begin
      NbMat             := 0;
      Btn_Stop.enabled  := False;
      Stop              := False;
      Start             := False;
      Btn_Start.enabled := True;
      Btn_Quit.enabled  := True;
    End;
  
  //Raffraichi l'affichage
  Lab_Info.caption        := LibInfo;
  PgB_Traitement.Min      := 0;
  PgB_Traitement.Max      := NbMat;
  PgB_Traitement.Position := Compteur;
  Lab_Cpt.caption := IntToStr(Compteur) + ' / ' + IntToStr(NbMat);

end;

initialization
  Transpo :=  TTranspoThread.Create(true);
finalization
  Transpo.Free;

end.
