unit frmOrdemServicoConsulta;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmConsulta, Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TformOrdemServicoConsulta = class(TformConsulta)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formOrdemServicoConsulta: TformOrdemServicoConsulta;

implementation

{$R *.dfm}

uses dmOrdemServico;

end.
