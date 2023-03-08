unit Ticket_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, DB, dxmdaset, ExtCtrls, Buttons, Menus;

type
  TFrm_Ticket = class(TForm)
    Gbx_EntTick: TGroupBox;
    Label4: TLabel;
    Edt_TkeID: TEdit;
    Label5: TLabel;
    Edt_TkeNum: TEdit;
    Label6: TLabel;
    Edt_Qte1: TEdit;
    Label7: TLabel;
    Edt_Qte2: TEdit;
    Label8: TLabel;
    Edt_Qte3: TEdit;
    Label9: TLabel;
    Edt_Qte4: TEdit;
    Label10: TLabel;
    Edt_Tot1: TEdit;
    Label11: TLabel;
    Edt_Tot2: TEdit;
    Label12: TLabel;
    Edt_Tot3: TEdit;
    Label13: TLabel;
    Edt_Tot4: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    Edt_EntQte: TEdit;
    Edt_EntTot: TEdit;
    GroupBox1: TGroupBox;
    MemD_Art: TdxMemData;
    MemD_ArtTKL_ID: TIntegerField;
    MemD_ArtNom: TStringField;
    MemD_ArtQte: TIntegerField;
    MemD_ArtPTot: TFloatField;
    MemD_ArtCoefSS: TFloatField;
    MemD_ArtCoefBA: TFloatField;
    MemD_ArtPU: TFloatField;
    MemD_ArtPAtt: TFloatField;
    Ds_Art: TDataSource;
    DBGrid1: TDBGrid;
    MemD_ArtOkSStotal: TIntegerField;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Edt_ArtQte: TEdit;
    Label20: TLabel;
    Edt_ArtTot: TEdit;
    Label21: TLabel;
    Edt_TotLig: TEdit;
    Label22: TLabel;
    Edt_ArtBA: TEdit;
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    MemD_Csh: TdxMemData;
    Ds_Csh: TDataSource;
    MemD_CshENC_ID: TIntegerField;
    MemD_CshENC_MENID: TIntegerField;
    MemD_CshMnt: TFloatField;
    MemD_CshBA: TFloatField;
    MemD_CshNom: TStringField;
    DBGrid2: TDBGrid;
    Label23: TLabel;
    Edt_CshTot: TEdit;
    MemD_Cli: TdxMemData;
    Ds_Cli: TDataSource;
    MemD_CliCTE_ID: TIntegerField;
    MemD_CliCTE_CLTID: TIntegerField;
    MemD_CliCredit: TFloatField;
    MemD_CliDebit: TFloatField;
    MemD_CliLib: TStringField;
    MemD_CliClient: TStringField;
    DBGrid3: TDBGrid;
    Label24: TLabel;
    Edt_CliTot: TEdit;
    Label25: TLabel;
    Edt_DiffEntArt: TEdit;
    Label26: TLabel;
    Edt_DiffEntCsh: TEdit;
    MemD_ArtTxTva: TFloatField;
    Label27: TLabel;
    Edt_DiffArtEnt: TEdit;
    Label28: TLabel;
    Edt_DiffArtCsh: TEdit;
    MemD_CshMEN_TYPEMOD: TIntegerField;
    Label29: TLabel;
    Edt_CptCli: TEdit;
    Label30: TLabel;
    Edt_TotCsh: TEdit;
    Label31: TLabel;
    Edt_TotCli: TEdit;
    Label32: TLabel;
    Edt_DiffCshEnt: TEdit;
    Label33: TLabel;
    Edt_DiffCshArt: TEdit;
    Nbt_ActionArt: TBitBtn;
    PopArt: TPopupMenu;
    Mettrepartoutleprixattendu1: TMenuItem;
    MemD_CshERREUR: TStringField;
    Lab_CshErr: TLabel;
    MemD_Clitipe: TIntegerField;
    Edt_Cli123: TEdit;
    Label34: TLabel;
    Edt_Cli4: TEdit;
    Label35: TLabel;
    Label36: TLabel;
    Edt_Cli6: TEdit;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Pressepapier1: TMenuItem;
    CopiertouslesTKLIDdanslepressepapier2: TMenuItem;
    prparertouslesupdates1: TMenuItem;
    MettretouslesIDavecKENABLED1etatsupprim1: TMenuItem;
    Prparertouteslessuppressionsphysiques1: TMenuItem;
    Nbt_CopierEncais: TBitBtn;
    Nbt_CopierCli: TBitBtn;
    PopEncais: TPopupMenu;
    CopiertouslesIDavecdesOR1: TMenuItem;
    Prparertouslesupdates2: TMenuItem;
    MettretouslesIDavecKENABLED1etatsupprim2: TMenuItem;
    Prparertouteslessuppressionsphysiques2: TMenuItem;
    PopCli: TPopupMenu;
    CopierCliIDOr: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    Creerunenouvelleligne1: TMenuItem;
    Creerunenouvelleligne2: TMenuItem;
    Creerunenouvelleligne3: TMenuItem;
    Nbt_DetEnt: TBitBtn;
    Nbt_VoirTick: TBitBtn;
    Label42: TLabel;
    splSplitter1: TSplitter;
    splSplitter2: TSplitter;
    pnlTop: TPanel;
    Gbx_InfoSession: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edt_Num: TEdit;
    Edt_ID: TEdit;
    Edt_Ecart: TEdit;
    Nbt_cancel: TBitBtn;
    btnGLobalAction: TBitBtn;
    pmGlobalAction: TPopupMenu;
    mniEntete: TMenuItem;
    mniLigne: TMenuItem;
    mniEncaissement: TMenuItem;
    mniVoirLeTicket: TMenuItem;
    mniEnteteDetail: TMenuItem;
    mniLigneDetail: TMenuItem;
    mniEncaissementDetail: TMenuItem;
    mniCompteClient: TMenuItem;
    mniCompteDetail: TMenuItem;
    mniLigneToutes: TMenuItem;
    mniLigneSelectionnee: TMenuItem;
    mniLigneNew: TMenuItem;
    mniLigneTCopierID: TMenuItem;
    mniLigneTPerpUpdate: TMenuItem;
    mniLigneTPrepSupprLog: TMenuItem;
    mniLigneTPrepSupprPhy: TMenuItem;
    mniLigneUCopierID: TMenuItem;
    mniLigneUPreprUpdate: TMenuItem;
    mniLigneUPrepSupprLog: TMenuItem;
    mniLigneUPrepSupprsPhy: TMenuItem;
    mniEncaissementTous: TMenuItem;
    mniEncaissementTPrepSupprPhy: TMenuItem;
    mniEncaissementTPrepSupprLog: TMenuItem;
    mniEncaissementTPrepUpdate: TMenuItem;
    mniEncaissementTCopierID: TMenuItem;
    mniEncaissementSelectionne: TMenuItem;
    mniEncaissementUPrepSupprPhy: TMenuItem;
    mniEncaissementUPrepSupprLog: TMenuItem;
    mniEncaissementUPrepUpdate: TMenuItem;
    mniEncaissementUCopierID: TMenuItem;
    mniEncaissementNew: TMenuItem;
    mniCompteTous: TMenuItem;
    mniCompteTPrepSupprPhy: TMenuItem;
    mniCompteTPrepSupprLog: TMenuItem;
    mniCompteTPrepUpdate: TMenuItem;
    mniCompteTCopierID: TMenuItem;
    mniCompteSelectionne: TMenuItem;
    mniCompteUPrepSupprPhy: TMenuItem;
    mniCompteUPrepSupprLog: TMenuItem;
    mniCompteUPrepUpdate: TMenuItem;
    mniCompteUCopierID: TMenuItem;
    mniCompteNew: TMenuItem;
    mniEntetePreparerUpdate: TMenuItem;
    mniEnteteCopierID: TMenuItem;
    mniN1: TMenuItem;
    mniN2: TMenuItem;
    mniBonLocation: TMenuItem;
    mniN3: TMenuItem;
    mniN4: TMenuItem;
    mniN5: TMenuItem;
    mniN6: TMenuItem;
    mdtTicket: TdxMemData;
    mniN7: TMenuItem;
    mniN8: TMenuItem;
    mniLigneTChgPxU: TMenuItem;
    mniLigneUChgPxU: TMenuItem;
    mdtTickettke_id: TIntegerField;
    mdtTickettke_numero: TStringField;
    mdtTickettke_qtea1: TIntegerField;
    mdtTickettke_qtea2: TIntegerField;
    mdtTickettke_qtea3: TIntegerField;
    mdtTickettke_qtea4: TIntegerField;
    mdtTickettke_totneta1: TFloatField;
    mdtTickettke_totneta2: TFloatField;
    mdtTickettke_totneta3: TFloatField;
    mdtTickettke_totneta4: TFloatField;
    mniN9: TMenuItem;
    mniEncaissementUChgMnt: TMenuItem;
    Edt_BACASH: TEdit;
    Edt_AcompteCash: TEdit;
    Edt_CCCash: TEdit;

    N1: TMenuItem;
    mniCorrectionTicketAvecRemiseFideliteSansBon: TMenuItem;
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure Nbt_ActionArtClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Mettrepartoutleprixattendu1Click(Sender: TObject);
    procedure Ds_CshDataChange(Sender: TObject; Field: TField);
    procedure CopiertouslesTKLIDdanslepressepapier2Click(Sender: TObject);
    procedure prparertouslesupdates1Click(Sender: TObject);
    procedure MettretouslesIDavecKENABLED1etatsupprim1Click(Sender: TObject);
    procedure Prparertouteslessuppressionsphysiques1Click(Sender: TObject);
    procedure Nbt_CopierEncaisClick(Sender: TObject);
    procedure Nbt_CopierCliClick(Sender: TObject);
    procedure CopiertouslesIDavecdesOR1Click(Sender: TObject);
    procedure Prparertouslesupdates2Click(Sender: TObject);
    procedure MettretouslesIDavecKENABLED1etatsupprim2Click(Sender: TObject);
    procedure Prparertouteslessuppressionsphysiques2Click(Sender: TObject);
    procedure CopierCliIDOrClick(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure Creerunenouvelleligne1Click(Sender: TObject);
    procedure Creerunenouvelleligne2Click(Sender: TObject);
    procedure Creerunenouvelleligne3Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure Nbt_DetEntClick(Sender: TObject);
    procedure Nbt_VoirTickClick(Sender: TObject);
    procedure DBGridTitleClick(Column: TColumn);
    procedure btnGLobalActionClick(Sender: TObject);

    procedure mniVoirLeTicketClick(Sender: TObject);
    procedure mniEnteteDetailClick(Sender: TObject);
    procedure mniEnteteCopierIDClick(Sender: TObject);
    procedure mniEntetePreparerUpdateClick(Sender: TObject);
    procedure mniLigneDetailClick(Sender: TObject);
    procedure mniLigneTCopierIDClick(Sender: TObject);
    procedure mniLigneTPerpUpdateClick(Sender: TObject);
    procedure mniLigneTPrepSupprLogClick(Sender: TObject);
    procedure mniLigneTPrepSupprPhyClick(Sender: TObject);
    procedure mniLigneUCopierIDClick(Sender: TObject);
    procedure mniLigneUPreprUpdateClick(Sender: TObject);
    procedure mniLigneUPrepSupprLogClick(Sender: TObject);
    procedure mniLigneUPrepSupprsPhyClick(Sender: TObject);
    procedure mniLigneNewClick(Sender: TObject);
    procedure mniEncaissementDetailClick(Sender: TObject);
    procedure mniEncaissementTCopierIDClick(Sender: TObject);
    procedure mniEncaissementTPrepUpdateClick(Sender: TObject);
    procedure mniEncaissementTPrepSupprLogClick(Sender: TObject);
    procedure mniEncaissementTPrepSupprPhyClick(Sender: TObject);
    procedure mniEncaissementUCopierIDClick(Sender: TObject);
    procedure mniEncaissementUPrepUpdateClick(Sender: TObject);
    procedure mniEncaissementUPrepSupprLogClick(Sender: TObject);
    procedure mniEncaissementUPrepSupprPhyClick(Sender: TObject);
    procedure mniEncaissementNewClick(Sender: TObject);
    procedure mniCompteDetailClick(Sender: TObject);
    procedure mniCompteTCopierIDClick(Sender: TObject);
    procedure mniCompteTPrepUpdateClick(Sender: TObject);
    procedure mniCompteTPrepSupprLogClick(Sender: TObject);
    procedure mniCompteTPrepSupprPhyClick(Sender: TObject);
    procedure mniCompteUCopierIDClick(Sender: TObject);
    procedure mniCompteUPrepUpdateClick(Sender: TObject);
    procedure mniCompteUPrepSupprLogClick(Sender: TObject);
    procedure mniCompteUPrepSupprPhyClick(Sender: TObject);
    procedure mniCompteNewClick(Sender: TObject);
    procedure mniBonLocationClick(Sender: TObject);
    procedure mniLigneUChgPxUClick(Sender: TObject);
    procedure mniLigneTChgPxUClick(Sender: TObject);
    procedure pmGlobalActionPopup(Sender: TObject);
    procedure mniEncaissementUChgMntClick(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mniCorrectionTicketAvecRemiseFideliteSansBonClick(Sender: TObject);
  private
    { Déclarations privées }
    SesNum: string;
    SesID: integer;
    TkeID: integer;
    vEntTot: Double;
    vArtTot: double;
    vCshMnt: double;
    vCshCli: double;
    vCli123: double;
    vCli4: double;
    vCli6: double;
    vCliMnt: double;
    vBonAch: double;
    vBonLoc: double;
    procedure WMSysCommand(var Msg: TWMSyscommand); message WM_SYSCOMMAND;

    function GetRequeteChgPrxUneLigne() : string;
  public
    { Déclarations publiques }
    LstScript: TStringList;
    LstReq: TStringList;
    procedure InitEcr(ASesNum: string; ASesID: integer; AEcart: string; ATkeID: integer);
  end;

implementation

uses
  Math,
  Main_Dm,
  ClipBrd,
  Detail_Frm,
  VoirTicket_Frm,
  Location_Frm,
  SasieFloat_Frm,
  SasieEncaissement_Frm;

{$R *.dfm}

procedure MetValeurDiff(AEdit: TEdit; Value: double);
begin
  if abs(Value)<0.009 then
  begin
    AEdit.Text := '0';
    AEdit.Color := rgb(192,224,255);
  end
  else
  begin
    AEdit.Text := FloatToStr(Value);
    AEdit.Color := rgb(255,202,202);
  end;
end;

procedure MetValeurMontant(AEdit : TEdit; Value: double);
begin
  if abs(StrToFloatDef(AEdit.Text, 0) - Value) < 0.009 then
  begin
    AEdit.Color := rgb(192,224,255);
  end
  else
  begin
    AEdit.Color := rgb(255,202,202);
  end;
end;

procedure TFrm_Ticket.WMSysCommand(var Msg: TWMSyscommand);
begin
  // intercepte le clic sur le bouton minimise
  if ((msg.CmdType and $FFF0) = SC_MINIMIZE) then begin  
    Msg.Result:=1;
    Application.Minimize;
    exit;
  end;
  inherited;
end;

procedure TFrm_Ticket.btnGLobalActionClick(Sender: TObject);
var
  pt : TPoint;
begin
  GetCursorPos(pt);
  pmGlobalAction.PopupComponent := TComponent(Sender);
  pmGlobalAction.Popup(pt.X,pt.y);
end;

procedure TFrm_Ticket.CopierCliIDOrClick(Sender: TObject);
begin
  CopierIDAvecDesOR('CTE_ID', MemD_Cli);
end;

procedure TFrm_Ticket.CopiertouslesIDavecdesOR1Click(Sender: TObject);
begin
  CopierIDAvecDesOR('ENC_ID', MemD_Csh);
end;

procedure TFrm_Ticket.CopiertouslesTKLIDdanslepressepapier2Click(Sender: TObject);
begin
  CopierIDAvecDesOR('TKL_ID', MemD_Art);
end;

procedure TFrm_Ticket.Creerunenouvelleligne1Click(Sender: TObject);
begin
  CreerNouvLigne('CSHTICKETL', 'TKL_ID');
end;

procedure TFrm_Ticket.Creerunenouvelleligne2Click(Sender: TObject);
begin
  CreerNouvLigne('CSHENCAISSEMENT', 'ENC_ID');
end;

procedure TFrm_Ticket.Creerunenouvelleligne3Click(Sender: TObject);
begin
  CreerNouvLigne('CLTCOMPTE', 'CTE_ID');
end;

procedure TFrm_Ticket.DBGrid1DblClick(Sender: TObject);
var
  Frm_Detail : TFrm_Detail;
begin
  Frm_Detail := TFrm_Detail.Create(Self);
  try
    Frm_Detail.InitEcr('select l.* from cshticketl l '+
                       'join K on (K_ID = TKL_ID and K_enabled=1)'+
                       'Where TKL_TKEID='+inttostr(TkeID),'cshticketl','TKL_ID');
    Frm_Detail.ShowModal;
  finally
    FreeAndNil(Frm_Detail);
  end;
end;

procedure TFrm_Ticket.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
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
      if (MemD_Art.Active) and (MemD_Art.RecordCount>0) then
      begin
        if MemD_Art.fieldbyname('OkSSTotal').AsInteger>0 then
          ChBrush := rgb(0,96,153)
        else
        begin
          if Abs(MemD_Art.fieldbyname('PU').AsFloat-MemD_Art.fieldbyname('PAtt').AsFloat)>0.009 then
            ChBrush := rgb(153,0,0)
        end;
      end;
    end
    else
    begin
      ChFont := clBlack;
      ChBrush := rgb(202,255,202);
      if (MemD_Art.Active) and (MemD_Art.RecordCount>0) then
      begin
        if MemD_Art.fieldbyname('OkSSTotal').AsInteger>0 then
          ChBrush := rgb(202,228,255)
        else
        begin
          if Abs(MemD_Art.fieldbyname('PU').AsFloat-MemD_Art.fieldbyname('PAtt').AsFloat)>0.009 then
            ChBrush := rgb(255,202,202)
        end;
      end;
    end;

    Font.Color := chFont;
    Brush.Color := chBrush;
    TDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State); 
    Font.Color := savFont;
    Brush.Color := savBrush;

  end;
end;

procedure TFrm_Ticket.DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('C')) and (Shift = [ssCtrl]) then
    ClipBoard.AsText := DBGrid1.SelectedField.AsString;
