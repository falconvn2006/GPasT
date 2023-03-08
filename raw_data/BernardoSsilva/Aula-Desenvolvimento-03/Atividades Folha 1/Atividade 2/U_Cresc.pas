unit U_Cresc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  Tfmr_principal = class(TForm)
    lb_x: TLabel;
    lb_A: TLabel;
    lb_B: TLabel;
    lb_C: TLabel;
    txt_X: TEdit;
    txt_A: TEdit;
    txt_B: TEdit;
    txt_C: TEdit;
    btn_proc: TButton;
    procedure btn_procClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmr_principal: Tfmr_principal;

implementation

{$R *.dfm}

procedure Tfmr_principal.btn_procClick(Sender: TObject);
var
X, A, B, C, T : integer;

begin
  X := strtoint(txt_X.Text);
  A := strtoint(txt_A.Text);
  B := strtoint(txt_B.Text);
  C := strtoint(txt_C.Text);
  if X = 1 then
  begin
    if (A > B) and (A > C) then
    begin
      if B > C then
      BEGIN
      A := A;
      B := B;
      C := C
      end else
      if C > B then
      begin
      A := A;
      T := C;
      C := B;
      B := T;
      end;
    END
    else
    if (B > A) and (B > C) then
    begin
      if A > C then
      begin
        T := A;
        A := B;
        B := T;
        C := C;
      end
      else
      begin
        T := A;
        A := B;
        B := C;
        C := T;
      end;
    end
    else
    if (C > A) and (C > B) then
    begin
      if A > B then
      begin
        T := A;
        A := C;
        C := B;
        B := T;
      end
      else
      begin
        T := A;
        A := C;
        C := T;
        B := B;
      end;
    end;
  showmessage(inttostr(C)+ ', '+ inttostr(B)+ ', '+inttostr(A));
  end
  else
  if X = 2 then
  begin
    if (A > B) and (A > C) then
    begin
      if B > C then
      BEGIN
      A := A;
      B := B;
      C := C
      end else
      if C > B then
      begin
      A := A;
      T := C;
      C := B;
      B := T;
      end;
    END
    else
    if (B > A) and (B > C) then
    begin
      if A > C then
      begin
        T := A;
        A := B;
        B := T;
        C := C;
      end
      else
      begin
        T := A;
        A := B;
        B := C;
        C := T;
      end;
    end
    else
    if (C > A) and (C > B) then
    begin
      if A > B then
      begin
        T := A;
        A := C;
        C := B;
        B := T;
      end
      else
      begin
        T := A;
        A := C;
        C := T;
        B := B;
      end;
    end;
  showmessage(inttostr(A)+ ', '+ inttostr(B)+ ', '+inttostr(C));
  end
  else
  if X = 3 then
  begin
    if (A > B) and (A > C) then
    begin
      if B > C then
      BEGIN
      A := A;
      B := B;
      C := C
      end else
      if C > B then
      begin
      A := A;
      T := C;
      C := B;
      B := T;
      end;
    END
    else
    if (B > A) and (B > C) then
    begin
      if A > C then
      begin
        T := A;
        A := B;
        B := T;
        C := C;
      end
      else
      begin
        T := A;
        A := B;
        B := C;
        C := T;
      end;
    end
    else
    if (C > A) and (C > B) then
    begin
      if A > B then
      begin
        T := A;
        A := C;
        C := B;
        B := T;
      end
      else
      begin
        T := A;
        A := C;
        C := T;
        B := B;
      end;
    end;
  showmessage(inttostr(B)+ ', '+ inttostr(A)+ ', '+inttostr(C));
  end
  else
  begin
    Showmessage('X deve receber um valor inteiro entre 1 e 3')
  end;


end;

end.
