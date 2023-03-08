unit AssisEasyRecupBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls{, dxGDIPlusClasses},
  Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    Panel3: TPanel;
    Image2: TImage;
    Label9: TLabel;
    Panel1: TPanel;
    BEASYEXIST: TButton;
    BDELOS2EASY: TButton;
    sb: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure BDELOS2EASYClick(Sender: TObject);
    procedure BEASYEXISTClick(Sender: TObject);
  private
    FEASYService  : boolean;
    FBase0:TFileName;
    FEASYDir      : string;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses ServiceControler,UCommun,SymmetricDS.Commun, MainEasyRecupBase_Frm, uEasy.Types;

procedure TForm1.BDELOS2EASYClick(Sender: TObject);
begin
  Self.Hide;
  Application.CreateForm(TFrmMainEasyRecupBase, FrmMainEasyRecupBase);
  FrmMainEasyRecupBase.MODE := CST_DELOS2EASY;
  FrmMainEasyRecupBase.ShowModal;
  Application.Terminate;
end;

procedure TForm1.BEASYEXISTClick(Sender: TObject);
begin
  Self.Hide;
  Application.CreateForm(TFrmMainEasyRecupBase, FrmMainEasyRecupBase);
  FrmMainEasyRecupBase.MODE := CST_DEJAEASY;
  FrmMainEasyRecupBase.ShowModal;
  Application.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    FEASYService  :=  ServiceExist('','EASY');
    FBase0 := ReadBase0;
    FEASYDir := ExtractFilePath(FBase0)+'..\EASY';

    if Not(FileExists(FBase0))
      then
        begin
          MessageDlg('Verifiez la base0 dans le registre',  mtError, [mbOK],
            0);
        end;

    BEASYEXIST.Enabled  := DirectoryExists(FEASYDir) and FEASYService;
    BDELOS2EASY.Enabled := not(BEASYEXIST.Enabled);

end;

end.
