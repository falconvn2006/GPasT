unit UInstallClient;

interface

uses
   split_frm,
   Param_frm,
   Ident_Frm, ChxBase, UInternet, SevenZip, UInstall, UBase, ChxMagPoste_frm,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   ActiveX, AxCtrls, InstallClient_TLB, StdVcl, ComCtrls, StdCtrls, UCst;

type
   TInstallClientX = class(TActiveForm, IInstallClientX)
      PB: TProgressBar;
      lab_etat: TLabel;
      procedure ActiveFormCreate(Sender: TObject);
   private
    { Déclarations privées }
      FEvents: IInstallClientXEvents;
      procedure ActivateEvent(Sender: TObject);
      procedure ClickEvent(Sender: TObject);
      procedure CreateEvent(Sender: TObject);
      procedure DblClickEvent(Sender: TObject);
      procedure DeactivateEvent(Sender: TObject);
      procedure DestroyEvent(Sender: TObject);
      procedure KeyPressEvent(Sender: TObject; var Key: Char);
      procedure PaintEvent(Sender: TObject);
   protected
    { Déclarations protégées }
      procedure DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage); override;
      procedure EventSinkChanged(const EventSink: IUnknown); override;
      function Get_Active: WordBool; safecall;
      function Get_AutoScroll: WordBool; safecall;
      function Get_AutoSize: WordBool; safecall;
      function Get_AxBorderStyle: TxActiveFormBorderStyle; safecall;
      function Get_Caption: WideString; safecall;
      function Get_Color: OLE_COLOR; safecall;
      function Get_Cursor: Smallint; safecall;
      function Get_DoubleBuffered: WordBool; safecall;
      function Get_DropTarget: WordBool; safecall;
      function Get_Enabled: WordBool; safecall;
      function Get_Font: IFontDisp; safecall;
      function Get_HelpFile: WideString; safecall;
      function Get_KeyPreview: WordBool; safecall;
      function Get_PixelsPerInch: Integer; safecall;
      function Get_PrintScale: TxPrintScale; safecall;
      function Get_Scaled: WordBool; safecall;
      function Get_Visible: WordBool; safecall;
      function Get_VisibleDockClientCount: Integer; safecall;
    procedure _Set_Font(var Value: IFontDisp); safecall;
      procedure Set_AutoScroll(Value: WordBool); safecall;
      procedure Set_AutoSize(Value: WordBool); safecall;
      procedure Set_AxBorderStyle(Value: TxActiveFormBorderStyle); safecall;
      procedure Set_Caption(const Value: WideString); safecall;
      procedure Set_Color(Value: OLE_COLOR); safecall;
      procedure Set_Cursor(Value: Smallint); safecall;
      procedure Set_DoubleBuffered(Value: WordBool); safecall;
      procedure Set_DropTarget(Value: WordBool); safecall;
      procedure Set_Enabled(Value: WordBool); safecall;
    procedure Set_Font(const Value: IFontDisp); safecall;
      procedure Set_HelpFile(const Value: WideString); safecall;
      procedure Set_KeyPreview(Value: WordBool); safecall;
      procedure Set_PixelsPerInch(Value: Integer); safecall;
      procedure Set_PrintScale(Value: TxPrintScale); safecall;
      procedure Set_Scaled(Value: WordBool); safecall;
      procedure Set_Visible(Value: WordBool); safecall;
    procedure Recuperation(const AURL, ALectTools, ALectLame: WideString); safecall;
    procedure SplitBase(recup: WordBool; const AURL, ALectTools,
      ALectLame: WideString; ADoZipAuto: WordBool); safecall;
    procedure Parametrage(const AURL, ALectTools, ALectLame: WideString); safecall;
   public
    { Déclarations publiques }
      procedure Initialize; override;
      procedure OnInternetProgress(Sender: TObject; Actuel: Integer; Maximum: Integer);
      procedure OnZipProgress(Sender: TObject; Percent: Integer);
      procedure OnPatch(Sender: TObject; Action: string; actu, max: Integer);
   end;

implementation

uses ComObj, ComServ;

{$R *.DFM}

{ TInstallClientX }

procedure TInstallClientX.DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage);
begin
  { Définir des pages de propriétés ici. Les pages de propriétés sont définies en
    appelant DefinePropertyPage avec l'id de classe de la page. Par exemple,
      DefinePropertyPage(Class_InstallClientXPage); }
