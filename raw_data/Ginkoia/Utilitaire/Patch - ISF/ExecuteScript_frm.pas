unit ExecuteScript_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ClassDossier, RzTabs, AssistComClient_frm, AddDossier_frm,
  ComCtrls, ListBase, ImgList, LMDCustomImageList, LMDBitmapList, uThreadProc, inifiles, ParamMail_frm, GestionEMail,
  GestionJetonLaunch, ActiveX, IdBaseComponent, IdSASL, IdSASLAnonymous;

type
  TFrm_ExecuteScript = class(TForm)
    Lab_Step1: TLabel;
    l2: TLabel;
    Lab_Step2: TLabel;
    Shape_Step2: TShape;
    Lab_Step3: TLabel;
    Shape_Step3: TShape;
    l4: TLabel;
    Lab_Step4: TLabel;
    Shape_Step4: TShape;
    Pan_Frise: TPanel;
    Shape_Line: TShape;
    l3: TLabel;
    Pan_Script: TPanel;
    PageControl: TRzPageControl;
    Tab_Scripts: TRzTabSheet;
    Pan_Script_Btn: TPanel;
    Tab_Bases: TRzTabSheet;
    Tab_Options: TRzTabSheet;
    Tab_Traitement: TRzTabSheet;
    Nbt_AssistantComClient: TSpeedButton;
    Nbt_EffacerScript: TSpeedButton;
    Pan_Bases: TPanel;
    Pan_Bases_Btn: TPanel;
    Nbt_AddDossier: TSpeedButton;
    Nbt_LoadListXML: TSpeedButton;
    Nbt_SaveListXML: TSpeedButton;
    Nbt_DeleteDossier: TSpeedButton;
    Pan_BasePage: TPanel;
    Memo_Script: TMemo;
    lv_dossiers: TListView;
    Btn_before: TButton;
    Btn_Next: TButton;
    OD_XML: TOpenDialog;
    SD_XML: TSaveDialog;
    Pan_Log: TPanel;
    Pan_Progress: TPanel;
    Lab_LogTraitement: TLabel;
    Memo_Log: TMemo;
    PB_Progress: TProgressBar;
    Lab_Progress: TLabel;
    Btn_test: TButton;
    L1: TLabel;
    Shape_Step1: TShape;
    Btn_s: TButton;
    Pan_Options: TPanel;
    Gbx_Errors: TGroupBox;
    Lab_Errors: TLabel;
    Rgr_Errors: TRadioGroup;
    Gbx_Token: TGroupBox;
    Rgr_Token: TRadioGroup;
    Gbx_WorkSilent: TGroupBox;
    Gbx_Work: TGroupBox;
    Nbt_WorkSilent_SendMail_Param: TSpeedButton;
    RB_WorkSilent_Activ: TRadioButton;
    Chk_SendMail: TCheckBox;
    Chk_CloseGUID: TCheckBox;
    RB_WorkSilent_Inactiv: TRadioButton;
    Edit_Mail: TEdit;
    Pan_CorpsLog: TPanel;
    procedure PageControlChange(Sender: TObject);
    procedure Nbt_EffacerScriptClick(Sender: TObject);
    procedure Nbt_AssistantComClientClick(Sender: TObject);
    procedure Nbt_AddDossierClick(Sender: TObject);
    procedure Nbt_DeleteDossierClick(Sender: TObject);
    procedure Btn_beforeClick(Sender: TObject);
    procedure Btn_NextClick(Sender: TObject);
    procedure Nbt_LoadListXMLClick(Sender: TObject);
    procedure Nbt_SaveListXMLClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Btn_testClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RB_WorkSilent_ActivClick(Sender: TObject);
    procedure RB_WorkSilent_InactivClick(Sender: TObject);
    procedure Chk_SendMailClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Nbt_WorkSilent_SendMail_ParamClick(Sender: TObject);
    procedure Btn_sClick(Sender: TObject);
    procedure lv_dossiersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Déclarations privées }
    Options : TOptions;
    onWork : boolean;
    Procedure BuildFrise (Ind,Decalage : integer);
    procedure SelectStepFrise(Ind : integer);
    procedure Traitement;
    procedure Msg(s : string);
    function Patch(BASE: String): boolean;
    function GetMemoLines : String;
    procedure SaveXML(xml : string);
    procedure LoadXML(xml : string);
    procedure SaveOptions;
    procedure LoadOptions;
    procedure doSendMail(SansErreur : boolean;FicLog : String);
    procedure onLog(Sender: TObject; aMsg: string);
  public
    { Déclarations publiques }
  end;

var
  Frm_ExecuteScript: TFrm_ExecuteScript;

implementation

uses uguid;

