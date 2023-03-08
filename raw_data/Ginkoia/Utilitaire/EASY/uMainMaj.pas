unit uMainMaj;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm15 = class(TForm)
    teBASE: TEdit;
    bBase: TButton;
    Panel1: TPanel;
    Memo1: TMemo;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ComboBox1: TComboBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Edit1: TEdit;
    Button1: TButton;
    procedure bBaseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form15: TForm15;

implementation

{$R *.dfm}

Uses UInfosBase,UYellis;

procedure TForm15.bBaseClick(Sender: TObject);
var vVersion, vNom, vGUID, vSender : string;
    vDateVersion : TDateTime;
    vGenerateur : integer;
    vRecalcul : boolean;
    verror :string;
    dlgopenFile:TOpenDialog;
begin
  dlgopenFile:=TOpenDialog.Create(self);
  try
    dlgOpenFile.InitialDir  := ExtractFileDir(TeBase.text);
    if dlgopenFile.Execute()
      then
          begin
              TeBase.text := dlgopenFile.FileName;
              GetInfosBase('localhost', TeBase.text, 'SYSDBA','masterkey',3050, vVersion, vNom, vGUID, vSender, vDateVersion, vGenerateur,vRecalcul, vError);
              Label2.Caption := Format('Version : %s',[vVersion]);
              Label3.Caption := Format('Nom : %s',[vNom]);
              Label4.Caption := Format('GUID : %s',[vGUID]);
              Label5.Caption := Format('Sender : %s',[vSender]);
              Label6.Caption := Format('IdBASE : %d',[vGenerateur]);
          end;
  finally
    dlgopenFile.Free;
  end;
end;

procedure TForm15.FormCreate(Sender: TObject);
//var vVersions:TStringList;
begin
//    vVersions := GetVersionsFromYellis();
    ComboBox1.Items.Clear;
    ComboBox1.Items.Text := GetVersionsFromYellis().Text;
end;

end.
