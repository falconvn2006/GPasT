unit ExportBI_Frm;

interface

uses
  Windows,
  Messages,
  // Uses Perso
//  ExportBI_Dm,
  UVersion,
  // fin uses perso
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  AdvProgr,
  StdCtrls,
  RzLabel,
  ExtCtrls,
  jpeg,
  RzPanel;

type
  TFrm_ExportBI = class(TForm)
    Lab_ConnectGin: TRzLabel;
    MainProgressBar: TAdvProgress;
    Lab_Progression: TRzLabel;
    Tim_LanceTraitement: TTimer;
    Lab_Titre: TRzLabel;
    Img_Ginkoia: TImage;
    Od_FtpSend: TFileOpenDialog;
    Btn_CalcStock: TButton;
    Btn_TraitementComplet: TButton;
    Btn_EnvoiFTPSeul: TButton;
    Btn_InitialisationMagasin: TButton;
    Pan_Fond: TRzPanel;
    Btn_TraitementMagasin: TButton;
    Btn_TraitementDossier: TButton;
    Btn_Correction: TButton;
    Chk_Jeton: TCheckBox;
    Btn_InitialisationDossier: TButton;

    procedure FormCreate(Sender: TObject);

    procedure Btn_InitialisationMagasinClick(Sender: TObject);
    procedure Btn_TraitementCompletClick(Sender: TObject);
    procedure Btn_TraitementMagasinClick(Sender: TObject);

    procedure Btn_CalcStockClick(Sender: TObject);
    procedure Btn_EnvoiFTPSeulClick(Sender: TObject);
    procedure Tim_LanceTraitementTimer(Sender: TObject);
    procedure Btn_TraitementDossierClick(Sender: TObject);
    procedure Btn_CorrectionClick(Sender: TObject);
    procedure Btn_InitialisationDossierClick(Sender: TObject);
  private
    { Déclarations privées }
    FModeAuto  : boolean;
    FCalcStock : boolean;
    FInit      : boolean;

    function LanceTraitement(CalcStock, FTPSend : boolean) : boolean;
  public
    { Déclarations publiques }
  end;

var
  Frm_ExportBI: TFrm_ExportBI;

implementation

{$R *.dfm}

uses
  UDateChooser,
  ExportBI_new_Dm;

{ TFrm_ExportBI }

procedure TFrm_ExportBI.FormCreate(Sender: TObject);
var
  i : integer;
begin
  Frm_ExportBI.Caption := 'Exportation des données pour BI - V' + GetNumVersionSoft;

  FModeAuto := False;
  FInit := False;
  for i := 1 to ParamCount do
  begin
    if UpperCase(ParamStr(i)) = 'AUTO' then
    begin
      FModeAuto := True;
      FInit := False;
    end
    else if UpperCase(ParamStr(i)) = 'INIT' then
    begin
      FModeAuto := True;
      FInit := True;
    end
    else if UpperCase(ParamStr(i)) = 'STOCK' then
    begin
      FCalcStock := True;
    end;
  end;

  if FModeAuto then
  begin
    Pan_Fond.Enabled := False;
    Tim_LanceTraitement.Enabled := True;
  end;
end;

// boutons

procedure TFrm_ExportBI.Btn_InitialisationDossierClick(Sender: TObject);
var
  DM_New : TDm_ExportBI_new;
