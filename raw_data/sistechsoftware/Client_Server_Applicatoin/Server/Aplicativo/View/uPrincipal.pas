unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, uDWAbout, uRESTDWBase, FMX.Edit, FMX.ScrollBox,
  FMX.Memo, FMX.Objects;

type
  TfrmPrincipal = class(TForm)
    Memo1: TMemo;
    GroupBox1: TGroupBox;
    edtPorta: TEdit;
    Label1: TLabel;
    Switch: TSwitch;
    Ativo: TLabel;
    btnReconectar: TSpeedButton;
    Image1: TImage;
    procedure SwitchSwitch(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Log(msg : String);
    procedure btnReconectarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FServicePooler: TRESTServicePooler;
    { Private declarations }
  public
    { Public declarations }
    property ServicePooler : TRESTServicePooler read FServicePooler write FServicePooler;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

uses uDM, ServerUtils, RestServerController;

procedure TfrmPrincipal.btnReconectarClick(Sender: TObject);
begin
  if Switch.IsChecked then
    Switch.IsChecked := False;

  FServicePooler.ServicePort := StrToInt(edtPorta.Text);

  Switch.IsChecked := True;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
//var
//  restServer : TRestServerController;
begin
  FServicePooler                   := TRESTServicePooler.Create(Self);
  FServicePooler.CORS              := True;
  FServicePooler.AuthenticationOptions.AuthorizationOption := ServerUtils.TRDWAuthOption.rdwAONone;
  FServicePooler.ServicePort       := 8084;

  FServicePooler.ServerMethodClass := TDM;
  FServicePooler.Active            := Switch.IsChecked;

  //restServer := TRestServerController.Create;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  edtPorta.Text := FServicePooler.ServicePort.ToString;
end;

procedure TfrmPrincipal.Log(msg: String);
begin
  Memo1.Lines.Add(msg);
end;

procedure TfrmPrincipal.SwitchSwitch(Sender: TObject);
begin
  FServicePooler.Active := Switch.IsChecked;

  if Switch.IsChecked then
  begin
    Ativo.Text := 'ONLINE';
    Ativo.TextSettings.FontColor := TAlphaColorRec.Green;
    Log('Servidor ONLINE');
  end
  else
  begin
    Ativo.Text := 'OFFLINE';
    Ativo.TextSettings.FontColor := TAlphaColorRec.Red;
    Log('Servidor OFFLINE');
  end;
end;

end.