const
  Frise_Color_InProgress : cardinal = clWebOrange;
  Frise_Color_ToDo : cardinal = clWebOrangeRed;
  Frise_Color_Done : cardinal = clWebGreen;
  Pan_Btn_Color : cardinal = clWebLightBlue;
  LastFicLog = 'LastLog.log';
{$R *.dfm}

procedure TFrm_ExecuteScript.Btn_beforeClick(Sender: TObject);
begin
  if onWork then
    Exit;
  try
    Btn_before.Enabled := false;
    case PageControl.ActivePageIndex of
      1 : PageControl.ActivePageIndex := 0;
      2 : PageControl.ActivePageIndex := 1;
      3 : PageControl.ActivePageIndex := 2;
    end;
  finally
    Btn_before.Enabled := true;
    PageControlChange(self);
  end;
end;

procedure TFrm_ExecuteScript.Btn_NextClick(Sender: TObject);
begin
  try
    Btn_Next.Enabled := false;
    case PageControl.ActivePageIndex of
      0 : begin
            if GetMemoLines <> ''
              then PageControl.ActivePageIndex := 1
              else Msg('Info : Veuillez renseigner un scripts');
          end;
      1 : begin
            if lv_dossiers.Items.Count > 0 then
            begin
              LoadOptions;
              PageControl.ActivePageIndex := 2;
            end
            else
              Msg('Info : Veuillez choisir un dossier');
          end;
      2 : begin
            if ((Chk_SendMail.Checked) and (Edit_Mail.Text = '')) then
            begin
              Msg('Erreur : Veuillez renseigner une adresse email');
              Edit_Mail.SetFocus;
              Exit;
            end;
            SaveOptions;
            Pan_Log.Visible := (Options.Ini_Opt_Mode = 0);
            PageControl.ActivePageIndex := 3;
          end;
      3 : Traitement;
    end;
  finally
    Btn_Next.Enabled := true;
    PageControlChange(self);
  end;
end;

procedure TFrm_ExecuteScript.Btn_sClick(Sender: TObject);
var
  ListItem : TListItem;
begin
  Memo_Script.Lines.Clear;
  Memo_Script.Lines.Add('select count(*) from CSHTICKET');

  lv_dossiers.Items.Clear;
  ListItem := lv_dossiers.Items.Add;
  ListItem.SubItems.add('test 1');// Nom
  ListItem.SubItems.add('');// NomCentrale
  ListItem.SubItems.add('');// Version
  ListItem.SubItems.add('');// Serveur
  ListItem.SubItems.add('Lame2Test:F:\Intersport\TEST-LMASSE\DATA\Ginkoia.ib');// Base
  ListItem := lv_dossiers.Items.Add;
  ListItem.SubItems.add('test 2');// Nom
  ListItem.SubItems.add('');// NomCentrale
  ListItem.SubItems.add('');// Version
  ListItem.SubItems.add('');// Serveur
  ListItem.SubItems.add('Lame2Test:F:\Intersport\TEST-MAJ-NOSYMAG\DATA\Ginkoia.ib');// Base


  PageControl.ActivePageIndex := 3;
  PageControlChange(self);


end;

procedure TFrm_ExecuteScript.Btn_testClick(Sender: TObject);
var
  ListItem : TListItem;
begin
  Memo_Script.Lines.Clear;
  Memo_Script.Lines.Add('select count(*) from CSHTICKET');
  Memo_Script.Lines.Add('<---->');
  Memo_Script.Lines.Add('select count(*) from k');

  lv_dossiers.Items.Clear;
  ListItem := lv_dossiers.Items.Add;
  ListItem.SubItems.add('flammier');// Nom
  ListItem.SubItems.add('');// NomCentrale
  ListItem.SubItems.add('');// Version
  ListItem.SubItems.add('');// Serveur
  ListItem.SubItems.add('masse:D:\bases\flammier\flammier.ib');// Base
  ListItem := lv_dossiers.Items.Add;
  ListItem.SubItems.add('thierriaz');// Nom
  ListItem.SubItems.add('');// NomCentrale
  ListItem.SubItems.add('');// Version
  ListItem.SubItems.add('');// Serveur
  ListItem.SubItems.add('masse:D:\bases\thierriaz.ib');// Base
