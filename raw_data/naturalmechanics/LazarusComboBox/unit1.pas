unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  Menus, StdCtrls, ExtCtrls,BCLabel, bgraControls,BCTypes,
  TAdvancedDropDown,
  BCPanel, Types;

type

  { TForm1 }

  TForm1 = class(TForm)
    BCLabel1: TBCLabel;
    BCPanel1: TBCPanel;
    ComboBox1: TComboBox;
    Label1: TLabel;
    ListBox1: TListBox;
    ScrollBar1: TScrollBar;
    procedure ComboBox1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure Label1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
  private

  public

  end;

var
  Form1: TForm1;
  exampleDropDown : TAdvancedDropDown.TAdvancedDropDownList;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  items         : TAdvancedDropDown.TStringArray;
  pPanel        : TBCPanel;


begin
  items         := ['Lorem', 'ipsum', 'dolor', 'sit', 'amet',
                    'consetetur', 'sadipscing', 'elitr', 'sed',
                    'diam nonumy eirmod tempor invidunt',
                    'ut labore et',
                    'dolore', 'magna aliquyam erat',
                    'sed', 'diam', 'voluptua'];

  pPanel        :=    BCPanel1;


  exampleDropDown := TAdvancedDropDown.TAdvancedDropDownList.Create()   ;
  exampleDropDown.Initialize( items);

  // exampleDropDown.dropDownHeight:=40;
  // exampleDropDown.dropDownWidth:= 600;

  exampleDropDown.debugLabel := BCLabel1;

  exampleDropDown.Render(pPanel);

  // exampleDropDown.example:='hello';
end;

procedure TForm1.Label1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  label1.Caption:=IntToStr(wheelDelta);
end;

procedure TForm1.ListBox1SelectionChange(Sender: TObject; User: boolean);
begin

end;

procedure TForm1.ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
  label1.Caption:=IntToStr(ScrollPos);
end;

procedure TForm1.ComboBox1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin

end;

end.

