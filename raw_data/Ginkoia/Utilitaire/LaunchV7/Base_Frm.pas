//$Log:
// 2    Utilitaires1.1         21/06/2005 09:46:44    pascal         
//      Possibilit? de mettre ? jour les note book pas en r?plication
//      automatique
// 1    Utilitaires1.0         27/04/2005 10:40:32    pascal          
//$
//$NoKeywords$
//
unit Base_Frm;

interface

uses CstLaunch,
   Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
   Buttons, ExtCtrls;

type

   TFrm_Base = class(TForm)
      OKBtn: TButton;
      CancelBtn: TButton;
      Bevel1: TBevel;
      Cb_Base: TComboBox;
      Cb_Auto: TCheckBox;
      Label1: TLabel;
      Ed_Heure1: TEdit;
      Label2: TLabel;
      Cb_Valide1: TCheckBox;
      Cb_Valide2: TCheckBox;
      Ed_Heure2: TEdit;
      Label3: TLabel;
      Label4: TLabel;
      Lb_Connexions: TListBox;
      Button1: TButton;
      Sb_Up: TSpeedButton;
      SB_Down: TSpeedButton;
      Button2: TButton;
      Button3: TButton;
      Cb_Back: TCheckBox;
      ed_BackTime: TEdit;
      Label5: TLabel;
    CB_ForceMaj: TCheckBox;
      procedure Cb_BaseChange(Sender: TObject);
      procedure Ed_Heure1Change(Sender: TObject);
      procedure Cb_AutoClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure Button1Click(Sender: TObject);
      procedure Lb_ConnexionsDblClick(Sender: TObject);
      procedure Sb_UpClick(Sender: TObject);
      procedure SB_DownClick(Sender: TObject);
      procedure Lb_ConnexionsKeyDown(Sender: TObject; var Key: Word;
         Shift: TShiftState);
      procedure Button2Click(Sender: TObject);
      procedure Button3Click(Sender: TObject);
   private
      FNeedHorraire: TOnNeedHorraire;
      FOnNeedConnexion: TonNeedConnexion;
      FOnNeedReplication: TOnNeedReplication;
      procedure SetNeedHorraire(const Value: TOnNeedHorraire);
      procedure UneConnexion(Nom, Tel: string; LeType, Ordre, ID: Integer);
      procedure UneReplication(Id: Integer; Ping, Push, Pull, User, PWD, URLLocal, URLDISTANT, PlaceEai, PlaceBase: string; Ordre: integer);
      procedure SetOnNeedConnexion(const Value: TonNeedConnexion);
      procedure Dispose_List_Connexion;
      procedure SetOnNeedReplication(const Value: TOnNeedReplication);
        { Private declarations }
   public
        { Public declarations }
      List_Connexion: Tlist;
      List_ConnSup: Tlist;
      List_Repli: TList;
      LAUID: Integer;
      BASID:Integer ;
      PRMID:Integer ;

      UnNv: Boolean;
      NvHeure1: string;
      NvHeure2: string;
      NvH1: Boolean;
      NvH2: Boolean;
      NvAuto: Boolean;
      NvDate: string;
      NvBack: Boolean;
      NvBackTime: string;
      function Execute: Boolean;
      property OnNeedHorraire: TOnNeedHorraire read FNeedHorraire write SetNeedHorraire;
      property OnNeedConnexion: TonNeedConnexion read FOnNeedConnexion write SetOnNeedConnexion;
      property OnNeedReplication: TOnNeedReplication read FOnNeedReplication write SetOnNeedReplication;
   end;

    {
    var
      Frm_Base: TFrm_Base;
    }

implementation
uses
   Connexion_frm,
   BaseModif_Frm,
   Replic_frm;
{$R *.DFM}

{ TFrm_Base }

function TFrm_Base.Execute: Boolean;
var
   H1: string;
   Valid1: Integer;
   H2: string;
   Valid2: Integer;
   Auto: Integer;
   LaDate: string;
   BackTime: string;
   Back: Integer;
   ForcerMAJ : boolean ;
   i : integer ;

