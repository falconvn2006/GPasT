unit Analyse_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, RzPanel, DB, Grids, DBGrids, dxmdaset, ComCtrls, ImgList,
  Menus;

type
  TFrm_AnalyseSession = class(TForm)
    Pan_Haut: TRzPanel;
    Label1: TLabel;
    Edt_Num: TEdit;
    Label2: TLabel;
    Edt_ID: TEdit;
    Label3: TLabel;
    Edt_Ecart: TEdit;
    Nbt_Quit: TBitBtn;
    MemD_Ticket: TdxMemData;
    MemD_TicketTKE_ID: TIntegerField;
    MemD_TicketNUMTICK: TIntegerField;
    MemD_TicketENTMNT: TFloatField;
    MemD_TicketENTQTE: TIntegerField;
    Ds_Ticket: TDataSource;
    MemD_TicketARTQTE: TIntegerField;
    MemD_TicketARTMNT: TFloatField;
    MemD_TicketERREUR: TStringField;
    MemD_TicketCSHMNT: TFloatField;
    MemD_TicketDIFFENTART: TFloatField;
    MemD_TicketDIFFENTCSH: TFloatField;
    MemD_TicketDIFFARTCSH: TFloatField;
    Nbt_Refresh: TBitBtn;
    Label4: TLabel;
    Edt_Fic: TEdit;
    Nbt_Voir: TBitBtn;
    Label5: TLabel;
    Edt_TotEnt: TEdit;
    Label6: TLabel;
    Edt_TotLigArt: TEdit;
    Label7: TLabel;
    Edt_BonAch: TEdit;
    Label8: TLabel;
    Edt_TotArt: TEdit;
    Label9: TLabel;
    Edt_TotCsh: TEdit;
    MemD_TicketBONACH: TFloatField;
    Ds_SyntEncais: TDataSource;
    Ds_SyntCli: TDataSource;
    Ds_FndCais: TDataSource;
    MemD_TicketENTLOC: TFloatField;
    Pan_Client: TRzPanel;
    iob: TDBGrid;
    Pan_Bas: TPanel;
    Pgc_Page1: TPageControl;
    Tb_SyntCais: TTabSheet;
    DBGrid1: TDBGrid;
    Tab_CpteCli: TTabSheet;
    DBGrid2: TDBGrid;
    Tab_FndCais: TTabSheet;
    DBGrid3: TDBGrid;
    splSplitter1: TSplitter;
    pnlSynEncTot: TPanel;
    Label30: TLabel;
    Edt_TotLigCsh: TEdit;
    Label31: TLabel;
    Edt_TotCli: TEdit;
    Label29: TLabel;
    Edt_CptCli: TEdit;
    Label23: TLabel;
    Edt_CshTot: TEdit;
    splSplitter2: TSplitter;
    pnlSyntCptCliTot: TPanel;
    Label34: TLabel;
    Edt_Cli123: TEdit;
    Label35: TLabel;
    Edt_Cli4: TEdit;
    Label36: TLabel;
    Edt_Cli6: TEdit;
    Label10: TLabel;
    Edt_TotSyntCli: TEdit;
    splSplitter3: TSplitter;
    splSplitter4: TSplitter;
    pnlSyntFndCaiTot: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label14: TLabel;
    Edt_TotFndCais: TEdit;
    Edt_TotCli2: TEdit;
    Edt_CptCli2: TEdit;
    Edt_BonAch2: TEdit;
    Edt_FndTot: TEdit;
    Nbt_LigFndCais: TBitBtn;
    edtSortieCaisse: TEdit;
    lblSortieCaisse: TLabel;
    btnGLobalAction: TBitBtn;
    pmGlobalAction: TPopupMenu;
    CorrectionerreurdeventilationPxNN0opration3pour21: TMenuItem;
    CorrectionMENIDzro1: TMenuItem;
    CorrectiondesproblmesdeBAgnrantdespseudoremises1: TMenuItem;
    Label16: TLabel;
    Edt_SpeCASH: TEdit;
    edtSortieCaisseCASH: TEdit;
    Label17: TLabel;

    Separateur1: TMenuItem;
    Correctionduticketavecremisefidlitsansbon1: TMenuItem;
    procedure iobDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure MemD_TicketCalcFields(DataSet: TDataSet);
    procedure Nbt_RefreshClick(Sender: TObject);
    procedure Nbt_VoirClick(Sender: TObject);
    procedure iobDblClick(Sender: TObject);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure Nbt_LigFndCaisClick(Sender: TObject);
    procedure iobTitleClick(Column: TColumn);
    procedure DBGridTitleClick(Column: TColumn);
    procedure iobKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnGLobalActionClick(Sender: TObject);
    procedure CorrectionerreurdeventilationPxNN0opration3pour21Click(
      Sender: TObject);
    procedure CorrectionMENIDzro1Click(Sender: TObject);
    procedure CorrectiondesproblmesdeBAgnrantdespseudoremises1Click(
      Sender: TObject);
    procedure Correctionduticketavecremisefidlitsansbon1Click(Sender: TObject);
  private
    { Déclarations privées }
    SesNum: string;
    SesID: integer;
    vSyntCsh: Double;
    vSyntCli: double;
    vSyntSoDiv : Double;
    vSyntSoDivCASH : Double;
    vCptCli: double;
    vCptCli123: double;
    vCptCli4: double;
    vCptCli6: double;
    vSyntTot: double;
    TotGenAch: double;
    TotGenLoc: double;
    vSyntFndCais: double;
    vSyntTotFndCais: double;
    procedure UpdateCouleur;
    procedure UpdateRec(ATKE_ID: integer; DoMajEntete : boolean);
    procedure Synthese;
    function Analyse: boolean;
    procedure WMSysCommand(var Msg: TWMSyscommand); message WM_SYSCOMMAND;
  public
    { Déclarations publiques }
    function InitEcr(ANomReq: string; ASesNum: string):boolean;
  end;

implementation

uses
  Main_Dm,
  Progression_Frm,
  FichierRequete_Frm,
  Ticket_Frm,
  FndDeCaisse_Frm,
  IBODataset,
  ClipBrd,
  StdEnums;

{$R *.dfm}

procedure TFrm_AnalyseSession.UpdateCouleur;
var
  TotEnt, TotCsh, TotArt, CshTot, FndTot, SorDiv, SorDivCash, SpeCash : Double;
begin
  TotEnt := StrToFloatDef(StringReplace(Edt_TotEnt.Text, FormatSettings.ThousandSeparator, '', [rfReplaceAll, rfIgnoreCase]), -50);
  TotCsh := StrToFloatDef(StringReplace(Edt_TotCsh.Text, FormatSettings.ThousandSeparator, '', [rfReplaceAll, rfIgnoreCase]), 12);
  TotArt := StrToFloatDef(StringReplace(Edt_TotArt.Text, FormatSettings.ThousandSeparator, '', [rfReplaceAll, rfIgnoreCase]), 34);
  CshTot := StrToFloatDef(StringReplace(Edt_CshTot.Text, FormatSettings.ThousandSeparator, '', [rfReplaceAll, rfIgnoreCase]), 128);
//  CshTot := StrToFloatDef(StringReplace(Edt_TotLigCsh.Text, FormatSettings.ThousandSeparator, '', [rfReplaceAll, rfIgnoreCase]), 128);
  FndTot := StrToFloatDef(StringReplace(Edt_FndTot.Text, FormatSettings.ThousandSeparator, '', [rfReplaceAll, rfIgnoreCase]), 9);
  SorDiv := StrToFloatDef(StringReplace(edtSortieCaisse.Text, FormatSettings.ThousandSeparator, '', [rfReplaceAll, rfIgnoreCase]), -87);
  SorDivCASH := StrToFloatDef(StringReplace(edtSortieCaisseCASH.Text, FormatSettings.ThousandSeparator, '', [rfReplaceAll, rfIgnoreCase]), -87);
  SpeCash := StrToFloatDef(StringReplace(Edt_SpeCASH.Text, FormatSettings.ThousandSeparator, '', [rfReplaceAll, rfIgnoreCase]), -87);

  if (ArrondiA2(TotEnt + SpeCash) <> TotCsh) or
     (ArrondiA2(TotEnt) <> TotArt) or
     (ArrondiA2(TotEnt + SpeCash) <> CshTot) or
     (ArrondiA2(TotEnt + SorDiv + SpeCash) <> FndTot) or
     (ArrondiA2(TotCsh - SpeCash) <> TotArt) or
     (ArrondiA2(TotCsh) <> CshTot) or
     (ArrondiA2(TotCsh + SorDiv) <> FndTot) or
     (ArrondiA2(TotArt + SpeCash) <> CshTot) or
     (ArrondiA2(TotArt + SorDiv + SpeCash) <> FndTot) or
     (ArrondiA2(CshTot + SorDiv) <> FndTot) then
  begin
    Edt_TotEnt.Color := clRed;
    Edt_TotCsh.Color := clRed;
    Edt_TotArt.Color := clRed;
    Edt_CshTot.Color := clRed;
    Edt_FndTot.Color := clRed;
  end
  else
  begin
    Edt_TotEnt.Color := clSkyBlue;
    Edt_TotCsh.Color := clSkyBlue;
    Edt_TotArt.Color := clSkyBlue;
    Edt_CshTot.Color := clSkyBlue;
    Edt_FndTot.Color := clSkyBlue;
  end;

  if SorDiv <> 0 then
    edtSortieCaisse.Color := clYellow;
  if SorDivCASH <> 0 then
    edtSortieCaisseCASH.Color := clYellow;
