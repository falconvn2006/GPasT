unit Load_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, StdCtrls, AdvGlowButton, ExtCtrls, RzPanel,
  ComCtrls, GinkoiaStyle_Dm, Buttons;

type
  TFrm_Load = class(TForm)
    pb_EtatArt: TProgressBar;
    Pan_Bottom: TRzPanel;
    lbl_Titre: TLabel;
    lbl_Clients: TLabel;
    Lab_EtatCli1: TLabel;
    Lab_EtatArt2: TLabel;
    lbl_RefArticle: TLabel;
    Lab_EtatHis1: TLabel;
    lbl_Historiques: TLabel;
    img_Clients: TImage;
    img_RefArticle: TImage;
    img_Historiques: TImage;
    Lab_EtatCli2: TLabel;
    Lab_EtatHis2: TLabel;
    Lab_EtatArt1: TLabel;
    pb_EtatCli: TProgressBar;
    pb_EtatHis: TProgressBar;
    Lab_ErrCli: TLabel;
    Btn_ErrCli: TAdvGlowButton;
    Lab_ErrArt: TLabel;
    Btn_ErrArt: TAdvGlowButton;
    Lab_ErrHis: TLabel;
    Btn_ErrHis: TAdvGlowButton;
    Nbt_StopRecal: TBitBtn;
    LabelBonRapprochement: TLabel;
    Lab_EtatBonR1: TLabel;
    img_BonRapprochement: TImage;
    Lab_EtatBonR2: TLabel;
    Lab_ErrBonR: TLabel;
    pb_EtatBonR: TProgressBar;
    Btn_ErrBonR: TAdvGlowButton;
    img_Atelier: TImage;
    LabelAtelier: TLabel;
    Lab_ErrAtelier: TLabel;
    Btn_ErrAtelier: TAdvGlowButton;
    Lab_EtatAtelier1: TLabel;
    Lab_EtatAtelier2: TLabel;
    pb_EtatAtelier: TProgressBar;

    procedure AlgolDialogFormClose(Sender: TObject; var Action: TCloseAction);
    procedure AlgolDialogFormCreate(Sender: TObject);
    procedure Btn_ErrArtClick(Sender: TObject);
    procedure Btn_ErrCliClick(Sender: TObject);
    procedure Btn_ErrHisClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Nbt_StopRecalClick(Sender: TObject);
    procedure Btn_ErrBonRClick(Sender: TObject);
    procedure Btn_ErrAtelierClick(Sender: TObject);

  private
    sErreurCli: string;
    sErreurArt: string;
    sErreurHis: string;
    sErreurBonR: String;
    sErreurAtelier: String;

    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;

  public
    bStopRecal: boolean;
    bBackupRestore: boolean;
    OkFermer: boolean;

    procedure DoInit(AEtatCli, AEtatArt, AEtatHisto, AEtatBonR, AEtatAtelier: Integer);
    procedure DoErreurCli(AErreur: string);
    procedure DoErreurArt(AErreur: string);
    procedure DoErreurHis(AErreur: string);
    procedure DoErreurBonR(AErreur: String);
    procedure DoErreurAtelier(AErreur: String);
    procedure DoCanStopRecal(bOk: boolean);
    procedure Rafraichir;
  end;

var
  Frm_Load: TFrm_Load;

implementation

Uses Main_Frm;

{$R *.dfm}

{ TFrm_Load }

procedure TFrm_Load.WMSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType = SC_MINIMIZE then
  begin
    Msg.Result := 1;
    Application.Minimize;
    Application.ProcessMessages;
    exit;
  end;
  inherited;
end;

procedure TFrm_Load.AlgolDialogFormCreate(Sender: TObject);
begin
  Nbt_StopRecal.Enabled := true;
  Nbt_StopRecal.Visible := false;
  bStopRecal := false;
  bBackupRestore := false;
  OkFermer := true;
  sErreurCli := '';
  sErreurArt := '';
  sErreurHis := '';
  sErreurBonR := '';
  sErreurAtelier := '';
  Lab_ErrCli.Visible := false;
  Btn_ErrCli.Visible := false;
  Lab_ErrArt.Visible := false;
  Btn_ErrArt.Visible := false;
  Lab_ErrHis.Visible := false;
  Btn_ErrHis.Visible := false;
  Lab_ErrBonR.Visible := False;
  Btn_ErrBonR.Visible := False;
  Lab_ErrAtelier.Visible := False;
  Btn_ErrAtelier.Visible := False;
end;

procedure TFrm_Load.Btn_ErrArtClick(Sender: TObject);
begin
  if sErreurArt<>'' then
    MessageDlg(sErreurArt, mterror, [mbok],0);
end;

procedure TFrm_Load.Btn_ErrCliClick(Sender: TObject);
begin
  if sErreurCli<>'' then
    MessageDlg(sErreurCli, mterror, [mbok],0);
end;

procedure TFrm_Load.Btn_ErrHisClick(Sender: TObject);
begin
  if sErreurHis<>'' then
    MessageDlg(sErreurHis, mterror, [mbok],0);
