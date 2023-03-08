{***************************************************************
 *
 * Unit Name: FidNatTwin_Frm
 * Purpose  :
 * Author   :
 * History  :
 *
 ****************************************************************}

//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

unit FidNatTwin_Frm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  AlgolDialogForms,
  //debut uses
  XMLCursor,
  StdXML_TLB,
  soapOperation,
  Patienter_Frm,
  Twinner_Dm,
  //fin uses
  Dialogs,
  AlgolStdFrm,
  LMDControl,
  LMDBaseControl,
  LMDBaseGraphicButton,
  LMDCustomSpeedButton,
  LMDSpeedButton,
  ExtCtrls,
  RzPanel,
  fcStatusBar,
  RzBorder,
  LMDCustomComponent,
  LMDWndProcComponent,
  LMDFormShadow, dxCntner, dxTL, dxDBCtrl, dxDBGrid, dxDBGridHP, StdCtrls,
  RzLabel, Mask, wwdbedit, wwDBEditRv, Db, dxmdaset, RzPanelRv,
  IB_Components, dxDBTLCl, dxGrClms, IB_StoredProc, IB_Access,
  LMDBaseGraphicControl, AdvGlowButton, AdvEdit, DBAdvEd,GinkoiaStyle_dm,
  IBCustomDataSet, IBQuery, ShellAPI, IniFiles;

const
  NUMQUALIFIANT = 40000;

type
  TFrm_FidNatTwin = class(TAlgolDialogForm)
    Pan_Btn: TRzPanel;
    Ds_ClientsNat: TDataSource;
    MemD_Clients: TdxMemData;
    MemD_ClientsMagNom: TStringField;
    MemD_ClientsNom: TStringField;
    MemD_ClientsPrenom: TStringField;
    MemD_ClientsAdresse: TStringField;
    MemD_ClientsCp: TStringField;
    MemD_ClientsVilNom: TStringField;
    MemD_ClientsGsm: TStringField;
    MemD_ClientsEmail: TStringField;
    MemD_ClientsNaissance: TDateTimeField;
    MemD_ClientsPayNom: TStringField;
    MemD_ClientsCb: TStringField;
    MemD_ClientsLabels: TStringField;
    IbStProc_Client: TIB_StoredProc;
    MemD_ClientsADR2: TStringField;
    MemD_ClientsADR3: TStringField;
    Lab_Nom: TRzLabel;
    Lab_Prenom: TRzLabel;
    Nbt_Rechercher: TAdvGlowButton;
    Chp_Nom: TDBAdvEdit;
    Chp_Prenom: TDBAdvEdit;
    RzPanel1: TRzPanel;
    Pan_Edition: TRzPanel;
    Lab_Ou: TRzLabel;
    Nbt_Cancel: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    Shape1: TShape;
    Pan_Consult: TRzPanel;
    Nbt_Edit: TAdvGlowButton;
    DBG_ClientsNat: TdxDBGridHP;
    DBG_ClientsNatRecId: TdxDBGridColumn;
    DBG_ClientsNatMagNom: TdxDBGridMaskColumn;
    DBG_ClientsNatNom: TdxDBGridMaskColumn;
    DBG_ClientsNatPrenom: TdxDBGridMaskColumn;
    DBG_ClientsNatAdresse: TdxDBGridMaskColumn;
    DBG_ClientsNatCp: TdxDBGridMaskColumn;
    DBG_ClientsNatVilNom: TdxDBGridMaskColumn;
    DBG_ClientsNatGsm: TdxDBGridMaskColumn;
    DBG_ClientsNatEmail: TdxDBGridMaskColumn;
    DBG_ClientsNatNaissance: TdxDBGridDateColumn;
    DBG_ClientsNatPayNom: TdxDBGridMaskColumn;
    DBG_ClientsNatCb: TdxDBGridMaskColumn;
    DBG_ClientsNatLabels: TdxDBGridMaskColumn;
    RzPanel2: TRzPanel;
    dxDBGridHP1: TdxDBGridHP;
    dxDBGridColumn1: TdxDBGridColumn;
    dxDBGridMaskColumn1: TdxDBGridMaskColumn;
    dxDBGridMaskColumn2: TdxDBGridMaskColumn;
    dxDBGridMaskColumn3: TdxDBGridMaskColumn;
    dxDBGridMaskColumn4: TdxDBGridMaskColumn;
    dxDBGridMaskColumn5: TdxDBGridMaskColumn;
    dxDBGridMaskColumn6: TdxDBGridMaskColumn;
    dxDBGridMaskColumn7: TdxDBGridMaskColumn;
    dxDBGridMaskColumn8: TdxDBGridMaskColumn;
    dxDBGridDateColumn1: TdxDBGridDateColumn;
    dxDBGridMaskColumn9: TdxDBGridMaskColumn;
    dxDBGridMaskColumn10: TdxDBGridMaskColumn;
    dxDBGridMaskColumn11: TdxDBGridMaskColumn;
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
    procedure AlgolMainFrmKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AlgolStdFrmCreate(Sender: TObject);
    procedure Pan_BtnEnter(Sender: TObject);
    procedure Pan_BtnExit(Sender: TObject);
    procedure Nbt_RechercherClick(Sender: TObject);
    procedure AlgolStdFrmShow(Sender: TObject);
    procedure Nbt_EditClick(Sender: TObject);
  private
    UserCanModify, UserVisuMags: Boolean;
    clt_id: Integer; //id renseigné lors d'une création ou d'une sélection dans la base nationale
    procedure renseigner_client(PassXml: IXMLCursor);
    procedure add_clientBaseLocale();
    function get_client_via_code_barre(cbClient: string; var MemD_Clients: TdxMemData): integer;
    function get_client_via_nom_prenom(nom, prenom: string; var MemD_Clients: TdxMemData): Boolean;
    function get_code_qualifiant(qualifiant: string): Integer;
    function creer_labels_web(labels: string): string;
    function creer_labels_ginkoia(PassXml: IXMLCursor): string;
    function get_count_qualifiants(): Integer;
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published

  end;