end;

procedure TFrm_Ticket.DBGridTitleClick(Column: TColumn);
var
  Query : TdxMemData;
begin
  // fonction generique de tri de DBGrid lié a une TIBOQuery

  // test de la query si c'est le bon type
  if Assigned(Column.Grid.DataSource) and
     Assigned(Column.Grid.DataSource.DataSet) and
     (Column.Grid.DataSource.DataSet is TdxMemData) then
  begin
    // recup de la query
    Query := Column.Grid.DataSource.DataSet as TdxMemData;
    // trie lui meme
    if Query.SortedField = Column.FieldName then
    begin
      if soDesc in Query.SortOptions then
        Query.SortOptions := [soCaseInsensitive]
      else
        Query.SortOptions := [soDesc, soCaseInsensitive];
    end
    else
    begin
      Query.SortOptions := [soCaseInsensitive];
      Query.SortedField := Column.FieldName;
    end;
  end;
end;

procedure TFrm_Ticket.DBGrid2DblClick(Sender: TObject);
var
  Frm_Detail : TFrm_Detail;
begin
  Frm_Detail := TFrm_Detail.Create(Self);
  try
    Frm_Detail.InitEcr('select c.* from CSHENCAISSEMENT c '+
                       'join K on (K_ID = ENC_ID and K_enabled=1)'+
                       'Where ENC_TkeId='+inttostr(TkeID),'CSHENCAISSEMENT','ENC_ID');
    Frm_Detail.ShowModal;
  finally
    FreeAndNil(Frm_Detail);
  end;
