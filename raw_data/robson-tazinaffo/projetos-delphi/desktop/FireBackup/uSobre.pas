unit uSobre;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, RXCtrls;

type
  TFrmSobre = class(TForm)
    RxLabel1: TRxLabel;
    Label1: TLabel;
    Panel1: TPanel;
    SP: TSecretPanel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSobre: TFrmSobre;

implementation

{$R *.dfm}

procedure TFrmSobre.FormCreate(Sender: TObject);
begin
  With SP do
  begin
     Active := True;
     Cycled := True;
     Interval := 40;
  end;
end;

end.
