unit UnFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnBurningUtility.Types,IMAPI2_TLB,System.UiTypes,
  Vcl.WinXCtrls, Vcl.ComCtrls,UnBurningUtility, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  Vcl.StdCtrls, dxGDIPlusClasses, Vcl.ExtCtrls, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxImageComboBox;

type
  TForm2 = class(TForm)
    cxGroupBox1: TPanel;
    PBurn: TProgressBar;
    cxLabel1: TLabel;
    LDrive: TLabel;
    CBDriver: TcxImageComboBox;
    cxGroupBox6: TPanel;
    CkCheckFinalFile: TToggleSwitch;
    LstatusCheckFile: TLabel;
    PVerifica: TProgressBar;
    LVerifica: TLabel;
    cxGroupBox14: TPanel;
    cxGroupBox7: TPanel;
    ImgTipoSupporto: TImage;
    LInfoBurn: TLabel;
    BCancel: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BCancelClick(Sender: TObject);
  private
    { Private declarations }
    FBurningTool : TBurningTool;
    FAbort       : Boolean;
    FRunning     : Boolean;
    procedure DoOnProgress(Sender:Tobject;Const SInfo:String;SPosition :Int64;RefreshPosition,aAbort:Boolean;iType:integer;AllowAbort:Boolean);
    procedure DoOnLog(Const aFunctionName,aDescriptionName:String;Level:TpLivLog;IsDebug:Boolean=False);
    procedure CancelBurning;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button2Click(Sender: TObject);
begin
  PBurn.Position := 0;
  FAbort         := False;
  if OpenDialog1.Execute then
  begin

    if FileExists(OpenDialog1.FileName) then
    begin

      if CbDriver.ItemIndex  < 0 then
      begin
        MessageDlg( 'Select one driver',mtWarning,[mbOk],0);
        Exit;
      end;
      LInfoBurn.Caption := 'Start burning...';
      {Evento di progress della masterizzazione}
      FBurningTool.BurningDiskImage(CbDriver.ItemIndex,CBDriver.Properties.Items[CbDriver.ItemIndex].Tag,OpenDialog1.FileName,'DiscTest',CkCheckFinalFile.State=tssON)
    end
    else
    begin
      MessageDlg('Iso file not exists',mtError,[mbOK],0);
    end;  
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FBurningTool                := TBurningTool.Create;
  FBurningTool.OnProgressBurn := DoOnProgress;
  FBurningTool.OnLog          := DoOnLog;
  FBurningTool.BuilcxComboBoxAll(CBDriver.Properties.Items);
end;

Procedure TForm2.CancelBurning;
var iCount : integer;
begin
  Try
    iCount := 0;
    FBurningTool.CancelBurning;
    while FRunning do
    begin
      Inc(iCount);
      if iCount > 1024 then
      begin
        iCount := 0;
        Application.ProcessMessages;
      end;
    end;

  Except on E: Exception do
    {$REGION 'Log'}
    {TSI:IGNORE ON}
      DoOnLog('TFormBurn.CancelBurning',e.Message,tplivException);
    {TSI:IGNORE OFF}
    {$ENDREGION}
  End;
  Close;
end;

procedure TForm2.DoOnProgress(Sender: Tobject; const SInfo: String;
  SPosition: Int64; RefreshPosition, aAbort: Boolean; iType: integer;
  AllowAbort: Boolean);
begin
  LInfoBurn.Caption  := sInfo;
  BCancel.Enabled    := AllowAbort;
  FRunning           := True;
  case iType of
    IMAPI_FORMAT2_DATA_WRITE_ACTION_WRITING_DATA :
        begin
          if RefreshPosition then
          begin
            PBurn.Position := (SPosition);
          end;
        end;

    IMAPI_FORMAT2_DATA_WRITE_ACTION_VERIFYING : PVerifica.Position := SPosition;
  end;

  if FAbort then   
  begin
    FRunning := False;
    PBurn.Position := 0;
  end;

end;

procedure TForm2.DoOnLog(Const aFunctionName,aDescriptionName:String;Level:TpLivLog;IsDebug:Boolean=False);
var aLog : String;
begin
  aLog := Format('%s --> %s',[aFunctionName,aDescriptionName]); 

  if IsDebug then
    aLog := Format('[DEBUG] %s',[aLog]);
  case Level of
    tplivException: Memo1.Lines.add( String('[Exception]').PadRight(12) + aLog);
    tpLivError    : Memo1.Lines.add(String('[Error]').PadRight(12) + aLog);
    tpLivWarning  : Memo1.Lines.add(String('[Warning]').PadRight(12) + aLog);
    tpLivInfo     : Memo1.Lines.add(String('[Info]').PadRight(12) + aLog);
  end;
end;

procedure TForm2.BCancelClick(Sender: TObject);
begin
  CancelBurning;
end;

end.
