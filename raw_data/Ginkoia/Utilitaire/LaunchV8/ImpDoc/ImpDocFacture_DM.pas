unit ImpDocFacture_DM;

interface

uses
  SysUtils, Classes, EuGen, Main_DM, ConvertorRv, GinkoiaResStr, DB, IBODataset,
  Registry, StdUtils, windows, ImpDoc_Types, uLogs, RapRv_frm, StdDateUtils,
  vgStndrt;

type
  TDM_ImpDocFacture = class(TDataModule)
    Convertor: TConvertorRv;
    Que_ROFacTmp: TIBOQuery;
    Que_TetImp: TIBOQuery;
    Que_TetImpTTCEURO: TFloatField;
    Que_TetImpDateRglt: TDateTimeField;
    Que_TetImpFCE_ID: TIntegerField;
    Que_TetImpFCE_MAGID: TIntegerField;
    Que_TetImpFCE_CLTID: TIntegerField;
    Que_TetImpFCE_NUMERO: TStringField;
    Que_TetImpFCE_DATE: TDateTimeField;
    Que_TetImpFCE_PRENEUR: TStringField;
    Que_TetImpFCE_REMISE: TIBOFloatField;
    Que_TetImpFCE_DETAXE: TIntegerField;
    Que_TetImpFCE_TVAHT1: TIBOFloatField;
    Que_TetImpFCE_TVATAUX1: TIBOFloatField;
    Que_TetImpFCE_TVA1: TIBOFloatField;
    Que_TetImpFCE_TVAHT2: TIBOFloatField;
    Que_TetImpFCE_TVATAUX2: TIBOFloatField;
    Que_TetImpFCE_TVA2: TIBOFloatField;
    Que_TetImpFCE_TVAHT3: TIBOFloatField;
    Que_TetImpFCE_TVATAUX3: TIBOFloatField;
    Que_TetImpFCE_TVA3: TIBOFloatField;
    Que_TetImpFCE_TVAHT4: TIBOFloatField;
    Que_TetImpFCE_TVATAUX4: TIBOFloatField;
    Que_TetImpFCE_TVA4: TIBOFloatField;
    Que_TetImpFCE_TVAHT5: TIBOFloatField;
    Que_TetImpFCE_TVATAUX5: TIBOFloatField;
    Que_TetImpFCE_TVA5: TIBOFloatField;
    Que_TetImpFCE_CLOTURE: TIntegerField;
    Que_TetImpFCE_ARCHIVE: TIntegerField;
    Que_TetImpFCE_USRID: TIntegerField;
    Que_TetImpFCE_TYPID: TIntegerField;
    Que_TetImpFCE_CLTNOM: TStringField;
    Que_TetImpFCE_CLTPRENOM: TStringField;
    Que_TetImpFCE_CIVID: TIntegerField;
    Que_TetImpFCE_VILID: TIntegerField;
    Que_TetImpFCE_ADRLIGNE: TMemoField;
    Que_TetImpFCE_MRGID: TIntegerField;
    Que_TetImpFCE_CPAID: TIntegerField;
    Que_TetImpFCE_NMODIF: TIntegerField;
    Que_TetImpFCE_COMENT: TMemoField;
    Que_TetImpFCE_MARGE: TIBOFloatField;
    Que_TetImpFCE_PRO: TIntegerField;
    Que_TetImpFCE_REGLEMENT: TDateTimeField;
    Que_TetImpFCE_FACTOR: TIntegerField;
    Que_TetImpFCE_MODELE: TIntegerField;
    Que_TetImpFCE_HTWORK: TIntegerField;
    Que_TetImpCPA_NOM: TStringField;
    Que_TetImpCPA_CODE: TIntegerField;
    Que_TetImpMRG_LIB: TStringField;
    Que_TetImpCIV_NOM: TStringField;
    Que_TetImpCLTVILLE: TStringField;
    Que_TetImpCLTCP: TStringField;
    Que_TetImpCLTPAYS: TStringField;
    Que_TetImpMAGVILLE: TStringField;
    Que_TetImpMAGCP: TStringField;
    Que_TetImpMAGPAYS: TStringField;
    Que_TetImpCLT_NUMERO: TStringField;
    Que_TetImpSOC_NOM: TStringField;
    Que_TetImpCLT_NUMFACTOR: TStringField;
    Que_TetImpCLTADR: TMemoField;
    Que_TetImpMAGADR: TMemoField;
    Que_TetImpUSR_USERNAME: TStringField;
    Que_TetImpUSR_FULLNAME: TStringField;
    Que_TetImpCLIENT: TStringField;
    Que_TetImpTOTTTC: TIBOFloatField;
    Que_TetImpTOTTVA: TIBOFloatField;
    Que_TetImpHT1: TIBOFloatField;
    Que_TetImpHT2: TIBOFloatField;
    Que_TetImpHT3: TIBOFloatField;
    Que_TetImpHT4: TIBOFloatField;
    Que_TetImpHT5: TIBOFloatField;
    Que_TetImpTOTHT: TIBOFloatField;
    Que_TetImpCLT_CODETVA: TStringField;
    Que_TetImpSUMTTC: TFloatField;
    Que_TetImpMAG_ENSEIGNE: TStringField;
    Que_TetImpFCE_CATEG: TIntegerField;
    Que_TetImpFCE_WEB: TIntegerField;
    Que_TetImpTYP_COD: TIntegerField;
    Que_TetImpMAG_CODEADH: TStringField;
    Que_TetImpUSR_TEL: TStringField;
    Que_TetImpUSR_FAX: TStringField;
    Que_TetImpUSR_GSM: TStringField;
    Que_TetImpUSR_EMAIL: TStringField;
    Que_TetImpFCE_SUIVI: TStringField;
    Que_TetImpFCE_URLSUIVI: TStringField;
    Que_TetImpFCE_CLTIDPRO: TIntegerField;
    Que_TetImpFCE_IMAID: TIntegerField;
    Que_TetImpFCE_IDWEB: TIntegerField;
    Que_TetImpFCE_DVEID: TIntegerField;
    Que_TetImpFCE_BLLID: TIntegerField;
    Que_TetImpFCE_CODESITEWEB: TIntegerField;
    Que_TetImpFCE_NUMCDE: TStringField;
    Que_TetImpFCE_REGLER: TIntegerField;
    Que_TetImpFCE_DTREGLER: TDateTimeField;
    Que_TetImpFCE_FILID: TIntegerField;
    Que_TetImpFIL_COMMENT1: TMemoField;
    Que_TetImpFIL_COMMENT2: TMemoField;
    Que_TetImpFIL_ID: TIntegerField;
    Que_LineImp: TIBOQuery;
    Que_LineImpART_REFMRK: TStringField;
    Que_LineImpART_ORIGINE: TIntegerField;
    Que_LineImpARF_CHRONO: TStringField;
    Que_LineImpARF_DIMENSION: TIntegerField;
    Que_LineImpTGF_NOM: TStringField;
    Que_LineImpCOU_NOM: TStringField;
    Que_LineImpPUMP: TIBOFloatField;
    Que_LineImpFCL_ID: TIntegerField;
    Que_LineImpFCL_FCEID: TIntegerField;
    Que_LineImpFCL_ARTID: TIntegerField;
    Que_LineImpFCL_TGFID: TIntegerField;
    Que_LineImpFCL_COUID: TIntegerField;
    Que_LineImpFCL_NOM: TStringField;
    Que_LineImpFCL_USRID: TIntegerField;
    Que_LineImpFCL_QTE: TIBOFloatField;
    Que_LineImpFCL_PXBRUT: TIBOFloatField;
    Que_LineImpFCL_PXNET: TIBOFloatField;
    Que_LineImpFCL_PXNN: TIBOFloatField;
    Que_LineImpFCL_SSTOTAL: TIntegerField;
    Que_LineImpFCL_INSSTOTAL: TIntegerField;
    Que_LineImpFCL_GPSSTOTAL: TIntegerField;
    Que_LineImpFCL_TVA: TIBOFloatField;
    Que_LineImpFCL_COMENT: TStringField;
    Que_LineImpFCL_BLLID: TIntegerField;
    Que_LineImpFCL_TYPID: TIntegerField;
    Que_LineImpFCL_LINETIP: TIntegerField;
    Que_LineImpFCL_FROMBLL: TIntegerField;
    Que_LineImpFCL_DATEBLL: TDateTimeField;
    Que_LineImpARF_VIRTUEL: TIntegerField;
    Que_LineImpARF_VTFRAC: TIntegerField;
    Que_LineImpARF_SERVICE: TIntegerField;
    Que_LineImpARF_COEFT: TIBOFloatField;
    Que_LineImpUSR_USERNAME: TStringField;
    Que_LineImpNEOLINE: TIntegerField;
    Que_LineImpFCL_VALREMGLO: TIBOFloatField;
    Que_LineImpPXSBR: TIBOBCDField;
    Que_LineImpPXSAR: TIBOBCDField;
    Que_LineImpMTLINE: TIBOBCDField;
    Que_LineImpMARGE: TIBOBCDField;
    Que_LineImpREMISE: TIBOBCDField;
    Que_LineImpMRK_NOM: TStringField;
    Que_LineImpCBTO: TStringField;
    Que_LineImpPXSBRHT: TIBOFloatField;
    Que_LineImpPXSARHT: TIBOFloatField;
    Que_Mags: TIBOQuery;
    IbQ_Univers: TIBOQuery;
    IbQ_UniversUNI_NOM: TStringField;
    IbQ_UniversUNI_NIVEAU: TIntegerField;
    IbQ_UniversUNI_ORIGINE: TIntegerField;
    IbQ_UniversUNI_ID: TIntegerField;
    IbQ_UniversUNI_IDREF: TIntegerField;
    ConvertorEtik: TConvertorRv;
    Que_LineImpFCL_LOTID: TIntegerField;
    Que_LineImpFCL_TYPELOT: TIntegerField;
    Que_LineImpFCL_NUMLOT: TIntegerField;
    Que_LineImpART_FUSARTID: TIntegerField;
    CurSto_Main: TCurrencyStorage;
    procedure Que_TetImpCalcFields(DataSet: TDataSet);
    procedure Que_LineImpREMISEGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure Que_TetImpTOTTTCGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Déclarations privées }
    TxtFinFact, TxtFactor, TxtRgltDef: STRING;
    LabFactor: STRING;
    HTPied: extended;
    ImpCdv, ImpTailCoul, ImpTVA, ImpLine, ImpVend, ImpRem, ImpCivClt, ImpPayClt,
    ImpPayMag, ImpEuro, ImpTextePied, ImpPg, ImpTete, ImpPied: Boolean;


    FUNCTION SetParamImp(AMAGID : Integer): Boolean;
    FUNCTION GetISO(Mny: TMYTYP): STRING;
    function GetOrigine : Integer;
    function GetTypeFac(ATyp : Integer) : TTypFac;
    PROCEDURE ChpDateRgltCODE(DateDoc: TDateTime; CPACode: Integer; VAR Chp: TDateTimeField);
    FUNCTION DateRgltCODE(DateDoc: TDateTime; CPACode: Integer): TDateTime;
    PROCEDURE InitConvertor;
    FUNCTION GetStringParamValue(ParamName: STRING): STRING;



    function GetGenParamStr(ATYPE, ACODE : Integer; AMAGID : Integer = 0; APOSID : Integer = 0) : String;overload;
    function GetGenParamInt(ATYPE, ACODE : Integer; AMAGID : Integer = 0; APOSID : Integer = 0) : Integer;overload;
    function GetGenParamFloat(ATYPE, ACODE : Integer; AMAGID : Integer = 0; APOSID : Integer = 0) : Single;overload;
  public
    { Déclarations publiques }
    FUNCTION ImprimeFactureKour(IdFac: Integer; APDFDir : String): Boolean;
  end;

