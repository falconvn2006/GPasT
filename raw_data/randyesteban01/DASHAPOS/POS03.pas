unit POS03;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  TfrmAcceso = class(TForm)
    edclave: TEdit;
    bt7: TSpeedButton;
    bt4: TSpeedButton;
    bt1: TSpeedButton;
    bt8: TSpeedButton;
    bt5: TSpeedButton;
    bt2: TSpeedButton;
    bt9: TSpeedButton;
    bt6: TSpeedButton;
    bt3: TSpeedButton;
    btborra: TSpeedButton;
    bt0: TSpeedButton;
    btpunto: TSpeedButton;
    SpeedButton15: TSpeedButton;
    btigual: TSpeedButton;
    btast: TSpeedButton;
    btmenos: TSpeedButton;
    btmas: TSpeedButton;
    lbtitulo: TLabel;
    Image1: TImage;
    procedure SpeedButton15Click(Sender: TObject);
    procedure btborraClick(Sender: TObject);
    procedure bt7Click(Sender: TObject);
    procedure bt8Click(Sender: TObject);
    procedure bt9Click(Sender: TObject);
    procedure btastClick(Sender: TObject);
    procedure bt4Click(Sender: TObject);
    procedure bt5Click(Sender: TObject);
    procedure bt6Click(Sender: TObject);
    procedure btmenosClick(Sender: TObject);
    procedure bt1Click(Sender: TObject);
    procedure bt2Click(Sender: TObject);
    procedure bt3Click(Sender: TObject);
    procedure btmasClick(Sender: TObject);
    procedure bt0Click(Sender: TObject);
    procedure btpuntoClick(Sender: TObject);
    procedure btigualClick(Sender: TObject);
    procedure edclaveKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    LetraTotal : string;
    acepto : integer;
    procedure calcular(valor : string);
  end;

var
  frmAcceso: TfrmAcceso;

implementation

{$R *.dfm}

{ TfrmAcceso }

procedure TfrmAcceso.calcular(valor: string);
begin
  LetraTotal := LetraTotal + valor;
  edclave.Text := LetraTotal;
end;

procedure TfrmAcceso.SpeedButton15Click(Sender: TObject);
begin
  LetraTotal := '';
  edclave.Text := '';
end;

procedure TfrmAcceso.btborraClick(Sender: TObject);
begin
  if Length(LetraTotal) > 0 then
    Delete(LetraTotal,length(LetraTotal),1);

  if Length(LetraTotal) = 0 then
    LetraTotal := '';

  edclave.Text := LetraTotal;
end;

procedure TfrmAcceso.bt7Click(Sender: TObject);
begin
  calcular('7');
end;

procedure TfrmAcceso.bt8Click(Sender: TObject);
begin
  calcular('8');
end;

procedure TfrmAcceso.bt9Click(Sender: TObject);
begin
  calcular('9');
end;

procedure TfrmAcceso.btastClick(Sender: TObject);
begin
  calcular('*');
end;

procedure TfrmAcceso.bt4Click(Sender: TObject);
begin
  calcular('4');
end;

procedure TfrmAcceso.bt5Click(Sender: TObject);
begin
  calcular('5');
end;

procedure TfrmAcceso.bt6Click(Sender: TObject);
begin
  calcular('6');
end;

procedure TfrmAcceso.btmenosClick(Sender: TObject);
begin
  calcular('-');
end;

procedure TfrmAcceso.bt1Click(Sender: TObject);
begin
  calcular('1');
end;

procedure TfrmAcceso.bt2Click(Sender: TObject);
begin
  calcular('2');
end;

procedure TfrmAcceso.bt3Click(Sender: TObject);
begin
  calcular('3');
end;

procedure TfrmAcceso.btmasClick(Sender: TObject);
begin
  calcular('+');
end;

procedure TfrmAcceso.bt0Click(Sender: TObject);
begin
  calcular('0');
end;

procedure TfrmAcceso.btpuntoClick(Sender: TObject);
begin
  calcular('.');
end;

procedure TfrmAcceso.btigualClick(Sender: TObject);
begin
  Acepto := 1;
  Close;
end;

procedure TfrmAcceso.edclaveKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    btigualClick(Self);
    key := #0;
  end;
end;

procedure TfrmAcceso.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
  begin
    Acepto := 0;
    Close;
    key := #0;
  end;
end;

procedure TfrmAcceso.FormCreate(Sender: TObject);
begin
  acepto := 0;
end;

end.
