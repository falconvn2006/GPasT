unit U_CadastroEstados;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, U_FormMain, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls;

type
  Tfrm_CadastrosEstados = class(Tfrm_Principal)
    fd_QueryCadastroCONTROLE_ESTADO: TFDAutoIncField;
    fd_QueryCadastroNOME: TStringField;
    Label1: TLabel;
    txt_controle: TDBEdit;
    Label2: TLabel;
    txt_nome: TDBEdit;
    fd_QueryCadastroUF: TStringField;
    Label3: TLabel;
    txt_UF: TDBEdit;
    procedure btn_gravarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_CadastrosEstados: Tfrm_CadastrosEstados;

implementation

{$R *.dfm}

procedure Tfrm_CadastrosEstados.btn_gravarClick(Sender: TObject);
begin

  if txt_UF.Text = '' then
  begin
    showmessage ('O Valor da UF não foi informado');
  end

  else if txt_nome.Text = '' then
  begin
    showmessage ('O nome do estado não foi informado');
  end

  else
  begin
   inherited;
  end;


end;

end.
