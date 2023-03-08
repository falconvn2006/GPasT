unit SelectCaisseSecours_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.shlobj,
  System.SysUtils, System.Variants, System.Classes, System.Ioutils,
  System.Windows.neighbors,
  //Début Uses Perso
  uRessourcestr,
  ufunctions,
  uBasetest,
  //Fin Uses Perso
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.Graphics, Vcl.ImgList, Vcl.filectrl,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Stan.Error,
  FireDAC.Phys.IB,
  FireDAC.DApt,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, Data.DB, Datasnap.DBClient;

type
  TFrm_SelectCaisseSecours = class(TForm)
    lblMagasin: TLabel;
    cbMagasin: TComboBox;
    lblPosteSecours: TLabel;
    cbPosteSecours: TComboBox;
    Panel1: TPanel;
    Image1: TImage;
    ItemSubtitle: TLabel;
    btnparam: TButton;
    btnInstall: TButton;
    lblNomServeur: TLabel;
    cbListeServeur: TComboBox;
    procedure Image1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_SelectCaisseSecours: TFrm_SelectCaisseSecours;

implementation

Uses
  Main_Frm,
  Main_Dm,
  Codeuser_Frm,
  Paramlame_Frm;

{$R *.dfm}

procedure TFrm_SelectCaisseSecours.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Frm_Main.Tag := 0; // pour permettre la fermeture de la fenêtre principale.
  Action := caFree;
end;

procedure TFrm_SelectCaisseSecours.Image1Click(Sender: TObject);
begin
  // on ferme la fenêtre
  Postmessage(handle, WM_CLOSE, 0, 0);
end;

end.