end;

procedure TInstallClientX.EventSinkChanged(const EventSink: IUnknown);
begin
   FEvents := EventSink as IInstallClientXEvents;
end;

procedure TInstallClientX.Initialize;
begin
   inherited Initialize;
   OnActivate := ActivateEvent;
   OnClick := ClickEvent;
   OnCreate := CreateEvent;
   OnDblClick := DblClickEvent;
   OnDeactivate := DeactivateEvent;
   OnDestroy := DestroyEvent;
   OnKeyPress := KeyPressEvent;
   OnPaint := PaintEvent;
end;

function TInstallClientX.Get_Active: WordBool;
begin
   Result := Active;
end;

function TInstallClientX.Get_AutoScroll: WordBool;
begin
   Result := AutoScroll;
end;

function TInstallClientX.Get_AutoSize: WordBool;
begin
   Result := AutoSize;
end;

function TInstallClientX.Get_AxBorderStyle: TxActiveFormBorderStyle;
begin
   Result := Ord(AxBorderStyle);
end;

function TInstallClientX.Get_Caption: WideString;
begin
   Result := WideString(Caption);
end;

function TInstallClientX.Get_Color: OLE_COLOR;
begin
   Result := OLE_COLOR(Color);
end;

function TInstallClientX.Get_Cursor: Smallint;
begin
   Result := Smallint(Cursor);
end;

function TInstallClientX.Get_DoubleBuffered: WordBool;
begin
   Result := DoubleBuffered;
end;

function TInstallClientX.Get_DropTarget: WordBool;
begin
   Result := DropTarget;
end;

function TInstallClientX.Get_Enabled: WordBool;
begin
   Result := Enabled;
end;

function TInstallClientX.Get_Font: IFontDisp;
begin
   GetOleFont(Font, Result);
end;

function TInstallClientX.Get_HelpFile: WideString;
begin
   Result := WideString(HelpFile);
end;

function TInstallClientX.Get_KeyPreview: WordBool;
begin
   Result := KeyPreview;
end;

function TInstallClientX.Get_PixelsPerInch: Integer;
begin
   Result := PixelsPerInch;
end;

function TInstallClientX.Get_PrintScale: TxPrintScale;
begin
   Result := Ord(PrintScale);
end;

function TInstallClientX.Get_Scaled: WordBool;
begin
   Result := Scaled;
end;

function TInstallClientX.Get_Visible: WordBool;
begin
   Result := Visible;
end;

function TInstallClientX.Get_VisibleDockClientCount: Integer;
begin
   Result := VisibleDockClientCount;
end;

procedure TInstallClientX._Set_Font(var Value: IFontDisp);
begin
   SetOleFont(Font, Value);
end;

procedure TInstallClientX.ActivateEvent(Sender: TObject);
begin
   if FEvents <> nil then FEvents.OnActivate;
end;

procedure TInstallClientX.ClickEvent(Sender: TObject);
begin
   if FEvents <> nil then FEvents.OnClick;
end;

procedure TInstallClientX.CreateEvent(Sender: TObject);
begin
   if FEvents <> nil then FEvents.OnCreate;
end;

procedure TInstallClientX.DblClickEvent(Sender: TObject);
begin
   if FEvents <> nil then FEvents.OnDblClick;
end;

procedure TInstallClientX.DeactivateEvent(Sender: TObject);
begin
   if FEvents <> nil then FEvents.OnDeactivate;
end;

procedure TInstallClientX.DestroyEvent(Sender: TObject);
begin
   if FEvents <> nil then FEvents.OnDestroy;
end;

procedure TInstallClientX.KeyPressEvent(Sender: TObject; var Key: Char);
var
   TempKey: Smallint;
begin
   TempKey := Smallint(Key);
   if FEvents <> nil then FEvents.OnKeyPress(TempKey);
   Key := Char(TempKey);
end;

procedure TInstallClientX.PaintEvent(Sender: TObject);
begin
   if FEvents <> nil then FEvents.OnPaint;
end;

procedure TInstallClientX.Set_AutoScroll(Value: WordBool);
begin
   AutoScroll := Value;
end;

