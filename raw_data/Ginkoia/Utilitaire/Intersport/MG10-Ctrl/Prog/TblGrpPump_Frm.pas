unit TblGrpPump_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvGlowButton, ExtCtrls, RzPanel, DBCtrls, StdCtrls, Buttons, Grids,
  DBGrids, DB, IBODataset;

type
  TFrm_TblGrpPump = class(TForm)
    DBGrid1: TDBGrid;
    SpAjout: TSpeedButton;
    SpModif: TSpeedButton;
    SpSuppr: TSpeedButton;
    Label1: TLabel;
    DBText1: TDBText;
    Pan_Bottom: TRzPanel;
    btn_Valid: TAdvGlowButton;
    btn_Annul: TAdvGlowButton;
    Que_GrpPump: TIBOQuery;
    Ds_GrpPump: TDataSource;
    Que_GrpPumpGCP_ID: TIntegerField;
    Que_GrpPumpGCP_NOM: TStringField;
    procedure SpModifClick(Sender: TObject);
    procedure SpSupprClick(Sender: TObject);
    procedure SpAjoutClick(Sender: TObject);
    procedure btn_ValidClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    rGcpId: integer;
    procedure InitEcr(iGcpId: integer);
  end;

var
  Frm_TblGrpPump: TFrm_TblGrpPump;

implementation

uses
  Main_Dm, AjoutModifGrpPump_Frm;

{$R *.dfm}

procedure TFrm_TblGrpPump.InitEcr(iGcpId: integer);
begin
  Que_GrpPump.Open;
  Que_GrpPump.Locate('GCP_ID', iGcpId, []);
end;

procedure TFrm_TblGrpPump.btn_ValidClick(Sender: TObject);
begin
  if not(Que_GrpPump.Active) or (Que_GrpPump.RecordCount=0) then
  begin
    ModalResult := mrNone;
    MessageDlg('Aucun groupe de pump', mterror,[mbok],0);
    exit;
  end;
  rGcpId := Que_GrpPump .FieldByName('GCP_ID').AsInteger;
  ModalResult := mrOk;
end;

procedure TFrm_TblGrpPump.SpAjoutClick(Sender: TObject);
var
  sNom: string;
//  Book: TBookMark;
  iGcpId: integer;
begin
  From_AjoutModifGrpPump := TFrom_AjoutModifGrpPump.Create(nil);
  try
    From_AjoutModifGrpPump.InitEcr('');
    if From_AjoutModifGrpPump.ShowModal=mrok then
    begin
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      try
        sNom := Trim(From_AjoutModifGrpPump.ENom.Text);
        iGcpId := Dm_Main.AjoutModifGrpPump(0, sNom);
        Que_GrpPump.DisableControls;
        try
          Que_GrpPump.Refresh;
          Que_GrpPump.Locate('GCP_ID', iGcpId, []);
        finally
          Que_GrpPump.EnableControls;
        end;
      finally
        Application.ProcessMessages;
        Screen.Cursor := crDefault;
      end;
    end;
  finally
    FreeAndNil(From_AjoutModifGrpPump);
  end;
end;

procedure TFrm_TblGrpPump.SpModifClick(Sender: TObject);
var
  sNom: string;
//  Book: TBookMark;
  iGcpId: integer;
begin
  if not(Que_GrpPump.Active) or (Que_GrpPump.RecordCount=0) then
    exit;
  From_AjoutModifGrpPump := TFrom_AjoutModifGrpPump.Create(nil);
  try
    From_AjoutModifGrpPump.InitEcr(Que_GrpPump.FieldByName('GCP_NOM').AsString);
    if From_AjoutModifGrpPump.ShowModal=mrok then
    begin
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      try
        sNom := Trim(From_AjoutModifGrpPump.ENom.Text);
        iGcpId :=  Que_GrpPump.FieldByName('GCP_ID').AsInteger;
        iGcpId := Dm_Main.AjoutModifGrpPump(iGcpId, sNom);
        Que_GrpPump.DisableControls;
        try
          Que_GrpPump.Refresh;
          Que_GrpPump.Locate('GCP_ID', iGcpId, []);
        finally
          Que_GrpPump.EnableControls;
        end;
      finally
        Application.ProcessMessages;
        Screen.Cursor := crDefault;
      end;
    end;
  finally
    FreeAndNil(From_AjoutModifGrpPump);
  end;
end;

procedure TFrm_TblGrpPump.SpSupprClick(Sender: TObject);
begin
  if not(Que_GrpPump.Active) or (Que_GrpPump.RecordCount=0) then
    exit;
  // TODO
end;

end.
