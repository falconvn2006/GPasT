unit uCadUsuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, DM.Main, Vcl.ExtCtrls, Vcl.Buttons, Fnc_Utils, uMessage,
  DTO.Usuario, Controle.Caixa.Controller.Manager.Interfaces,
  Controle.Caixa.Controller.Manager;

type
  TFrmCadUser = class(TForm)
    CkbAdmin: TCheckBox;
    BtnFechar: TSpeedButton;
    ContainerButton: TPanel;
    BtnSalvar: TSpeedButton;
    ContainerName: TPanel;
    Panel4: TPanel;
    EdtNome: TLabeledEdit;
    PanelMain: TPanel;
    ContainerSenha: TPanel;
    Panel2: TPanel;
    EdtSenha: TLabeledEdit;
    ContainerMain: TPanel;
    procedure FormShow(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    FControllerManager: iControllerManager;
    FUsuario: TUsuario;
    procedure LimparCampos;
    procedure SaveOrUpdate;
  public
    idUser: Integer;
    pResult: Boolean;
  end;

var
  FrmCadUser: TFrmCadUser;

implementation

{$R *.dfm}

procedure TFrmCadUser.BtnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmCadUser.btnSalvarClick(Sender: TObject);
begin
  SaveOrUpdate;
  pResult := true;
  LimparCampos;
  Close;
end;

procedure TFrmCadUser.FormCreate(Sender: TObject);
begin
  FControllerManager := TControllerManager.New;
end;

procedure TFrmCadUser.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TFrmCadUser.FormShow(Sender: TObject);
begin
  if idUser <= 0 then
  begin
    FUsuario := TUsuario.Create;
    FUsuario.ID(0);
    Exit;
  end;

  FUsuario := FControllerManager.Usuario.FindByID(idUser);
  EdtNome.Text := FUsuario.NOME;
  CkbAdmin.Checked := FUsuario.ADMIN;
end;

procedure TFrmCadUser.LimparCampos;
begin
  EdtNome.Text := '';
  EdtSenha.Text := '';
  CkbAdmin.Checked := False;
end;

procedure TFrmCadUser.SaveOrUpdate;
begin
  FUsuario.NOME(EdtNome.Text).SENHA(EdtSenha.Text).ADMIN(CkbAdmin.Checked.ToInteger);

  if FUsuario.NOME = '' then
  begin
    CCShowMessage('Erro ao Salvar', 'Campo requeridos vazios, favor preencher!', tpMessage.tError);
    Exit;
  end;

  if FUsuario.ID > 0 then
  begin
    FControllerManager.Usuario.Update(FUsuario);
    CCShowMessage('Sucesso', 'Registro salvo com sucesso!', tpMessage.tSuccess);
  end
  else
  begin
    if FUsuario.SENHA = '' then
    begin
      CCShowMessage('Erro ao Salvar', 'Campo requeridos vazios, favor preencher!', tpMessage.tError);
      Exit;
    end;

    FControllerManager.Usuario.Save(FUsuario);
    CCShowMessage('Sucesso', 'Registro salvo com sucesso!', tpMessage.tSuccess);
  end;

end;

end.

