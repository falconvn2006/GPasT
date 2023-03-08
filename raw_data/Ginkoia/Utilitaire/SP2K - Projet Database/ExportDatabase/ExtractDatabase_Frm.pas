unit ExtractDatabase_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtractDatabase_Dm,
  // Fin Uses persos
  Dialogs, AlgolDialogForms, jpeg, ExtCtrls, AdvGlowButton, RzPanel, StdCtrls,
  RzLabel, ComCtrls, AdvProgr, IniCfg_Frm, uLog, LstMarqueSQLSrv, uVersion;

type
  TFrm_ExtractDatabase = class(TAlgolDialogForm)
    Tim_LanceTraitement: TTimer;
    Pan_Top: TPanel;
    Lab_Titre: TRzLabel;
    Img_Ginkoia: TImage;
    Img_Sp2K: TImage;
    Pan_client: TPanel;
    Pan_Left: TPanel;
    MainProgressBar: TAdvProgress;
    Lab_Progression: TRzLabel;
    Lab_ConnectGin: TRzLabel;
    Lab_ConnectDtb: TRzLabel;
    RzPanel1: TRzPanel;
    nbt_param: TAdvGlowButton;
    Nbt_Trt: TAdvGlowButton;
    Nbt_TrtMag: TAdvGlowButton;
    Nbt_InitCB: TAdvGlowButton;
    Nbt_RefMrk: TAdvGlowButton;
    Nbt_TrtInit: TAdvGlowButton;
    ArtProgressBar: TAdvProgress;
    nbt_GestionStock: TAdvGlowButton;
    nbt_ByDate: TAdvGlowButton;
    nbt_stop: TAdvGlowButton;
    procedure Nbt_TrtClick(Sender: TObject);
    procedure Nbt_TrtInitClick(Sender: TObject);
    procedure AlgolDialogFormCreate(Sender: TObject);
    procedure Tim_LanceTraitementTimer(Sender: TObject);
    procedure nbt_paramClick(Sender: TObject);
    procedure Nbt_TrtMagClick(Sender: TObject);
    procedure AlgolDialogFormClose(Sender: TObject; var Action: TCloseAction);
    procedure Nbt_RefMrkClick(Sender: TObject);
    procedure Nbt_InitCBClick(Sender: TObject);
    procedure nbt_GestionStockClick(Sender: TObject);
    procedure nbt_ByDateClick(Sender: TObject);
  private
    FModeAuto : boolean;
    FInit     : boolean;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_ExtractDatabase: TFrm_ExtractDatabase;

implementation

{$R *.dfm}

procedure TFrm_ExtractDatabase.nbt_paramClick(Sender: TObject);
begin
  IniCfg.AdoConnection := Dm_ExtractDatabase.ADODatabase;
  if IniCfg.ShowCfgInterface = mrOk then
    Dm_ExtractDatabase.DataBaseConnection;

  if Dm_ExtractDatabase.ADODatabase.ConnectionString <> IniCfg.MsSqlConnectionString  then
    Dm_ExtractDatabase.DataBaseConnection;
end;

procedure TFrm_ExtractDatabase.AlgolDialogFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Log.saveIni();
    Dm_ExtractDatabase.ADODatabase.Connected := False;
    Dm_ExtractDatabase.Free;
end;

procedure TFrm_ExtractDatabase.AlgolDialogFormCreate(Sender: TObject);
begin
  Log.App  := 'ExtractDATABASE';
  Log.Inst := '1';
  Log.SendOnClose := True;
  Log.Open;

  Dm_ExtractDatabase.MainProgress := MainProgressBar;
  Dm_ExtractDatabase.ArtProgress := ArtProgressBar;
  Dm_ExtractDatabase.Lab_ConnexionStateDtb := Lab_ConnectDtb;
  Dm_ExtractDatabase.Lab_ConnexionStateGin := Lab_ConnectGin;
  Dm_ExtractDatabase.Lab_State := Lab_Progression;
  Dm_ExtractDatabase.Nbt_Stop := nbt_stop;

  Caption := Caption + ' v' + GetNumVersionSoft;

  FModeAuto := False;
  FInit := False;
  IF ParamCount > 0 THEN
  begin
    if UpperCase(ParamStr(1)) = 'AUTO' then
    begin
      FModeAuto := True;
      FInit := False;
    end
    else if UpperCase(ParamStr(1)) = 'INIT' then
    begin
      FModeAuto := True;
      FInit := True;
    end;
  end;

  if FModeAuto then
  begin
    // Active le timer qui lancera le traitement.
    Tim_LanceTraitement.Enabled := True;
  end;

end;

procedure TFrm_ExtractDatabase.nbt_ByDateClick(Sender: TObject);
begin
// traitement par date
Dm_ExtractDatabase.DoNewTraitement;

end;

procedure TFrm_ExtractDatabase.nbt_GestionStockClick(Sender: TObject);
begin
  Dm_ExtractDatabase.DoTraitementStock;
end;

procedure TFrm_ExtractDatabase.Nbt_InitCBClick(Sender: TObject);
begin
  Dm_ExtractDatabase.DoTraitementCB;
end;

procedure TFrm_ExtractDatabase.Nbt_RefMrkClick(Sender: TObject);
begin
  IniCfg.LoadIni;
  Dm_ExtractDatabase.DataBaseConnection;

  With Tfrm_LstMarque.Create(Self) do
  try
    if Showmodal = mrOk then
      Dm_ExtractDatabase.DoTraitementMarque(MRK_NOM);
  finally
    Release;
  end;
end;

procedure TFrm_ExtractDatabase.Nbt_TrtClick(Sender: TObject);
begin
  Dm_ExtractDatabase.DoTraitement(False, False, False, '', true);
end;

procedure TFrm_ExtractDatabase.Nbt_TrtInitClick(Sender: TObject);
begin
  Dm_ExtractDatabase.DoTraitement(True, False, False, '');
end;

procedure TFrm_ExtractDatabase.Nbt_TrtMagClick(Sender: TObject);
var
  sValue : string;
begin
  sValue := '';
  sValue := InputBox('Choix du magasin', 'Merci de saisir le code adhérent du magasin à traiter :', '');
  if sValue <> '' then
  begin
    Dm_ExtractDatabase.DoTraitement(False, False, True, sValue);
  end;
end;

procedure TFrm_ExtractDatabase.Tim_LanceTraitementTimer(Sender: TObject);
begin
  Tim_LanceTraitement.Enabled := False;
  Dm_ExtractDatabase.DoTraitement(FInit, True, False, '');
  Close;
end;

end.
