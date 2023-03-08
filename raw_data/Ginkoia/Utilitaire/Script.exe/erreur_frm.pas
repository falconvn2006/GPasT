unit erreur_frm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls,
  wwcheckbox, RzLabel;

type
  TFrm_Erreur = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Lab_Erreur: TRzLabel;
    Memo_Erreur: TMemo;
    Button1: TButton;
    Memo_Query: TMemo;
    Button2: TButton;
    Chp_Err: TwwCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Erreur: TFrm_Erreur;

implementation

{$R *.DFM}

procedure TFrm_Erreur.Button1Click(Sender: TObject);
begin
  if height<250 then
    height := 376
  else
    height := 202 ;
end;

procedure TFrm_Erreur.FormActivate(Sender: TObject);
begin
    IF ( ParamCount > 0 ) AND ( Uppercase ( ParamStr ( 1 ) ) = 'MANU' ) THEN
    BEGIN
      button2.visible := true ;
    END
end;

end.