function ExecuteFidNatTwinNomPrenom(aNom: string = ''; aPrenom: string = ''): Integer;
function ExecuteFidNatTwinCodeBarre(ACb: string): Integer;
function ExecuteFidNatTwinAjoutModifClient(ACltId: Integer; ancienCbTwin : string; boolSuppression : boolean): Boolean;

var
  Frm_FidNatTwin: TFrm_FidNatTwin;

implementation
{$R *.DFM}
uses
  StdUtils;
  //GinkoiaStd,
  //DlgStd_Frm,
  //GinkoiaResStr, Main_Dm,UCGODisableForm;

function ExecuteFidNatTwinNomPrenom(aNom: string = ''; aPrenom: string = ''): Integer;
begin
//  Application.createform(TFrm_FidNatTwin, Frm_FidNatTwin);
//  with Frm_FidNatTwin do
//  begin
//    try
//      //renseigner les champs par défaut
//      Chp_Nom.text := aNom;
//      Chp_Prenom.text := aPrenom;
//      //tag
//      {Pan_NomPrenom.tag := 1;} // SST 2011 paneau supprimé
//      if {Showmodal} CustomShowModal(Frm_FidNatTwin,FdCurrentWindow,DmDarkForm,80)= mrOk then
//      begin
//      end;
//    finally
//      MemD_Clients.close;
//      //retourner le résultat
//      Result := Frm_FidNatTwin.clt_id;
//      Free;
//    end;
//  end;
end;

function ExecuteFidNatTwinCodeBarre(ACb: string): Integer;
var
 IntCodeRetour : Integer;
begin
//     //initialiser le code retour
//IntCodeRetour := 0;
//  Frm_FidNatTwin := TFrm_FidNatTwin.create(Application);
//  with Frm_FidNatTwin do
//  begin
//    try
//      // interroger le web service
//      IntCodeRetour := get_client_via_code_barre(ACb, MemD_Clients);
//      //tester le code retour
//      //Si un ou plusieur clients trouvés
//      IF (IntCodeRetour > 0) then
//      begin
//        //si une réponse  créer le client dans la base locale
//        if MemD_Clients.RecordCount = 1 then
//        begin
//          //créer le client
//          add_clientBaseLocale();
//        end
//          //si plusieurs réponse afficher form de sélection sans panel nom prenom
//        else
//        begin
//          //signaler panel invisible à l'ouverture
//         { Pan_NomPrenom.tag := 0;} // SST 2011 paneau supprimé
//          if Showmodal = mrOk then
//          begin
//          end;
//        end;
//      end
//      //si le code n'existe pas
//      ELSE IF (IntCodeRetour = -2) then
//      begin
//           Frm_FidNatTwin.clt_id := -2;
//      END;
//    finally
//      MemD_Clients.close;
//      //retourner le résultat
//      Result := Frm_FidNatTwin.clt_id;
//      Free;
//    end;
//  end;
end;

