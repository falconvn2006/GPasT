unit ChxMagPoste_frm;

interface

uses
   UInstall,
   Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
   Buttons, ExtCtrls;

type
   Tfrm_ChxMagPoste = class(TForm)
      Bevel1: TBevel;
      Label2: TLabel;
      CB_MAG: TComboBox;
      Label3: TLabel;
      cb_poste: TComboBox;
      BitBtn1: TBitBtn;
      procedure CB_MAGChange(Sender: TObject);
    { Private declarations }
   public
    { Public declarations }
    Install: TInstall ;
      procedure OnMagasin(Sender: TObject; Magasin: string);
      procedure OnPoste(Sender: TObject; Poste: string);
      function Execute(Install: TInstall): TModalResult;
   end;

var
   frm_ChxMagPoste: Tfrm_ChxMagPoste;

implementation

{$R *.DFM}

{ Tfrm_ChxMagPoste }

procedure Tfrm_ChxMagPoste.OnMagasin(Sender: TObject; Magasin: string);
begin
   CB_MAG.Items.add(Magasin);
end;

procedure Tfrm_ChxMagPoste.OnPoste(Sender: TObject; Poste: string);
begin
   cb_poste.Items.add(Poste);
   if poste = 'SERVEUR' then
      cb_Poste.ItemIndex := cb_poste.Items.count - 1;
end;

procedure Tfrm_ChxMagPoste.CB_MAGChange(Sender: TObject);
begin
  cb_Poste.Clear;
  Install.ListePoste (CB_MAG.Items[CB_MAG.ItemIndex]) ;
end;

function Tfrm_ChxMagPoste.Execute(Install: TInstall): TModalResult;
begin
   self.Install := Install ;
   result := ShowModal;
end;

end.