end;

procedure TFrm_Ticket.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
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
      if (MemD_Csh.Active) and (MemD_Csh.RecordCount>0) then
      begin
        if (MemD_Csh.fieldbyname('ERREUR').AsString<>'') then
          ChBrush := rgb(153,0,0);
      end;
    end
    else
    begin
      ChFont := clBlack;
      ChBrush := rgb(202,255,202);    
      if (MemD_Csh.Active) and (MemD_Csh.RecordCount>0) then
      begin
        if (MemD_Csh.fieldbyname('ERREUR').AsString<>'') then
          ChBrush := rgb(255,202,202);
      end;
    end;

    Font.Color := chFont;
    Brush.Color := chBrush;
    TDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State); 
    Font.Color := savFont;
    Brush.Color := savBrush;

  end;
end;

procedure TFrm_Ticket.DBGrid2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('C')) and (Shift = [ssCtrl]) then
    ClipBoard.AsText := DBGrid2.SelectedField.AsString;
end;

procedure TFrm_Ticket.DBGrid3DblClick(Sender: TObject);
var
  Frm_Detail : TFrm_Detail;
begin
  Frm_Detail := TFrm_Detail.Create(Self);
  try
    Frm_Detail.InitEcr('select c.* from cltcompte c '+
                       'Join k on (k_id=CTE_ID and k_enabled=1)'+
                       'where CTE_TKEID='+inttostr(TkeID),'cltcompte','CTE_ID');
    Frm_Detail.ShowModal;
  finally
    FreeAndNil(Frm_Detail);
  end;
end;

procedure TFrm_Ticket.DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
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
      if (MemD_Cli.Active) and (MemD_Cli.RecordCount>0) then
      begin
        if (MemD_Cli.fieldbyname('CTE_CLTID').AsInteger=0) then
          ChBrush := rgb(153,0,0)
      end;
    end
    else
    begin
      ChFont := clBlack;
      ChBrush := rgb(202,255,202); 
      if (MemD_Cli.Active) and (MemD_Cli.RecordCount>0) then
      begin
        if (MemD_Cli.fieldbyname('CTE_CLTID').AsInteger=0) then
          ChBrush := rgb(255,202,202)
      end;
    end;

    Font.Color := chFont;
    Brush.Color := chBrush;
    TDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
    Font.Color := savFont;
    Brush.Color := savBrush;

  end;
end;

procedure TFrm_Ticket.DBGrid3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('C')) and (Shift = [ssCtrl]) then
    ClipBoard.AsText := DBGrid3.SelectedField.AsString;
end;

procedure TFrm_Ticket.Ds_CshDataChange(Sender: TObject; Field: TField);
begin
  if MemD_Csh.FieldByName('ERREUR').AsString<>'' then
  begin
    Lab_CshErr.Caption := MemD_Csh.FieldByName('ERREUR').AsString;
    Lab_CshErr.Visible := true;
  end
  else
    Lab_CshErr.Visible := false;
end;

procedure TFrm_Ticket.FormCreate(Sender: TObject);
begin
  LstScript := TStringList.Create;
  LstReq := TStringList.Create;
end;

procedure TFrm_Ticket.FormDestroy(Sender: TObject);
begin
  LstScript.Free;
  LstScript := nil;
  LstReq.Free;
  LstReq := nil;
end;

procedure TFrm_Ticket.InitEcr(ASesNum: string; ASesID: integer; AEcart: string; ATkeID: integer);
var
  coefBA: Double;
  ArtQte: integer;  
  TmpQte: integer;
  TmpPx: double;
  TmpTot: double;
  TmpAtt: double;
  coefSS: double;  
  vSSTotal: integer;
  Client: string;
  ModEnc: string;
  ModType: integer;
  ModSupp: boolean;
  sErreur: string;
  vEntLoc: double;
  MntBonLoc : double;

  bIsCashSession: Boolean;
  vTicketCash_BonAchat: double;
  vTicketCash_EmissionAcompte: double;
  vTicketCash_EmissionCarteCadeau: double;
  PSPiedTicketCASH: double;
  PBACASH: double;
