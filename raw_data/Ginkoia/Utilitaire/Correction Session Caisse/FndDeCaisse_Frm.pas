unit FndDeCaisse_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, Grids, DBGrids, DB, Menus;

type
  TFrm_FndDeCaisse = class(TForm)
    Gbx_InfoSession: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edt_Num: TEdit;
    Edt_ID: TEdit;
    Edt_Ecart: TEdit;
    Nbt_Fermer: TBitBtn;
    Pgc_liaison: TPageControl;
    Tab_Synthese: TTabSheet;
    Tab_Coffre: TTabSheet;
    Gbx_FndCaisse: TGroupBox;
    DBGrid1: TDBGrid;
    Pan_bas: TPanel;
    Ds_LigFndCais: TDataSource;
    Nbt_CopierEncais: TBitBtn;
    PopFndCais: TPopupMenu;
    CopiertouslesIDavecdesOR1: TMenuItem;
    Prparertouslesupdates2: TMenuItem;
    MettretouslesIDavecKENABLED1etatsupprim2: TMenuItem;
    Prparertouteslessuppressionsphysiques2: TMenuItem;
    Ds_SyntFndcais: TDataSource;
    DBGrid3: TDBGrid;
    DBGrid2: TDBGrid;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    Ds_Coffre: TDataSource;
    PopCoffre: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    Creerunenouvelleligne1: TMenuItem;
    Creerunenouvelleligne2: TMenuItem;
    Label4: TLabel;
    ERefID: TEdit;
    splSplitter1: TSplitter;
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure Nbt_CopierEncaisClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure CopiertouslesIDavecdesOR1Click(Sender: TObject);
    procedure Prparertouslesupdates2Click(Sender: TObject);
    procedure MettretouslesIDavecKENABLED1etatsupprim2Click(Sender: TObject);
    procedure Prparertouteslessuppressionsphysiques2Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Creerunenouvelleligne2Click(Sender: TObject);
    procedure Creerunenouvelleligne1Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure DBGridTitleClick(Column: TColumn);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Déclarations privées }
    EtatFiche: boolean;
    SesNum: string;
    SesID: integer;
    TypeFndCais: integer;
    procedure CMDialogKey(var M: TCMDialogKey); message CM_DIALOGKEY;
    procedure WMSysCommand(var Msg: TWMSyscommand); message WM_SYSCOMMAND;
  public
    { Déclarations publiques }
    procedure InitEcr(ASesNum: string; ASesID: integer; AEcart: string);
  end;

implementation

uses
  Main_Dm, Detail_Frm, IBODataset, Clipbrd;

{$R *.dfm}

procedure TFrm_FndDeCaisse.CMDialogKey(var M: TCMDialogKey);
begin
  if (m.CharCode=VK_RETURN) then
  begin
    if (ERefID.Focused) and (ERefID.Text<>'') and (Dm_Main.Que_LigFndCais.Active) then
    begin
      Dm_Main.Que_LigFndCais.Locate('FDC_REFID',ERefID.Text,[]);
      m.Result := 1;
      ERefID.SetFocus;
      ERefID.SelectAll;
      exit;
    end;
  end;
  inherited;
end;

procedure TFrm_FndDeCaisse.WMSysCommand(var Msg: TWMSyscommand);
begin
  // intercepte le clic sur le bouton minimise
  if ((msg.CmdType and $FFF0) = SC_MINIMIZE) then begin  
    Msg.Result:=1;
    Application.Minimize;
    exit;
  end;
  inherited;
end;

procedure TFrm_FndDeCaisse.BitBtn1Click(Sender: TObject);
var
  pt: TPoint;
begin
  GetCursorPos(pt);
  PopCoffre.Popup(pt.X,pt.y);
end;

procedure TFrm_FndDeCaisse.CopiertouslesIDavecdesOR1Click(Sender: TObject);
begin
  CopierIDAvecDesOR('FDC_ID', Dm_Main.Que_LigFndCais);
end;

procedure TFrm_FndDeCaisse.Creerunenouvelleligne1Click(Sender: TObject);
begin
  CreerNouvLigne('CSHFONDCOFFRE', 'FCF_ID');
end;

procedure TFrm_FndDeCaisse.Creerunenouvelleligne2Click(Sender: TObject);
begin
  CreerNouvLigne('CSHFONDCAISSE', 'FDC_ID');
end;

procedure TFrm_FndDeCaisse.DBGrid1DblClick(Sender: TObject);
var
  Frm_Detail : TFrm_Detail;
begin
  Frm_Detail := TFrm_Detail.Create(Self);
  try
    Frm_Detail.InitEcr('select l.* from CSHFONDCAISSE l '+
                       'join K on (K_ID = FDC_ID and K_enabled=1)'+
                       'Where fdc_sesid='+inttostr(SesID),'CSHFONDCAISSE','FDC_ID');
    Frm_Detail.GotoID(Dm_Main.Que_LigFndCais.FieldByName('FDC_ID').AsInteger);
    Frm_Detail.ShowModal;
  finally
    FreeAndNil(Frm_Detail);
  end;
end;

procedure TFrm_FndDeCaisse.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
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

procedure TFrm_FndDeCaisse.DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('C')) and (Shift = [ssCtrl]) then
    ClipBoard.AsText := DBGrid1.SelectedField.AsString;
end;

procedure TFrm_FndDeCaisse.DBGridTitleClick(Column: TColumn);
var
  Query : TIBOQuery;
  IdxTri, i : Integer;
