//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT ClientAdrMaj_Frm;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  // up
  UCommon_Dm,
  // fup
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
  LMDFormShadow,
  StdCtrls,
  RzLabel,
  Db,
  IBODataset, IB_Components;

TYPE TUnClient = RECORD
    sNom, sPrenom: STRING;
    sAdrLig, sVilNom, sVilCP, sPayNom: STRING;
    sAdrTel, sAdrFax, sAdrGsm, sAdrEMail, sAdrComment: STRING;
    iCltID: integer;
  END;

TYPE
  TFrm_ClientAdrMaj = CLASS(TAlgolStdFrm)
    IbC_MajAdr: TIB_Cursor;
    Que_GetClientAdr: TIBOQuery;
    Que_MajClient: TIBOQuery;
  private
    UserCanModify, UserVisuMags: Boolean;
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published

  END;

FUNCTION AdrCliVersStructure(ACltID: integer; AAdrLig, AVilNom, AVilCP, APayNom: STRING; AAdrTel: STRING = ''; AAdrFax: STRING = ''; AAdrGsm: STRING = ''; AAdrEMail: STRING = ''; AAdrComment: STRING = ''): TUnClient;
FUNCTION IsIdem(Clt1, Clt2: TUnClient): boolean;
FUNCTION MajClient(Clt, CltSav: TUnClient; TypeDoc: integer): boolean;

IMPLEMENTATION
{$R *.DFM}

USES UCommon;

FUNCTION AdrCliVersStructure(ACltID: integer; AAdrLig, AVilNom, AVilCP, APayNom: STRING; AAdrTel: STRING = ''; AAdrFax: STRING = ''; AAdrGsm: STRING = ''; AAdrEMail: STRING = ''; AAdrComment: STRING = ''): TUnClient;
VAR
  MyRes: TUnClient;
BEGIN
  MyRes.sAdrLig := AAdrLig;
  MyRes.sVilNom := AVilNom;
  MyRes.sVilCP := AVilCP;
  MyRes.sPayNom := APayNom;
  MyRes.sAdrTel := AAdrTel;
  MyRes.sAdrFax := AAdrFax;
  MyRes.sAdrGsm := AAdrGsm;
  MyRes.sAdrEMail := AAdrEMail;
  MyRes.sAdrComment := AAdrComment;

  MyRes.iCltID := ACltID;
  Result := MyRes;
END;



FUNCTION IsIdem(Clt1, Clt2: TUnClient): boolean;
BEGIN
  Result := (Clt1.sAdrLig = Clt2.sAdrLig) AND (Clt1.sVilNom = Clt2.sVilNom) AND (Clt1.sVilCP = Clt2.sVilCP) AND (Clt1.sPayNom = Clt2.sPayNom);
END;

FUNCTION MajClient(Clt, CltSav: TUnClient; TypeDoc: integer): boolean;
VAR
  Frm_ClientAdrMaj: TFrm_ClientAdrMaj;
  sLibDoc: STRING;
  sLibAdr: STRING;
  LeFieldAdrId: STRING;
  iAdrId: Integer;
BEGIN
  Result := False;

  // Rien à faire dans ce cas
  IF IsIdem(Clt, CltSav) THEN EXIT;

  Application.createform(TFrm_ClientAdrMaj, Frm_ClientAdrMaj);
  WITH Frm_ClientAdrMaj DO
  BEGIN
    TRY
      Que_GetClientAdr.Close;
      Que_GetClientAdr.ParamByName('CLTID').AsInteger := Clt.iCltID;
      Que_GetClientAdr.Open;

      CASE TypeDoc OF
        1: // Adr Livraison
          BEGIN
            LeFieldAdrId := 'CLT_ADRID';
          END;
        2: // Adr Facturation
          BEGIN
            LeFieldAdrId := 'CLT_AFADRID';
          END;
      END;
      // On met à jour le client
      TRY
//        IbC_MajAdr.Ib_Transaction.StartTransaction;
        IbC_MajAdr.Close;
        IbC_MajAdr.ParamByName('ID').AsInteger := Que_GetClientAdr.FieldByName(LeFieldAdrId).AsInteger;
        IbC_MajAdr.ParamByName('ADR_LIGNE').AsString := Clt.sAdrLig;
        IbC_MajAdr.ParamByName('VIL_NOM').AsString := Clt.sVilNom;
        IbC_MajAdr.ParamByName('VIL_CP').AsString := Clt.sVilCP;
        IbC_MajAdr.ParamByName('PAY_NOM').AsString := Clt.sPayNom;
        IbC_MajAdr.ParamByName('ADR_TEL').AsString := Clt.sAdrTel;
        IbC_MajAdr.ParamByName('ADR_FAX').AsString := Clt.sAdrFax;
        IbC_MajAdr.ParamByName('ADR_GSM').AsString := Clt.sAdrGSM;
        IbC_MajAdr.ParamByName('ADR_EMAIL').AsString := Clt.sAdrEmail;
        IbC_MajAdr.ParamByName('ADR_COMMENT').AsString := Clt.sAdrComment;
        IbC_MajAdr.Open;


        IF NOT IbC_MajAdr.Eof THEN
        BEGIN
          iAdrId := IbC_MajAdr.Fields[0].AsInteger;
          IF Que_GetClientAdr.FieldByName(LeFieldAdrId).AsInteger <> iAdrId THEN
          BEGIN
            Que_MajClient.SQL.Text := 'UPDATE CLTCLIENT SET ' + LeFieldAdrId + ' = ' + IntToStr(iAdrId) + ' WHERE CLT_ID = ' + IntToStr(Clt.iCltID);
            Que_MajClient.ExecSQL;
          END;
//          IbC_MajAdr.Ib_Transaction.Commit;
        END;
      EXCEPT
        ON E: Exception DO
        BEGIN
          LogAction(E.Message,4);
//        IbC_MajAdr.Ib_Transaction.Rollback;
        END;
      END;

      Result := True;
    FINALLY
      Free;
    END;
  END;
END;

END.

