unit UnitPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Data.DB, Data.Win.ADODB;

type
  TfmrPrincipal = class(TForm)
    Shape1: TShape;
    MainMenu1: TMainMenu;
    mmCadUsuario: TMenuItem;
    mmCadProdutos: TMenuItem;
    mmCadastro: TMenuItem;
    imgLogo: TImage;
    mmCadFornecedores: TMenuItem;
    mmEntrada: TMenuItem;
    mmSaida: TMenuItem;
    mmEntradaProd: TMenuItem;
    mmSaidaProd: TMenuItem;
    Consulta1: TMenuItem;
    Produtos1: TMenuItem;
    mmpdv: TMenuItem;
    mmtelapdv: TMenuItem;
    procedure mmCadUsuarioClick(Sender: TObject);
    procedure mmCadFornecedoresClick(Sender: TObject);
    procedure mmCadProdutosClick(Sender: TObject);
    procedure mmEntradaProdClick(Sender: TObject);
    procedure mmSaidaProdClick(Sender: TObject);
    procedure Produtos1Click(Sender: TObject);
    procedure mmtelapdvclick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmrPrincipal: TfmrPrincipal;

implementation

{$R *.dfm}

uses UnitCadUsuario, UnitFornecedor, UnitProduto, tlconsul, UnitTelaSaida,
  UnitConsulta, unit2;

procedure TfmrPrincipal.mmCadFornecedoresClick(Sender: TObject);
begin
fmrfornecedor.showmodal;
end;

procedure TfmrPrincipal.mmCadProdutosClick(Sender: TObject);
begin
fmrProduto.ShowModal;
end;

procedure TfmrPrincipal.mmCadUsuarioClick(Sender: TObject);
begin
fmrCadUsuario.showmodal;
end;

procedure TfmrPrincipal.mmEntradaProdClick(Sender: TObject);
begin
fmrentrada.showmodal;
end;

procedure TfmrPrincipal.mmSaidaProdClick(Sender: TObject);
begin
fmrsaida.showmodal;
end;

procedure TfmrPrincipal.mmtelapdvClick(Sender: TObject);
begin
TelaPDV.showmodal;
end;

procedure TfmrPrincipal.Produtos1Click(Sender: TObject);
  begin
  fmrconsulta.ADOQueryBProduto.Close;
  fmrconsulta.ADOQueryBProduto.sql.clear;
  fmrconsulta.ADOQueryBProduto.SQL.Add('select * from produto for update');
  fmrconsulta.ADOQueryBProduto.Open;
  fmrconsulta.showmodal;
  end;

end.
