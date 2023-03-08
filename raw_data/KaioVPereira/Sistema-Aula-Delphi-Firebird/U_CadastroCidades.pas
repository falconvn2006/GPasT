unit U_CadastroCidades;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, U_FormMain, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls;

type
  Tfrm_CadatroCidade = class(Tfrm_Principal)
    fd_QueryCadastroCONTROLE_CIDADE: TFDAutoIncField;
    fd_QueryCadastroNOME: TStringField;
    fd_QueryCadastroUF: TStringField;
    Label1: TLabel;
    txt_controle: TDBEdit;
    Label2: TLabel;
    txt_nomecidade: TDBEdit;
    Label3: TLabel;
    txt_UF: TDBEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_CadatroCidade: Tfrm_CadatroCidade;

implementation

{$R *.dfm}

end.
