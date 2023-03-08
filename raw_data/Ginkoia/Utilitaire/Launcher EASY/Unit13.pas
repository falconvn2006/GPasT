unit Unit13;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Vcl.ComCtrls;

type
  TForm13 = class(TForm)
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    pOuvrir: TMenuItem;
    N1: TMenuItem;
    pQuitter: TMenuItem;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure pQuitterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pOuvrirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FCanClose:Boolean;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form13: TForm13;

implementation

{$R *.dfm}

procedure TForm13.FormActivate(Sender: TObject);
begin
   ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TForm13.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    Self.Hide;
    CanClose:=FCanClose;
end;

procedure TForm13.FormCreate(Sender: TObject);
begin
    FCanClose := false;
end;

procedure TForm13.FormShow(Sender: TObject);
begin
    ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TForm13.pOuvrirClick(Sender: TObject);
begin
   Self.Show;
   Application.BringToFront;
end;

procedure TForm13.pQuitterClick(Sender: TObject);
begin
    FCanClose:=true;
    Close;
end;

end.