begin
   UnNv := False;
   if (Cb_Base.ItemIndex >= 0) and (assigned(FNeedHorraire)) then
   begin
      BASID := Integer(Cb_Base.Items.Objects[Cb_Base.ItemIndex]);
      FNeedHorraire(BASID, true, LauId, H1, Valid1, H2, Valid2, Auto, LaDate, Back, BackTime, ForcerMAJ, PRMID);
      Ed_Heure1.text := H1;
      Ed_Heure2.text := H2;
      Cb_Valide1.Checked := Valid1 = 1;
      Cb_Valide2.Checked := Valid2 = 1;
      Cb_Auto.Checked := Auto = 1;
      CB_ForceMaj.Checked := ForcerMAJ ;
      Cb_Base.Enabled := True;
      Cb_Back.Checked := Back = 1;
      Ed_BackTime.text := BackTime;
      Dispose_List_Connexion;

      FNeedHorraire(BASID, False, LauId, NvHeure1, Valid1, NvHeure2, Valid2, Auto, NvDate, Back, NvBackTime, ForcerMAJ, i);
      NvH1 := Valid1 = 1;
      NvH2 := Valid2 = 1;
      NvAuto := Auto = 1;
      NvBack := Back = 1;

      FOnNeedConnexion(LauId, UneConnexion);
      FOnNeedReplication(LauId, UneReplication);
   end;
   Cb_Base.Enabled := true;
   result := ShowModal = MrOk;
end;

procedure TFrm_Base.SetNeedHorraire(const Value: TOnNeedHorraire);
begin
   FNeedHorraire := Value;
end;

procedure TFrm_Base.Cb_BaseChange(Sender: TObject);
var
   H1: string;
   Valid1: Integer;
   H2: string;
   Valid2: Integer;
   Auto: Integer;
   Ladate: string;
   Back: Integer;
   BackTime: string;
   ForcerMAJ:Boolean ;
   i:integer ;
begin
   if (Cb_Base.ItemIndex >= 0) and (assigned(FNeedHorraire)) then
   begin
      BASID := Integer(Cb_Base.Items.Objects[Cb_Base.ItemIndex]);
      FNeedHorraire(BASID, true, LauId, H1, Valid1, H2, Valid2, Auto, Ladate, Back, BackTime, ForcerMAJ, PRMID);
      Ed_Heure1.text := H1;
      Ed_Heure2.text := H2;
      Cb_Valide1.Checked := Valid1 = 1;
      Cb_Valide2.Checked := Valid2 = 1;
      Cb_Auto.Checked := Auto = 1;
      Cb_Base.Enabled := True;
      Cb_Back.Checked := Back = 1;
      CB_ForceMaj.Checked := ForcerMAJ ;
      Ed_BackTime.text := BackTime;

      FNeedHorraire(BASID, False, LauId, NvHeure1, Valid1, NvHeure2, Valid2, Auto, NvDate, Back, NvBackTime, ForcerMAJ,i);
      NvH1 := Valid1 = 1;
      NvH2 := Valid2 = 1;
      NvAuto := Auto = 1;
      NvBack := Back = 1;

      Dispose_List_Connexion;
      FOnNeedConnexion(LauId, UneConnexion);
      FOnNeedReplication(LauId, UneReplication);
   end;
end;

procedure TFrm_Base.Ed_Heure1Change(Sender: TObject);
begin
   Cb_Base.Enabled := false;
end;

procedure TFrm_Base.Cb_AutoClick(Sender: TObject);
begin
   Cb_Base.Enabled := false;
end;

procedure TFrm_Base.UneConnexion(Nom, Tel: string; LeType, Ordre, ID: Integer);
begin
   List_Connexion.Add(TLesConnexion.Create);
   TLesConnexion(List_Connexion[List_Connexion.Count - 1]).ID := ID;
   TLesConnexion(List_Connexion[List_Connexion.Count - 1]).Nom := Nom;
   TLesConnexion(List_Connexion[List_Connexion.Count - 1]).Tel := Tel;
   TLesConnexion(List_Connexion[List_Connexion.Count - 1]).LeType := LeType;
   TLesConnexion(List_Connexion[List_Connexion.Count - 1]).Ordre := Ordre;
   Lb_Connexions.Items.Add(NOM);
end;

procedure TFrm_Base.SetOnNeedConnexion(const Value: TonNeedConnexion);
begin
   FOnNeedConnexion := Value;
end;

procedure TFrm_Base.FormCreate(Sender: TObject);
begin
   List_Connexion := Tlist.create;
   List_ConnSup := Tlist.create;
   List_Repli := Tlist.create;
end;

procedure TFrm_Base.FormDestroy(Sender: TObject);
begin
   Dispose_List_Connexion;
   List_Connexion.Free;
   List_ConnSup.Free;
   List_Repli.free;
