unit URechercheArticle;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  TFormRechercheArticle = class(TForm)
    Panel: TPanel;
    BtnOk: TBitBtn;
    BtnAnnuler: TBitBtn;
    EditCB: TLabeledEdit;
    EditDesignationModele: TLabeledEdit;
    EditTaille: TLabeledEdit;
    EditCouleur: TLabeledEdit;

    procedure BtnOkClick(Sender: TObject);

  private

  public

  end;

var
  FormRechercheArticle: TFormRechercheArticle;

implementation

{$R *.dfm}

procedure TFormRechercheArticle.BtnOkClick(Sender: TObject);
begin
  // Si pas de critères.
  if(EditCB.Text = '') and (EditDesignationModele.Text = '') and (EditTaille.Text = '') and (EditCouleur.Text = '') then
  begin
    Application.MessageBox('Attention :  il faut saisir au moins un critère de recherche !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
    EditCB.SetFocus;
  end
  else
    ModalResult := mrOk;
end;

end.
