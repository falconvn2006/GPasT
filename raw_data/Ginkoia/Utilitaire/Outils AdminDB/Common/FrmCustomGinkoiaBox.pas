unit FrmCustomGinkoiaBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaForm, cxPropertiesStore, StdCtrls, Buttons, ExtCtrls;

type
  TCustomGinkoiaBoxFrm = class(TCustomGinkoiaFormFrm)
    pnlBottom: TPanel;
    BtBtnClose: TBitBtn;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  CustomGinkoiaBoxFrm: TCustomGinkoiaBoxFrm;

implementation

{$R *.dfm}

end.