end;

procedure TFrm_Load.Btn_ErrBonRClick(Sender: TObject);
begin
  if sErreurBonR <> '' then
    MessageDlg(sErreurBonR, mterror, [mbok],0);
end;

procedure TFrm_Load.Btn_ErrAtelierClick(Sender: TObject);
begin
  if sErreurAtelier <> '' then
    MessageDlg(sErreurAtelier, mterror, [mbok],0);
end;

procedure TFrm_Load.DoInit(AEtatCli, AEtatArt, AEtatHisto, AEtatBonR, AEtatAtelier: Integer);
begin
  Nbt_StopRecal.Enabled := true;
  Nbt_StopRecal.Visible := false;
  bStopRecal := false;
  bBackupRestore := false;
  sErreurCli := '';
  sErreurArt := '';
  sErreurHis := '';
  sErreurBonR := '';
  sErreurAtelier := '';
  Lab_ErrCli.Visible := false;
  Btn_ErrCli.Visible := false;
  Lab_ErrArt.Visible := false;
  Btn_ErrArt.Visible := false;
  Lab_ErrHis.Visible := false;
  Btn_ErrHis.Visible := false;
  Lab_ErrBonR.Visible := False;
  Btn_ErrBonR.Visible := False;
  Lab_ErrAtelier.Visible := False;
  Btn_ErrAtelier.Visible := False;

  if (AEtatCli=-1) then
    Lab_EtatCli1.Caption := 'Non lancé'
  else
    Lab_EtatCli1.Caption := 'En Attente';
  Lab_EtatCli2.Caption := '';
  pb_EtatCli.Position := 0;

  if (AEtatArt=-1) then
    Lab_EtatArt1.Caption := 'Non lancé'
  else
    Lab_EtatArt1.Caption := 'En Attente';
  Lab_EtatArt2.Caption := '';
  pb_EtatArt.Position := 0;

  if (AEtatHisto=-1) then
    Lab_EtatHis1.Caption := 'Non lancé'
  else
    Lab_EtatHis1.Caption := 'En Attente';
  Lab_EtatHis2.Caption := '';
  pb_EtatHis.Position := 0;

  if(AEtatBonR = -1) then
    Lab_EtatBonR1.Caption := 'Non lancé'
  else
    Lab_EtatBonR1.Caption := 'En Attente';
  Lab_EtatBonR2.Caption := '';
  pb_EtatBonR.Position := 0;

  if(AEtatAtelier = -1) then
    Lab_EtatAtelier1.Caption := 'Non lancé'
  else
    Lab_EtatAtelier1.Caption := 'En Attente';
  Lab_EtatAtelier2.Caption := '';
  pb_EtatAtelier.Position := 0;
end;

procedure TFrm_Load.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := OkFermer;
  if not(OkFermer) then
  begin
    Application.Minimize;
    Application.ProcessMessages;
  end;
end;

procedure TFrm_Load.Nbt_StopRecalClick(Sender: TObject);
var
  LRet: integer;
begin
  lret := MessageDlg('Voulez-vous faire un backup-restore ?', mtConfirmation, [mbyes, mbno, mbCancel],0, mbno);
  case lret of
    mryes:
    begin
      bBackupRestore := true;
      Nbt_StopRecal.Enabled := false;
      bStopRecal := true;
    end;
    mrno:
    begin
      bBackupRestore := false;
      Nbt_StopRecal.Enabled := false;
      bStopRecal := true;
    end;
    mrCancel: exit;
  end;
end;

procedure TFrm_Load.AlgolDialogFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Frm_Main.Enabled := True;
end;

procedure TFrm_Load.DoErreurCli(AErreur: string);
begin
  Lab_ErrCli.Visible := true;
  Btn_ErrCli.Visible := true;
  sErreurCli := AErreur;
  OkFermer := true;
end;

procedure TFrm_Load.DoCanStopRecal(bOk: boolean);
begin
  Nbt_StopRecal.Visible := bOk;
end;

procedure TFrm_Load.DoErreurArt(AErreur: string);
begin
  sErreurArt := AErreur;
  Lab_ErrArt.Visible := true;
  Btn_ErrArt.Visible := true;
  OkFermer := true;
end;

procedure TFrm_Load.DoErreurHis(AErreur: string);
begin
  sErreurHis := AErreur;
  Lab_ErrHis.Visible := true;
  Btn_ErrHis.Visible := true;
  OkFermer := true;
end;

procedure TFrm_Load.DoErreurBonR(AErreur: String);
begin
  sErreurBonR := AErreur;
  Lab_ErrBonR.Visible := True;
  Btn_ErrBonR.Visible := True;
  OkFermer := True;
end;

procedure TFrm_Load.DoErreurAtelier(AErreur: String);
begin
  sErreurAtelier := AErreur;
  Lab_ErrAtelier.Visible := True;
  Btn_ErrAtelier.Visible := True;
  OkFermer := True;
end;

procedure TFrm_Load.Rafraichir;
begin
  Refresh;
  Application.ProcessMessages;
end;

end.