begin
  // fonction generique de tri de DBGrid lié a une TIBOQuery

  // test de la query si c'est le bon type
  if Assigned(Column.Grid.DataSource) and
     Assigned(Column.Grid.DataSource.DataSet) and
     (Column.Grid.DataSource.DataSet is TIBOQuery) then
  begin
    // recup de la query
    Query := Column.Grid.DataSource.DataSet as TIBOQuery;
    // preparation des propriété tri
    if Query.OrderingItems.Count = 0 then
    begin
      Query.OrderingItems.Clear();
      Query.OrderingLinks.Clear();
      for i := 0 to Query.FieldCount -1 do
      begin
        Query.OrderingItems.Add(Query.Fields[i].FieldName + '=' + Query.Fields[i].FieldName + ' ASC;' + Query.Fields[i].FieldName + ' DESC');
        Query.OrderingLinks.Add(Query.Fields[i].FieldName + '=' + IntToStr(i +1))
      end;
    end;
    // trie lui meme
    IdxTri := Column.Index +1;
    if Abs(Query.OrderingItemNo) = IdxTri then
      Query.OrderingItemNo := -Query.OrderingItemNo
    else
      Query.OrderingItemNo :=IdxTri;
  end;
end;

procedure TFrm_FndDeCaisse.DBGrid2DblClick(Sender: TObject);
var
  Frm_Detail : TFrm_Detail;
begin
  Frm_Detail := TFrm_Detail.Create(Self);
  try
    Frm_Detail.InitEcr('select l.* from CSHFONDCOFFRE l '+
                       'join K on (K_ID = FCF_ID and K_enabled=1)'+
                       'Where fcf_libelle like '+QuotedStr('%'+SesNum+'%'),'CSHFONDCOFFRE','FCF_ID');
    Frm_Detail.ShowModal;
  finally
    FreeAndNil(Frm_Detail);
  end;
end;

procedure TFrm_FndDeCaisse.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
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

procedure TFrm_FndDeCaisse.DBGrid2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('C')) and (Shift = [ssCtrl]) then
    ClipBoard.AsText := DBGrid2.SelectedField.AsString;
end;

procedure TFrm_FndDeCaisse.DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
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

procedure TFrm_FndDeCaisse.DBGrid3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('C')) and (Shift = [ssCtrl]) then
    ClipBoard.AsText := DBGrid3.SelectedField.AsString;
end;

procedure TFrm_FndDeCaisse.FormActivate(Sender: TObject);
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

procedure TFrm_FndDeCaisse.FormCreate(Sender: TObject);
begin
  EtatFiche := false;
  ERefID.Text := '';
end;

procedure TFrm_FndDeCaisse.InitEcr(ASesNum: string; ASesID: integer; AEcart: string);
begin
  with Dm_Main do
  begin
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    try

      SesNum      := ASesNum;
      SesID       := ASesID;        

      // info session
      Edt_Num.Text := SesNum;
      Edt_ID.Text := inttostr(SesID);
      Edt_Ecart.Text := AEcart;

      // lignes fond de caisse
      with Que_LigFndCais do
      begin
        Close;
        ParamByName('SESID').AsInteger := SesID;
        Open;
      end;

      // coffre 
      with Que_Coffre do
      begin
        Close;
        ParamByName('SESNUM').AsString := '%'+SesNum+'%';
        Open;
      end;

      
    finally
      Screen.Cursor := crDefault;
      Application.ProcessMessages;
    end;
  end;
end;

procedure TFrm_FndDeCaisse.MenuItem1Click(Sender: TObject);
begin
  CopierIDAvecDesOR('FCF_ID', Dm_Main.Que_Coffre);
end;

procedure TFrm_FndDeCaisse.MenuItem2Click(Sender: TObject);
begin
  PreparerLesUpdates('CSHFONDCOFFRE', 'FCF_ID', Dm_Main.Que_Coffre);
end;

procedure TFrm_FndDeCaisse.MenuItem3Click(Sender: TObject);
begin
  PreparerLesK_ENABLEDa1('FCF_ID', Dm_Main.Que_Coffre);
end;

procedure TFrm_FndDeCaisse.MenuItem4Click(Sender: TObject);
begin 
  PreparerLesSuppPhy('CSHFONDCOFFRE', 'FCF_ID', Dm_Main.Que_Coffre);
end;

procedure TFrm_FndDeCaisse.MettretouslesIDavecKENABLED1etatsupprim2Click(Sender: TObject);
begin 
  PreparerLesK_ENABLEDa1('FDC_ID', Dm_Main.Que_LigFndCais);
end;

procedure TFrm_FndDeCaisse.Nbt_CopierEncaisClick(Sender: TObject);
var
  pt: TPoint;
begin
  GetCursorPos(pt);
  PopFndCais.Popup(pt.X,pt.y);
end;

procedure TFrm_FndDeCaisse.Prparertouslesupdates2Click(Sender: TObject);
begin
  PreparerLesUpdates('CSHFONDCAISSE', 'FDC_ID', Dm_Main.Que_LigFndCais);
end;

procedure TFrm_FndDeCaisse.Prparertouteslessuppressionsphysiques2Click(Sender: TObject);
begin     
  PreparerLesSuppPhy('CSHFONDCAISSE', 'FDC_ID', Dm_Main.Que_LigFndCais);
end;

end.
