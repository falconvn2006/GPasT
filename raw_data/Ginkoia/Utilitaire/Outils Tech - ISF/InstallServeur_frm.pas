unit InstallServeur_frm;

interface

uses
   SevenZip, UInstall, UBase,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Buttons, StdCtrls, ComCtrls;

type
   TFrm_InstallServeur = class(TForm)
      Edit1: TEdit;
      Label1: TLabel;
      SpeedButton1: TSpeedButton;
      OD: TOpenDialog;
      pg: TPageControl;
      dez: TTabSheet;
      inst: TTabSheet;
      Pb1: TProgressBar;
      SpeedButton2: TSpeedButton;
      Lab_Etat: TLabel;
      Label2: TLabel;
      CB_MAG: TComboBox;
      cb_poste: TComboBox;
      Label3: TLabel;
      SpeedButton3: TSpeedButton;
      procedure SpeedButton1Click(Sender: TObject);
      procedure Edit1Change(Sender: TObject);
      procedure SpeedButton2Click(Sender: TObject);
      procedure CB_MAGClick(Sender: TObject);
      procedure SpeedButton3Click(Sender: TObject);
   private
    { Déclarations privées }
   public
    { Déclarations publiques }
      Install: TInstall;
      procedure OnZipProgress(Sender: TObject; Percent: Integer);
      procedure OnMagasin(Sender: TObject; Magasin: string);
      procedure OnPoste(Sender: TObject; Poste: string);
      PROCEDURE OnPatch(Sender: TObject; Action: string; actu, max: Integer) ;
   end;

var
   Frm_InstallServeur: TFrm_InstallServeur;

implementation

{$R *.DFM}

procedure TFrm_InstallServeur.SpeedButton1Click(Sender: TObject);
begin
   if od.Execute then
      Edit1.text := od.filename;
end;

procedure TFrm_InstallServeur.Edit1Change(Sender: TObject);
begin
   if fileexists(edit1.text) then
   begin
      pg.ActivePage := dez;
      Pb1.Position := 0;
      Lab_Etat.Caption := '';
      pg.visible := true;
   end
   else
      pg.visible := false;
end;

procedure TFrm_InstallServeur.SpeedButton2Click(Sender: TObject);
var
   BaseTest: TBaseTest;
begin
   screen.cursor := crHourGlass;
   Enabled := false;
   try
      Edit1.enabled := false;
      {}
      SpeedButton1.enabled := false;
      Lab_Etat.Caption := 'Extraction des données'; Lab_Etat.Update;
      LoadSevenZipDLL;
      SevenZipExtractArchive(application.Handle,
                              edit1.text,
                              '"*.*"',
                              True,
                              '1082',
                              True,
                              'C:\Ginkoia\',
                              True);
      UnloadSevenZipDLL;
      Lab_Etat.Caption := 'Référencement de la base'; Lab_Etat.Update;
      {}
      Install := TInstall.create(self);
      Install.Referencement('c:\ginkoia\data\ginkoia.ib');
      {}
      Install.SetPathBPL;
//      Lab_Etat.Caption := 'Fabrication de la base test, patience ...'; Lab_Etat.Update;
//      BaseTest := TBaseTest.Create(self);
//      BaseTest.Creation;
//      BaseTest.free;
      {}
      install.Connexion('c:\ginkoia\data\ginkoia.ib');

      Install.OnNotifyMagasin := OnMagasin;
      Install.OnNotifyPoste := OnPoste;
      CB_MAG.Items.Clear;
      Install.ListeMagasin;
      CB_MAG.ItemIndex := 0;
      cb_Poste.Clear;
      if cb_Mag.ItemIndex > -1 then
         Install.ListePoste(cb_Mag.Items[cb_Mag.ItemIndex]);

      pg.ActivePage := inst;
   finally
      screen.cursor := crDefault;
      Enabled := true;
   end;
end;

procedure TFrm_InstallServeur.OnZipProgress(Sender: TObject;
   Percent: Integer);
begin
   Pb1.Position := Percent;
   Application.ProcessMessages;
end;

procedure TFrm_InstallServeur.OnMagasin(Sender: TObject; Magasin: string);
begin
   CB_MAG.Items.add(Magasin);
end;

procedure TFrm_InstallServeur.OnPoste(Sender: TObject; Poste: string);
begin
   cb_poste.Items.add(Poste);
   if poste = 'SERVEUR' then
      cb_Poste.ItemIndex := cb_poste.Items.count - 1;
end;

procedure TFrm_InstallServeur.CB_MAGClick(Sender: TObject);
begin
   cb_Poste.Clear;
   if cb_Mag.ItemIndex > -1 then
      Install.ListePoste(cb_Mag.Items[cb_Mag.ItemIndex]);
end;

procedure TFrm_InstallServeur.SpeedButton3Click(Sender: TObject);
{}
var
  PatchScript : TPatchScript ;
{}
begin
   if (cb_Mag.ItemIndex > -1) and
      (cb_poste.ItemIndex > -1) then
   begin
      screen.cursor := crHourGlass;
      try
         Install.SetPathBPL;
         Install.CreerINIServeur(cb_Mag.items[cb_Mag.itemindex], cb_Poste.items[cb_Poste.itemindex]);
         Install.free;
         {}
         PatchScript := TPatchScript.create(self) ;
         PatchScript.Connexion('c:\ginkoia\data\ginkoia.ib',true);
         PatchScript.ActionProgress := OnPatch ;
         PatchScript.Script ;
         PatchScript.Patch ;
         PatchScript.free ;
         {}
      finally
         screen.cursor := crDefault;
      end;
      application.MessageBox('Merci pour votre patience', 'Fin', MB_OK);
      Close;
   end;
end;

procedure TFrm_InstallServeur.OnPatch(Sender: TObject; Action: string;
  actu, max: Integer);
begin
   pb1.Max := max ;
   Pb1.Position := actu;
   Lab_Etat.Caption := Action ; Lab_Etat.Update;
   Application.ProcessMessages;
end;

end.

