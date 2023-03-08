unit FSP2KMain_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FSP2K_DM, StdCtrls, Buttons, ComCtrls, ExtCtrls, FSP2KTypes, IniFiles;

type
  Tfrm_FSP2KMain = class(TForm)
    Pan_Top: TPanel;
    Pan_client: TPanel;
    Gbx_Logs: TGroupBox;
    Pan_Topclient: TPanel;
    Gbx_Etat: TGroupBox;
    Pan_TopLeft: TPanel;
    Gbx_Actions: TGroupBox;
    Pan_LogsClient: TPanel;
    mmLogs: TMemo;
    Lab_Etat1: TLabel;
    Lab_Etat2: TLabel;
    pg_Etat1: TProgressBar;
    pg_Etat2: TProgressBar;
    Lab_BaseEncours: TLabel;
    Nbt_DoTraitManuel: TBitBtn;
    Nbt_DoTraitAuto: TBitBtn;
    OD_DB: TOpenDialog;
    nbt_StopNext: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Nbt_DoTraitManuelClick(Sender: TObject);
    procedure Nbt_DoTraitAutoClick(Sender: TObject);
    procedure nbt_StopNextClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure LoadIni;
  public
    { Déclarations publiques }
  end;

var
  frm_FSP2KMain: Tfrm_FSP2KMain;

implementation

{$R *.dfm}

procedure Tfrm_FSP2KMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(DM_FSP2K) then
    DM_FSP2K.Free;

  if Assigned(lstDbListDone) then
    lstDbListDone.Free;
end;

procedure Tfrm_FSP2KMain.FormCreate(Sender: TObject);
var
  i : Integer;
begin
  Caption := 'Fedas Sp2000 v' + CVERSION;

  GAPPPATH := ExtractFilePath(Application.ExeName);
  GLOGFILEPATH := GAPPPATH + '\Logs\';

  if not DirectoryExists(GLOGFILEPATH) then
    ForceDirectories(GLOGFILEPATH);

  DM_FSP2K := TDM_FSP2K.Create(Self);
  With DM_FSP2K do
  begin
    LabEncours := Lab_BaseEncours;

    LabAjout  := Lab_Etat1;
    LabOldImp := Lab_Etat2;

    PgAjout   := pg_Etat1;
    PgOldImp  := pg_Etat2;

    MemoLogs := mmLogs;
  end;

  lstDbListDone := TStringList.Create;
  if FileExists(GAPPPATH + 'IsDone.txt') then
  begin
    lstDbListDone.LoadFromFile(GAPPPATH + 'IsDone.txt');
    // On vire les lignes vides au cas où
    for i := lstDbListDone.Count -1 Downto 0 do
      if Trim(lstDbListDone[i]) = '' then
        lstDbListDone.Delete(i);
  end;

  LoadIni;
end;

procedure Tfrm_FSP2KMain.LoadIni;
begin
  With TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    With IniStruct do
    begin
      // Debug
      IsDebugMode := (ReadInteger('DEBUG','MODE',0) = 1);
      if IsDebugMode then
      begin
        lgDebugMode := ReadString('DEBUG','LOGIN','');
        pwDebugMode := ReadString('DEBUG','PASS','');
        dbDebugMode := ReadString('DEBUG','DB','');
        ctDebugMode  := ReadString('DEBUG','CATALOGUE','');
      end;

      LoginDb    := ReadString('DATABASE','LOGIN','');
      PasswordDb := ReadString('DATABASE','PASS','');
      CatalogDb  := readString('DATABASE','CATALOGUE','');
      Database   := ReadString('DATABASE','DB','');

      FedasFile  := ReadString('FEDAS','FILE',GAPPPATH + 'Fedas-Adherent.csv');
      FedasRef   := ReadInteger('FEDAS','REF',200124);
    end;
  finally
    Free;
  end;
end;

procedure Tfrm_FSP2KMain.Nbt_DoTraitAutoClick(Sender: TObject);
begin
  Nbt_DoTraitManuel.Enabled := False;
  Nbt_DoTraitAuto.Enabled   := False;
  nbt_StopNext.Enabled      := True;
  bStopProg                 := False;
  try
    if DM_FSP2K.Open2kDatabase then
    begin
      if lstDbListDone.Count <> 0 then
      begin
        case MessageDlg('Le fichier des bases déjà traitées n''est pas vide' + #13#10 + 'Voulez vous le vider ?',mtConfirmation,[mbYes,mbNo],0) of
          mrYes: lstDbListDone.Clear;
        end;
      end;

      GLOGFILENAME := FormatDateTime('YYYYMMDDhhmmssnn',Now) + '.txt';
      With DM_FSP2K.aQue_LstDossier do
        while not EOF do
        begin
          Try
            if lstDbListDone.IndexOf(Trim(FieldByName('DOS_CHEMIN').AsString)) = -1 then
            begin
              DM_FSP2K.DoTraitement(FieldByName('DOS_CHEMIN').AsString);
              lstDbListDone.Add(Trim(FieldByName('DOS_CHEMIN').AsString));
              lstDbListDone.SaveToFile(GAPPPATH + 'IsDone.txt');
            end;
          Except on E:Exception do
            begin
              DM_FSP2K.AddToMemo('-- Err : Base ' + FieldByName('DOS_CHEMIN').AsString);
              DM_FSP2K.addToMemo('-- Err : ' + E.Message);
            end;
          End;

          if bStopProg then
            Exit;

          Next;
        end; // While
    end; // if
  finally
    Nbt_DoTraitManuel.Enabled := True;
    Nbt_DoTraitAuto.Enabled   := True;
    Nbt_StopNext.Enabled      := False;
  end;
end;

procedure Tfrm_FSP2KMain.Nbt_DoTraitManuelClick(Sender: TObject);
begin
  if OD_DB.Execute then
  begin
    Nbt_DoTraitManuel.Enabled := False;
    Nbt_DoTraitAuto.Enabled := False;
    nbt_StopNext.Enabled := False;
    try

      GLOGFILENAME := FormatDateTime('YYYYMMDDhhmmssnn',Now) + '.txt';
      DM_FSP2K.DoTraitement(OD_DB.FileName);
    finally
      Nbt_DoTraitManuel.Enabled := True;
      Nbt_DoTraitAuto.Enabled := True;
    end;
  end;
end;

procedure Tfrm_FSP2KMain.nbt_StopNextClick(Sender: TObject);
begin
  bStopProg := True;
  nbt_StopNext.Enabled := False;
end;

end.