begin
  with Dm_Main.Que_Div, SQL do
  begin
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    try
      SesNum := ASesNum;
      SesID := ASesID;
      TkeID := ATkeID;

      // info session
      Edt_Num.Text := SesNum;
      Edt_ID.Text := inttostr(SesID);
      Edt_Ecart.Text := AEcart;

      // info entete
      Edt_TkeID.Text := inttostr(ATkeID);
      Clear;
      Add('select tke_id, tke_numero,');
      Add('tke_qtea1, tke_qtea2, tke_qtea3, tke_qtea4,');
      Add('tke_totneta1, tke_totneta2, tke_totneta3, tke_totneta4');
      Add('from cshticket ');
      Add('join k on (k_id=tke_id and k_enabled=1)');
      Add('where tke_id='+inttostr(ATkeID));
      Active:=true;
      // information d'entete
      mdtTicket.Close();
      mdtTicket.Open();
      mdtTicket.Append();
      mdtTicket.FieldByName('tke_id').AsInteger := ATkeID;
      mdtTicket.FieldByName('tke_numero').AsString := fieldbyname('TKE_NUMERO').AsString;
      mdtTicket.FieldByName('tke_qtea1').AsInteger := fieldbyname('tke_qtea1').AsInteger;
      mdtTicket.FieldByName('tke_qtea2').AsInteger := fieldbyname('tke_qtea2').AsInteger;
      mdtTicket.FieldByName('tke_qtea3').AsInteger := fieldbyname('tke_qtea3').AsInteger;
      mdtTicket.FieldByName('tke_qtea4').AsInteger := fieldbyname('tke_qtea4').AsInteger;
      mdtTicket.FieldByName('tke_totneta1').AsFloat := fieldbyname('tke_totneta1').AsFloat;
      mdtTicket.FieldByName('tke_totneta2').AsFloat := fieldbyname('tke_totneta2').AsFloat;
      mdtTicket.FieldByName('tke_totneta3').AsFloat := fieldbyname('tke_totneta3').AsFloat;
      mdtTicket.FieldByName('tke_totneta4').AsFloat := fieldbyname('tke_totneta4').AsFloat;
      mdtTicket.Post();
      Active:=false;

      // afichage
      Edt_TkeNum.Text := mdtTicket.fieldbyname('TKE_NUMERO').AsString;
      Edt_Qte1.Text := inttostr(mdtTicket.fieldbyname('tke_qtea1').AsInteger);
      Edt_Qte2.Text := inttostr(mdtTicket.fieldbyname('tke_qtea2').AsInteger);
      Edt_Qte3.Text := inttostr(mdtTicket.fieldbyname('tke_qtea3').AsInteger);
      Edt_Qte4.Text := inttostr(mdtTicket.fieldbyname('tke_qtea4').AsInteger);
      Edt_EntQte.Text := inttostr(mdtTicket.fieldbyname('tke_qtea1').AsInteger+
                                  mdtTicket.fieldbyname('tke_qtea2').AsInteger+
                                  mdtTicket.fieldbyname('tke_qtea3').AsInteger+
                                  mdtTicket.fieldbyname('tke_qtea4').AsInteger);

      Edt_Tot1.Text := FloatToStr(mdtTicket.fieldbyname('tke_totneta1').AsFloat);
      Edt_Tot2.Text := FloatToStr(mdtTicket.fieldbyname('tke_totneta2').AsFloat);
      Edt_Tot3.Text := FloatToStr(mdtTicket.fieldbyname('tke_totneta3').AsFloat);
      Edt_Tot4.Text := FloatToStr(mdtTicket.fieldbyname('tke_totneta4').AsFloat);
      vEntTot := mdtTicket.fieldbyname('tke_totneta1').AsFloat+
                 mdtTicket.fieldbyname('tke_totneta2').AsFloat+
                 mdtTicket.fieldbyname('tke_totneta3').AsFloat+
                 mdtTicket.fieldbyname('tke_totneta4').AsFloat;
      vEntLoc := mdtTicket.fieldbyname('tke_totneta2').AsFloat;
      Edt_EntTot.Text := FloatToStr(vEntTot);

      // ligne art
      //     bon d'achat et coef ba pour les lignes art
      coefBA := 1.0;
      vBonAch := 0.0;
      Active:=false;
      Clear;
      Add('select men_application, sum(ENC_BA) as BA');
      Add('from CSHENCAISSEMENT');
      Add('join K on (K_ID = ENC_ID and K_enabled=1)');
      Add('join cshmodeenc on men_id = enc_menid');
      Add('Where ENC_TkeId='+inttostr(TkeID));
      Add('group by men_application');
      Active:=true;
      while not Eof do
      begin
        case fieldbyname('men_application').AsInteger of
          1 : vBonAch := fieldbyname('BA').AsFloat;
          2 : vBonLoc := fieldbyname('BA').AsFloat;
        end;
        Next;
      end;
      Active:=false;

      // Correction sur la gestion du CoefBa
      if vBonAch <> 0 then
      begin
        Active:=false;
        Clear;
        Add('select sum(tkl_pxnet)');
        Add('from cshticket join cshticketl on tkl_tkeid = tke_id');
        Add('where tke_id = ' + inttostr(TkeID));
        Active := true;
        if Fields[0].AsFloat <> 0 then
          coefBA := (Fields[0].AsFloat - vBonAch) / Fields[0].AsFloat
        else
          coefBA := 1;
        Active := false;
      end
      else
        coefBA := 1;

      bIsCashSession := Dm_Main.SessionIsCashSession(SesID);
      vTicketCash_BonAchat := 0;
      PBACASH := 1.0;
      if bIsCashSession then
      begin
        // Pour les sessions CASH les bon achats fidélités ne sont pas dans les encaissements
        vTicketCash_BonAchat := dm_Main.GetTicketCASH_BonAchatValue(TkeID);
        PBACASH := dm_main.GetTicketCASH_BonAchatPercent(TkeID);

        vTicketCash_EmissionCarteCadeau := dm_Main.GetTicketCASH_EmissionCarteCadeau(TkeID);
        vTicketCash_EmissionAcompte := dm_Main.GetTicketCASH_EmissionAcompte(TkeID);
      end;
      Edt_BACASH.Visible := bIsCashSession;
      Edt_BACASH.Text := FloatToStr(vTicketCash_BonAchat);

      Edt_AcompteCash.Visible := bIsCashSession;
      Edt_AcompteCash.Text := FloatToStr(vTicketCash_EmissionAcompte);

      Edt_CCCash.Visible := bIsCashSession;
      Edt_CCCash.Text := FloatToStr(vTicketCash_EmissionCarteCadeau);