procedure TInstallClientX.Set_AutoSize(Value: WordBool);
begin
   AutoSize := Value;
end;

procedure TInstallClientX.Set_AxBorderStyle(
   Value: TxActiveFormBorderStyle);
begin
   AxBorderStyle := TActiveFormBorderStyle(Value);
end;

procedure TInstallClientX.Set_Caption(const Value: WideString);
begin
   Caption := TCaption(Value);
end;

procedure TInstallClientX.Set_Color(Value: OLE_COLOR);
begin
   Color := TColor(Value);
end;

procedure TInstallClientX.Set_Cursor(Value: Smallint);
begin
   Cursor := TCursor(Value);
end;

procedure TInstallClientX.Set_DoubleBuffered(Value: WordBool);
begin
   DoubleBuffered := Value;
end;

procedure TInstallClientX.Set_DropTarget(Value: WordBool);
begin
   DropTarget := Value;
end;

procedure TInstallClientX.Set_Enabled(Value: WordBool);
begin
   Enabled := Value;
end;

procedure TInstallClientX.Set_Font(const Value: IFontDisp);
begin
   SetOleFont(Font, Value);
end;

procedure TInstallClientX.Set_HelpFile(const Value: WideString);
begin
   HelpFile := string(Value);
end;

procedure TInstallClientX.Set_KeyPreview(Value: WordBool);
begin
   KeyPreview := Value;
end;

procedure TInstallClientX.Set_PixelsPerInch(Value: Integer);
begin
   PixelsPerInch := Value;
end;

procedure TInstallClientX.Set_PrintScale(Value: TxPrintScale);
begin
   PrintScale := TPrintScale(Value);
end;

procedure TInstallClientX.Set_Scaled(Value: WordBool);
begin
   Scaled := Value;
end;

procedure TInstallClientX.Set_Visible(Value: WordBool);
begin
   Visible := Value;
end;

procedure TInstallClientX.Recuperation(const AURL, ALectTools,
  ALectLame: WideString);
var
   frm_Ident: Tfrm_Ident;
   Id, Psw: string;
   Internet: TInternet;
   fich: string;
   Install: TInstall;
   BaseTest: TBaseTest;
   frm_ChxMagPoste: Tfrm_ChxMagPoste;
   PatchScript: TPatchScript;
begin
   LecteurLame := ALectLame;
   LecteurTools := ALectTools;
   PUrl := AURL;


   Application.Createform(Tfrm_Ident, frm_Ident);
   if frm_Ident.ShowModal = mrok then
   begin
      Id := frm_Ident.ed_Ident.text;
      Psw := frm_Ident.ed_Password.text;
      Internet := TInternet.create(self);
      fich := Internet.Connexion(Id, Psw);
      if Fich <> '' then
      begin
         lab_etat.caption := 'Récupération du fichier d''installation en cours';
         Application.processMessages;
         Internet.OnProgress := OnInternetProgress;
         Internet.Download(Fich);
         lab_etat.caption := 'Extraction en cours';
         Pb.Position := 0;
         PB.Max := 100;
         Application.processMessages;
         while pos('/', fich) > 0 do
            delete(fich, 1, pos('/', fich));

         SevenZipExtractArchive(application.Handle,
                                ExtractFileName(fich),
                                'C:\TMP\' + ExtractFilePath(fich),
                                True,
                                '1082',
                                True,
                                'C:\Ginkoia\',
                                True);
         Lab_Etat.Caption := 'Référencement de la base';
         Application.processMessages;
         Install := TInstall.create(self);
         Install.Referencement('c:\ginkoia\data\ginkoia.ib');
         Install.SetPathBPL;
         Lab_Etat.Caption := 'Fabrication de la base test, patience ...';
         Application.processMessages;
         BaseTest := TBaseTest.Create(self);
         BaseTest.Creation;
         BaseTest.free;
         install.Connexion('c:\ginkoia\data\ginkoia.ib');
         Application.CreateForm(Tfrm_ChxMagPoste, frm_ChxMagPoste);
         Install.OnNotifyMagasin := frm_ChxMagPoste.OnMagasin;
         Install.OnNotifyPoste := frm_ChxMagPoste.OnPoste;
         frm_ChxMagPoste.CB_MAG.Items.Clear;
         Install.ListeMagasin;
         frm_ChxMagPoste.CB_MAG.ItemIndex := 0;
         frm_ChxMagPoste.cb_Poste.Clear;
         if frm_ChxMagPoste.cb_Mag.ItemIndex > -1 then
            Install.ListePoste(frm_ChxMagPoste.cb_Mag.Items[frm_ChxMagPoste.cb_Mag.ItemIndex]);
         if frm_ChxMagPoste.execute(install) = mrok then
         begin
            if (frm_ChxMagPoste.cb_Mag.ItemIndex > -1) and
               (frm_ChxMagPoste.cb_poste.ItemIndex > -1) then
            begin
               Install.CreerINIServeur(frm_ChxMagPoste.cb_Mag.items[frm_ChxMagPoste.cb_Mag.itemindex], frm_ChxMagPoste.cb_Poste.items[frm_ChxMagPoste.cb_Poste.itemindex]);
            end;
         end;
         frm_ChxMagPoste.release;
         install.free;

         PatchScript := TPatchScript.create(self);
         PatchScript.Connexion('c:\ginkoia\data\ginkoia.ib', True);
         PatchScript.ActionProgress := OnPatch;
         PatchScript.Script;
         PatchScript.Patch;
         PatchScript.free;

      end
      else
      begin
         Application.messageBox('Mauvais identifiant ou mot de passe', '  Erreur', MB_OK);
      end;
      Internet.free;
   end;
   frm_Ident.release;
