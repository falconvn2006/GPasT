unit Conexao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB;

type
  TfrmConecta = class(TForm)
    Conexao: TADOConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConecta: TfrmConecta;

implementation

{$R *.dfm}

end.
