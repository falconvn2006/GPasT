unit GKEasyComptage.Form.Param;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.DateUtils,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Samples.Spin,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.FileCtrl,
  GKEasyComptage.Methodes;

type
  TFormParam = class(TForm)
    LblRepertoire: TLabel;
    LblJours: TLabel;
    LblJours2: TLabel;
    TxtRepertoire: TEdit;
    BtnRepertoire: TBitBtn;
    PnlBoutons: TPanel;
    LblInformation: TLabel;
    LblIconeInfo: TLabel;
    BtnOk: TBitBtn;
    BtnAnnuler: TBitBtn;
    SpnJours: TSpinEdit;
    SpnPeriodicite: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    rgType: TRadioGroup;
    GroupBox1: TGroupBox;
    BtnTachePlanifiee: TButton;
    Label2: TLabel;
    DtpDemarrage: TDateTimePicker;
    Label1: TLabel;
    DtpArret: TDateTimePicker;
    Button1: TButton;
    GroupBox2: TGroupBox;
    edtFtpUrl: TEdit;
    Label5: TLabel;
    edtFtpLogin: TEdit;
    Label6: TLabel;
    edtFtpMdp: TEdit;
    Label7: TLabel;
    edtFtpDossier: TEdit;
    Label8: TLabel;
    chkFtpActif: TCheckBox;
    procedure BtnRepertoireClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnTachePlanifieeClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FormParam: TFormParam;

implementation

{$R *.dfm}

procedure TFormParam.BtnRepertoireClick(Sender: TObject);
var
  sDossier: string;
begin
  sDossier := TxtRepertoire.Text;
  if SelectDirectory('', '', sDossier,
    [sdNewFolder, sdShowEdit, sdShowShares, sdNewUI, sdValidateDir], Self) then
    TxtRepertoire.Text  := sDossier;
end;

procedure TFormParam.BtnTachePlanifieeClick(Sender: TObject);
begin
    CreerDemarrageAuto();
end;

procedure TFormParam.Button1Click(Sender: TObject);
begin
    try
      SupprimeTachePlanifiee();
      CreerTachePlanifiee(DtpDemarrage.Time);
    Except On E:Exception do
      begin
         Showmessage(E.Message);
      end;
      // -----
    end;
end;

procedure TFormParam.FormCreate(Sender: TObject);
begin
  LblIconeInfo.Visible    := FindCmdLineSwitch('PARAM');
  LblInformation.Visible  := FindCmdLineSwitch('PARAM');
end;

end.
