unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn;

type
  TPreStartMentalTest = class(TForm)
    sBitBtn3: TsBitBtn;
    sBitBtn1: TsBitBtn;
    Label1: TLabel;
    procedure sBitBtn1Click(Sender: TObject);
    procedure sBitBtn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PreStartMentalTest: TPreStartMentalTest;

implementation
     uses Unit3;
{$R *.dfm}

procedure TPreStartMentalTest.sBitBtn1Click(Sender: TObject);
begin
Close;
end;

procedure TPreStartMentalTest.sBitBtn3Click(Sender: TObject);
begin
    AbilitiesTest.ShowModal;
    AbilitiesTest.Label2.Caption:='600';
    //AbilitiesTest.Timer1.Enabled:=true;
    AbilitiesTest.sBitBtn1.Visible:=true;
    AbilitiesTest.sBitBtn3.Visible:=false;
    AbilitiesTest.sBitBtn4.Visible:=true;
    AbilitiesTest.Label21.Caption:='0';
    AbilitiesTest.Label22.Caption:='1';
    AbilitiesTest.Label23.Caption:='0';
    AbilitiesTest.Label25.Caption:='0';
end;

end.
