unit ControllerAbastecer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DaoAbastecimento;

type
  TfrmControllerAbastecer = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FDaoAbastecimento:TfrmDaoAbastecimento;
  public
    { Public declarations }
    procedure SalvarAbastecimento(sID_Posto, sID_Bomba, sLitro, sValorLitro, sValorImposto, sValor, sData, sID_Tanque:String);
  end;

var
  frmControllerAbastecer: TfrmControllerAbastecer;

implementation

{$R *.dfm}

{ TfrmControllerAbastecer }

procedure TfrmControllerAbastecer.FormCreate(Sender: TObject);
begin
  FDaoAbastecimento := TfrmDaoAbastecimento.Create(FDaoAbastecimento);
  FDaoAbastecimento.Visible := False;
end;

procedure TfrmControllerAbastecer.FormDestroy(Sender: TObject);
begin
  FDaoAbastecimento.Free;
end;

procedure TfrmControllerAbastecer.SalvarAbastecimento(sID_Posto, sID_Bomba,
  sLitro, sValorLitro, sValorImposto, sValor, sData, sID_Tanque: String);
begin
  FDaoAbastecimento.SalvarAbastecimento(sID_Posto, sID_Bomba,
  sLitro, sValorLitro, sValorImposto, sValor, sData, sID_Tanque);
end;

end.