//  ListItem := lv_dossiers.Items.Add;
//  ListItem.SubItems.add('big 15go');// Nom
//  ListItem.SubItems.add('');// NomCentrale
//  ListItem.SubItems.add('');// Version
//  ListItem.SubItems.add('');// Serveur
//  ListItem.SubItems.add('masse:D:\bases\ginkoia.ib');// Base
//  ListItem := lv_dossiers.Items.Add;
//  ListItem.SubItems.add('locate');// Nom
//  ListItem.SubItems.add('');// NomCentrale
//  ListItem.SubItems.add('');// Version
//  ListItem.SubItems.add('');// Serveur
//  ListItem.SubItems.add('masse:D:\bases\locate.ib');// Base
//  ListItem := lv_dossiers.Items.Add;
//  ListItem.SubItems.add('prevost');// Nom
//  ListItem.SubItems.add('');// NomCentrale
//  ListItem.SubItems.add('');// Version
//  ListItem.SubItems.add('');// Serveur
//  ListItem.SubItems.add('masse:D:\bases\prevost.ib');// Base
//  ListItem := lv_dossiers.Items.Add;
//  ListItem.SubItems.add('monti');// Nom
//  ListItem.SubItems.add('');// NomCentrale
//  ListItem.SubItems.add('');// Version
//  ListItem.SubItems.add('');// Serveur
//  ListItem.SubItems.add('masse:D:\bases\monti.ib');// Base
//  ListItem := lv_dossiers.Items.Add;
//  ListItem.SubItems.add('morales');// Nom
//  ListItem.SubItems.add('');// NomCentrale
//  ListItem.SubItems.add('');// Version
//  ListItem.SubItems.add('');// Serveur
//  ListItem.SubItems.add('masse:D:\bases\morales.ib');// Base
//  ListItem := lv_dossiers.Items.Add;
//  ListItem.SubItems.add('moy');// Nom
//  ListItem.SubItems.add('');// NomCentrale
//  ListItem.SubItems.add('');// Version
//  ListItem.SubItems.add('');// Serveur
//  ListItem.SubItems.add('masse:D:\bases\moy.ib');// Base
//  ListItem := lv_dossiers.Items.Add;
//  ListItem.SubItems.add('rosec');// Nom
//  ListItem.SubItems.add('');// NomCentrale
//  ListItem.SubItems.add('');// Version
//  ListItem.SubItems.add('');// Serveur
//  ListItem.SubItems.add('masse:D:\bases\rosec.ib');// Base
  ListItem := lv_dossiers.Items.Add;
  ListItem.SubItems.add('martinez');// Nom
  ListItem.SubItems.add('');// NomCentrale
  ListItem.SubItems.add('');// Version
  ListItem.SubItems.add('');// Serveur
  ListItem.SubItems.add('masse:D:\bases\martinez.ib');// Base

  PageControl.ActivePageIndex := 3;
  PageControlChange(self);


end;

procedure TFrm_ExecuteScript.BuildFrise(Ind, Decalage: integer);
begin
  case Ind of
    1:
      begin
        l1.Caption := '1';
        l1.Top := 20;
        l1.Left := Decalage+24;
        l1.Width := 35;
        l1.Height := 45;
        l1.Color := clWhite;
        Shape_Step1.Top := 10;
        Shape_Step1.Left := Decalage;
        Shape_Step1.Width := 70;
        Shape_Step1.Height := 70;
        Shape_Step1.BringToFront;
        Lab_Step1.Width := Shape_Step1.Width+10;
        Lab_Step1.Height := 20;
        Lab_Step1.Top := 80;
        Lab_Step1.left := Decalage-5;
        Lab_Step1.Alignment := taCenter;
        l1.BringToFront;
      end;
    2:
      begin
        l2.Caption := '2';
        l2.Top := 20;
        l2.Left := Decalage+24;
        l2.Width := 35;
        l2.Height := 45;
        l2.Color := clWhite;
        Shape_Step2.Top := 10;
        Shape_Step2.Left := Decalage;
        Shape_Step2.Width := 70;
        Shape_Step2.Height := 70;
        Lab_Step2.Width := Shape_Step2.Width+10;
        Lab_Step2.Height := 20;
        Lab_Step2.Top := 80;
        Lab_Step2.left := Decalage-5;
        Lab_Step2.Alignment := taCenter;
        l2.BringToFront;
      end;
    3:
      begin
        l3.Caption := '3';
        l3.Top := 20;
        l3.Left := Decalage+24;
        l3.Width := 35;
        l3.Height := 45;
        l3.Color := clWhite;
        Shape_Step3.Top := 10;
        Shape_Step3.Left := Decalage;
        Shape_Step3.Width := 70;
        Shape_Step3.Height := 70;
        Lab_Step3.Width := Shape_Step3.Width+10;
        Lab_Step3.Height := 20;
        Lab_Step3.Top := 80;
        Lab_Step3.left := Decalage-5;
        Lab_Step3.Alignment := taCenter;
        l3.BringToFront;
      end;
    4:
      begin
        l4.Caption := '4';
        l4.Top := 20;
        l4.Left := Decalage+24;
        l4.Width := 35;
        l4.Height := 45;
        l4.Color := clWhite;
        Shape_Step4.Top := 10;
        Shape_Step4.Left := Decalage;
        Shape_Step4.Width := 70;
        Shape_Step4.Height := 70;
        Lab_Step4.Width := Shape_Step4.Width+10;
        Lab_Step4.Height := 20;
        Lab_Step4.Top := 80;
        Lab_Step4.left := Decalage-5;
        Lab_Step4.Alignment := taCenter;
        l4.BringToFront;
      end;
  end;
