unit Main_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, rxToolEdit, RzPanel, ExtCtrls, dblookup, dxCntner,
  dxTL, dxDBCtrl, dxDBGrid, dxDBGridHP, IB_Components, Boxes, PanBtnDbgHP,
  dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev,
  dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns, dxDBTLCl, dxGrClms, DB,
  dxmdaset, dxPSCore, dxPSdxTLLnk, dxPSdxDBCtrlLnk, dxPSdxDBGrLnk,
  dxComponentPrinterHP, IBODataset, wwDialog, wwidlg, wwLookupDialogRv,
  wwdblook, wwDBLookupComboRv, Grids, DBGrids, Menus, Math;

type
  TForm1 = class(TForm)
    Pan_Top: TPanel;
    Pan_TopChrono: TPanel;
    Gbx_Chrono: TRzGroupBox;
    Pan_TopBase: TPanel;
    Gbx_Base: TRzGroupBox;
    Pan_ClientBase: TPanel;
    Gbx_Grid: TRzGroupBox;
    fe_base: TFilenameEdit;
    edt_Chrono: TEdit;
    Pan_Grid: TPanel;
    DBG_Base: TdxDBGridHP;
    IbC_base: TIB_Connection;
    Pan_basebottom: TPanel;
    Pan_cmz: TPanelDbg;
    dxPrt_Base: TdxComponentPrinterHP;
    dxPrt_BaseLink1: TdxDBGridReportLink;
    Ds_Base: TDataSource;
    MemD_Base: TdxMemData;
    MemD_BaseDate: TDateField;
    MemD_BaseStk_BeforeMvt: TIntegerField;
    MemD_BasePmp_BeforeMvt: TFloatField;
    MemD_BaseQte_Entree: TIntegerField;
    MemD_BaseVal_unitaire: TFloatField;
    MemD_BaseStk_Final: TIntegerField;
    MemD_BasePmp_final: TFloatField;
    DBG_BaseRecId: TdxDBGridColumn;
    DBG_BaseDate: TdxDBGridDateColumn;
    DBG_BaseStk_BeforeMvt: TdxDBGridMaskColumn;
    DBG_BasePmp_BeforeMvt: TdxDBGridMaskColumn;
    DBG_BaseQte_Entree: TdxDBGridMaskColumn;
    DBG_BaseVal_unitaire: TdxDBGridMaskColumn;
    DBG_BaseStk_Final: TdxDBGridMaskColumn;
    DBG_BasePmp_final: TdxDBGridMaskColumn;
    Que_TailleList: TIBOQuery;
    Que_PumpList: TIBOQuery;
    Ds_test: TDataSource;
    DBGrid1: TDBGrid;
    Memo1: TMemo;
    MainMenu1: TMainMenu;
    HideShow1: TMenuItem;
    Que_CouleurList: TIBOQuery;
    DBLk_GRPPUMP: TwwDBLookupComboRv;
    DBLk_Couleur: TwwDBLookupComboRv;
    DBLk_Taille: TwwDBLookupComboRv;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    Que_GRPPUMP: TIBOQuery;
    lbl4: TLabel;
    lbl5: TLabel;
    Que_GRPPUMPGCP_ID: TIntegerField;
    Que_GRPPUMPGCP_NOM: TStringField;
    MemD_BaseENTTYPE: TStringField;
    DBG_BaseENTTYPE: TdxDBGridColumn;
    procedure fe_baseAfterDialog(Sender: TObject; var Name: string;
      var Action: Boolean);
    procedure edt_ChronoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBLk_TailleCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure HideShow1Click(Sender: TObject);
    procedure IbC_baseAfterConnect(Sender: TIB_Connection);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.DBLk_TailleCloseUp(Sender: TObject; LookupTable,
  FillTable: TDataSet; modified: Boolean);
var
  OldQte : integer;
  OldPump : single;
