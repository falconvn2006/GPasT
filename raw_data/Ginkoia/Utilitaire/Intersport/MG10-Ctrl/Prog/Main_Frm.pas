unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, RzPanel, GinPanel, ExtCtrls, AdvGlowButton, ComCtrls,
  StdCtrls, Buttons, ImgList, cxGraphics, LMDPNGImage, DB, dxmdaset, Grids, DBGrids, IBODataset, Menus, StrUtils;

type
  TFrm_Main = class(TForm)
    Pan_Top: TPanel;
    Pan_destination: TGinPanel;
    PanelGeneral: TPanel;
    Pan_Bottom: TRzPanel;
    btn_Quitter: TAdvGlowButton;
    Pan_Origine: TGinPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lbl_BaseGinkoia: TLabel;
    ed_BaseOri: TEdit;
    Bt_PathOri: TAdvGlowButton;
    Bt_ConnOri: TBitBtn;
    Lab_OriConn: TLabel;
    Label1: TLabel;
    ed_BaseDst: TEdit;
    bt_PathDst: TAdvGlowButton;
    Bt_ConnDst: TBitBtn;
    Lab_DstConn: TLabel;
    PanGauche: TPanel;
    Pan_Droite: TPanel;
    LstImg_Etat32: TcxImageList;
    Panel1: TPanel;
    Lab_OriControle: TLabel;
    Cb_OriControle: TComboBox;
    Panel4: TPanel;
    Lab_DstControle: TLabel;
    Cb_DstControle: TComboBox;
    Mem_Ori: TdxMemData;
    Mem_OriNumero: TIntegerField;
    Mem_OriTitre: TStringField;
    Mem_OriEtat: TIntegerField;
    Mem_Dst: TdxMemData;
    Mem_DstNumero: TIntegerField;
    Mem_DstTitre: TStringField;
    Mem_DstEtat: TIntegerField;
    Pgc_Ori: TPageControl;
    Pgc_Dst: TPageControl;
    Tab_OriRien: TTabSheet;
    Tab_DstRien: TTabSheet;
    Tab_OriVersion: TTabSheet;
    Tab_DstVersion: TTabSheet;
    Img_OriVersion: TImage;
    RzPanel1: TRzPanel;
    Ctrl_OriVersion: TRzPanel;
    LstImg_Etat64: TcxImageList;
    LInfoVerOri: TLabel;
    Img_DstVersion: TImage;
    RzPanel2: TRzPanel;
    Ctrl_DstVersion: TRzPanel;
    LInfoVerDst: TLabel;
    Tab_OriMagasin: TTabSheet;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Img_OriMag: TImage;
    RzPanel3: TRzPanel;
    Ctrl_OriMag: TRzPanel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    Tab_DstMagasin: TTabSheet;
    DBGrid1: TDBGrid;
    Nbt_OriMagRefresh: TBitBtn;
    Nbt_OriMagModif: TBitBtn;
    Ds_OriMag: TDataSource;
    Bevel9: TBevel;
    Bevel10: TBevel;
    Img_DstMag: TImage;
    RzPanel4: TRzPanel;
    Ctrl_DstMag: TRzPanel;
    DBGrid2: TDBGrid;
    Nbt_DstMagRefresh: TBitBtn;
    Nbt_DstMagModif: TBitBtn;
    Ds_DstMag: TDataSource;
    LOriMag: TLabel;
    LOriDstMag: TLabel;
    LDstMag: TLabel;
    LDstOriMag: TLabel;
    Tab_OriStock: TTabSheet;
    Bevel11: TBevel;
    Bevel12: TBevel;
    Img_OriStock: TImage;
    RzPanel5: TRzPanel;
    Ctrl_OriStock: TRzPanel;
    Lab_OriRecalStock: TLabel;
    Nbt_OriStkRefresh: TBitBtn;
    Nbt_RecalStock: TBitBtn;
    Tab_DstGrpPump: TTabSheet;
    Bevel13: TBevel;
    Bevel14: TBevel;
    Img_DstGrpPump: TImage;
    RzPanel6: TRzPanel;
    Ctrl_DstGrpPump: TRzPanel;
    Lab_DstGrpPump: TLabel;
    Nbt_DstPumpRefresh: TBitBtn;
    Nbt_DstAffecterPump: TBitBtn;
    Nbt_AffectGrpPumpAuto: TBitBtn;
    Tab_OriCtrl: TTabSheet;
    Bevel15: TBevel;
    Bevel16: TBevel;
    Img_OriCtrl: TImage;
    RzPanel7: TRzPanel;
    Ctrl_OriCtrl: TRzPanel;
    OD_PrepaArt: TOpenDialog;
    Gbx_PrepaArt: TGroupBox;
    Nbt_OuvrirPrepaArt: TBitBtn;
    Nbt_Preparer: TBitBtn;
    Nbt_PreparerCtrl: TBitBtn;
    Lab_PrepaArt: TLabel;
    Nbt_CtrlBase: TBitBtn;
    GroupBox1: TGroupBox;
    Mem_Ctrl: TMemo;
    SD_PrepaArt: TSaveDialog;
    MemD_PrepaArt: TdxMemData;
    MemD_PrepaArtARTID: TIntegerField;
    MemD_PrepaArtMRKID: TIntegerField;
    MemD_PrepaArtSSFID: TIntegerField;
    MemD_PrepaArtCHRONO: TStringField;
    MemD_PrepaArtARTNOM: TStringField;
    MemD_PrepaArtVIRTUEL: TIntegerField;
    MemD_PrepaArtARFID: TIntegerField;
    Nbt_CtrlParam: TBitBtn;
    Pop_CtrlParam: TPopupMenu;
    MnCtrlFourn: TMenuItem;
    MnCtrlArtSsf: TMenuItem;
    MnCtrlCodeBarre: TMenuItem;
    Lab_InfoCtrl: TLabel;
    MNCtrlPrelim: TMenuItem;
    Tab_OriParamMagasins: TTabSheet;
    DBGridOriParamMag: TDBGrid;
    Ds_OriParamMag: TDataSource;
    BevelOriParamMag: TBevel;
    Img_OriParamMag: TImage;
    Pan_OriParamMag: TRzPanel;
    Ctrl_OriParamMag: TRzPanel;
    Btn_OriParamMagModifier: TBitBtn;
    Btn_OriParamMagRafraichir: TBitBtn;
    Tab_DstParamMagasins: TTabSheet;
    DBGridDstParamMag: TDBGrid;
    Ds_DstParamMag: TDataSource;
    Img_DstParamMag: TImage;
    BevelDstParamMag: TBevel;
    Pan_DstParamMag: TRzPanel;
    Ctrl_DstParamMag: TRzPanel;
    Btn_DstParamMagRafraichir: TBitBtn;
    Btn_DstParamMagModifier: TBitBtn;
    PanelAffichage: TPanel;
    CheckBoxGroupeClient: TCheckBox;
    LabelAffichage: TLabel;
    CheckBoxGroupeCompteClient: TCheckBox;
    CheckBoxGroupeDePump: TCheckBox;

    procedure Pan_TopResize(Sender: TObject);
    procedure btn_QuitterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Bt_ConnOriClick(Sender: TObject);
    procedure Bt_PathOriClick(Sender: TObject);
    procedure bt_PathDstClick(Sender: TObject);
    procedure Bt_ConnDstClick(Sender: TObject);
    procedure Cb_OriControleDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure Cb_OriControleChange(Sender: TObject);
    procedure Cb_DstControleChange(Sender: TObject);
    procedure Nbt_OriMagModifClick(Sender: TObject);
    procedure Nbt_OriMagRefreshClick(Sender: TObject);
    procedure Nbt_DstMagModifClick(Sender: TObject);
    procedure Tab_OriMagasinResize(Sender: TObject);
    procedure Tab_DstMagasinResize(Sender: TObject);
    procedure Nbt_OriStkRefreshClick(Sender: TObject);
    procedure Nbt_RecalStockClick(Sender: TObject);
    procedure Nbt_DstPumpRefreshClick(Sender: TObject);
    procedure Nbt_AffectGrpPumpAutoClick(Sender: TObject);
    procedure Nbt_CtrlBaseClick(Sender: TObject);
    procedure Nbt_OuvrirPrepaArtClick(Sender: TObject);
    procedure Nbt_PreparerClick(Sender: TObject);
    procedure Nbt_PreparerCtrlClick(Sender: TObject);
    procedure MnCtrlFournClick(Sender: TObject);
    procedure Nbt_CtrlParamClick(Sender: TObject);
    procedure Nbt_DstAffecterPumpClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Btn_OriParamMagModifierClick(Sender: TObject);
    procedure Btn_OriParamMagRafraichirClick(Sender: TObject);
    procedure Btn_DstParamMagRafraichirClick(Sender: TObject);
    procedure Btn_DstParamMagModifierClick(Sender: TObject);
    procedure CheckBoxGroupeClientClick(Sender: TObject);
    procedure CheckBoxGroupeCompteClientClick(Sender: TObject);
    procedure CheckBoxGroupeDePumpClick(Sender: TObject);

  private
    ReperBase: string;
    EtatFiche: boolean;
    FPageOri: Integer;
    FPageDst: Integer;

    procedure SetPageOri(const Value: Integer);
    procedure SetPageDst(const Value: Integer);

    procedure InitOrigine;
    procedure InitDestination;

    function doOriVersion: boolean;
    function DoOriCodeAdherentMag: boolean;
    function DoOriParamMagasins: Boolean;
//    function DoOriDstCodeMag: boolean;
    function DoOriCtrlStock: boolean;
    procedure DoInitCtrlGeneral;

    function doDstVersion: boolean; 
    function DoDstCodeAdherentMag: boolean;
    function DoDstParamMagasins: Boolean;
//    function DoDstOriCodeMag: boolean;
    function DoDstGrpPump: boolean;
    function PreparerArt: boolean;
    procedure ControlerBase;

    procedure TerminateThreadRecalculStk(Sender: TObject);

    //function RechercheID(AListe: TStrings; ACode: string; const ACount: integer = -1): integer;
    //function AjoutInListeID(AListe: TStrings; ACode: string; AChamps: array of string): integer; overload;
    //function AjoutInListeID(AListe: TStrings; ACode: string; AChamps: string): integer; overload;

    property PageOri: Integer read FPageOri write SetPageOri;
    property PageDst: Integer read FPageDst write SetPageDst;
    procedure AfficherColonneGrilleParamMag(DBGrid: TDBGrid; const sChamp: String; const bAfficher: Boolean);

  public

  end;

var
  Frm_Main: TFrm_Main;

implementation

uses
  GinkoiaStyle_Dm, Main_Dm, ModifCodeAdh_Frm, MajStk_Frm, DateLimit_Frm, uVersion, GrpPump_Frm, ParamMagasins_Frm;

const
  // Origine
  PC_ORI_RIEN = 0;
  PC_ORI_VERSION = 1;
  PC_ORI_MAGASIN = 2;
  PC_ORI_PARAM_MAGASINS = 3;
  PC_ORI_CALCSTOCK = 4;
  PC_ORI_CONTROLE = 5;

  // Destination
  PC_DST_RIEN = 0;
  PC_DST_VERSION = 1;
  PC_DST_MAGASIN = 2;
  PC_DST_PARAM_MAGASINS = 3;
  PC_DST_GROUPPUMP = 4;

{$R *.dfm}

