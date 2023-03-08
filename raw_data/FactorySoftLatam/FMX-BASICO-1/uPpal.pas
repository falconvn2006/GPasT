unit uPpal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  System.Rtti, System.Bindings.Outputs, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Data.Bind.Components, FMX.StdCtrls, FMX.Controls.Presentation;

type
  TfPPal = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    BindingsList1: TBindingsList;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPPal: TfPPal;

implementation

{$R *.fmx}

uses uGestionar, uListar, uLogin;

procedure TfPPal.FormCreate(Sender: TObject);
begin
  //Mostramos la pantalla de inicio
  FLogin := TFLogin.Create(Self);
  try
    FLogin.ShowModal;
  finally
    Flogin.Free;
  end;
end;

procedure TfPPal.MenuItem2Click(Sender: TObject);
begin
  fGestionar := TfGestionar.Create(Self);
  fGestionar.ShowModal;
end;

procedure TfPPal.MenuItem3Click(Sender: TObject);
begin
  fListar := TfListar.Create(Self);
  fListar.ShowModal;
end;

end.
