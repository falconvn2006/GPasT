unit POS02;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfrmCalc = class(TForm)
    bt7: TSpeedButton;
    lbTotal: TStaticText;
    bt4: TSpeedButton;
    bt1: TSpeedButton;
    bt0: TSpeedButton;
    bt8: TSpeedButton;
    bt5: TSpeedButton;
    bt2: TSpeedButton;
    btpunto: TSpeedButton;
    bt9: TSpeedButton;
    bt6: TSpeedButton;
    bt3: TSpeedButton;
    btigual: TSpeedButton;
    btborra: TSpeedButton;
    SpeedButton15: TSpeedButton;
    procedure SpeedButton15Click(Sender: TObject);
    procedure bt7Click(Sender: TObject);
    procedure bt8Click(Sender: TObject);
    procedure bt9Click(Sender: TObject);
    procedure bt4Click(Sender: TObject);
    procedure bt5Click(Sender: TObject);
    procedure bt6Click(Sender: TObject);
    procedure bt1Click(Sender: TObject);
    procedure bt2Click(Sender: TObject);
    procedure bt3Click(Sender: TObject);
    procedure bt0Click(Sender: TObject);
    procedure btigualClick(Sender: TObject);
    procedure btborraClick(Sender: TObject);
    procedure btpuntoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    Total : double;
    LetraTotal : string;
    procedure calcular(valor : string);
  end;

var
  frmCalc: TfrmCalc;

implementation

{$R *.dfm}

procedure TfrmCalc.calcular(valor : string);
begin
  if (valor = '.') and (pos('.',lbTotal.Caption)>0) then valor := ''; 
  LetraTotal := LetraTotal + valor;
  total := strtofloat(LetraTotal);
  lbTotal.Caption := FloatToStr(total);
end;

procedure TfrmCalc.SpeedButton15Click(Sender: TObject);
begin
  LetraTotal := '0';
  lbTotal.Caption := '0';
  Total := 0;
end;

procedure TfrmCalc.bt7Click(Sender: TObject);
begin
  calcular('7');
end;

procedure TfrmCalc.bt8Click(Sender: TObject);
begin
  calcular('8');
end;

procedure TfrmCalc.bt9Click(Sender: TObject);
begin
  calcular('9');
end;

procedure TfrmCalc.bt4Click(Sender: TObject);
begin
  calcular('4');
end;

procedure TfrmCalc.bt5Click(Sender: TObject);
begin
  calcular('5');
end;

procedure TfrmCalc.bt6Click(Sender: TObject);
begin
  calcular('6');
end;

procedure TfrmCalc.bt1Click(Sender: TObject);
begin
  calcular('1');
end;

procedure TfrmCalc.bt2Click(Sender: TObject);
begin
  calcular('2');
end;

procedure TfrmCalc.bt3Click(Sender: TObject);
begin
  calcular('3');
end;

procedure TfrmCalc.bt0Click(Sender: TObject);
begin
  calcular('0');
end;

procedure TfrmCalc.btigualClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCalc.btborraClick(Sender: TObject);
begin
  if Length(LetraTotal) > 0 then
    Delete(LetraTotal,length(LetraTotal),1);

  if Length(LetraTotal) = 0 then
    LetraTotal := '0';

  total := strtofloat(LetraTotal);
  lbTotal.Caption := FloatToStr(total);
end;

procedure TfrmCalc.btpuntoClick(Sender: TObject);
begin
  calcular('.');
end;

procedure TfrmCalc.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then close;
end;

end.