begin
  try
    Pan_Fond.Enabled := False;

    try
      DM_New := TDm_ExportBI_new.Create(Self);
      DM_New.InitControl(MainProgressBar, Lab_Progression);
      try
        if DM_New.InitialiseDossier(Chk_Jeton.Checked) then
          MessageDlg('Initialisation effectué correctement', mtInformation, [mbOK], 0)
        else
          MessageDlg('Initialisation non effectué', mtWarning, [mbOK], 0);
      except
        on e : Exception do
        begin
          MessageDlg('Erreur lors de l''initialisation : ' + E.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
        end;
      end;
    finally
      FreeAndNil(DM_New);
    end;
  finally
    Pan_Fond.Enabled := True;
  end;
end;

procedure TFrm_ExportBI.Btn_InitialisationMagasinClick(Sender: TObject);
var
  DM_New : TDm_ExportBI_new;
begin
  try
    Pan_Fond.Enabled := False;

    try
      DM_New := TDm_ExportBI_new.Create(Self);
      DM_New.InitControl(MainProgressBar, Lab_Progression);
      try
        if DM_New.InitialiseMagasin(Chk_Jeton.Checked) then
          MessageDlg('Initialisation effectué correctement', mtInformation, [mbOK], 0)
        else
          MessageDlg('Initialisation non effectué', mtWarning, [mbOK], 0);
      except
        on e : Exception do
        begin
          MessageDlg('Erreur lors de l''initialisation : ' + E.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
        end;
      end;
    finally
      FreeAndNil(DM_New);
    end;
  finally
    Pan_Fond.Enabled := True;
  end;
end;

procedure TFrm_ExportBI.Btn_TraitementCompletClick(Sender: TObject);
var
  CalcStock, FTPSend : boolean;
begin
  try
    Pan_Fond.Enabled := False;

    CalcStock := (MessageDlg('Effectuer le recalcul de stock ?', mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes);
    FTPSend := (MessageDlg('Effectuer l''envoi FTP une fois l''extraction terminée ?', mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes);
    try
      if LanceTraitement(CalcStock, FTPSend) then
        MessageDlg('Traitement effectué correctement', mtInformation, [mbOK], 0)
      else
        MessageDlg('Traitement non effectué', mtWarning, [mbOK], 0);
    except
      on e : Exception do
      begin
        MessageDlg('Erreur lors du Traitement : ' + E.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
    Pan_Fond.Enabled := True;
  end;
end;

procedure TFrm_ExportBI.Btn_TraitementDossierClick(Sender: TObject);
var
  DM_New : TDm_ExportBI_new;
  CalcStock, FTPSend : boolean;
begin
  try
    Pan_Fond.Enabled := False;

    CalcStock := (MessageDlg('Effectuer le recalcul de stock ?', mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes);
    FTPSend := (MessageDlg('Effectuer l''envoi FTP une fois l''extraction terminée ?', mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes);

    try
      DM_New := TDm_ExportBI_new.Create(Self);
      DM_New.InitControl(MainProgressBar, Lab_Progression);
      try
        if DM_New.TraitementDossier(CalcStock, FTPSend, Chk_Jeton.Checked) then
          MessageDlg('Traitement effectué correctement', mtInformation, [mbOK], 0)
        else
          MessageDlg('Traitement non effectué', mtWarning, [mbOK], 0);
      except
        on e : Exception do
        begin
          MessageDlg('Erreur lors du Traitement : ' + E.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
        end;
      end;
    finally
      FreeAndNil(DM_New);
    end;
  finally
    Pan_Fond.Enabled := True;
  end;
end;

procedure TFrm_ExportBI.Btn_TraitementMagasinClick(Sender: TObject);
var
  DM_New : TDm_ExportBI_new;
  CalcStock, FTPSend : boolean;
begin
  try
    Pan_Fond.Enabled := False;

    CalcStock := (MessageDlg('Effectuer le recalcul de stock ?', mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes);
    FTPSend := (MessageDlg('Effectuer l''envoi FTP une fois l''extraction terminée ?', mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes);

    try
      DM_New := TDm_ExportBI_new.Create(Self);
      DM_New.InitControl(MainProgressBar, Lab_Progression);
      try
        if DM_New.TraitementMagasin(CalcStock, FTPSend, Chk_Jeton.Checked) then
          MessageDlg('Traitement effectué correctement', mtInformation, [mbOK], 0)
        else
          MessageDlg('Traitement non effectué', mtWarning, [mbOK], 0);
      except
        on e : Exception do
        begin
          MessageDlg('Erreur lors du Traitement : ' + E.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
        end;
      end;
    finally
      FreeAndNil(DM_New);
    end;
  finally
    Pan_Fond.Enabled := True;
  end;
end;

// Timer

procedure TFrm_ExportBI.Tim_LanceTraitementTimer(Sender: TObject);
begin
  Tim_LanceTraitement.Enabled := false;
  LanceTraitement(FCalcStock, true);
  Close();
end;

// traitement

function TFrm_ExportBI.LanceTraitement(CalcStock, FTPSend : boolean) : boolean;
var
  DM_New : TDm_ExportBI_new;
begin
  try
    DM_New := TDm_ExportBI_new.Create(Self);
    DM_New.InitControl(MainProgressBar, Lab_Progression);
    try
      Result := DM_New.TraitementComplet(CalcStock, FTPSend, Chk_Jeton.Checked);
    except
      on E:Exception do
      begin
        Result := false;
        DM_New.DoLogAction('Exception lors du traitement : ' + E.ClassName + ' - ' + E.Message, 0);
      end;
    end;
  finally
    FreeAndNil(DM_New);
  end;
end;

// autres ...

procedure TFrm_ExportBI.Btn_CalcStockClick(Sender: TObject);
begin
//  Dm_ExportBI.DoLogAction('TFrm_ExportBI.Btn_CalcStockClick', 3);
//
//  Pan_Fond.Enabled := False;
//  Dm_ExportBI.DoCalcAllStock;
//  Pan_Fond.Enabled := True;
end;

procedure TFrm_ExportBI.Btn_CorrectionClick(Sender: TObject);
var
  DateTrt : TDate;
  DM_New : TDm_ExportBI_new;
begin
  try
    Pan_Fond.Enabled := False;

    if SelectDate(DateTrt) then
    begin
      try
        DM_New := TDm_ExportBI_new.Create(Self);
        DM_New.InitControl(MainProgressBar, Lab_Progression);
        if DM_New.CorrigeDossier(DateTrt) then

        else

      finally
        FreeAndNil(DM_New);
      end;
    end;
  finally
    Pan_Fond.Enabled := True;
  end;
end;

procedure TFrm_ExportBI.Btn_EnvoiFTPSeulClick(Sender: TObject);
var
  DM_New : TDm_ExportBI_new;
  sPath : string;
begin
  try
    Pan_Fond.Enabled := False;

    sPath := ExtractFilePath(Application.ExeName) + 'Extract\' + FormatDateTime('YYYY\MM\DD\', Now);
    if NOT DirectoryExists(sPath, False) then
       sPath := ExtractFilePath(Application.ExeName) + 'Extract\' + FormatDateTime('YYYY\MM\', Now);
    if NOT DirectoryExists(sPath, False) then
       sPath := ExtractFilePath(Application.ExeName) + 'Extract\' + FormatDateTime('YYYY\', Now);
    if NOT DirectoryExists(sPath, False) then
       sPath := ExtractFilePath(Application.ExeName);

    Od_FtpSend.DefaultFolder := sPath;
    IF Od_FtpSend.Execute THEN
    begin
      if FileExists(Od_FtpSend.FileName) then
      begin
        try
          DM_New := TDm_ExportBI_new.Create(Self);
          DM_New.InitControl(MainProgressBar, Lab_Progression);
          DM_New.SendFileFTP(Od_FtpSend.FileName);
        finally
          FreeAndNil(DM_New);
        end;
      end;
    end;
  finally
    Pan_Fond.Enabled := True;
  end;
end;

end.
