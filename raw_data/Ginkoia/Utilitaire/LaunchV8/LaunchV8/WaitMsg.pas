unit WaitMsg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel, GinPanel;

type
  TFrmWaitMsg = class(TForm)
    GinPanel1: TGinPanel;
    Lab_Message: TLabel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.dfm}

end.