end;

procedure TFrm_AnalyseSession.iobDblClick(Sender: TObject);
var
  Frm_Ticket : TFrm_Ticket;
  TpListe: TStringList;
  i: integer;
begin
  if not(MemD_Ticket.Active) or (MemD_Ticket.RecordCount=0) then
    exit;

  Frm_Ticket := TFrm_Ticket.Create(Self);
  try
    Frm_Ticket.InitEcr(SesNum, SesID, Edt_Ecart.Text, MemD_Ticket.fieldbyname('TKE_ID').AsInteger);
    if (Frm_Ticket.ShowModal=mrok) and (Frm_Ticket.LstScript.Count>0) then
    begin
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      TpListe := TStringList.Create;
      try                               
        if FileExists(ReperBase+Edt_Fic.Text) then
          TpListe.LoadFromFile(ReperBase+Edt_Fic.Text);

        TpListe.AddStrings(Frm_Ticket.LstScript);

        TpListe.SaveToFile(ReperBase+Edt_Fic.Text);

        with Dm_Main do
        begin
          Ginkoia.StartTransaction;
          try
            for i := 1 to Frm_Ticket.LstReq.Count do
              Ginkoia.ExecSQL(Frm_Ticket.LstReq[i-1]);
            Ginkoia.Commit;
          except
            on E:Exception do
            begin  
              Ginkoia.Rollback;
              MessageDlg(E.Message,mterror,[mbok],0);
            end;
          end;
        end;   

        UpdateRec(MemD_Ticket.fieldbyname('TKE_ID').AsInteger, true);
        Nbt_Refresh.Font.Style := [fsBold];
      finally
        TpListe.Free;
        TpListe := nil;
        Screen.Cursor := crDefault;
        Application.ProcessMessages;
      end;
    end;
  finally
    FreeAndNil(Frm_Ticket);
  end;
end;

procedure TFrm_AnalyseSession.iobDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
var
  chFont, savFont: TColor;
  chBrush, savBrush: TColor;
  sErreur: string;
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
      if (MemD_Ticket.Active) and (MemD_Ticket.RecordCount>0)
            and (MemD_Ticket.fieldbyname('ERREUR').AsString<>'') then
      begin
        sErreur := MemD_Ticket.fieldbyname('ERREUR').AsString;
        if (Pos('ANNULATION TICKET',UpperCase(sErreur))=1) then
        begin
          if (Column.FieldName='ERREUR') and (Pos(';',sErreur)>0) then
            ChBrush := rgb(153,0,0)
          else
            ChBrush := rgb(153,153,0);
        end
        else if (Pos('DéPENSE (MOTIF', UpperCase(sErreur))=1) or (Pos('APPORT (MOTIF', UpperCase(sErreur))=1) or (Pos('PRéLèVEMENT (MOTIF', UpperCase(sErreur))=1) then
        begin
          if (Column.FieldName='ERREUR') and (Pos(';',sErreur)>0) then
            ChBrush := rgb(153,0,0)
          else
            ChBrush := rgb(153,153,0);
        end
        else
          ChBrush := rgb(153,0,0);
      end;
      if (MemD_Ticket.Active) and (MemD_Ticket.RecordCount>0)
        and ((Column.FieldName='ENTQTE') or (Column.FieldName='ARTQTE'))
            and (MemD_Ticket.fieldbyname('ENTQTE').AsInteger<>MemD_Ticket.fieldbyname('ARTQTE').AsInteger) then
        ChBrush := rgb(0,153,202);
    end
    else
    begin
      ChFont := clBlack;
      ChBrush := rgb(202,255,202);
      if (MemD_Ticket.Active) and (MemD_Ticket.RecordCount>0)
            and (MemD_Ticket.fieldbyname('ERREUR').AsString<>'') then
      begin
        sErreur := MemD_Ticket.fieldbyname('ERREUR').AsString;
        if (Pos('ANNULATION TICKET',UpperCase(sErreur))=1) then
        begin
          if (Column.FieldName='ERREUR') and (Pos(';',sErreur)>0) then
            ChBrush := rgb(255,202,202)
          else
            ChBrush := rgb(255,255,202);
        end
        else if (Pos('DéPENSE (MOTIF', UpperCase(sErreur))=1) or (Pos('APPORT (MOTIF', UpperCase(sErreur))=1) or (Pos('PRéLèVEMENT (MOTIF', UpperCase(sErreur))=1) then
        begin
          if (Column.FieldName='ERREUR') and (Pos(';',sErreur)>0) then
            ChBrush := rgb(255,202,202)
          else
            ChBrush := rgb(255,255,202);
        end
        else
          ChBrush := rgb(255,202,202);
      end;
      if (MemD_Ticket.Active) and (MemD_Ticket.RecordCount>0)
        and ((Column.FieldName='ENTQTE') or (Column.FieldName='ARTQTE'))
            and (MemD_Ticket.fieldbyname('ENTQTE').AsInteger<>MemD_Ticket.fieldbyname('ARTQTE').AsInteger) then
        ChBrush := rgb(153,202,255);
    end;

    Font.Color := chFont;
    Brush.Color := chBrush;
    TDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State); 
    Font.Color := savFont;
    Brush.Color := savBrush;

  end;
end;

procedure TFrm_AnalyseSession.iobKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('C')) and (Shift = [ssCtrl]) then
    ClipBoard.AsText := iob.SelectedField.AsString;
end;

procedure TFrm_AnalyseSession.iobTitleClick(Column: TColumn);
begin
  if MemD_Ticket.SortedField = Column.FieldName then
  begin
    if soDesc in MemD_Ticket.SortOptions then
      MemD_Ticket.SortOptions := [soCaseInsensitive]
    else
      MemD_Ticket.SortOptions := [soDesc, soCaseInsensitive];
  end
  else
  begin
    MemD_Ticket.SortOptions := [soCaseInsensitive];
    MemD_Ticket.SortedField := Column.FieldName;
  end;
end;

procedure TFrm_AnalyseSession.Synthese;
begin
  with Dm_Main do
  begin
    // synthèse des comptes clients
    vCptCli := 0.0;
    vCptCli123 := 0.0;
    vCptCli4 := 0.0;
    vCptCli6 := 0.0;
    with Que_SyntCli do
    begin
      DisableControls;
      try
        Active:=false;
        ParamByName('SESID').AsInteger := SesID;
        Active:=true;
        First;
        while not(Eof) do
        begin
          if (fieldbyname('cte_typ').AsInteger in [1..3]) then
            vCptCli123 := vCptCli123 + fieldbyname('TOT').AsFloat;
          if (fieldbyname('cte_typ').AsInteger=4) then
            vCptCli4 := vCptCli4 + fieldbyname('TOT').AsFloat;
          if (fieldbyname('cte_typ').AsInteger=6) then
            vCptCli6 := vCptCli6 + fieldbyname('TOT').AsFloat;
          vCptCli := vCptCli + fieldbyname('TOT').AsFloat;
          Next;
        end;
      finally
        First;
        EnableControls;
      end;
    end;
    Edt_Cli123.Text := FormatFloat('#,##0.00', vCptCli123);
    Edt_Cli4.Text := FormatFloat('#,##0.00', vCptCli4);
    Edt_Cli6.Text := FormatFloat('#,##0.00', vCptCli6);
    Edt_TotSyntCli.Text := FormatFloat('#,##0.00', vCptCli);

    // synthèse des encaissements
    vSyntCsh := 0.0;
    vSyntCli := 0.0;
    vSyntSoDiv := 0.0;
    vSyntSoDivCASH := 0.0;
    with Que_SyntEncais do
    begin
      DisableControls;
      try
        Active:=false;
        ParamByName('SESID').AsInteger := SesID;
        Active:=true;
        First;
        while not(Eof) do
        begin
          if (fieldbyname('tke_type').AsInteger in [6, 7]) then
          begin
            vSyntSoDivCASH := vSyntSoDivCASH + fieldbyname('TOT').AsFloat;
          end;
          vSyntCsh := vSyntCsh + fieldbyname('TOT').AsFloat;
          if (fieldbyname('enc_depense').AsInteger = 1) then
            vSyntSoDiv := vSyntSoDiv + fieldbyname('TOT').AsFloat;
          if fieldbyname('MEN_TYPEMOD').AsInteger in [1, 6] then
            vSyntCli := vSyntCli + fieldbyname('TOT').AsFloat;
          Next;
        end;
      finally
        First;
        EnableControls;
      end;
    end;
    vSyntTot := vSyntCsh + vSyntCli + vCptCli4 - vCptCli123 - vSyntSoDiv - vSyntSoDivCASH;

    Edt_TotLigCsh.Text := FormatFloat('#,##0.00', vSyntCsh);
    Edt_TotCli.Text := FormatFloat('#,##0.00', vSyntCli);
    Edt_CptCli.Text := FormatFloat('#,##0.00', vCptCli4 - vCptCli123);
    edtSortieCaisse.Text := FormatFloat('#,##0.00', vSyntSoDiv);
    edtSortieCaisseCASH.Text := FormatFloat('#,##0.00', vSyntSoDivCASH);
    Edt_CshTot.Text := FormatFloat('#,##0.00', vSyntTot);

    // synthèse fond de caisse
    vSyntFndCais := 0;
    with Que_SyntFndCais do
    begin
      DisableControls;
      try
        Active:=false;
        ParamByName('SESID').AsInteger := SesID;
        Active:=true;
        First;
        while not(Eof) do
        begin
          vSyntFndCais := vSyntFndCais+fieldbyname('MNT').AsFloat;
          Next;
        end;
      finally
        First;
        EnableControls;
      end;
    end;
    vSyntFndCais := -vSyntFndCais;
    vSyntTotFndCais := vSyntFndCais + vSyntCli + vCptCli4 - vCptCli123 + TotGenAch + TotGenLoc;
    Edt_TotFndCais.Text := FormatFloat('#,##0.00', vSyntTotFndCais);
    Edt_TotCli2.Text := FormatFloat('#,##0.00', vSyntCli);
    Edt_CptCli2.Text := FormatFloat('#,##0.00', vCptCli4-vCptCli123);
    Edt_BonAch2.Text := FormatFloat('#,##0.00', TotGenAch + TotGenLoc);
    Edt_FndTot.Text := FormatFloat('#,##0.00', vSyntTotFndCais);
  end;

  UpdateCouleur;
