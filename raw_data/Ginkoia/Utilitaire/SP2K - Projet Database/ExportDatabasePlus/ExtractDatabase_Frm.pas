unit ExtractDatabase_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtractDatabase_Dm,
  // Fin Uses persos
  Dialogs, AlgolDialogForms, jpeg, ExtCtrls, AdvGlowButton, RzPanel, StdCtrls,
  RzLabel, ComCtrls, AdvProgr;

type
  TFrm_ExtractDatabase = class(TAlgolDialogForm)
    Img_Sp2K: TImage;
    Img_Ginkoia: TImage;
    Pan_Btn: TRzPanel;
    Nbt_Trt: TAdvGlowButton;
    Lab_Progression: TRzLabel;
    Lab_Titre: TRzLabel;
    MainProgressBar: TAdvProgress;
    Nbt_TrtInit: TAdvGlowButton;
    Lab_ConnectDtb: TRzLabel;
    Lab_ConnectGin: TRzLabel;
    Tim_LanceTraitement: TTimer;
    procedure Nbt_TrtClick(Sender: TObject);
    procedure Nbt_TrtInitClick(Sender: TObject);
    procedure AlgolDialogFormCreate(Sender: TObject);
    procedure Tim_LanceTraitementTimer(Sender: TObject);
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

procedure TFrm_ExtractDatabase.AlgolDialogFormCreate(Sender: TObject);
begin
  Dm_ExtractDatabase.MainProgress := MainProgressBar;
  Dm_ExtractDatabase.Lab_ConnexionStateDtb := Lab_ConnectDtb;
  Dm_ExtractDatabase.Lab_ConnexionStateGin := Lab_ConnectGin;
  Dm_ExtractDatabase.Lab_State := Lab_Progression;


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

procedure TFrm_ExtractDatabase.Nbt_TrtClick(Sender: TObject);
begin

  Dm_ExtractDatabase.DoTraitement(False, False);
end;

procedure TFrm_ExtractDatabase.Nbt_TrtInitClick(Sender: TObject);
begin
  Dm_ExtractDatabase.DoTraitement(True, False);
end;

procedure TFrm_ExtractDatabase.Tim_LanceTraitementTimer(Sender: TObject);
begin
  Tim_LanceTraitement.Enabled := False;
  Dm_ExtractDatabase.DoTraitement(FInit, True);
  Close;
end;

end.
