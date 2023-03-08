unit ExtractDatabase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, jpeg, ExtCtrls;

type
  TFrm_ExtractDatabase = class(TAlgolDialogForm)
    Img_Sp2K: TImage;
    Img_Ginkoia: TImage;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_ExtractDatabase: TFrm_ExtractDatabase;

implementation

{$R *.dfm}

end.