function StrListCompareStrings(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := CompareStr(List[Index1], List[Index2]);
end;

function ResultRechercheDico(AListe: TStrings; iDebut, iFin: integer; sRech: string): integer;
var
  iMilieu: integer;
  sCode: string;
  LStrcomp: integer;
begin
  if (iDebut<=iFin) then
  begin
    iMilieu  := (iDebut+iFin) div 2;
    sCode    := TStringList(AListe)[iMilieu];

    LStrcomp := CompareStr(sRech, sCode);
    if LStrcomp = 0 then           // sCode=sRech
      Result := iMilieu
    else
    begin
      if LStrcomp < 0 then     // sRech<sCode
        Result := ResultRechercheDico(AListe, iDebut, iMilieu-1, sRech)
      else
        Result := ResultRechercheDico(AListe, iMilieu+1, iFin, sRech);
    end;
  end
  else
    Result := -1;
end;

procedure TFrm_Main.SetPageOri(const Value: Integer);
var
  lret, i: Integer;
begin
  if FPageOri <> Value then
  begin
    FPageOri := Value;
    case FPageOri of
      PC_ORI_VERSION:
        Pgc_Ori.ActivePage := Tab_OriVersion;

      PC_ORI_MAGASIN:
        Pgc_Ori.ActivePage := Tab_OriMagasin;

      PC_ORI_PARAM_MAGASINS:
        begin
          Pgc_Ori.ActivePage := Tab_OriParamMagasins;
          CheckBoxGroupeClientClick(nil);
          CheckBoxGroupeCompteClientClick(nil);
          CheckBoxGroupeDePumpClick(nil);
        end;

      PC_ORI_CALCSTOCK:
        Pgc_Ori.ActivePage := Tab_OriStock;

      PC_ORI_CONTROLE:
        Pgc_Ori.ActivePage := Tab_OriCtrl;
    else
      // PC_ORI_RIEN
      Pgc_Ori.ActivePage := Tab_OriRien;
    end;

    PanelAffichage.Visible := (FPageOri = PC_ORI_PARAM_MAGASINS) or (FPageDst = PC_DST_PARAM_MAGASINS);

    lret := -1;
    i := 1;
    while(lret = -1) and (i <= Cb_OriControle.Items.Count) do
    begin
      if Cb_OriControle.Items[i - 1] = IntToStr(FPageOri) then
        lret := i - 1;

      inc(i);
    end;
    Cb_OriControle.ItemIndex := lret;
    Cb_OriControle.Enabled := (FPageOri > 0);
    Lab_OriControle.Enabled := (FPageOri > 0);
  end;
end;

procedure TFrm_Main.Tab_DstMagasinResize(Sender: TObject);
begin   
  LDstMag.Top    := Nbt_DstMagModif.Top-1;
  LDstOriMag.Top := LDstMag.Top+LDstMag.Height+1;
end;

procedure TFrm_Main.Tab_OriMagasinResize(Sender: TObject);
begin
  LOriMag.Top    := Nbt_OriMagModif.Top-1;
  LOriDstMag.Top := LOriMag.Top+LOriMag.Height+1;
end;

procedure TFrm_Main.SetPageDst(const Value: Integer);
var
  lret, i: Integer;
begin
  if FPageDst <> Value then
  begin
    FPageDst := Value;
    case FPageDst of
      PC_DST_VERSION:
        Pgc_Dst.ActivePage := Tab_DstVersion;

      PC_DST_MAGASIN:
        Pgc_Dst.ActivePage := Tab_DstMagasin;

      PC_DST_PARAM_MAGASINS:
        begin
          Pgc_Dst.ActivePage := Tab_DstParamMagasins;
          CheckBoxGroupeClientClick(nil);
          CheckBoxGroupeCompteClientClick(nil);
          CheckBoxGroupeDePumpClick(nil);
        end;

      PC_DST_GROUPPUMP:
        Pgc_Dst.ActivePage := Tab_DstGrpPump;
    else
      // PC_DST_RIEN
      Pgc_Dst.ActivePage := Tab_DstRien;
    end;

    PanelAffichage.Visible := (FPageOri = PC_ORI_PARAM_MAGASINS) or (FPageDst = PC_DST_PARAM_MAGASINS);

    lret := -1;
    i := 1;
    while (lret = -1) and (i <= Cb_DstControle.Items.Count) do
    begin
      if Cb_DstControle.Items[i - 1] = IntToStr(FPageDst) then
        lret := i - 1;

      inc(i);
    end;
    Cb_DstControle.ItemIndex := lret;
    Cb_DstControle.Enabled   := (FPageDst > 0);
    Lab_DstControle.Enabled  := (FPageDst > 0);
  end;
end;

procedure TFrm_Main.Bt_ConnDstClick(Sender: TObject);
var
  iPage       : Integer;
//  VersionBase : string;
begin
  Lab_DstConn.Font.Color := rgb(0, 0, 153);
  Lab_DstConn.Caption    := 'Déconnecté';
  PageDst                := PC_DST_RIEN;
  iPage                  := -1;
  Application.ProcessMessages;
  try
    if ed_BaseDst.Text = '' then
    begin
      bt_PathDstClick(nil);
      Exit;
    end
    else if not FileExists(ed_BaseDst.Text) then
      raise Exception.Create('Base destination non trouvée !');

    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    try
      Dm_Main.ConnexionDst(ed_BaseDst.Text);

      // version
      if not(doDstVersion) and (iPage = -1) then
           iPage := PC_DST_VERSION;

      // test code adhérent magasin
      if not(DoDstCodeAdherentMag) and (iPage = -1) then
        iPage := PC_DST_MAGASIN;
      //DoOriCodeAdherentMag;
      DoDstCodeAdherentMag;

      // Paramétrage magasins.
      DoDstParamMagasins;

      // test groupe de pump
      if not(DoDstGrpPump) and (iPage = -1) then
        iPage := PC_DST_GROUPPUMP;

      if iPage = -1 then
        iPage := PC_DST_VERSION;
      PageDst := iPage;

    finally  
      Cb_OriControle.Refresh;
      Cb_DstControle.Refresh;
      Application.ProcessMessages;
      Screen.Cursor := crDefault;
    end;
  except
    on E: Exception do
      MessageDlg(E.Message, mterror, [mbok], 0);
  end;
end;

procedure TFrm_Main.Bt_ConnOriClick(Sender: TObject);
var
  iPage: Integer;
begin
  Lab_OriConn.Font.Color := rgb(0, 0, 153);
  Lab_OriConn.Caption    := 'Déconnecté';
  PageOri                := PC_ORI_RIEN;
  iPage                  := -1;
  Application.ProcessMessages;
  try
    if ed_BaseOri.Text = '' then
    begin
      Bt_PathOriClick(nil);
      Exit;
    end
    else if not FileExists(ed_BaseOri.Text) then
      raise Exception.Create('Base origine non trouvée !');

    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    try
      Dm_Main.ConnexionOri(ed_BaseOri.Text);

      // version
      if not(doOriVersion) and (iPage = -1) then
        iPage := PC_ORI_VERSION;

      // test code adhérent magasin
      if not(DoOriCodeAdherentMag) and (iPage = -1) then
        iPage := PC_ORI_MAGASIN;
      //DoDstCodeAdherentMag;
      DoOriCodeAdherentMag;

      // Paramétrage magasins.
      DoOriParamMagasins;

      // test Recalcul du stock
      if not(DoOriCtrlStock) and (iPage = -1) then
        iPage := PC_ORI_CALCSTOCK;

      // contrôle général de la baaes
      DoInitCtrlGeneral;

      if iPage = -1 then
        iPage := PC_ORI_VERSION;
      PageOri := iPage;
                                 
    finally
      Cb_OriControle.Refresh;
      Cb_DstControle.Refresh;
      Application.ProcessMessages;
      Screen.Cursor := crDefault;
    end;
  except
    on E: Exception do
      MessageDlg(E.Message, mterror, [mbok], 0);
  end;
end;

procedure TFrm_Main.bt_PathDstClick(Sender: TObject);
var
  odTemp: TOpenDialog;
  bOk: Boolean;
begin
  bOk := False;
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'Fichier Interbase|*.IB;*.gbk|Tous|*.*';
    odTemp.Title := 'Choix de la base de données Destination';
    odTemp.Options := [ofReadOnly, ofPathMustExist, ofFileMustExist, ofNoReadOnlyReturn, ofEnableSizing];
    if odTemp.Execute then
    begin
      bOk := True;
      ed_BaseDst.Text := odTemp.FileName;
    end;
  finally
    odTemp.Free;
  end;
  Application.ProcessMessages;
  if bOk then
    Bt_ConnDstClick(Bt_ConnDst);
end;

procedure TFrm_Main.Bt_PathOriClick(Sender: TObject);
var
  odTemp: TOpenDialog;
  bOk: Boolean;
begin
  bOk := False;
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'Fichier Interbase|*.IB;*.gbk|Tous|*.*';
    odTemp.Title := 'Choix de la base de données Origine';
    odTemp.Options := [ofReadOnly, ofPathMustExist, ofFileMustExist, ofNoReadOnlyReturn, ofEnableSizing];
    if odTemp.Execute then
    begin
      bOk := True;
      ed_BaseOri.Text := odTemp.FileName;
    end;
  finally
    odTemp.Free;
  end;
  Application.ProcessMessages;
  if bOk then
    Bt_ConnOriClick(Bt_ConnOri);
end;

procedure TFrm_Main.Cb_DstControleChange(Sender: TObject);
var
  lret: Integer;
begin
  lret := Cb_DstControle.ItemIndex;
  if lret < 0 then
    exit;

  PageDst := StrToIntDef(Cb_DstControle.Items[lret], 0);
end;

procedure TFrm_Main.Cb_OriControleChange(Sender: TObject);
var
  lret: Integer;
begin
  lret := Cb_OriControle.ItemIndex;
  if lret < 0 then
    exit;

  PageOri := StrToIntDef(Cb_OriControle.Items[lret], 0);
end;

procedure TFrm_Main.Cb_OriControleDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x, y    : Integer;
  ChBrush : TColor;
  savBrush: TColor;
  ChFont  : TColor;
  savFont : TColor;
  r1      : TRect;
  iPage   : Integer;
  s       : string;
  Etat    : Integer;
begin
  with TComboBox(Control).Canvas do
  begin
    savBrush := Brush.Color;
    savFont  := Font.Color;
    Etat  := 0;
    s     := '';
    iPage := StrToIntDef(TComboBox(Control).Items[Index], -1);
    if TComboBox(Control).Tag = 1 then // Cb_OriControle
    begin
      if Mem_Ori.Locate('Numero', iPage, []) then
      begin
        s    := Mem_Ori.FieldByName('Titre').AsString;
        Etat := Mem_Ori.FieldByName('Etat').AsInteger;
      end;
    end
    else
    begin // Cb_DstControle
      if Mem_Dst.Locate('Numero', iPage, []) then
      begin
        s    := Mem_Dst.FieldByName('Titre').AsString;
        Etat := Mem_Dst.FieldByName('Etat').AsInteger;
      end;
    end;

    if (Etat = 0) or (Etat=2) then
    begin
      if odSelected in State then
      begin
        ChFont  := clWhite;
        ChBrush := rgb(153, 0, 0);
      end
      else
      begin
        ChFont  := clBlack;
        ChBrush := rgb(255, 240, 240);
      end;
    end
    else
    begin // Etat=1
      if odSelected in State then
      begin
        ChFont  := clWhite;
        ChBrush := rgb(0, 153, 0);
      end
      else
      begin
        ChFont  := clBlack;
        ChBrush := rgb(240, 255, 240);
      end;
    end;
    Brush.Color := ChBrush;
    Font.Color  := ChFont;
    FillRect(Rect);
    x := Rect.Left + 4 + LstImg_Etat32.Width + 6;
    y := Rect.Top + Round(((Rect.Bottom - Rect.Top) / 2) -
      (TextHeight('Ap') / 2));
    TextRect(Rect, x, y, s);

    x := Rect.Left + 4;
    y := Rect.Top + Round(((Rect.Bottom - Rect.Top) / 2) -
      (LstImg_Etat32.Height / 2));
    SetRect(r1, x, y, x + 32, y + 32);
    if (Etat = 0) or (Etat=2) then
      LstImg_Etat32.Draw(TComboBox(Control).Canvas, x, y, 0)
    else
      LstImg_Etat32.Draw(TComboBox(Control).Canvas, x, y, 1);
    Brush.Color := savBrush;
    Font.Color  := savFont;
  end;
end;

procedure TFrm_Main.CheckBoxGroupeClientClick(Sender: TObject);
begin
  if Pgc_Ori.ActivePage = Tab_OriParamMagasins then
    AfficherColonneGrilleParamMag(DBGridOriParamMag, 'GCL_NOM', CheckBoxGroupeClient.Checked);

  if Pgc_Dst.ActivePage = Tab_DstParamMagasins then
    AfficherColonneGrilleParamMag(DBGridDstParamMag, 'GCL_NOM', CheckBoxGroupeClient.Checked);
end;

procedure TFrm_Main.CheckBoxGroupeCompteClientClick(Sender: TObject);
begin
  if Pgc_Ori.ActivePage = Tab_OriParamMagasins then
    AfficherColonneGrilleParamMag(DBGridOriParamMag, 'GCC_NOM', CheckBoxGroupeCompteClient.Checked);

  if Pgc_Dst.ActivePage = Tab_DstParamMagasins then
    AfficherColonneGrilleParamMag(DBGridDstParamMag, 'GCC_NOM', CheckBoxGroupeCompteClient.Checked);
end;

procedure TFrm_Main.CheckBoxGroupeDePumpClick(Sender: TObject);
begin
  if Pgc_Ori.ActivePage = Tab_OriParamMagasins then
    AfficherColonneGrilleParamMag(DBGridOriParamMag, 'GCP_NOM', CheckBoxGroupeDePump.Checked);

  if Pgc_Dst.ActivePage = Tab_DstParamMagasins then
    AfficherColonneGrilleParamMag(DBGridDstParamMag, 'GCP_NOM', CheckBoxGroupeDePump.Checked);
end;

procedure TFrm_Main.AfficherColonneGrilleParamMag(DBGrid: TDBGrid; const sChamp: String; const bAfficher: Boolean);
var
  i: Integer;
begin
  for i:=0 to Pred(DBGrid.Columns.Count) do
  begin
    if DBGrid.Columns[i].FieldName = sChamp then
    begin
      DBGrid.Columns[i].Visible := bAfficher;
      Break;
    end;
  end;
end;

function TFrm_Main.doOriVersion: boolean;
const
  VERSION_MIN = 11.2;
var
  sVersion, sTmp, sVersionMaj: String;
  nIndex: Integer;
  dVersion: Double;
begin
  Result := False;
  sVersion := Dm_Main.GetVersionOri;
  Img_OriVersion.Picture := nil;
  Application.ProcessMessages;

  sTmp := sVersion;
  nIndex := Pos('.', sTmp);
  if nIndex > 0 then
  begin
    sVersionMaj := LeftStr(sTmp, nIndex);
    sTmp := Copy(sTmp, nIndex + 1, Length(sTmp));
    nIndex := Pos('.', sTmp);
    if nIndex > 0 then
    begin
      sVersionMaj := sVersionMaj + LeftStr(sTmp, nIndex - 1);
      sVersionMaj := StringReplace(sVersionMaj, '.', FormatSettings.DecimalSeparator, []);
      if TryStrToFloat(sVersionMaj, dVersion) then
        Result := (dVersion >= VERSION_MIN);
    end;
  end;

  if Result then
  begin
    Ctrl_OriVersion.Caption := 'Contrôle: Ok';
    Ctrl_OriVersion.Color   := rgb(192, 240, 192);
    Lab_OriConn.Font.Color  := rgb(0, 153, 0);
    Lab_OriConn.Caption     := 'Connecté bonne version ' + sVersion;
    LstImg_Etat64.Draw(Img_OriVersion.Canvas, 0, 0, 1);
    LInfoVerOri.Caption     := 'La version de la base de données ORIGINE est bien 11.2 ou supérieure';
    if Mem_Ori.Locate('Numero', PC_ORI_VERSION, []) then
    begin
      Mem_Ori.Edit;
      Mem_Ori.FieldByName('Etat').AsInteger := 1;
      Mem_Ori.Post;
    end;
  end
  else
  begin
    Ctrl_OriVersion.Caption := 'Contrôle: Erreur';
    Ctrl_OriVersion.Color   := rgb(240, 192, 192);
    Lab_OriConn.Font.Color  := rgb(153, 0, 0);
    Lab_OriConn.Caption     := 'Connecté mauvaise version ' + sVersion;
    LstImg_Etat64.Draw(Img_OriVersion.Canvas, 0, 0, 0);
    LInfoVerOri.Caption     := 'La version de la base de données ORIGINE doit être 11.2 minimum';
    if Mem_Ori.Locate('Numero', PC_ORI_VERSION, []) then
    begin
      Mem_Ori.Edit;
      Mem_Ori.FieldByName('Etat').AsInteger := 0;
      Mem_Ori.Post;
    end;
  end;
end;

procedure TFrm_Main.DoInitCtrlGeneral;
begin
  if not(Dm_Main.DatabaseOri.Connected) then
  begin
    exit;
  end;
  Lab_PrepaArt.Caption := '';
  Mem_Ctrl.Clear;
  Ctrl_OriCtrl.Caption := 'Contrôle: Non fait';
  Ctrl_OriCtrl.Color   := rgb(240, 192, 192);
  LstImg_Etat64.Draw(Img_OriCtrl.Canvas, 0, 0, 0);
  if Mem_Ori.Locate('Numero', PC_ORI_CONTROLE, []) then
  begin
    Mem_Ori.Edit;
    Mem_Ori.FieldByName('Etat').AsInteger := 0;
    Mem_Ori.Post;
  end;
end;

function TFrm_Main.DoOriCodeAdherentMag: boolean;
var
  iMagId: Integer; 
//  bCompare: boolean;
begin
  if not(Dm_Main.DatabaseOri.Connected) then
  begin
    Result := false;
    exit;
  end;
  Result := true;
  with Dm_Main.Que_OriMag do
  begin
    iMagId := -1;
    if Active then
      iMagId := FieldByName('MAG_ID').AsInteger;
    Open;
    DisableControls;
    try
      First;
      while not(Eof) do
      begin
        if Trim(FieldByName('MAG_CODEADH').AsString) = '' then
          Result := false;

        Next;
      end;
    finally
      if not(Locate('MAG_ID', iMagId, [])) then
        First;
      EnableControls;
    end;
  end;

  LOriMag.Visible := not(Result);

  //bCompare := DoOriDstCodeMag;
  //Result := Result and bCompare;
  Result := Result;

  Img_OriMag.Picture := nil;   
  Application.ProcessMessages;
  if Result then
  begin
    Ctrl_OriMag.Caption := 'Contrôle: Ok';
    Ctrl_OriMag.Color   := rgb(192, 240, 192);
    LstImg_Etat64.Draw(Img_OriMag.Canvas, 0, 0, 1);
    if Mem_Ori.Locate('Numero', PC_ORI_MAGASIN, []) then
    begin
      Mem_Ori.Edit;
      Mem_Ori.FieldByName('Etat').AsInteger := 1;
      Mem_Ori.Post;
    end;
  end
  else
  begin
    Ctrl_OriMag.Caption := 'Contrôle: Erreur';
    Ctrl_OriMag.Color   := rgb(240, 192, 192);
    LstImg_Etat64.Draw(Img_OriMag.Canvas, 0, 0, 0);
    if Mem_Ori.Locate('Numero', PC_ORI_MAGASIN, []) then
    begin
      Mem_Ori.Edit;
      Mem_Ori.FieldByName('Etat').AsInteger := 0;
      Mem_Ori.Post;
    end;
  end
end;

function TFrm_Main.DoOriParamMagasins: Boolean;
var
  nIDMag: Integer;
begin
  Result := True;
  if not Dm_Main.DatabaseOri.Connected then
  begin
    Result := False;
    Exit;
  end;

  nIDMag := -1;
  if(Dm_Main.Que_OriParamMag.Active) and (not Dm_Main.Que_OriParamMag.IsEmpty) then
    nIDMag := Dm_Main.Que_OriParamMag.FieldByName('MAG_ID').AsInteger;

  // Paramétrage magasins.
  Dm_Main.Que_OriParamMag.Close;
  try
    Dm_Main.Que_OriParamMag.Open;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar(E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
      Exit;
    end;
  end;

  if(Dm_Main.Que_OriParamMag.Active) and (not Dm_Main.Que_OriParamMag.IsEmpty) and (nIDMag > -1) then
  begin
    try
      Dm_Main.Que_OriParamMag.Locate('MAG_ID', nIDMag, []);
    except
    end;
  end;

  Img_OriParamMag.Picture := nil;
  Application.ProcessMessages;
  if Result then
  begin
    Ctrl_OriParamMag.Caption := 'Contrôle: Ok';
    Ctrl_OriParamMag.Color := RGB(192, 240, 192);
    LstImg_Etat64.Draw(Img_OriParamMag.Canvas, 0, 0, 1);
    if Mem_Ori.Locate('Numero', PC_ORI_PARAM_MAGASINS, []) then
    begin
      Mem_Ori.Edit;
      Mem_Ori.FieldByName('Etat').AsInteger := 1;
      Mem_Ori.Post;
    end;
  end
  else
  begin
    Ctrl_OriParamMag.Caption := 'Contrôle: Erreur';
    Ctrl_OriParamMag.Color := RGB(240, 192, 192);
    LstImg_Etat64.Draw(Img_OriParamMag.Canvas, 0, 0, 0);
    if Mem_Ori.Locate('Numero', PC_ORI_PARAM_MAGASINS, []) then
    begin
      Mem_Ori.Edit;
      Mem_Ori.FieldByName('Etat').AsInteger := 0;
      Mem_Ori.Post;
    end;
  end;
end;

{unction TFrm_Main.DoOriDstCodeMag: boolean;
var
  iMagIdOri: Integer;
  iMagIdDst: Integer;
  sCodeMag : string;
begin
  Result := true;
  if not(Dm_Main.Que_OriMag.Active) then
  begin
    Result             := false;
    LOriDstMag.Caption := 'Base Origine non ouverte';
    LOriDstMag.Visible := true;
    exit;
  end;
  if not(Dm_Main.Que_DstMag.Active) then
  begin
    Result             := false;
    LOriDstMag.Caption := 'Base Destination non ouverte';
    LOriDstMag.Visible := true;
    exit;
  end;

  with Dm_Main.Que_OriMag do
  begin
    iMagIdOri := FieldByName('MAG_ID').AsInteger;
    iMagIdDst := Dm_Main.Que_DstMag.FieldByName('MAG_ID').AsInteger;
    DisableControls;
    Dm_Main.Que_DstMag.DisableControls;
    try
      First;
      while not(Eof) do
      begin
        sCodeMag := Trim(FieldByName('MAG_CODEADH').AsString);
        if (sCodeMag<>'') and not(Dm_Main.Que_DstMag.Locate('MAG_CODEADH', sCodeMag, [])) then
          Result := false;

        Next;
      end;
    finally
      if not(Locate('MAG_ID', iMagIdOri, [])) then
        First;
      if not(Dm_Main.Que_DstMag.Locate('MAG_ID', iMagIdDst, [])) then
        First;
      EnableControls;
      Dm_Main.Que_DstMag.EnableControls;
    end;
  end;

  if Result then
  begin
    LOriDstMag.Caption := '';
    LOriDstMag.Visible := false;
  end
  else
  begin
    LOriDstMag.Caption := 'Un ou plus. code adh. non présent dans dest.';
    LOriDstMag.Visible := true;
  end;
end;  }

function TFrm_Main.DoOriCtrlStock: boolean;
var
  NBre: integer;
begin
  Nbre   := Dm_Main.GetOriCntStkReCalc;

  Result := (Nbre = 0);

  if Nbre=0 then
    Lab_OriRecalStock.Caption := 'Aucun article à recalculer'
  else
    Lab_OriRecalStock.Caption := inttostr(Nbre)+' ARTICLE(S) A RECALCULER';

  Img_OriStock.Picture := nil;
  Application.ProcessMessages;
  if Result then
  begin
    Ctrl_OriStock.Caption := 'Contrôle: Ok';
    Ctrl_OriStock.Color   := rgb(192, 240, 192);
    LstImg_Etat64.Draw(Img_OriStock.Canvas, 0, 0, 1);
    if Mem_Ori.Locate('Numero', PC_ORI_CALCSTOCK, []) then
    begin
      Mem_Ori.Edit;
      Mem_Ori.FieldByName('Etat').AsInteger := 1;
      Mem_Ori.Post;
    end;
  end
  else
  begin
    Ctrl_OriStock.Caption := 'Contrôle: Erreur';
    Ctrl_OriStock.Color   := rgb(240, 192, 192);
    LstImg_Etat64.Draw(Img_OriStock.Canvas, 0, 0, 0);
    if Mem_Ori.Locate('Numero', PC_ORI_CALCSTOCK, []) then
    begin
      Mem_Ori.Edit;
      Mem_Ori.FieldByName('Etat').AsInteger := 0;
      Mem_Ori.Post;
    end;
  end
end;

function TFrm_Main.doDstVersion: boolean;
const
  VERSION_MIN = 13.1;
var
  sVersion, sTmp, sVersionMaj: String;
  nIndex: Integer;
  dVersion: Double;
begin
  Result := False;
  sVersion := Dm_Main.GetVersionDst;
  Img_DstVersion.Picture := nil;
  Application.ProcessMessages;

  sTmp := sVersion;
  nIndex := Pos('.', sTmp);
  if nIndex > 0 then
  begin
    sVersionMaj := LeftStr(sTmp, nIndex);
    sTmp := Copy(sTmp, nIndex + 1, Length(sTmp));
    nIndex := Pos('.', sTmp);
    if nIndex > 0 then
    begin
      sVersionMaj := sVersionMaj + LeftStr(sTmp, nIndex - 1);
      sVersionMaj := StringReplace(sVersionMaj, '.', FormatSettings.DecimalSeparator, []);
      if TryStrToFloat(sVersionMaj, dVersion) then
        Result := (dVersion >= VERSION_MIN);
    end;
  end;

  if Result then
  begin
    Result                  := true;
    Ctrl_DstVersion.Caption := 'Contrôle: Ok';
    Ctrl_DstVersion.Color   := rgb(192, 240, 192);
    Lab_DstConn.Font.Color  := rgb(0, 153, 0);
    Lab_DstConn.Caption     := 'Connecté bonne version ' + sVersion;
    LstImg_Etat64.Draw(Img_DstVersion.Canvas, 0, 0, 1);
    LInfoVerDst.Caption     := 'La version de la base de données DESTINATION est bien 13.1 ou supérieure';
    if Mem_Dst.Locate('Numero', PC_DST_VERSION, []) then
    begin
      Mem_Dst.Edit;
      Mem_Dst.FieldByName('Etat').AsInteger := 1;
      Mem_Dst.Post;
    end;
  end
  else
  begin
    Ctrl_DstVersion.Caption := 'Contrôle: Erreur';
    Ctrl_DstVersion.Color   := rgb(240, 192, 192);
    Lab_DstConn.Font.Color  := rgb(153, 0, 0);
    Lab_DstConn.Caption     := 'Connecté mauvaise version ' + sVersion;
    LstImg_Etat64.Draw(Img_DstVersion.Canvas, 0, 0, 0);
    LInfoVerDst.Caption    := 'La version de la base de données DESTINATION doit être 13.1 minimum';
    if Mem_Dst.Locate('Numero', PC_DST_VERSION, []) then
    begin
      Mem_Dst.Edit;
      Mem_Dst.FieldByName('Etat').AsInteger := 0;
      Mem_Dst.Post;
    end;
  end
end;

function TFrm_Main.DoDstCodeAdherentMag: boolean;
var
  iMagId: Integer;
//  bCompare: boolean;
begin
  if not(Dm_Main.DatabaseDst.Connected) then
  begin
    Result := false;
    exit;
  end;
  Result := true;
  with Dm_Main.Que_DstMag do
  begin
    iMagId := -1;
    if Active then
      iMagId := FieldByName('MAG_ID').AsInteger;
    Open;
    DisableControls;
    try
      First;
      while not(Eof) do
      begin
        if Trim(FieldByName('MAG_CODEADH').AsString) = '' then
          Result := false;

        Next;
      end;
    finally
      if not(Locate('MAG_ID', iMagId, [])) then
        First;
      EnableControls;
    end;
  end; 
  
  LDstMag.Visible := not(Result);

//  bCompare           := DoDstOriCodeMag;
//  Result             := Result and bCompare;
  Result             := Result;

  Img_DstMag.Picture := nil; 
  Application.ProcessMessages;
  if Result then
  begin
    LDstOriMag.Visible  := False;
    Ctrl_DstMag.Caption := 'Contrôle: Ok';
    Ctrl_DstMag.Color   := rgb(192, 240, 192);
    LstImg_Etat64.Draw(Img_DstMag.Canvas, 0, 0, 1);
    if Mem_Dst.Locate('Numero', PC_DST_MAGASIN, []) then
    begin
      Mem_Dst.Edit;
      Mem_Dst.FieldByName('Etat').AsInteger := 1;
      Mem_Dst.Post;
    end;
  end
  else
  begin
    Ctrl_DstMag.Caption := 'Contrôle: Erreur';
    Ctrl_DstMag.Color   := rgb(240, 192, 192);
    LstImg_Etat64.Draw(Img_DstMag.Canvas, 0, 0, 0);
    if Mem_Dst.Locate('Numero', PC_DST_MAGASIN, []) then
    begin
      Mem_Dst.Edit;
      Mem_Dst.FieldByName('Etat').AsInteger := 0;
      Mem_Dst.Post;
    end;
  end
end;

function TFrm_Main.DoDstGrpPump: boolean;
var
  sTmp: string;
  QueTmp: TIBOQuery;
begin
  Result := True;

  if not(Dm_Main.DatabaseDst.Connected) then
  begin
    Result := False;
    exit;
  end;

  sTmp := '';
  QueTmp := TIBOQuery.Create(Self);
  try
    QueTmp.IB_Connection  := Dm_Main.DatabaseDst;
    QueTmp.IB_Transaction := Dm_Main.Trans_Dst;
    // test sur les groupe de pump
    with QueTmp, SQL do
    begin
      Close;
      Clear;
      Add('select GCP_ID from GENGESTIONPUMP');
      Add('  join k on k_id=gcp_id and k_enabled=1');
      Add(' where GCP_ID<>0');
      try
        Open;
        Result := (RecordCount>0);
        if RecordCount=0 then
          sTmp := 'Pas de groupe de Pump défini';
        Close;
      except
        Result := false;
        sTmp   := 'Impossible de tester le groupe de Pump';
      end;
    end;
    // test sur l'affection des magasins à un groupe de pump
    if Result then
    begin
      try
        with QueTmp, SQL do
        begin
          Close;
          Clear;
          Add('select MAG_ID, MAG_ENSEIGNE, MPU_ID from GENMAGASIN');
          Add('  join k on k_id=mag_id and k_enabled=1');
          Add('  left join GENMAGGESTIONPUMP on MPU_MAGID=MAG_ID');
          Add(' where MAG_ID<>0');
          Open;
          while not(eof) do
          begin
            if (FieldByName('MPU_ID').IsNull) or (FieldByName('MPU_ID').AsInteger=0) then
            begin
              sTmp   := 'Au moins un magasin n''est pas affecté à un groupe de Pump';
              Result := false;
            end;
            Next;
          end;
          Close;
        end;
      except
        Result := false;
        sTmp   := 'Impossible de tester les magasins aux groupes de Pump';
      end;
    end;
  finally
    QueTmp.Close;
    FreeAndNil(QueTmp);
  end;


  Img_DstGrpPump.Picture := nil;
  Application.ProcessMessages;
  if Result then
  begin
    Lab_DstGrpPump.Caption  := 'Tous les magasins sont affectés à un groupe de Pump';
    Ctrl_DstGrpPump.Caption := 'Contrôle: Ok';
    Ctrl_DstGrpPump.Color   := rgb(192, 240, 192);
    LstImg_Etat64.Draw(Img_DstGrpPump.Canvas, 0, 0, 1);
    if Mem_Dst.Locate('Numero', PC_DST_GROUPPUMP, []) then
    begin
      Mem_Dst.Edit;
      Mem_Dst.FieldByName('Etat').AsInteger := 1;
      Mem_Dst.Post;
    end;
  end
  else
  begin
    Lab_DstGrpPump.Caption  := sTmp;
    Ctrl_DstGrpPump.Caption := 'Contrôle: Erreur';
    Ctrl_DstGrpPump.Color   := rgb(240, 192, 192);
    LstImg_Etat64.Draw(Img_DstGrpPump.Canvas, 0, 0, 0);
    if Mem_Dst.Locate('Numero', PC_DST_GROUPPUMP, []) then
    begin
      Mem_Dst.Edit;
      Mem_Dst.FieldByName('Etat').AsInteger := 0;
      Mem_Dst.Post;
    end;
  end
end;

function TFrm_Main.DoDstParamMagasins: Boolean;
var
  nIDMag: Integer;
begin
  Result := True;
  if not Dm_Main.DatabaseDst.Connected then
  begin
    Result := False;
    Exit;
  end;

  nIDMag := -1;
  if(Dm_Main.Que_DstParamMag.Active) and (not Dm_Main.Que_DstParamMag.IsEmpty) then
    nIDMag := Dm_Main.Que_DstParamMag.FieldByName('MAG_ID').AsInteger;

  // Paramétrage magasins.
  Dm_Main.Que_DstParamMag.Close;
  try
    Dm_Main.Que_DstParamMag.Open;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar(E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
      Exit;
    end;
  end;

  if(Dm_Main.Que_DstParamMag.Active) and (not Dm_Main.Que_DstParamMag.IsEmpty) and (nIDMag > -1) then
  begin
    try
      Dm_Main.Que_DstParamMag.Locate('MAG_ID', nIDMag, []);
    except
    end;
  end;

  Img_DstParamMag.Picture := nil;
  Application.ProcessMessages;
  if Result then
  begin
    Ctrl_DstParamMag.Caption := 'Contrôle: Ok';
    Ctrl_DstParamMag.Color := RGB(192, 240, 192);
    LstImg_Etat64.Draw(Img_DstParamMag.Canvas, 0, 0, 1);
    if Mem_Dst.Locate('Numero', PC_DST_PARAM_MAGASINS, []) then
    begin
      Mem_Dst.Edit;
      Mem_Dst.FieldByName('Etat').AsInteger := 1;
      Mem_Dst.Post;
    end;
  end
  else
  begin
    Ctrl_DstParamMag.Caption := 'Contrôle: Erreur';
    Ctrl_DstParamMag.Color := RGB(240, 192, 192);
    LstImg_Etat64.Draw(Img_DstParamMag.Canvas, 0, 0, 0);
    if Mem_Dst.Locate('Numero', PC_DST_PARAM_MAGASINS, []) then
    begin
      Mem_Dst.Edit;
      Mem_Dst.FieldByName('Etat').AsInteger := 0;
      Mem_Dst.Post;
    end;
  end;
end;

{unction TFrm_Main.DoDstOriCodeMag: boolean;
var
  iMagIdOri: Integer;
  iMagIdDst: Integer;
  sCodeMag : string;
begin
  Result := true; 
  if not(Dm_Main.Que_DstMag.Active) then   
  begin
    Result             := false;
    LDstOriMag.Caption := 'Base Destination non ouverte';
    LDstOriMag.Visible := true;
    exit;
  end;
  if not(Dm_Main.Que_OriMag.Active) then    
  begin
    Result             := false;
    LDstOriMag.Caption := 'Base Origine non ouverte';
    LDstOriMag.Visible := true;
    exit;
  end;

  with Dm_Main.Que_DstMag do    
  begin
    iMagIdDst := FieldByName('MAG_ID').AsInteger;
    iMagIdOri := Dm_Main.Que_OriMag.FieldByName('MAG_ID').AsInteger;
    DisableControls;
    Dm_Main.Que_OriMag.DisableControls;
    try
      First;
      while not(Eof) do
      begin
        sCodeMag := Trim(FieldByName('MAG_CODEADH').AsString);
        if (sCodeMag<>'') and not(Dm_Main.Que_OriMag.Locate('MAG_CODEADH', sCodeMag, [])) then
          Result := false;

        Next;
      end;
    finally
      if not(Locate('MAG_ID', iMagIdDst, [])) then
        First;
      if not(Dm_Main.Que_OriMag.Locate('MAG_ID', iMagIdOri, [])) then
        First;
      EnableControls;
      Dm_Main.Que_OriMag.EnableControls;
    end;
  end;

  if Result then
  begin
    LDstOriMag.Caption := '';
    LDstOriMag.Visible := false;
  end
  else
  begin
    LDstOriMag.Caption := 'Un ou plus. code adh. non présent dans Orig.';
    LDstOriMag.Visible := true;
  end;
end;  }

procedure TFrm_Main.Nbt_AffectGrpPumpAutoClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    Dm_Main.GrpPumpAuto;
    DoDstGrpPump;
    Cb_DstControle.Refresh;
  finally
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.Nbt_CtrlBaseClick(Sender: TObject);
begin
  if not(MemD_PrepaArt.Active) or (MemD_PrepaArt.RecordCount=0) then
  begin
    MessageDlg('Pas de fichier préparation article', mterror,[mbok],0);
    exit;
  end;
  ControlerBase;
end;

procedure TFrm_Main.Nbt_CtrlParamClick(Sender: TObject);
var
  p: TPoint;
begin
  GetCursorPos(p);
  Pop_CtrlParam.Popup(p.X, p.Y);
//  Pop_CtrlParam.Popup(ClientToScreen(Point(Nbt_CtrlParam.Left, Nbt_CtrlParam.Top)).X,
//                      ClientToScreen(Point(Nbt_CtrlParam.Left, Nbt_CtrlParam.Top)).Y+Nbt_CtrlParam.Height);
end;

procedure TFrm_Main.Nbt_DstAffecterPumpClick(Sender: TObject);
begin
  Frm_GrpPump := TFrm_GrpPump.Create(nil);
  try
    Frm_GrpPump.InitEcr;
    Frm_GrpPump.ShowModal;
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    try
      DoDstGrpPump;
      Cb_DstControle.Refresh;
    finally
      Application.ProcessMessages;
      Screen.Cursor := crDefault;
    end;
  finally
    FreeAndNil(Frm_GrpPump);
  end;
end;

procedure TFrm_Main.Nbt_DstMagModifClick(Sender: TObject);
begin
  if not(Dm_Main.Que_DstMag.Active) or (Dm_Main.Que_DstMag.RecordCount=0) then
    exit;

  Frm_ModifCodeAdh := TFrm_ModifCodeAdh.Create(Self);
  try
    Frm_ModifCodeAdh.SetModif(False);
    Frm_ModifCodeAdh.ShowModal;
  finally
    FreeAndNil(Frm_ModifCodeAdh);
  end;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    DoOriCodeAdherentMag;
    DoDstCodeAdherentMag;
  finally
    Cb_OriControle.Refresh;
    Cb_DstControle.Refresh;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.Nbt_DstPumpRefreshClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    DoDstGrpPump;
    Cb_DstControle.Refresh;
  finally
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.btn_QuitterClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_Main.FormActivate(Sender: TObject);
begin
  if EtatFiche then
    exit;
  EtatFiche      := true;
  Application.ProcessMessages;
  Realign;
  Application.ProcessMessages;
  Align          := alNone;
  Application.ProcessMessages;
  LOriMag.Top    := Nbt_OriMagModif.Top-1;
  LOriDstMag.Top := LOriMag.Top+LOriMag.Height+1;
end;

procedure TFrm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //quand on ferme la form
  Self.Free;
  Application.Terminate;
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
begin
  ReperBase := extractfilePath(Paramstr(0));
  if ReperBase[Length(ReperBase)]<>'\' then
    ReperBase := ReperBase+'\';

  EtatFiche              := false;
  Lab_OriConn.Caption    := 'Déconnecté';
  Lab_OriConn.Font.Color := rgb(0, 0, 153);
  Lab_DstConn.Caption    := 'Déconnecté';
  Lab_DstConn.Font.Color := rgb(0, 0, 153);
  FPageOri               := -1;
  PageOri                := PC_ORI_RIEN;
  // init origine
  InitOrigine;

  FPageDst := -1;
  PageDst  := PC_DST_RIEN;
  // init destination
  InitDestination;

  Lab_InfoCtrl.Caption := '';

  Caption              := Caption +' - Version '+ GetNumVersionSoft();
end;

procedure TFrm_Main.InitOrigine;
begin
  Cb_OriControle.Clear;
  Mem_Ori.Close;
  Mem_Ori.Open;
  // version
  Mem_Ori.Append;
  Mem_Ori.FieldByName('NUMERO').AsInteger := PC_ORI_VERSION;
  Mem_Ori.FieldByName('TITRE').AsString   := 'Version de la base';
  Mem_Ori.FieldByName('ETAT').AsInteger   := 0;
  Mem_Ori.Post;
  Cb_OriControle.Items.Add(IntToStr(PC_ORI_VERSION));

  // code adhérent magasin
  Mem_Ori.Append;
  Mem_Ori.FieldByName('NUMERO').AsInteger := PC_ORI_MAGASIN;
  Mem_Ori.FieldByName('TITRE').AsString   := 'Code adhérent magasin';
  Mem_Ori.FieldByName('ETAT').AsInteger   := 0;
  Mem_Ori.Post;
  Cb_OriControle.Items.Add(IntToStr(PC_ORI_MAGASIN));

  // Paramétrage magasins.
  Mem_Ori.Append;
  Mem_Ori.FieldByName('NUMERO').AsInteger := PC_ORI_PARAM_MAGASINS;
  Mem_Ori.FieldByName('TITRE').AsString := 'Paramétrage magasins';
  Mem_Ori.FieldByName('ETAT').AsInteger := 0;
  Mem_Ori.Post;
  Cb_OriControle.Items.Add(IntToStr(PC_ORI_PARAM_MAGASINS));

  // contrôle s'il y a besoin de recalculer le stock
  Mem_Ori.Append;
  Mem_Ori.FieldByName('NUMERO').AsInteger := PC_ORI_CALCSTOCK;
  Mem_Ori.FieldByName('TITRE').AsString   := 'Recalcul du stock';
  Mem_Ori.FieldByName('ETAT').AsInteger   := 0;
  Mem_Ori.Post;
  Cb_OriControle.Items.Add(IntToStr(PC_ORI_CALCSTOCK));

  // contrôle générale de la base
  Mem_Ori.Append;
  Mem_Ori.FieldByName('NUMERO').AsInteger := PC_ORI_CONTROLE;
  Mem_Ori.FieldByName('TITRE').AsString   := 'Contrôle général de la base';
  Mem_Ori.FieldByName('ETAT').AsInteger   := 0;
  Mem_Ori.Post;
  Cb_OriControle.Items.Add(IntToStr(PC_ORI_CONTROLE));
end;

procedure TFrm_Main.MnCtrlFournClick(Sender: TObject);
begin
  TMenuItem(Sender).Checked := not(TMenuItem(Sender).Checked);
end;

procedure TFrm_Main.InitDestination;
begin
  Cb_DstControle.Clear;
  Mem_Dst.Close;
  Mem_Dst.Open;
  // version
  Mem_Dst.Append;
  Mem_Dst.FieldByName('NUMERO').AsInteger := PC_DST_VERSION;
  Mem_Dst.FieldByName('TITRE').AsString   := 'Version de la base';
  Mem_Dst.FieldByName('ETAT').AsInteger   := 0;
  Mem_Dst.Post;
  Cb_DstControle.Items.Add(IntToStr(PC_DST_VERSION));

  // code adhérent magasin
  Mem_Dst.Append;
  Mem_Dst.FieldByName('NUMERO').AsInteger := PC_DST_MAGASIN;
  Mem_Dst.FieldByName('TITRE').AsString   := 'Code adhérent magasin';
  Mem_Dst.FieldByName('ETAT').AsInteger   := 0;
  Mem_Dst.Post;
  Cb_DstControle.Items.Add(IntToStr(PC_DST_MAGASIN));

  // Paramétrage magasins.
  Mem_Dst.Append;
  Mem_Dst.FieldByName('NUMERO').AsInteger := PC_DST_PARAM_MAGASINS;
  Mem_Dst.FieldByName('TITRE').AsString := 'Paramétrage magasins';
  Mem_Dst.FieldByName('ETAT').AsInteger := 0;
  Mem_Dst.Post;
  Cb_DstControle.Items.Add(IntToStr(PC_DST_PARAM_MAGASINS));

  // groupe de pump
  Mem_Dst.Append;
  Mem_Dst.FieldByName('NUMERO').AsInteger := PC_DST_GROUPPUMP;
  Mem_Dst.FieldByName('TITRE').AsString   := 'Groupe de pump';
  Mem_Dst.FieldByName('ETAT').AsInteger   := 0;
  Mem_Dst.Post;
  Cb_DstControle.Items.Add(IntToStr(PC_DST_GROUPPUMP));
end;

procedure TFrm_Main.Nbt_OriMagModifClick(Sender: TObject);
begin
  if not(Dm_Main.Que_OriMag.Active) or (Dm_Main.Que_OriMag.RecordCount=0) then
    Exit;

  Frm_ModifCodeAdh := TFrm_ModifCodeAdh.Create(Self);
  try
    Frm_ModifCodeAdh.SetModif(True);
    Frm_ModifCodeAdh.ShowModal;
  finally
    FreeAndNil(Frm_ModifCodeAdh);
  end;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    DoOriCodeAdherentMag;
    DoDstCodeAdherentMag;
  finally
    Cb_OriControle.Refresh;
    Cb_DstControle.Refresh;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.Nbt_OriMagRefreshClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    DoOriCodeAdherentMag;
    DoDstCodeAdherentMag;
  finally
    Cb_OriControle.Refresh;
    Cb_DstControle.Refresh;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.Btn_OriParamMagRafraichirClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    DoOriParamMagasins;
  finally
    Cb_OriControle.Refresh;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.Btn_OriParamMagModifierClick(Sender: TObject);
begin
  FrmParamMagasins := TFrmParamMagasins.Create(Self, Pgc_Ori);
  try
    FrmParamMagasins.Initialisations(True, Dm_Main.Que_OriParamMag.FieldByName('MAG_ID').AsInteger, Dm_Main.Que_OriParamMag.FieldByName('MAG_NOM').AsString, Dm_Main.Que_OriParamMag.FieldByName('GCL_ID').AsInteger, Dm_Main.Que_OriParamMag.FieldByName('GCC_ID').AsInteger, Dm_Main.Que_OriParamMag.FieldByName('GCP_ID').AsInteger);

    // Si validation.
    if FrmParamMagasins.ShowModal = mrOk then
      DoOriParamMagasins;
    DBGridOriParamMag.SetFocus;
  finally
    FreeAndNil(FrmParamMagasins);
  end;
end;

procedure TFrm_Main.Nbt_OriStkRefreshClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    DoOriCtrlStock;
    Cb_OriControle.Refresh;
  finally
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.Btn_DstParamMagRafraichirClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    DoDstParamMagasins;
  finally
    Cb_DstControle.Refresh;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.Btn_DstParamMagModifierClick(Sender: TObject);
begin
  FrmParamMagasins := TFrmParamMagasins.Create(Self, Pgc_Dst);
  try
    FrmParamMagasins.Initialisations(False, Dm_Main.Que_DstParamMag.FieldByName('MAG_ID').AsInteger, Dm_Main.Que_DstParamMag.FieldByName('MAG_NOM').AsString, Dm_Main.Que_DstParamMag.FieldByName('GCL_ID').AsInteger, Dm_Main.Que_DstParamMag.FieldByName('GCC_ID').AsInteger, Dm_Main.Que_DstParamMag.FieldByName('GCP_ID').AsInteger);

    // Si validation.
    if FrmParamMagasins.ShowModal = mrOk then
      DoDstParamMagasins;
    DBGridDstParamMag.SetFocus;
  finally
    FreeAndNil(FrmParamMagasins);
  end;
end;

procedure TFrm_Main.Nbt_OuvrirPrepaArtClick(Sender: TObject);
var
  sFile: string;
begin
  sFile := '';
  if OD_PrepaArt.Execute then
    sFile := OD_PrepaArt.FileName;

  if sFile='' then
    exit;

  DoInitCtrlGeneral;
  Application.ProcessMessages;
  Screen.Cursor := crHourGlass;
  try
    MemD_PrepaArt.Close;
    MemD_PrepaArt.Open;
    MemD_PrepaArt.LoadFromBinaryFile(sFile);
    Lab_PrepaArt.Caption := inttostr(MemD_PrepaArt.RecordCount)+' Modèles: '+
                            ExtractFileName(sFile);
  finally
    Cb_OriControle.Refresh;
    Screen.Cursor := crDefault;
    Application.ProcessMessages;
  end;
end;

function TFrm_Main.PreparerArt: boolean;
var
  sFile     : string;
  QueArt    : TIBOQuery;
  QueTst    : TIBOQuery;
  dLimit    : TDateTime;
  bOk       : boolean;
  iArtId    : integer;
  dRefresh  : DWord;
  nbArt     : integer;
  ArtEnCours: integer;
begin
  result  := false;
  sFile   := '';
  if SD_PrepaArt.Execute then
    sFile := SD_PrepaArt.FileName;

  if sFile = '' then
    exit;

  bOk           := false;
  dLimit        := Date;
  Frm_DateLimit := TFrm_DateLimit.Create(Self);
  try
    if Frm_DateLimit.ShowModal=mrok then
    begin
      bOk    := true;
      dLimit := Frm_DateLimit.Chp_Date.Date;
    end;
  finally
    FreeAndNil(Frm_DateLimit);
  end;

  if not(bOk) then
    exit;

  if FileExists(sFile) then
    DeleteFile(sFile);

  DoInitCtrlGeneral;
  Application.ProcessMessages;
  Screen.Cursor := crHourGlass;
  dRefresh      := GetTickCount;
  QueArt        := TIBOQuery.Create(Self);
  QueTst        := TIBOQuery.Create(Self);
  try
    QueArt.IB_Connection  := Dm_Main.DatabaseOri;
    QueArt.IB_Transaction := Dm_Main.Trans_Ori;
    QueTst.IB_Connection  := Dm_Main.DatabaseOri;
    QueTst.IB_Transaction := Dm_Main.Trans_Ori;

    MemD_PrepaArt.Close;
    MemD_PrepaArt.Open;

    // nombre d'article
    QueArt.Close;
    QueArt.SQL.Clear;
    QueArt.SQL.Add('select count(art_id) as NBRE from ARTARTICLE');
    QueArt.SQL.Add('  join k on k_id=art_id and k_enabled=1');
    QueArt.SQL.Add(' where ART_ID<>0');
    QueArt.Open;
    nbArt := QueArt.FieldByName('NBRE').AsInteger;

    QueArt.Close;
    QueArt.SQL.Clear;
    QueArt.SQL.Add('select ART_ID, ARF_CREE, ARF_VIRTUEL, ARF_ID, ARF_CHRONO, ART_NOM, ART_SSFID, ART_MRKID from ARTARTICLE');
    QueArt.SQL.Add('  join k on k_id=art_id and k_enabled=1');
    QueArt.SQL.Add('  join ARTREFERENCE on arf_artid=art_id');
    QueArt.SQL.Add(' where ART_ID<>0');
    QueArt.Open;
    ArtEnCours := 1;
    Lab_PrepaArt.Caption := inttostr(ArtEnCours)+' / '+inttostr(NbArt);
    Application.ProcessMessages;
    QueArt.First;
    while not(QueArt.Eof) do
    begin
      iArtId := QueArt.FieldByName('ART_ID').AsInteger;

      // Pseudo ?
      bOk := (QueArt.FieldByName('ARF_VIRTUEL').AsInteger=1);

      if not(bOk) then
      begin
        // stk courant>0 ?
        QueTst.Close;
        QueTst.SQL.Clear;
        QueTst.SQL.Add('select sum(stc_qte) as QTE from AGRSTOCKCOUR');
        QueTst.SQL.Add(' where stc_artid='+inttostr(iArtId));
        QueTst.Open;
        if Round(QueTst.FieldByName('QTE').AsInteger)>0 then
          bOk := true;
        QueTst.Close;
      end;

      if (QueArt.FieldByName('ARF_CREE').AsDateTime>Trunc(dLimit)) then
      begin
        if not(bOk) then
        begin
          // du pump ?
          QueTst.Close;
          QueTst.SQL.Clear;
          QueTst.SQL.Add('select distinct hpp_artid from agrhistopump');
          QueTst.SQL.Add(' where hpp_artid='+inttostr(iArtId));
          QueTst.Open;
          if QueTst.RecordCount>0 then
            bOk := true;
          QueTst.Close;
        end;

        if not(bOk) then
        begin
          // du stock ?
          QueTst.Close;
          QueTst.SQL.Clear;
          QueTst.SQL.Add('select distinct hst_artid from agrhistostock');
          QueTst.SQL.Add(' where hst_artid='+inttostr(iArtId));
          QueTst.Open;
          if QueTst.RecordCount>0 then
            bOk := true;
          QueTst.Close;
        end;

        if not(bOk) then
        begin
          // du RAL ?
          QueTst.Close;
          QueTst.SQL.Clear;
          QueTst.SQL.Add('select distinct cdl_artid from COMBCDEL');
          QueTst.SQL.Add('  JOIN AGRRAL ON (RAL_CDLID=CDL_ID AND RAL_QTE <> 0)');
          QueTst.SQL.Add(' where cdl_artid='+inttostr(iArtId));
          QueTst.Open;
          if QueTst.RecordCount>0 then
            bOk := true;
          QueTst.Close;
        end;
      end
      else
      begin
        if not(bOk) then
        begin
          // du pump ?
          QueTst.Close;
          QueTst.SQL.Clear;
          QueTst.SQL.Add('select distinct hpp_artid from agrhistopump');
          QueTst.SQL.Add(' where cast(hpp_date as date)>='+QuotedStr(FormatDateTime('mm/dd/yyyy', dLimit)));
          QueTst.SQL.Add('   and hpp_artid='+inttostr(iArtId));
          QueTst.Open;
          if QueTst.RecordCount>0 then
            bOk := true;
          QueTst.Close;
        end;

        if not(bOk) then
        begin
          // du stock ?
          QueTst.Close;
          QueTst.SQL.Clear;
          QueTst.SQL.Add('select distinct hst_artid from agrhistostock');
          QueTst.SQL.Add(' where cast(hst_date as date)>='+QuotedStr(FormatDateTime('mm/dd/yyyy', dLimit)));
          QueTst.SQL.Add('   and hst_artid='+inttostr(iArtId));
          QueTst.Open;
          if QueTst.RecordCount>0 then
            bOk := true;
          QueTst.Close;
        end;
      end;

      if bOk then
      begin
        MemD_PrepaArt.Append;
        MemD_PrepaArt.FieldByName('ARTID').AsInteger := iArtId;
        MemD_PrepaArt.FieldByName('MRKID').AsInteger := QueArt.FieldByName('ART_MRKID').AsInteger;
        MemD_PrepaArt.FieldByName('SSFID').AsInteger := QueArt.FieldByName('ART_SSFID').AsInteger;
        MemD_PrepaArt.FieldByName('ARFID').AsInteger := QueArt.FieldByName('ARF_ID').AsInteger;
        MemD_PrepaArt.FieldByName('CHRONO').AsString := QueArt.FieldByName('ARF_CHRONO').AsString;
        MemD_PrepaArt.FieldByName('ARTNOM').AsString := QueArt.FieldByName('ART_NOM').AsString;
        MemD_PrepaArt.FieldByName('VIRTUEL').AsInteger := QueArt.FieldByName('ARF_VIRTUEL').AsInteger;
        MemD_PrepaArt.Post;
      end;

      if ((GetTickCount-dRefresh)>1500) then
      begin
        Lab_PrepaArt.Caption := inttostr(ArtEnCours)+' / '+inttostr(NbArt);
        Application.ProcessMessages;
        dRefresh := getTickCount;
      end;

      inc(ArtEnCours);
      QueArt.Next;
    end;
    QueArt.Close;

    MemD_PrepaArt.SaveToBinaryFile(sFile);
    Lab_PrepaArt.Caption := inttostr(MemD_PrepaArt.RecordCount)+' Modèles: '+
                            ExtractFileName(sFile);

  finally
    QueArt.Close;
    FreeAndNil(QueArt);
    QueTst.Close;
    FreeAndNil(QueTst);
    Cb_OriControle.Refresh;
    Screen.Cursor := crDefault;
    Application.ProcessMessages;
  end;
  result := true;
end;

procedure AjoutLog(AFile: string; ALigne: string);
var
  sLigne: AnsiString;
  Stream: TFileStream;
begin
  sLigne := AnsiString(ALigne);
  Stream := nil;
  try
    if FileExists(AFile) then
    begin
      Stream := TFileStream.Create(AFile, fmOpenWrite);
      Stream.Seek(0, SoFromEnd);
    end
    else
    begin
      Stream := TFileStream.Create(AFile, fmCreate);
    end;
    Stream.Write(sLigne[1],Length(sLigne));
  finally
    if Assigned(Stream) then
    begin
      Stream.Free;
//      Stream := nil;
    end;
  end;
end;

procedure TFrm_Main.ControlerBase;
var
  Delai: DWord;
  LstMrkID: TStringList;
  LstFouID: TStringList;
  LstTgfID: TStringList;
  LstCouID: TStringList;
  bEtatLocal: boolean;
  bToutOk: boolean;
  bFaire: boolean;
  sLogLigne: string;
  iArtID: integer;
  iMrkID: integer;
  iFouID: integer;
  iSsfId: integer;
  iTgfId: integer;
  iCouId: integer;
  //iCbiId: integer;
  //i: integer;
  QueFou: TIBOQuery;
  Quetst: TIBOQuery;
  TempListe: TStringList;
  sFirstLigne: string;
  sProcName: string;
  iNbCB: integer;
  sfile: string;
  dDelai: Word;
  NbArt: integer;
  CntArt: integer;

  procedure AfficheLog(ALigne: string);
  begin
    AjoutLog(sFile, ALigne);
    sLogLigne     := sLogLigne+ALigne;
    Mem_Ctrl.Lines.BeginUpdate;
    Mem_Ctrl.Text := sLogLigne;
    SendMessage(Mem_Ctrl.Handle, WM_VSCROLL, SB_BOTTOM, 0);
    Mem_Ctrl.Lines.EndUpdate;
    Application.ProcessMessages;
  end;

begin
  if not(MemD_PrepaArt.Active) or (MemD_PrepaArt.RecordCount=0) then
    exit;

  sFile := ReperBase+'Rapport '+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt';

  Application.ProcessMessages;
  Screen.Cursor := crHourGlass;
  LstMrkID      := TStringList.Create;
  LstFouID      := TStringList.Create;
  LstTgfID      := TStringList.Create;
  LstCouID      := TStringList.Create;
  TempListe     := TStringList.Create;
  sLogLigne     := '';
  Mem_Ctrl.Clear;
  bToutOk       := true;  // tout est ok
  QueFou        := TIBOQuery.Create(Self);
  QueTst        := TIBOQuery.Create(Self);
  try
    QueFou.IB_Connection  := Dm_Main.DatabaseOri;
    QueFou.IB_Transaction := Dm_Main.Trans_Ori;
    QueTst.IB_Connection  := Dm_Main.DatabaseOri;
    QueTst.IB_Transaction := Dm_Main.Trans_Ori;

    // contrôle du fichier d'article de base + constitution de la liste ID des marques
    NbArt                := MemD_PrepaArt.RecordCount;
    CntArt               := 0;
    Lab_InfoCtrl.Caption := inttostr(CntArt)+' / '+inttostr(NbArt);
    dDelai               := GetTickcount;
    AfficheLog('Contrôle préléminaire: ');
    bEtatLocal           := true;
    if MNCtrlPrelim.Checked then
    begin
      Application.ProcessMessages;
      MemD_PrepaArt.First;
      while not(MemD_PrepaArt.Eof) do
      begin
        inc(CntArt);
        if GetTickCount-dDelai>750 then
        begin
          Lab_InfoCtrl.Caption := inttostr(CntArt)+' / '+inttostr(NbArt);
          dDelai               := GetTickcount;
          Application.ProcessMessages;
        end;
        iArtId := MemD_PrepaArt.FieldByName('ARTID').AsInteger;
        // Ctrl article
        QueTst.Close;
        QueTst.SQL.Clear;
        QueTst.SQL.Add('select ART_NOM, ART_MRKID, ART_SSFID from ARTARTICLE');
        QueTst.SQL.Add(' where ART_ID='+inttostr(iArtId));
        QueTst.Open;
        // S/Famille à zero
        iSsfID := QueTst.FieldByName('ART_SSFID').AsInteger;
        if (iSsfID=0) and (MemD_PrepaArt.FieldByName('VIRTUEL').AsInteger=0) then
        begin
          if bEtatLocal then
            AfficheLog(#13#10);

          AfficheLog('  ART_SSFID à zéro pour le modèle: '+MemD_PrepaArt.FieldByName('CHRONO').AsString+
                     ' (ART_ID='+inttostr(MemD_PrepaArt.FieldByName('ARTID').AsInteger)+')'+#13#10);
          bEtatLocal := false;
        end;
        // nom article
        if QueTst.FieldByName('ART_NOM').AsString='' then
        begin
          if bEtatLocal then
            AfficheLog(#13#10);

          AfficheLog('  ART_NOM vide pour le modèle: '+MemD_PrepaArt.FieldByName('CHRONO').AsString+
                     ' (ART_ID='+inttostr(MemD_PrepaArt.FieldByName('ARTID').AsInteger)+')'+#13#10);
          bEtatLocal := false;
        end;
        // marque
        iMrkID := QueTst.FieldByName('ART_MRKID').AsInteger;
        QueTst.Close;
        if (iMrkID=0) and (MemD_PrepaArt.FieldByName('VIRTUEL').AsInteger=0) then
        begin
          if bEtatLocal then
            AfficheLog(#13#10);

          AfficheLog('  ART_MRKID à zéro pour le modèle: '+MemD_PrepaArt.FieldByName('CHRONO').AsString+
                     ' (ART_ID='+inttostr(MemD_PrepaArt.FieldByName('ARTID').AsInteger)+')'+#13#10);
          bEtatLocal := false;
          Application.ProcessMessages;
        end
        else
        begin
          QueTst.Close;
          QueTst.SQL.Clear;
          QueTst.SQL.Add('select MRK_ID from ARTMARQUE');
          QueTst.SQL.Add('  join k on k_id=mrk_id');
          QueTst.SQL.Add(' where MRK_ID='+inttostr(iMrkId));
          QueTst.Open;
          if QueTst.RecordCount=0 then
          begin
            if bEtatLocal then
              AfficheLog(#13#10);

            AfficheLog('  ART_MRKID='+inttostr(iMrkId)+' n''existe pas pour le modèle: '+MemD_PrepaArt.FieldByName('CHRONO').AsString+
                       ' (ART_ID='+inttostr(MemD_PrepaArt.FieldByName('ARTID').AsInteger)+')'+#13#10);
            bEtatLocal := false;
          end;
          QueTst.Close;

          if LstMrkID.IndexOf(inttostr(iMrkID))<0 then
            LstMrkID.Add(inttostr(iMrkID));
        end;
        MemD_PrepaArt.Next;
      end;

      if bEtatLocal then
        AfficheLog('Ok'+#13#10)
      else
        bToutOk := false;
    end;

    if MnCtrlFourn.Checked then
    begin
      // contrôle fournisseur
      AfficheLog(#13#10+'Contrôle fournisseur: ');
      bEtatLocal := true;
      Application.ProcessMessages;
      QueFou.Close;
      QueFou.SQL.Clear;
      QueFou.SQL.Add('select FOU_ID, fou_nom from artfourn');
      QueFou.SQL.Add('  join k on k_id=fou_id and k_enabled=1');
      QueFou.SQL.Add(' where fou_id<>0');
      QueFou.Open;
      QueFou.First;
      while not(QueFou.Eof) do
      begin
        bFaire := false;
        iFouId := QueFou.Fieldbyname('FOU_ID').AsInteger;

        QueTst.Close;
        QueTst.SQL.Clear;
        QueTst.SQL.Add('select CLG_ARTID from tarclgfourn');
        QueTst.SQL.Add(' where clg_fouid='+inttostr(iFouId)+' and clg_tgfid=0');
        QueTst.Open;
        while not(bFaire) and not(QueTst.Eof) do
        begin
          iArtId   := QueTst.Fieldbyname('CLG_ARTID').AsInteger;
          if MemD_PrepaArt.Locate('ARTID', iArtId, []) then
            bFaire := true;

          QueTst.Next;
        end;
        QueTst.Close;

        if not(bFaire) then
        begin
          QueTst.Close;
          QueTst.SQL.Clear;
          QueTst.SQL.Add('select FMK_MRKID from ARTMRKFOURN');
          QueTst.SQL.Add('  join k on k_id=fmk_id and k_enabled=1');
          QueTst.SQL.Add(' where fmk_fouid='+inttostr(iFouId));
          QueTst.Open;
          while not(bFaire) and not(QueTst.Eof) do
          begin
            iMrkId   := QueTst.FieldByName('FMK_MRKID').AsInteger;
            if LstMrkID.IndexOf(inttostr(iMrkId))>0 then
              bFaire := true;

            QueTst.Next;
          end;
          QueTst.Close;
        end;

        if bFaire then
        begin
          if QueFou.FieldByName('FOU_NOM').AsString='' then
          begin
            if bEtatLocal then
              AfficheLog(#13#10);

            AfficheLog('  FOU_NOM vide pour le fournisseur : '+
                       'FOU_ID='+inttostr(iFouId)+#13#10);
            bEtatLocal := false;
          end;

          LstFouID.Add(inttostr(iFouId));
        end;

        QueFou.Next;
      end;
      if bEtatLocal then
        AfficheLog('Ok'+#13#10)
      else
        bToutOk := false;
    end;

    // contrôle relation Article <--> S/Famille
    if MnCtrlArtSsf.Checked then
    begin
      AfficheLog(#13#10+'Contrôle Article <-->  S/Famille: ');
      bEtatLocal := true;
      MemD_PrepaArt.First;
      while not(MemD_PrepaArt.Eof) do
      begin
        iSsfId  := MemD_PrepaArt.FieldByName('SSFID').AsInteger;
        if (iSsfId<>0) then
        begin
          QueTst.Close;
          QueTst.SQL.Clear;
          QueTst.SQL.Add('select SSF_ID from NKLSSFAMILLE');
          QueTst.SQL.Add('  join k on k_id=ssf_id and k_enabled=1');
          QueTst.SQL.Add(' where SSF_ID='+inttostr(iSsfId));
          QueTst.Open;
          if QueTst.RecordCount=0 then
          begin
            if bEtatLocal then
              AfficheLog(#13#10);

            AfficheLog('  ART_SSFID='+inttostr(iSsfId)+' non trouvé pour le modèle: '+MemD_PrepaArt.FieldByName('CHRONO').AsString+
                       ' (ART_ID='+inttostr(MemD_PrepaArt.FieldByName('ARTID').AsInteger)+')'+#13#10);
            bEtatLocal := false;
          end;
          QueTst.Close;
        end;
        MemD_PrepaArt.Next;
      end;
      if bEtatLocal then
        AfficheLog('Ok'+#13#10)
      else
        bToutOk := false;
    end;

    if MnCtrlCodeBarre.Checked then
    begin
      // Chargement Taille
      AfficheLog(#13#10+'Chargement Taille: ');
//    bEtatLocal := true;
      QueTst.Close;
      QueTst.SQL.Clear;
      QueTst.SQL.Add('select TGF_ID from PLXTAILLESGF');
      QueTst.SQL.Add('  join k on k_id=TGF_ID and k_enabled=1');
      QueTst.SQL.Add('  join PLXGTF on GTF_ID=TGF_GTFID');
      QueTst.SQL.Add(' where tgf_id<>0');
      QueTst.Open;
      QueTst.First;
      while not(QueTst.Eof) do
      begin
        LstTgfID.Add(inttostr(QueTst.FieldByName('TGF_ID').AsInteger));
        QueTst.Next;
      end;
      QueTst.Close;
      AfficheLog('Ok'+#13#10);

      // Chargement Couleur
      AfficheLog(#13#10+'Chargement Couleur: ');
//    bEtatLocal := true;
      QueTst.Close;
      QueTst.SQL.Clear;
      QueTst.SQL.Add('select COU_ID, COU_ARTID from plxcouleur');
      QueTst.SQL.Add('  join k on k_id=cou_id and k_enabled=1');
      QueTst.SQL.Add(' where cou_id<>0');
      QueTst.Open;
      QueTst.First;
      while not(QueTst.Eof) do
      begin
        iArtId := QueTst.Fieldbyname('COU_ARTID').AsInteger;
        if MemD_PrepaArt.Locate('ARTID', iArtId, []) then
          LstCouID.Add(inttostr(QueTst.FieldByName('COU_ID').AsInteger));

        QueTst.Next;
      end;
      QueTst.Close;
      AfficheLog('Ok'+#13#10);

      // contrôle Code barre
      AfficheLog(#13#10+'Contrôle Code barre: ');
      bEtatLocal := true;
      MemD_PrepaArt.First;
      while not(MemD_PrepaArt.Eof) do
      begin
        if MemD_PrepaArt.FieldByName('VIRTUEL').AsInteger=0 then
        begin
          QueTst.Close;
          QueTst.SQL.Clear;
          QueTst.SQL.Add('select cbi_id, cbi_tgfid, cbi_couid from ARTCODEBARRE');
          QueTst.SQL.Add('  join k on k_id=cbi_id and k_enabled=1');
          QueTst.SQL.Add(' where cbi_id<>0 and (cbi_type=1 or cbi_type=3)');
          QueTst.SQL.Add('   and cbi_arfid='+inttostr(MemD_PrepaArt.fieldbyname('ARFID').AsInteger));
          QueTst.Open;
          QueTst.First;
          while not(QueTst.Eof) do
          begin
            iTgfId := QueTst.fieldbyname('cbi_tgfid').AsInteger;
            iCouId := QueTst.fieldbyname('cbi_couid').AsInteger;

            // test taille
            if iTgfId=0 then
            begin
              if bEtatLocal then
                AfficheLog(#13#10);

              AfficheLog('  CBI_TGFID à zéro pour le code barre: '+QueTst.FieldByName('CBI_ID').AsString+
                         ' (ART_ID='+inttostr(MemD_PrepaArt.FieldByName('ARTID').AsInteger)+')'+#13#10);
              bEtatLocal := false;
            end
            else
            begin
              if LstTgfID.IndexOf(inttostr(iTgfId))<0 then
              begin
                if bEtatLocal then
                  AfficheLog(#13#10);

                AfficheLog('  CBI_TGFID='+inttostr(iTgfId)+' non trouvé pour l''ID code barre: '+QueTst.FieldByName('CBI_ID').AsString+
                           ' (ART_ID='+inttostr(MemD_PrepaArt.FieldByName('ARTID').AsInteger)+')'+#13#10);
                bEtatLocal := false;
              end;
            end;

            // test couleur
            if iCouId=0 then
            begin
              if bEtatLocal then
                AfficheLog(#13#10);

              AfficheLog('  CBI_COUID à zéro pour le code barre: '+QueTst.FieldByName('CBI_ID').AsString+
                         ' (ART_ID='+inttostr(MemD_PrepaArt.FieldByName('ARTID').AsInteger)+')'+#13#10);
              bEtatLocal := false;
            end
            else
            begin
              if LstCouID.IndexOf(inttostr(iCouId))<0 then
              begin
                if bEtatLocal then
                  AfficheLog(#13#10);

                AfficheLog('  CBI_COUID='+inttostr(iCouId)+' non trouvé pour l''ID code barre: '+QueTst.FieldByName('CBI_ID').AsString+
                           ' (ART_ID='+inttostr(MemD_PrepaArt.FieldByName('ARTID').AsInteger)+')'+#13#10);
                bEtatLocal := false;
              end;
            end;

            QueTst.Next;
          end;
        end;
        MemD_PrepaArt.Next;
      end;
      if bEtatLocal then
        AfficheLog('Ok'+#13#10)
      else
        bToutOk := false;
    end;

    // contrôle Code barre <-->Article
    // CreateTion procedure Stockée
    sProcName := 'TMP_CTRL_CODEBARRE';
    TempListe.Clear;
    TempListe.Text := Dm_Main.Que_PrcCB.SQL.Text;
    // test existance procedure stocké et change eventuellement en alter
    if (sProcName<>'') and Dm_Main.IsProcedureExists(sProcName) then
    begin
      sFirstLigne := UpperCase(TempListe[0]);
      sFirstLigne := 'ALTER '+Trim(Copy(sFirstLigne, 7, Length(sFirstLigne)));
      TempListe.Insert(0, sFirstLigne);
      TempListe.Delete(1);
    end;
    Dm_Main.PassageScript(TempListe.Text);
    if (sProcName<>'') then
      Dm_Main.GrantProcedure(sProcName, true);
    if (sProcName<>'') then
      Dm_Main.GrantProcedure(sProcName, false);

    AfficheLog(#13#10+'Contrôle Existance Article <--> Code barre: ');
    bEtatLocal := true;
    iNbCB := 0;
    Delai := GetTickCount;
    Application.ProcessMessages;
    try
      Dm_Main.Trans_Ori.StartTransaction;
      try
        MemD_PrepaArt.First;
        while not(MemD_PrepaArt.Eof) do
        begin
          if MemD_PrepaArt.FieldByName('VIRTUEL').AsInteger=0 then
          begin
            QueTst.Close;
            QueTst.SQL.Clear;
            QueTst.SQL.Add('select * from TMP_CTRL_CODEBARRE('+inttostr(MemD_PrepaArt.FieldByName('ARTID').AsInteger)+
                                                           ','+inttostr(MemD_PrepaArt.FieldByName('ARFID').AsInteger)+')');
            QueTst.Open;
            while not(QueTst.Eof) do
            begin
              if bEtatLocal then
                AfficheLog(#13#10);

                AfficheLog('execute procedure MG10_CREECODEBARRE('+
                      inttostr(MemD_PrepaArt.FieldByName('ARTID').AsInteger)+', '+
                      inttostr(MemD_PrepaArt.FieldByName('ARFID').AsInteger)+', '+
                      inttostr(QueTst.FieldByName('TGFID').AsInteger)+', '+
                      inttostr(QueTst.FieldByName('COUID').AsInteger)+');'+#13#10);
//
//              AfficheLog('ART_ID = '+inttostr(MemD_PrepaArt.FieldByName('ARTID').AsInteger)+', '+
//                         'TGF_ID = '+inttostr(QueTst.FieldByName('TGFID').AsInteger)+', '+
//                         'COU_ID = '+inttostr(QueTst.FieldByName('COUID').AsInteger)+' --> '+
//                         'CB = '+QueTst.FieldByName('CB').AsString+#13#10);
              bEtatLocal := false;
              inc(iNbCB);

              QueTst.Next;
            end;
          end;
          MemD_PrepaArt.Next;
          if (GetTickCount-Delai)>3000 then
          begin
            Application.ProcessMessages;
            Delai := GetTickCount;
          end;
        end;
        Dm_Main.Trans_Ori.Commit;
      except
        Dm_Main.Trans_Ori.RollBack;
        raise;
      end;
    finally
      if (sProcName<>'') and Dm_Main.IsProcedureExists(sProcName) then
        Dm_Main.PassageScript('DROP PROCEDURE '+sProcName);
    end;

    if bEtatLocal then
      AfficheLog('Ok'+#13#10)
    else
    begin
      AfficheLog(inttostr(iNbCb)+' Code barre ont été créés');
    end;
    Application.ProcessMessages;

    // maj de l'affichage du contrôle
    if bToutOk then
    begin
      Ctrl_OriCtrl.Caption := 'Contrôle: Ok';
      Ctrl_OriCtrl.Color   := rgb(192, 240, 192);
      LstImg_Etat64.Draw(Img_OriVersion.Canvas, 0, 0, 1);
      if Mem_Ori.Locate('Numero', PC_ORI_CONTROLE, []) then
      begin
        Mem_Ori.Edit;
        Mem_Ori.FieldByName('Etat').AsInteger := 1;
        Mem_Ori.Post;
      end;
    end
    else
    begin
      Ctrl_OriCtrl.Caption := 'Contrôle: Erreur';
      Ctrl_OriCtrl.Color   := rgb(240, 192, 192);
      LstImg_Etat64.Draw(Img_OriVersion.Canvas, 0, 0, 0);
      if Mem_Ori.Locate('Numero', PC_ORI_CONTROLE, []) then
      begin
        Mem_Ori.Edit;
        Mem_Ori.FieldByName('Etat').AsInteger := 2;
        Mem_Ori.Post;
      end;
    end;
  finally
    QueFou.Close;
    FreeAndNil(QueFou);
    QueTst.Close;
    FreeAndNil(QueTst);
    FreeAndNil(LstMrkID);
    FreeAndNil(LstFouID);
    FreeAndNil(LstTgfID);
    FreeAndNil(LstCouID);
    FreeAndNil(TempListe);
    Cb_OriControle.Refresh;
    Screen.Cursor := crDefault;
    Application.ProcessMessages;
  end;
end;

procedure TFrm_Main.Nbt_PreparerClick(Sender: TObject);
begin
  PreparerArt;
end;

procedure TFrm_Main.Nbt_PreparerCtrlClick(Sender: TObject);
begin
  if PreparerArt then
    ControlerBase;
end;

procedure TFrm_Main.TerminateThreadRecalculStk(Sender: TObject);
begin
  Frm_MajStk.OkFermer := true;
  Enabled             := True;
  Frm_MajStk.Hide;
  FreeAndNil(Frm_MajStk);
  Application.ProcessMessages;
  Application.CreateForm(TFrm_MajStk, Frm_MajStk);
  Application.ProcessMessages;
  DoOriCtrlStock;
  Cb_OriControle.Refresh;
  Application.ProcessMessages;
  Screen.Cursor := crDefault;
  if TThreadRecalculStk(Sender).sError = '' then
    MessageDlg('Recalcul stock réalisé avec succès !', mtInformation, [mbok], 0)
  else
    MessageDlg(TThreadRecalculStk(Sender).sError, mtError, [mbok], 0);
end;

//function TFrm_Main.RechercheID(AListe: TStrings; ACode: string; const ACount: integer = -1): integer;
//begin
//end;

//function TFrm_Main.AjoutInListeID(AListe: TStrings; ACode: string; AChamps: array of string): integer;
//begin
//end;

//function TFrm_Main.AjoutInListeID(AListe: TStrings; ACode: string; AChamps: string): integer;
//var
//  AArray: Array [0..0] of String;
//begin
//  AArray[0] := AChamps;
//  Result := AjoutInListeID(Aliste, ACode, AArray);
//end;

procedure TFrm_Main.Nbt_RecalStockClick(Sender: TObject);
var
  ThreadRecalculStk: TThreadRecalculStk;
begin
  ThreadRecalculStk             := TThreadRecalculStk.Create;
  ThreadRecalculStk.OnTerminate := TerminateThreadRecalculStk;
  Frm_MajStk.DoInit;
  Frm_MajStk.Show;
  Frm_MajStk.OkFermer := false;
  Enabled             := False;
  Screen.Cursor       := crHourGlass;
  Application.ProcessMessages;
  ThreadRecalculStk.Start;
end;

procedure TFrm_Main.Pan_TopResize(Sender: TObject);
begin
  Pan_Origine.Width := (Pan_Top.Width div 2) - 1;
  PanGauche.Width   := (Pan_Top.Width div 2) - 1;
end;

end.