//      coefBA := coefBA + PBACASH;

      MemD_Art.Active := false;
      MemD_Art.Active := true;
      ArtQte := 0;
      vArtTot := vEntLoc;
      Clear;
      Add('select TKL_ID, TKL_NOM, ART_NOM, TKL_GPSSTOTAL, TKL_INSSTOTAL, TKL_SSTOTAL, TKL_PXBRUT, '+
                  'TKL_QTE, TKL_PXNET, TKL_PXNN, TKL_TVA');
      Add('from cshticketl ');
      Add('join K on (K_ID = TKL_ID and K_enabled=1)');
      Add('join artarticle on (art_id=tkl_artid)');
      Add('Where TKL_TKEID='+inttostr(TkeID));
      Add('order by tkl_gpsstotal,tkl_sstotal,tkl_id');
      Active := true;
      First;
      while not(Eof) do
      begin
        if fieldbyname('TKL_SSTOTAL').AsInteger <> 0 then
        begin
          coefSS := 1.0;
          if not(Eof) and (ArrondiA2(fieldbyname('TKL_PXBRUT').AsFloat)<>0) then
            coefSS := 1-((abs(fieldbyname('TKL_PXBRUT').AsFloat)-abs(fieldbyname('TKL_PXNET').AsFloat))/abs(fieldbyname('TKL_PXBRUT').AsFloat));
          MemD_Art.Append;
          MemD_Art.FieldByName('TKL_ID').AsInteger := fieldbyname('TKL_ID').AsInteger;   
          MemD_Art.FieldByName('Nom').AsString := fieldbyname('TKL_NOM').AsString;
          MemD_Art.FieldByName('PTot').AsFloat := fieldbyname('TKL_PXBRUT').AsFloat;
          MemD_Art.FieldByName('CoefSS').AsFloat := coefSS;
          MemD_Art.FieldByName('PU').AsFloat := fieldbyname('TKL_PXNET').AsFloat;
          MemD_Art.FieldByName('OkSStotal').AsInteger := 1;  
          MemD_Art.FieldByName('TxTva').AsFloat := fieldbyname('TKL_TVA').AsFloat;
          MemD_Art.Post;
        end
        else
        begin
          TmpQte := fieldbyname('TKL_QTE').AsInteger;
          TmpPx := fieldbyname('TKL_PXNN').AsFloat;
          TmpTot := fieldbyname('TKL_PXNET').AsFloat;
          //calcul du % au sous total
          coefSS := 1.0;
          vSSTotal := -1;
          if fieldbyname('TKL_INSSTOTAL').AsInteger=1 then
            vSSTotal := fieldbyname('TKL_GPSSTOTAL').AsInteger;
          if vSSTotal>=0 then
          begin  
            with Dm_Main.Que_Div2, SQL do
            begin
              Active:=false;
              Clear;
              Add('select TKL_PXBRUT,TKL_PXNET');
              Add('from cshticketl join K on (K_ID = TKL_ID and K_enabled=1)');
              Add('Where TKL_GPSSTOTAL='+inttostr(vSSTotal));
              Add('  and TKL_SSTOTAL=1');
              Add('  and TKL_TKEID='+inttostr(TkeID));
              Active:=true;
              First;
              if not(Eof) and (ArrondiA2(fieldbyname('TKL_PXBRUT').AsFloat)<>0) then
                coefSS := 1-((abs(fieldbyname('TKL_PXBRUT').AsFloat)-abs(fieldbyname('TKL_PXNET').AsFloat))/abs(fieldbyname('TKL_PXBRUT').AsFloat));
              Active:=false;
            end;
          end;

          PSPiedTicketCASH := 1.0;
          if bIsCashSession then
          begin
            // Pour les sessions CASH il faut prendre en compte la remise pied de ticket.
            with Dm_Main.Que_Div2, SQL do
            begin
              Active:=false;
              Clear;
              Add('select TKE_REMISE ');
              Add('from cshticket join K on (K_ID = TKE_ID and K_enabled=1) ');
              Add('Where ');
              Add('  TKE_ID='+inttostr(TkeID));
              Active:=true;
              First;
              if not(Eof) and (ArrondiA2(fieldbyname('TKE_REMISE').AsFloat)<>0) then
                PSPiedTicketCASH := 1-(ArrondiA2(fieldbyname('TKE_REMISE').AsFloat)/100);
              Active:=false;
            end;
          end;

          TmpAtt := TmpPx;
          if ArrondiA2(TmpQte)<>0 then
            TmpAtt := (CoefBA*PBACASH*PSPiedTicketCASH*CoefSS*TmpTot)/TmpQte;

          MemD_Art.Append;
          MemD_Art.FieldByName('TKL_ID').AsInteger := fieldbyname('TKL_ID').AsInteger;
          MemD_Art.FieldByName('Nom').AsString := fieldbyname('ART_NOM').AsString;
          MemD_Art.FieldByName('PTot').AsFloat := TmpTot;
          MemD_Art.FieldByName('CoefSS').AsFloat := coefSS;
          MemD_Art.FieldByName('CoefBA').AsFloat := coefBA;
          MemD_Art.FieldByName('Qte').AsInteger := TmpQte;
          MemD_Art.FieldByName('PU').AsFloat := TmpPx;
          MemD_Art.FieldByName('PAtt').AsFloat := TmpAtt;
          MemD_Art.FieldByName('OkSStotal').AsInteger := 0;
          MemD_Art.Post;

          ArtQte := ArtQte+TmpQte;
          vArtTot := vArtTot+(TmpQte*TmpPx);
        end;

        Next;
      end;
      Active := false;
      MemD_Art.First;

      Edt_ArtQte.Text := inttostr(ArtQte);
      Edt_TotLig.Text := FloatToStr(vArtTot);
      Edt_ArtBA.Text := FloatToStr(vBonAch);
      vArtTot := vArtTot+vBonAch;
      Edt_ArtTot.Text := FloatToStr(vArtTot);  

      // location
      MntBonLoc := 0;
      Dm_Main.Que_Div.SQL.Clear();
      Dm_Main.Que_Div.SQL.Add('select sum(loa_pxnn)');
      Dm_Main.Que_Div.SQL.Add('from locbonlocation join k on k_id = loc_id and k_enabled = 1');
      Dm_Main.Que_Div.SQL.Add('join locbonlocationligne join k on k_id = loa_id and k_enabled = 1 on loa_locid = loc_id and loa_typeligne between 1 and 3');
      Dm_Main.Que_Div.SQL.Add('where loc_tkeid = ' + inttostr(TkeID) + ' and loc_typedoc = 2');
      try
        Dm_Main.Que_Div.Open();
        if not Dm_Main.Que_Div.Eof then
          MntBonLoc := Dm_Main.Que_Div.Fields[0].AsFloat;
      finally
        Dm_Main.Que_Div.Close();
      end;

      // compte client
      vCliMnt := 0.0;
      vCli123 := 0.0;
      vCli4 := 0.0;
      vCli6 := 0.0;
      MemD_Cli.Active := false;
      MemD_Cli.Active := true;
      Clear;
      Add('Select clt_nom,clt_prenom, a.*');
      Add('from cltcompte a');
      Add('Join k on (k_id=CTE_ID and k_enabled=1)');
      Add('join CLTCLIENT b on (CLT_ID=cte_cltid)');
      Add('where CTE_TKEID='+inttostr(TkeID));
      Add('order by CTE_ID');
      Active:=true;
      First;
      while not(Eof) do
      begin
        Client := fieldbyname('clt_nom').AsString;
        if (Client<>'') and (fieldbyname('clt_prenom').AsString<>'') then
          Client := Client+' ';
        Client := Client+fieldbyname('clt_prenom').AsString;

        if (fieldbyname('cte_typ').AsInteger in [1..3]) then
          vCli123 := vCli123+fieldbyname('cte_credit').AsFloat-fieldbyname('cte_debit').AsFloat
        else if (fieldbyname('cte_typ').AsInteger=4) then
          vCli4 := vCli4+fieldbyname('cte_credit').AsFloat-fieldbyname('cte_debit').AsFloat
        else if (fieldbyname('cte_typ').AsInteger=6) then
          vCli6 := vCli6+fieldbyname('cte_credit').AsFloat-fieldbyname('cte_debit').AsFloat;

        vCliMnt := vCliMnt+fieldbyname('cte_credit').AsFloat-fieldbyname('cte_debit').AsFloat;

        MemD_Cli.Append;
        MemD_Cli.fieldbyname('CTE_ID').AsInteger := fieldbyname('CTE_ID').AsInteger;
        MemD_Cli.fieldbyname('CTE_CLTID').AsInteger := fieldbyname('cte_cltid').AsInteger;
        MemD_Cli.fieldbyname('Tipe').AsInteger := fieldbyname('cte_typ').AsInteger;
        MemD_Cli.fieldbyname('Credit').AsFloat := fieldbyname('cte_credit').AsFloat;
        MemD_Cli.fieldbyname('Debit').AsFloat := fieldbyname('cte_debit').AsFloat;
        MemD_Cli.fieldbyname('Lib').AsString := fieldbyname('cte_libelle').AsString;
        MemD_Cli.fieldbyname('Client').AsString := Client;
        MemD_Cli.Post;

        Next;
      end;
      Active := false;
      Edt_Cli123.Text := FloatToStr(vCli123);
      Edt_Cli4.Text := FloatToStr(vCli4);
      Edt_Cli6.Text := FloatToStr(vCli6);
      Edt_CliTot.Text := FloatToStr(vCliMnt);

      //encaissement
      vCshMnt := 0.0;
      vCshCli := 0.0;
      MemD_Csh.Active := false;
      MemD_Csh.Active := true;
      Clear;
      Add('select ENC_ID, ENC_MENID,ENC_MONTANT,ENC_BA,MEN_NOM, MEN_TYPEMOD');
      Add('from CSHENCAISSEMENT');
      Add('join K on (K_ID = ENC_ID and K_enabled=1)');
      Add('join CSHMODEENC on (MEN_ID=ENC_MENID)');
      Add('Where ENC_TkeId='+inttostr(TkeID));
      Add('order by ENC_ID');
      Active:=true;
      First;
      while not(Eof) do
      begin
        vCshMnt := vCshMnt+fieldbyname('ENC_MONTANT').AsFloat+fieldbyname('ENC_BA').AsFloat;
        if fieldbyname('MEN_TYPEMOD').AsInteger in [1, 6] then
          vCshCli := vCshCli+fieldbyname('ENC_MONTANT').AsFloat+fieldbyname('ENC_BA').AsFloat;

        Dm_Main.GetNomReglement(fieldbyname('ENC_MENID').AsInteger, ModEnc, ModType, ModSupp);
        sErreur := '';
        if fieldbyname('ENC_MENID').AsInteger=0 then
          sErreur := 'Valeur de ENC_MENID à zéro !'
        else
        begin
          if ModEnc='' then
            sErreur := 'Mode d''encaissement non trouvé !'
          else
          begin
            if ModSupp then
              sErreur := 'Mode d''encaissement avec K_ENABLED <> 1 !';
          end;
        end;

        MemD_Csh.Append;
        MemD_Csh.fieldbyname('ENC_ID').AsInteger := fieldbyname('ENC_ID').AsInteger;
        MemD_Csh.fieldbyname('ENC_MENID').AsInteger := fieldbyname('ENC_MENID').AsInteger;
        MemD_Csh.fieldbyname('Nom').AsString := ModEnc;
        MemD_Csh.fieldbyname('Mnt').AsFloat := fieldbyname('ENC_MONTANT').AsFloat;
        MemD_Csh.fieldbyname('BA').AsFloat := fieldbyname('ENC_BA').AsFloat;
        MemD_Csh.fieldbyname('MEN_TYPEMOD').AsInteger := ModType;
        MemD_Csh.fieldbyname('ERREUR').AsString := sErreur;
        MemD_Csh.Post;
        
        Next;
      end;
      active:=false;
      MemD_Csh.First;
      Edt_TotCsh.Text := FloatToStr(vCshMnt);
      Edt_TotCli.Text := FloatToStr(vCshCli);
      Edt_CptCli.Text := FloatToStr(vCli4-vCli123);
      vCshMnt := vCshMnt+vCshCli+vCli4-vCli123;
      Edt_CshTot.Text := FloatToStr(vCshMnt);

      // diff
      MetValeurDiff(Edt_DiffEntArt, Abs(vEntTot-vArtTot));
      MetValeurDiff(Edt_DiffEntCsh, Abs(vEntTot-vCshMnt));

      MetValeurDiff(Edt_DiffArtEnt, Abs(vEntTot-vArtTot));
      MetValeurDiff(Edt_DiffArtCsh, Abs(vCshMnt-vArtTot));

      MetValeurDiff(Edt_DiffCshEnt, Abs(vEntTot-vCshMnt));
      MetValeurDiff(Edt_DiffCshArt, Abs(vCshMnt-vArtTot));

      MetValeurMontant(Edt_Tot2, MntBonLoc + vBonLoc);

    finally
      Screen.Cursor := crDefault;
      Application.ProcessMessages;
    end;
  end;
