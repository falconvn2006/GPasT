unit ListArtTrouve_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLabel, ExtCtrls, RzPanel, dxCntner, dxTL, dxDBCtrl, dxDBGrid, dxDBGridHP, LMDCustomButton,
  LMDButton, Boxes, PanBtnDbgHP, DB, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider,
  dxPSFillPatterns, dxPSEdgePatterns, dxPSCore, dxPSdxTLLnk, dxPSdxDBCtrlLnk, dxPSdxDBGrLnk, dxComponentPrinterHP,
  Buttons, dxDBTLCl, dxGrClms;

const
  WM_EXCELREPORT = WM_USER + 1001;

type
  TFrm_ListArtTrouve = class(TForm)
    DBG_LstArt: TdxDBGridHP;
    Pan_Haut: TRzPanel;
    Lab_Tit: TRzLabel;
    Pan_Bas: TRzPanel;
    Ds_LstArt: TDataSource;
    Pan_LstArt: TPanelDbg;
    DBG_LstArtArtID: TdxDBGridMaskColumn;
    DBG_LstArtChrono: TdxDBGridMaskColumn;
    DBG_LstArtNom: TdxDBGridMaskColumn;
    DBG_LstArtMarque: TdxDBGridMaskColumn;
    DBG_LstArtStkCourant: TdxDBGridMaskColumn;
    DBG_LstArtStkHisto: TdxDBGridMaskColumn;
    Nbt_Close: TLMDButton;
    dxPtr_LstArt: TdxComponentPrinterHP;
    dxPtr_LstArtLink1: TdxDBGridReportLink;
    DBG_LstPbSckHisto: TdxDBGridCheckColumn;
    DBG_LstArtStkMvt: TdxDBGridColumn;
    procedure DBG_LstArtButtonGestionBeforeAction(Sender: TObject; ComponentName: string; var Allow: Boolean);
  private
    { Déclarations privées }
    FicExcel: string;
    procedure WmExportExcel(var m:TMessage); message WM_EXCELREPORT;
    procedure WMSysCommand(var Msg: TWMSyscommand); message WM_SYSCOMMAND;
  public
    { Déclarations publiques }
    procedure SetLstArt(AFilename: String);
  end;

var
  Frm_ListArtTrouve: TFrm_ListArtTrouve;

implementation

uses
  Main_Dm, ShellApi, ExportExcelConfirm_Frm, Clipbrd;

{$R *.dfm}


procedure TFrm_ListArtTrouve.WMSysCommand(var Msg: TWMSyscommand);
begin  
  // intercepte le clic sur le bouton minimise
  if ((msg.CmdType and $FFF0) = SC_MINIMIZE) then begin  
    Msg.Result:=1;
    Application.Minimize;
    exit;
  end;
  inherited;
end;

procedure TFrm_ListArtTrouve.WmExportExcel(var m:TMessage);
var
  sFileName: string;
  Flag: boolean;
  bOk: boolean;
  bOuvreExcel: boolean;
begin
  if FicExcel='' then
    exit;
  sFileName := ReperBase+'Exports\';
  if not(DirectoryExists(sFileName)) then
    ForceDirectories(sFileName);
  sFileName := sFileName+FicExcel;

  bOuvreExcel := false;
  bOk := false;
  Frm_ExportExcelConfirm := TFrm_ExportExcelConfirm.Create(Self);
  try
    Frm_ExportExcelConfirm.SetInit(sFilename);
    bOk := (Frm_ExportExcelConfirm.ShowModal = mrok);
    bOuvreExcel := Frm_ExportExcelConfirm.Chk_OuvrirExcel.Checked;
  finally
    Frm_ExportExcelConfirm.Free;
    Frm_ExportExcelConfirm:=nil;
  end;
  if not(bOk) then
    exit;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Flag := False;
  if (DBG_LstArt.HPAddOn.Groupes.SummaryGroupOnTop and DBG_LstArt.ShowRowFooter) then
  begin
    Flag := True;
    DBG_LstArt.HpAddon.Groupes.SummaryGroupOnTop := false;
  end;
  DBG_LstArt.BeginUpdate;
  try
    DBG_LstArt.SaveToXLS(sFileName, true);
  finally
    if Flag then
      DBG_LstArt.HpAddon.Groupes.SummaryGroupOnTop := true;

    DBG_LstArt.EndUpdate;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;

  if bOuvreExcel then
    ShellExecute(0, 'open', PChar(sFileName), nil, nil, SW_SHOW);