end;

procedure TFrm_ExecuteScript.Chk_SendMailClick(Sender: TObject);
begin
  Edit_Mail.Enabled := Chk_SendMail.Checked;
  Nbt_WorkSilent_SendMail_Param.Enabled := Chk_SendMail.Checked;
end;

procedure TFrm_ExecuteScript.FormCreate(Sender: TObject);
begin
  ModalResult := mrNone;
  Options := TOptions.Create;
  PageControl.ActivePageDefault := Tab_Scripts;
  Shape_Line.Margins.Top := 40;
  Pan_Frise.Color := Pan_Btn_Color;
  Pan_BasePage.Color := Pan_Btn_Color;
  Pan_Script_Btn.Color := Pan_Btn_Color;
  Pan_Bases_Btn.Color := Pan_Btn_Color;
  Pan_Script.Color := Pan_Btn_Color;
  Pan_Options.Color := Pan_Btn_Color;
  Pan_Bases.Color := Pan_Btn_Color;
  Pan_Log.Color := Pan_Btn_Color;
  Pan_Progress.Color := Pan_Btn_Color;
  Pan_CorpsLog.Color := Pan_Btn_Color;
  onWork := false;
  LoadOptions;
end;

procedure TFrm_ExecuteScript.FormDestroy(Sender: TObject);
begin
  if assigned(Options) then
    Options.Free;
end;

procedure TFrm_ExecuteScript.FormResize(Sender: TObject);
var
  Decalage : integer;
begin
  Decalage := trunc(Width/5);
  BuildFrise(1,(Decalage*1)-50);
  BuildFrise(2,(Decalage*2)-50);
  BuildFrise(3,(Decalage*3)-50);
  BuildFrise(4,(Decalage*4)-50);
  SelectStepFrise(PageControl.ActivePageIndex+1);
end;

procedure TFrm_ExecuteScript.FormShow(Sender: TObject);
begin
  PageControl.ActivePageDefault := Tab_Scripts;
  PageControl.ActivePage := Tab_Scripts;
end;

function TFrm_ExecuteScript.GetMemoLines: String;
var
  i : integer;
  sTmp : string;
begin
  sTmp := '';
  result := '';
  try
    try
      for I := 0 to Memo_Script.Lines.Count - 1 do
        sTmp := sTmp + ' ' + Memo_Script.Lines[i];
    except
      Msg('Erreur lors de la récupération du script')
    end;
  finally
    if sTmp <> '' then
      result := trim(sTmp);
  end;
end;

procedure TFrm_ExecuteScript.LoadOptions;
begin
  Options.LoadOptions(ChangeFileExt(Application.ExeName, '.ini'));

  RB_WorkSilent_Activ.Checked := (Options.Ini_Opt_Mode = 1);
  RB_WorkSilent_Inactiv.Checked := (Options.Ini_Opt_Mode = 0);
  Chk_SendMail.Checked := (Options.Ini_Opt_Mail <> '');
  Edit_Mail.Text := Options.Ini_Opt_Mail;
  Chk_CloseGUID.Checked := (Options.Ini_Opt_AutoClose = 1);

  if Options.Ini_Opt_Error = 1
    then Rgr_Errors.ItemIndex := 0
    else Rgr_Errors.ItemIndex := 1;

  if Options.Ini_Opt_Token = 1
    then  Rgr_Token.ItemIndex := 0
    else  Rgr_Token.ItemIndex := 1;
end;

procedure TFrm_ExecuteScript.LoadXML(xml : string);
var
  Dossiers: IXMLDossiersType;
  Dossier: IXMLDossierType;
  i : integer;
  ListItem : TListItem;
begin
  if xml <> '' then
  begin
    Dossiers := LoadDossiers(xml);
    lv_dossiers.Items.Clear;
    for I := 0 to Dossiers.Count - 1 do
    begin
      Dossier := Dossiers.Dossier[i];
      ListItem := lv_dossiers.Items.Add;
      ListItem.SubItems.add(Dossier.Name);
      ListItem.SubItems.add(Dossier.Centrale);
      ListItem.SubItems.add(Dossier.Version);
      ListItem.SubItems.add(Dossier.Serveur);
      ListItem.SubItems.add(Dossier.Base);
    end;
  end;
end;

procedure TFrm_ExecuteScript.lv_dossiersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_DELETE : Nbt_DeleteDossierClick(self);
  end;
