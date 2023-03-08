unit Jeton_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  //Start Uses Perso
  GestionJetonLaunch,
  IOUtils,
  AlgolStdFrm,
  GinkoiaStyle_dm,
  AlgolDialogForms,
  Jeton_Dm,
  UTools,
  Dialogs,
  //End Uses Perso
  StdCtrls, ExtCtrls, RzPanel, AdvGlowButton;

type
  TFrm_Jeton = class(TAlgolDialogForm)
    ed_BasePath: TEdit;
    lbl_BaseGinkoia: TLabel;
    btn_BasePath: TAdvGlowButton;
    lbl_Magasin: TLabel;
    cb_Magasin: TComboBox;
    Pan_Btn: TRzPanel;
    Btn_Param: TAdvGlowButton;
    Btn_GetJeton: TAdvGlowButton;
    Btn_DelJeton: TAdvGlowButton;
    AdvGlowButton1: TAdvGlowButton;
    procedure btn_BasePathClick(Sender: TObject);
    procedure Btn_GetJetonClick(Sender: TObject);
    procedure Btn_DelJetonClick(Sender: TObject);
    procedure Btn_ParamClick(Sender: TObject);
    procedure cb_MagasinChange(Sender: TObject);
    procedure AlgolDialogFormCreate(Sender: TObject);
    procedure AlgolDialogFormClose(Sender: TObject; var Action: TCloseAction);
    procedure AdvGlowButton1Click(Sender: TObject);
  private
    tpJeton     : TTokenParams;
    bJeton      : Boolean;        //Vrai si on a le jeton sinon faux
    BaseID      : Integer;
    function OpenIBDatabase(ABasePath: String): Boolean;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_Jeton: TFrm_Jeton;

implementation

Uses
  Param_Frm;

{$R *.dfm}

function TFrm_Jeton.OpenIBDatabase(ABasePath: String): Boolean;
begin
  Result := False;
  // Ouverture de la base GINKOIA
  Dm_Jeton.Dtb_Ginkoia.Close;
  Dm_Jeton.Dtb_Ginkoia.DatabaseName := ABasePath;
  Dm_Jeton.Dtb_Ginkoia.Params.Add('user_name=GINKOIA');
  Dm_Jeton.Dtb_Ginkoia.Params.Add('password=ginkoia');
  try
    Dm_Jeton.Dtb_Ginkoia.Open;
    Result := True;
  Except on E:Exception do
    raise Exception.Create('InitGinkoiaDB -> ' + E.Message);
  end;
end;

procedure TFrm_Jeton.AdvGlowButton1Click(Sender: TObject);
var
  BBloque : boolean;
begin
  BBloque := LocalBloqueReplic(ed_BasePath.Text,'ginkoia','ginkoia', -1, True);

  if BBLoque then
    showmessage('ok')
  else
    showmessage('pas ok');


  showmessage('en pause');
  LocalDebloqueReplic;
end;

procedure TFrm_Jeton.AlgolDialogFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if bJeton then
  begin
    StopTokenEnBoucle;      //Relache le jeton
  end;
end;

procedure TFrm_Jeton.AlgolDialogFormCreate(Sender: TObject);
begin
  Dm_GinkoiaStyle.AppliqueAllStyleAdvGlowButton(Self);
  bJeton  := False;
  btn_BasePath.Enabled  := True;
  Btn_Param.Enabled     := False;
  Btn_GetJeton.Enabled  := False;
  Btn_DelJeton.Enabled  := False;
end;

procedure TFrm_Jeton.btn_BasePathClick(Sender: TObject);
var
  odTemp  : TOpenDialog;
  iTmp    : integer;
begin
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'InterBase|*.ib';
    odTemp.Title := 'Choix de la base de données';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    odTemp.Execute;
    if odTemp.FileName <> '' then
      ed_BasePath.Text := odTemp.FileName;
  finally
    odTemp.Free;
  end;

  if ed_BasePath.Text <> '' then
  begin
    if not OpenIBDatabase(ed_BasePath.Text) then
      ShowMessage('Problème de connexion à la base de données');

    Dm_Jeton.Que_ListeMag.Open;
    Dm_Jeton.Que_ListeMag.First;
    cb_Magasin.Clear;
    iTmp := -1;
    cb_Magasin.AddItem('Choisir la base', TObject(iTmp));
    while not Dm_Jeton.Que_ListeMag.Eof do
    begin
      cb_Magasin.AddItem(Dm_Jeton.Que_ListeMag.FieldByName('BAS_NOM').AsString, TObject(Dm_Jeton.Que_ListeMag.FieldByName('BAS_ID').AsInteger));
      Dm_Jeton.Que_ListeMag.Next;
    end;

    if cb_Magasin.Items.Count>0 then
    begin
      cb_Magasin.ItemIndex := 0;
      BaseID := Integer(cb_Magasin.Items.Objects[cb_Magasin.ItemIndex]);
    end;

    btn_BasePath.Enabled  := True;
    Btn_Param.Enabled     := False;
    Btn_GetJeton.Enabled  := True;
    Btn_DelJeton.Enabled  := False;
  end;
end;

procedure TFrm_Jeton.Btn_DelJetonClick(Sender: TObject);
begin
  try
    if bJeton then
    begin
      try
        StopTokenEnBoucle;      //Relache le jeton
      finally
        bJeton := False;
      end;
    end;
  finally
    btn_BasePath.Enabled  := True;
    if BaseID = 0 then
    begin
      Btn_Param.Enabled   := False;
    end
    else
    begin
      Btn_Param.Enabled   := True;
    end;
    Btn_GetJeton.Enabled  := True;
    Btn_DelJeton.Enabled  := False;
  end;
end;

procedure TFrm_Jeton.Btn_GetJetonClick(Sender: TObject);
begin
  if not TFile.Exists(ed_BasePath.Text) then
  begin
    ShowMessage('La base n''existe pas. Merci de vérifier le chemin.');
  end
  else
  begin
    try
      tpJeton := GetParamsToken(ed_BasePath.Text,'ginkoia','ginkoia');    //Prise en compte des Jetons
      bJeton  := False;

      if tpJeton.bLectureOK then
      begin
        bJeton  := StartTokenEnBoucle(tpJeton, 30000);             //On rafraichi toute les 30s
      end;

      if not bJeton then    //Si pas de jeton
      begin
        ShowMessage('Impossible de prendre un Jeton.');
      end
      else
      begin
        ShowMessage('Jeton prit, pensez à le rendre à la fin du traitement.');
        btn_BasePath.Enabled  := False;
        Btn_Param.Enabled     := False;
        Btn_GetJeton.Enabled  := False;
        Btn_DelJeton.Enabled  := True;
      end;
    except on e:Exception do
      ShowMessage('Erreur dans Btn_GetJetonClick : ' + e.Message);
    end;
  end;
end;

procedure TFrm_Jeton.Btn_ParamClick(Sender: TObject);
begin
  ExecuteParamFrm(BaseID);
end;

procedure TFrm_Jeton.cb_MagasinChange(Sender: TObject);
begin
  if (cb_Magasin.ItemIndex <> -1) and (cb_Magasin.ItemIndex <> 0) then
  begin
    Btn_Param.Enabled := True;
    BaseID := Integer(cb_Magasin.Items.Objects[cb_Magasin.ItemIndex]);
  end
  else
  begin
    Btn_Param.Enabled := False;
    BaseID := 0;
  end;
end;

initialization
  UTools.initLogFileName(0, Application.ExeName, 'yyyy_mm_dd');

end.
