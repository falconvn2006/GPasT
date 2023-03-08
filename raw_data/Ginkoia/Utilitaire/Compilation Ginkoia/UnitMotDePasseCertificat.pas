unit UnitMotDePasseCertificat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TFrmMotDePasseCertificat = class(TForm)
    Img_MotDePasse: TImage;
    Nbt_Ok: TBitBtn;
    Nbt_Annuler: TBitBtn;
    EditMotDePasse: TLabeledEdit;

    procedure FormShow(Sender: TObject);

  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FrmMotDePasseCertificat: TFrmMotDePasseCertificat;

implementation

{$R *.dfm}

procedure TFrmMotDePasseCertificat.FormShow(Sender: TObject);
begin
  EditMotDePasse.SetFocus;
end;

end.