end;

procedure TFrm_ExecuteScript.Msg(s: string);
begin
  if ((copy(s,0,6) = 'Erreur') or (copy(s,0,4) = 'Info')) then
  begin
    if Options.Ini_Opt_Mode = 0 then
      showmessage(s);
  end
  else
  begin
    if copy(s,0,4) = 'Mail' then
    begin
      if Options.Ini_Opt_Mail_Log = 1 then
        Memo_Log.Lines.Add('[' + DateTimeToStr(Now) + ']  ' + s);
    end
    else
      Memo_Log.Lines.Add('[' + DateTimeToStr(Now) + ']  ' + s);
  end;
end;

procedure TFrm_ExecuteScript.Nbt_AddDossierClick(Sender: TObject);
var
  aDossiers : TDossiers;
  aDossier : TDossier;
  i : integer;
  ListItem : TListItem;
begin
  aDossiers := ExecuteChercheDossiers;
  if assigned(aDossiers) then
  begin
    for I := 0 to aDossiers.Count - 1 do
    begin
      aDossier := (aDossiers.Items[i] as TDossier);
      ListItem := lv_dossiers.Items.Add;
      ListItem.SubItems.add(aDossier.Nom);
      ListItem.SubItems.add(aDossier.NomCentrale);
      ListItem.SubItems.add(aDossier.Version);
      ListItem.SubItems.add(aDossier.Serveur);
      ListItem.SubItems.add(aDossier.Base);
    end;
  end
  else
    Msg('Erreur : Dossiers vide !');
end;

procedure TFrm_ExecuteScript.Nbt_AssistantComClientClick(Sender: TObject);
var
  sURL : string;
begin
  sURL := ExecuteAssitComClient;
  if sURL <> '' then
  begin
    Memo_Script.Lines.clear;
    Memo_Script.Lines.Add('UPDATE GENPARAM SET PRM_INTEGER=-1');
    Memo_Script.Lines.Add('where PRM_CODE=9997 AND PRM_TYPE=4 and PRM_INTEGER<>-1 and PRM_STRING<> ' + quotedstr(sURL) + ' ;');
    Memo_Script.Lines.Add('<---->');
    Memo_Script.Lines.Add('execute PROCEDURE SM_RE_ADVERTISING (' + quotedstr(sURL) + ',Null,1,0,3);');
  end;
end;

procedure TFrm_ExecuteScript.Nbt_DeleteDossierClick(Sender: TObject);
var
  i : integer;
  li : TListItem;
begin
  try
    for i := lv_dossiers.Items.Count - 1 downto 0 do
    begin
      li := lv_dossiers.Items[i];
      if li.Selected then
        li.Delete;
    end;
  except
    Msg('Erreur : La suppression a échouée !');
  end;
end;

procedure TFrm_ExecuteScript.Nbt_EffacerScriptClick(Sender: TObject);
begin
  Memo_Script.Lines.Clear;
end;

procedure TFrm_ExecuteScript.Nbt_LoadListXMLClick(Sender: TObject);
begin
//  if lv_dossiers.Items.Count = 0 then
//  begin
//    if OD_XML.Execute then
//      LoadXML(OD_XML.FileName)
//  end
//  else
//  begin
//    if MessageDlg('Les dossiers en cours seront supprimés, voulez-vous continuez ?', mtConfirmation, [mbOK, mbCancel], 0) = mrOk then
      if OD_XML.Execute then
        LoadXML(OD_XML.FileName);
//  end;
end;

procedure TFrm_ExecuteScript.Nbt_SaveListXMLClick(Sender: TObject);
begin
  if lv_dossiers.Items.Count > 0 then
  begin
    if SD_XML.Execute then
      SaveXML(SD_XML.FileName);
  end
  else
    Msg('Erreur : La liste est vide, sauvegarde impossible !');
end;

procedure TFrm_ExecuteScript.Nbt_WorkSilent_SendMail_ParamClick(
  Sender: TObject);
begin
  ExecuteParamMail(Options);
end;

procedure TFrm_ExecuteScript.PageControlChange(Sender: TObject);
begin
  SelectStepFrise(PageControl.ActivePageIndex + 1);
  case PageControl.ActivePageIndex of
    3 : Btn_Next.caption := 'Lancer le traitement';
    else Btn_Next.caption := 'Suivant >';
  end;
end;

function TFrm_ExecuteScript.Patch(BASE: STRING): boolean;
var
  ok : boolean;
  tpJeton : TTokenParams;
  bJeton  : Boolean;        //Vrai si on a le jeton sinon faux
  i, vNbEssais: Integer;    //Compteur pour les jetons / Nombre d'essais
  vAllowExecJob : boolean;
