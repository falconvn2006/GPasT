unit MSS_CFGBasesLignes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvGlowButton, StdCtrls, RzLabel, ExtCtrls, RzPanel, Mask, RzEdit,
  RzCmboBx, RzBtnEdt, MSS_DMDbMag, DB, DBCtrls, RzDBCmbo, AdvDBLookupComboBox,
  Grids, DBGrids, RzDBEdit, RzDBBnEd, ComCtrls, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinXmas2008Blue,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridLevel, cxClasses, cxGridCustomView, cxGrid, cxTextEdit,
  cxDBLookupComboBox
  //, MSS_Type
  ;

type
  TMode = (mAdd, mEdit);

  Tfrm_CfgBasesLignes = class(TForm)
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    Lab_Ou: TRzLabel;
    Nbt_Cancel: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    OD_DB: TOpenDialog;
    Ds_LstMag: TDataSource;
    Pan_Left: TPanel;
    Pan_Client: TPanel;
    Pan_LeftTop: TPanel;
    Gbx_Informations: TGroupBox;
    Lab_Dossiers: TLabel;
    Lab_BasePath: TLabel;
    edt_BasePath: TRzButtonEdit;
    edt_Dossiers: TEdit;
    Pan_LeftClient: TPanel;
    Pan_ClientTop: TPanel;
    Gbx_Initialisation: TGroupBox;
    Chk_ActiveInit: TCheckBox;
    Lab_Debut: TLabel;
    Lab_Au: TLabel;
    Lab_LivreraPartir: TLabel;
    dtp_Du: TDateTimePicker;
    dtp_Au: TDateTimePicker;
    dtp_Liv: TDateTimePicker;
    AdvGlowButton1: TAdvGlowButton;
    Gbx_Mail: TGroupBox;
    Chk_MailMode: TCheckBox;
    Lab_MailClient: TLabel;
    edt_MailClient: TEdit;
    Ds_LstUsr: TDataSource;
    Gbx_ParamMag: TGroupBox;
    cxg_Magasin: TcxGrid;
    cxg_MagasinDBTableView1: TcxGridDBTableView;
    cxg_MagasinDBTableView1MAG_ID: TcxGridDBColumn;
    cxg_MagasinDBTableView1MAGASIN: TcxGridDBColumn;
    cxg_MagasinDBTableView1VILLE: TcxGridDBColumn;
    cxg_MagasinDBTableView1ADR_EMAIL: TcxGridDBColumn;
    cxg_MagasinDBTableView1Groupe: TcxGridDBColumn;
    cxg_MagasinDBTableView1Numero: TcxGridDBColumn;
    cxg_MagasinDBTableView1USR_ID: TcxGridDBColumn;
    cxg_MagasinDBTableView1USR_NOM: TcxGridDBColumn;
    cxg_MagasinLevel1: TcxGridLevel;
    Gbx_ParamGen: TGroupBox;
    Lab_TVA: TLabel;
    Lab_Garantie: TLabel;
    Lab_TypeComptable: TLabel;
    lku_Garantie: TRzDBLookupComboBox;
    lku_TypeComp: TRzDBLookupComboBox;
    Ds_TVAList: TDataSource;
    Ds_GarantieList: TDataSource;
    Ds_TypeComptableList: TDataSource;
    lku_Tva: TRzDBLookupComboBox;
    Lab_Domaine: TLabel;
    Lab_AxeUnivers: TLabel;
    Lab_AxeFedas: TLabel;
    Gbx_Commentaires: TGroupBox;
    Pan_Coms: TPanel;
    mmComment: TMemo;
    lku_Domaine: TRzDBLookupComboBox;
    lku_AxeUnivers: TRzDBLookupComboBox;
    lku_AxeFedas: TRzDBLookupComboBox;
    Ds_Domaine: TDataSource;
    Ds_AxeUnivers: TDataSource;
    Ds_AxeFedas: TDataSource;
    Lab_Groupe: TLabel;
    edt_Groupe: TEdit;
    procedure edt_BasePathButtonClick(Sender: TObject);
    procedure lku_MagCloseUp(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure cxGrid1DBTableView1USR_NOMPropertiesCloseUp(Sender: TObject);
    procedure Ds_DomaineDataChange(Sender: TObject; Field: TField);
  private
    FMode: TMode;
    FDOSID: Integer;
    FUpdateMainBase : Boolean;
    { Déclarations privées }
  public
    { Déclarations publiques }
    Function ConnectToDb(sBasePath : String) : Boolean;

    Function CheckData : Boolean;

    property Mode : TMode read FMode write FMode;
    property DOS_ID : Integer read FDOSID write FDOSID;
  end;

var
  frm_CfgBasesLignes: Tfrm_CfgBasesLignes;


  function ShowForm(AMode : TMode; ADOS_ID : Integer = 0) : Integer;
implementation

{$R *.dfm}

function ShowForm(AMode : TMode; ADOS_ID : Integer = 0) : Integer;
begin
  frm_CfgBasesLignes := Tfrm_CfgBasesLignes.Create(Nil);
  With frm_CfgBasesLignes do
  try
    Mode := AMode;
    DOS_ID := ADOS_ID;
    dtp_Du.Date := Now;
    dtp_Du.Date := Now;
    dtp_Liv.Date := Now;

    case Mode of
      mAdd: Caption  := 'Ajouter une base';
      mEdit: begin
        Caption := 'Modifier une base';
        With DM_DbMAG,Que_DOSSIERS do
        begin
          If Locate('DOS_ID',ADOS_ID,[]) then
          begin
            edt_Dossiers.Text := FieldByName('DOS_NOM').AsString;
            edt_BasePath.Text := FieldByName('DOS_BASEPATH').AsString;

            If ConnectToDb(edt_BasePath.Text) then
            begin
              Chk_MailMode.Checked := (FieldByName('DOS_MAILMODE').AsInteger = 1);
              if Chk_MailMode.Checked then
                edt_MailClient.Text := FieldByName('DOS_MAILSENDTO').AsString;
              Chk_ActiveInit.Checked := (FieldByName('DOS_PERIODEINIT').AsInteger = 1);
              if Chk_ActiveInit.Checked then
              begin
                dtp_Du.Date := FieldByName('DOS_PERIODEDEBUT').AsDateTime;
                dtp_Au.Date := FieldByName('DOS_PERIODEFIN').AsDateTime;
                dtp_Liv.Date := FieldByName('DOS_PERIODELIVRAISON').AsDateTime;
              end;
            end;

            mmComment.Text := FieldByName('DOS_COMMENT').AsString;
          end;
        end;
      end;
    end;

    Result := -1;
    if ShowModal = mrOk then
      Result := DOS_ID;
  finally
    frm_CfgBasesLignes.Release;
  end;
end;

procedure Tfrm_CfgBasesLignes.AdvGlowButton1Click(Sender: TObject);
begin
  ConnectToDb(edt_BasePath.Text);
//  With DM_DbMAG do
//    if ConnectToDbCheck(edt_BasePath.Text) then
//    begin
//      edt_BasePath.Text := edt_BasePath.Text;
//      Que_LstMag.Close;
//      Que_LstMag.Open;
//      edt_MailClient.Text := '';
//      Que_lstUsr.Close;
//      Que_lstUsr.Open;
//    end;
end;

function Tfrm_CfgBasesLignes.CheckData: Boolean;
begin
  Result := False;
  if Trim(edt_Dossiers.Text) = '' then
  begin  
    ShowMessage('Veuillez saisir un nom de dossier');
    edt_Dossiers.SetFocus;
    Exit;
  end;

  if (Trim(edt_BasePath.Text) = '') {or (not FileExists(edt_BasePath.Text))} then
  begin
    ShowMessage('Veuillez saisir un chemin vers une base de données valide');
    edt_BasePath.SetFocus;
    Exit;
  end;

  With DM_DbMAG do
  begin
//    if Trim(lku_Domaine.Text) = '' then
//    begin
//      Showmessage('Vous devez sélectionner un domaine');
//      Exit;
//    end;

//    if Trim(lku_AxeUnivers.Text) = '' then
//    begin
//      ShowMessage('Vous devez sélectionner un axe univers');
//      Exit;
//    end;

//    if trim(lku_AxeFedas.Text) = '' then
//    begin
//      ShowMessage('Vous devez sélectionner un axe fedas');
//      Exit;
//    end;

//    if cds_AxeUnivers.FieldByName('UNI_ID').AsInteger = cds_AxeFedas.FieldByName('UNI_ID').AsInteger then
//    begin
//      Showmessage('L''axe univers et fedas doivent être différent');
//      Exit;
//    end;
  end;

//   FUpdateMainBase := False;
//   With DM_DbMAG Do
//     if iboDbCheck.Connected then
//     begin
//       sCode := GetGenParamInfo(12,9,Que_LstMag.FieldByName('MAG_ID').AsInteger);//Que_DOSSIERS.FieldByName('DOS_MAGID').AsInteger);
//       sNum  := GetGenParamInfo(12,10,Que_LstMag.FieldByName('MAG_ID').AsInteger); //Que_DOSSIERS.FieldByName('DOS_MAGID').AsInteger);

//       if (sCode <> edt_Groupe.Text) Or
//          (sNum <> edt_Num.Text) Then
//         FUpdateMainBase := (MessageDlg('Le groupe et/ou le numéro ne correspondent pas à celui de la base client, doit on les mettre à jour ?', mtConfirmation,[mbYes,mbNo],0) = mrYes );
//     end;
  Result := True;
end;

function Tfrm_CfgBasesLignes.ConnectToDb(sBasePath: String) : Boolean;
var
  TVA_ID, GAR_ID, TCT_ID : integer;
  ACT_ID, UNI_ID_UNIV, UNI_ID_FEDAS : integer;

begin
  Result := False;
  With DM_DbMAG do
    if ConnectToDbCheck(sBasePath) then
    begin
      edt_BasePath.Text := sBasePath;

      // Paramètres généraux
      TVA_ID := GetGenParamInteger(12,1,0);
      GAR_ID := GetGenParamInteger(12,2,0);
      TCT_ID := GetGenParamInteger(12,3,0);

      Que_ListGarantie.Close;
      Que_ListGarantie.Open;
      if Que_ListGarantie.Locate('GAR_ID',GAR_ID,[]) then
        lku_Garantie.KeyValue := GAR_ID;

      Que_ListTypeComptable.Close;
      Que_ListTypeComptable.Open;
      if Que_ListTypeComptable.Locate('TCT_ID',TCT_ID,[]) then
        lku_TypeComp.KeyValue := TCT_ID;

      Que_ListTVA.Close;
      Que_ListTVA.Open;
      if Que_ListTVA.Locate('TVA_ID',TVA_ID,[]) then
        lku_Tva.KeyValue := TVA_ID;

      ACT_ID := GetGenParamInteger(12,15,0);
      UNI_ID_UNIV := GetGenParamInteger(12,16,0);
      UNI_ID_FEDAS := GetGenParamInteger(12,17,0);

      Que_Domaine.Close;
      Que_Domaine.Open;
      if Que_Domaine.Locate('ACT_ID',ACT_ID,[]) then
      begin
        lku_Domaine.KeyValue := ACT_ID;

        if cds_AxeUnivers.Locate('UNI_ID',UNI_ID_UNIV,[]) then
          lku_AxeUnivers.KeyValue := UNI_ID_UNIV;

        if cds_AxeFedas.Locate('UNI_ID',UNI_ID_FEDAS,[]) then
          lku_AxeFedas.KeyValue := UNI_ID_FEDAS;
      end
      else begin
        lku_AxeUnivers.Enabled := False;
        lku_AxeFedas.Enabled := False;
      end;

      edt_Groupe.Text := GetGenParamInfo(12,18,0);

      // Paramètres magasin
      Que_LstMag.Close;
      Que_LstMag.Open;
      Que_lstUsr.Close;
      Que_lstUsr.Open;

      cds_LstMag.EmptyDataSet;

      while Not Que_LstMag.Eof do
      begin
        With cds_LstMag do
        begin
          Append;
          FieldByName('MAG_ID').AsInteger := Que_LstMag.FieldByName('MAG_ID').AsInteger;
          FieldByName('Magasin').AsString := Que_LstMag.FieldByName('Magasin').AsString;
          FieldByName('Ville').AsString := Que_LstMag.FieldByName('ville').AsString;
          FieldByName('Groupe').AsString := GetGenParamInfo(12,9,Que_LstMag.FieldByName('MAG_ID').AsInteger);
          FieldByName('Numero').AsString := GetGenParamInfo(12,10,Que_LstMag.FieldByName('MAG_ID').AsInteger);
          FieldByName('USR_ID').AsInteger := GetGenParamInteger(12,8,Que_LstMag.FieldByName('MAG_ID').AsInteger);
          if Que_lstUsr.Locate('USR_ID',FieldByName('USR_ID').AsInteger,[]) then
            FieldByName('USR_NOM').AsString := Que_lstUsr.FieldByName('USR_USERNAME').AsString;
          Post;
        end;
        Que_LstMag.Next;
      end;

      Result := True;
    end;
end;

procedure Tfrm_CfgBasesLignes.cxGrid1DBTableView1USR_NOMPropertiesCloseUp(
  Sender: TObject);
begin
  With DM_DbMAG do
  begin
    if not(cds_LstMag.State = dsEdit) then
      cds_LstMag.Edit;
    cds_LstMag.FieldByName('USR_NOM').AsString := Que_lstUsr.FieldByName('USR_USERNAME').AsString;
    cds_LstMag.FieldByName('USR_ID').AsInteger := Que_lstUsr.FieldByName('USR_ID').AsInteger;
    cds_LstMag.Post;
  end;

end;

procedure Tfrm_CfgBasesLignes.Ds_DomaineDataChange(Sender: TObject;
  Field: TField);
begin
  With DM_DbMAG do
  begin
//    Que_LstAxes.Close;
//    Que_LstAxes.ParamCheck := True;
//    Que_LstAxes.ParamByName('PACTID').AsInteger := Ds_Domaine.DataSet.FieldByName('ACT_ID').AsInteger;
//    Que_LstAxes.Open;

    Que_LstAxes.Close;
    Que_LstAxes.SQL.Clear;
    Que_LstAxes.SQL.Add('Select UNI_ID, UNI_NOM from NKLUNIVERS');
    Que_LstAxes.SQL.Add(' join K on K_ID = UNI_ID and K_Enabled = 1');
    Que_LstAxes.SQL.Add('Where UNI_ID <> 0');
    Que_LstAxes.SQL.Add('ORDER BY UNI_NOM');
    Que_LstAxes.Open;

    lku_AxeUnivers.Enabled := Que_LstAxes.RecordCount > 0;
    lku_AxeFedas.Enabled   := Que_LstAxes.RecordCount > 0;

    cds_AxeUnivers.Active := False;
    cds_AxeFedas.Active := False;
    if Que_LstAxes.RecordCount > 0 then
    begin
      cds_AxeUnivers.Active := True;
      cds_AxeFedas.Active := True;
    end;

  end;

end;

procedure Tfrm_CfgBasesLignes.edt_BasePathButtonClick(Sender: TObject);
begin
  With DM_DbMAG do
    if OD_DB.Execute then
    begin
      ConnectToDb(OD_DB.FileName);
//      if ConnectToDbCheck(OD_DB.FileName) then
//      begin
//        edt_BasePath.Text := OD_DB.FileName;
//        Que_LstMag.Close;
//        Que_LstMag.Open;
//        Que_lstUsr.Close;
//        Que_lstUsr.Open;
//
//      end;
    end; // if
end;

procedure Tfrm_CfgBasesLignes.lku_MagCloseUp(Sender: TObject);
begin
  With DM_DbMAG do
  begin
//    edt_Groupe.Text := GetGenParamInfo(12,9,Que_LstMag.FieldByName('MAG_ID').AsInteger);
//    edt_Num.Text    := GetGenParamInfo(12,10,Que_LstMag.FieldByName('MAG_ID').AsInteger);
    edt_MailClient.Text := Que_LstMag.FieldByName('ADR_EMAIL').AsString;
  end;
end;

procedure Tfrm_CfgBasesLignes.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Tfrm_CfgBasesLignes.Nbt_PostClick(Sender: TObject);
var
  PRMID_Groupe,
  PRMID_Num : Integer;
  sCode, sNum : String;
  TVA_ID, GAR_ID, TCT_ID : integer;
  ACT_ID, UNI_ID_UNIV, UNI_ID_FEDAS : integer;
begin
  if CheckData then
    With DM_DbMAG do
    begin
      try
        // Sauvegarde du param général
        TVA_ID       := GetGenParamInteger(12,1,0);
        GAR_ID       := GetGenParamInteger(12,2,0);
        TCT_ID       := GetGenParamInteger(12,3,0);
        ACT_ID       := GetGenParamInteger(12,15,0);
        UNI_ID_UNIV  := GetGenParamInteger(12,16,0);
        UNI_ID_FEDAS := GetGenParamInteger(12,17,0);

        if TVA_ID <> Que_ListTVA.FieldByName('TVA_ID').AsInteger then
          SetGenParamInteger(12,1,0,Que_ListTVA.FieldByName('TVA_ID').AsInteger);

        if GAR_ID <> Que_ListGarantie.FieldByName('GAR_ID').AsInteger then
          SetGenParamInteger(12,2,0,Que_ListGarantie.FieldByName('GAR_ID').AsInteger);

        if TCT_ID <> Que_ListTypeComptable.FieldByName('TCT_ID').AsInteger then
          SetGenParamInteger(12,3,0,Que_ListTypeComptable.FieldByName('TCT_ID').AsInteger);

        If ACT_ID <> Que_Domaine.FieldByName('ACT_ID').AsInteger then
          SetGenParamInteger(12,15,0,Que_Domaine.FieldByName('ACT_ID').AsInteger);

        If UNI_ID_UNIV <> cds_AxeUnivers.FieldByName('UNI_ID').AsInteger then
          SetGenParamInteger(12,16,0,cds_AxeUnivers.FieldByName('UNI_ID').AsInteger);

        if UNI_ID_FEDAS <> cds_AxeFedas.FieldByName('UNI_ID').AsInteger then
          SetGenParamInteger(12,17,0,cds_AxeFedas.FieldByName('UNI_ID').AsInteger);

        if edt_Groupe.Text <> GetGenParamInfo(12,18,0) then
          SetGenParamInfo(12,18,0,edt_Groupe.Text);

        // Sauvegarde et mise à jour du tableau de magasin
        With DM_DbMAG do
          With cds_LstMag do
          begin
            First;
            while Not Eof do
            begin
              sCode := GetGenParamInfo(12,9,FieldByName('MAG_ID').AsInteger);
              sNum  := GetGenParamInfo(12,10,FieldByName('MAG_ID').AsInteger);

              if Trim(sCode) <> Trim(FieldByName('Groupe').AsString)  then
                SetGenParamInfo(12,9,FieldByName('MAG_ID').AsInteger,FieldByName('Groupe').AsString);

              if Trim(sNum) <> Trim(FieldByName('Numero').AsString)  then
                SetGenParamInfo(12,10,FieldByName('MAG_ID').AsInteger,FieldByName('Numero').AsString);

              if FieldByName('USR_ID').AsInteger <> 0 then
                SetGenParamInteger(12,8,FieldByName('MAG_ID').AsInteger,FieldByName('USR_ID').AsInteger);
              Next;
            end;
          end;
      Except on E:Exception do

      end;

      try
        With Que_DbMTmp do
        begin
            IBOTransDbM.StartTransaction;
            Close;
            SQL.Clear;
            case Mode of
              mAdd: begin
                SQL.Add('Insert into DOSSIERS(DOS_NOM, DOS_GROUPE, DOS_NUM,DOS_MAGID, DOS_MAGENSEIGNE,');
                SQL.Add('DOS_BASEPATH, DOS_VILLE, DOS_ACTIF, DOS_DTCREATION, DOS_DTMODIFICATION, DOS_COMMENT,');
                SQL.Add('DOS_PERIODEINIT, DOS_PERIODEDEBUT, DOS_PERIODEFIN, DOS_PERIODELIVRAISON,');
                SQL.Add('DOS_MAILMODE, DOS_MAILSENDTO)');
                SQL.Add('Values(:PDOSNOM, :PDOSGROUPE, :PDOSNUM, :PDOSMAGID, :PDOSMAGENSEIGNE,');
                SQL.Add(' :PDOSBASEPATH, :PDOSVILLE, :PDOSACTIVE, :PDOSDTCREATION, :PDOSDTMODIFICATION, :PDOSCOMMENT,');
                SQL.Add(' :PDOSINIT, :PDOSDEBUT, :PDOSFIN, :PDOSLIVRAISON, :PDOSMAILMODE, :PDOSMAILSENDTO)');
                ParamCheck := True;

//                if (Trim(edt_Groupe.Text) <> '') and (Trim(edt_Num.Text) <> '') then
                  ParamByName('PDOSACTIVE').AsInteger := 1;
//                else
//                  ParamByName('PDOSACTIVE').AsInteger := 0;

                ParamByName('PDOSDTCREATION').AsDateTime := Now;
              end;
              mEdit: begin
                SQL.Add('Update DOSSIERS Set');
                SQL.Add(' DOS_NOM = :PDOSNOM, DOS_GROUPE = :PDOSGROUPE, DOS_NUM = :PDOSNUM,');
                SQL.Add(' DOS_MAGID = :PDOSMAGID, DOS_MAGENSEIGNE = :PDOSMAGENSEIGNE,');
                SQL.Add(' DOS_BASEPATH =:PDOSBASEPATH, DOS_VILLE = :PDOSVILLE,');
                SQL.Add(' DOS_DTMODIFICATION = :PDOSDTMODIFICATION, DOS_COMMENT = :PDOSCOMMENT,');
                SQL.Add(' DOS_PERIODEINIT = :PDOSINIT, DOS_PERIODEDEBUT = :PDOSDEBUT,');
                SQL.Add(' DOS_PERIODEFIN = :PDOSFIN, DOS_PERIODELIVRAISON = :PDOSLIVRAISON,');
                SQL.Add(' DOS_MAILMODE = :PDOSMAILMODE, DOS_MAILSENDTO = :PDOSMAILSENDTO');
                SQL.ADD('Where DOS_ID = :PDOSID');
                ParamCheck                      := True;
                ParamByName('PDOSID').AsInteger := FDOSID;
              end;
            end; // case
            ParamByName('PDOSNOM').AsString              := edt_Dossiers.Text;
            ParamByName('PDOSGROUPE').AsString           := edt_Groupe.Text;
//            ParamByName('PDOSNUM').AsString              := edt_Num.Text;
//            ParamByName('PDOSMAGID').AsInteger           := Que_LstMag.FieldByName('MAG_ID').AsInteger;
//            ParamByName('PDOSMAGENSEIGNE').AsString      := Que_LstMag.FieldByName('Magasin').AsString;
            ParamByName('PDOSBASEPATH').AsString         := edt_BasePath.Text;
//            ParamByName('PDOSVILLE').AsString            := Que_LstMag.FieldByName('Ville').AsString;
            ParamByName('PDOSDTMODIFICATION').AsDateTime := Now;
            ParamByName('PDOSCOMMENT').AsString          := mmComment.Text;
            if Chk_ActiveInit.Checked then
            begin
              ParamByName('PDOSINIT').AsInteger   := 1;
              ParamByName('PDOSDEBUT').AsDate     := dtp_Du.Date;
              ParamByName('PDOSFIN').AsDate       := dtp_Au.Date;
              ParamByName('PDOSLIVRAISON').AsDate := dtp_Liv.Date;
            end
            else begin
              ParamByName('PDOSINIT').AsInteger := 0;
              ParamByName('PDOSDEBUT').Clear;
              ParamByName('PDOSFIN').Clear;
              ParamByName('PDOSLIVRAISON').Clear;
            end;

            if Chk_MailMode.Checked then
            begin
             ParamByName('PDOSMAILMODE').AsInteger := 1;
             ParamByName('PDOSMAILSENDTO').AsString := edt_MailClient.Text;
            end
            else begin
             ParamByName('PDOSMAILMODE').AsInteger := 0;
             ParamByName('PDOSMAILSENDTO').Clear;
            end;

            ExecSQL;

            IBOTransDbM.Commit;

            if FDOSID = 0 then
            begin
              Close;
              SQL.Clear;
              SQL.Add('Select Max(DOS_ID) as Resultat from DOSSIERS');
              Open;

              FDOSID := FieldByName('Resultat').AsInteger;
            end;
        end; // with

//        If FUpdateMainBase then
//          With que_Tmp do
//          begin
//            // récupération des ID des paramètres
//            Close;
//            SQL.Clear;
//            SQL.Add('Select PRM_ID, PRM_CODE, PRM_TYPE from GenParam');
//            SQL.Add('  join K on K_ID = PRM_ID and K_Enabled = 1');
//            SQL.Add('Where PRM_TYPE = 12 and PRM_CODE in (9,10)');
//            SQL.Add('  and PRM_MAGID = :PMAGID');
//            ParamCheck := True;
//            ParamByName('PMAGID').AsInteger := Que_LstMag.FieldByName('MAG_ID').AsInteger;
//            Open;
//
//            if Que_Tmp.Locate('PRM_TYPE;PRM_CODE',VarArrayOf([12,9]),[]) then
//              PRMID_Groupe := Que_Tmp.FieldByName('PRM_ID').AsInteger
//            else
//              PRMID_Groupe := -1;
//
//            if Que_Tmp.Locate('PRM_TYPE;PRM_CODE',VarArrayOf([12,10]),[]) then
//              PRMID_Num := Que_Tmp.FieldByName('PRM_ID').AsInteger
//            else
//              PRMID_Num := -1;
//
//            // Mise à jour des paramètres
//            Close;
//            SQL.Clear;
//            SQL.Add('Update GENPARAM Set');
//            SQL.Add('  PRM_INFO = :PPRMINFO');
//            SQL.Add('Where PRM_ID = :PPRMID');
//            ParamCheck := True;
//
//            if PRMID_Groupe <> -1 then
//            begin
//              ParamByName('PPRMINFO').AsString := edt_Groupe.Text;
//              ParamByName('PPRMID').AsInteger := PRMID_Groupe;
//              ExecSQL;
//            end;
//
//            if PRMID_Num <> -1 then
//            begin
//              ParamByName('PPRMINFO').AsString := edt_Num.Text;
//              ParamByName('PPRMID').AsInteger := PRMID_Num;
//              ExecSQL;
//            end;
//
//            Close;
//            SQL.Clear;
//            SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,0)');
//            ParamCheck := True;
//
//            if PRMID_Groupe <> -1 then
//            begin
//              ParamByName('ID').AsInteger := PRMID_Groupe;
//              ExecSQL;
//            end;
//
//            if PRMID_Num <> -1 then
//            begin
//              ParamByName('ID').AsInteger := PRMID_Num;
//              ExecSQL;
//            end;
//          end;

        ModalResult := mrOk;
      Except on E:Exception do
        begin
          IBOTransDbM.Rollback;
          ShowMessage('Erreur : ' + E.Message);
        end;
      end; // try/except
    end; // with

end;

end.
