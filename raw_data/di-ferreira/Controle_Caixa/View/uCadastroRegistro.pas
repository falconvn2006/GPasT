unit uCadastroRegistro;

interface

uses
  {(*}
  Winapi.Windows,
  Winapi.Messages,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Mask,
  JvExMask,
  JvToolEdit,
  JvBaseEdits,
  JvExStdCtrls,
  JvEdit,
  JvValidateEdit,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Fnc_Utils,
  uMessage,
  Controle.Caixa.Controller.Manager.Interfaces,
  Controle.Caixa.Controller.Manager,
  DTO.Caixa, System.SysUtils, DM.Main;
  {*)}

type
  TFrmCadastro = class(TForm)
    ContainerMain: TPanel;
    PanelMain: TPanel;
    BtnFechar: TSpeedButton;
    ContainerButton: TPanel;
    btnSalvar: TSpeedButton;
    ContainerTitulo: TPanel;
    LineTitulo: TPanel;
    EdtTitulo: TLabeledEdit;
    CkbEntrada: TCheckBox;
    ContainerValor: TPanel;
    LineValor: TPanel;
    ContainerDTCadastro: TPanel;
    Panel3: TPanel;
    DTCadastro: TDateTimePicker;
    ContainerOBS: TPanel;
    LineOBS: TPanel;
    mObs: TMemo;
    Label2: TLabel;
    EdtValor: TJvCalcEdit;
    Label1: TLabel;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure loadRegistro;
    procedure LimparCampos;
    procedure BtnFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FControllerManager: iControllerManager;
    FCaixa: TCaixa;
  public
    { Public declarations }
    idRegistro: Integer;
    pResult: Boolean;
  end;

var
  FrmCadastro: TFrmCadastro;

implementation

{$R *.dfm}

procedure TFrmCadastro.BtnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmCadastro.btnSalvarClick(Sender: TObject);
begin
  if EdtTitulo.Text = '' then
  begin
    CCShowMessage('Erro ao Salvar', 'Campo requeridos vazios, favor preencher!', tpMessage.tError);
    Exit;
  end;

  if EdtValor.Text = '' then
  begin
    CCShowMessage('Erro ao Salvar', 'Campo requeridos vazios, favor preencher!', tpMessage.tError);
    Exit;
  end;

  FCaixa.TITULO(EdtTitulo.Text)
        .VALOR(StrToCurr(EdtValor.Text))
        .DESCRICAO(mObs.Text)
        .ENTRADA(CkbEntrada.Checked)
        .Usuario(DMMain.currentUser);

  if idRegistro > 0 then
    FControllerManager.Caixa.Update(FCaixa)
  else
    FControllerManager.Caixa.Save(FCaixa);

//  if idRegistro > 0 then
//    DMMain.SalvarRegistro(EdtTitulo.Text, mObs.Text, EdtValor.Value, DTCadastro.DateTime, CkbEntrada.Checked, idRegistro)
//  else
//    DMMain.SalvarRegistro(EdtTitulo.Text, mObs.Text, EdtValor.Value, DTCadastro.DateTime, CkbEntrada.Checked, idRegistro);

  CCShowMessage('Sucesso', 'Registro salvo com sucesso!', tpMessage.tSuccess);
  pResult := true;
  LimparCampos;
  Close;
end;

procedure TFrmCadastro.FormCreate(Sender: TObject);
begin
  FControllerManager := TControllerManager.New;
end;

procedure TFrmCadastro.FormShow(Sender: TObject);
begin
  loadRegistro;
end;

procedure TFrmCadastro.LimparCampos;
begin
  EdtTitulo.Text := '';
  EdtValor.Text := '';
  CkbEntrada.Checked := true;
  mObs.Lines.Clear;
  DTCadastro.DateTime := Date;
end;

procedure TFrmCadastro.loadRegistro;
begin
  if idRegistro < 1 then
  begin
    DTCadastro.Date := Date;
    CkbEntrada.Checked := true;
    FCaixa := TCaixa.Create;
    Exit;
  end;

  FCaixa := FControllerManager.Caixa.FindByID(idRegistro);

  EdtTitulo.Text := FCaixa.TITULO;
  EdtValor.Value := FCaixa.VALOR;
  DTCadastro.Date := StrToDate((formatdatetime('dd/mm/yy', FCaixa.DTENTRADA)));
  mObs.Text := FCaixa.DESCRICAO;
  CkbEntrada.Checked := FCaixa.ENTRADA;
end;

end.