begin
  result := false;
  try
    uguid.Form1.data.DatabaseName := BASE;
    uguid.Form1.data.Open;
    try
      bJeton := true;
      if Options.Ini_Opt_Token = 1 then
      begin
        TRY
          vAllowExecJob:= false;

          uguid.Form1.QryGENVERSION.Open;

          if (not uguid.Form1.QryGENVERSION.Eof) and (uguid.Form1.IsJetonVersion(uguid.Form1.QryGENVERSION.FieldByName('VER_VERSION').AsString)) then
            begin
              Msg('Récupération des paramétres des jetons');
              tpJeton := GetParamsToken(BASE,'ginkoia','ginkoia');
              bJeton  := False;

              if tpJeton.bLectureOK then
              begin
                Msg('Prise de jeton');
                i := 1;

                vNbEssais:= 5;
                while (not bJeton) and (i < vNbEssais) do
                begin
                  CoInitializeEx(nil, COINIT_MULTITHREADED) ; // sinon ça marche pas
                  bJeton  := StartTokenEnBoucle(tpJeton,30000);
                  CoUnInitialize;                            // sinon ça marche pas
                  if not bJeton then    //Si pas de jeton
                  begin
                    Msg('Impossible de prendre un Jeton. Tentative : '+ IntToStr(i) +' sur ' + IntToStr(vNbEssais) + '.');
                    sleep(30000);       //Pause de 30s
                    Inc(i);             //On incrémente le nombre d'essai
                  end
                  else
                    Break;  // Jeton trouvé
                end;
              end;

              Msg('Contrôle jeton bJeton = '+BoolToStr(bJeton)+' ; tpJeton.bLectureOK: ' + BoolToStr(tpJeton.bLectureOK));
              vAllowExecJob:= (bJeton and tpJeton.bLectureOK) or (not bJeton and not tpJeton.bLectureOK);
            end;

          if vAllowExecJob then
          begin
            ok := uguid.Form1.Patch(0, GetMemoLines);
          end
          else
          begin
            Msg('Impossible de prendre un Jeton.');
          end;
        EXCEPT  on E:exception do
          begin
            Msg('prob sur la base : '+E.Message);
          end;
        END;
        if bJeton then
        begin
          StopTokenEnBoucle;      //Relache le jeton
          Msg('Jeton libéré correctement.');
        end;
      end
      else
        ok := uguid.Form1.Patch(0, GetMemoLines);
    finally
      result := not ok;
      uguid.Form1.data.close;
    end;
  except
    result := false;
  end;
end;

procedure TFrm_ExecuteScript.RB_WorkSilent_ActivClick(Sender: TObject);
begin
  RB_WorkSilent_Inactiv.Checked := not RB_WorkSilent_Activ.Checked;
  if RB_WorkSilent_Activ.Checked then
  begin
    Chk_SendMail.Checked := (Options.Ini_Opt_Mail <> '');
    Chk_SendMail.Enabled := true;
    Edit_Mail.Text := Options.Ini_Opt_Mail;
    Edit_Mail.Enabled := true;
    Chk_CloseGUID.Checked := (Options.Ini_Opt_AutoClose = 1);
    Chk_CloseGUID.Enabled := true;
  end;
end;

procedure TFrm_ExecuteScript.RB_WorkSilent_InactivClick(Sender: TObject);
begin
  RB_WorkSilent_Activ.Checked := not RB_WorkSilent_Inactiv.Checked;
  if RB_WorkSilent_Inactiv.Checked then
  begin
    Chk_SendMail.Checked := false;
    Chk_SendMail.Enabled := false;
    Edit_Mail.Text := '';
    Edit_Mail.Enabled := false;
    Chk_CloseGUID.Checked := false;
    Chk_CloseGUID.Enabled := false;
  end;
end;

procedure TFrm_ExecuteScript.SaveOptions;
begin
  if RB_WorkSilent_Activ.Checked
    then Options.Ini_Opt_Mode := 1
    else Options.Ini_Opt_Mode := 0;

  if ((Chk_SendMail.Checked) and (Edit_Mail.Text <> '')) then
    Options.Ini_Opt_Mail := Edit_Mail.Text
  else
    Options.Ini_Opt_Mail := '';

  if Chk_CloseGUID.Checked
    then Options.Ini_Opt_AutoClose := 1
    else Options.Ini_Opt_AutoClose := 0;

  if Rgr_Errors.ItemIndex = 1
    then Options.Ini_Opt_Error := 0
    else Options.Ini_Opt_Error := 1;

  if Rgr_Token.ItemIndex = 1
    then  Options.Ini_Opt_Token := 0
    else  Options.Ini_Opt_Token := 1;

  Options.SaveOptions(ChangeFileExt(Application.ExeName, '.ini'));
