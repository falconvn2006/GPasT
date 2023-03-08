unit AddServeur_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.Buttons;

type
  TFrm_AddServer = class(TForm)
    Pan_Header: TPanel;
    ItemSubtitle: TLabel;
    pnl_bottom: TPanel;
    btn1: TButton;
    btn2: TButton;
    mmo_serv: TMemo;
    lbl_nameServ: TLabel;
    lbl_LetterDir: TLabel;
    edt_NameServ: TEdit;
    cbb_LetterDir: TComboBox;
    btn3: TButton;
    procedure btn2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    ListServ : TStringList;

    function GetListServ : TStringList;
    procedure initList;
    { Déclarations publiques }
  end;

var
  Frm_AddServer: TFrm_AddServer;

implementation

{$R *.dfm}

procedure TFrm_AddServer.btn1Click(Sender: TObject);
var
  i : Integer;
begin
  i := 0;

  ListServ := TStringList.Create;
  for I := 0 to mmo_serv.Lines.Count - 1 do
  begin
    ListServ.Add(mmo_serv.Lines[i]);
  end;

//  GetListServ(ListServ);

  modalResult := mrOk;
end;

procedure TFrm_AddServer.btn2Click(Sender: TObject);
begin
  modalResult := mrCancel;
end;

procedure TFrm_AddServer.btn3Click(Sender: TObject);
begin
  mmo_serv.Lines.Add(edt_NameServ.Text+':'+cbb_LetterDir.Text+':\Ginkoia\DATA\Ginkoia.IB');
end;

procedure TFrm_AddServer.initList;
var
  a : Char;
begin
  //
  cbb_LetterDir.Clear;
  for a := 'A' to 'Z' do
    cbb_LetterDir.Items.Add(a);

end;

function TFrm_AddServer.GetListServ: TStringList;
begin
  if Assigned(ListServ) then
    Result := ListServ;

end;

end.