var
  DM_ImpDocFacture: TDM_ImpDocFacture;

implementation

{$R *.dfm}

{ TDM_ImpDocFacture }

function TDM_ImpDocFacture.GetGenParamStr(ATYPE, ACODE, AMAGID,
  APOSID: Integer): String;
begin
  With Que_ROFacTmp do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select PRM_STRING from GENPARAM');
    SQL.Add('  join K on K_ID = PRM_ID and K_Enabled = 1');
    SQL.Add('Where PRM_TYPE = :PTYPE');
    SQL.Add('  and PRM_CODE = :PCODE');
    if AMAGID <> 0 then
      SQL.Add('  and PRM_MAGID = :PMAGID');
    if APOSID <> 0 then
      SQL.Add('  and PRM_POSID = :PPOSID');
    ParamCheck := True;
    ParamByName('PTYPE').AsInteger := ATYPE;
    ParamByName('PCODE').AsInteger := ACODE;
    if AMAGID <> 0 then
      ParamByName('PMAGID').AsInteger := AMAGID;
    if APOSID <> 0 then
      ParamByName('PPOSID').AsInteger := APOSID;
    Open;

    Result := FieldByName('PRM_STRING').AsString;
  except on E: Exception do
    raise Exception.Create('GetGenParam Str -> ' + E.Message);
  end;

