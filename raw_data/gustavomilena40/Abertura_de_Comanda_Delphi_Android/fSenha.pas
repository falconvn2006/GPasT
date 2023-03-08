unit fSenha;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Objects;

type
  TFrame1 = class(TFrame)
    PanelSenha: TPanel;
    LbSenha: TLabel;
    EdSenha: TEdit;
    BtSenha: TButton;
    Button1: TButton;
    Rectangle1: TRectangle;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}


end.
