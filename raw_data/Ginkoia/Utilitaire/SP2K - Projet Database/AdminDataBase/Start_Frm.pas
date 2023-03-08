unit Start_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel;

type
  TFrm_Start = class(TForm)
    Pan_fond: TRzPanel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_Start: TFrm_Start;

implementation

{$R *.dfm}

end.