end;

function TDM_ImpDocFacture.GetGenParamInt(ATYPE, ACODE, AMAGID,
  APOSID: Integer): Integer;
begin
  With Que_ROFacTmp do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select PRM_INTEGER from GENPARAM');
    SQL.Add('  join K on K_ID = PRM_ID and K_Enabled = 1');
    SQL.Add('Where PRM_TYPE = :PTYPE');
    SQL.Add('  and PRM_CODE = :PCODE');
    if AMAGID <> 0 then
      SQL.Add('  and PRM_MAGID = :PMAGID');
    if APOSID <> 0 then
      SQL.Add('  and PRM_POSID = :PPOSID');
    ParamCheck := True;
    ParamByName('PTYPE').AsInteger := ATYPE;
    ParamByName('PCODE').AsInteger := ACODE;
    if AMAGID <> 0 then
      ParamByName('PMAGID').AsInteger := AMAGID;
    if APOSID <> 0 then
      ParamByName('PPOSID').AsInteger := APOSID;
    Open;

    Result := FieldByName('PRM_INTEGER').AsInteger;

  except on E: Exception do
    raise Exception.Create('GetGenParam Int -> ' + E.Message);
  end;
end;

procedure TDM_ImpDocFacture.ChpDateRgltCODE(DateDoc: TDateTime;
  CPACode: Integer; var Chp: TDateTimeField);
