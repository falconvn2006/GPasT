unit frmlog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFlog = class(TForm)
    Memo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Fcanclose : boolean ;
  end;

var
  Flog: TFlog;

implementation

{$R *.dfm}

procedure TFlog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := caFree ;
end;

procedure TFlog.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Canclose := Fcanclose ;
end;

procedure TFlog.FormCreate(Sender: TObject);
begin
 Top := 0 ;
 Left := 0 ;
end;

end.
