unit MasterParam;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, System.Actions, Vcl.ActnList, Vcl.Touch.GestureMgr;

type
  TMasterParamForm = class(TForm)
    ActionList1: TActionList;
    Action1: TAction;
    GestureManager1: TGestureManager;
    Panel1: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    eurl: TEdit;
    euser: TEdit;
    epassword: TEdit;
    Image1: TImage;
    procedure Image1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  MasterParamForm: TMasterParamForm;

implementation

{$R *.dfm}

uses GroupedItems1;

procedure TMasterParamForm.Image1Click(Sender: TObject);
begin
  Hide;
  GridForm.BringToFront;
end;

end.