VAR
  T: TDateTime;
BEGIN
  T := DateRgltCODE(DateDoc, CPACode);
  IF T = 0 THEN
    chp.Clear
  ELSE
    chp.asDateTime := T;
end;

function TDM_ImpDocFacture.DateRgltCODE(DateDoc: TDateTime;
  CPACode: Integer): TDateTime;
begin
  Result := 0;
  IF DateDoc = 0 THEN DateDoc := Date;
  CASE CPACode OF
    2: Result := DateDoc + 3;
    3: Result := AddDays(DateDoc, 30);
    15: Result := AddDays(DateDoc, 45);
    4: Result := AddDays(DateDoc, 60);
    5: Result := AddDays(DateDoc, 90);
    6: Result := AddDays(DateDoc, 120);

    7: Result := LastDayOfMonth(AddDays(DateDoc, 30));
    16: Result := LastDayOfMonth(AddDays(DateDoc, 45));
    8: Result := LastDayOfMonth(AddDays(DateDoc, 60));
    9: Result := LastDayOfMonth(AddDays(DateDoc, 90));
    10: Result := LastDayOfMonth(AddDays(DateDoc, 120));

    11: Result := AddDays(LastDayOfMonth(AddDays(DateDoc, 30)), 10);
    17: Result := AddDays(LastDayOfMonth(AddDays(DateDoc, 45)), 10);
    12: Result := AddDays(LastDayOfMonth(AddDays(DateDoc, 60)), 10);
    13: Result := AddDays(LastDayOfMonth(AddDays(DateDoc, 90)), 10);
    14: Result := AddDays(LastDayOfMonth(AddDays(DateDoc, 120)), 10);

  END;
end;

function TDM_ImpDocFacture.GetGenParamFloat(ATYPE, ACODE, AMAGID,
  APOSID: Integer): Single;