end;

procedure TFrm_Ticket.MenuItem2Click(Sender: TObject);
begin
  PreparerLesUpdates('CLTCOMPTE', 'CTE_ID', MemD_Cli);
end;

procedure TFrm_Ticket.MenuItem3Click(Sender: TObject);
begin
  PreparerLesK_ENABLEDa1('CTE_ID', MemD_Cli);
end;

procedure TFrm_Ticket.MenuItem4Click(Sender: TObject);
begin  
  PreparerLesSuppPhy('CLTCOMPTE', 'CTE_ID', MemD_Cli);
end;

procedure TFrm_Ticket.Mettrepartoutleprixattendu1Click(Sender: TObject);

  function ToStrFloat(Value: double): string;
  begin
    if Abs(Value)<0.009 then
      Result := '0'
    else
      Result := FloatToStr(Value);
    if Pos(',',Result)>0 then
      Result[Pos(',',Result)]:='.';
    Result := QuotedStr(Result);
  end;

var
  TmpQte: integer;
  TmpPx: Double;
  TmpTot: Double;
  TmpAtt: Double;
  sReq: string;
begin
  MemD_Art.DisableControls;
  try
    vArtTot := 0.0;
    MemD_Art.First;
    while not(MemD_Art.Eof) do
    begin
      if MemD_Art.FieldByName('OkSSTotal').AsInteger=0 then
      begin
        TmpQte := MemD_Art.FieldByName('Qte').AsInteger;
        TmpPx := MemD_Art.FieldByName('PU').AsFloat;
        TmpTot := MemD_Art.FieldByName('PTot').AsFloat;
        TmpAtt := MemD_Art.FieldByName('PAtt').AsFloat;

        MemD_Art.Edit;
        TmpPx := TmpAtt;
        MemD_Art.FieldByName('PU').AsFloat :=TmpPx;
        MemD_Art.Post;

        vArtTot := vArtTot+(TmpQte*TmpPx);

        sReq := 'update CSHTICKETL set '+
                ' TKL_PXNN='+ToStrFloat(TmpPx);
        if Abs(MemD_Art.FieldByName('TxTva').AsFloat)>0.009 then  
          sReq := sReq+' ,TKL_PXNNHT=TKL_PXNN/(1+(TKL_TVA/100))';
        sReq := sReq+' where TKL_ID='+inttostr(MemD_Art.FieldByName('TKL_ID').AsInteger)+';';
        LstReq.Add(sReq);
        LstScript.Add(sReq);
        LstScript.Add('');

        sReq := 'execute procedure PR_UPDATEK('+inttostr(MemD_Art.FieldByName('TKL_ID').AsInteger)+',0);';
        LstReq.Add(sReq);
        LstScript.Add(sReq);
        LstScript.Add('');
      end;

      MemD_Art.Next;
    end;
    
    Edt_TotLig.Text := FloatToStr(vArtTot);
    Edt_ArtBA.Text := FloatToStr(vBonAch);
    vArtTot := vArtTot+vBonAch;
    Edt_ArtTot.Text := FloatToStr(vArtTot);
    
    // diff
    MetValeurDiff(Edt_DiffEntArt, Abs(vEntTot-vArtTot));
    MetValeurDiff(Edt_DiffEntCsh, Abs(vEntTot-vCshMnt));

    MetValeurDiff(Edt_DiffArtEnt, Abs(vEntTot-vArtTot));
    MetValeurDiff(Edt_DiffArtCsh, Abs(vCshMnt-vArtTot));

    MetValeurDiff(Edt_DiffCshEnt, Abs(vEntTot-vCshMnt));
    MetValeurDiff(Edt_DiffCshArt, Abs(vCshMnt-vArtTot));
  finally
    MemD_Art.First;
    MemD_Art.EnableControls;
  end;
end;

procedure TFrm_Ticket.MettretouslesIDavecKENABLED1etatsupprim1Click(Sender: TObject);
begin
  PreparerLesK_ENABLEDa1('TKL_ID', MemD_Art);
end;

procedure TFrm_Ticket.MettretouslesIDavecKENABLED1etatsupprim2Click(Sender: TObject);
begin
  PreparerLesK_ENABLEDa1('ENC_ID', MemD_Csh);
end;

//===============//
// Debut du menu //
//===============//

// activation ...

procedure TFrm_Ticket.pmGlobalActionPopup(Sender: TObject);
begin
  // les lignes
  mniLigneSelectionnee.Enabled := (MemD_Art.RecordCount > 0);
  mniLigneToutes.Enabled := (MemD_Art.RecordCount > 1);
  // les encaissement
  mniEncaissementSelectionne.Enabled := (MemD_Csh.RecordCount > 0);
  mniEncaissementTous.Enabled := (MemD_Csh.RecordCount > 1);
  // les comptes
  mniCompteSelectionne.Enabled := (MemD_Cli.RecordCount > 0);
  mniCompteTous.Enabled := (MemD_Cli.RecordCount > 1);
  // bon de location ?
  mniBonLocation.Enabled := (mdtTicket.FieldByName('tke_totneta2').AsFloat <> 0);

  // selon le menu !
  if Assigned(pmGlobalAction.PopupComponent) then
  begin
    if pmGlobalAction.PopupComponent = DBGrid1 then
    begin
      // lignes
      mniVoirLeTicket.Visible := false;
      mniEntete.Visible := false;
      mniLigne.Visible := true;
      mniEncaissement.Visible := false;
      mniCompteClient.Visible := false;
      mniBonLocation.Visible := false;
    end
    else if pmGlobalAction.PopupComponent = DBGrid2 then
    begin
      // encaissement
      mniVoirLeTicket.Visible := false;
      mniEntete.Visible := false;
      mniLigne.Visible := false;
      mniEncaissement.Visible := true;
      mniCompteClient.Visible := false;
      mniBonLocation.Visible := false;
    end
    else if pmGlobalAction.PopupComponent = DBGrid3 then
    begin
      // compte client
      mniVoirLeTicket.Visible := false;
      mniEntete.Visible := false;
      mniLigne.Visible := false;
      mniEncaissement.Visible := false;
      mniCompteClient.Visible := true;
      mniBonLocation.Visible := false;
    end
    else
    begin
      mniVoirLeTicket.Visible := true;
      mniEntete.Visible := true;
      mniLigne.Visible := true;
      mniEncaissement.Visible := true;
      mniCompteClient.Visible := true;
      mniBonLocation.Visible := true;
    end;
  end
  else
  begin
    mniVoirLeTicket.Visible := true;
    mniEntete.Visible := true;
    mniLigne.Visible := true;
    mniEncaissement.Visible := true;
    mniCompteClient.Visible := true;
    mniBonLocation.Visible := true;
  end;
end;

// Bon de location

procedure TFrm_Ticket.mniBonLocationClick(Sender: TObject);
var
  Frm_Location : Trm_Location;
begin
  Frm_Location := Trm_Location.Create(Self);
  try
    Frm_Location.InitEcr(SesNum, SesID, Edt_Ecart.Text, TkeID);
    Frm_Location.ShowModal();
  finally
    FreeAndNil(Frm_Location);
  end;
end;

// Compte clients

procedure TFrm_Ticket.mniCompteDetailClick(Sender: TObject);
var
  Frm_Detail : TFrm_Detail;
begin
  Frm_Detail := TFrm_Detail.Create(Self);
  try
    Frm_Detail.InitEcr('select cltcompte.* from cltcompte join k on k_id = cte_id and k_enabled = 1 where cte_tkeid = ' + inttostr(tkeid), 'cltcompte', 'cte_id');
    Frm_Detail.ShowModal();
  finally
    FreeAndNil(Frm_Detail);
  end;
end;

procedure TFrm_Ticket.mniCompteNewClick(Sender: TObject);
begin
  ClipBoard.AsText := Dm_Main.CreerNouvLigne('cltcompte', 'cte_id', [], []);
end;

