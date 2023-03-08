unit UChxPeriode;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TChoixPeriode = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    ed_de: TEdit;
    ed_a: TEdit;
    procedure RadioButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    toto : Integer ;
  end;

implementation

{$R *.DFM}

procedure TChoixPeriode.RadioButton1Click(Sender: TObject);
begin
  toto := TRadioButton(sender).tag ;
end;

procedure TChoixPeriode.FormCreate(Sender: TObject);
begin
  toto := 2 ;
end;

end.


