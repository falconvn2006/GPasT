unit Clt_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, InvokeRegistry, Rio, SOAPHTTPClient;

type
  TForm6 = class(TForm)
    Btn_: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    HTTPRIO1: THTTPRIO;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Btn_2: TButton;
    procedure Btn_Click(Sender: TObject);
    procedure HTTPRIO1AfterExecute(const MethodName: string;
      SOAPResponse: TStream);
    procedure HTTPRIO1BeforeExecute(const MethodName: string;
      SOAPRequest: TStream);
    procedure Btn_2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form6: TForm6;

implementation

uses GestionJetonLaunch;

{$R *.dfm}

procedure TForm6.Btn_2Click(Sender: TObject);
begin
  Edit5.Text := '';

  Edit5.Text := GetIJetonLaunch(Edit2.Text, HTTPRIO1).GetVersion(Edit3.Text);
end;

procedure TForm6.Btn_Click(Sender: TObject);
begin
  Edit1.Text := '';

  Edit1.Text := GetIJetonLaunch(Edit2.Text, HTTPRIO1).GetToken(Edit3.Text, Edit4.Text);
end;

procedure TForm6.HTTPRIO1AfterExecute(const MethodName: string;
  SOAPResponse: TStream);
begin
  TMemoryStream(SOAPResponse).SaveToFile('c:\test.txt');
end;

procedure TForm6.HTTPRIO1BeforeExecute(const MethodName: string;
  SOAPRequest: TStream);
begin
  TMemoryStream(SOAPRequest).SaveToFile('c:\TestReq.txt');

end;

end.