begin
  With Que_ROFacTmp do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select PRM_FLOAT from GENPARAM');
    SQL.Add('  join K on K_ID = PRM_ID and K_Enabled = 1');
    SQL.Add('Where PRM_TYPE = :PTYPE');
    SQL.Add('  and PRM_CODE = :PCODE');
    if AMAGID <> 0 then
      SQL.Add('  and PRM_MAGID = :PMAGID');
    if APOSID <> 0 then
      SQL.Add('  and PRM_POSID = :PPOSID');
    ParamCheck := True;
    ParamByName('PTYPE').AsInteger := ATYPE;
    ParamByName('PCODE').AsInteger := ACODE;
    if AMAGID <> 0 then
      ParamByName('PMAGID').AsInteger := AMAGID;
    if APOSID <> 0 then
      ParamByName('PPOSID').AsInteger := APOSID;
    Open;

    Result := FieldByName('PRM_FLOAT').AsFloat;

  except on E: Exception do
    raise Exception.Create('GetGenParam Sing -> ' + E.Message);
  end;

end;

function TDM_ImpDocFacture.GetISO(Mny: TMYTYP): STRING;
begin
  Result := Convertor.GetISO(Mny);
end;


function TDM_ImpDocFacture.GetOrigine: Integer;
begin
  With Que_ROFacTmp do
  Try
    Close;
    SQL.Clear;
    SQL.Add('SELECT NKLUNIVERS.* FROM NKLUNIVERS');
    SQL.Add('JOIN K ON (K_ID=UNI_ID AND K_ENABLED=1)');
    SQL.Add('where UNI_ID<>0');
    Open;

    Result := FieldByName('UNI_ORIGINE').AsInteger;
  Except on E:eXception do
    raise Exception.Create('GetOrigine -> ' + E.Message);
  end;
end;

function TDM_ImpDocFacture.GetStringParamValue(ParamName: STRING): STRING;
begin
  With Que_ROFacTmp do
  begin
    Close;
    SQL.clear;
    SQL.Add('SELECT GENDOSSIER.* FROM GENDOSSIER');
    SQL.Add('  JOIN K ON (K_ID=DOS_ID AND K_ENABLED=1)');
    SQL.Add('WHERE DOS_NOM=:PARAM_NAME');
    ParamCheck := true;
    ParamByName('PARAM_NAME').AsString := ParamName;
    Open;

    Result := FieldByName('DOS_STRING').AsString;
  end;
end;

function TDM_ImpDocFacture.GetTypeFac(ATyp: Integer): TTypFac;
begin
  With Que_ROFacTmp do
  Try
    Close;
    SQL.Clear;
    SQL.Add('SELECT TYP_ID, TYP_LIB FROM GENTYPCDV');
    SQL.Add('  JOIN K ON (K_ID=TYP_ID AND K_ENABLED=1)');
    SQL.Add('WHERE TYP_COD=:LETIP');
    ParamCheck := True;
    ParamByName('LETIP').AsInteger := ATyp;
    Open;

    Result.Id  := FieldbyName('TYP_ID').AsInteger;
    Result.Lib := FieldByName('TYP_LIB').AsString;

  Except on E:eXception do
    raise Exception.Create('GetTypeFac -> ' + E.Message);
  end;
end;

function TDM_ImpDocFacture.ImprimeFactureKour(IdFac: Integer; APDFDir : String): Boolean;
VAR
  i: Integer;
  isPro: Boolean;
  Reg: TRegistry;
  Nom, NomPdf, FactRtm: STRING;
  sNomExportPdf: string;
  sFactureOuAvoir: string;  // libellé suivant que c'est un avoir ou une facture
