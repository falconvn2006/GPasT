unit FModalBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TModalBase = class(TForm)
    pl_bottom: TPanel;
    btn_zapisz: TButton;
    bt_anuluj: TButton;
    BaseQuery: TADOQuery;
    pl_all: TPanel;
    dsBase: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btn_zapiszClick(Sender: TObject);
    procedure bt_anulujClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    function SprawdzZapis:boolean; virtual;
  end;

var
  ModalBase: TModalBase;

implementation
uses Main;
{$R *.dfm}

procedure TModalBase.btn_zapiszClick(Sender: TObject);
begin
   try
    if not SprawdzZapis then
       exit;
    if BaseQuery.State in [dsInsert,dsEdit] then
      BaseQuery.Post;
      modalresult:=mrok;
  except

  end;
end;

procedure TModalBase.bt_anulujClick(Sender: TObject);
begin
  if BaseQuery.State in [dsInsert, dsedit] then
  BaseQuery.Cancel;
  ModalResult:= mrCancel;
end;

procedure TModalBase.FormCreate(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to self.ComponentCount-1 do begin
    if self.Components[i] is TADOQuery then begin
     TADOQuery(self.Components[i]).Connection :=FormMain.ADOConnection;
    end;
  end;
end;

function TModalBase.SprawdzZapis: boolean;
begin
  result:=true;
end;

end.
