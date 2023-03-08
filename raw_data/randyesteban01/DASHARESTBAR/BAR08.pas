unit BAR08;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmSeleccionaCategoria = class(TForm)
    pncat2: TPanel;
    lbcat2: TStaticText;
    pncat1: TPanel;
    lbcat1: TStaticText;
    pncat3: TPanel;
    lbcat3: TStaticText;
    pncat4: TPanel;
    lbcat4: TStaticText;
    pncat6: TPanel;
    lbcat6: TStaticText;
    pncat5: TPanel;
    lbcat5: TStaticText;
    pncat7: TPanel;
    lbcat7: TStaticText;
    pncat8: TPanel;
    lbcat8: TStaticText;
    pncat10: TPanel;
    lbcat10: TStaticText;
    pncat9: TPanel;
    lbcat9: TStaticText;
    pncat11: TPanel;
    lbcat11: TStaticText;
    pncat12: TPanel;
    lbcat12: TStaticText;
    pncat14: TPanel;
    lbcat14: TStaticText;
    pncat13: TPanel;
    lbcat13: TStaticText;
    pncat15: TPanel;
    lbcat15: TStaticText;
    pncat16: TPanel;
    lbcat16: TStaticText;
    pncat17: TPanel;
    lbcat17: TStaticText;
    pncat18: TPanel;
    lbcat18: TStaticText;
    pncat19: TPanel;
    lbcat19: TStaticText;
    pncat21: TPanel;
    lbcat21: TStaticText;
    pncat20: TPanel;
    lbcat20: TStaticText;
    pncat22: TPanel;
    lbcat22: TStaticText;
    pncat23: TPanel;
    lbcat23: TStaticText;
    pncat24: TPanel;
    lbcat24: TStaticText;
    pncat25: TPanel;
    lbcat25: TStaticText;
    pncat26: TPanel;
    lbcat26: TStaticText;
    pncat28: TPanel;
    lbcat28: TStaticText;
    pncat27: TPanel;
    lbcat27: TStaticText;
    pncat29: TPanel;
    lbcat29: TStaticText;
    pncat30: TPanel;
    lbcat30: TStaticText;
    pncat31: TPanel;
    lbcat31: TStaticText;
    pncat32: TPanel;
    lbcat32: TStaticText;
    lbpanelactual1: TShape;
    procedure lbcat1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat5MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat6MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat7MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat8MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat9MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat11MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat12MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat13MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat14MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat15MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat16MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat17MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat18MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat19MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat20MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat21MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat22MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat23MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat24MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat25MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat26MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat27MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat28MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat29MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat30MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat31MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat32MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbcat1Click(Sender: TObject);
    procedure lbcat2Click(Sender: TObject);
    procedure lbcat3Click(Sender: TObject);
    procedure lbcat4Click(Sender: TObject);
    procedure lbcat5Click(Sender: TObject);
    procedure lbcat6Click(Sender: TObject);
    procedure lbcat7Click(Sender: TObject);
    procedure lbcat8Click(Sender: TObject);
    procedure lbcat9Click(Sender: TObject);
    procedure lbcat10Click(Sender: TObject);
    procedure lbcat11Click(Sender: TObject);
    procedure lbcat12Click(Sender: TObject);
    procedure lbcat13Click(Sender: TObject);
    procedure lbcat14Click(Sender: TObject);
    procedure lbcat15Click(Sender: TObject);
    procedure lbcat16Click(Sender: TObject);
    procedure lbcat17Click(Sender: TObject);
    procedure lbcat18Click(Sender: TObject);
    procedure lbcat19Click(Sender: TObject);
    procedure lbcat20Click(Sender: TObject);
    procedure lbcat21Click(Sender: TObject);
    procedure lbcat22Click(Sender: TObject);
    procedure lbcat23Click(Sender: TObject);
    procedure lbcat24Click(Sender: TObject);
    procedure lbcat25Click(Sender: TObject);
    procedure lbcat26Click(Sender: TObject);
    procedure lbcat27Click(Sender: TObject);
    procedure lbcat28Click(Sender: TObject);
    procedure lbcat29Click(Sender: TObject);
    procedure lbcat30Click(Sender: TObject);
    procedure lbcat31Click(Sender: TObject);
    procedure lbcat32Click(Sender: TObject);
    procedure lbcat10MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    Cat : Integer;
  end;

var
  frmSeleccionaCategoria: TfrmSeleccionaCategoria;

implementation

{$R *.dfm}

procedure TfrmSeleccionaCategoria.lbcat1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat1;
end;

procedure TfrmSeleccionaCategoria.lbcat2MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat2;
end;

