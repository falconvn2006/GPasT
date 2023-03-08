unit frmAboutUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  System.IniFiles, System.Win.Registry, System.Actions, Vcl.ActnList,
  plugin, NppForms, ShellAPI;

type
  TfrmAbout = class(TNppForm)
    btnOk: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure Label7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label7MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Label7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
 
  private
    procedure ShellOpen(const Url: string; const Params: string = '');

  public
  
    function Data: string;

  end;


implementation


{$R *.dfm}


function TfrmAbout.Data: string;
begin

end;



procedure TfrmAbout.FormCreate(Sender: TObject);
var
   i: Integer;
begin
  inherited;


  i:=SizeOf(System.NativeInt) * 8;

  Label1.Caption:='BFRegex (' + IntToStr(i)  + '-bit/Unicode) - Copyright © 2023 Bernard Ford';

  //ShowMessagE(IntToStr(i*8) + 'bit');


end;

procedure TfrmAbout.FormKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if (Key = Char(vk_escape)) then begin  // #27
      self.ModalResult:=mrOk;
      self.CloseModal;
  end
  else if (Key = Char(vk_return))  then begin  // #27
      self.ModalResult:=mrOk;
      self.CloseModal;
  end;

end;

procedure TfrmAbout.Label7Click(Sender: TObject);
begin
  inherited;
 ShellOpen('https://creativecommons.org/licenses/by-nd/4.0/legalcode', '');
end;

procedure TfrmAbout.Label7MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  {Label7.Left:=Label7.Left+2;
    Label7.Top:=Label7.Top+2;}
end;

procedure TfrmAbout.Label7MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
{  Label7.Left:=Label7.Left-2;
  Label7.Top:=Label7.Top - 2;  }
end;

procedure TfrmAbout.ShellOpen(const Url: string; const Params: string = '');
var
  res: NativeUInt;
begin

  try
    self.Cursor:=crAppStart;


    res:=ShellAPI.ShellExecute(0, 'Open', PChar(Url), PChar(Params), nil, SW_SHOWNORMAL);
    if(res<32) then begin
        ShowMessage('Failed: ' + IntToStr(res));
    end;

  finally
    self.Cursor:=crDefault;
  end;

end;

end.
