unit ProvidersSubscribers_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  //Uses Perso
  GinkoiaStyle_dm, AlgolDialogForms, Param_Dm, Jeton_Dm,
  //End
  Dialogs, StdCtrls, AdvEdit, AdvGlowButton, RzLabel, ExtCtrls, RzPanel;

type
  TFrm_ProvidersSubscribers = class(TAlgolDialogForm)
    Pan_Btn: TRzPanel;
    Nbt_Cancel: TRzLabel;
    Lab_OuAnnuler: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    ed_Nom: TAdvEdit;
    Lab_Nom: TLabel;
    ed_Loop: TAdvEdit;
    Lab_Loop: TLabel;
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
  private
    iGlobProSubId,
    iRepId          : Integer;
    bGlobAjout,
    bGlobProviders  : Boolean;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_ProvidersSubscribers: TFrm_ProvidersSubscribers;

Function ExecuteProviderSubscribersFrm(aAjout,aProvider:Boolean;aRepId:Integer;aProSubId:Integer = 0;aNom:string = '';aLoop:Integer = 0):Boolean;

implementation

{$R *.dfm}

Function ExecuteProviderSubscribersFrm(aAjout,aProvider:Boolean;aRepId:Integer;aProSubId:Integer;aNom:string;aLoop:Integer):Boolean;
begin
  Result := False;
  Frm_ProvidersSubscribers := TFrm_ProvidersSubscribers.Create(Nil);
  TRY
    if aAjout then
    begin
      if aProvider then
        Frm_ProvidersSubscribers.Caption := 'Ajout d''un Provider'
      else
        Frm_ProvidersSubscribers.Caption := 'Ajout d''un Subscription';
      Frm_ProvidersSubscribers.ed_Loop.Text := '0';
    end
    else
    begin
      Frm_ProvidersSubscribers.ed_Nom.Text := aNom;
      Frm_ProvidersSubscribers.ed_Loop.Text := IntToStr(aLoop);
      if aProvider then
        Frm_ProvidersSubscribers.Caption := 'Modification d''un Provider'
      else
        Frm_ProvidersSubscribers.Caption := 'Modification d''un Subscription';
    end;

    Frm_ProvidersSubscribers.iGlobProSubId  := aProSubId;
    Frm_ProvidersSubscribers.iRepId         := aRepId;
    Frm_ProvidersSubscribers.bGlobAjout     := aAjout;
    Frm_ProvidersSubscribers.bGlobProviders := aProvider;

    Result := Frm_ProvidersSubscribers.ShowModal = mrOk;
  FINALLY
    Frm_ProvidersSubscribers.Release;
  END;
end;

procedure TFrm_ProvidersSubscribers.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrm_ProvidersSubscribers.Nbt_PostClick(Sender: TObject);
var
  id : Integer;
begin
  try
    //Démarre une transaction
    if Dm_Jeton.Tra_Ginkoia.InTransaction then
      Dm_Jeton.Tra_Ginkoia.Commit;
    Dm_Jeton.Tra_Ginkoia.StartTransaction;

    if bGlobAjout then
    begin
      if bGlobProviders then
      begin
        id := Dm_Param.AddProviders(ed_Nom.Text,StrToInt(ed_Loop.Text));
      end
      else
      begin
        id := Dm_Param.AddSubscribers(ed_Nom.Text,StrToInt(ed_Loop.Text));
      end;
    end
    else
    begin
      if bGlobProviders then
      begin
        Dm_Param.ModifyProviders(iGlobProSubId,ed_Nom.Text,StrToInt(ed_Loop.Text));
      end
      else
      begin
        Dm_Param.ModifySubscribers(iGlobProSubId,ed_Nom.Text,StrToInt(ed_Loop.Text));
      end;
      id := iGlobProSubId;
    end;

    Dm_Jeton.Tra_Ginkoia.Commit;

    if bGlobProviders then
    begin
      Dm_Param.RefreshProviders(iRepId);
      Dm_Param.LocateDProId(id);
      Dm_Param.LocateTProId(id);
    end
    else
    begin
      Dm_Param.RefreshSubscribers(iRepId);
      Dm_Param.LocateDSubId(id);
      Dm_Param.LocateTSubId(id);
    end;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de l''ajout/modification d''un Provider/Subscriber. (' + e.Message + ')');
      ModalResult := mrCancel;
      Dm_Jeton.Tra_Ginkoia.Rollback;
    end;
  end;
  ModalResult := mrOk
end;

end.
