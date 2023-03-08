unit U_Dados;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  U_Biblioteca, U_FormMain, Vcl.Forms;
type

  Tdm_Dados = class(TDataModule)
    fd_Connection: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);

  private
    { Private declarations }

    procedure CarregaBanco;


  public
    { Public declarations }
  end;

var
  dm_Dados: Tdm_Dados;

implementation

uses U_ConfigIni,  Vcl.Dialogs;


{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure Tdm_Dados.CarregaBanco;
begin
  try
    fd_Connection.Params.Values['Database'] := GetArqIni(ExtractFilePath(Application.ExeName)+ 'config.ini', 'CONFIGURACAO','LOCAL_DB');
    fd_Connection.Params.Values['UserName'] := GetArqIni(ExtractFilePath(Application.ExeName)+ 'config.ini', 'CONFIGURACAO','USER');
    fd_Connection.Params.Values['Port']:= GetArqIni(ExtractFilePath(Application.ExeName)+ 'config.ini', 'CONFIGURACAO','PORTA');
    fd_Connection.Params.Values['Password'] := GetArqIni(ExtractFilePath(Application.ExeName)+ 'config.ini', 'CONFIGURACAO','PASSWORD');
    fd_Connection.Connected := True;
  except
    showmessage('Caminho de conexão com banco inválido');
    frm_ConfigIni.showModal;
  end;
end;

procedure Tdm_Dados.DataModuleCreate(Sender: TObject);
begin
  CarregaBanco;
end;

end.