function ExecuteFidNatTwinAjoutModifClient(ACltId: Integer; ancienCbTwin : string; boolSuppression : boolean): Boolean;
var
  reponse   : boolean;
  Soap      : ISoapOperation;
  PassXML,
  Document  : IXMLCursor;
  strDate   : string;
  sFicIni,
  sMsg,
  sCode     : string;
  MyIniFile : TIniFile;


begin
  reponse := False;
  Application.createform(TFrm_FidNatTwin, Frm_FidNatTwin);
  with Frm_FidNatTwin do
  begin
    try
      Dm_Twinner.Que_FidNatTwin.Close;
      Dm_Twinner.Que_FidNatTwin.ParamByName('magid').AsInteger := Dm_Twinner.que_magmag_magid.AsInteger;
      Dm_Twinner.Que_FidNatTwin.Open;

      //ShowMessHPAvi('Liaison avec la base nationale Twinner', true, 0, 0, 'Fidélité Twinner');
      VeuillezPatienter('Liaison avec la base nationale Twinner');

      // Création de l'objet inifile
      sFicIni := ExtractFilePath(Application.ExeName)+'\SendSoap.ini';
      MyIniFile := TIniFile.Create(sFicIni);
      try
        MyIniFile.WriteString('SEND','Url',Dm_Twinner.que_FidNatTwin.Fields[1].asstring);
        MyIniFile.WriteString('SEND','SoapAction','add_clientAction');
        MyIniFile.WriteString('SEND','Message','twin:add_client_datas');
        MyIniFile.WriteString('SEND','Prepare','<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:twin="http://www.twinner-sports.com/webservice/soap/twinner.wsdl"><soapenv:Header/></soapenv:Envelope>');
        MyIniFile.WriteString('SEND','Select','/twin:add_client_datas');

        Dm_Twinner.Que_GUID.Close;
        Dm_Twinner.Que_GUID.Open;
        MyIniFile.WriteString('SEND','GuidBase',Dm_Twinner.Que_GUID.FieldByName('bas_guid').AsString);

        Dm_Twinner.Que_ClientFidNatTwin.Close;
        Dm_Twinner.Que_ClientFidNatTwin.parambyname('cltid').asInteger := ACltid;
        Dm_Twinner.Que_ClientFidNatTwin.Open;
        MyIniFile.WriteString('SEND','NumAdherent',Trim(Dm_Twinner.que_magmag_codeadh.asstring));
        MyIniFile.WriteString('SEND','ContGinkoiaId',IntToStr(Acltid));
        MyIniFile.WriteString('SEND','ContMagasin',Trim(Dm_Twinner.que_magmag_nom.asstring));
        MyIniFile.WriteString('SEND','ContNom',Dm_Twinner.Que_ClientFidNatTwin.FieldByName('CLT_NOM').AsString);
        MyIniFile.WriteString('SEND','ContPrenom',Dm_Twinner.Que_ClientFidNatTwin.FieldByName('CLT_PRENOM').AsString);
        MyIniFile.WriteString('SEND','ContAdresse',Dm_Twinner.Que_ClientFidNatTwin.FieldByName('ADR1').AsString);
        MyIniFile.WriteString('SEND','ContAdresse2',Dm_Twinner.Que_ClientFidNatTwin.FieldByName('ADR2').AsString);
        MyIniFile.WriteString('SEND','ContAdresse3',Dm_Twinner.Que_ClientFidNatTwin.FieldByName('ADR3').AsString);
        MyIniFile.WriteString('SEND','ContCp',Dm_Twinner.Que_ClientFidNatTwin.FieldByName('VIL_CP').AsString);
        MyIniFile.WriteString('SEND','ContVille',Dm_Twinner.Que_ClientFidNatTwin.FieldByName('VIL_NOM').AsString);
        MyIniFile.WriteString('SEND','ContNumMobile',Dm_Twinner.Que_ClientFidNatTwin.FieldByName('ADR_GSM').AsString);
        MyIniFile.WriteString('SEND','ContEmail',Dm_Twinner.Que_ClientFidNatTwin.FieldByName('ADR_EMAIL').AsString);

        strDate := Dm_Twinner.Que_ClientFidNatTwin.FieldByName('CLT_NAISSANCE').AsString; //'19/12/2003' avant;
        if (strDate <> '') and (length(strDate) >= 10) then
        begin
          MyIniFile.WriteString('SEND','Date',copy(strDate, 7, 4) + '-' + copy(strDate, 4, 2) + '-' + copy(strDate, 1, 2)); //'2001-12-19' après;
        end
        else
        begin
          MyIniFile.WriteString('SEND','Date','');
        end;

        MyIniFile.WriteString('SEND','ContPays',Dm_Twinner.Que_ClientFidNatTwin.FieldByName('PAY_NOM').AsString);

        IF boolSuppression then
        begin
          //envoyer l'ancien code à supprimer
          MyIniFile.WriteString('SEND','CodeBarre',ancienCbTwin);
          //signaler qu'il s'agit d'une suppression
          MyIniFile.WriteString('SEND','CodeBarreOLD','-1'); //ancienCbTwin;
        end
        //sinon utiliser le code mémoriser dans la ficher client
        else
        begin
          MyIniFile.WriteString('SEND','CodeBarre',Dm_Twinner.Que_ClientFidNatTwin.FieldByName('CBI_CB').AsString);
          MyIniFile.WriteString('SEND','CodeBarreOLD',ancienCbTwin); //ancienCbTwin;
        END;

        MyIniFile.WriteString('SEND','Labels',creer_labels_web(Dm_Twinner.Que_ClientFidNatTwin.FieldByName('CLT_TELEPHONE').AsString));
        MyIniFile.WriteString('SEND','DocSelect','/SOAP-ENV:Envelope/SOAP-ENV:Body/ns1:retour_add_client');
      finally
        FreeAndNil(MyIniFile);
      end;

      ShellExecute(Handle,'open',PChar(ExtractFilePath(Application.ExeName)+'\SendSoap.exe'),nil,nil,SW_SHOW);

      FermerPatienter;
    finally
      MyIniFile := TIniFile.Create(sFicIni);
      try
        sMsg  := MyIniFile.ReadString('LOG','Msg','');
        sCode := MyIniFile.ReadString('LOG','Code','');
      finally
        FreeAndNil(MyIniFile);
      end;
      if sCode = '0' then
      begin
        reponse := True;
      end
      else
      begin
        MessageDlg(sMsg+#13#10+sCode,mtError,[mbok],0);
      end;

      Dm_Twinner.Que_GUID.close;
      Dm_Twinner.Que_FidNatTwin.Close;
      Dm_Twinner.Que_ClientFidNatTwin.close;
      Free;
    end;
  end;
  result := reponse;
end;

procedure TFrm_FidNatTwin.AlgolStdFrmCreate(Sender: TObject);
begin
  //initialiser la variable id
  clt_id := -1;
  try
    screen.Cursor := crSQLWait;
    Hint := Caption;
//    StdGinkoia.AffecteHintEtBmp(self);
//    UserVisuMags := StdGinkoia.UserVisuMags;
//    UserCanModify := StdGinkoia.UserCanModify('YES_PAR_DEFAUT');
  finally
    screen.Cursor := crDefault;
  end;
end;

procedure TFrm_FidNatTwin.AlgolMainFrmKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    VK_DOWN:
      begin
        if not DBG_ClientsNat.Focused then
        begin
          if DBG_ClientsNat.FocusedNode <> nil then
          begin
            if DBG_ClientsNat.FocusedNode.GetNext <> nil then
            begin
              DBG_ClientsNat.FocusedNode.GetNext.Focused := True;
            end;
          end;
        end;
        Key := 0;
      end;
    VK_UP:
      begin
        // si le grid n'a pas le focus
        if not DBG_ClientsNat.Focused then
        begin
          //si le node qui à le focus existe
          if DBG_ClientsNat.FocusedNode <> nil then
          begin
            //s'il existe un node précédent
            if DBG_ClientsNat.FocusedNode.GetPrev <> nil then
            begin
              //focus sur le précédent
              DBG_ClientsNat.FocusedNode.GetPrev.Focused := True;
            end;
          end;
        end;
        Key := 0;
      end;
    VK_ESCAPE:
      begin
        Nbt_CancelClick(Sender);
        Key := 0;
      end;
    VK_F12:
      begin
        Nbt_PostClick(Sender);
        Key := 0;
      end;
    VK_RETURN:
      begin
        //s'il y a une modification de l'un des champs de recherche alors rechercher
        if (Chp_Nom.Modified or chp_prenom.modified) then
        begin
          //lancer la recherche
          Nbt_RechercherClick(Sender);
          //reinitailiser la valeur de modified
          Chp_Nom.Modified := false;
          chp_prenom.modified := false;
        end
          // sinon tester la présence d'un résultat et ensuite valider
        else
        begin
          if (dbg_clientsNat.FocusedNode <> nil) then
          begin
            Nbt_PostClick(Sender);
          end;
        end;
        Key := 0;
      end;
  end;
end;

procedure TFrm_FidNatTwin.Nbt_PostClick(Sender: TObject);
begin
  Nbt_Rechercher.Visible := False;
  Pan_Edition.Visible := False;
  Pan_Consult.Visible := True;
  //si un champs sélectionné dans le tableau enregistrer dans la base nationale
  if MemD_Clients.FieldByName('RecId').AsInteger <> 0 then
  begin
    add_clientBaseLocale();
  end;
  ModalResult := mrOk;
end;

procedure TFrm_FidNatTwin.Nbt_CancelClick(Sender: TObject);
begin
 //SST 2011 ModalResult := mrCancel;
  Pan_Edition.Visible := False;
  Pan_Consult.Visible := True;
  Nbt_Rechercher.Visible := False;
end;

procedure TFrm_FidNatTwin.Nbt_EditClick(Sender: TObject);
begin
  Pan_Edition.Visible := True;
  Pan_Consult.Visible := False;
  Nbt_Rechercher.Visible := True;
end;

procedure TFrm_FidNatTwin.Pan_BtnEnter(Sender: TObject);
begin
  Nbt_Post.Font.style := [fsBold];
end;

procedure TFrm_FidNatTwin.Pan_BtnExit(Sender: TObject);
begin
  Nbt_Post.Font.style := [];
end;

procedure TFrm_FidNatTwin.Nbt_RechercherClick(Sender: TObject);
begin
//  //vérifier la présence d'un nom et d'un prénom
//  if ((chp_nom.text <> '') and (chp_prenom.text <> '')) then
//  begin
//    // interroger le web service , si recherche infructueuse prévenir l'utilisateur
//    if not get_client_via_nom_prenom(Chp_Nom.text, Chp_Prenom.text, MemD_Clients) then
//    begin
//      InfoMessHP('Aucun client trouvé pour cette recherche', true, 0, 0, '');
//    end;
//  end
//    //si un paramètre manquant prévenir l'utilisateur
//  else
//  begin
//    //message de l'erreur
//    InfoMessHP('Veuillez indiquer un nom et un prénom avant de lancer la recherche', true, 0, 0, '');
//  end;
end;


//lab 15/07/08

function TFrm_FidNatTwin.get_client_via_code_barre(cbClient: string; var MemD_Clients: TdxMemData): integer;
var
  reponse: integer;
  Soap: ISoapOperation;
  PassXML, Document: IXMLCursor;
begin
//  //initialiser la réponse
//  reponse := 0;
//  try
//    ShowMessHPAvi('Consultation de la base nationale Twinner', true, 0, 0, 'Fidélité Twinner');
//
//    //prépation de la requête
//    Soap := TSoapOperation.Create;
//    Soap.url := StdGinKoia.FidNatUrl;
//    Soap.SoapAction := 'get_client_via_code_barreAction';
//    Soap.Message := 'twin:get_client_via_code_barre';
//    Soap.Prepare('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:twin="http://www.twinner-sports.com/webservice/soap/twinner.wsdl"><soapenv:Header/></soapenv:Envelope>');
//    PassXml := Soap.InputMessage.Select('/twin:get_client_via_code_barre');
//    Soap.Values['code_barre'] := cbClient;
//    Soap.execute;
//
//    ShowCloseHP;
//    Document := TXMLCursor.Create;
//    Document.LoadXML(Soap.Response);
//
//    PassXml := Document.select('/SOAP-ENV:Envelope/SOAP-ENV:Body/ns1:TousLesClients/Client');
//    //vérrouiller le rafraichissement du grid pendant le remplissage du memdata
//    DBG_ClientsNat.BeginUpdate;
//    //parcourir tous les clients pour stocker leur infos
//    MemD_Clients.Close;
//    MemD_Clients.Open;
//    //en fonction du nombre de node client
//    case (PassXml.count) of
//      1: //si réponse tenter de récupèrer les valeurs
//        begin
//          if (PassXml.GetValue('existe') = '1') then
//          begin
//            //renseigner le client
//            renseigner_client(PassXml);
//            reponse := 1;
//          end
//          ELSE if (PassXml.GetValue('existe') = '0') then
//          begin
//            reponse :=-2;
//          END;
//        end;
//    else //plusieurs client
//      begin
//        //se placer sur le premier
//        PassXml.First;
//        while not PassXml.EOF do
//        begin
//          if (PassXml.GetValue('existe') = '1') then
//          begin
//            //renseigner le client
//            renseigner_client(PassXml);
//            reponse := 2;
//            //suivant
//            PassXml.Next;
//          end;
//        end;
//      end;
//    end;
//    //déverrouiller le grid
//    DBG_ClientsNat.endupdate;
//  except
//    on e: Exception do
//    begin
//      ShowCloseHP;
//      InfoMessHP('Erreur lors de l''interrogation des données du client sur la base nationale Twinner :'+#13#10+e.message, true, 0, 0, '');
//    end;
//  end;
//  result := reponse;
end;

//lab 15/07/08

function TFrm_FidNatTwin.get_client_via_nom_prenom(nom, prenom: string; var MemD_Clients: TdxMemData): Boolean;
var
  reponse: boolean;
  Soap: ISoapOperation;
  PassXML, Document, XmlLabel: IXMLCursor;
  i: Integer;
begin
//  //initialsier la réponse
//  reponse := false;
//  //intialiser l'indice de parcourt
//  i := 0;
//  //interogation du web service
//  try
//    ShowMessHPAvi('Consultation de la base nationale Twinner', true, 0, 0, 'Fidélité Twinner');
//    //préparation de la requête
//    Soap := TSoapOperation.Create;
//    Soap.url := StdGinKoia.FidNatUrl;
//    Soap.SoapAction := 'get_client_via_code_barreAction';
//    Soap.Message := 'twin:personne_nom_prenom';
//
//    Soap.Prepare('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:twin="http://www.twinner-sports.com/webservice/soap/twinner.wsdl"><soapenv:Header/></soapenv:Envelope>');
//    PassXml := Soap.InputMessage.Select('/twin:personne_nom_prenom');
//    Soap.Values['nom'] := nom;
//    Soap.Values['prenom'] := prenom;
//
//    Soap.execute;
//
//    ShowCloseHP;
//
//    Document := TXMLCursor.Create;
//    Document.LoadXML(Soap.Response);
//
//    PassXml := Document.select('/SOAP-ENV:Envelope/SOAP-ENV:Body/ns1:TousLesClients/Client');
//    //Parcourir tous les clients pour stocker leur infos
//    MemD_Clients.Close;
//    MemD_Clients.Open;
//    //vérrouiller le rafraichissement du grid pendant le remplissage du memdata
//    DBG_ClientsNat.BeginUpdate;
//    //en fonction du nombre de node client
//    case (PassXml.count) of
//      0:
//        begin
//          reponse := false; //aucun client trouvé
//        end;
//      1: //si 1 client existe récupèrer les valeurs
//        begin
//          if (PassXml.GetValue('existe') = '1') then
//          begin
//            //renseigner le client
//            renseigner_client(PassXml);
//            reponse := true;
//          end;
//        end;
//    else //plusieurs client
//      begin
//        //se placer sur le premier
//        PassXml.First;
//        //Parcourir tous les clients pour stocker leur infos
//        while not PassXml.EOF do
//        begin
//          if (PassXml.GetValue('existe') = '1') then
//          begin
//            //renseigner le client
//            XmlLabel := TXMLCursor.Create;
//            XmlLabel.LoadXML(PassXML.XML);
//            renseigner_client(XmlLabel);
//            reponse := true;
//          end;
//          //suivant
//          PassXml.Next;
//        end;
//      end;
//    end;
//    //déverrouiller le grid
//    DBG_ClientsNat.endupdate;
//    //se placer sur le premier pour l'affichage
//    MemD_Clients.First();
//  except
//    on e: Exception do
//    begin
//      ShowCloseHP;
//      InfoMessHP('Erreur lors de l''interrogation des données du client sur la base nationale Twinner :'+#13#10+e.message, true, 0, 0, '');
//    end;
//  end;
//  result := reponse;
end;


function TFrm_FidNatTwin.get_code_qualifiant(qualifiant: string): Integer;
var
  code: Integer; // le code retour
  IbC_CodeQualifiant: TIB_CURSOR;
  requete: string;
begin
  //initialiser le code retour
  code := 0;
  //créer le cursor
  IbC_CodeQualifiant := TIB_CURSOR.Create(nil);
  //préparer la requete
  IbC_CodeQualifiant.sql.clear;
  IbC_CodeQualifiant.sql.Add('select PRM_CODE from genparam join k on (k_id=prm_id and k_enabled=1 and ktb_id=-11111454) where PRM_STRING=:qualifiant');
  try
    IbC_CodeQualifiant.parambyname('qualifiant').asstring := qualifiant;
    IbC_CodeQualifiant.Open;
    //lire la réponse
    code := IbC_CodeQualifiant.Fields[0].AsInteger - NUMQUALIFIANT;
  finally
    IbC_CodeQualifiant.close;
    IbC_CodeQualifiant.free;
  end;
  result := code;
end;

function TFrm_FidNatTwin.get_count_qualifiants(): Integer;
var
  count: Integer; //le code retour
  IbC_CodeQualifiant: TIB_CURSOR;
begin
  //initialiser le code retour
  count := 0;
  //créer le cursor
  IbC_CodeQualifiant := TIB_CURSOR.Create(nil);
  //préparer la requete
  IbC_CodeQualifiant.sql.clear;
  IbC_CodeQualifiant.sql.Add('select count(prm_code) from genparam join k on (k_id=prm_id and k_enabled=1 and ktb_id=-11111454) where prm_code>40000 and prm_code<40033');
  try
    IbC_CodeQualifiant.Open;
    //lire la réponse
    count := IbC_CodeQualifiant.Fields[0].AsInteger;
  finally
    IbC_CodeQualifiant.close;
    IbC_CodeQualifiant.free;
  end;
  result := count;
end;

//formatte la chaîne pour quelle soit lue par le web service visual link

function TFrm_FidNatTwin.creer_labels_web(labels: string): string;
var
  i: integer;
  listeLabels: string;
begin
  i := 1;
  //Parcourir chaque caractère du label et ajouter pour chaque 1 trouvé
  while (i <= length(labels)) do
  begin
    //si qualifiant sélectionné et pas le dernier
    if (labels[i] = '1') then
    begin
      //ajouter avec le séparateur ',' pour visual link...
      listeLabels := listeLabels + ',' + IntToStr(i);
    end;
    inc(i);
  end;
  //supprimer la 1ere virgule
  Delete(listeLabels, 1, 1);
  result := listeLabels;
end;

//formatte la chaine sous la forme de 0 et de 1 pour la stockée dans notre base

function TFrm_FidNatTwin.creer_labels_ginkoia(PassXml: IXMLCursor): string;
var
  labels: string;
  nbCode, position: Integer;
  xmlNode, xmlNode_Labels: IXMLCursor;
  xml: Widestring;
begin
  // par sécurité intialiser NbCode au maxi possible   (labels = varchar32)
  nbCode := 32;
  position := 0;
  //récupèrer le de qualifiants  dans la base
  nbCode := get_count_qualifiants();
  //initialiser le label en fonction du nombre de qualifiants
  while (length(labels) < nbCode) do
  begin
    //ajouter un '0'
    labels := labels + '0';
  end;
  //recopier le node
    //formatter les caractères accentué du fichier xml
  xmlNode := TXMLCursor.Create;
  xmlNode.LoadXML(StringReplace(PassXml.xml, '&amp;eacute;', 'é', [rfReplaceAll]));
  //parcourir le noeud xml et pour chaque nom de label rencontré attribuer la valeur au caractère à la position occupé par le qualifiant
  xmlNode_Labels := xmlNode.select('labels/SOAP-ENC:Struct');
  //se placer sur le premier
  xmlNode_Labels.First;
  while not xmlNode_Labels.EOF do
  begin
    //récupèrer la valeur du code barre et le transformer en position dans le label
    position := get_code_qualifiant(xmlNode_Labels.GetValue('titre'));
    //tester la validité de la position renvoyée
    if position > 0 then
    begin
      //attribuer la valeur '1' à cette position
      labels[position] := '1';
    end;
    //suivant
    xmlNode_Labels.Next;
  end;
  result := labels;
end;

procedure TFrm_FidNatTwin.renseigner_client(PassXml: IXMLCursor);
var
  strDate: string;
  strAdrComplete: string; // l'adresse complete et une portion d'adresse
begin
  try
    //nouvel enregistrement
    MemD_Clients.Append;
    //recopier les infos reçus
    MemD_Clients.FieldByName('Nom').Asstring := PassXml.GetValue('nom');
    MemD_Clients.FieldByName('Prenom').Asstring := PassXml.GetValue('prenom');
    MemD_Clients.FieldByName('Adresse').Asstring := PassXml.GetValue('adresse');
    MemD_Clients.FieldByName('Adr2').Asstring := PassXml.GetValue('adresse2');
    MemD_Clients.FieldByName('Adr3').Asstring := PassXml.GetValue('adresse3');
    MemD_Clients.FieldByName('Cp').Asstring := PassXml.GetValue('code_postal');
    MemD_Clients.FieldByName('VilNom').Asstring := PassXml.GetValue('ville');
    MemD_Clients.FieldByName('Gsm').Asstring := PassXml.GetValue('mobile');
    MemD_Clients.FieldByName('Email').Asstring := PassXml.GetValue('mail');
    //retravailler la date
    strDate := copy(PassXml.getValue('date_naissance'), 1, 10);
    //si date par défaut de twinner
    if (strDate = '0000-00-00') or (length(strDate)<10) then
    begin
      strDate := '30/12/1899';
    end
    else
    begin
      strDate := copy(strDate, 9, 2) + '/' + copy(strDate, 6, 2) + '/' + copy(strDate, 1, 4);
    end;
    MemD_Clients.FieldByName('Naissance').Asstring := strDate;
    MemD_Clients.FieldByName('PayNom').Asstring := PassXml.GetValue('cont_pays');
    MemD_Clients.FieldByName('Cb').Asstring := PassXml.GetValue('code_barre');
    MemD_Clients.FieldByName('Labels').Asstring := creer_labels_ginkoia(PassXml);
    MemD_Clients.post;
  except
    MemD_Clients.close;
  end;
end;

procedure TFrm_FidNatTwin.add_clientBaseLocale();
begin
//
//  //initialiser la variable globale
//  clt_id := -1;
//  try
//
//    //recopier dans la base l'enregistremetn sélectionné
//    IbStProc_Client.Close;
//    IbStProc_Client.Prepared := True;
//    //renseigner les variables
//
//    IbStProc_Client.ParamByName('NOM_CLIENT').asString := MemD_Clients.FieldByName('Nom').Asstring;
//    IbStProc_Client.ParamByName('PRENOM_CLIENT').asString := MemD_Clients.FieldByName('Prenom').Asstring;
//    IbStProc_Client.ParamByName('ADRESSE_CLIENT').asString := stdGinkoia.creerAdresseLigne(MemD_Clients.FieldByName('Adresse').Asstring,MemD_Clients.FieldByName('Adr2').Asstring,MemD_Clients.FieldByName('Adr3').Asstring);
//    IbStProc_Client.ParamByName('CP_CLIENT').asString := MemD_Clients.FieldByName('Cp').Asstring;
//    IbStProc_Client.ParamByName('VILLE_CLIENT').asString := MemD_Clients.FieldByName('VilNom').Asstring;
//    IbStProc_Client.ParamByName('PAYS_CLIENT').asString := MemD_Clients.FieldByName('PayNom').asstring;
//    IbStProc_Client.ParamByName('EMAIL_CLIENT').asString := MemD_Clients.FieldByName('Email').Asstring;
//    IbStProc_Client.ParamByName('GSM_CLIENT').asString := MemD_Clients.FieldByName('Gsm').Asstring;
//    IbStProc_Client.ParamByName('LABEL').asString := MemD_Clients.FieldByName('Labels').Asstring;
//    IbStProc_Client.ParamByName('MAGID').asInteger := StdGinKoia.MagasinID;
//    // tester si appel depuis CaisseGinkoia ou depuis Ginkoia
//    //depuis caisse rechercher l'id du psote pour le type de fidélité, sinon -1
//
//    if (Pos('CaisseGinkoia.exe', Application.ExeName) <> 0) then
//    begin
//      IbStProc_Client.ParamByName('POSID').asInteger := StdGinKoia.PosteID;
//    end
//    else
//    begin
//      IbStProc_Client.ParamByName('POSID').asInteger := -1;
//    end;
//    IbStProc_Client.ParamByName('EAN').asString := MemD_Clients.FieldByName('cb').Asstring;
//    IbStProc_Client.ParamByName('DTNAISSANCE').asdatetime := MemD_Clients.FieldByName('Naissance').asdatetime;
//    IbStProc_Client.ExecProc;
//    //stocker le résultat
//    clt_id := IbStProc_Client.Fields[0].asInteger;
//    if clt_id <> -1 then
//    begin
//      IbStProc_Client.IB_Transaction.commit;
//    end
//    else
//    begin
//      IbStProc_Client.IB_Transaction.Rollback;
//    end;
//    IbStProc_Client.unprepare;
//
//  except
//    on E: exception do
//    begin
//      IbStProc_Client.IB_Transaction.Rollback;
//      IbStProc_Client.unprepare;
//      IbStProc_Client.Close;
//    end;
//  end;
end;

procedure TFrm_FidNatTwin.AlgolStdFrmShow(Sender: TObject);
begin
   Nbt_Rechercher.Visible := False;
   Pan_Edition.Visible := False; // SST 2011
   Pan_Consult.Visible := True;
  //S'il n'y a pas de nom
  if Chp_Nom.Text = '' then
  begin
    Chp_Nom.SetFocus;
  end
    //sinon focus sur le prénom
  else
  begin
    Chp_prenom.SetFocus;
  end;
  //visibilite du panel de choix nom prenom
 { if Pan_NomPrenom.tag = 0 then
  begin
    Pan_NomPrenom.visible := false; // SST 2011 paneau supprimé
  end; }
end;

end.

