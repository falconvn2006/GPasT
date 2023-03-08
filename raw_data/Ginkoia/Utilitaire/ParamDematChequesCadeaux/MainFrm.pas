unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls,ExtCtrls,
  ComCtrls, Buttons, Math, DB, Grids, DBGrids,
  cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, cxDBData, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridLevel, cxClasses, cxGridCustomView,
  cxGrid, cxDBLookupComboBox, Spin,  Menus, cxButtons, StrUtils, dxmdaset,
  cxCheckComboBox, cxCheckBox, cxDropDownEdit,GestionJetonLaunch,
  Registry,uGinkoiaTools,uCreateProcess,uDemat, uThreadProc;
  { uLog // uLog dans la prochaine Version}

Const
  ListeOrdres : array[0..6] of string = ('SERVEUR', 'PORT', 'BASE','AUTO','CODETIERS','CENTRALE','MAGCODE');  // ,'AUTOGT'

type
  Tfrm_Main = class(TForm)
    lbl_BaseFile: TLabel;
    cbx_TypeBase: TComboBox;
    edt_Serveur: TEdit;
    edt_Port: TEdit;
    edt_BaseFile: TEdit;
    pb_Progress: TProgressBar;
    pnl_Sep_1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    pnl_Bottom: TPanel;
    Panel1: TPanel;
    lbl_version: TLabel;
    MemMags: TdxMemData;
    MemMagsMAG_ID: TIntegerField;
    MemMagsMAG_NOM: TStringField;
    dsMags: TDataSource;
    Label2: TLabel;
    Label3: TLabel;
    edt_Defaut: TEdit;
    edt_Trop_Percu: TEdit;
    Label4: TLabel;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1MAG_ID: TcxGridDBColumn;
    cxGrid1DBTableView1MAG_NOM: TcxGridDBColumn;
    cxGridEmetteur: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    MemEmetteurs: TdxMemData;
    dsEmetteurs: TDataSource;
    MemEmetteursCKE_CODE: TStringField;
    MemEmetteursCKE_LIBELLE: TStringField;
    MemEmetteursMEN_NOM: TStringField;
    cxGridDBTableView1CKE_CODE: TcxGridDBColumn;
    cxGridDBTableView1CKE_LIBELLE: TcxGridDBColumn;
    cxGridDBTableView1MEN_NOM: TcxGridDBColumn;
    MemEmetteursDETAIL: TStringField;
    cxGridDBTableView1DETAIL: TcxGridDBColumn;
    MemEnc: TdxMemData;
    dsEnc: TDataSource;
    MemEncNOM: TStringField;
    MemTitres: TdxMemData;
    MemTitresCKI_CKECODE: TStringField;
    MemTitresCKI_TYPECODE: TStringField;
    MemTitresCKI_LIBELLE: TStringField;
    MemTitresUTILISABLE: TIntegerField;
    cbCentrale: TComboBox;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxStyle2: TcxStyle;
    edt_URL: TEdit;
    edt_GUID: TEdit;
    Label5: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Panel2: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    spn_Delai: TSpinEdit;
    BModifier: TcxButton;
    BCancel: TcxButton;
    BValid: TcxButton;
    BExecute: TcxButton;
    Bconnect: TcxButton;
    BDisconnect: TcxButton;
    GroupBox3: TGroupBox;
    BQuitter: TcxButton;
    Logs: TTabSheet;
    mLogs: TMemo;
    tAuto: TTimer;
    MemMagsMAG_CODETIERS: TStringField;
    cxGrid1DBTableView1MAG_CODETIERS: TcxGridDBColumn;
    MemMagsCHECK: TIntegerField;
    MemMagsMAG_CENTRALE: TStringField;
    cxGrid1DBTableView1CHECK: TcxGridDBColumn;
    cxGrid1DBTableView1MAG_CENTRALE: TcxGridDBColumn;
    cbJETON: TCheckBox;
    MemMagsMAG_DONE: TIntegerField;
    cxGrid1DBTableView1MAG_DONE: TcxGridDBColumn;
    lbl_status: TLabel;
    MemMagsMAG_CODE: TStringField;
    cxGrid1DBTableView1MAG_CODE: TcxGridDBColumn;
    procedure cbx_TypeBaseChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BQuitterClick(Sender: TObject);
    procedure BConnectClick(Sender: TObject);
    procedure edt_BaseFileChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure cxGridDBTableView1CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cbCentraleChange(Sender: TObject);
    procedure BSAVEClick(Sender: TObject);
    procedure Click(Sender: TObject);
    procedure BModifierClick(Sender: TObject);
    procedure BCancelClick(Sender: TObject);
    procedure BExecuteClick(Sender: TObject);
    procedure BDisconnectClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tAutoTimer(Sender: TObject);
    procedure cxGridDBTableView1MEN_NOMPropertiesEditValueChanged(
      Sender: TObject);
    procedure cxGrid1DBTableView1MAG_CENTRALEPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure edt_BaseFileKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GinkoiaTools_onStart(aSender : TObject) ;
    procedure GinkoiaTools_onExit(aSender : TObject) ;
    procedure FormDestroy(Sender: TObject);
    procedure cxGrid1DBTableView1CHECKPropertiesEditValueChanged(
      Sender: TObject);

  private
    FGinkoiaTools : TGinkoiaTools;
    FAUTOGT       : boolean;

    FRunning     : boolean ;
    FError       : string ;

    FState   : TDataSetState;
    Fauto    : boolean;
    FLogDest : string;
    FVersion : string;
    FNom, FCentrale : string;

    FCODETIERS : string;
    FCODETIERSList : TStringList;

    FFORCECENTRALE : string;
    FMAG_CODE : string;
    FMAG_CODEList : TStringList;

    FGUID, FBasSender : string;
    FGenerateur : integer;
    FRecalcul : boolean;
    { Déclarations privées }
    procedure SetState(aValue:TDataSetState);
    procedure setError(aError : string) ;
    procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
    procedure MAJ_Button_Execute();

  protected
     // activation
     function Controles_Before_Start(aMags:TMagasins;aCentrale:string):boolean;

     procedure Save();
     procedure GestionInterface(Enabled : Boolean);
     procedure UpdateColDetail();
     procedure GestionOrdre(Param, Value : string);
     function Readbase0:string;
      // procedure ExecuteJob();
     procedure doStart();


  public
    { Déclarations publiques }
    property State : TDataSetState Read FState Write SetState;
  end;

var
  frm_Main: Tfrm_Main;

implementation

{$R *.dfm}

Uses uGestionBDD, UInfosBase,uFileUtils,TitreFrm,ListDossiersDistantsFrm;

function Tfrm_Main.Readbase0:string;
Const C_KEY='Software\Algol\Ginkoia\';
var
  RegistryEntry: TRegistry;
begin
  result:='';
  RegistryEntry := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
  try
    RegistryEntry.RootKey := HKEY_LOCAL_MACHINE;
    RegistryEntry.Access := KEY_READ {or KEY_WOW64_64KEY};
    if RegistryEntry.OpenKey(C_KEY, false) then
      begin
        result := RegistryEntry.ReadString('Base0');
      end;
    RegistryEntry.CloseKey();
  finally
    RegistryEntry.Free;
  end;
end;

procedure Tfrm_Main.BCancelClick(Sender: TObject);
begin
   // Annulation des Modif....
   // On recharge
   cbCentraleChange(Sender);
   State := dsBrowse;
end;

procedure Tfrm_Main.GinkoiaTools_onExit(aSender: TObject);
begin
  Application.Terminate ;
end;

procedure Tfrm_Main.GinkoiaTools_onStart(aSender : TObject) ;
begin
  // Ceci est une manière de sortir de l'évènement onStart de uGinkoiaTools,
  // sinon les ordres suivants ne sont pas transmis avant la fin de l'execution du traitement,
  // parce que le traitement n'est pas executé dans un thread

  TThreadProc.RunInThread(
    procedure
    begin
      sleep(100) ;
    end
  ).whenFinish(
    procedure
    begin
      doStart ;
    end
  ).Run ;

end;


function Tfrm_Main.Controles_Before_Start(aMags:TMagasins;aCentrale:string):boolean;
var i:Integer;
begin
  result := false;
  try
    if Length(aMags)=0 then
      begin
         // vErreur := true;

         setError('Veuillez choisir au moins un magasin.');

         BExecute.Enabled    := true;
         BDisconnect.Enabled := true;
         BQuitter.Enabled    := true;
         cbJETON.Enabled     := true;
         Screen.Cursor := crDefault;
         MemMags.EnableControls;
         exit;  // donc result = FALSE
      end;

    for I := Low(aMags) to High(aMags) do
      begin
          if aCentrale=''
            then
              begin
                  // vErreur :=true;
                  setError('Aucune centrale.');


                  BExecute.Enabled    := true;
                  BDisconnect.Enabled := true;
                  BQuitter.Enabled    := true;
                  cbJETON.Enabled     := true;
                  Screen.Cursor := crDefault;
                  MemMags.EnableControls;
                  exit;  // donc result = FALSE
              end
            else if aCentrale<>aMags[i].MAG_CENTRALE
              then
                 begin
                   // vErreur :=true;
                   setError('Une seule centrale à la fois.');

                   BExecute.Enabled    := true;
                   BDisconnect.Enabled := true;
                   BQuitter.Enabled    := true;
                   cbJETON.Enabled     := true;
                   Screen.Cursor := crDefault;
                   MemMags.EnableControls;
                   exit;  // donc result = FALSE
                 end;

          if (aMags[i].MAG_CODETIERS='')
            then
              begin
                 if (FVersion<='18.1.0.9999') then
                    begin
                         setError('Erreur CodeTiers Vide : Jusqu''à V18.1, Veuillez renseigner correctement MAG_ID > MAG_BASID > BAS_ID > BASE_CODETIERS');
                    end
                 else
                    begin
                        setError('Erreur CodeTiers vide : A partir de V18.2, Veuillez renseigner correctement MAG_ID > MAG_CODETIERS');
                    end;


                 BExecute.Enabled    := true;
                 BDisconnect.Enabled := true;
                 BQuitter.Enabled    := true;
                 cbJETON.Enabled     := true;
                 Screen.Cursor := crDefault;
                 MemMags.EnableControls;
                 exit;
              end;
      end;

    // On pose vCentrale dans cbCentrale.Text
    cbCentrale.Text := aCentrale;
    cbCentrale.ItemIndex := cbCentrale.Items.IndexOf(aCentrale);
    if cbCentrale.ItemIndex=-1 then
        begin
          setError(Format('La centrale %s n''est pas dans le paramétrage.',[aCentrale]));
          BExecute.Enabled    := true;
          BDisconnect.Enabled := true;
          BQuitter.Enabled    := true;
          cbJETON.Enabled     := true;
          Screen.Cursor := crDefault;
          MemMags.EnableControls;
          exit;  // donc result = FALSE
        end;


    cbCentraleChange(Self);
    Result := true;  // Tout semble OK ==> TRUE
  except
    On E:Exception do
      begin
          result :=false;
          If (FAUTOGT)
           then
              BEGIN
                  FGinkoiaTools.error(E.ClassName + ' ' + E.Message);
                  FGinkoiaTools.failed;
              END;
      end;
  end;
end;




procedure Tfrm_Main.BExecuteClick(Sender: TObject);
begin
    if FAUTOGT
      then FGinkoiaTools.start()
      else doStart();
end;

procedure Tfrm_Main.doStart();
var vMagParams : TParamsMag;
    vOK : Boolean;
    vMags : TMagasins;
    i:Integer;
    vCentrale:string;
//  vErreur: Boolean;
    vtpJeton  : TTokenParams;   // Record avec les paramètres pour les Jetons
    vTokenManager : TTokenManager;   // Pour le jeton
    vAdresse  : String;
    vJeton    : Boolean;        // Vrai si on a le jeton sinon faux


begin

  {$REGION 'LOCKAGE'}
  Screen.Cursor := crSQLWait;
  BExecute.Enabled    := false;
  BDisconnect.Enabled := false;
  BQuitter.Enabled    := false;
  cbJETON.Enabled     := false;

  FGinkoiaTools.started ;       // on dit au servce qu'on a démarré
  {$ENDREGION 'LOCKAGE'}


  try
    {$REGION 'CONTROLES'}
    vTokenManager := nil;
    if (cbJETON.Checked) then
      begin
         FGinkoiaTools.phase('Prise du jeton');
         try
             vTokenManager :=  TTokenManager.Create;
             //Prise en compte des Jetons
             if cbx_TypeBase.ItemIndex = 1
               then vtpJeton := GetParamsToken(edt_Serveur.text+'/'+edt_Port.Text+':' +edt_BaseFile.Text,'ginkoia','ginkoia')
               else vtpJeton := GetParamsToken(edt_BaseFile.Text,'ginkoia','ginkoia');
             vAdresse := StringReplace(vtpJeton.sURLDelos, '/DelosQPMAgent.dll', vtpJeton.sAdresseWS, [rfReplaceAll, rfIgnoreCase]);
             mLogs.Lines.Add('Adresse de prise de Jeton : '+ vAdresse);
             vJeton := vTokenManager.tryGetToken(vAdresse,vtpJeton.sDatabaseWS,vtpJeton.sSenderWS,20,30000);
             if vJeton
              then mLogs.Lines.Add('Jeton Acquis !!')
              else
                  begin
                     mLogs.Lines.Add('Problème lors de l''obtention du jeton');
                     BExecute.Enabled    := true;
                     BDisconnect.Enabled := true;
                     BQuitter.Enabled    := true;
                     cbJETON.Enabled     := true;
                     exit;
                  end;
           Except on E:Exception do
            begin
              mLogs.Lines.Add('Erreur à l''obtention du jeton : '+E.Message);
              raise Exception.Create('Erreur à l''obtention du jeton : '+E.Message);
            End;
         end;
       end;


  // Construction des Variables
  MemMags.DisableControls;
  MemMags.First;
  SetLength(vMags,0);
  // vErreur := False;
  while not(MemMags.Eof) do
    begin
        if MemMags.FieldByName('CHECK').AsInteger=1 then
          begin
            i:=Length(vMags);
            SetLength(vMags,i+1);
            vMags[i].MAG_ID       := MemMags.FieldByName('MAG_ID').AsInteger;
            vMags[i].MAG_NOM      := MemMags.FieldByName('MAG_NOM').Asstring;
            vMags[i].MAG_CENTRALE  := MemMags.FieldByName('MAG_CENTRALE').Asstring;
            vCentrale              := MemMags.FieldByName('MAG_CENTRALE').Asstring;
            vMags[i].MAG_CODETIERS := MemMags.FieldByName('MAG_CODETIERS').Asstring;
          end;
        MemMags.Next;
    end;

    // Controles Faire une fonction ....
    FGinkoiaTools.phase('Controles');
    If not(Controles_Before_Start(vMags,vCentrale))
      then
        begin
           // raise Exception.Create('Erreur de Paramétrage');
            If (FAUTOGT)
               then
                  BEGIN
                       FGinkoiaTools.failed;
                  END;
            exit;
        end;

   {$ENDREGION 'CONTROLES'}

    {$REGION 'TRAITEMENT'}
    lbl_status.Caption := 'Traitement en cours...';
    lbl_status.Refresh;
    pnl_Bottom.Repaint;
    Application.ProcessMessages;
    FGinkoiaTools.phase('Debut du traitement');

    vMagParams := LoadParametrageCentrale(cbCentrale.Text);


    // Construction
    vOK := SetParams(edt_Serveur.Text,
                edt_BaseFile.Text,
                CST_BASE_LOGIN,
                CST_BASE_PASSWORD,
                StrToIntDef(edt_Port.Text, CST_BASE_PORT),
                vMagParams,
                mLogs,
                vMags);

    // -------------------
    // Faire un thread ?
    // ==> [OK] pose/ecrasement des paramètres  131,132 etc...
    // ==> [OK] Désactivation des anciens Modes d'encaissement
    // ==> [OK] Ajout des nouveaux Mode d'encaissement (tous) y compris ceux qu'on utilisera pas
    // ==> [OK] Association dans CSHEMTTEURENC
    // ==> [OK]Association dans CSHEMETTEUR LINK
    // ==> reste à faire

    {$ENDREGION 'TRAITEMENT'}

    {$REGION 'LIBERATION_JETON'}
    if cbJeton.Checked and Assigned(vTokenManager) then
      begin
         try
           vTokenManager.releaseToken;
           FreeAndNil(vTokenManager);
           mLogs.Lines.Add('libération du Jeton : OK');
           Except on E:Exception do
            begin
              mLogs.Lines.Add('Erreur à la libération du Jeton : '+E.Message);
              raise Exception.Create('Erreur à la libération du Jeton : '+E.Message);
            End;
         end;
      end;
    {$ENDREGION 'LIBERATION_JETON'}

    FGinkoiaTools.success;
  Except
    On E:Exception do
      begin
          FGinkoiaTools.error(E.ClassName + ' ' + E.Message);
          FGinkoiaTools.failed;
      end;
  end;

  {$REGION 'AFFICHAGE'}
  // Ici il n'y a plus que de l'affichage
  Screen.Cursor := crDefault;
  if ((not FAuto) and (not FAUTOGT))
    then
      begin
          GestionInterface(true);
          // pour la mise à jour de la grille avant le message...
          MemMags.EnableControls;
          MessageDlg('Traitement Terminé', mtInformation, [mbOK], 0);
      end;

  lbl_status.Caption := 'Traitement Terminé';
  lbl_status.Refresh;
  pnl_Bottom.Repaint;
  Application.ProcessMessages;

  MemMags.EnableControls;
  BQuitter.Enabled    := true;
  BDisconnect.Enabled := true;
  if FAuto
    then
      begin
          mLogs.Lines.Add('Fermture auto...');
          Close;
      end
    else
      begin
        cbJeton.Enabled     := true;
        BExecute.Enabled    := true;
      end;

  {$ENDREGION 'AFFICHAGE'}

end;

procedure Tfrm_Main.BModifierClick(Sender: TObject);
begin
  if edt_BaseFile.Text<>'' then
    begin
      //
      exit;
    end;
  State := dsEdit;
end;

procedure Tfrm_Main.BSAVEClick(Sender: TObject);
begin
  Save;
end;

procedure Tfrm_Main.SetState(aValue:TDataSetState);
begin
  FState := aValue;
  if (cbCentrale.Text='') or (edt_BaseFile.Text<>'') then
    begin
      BModifier.Enabled:=false;
    end;
  if (aValue=dsBrowse) and (cbCentrale.Text='')
   then
     begin
       BModifier.Enabled:=false;
       BCancel.Enabled:=false;
       BValid.Enabled:=false;
       MemEmetteurs.ReadOnly:=true;
       MemTitres.Readonly:=true;
       edt_Defaut.Enabled :=false;
       edt_Trop_Percu.Enabled :=false;
       edt_URL.Enabled   := false;
       edt_GUID.Enabled  := false;
       spn_Delai.Enabled := false;
     end;


  if (aValue=dsBrowse) and (cbCentrale.Text<>'')
   then
     begin
       BModifier.Enabled:=true;
       BCancel.Enabled:=false;
       BValid.Enabled:=false;
       MemEmetteurs.ReadOnly:=true;
       MemTitres.Readonly:=true;
       edt_Defaut.Enabled :=false;
       edt_Trop_Percu.Enabled :=false;
       edt_URL.Enabled   := false;
       edt_GUID.Enabled  := false;
       spn_Delai.Enabled := false;
     end;

  if (aValue=dsEdit) and (cbCentrale.Text<>'')
    then
      begin
        BModifier.Enabled:=False;
        BCancel.Enabled:=true;
        BValid.Enabled:=true;
        MemEmetteurs.ReadOnly:=false;
        MemTitres.Readonly:=false;
        edt_Defaut.Enabled :=true;
        edt_Trop_Percu.Enabled :=true;
        edt_URL.Enabled   := true;
        edt_GUID.Enabled  := true;
        spn_Delai.Enabled := true;
      end;
end;

procedure Tfrm_Main.tAutoTimer(Sender: TObject);
begin
  tAuto.Enabled:=false;
  // une seule fois le lancement
  if (BExecute.Enabled)
    then
        begin
            mLogs.Lines.Add('Lancement Automatique...');
            BExecuteClick(BExecute);
        end;
  //
end;

procedure Tfrm_Main.Save();
var vParamCentrale:TParamsCentrale;
    i:integer;
    vMemoCODE : string;
    vCanSave : boolean;
    vCause   : string;
begin
  // Construction du record
  vCanSave := true;
  vCause   := '';
  vParamCentrale.Init(cbCentrale.Text);
  vParamCentrale.Defaut     := edt_Defaut.Text;
  vParamCentrale.TROP_PERCU := edt_Trop_Percu.Text;
  vParamCentrale.URL        := edt_URL.Text;
  vParamCentrale.GUID       := edt_GUID.Text;
  vParamCentrale.DELAI      := spn_Delai.Value;
  vMemoCODE := MemEmetteurs.FieldByName('CKE_CODE').AsString;
  MemEmetteurs.DisableControls;
  MemTitres.DisableControls;
  try
     // If
     If edt_Defaut.Text=edt_Trop_Percu.Text
        then
          begin
            vCanSave := false;
            vCause   := 'Le chèque Non Identifié et Trop Perçu doivent être différents !';
          end;

     MemEmetteurs.First;
     while not(MemEmetteurs.Eof) do
      begin
        i:=Length(vParamCentrale.Emetteurs);
        SetLength(vParamCentrale.Emetteurs,i+1);
        vParamCentrale.Emetteurs[i].CKE_CODE    := MemEmetteurs.FieldByName('CKE_CODE').AsString;
        vParamCentrale.Emetteurs[i].CKE_LIBELLE := MemEmetteurs.FieldByName('CKE_LIBELLE').AsString;
        vParamCentrale.Emetteurs[i].MEN_NOM := MemEmetteurs.FieldByName('MEN_NOM').AsString;
        If (MemEmetteurs.FieldByName('DETAIL').asstring = 'Attention')
          then
              begin
                 vCause   := ' "Attention" dans Détails';
                 vCanSave := false;
                 break;
              end;
        MemEmetteurs.Next;
      end;

     MemTitres.First;
     while not(MemTitres.Eof) do
      begin
        i:=Length(vParamCentrale.Titres);
        SetLength(vParamCentrale.Titres,i+1);
        vParamCentrale.Titres[i].CKI_CKECODE  := MemTitres.FieldByName('CKI_CKECODE').AsString;
        vParamCentrale.Titres[i].CKI_TYPECODE := MemTitres.FieldByName('CKI_TYPECODE').AsString;
        vParamCentrale.Titres[i].CKI_LIBELLE  := MemTitres.FieldByName('CKI_LIBELLE').AsString;
        vParamCentrale.Titres[i].UTILISABLE   := MemTitres.FieldByName('UTILISABLE').AsInteger;
        MemTitres.Next;
      end;

  finally
   MemTitres.EnableControls;
   MemEmetteurs.Locate('CKE_CODE',vMemoCODE,[]);
   MemEmetteurs.EnableControls;
  end;
  // Sauvegarde du Record
  if vCanSave then
     begin
        if not(SaveParametrageCentrale(vParamCentrale))
          then MessageDlg('Erreur la la sauvegarde',  mtError, [mbOK], 0);
        State := dsBrowse;
     end
   else
    begin
       MessageDlg('Impossible de sauvegarder :'+ #13+#10 + vCause,  mtError, [mbOK], 0);
    end;

  vParamCentrale.Destroy;
end;

procedure Tfrm_Main.BConnectClick(Sender: TObject);
var  Open : TOpenDialog;
begin
  // base distante
  if cbx_TypeBase.ItemIndex = 1
    then
      begin
        {*
        Par la base Maintenance uniquement....  WS ?
        // yellis ?
        *}
        Application.CreateForm(TFrm_ListeDossiersDistants,Frm_ListeDossiersDistants);
        If Frm_ListeDossiersDistants.Showmodal=mrOk
          then
            begin
              //
              edt_serveur.Text    := Frm_ListeDossiersDistants.Lame;
              edt_BaseFile.Text   := StringReplace(Frm_ListeDossiersDistants.chemin,edt_serveur.Text+':','',[rfIgnoreCase]);
              GestionInterface(True);
            end;
      end
    else
      try
        Open := TOpenDialog.Create(Self);
        Open.FileName := ExtractFileName(edt_BaseFile.Text);
        Open.InitialDir := ExtractFilePath(edt_BaseFile.Text);
        Open.Filter := 'IB Database|*.IB';
        Open.FilterIndex := 0;
        Open.DefaultExt := 'IB';
        if Open.Execute() then
        begin
          edt_BaseFile.Text := '';
          cbx_TypeBase.ItemIndex := 0;
          cbx_TypeBaseChange(Sender);
          edt_BaseFile.Text := Open.FileName;
          GestionInterface(True);
        end;
      finally
        FreeAndNil(Open);
      end;
end;

procedure Tfrm_Main.BDisconnectClick(Sender: TObject);
begin
  // Disconnect;
  BDisconnect.Enabled  := false;
  BDisconnect.Visible  := false;

  Bconnect.Enabled     := true;
  Bconnect.Visible     := true;

  cbx_TypeBase.Enabled := true;
  edt_BaseFile.Enabled := true;
  edt_BaseFile.Text    := '';

  MemMags.Close;
  MemMags.open;
  BExecute.Enabled := false;
  //----------------------------
  cbCentrale.Enabled:=true;
  BModifier.Enabled:=true;
end;

procedure Tfrm_Main.BQuitterClick(Sender: TObject);
begin
    Close;
end;


procedure Tfrm_Main.UpdateColDetail();
var vMemoCODE : string;
begin
   if State=dsBrowse then exit;
   vMemoCODE := MemEmetteurs.FieldByName('CKE_CODE').AsString;
   MemEmetteurs.DisableControls;
   try
      MemEmetteurs.First;
      while not(MemEmetteurs.eof) do
        begin
          MemEmetteurs.Edit;
          If (MemEmetteurs.FieldByName('MEN_NOM').asstring='')
            then MemEmetteurs.FieldByName('DETAIL').asstring := ''
            else
              begin
                //
                If (MemTitres.Locate('CKI_CKECODE;UTILISABLE',
                               VarArrayOf([MemEmetteurs.FieldByName('CKE_CODE').asstring,'1']),
                               [loCaseInsensitive]))
                  then MemEmetteurs.FieldByName('DETAIL').asstring := 'Voir Détails'
                  else MemEmetteurs.FieldByName('DETAIL').asstring := 'Attention'
              end;
          MemEmetteurs.Post;
          MemEmetteurs.Next;
        end;
   finally
    MemEmetteurs.Locate('CKE_CODE',vMemoCODE,[]);
    MemEmetteurs.EnableControls;
   end;
end;




procedure Tfrm_Main.Button1Click(Sender: TObject);
begin
    // il faut voir si c'est pas déja passé ???
// Controle
    // Compter le nombre de Mode d'encaissement
    // Compter le nombre de boutons liés à ces modes
    // Compter le nombre de postes liés à ces boutons
    {
    SELECT COUNT(*) FROM CSHMODEENC
    JOIN K ON (K_ID = MEN_ID AND K_ENABLED = 1)
							WHERE MEN_IDENT IN ('BEST','BON KYR.','CADHOC','CHQ CADO','HAVAS','KADEOS', 'SHOP. PASS','TIR GRP','TK HORI','TK INF')
								AND MEN_MAGID=:MAGID AND MEN_NOM NOT LIKE 'NE PLUS UTILISER - %'
    }


    // Action de nettoyage
    // Basculer les Anciens mode d'encaissement en 'NE PLUS UTLISER'
    // Suppression des boutons liés à ces modes d'encaissement sur chaque poste

    // ==> Procedure
{
ALTER PROCEDURE DESACTIVE_MODENC_BOUTON_CHEQUECADEAU
AS
declare variable RETOUR integer;
DECLARE VARIABLE MAGID integer;
DECLARE VARIABLE MENID integer;
DECLARE VARIABLE BTNID integer;
DECLARE VARIABLE MENNOM varchar(64);
BEGIN
	select retour from bn_only_pantin into :retour;
	/* Seulement sur la base LAME */
	if (retour<>0) then
		BEGIN
			FOR SELECT MAG_ID FROM UILGRPGINKOIA
			JOIN UILGRPGINKOIAMAG ON UGG_ID=UGM_UGGID
			JOIN GENMAGASIN ON MAG_ID=UGM_MAGID
			WHERE UGG_NOM='DEMATCHEQUECADEAU'
			INTO :MAGID
				DO
				BEGIN
					FOR SELECT MEN_ID, MEN_NOM FROM CSHMODEENC
							JOIN K ON (K_ID = MEN_ID AND K_ENABLED = 1)
							WHERE MEN_IDENT IN ('BEST','BON KYR.','CADHOC','CHQ CADO','HAVAS','KADEOS', 'SHOP. PASS','TIR GRP','TK HORI','TK INF')
								AND MEN_MAGID=:MAGID AND MEN_NOM NOT LIKE 'NE PLUS UTILISER - %'
							INTO :MENID, :MENNOM
								DO
									BEGIN
										UPDATE CSHMODEENC SET MEN_NOM=F_LEFT('NE PLUS UTILISER - '||MEN_NOM,64) WHERE MEN_ID=:MENID;
										EXECUTE PROCEDURE PR_UPDATEK(:MENID,0); /* reste actif */
										/* désactivation des boutons */
										FOR SELECT BTN_ID FROM CSHBOUTON
											JOIN K ON K_ID=BTN_ID AND K_ENABLED=1
											JOIN GENPOSTE ON POS_ID=BTN_POSID AND POS_MAGID=:MAGID
											JOIN K ON K_ID=POS_ID AND K_ENABLED=1
											WHERE BTN_MENID=:MENID INTO :BTNID
											DO
												BEGIN
													EXECUTE PROCEDURE PR_UPDATEK(:BTNID,1); /* désactive */
												END;
									END
				END
		END
END
}



// Action de Création
    // Création des 2 Modes d'encaissements (NON RENDU et par defaut) + liaison demat
    // Création des autres modes d'encaissement (suivant centrale) et evidement les liés dans la Demat
    // Création des 2 Boutons par Poste (1 en encaissement, 1 en utilitaire)

// Repositionnement/ arrangement des positions des boutons

    {
    SELECT MEN_ID, MEN_NOM FROM CSHMODEENC
        JOIN K ON (K_ID = MEN_ID AND K_ENABLED = 1)
				WHERE MEN_IDENT IN ('BEST','BON KYR.','CADHOC','CHQ CADO','HAVAS','KADEOS', 'SHOP. PASS','TIR GRP','TK HORI','TK INF')
          AND MEN_MAGID=:MAGID AND MEN_NOM NOT LIKE 'NE PLUS UTILISER - %'
    }



end;


procedure Tfrm_Main.cbCentraleChange(Sender: TObject);
var vParamsCentrale : TParamsCentrale;
    i:integer;
begin
   MemEmetteurs.DisableControls;
   MemTitres.DisableControls;
   State := dsEdit;
   try
     edt_Trop_Percu.Text := '';
     edt_Defaut.Text    := '';
     edt_URL.Text       := '';
     edt_GUID.Text      := '';
     spn_Delai.Value    := 15;
     //-------------  Nettoyage -----------------------------
     MemEmetteurs.First;
     while not(MemEmetteurs.eof) do
        begin
             MemEmetteurs.Edit;
             MemEmetteurs.FieldByName('MEN_NOM').Clear;
             MemEmetteurs.Post;
             MemEmetteurs.Next;
        end;

     MemTitres.First;
     while not(MemTitres.eof) do
        begin
            MemTitres.Edit;
            MemTitres.FieldByName('UTILISABLE').AsInteger:=0;
            MemTitres.Post;
            MemTitres.Next;
        end;

     vParamsCentrale := LoadParametrageCentrale(cbCentrale.Text);

     edt_Trop_Percu.Text := vParamsCentrale.TROP_PERCU;
     edt_Defaut.Text     := vParamsCentrale.Defaut;
     edt_URL.Text        := vParamsCentrale.URL;
     edt_GUID.Text       := vParamsCentrale.GUID;
     spn_Delai.Value     := vParamsCentrale.DELAI;


     // Mise à jour de l'écran
     for I := Low(vParamsCentrale.Emetteurs) to High(vParamsCentrale.Emetteurs) do
      begin
        if MemEmetteurs.Locate('CKE_CODE',vParamsCentrale.Emetteurs[i].CKE_CODE,[loCaseInsensitive])
          then
            begin
              MemEmetteurs.Edit;
              MemEmetteurs.FieldByName('MEN_NOM').AsString:=vParamsCentrale.Emetteurs[i].MEN_NOM;
              MemEmetteurs.Post;
            end
      end;

     for I := Low(vParamsCentrale.Titres) to High(vParamsCentrale.Titres) do
      begin
        if MemTitres.Locate('CKI_CKECODE;CKI_TYPECODE',
              VarArrayOf([vParamsCentrale.Titres[i].CKI_CKECODE,
                         vParamsCentrale.Titres[i].CKI_TYPECODE])
                      ,[loCaseInsensitive])
          then
            begin
              MemTitres.Edit;
              MemTitres.FieldByName('UTILISABLE').Asinteger:=vParamsCentrale.Titres[i].UTILISABLE;
              MemTitres.Post;
            end
      end;
  finally
   MemTitres.EnableControls;
   MemEmetteurs.EnableControls;
  end;
  UpdateColDetail;
  State := dsBrowse;
  vParamsCentrale.Destroy;
end;

procedure Tfrm_Main.cbx_TypeBaseChange(Sender: TObject);
begin
  case cbx_TypeBase.ItemIndex of
    0 : // local
      begin
        edt_Serveur.Text := 'localhost';
        edt_Serveur.Visible := false;
        edt_Port.Text := IntToStr(CST_BASE_PORT);
        edt_Port.Visible := false;
        BConnect.Visible := true;
        // taille de l'edit
        edt_BaseFile.Left  := 107;
        edt_BaseFile.Width := 514;
      end;
    1 : // distante
      begin
        edt_Serveur.Visible := true;
        edt_Port.Visible := true;
        BConnect.Visible := true;
        // taille de l'edit
        edt_BaseFile.Left := 244;
        edt_BaseFile.Width := 404;
      end;
  end;
  GestionInterface(true);
end;

procedure Tfrm_Main.Click(Sender: TObject);
begin
  Save();
end;

procedure Tfrm_Main.cxGrid1DBTableView1CHECKPropertiesEditValueChanged(
  Sender: TObject);
begin
  MAJ_Button_Execute();
end;

procedure Tfrm_Main.cxGrid1DBTableView1MAG_CENTRALEPropertiesValidate(
  Sender: TObject; var DisplayValue: Variant; var ErrorText: TCaption;
  var Error: Boolean);
begin
   cbCentrale.Text := DisplayValue;
   cbCentrale.ItemIndex := cbCentrale.Items.IndexOf(DisplayValue);
   cbCentraleChange(Self);
end;

procedure Tfrm_Main.cxGridDBTableView1CellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
var aArray,aNewArray:TTitres;
//    vTmp : TTitre;
    i:integer;
begin
   if (AcellViewInfo.Item.Index=cxGridDBTableView1DETAIL.Index)
    then
      begin
           if (MemEmetteurs.FieldByName('MEN_NOM').AsString<>'')
            then
              begin
                 // Creation du Tableau dynamique...
                 // Faut aller chercher en mémoire (memTitres) pas dans la table...
                 memTitres.First;
                 SetLength(aArray,0);
                 while not(MemTitres.eof) do
                    begin
                        if (MemTitres.FieldByName('CKI_CKECODE').AsString=MemEmetteurs.FieldByName('CKE_CODE').AsString)
                          then
                            begin
                              i:=Length(aArray);
                              SetLength(aArray,i+1);
                              aArray[i].CKI_CKECODE  := MemTitres.FieldByName('CKI_CKECODE').AsString;
                              aArray[i].CKI_TYPECODE := MemTitres.FieldByName('CKI_TYPECODE').AsString;
                              aArray[i].CKI_LIBELLE  := MemTitres.FieldByName('CKI_LIBELLE').AsString;
                              aArray[i].UTILISABLE   := MemTitres.FieldByName('UTILISABLE').AsInteger;
                            end;
                      MemTitres.Next;
                    end;
                 if State=dsEdit
                   then
                      begin
                          aNewArray := ExecuteTitres(aArray,false);
                          // mise à jour en mémoire...
                          for I := Low(aNewArray) to High(aNewArray) do
                            begin
                               If (MemTitres.Locate('CKI_CKECODE;CKI_TYPECODE;CKI_LIBELLE',
                                         VarArrayOf([aNewArray[i].CKI_CKECODE,aNewArray[i].CKI_TYPECODE,aNewArray[i].CKI_LIBELLE]),
                                         [loCaseInsensitive]))
                                 then
                                   begin
                                     MemTitres.Edit;
                                     MemTitres.FieldByName('UTILISABLE').AsInteger := aArray[i].UTILISABLE;
                                     MemTitres.Post;
                                   end;
                            end;
                          UpdateColDetail();
                      end
                   else ExecuteTitres(aArray,true);
              end;
      end;
end;

procedure Tfrm_Main.cxGridDBTableView1MEN_NOMPropertiesEditValueChanged(
  Sender: TObject);
begin
    UpdateColDetail;
    ///
    ///
end;

procedure Tfrm_Main.edt_BaseFileChange(Sender: TObject);
begin
  // base local ou même distante
{
  if cbx_TypeBase.ItemIndex = 0
     then GestionInterface(True);
}
end;

procedure Tfrm_Main.edt_BaseFileKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key=VK_RETURN
      then GestionInterface(True);
end;

procedure Tfrm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Log.CLose; Prochainement
  // FGinkoiaTools.exit ;

  Action:=caFree;
end;

procedure Tfrm_Main.setError(aError : string) ;
begin

  FError := aError ;
  FGinkoiaTools.error(aError);

  // Message si pas en mode AUto
  if (not(FAuto or FAUTOGT))
     then MessageDlg(aError,  mtError, [mbOK], 0);

  mLogs.Lines.Add('Erreur : ' +aError);
  lbl_status.Caption := 'Erreur : ' +aError;
  lbl_status.Refresh;
  pnl_Bottom.Repaint;
  Application.ProcessMessages;

end;

procedure Tfrm_Main.FormCreate(Sender: TObject);
var vEncaissements : TEncaissements;
    vEMetteurs : TEmetteurs;
    vCentrales : Tcentrales;
    vTitres : TTitres;
    i:integer;
    Param, Value : string;
begin
   FautoGT    := false;
   FAuto      := false;
   FCODETIERS := '';
   FFORCECentrale := '';

   FCODETIERSList := TStringList.Create;
   FMAG_CODEList  := TStringList.Create;


   FGinkoiaTools := TGinkoiaTools.Create ;
   FGinkoiaTools.onStart := GinkoiaTools_onStart ;
   FGinkoiaTools.onExit := GinkoiaTools_onExit ;

   FAUTOGT := FGinkoiaTools.Active;

   if not (SameText(edt_Serveur.Text, CST_BASE_SERVEUR) and SameText(edt_Port.Text, IntToStr(CST_BASE_PORT))) then
    cbx_TypeBase.ItemIndex := 1
   else
    cbx_TypeBaseChange(nil);

   vEncaissements := GetEncaissements();
   MemEnc.Close();
   MemEnc.Open();
   for I := Low(vEncaissements) to High(vEncaissements) do
     begin
      MemEnc.Append();
      MemEnc.FieldByName('NOM').Asstring:=vEncaissements[i].Nom;
      MemEnc.Post();
     end;

   vEMetteurs     := GetEmetteurs();

   MemEmetteurs.Close();
   MemEmetteurs.Open();
   for I := Low(vEMetteurs) to High(vEMetteurs) do
     begin
      MemEmetteurs.Append();
      MemEmetteurs.FieldByName('CKE_CODE').Asstring:=vEmetteurs[i].CKE_CODE;
      MemEmetteurs.FieldByName('CKE_LIBELLE').Asstring:=vEmetteurs[i].CKE_LIBELLE;
      MemEmetteurs.FieldByName('MEN_NOM').Asstring:=vEmetteurs[i].MEN_NOM;
      MemEmetteurs.Post();
     end;

    vTitres        := GetTitres();
    MemTitres.Close();
    MemTitres.Open();
  for I := Low(vTitres) to High(vTitres) do
    begin
      MemTitres.Append();
      MemTitres.FieldByName('CKI_CKECODE').Asstring:=vTitres[i].CKI_CKECODE;
      MemTitres.FieldByName('CKI_TYPECODE').Asstring:=vTitres[i].CKI_TYPECODE;
      MemTitres.FieldByName('CKI_LIBELLE').Asstring:=vTitres[i].CKI_LIBELLE;
      MemTitres.FieldByName('UTILISABLE').Asinteger:=vTitres[i].UTILISABLE;
      MemTitres.Post();
    end;

   //---------------------------------------------------------------------------
   vCentrales := GetCentrales;
   cbCentrale.Clear;
   TcxComboBoxProperties(cxGrid1DBTableView1MAG_CENTRALE.Properties).Items.CLear;
   for I := Low(vCentrales) to High(vCentrales) do
     begin
       cbCentrale.Items.Add(vCentrales[i].Nom);
       TcxComboBoxProperties(cxGrid1DBTableView1MAG_CENTRALE.Properties).Items.Add(vCentrales[i].Nom);
     end;
   cbCentrale.ItemIndex:=-1;

   State := dsBrowse;
   setLength(vTitres,0);
   setLength(vCentrales,0);
   setLength(vEMetteurs,0);
   setLength(vEncaissements,0);

  // paramètres
  for i := 1 to ParamCount do
  begin
    if Pos('=', ParamStr(i)) > 0 then
    begin
      Param := UpperCase(Trim(Copy(ParamStr(i), 1, Pos('=', ParamStr(i)) -1)));
      Value := Copy(ParamStr(i), Pos('=', ParamStr(i)) +1, Length(ParamStr(i)));
    end
    else
    begin
      Param := UpperCase(Trim(ParamStr(i)));
      Value := '';
    end;
    GestionOrdre(Param, Value);
    // Seulememnt quand on a tous les paramètres

    if i=ParamCount then GestionInterface(True);

  end;



  Split(',',FCODETIERS,FCODETIERSList) ;
  Split(',',FMAG_CODE,FMAG_CODEList) ;


  // ShowMessage(IntToStr(FMAG_CODEList.Count));

  // Si mode Auto mais qu'on a pas mis le chemin de la base Alors on lit la base 0
  if ((FAuto) or (FAUTOGT)) and (edt_BaseFile.Text='')
    then
      begin
          mLogs.Lines.Add('Aucun paramètre de BASE on va lire dans le registre "Base0"');
          edt_BaseFile.Text := ReadBase0;
          mLogs.Lines.Add(Format('BASE=%s',[edt_BaseFile.Text]));
      end;

   GestionInterface(True);




  // un split des codes CODETIERS et des MAGCODES passés en paramètres
  { // Prochainement
   Log.App   := Application.ExeName;
   Log.Inst  := '' ;
   Log.FileLogFormat := [elDate, elMdl, elKey, elLevel, elNb, elValue] ;
   Log.SendOnClose := true ;
   Log.Open ;
   Log.SendLogLevel := logTrace;
  }


end;


procedure Tfrm_Main.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FCODETIERSList);
  FreeAndNil(FMAG_CODEList);

  FreeAndNil(FGinkoiaTools) ;
end;

procedure TFrm_Main.GestionOrdre(Param, Value : string);
var Ordre : integer;
begin
  if CharInSet(Param[1], ['/', '-']) then
    Param := Copy(Param, 2, Length(Param));
  Ordre := IndexStr(Param, ListeOrdres);
  case Ordre of
    0 : // SERVEUR
      edt_Serveur.Text := value;
    1 : // PORT
      edt_Port.Text := IntToStr(StrToIntDef(Value, CST_BASE_PORT));
    2 : // BASE
      begin
        edt_BaseFile.Text := Value;
        mLogs.Lines.Add(Format('BASE=%s',[edt_BaseFile.Text]));
      end;
    3 : // AUTO avant tout le monde car il permet de Flager tous les mags
      begin
          FAuto := true;

          // ??? mettre ici ?
          // FGinkoiaTools.start ;

          tAuto.Interval := Math.Max(StrToIntDef(Value,5)*1000,5000);
          mLogs.Lines.Add(Format('Lancement Automatique dans %d secondes',[tAuto.Interval div 1000]));
          lbl_status.Caption := 'Lancement Automatique dans un instant. Veuillez patienter';
          // lbl_status.Refresh;
          TabSheet1.Enabled:=false;
          tAuto.Enabled  := true;
      end;
    4: // CODETIERS
      begin
        // Exemple CODETIERS=5236,5499
        mLogs.Lines.Add(Format('CODETIERS=%s',[Value]));
        // FCODETIERS = ,5236,5499,
        FCODETIERS := ','+Value+','; // cela va nous permettre de mieux chercher sans erreur
      end;
    5: // CENTRALE
      begin
        FFORCECentrale := Value;
        mLogs.Lines.Add(Format('CENTRALE=%s',[FFORCECentrale]));
      end;

    6: // MAG_CODE
      begin
        FMAG_CODE := Value;
        mLogs.Lines.Add(Format('MAG_CODE=%s',[FMAG_CODE]));
      end;

     { Désormais
     7: // AUTOGT
      begin
         FAutoGT := true;
      end;
     }

  end;
end;



procedure Tfrm_Main.FormShow(Sender: TObject);
begin
    //

    //
end;


procedure Tfrm_Main.Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;

procedure Tfrm_Main.GestionInterface(Enabled : Boolean);
var
  CnxEnabled, InfEnabled : boolean;
  error, tmpNom, Unite : string;
  Taille : double;
  DateVersion : TDateTime;
  vMags : TMagasins;
  I,j: Integer;
//  vTitres : TTitres;
begin
  // if not Enabled then
  Screen.Cursor := crHourGlass; // Toujours
  Application.ProcessMessages();

  CnxEnabled := false;
  InfEnabled := false;

  try
    // blocage temporaire
    Self.Enabled := False;

    lbl_BaseFile.Enabled := Enabled;
    cbx_TypeBase.Enabled := Enabled;
    edt_Serveur.Enabled := Enabled;
    edt_Port.Enabled := Enabled;
    edt_BaseFile.Enabled := Enabled;
    Bconnect.Enabled := Enabled;

    try
      if Enabled and
         ((Trim(edt_BaseFile.Text) <> '') and
         ((cbx_TypeBase.ItemIndex = 1) or FileExists(edt_BaseFile.Text))) then
      begin
        CnxEnabled := CanConnect(edt_Serveur.Text, edt_BaseFile.Text, CST_BASE_LOGIN, CST_BASE_PASSWORD, StrToIntDef(edt_Port.Text, CST_BASE_PORT), error);
        if CnxEnabled then
          InfEnabled := GetInfosBase(edt_Serveur.Text, edt_BaseFile.Text, CST_BASE_LOGIN, CST_BASE_PASSWORD, StrToIntDef(edt_Port.Text, CST_BASE_PORT), FVersion, FNom, FCentrale, FGUID, FBasSender, DateVersion, FGenerateur, FRecalcul, error)
                        and (FVersion <> '') and (FGenerateur > -1)
        else
          begin
              // If not(Fauto)
              //  then MessageDlg('Erreur de connexion a la base de données :'#10#13 + error, mtError, [mbOK],0);
              setError('Erreur de connexion a la base de données :'#10#13 + error);
              FGinkoiaTools.failed ;
          end;
      end;
    except
      on e : Exception do
      begin
        // if not(Fauto)
        //   then MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK],0);
        setError('Exception : ' + e.ClassName + ' - ' + e.Message);
        FGinkoiaTools.failed ;
        CnxEnabled := false;
        InfEnabled := false;
      end;
    end;

    // Seulement si on a une base
    // et que le logiciel est dispo
    if Enabled then
    begin
      if InfEnabled then
      begin
        // info Yellis
        // FreeAndNil(FYellisVersion);
        // GetYellisVersion(FYellisVersion, FVersion);
        BDisconnect.Enabled := true;
        BDisconnect.Visible := true;

        BConnect.Enabled    := false;
        BConnect.Visible    := false;
        cbx_TypeBase.Enabled := false;
        edt_BaseFile.Enabled := false;

        // nom de base
        tmpNom := 'Nom : ' + FNom;

        {
        if lbl_Version.Canvas.TextWidth(tmpNom) > lbl_Version.ClientWidth then
        begin
          while lbl_Version.Canvas.TextWidth(tmpNom + '…') > lbl_Version.ClientWidth do
            Delete(tmpNom, Length(tmpNom), 1);
          tmpNom := tmpNom + '…';
        end;
        }
        vMags := GetDBMagasinDemat(edt_Serveur.Text, edt_BaseFile.Text, CST_BASE_LOGIN, CST_BASE_PASSWORD,StrToIntDef(edt_Port.Text, CST_BASE_PORT));
        if Length(vMags)=0 then
          begin
            // if Not(FAuto)
            //   then MessageDlg('Aucun Magasin avec le Module de Démat',  mtError, [mbOK], 0);

            setError('Aucun Magasin avec le Module de Démat');
            FGinkoiaTools.failed ;
          end;

        { On peut désormais passer sur une base non Zero
        if (FGenerateur<>0) then
          begin
            MessageDlg('Vous n''êtes pas sur une Base Zéro',  mtError, [mbOK], 0);
          end;
        }

        // prise de jeton uniquement si Lame = Base0
        cbJETON.Checked := (FGenerateur=0);

        // On se positionne sur la bonne centrale
        if FCentrale<>'' then
          begin
            cbCentrale.Enabled := false;
            cbCentrale.ItemIndex := cbCentrale.Items.IndexOf(Fcentrale);
            cbCentraleChange(Self);
            BModifier.Enabled := false;
          end;

        MemMags.Close();
        MemMags.Open();
        for I := Low(vMags) to High(vMags) do
          begin
            MemMags.Append();
            MemMags.FieldByName('CHECK').Asinteger:=0;

            if (FAuto) and (FGenerateur=0)
              then MemMags.FieldByName('CHECK').Asinteger:=1;

            MemMags.FieldByName('MAG_ID').AsInteger:=vMags[i].MAG_ID;
            MemMags.FieldByName('MAG_NOM').Asstring:=vMags[i].MAG_NOM;
            MemMags.FieldByName('MAG_CENTRALE').AsString  :=  vMags[i].MAG_CENTRALE;
            MemMags.FieldByName('MAG_CODETIERS').AsString :=  vMags[i].MAG_CODETIERS;
            MemMags.FieldByName('MAG_CODE').AsString      :=  vMags[i].MAG_CODE;

            if (FCODETIERS<>'')
              then
                begin
                    For j:=0 to FCODETIERSList.Count-1 do
                      begin
                         if vMags[i].MAG_CODETIERS=FCODETIERSList[j]
                           then MemMags.FieldByName('CHECK').Asinteger:=1;
                      end;
                end;


            if (FMAG_CODE<>'')
              then
                begin
                    For j:=0 to FMAG_CODEList.Count-1 do
                      begin
                         if vMags[i].MAG_CODE=FMAG_CODEList[j]
                           then MemMags.FieldByName('CHECK').Asinteger:=1;
                      end;
                end;

            if (FFORCECENTRALE<>'')
              then
                begin
                  MemMags.FieldByName('MAG_CENTRALE').Asstring:=FFORCECENTRALE;
                end;

            MemMags.FieldByName('MAG_DONE').AsInteger     :=  vMags[i].MAG_DONE;
            // cbMags.Items.Add(vMags[i].MAG_NOM);
            MemMags.Post();
          end;


        MAJ_Button_Execute();

        UpdateColDetail();

        if SameText(edt_Serveur.Text, CST_BASE_SERVEUR) then
        begin
          // taille du fichier
          Taille := GetFileSize(edt_BaseFile.Text);

          Unite := 'o';
          if Taille > 1000 then
          begin
            Taille := Taille / 1000;
            Unite := 'ko';
          end;
          if Taille > 1000 then
          begin
            Taille := Taille / 1000;
            Unite := 'Mo';
          end;
          if Taille > 1000 then
          begin
            Taille := Taille / 1000;
            Unite := 'Go';
          end;

          // label information
          lbl_Version.Caption := tmpNom + #13#10
                               + 'Base : ' + FVersion + ' (le ' + FormatDateTime('yyyy-mm-dd', DateVersion) + ')' + #13#10
                               + 'Taille : ' + FloatToStr(RoundTo(Taille, -2)) + ' ' + Unite + #13#10
                               + 'Nom : ' + FNom + #13#10
                               + 'GUID : ' + FGUID + #13#10
                               + 'IDGENERATEUR/BAS_IDENT : ' + IntToStr(FGenerateur) + #13#10
                               + 'Sender : ' + FBasSender + #13#10
                               + 'Centrale : ' + FCentrale;
        end
        else
        begin
          lbl_Version.Caption := tmpNom + #13#10
                               + 'Base : ' + FVersion + ' (le ' + FormatDateTime('yyyy-mm-dd', DateVersion) + ')' + #13#10
                               + 'Générateur : ' + IntToStr(FGenerateur)+ #13#10
                               + 'Nom : ' + FNom + #13#10
                               + 'GUID : ' + FGUID + #13#10
                               + 'IDGENERATEUR/BAS_IDENT : ' + IntToStr(FGenerateur) + #13#10
                               + 'Sender : ' + FBasSender + #13#10
                               + 'Centrale : ' + FCentrale;
        end;

        // repertoir de log (pour cette base)
        FLogDest := IncludeTrailingPathDelimiter(ExtractFilePath(edt_BaseFile.Text) + 'Log');
      end
      else if CnxEnabled then
      begin
        lbl_Version.Caption := 'Base non Ginkoia';
        // repertoir de log (pour cette base)
        FLogDest := IncludeTrailingPathDelimiter(ExtractFilePath(edt_BaseFile.Text) + 'Log');
      end
      else
      begin
        lbl_Version.Caption := '';
        // repertoir de log (par défaut)
        FLogDest := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'Log');
      end;
    end;

    BQuitter.Enabled := Enabled;
  finally
    // deblocage
    Self.Enabled := True;
    SetLength(vMags,0);
  end;

  // if Enabled then
  Screen.Cursor := crDefault;
  Application.ProcessMessages();
end;



procedure Tfrm_Main.MAJ_Button_Execute();
var vActif:Boolean;
    i:integer;
begin
     try
       if MemMags.IsEmpty then exit;
       vActif := False;
       BExecute.Enabled := false;
       MemMags.DisableControls;
       i := MemMags.FieldByName('MAG_ID').asinteger;
       MemMags.First;
       // (cbCentrale.ItemIndex>-1) and (MemMags.RecordCount>0)
       While not(MemMags.eof) do
          begin
             vActif :=  vActif or ((MemMags.FieldByName('CHECK').AsInteger=1) and (cbCentrale.ItemIndex>-1));
             MemMags.Next;
          end;

       BExecute.Enabled := vActif;
       MemMags.Locate('MAG_ID',i,[]);
       MemMags.EnableControls;
    finally
      If (FAUTOGT) then
        begin
            If BExecute.Enabled
               then FGinkoiaTools.ready
               else
                begin
                  FGinkoiaTools.error('Mauvais parametrage');
                  FGinkoiaTools.failed ;
                end;

        end;
    end;
end;


end.