end;

procedure TFrm_ListArtTrouve.DBG_LstArtButtonGestionBeforeAction(Sender: TObject; ComponentName: string;
  var Allow: Boolean);
begin
  if UpperCase(ComponentName)='NBT_EXCEL' then
  begin
    Allow := false;
    PostMessage(Handle, WM_EXCELREPORT, 0, 0);
    exit;
  end;
end;

procedure TFrm_ListArtTrouve.SetLstArt(AFilename: String);
var
  TpListe: TStringList;
  TpListeEntete: TStringList;
  i: integer;
  sEntete: string;
  sLigne, sChamp: string;
  Position: integer;
  Ligne: integer;
begin
  with Dm_Main do
  begin

    // Titre et entête
    Lab_Tit.Caption:='Recherche article du '+
                     FormatDateTime('dd/mm/yyyy',Cds_Rapp.fieldbyname('RDate').AsDateTime)+' '+
                     FormatDateTime('hh:nn:ss',Cds_Rapp.fieldbyname('RHeure').AsDateTime);
    dxPtr_LstArtLink1.PrinterPage.PageHeader.CenterTitle.Text:=Lab_Tit.Caption;
    FicExcel := Cds_Base.fieldbyname('Nom').AsString+'_'+
                'Recherche article du '+
                FormatDateTime('dd-mm-yyyy',Cds_Rapp.fieldbyname('RDate').AsDateTime)+' '+
                FormatDateTime('hh.nn.ss',Cds_Rapp.fieldbyname('RHeure').AsDateTime)+'.xls';

    // article
    Ligne := 0;
    try
      with Cds_LstArt do
      begin
        EmptyDataSet;
        DisableControls;

        TpListe := TStringList.Create;
        TpListeEntete := TStringList.Create;
        try
          TPListe.LoadFromFile(AFileName);
          if TPListe.Count=0 then
            exit;

          // entete du csv
          sEntete:=TpListe[0];
          while Pos(';',sEntete)>0 do
          begin
            TpListeEntete.Add(Copy(sEntete,1,Pos(';',sEntete)-1));
            sEntete := Copy(sEntete, Pos(';',sEntete)+1, Length(sEntete));
          end;
          if sEntete<>'' then
            TpListeEntete.Add(sEntete);

          // les champs
          for i := 2 to TpListe.Count do
          begin  
            Append;
            Ligne := i;
            sLigne := TpListe[i-1];
            Position := 0;
            while Pos(';',sLigne)>0 do
            begin
              sChamp := Copy(sLigne,1,Pos(';',sLigne)-1);
              sLigne := Copy(sLigne, Pos(';',sLigne)+1, Length(sLigne));
              if Position<TpListeEntete.Count then
                fieldbyname(TpListeEntete[Position]).AsString := sChamp;

              Inc(Position);
            end;
            if (sLigne<>'') and (Position<TpListeEntete.Count) then
                fieldbyname(TpListeEntete[Position]).AsString := sLigne;

            Post;
          end;

        finally
          First;
          EnableControls;
          TpListe.Free;
          TpListe := nil;
          TpListeEntete.Free;
          TpListeEntete := nil;
        end;
      end;
    except
      on E:Exception do
      begin
        if Ligne>0 then
          MessageDlg('Erreur ligne '+inttostr(Ligne)+': '+E.Message,mterror,[mbok],0)
        else
          MessageDlg(E.Message,mterror,[mbok],0);
      end;
    end;

  end;
end;

end.
