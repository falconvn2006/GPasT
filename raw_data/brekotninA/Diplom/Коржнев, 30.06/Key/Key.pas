unit Key;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, sEdit, sLabel, Registry, Clipbrd;


type
  TForm9 = class(TForm)
    sEdit1: TsEdit;
    sEdit2: TsEdit;
    sEdit3: TsEdit;
    sButton1: TsButton;
    sButton2: TsButton;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    sEdit4: TsEdit;
    sButton3: TsButton;
    sButton4: TsButton;
    procedure sButton1Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sButton3Click(Sender: TObject);
    procedure sButton4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form9: TForm9;

implementation

uses PW;

{$R *.dfm}

procedure TForm9.sButton1Click(Sender: TObject);
var
  keyString, accessCodeString: string;
begin
{$IfDeF SIMPLE_PROTECT}
   if (trim(sEdit2.Text) <> '') and (trim(sEdit3.Text) <> '') and (trim(sEdit4.Text) <> '') then
    begin
      keyString := sEdit1.Text;
      accessCodeString := sEdit2.Text + sEdit3.Text + sEdit4.Text;
      if CheckAccessCode(keyString, accessCodeString) then
        begin
          WriteAccessCode(accessCodeString);
          ShowMessage('СОВПАДЕНИЕ КЛЮЧА');
          GoodKey := true;
          Close;
        end
    else
      begin
        ShowMessage('Пароль не подходит');
      end;
    end
  else
    begin
      ShowMessage('Вы не ввели пароль, попробуйте ещё раз.');
    end;
{$EndIf}
{$IfDeF STANDARD_PROTECT}
   if (trim(sEdit2.Text) <> '') and (trim(sEdit3.Text) <> '') and (trim(sEdit4.Text) <> '') then
    begin
      keyString := sEdit1.Text;
      accessCodeString := sEdit2.Text + sEdit3.Text + sEdit4.Text;
      if CheckAccessCode(keyString, accessCodeString) then
        begin
          WriteAccessCode(accessCodeString);
          ShowMessage('СОВПАДЕНИЕ КЛЮЧА');
          GoodKey := true;
          Close;
        end
    else
      begin
        ShowMessage('Пароль не подходит');
      end;
    end
  else
    begin
      ShowMessage('Вы не ввели пароль, попробуйте ещё раз.');
    end;
{$EndIf}
end;

procedure TForm9.sButton2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm9.FormCreate(Sender: TObject);
begin
{$IfDeF SIMPLE_PROTECT}
	sEdit2.MaxLength := 3;
	sEdit3.MaxLength := 3;
 sEdit4.MaxLength := 3;
{$EndIf}
{$IfDeF STANDARD_PROTECT}
	sEdit2.MaxLength := 4;
	sEdit3.MaxLength := 4;
 sEdit4.MaxLength := 4;
{$EndIf}
end;

procedure TForm9.sButton3Click(Sender: TObject);
var
	s: string;
 i: integer;
begin
		s := '';
		for i := 1 to Length(sEdit1.Text) do begin
   	s := s + sEdit1.Text[i];
			if i in [4, 8, 12] then
     	s := s + '-';
   end;
		Clipboard.AsText := s;
end;

procedure TForm9.sButton4Click(Sender: TObject);
var
	s: string;
 i: integer;
begin
	s := AnsiUpperCase(Clipboard.AsText);
 for i := Length(s) downto 1 do begin
		if s[i] = '-' then
   	Delete(s, i, 1);
 end;
 sEdit2.Text := '';
 sEdit3.Text := '';
 sEdit4.Text := '';
	for i := 1 to Length(sEdit1.Text) do begin
{$IfDeF SIMPLE_PROTECT}
			if i <= 3 then
     	sEdit2.Text := sEdit2.Text + s[i];
			if (i > 3) and (i <= 6) then
     	sEdit3.Text := sEdit3.Text + s[i];
			if (i > 6) and (i <= 9) then
     	sEdit4.Text := sEdit4.Text + s[i];
{$EndIf}
{$IfDeF STANDARD_PROTECT}
			if i <= 4 then
     	sEdit2.Text := sEdit2.Text + s[i];
			if (i > 4) and (i <= 8) then
     	sEdit3.Text := sEdit3.Text + s[i];
			if (i > 8) and (i <= 12) then
     	sEdit4.Text := sEdit4.Text + s[i];
{$EndIf}
 end;
end;

end.
