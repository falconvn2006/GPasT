unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Abastecer, Tanque, Imposto,
  Relatorio;

type
  TfrmPrincipal = class(TForm)
    pnPrincipal: TPanel;
    Label1: TLabel;
    btAbastecer: TButton;
    btRelatorio: TButton;
    btAtlImposto: TButton;
    btTanque: TButton;
    lbNomePosto: TLabel;
    procedure btAbastecerClick(Sender: TObject);
    procedure btAtlImpostoClick(Sender: TObject);
    procedure btTanqueClick(Sender: TObject);
    procedure btRelatorioClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ID_Posto:string;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.btAbastecerClick(Sender: TObject);
begin
    Application.CreateForm(TfrmAbastecer,frmAbastecer);
    try
      frmAbastecer.ID_Posto := ID_Posto;
      frmAbastecer.ShowModal;
    finally
      FreeAndNil(frmAbastecer);
    end;
end;

procedure TfrmPrincipal.btAtlImpostoClick(Sender: TObject);
begin
    Application.CreateForm(TfrmImposto,frmImposto);
    try
      frmImposto.ShowModal;
    finally
      FreeAndNil(frmImposto);
    end;
end;

procedure TfrmPrincipal.btRelatorioClick(Sender: TObject);
begin
    Application.CreateForm(TfrmRelatorio,frmRelatorio);
    try
      frmRelatorio.ShowModal;
    finally
      FreeAndNil(frmRelatorio);
    end;
end;

procedure TfrmPrincipal.btTanqueClick(Sender: TObject);
begin
    Application.CreateForm(TfrmTanque,frmTanque);
    try
      frmTanque.ID_Posto := ID_Posto;
      frmTanque.ShowModal;
    finally
      FreeAndNil(frmTanque);
    end;
end;

end.