procedure TFrm_Ticket.mniCompteTCopierIDClick(Sender: TObject);
begin
  CopierIDAvecDesOR('cte_id', MemD_Cli);
end;

procedure TFrm_Ticket.mniCompteTPrepSupprLogClick(Sender: TObject);
begin
  PreparerLesK_ENABLEDa1('cte_id', MemD_Cli);
end;

procedure TFrm_Ticket.mniCompteTPrepSupprPhyClick(Sender: TObject);
begin
  PreparerLesSuppPhy('cltcompte', 'cte_id', MemD_Cli);
end;

procedure TFrm_Ticket.mniCompteTPrepUpdateClick(Sender: TObject);
begin
  PreparerLesUpdates('cltcompte', 'cte_id', MemD_Cli, True);
end;

procedure TFrm_Ticket.mniCompteUCopierIDClick(Sender: TObject);
begin
  Clipboard.AsText := MemD_Cli.FieldByName('cte_id').AsString;
end;

procedure TFrm_Ticket.mniCompteUPrepSupprLogClick(Sender: TObject);
begin
  Clipboard.AsText := Dm_Main.PreparerUneSupprLog('cte_id', MemD_Cli);
end;

procedure TFrm_Ticket.mniCompteUPrepSupprPhyClick(Sender: TObject);
begin
  Clipboard.AsText := Dm_Main.PreparerUneSupprPhy('cltcompte', 'cte_id', MemD_Cli);
end;

procedure TFrm_Ticket.mniCompteUPrepUpdateClick(Sender: TObject);
begin
  Clipboard.AsText := Dm_Main.PreparerUnUpdate('cltcompte', 'cte_id', MemD_Cli, True);
end;

// encaissement

procedure TFrm_Ticket.mniEncaissementDetailClick(Sender: TObject);
var
  Frm_Detail : TFrm_Detail;
begin
  Frm_Detail := TFrm_Detail.Create(Self);
  try
    Frm_Detail.InitEcr('select cshencaissement.* from cshencaissement join k on k_id = enc_id and k_enabled = 1 where enc_tkeid = ' + inttostr(tkeid), 'cshencaissement', 'enc_id');
    Frm_Detail.ShowModal();
  finally
    FreeAndNil(Frm_Detail);
  end;
end;

procedure TFrm_Ticket.mniEncaissementNewClick(Sender: TObject);
var
  Motif : string;
  ModEncID, FdcTrfDest : Integer;
  Montant : Double;
  CorrFDC : Boolean;
begin
  Motif := '';
  ModEncID := 0;
  Montant := 0;
  CorrFDC := True;
  if InputEncaissement(Dm_Main.GetMagIDFromSesID(SesID), Motif, ModEncID, Montant, CorrFDC) then
  begin
    if CorrFDC then
    begin
      if Dm_Main.SeekFDCFromMen(SesID, ModEncID, -Montant, FdcTrfDest) then
      begin
        Clipboard.AsText := Dm_Main.CreerNouvLigne('cshencaissement', 'enc_id',
                                                   ['enc_tkeid', 'enc_echeance', 'enc_montant', 'enc_menid', 'enc_motif'],
                                                   [IntToStr(TkeID), Dm_Main.GetDateTimeForDB(0), Dm_Main.GetFloatForDB(Montant), IntToStr(ModEncID), QuotedStr(Motif)])
                          + Dm_Main.PreparerUnUpdate('cshfondcaisse', 'fdc_id', Dm_Main.queSeekFdcFromEnc, ['fdc_montant'], ['fdc_montant - ' + Dm_Main.GetFloatForDB(Montant)], True);
      end
      else
      begin
        Clipboard.AsText :=
            Dm_Main.ProcedureForCreate('cshencaissement', 'NewEncID',
                                        Dm_Main.CreerNouvLigne('cshencaissement', 'enc_id',
                                                               ['enc_tkeid', 'enc_echeance', 'enc_montant', 'enc_menid', 'enc_motif'],
                                                               [IntToStr(TkeID), Dm_Main.GetDateTimeForDB(0), Dm_Main.GetFloatForDB(Montant), IntToStr(ModEncID), QuotedStr(Motif)], 'NewEncID')
                                      + Dm_Main.CreerNouvLigne('cshfondcaisse', 'fdc_id',
                                                               ['fdc_menid', 'fdc_sesid', 'fdc_echeance', 'fdc_date', 'fdc_libelle', 'fdc_montant', 'fdc_qte', 'fdc_typ', 'fdc_apport', 'fdc_bcecffid', 'fdc_refid'],
                                                               [IntToStr(ModEncID), IntToStr(SesID), Dm_Main.GetDateTimeForDB(0), 'current_date', QuotedStr('Correction de caisse : ' + Motif), Dm_Main.GetFloatForDB(-Montant), '1', '2', '2', IntToStr(FdcTrfDest), ':NewEncID'])
                          );
      end;
    end
    else
    begin
      Clipboard.AsText := Dm_Main.CreerNouvLigne('cshencaissement', 'enc_id',
                                                 ['enc_tkeid', 'enc_echeance', 'enc_montant', 'enc_menid', 'enc_motif'],
                                                 [IntToStr(TkeID), Dm_Main.GetDateTimeForDB(0), Dm_Main.GetFloatForDB(Montant), IntToStr(ModEncID), QuotedStr(Motif)]);
    end;
  end;
end;

procedure TFrm_Ticket.mniEncaissementTCopierIDClick(Sender: TObject);
begin
  CopierIDAvecDesOR('enc_id', MemD_Csh);
end;

procedure TFrm_Ticket.mniEncaissementTPrepSupprLogClick(Sender: TObject);
begin
  PreparerLesK_ENABLEDa1('enc_id', MemD_Csh);
end;

procedure TFrm_Ticket.mniEncaissementTPrepSupprPhyClick(Sender: TObject);
begin
  PreparerLesSuppPhy('cshencaissement', 'enc_id', MemD_Csh);
end;

procedure TFrm_Ticket.mniEncaissementTPrepUpdateClick(Sender: TObject);
begin
  PreparerLesUpdates('cshencaissement', 'enc_id', MemD_Csh, True);
end;

procedure TFrm_Ticket.mniEncaissementUChgMntClick(Sender: TObject);
var
  EncID : Integer;
  NewMnt, OldMnt, DiffMnt : Double;
begin
  // identifiant de l'encaissement a changer
  EncID := MemD_Csh.FieldByName('enc_id').AsInteger;
  OldMnt := MemD_Csh.FieldByName('Mnt').AsFloat;
  NewMnt := OldMnt;
  DiffMnt := RoundTo(NewMnt - OldMnt, -2);
  if InputMontant(NewMnt) then
  begin
    if Dm_Main.SeekFDCFromEnc(EncID, DiffMnt) then
    begin
      Clipboard.AsText := Dm_Main.PreparerUnUpdate('cshencaissement', 'enc_id', MemD_Csh, ['enc_montant'], [Dm_Main.GetFloatForDB(NewMnt)], True)
                        + Dm_Main.PreparerUnUpdate('cshfondcaisse', 'fdc_id', Dm_Main.queSeekFdcFromEnc, ['fdc_montant'], ['fdc_montant - ' + Dm_Main.GetFloatForDB(DiffMnt)], True);
    end
    else
      MessageDlg('Ligne de fond de caisse non trouvé', mtWarning, [mbOK], 0);
  end;
end;

procedure TFrm_Ticket.mniEncaissementUCopierIDClick(Sender: TObject);
begin
  Clipboard.AsText := MemD_Csh.FieldByName('enc_id').AsString;
end;

procedure TFrm_Ticket.mniEncaissementUPrepSupprLogClick(Sender: TObject);
begin
  Clipboard.AsText := Dm_Main.PreparerUneSupprLog('enc_id', MemD_Csh);
end;

procedure TFrm_Ticket.mniEncaissementUPrepSupprPhyClick(Sender: TObject);
begin
  Clipboard.AsText := Dm_Main.PreparerUneSupprPhy('cshencaissement', 'enc_id', MemD_Csh);
end;

procedure TFrm_Ticket.mniEncaissementUPrepUpdateClick(Sender: TObject);
begin
  Clipboard.AsText := Dm_Main.PreparerUnUpdate('cshencaissement', 'enc_id', MemD_Csh, True);
end;

// entete

procedure TFrm_Ticket.mniEnteteCopierIDClick(Sender: TObject);
begin
  Clipboard.AsText := mdtTicket.FieldByName('tke_id').AsString;
end;

procedure TFrm_Ticket.mniEnteteDetailClick(Sender: TObject);
var
  Frm_Detail : TFrm_Detail;
