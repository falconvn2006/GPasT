unit u_i_BaseClientNationaleImpl;

interface

uses InvokeRegistry, Classes, Contnrs, SysUtils, DB, Types, XSBuiltIns,
     u_i_BaseClientNationaleIntf;

type
  c_BaseClientNationale = class(TInvokableClass, I_BaseClientNationale)
  public
    function GetTime: String; stdcall;

    function InfoClientGet(Const sDateHeure, sPassword: String; Const iCentrale: integer;
                           Const sNumCarte, sNomClient, sPrenomClient, sVilleClient,
                           sCPClient, sDateNaiss: String): TInfoClients; stdcall;

    function NbPointsClientGet(Const sDateHeure, sPassword, sNumcarte: String;
                               Const iCentrale: integer): TNbPointsClient; stdcall;

    function InfoClientMaj(Const iCentrale: integer; Const sDateHeure, sPassword,
                           sNumCarte, sCodeMag, sCiv, sNom, sPrenom, sAdr, sCP,
                           sVille, sPays, sTel1, sTel2, sDateNaiss, sEmail, sDateMAJ: String;
                           iTypeFid : integer;
                           iCstTel : string = ''; iCstMail : string = ''; iCstCgv : string = ''; iCltDesactive : Integer = 0): TRemotableGnk; stdcall;

    function InfoClientMajCAP(Const iCentrale: integer; Const sDateHeure, sPassword,
                              sNumCarte, sCodeMag, sCiv, sNom, sPrenom, sAdr, sCP,
                              sVille, sPays, sTel1, sTel2, sDateNaiss, sEmail, sDateMAJ: String;
                              CapRetMail, CapQualite : string; iTypeFid : integer;
                              iCstTel : string = ''; iCstMail : string = ''; iCstCgv : string = ''; iCltDesactive : Integer = 0): TRemotableGnk; stdcall;

    function BonReducUtilise(Const iCentrale: integer; Const sDateHeure, sPassword,
                             sNumCarte, sNumTicket, sCodeMag, sDate, sNumeroBon: String): TRemotableGnk; stdcall;
    function CheckBonReducUtilise(Const iCentrale: integer; Const sDateHeure, sPassword,
                                  sNumCarte, sNumTicket, sCodeMag, sDate, sNumeroBon: String): TRemotableGnk; stdcall; //--> Demande de BN

    function PalierUtilise(Const iCentrale, iPalierUtilise: integer; Const sDateHeure, sPassword,
                           sNumCarte, sCodeMag: String): TRemotableGnk; stdcall;

    function ImportClients(Const sDateHeure, sPassword, AFileName: String): TRemotableGnk; stdcall;
    function ImportPoints(Const sDateHeure, sPassword, AFileName: String): TRemotableGnk; stdcall;
    function ExportClients(Const sDateHeure, sPassword, AExtension, APathDest: String): TRemotableGnk; stdcall;
    function ExportBonRepris(Const sDateHeure, sPassword, AExtension, APathDest: String): TRemotableGnk; stdcall;

    function LogExportGet(Const sDateHeure, sPassword: String): TLogExports; stdcall;
  end;

implementation

uses uCtrlBaseClientNationale, uMdlBaseClientNationale, uConst, uVar, uLog;

function IsCheckSecurityOk(const sDateHeure, sPassword: String;
  Const ARemotableGnk: TRemotableGnk): Boolean;
var
  vResultCode: TResultCode;
begin
  Result:= True;
  GBaseClientNationaleCtrl.CheckSecurity(sDateHeure, sPassword, vResultCode);
  ARemotableGnk.sFilename := vResultCode.AFilename;
  if not vResultCode.IsSucceed then
    begin
      ARemotableGnk.iErreur:= vResultCode.ACodeErr;
      ARemotableGnk.sMessage:= vResultCode.AMessage;
      Result:= False;
    end;
end;

function c_BaseClientNationale.BonReducUtilise(const iCentrale: integer;
  const sDateHeure, sPassword, sNumCarte, sNumTicket, sCodeMag,
  sDate, sNumeroBon: String): TRemotableGnk;
var
  vResultCode: TResultCode;
  vBonRepris: TBonRepris;
  vSL: TStringList;
