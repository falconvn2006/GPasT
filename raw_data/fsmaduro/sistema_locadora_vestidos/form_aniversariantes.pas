unit form_aniversariantes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, DBCtrls, DB, IBCustomDataSet, IBQuery,
  RxLookup, untDados, Grids, DBGrids;

type
  TAniversariantesDia = class(TForm)
    lblPergunta: TLabel;
    DBGrid1: TDBGrid;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AniversariantesDia: TAniversariantesDia;

implementation


{$R *.dfm}

procedure TAniversariantesDia.FormShow(Sender: TObject);
begin
  TOP := 0;
  LEFT := 124;
  Height := 572;  
end;

end.
