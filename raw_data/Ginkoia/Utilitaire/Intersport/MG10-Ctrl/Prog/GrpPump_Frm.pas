unit GrpPump_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, Grids, DBGrids, AdvGlowButton, StdCtrls, Buttons,
  DB, IBODataset;

type
  TFrm_GrpPump = class(TForm)
    DBGrid1: TDBGrid;
    Ds_GrpPump: TDataSource;
    Nbt_AffectAuto: TBitBtn;
    Nbt_Affect: TBitBtn;
    RzPanel1: TRzPanel;
    Pan_Bottom: TRzPanel;
    btn_Quitter: TAdvGlowButton;
    Que_GrpPump: TIBOQuery;
    Que_GrpPumpMAG_ID: TIntegerField;
    Que_GrpPumpMAG_ENSEIGNE: TStringField;
    Que_GrpPumpMPU_ID: TIntegerField;
    Que_GrpPumpGCP_ID: TIntegerField;
    Que_GrpPumpGCP_NOM: TStringField;
    Que_GrpPumpMAG_CODEADH: TStringField;
    procedure btn_QuitterClick(Sender: TObject);
    procedure Nbt_AffectClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Nbt_AffectAutoClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure InitEcr;
  end;

var
  Frm_GrpPump: TFrm_GrpPump;

implementation

uses
  Main_Dm, TblGrpPump_Frm;

{$R *.dfm}

procedure TFrm_GrpPump.btn_QuitterClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_GrpPump.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  savBrush: TColor;
  savFont: TColor;
  ChBrush: TColor;
  ChFont: TColor;
begin
  With TDBGrid(Sender).Canvas do
  begin
    if Column.FieldName='GCP_NOM' then
    begin
      if (gdSelected in State) or (gdFocused in State) then
        ChFont := clWhite
      else
        ChFont := clBlack;
      if (Que_GrpPump.FieldByName('MPU_ID').AsInteger=0) or (Que_GrpPump.FieldByName('GCP_ID').AsInteger=0) then
      begin
        if (gdSelected in State) or (gdFocused in State) then
          ChBrush := rgb(153, 0, 0)      // rouge
        else
          ChBrush := rgb(255,153,153);
      end
      else
      begin
        if (gdSelected in State) or (gdFocused in State) then
          ChBrush := rgb(0, 153, 0)      // vert
        else
          ChBrush := rgb(153,255,153);
      end;
      savBrush := Brush.Color;
      savFont   := Font.Color;
      Font.Color :=ChFont;
      Brush.Color := ChBrush;
      TDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
      Font.Color :=savFont;
      Brush.Color := savBrush;
    end
    else
    begin
      if (gdSelected in State) or (gdFocused in State) then
      begin
        ChFont := clHighlightText;
        ChBrush := clHighlight;
      end
      else
      begin
        ChFont := clWindowText;
        ChBrush := clWindow;
      end;
      if (gdSelected in State) or (gdFocused in State) then
      savBrush := Brush.Color;
      savFont   := Font.Color;
      Font.Color :=ChFont;
      Brush.Color := ChBrush;
      TDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
      Font.Color :=savFont;
      Brush.Color := savBrush;
    end;
  end;
end;

procedure TFrm_GrpPump.InitEcr;
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    Que_GrpPump.Open;
    Que_GrpPump.First;
  finally
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_GrpPump.Nbt_AffectAutoClick(Sender: TObject);
var
  Book: TBookmark;
  sTmp: string;
begin
  if not(Que_GrpPump.Active) or (Que_GrpPump.RecordCount=0) then
    exit;
  Book := Que_GrpPump.GetBookmark;
  Que_GrpPump.DisableControls;
  try
    Que_GrpPump.First;
    while not(Que_GrpPump.Eof) do
    begin
      if (Que_GrpPump.FieldByName('MPU_ID').AsInteger=0)
           or (Que_GrpPump.FieldByName('GCP_ID').AsInteger=0) then
      begin
        sTmp := 'GROUPE '+Trim(UpperCase(Que_GrpPump.FieldByName('MAG_ENSEIGNE').AsString));
        if Length(sTmp)>64 then
          sTmp := Copy(sTmp, 1, 64);
        Dm_Main.AffectationGrpPump(Que_GrpPump.FieldByName('MAG_ID').AsInteger, 0, 0, sTmp);
      end;
      Que_GrpPump.Next;
    end;
    Que_GrpPump.Refresh;
    try
      Que_GrpPump.GotoBookmark(Book);
    except
    end;
  finally
    Que_GrpPump.FreeBookmark(Book);
    Que_GrpPump.EnableControls;
  end;
end;

procedure TFrm_GrpPump.Nbt_AffectClick(Sender: TObject);
var
  Book: TBookmark;
begin
  if not(Que_GrpPump.Active) or (Que_GrpPump.RecordCount=0) then
    exit;
  Frm_TblGrpPump := TFrm_TblGrpPump.Create(Nil);
  try
    Frm_TblGrpPump.InitEcr(Que_GrpPump.FieldByName('GCP_ID').AsInteger);
    if Frm_TblGrpPump.ShowModal=mrok then
    begin
      Dm_Main.AffectationGrpPump(Que_GrpPump.FieldByName('MAG_ID').AsInteger,
                                 Que_GrpPump.FieldByName('MPU_ID').AsInteger,
                                 Frm_TblGrpPump.rGcpId, '');
      Book := Que_GrpPump.GetBookmark;
      Que_GrpPump.DisableControls;
      try
        Que_GrpPump.Refresh;
        try
          Que_GrpPump.GotoBookmark(Book);
        except
        end;
      finally
        Que_GrpPump.FreeBookmark(Book);
        Que_GrpPump.EnableControls;
      end;
    end;
  finally
    FreeAndNil(Frm_TblGrpPump);
  end;
end;

end.