end;

procedure TFrm_Base.Dispose_List_Connexion;
var
   i: integer;
begin
   Lb_Connexions.Items.clear;
   for i := 0 to List_Connexion.Count - 1 do
      TLesConnexion(List_Connexion[i]).free;
   List_Connexion.Clear;
   for i := 0 to List_ConnSup.Count - 1 do
      TLesConnexion(List_ConnSup[i]).free;
   List_ConnSup.Clear;

   for i := 0 to List_Repli.Count - 1 do
      TLesreplication(List_Repli[i]).free;
   List_Repli.Clear;
end;

procedure TFrm_Base.Button1Click(Sender: TObject);
var
   Frm_Connexion: TFrm_Connexion;
begin
   Cb_Base.Enabled := false;
   application.createform(TFrm_Connexion, Frm_Connexion);
   try
      if Frm_Connexion.showModal = MrOk then
      begin
         List_Connexion.Add(TLesConnexion.Create);
         TLesConnexion(List_Connexion[List_Connexion.Count - 1]).ID := -1;
         TLesConnexion(List_Connexion[List_Connexion.Count - 1]).Nom := Frm_Connexion.Ed_Nom.Text;
         TLesConnexion(List_Connexion[List_Connexion.Count - 1]).Tel := Frm_Connexion.Ed_Tel.Text;
         if Frm_Connexion.Cb_Routeur.Checked then
            TLesConnexion(List_Connexion[List_Connexion.Count - 1]).LeType := 1
         else
            TLesConnexion(List_Connexion[List_Connexion.Count - 1]).LeType := 0;
         if List_Connexion.Count - 1 = 0 then
            TLesConnexion(List_Connexion[List_Connexion.Count - 1]).Ordre := 1
         else
            TLesConnexion(List_Connexion[List_Connexion.Count - 1]).Ordre :=
               TLesConnexion(List_Connexion[List_Connexion.Count - 2]).Ordre + 1;
         TLesConnexion(List_Connexion[List_Connexion.Count - 1]).Change := true;
         Lb_Connexions.Items.Add(Frm_Connexion.Ed_Nom.Text);
      end;
   finally
      Frm_Connexion.release;
   end;
end;

procedure TFrm_Base.UneReplication(Id: Integer; Ping, Push, Pull, User,
   PWD, URLLocal, URLDISTANT, PlaceEai, PlaceBase: string; Ordre: integer);
var
   repli: TLesreplication;
begin
   repli := TLesreplication.Create;
   repli.ID := id;
   repli.Ping := Ping;
   repli.Push := Push;
   repli.Pull := Pull;
   repli.User := user;
   repli.PWD := PWD;
   Repli.Ordre := Ordre;
   repli.URLLocal := URLLocal;
   repli.URLDISTANT := URLDISTANT;
   repli.placeEai := placeEai;
   Repli.PlaceBase := PlaceBase;
   List_Repli.Add(repli);
end;

procedure TFrm_Base.SetOnNeedReplication(const Value: TOnNeedReplication);
begin
   FOnNeedReplication := Value;
end;

procedure TFrm_Base.Lb_ConnexionsDblClick(Sender: TObject);
var
   Connexion: TLesConnexion;
   Frm_Connexion: TFrm_Connexion;
   i: Integer;
begin
   I := Lb_Connexions.ItemIndex;
   if i >= 0 then
   begin
      Connexion := TLesConnexion(List_Connexion[i]);
      application.createform(TFrm_Connexion, Frm_Connexion);
      try
         Frm_Connexion.Ed_Nom.Text := Connexion.Nom;
         Frm_Connexion.Ed_Tel.Text := Connexion.TEL;
         Frm_Connexion.Cb_Routeur.Checked := Connexion.LeType = 1;
         if Frm_Connexion.showModal = MrOk then
         begin
            Connexion.Nom := Frm_Connexion.Ed_Nom.Text;
            Connexion.TEL := Frm_Connexion.Ed_Tel.Text;
            if Frm_Connexion.Cb_Routeur.Checked then
               Connexion.LeType := 1
            else
               Connexion.LeType := 0;
            Connexion.Change := true;
            Lb_Connexions.Items[i] := Connexion.Nom;
         end;
      finally
         Frm_Connexion.release;
      end;
   end;
end;

procedure TFrm_Base.Sb_UpClick(Sender: TObject);
var
   i: integer;
   OldOrdre: Integer;
