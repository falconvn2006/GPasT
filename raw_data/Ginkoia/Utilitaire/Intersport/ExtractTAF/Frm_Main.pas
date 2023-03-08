unit Frm_Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.StdCtrls, FMX.Layouts, FMX.Controls.Presentation, FMX.Objects,
  FMX.DateTimeCtrls, UThreadExtract, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.Stan.Error, Data.DB,
  FireDAC.Comp.DataSet, inifiles, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, system.DateUtils, FMX.ScrollBox,
  FMX.Memo, Winapi.Windows, FMX.Ani;

type
  TMainFrm = class(TForm)
    TabControl: TTabControl;
    TabMain: TTabItem;
    TabTraitement: TTabItem;
    recTitre: TRectangle;
    lblTitre: TLabel;
    lblExtractTAF: TLabel;
    btnFermer: TButton;
    edtDate: TDateEdit;
    BtnExporter: TButton;
    cbVente: TCheckBox;
    cbEncaissements: TCheckBox;
    cbStock: TCheckBox;
    Rectangle1: TRectangle;
    ProgressBar: TProgressBar;
    lblDate: TLabel;
    lblDateEC: TLabel;
    lblStatus: TLabel;
    lblTitreTraitementAuto: TLabel;
    lblTitreDateDebut: TLabel;
    lblTitreDateFin: TLabel;
    lblDateDebut: TLabel;
    lblDateFin: TLabel;
    lblTitreDateManuel: TLabel;
    lblTitreFichiers: TLabel;
    Image1: TImage;
    lblPourcent: TLabel;
    memLog: TMemo;
    layoutTop: TLayout;
    layoutDateEC: TLayout;
    layoutMemo: TLayout;
    RectAnimation1: TRectAnimation;
    procedure recTitreMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FormCreate(Sender: TObject);
    procedure btnFermerClick(Sender: TObject);
    procedure BtnExporterClick(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtDateChange(Sender: TObject);
  private
    FThreadExtract: TThreadExtract;
    FModeAuto: boolean;
    procedure FinTraitement(Sender: TObject);
    procedure MajIHM(Sender: TObject);
    procedure MajPourcent(Sender: TObject);
  public

  end;

var
  MainFrm: TMainFrm;

implementation

{$R *.fmx}

procedure TMainFrm.BtnExporterClick(Sender: TObject);
var
  lListe: array of TExtractFile;
begin
  if TabControl.ActiveTab = TabMain then
  begin
    SetLength(lListe,0);
    if cbVente.IsChecked then
    begin
      SetLength(lListe,Length(lListe)+1);
      lListe[High(lListe)] := efVentes;
    end;
    if cbEncaissements.IsChecked then
    begin
      SetLength(lListe,Length(lListe)+1);
      lListe[High(lListe)] := efEncaissements;
    end;
    if cbStock.IsChecked then
    begin
      SetLength(lListe,Length(lListe)+1);
      lListe[High(lListe)] := efStocks;
    end;
//    memLog.Lines.Clear;
    memLog.Text := '';
    lblPourcent.TextSettings.FontColor := TAlphaColorRec.Black;
    FThreadExtract.StartManu(edtDate.Date, edtDate.Date, lListe);
    //TabControl.ActiveTab := TabTraitement;
  end
  else if TabControl.ActiveTab = TabTraitement then
  begin
    if FThreadExtract.EnCours then
    begin
      if MessageDlg('Arrêter le traitement en cours ?',TMsgDlgType.mtWarning,[TMsgDlgBtn.mbYes,TMsgDlgBtn.mbNo],0,TMsgDlgBtn.mbNo) = mrYes then
        FThreadExtract.Stop;
    end
    else
    begin
      TabControl.ActiveTab := TabMain;
    end;
  end;
end;

procedure TMainFrm.btnFermerClick(Sender: TObject);
begin
  if {(TabControl.ActiveTab = TabTraitement) or} (FThreadExtract.EnCours) then
  begin
    MessageDlg('Vous ne pouvez pas quitter lorsqu''un traitement est en cours',
      TMsgDlgType.mtWarning,[TMsgDlgBtn.mbOK],0,TMsgDlgBtn.mbOK);
    exit;
  end;
  if MessageDlg('Quitter l''outil ExtractTAF ?',TMsgDlgType.mtConfirmation,[TMsgDlgBtn.mbYes,TMsgDlgBtn.mbNo],0,TMsgDlgBtn.mbYes) = mrYes then
  begin
    Application.Terminate;
  end;
end;

procedure TMainFrm.edtDateChange(Sender: TObject);
begin
  if edtDate.Date > Date then
  begin
    if MessageDlg('Impossible d''extraire à une date postérieure à la date du jour',TMsgDlgType.mtError,[TMsgDlgBtn.mbOK],0) = mrOk then
      edtDate.Date := Date;
  end;
end;

procedure TMainFrm.FinTraitement(Sender: TObject);
begin
  if FModeAuto then
  begin
    Application.Terminate;
  end
  else
  begin
    TabControlChange(nil);
//    BtnExporter.Text := 'Retour';
  end;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
var
  lMajor, lMinor, lBuild: cardinal;
begin
  FModeAuto := false;
  GetProductVersion(ParamStr(0),lMajor,lMinor,lBuild);
  lblExtractTAF.Text := 'ExtractTAF - v '
                        + IntToStr(lMajor) + '.'
                        + IntToStr(lMinor) + '.'
                        + IntToStr(lBuild);
  FThreadExtract := TThreadExtract.Create;
  FThreadExtract.OnFinTraitement := FinTraitement;
  FThreadExtract.OnMajIHM := MajIHM;
  FThreadExtract.OnMajPourcent := MajPourcent;

  TabControl.ActiveTab := TabMain;
  if (FThreadExtract.LastDate = 0) or (FThreadExtract.LastDate = Date) then
    edtDate.Date := Date
  else
    edtDate.Date := IncDay(FThreadExtract.LastDate,1);


  if UpperCase(ParamStr(1)) = 'AUTO' then
  begin
    lblTitre.Text := ' Traitement Automatique';
    FModeAuto := true;
    FThreadExtract.StartAuto;
    //TabControl.ActiveTab := TabTraitement;
  end
  else
  begin
    lblTitre.Text := ' Mode Manuel';
  end;
end;

procedure TMainFrm.FormDestroy(Sender: TObject);
begin
  FThreadExtract.Terminate;
  FThreadExtract.WaitFor;
  FThreadExtract.Free;
end;

procedure TMainFrm.MajIHM(Sender: TObject);
begin
  if FThreadExtract.EnCours and (TabControl.ActiveTab <> TabTraitement) then
    TabControl.ActiveTab := TabTraitement;
  if FThreadExtract.DateEnCours = 0 then
    lblDateEC.Text := ''
  else
    lblDateEC.Text := DateToStr(FThreadExtract.DateEnCours);

  lblDateDebut.Text := DateToStr(FThreadExtract.DateDebut);
  lblDateFin.Text := DateToStr(FThreadExtract.DateFin);
  if not (FThreadExtract.LastDate = Date) then
   edtDate.Date := incDay(FThreadExtract.LastDate,1);

  memLog.Lines.Add(DateTimeToStr(Now) + ' - ' + FThreadExtract.Status);
  if Assigned(memLog.VScrollBar) then
    memLog.VScrollBar.Value := memLog.VScrollBar.Max;
end;

procedure TMainFrm.MajPourcent(Sender: TObject);
begin
  ProgressBar.Value := FThreadExtract.Pourcent;
//  lblPourcent.Text := FormatFloat('#0',ProgressBar.Value) + ' %';
  lblPourcent.Text := IntToStr(FThreadExtract.Pourcent) + ' %';
  if FThreadExtract.Error then
  begin
    lblPourcent.TextSettings.FontColor := TAlphaColorRec.Red;
  end;
end;

procedure TMainFrm.recTitreMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  self.StartWindowDrag;
end;

procedure TMainFrm.TabControlChange(Sender: TObject);
begin
  if TabControl.ActiveTab = TabMain then
  begin
    BtnExporter.Text := 'Exporter';
  end
  else if TabControl.ActiveTab = TabTraitement then
  begin
//    if FModeAuto then
//        lblTitreTraitementAuto.Text := 'Traitement Automatique'
//    else
//      lblTitreTraitementAuto.Text := 'Traitement Manuel';
    if FThreadExtract.EnCours then
    begin
      BtnExporter.Text := 'Annuler';

    end
    else
    begin
      BtnExporter.Text := 'Retour';

    end;
  end;
end;

end.