BEGIN
  Result := False;
  IF IDFac <= 0 THEN Exit;

  InitConvertor;

  IF GetIso(Convertor.MnyRef) <> GetIso(Convertor.DefaultMnyRef) THEN
    raise Exception.Create(NoNegEuro)
  ELSE BEGIN

    TRY
      que_TetImp.Close;
      que_TetImp.paramByName('FCEID').asInteger := IdFac;
      que_tetImp.Open;
      IsPro := que_TetImpFCE_PRO.asInteger = 1;

      // Facture ou avoir
      if Que_TetImp.Fieldbyname('TOTTTC').AsFloat<0 then
      begin
        sFactureOuAvoir := 'Avoir';
        sNomExportPdf := FormatDateTime('yyyy-mm-dd', Date)+
                         '_'+sFactureOuAvoir+'_'+
                         que_TetImp.fieldByName('FCE_NUMERO').asString+'-A.pdf';
      end
      else
      begin
        sFactureOuAvoir := 'Facture';
        sNomExportPdf := FormatDateTime('yyyy-mm-dd', Date)+
                         '_'+sFactureOuAvoir+'_'+
                         que_TetImp.fieldByName('FCE_NUMERO').asString+'.pdf';
      end;

      Nom := ReplaceChars(que_TetImpFCE_CLTNOM.asstring, ';.?./\''#@5{[]}°"~!§?%àèéïô+*%$| ', '_');
      // modification car la date n'a pas d'interet
      NomPdf := Que_TetImpFCE_IDWEB.AsString + '_' +
        que_TetImpFCE_NUMERO.asstring + '_' + Copy(Nom, 1, 32) + '.pdf';

      CASE Que_TetImpTYP_COD.asinteger OF
        903: FactRtm := 'FACTURE2.RTM';
      ELSE
        if Que_TetImp.FieldByName('FIL_ID').AsInteger <> 0 then
          FactRtm := 'FactureFiliale.rtm'
        else
          FactRtm := 'Facture1.RTM';
      END;

      que_TetImp.Close;
      i := que_TetImp.SQL.IndexOf('/*BALISE1*/');
      IF i <> -1 THEN
      BEGIN
        IF NOT isPro THEN
        BEGIN
          IF ImpCivClt THEN
            que_TetImp.SQL[i + 1] :=
              '( LTRIM(CIV_NOM||'' '')||FCE_CLTNOM||'' ''||FCE_CLTPRENOM ) CLIENT,'
          ELSE
            que_TetImp.SQL[i + 1] :=
              '( FCE_CLTNOM||'' ''||FCE_CLTPRENOM ) CLIENT,'
        END
        ELSE que_TetImp.SQL[i + 1] := '( FCE_CLTNOM ) CLIENT,'
      END;
      que_TetImp.paramByName('FCEID').asInteger := IdFac;
      que_tetImp.Open;

      Que_LineImp.Close;
      que_LineImp.paramByName('FCEID').asInteger := IdFac;
      que_LineImp.Open;

      que_Mags.Close;
      que_Mags.Open;
      que_Mags.Locate('MAG_ID', que_TetImp.fieldByName('FCE_MAGID').asInteger, []);

      SetParamImp(que_TetImp.fieldByName('FCE_MAGID').asInteger);

      Reg := TRegistry.Create;
      TRY
        TRY
          Reg.RootKey := HKEY_CURRENT_USER; // Section à rechercher dans le registre
          IF Reg.OpenKey('Software\Dane Prairie Systems\Win2Pdf', FALSE) THEN
            Reg.WriteString('PDFFileName', GGKPATH + 'Pdf\' + Nompdf);
          if Not DirectoryExists(GGKPATH + 'Pdf\') then
            ForceDirectories(GGKPATH + 'Pdf\');
        EXCEPT on E:Exception do
          raise Exception.Create('ImprimeFactureKour ->' + E.MEssage);
        END;
      FINALLY
        Reg.CloseKey;
        Reg.Free;
      END;

      frm_RapRv.imp_Quetet                := que_TetImp;
      frm_RapRv.imp_QueLigne              := Que_LineImp;
      frm_RapRv.Imp_QueMags               := Que_mags;
      frm_RapRv.FFacture.Origine          := GetOrigine;
      frm_RapRv.FFacture.ImpLine          := Impline;
      frm_RapRv.FFacture.LabFactor        := LabFactor;
      frm_RapRv.FFacture.ImpTva           := ImpTva;
      frm_RapRv.FFacture.TipFacRetro      := GetTypeFac(1001);
      frm_RapRv.FFacture.ImpTailCoul      := ImpTailCoul;
      frm_RapRv.FFacture.ImpRem           := ImpRem;
      frm_RapRv.FFacture.ImpVend          := ImpVend;
      frm_RapRv.FFacture.TipFacLoc        := GetTypeFac(903);
      frm_RapRv.FFacture.IdToTwinner      := GetGenParamInt(9,93);
      frm_RapRv.FFacture.ImpTete          := ImpTete;
      frm_RapRv.FFacture.ImpPayMag        := ImpPayMag;
      frm_RapRv.FFacture.ImpPayClt        := ImpPayClt;
      frm_RapRv.FFacture.ImpPied          := ImpPied;
      frm_RapRv.FFacture.ImpPg            := ImpPg;
      frm_RapRv.FFacture.TxtFactor        := TxtFactor;
      frm_RapRv.FFacture.TxtRgltDef       := TxtRgltDef;
      frm_RapRv.FFacture.TxtFinFact       := TxtFinFact;
      frm_RapRv.FFacture.ImpTextePied     := ImpTextePied;
      frm_RapRv.FFacture.ImpEuro          := ImpEuro;
      frm_RapRv.GetIso                    :=  GetIso;
      frm_RapRv.Convertor                 := Convertor;
      frm_RapRv.ConvertorEtik             := ConvertorEtik;
      frm_RapRv.FFacture.sMonnaieActuelle := GetGenParamStr(1,9);
      if trim(frm_RapRv.FFacture.sMonnaieActuelle) = '' then
        frm_RapRv.FFacture.sMonnaieActuelle := 'EUR';


      IF ChargeRap(que_TetImp, Que_LineImp, que_Mags, True, FactRtm, HTPied) THEN
      begin
        Frm_RapRV.Imprime(GGKPATH + 'Pdf\' + NomPdf, False, False, True);
        if not MoveFile(Pansichar(GGKPATH + 'Pdf\' + Nompdf),PAnsichar(APDFDir + Nompdf)) then
          Logs.AddToLogs(Format('Impossible de déplacer le fichier PDF %s vers %s',[NomPdf, APdfDir]));
      end;
    FINALLY
      que_TetImp.close;
      que_LineImp.Close;
      que_Mags.Close;
    END;
  END;
end;

procedure TDM_ImpDocFacture.InitConvertor;
begin
  Convertor.DefaultMnyRef :=
    Convertor.GetTMYTYP(GetStringParamValue('MONNAIE_REFERENCE'));
  Convertor.DefaultMnyTgt :=
    Convertor.GetTMYTYP(GetStringParamValue('MONNAIE_CIBLE'));
  Convertor.ReInit;

  // Après le passage à l'euro changer le sens des monnaies
  IF GetStringParamValue('MONNAIE_REFERENCE') = 'EUR' THEN
  BEGIN
    ConvertorEtik.DefaultMnyTgt :=
      ConvertorEtik.GetTMYTYP(GetStringParamValue('MONNAIE_REFERENCE'));
    ConvertorEtik.DefaultMnyRef :=
      ConvertorEtik.GetTMYTYP(GetStringParamValue('MONNAIE_CIBLE'));
  END
  ELSE
  BEGIN
    ConvertorEtik.DefaultMnyRef :=
      ConvertorEtik.GetTMYTYP(GetStringParamValue('MONNAIE_REFERENCE'));
    ConvertorEtik.DefaultMnyTgt :=
      ConvertorEtik.GetTMYTYP(GetStringParamValue('MONNAIE_CIBLE'));
  END;

  ConvertorEtik.ReInit;
end;

procedure TDM_ImpDocFacture.Que_LineImpREMISEGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
VAR
  v: double;
BEGIN
  IF ABS(Que_LineIMPREMISE.Asfloat) < 0.01 THEN
    Text := '0.00'
  ELSE BEGIN
    v := roundrv(Que_LineIMPREMISE.Asfloat, 1);
    Text := FormatFloat('#0.00', v);
  END;
end;

procedure TDM_ImpDocFacture.Que_TetImpCalcFields(DataSet: TDataSet);
begin
  IF que_TetImpCPA_CODE.asInteger = 1 THEN
    que_TetImpDateRglt.asdatetime :=  que_TetImp.FieldByName('FCE_REGLEMENT').asDateTime
  ELSE
    ChpDateRgltCODE(que_TetImpFCE_DATE.asDateTime, que_TetImpCPA_CODE.asInteger, que_TetImpDateRglt);

  IF que_TetImpFCE_DETAXE.asInteger = 1 THEN
  BEGIN
    que_TetImpTTCEURO.asFloat := RoundRv(que_TetImpTOTHT.asFloat, 2);
    que_TetImpSUMTTC.asFloat := RoundRv(que_TetImpTOTHT.asFloat, 2);
  END
  ELSE BEGIN
    que_TetImpTTCEURO.asFloat := RoundRv(que_TetImpTOTTTC.asFloat, 2);
    que_TetImpSUMTTC.asFloat := RoundRv(que_TetImpTOTTTC.asFloat, 2);
  END
end;

procedure TDM_ImpDocFacture.Que_TetImpTOTTTCGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := Convertor.Convert((Sender AS TField).AsFloat)
end;

function TDM_ImpDocFacture.SetParamImp(AMAGID: Integer): Boolean;
VAR
  ch: STRING;
  j: Integer;
BEGIN
  TxtFinFact := '';
  TxtFactor := TxtPmtFactor;
  TxtRgltDef := FacImpDateDef;
  LabFactor := '';
  Result := False;

  With Que_ROFacTmp do
  TRY
    Close;
    SQL.Clear;
    SQL.Add('SELECT GENPARAM.* FROM GENPARAM');
    SQL.Add('  JOIN K ON (K_ID=PRM_ID AND K_ENABLED=1)');
    SQL.Add('WHERE PRM_TYPE=1 AND PRM_MAGID=:MAGID');
    ParamCheck := True;
    ParamByName('MAGID').asInteger := AMAGID;
    Open;

    IF IsEmpty THEN
      raise Exception.Create(NeedParamimp)
    ELSE BEGIN
      Result := True;

      IF Locate('PRM_CODE', 1, []) THEN
      BEGIN
        ch := FieldByName('PRM_STRING').asstring;
        HtPied := FieldByName('PRM_FLOAT').asFloat;
      END
      ELSE BEGIN
        FOR j := 1 TO 100 DO
          ch := ch + '1';
        HtPied := 11.642;
      END;

      IF ch[1] = '1' THEN
        ImpTete := True
      ELSE
        ImpTete := False;

      IF ch[2] = '1' THEN
        ImpPied := True
      ELSE
        ImpPied := False;

      IF ch[4] = '1' THEN
        ImpPg := True
      ELSE
        ImpPg := False;

      IF ch[41] = '1' THEN
        ImpTextePied := True
      ELSE
        ImpTextePied := False;

      IF ch[42] = '1' THEN
        ImpEuro := True
      ELSE
        ImpEuro := False;

      IF ch[3] = '1' THEN
        ImpPayMag := True
      ELSE
        ImpPayMag := False;

      IF ch[43] = '1' THEN
        ImpPayClt := True
      ELSE
        ImpPayClt := False;

      IF ch[44] = '1' THEN
        ImpCivClt := True
      ELSE
        ImpCivClt := False;

      IF ch[45] = '1' THEN
        ImpRem := True
      ELSE
        ImpRem := False;

      IF ch[46] = '1' THEN
        ImpVend := True
      ELSE
        ImpVend := False;

      IF ch[47] = '1' THEN
        ImpLine := True
      ELSE
        ImpLine := False;

      IF ch[49] = '1' THEN
        ImpTVA := True
      ELSE
        ImpTVA := False;

      IF ch[52] = '1' THEN
        ImpTailCoul := True
      ELSE
        ImpTailCoul := False;

      IF ch[53] = '1' THEN
        ImpCDV := True
      ELSE
        ImpCDV := False;

      IF Locate('PRM_CODE', 4, []) THEN
        TxtFinFact := FieldbyName('PRM_STRING').asString;
      IF Locate('PRM_CODE', 5, []) THEN
        TxtRgltDef := FieldbyName('PRM_STRING').asString;
      IF Locate('PRM_CODE', 7, []) THEN
        LabFactor := FieldbyName('PRM_STRING').asString;
      IF Locate('PRM_CODE', 8, []) THEN
        TxtFactor := FieldbyName('PRM_STRING').asString;
    END;
  FINALLY
    Close;
  END;
end;

end.
