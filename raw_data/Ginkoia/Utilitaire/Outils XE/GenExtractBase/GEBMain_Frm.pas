unit GEBMain_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CategoryButtons, ActnList, ExtCtrls, RzPanel, StdCtrls, ComCtrls,
  StdActns, StrUtils, Types, GEB_DM, GEB_Magasins;

type
  Tfrm_GEBMain = class(TForm)
    CategoryButtons1: TCategoryButtons;
    ActLst_Menu: TActionList;
    Ax_SelectBase: TAction;
    Ax_DoExtract: TAction;
    Pan_Client: TRzPanel;
    Gbx_Base: TGroupBox;
    Lab_Source: TLabel;
    Lab_Destination: TLabel;
    Lab_SourceDir: TLabel;
    Lab_DestinationDir: TLabel;
    Gbx_Progress: TGroupBox;
    Pan_ProgressTop: TRzPanel;
    Lab_Etat: TLabel;
    Lab_Total: TLabel;
    Lab_EtatText: TLabel;
    pg_Total: TProgressBar;
    Pan_ProgressClient: TRzPanel;
    mmLogs: TMemo;
    Ax_SelectDestination: TAction;
    OD_BaseFile: TOpenDialog;
    Ax_SelectMagasins: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Ax_SelectBaseExecute(Sender: TObject);
    procedure Ax_SelectDestinationExecute(Sender: TObject);
    procedure Ax_DoExtractExecute(Sender: TObject);
    procedure Ax_DoSelectMagasins(Sender: TObject);
  private
    { Déclarations privées }
    function CheckData : Boolean;

  public
    { Déclarations publiques }
  end;

var
  frm_GEBMain: Tfrm_GEBMain;

implementation

{$R *.dfm}

procedure Tfrm_GEBMain.Ax_DoExtractExecute(Sender: TObject);
begin
  if CheckData then
  begin
    DM_GEB.DoExecuteProcess(Lab_DestinationDir.Caption);
  end;
end;

procedure Tfrm_GEBMain.Ax_DoSelectMagasins(Sender: TObject);
var
  frm_GEBMagasins: Tfrm_GEBMagasins;
  slMagasins, slMagasinsSelect: TStringList;
  sdaMagasinsSelect: TStringDynArray;
  i, j: Integer;
begin
  if CheckData() then
  begin
    Application.CreateForm(Tfrm_GEBMagasins, frm_GEBMagasins);
    slMagasins := TStringList.Create();
    slMagasinsSelect := TStringList.Create();
    try
      // Récupére la liste des magasins
      sdaMagasinsSelect := SplitString(DM_GEB.ListeIdMag, ',');

      slMagasinsSelect.Clear();
      for i := 0 to Length(sdaMagasinsSelect) - 1 do
        slMagasinsSelect.Add(sdaMagasinsSelect[i]);

      if DM_GEB.ListeMagasins(slMagasins) then
      begin
        frm_GEBMagasins.Clb_Liste.Clear();

        for i := 0 to slMagasins.Count - 1 do
        begin
          j := frm_GEBMagasins.Clb_Liste.Items.Add(slMagasins.Names[i]);

          if (slMagasinsSelect.IndexOf(slMagasins.ValueFromIndex[i]) > -1)
            or (slMagasinsSelect.Count = 0) then
            frm_GEBMagasins.Clb_Liste.Checked[j] := True
        end;

        frm_GEBMagasins.Clb_ListeClickCheck(nil);

        if frm_GEBMagasins.ShowModal() = mrOk then
        begin
          DM_GEB.ListeIdMag := ',0';

          for i := 0 to frm_GEBMagasins.Clb_Liste.Count - 1 do
          begin
            if frm_GEBMagasins.Clb_Liste.Checked[i] then
              DM_GEB.ListeIdMag := DM_GEB.ListeIdMag + ',' + slMagasins.Values[frm_GEBMagasins.Clb_Liste.Items[i]];
          end;

          DM_GEB.ListeIdMag := RightStr(DM_GEB.ListeIdMag, Length(DM_GEB.ListeIdMag) - 1);
        end;
      end;
    finally
      slMagasinsSelect.Free();
      slMagasins.Free();
      frm_GEBMagasins.Free();
    end;
  end;
end;

procedure Tfrm_GEBMain.Ax_SelectBaseExecute(Sender: TObject);
begin
  if OD_BaseFile.Execute then
  begin
    Lab_SourceDir.Caption := OD_BaseFile.FileName;
    Lab_SourceDir.Hint := OD_BaseFile.FileName;
  end;
end;

procedure Tfrm_GEBMain.Ax_SelectDestinationExecute(Sender: TObject);
var
  bf : TBrowseForFolder;
begin
  bf := TBrowseForFolder.Create(Self);
  try
    bf.Caption := 'Sélectionner le répertoire de destination';
    bf.BrowseOptions := [bifNoTranslateTargets,bifNewDialogStyle];

    if Lab_DestinationDir.Caption <> '...' then
      bf.Folder := Lab_DestinationDir.Caption;

    if bf.Execute then
      Lab_DestinationDir.Caption := bf.Folder;
  finally
    bf.Free;
  end;
end;

function Tfrm_GEBMain.CheckData: Boolean;
begin
  Result := False;
  if (trim(Lab_SourceDir.Caption) = '') or (Lab_SourceDir.Caption = '...') then
  begin
    ShowMessage('Veuillez sélectionner une base de données');
    Exit;
  end;

  if (trim(Lab_DestinationDir.Caption) = '') or (Lab_DestinationDir.Caption = '...') then
  begin
    ShowMessage('Veuillez sélectionner un répertoire de destination');
    Exit;
  end;

  With DM_GEB do
  begin
    if not ConnectToDb(IBODbSource,Lab_SourceDir.Caption) then
      Exit;
  end;

  Result := True;
end;

procedure Tfrm_GEBMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DM_GEB.Free;
end;

procedure Tfrm_GEBMain.FormCreate(Sender: TObject);
begin
  DM_GEB := TDM_GEB.Create(Self);
  DM_GEB.LabelEtat := Lab_EtatText;
  DM_GEB.Progress := pg_Total;
  DM_GEB.Memo := mmLogs;
end;

end.