end;

procedure TFrm_ExecuteScript.SaveXML(xml : string);
var
  Dossiers: IXMLDossiersType;
  Dossier: IXMLDossierType;
  i : integer;
  ListItem : TListItem;
begin
  if xml <> '' then
  begin
    Dossiers := NewDossiers;
    for I := 0 to lv_dossiers.Items.Count - 1 do
    begin
      Dossier := Dossiers.Add;
      ListItem := lv_dossiers.Items[i];
      Dossier.Name := ListItem.SubItems[0];
      Dossier.Centrale := ListItem.SubItems[1];
      Dossier.Version := ListItem.SubItems[2];
      Dossier.Serveur := ListItem.SubItems[3];
      Dossier.Base := ListItem.SubItems[4];
    end;
    Dossiers.OwnerDocument.SaveToFile(xml);
  end;
end;

procedure TFrm_ExecuteScript.SelectStepFrise(Ind: integer);
begin
  case Ind of
    1:
      begin
        l1.Color := Frise_Color_InProgress;
        Shape_Step1.Brush.Color := Frise_Color_InProgress;
        l2.Color := Frise_Color_ToDo;
        Shape_Step2.Brush.Color := Frise_Color_ToDo;
        l3.Color := Frise_Color_ToDo;
        Shape_Step3.Brush.Color := Frise_Color_ToDo;
        l4.Color := Frise_Color_ToDo;
        Shape_Step4.Brush.Color := Frise_Color_ToDo;
      end;
    2:
      begin
        l1.Color := Frise_Color_Done;
        Shape_Step1.Brush.Color := Frise_Color_Done;
        l2.Color := Frise_Color_InProgress;
        Shape_Step2.Brush.Color := Frise_Color_InProgress;
        l3.Color := Frise_Color_ToDo;
        Shape_Step3.Brush.Color := Frise_Color_ToDo;
        l4.Color := Frise_Color_ToDo;
        Shape_Step4.Brush.Color := Frise_Color_ToDo;
      end;
    3:
      begin
        l1.Color := Frise_Color_Done;
        Shape_Step1.Brush.Color := Frise_Color_Done;
        l2.Color := Frise_Color_Done;
        Shape_Step2.Brush.Color := Frise_Color_Done;
        l3.Color := Frise_Color_InProgress;
        Shape_Step3.Brush.Color := Frise_Color_InProgress;
        l4.Color := Frise_Color_ToDo;
        Shape_Step4.Brush.Color := Frise_Color_ToDo;
      end;
    4:
      begin
        l1.Color := Frise_Color_Done;
        Shape_Step1.Brush.Color := Frise_Color_Done;
        l2.Color := Frise_Color_Done;
        Shape_Step2.Brush.Color := Frise_Color_Done;
        l3.Color := Frise_Color_Done;
        Shape_Step3.Brush.Color := Frise_Color_Done;
        l4.Color := Frise_Color_InProgress;
        Shape_Step4.Brush.Color := Frise_Color_InProgress;
      end;
    5:
      begin
        l1.Color := Frise_Color_Done;
        Shape_Step1.Brush.Color := Frise_Color_Done;
        l2.Color := Frise_Color_Done;
        Shape_Step2.Brush.Color := Frise_Color_Done;
        l3.Color := Frise_Color_Done;
        Shape_Step3.Brush.Color := Frise_Color_Done;
        l4.Color := Frise_Color_Done;
        Shape_Step4.Brush.Color := Frise_Color_Done;
      end;
  end;
end;

procedure TFrm_ExecuteScript.doSendMail(SansErreur : boolean;FicLog : String);
var
  sServeur, sLogin, sPwd, sExp, sTitre, sDest, sText : string;
  iPort: integer;
  Security : SecuriteMail;
  PJ, slDest : TStringList;
  email : TMailManager;