procedure TfrmSeleccionaCategoria.lbcat3MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat3;
end;

procedure TfrmSeleccionaCategoria.lbcat4MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat4;
end;

procedure TfrmSeleccionaCategoria.lbcat5MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat5;
end;

procedure TfrmSeleccionaCategoria.lbcat6MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat6;
end;

procedure TfrmSeleccionaCategoria.lbcat7MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat7;
end;

procedure TfrmSeleccionaCategoria.lbcat8MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat8;
end;

procedure TfrmSeleccionaCategoria.lbcat9MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat9;
end;

procedure TfrmSeleccionaCategoria.lbcat11MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat11;
end;

procedure TfrmSeleccionaCategoria.lbcat12MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat12;
end;

procedure TfrmSeleccionaCategoria.lbcat13MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat13;
end;

procedure TfrmSeleccionaCategoria.lbcat14MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat14;
end;

procedure TfrmSeleccionaCategoria.lbcat15MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat15;
end;

procedure TfrmSeleccionaCategoria.lbcat16MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat16;
end;

procedure TfrmSeleccionaCategoria.lbcat17MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat17;
end;

procedure TfrmSeleccionaCategoria.lbcat18MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat18;
end;

procedure TfrmSeleccionaCategoria.lbcat19MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat19;
end;

procedure TfrmSeleccionaCategoria.lbcat20MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat20;
end;

procedure TfrmSeleccionaCategoria.lbcat21MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat21;
end;

procedure TfrmSeleccionaCategoria.lbcat22MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat22;
end;

procedure TfrmSeleccionaCategoria.lbcat23MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat23;
end;

procedure TfrmSeleccionaCategoria.lbcat24MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat24;
end;

procedure TfrmSeleccionaCategoria.lbcat25MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat25;
end;

procedure TfrmSeleccionaCategoria.lbcat26MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat26;
end;

procedure TfrmSeleccionaCategoria.lbcat27MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat27;
end;

procedure TfrmSeleccionaCategoria.lbcat28MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat28;
end;

procedure TfrmSeleccionaCategoria.lbcat29MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat29;
end;

procedure TfrmSeleccionaCategoria.lbcat30MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat30;
end;

procedure TfrmSeleccionaCategoria.lbcat31MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat31;
end;

procedure TfrmSeleccionaCategoria.lbcat32MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat32;
end;

procedure TfrmSeleccionaCategoria.lbcat1Click(Sender: TObject);
begin
  Cat := 1;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat2Click(Sender: TObject);
begin
  Cat := 2;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat3Click(Sender: TObject);
begin
  Cat := 3;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat4Click(Sender: TObject);
begin
  Cat := 4;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat5Click(Sender: TObject);
begin
  Cat := 5;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat6Click(Sender: TObject);
begin
  Cat := 6;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat7Click(Sender: TObject);
begin
  Cat := 7;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat8Click(Sender: TObject);
begin
  Cat := 8;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat9Click(Sender: TObject);
begin
  Cat := 9;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat10Click(Sender: TObject);
begin
  Cat := 10;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat11Click(Sender: TObject);
begin
  Cat := 11;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat12Click(Sender: TObject);
begin
  Cat := 12;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat13Click(Sender: TObject);
begin
  Cat := 13;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat14Click(Sender: TObject);
begin
  Cat := 14;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat15Click(Sender: TObject);
begin
  Cat := 15;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat16Click(Sender: TObject);
begin
  Cat := 16;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat17Click(Sender: TObject);
begin
  Cat := 17;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat18Click(Sender: TObject);
begin
  Cat := 18;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat19Click(Sender: TObject);
begin
  Cat := 19;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat20Click(Sender: TObject);
begin
  Cat := 20;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat21Click(Sender: TObject);
begin
  Cat := 21;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat22Click(Sender: TObject);
begin
  Cat := 22;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat23Click(Sender: TObject);
begin
  Cat := 23;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat24Click(Sender: TObject);
begin
  Cat := 24;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat25Click(Sender: TObject);
begin
  Cat := 25;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat26Click(Sender: TObject);
begin
  Cat := 26;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat27Click(Sender: TObject);
begin
  Cat := 27;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat28Click(Sender: TObject);
begin
  Cat := 28;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat29Click(Sender: TObject);
begin
  Cat := 29;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat30Click(Sender: TObject);
begin
  Cat := 30;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat31Click(Sender: TObject);
begin
  Cat := 31;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat32Click(Sender: TObject);
begin
  Cat := 32;
  Close;
end;

procedure TfrmSeleccionaCategoria.lbcat10MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbpanelactual1.Parent := pncat10;
end;

end.
