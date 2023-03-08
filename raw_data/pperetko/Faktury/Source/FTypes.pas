unit FTypes;

interface
uses SysUtils,Windows,forms;
type
  TArrayOfString=Array of string;
  TArrayOfInteger=array of integer;


  TKomunikat = class
  public
    procedure WyswietlKomunikat(Anapis: string; ANaglowek: string);
    function WyswietlKomunikatF(Anapis: string; ANaglowek: string): integer;
  end;
var
  Komunikat: TKomunikat;

implementation

{ TKomunikat }

procedure TKomunikat.WyswietlKomunikat(Anapis, ANaglowek: string);
begin
with Application do begin
    SetWindowPos(handle, 0, 0, 0, 0, 0, SWP_NOZORDER or SWP_NOMOVE or SWP_NOSIZE or SWP_NOREDRAW);
    MessageBox(PChar(Anapis), PChar(ANaglowek), mb_OK or mb_IconInformation or mb_ApplModal);
  end;
end;

function TKomunikat.WyswietlKomunikatF(Anapis, ANaglowek: string): integer;
var
  wynik: integer;
begin
  result := -1;
  with Application do begin
    wynik := MessageBox(Pchar(Anapis), PChar(ANaglowek), MB_YESNO or MB_ICONWARNING);
    SetWindowPos(Application.Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or SWP_NOMOVE or SWP_NOSIZE or SWP_NOREDRAW);
    if wynik = id_Yes then begin
      result := 1;
    end;
  end;
end;

end.