end;

procedure TFrm_AnalyseSession.UpdateRec(ATKE_ID: integer; DoMajEntete : boolean);
var
  sValue: string;
  vValue: Double;
  TkeID: integer;
  TkeNum: integer;
  TkeQte: integer;
  TkeMnt: double;
  TkeLoc: double;
  ArtQte: integer;
  ArtMnt: Double;
  CshMnt: Double;
  SoDivMnt : Double;
  vCshCli: Double;
  vCli123: double;
  vCli4: double;
  vCli6: double;
  TmpQte: integer;
  TmpPx: double;
  TmpTot: double;
  vBonAch : Double;
  vBonLoc : Double;
  PBA: double;
  PSSTotal: double;
  vSSTotal: integer;
  sErreur: string;
  bErr: boolean;
  bErr2: boolean;
  bErr3: boolean;
  NbreTick: integer;  
  ModEnc: string;
  ModType: integer;
  ModSupp: boolean;
  Book: TBookmark;
  TotGenArt: double;
  TotGenCsh: double;

//  TotSpeCash: double;
//  TkeSpeCash: double;
  bIsCashSession: Boolean;
  TkeType: TGinTicketType;
//  PSPiedTicketCASH: double;
//  vSpeCashValue: double;
//  PBACASH: double;

  MntBonLoc : double;
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Book := MemD_Ticket.GetBookmark;
  MemD_Ticket.DisableControls;
  Try
    if DoMajEntete then
    begin
      Dm_Main.Que_Div.SQL.Clear();
      Dm_Main.Que_Div.SQL.Add('select STR2 from pr_sesjournalzses ('+inttostr(SesID)+')');
      Dm_Main.Que_Div.Active := true;
      Dm_Main.Que_Div.Last;
      sValue := Dm_Main.Que_Div.fieldbyname('STR2').AsString;
      if Pos('.',sValue)>0 then
        sValue[Pos('.',sValue)] := DecimalSeparator;
      if Pos(',',sValue)>0 then
        sValue[Pos(',',sValue)] := DecimalSeparator;
      vValue := StrToFloatDef(sValue,0.0);
      vValue := vValue + dm_Main.GetCashSessionDelta(SesId);
      Edt_Ecart.Text:=FloatToStr(vValue);
      Dm_Main.Que_Div.Active := false;

      // total bon achat session
      vBonAch := 0;
      vBonLoc := 0;
      Dm_Main.Que_Div.SQL.Clear;
      Dm_Main.Que_Div.SQL.Add('select men_application, sum(ENC_BA) as BA');
      Dm_Main.Que_Div.SQL.Add(' from CSHENCAISSEMENT');
      Dm_Main.Que_Div.SQL.Add('join K on (K_ID = ENC_ID and K_enabled=1)');
      Dm_Main.Que_Div.SQL.Add('join cxshmodeenc on men_id = enc_menid');
      Dm_Main.Que_Div.SQL.Add('join CSHTICKET');
      Dm_Main.Que_Div.SQL.Add('    join k on (k_id=tke_id and k_enabled=1)');
      Dm_Main.Que_Div.SQL.Add('on (tke_id=enc_tkeid and tke_sesid='+inttostr(SesID)+')');
      Dm_Main.Que_Div.SQL.Add('group by men_application');
      Dm_Main.Que_Div.Active := true;
      while not Dm_Main.Que_Div.Eof do
      begin
        case Dm_Main.Que_Div.FieldByName('').AsInteger of
          1 : vBonAch := Dm_Main.Que_Div.fieldbyname('BA').AsFloat;
          2 : vBonLoc := Dm_Main.Que_Div.fieldbyname('BA').AsFloat;
        end;
        Dm_Main.Que_Div.Next();
      end;
      Dm_Main.Que_Div.Active := false;

      // total ligne article session
      Dm_Main.Que_Div.SQL.Clear;
      Dm_Main.Que_Div.SQL.Add('select sum(TKL_QTE*TKL_PXNN) MNT');
      Dm_Main.Que_Div.SQL.Add('from cshticketl join K on (K_ID = TKL_ID and K_enabled=1)');
      Dm_Main.Que_Div.SQL.Add('join CSHTICKET');
      Dm_Main.Que_Div.SQL.Add('    join k on (k_id=tke_id and k_enabled=1)');
      Dm_Main.Que_Div.SQL.Add('on (tke_id=tkl_tkeid and tke_sesid='+inttostr(SesID)+')');
      Dm_Main.Que_Div.SQL.Add('Where TKL_SSTOTAL=0');
      Dm_Main.Que_Div.Active := true;
      ArtMnt := Dm_Main.Que_Div.fieldbyname('MNT').AsFloat;
      Dm_Main.Que_Div.Active := false;

      Edt_TotLigArt.Text := FormatFloat('#,##0.00',ArtMnt);
      Edt_BonAch.Text := FormatFloat('#,##0.00',vBonAch + vBonLoc);
      Edt_TotArt.Text := FormatFloat('#,##0.00',ArtMnt+vBonAch);
    end;

    bIsCashSession := Dm_Main.SessionIsCashSession(SesID);

    Dm_Main.Que_Div.SQL.Clear;
    Dm_Main.Que_Div.SQL.Add('select tke_id,tke_numero,tke_divint,');
    Dm_Main.Que_Div.SQL.Add('(tke_qtea1+tke_qtea2+tke_qtea3+tke_qtea4) as qte,');
    Dm_Main.Que_Div.SQL.Add('(tke_totneta1+tke_totneta2+tke_totneta3+tke_totneta4) as mnt, tke_totneta2');
    Dm_Main.Que_Div.SQL.Add('from cshticket ');
    Dm_Main.Que_Div.SQL.Add('join k on (k_id=tke_id and k_enabled=1)');
    Dm_Main.Que_Div.SQL.Add('where tke_sesid='+inttostr(SesID));
    Dm_Main.Que_Div.SQL.Add('  and tke_id='+inttostr(ATKE_ID));
    Dm_Main.Que_Div.Active:=true;
    Dm_Main.Que_Div.First;
    if not(Eof) then
    begin
      MntBonLoc := 0;

      // entete du ticket
      TkeID := Dm_Main.Que_Div.fieldbyname('tke_id').AsInteger;
      TkeNum := Dm_Main.Que_Div.fieldbyname('tke_numero').AsInteger;
      TkeQte := Dm_Main.Que_Div.fieldbyname('qte').AsInteger;
      TkeMnt := Dm_Main.Que_Div.fieldbyname('mnt').AsFloat;
      TkeLoc := Dm_Main.Que_Div.fieldbyname('tke_totneta2').AsFloat;
      TkeType := TGinTicketType( Dm_Main.Que_Div.fieldbyname('tke_type').AsInteger );
      sErreur := '';
      if (Dm_Main.Que_Div.fieldbyname('tke_divint').asinteger <> 0) and
         (Dm_Main.Que_Div.fieldbyname('tke_divint').asstring <> '') then
        sErreur := 'Annulation Ticket N° ' + Dm_Main.Que_Div.fieldbyname('tke_divint').asstring;

      //p remise BA
      PBA := 1;
      vBonAch := 0;
      vBonLoc := 0;

      Dm_Main.Que_Div2.Active:=false;
      Dm_Main.Que_Div2.SQL.Clear;
      Dm_Main.Que_Div2.SQL.Add('select men_application, sum(ENC_MONTANT+ENC_BA) as TOTAL,sum(ENC_BA) as BA');
      Dm_Main.Que_Div2.SQL.Add('from CSHENCAISSEMENT');
      Dm_Main.Que_Div2.SQL.Add('join K on (K_ID = ENC_ID and K_enabled=1)');
      Dm_Main.Que_Div2.SQL.Add('join cshmodeenc on men_id = enc_menid');
      Dm_Main.Que_Div2.SQL.Add('Where ENC_TkeId='+inttostr(TkeID));
      Dm_Main.Que_Div2.SQL.Add('group by men_application');

      Dm_Main.Que_Div2.Active:=true;
      while not Dm_Main.Que_Div2.Eof do
      begin
        case Dm_Main.Que_Div2.FieldByName('men_application').AsInteger of
          1 : vBonAch := Dm_Main.Que_Div2.fieldbyname('BA').AsFloat;
          2 : vBonLoc := Dm_Main.Que_Div2.fieldbyname('BA').AsFloat;
        end;
        Dm_Main.Que_Div2.Next();
      end;
      Dm_Main.Que_Div2.Active:=false;

      if vBonAch <> 0 then
      begin
        with Dm_Main.Que_Div2, SQL do
        begin
          Active:=false;
          Clear;
          Add('select sum(tkl_pxnet)');
          Add('from cshticket join cshticketl on tkl_tkeid = tke_id');
          Add('where tke_id = ' + inttostr(TkeID));
          Active := true;
          if Fields[0].AsFloat <> 0 then
            PBA := (Fields[0].AsFloat - vBonAch) / Fields[0].AsFloat
          else
            PBA := 1;
          Active := false;
        end;
      end
      else
        PBA := 1;

      // ligne art
      ArtQte := 0;
      ArtMnt := vBonAch+TkeLoc;
      bErr := false;

      Dm_Main.Que_Div2.Active:=false;
      Dm_Main.Que_Div2.SQL.Clear;
      Dm_Main.Que_Div2.SQL.Add('select TKL_GPSSTOTAL,TKL_INSSTOTAL,TKL_QTE,TKL_PXNET,TKL_PXNN');
      Dm_Main.Que_Div2.SQL.Add('from cshticketl join K on (K_ID = TKL_ID and K_enabled=1)');
      Dm_Main.Que_Div2.SQL.Add('Where TKL_SSTOTAL=0');
      Dm_Main.Que_Div2.SQL.Add('  and TKL_TKEID='+inttostr(TkeID));
      Dm_Main.Que_Div2.SQL.Add('order by TKL_ID');
      Dm_Main.Que_Div2.Active:=true;
      Dm_Main.Que_Div2.First;
      while not(Eof) do
      begin
        TmpQte := Dm_Main.Que_Div2.fieldbyname('TKL_QTE').AsInteger;
        TmpPx := Dm_Main.Que_Div2.fieldbyname('TKL_PXNN').AsFloat;
        TmpTot := Dm_Main.Que_Div2.fieldbyname('TKL_PXNET').AsFloat;
        //calcul du % au sous total
        PSSTotal := 1.0;
        vSSTotal := -1;
        if Dm_Main.Que_Div2.fieldbyname('TKL_INSSTOTAL').AsInteger=1 then
          vSSTotal := Dm_Main.Que_Div2.fieldbyname('TKL_GPSSTOTAL').AsInteger;
        if vSSTotal>=0 then
        begin
          Dm_Main.Que_Div3.Active:=false;
          Dm_Main.Que_Div3.SQL.Clear;
          Dm_Main.Que_Div3.SQL.Add('select TKL_PXBRUT,TKL_PXNET');
          Dm_Main.Que_Div3.SQL.Add('from cshticketl join K on (K_ID = TKL_ID and K_enabled=1)');
          Dm_Main.Que_Div3.SQL.Add('Where TKL_GPSSTOTAL='+inttostr(vSSTotal));
          Dm_Main.Que_Div3.SQL.Add('  and TKL_SSTOTAL=1');
          Dm_Main.Que_Div3.SQL.Add('  and TKL_TKEID='+inttostr(TkeID));
          Dm_Main.Que_Div3.Active:=true;
          Dm_Main.Que_Div3.First;
          if not(Eof) and (ArrondiA2(Dm_Main.Que_Div3.fieldbyname('TKL_PXBRUT').AsFloat)<>0) then
            PSSTotal := 1-((abs(Dm_Main.Que_Div3.fieldbyname('TKL_PXBRUT').AsFloat)-abs(Dm_Main.Que_Div3.fieldbyname('TKL_PXNET').AsFloat))/abs(Dm_Main.Que_Div3.fieldbyname('TKL_PXBRUT').AsFloat));
          Dm_Main.Que_Div3.Active:=false;
        end;

        ArtQte := ArtQte+TmpQte;
        ArtMnt := ArtMnt+(TmpQte*TmpPx);
        if (abs((PBA*TmpTot*PSSTotal)-(TmpQte*TmpPx))>0.009) then
          bErr:=true;
        Next;
      end;
      Dm_Main.Que_Div2.active:=false;

      if bErr then
      begin
        if sErreur<>'' then
          sErreur:=sErreur+' ; ';
        sErreur := sErreur+'une ligne Art avec Qte*Px<>PTot ligne';
      end;
      if ArrondiA2(TkeMnt)<>ArrondiA2(ArtMnt) then
      begin
        if sErreur<>'' then
          sErreur:=sErreur+' ; ';
        sErreur := sErreur+'Mnt Entête <> Mnt Tot Art Ligne';
      end;
                     
      // location
      if ArrondiA2(TkeLoc) <> 0 then
      begin
        Dm_Main.Que_Div2.SQL.Clear();
        Dm_Main.Que_Div2.SQL.Add('select sum(loa_pxnn)');
        Dm_Main.Que_Div2.SQL.Add('from locbonlocation join k on k_id = loc_id and k_enabled = 1');
        Dm_Main.Que_Div2.SQL.Add('join locbonlocationligne join k on k_id = loa_id and k_enabled = 1 on loa_locid = loc_id and loa_typeligne between 1 and 3');
        Dm_Main.Que_Div2.SQL.Add('where loc_tkeid = ' + inttostr(TkeID) + ' and loc_typedoc = 2');
        try
          Dm_Main.Que_Div2.Open();
          if not Dm_Main.Que_Div2.Eof then
            MntBonLoc := Dm_Main.Que_Div2.Fields[0].AsFloat;
        finally
          Dm_Main.Que_Div2.Close();
        end;
        if ArrondiA2(TkeLoc) <> ArrondiA2(MntBonLoc + vBonLoc) then
        begin
          if sErreur<>'' then
            sErreur:=sErreur+' ; ';
          sErreur := sErreur+'Mnt Location <> Mnt Tot Ligne bon loc';
        end;
      end;

      // encaissement
      CshMnt := 0.0;
      SoDivMnt := 0.0;
      vCshCli := 0.0;
      bErr := false;
      bErr2 := false;
      bErr3 := false;

      Dm_Main.Que_Div2.Active:=false;
      Dm_Main.Que_Div2.SQL.Clear;
      Dm_Main.Que_Div2.SQL.Add('select ENC_MENID, ENC_MONTANT, ENC_BA, MEN_TYPEMOD, ENC_DEPENSE, ENC_MOTIF, TKE_TYPE');
      Dm_Main.Que_Div2.SQL.Add('from CSHENCAISSEMENT');
      Dm_Main.Que_Div2.SQL.Add('join K on (K_ID = ENC_ID and K_enabled=1)');
      Dm_Main.Que_Div2.SQL.Add('join CSHMODEENC on (MEN_ID=ENC_MENID)');
      Dm_Main.Que_Div2.SQL.Add('join CSHTICKET on (TKE_ID=ENC_TKEID)');
      Dm_Main.Que_Div2.SQL.Add('Where ENC_TkeId='+inttostr(TkeID));
      Dm_Main.Que_Div2.SQL.Add('order by ENC_ID');
      Dm_Main.Que_Div2.Active:=true;
      Dm_Main.Que_Div2.First;
      while not(Eof) do
      begin
        if (Dm_Main.Que_Div2.FieldByName('TKE_TYPE').AsInteger in [6, 7, 8]) then
        begin
          if sErreur <> '' then
            sErreur := ' ; ' + sErreur;

          case TGinTicketType(Dm_Main.Que_Div2.FieldByName('TKE_TYPE').AsInteger) of
            gttRegulImput:  sErreur := 'Apport (motif : ' + Dm_Main.Que_Div2.fieldbyname('ENC_MOTIF').AsString + ') ' + sErreur;
            gttRegulTaking: sErreur := 'Prélèvement (motif : ' + Dm_Main.Que_Div2.fieldbyname('ENC_MOTIF').AsString + ') ' + sErreur;
            gttExpense:     sErreur := 'Dépense (motif : ' + Dm_Main.Que_Div2.fieldbyname('ENC_MOTIF').AsString + ') ' + sErreur;
          end;

          SoDivMnt := SoDivMnt + Dm_Main.Que_Div2.fieldbyname('ENC_MONTANT').AsFloat + Dm_Main.Que_Div2.fieldbyname('ENC_BA').AsFloat;
        end
        else
        if (Dm_Main.Que_Div2.FieldByName('ENC_DEPENSE').AsInteger = 1) then
        begin
          if sErreur <> '' then
            sErreur := ' ; ' + sErreur;
          sErreur := 'Dépense (motif : ' + Dm_Main.Que_Div2.fieldbyname('ENC_MOTIF').AsString + ') ' + sErreur;
          SoDivMnt := SoDivMnt + Dm_Main.Que_Div2.fieldbyname('ENC_MONTANT').AsFloat + Dm_Main.Que_Div2.fieldbyname('ENC_BA').AsFloat;
        end
        else
          CshMnt := CshMnt + Dm_Main.Que_Div2.fieldbyname('ENC_MONTANT').AsFloat + Dm_Main.Que_Div2.fieldbyname('ENC_BA').AsFloat;
        if Dm_Main.Que_Div2.fieldbyname('MEN_TYPEMOD').AsInteger in [1, 6] then
          vCshCli := vCshCli + Dm_Main.Que_Div2.fieldbyname('ENC_MONTANT').AsFloat + Dm_Main.Que_Div2.fieldbyname('ENC_BA').AsFloat;
        Dm_Main.GetNomReglement(Dm_Main.Que_Div2.fieldbyname('ENC_MENID').AsInteger, ModEnc, ModType, ModSupp);
        if (Trim(ModEnc)='') and (Dm_Main.Que_Div2.fieldbyname('ENC_MENID').AsInteger<>0) then
          bErr:=true;
        if (Dm_Main.Que_Div2.fieldbyname('ENC_MENID').AsInteger=0) then
          bErr2:=true;
        if (ModSupp) then
          bErr3:=true;
        Next;
      end;
      Dm_Main.Que_Div2.active:=false;

      if bErr then
      begin
        if sErreur<>'' then
          sErreur:=sErreur+' ; ';
        sErreur := sErreur+'une ligne avec Mode de paiement invalide';
      end;
      if bErr2 then
      begin
        if sErreur<>'' then
          sErreur:=sErreur+' ; ';
        sErreur := sErreur+'une ligne avec ID(MEN_ID) Mode de paiement à zéro';
      end;
      if bErr3 then
      begin
        if sErreur<>'' then
          sErreur:=sErreur+' ; ';
        sErreur := sErreur+'une ligne Mode de paiement dont K_ENABLED<>1';
      end;

      // compte client
      bErr := false;
      vCli123 := 0.0;
      vCli4 := 0.0;
      vCli6 := 0.0;

      Dm_Main.Que_Div2.Active:=false;
      Dm_Main.Que_Div2.SQL.Clear;
      Dm_Main.Que_Div2.SQL.Add('Select cte_cltid,cte_typ,cte_credit,cte_debit,cte_libelle');
      Dm_Main.Que_Div2.SQL.Add('from cltcompte a');
      Dm_Main.Que_Div2.SQL.Add('Join k on (k_id=CTE_ID and k_enabled=1)');
      Dm_Main.Que_Div2.SQL.Add('where CTE_TKEID='+inttostr(TkeID));
      Dm_Main.Que_Div2.SQL.Add('order by CTE_ID');
      Dm_Main.Que_Div2.Active:=true;
      Dm_Main.Que_Div2.First;
      while not(Eof) do
      begin
        if (Dm_Main.Que_Div2.fieldbyname('cte_typ').AsInteger in [1..3]) then
          vCli123 := vCli123 + Dm_Main.Que_Div2.fieldbyname('cte_credit').AsFloat - Dm_Main.Que_Div2.fieldbyname('cte_debit').AsFloat;
        if (Dm_Main.Que_Div2.fieldbyname('cte_typ').AsInteger = 4) then
          vCli4 := vCli4 + Dm_Main.Que_Div2.fieldbyname('cte_credit').AsFloat - Dm_Main.Que_Div2.fieldbyname('cte_debit').AsFloat;
        if (Dm_Main.Que_Div2.fieldbyname('cte_typ').AsInteger = 6) then
          vCli6 := vCli6 + Dm_Main.Que_Div2.fieldbyname('cte_credit').AsFloat - Dm_Main.Que_Div2.fieldbyname('cte_debit').AsFloat;
        if (Dm_Main.Que_Div2.fieldbyname('cte_cltid').AsInteger = 0) then
          bErr:=true;
        Next;
      end;
      Dm_Main.Que_Div2.active:=false;

      CshMnt := CshMnt + vCshCli + vCli4 - vCli123;
      if bErr then
      begin
        if sErreur<>'' then
          sErreur:=sErreur+' ; ';
        sErreur := sErreur+'une ligne avec ID(CTE_CLTID) compte client à zéro';
      end;
      if ArrondiA2(TkeMnt)<>ArrondiA2(CshMnt) then
      begin
        if sErreur<>'' then
          sErreur:=sErreur+' ; ';
        sErreur := sErreur+'Mnt Entête <> Mnt Tot Encais.';
      end;

      MemD_Ticket.Edit;
      MemD_Ticket.fieldbyname('ENTQTE').AsInteger := TkeQte;
      MemD_Ticket.fieldbyname('ENTMNT').AsFloat := TkeMnt;
      MemD_Ticket.fieldbyname('ARTQTE').AsInteger := ArtQte;
      MemD_Ticket.fieldbyname('ARTMNT').AsFloat := ArtMnt;
      MemD_Ticket.fieldbyname('CSHMNT').AsFloat := CshMnt;
      MemD_Ticket.fieldbyname('ERREUR').AsString := sErreur;
      MemD_Ticket.fieldbyname('BONACH').AsFloat := vBonAch + vBonLoc;
      MemD_Ticket.fieldbyname('ENTLOC').AsFloat := TkeLoc;
      MemD_Ticket.Post;
    end;
                  
    TotGenAch := 0.0;
    TotGenArt := 0.0;
    TotGenCsh := 0.0;
    MemD_Ticket.First;
    while not(MemD_Ticket.Eof) do
    begin
      TotGenCsh := TotGenCsh + MemD_Ticket.fieldbyname('CSHMNT').AsFloat;
      TotGenArt := TotGenArt + MemD_Ticket.fieldbyname('ARTMNT').AsFloat+MemD_Ticket.fieldbyname('ENTLOC').AsFloat;
      TotGenAch := TotGenAch + MemD_Ticket.fieldbyname('BONACH').AsFloat;
      MemD_Ticket.Next;
    end;

    Edt_TotCsh.Text := FormatFloat('#,##0.00', TotGenCsh);

    Edt_TotLigArt.Text := FormatFloat('#,##0.00',TotGenArt-TotGenAch);
    Edt_BonAch.Text := FormatFloat('#,##0.00',TotGenAch);
    Edt_TotArt.Text := FormatFloat('#,##0.00',TotGenArt);

  finally
    MemD_Ticket.GotoBookmark(Book);
    MemD_Ticket.FreeBookmark(Book);
    MemD_Ticket.EnableControls;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;

  UpdateCouleur;