begin
  Frm_Detail := TFrm_Detail.Create(Self);
  try
    Frm_Detail.InitEcr('select cshticket.* from cshticket join k on k_id = tke_id and k_enabled = 1 where tke_id = ' + inttostr(tkeid), 'cshticket', 'tke_id');
    Frm_Detail.ShowModal();
  finally
    FreeAndNil(Frm_Detail);
  end;
end;

procedure TFrm_Ticket.mniEntetePreparerUpdateClick(Sender: TObject);
begin
  Clipboard.AsText := Dm_Main.PreparerUnUpdate('cshticket', 'tke_id', mdtTicket, True);
end;

// Lignes

procedure TFrm_Ticket.mniLigneDetailClick(Sender: TObject);
var
  Frm_Detail : TFrm_Detail;
begin
  Frm_Detail := TFrm_Detail.Create(Self);
  try
    Frm_Detail.InitEcr('select cshticketl.* from cshticketl join k on k_id = tkl_id and k_enabled = 1 where tkl_tkeid = ' + inttostr(tkeid), 'cshticketl', 'tkl_id');
    Frm_Detail.ShowModal();
  finally
    FreeAndNil(Frm_Detail);
  end;
end;

procedure TFrm_Ticket.mniLigneNewClick(Sender: TObject);
begin
  CreerNouvLigne('cshticketl', 'tkl_id');
end;

procedure TFrm_Ticket.mniLigneTChgPxUClick(Sender: TObject);
var
  OldPos : TBookmark;
  Script : string;
begin
  OldPos := MemD_Art.GetBookmark();
  try
    Script := '';
    MemD_Art.DisableControls();
    MemD_Art.First();
    while not MemD_Art.Eof do
    begin
      if MemD_Art.FieldByName('OkSSTotal').AsInteger = 0 then
      begin
        Script := Script + GetRequeteChgPrxUneLigne();
      end;
      MemD_Art.Next();
    end;
    Clipboard.AsText := Script;
  finally
    MemD_Art.GotoBookmark(OldPos);
    MemD_Art.EnableControls();
  end;
end;

procedure TFrm_Ticket.mniLigneTCopierIDClick(Sender: TObject);
begin
  CopierIDAvecDesOR('tkl_id', MemD_Art);
end;

procedure TFrm_Ticket.mniLigneTPerpUpdateClick(Sender: TObject);
begin
  PreparerLesUpdates('cshticketl', 'tkl_id', MemD_Art, True);
end;

procedure TFrm_Ticket.mniLigneTPrepSupprLogClick(Sender: TObject);
begin
  PreparerLesK_ENABLEDa1('tkl_id', MemD_Art);
end;

procedure TFrm_Ticket.mniLigneTPrepSupprPhyClick(Sender: TObject);
begin
  PreparerLesSuppPhy('cshticketl', 'tkl_id', MemD_Art);
end;

procedure TFrm_Ticket.mniLigneUChgPxUClick(Sender: TObject);
begin
  if MemD_Art.FieldByName('OkSSTotal').AsInteger = 0 then
  begin
    Clipboard.AsText := GetRequeteChgPrxUneLigne();
  end;
end;

procedure TFrm_Ticket.mniLigneUCopierIDClick(Sender: TObject);
begin
  Clipboard.AsText := MemD_Art.FieldByName('tkl_id').AsString;
end;

procedure TFrm_Ticket.mniLigneUPrepSupprLogClick(Sender: TObject);
begin
  Clipboard.AsText := Dm_Main.PreparerUneSupprLog('tkl_id', MemD_Art);
end;

procedure TFrm_Ticket.mniLigneUPrepSupprsPhyClick(Sender: TObject);
begin
  Clipboard.AsText := Dm_Main.PreparerUneSupprPhy('cshticketl', 'tkl_id', MemD_Art);
end;

procedure TFrm_Ticket.mniLigneUPreprUpdateClick(Sender: TObject);
begin
  Clipboard.AsText := Dm_Main.PreparerUnUpdate('cshticketl', 'tkl_id', MemD_Art, True);
end;

// ticket

procedure TFrm_Ticket.mniVoirLeTicketClick(Sender: TObject);
var
  Frm_VoirTicket : TFrm_VoirTicket;
begin
  Frm_VoirTicket := TFrm_VoirTicket.Create(self);
  try
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages();
    try
      Frm_VoirTicket.InitEcr(TkeID);
    finally
      Application.ProcessMessages();
      Screen.Cursor := crDefault;
    end;
    Frm_VoirTicket.ShowModal();
  finally
    FreeAndNil(Frm_VoirTicket);
  end;
end;

// utilitaire

function TFrm_Ticket.GetRequeteChgPrxUneLigne() : string;
var
  TmpQte : Integer;
  TmpPx, TmpTot, TmpAtt : Double;
  sReq : string;
begin
  if MemD_Art.FieldByName('OkSSTotal').AsInteger = 0 then
  begin
    TmpQte := MemD_Art.FieldByName('Qte').AsInteger;
    TmpPx := MemD_Art.FieldByName('PU').AsFloat;
    TmpTot := MemD_Art.FieldByName('PTot').AsFloat;
    TmpAtt := MemD_Art.FieldByName('PAtt').AsFloat;
    vArtTot := vArtTot + (TmpQte*TmpPx);

    Result := Dm_Main.PreparerUnUpdate('cshticketl', 'tkl_id', MemD_Art, ['tkl_pxnn', 'tkl_pxnnht'], [Dm_Main.GetFloatForDB(TmpPx), 'tkl_pxnn / (1 + (tkl_tva / 100))'], True);
  end
  else
    Result := '';
end;

procedure TFrm_Ticket.mniCorrectionTicketAvecRemiseFideliteSansBonClick(Sender: TObject);
var
  Msg : string;
begin
  // eurf !
  if Dm_Main.CorrigeTicketRemiseFidSansBon(TkeID, Msg) then
  begin
    InitEcr(SesNum, SesID, Edt_Ecart.Text, TkeID);
    MessageDlg('', mtInformation, [mbOK], 0);
  end
  else
    MessageDlg(Msg, mterror,[mbok],0);
end;

//===============//
//  fin du menu  //
//===============//

procedure TFrm_Ticket.Nbt_ActionArtClick(Sender: TObject);
var
  pt: TPoint;
begin
  GetCursorPos(pt);
  PopArt.Popup(pt.X,pt.y);
end;

procedure TFrm_Ticket.Nbt_CopierCliClick(Sender: TObject);
var
  pt: TPoint;
begin
  GetCursorPos(pt);
  PopCli.Popup(pt.X,pt.y);
end;

procedure TFrm_Ticket.Nbt_CopierEncaisClick(Sender: TObject);
var
  pt: TPoint;
begin
  GetCursorPos(pt);
  PopEncais.Popup(pt.X,pt.y);
end;

procedure TFrm_Ticket.Nbt_DetEntClick(Sender: TObject);
var
  Frm_Detail : TFrm_Detail;
begin
  Frm_Detail := TFrm_Detail.Create(Self);
  try
    Frm_Detail.InitEcr('select c.* from cshticket c '+
                       'join K on (K_ID = TKE_ID and K_enabled=1)'+
                       'Where TKE_ID='+inttostr(TkeID),'cshticket','TKE_ID');
    Frm_Detail.ShowModal;
  finally
    FreeAndNil(Frm_Detail);
  end;
end;

procedure TFrm_Ticket.Nbt_VoirTickClick(Sender: TObject);
var
  Frm_VoirTicket : TFrm_VoirTicket;
begin
  Frm_VoirTicket := TFrm_VoirTicket.Create(self);
  try
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    try
      Frm_VoirTicket.InitEcr(TkeID);
    finally
      Application.ProcessMessages;
      Screen.Cursor := crDefault;
    end;
    Frm_VoirTicket.ShowModal;
  finally
    FreeAndNil(Frm_VoirTicket);
  end;
end;

procedure TFrm_Ticket.prparertouslesupdates1Click(Sender: TObject);
begin
  PreparerLesUpdates('CSHTICKETL', 'TKL_ID', MemD_Art);
end;

procedure TFrm_Ticket.Prparertouslesupdates2Click(Sender: TObject);
begin
  PreparerLesUpdates('CSHENCAISSEMENT', 'ENC_ID', MemD_Csh);
end;

procedure TFrm_Ticket.Prparertouteslessuppressionsphysiques1Click(Sender: TObject);
begin
  PreparerLesSuppPhy('CSHTICKETL', 'TKL_ID', MemD_Art);
end;

procedure TFrm_Ticket.Prparertouteslessuppressionsphysiques2Click(Sender: TObject);
begin    
  PreparerLesSuppPhy('CSHENCAISSEMENT', 'ENC_ID', MemD_Csh);
end;

end.
