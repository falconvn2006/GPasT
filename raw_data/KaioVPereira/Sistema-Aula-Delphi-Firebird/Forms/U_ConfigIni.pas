unit U_ConfigIni;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, U_Biblioteca, U_Dados,U_FormMain;

type
  Tfrm_ConfigIni = class(TForm)
    img_bd: TImage;
    txt_localBD: TEdit;
    lb_localBD: TLabel;
    Button1: TButton;
    opn_pastas: TOpenDialog;
    btn_salvar: TButton;
    txt_porta: TEdit;
    txt_server: TEdit;
    txt_usarname: TEdit;
    txt_pass: TEdit;
    lb_username: TLabel;
    lb_port: TLabel;
    lb_servidor: TLabel;
    lb_pass: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure btn_salvarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }

     procedure Configurar;
     procedure SalvaValidaConexao;

  public
    { Public declarations }
  end;

var
  frm_ConfigIni: Tfrm_ConfigIni;

implementation



{$R *.dfm}



procedure Tfrm_ConfigIni.btn_salvarClick(Sender: TObject);
begin
  SalvaValidaConexao;
end;

procedure Tfrm_ConfigIni.Button1Click(Sender: TObject);
begin
  Configurar;

end;


// Procedure para encontrar o caminho do banco e gravar no Tedit.text
procedure Tfrm_ConfigIni.Configurar;
var
  vFileName: String;
begin

  if opn_pastas.Execute then
  begin
    txt_localBD.Text := opn_pastas.FileName;
    vFileName        := ExtractFilePath(application.ExeName) + 'config.ini';
    ArqIni (vFileName,'CONFIGURACAO', 'LOCAL_DB', txt_localBD.Text );
    try
      dm_Dados.fd_Connection.Params.Values['DataBase'] := GetArqIni(ExtractFilePath(Application.ExeName)+ 'config.ini', 'CONFIGURACAO','LOCAL_DB');
    except

  end;

  end;

end;

procedure Tfrm_ConfigIni.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

//Procedure para usar no botãos salvar
procedure Tfrm_ConfigIni.SalvaValidaConexao;
var vFileName : String;
begin
  vFileName        := ExtractFilePath(application.ExeName) + 'config.ini';
  ArqIni (vFileName,'CONFIGURACAO', 'SERVIDOR',txt_server.Text);
  ArqIni (vFileName,'CONFIGURACAO', 'PORTA', txt_porta.Text);
  ArqIni (vFileName,'CONFIGURACAO', 'USER', txt_usarname.Text);
  ArqIni (vFileName,'CONFIGURACAO', 'PASSWORD', txt_pass.Text);

  try
    dm_Dados.fd_Connection.Params.Values['DataBase'] := GetArqIni(ExtractFilePath(Application.ExeName)+ 'config.ini', 'CONFIGURACAO','LOCAL_DB');
    dm_Dados.fd_Connection.Params.Values['UserName'] := GetArqIni(ExtractFilePath(Application.ExeName)+ 'config.ini', 'CONFIGURACAO','USER');
    dm_Dados.fd_Connection.Params.Values['Port']     := GetArqIni(ExtractFilePath(Application.ExeName)+ 'config.ini', 'CONFIGURACAO','PORTA');
    dm_Dados.fd_Connection.Params.Values['Password'] := GetArqIni(ExtractFilePath(Application.ExeName)+ 'config.ini', 'CONFIGURACAO','PASSWORD');
    dm_Dados.fd_Connection.Connected := True;
    showMessage('Conexão feita com sucesso');
    Self.Close;
    //frm_Principal.Create(self);
    //frm_Principal.showmodal
    //
  except
    showmessage('Configuração de banco incorreta, valide as informações e tente novamente');
  end;
end;

end.