begin
  Log.Log('BonReducUtilise', 'c_BaseClientNationale', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    Result:= TRemotableGnk.Create;
    Result.iErreur:= 0;
    Result.sMessage:= rs_ProcessTerminate;
    Result.sFilename := '';

    if not IsCheckSecurityOk(sDateHeure, sPassword, Result) then
    begin
      Log.Log('BonReducUtilise', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
      Exit;
    end;

    vSL:= TStringList.Create;
    try
      if (Trim(sNumTicket) = '') then
        vSL.Append(rs_FieldMissing_NUMTICKET);

      if (Trim(sNumCarte) = '') then
        vSL.Append(rs_FieldMissing_NUMCARTE);

      if (Trim(sCodeMag) = '') then
        vSL.Append(rs_FieldMissing_MAGORIG);

      if (Trim(sDate) = '') then
        vSL.Append(rs_FieldMissing_DATE);

      if (Trim(sNumeroBon) = '') then
        vSL.Append(rs_FieldMissing_NUMBON);

      if vSL.Count <> 0 then
        begin
          vSL.Insert(0, rs_FieldMissing_EnteteMsg);
          Result.iErreur:= 1;
          Result.sMessage:= vSL.Text;
          Result.sFilename := '';
          Log.Log('BonReducUtilise', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
          Exit;
        end;

      vBonRepris:= GBaseClientNationaleCtrl.GetBonReducUtilise(iCentrale, StrToInt(sNumTicket),
                                                               sNumCarte, sCodeMag, sDate, sNumeroBon, vResultCode);
      Result.sFilename := vResultCode.AFilename;

      if not vResultCode.IsSucceed then
        begin
          Result.iErreur:= vResultCode.ACodeErr;
          Result.sMessage:= vResultCode.AMessage;
          Log.Log('BonReducUtilise', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
          Exit;
        end;

      if vBonRepris.BRP_ID = 0 then
        begin
          vBonRepris.BRP_ENSID:= iCentrale;
          vBonRepris.BRP_NUMTCK:= StrToInt(sNumTicket);
          vBonRepris.BRP_MAG:= sCodeMag;
          vBonRepris.BRP_DATE:= StrToDate(sDate);
          vBonRepris.BRP_CODEBON:= sNumeroBon;
          vBonRepris.BRP_TRAITE:= 0;

          vBonRepris.MAJ(ukInsert);
        end
      else
        begin
          vBonRepris.BRP_TRAITE:= 1;
          vBonRepris.MAJ(ukModify);
        end;
    finally
      if vBonRepris <> nil then
        FreeAndNil(vBonRepris);
      FreeAndNil(vSL);
    end;
    Log.Log('BonReducUtilise', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      Result.iErreur:= 1;
      Result.sMessage:= E.Message;
      Log.Log('BonReducUtilise', 'c_BaseClientNationale', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
    end;
  end;
end;

function c_BaseClientNationale.CheckBonReducUtilise(const iCentrale: integer;
  const sDateHeure, sPassword, sNumCarte, sNumTicket, sCodeMag, sDate,
  sNumeroBon: String): TRemotableGnk;
var
  vResultCode: TResultCode;
  vBonRepris: TBonRepris;
  vSL: TStringList;
begin
  Log.Log('CheckBonReducUtilise', 'c_BaseClientNationale', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    vBonRepris:= nil;
    Result:= TRemotableGnk.Create;
    Result.iErreur:= 0;
    Result.sMessage:= rs_MESS_BonValide;
    Result.sFilename := '';

    if not IsCheckSecurityOk(sDateHeure, sPassword, Result) then
    begin
      Log.Log('CheckBonReducUtilise', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
      Exit;
    end;

    vSL:= TStringList.Create;
    try
      if (Trim(sNumTicket) = '') then
        vSL.Append(rs_FieldMissing_NUMTICKET);

      if (Trim(sNumCarte) = '') then
        vSL.Append(rs_FieldMissing_NUMCARTE);

      if (Trim(sCodeMag) = '') then
        vSL.Append(rs_FieldMissing_MAGORIG);

      if (Trim(sDate) = '') then
        vSL.Append(rs_FieldMissing_DATE);

      if (Trim(sNumeroBon) = '') then
        vSL.Append(rs_FieldMissing_NUMBON);

      if vSL.Count <> 0 then
        begin
          vSL.Insert(0, rs_FieldMissing_EnteteMsg);
          Result.iErreur:= 1;
          Result.sMessage:= vSL.Text;
          Result.sFilename := '';
          Log.Log('CheckBonReducUtilise', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
          Exit;
        end;

      vBonRepris:= GBaseClientNationaleCtrl.GetBonReducUtilise(iCentrale, StrToInt(sNumTicket),
                                                             sNumCarte, sCodeMag, sDate, sNumeroBon, vResultCode);
      Result.sFilename := vResultCode.AFilename;

      if not vResultCode.IsSucceed then
        begin
          Result.iErreur:= vResultCode.ACodeErr;
          Result.sMessage:= vResultCode.AMessage;
        end;
    finally
      if vBonRepris <> nil then
        FreeAndNil(vBonRepris);
      FreeAndNil(vSL);
    end;
    Log.Log('CheckBonReducUtilise', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      Log.Log('CheckBonReducUtilise', 'c_BaseClientNationale', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

function c_BaseClientNationale.ExportBonRepris(const sDateHeure, sPassword,
  AExtension, APathDest: String): TRemotableGnk;
var
  vResultCode: TResultCode;
begin
  Log.Log('ExportBonRepris', 'c_BaseClientNationale', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    Result:= TRemotableGnk.Create;
    Result.iErreur:= 0;
    Result.sMessage:= rs_ProcessTerminate;
    Result.sFilename := '';

    if not IsCheckSecurityOk(sDateHeure, sPassword, Result) then
    begin
      Log.Log('ExportBonRepris', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
      Exit;
    end;

    GBaseClientNationaleCtrl.ExportBonRepris(AExtension, APathDest, vResultCode);
    Result.sFilename := vResultCode.AFilename;

    if vResultCode.IsFailed then
      begin
        Result.iErreur:= vResultCode.ACodeErr;
        Result.sMessage:= vResultCode.AMessage;
      end;
    Log.Log('ExportBonRepris', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      Log.Log('ExportBonRepris', 'c_BaseClientNationale', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

function c_BaseClientNationale.ExportClients(const sDateHeure, sPassword,
  AExtension, APathDest: String): TRemotableGnk;
var
  vResultCode: TResultCode;
begin
  Log.Log('ExportClients', 'c_BaseClientNationale', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    Result:= TRemotableGnk.Create;
    Result.iErreur:= 0;
    Result.sMessage:= rs_ProcessTerminate;
    Result.sFilename := '';

    if not IsCheckSecurityOk(sDateHeure, sPassword, Result) then
    begin
      Log.Log('ExportClients', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
      Exit;
    end;

    GBaseClientNationaleCtrl.ExportClients(AExtension, APathDest, vResultCode);
    Result.sFilename := vResultCode.AFilename;

    if vResultCode.IsFailed then
      begin
        Result.iErreur:= vResultCode.ACodeErr;
        Result.sMessage:= vResultCode.AMessage;
      end;
    Log.Log('ExportClients', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      Log.Log('ExportClients', 'c_BaseClientNationale', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

function c_BaseClientNationale.GetTime: String;
begin
  Log.Log('GetTime', 'c_BaseClientNationale', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    Result:= GBaseClientNationaleCtrl.GetDateTimeGMT;
    Log.Log('GetTime', 'c_BaseClientNationale', '', 'exit', Result, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      Log.Log('GetTime', 'c_BaseClientNationale', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

function c_BaseClientNationale.ImportClients(Const sDateHeure, sPassword,
  AFileName: String): TRemotableGnk;
var
  vResultCode: TResultCode;
begin
  Log.Log('ImportClients', 'c_BaseClientNationale', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    Result:= TRemotableGnk.Create;
    Result.iErreur:= 0;
    Result.sMessage:= rs_ProcessTerminate;
    Result.sFilename := AFileName;

    if not IsCheckSecurityOk(sDateHeure, sPassword, Result) then
    begin
      Log.Log('ImportClients', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
      Exit;
    end;

    GBaseClientNationaleCtrl.ImportClients(AFileName, vResultCode);
    Result.sFilename := vResultCode.AFilename;

    if vResultCode.IsFailed then
      begin
        Result.iErreur:= vResultCode.ACodeErr;
        Result.sMessage:= vResultCode.AMessage;
      end;
    Log.Log('ImportClients', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      Log.Log('ImportClients', 'c_BaseClientNationale', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

function c_BaseClientNationale.ImportPoints(const sDateHeure, sPassword,
  AFileName: String): TRemotableGnk;
var
  vResultCode: TResultCode;
begin
  Log.Log('ImportPoints', 'c_BaseClientNationale', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    Result:= TRemotableGnk.Create;
    Result.iErreur:= 0;
    Result.sMessage:= rs_ProcessTerminate;
    Result.sFilename := AFilename;

    if not IsCheckSecurityOk(sDateHeure, sPassword, Result) then
    begin
      Log.Log('ImportPoints', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
      Exit;
    end;

    GBaseClientNationaleCtrl.ImportPoints(AFileName, vResultCode);
    Result.sFilename := vResultCode.AFilename;

    if vResultCode.IsFailed then
      begin
        Result.iErreur:= vResultCode.ACodeErr;
        Result.sMessage:= vResultCode.AMessage;
      end;
    Log.Log('ImportPoints', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      Log.Log('ImportPoints', 'c_BaseClientNationale', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

function c_BaseClientNationale.InfoClientGet(const sDateHeure, sPassword: String;
  const iCentrale: integer; const sNumCarte, sNomClient, sPrenomClient,
  sVilleClient, sCPClient, sDateNaiss: String): TInfoClients;
var
  i: integer;
  vClient: TClient;
  vClientInfos: TClientInfos;
  vClientsInfosArray: TClientsInfosArray;
  vList: TObjectList;
  vResultCode: TResultCode;
begin
  Log.Log('InfoClientGet', 'c_BaseClientNationale', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    Result:= TInfoClients.Create;
    SetLength(vClientsInfosArray, 0);

    if not IsCheckSecurityOk(sDateHeure, sPassword, Result) then
    begin
      Log.Log('InfoClientGet', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
      Exit;
    end;

    vList:= GBaseClientNationaleCtrl.GetListInfoClient(iCentrale, sNumCarte, sNomClient,
                                                       sPrenomClient, sCPClient, sVilleClient,
                                                       StrToDateDef(sDateNaiss, 0), vResultCode);
    try
      Result.sFilename := vResultCode.AFilename;

      if not vResultCode.IsSucceed then
        begin
          Result.iErreur:= vResultCode.ACodeErr;
          Result.sMessage:= vResultCode.AMessage;
          Log.Log('InfoClientGet', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
          Exit;
        end;

      Result.iNbClients:= vList.Count;

      for i:= 0 to vList.Count -1 do
        begin
          vClient:= TClient(vList.Items[i]);

          SetLength(vClientsInfosArray, Length(vClientsInfosArray) +1);
          vClientInfos:= TClientInfos.Create;

          vClientInfos.iCentrale:= vClient.CLI_ENSID;
          vClientInfos.sNumCarte:= vClient.CLI_NUMCARTE;
          vClientInfos.sCiv:= vClient.CLI_CIV;
          vClientInfos.sNom:= vClient.CLI_NOM;
          vClientInfos.sPrenom:= vClient.CLI_PRENOM;
          vClientInfos.sAdr:= vClient.CLI_ADR1 + cRC + vClient.CLI_ADR2 + cRC + vClient.CLI_ADR3 + cRC + vClient.CLI_ADR4;
          vClientInfos.sCP:= vClient.CLI_CP;
          vClientInfos.sVille:= vClient.CLI_VILLE;
          vClientInfos.sPays:= vClient.CLI_CODEPAYS;
          vClientInfos.sTel1:= vClient.CLI_TEL1;
          vClientInfos.sTel2:= vClient.CLI_TEL2;
          vClientInfos.sDateNaiss:= DateToStr(vClient.CLI_DTNAISS);
          vClientInfos.sEmail:= vClient.CLI_EMAIL;
          vClientInfos.iSalarie:= StrToInt(vClient.CLI_TOPSAL);
          vClientInfos.sDateCreation:= DateToStr(vClient.CLI_DTCREATION);
          vClientInfos.iBlackList:= StrToInt(vClient.CLI_BLACKLIST);
          vClientInfos.iNPAI:= StrToInt(vClient.CLI_TOPNPAI);
          vClientInfos.sDateSuppression:= DateToStr(vClient.CLI_DTSUP);
          vClientInfos.iTypeFid := vClient.CLI_TYPEFID;

          vClientInfos.iCstTel := vClient.CLI_CSTTEL;
          vClientInfos.iCstMail := vClient.CLI_CSTMAIL;
          vClientInfos.iCstCgv := vClient.CLI_CSTCGV;
          vClientInfos.iCltDesactive := vClient.CLI_DESACTIVE;

          vClientInfos.iVIB:= StrToIntDef(vClient.CLI_TOPVIB,0);
          if vClient.CLI_TOPVIBUTIL = 0 then
  //JB
            vClientInfos.iVIB:= StrToIntDef(vClient.CLI_TOPVIB,0);
  //          vClientInfos.iVIB:= StrToInt(vClient.CLI_TOPVIB);

          vClientInfos.sIDREF:= vClient.CLI_IDETO;
          vClientInfos.sSoldePts:= FloatToStr(vClient.Points.PTS_NBPOINTS);

          vClientInfos.sDateSoldePts:= '';
          if vClient.Points.PTS_DATE <> 0 then
            vClientInfos.sDateSoldePts:= DateTimeToStr(vClient.Points.PTS_DATE);

          vClientsInfosArray[Length(vClientsInfosArray) -1]:= vClientInfos;
        end;

      Result.stClientInfos:= vClientsInfosArray;
    finally
      if vList <> nil then
        FreeAndNil(vList);
    end;
    Log.Log('InfoClientGet', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      Log.Log('InfoClientGet', 'c_BaseClientNationale', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

function c_BaseClientNationale.InfoClientMaj(const iCentrale: integer;
  const sDateHeure, sPassword, sNumCarte, sCodeMag, sCiv, sNom, sPrenom, sAdr,
  sCP, sVille, sPays, sTel1, sTel2, sDateNaiss, sEmail, sDateMAJ: String; iTypeFid : integer;
  iCstTel, iCstMail, iCstCgv : string; iCltDesactive : Integer): TRemotableGnk;
var
  vClient: TClient;
  vSL: TStringList;
  vUk: TUpdateKind;
  vResultCode: TResultCode;
begin
  Log.Log('InfoClientMaj', 'c_BaseClientNationale', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    vClient:= nil;
    Result:= TRemotableGnk.Create;
    Result.iErreur:= 0;
    Result.sMessage:= rs_ProcessTerminate;
    Result.sFilename := '';

    if not IsCheckSecurityOk(sDateHeure, sPassword, Result) then
    begin
      Log.Log('InfoClientMaj', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
      Exit;
    end;

    vSL:= TStringList.Create;
    try
      if (Trim(sNumCarte) = '') then
        vSL.Append(rs_FieldMissing_NUMCARTE);

      if (Trim(sCodeMag) = '') then
        vSL.Append(rs_FieldMissing_MAGORIG);

      if (Trim(sNom) = '') then
        vSL.Append(rs_FieldMissing_NOM);

      // if (Trim(sAdr) = '') then
      //  vSL.Append(rs_FieldMissing_ADR);

      // if (Trim(sCP) = '') then
      //  vSL.Append(rs_FieldMissing_CP);

      // if (Trim(sVille) = '') then
      //  vSL.Append(rs_FieldMissing_VILLE);

      // if (Trim(sPays) = '') then
      //  vSL.Append(rs_FieldMissing_CODEPAYS);

      if vSL.Count <> 0 then
        begin
          vSL.Insert(0, rs_FieldMissing_EnteteMsg);
          Result.iErreur:= 1;
          Result.sMessage:= vSL.Text;
          Result.sFilename := '';
          Log.Log('InfoClientMaj', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
          Exit;
        end;

      vClient:= GBaseClientNationaleCtrl.GetClient(sNumCarte, vResultCode);
      Result.sFilename := vResultCode.AFilename;

      if vClient <> nil then
        vUk:= ukModify
      else
        begin
          vClient:= TClient.Create;
          vUk:= ukInsert;
        end;

      vSL.Text:= sAdr;
      if vSL.Count > 0 then
         vClient.CLI_ADR1:= vSL.Strings[0];

      if vSL.Count > 1 then
         vClient.CLI_ADR2:= vSL.Strings[1];

      if vSL.Count > 2 then
         vClient.CLI_ADR3:= vSL.Strings[2];

      if vSL.Count > 3 then
         vClient.CLI_ADR4:= vSL.Strings[3];

      vClient.CLI_ENSID:= iCentrale;
      vClient.CLI_NUMCARTE:= sNumCarte;

      case vUk of
        ukModify:
          begin
            vClient.CLI_MAGMODIF:= sCodeMag;
            vClient.CLI_DTMODIF:= StrToDate(sDateMAJ);
          end;
        ukInsert:
          begin
            vClient.CLI_MAGORIG:= sCodeMag;
            vClient.CLI_IDETO:= '';
            vClient.CLI_CODEPROF:= '';
            vClient.CLI_AUTRESP:= '';
            vClient.CLI_BLACKLIST:= '1';    // En Insert =
            vClient.CLI_TOPSAL:= '0';
            vClient.CLI_CODERFM:= '';
            vClient.CLI_OPTIN:= '0';
            vClient.CLI_OPTINPART:= '0';
            vClient.CLI_TOPNPAI:= '0';
            vClient.CLI_TOPVIB:= '0';
            vClient.CLI_REMRENOUV:= 0;
            vClient.CLI_MAGCREA:= sCodeMag;
            vClient.CLI_DTCREATION:= StrToDate(sDateMAJ);
            case GBaseClientNationaleCtrl.ValueToTypeEnseigne(iCentrale) of
              teGOSPORT: vClient.CLI_DTVAL := EncodeDate(2050, 12, 31);
              teCOURIR: vClient.CLI_DTVAL  := EncodeDate(2050, 12, 31);
            end;
          end;
      end;

      vClient.CLI_CIV:= sCiv;
      vClient.CLI_NOM:= sNom;
      vClient.CLI_PRENOM:= sPrenom;
      vClient.CLI_CP:= sCP;
      vClient.CLI_VILLE:= sVille;
      vClient.CLI_CODEPAYS:= sPays;
      vClient.CLI_TEL1:= sTel1;
      vClient.CLI_TEL2:= sTel2;
      vClient.CLI_DTNAISS:= StrToDate(sDateNaiss);
      vClient.CLI_EMAIL:= sEmail;
      vClient.CLI_TYPEFID := iTypeFid;

      vClient.CLI_CSTTEL := iCstTel;
      vClient.CLI_CSTMAIL := iCstMail;
      vClient.CLI_CSTCGV := iCstCgv;
      vClient.CLI_DESACTIVE := iCltDesactive;
      vClient.CLI_TOPVIB:= '0';

      vClient.MAJ(vUk);
    finally
      FreeAndNil(vSL);
      if vClient <> nil then
        FreeAndNil(vClient);
    end;
    Log.Log('InfoClientMaj', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      Result.iErreur:= 1;
      Result.sMessage:= E.Message;
      Log.Log('InfoClientMaj', 'c_BaseClientNationale', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
    end;
  end;
end;

function c_BaseClientNationale.InfoClientMajCAP(Const iCentrale: integer; Const sDateHeure, sPassword,
                                                sNumCarte, sCodeMag, sCiv, sNom, sPrenom, sAdr, sCP,
                                                sVille, sPays, sTel1, sTel2, sDateNaiss, sEmail, sDateMAJ: String;
                                                CapRetMail, CapQualite : string; iTypeFid : integer;
                                                iCstTel, iCstMail, iCstCgv : string; iCltDesactive : Integer): TRemotableGnk; stdcall;
var
  vClient: TClient;
  vSL: TStringList;
  vUk: TUpdateKind;
  vResultCode: TResultCode;
begin
  Log.Log('InfoClientMajCAP', 'c_BaseClientNationale', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    vClient:= nil;
    Result:= TRemotableGnk.Create;
    Result.iErreur:= 0;
    Result.sMessage:= rs_ProcessTerminate;
    Result.sFilename := '';

    if not IsCheckSecurityOk(sDateHeure, sPassword, Result) then
    begin
      Log.Log('InfoClientMajCAP', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
      Exit;
    end;

    vSL:= TStringList.Create;
    try
      if (Trim(sNumCarte) = '') then
        vSL.Append(rs_FieldMissing_NUMCARTE);

      if (Trim(sCodeMag) = '') then
        vSL.Append(rs_FieldMissing_MAGORIG);

      if (Trim(sNom) = '') then
        vSL.Append(rs_FieldMissing_NOM);

      // if (Trim(sAdr) = '') then
      //  vSL.Append(rs_FieldMissing_ADR);

      // if (Trim(sCP) = '') then
      //  vSL.Append(rs_FieldMissing_CP);

      // if (Trim(sVille) = '') then
      //  vSL.Append(rs_FieldMissing_VILLE);

      // if (Trim(sPays) = '') then
      //  vSL.Append(rs_FieldMissing_CODEPAYS);

      if vSL.Count <> 0 then
        begin
          vSL.Insert(0, rs_FieldMissing_EnteteMsg);
          Result.iErreur:= 1;
          Result.sMessage:= vSL.Text;
          Result.sFilename := '';
          Log.Log('InfoClientMajCAP', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
          Exit;
        end;

      vClient:= GBaseClientNationaleCtrl.GetClient(sNumCarte, vResultCode);
      Result.sFilename := vResultCode.AFilename;

      if vClient <> nil then
        vUk:= ukModify
      else
        begin
          vClient:= TClient.Create;
          vUk:= ukInsert;
        end;

      vSL.Text:= sAdr;
      if vSL.Count > 0 then
         vClient.CLI_ADR1:= vSL.Strings[0];

      if vSL.Count > 1 then
         vClient.CLI_ADR2:= vSL.Strings[1];

      if vSL.Count > 2 then
         vClient.CLI_ADR3:= vSL.Strings[2];

      if vSL.Count > 3 then
         vClient.CLI_ADR4:= vSL.Strings[3];

      vClient.CLI_ENSID:= iCentrale;
      vClient.CLI_NUMCARTE:= sNumCarte;

      case vUk of
        ukModify:
          begin
            vClient.CLI_MAGMODIF:= sCodeMag;
            vClient.CLI_DTMODIF := StrToDate(sDateMAJ);
          end;
        ukInsert:
          begin
            vClient.CLI_MAGORIG:= sCodeMag;
            vClient.CLI_IDETO:= '';
            vClient.CLI_CODEPROF:= '';
            vClient.CLI_AUTRESP:= '';
            vClient.CLI_BLACKLIST:= '1';    // En Insert =
            vClient.CLI_TOPSAL:= '0';
            vClient.CLI_CODERFM:= '';
            vClient.CLI_OPTIN:= '0';
            vClient.CLI_OPTINPART:= '0';
            vClient.CLI_TOPNPAI:= '0';
            vClient.CLI_TOPVIB:= '0';
            vClient.CLI_REMRENOUV:= 0;
            vClient.CLI_MAGCREA:= sCodeMag;
            vClient.CLI_DTCREATION:= StrToDate(sDateMAJ);
            case GBaseClientNationaleCtrl.ValueToTypeEnseigne(iCentrale) of
              teGOSPORT: vClient.CLI_DTVAL := EncodeDate(2050, 12, 31);
              teCOURIR: vClient.CLI_DTVAL  := EncodeDate(2050, 12, 31);
            end;

            vClient.CLI_RETMAIL := Copy(CapRetMail, 1, 5); // nb max caractères
            vClient.CLI_QUALITE := Copy(CapQualite, 1, 2); // nb max caractères
          end;
      end;

      vClient.CLI_CIV:= sCiv;
      vClient.CLI_NOM:= sNom;
      vClient.CLI_PRENOM:= sPrenom;
      vClient.CLI_CP:= sCP;
      vClient.CLI_VILLE:= sVille;
      vClient.CLI_CODEPAYS:= sPays;
      vClient.CLI_TEL1:= sTel1;
      vClient.CLI_TEL2:= sTel2;
      vClient.CLI_DTNAISS:= StrToDate(sDateNaiss);
      vClient.CLI_EMAIL:= sEmail;
      vClient.CLI_TYPEFID := iTypeFid;

      vClient.CLI_CSTTEL := iCstTel;
      vClient.CLI_CSTMAIL := iCstMail;
      vClient.CLI_CSTCGV := iCstCgv;
      vClient.CLI_DESACTIVE := iCltDesactive;

      vClient.MAJ(vUk);
    finally
      FreeAndNil(vSL);
      if vClient <> nil then
        FreeAndNil(vClient);
    end;
    Log.Log('InfoClientMajCAP', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
      begin
        Result.iErreur:= 1;
        Result.sMessage:= E.Message;
        Log.Log('InfoClientMajCAP', 'c_BaseClientNationale', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      end;
  end;
end;

function c_BaseClientNationale.LogExportGet(const sDateHeure,
  sPassword: String): TLogExports;
var
  i: integer;
  vResultCode: TResultCode;
  vExportLog: TExportLog;
  vList: TObjectList;
  vLogExportInfo: TLogExportInfo;
  vLogExportArray: TLogExportInfoArray;
begin
  Log.Log('LogExportGet', 'c_BaseClientNationale', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    Result:= TLogExports.Create;
    SetLength(vLogExportArray, 0);

    if not IsCheckSecurityOk(sDateHeure, sPassword, Result) then
    begin
      Log.Log('LogExportGet', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
      Exit;
    end;

    vList:= GBaseClientNationaleCtrl.GetListLogExport(vResultCode);
    try
      Result.sFilename := vResultCode.AFilename;

      if not vResultCode.IsSucceed then
        begin
          Result.iErreur:= vResultCode.ACodeErr;
          Result.sMessage:= vResultCode.AMessage;
          Log.Log('LogExportGet', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
          Exit;
        end;

      Result.iNbLogExport:= vList.Count;

      for i:= 0 to vList.Count -1 do
        begin
          vExportLog:= TExportLog(vList.Items[i]);

          SetLength(vLogExportArray, Length(vLogExportArray) +1);
          vLogExportInfo:= TLogExportInfo.Create;

          vLogExportInfo.sHeure:= DateTimeToStr(vExportLog.EXP_HEURE);
          vLogExportInfo.sFichier:= vExportLog.EXP_FICHIER;
          vLogExportInfo.sDateLastExport:= DateToStr(vExportLog.EXP_DATELASTEXPORT);

          vLogExportArray[Length(vLogExportArray) -1]:= vLogExportInfo;
        end;

      Result.AListLogExport:= vLogExportArray;
    finally
      if vList <> nil then
        FreeAndNil(vList);
    end;
    Log.Log('LogExportGet', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      Log.Log('LogExportGet', 'c_BaseClientNationale', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

function c_BaseClientNationale.NbPointsClientGet(const sDateHeure, sPassword,
  sNumcarte: String; const iCentrale: integer): TNbPointsClient;
var
  vPoints: TPoints;
  vResultCode: TResultCode;
begin
  Log.Log('NbPointsClientGet', 'c_BaseClientNationale', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    Result:= TNbPointsClient.Create;

    if not IsCheckSecurityOk(sDateHeure, sPassword, Result) then
    begin
      Log.Log('NbPointsClientGet', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
      Exit;
    end;

    vPoints:= GBaseClientNationaleCtrl.GetNbPointsClient(iCentrale, sNumcarte, vResultCode);
    try
      Result.sFilename := vResultCode.AFilename;

      if not vResultCode.IsSucceed then
        begin
          Result.iErreur:= vResultCode.ACodeErr;
          Result.sMessage:= vResultCode.AMessage;
          Exit;
        end;

      Result.sSoldePts:= FloatToStr(vPoints.PTS_NBPOINTS);
      Result.sDateSoldePts:= DateToStr(vPoints.PTS_DATE);

    finally
      FreeAndNil(vPoints);
    end;
    Log.Log('NbPointsClientGet', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      Log.Log('NbPointsClientGet', 'c_BaseClientNationale', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
      raise;
    end;
  end;
end;

function c_BaseClientNationale.PalierUtilise(const iCentrale,
  iPalierUtilise: integer; const sDateHeure, sPassword, sNumCarte,
  sCodeMag: String): TRemotableGnk;
var
  vClient: TClient;
  vResultCode: TResultCode;
  vSL: TStringList;
begin
  Log.Log('PalierUtilise', 'c_BaseClientNationale', '', 'call', '', logDebug, False, -1, ltLocal);
  try
    vClient:= nil;
    Result:= TRemotableGnk.Create;
    Result.iErreur:= 0;
    Result.sMessage:= rs_ProcessTerminate;
    Result.sFilename := '';

    if not IsCheckSecurityOk(sDateHeure, sPassword, Result) then
    begin
      Log.Log('PalierUtilise', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
      Exit;
    end;

    if iCentrale <> 2 then
      begin
        Result.iErreur:= 1;
        Result.sMessage:= rs_MESS_UpdatePalierNonAutorise;
        Result.sFilename := '';
        Log.Log('PalierUtilise', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
        Exit;
      end;

    vSL:= TStringList.Create;
    try
      if (Trim(sNumCarte) = '') then
        vSL.Append(rs_FieldMissing_NUMCARTE);

      if (Trim(sCodeMag) = '') then
        vSL.Append(rs_FieldMissing_MAGORIG);

      if vSL.Count <> 0 then
        begin
          vSL.Insert(0, rs_FieldMissing_EnteteMsg);
          Result.iErreur:= 1;
          Result.sMessage:= vSL.Text;
          Result.sFilename := '';
          Log.Log('PalierUtilise', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
          Exit;
        end;

      vClient:= GBaseClientNationaleCtrl.GetClient(sNumCarte, vResultCode);
      Result.sFilename := vResultCode.AFilename;
      if vClient = nil then
        begin
          Result.iErreur:= 1;
          Result.sMessage:= Format(rs_MESS_CardNotfound, [sNumCarte]);
          Log.Log('PalierUtilise', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
          Exit;
        end
      else
        if vClient.CLI_DTSUP <> 0 then
          begin
            Result.iErreur:= 1;
            Result.sMessage:= Format(rs_MESS_ClientDisabled, [sNumCarte]);
            Log.Log('PalierUtilise', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
            Exit;
          end
        else
          if vClient.CLI_TOPVIBUTIL <> 0 then
            begin
              Result.iErreur:= 1;
              Result.sMessage:= rs_MESS_PalierExist;
              Log.Log('PalierUtilise', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
              Exit;
            end;

      vClient.CLI_MAGMODIF:= sCodeMag;
      vClient.CLI_TOPVIBUTIL:= iPalierUtilise;
      vClient.MAJ(ukModify);
    finally
      FreeAndNil(vSL);
      if vClient <> nil then
        FreeAndNil(vClient);
    end;
    Log.Log('PalierUtilise', 'c_BaseClientNationale', '', 'exit', Result.sMessage, logDebug, False, -1, ltLocal);
  except
    on E: Exception do
    begin
      Result.iErreur:= 1;
      Result.sMessage:= E.Message;
      Log.Log('PalierUtilise', 'c_BaseClientNationale', '', 'exception', E.Message, logDebug, False, -1, ltLocal);
    end;
  end;
end;

initialization
   InvRegistry.RegisterInvokableClass(c_BaseClientNationale);
end.