end;

procedure TInstallClientX.OnInternetProgress(Sender: TObject; Actuel,
   Maximum: Integer);
begin
   if Actuel = -1 then
   begin
      Pb.Position := PB.Max;
      lab_etat.caption := 'Sauvegarde du fichier en cours ...';
   end
   else
   begin
      PB.Max := Maximum;
      Pb.Position := Actuel;
   end;
   Application.ProcessMessages;
end;

procedure TInstallClientX.ActiveFormCreate(Sender: TObject);
begin
   lab_etat.caption := '';
end;

procedure TInstallClientX.OnZipProgress(Sender: TObject; Percent: Integer);
begin
   Pb.Position := Percent;
   Application.ProcessMessages;
end;

procedure TInstallClientX.OnPatch(Sender: TObject; Action: string; actu,
   max: Integer);
begin
   pb.Max := max;
   Pb.Position := actu;
   Lab_Etat.Caption := Action; Lab_Etat.Update;
   Application.ProcessMessages;
end;

procedure TInstallClientX.SplitBase(recup: WordBool; const AURL, ALectTools,
  ALectLame: WideString; ADoZipAuto: WordBool);
var
   ChoixBase: TChoixBase;
   Frm_Split: TFrm_Split;
begin
   application.createform(TChoixBase, ChoixBase);
   try
      if ChoixBase.ShowModal = MrOk then
      begin
         application.CreateForm(tFrm_Split, Frm_Split);
         Frm_Split.Base := ChoixBase.Base;
         Frm_Split.recup := recup;
         LecteurLame := ALectLame;
         LecteurTools := ALectTools;
         PUrl := AURL;
         bDoZipAuto := ADoZipAuto;
         
         if recup then
            Frm_Split.Caption := 'Récupération de base';
            
         Frm_Split.execute;
         Frm_Split.release;
      end;
   finally
      ChoixBase.release;
   end;
end;

procedure TInstallClientX.Parametrage(const AURL, ALectTools,
  ALectLame: WideString);
var
   ChoixBase: TChoixBase;
   frm_param: Tfrm_param;
begin
   LecteurLame := ALectLame;
   LecteurTools := ALectTools;
   PUrl := AURL;
   
   application.createform(TChoixBase, ChoixBase);
   try
      if ChoixBase.ShowModal = MrOk then
      begin
         application.CreateForm(tfrm_param, frm_param);
         frm_param.DatabaseName := ChoixBase.Base;
         frm_param.Execute;
         frm_param.release;
      end;
   finally
      ChoixBase.release;
   end;
end;

initialization
   TActiveFormFactory.Create(
      ComServer,
      TActiveFormControl,
      TInstallClientX,
      Class_InstallClientX,
      1,
      '',
      OLEMISC_SIMPLEFRAME or OLEMISC_ACTSLIKELABEL,
      tmApartment);
end.

