unit ControllerTanque;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DaoTanque;

type
  TfrmControllerTanque = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FDaoTanque : TfrmDaoTanque;
  public
    { Public declarations }
    procedure SalvarAbastecimento(sID_Posto, sID_Tanque, sLitro:String);
  end;

var
  frmControllerTanque: TfrmControllerTanque;

implementation

{$R *.dfm}

{ TfrmControllerTanque }

procedure TfrmControllerTanque.FormCreate(Sender: TObject);
begin
  FDaoTanque := TfrmDaoTanque.Create(FDaoTanque);
  FDaoTanque.Visible := False;
end;

procedure TfrmControllerTanque.FormDestroy(Sender: TObject);
begin
  FDaoTanque.Free;
end;

procedure TfrmControllerTanque.SalvarAbastecimento(sID_Posto, sID_Tanque, sLitro:String);
begin
  FDaoTanque.SalvarAbastecimento(sID_Posto, sID_Tanque, sLitro);
end;

end.
