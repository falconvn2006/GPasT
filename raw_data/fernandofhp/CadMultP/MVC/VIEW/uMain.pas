unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DAO.DM,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls;

type
  TfrmMain = class(TForm)
    pnTools: TPanel;
    BitBtn1: TBitBtn;
    btnFechar: TBitBtn;
    pnForms: TPanel;
    Label2: TLabel;
    procedure btnFecharClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    FFormActive: TForm;
    procedure LoadForm(AClass: TFormClass);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses uFrmCadastroPessoa;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
var
  Form: TfrmCadastroPessoa;
begin
  { Form := TfrmCadastroPessoa.Create(nil);
    try
    Form.ShowModal;
    finally
    Freeandnil(Form);
    end; }
  Self.LoadForm(TfrmCadastroPessoa);
end;

procedure TfrmMain.btnFecharClick(Sender: TObject);
begin
  if (fsModal in Self.FormState) then
  begin
    ModalResult := mrOk;
  end
  else
  begin
    Close;
  end;
end;

procedure TfrmMain.LoadForm(AClass: TFormClass);
begin
  if Assigned(Self.FFormActive) then
  begin
    Self.FFormActive.Close;
    Self.FFormActive.Free;
    Self.FFormActive := nil;
  end;

  Self.FFormActive := AClass.Create(nil);
  Self.FFormActive.Parent := Self.pnForms;
  Self.FFormActive.BorderStyle := TFormBorderStyle.bsNone;

  Self.FFormActive.Top := 0;
  Self.FFormActive.Left := 0;
  Self.FFormActive.Align := TAlign.alClient;

  Self.FFormActive.Show;
end;

end.