begin
  TThreadProc.RunInThread(
    procedure
    var
      i : integer;
    begin
      Msg('Envoi du mail récap en cours ...');
      sServeur := Options.Ini_Opt_Mail_SMTP;
      iPort := Options.Ini_Opt_Mail_Port;
      sLogin := Options.Ini_Opt_Mail_Exp;
      sPwd  := Options.Ini_Opt_Mail_Pwd;
      Security := SecuriteMail(Options.Ini_Opt_Mail_Security);
      sExp := Options.Ini_Opt_Mail_Exp;
      sDest := Options.Ini_Opt_Mail;
      if SansErreur then
        sTitre := 'Réussite du GUID'
      else
        sTitre := 'Echec du GUID';

      sText := '';
      Msg('Mail - Serveur : ' + sServeur);
      Msg('Mail - Port : ' + inttostr(iPort));
      Msg('Mail - Login : ' + sLogin);
      Msg('Mail - Pwd : ' + sPwd);
      Msg('Mail - Expéditeur : ' + sExp);
      Msg('Mail - Destinataire : ' + sDest);
      case Security of
        tsm_Aucun: Msg('Mail - Securité : Aucun');
        tsm_TLS: Msg('Mail - Securité : TLS');
        tsm_SSL: Msg('Mail - Securité : SSL');
      end;

      PJ := TStringList.create;
      slDest := TStringList.create;
      slDest.Delimiter := ';';
      slDest.DelimitedText := sDest;
      for I := 0 to slDest.Count - 1 do
        Msg('Mail - Destinataire[' + inttostr(i) + '] : ' + slDest[i]);

      try
        PJ.Add(FicLog);
        email := TMailManager.Create;
        try
          email.onLog := onLog;
          email.serveur := sServeur;
          email.port := iPort;
          email.Login := sLogin;
          email.Password := sPwd;
          email.Securite := Security;
          email.expediteur := sExp;
          email.destinataires := slDest;
          email.titre := sTitre;
          email.text := sText;
          email.PiecesJointes := pj;
          Msg('Mail - email.doSendEmail : Avant');
          email.doSendEmail;
          Msg('Mail - email.doSendEmail : Après');
        finally
          email.free;
        end;
      finally
        PJ.free;
      end;
    end
  ).whenFinish(
    procedure
    begin
      onWork := false;
      Msg('Le mail a été envoyé correctement.');
      if Options.Ini_Opt_AutoClose = 1 then
        Application.Terminate;
    end
  ).whenError(
    procedure(aException : Exception)
    begin
      onWork := false;
      Msg('Echec lors de l''envoie du mail');
    end
  ).Run ;
end;

procedure TFrm_ExecuteScript.onLog(Sender: TObject; aMsg: string);
begin
  Msg(aMsg);
end;

procedure TFrm_ExecuteScript.Traitement;
var
  li : TListItem;
  NB_OK, NB_BASE : integer;
  ok : boolean;
  TpsBase, TpsBases : TDateTime;
begin
  if onWork then
    Exit;
  TThreadProc.RunInThread(
    procedure
    var
      i : integer;
    begin
      onWork := true;
      NB_BASE := lv_dossiers.Items.Count;
      PB_Progress.Position := 0;
      PB_Progress.Min := 0;
      PB_Progress.Max := NB_BASE;
      PB_Progress.Step := 1;
      Msg('**************************************** SCRIPT ****************************************');
      Msg(GetMemoLines);
      Msg('**************************************** BASES  ****************************************');
      TpsBases := Now;
      for i := 0 to NB_BASE - 1 do
      begin
        li := lv_dossiers.Items[i];
        Lab_Progress.Caption := li.SubItems[4];
        PB_Progress.StepIt;
        TpsBase := Now;
        ok := Patch(li.SubItems[4]);
        TpsBase := Now - TpsBase;
        if ok then
        begin
          Msg(' > La base "' + li.SubItems[4] + '" a été correctement scriptée (' + TimeToStr(TpsBase) + ')');
        end
        else
        begin
          Msg(' > La base "' + li.SubItems[4] + '" n''a pas été scriptée ('+ TimeToStr(TpsBase) +')');
          if Options.Ini_Opt_Error = 1 then
            break;
        end;
        if ok then inc(NB_OK);
      end;
    end
  ).whenFinish(
    procedure
    begin
      Msg('*************************************** TERMINE ****************************************');
      TpsBases := Now - TpsBases;
      if NB_OK = NB_BASE then
      begin
        Lab_Progress.Caption := 'Toutes les bases ont été correctement scriptées';
        Msg('Toutes les bases ont été correctement scriptées (' + TimeToStr(TpsBases) + ')');
      end
      else
      begin
        if Options.Ini_Opt_Error = 1 then
          Lab_Progress.Caption := 'Le traitement a été arrêté';
        Msg('Toutes les bases n''ont pas été correctement scriptées - '+inttostr(NB_OK)+'/'+inttostr(NB_BASE)+' (' + TimeToStr(TpsBases) + ')');
      end;
      SelectStepFrise(5);
      Memo_Log.lines.savetofile(ChangeFileExt(Application.ExeName, '.last.log'));
      if ((Options.Ini_Opt_Mode = 1) and (Options.Ini_Opt_Mail <> '')) then
        doSendMail((NB_OK = NB_BASE), ChangeFileExt(Application.ExeName, '.last.log'));

      onWork := false;
      if Options.Ini_Opt_AutoClose = 1 then
        Application.Terminate;
    end
  ).whenError(
    procedure(aException : Exception)
    begin
      Msg('Erreur : ' + aException.Message);
    end
  ).Run ;
end;

end.
