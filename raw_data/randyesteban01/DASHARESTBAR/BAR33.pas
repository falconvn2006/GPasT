unit BAR33;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TfrmTeclado = class(TForm)
    btclose: TSpeedButton;
    BitBtn1: TSpeedButton;
    BitBtn2: TSpeedButton;
    BitBtn3: TSpeedButton;
    BitBtn4: TSpeedButton;
    BitBtn5: TSpeedButton;
    BitBtn6: TSpeedButton;
    BitBtn7: TSpeedButton;
    BitBtn8: TSpeedButton;
    BitBtn9: TSpeedButton;
    BitBtn10: TSpeedButton;
    BitBtn11: TSpeedButton;
    BitBtn12: TSpeedButton;
    BitBtn13: TSpeedButton;
    BitBtn14: TSpeedButton;
    BitBtn15: TSpeedButton;
    BitBtn16: TSpeedButton;
    BitBtn17: TSpeedButton;
    BitBtn18: TSpeedButton;
    BitBtn19: TSpeedButton;
    BitBtn20: TSpeedButton;
    BitBtn21: TSpeedButton;
    BitBtn22: TSpeedButton;
    BitBtn23: TSpeedButton;
    BitBtn24: TSpeedButton;
    BitBtn25: TSpeedButton;
    BitBtn26: TSpeedButton;
    BitBtn27: TSpeedButton;
    BitBtn28: TSpeedButton;
    BitBtn29: TSpeedButton;
    BitBtn30: TSpeedButton;
    BitBtn31: TSpeedButton;
    BitBtn32: TSpeedButton;
    BitBtn33: TSpeedButton;
    BitBtn34: TSpeedButton;
    BitBtn35: TSpeedButton;
    BitBtn36: TSpeedButton;
    BitBtn37: TSpeedButton;
    BitBtn38: TSpeedButton;
    bttecla: TSpeedButton;
    BitBtn40: TSpeedButton;
    btcaps: TSpeedButton;
    btshift1: TSpeedButton;
    BitBtn43: TSpeedButton;
    BitBtn44: TSpeedButton;
    BitBtn45: TSpeedButton;
    BitBtn46: TSpeedButton;
    BitBtn47: TSpeedButton;
    BitBtn48: TSpeedButton;
    BitBtn49: TSpeedButton;
    BitBtn50: TSpeedButton;
    BitBtn51: TSpeedButton;
    BitBtn52: TSpeedButton;
    btshift2: TSpeedButton;
    BitBtn54: TSpeedButton;
    BitBtn55: TSpeedButton;
    BitBtn56: TSpeedButton;
    BitBtn57: TSpeedButton;
    BitBtn58: TSpeedButton;
    BitBtn59: TSpeedButton;
    BitBtn60: TSpeedButton;
    BitBtn61: TSpeedButton;
    BitBtn62: TSpeedButton;
    BitBtn63: TSpeedButton;
    BitBtn64: TSpeedButton;
    BitBtn65: TSpeedButton;
    BitBtn66: TSpeedButton;
    BitBtn67: TSpeedButton;
    BitBtn68: TSpeedButton;
    BitBtn69: TSpeedButton;
    BitBtn70: TSpeedButton;
    BitBtn71: TSpeedButton;
    BitBtn72: TSpeedButton;
    BitBtn73: TSpeedButton;
    BitBtn74: TSpeedButton;
    BitBtn75: TSpeedButton;
    BitBtn76: TSpeedButton;
    BitBtn77: TSpeedButton;
    BitBtn78: TSpeedButton;
    BitBtn79: TSpeedButton;
    BitBtn80: TSpeedButton;
    BitBtn81: TSpeedButton;
    edteclado: TEdit;
    btaceptar: TSpeedButton;
    procedure btcloseClick(Sender: TObject);
    procedure btteclaClick(Sender: TObject);
    procedure BitBtn55Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn79Click(Sender: TObject);
    procedure BitBtn57Click(Sender: TObject);
    procedure BitBtn59Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn63Click(Sender: TObject);
    procedure BitBtn60Click(Sender: TObject);
    procedure BitBtn64Click(Sender: TObject);
    procedure BitBtn27Click(Sender: TObject);
    procedure BitBtn47Click(Sender: TObject);
    procedure BitBtn45Click(Sender: TObject);
    procedure BitBtn29Click(Sender: TObject);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn30Click(Sender: TObject);
    procedure BitBtn31Click(Sender: TObject);
    procedure BitBtn32Click(Sender: TObject);
    procedure BitBtn21Click(Sender: TObject);
    procedure BitBtn33Click(Sender: TObject);
    procedure BitBtn34Click(Sender: TObject);
    procedure BitBtn35Click(Sender: TObject);
    procedure BitBtn49Click(Sender: TObject);
    procedure BitBtn48Click(Sender: TObject);
    procedure BitBtn22Click(Sender: TObject);
    procedure BitBtn23Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn17Click(Sender: TObject);
    procedure BitBtn28Click(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn46Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure BitBtn44Click(Sender: TObject);
    procedure BitBtn19Click(Sender: TObject);
    procedure BitBtn43Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn26Click(Sender: TObject);
    procedure BitBtn52Click(Sender: TObject);
    procedure BitBtn51Click(Sender: TObject);
    procedure BitBtn50Click(Sender: TObject);
    procedure BitBtn36Click(Sender: TObject);
    procedure BitBtn37Click(Sender: TObject);
    procedure BitBtn24Click(Sender: TObject);
    procedure BitBtn25Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure btaceptarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Acepto : integer;
    procedure Digita (tecla : string);
  end;

var
  frmTeclado: TfrmTeclado;

implementation

{$R *.dfm}

procedure PostKeyEx32(key: Word; const shift: TShiftState; specialkey: Boolean) ;
{
Parameters :
* key : virtual keycode of the key to send. For printable keys this is simply the ANSI code (Ord(character)) .
* shift : state of the modifier keys. This is a set, so you can set several of these keys (shift, control, alt, mouse buttons) in tandem. The TShiftState type is declared in the Classes Unit.
* specialkey: normally this should be False. Set it to True to specify a key on the numeric keypad, for example.
Description:
Uses keybd_event to manufacture a series of key events matching the passed parameters. The events go to the control with focus.
Note that for characters key is always the upper-case version of the character. Sending without any modifier keys will result in a lower-case character, sending it with [ ssShift ] will result in an upper-case character!
}
type
   TShiftKeyInfo = record
     shift: Byte ;
     vkey: Byte ;
   end;
   ByteSet = set of 0..7 ;
const
   shiftkeys: array [1..3] of TShiftKeyInfo =
     ((shift: Ord(ssCtrl) ; vkey: VK_CONTROL),
     (shift: Ord(ssShift) ; vkey: VK_SHIFT),
     (shift: Ord(ssAlt) ; vkey: VK_MENU)) ;
var
   flag: DWORD;
   bShift: ByteSet absolute shift;
   j: Integer;
begin
   for j := 1 to 3 do
   begin
     if shiftkeys[j].shift in bShift then
       keybd_event(shiftkeys[j].vkey, MapVirtualKey(shiftkeys[j].vkey, 0), 0, 0) ;
   end;
   if specialkey then
     flag := KEYEVENTF_EXTENDEDKEY
   else
     flag := 0;

   keybd_event(key, MapvirtualKey(key, 0), flag, 0) ;
   flag := flag or KEYEVENTF_KEYUP;
   keybd_event(key, MapvirtualKey(key, 0), flag, 0) ;

   for j := 3 downto 1 do
   begin
     if shiftkeys[j].shift in bShift then
       keybd_event(shiftkeys[j].vkey, MapVirtualKey(shiftkeys[j].vkey, 0), KEYEVENTF_KEYUP, 0) ;
   end;
end;

procedure TfrmTeclado.btcloseClick(Sender: TObject);
begin
  Acepto := 0;
  Close;
end;

procedure TfrmTeclado.Digita(tecla: string);
begin
  edteclado.Text := edteclado.text + tecla;
  edteclado.SelStart := length(edteclado.text);
end;

procedure TfrmTeclado.btteclaClick(Sender: TObject);
begin
  PostKeyEx32(192, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn55Click(Sender: TObject);
begin
  PostKeyEx32(VK_SPACE, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn13Click(Sender: TObject);
begin
  PostKeyEx32(VK_BACK, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn79Click(Sender: TObject);
begin
  PostKeyEx32(vk_delete, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn57Click(Sender: TObject);
begin
  PostKeyEx32(vk_left, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn59Click(Sender: TObject);
begin
  PostKeyEx32(vk_right, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn2Click(Sender: TObject);
begin
  PostKeyEx32(VK_NUMPAD2, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn3Click(Sender: TObject);
begin
  PostKeyEx32(VK_NUMPAD3, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn4Click(Sender: TObject);
begin
  PostKeyEx32(VK_NUMPAD4, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn5Click(Sender: TObject);
begin
  PostKeyEx32(VK_NUMPAD5, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn6Click(Sender: TObject);
begin
  PostKeyEx32(VK_NUMPAD6, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn7Click(Sender: TObject);
begin
  PostKeyEx32(VK_NUMPAD7, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn8Click(Sender: TObject);
begin
  PostKeyEx32(VK_NUMPAD8, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn9Click(Sender: TObject);
begin
  PostKeyEx32(VK_NUMPAD9, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn10Click(Sender: TObject);
begin
  PostKeyEx32(VK_NUMPAD0, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn63Click(Sender: TObject);
begin
  PostKeyEx32(VK_HOME, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn60Click(Sender: TObject);
begin
  PostKeyEx32(VK_END, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn64Click(Sender: TObject);
begin
  PostKeyEx32(VK_ESCAPE, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn27Click(Sender: TObject);
begin
  PostKeyEx32(65, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn47Click(Sender: TObject);
begin
  PostKeyEx32(66, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn45Click(Sender: TObject);
begin
  PostKeyEx32(67, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn29Click(Sender: TObject);
begin
  PostKeyEx32(68, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn16Click(Sender: TObject);
begin
  PostKeyEx32(69, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn30Click(Sender: TObject);
begin
  PostKeyEx32(70, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn31Click(Sender: TObject);
begin
  PostKeyEx32(71, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn32Click(Sender: TObject);
begin
  PostKeyEx32(72, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn21Click(Sender: TObject);
begin
  PostKeyEx32(73, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn33Click(Sender: TObject);
begin
  PostKeyEx32(74, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn34Click(Sender: TObject);
begin
  PostKeyEx32(75, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn35Click(Sender: TObject);
begin
  PostKeyEx32(76, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn49Click(Sender: TObject);
begin
  PostKeyEx32(77, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn48Click(Sender: TObject);
begin
  PostKeyEx32(78, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn22Click(Sender: TObject);
begin
  PostKeyEx32(79, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn23Click(Sender: TObject);
begin
  PostKeyEx32(80, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn14Click(Sender: TObject);
begin
  PostKeyEx32(81, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn17Click(Sender: TObject);
begin
  PostKeyEx32(82, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn28Click(Sender: TObject);
begin
  PostKeyEx32(83, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn18Click(Sender: TObject);
begin
  PostKeyEx32(84, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn20Click(Sender: TObject);
begin
  PostKeyEx32(85, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn46Click(Sender: TObject);
begin
  PostKeyEx32(86, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn15Click(Sender: TObject);
begin
  PostKeyEx32(87, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn44Click(Sender: TObject);
begin
  PostKeyEx32(88, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn19Click(Sender: TObject);
begin
  PostKeyEx32(89, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn43Click(Sender: TObject);
begin
  PostKeyEx32(90, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn11Click(Sender: TObject);
begin
  PostKeyEx32(189, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn12Click(Sender: TObject);
begin
  PostKeyEx32(187, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn26Click(Sender: TObject);
begin
  PostKeyEx32(192, [ssShift], True);
end;

procedure TfrmTeclado.BitBtn52Click(Sender: TObject);
begin
  PostKeyEx32(191, [ssShift], True);
end;

procedure TfrmTeclado.BitBtn51Click(Sender: TObject);
begin
  PostKeyEx32(190, [ssShift], True);
end;

procedure TfrmTeclado.BitBtn50Click(Sender: TObject);
begin
  PostKeyEx32(188, [ssShift], True);
end;

procedure TfrmTeclado.BitBtn36Click(Sender: TObject);
begin
  PostKeyEx32(186, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn37Click(Sender: TObject);
begin
  PostKeyEx32(222, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn24Click(Sender: TObject);
begin
  PostKeyEx32(219, [ssShift], False);
end;

procedure TfrmTeclado.BitBtn25Click(Sender: TObject);
begin
  PostKeyEx32(221, [ssShift], False);
end;

procedure TfrmTeclado.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //showmessage(inttostr(key));
end;

procedure TfrmTeclado.BitBtn1Click(Sender: TObject);
begin
  PostKeyEx32(VK_NUMPAD1, [ssShift], False);
end;

procedure TfrmTeclado.btaceptarClick(Sender: TObject);
begin
  Acepto := 1;
  Close;
end;

end.
