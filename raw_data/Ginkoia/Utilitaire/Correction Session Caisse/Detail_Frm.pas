unit Detail_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids, DB, IBODataset, Menus;

type
  TFrm_Detail = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Nbt_Close: TBitBtn;
    Que_Detail: TIBOQuery;
    Ds_Detail: TDataSource;
    PopupMenu1: TPopupMenu;
    CopierlUPDATE1: TMenuItem;
    CopierColonneUpdate: TMenuItem;
    N1: TMenuItem;
    CopierTxt: TMenuItem;

    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CopierlUPDATE1Click(Sender: TObject);
    procedure CopierColonneUpdateClick(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure CopierTxtClick(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Déclarations privées }
    EtatFiche: boolean;
    NomTbl: string;
    NomIndex: string;
    procedure WMSysCommand(var Msg: TWMSyscommand); message WM_SYSCOMMAND;
  public
    { Déclarations publiques }
    procedure InitEcr(sReq: string;ANomTbl, ANomIndex: string);
    procedure GotoID(ID : integer);
  end;

implementation

uses
  Main_Dm, ClipBrd;

{$R *.dfm}       

procedure TFrm_Detail.InitEcr(sReq: string;ANomTbl, ANomIndex: string);
var
  i : Integer;
begin
  NomTbl := ANomTbl;
  NomIndex := ANomIndex;
  with Que_Detail, SQL do
  begin
    Close;
    Clear;
    Add(sReq);
    Open;

  end;

  Que_Detail.OrderingItems.Clear();
  Que_Detail.OrderingLinks.Clear();
  for i := 0 to Que_Detail.FieldCount -1 do
  begin
    Que_Detail.OrderingItems.Add(Que_Detail.Fields[i].FieldName + '=' + Que_Detail.Fields[i].FieldName + ' ASC;' + Que_Detail.Fields[i].FieldName + ' DESC');
    Que_Detail.OrderingLinks.Add(Que_Detail.Fields[i].FieldName + '=' + IntToStr(i +1))
  end;
end;

procedure TFrm_Detail.FormActivate(Sender: TObject);
begin     
  if EtatFiche then
    exit;
  EtatFiche:=true;
  Application.ProcessMessages;
  ReAlign;
  Application.ProcessMessages;
  Align := AlNone;      
  Application.ProcessMessages;
end;

procedure TFrm_Detail.FormCreate(Sender: TObject);
begin
  EtatFiche := false;
end;

procedure TFrm_Detail.WMSysCommand(var Msg: TWMSyscommand);
begin
  // intercepte le clic sur le bouton minimise
  if ((msg.CmdType and $FFF0) = SC_MINIMIZE) then begin  
    Msg.Result:=1;
    Application.Minimize;
    exit;
  end;
  inherited;
end;

procedure TFrm_Detail.CopierColonneUpdateClick(Sender: TObject);
begin
  if not(Que_Detail.Active) or (Que_Detail.RecordCount=0) then
    exit;

  ClipBoard.AsText := Dm_Main.PreparerUnUpdate(NomTbl, NomIndex, Que_Detail, [DBGrid1.SelectedField.FieldName], [], True);
end;

procedure TFrm_Detail.CopierlUPDATE1Click(Sender: TObject);
begin
  if not(Que_Detail.Active) or (Que_Detail.RecordCount=0) then
    exit;
  ClipBoard.AsText := Dm_Main.PreparerUnUpdate(NomTbl, NomIndex, Que_Detail, True);
end;

procedure TFrm_Detail.CopierTxtClick(Sender: TObject);
begin
  ClipBoard.AsText := DBGrid1.SelectedField.AsString;
end;

procedure TFrm_Detail.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  chFont, savFont: TColor;
  chBrush, savBrush: TColor;
begin
  with TDBGrid(Sender).Canvas do
  begin
    savFont := Font.Color;
    chFont := Font.Color;
    savBrush := Brush.Color;
    chBrush := Brush.Color;

    if (gdSelected in State) or (gdFocused in State) then
    begin
      ChFont := clWhite;
      ChBrush := rgb(0,153,0);
    end
    else
    begin
      ChFont := clBlack;
      ChBrush := rgb(202,255,202);
    end;

    Font.Color := chFont;
    Brush.Color := chBrush;
    TDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
    Font.Color := savFont;
    Brush.Color := savBrush;
  end;
end;

procedure TFrm_Detail.DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('C')) and (Shift = [ssCtrl]) then
    ClipBoard.AsText := DBGrid1.SelectedField.AsString;
end;

procedure TFrm_Detail.DBGrid1TitleClick(Column: TColumn);
var
  IdxTri : Integer;
begin
  IdxTri := Column.Index +1;
  if Abs(Que_Detail.OrderingItemNo) = IdxTri then
    Que_Detail.OrderingItemNo := -Que_Detail.OrderingItemNo
  else
    Que_Detail.OrderingItemNo :=IdxTri;
end;

procedure TFrm_Detail.GotoID(ID : integer);
begin
  if Assigned(Que_Detail.FindField(NomIndex)) then
    Que_Detail.Locate(NomIndex, ID, []);
end;

end.
