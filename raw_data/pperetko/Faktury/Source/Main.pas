unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Data.Win.ADODB, Vcl.ComCtrls, ufaktury, Vcl.Menus;

type
  TFormMain = class(TForm)
    Panel1: TPanel;
    Menu: TListBox;
    Splitter1: TSplitter;
    ADOConnection: TADOConnection;
    pl_top: TPanel;
    pgDane: TPageControl;
    StatusBar1: TStatusBar;
    tsFaktury: TTabSheet;
    lv_faktury: TListView;
    MainMenu1: TMainMenu;
    Plik1: TMenuItem;
    Zakocz1: TMenuItem;
    Ustawienia1: TMenuItem;
    Danefirmy1: TMenuItem;
    procedure MenuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Danefirmy1Click(Sender: TObject);
  private
    params:TuFakturyParams;
  public

  end;

var
  FormMain: TFormMain;

implementation
uses ffaktury, fFirma, FKontrahenciLista;
{$R *.dfm}

procedure TFormMain.Danefirmy1Click(Sender: TObject);
begin
  TFirmaForm.Show;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  try
    params:= TuFakturyParams.Create;
    ADOConnection.ConnectionString := params.connectionString;
    ADOConnection.Open();
  except
    ShowMessage('Brak po³¹czenia z baz¹ danych');
    Application.Terminate;
  end;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  params.Free;
end;

procedure TFormMain.MenuClick(Sender: TObject);
begin
  case menu.ItemIndex of
    0: begin
         TKontrahenciListaForm.Show;
       end;
    1: begin
         Application.CreateForm(TfFakturyForm,ffakturyform);
         ffakturyform.showmodal;
         ffakturyform.Free;
       end;
  end;
end;

end.