end;

function TFrm_AnalyseSession.Analyse: boolean;
var
  sValue: string;
  vValue: Double;
  TkeID: integer;
  TkeNum: integer;
  TkeQte: integer;
  TkeMnt: double;  
  TkeLoc: double;
  ArtQte: integer;
  ArtMnt: Double;
  CshMnt: Double;
  SoDivMnt : Double;
  vCshCli: Double;
  vCli123: double;
  vCli4: double;
  vCli6: double;
  TmpQte: integer;
  TmpPx: double;
  TmpTot: double;
  vBonAch : Double;
  vBonLoc : double;
  PBA: double;
  PSSTotal: double;
  vSSTotal: integer;
  sErreur: string;
  bErr: boolean;
  bErr2: boolean;
  bErr3: boolean;
  NbreTick: integer;
  ModEnc: string;
  ModType: integer;
  ModSupp: boolean;
  TotGenArt: double;
  TotGenCsh: double;

  TotSpeCash: double;
  TkeSpeCash: double;
  bIsCashSession: Boolean;
  TkeType: TGinTicketType;
  PSPiedTicketCASH: double;
  vSpeCashValue: double;
  PBACASH: double;

  MntBonLoc : double;
begin
  result := false;
  with Dm_Main.Que_Div, SQL do
  begin
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    VeuillezPatienter('Analyse de la session de caisse: '+SesNum,0);
    AffichePatienter;         
    Application.ProcessMessages;
    MemD_Ticket.Active := false;
    MemD_Ticket.Active := true;
    MemD_Ticket.DisableControls;
    Try
      Active := false;
      Clear;
      Add('select SES_ID, SES_DEBUT, SES_FIN from CshSession where ses_numero = ' + QuotedStr(SesNum) + ' order by SES_ID desc');
      Active := true;
      FetchAll;
      if (Eof) then
      begin
        MessageDlg('Session non trouvé !',mterror,[mbok],0);
        exit;
      end
      else if RecordCount > 1 then
      begin
        // TODO -obpy : Choix de la session selons les dates ...
        MessageDlg('Attention : plusieur session trouvé.'#13'Utilisation de la dernière.', mtWarning, [mbOK], 0);
      end;
      SesID := fieldbyname('SES_ID').AsInteger;
      Edt_Num.Text:=SesNum;
      Edt_ID.Text:=inttostr(SesID);
      Active := false;

      Clear;
      Add('select STR2 from pr_sesjournalzses ('+inttostr(SesID)+')');
      Active := true;
      Last;
      sValue := fieldbyname('STR2').AsString;
      if Pos('.',sValue)>0 then
        sValue[Pos('.',sValue)] := DecimalSeparator;
      if Pos(',',sValue)>0 then
        sValue[Pos(',',sValue)] := DecimalSeparator;
      vValue := StrToFloatDef(sValue,0.0);
      vValue := vValue + dm_Main.GetCashSessionDelta(SesId);
      Edt_Ecart.Text:=FloatToStr(vValue);
      Active := false;

      bIsCashSession := Dm_Main.SessionIsCashSession(SesID);

      //mnt total entête
      Clear;
      Add('select sum(tke_totneta1 + tke_totneta2 + tke_totneta3 + tke_totneta4) as mnt');
      Add('from cshticket');
      Add('  join k on k_id = tke_id and k_enabled = 1');
      Add('where tke_sesid = '+inttostr(SesID));
      Active:=true;
      Edt_TotEnt.Text := FormatFloat('#,##0.00', fieldbyname('MNT').AsFloat);
      Active:=false;

      TotSpeCash := 0;
      Edt_SpeCASH.Text := FormatFloat('#,##0.00', 0);
      Edt_SpeCASH.Visible := bIsCashSession;

      Clear;
      Add('select count(*) as NBRE');
      Add('from cshticket ');
      Add('join k on (k_id=tke_id and k_enabled=1)');
      Add('where tke_sesid='+inttostr(SesID));
      Active:=true;
      NbreTick := fieldbyname('NBRE').AsInteger;
      Active:=false;
      SetMaxProgress(NbreTick);

      TotGenAch := 0;
      TotGenLoc := 0;
      TotGenCsh := 0;
      TotGenArt := 0;
      Clear;
      Add('select tke_id,tke_numero,tke_divint, tke_totneta2,');
      Add('(tke_qtea1 + tke_qtea2 + tke_qtea3 + tke_qtea4) as qte,');
      Add('(tke_totneta1 + tke_totneta2 + tke_totneta3 + tke_totneta4) as mnt, ');
      Add('tke_type ');
      Add('from cshticket ');
      Add('join k on (k_id=tke_id and k_enabled=1)');
      Add('where tke_sesid='+inttostr(SesID));
      Add('order by tke_numero');
      Active:=true;
      First;
      while not(Eof) do
      begin
        TkeSpeCash := 0;
        MntBonLoc := 0;

        // entete du ticket
        TkeID := fieldbyname('tke_id').AsInteger;
        TkeNum := fieldbyname('tke_numero').AsInteger;
        TkeQte := fieldbyname('qte').AsInteger;
        TkeMnt := fieldbyname('mnt').AsFloat;
        TkeLoc := fieldbyname('tke_totneta2').AsFloat;
        TkeType := TGinTicketType( fieldbyname('tke_type').AsInteger );
        sErreur := '';
        if (fieldbyname('tke_divint').asinteger <> 0) and
           (fieldbyname('tke_divint').asstring <> '') then
          sErreur := 'Annulation Ticket N° '+fieldbyname('tke_divint').asstring;
        TotGenArt := TotGenArt+TkeLoc;

        //p remise BA
        PBA := 1;
        vBonAch := 0;
        vBonLoc := 0;
        with Dm_Main.Que_Div2, SQL do
        begin
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
        end;

        TotGenAch := TotGenAch + vBonAch;
        TotGenLoc := TotGenLoc + vBonLoc;

        if vBonAch <> 0 then
        begin
          with Dm_Main.Que_Div2, SQL do
          begin
            Active:=false;
            Clear;
            Add('select sum(tkl_pxnet)');
            Add('from cshticket join cshticketl on tkl_tkeid = tke_id');
            Add('where tke_id = ' + inttostr(TkeID));
            Active := true;
            if Fields[0].AsFloat <> 0 then
              PBA := (Fields[0].AsFloat - vBonAch) / Fields[0].AsFloat
            else
              PBA := 1;
            Active := false;
          end;
        end
        else
          PBA := 1;

        vSpeCashValue := 0;
        PBACASH := 1.0;
        if bIsCashSession then //Pour les sessions CASH il faut ajouter ...
        begin
          vSpeCashValue := dm_Main.GetTicketCASH_EmissionAcompte(TkeID);
          if vSpeCashValue <> 0 then
          begin
            TkeMnt := TkeMnt + vSpeCashValue;
            TkeSpeCash := TkeSpeCash + vSpeCashValue;
          end;

          vSpeCashValue := dm_Main.GetTicketCASH_EmissionCarteCadeau(TkeID);
          if vSpeCashValue <> 0 then
          begin
            TkeMnt := TkeMnt + vSpeCashValue;
            TkeSpeCash := TkeSpeCash + vSpeCashValue;
          end;
          TotSpeCash := TotSpeCash + TkeSpeCash;

          PBACASH := dm_Main.GetTicketCASH_BonAchatPercent(TkeID);
        end;

        // ligne art  
        ArtQte := 0;
        ArtMnt := vBonAch+TkeLoc;
        bErr := false;
        with Dm_Main.Que_Div2, SQL do
        begin
          Active:=false;
          Clear;
          Add('select TKL_GPSSTOTAL,TKL_INSSTOTAL,TKL_QTE,TKL_PXNET,TKL_PXNN');
          Add('from cshticketl join K on (K_ID = TKL_ID and K_enabled=1)');
          Add('Where TKL_SSTOTAL=0');
          Add('  and TKL_TKEID='+inttostr(TkeID));
          Add('order by TKL_ID');
          Active:=true;
          First;
          while not(Eof) do
          begin
            TmpQte := fieldbyname('TKL_QTE').AsInteger;
            TmpPx := fieldbyname('TKL_PXNN').AsFloat;
            TmpTot := fieldbyname('TKL_PXNET').AsFloat;
            //calcul du % au sous total
            PSSTotal := 1.0;
            vSSTotal := -1;
            if fieldbyname('TKL_INSSTOTAL').AsInteger=1 then
              vSSTotal := fieldbyname('TKL_GPSSTOTAL').AsInteger;
            if vSSTotal>=0 then
            begin
              with Dm_Main.Que_Div3, SQL do
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
                  PSSTotal := 1-((abs(fieldbyname('TKL_PXBRUT').AsFloat)-abs(fieldbyname('TKL_PXNET').AsFloat))/abs(fieldbyname('TKL_PXBRUT').AsFloat));
                Active:=false;
              end;
            end;

            ArtQte := ArtQte+TmpQte;
            ArtMnt := ArtMnt+(TmpQte*TmpPx);
            TotGenArt := TotGenArt+(TmpQte*TmpPx);

            PSPiedTicketCASH := 1.0;
            if bIsCashSession then
            begin
              // Pour les sessions CASH il faut prendre en compte la remise pied de ticket.
              PSPiedTicketCASH := dm_main.GetTicketCASH_RemisePiedPercent(TkeId);
            end;

            if (abs((PBA*PBACASH*TmpTot*PSSTotal*PSPiedTicketCASH)) - abs(TmpQte*TmpPx) > 0.009) then
              bErr:=true;

            Next;
          end;
          active:=false;
        end;

        if bErr then
        begin
          if sErreur<>'' then
            sErreur:=sErreur+' ; ';
          sErreur := sErreur+'une ligne Art avec Qte * Px <> PTot ligne';
        end;
        if ArrondiA2(TkeMnt)<>ArrondiA2(ArtMnt + TkeSpeCASH) then
        begin
          if sErreur<>'' then
            sErreur:=sErreur+' ; ';
          sErreur := sErreur+'Mnt Entête <> Mnt Tot Art Ligne';
        end;

        // location
        if ArrondiA2(TkeLoc) <> 0 then
        begin
          Dm_Main.Que_Div2.SQL.Clear();
          Dm_Main.Que_Div2.SQL.Add('select sum(loa_pxnn)');
          Dm_Main.Que_Div2.SQL.Add('from locbonlocation join k on k_id = loc_id and k_enabled = 1');
          Dm_Main.Que_Div2.SQL.Add('join locbonlocationligne join k on k_id = loa_id and k_enabled = 1 on loa_locid = loc_id and loa_typeligne between 1 and 3');
          Dm_Main.Que_Div2.SQL.Add('where loc_tkeid = ' + inttostr(TkeID) + ' and loc_typedoc = 2');
          try
            Dm_Main.Que_Div2.Open();
            if not Dm_Main.Que_Div2.Eof then
              MntBonLoc := Dm_Main.Que_Div2.Fields[0].AsFloat;
          finally
            Dm_Main.Que_Div2.Close();
          end;
          if ArrondiA2(TkeLoc) <> ArrondiA2(MntBonLoc + vBonLoc) then
          begin
            if sErreur<>'' then
              sErreur:=sErreur+' ; ';
            sErreur := sErreur+'Mnt Location <> Mnt Tot Ligne bon loc';
          end;
        end;

        // encaissement
        CshMnt := 0.0;
        SoDivMnt := 0.0;
        vCshCli := 0.0;
        bErr := false;
        bErr2 := false;
        bErr3 := false;
        with Dm_Main.Que_Div2, SQL do
        begin
          Active:=false;
          Clear;
          Add('select ENC_MENID, ENC_MONTANT, ENC_BA, MEN_TYPEMOD, ENC_DEPENSE, ENC_MOTIF, TKE_TYPE');
          Add('from CSHENCAISSEMENT');
          Add('join K on (K_ID = ENC_ID and K_enabled=1)');
          Add('join CSHMODEENC on (MEN_ID=ENC_MENID)');
          Add('join CSHTICKET on (TKE_ID=ENC_TKEID)');
          Add('Where ENC_TkeId='+inttostr(TkeID));
          Add('order by ENC_ID');
          Active:=true;
          First;
          while not(Eof) do
          begin
            if (FieldByName('TKE_TYPE').AsInteger in [6, 7, 8]) then
            begin
              if sErreur <> '' then
                sErreur := ' ; ' + sErreur;

              case TGinTicketType(FieldByName('TKE_TYPE').AsInteger) of
                gttRegulImput:  sErreur := 'Apport (motif : ' + fieldbyname('ENC_MOTIF').AsString + ') ' + sErreur;
                gttRegulTaking: sErreur := 'Prélèvement (motif : ' + fieldbyname('ENC_MOTIF').AsString + ') ' + sErreur;
                gttExpense:     sErreur := 'Dépense (motif : ' + fieldbyname('ENC_MOTIF').AsString + ') ' + sErreur;
              end;

              SoDivMnt := SoDivMnt + fieldbyname('ENC_MONTANT').AsFloat+fieldbyname('ENC_BA').AsFloat;
            end
            else if (FieldByName('ENC_DEPENSE').AsInteger = 1) then
            begin
              if sErreur <> '' then
                sErreur := ' ; ' + sErreur;
              sErreur := 'Dépense (motif : ' + fieldbyname('ENC_MOTIF').AsString + ') ' + sErreur;
              SoDivMnt := SoDivMnt + fieldbyname('ENC_MONTANT').AsFloat+fieldbyname('ENC_BA').AsFloat;
            end
            else
              CshMnt := CshMnt+fieldbyname('ENC_MONTANT').AsFloat+fieldbyname('ENC_BA').AsFloat;
            if fieldbyname('MEN_TYPEMOD').AsInteger in [1, 6] then
              vCshCli := vCshCli+fieldbyname('ENC_MONTANT').AsFloat+fieldbyname('ENC_BA').AsFloat;
            Dm_Main.GetNomReglement(fieldbyname('ENC_MENID').AsInteger, ModEnc, ModType, ModSupp);
            if (Trim(ModEnc)='') and (fieldbyname('ENC_MENID').AsInteger<>0) then
              bErr:=true;
            if (fieldbyname('ENC_MENID').AsInteger=0) then
              bErr2:=true;
            if (ModSupp) then
              bErr3:=true;
            Next;
          end;
          active:=false;
        end;
        if bErr then
        begin
          if sErreur<>'' then
            sErreur:=sErreur+' ; ';
          sErreur := sErreur+'une ligne avec Mode de paiement invalide';
        end;
        if bErr2 then
        begin
          if sErreur<>'' then
            sErreur:=sErreur+' ; ';
          sErreur := sErreur+'une ligne avec ID(MEN_ID) Mode de paiement à zéro';
        end;    
        if bErr3 then
        begin
          if sErreur<>'' then
            sErreur:=sErreur+' ; ';
          sErreur := sErreur+'une ligne Mode de paiement dont K_ENABLED<>1';
        end;

        // compte client
        vCli123 := 0.0;
        vCli4 := 0.0;
        vCli6 := 0.0;
        bErr := false;
        with Dm_Main.Que_Div2, SQL do
        begin
          Active:=false;
          Clear;
          Add('Select * ');
          Add('from cltcompte');
          Add('Join k on (k_id = CTE_ID and k_enabled = 1)');
          Add('where CTE_TKEID = '+inttostr(TkeID));
          Add('order by CTE_ID');
          Active:=true;
          First;
          while not(Eof) do
          begin
            if (fieldbyname('cte_typ').AsInteger in [1..3]) then
              vCli123 := vCli123 + fieldbyname('cte_credit').AsFloat - fieldbyname('cte_debit').AsFloat
            else if (fieldbyname('cte_typ').AsInteger = 4) then
              vCli4 := vCli4 + fieldbyname('cte_credit').AsFloat - fieldbyname('cte_debit').AsFloat
            else if (fieldbyname('cte_typ').AsInteger = 6) then
              vCli6 := vCli6 + fieldbyname('cte_credit').AsFloat - fieldbyname('cte_debit').AsFloat;

            if (fieldbyname('cte_cltid').AsInteger = 0) then
              bErr := true;
            Next;
          end;
          active := false;
        end;
        CshMnt := CshMnt + vCshCli + vCli4 - vCli123;
        if bErr then
        begin
          if sErreur<>'' then
            sErreur:=sErreur+' ; ';
          sErreur := sErreur+'une ligne avec ID(CTE_CLTID) compte client à zéro';
        end;
        if ArrondiA2(TkeMnt)<>ArrondiA2(CshMnt) then
        begin
          if sErreur<>'' then
            sErreur:=sErreur+' ; ';

          // Dans les sessions CASH les tickets d'apport/prélèvement/dépense rentre dans ce cas la.
          if bIsCashSession then
          begin
            case TkeType of
              gttRegulImput:  ;//sErreur := sErreur + 'CASH Apport';
              gttRegulTaking: ;//sErreur := sErreur + 'CASH Prélèvement';
              gttExpense:     ;//sErreur := sErreur + 'CASH Dépense';
              else            sErreur := sErreur+'Mnt Entête <> Mnt Tot Encais.';
            end;
          end
          else
          begin
            sErreur := sErreur+'Mnt Entête <> Mnt Tot Encais.';
          end;
        end;

        MemD_Ticket.Append;
        MemD_Ticket.fieldbyname('TKE_ID').AsInteger := TkeID;
        MemD_Ticket.fieldbyname('NUMTICK').AsInteger := TkeNum;
        MemD_Ticket.fieldbyname('ENTQTE').AsInteger := TkeQte;
        MemD_Ticket.fieldbyname('ENTMNT').AsFloat := TkeMnt;
        MemD_Ticket.fieldbyname('ARTQTE').AsInteger := ArtQte;
        MemD_Ticket.fieldbyname('ARTMNT').AsFloat := ArtMnt;
        MemD_Ticket.fieldbyname('CSHMNT').AsFloat := CshMnt;
        MemD_Ticket.fieldbyname('ERREUR').AsString := sErreur; 
        MemD_Ticket.fieldbyname('BONACH').AsFloat := vBonAch + vBonLoc;
        MemD_Ticket.fieldbyname('ENTLOC').AsFloat := TkeLoc;
        MemD_Ticket.Post;
        TotGenCsh := TotGenCsh + CshMnt;

        AvanceProgress;
        Next;
      end;

      if bIsCashSession then
      begin
        Edt_SpeCASH.Text := FormatFloat('#,##0.00', TotSpeCash);
      end;

      Edt_TotCsh.Text := FormatFloat('#,##0.00', TotGenCsh);

      Edt_TotLigArt.Text := FormatFloat('#,##0.00',TotGenArt);
      Edt_BonAch.Text := FormatFloat('#,##0.00',TotGenAch);
      Edt_TotArt.Text := FormatFloat('#,##0.00',TotGenArt+TotGenAch);

      // remise a jour du montant total d'encaissement !

      result := true;
    finally
      MemD_Ticket.First;
      MemD_Ticket.EnableControls;
      Active:=false;
      FermerPatienter;
      Application.ProcessMessages;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFrm_AnalyseSession.btnGLobalActionClick(Sender: TObject);
var
  pt : TPoint;
begin
  GetCursorPos(pt);
  pmGlobalAction.PopupComponent := TComponent(Sender);
  pmGlobalAction.Popup(pt.X,pt.y);
end;

procedure TFrm_AnalyseSession.CorrectiondesproblmesdeBAgnrantdespseudoremises1Click( Sender: TObject);
var
  msg: string;
  nbModif: Integer;
  tslError: TStringList;
begin
  nbModif := 0;
  tslError := TStringList.Create;
  try
    MemD_Ticket.First;
    while not MemD_Ticket.Eof do
    begin
      if Dm_Main.CorrigeTicketAvecBAGenerantDesPseudoRemise(MemD_TicketTKE_ID.AsInteger, msg) then
        Inc(nbModif)
      else
      begin
        if msg <> '' then
          tslError.Add(Format('Ticket "%d" : %s', [MemD_TicketNUMTICK.AsInteger, msg]));
      end;
      MemD_Ticket.Next;
    end;
    if nbModif = 0 then
      msg := 'Aucun ticket corrigé'
    else if nbModif = 1 then
      msg := '1 ticket corrigé'
    else
      msg := format('%d tickets corrigés', [nbModif]);
    if tslError.Count > 0 then
      msg := msg + #13#10#13#10+tslError.Text;
    MessageDlg(msg, mterror,[mbok],0);
  finally
    if nbModif > 0 then
      Nbt_RefreshClick(sender);
    tslError.Free;
  end;
end;

procedure TFrm_AnalyseSession.CorrectionerreurdeventilationPxNN0opration3pour21Click(
  Sender: TObject);
var
  msg: string;
  nbModif: Integer;
  tslError: TStringList;
begin
  nbModif := 0;
  tslError := TStringList.Create;
  try
    MemD_Ticket.First;
    while not MemD_Ticket.Eof do
    begin
      if Dm_Main.CorrigeTicketAvecPxNNa0(MemD_TicketTKE_ID.AsInteger, msg) then
        Inc(nbModif)
      else
      begin
        if msg <> '' then
          tslError.Add(Format('Ticket "%d" : %s', [MemD_TicketNUMTICK.AsInteger, msg]));
      end;
      MemD_Ticket.Next;
    end;
    if nbModif = 0 then
      msg := 'Aucun ticket corrigé'
    else if nbModif = 1 then
      msg := '1 ticket corrigé'
    else
      msg := format('%d tickets corrigés', [nbModif]);
    if tslError.Count > 0 then
      msg := msg + #13#10#13#10+tslError.Text;
    MessageDlg(msg, mterror,[mbok],0);
  finally
    if nbModif > 0 then
      Nbt_RefreshClick(sender);
    tslError.Free;
  end;
end;

procedure TFrm_AnalyseSession.CorrectionMENIDzro1Click(Sender: TObject);
var
  msg: string;
  MenID, nbModif: Integer;
  tslError: TStringList;
begin
  nbModif := 0;
  tslError := TStringList.Create;
  try
    MenID := Dm_Main.GetBonReducIDBySession(edt_num.Text);
    if MenID = 0 then
      tslError.Add('Mode d''encaissement Bon de réduction non trouvé')
    else
    begin
      MemD_Ticket.First;
      while not MemD_Ticket.Eof do
      begin
        if Dm_Main.CorrigeMenIDZero(MemD_TicketTKE_ID.AsInteger, MenID, msg) then
          Inc(nbModif)
        else
        begin
          if msg <> '' then
            tslError.Add(Format('Ticket "%d" : %s', [MemD_TicketNUMTICK.AsInteger, msg]));
        end;
        MemD_Ticket.Next;
      end;
    end;
    if nbModif = 0 then
      msg := 'Aucun ticket corrigé'
    else if nbModif = 1 then
      msg := '1 ticket corrigé'
    else
      msg := format('%d tickets corrigés', [nbModif]);
    if tslError.Count > 0 then
      msg := msg + #13#10#13#10+tslError.Text;
    MessageDlg(msg, mterror,[mbok],0);
  finally
    if nbModif > 0 then
      Nbt_RefreshClick(sender);
    tslError.Free;
  end;
end;

procedure TFrm_AnalyseSession.Correctionduticketavecremisefidlitsansbon1Click(Sender: TObject);
var
  i, nbModif: Integer;
  msg: string;
  tslError: TStringList;
begin
  // selecttion !
  if iob.SelectedRows.Count > 0 then
  begin
    nbModif := 0;
    tslError := TStringList.Create;
    try
      for i := 0 to iob.SelectedRows.Count -1 do
      begin
        MemD_Ticket.GotoBookmark(iob.SelectedRows[i]);
        if Dm_Main.CorrigeTicketRemiseFidSansBon(MemD_Ticket.FieldByName('TKE_ID').AsInteger, msg) then
          Inc(nbModif)
        else
        begin
          if msg <> '' then
            tslError.Add(Format('Ticket "%d" : %s', [MemD_TicketNUMTICK.AsInteger, msg]));
        end;
      end;
      if nbModif = 0 then
        msg := 'Aucun ticket corrigé'
      else if nbModif = 1 then
        msg := '1 ticket corrigé'
      else
        msg := format('%d tickets corrigés', [nbModif]);
      if tslError.Count > 0 then
        msg := msg + #13#10#13#10+tslError.Text;
      MessageDlg(msg, mterror,[mbok],0);
    finally
      if nbModif > 0 then
        Nbt_RefreshClick(sender);
      tslError.Free;
    end;
  end
  else
  begin
    MessageDlg('Vous devez sélectionner (au moins) un ticket', mtWarning, [mbOK], 0);
  end;
end;

procedure TFrm_AnalyseSession.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
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

procedure TFrm_AnalyseSession.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
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

procedure TFrm_AnalyseSession.DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
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

procedure TFrm_AnalyseSession.DBGridTitleClick(Column: TColumn);
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

procedure TFrm_AnalyseSession.FormCreate(Sender: TObject);
begin
  Pgc_Page1.ActivePage := Tb_SyntCais;
end;

function TFrm_AnalyseSession.InitEcr(ANomReq: string; ASesNum: string):boolean;
begin
  Result:=false;
  if ASesNum='' then begin
    MessageDlg('Session invalide !',mterror,[mbok],0);
    exit;
  end;
  Edt_Fic.Text := UpperCase(ANomReq)+'.sql';
  SesNum := ASesNum;
  Result := Analyse;
  if Result then
    Synthese;
end;

procedure TFrm_AnalyseSession.MemD_TicketCalcFields(DataSet: TDataSet);
begin
  MemD_Ticket.FieldByName('DIFFENTART').AsFloat := Abs(MemD_Ticket.FieldByName('ENTMNT').AsFloat-
                                                       MemD_Ticket.FieldByName('ARTMNT').AsFloat);
                                                         
  MemD_Ticket.FieldByName('DIFFENTCSH').AsFloat := Abs(MemD_Ticket.FieldByName('ENTMNT').AsFloat-
                                                       MemD_Ticket.FieldByName('CSHMNT').AsFloat);

  MemD_Ticket.FieldByName('DIFFARTCSH').AsFloat := Abs(MemD_Ticket.FieldByName('ARTMNT').AsFloat-
                                                       MemD_Ticket.FieldByName('CSHMNT').AsFloat);
end;

procedure TFrm_AnalyseSession.Nbt_LigFndCaisClick(Sender: TObject);
var
  Frm_FndDeCaisse : TFrm_FndDeCaisse;
begin
  Frm_FndDeCaisse := TFrm_FndDeCaisse.Create(Self);
  try
    Frm_FndDeCaisse.InitEcr(SesNum, SesID, Edt_Ecart.Text);
    Frm_FndDeCaisse.ShowModal;
  finally
    FreeAndNil(Frm_FndDeCaisse);
  end;
end;

procedure TFrm_AnalyseSession.Nbt_RefreshClick(Sender: TObject);
begin
  Analyse;
  Synthese;
  Nbt_Refresh.Font.Style := [];
end;

procedure TFrm_AnalyseSession.Nbt_VoirClick(Sender: TObject);
var
  Frm_FichierRequete: TFrm_FichierRequete;
begin
  Frm_FichierRequete := TFrm_FichierRequete.Create(Self);
  try
    Frm_FichierRequete.InitEcr(Edt_Fic.Text);
    Frm_FichierRequete.ShowModal;
  finally
    FreeAndNil(Frm_FichierRequete);
  end;
end;

procedure TFrm_AnalyseSession.WMSysCommand(var Msg: TWMSyscommand);
begin
  // intercepte le clic sur le bouton minimise
  if ((msg.CmdType and $FFF0) = SC_MINIMIZE) then begin  
    Msg.Result:=1;
    Application.Minimize;
    exit;
  end;
  inherited;
end;

end.