begin
   if Lb_Connexions.ItemIndex > 0 then
   begin
      i := Lb_Connexions.ItemIndex;
      Lb_Connexions.items.Exchange(I, i - 1);
      List_Connexion.Exchange(i, I - 1);
      TLesConnexion(List_Connexion[i]).Change := true;
      TLesConnexion(List_Connexion[i - 1]).Change := true;
      OldOrdre := TLesConnexion(List_Connexion[i]).Ordre;
      TLesConnexion(List_Connexion[i]).Ordre := TLesConnexion(List_Connexion[i - 1]).Ordre;
      TLesConnexion(List_Connexion[i - 1]).Ordre := OldOrdre;
      Lb_Connexions.ItemIndex := i - 1;
   end;
end;

procedure TFrm_Base.SB_DownClick(Sender: TObject);
var
   i: integer;
   OldOrdre: Integer;
begin
   if (Lb_Connexions.ItemIndex < Lb_Connexions.Items.Count - 1) then
   begin
      i := Lb_Connexions.ItemIndex;
      Lb_Connexions.items.Exchange(I, i + 1);
      List_Connexion.Exchange(i, I + 1);
      TLesConnexion(List_Connexion[i]).Change := true;
      TLesConnexion(List_Connexion[i + 1]).Change := true;
      OldOrdre := TLesConnexion(List_Connexion[i]).Ordre;
      TLesConnexion(List_Connexion[i]).Ordre := TLesConnexion(List_Connexion[i + 1]).Ordre;
      TLesConnexion(List_Connexion[i + 1]).Ordre := OldOrdre;
      Lb_Connexions.ItemIndex := i + 1;
   end;
end;

procedure TFrm_Base.Lb_ConnexionsKeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
var
   Connexion: TLesConnexion;
   i: integer;
begin
   if key = VK_DELETE then
   begin
      if Lb_Connexions.ItemIndex >= 0 then
      begin
         Key := 0;
         if Application.MessageBox('Suppression de la connexion ', 'Suppression', MB_YESNO + MB_DEFBUTTON2) = IDYES then
         begin
            i := Lb_Connexions.ItemIndex;
            Connexion := TLesConnexion(List_Connexion[i]);
            Lb_Connexions.items.Delete(i);
            List_Connexion.Delete(i);
            if Connexion.ID <> -1 then
               List_ConnSup.Add(Connexion)
            else
               Connexion.free;
         end;
      end;
   end;
end;

procedure TFrm_Base.Button2Click(Sender: TObject);
var
   frm_replic: Tfrm_replic;
begin
    // Gestion des réplication
   Cb_Base.Enabled := False;
   Application.CreateForm(Tfrm_replic, frm_replic);
   try
      frm_replic.execute(List_Repli);
   finally
      frm_replic.release;
   end;
    //
end;

procedure TFrm_Base.Button3Click(Sender: TObject);
var
   frm_BaseModif: Tfrm_BaseModif;
begin
   Application.CreateForm(Tfrm_BaseModif, frm_BaseModif);
   try
      frm_BaseModif.Ed_Heure1.text := NvHeure1;
      frm_BaseModif.Ed_Heure2.text := NvHeure2;
      frm_BaseModif.Cb_Valide1.Checked := NvH1;
      frm_BaseModif.Cb_Valide2.Checked := NvH2;
      frm_BaseModif.Cb_Auto.Checked := NvAuto;
      frm_BaseModif.Ed_Date.text := NvDate;
      frm_BaseModif.Cb_Back.Checked := NvBack;
      frm_BaseModif.Ed_BackTime.text := NvHeure2;
      if frm_BaseModif.ShowModal = Mrok then
      begin
         Cb_Base.Enabled := False;
         UnNv := True;
         NvHeure1 := frm_BaseModif.Ed_Heure1.text;
         NvHeure2 := frm_BaseModif.Ed_Heure2.text;
         NvH1 := frm_BaseModif.Cb_Valide1.Checked;
         NvH2 := frm_BaseModif.Cb_Valide2.Checked;
         NvAuto := frm_BaseModif.Cb_Auto.Checked;
         NvDate := frm_BaseModif.Ed_Date.text;
         NvBack := frm_BaseModif.Cb_Back.Checked;
         NvHeure2 := frm_BaseModif.Ed_BackTime.text;
      end;
   finally
      frm_BaseModif.release;
   end;
end;

end.

