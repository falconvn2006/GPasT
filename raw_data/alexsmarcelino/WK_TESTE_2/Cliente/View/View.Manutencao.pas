unit View.Manutencao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Dm.Dados, Vcl.ComCtrls,
  Vcl.ToolWin, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls;

type
  TfrmManutencao = class(TForm)
    Panel1: TPanel;
    imgIcone: TImage;
    pnlPrincipal: TPanel;
    ToolBar1: TToolBar;
    tbbSalvar: TToolButton;
    tbbCancelar: TToolButton;
    pnlCrud: TPanel;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    Label5: TLabel;
    DBEdit5: TDBEdit;
    Label6: TLabel;
    DBEdit6: TDBEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Acao : TTipoAcao;
  end;

var
  frmManutencao: TfrmManutencao;

implementation

{$R *.dfm}

uses Dm.Imagens;

procedure TfrmManutencao.FormCreate(Sender: TObject);
begin
  dmImagens.img48.GetIcon(1,imgIcone.Picture.Icon);
end;

end.