begin
  if (DBLk_Couleur.Value<>'') and (DBLk_Taille.Value='') then
  begin
    DBLK_Taille.SetFocus;
    exit;
  end;

  if (DBLk_Couleur.Value='') and (DBLk_Taille.Value<>'') then
  begin
    DBLk_Couleur.SetFocus;
    exit;
  end;

  if (Que_TailleList.FieldByName('ARF_ARTID').AsInteger<=0) or
     (Que_TailleList.FieldByName('TGF_ID').AsInteger<=0) or
     (Que_CouleurList.FieldByName('COU_ID').AsInteger<=0) or
     (Que_CouleurList.FieldByName('COU_ID').AsInteger<=0) or
     (Que_GRPPUMP.FieldByName('GCP_ID').AsInteger<=0)
     then
  exit;

  with Que_PumpList do
  begin
    Close;
    SQL.Text := Memo1.Text;
    ParamCheck := True;
    ParamByName('PARTID1').AsInteger  := Que_TailleList.FieldByName('ARF_ARTID').AsInteger;
    ParamByName('PTGFID1').AsInteger  := Que_TailleList.FieldByName('TGF_ID').AsInteger;
    ParamByName('PCOUID1').AsInteger  := Que_CouleurList.FieldByName('COU_ID').AsInteger;
    ParamByName('PGCPID1').Asinteger  := Que_GRPPUMP.FieldByName('GCP_ID').AsInteger;

    ParamByName('PARTID2').AsInteger  := Que_TailleList.FieldByName('ARF_ARTID').AsInteger;
    ParamByName('PTGFID2').AsInteger  := Que_TailleList.FieldByName('TGF_ID').AsInteger;
    ParamByName('PCOUID2').AsInteger  := Que_CouleurList.FieldByName('COU_ID').AsInteger;
    ParamByName('PGCPID2').Asinteger  := Que_GRPPUMP.FieldByName('GCP_ID').AsInteger;
    Open;

    OldQte := 0;
    OldPump := 0;
    MemD_Base.Close;
    MemD_Base.Open;
    while not EOF do
    begin
      if Floor(FieldByName('MDATE').AsDateTime) = Floor(FieldByName('HST_DATE').AsDateTime) then
      begin
        MemD_Base.Append;
        MemD_Base.FieldByName('ENTTYPE').AsString        := Fields[0].AsString;
        MemD_Base.FieldByName('Date').AsDateTime         := FieldByName('MDATE').AsDateTime;
        MemD_Base.FieldByName('Stk_BeforeMvt').AsInteger := OldQte;
        MemD_Base.FieldByName('Pmp_BeforeMvt').AsFloat   := OldPump;
        MemD_Base.FieldByName('Qte_Entree').AsInteger    := FieldByName('QTE').AsInteger;
        MemD_Base.FieldByName('Val_unitaire').AsFloat    := FieldByName('PXNN').AsFloat;
        MemD_Base.FieldByName('Stk_Final').AsInteger     := FieldByName('HST_QTE').AsInteger;
        MemD_Base.FieldByName('Pmp_final').AsFloat       := FieldByName('HST_PUMP').AsFloat;
        MemD_Base.Post;
      end;
      OldQte  := FieldByName('HST_QTE').AsInteger;
      OldPump := FieldByName('HST_PUMP').AsFloat;
      
      Next;
    end;
    // Mise au début du memdata
    MemD_Base.First;
    // mise au dénut de la requete
    First;
  end;
end;

procedure TForm1.edt_ChronoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    (VK_RETURN): begin
      if IbC_base.Connected then
      begin

        Que_TailleList.Close;
        Que_TailleList.ParamByName('PARTCHRONO').AsString := edt_Chrono.Text;
        Que_TailleList.Open;

        Que_CouleurList.Close;
        Que_CouleurList.ParamByName('PARTCHRONO').AsString := edt_Chrono.Text;
        Que_CouleurList.Open;


        if ((Que_TailleList.IsEmpty) or (Que_CouleurList.IsEmpty)) then
          begin
            ShowMessage('Chrono inéxistant ou aucune taille/couleur trouvées');
            DBLk_Taille.Enabled  := False;
            DBLk_Couleur.Enabled := True;
          end
        else begin
            DBLk_Taille.Enabled  := True;
            DBLk_Couleur.Enabled := True;
            DBLk_Taille.SetFocus;
          end;
      end else
        ShowMessage('Veuillez vous connecter à une base de données');
    end;
    else begin
      DBLk_Taille.Text := '';
      Que_TailleList.Close;
      DBLk_Couleur.Text := '';
      Que_CouleurList.Close;
    end;
  end;

end;

procedure TForm1.fe_baseAfterDialog(Sender: TObject; var Name: string;
  var Action: Boolean);
begin
  if Action then
  begin
    With IbC_base do
    try
      Disconnect;
      DatabaseName := TFilenameEdit(Sender).Dialog.FileName;
      Connect;
    Except on E:Exception do
      begin
        ShowMessage('Erreur de connexion à la base de données : ' + E.Message);
      end;
    end;
  end;
end;

procedure TForm1.HideShow1Click(Sender: TObject);
begin
  DBGrid1.Visible := not DBGrid1.Visible;
  Memo1.Visible := not Memo1.Visible;
end;

procedure TForm1.IbC_baseAfterConnect(Sender: TIB_Connection);
begin
     Que_GRPPUMP.active:=true;
     DBLk_GRPPUMP.Enabled:=true;
end;

end.
