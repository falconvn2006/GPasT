unit Edit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, sRichEdit, Buttons, sBitBtn, sMemo;

type
  TEditForm = class(TForm)
    sBitBtn21: TsBitBtn;
    sRichEdit1: TsMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditForm: TEditForm;

implementation

uses IndependentWork, MyDB;

{$R *.dfm}

procedure TEditForm.FormShow(Sender: TObject);
begin
  sRichEdit1.Text:=fIndependentWork.sRichEdit1.Text;
end;

end.
