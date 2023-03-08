unit GSDataWebService_DM;

interface

uses
  SysUtils, Classes, GSDataMain_DM, DB, IBODataset, U_I_BaseClientNationale;

type
  TDM_GSDataWebService = class(TDataModule)
    que_Tmp: TIBOQuery;
    Que_MAJ: TIBOQuery;
    Que_WsReprise: TIBOQuery;
    Que_GetParam: TIBOQuery;

    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Déclarations privées }
  protected
    { Déclarations protégées }
    function GetCentrale(magid : integer) : integer;
    function GetMagCodeAdh(magid : integer) : string;
  public
    { Déclarations publiques }
    function GetParamWSURL(magid : integer) : string;
    function GetParamWSPassword(magid : integer) : string;

    function TraiteCreatModifClient(WsBaseClient : I_BaseClientNationale; WsPassword : string; magid, id : integer; cltid : integer; wsr_date: TDateTime; out error : string) : boolean;
    function TraiteEnregistrementBonReduc(WsBaseClient : I_BaseClientNationale; WsPassword : string; magid, id : integer; idreduc : integer; out error : string) : boolean;
    function TraiteUtilisationPalier(WsBaseClient : I_BaseClientNationale; WsPassword : string; magid, id : integer; idreduc : integer; out error : string) : boolean;

    function FlagAsSuppr(id : integer) : boolean;
  end;

implementation

uses
  MD5Api,
  uTool;

const
  WR_REPONSE = 'Le Web Service a répondu : ';

{$R *.dfm}

procedure TDM_GSDataWebService.DataModuleCreate(Sender: TObject);
begin
  // arf !
end;

procedure TDM_GSDataWebService.DataModuleDestroy(Sender: TObject);
begin
  // arf !
end;

function TDM_GSDataWebService.GetCentrale(magid : integer) : integer;
begin
  Result := -1;
  try
    Que_GetParam.ParamByName('magid').AsInteger := magid;
    Que_GetParam.ParamByName('posid').AsInteger := 0;
    Que_GetParam.ParamByName('prmtype').AsInteger := 16;
    Que_GetParam.ParamByName('prmcode').AsInteger := 7;
    Que_GetParam.Open();
    if not Que_GetParam.Eof then
      Result := Que_GetParam.FieldByName('prm_integer').AsInteger;
  finally
    Que_GetParam.Close();
  end;
end;

function TDM_GSDataWebService.GetMagCodeAdh(magid : integer) : string;
begin
  Result := '';
  try
    que_Tmp.SQL.Text := 'select mag_codeadh from genmagasin join k on k_id = mag_id and k_enabled = 1 where mag_id = ' + IntToStr(magid) + ';';
    que_Tmp.Open();
    if not que_Tmp.Eof then
      Result := que_Tmp.FieldByName('mag_codeadh').AsString;
  finally
    Que_GetParam.Close();
  end;
end;

function TDM_GSDataWebService.GetParamWSURL(magid : integer) : string;
begin
  Result := '';
  try
    Que_GetParam.ParamByName('magid').AsInteger := magid;
    Que_GetParam.ParamByName('posid').AsInteger := 0;
    Que_GetParam.ParamByName('prmtype').AsInteger := 16;
    Que_GetParam.ParamByName('prmcode').AsInteger := 11;
    Que_GetParam.Open();
    if not Que_GetParam.Eof then
      Result := Que_GetParam.FieldByName('prm_string').AsString;
  finally
    Que_GetParam.Close();
  end;
end;

function TDM_GSDataWebService.GetParamWSPassword(magid : integer) : string;
begin
  Result := '';
  try
    Que_GetParam.ParamByName('magid').AsInteger := magid;
    Que_GetParam.ParamByName('posid').AsInteger := 0;
    Que_GetParam.ParamByName('prmtype').AsInteger := 16;
    Que_GetParam.ParamByName('prmcode').AsInteger := 10;
    Que_GetParam.Open();
    if not Que_GetParam.Eof then
      Result := Que_GetParam.FieldByName('prm_string').AsString;
  finally
    Que_GetParam.Close();
  end;
end;

function TDM_GSDataWebService.TraiteCreatModifClient(WsBaseClient : I_BaseClientNationale; WsPassword : string; magid, id : integer; cltid : integer; wsr_date: TDateTime; out error : string) : boolean;
var
  tmpDate, tmpPassword : string;
  Reponse: TRemotableGnk;
  Centrale, vCstTel, vCstMail, vCstCgv, vCltDesactive : integer;
  CodeAdh : string;
  Adresse : TStringList;
  CQAAdresse, CQAemail : string;
begin
  Result := false;
  error := '';
  if (WsBaseClient = nil) or (Trim(WsPassword) = '') then
  begin
    error := 'WebService ou mot de passe non renseigné.';
    Exit;
  end;
  try
    Centrale := GetCentrale(magid);
    CodeAdh := GetMagCodeAdh(magid);

    que_Tmp.SQL.Text := 'select cbi_cb, clt_nom, clt_prenom, civ_nom, clt_naissance, adr_ligne, adr_tel, adr_gsm, '
                      + 'adr_email, vil_nom, vil_cp, pay_code, g1.imp_refstr as CQA, g2.imp_refstr as RET_EMAIL, '
                      + 'tcf_type, cst1001.cst_oui as CstTel, cst1002.cst_oui as CstMail, cst4001.cst_oui as CstCgv '
                      + 'cbi_inactif as CltDesactive'
                      + 'from cltclient join k on k_id = clt_id and k_enabled = 1 '
                      + 'join cltconsentement cst1001 on (cst1001.cst_cltid = clt_id and cst1001.cst_codefon = 1001) '
                      + 'join cltconsentement cst1002 on (cst1002.cst_cltid = clt_id and cst1002.cst_codefon = 1002) '
                      + 'join cltconsentement cst4001 on (cst4001.cst_cltid = clt_id and cst4001.cst_codefon = 4001) '
                      + 'join gencivilite on civ_id = clt_civid '
                      + 'join genadresse on adr_id = clt_adrid '
                      + 'join genville on vil_id = adr_vilid '
                      + 'join genpays on pay_id = vil_payid '
                      + 'join artcodebarre join k on k_id = cbi_id and k_enabled = 1 on cbi_cltid = clt_id and cbi_type = 5 '
                      + 'left join genimport g1 on imp_ginkoia = clt_id and imp_num = 40 '
                      + 'left join genimport g2 on imp_ginkoia = clt_id and imp_num = 41 '
                      + 'join gentypcartefid on artcodebarre.cbi_tcfid = gentypcartefid.tcf_id '
                      + 'join k ktcf on ktcf.k_id = tcf_id and ktcf.k_enabled = 1 '
                      + 'where clt_id = ' + IntToStr(cltid) + ';';
    try
      que_Tmp.Open();
      if not que_Tmp.Eof then
      begin
        tmpDate := WsBaseClient.GetTime();
        tmpPassword := MD5(Entrelacement(tmpDate, WsPassword));
        try
          Adresse := TStringList.Create();
          Adresse.Text := que_Tmp.FieldByName('adr_ligne').AsString;
          while Adresse.Count < 4 do
            Adresse.Add('');
          // code qualité adresse
          if que_Tmp.FieldByName('CQA').IsNull then
            CQAAdresse := '60'
          else if que_Tmp.FieldByName('CQA').AsString = '' then
            CQAAdresse := '60'
          else
            CQAAdresse := que_Tmp.FieldByName('CQA').AsString;
          // code qualité email
          if que_Tmp.FieldByName('RET_EMAIL').IsNull then
            CQAemail := 'XXXXX'
          else if que_Tmp.FieldByName('RET_EMAIL').AsString = '' then
            CQAemail := 'XXXXX'
          else
            CQAemail := que_Tmp.FieldByName('RET_EMAIL').AsString;
          // Consentement commerciaux & Conditions générales de vente
          if que_Tmp.FieldByName('CstTel').IsNull then
            vCstTel := 0
          else
            vCstTel := que_Tmp.FieldByName('CstTel').AsInteger;
          if que_Tmp.FieldByName('CstMail').IsNull then
            vCstMail := 0
          else
            vCstMail := que_Tmp.FieldByName('CstMail').AsInteger;
          if que_Tmp.FieldByName('CstCgv').IsNull then
            vCstCgv := 0
          else
            vCstCgv := que_Tmp.FieldByName('CstCgv').AsInteger;
          if que_Tmp.FieldByName('CltDesactive').IsNull then
            vCltDesactive := 0
          else
            vCltDesactive := que_Tmp.FieldByName('CltDesactive').AsInteger;

          // passage au webservice
          Reponse := WsBaseClient.InfoClientMajCAP(Centrale,
                                                   tmpDate,
                                                   tmpPassword,
                                                   que_Tmp.FieldByName('cbi_cb').AsString,
                                                   CodeAdh,
                                                   que_Tmp.FieldByName('civ_nom').AsString,
                                                   que_Tmp.FieldByName('clt_nom').AsString,
                                                   que_Tmp.FieldByName('clt_prenom').AsString,
                                                   Adresse.Text,
                                                   // que_Tmp.FieldByName('adr_ligne').AsString + #13#10#13#10#13#10,
                                                   que_Tmp.FieldByName('vil_cp').AsString,
                                                   que_Tmp.FieldByName('vil_nom').AsString,
                                                   que_Tmp.FieldByName('pay_code').AsString,
                                                   que_Tmp.FieldByName('adr_tel').AsString,
                                                   que_Tmp.FieldByName('adr_gsm').AsString,
                                                   FormatDateTime('dd/mm/yyyy', que_Tmp.FieldByName('clt_naissance').AsDateTime),
                                                   que_Tmp.FieldByName('adr_email').AsString,
                                                   FormatDateTime('dd/mm/yyyy', wsr_date),
                                                   CQAemail,
                                                   CQAAdresse,
                                                   que_Tmp.FieldByName('tcf_type').AsInteger,
                                                   IntToStr(vCstTel),
                                                   IntToStr(vCstMail),
                                                   IntToStr(vCstCgv),
                                                   vCltDesactive
                                                  );
        finally
          FreeAndNil(Adresse);
        end;
        Result := Reponse.iErreur = 0;
        error := WR_REPONSE + Reponse.sMessage;
      end
      else
        error := 'Information du client (ID : ' + IntToStr(cltid) + ') non trouvé.';
    finally
      que_Tmp.Close();
      FreeAndNil(Reponse);
    end;
  except
    on e : Exception do
    begin
      Result := false;
      error := 'Exception : ' + e.ClassName + ' - ' + e.Message;
    end;
  end;
end;

function TDM_GSDataWebService.TraiteEnregistrementBonReduc(WsBaseClient : I_BaseClientNationale; WsPassword : string; magid, id : integer; idreduc : integer; out error : string) : boolean;
var
  tmpDate, tmpPassword : string;
  Reponse: TRemotableGnk;
  Centrale : integer;
  CodeAdh : string;
begin
  Result := false;
  error := '';
  if (WsBaseClient = nil) or (Trim(WsPassword) = '') then
  begin
    error := 'WebService ou mot de passe non renseigné.';
    Exit;
  end;
  try
    Centrale := GetCentrale(magid);
    CodeAdh := GetMagCodeAdh(magid);

    que_Tmp.SQL.Text := 'select cbi_cb, ofe_chrono, tke_numero, tke_date '
                      + 'from ofrgenetete join k on k_id = oge_id and k_enabled = 1 '
                      + 'join ofrtete on ofe_id =  oge_ofeid '
                      + 'join cshticket join k on k_id = tke_id and k_enabled = 1 on tke_id = oge_tkeid '
                      + 'join cltclient on clt_id = tke_cltid '
                      + 'join artcodebarre join k on k_id = cbi_id and k_enabled = 1 on cbi_cltid = clt_id and cbi_type = 5 '
                      + 'where oge_id = ' + IntToStr(idreduc) + ';';
    try
      que_Tmp.Open();
      if not que_Tmp.Eof then
      begin
        tmpDate := WsBaseClient.GetTime();
        tmpPassword := MD5(Entrelacement(tmpDate, WsPassword));
        Reponse := WsBaseClient.BonReducUtilise(Centrale,
                                                tmpDate,
                                                tmpPassword,
                                                que_Tmp.FieldByName('cbi_cb').AsString,
                                                que_Tmp.FieldByName('tke_numero').AsString,
                                                CodeAdh,
                                                FormatDateTime('dd/mm/yyyy', que_Tmp.FieldByName('tke_date').AsDateTime),
                                                que_Tmp.FieldByName('ofe_numero').AsString
                                               );
        Result := Reponse.iErreur = 0;
        error := WR_REPONSE + Reponse.sMessage;
      end
      else
        error := 'Information non recupéré.';
    finally
      que_Tmp.Close();
      FreeAndNil(Reponse);
    end;
  except
    on e : Exception do
    begin
      Result := false;
      error := 'Exception : ' + e.ClassName + ' - ' + e.Message;
    end;
  end;
end;

function TDM_GSDataWebService.TraiteUtilisationPalier(WsBaseClient : I_BaseClientNationale; WsPassword : string; magid, id : integer; idreduc : integer; out error : string) : boolean;
var
  tmpDate, tmpPassword : string;
  Reponse: TRemotableGnk;
  Centrale : integer;
  CodeAdh : string;
begin
  Result := false;
  error := '';
  if (WsBaseClient = nil) or (Trim(WsPassword) = '') then
  begin
    error := 'WebService ou mot de passe non renseigné.';
    Exit;
  end;
  try
    Centrale := GetCentrale(magid);
    CodeAdh := GetMagCodeAdh(magid);

    que_Tmp.SQL.Text := 'select ofe_copalierfid, cbi_cb '
                      + 'from ofrgenetete join k on k_id = oge_id and k_enabled = 1 '
                      + 'join ofrtete on ofe_id =  oge_ofeid '
                      + 'join cshticket join k on k_id = tke_id and k_enabled = 1 on tke_id = oge_tkeid '
                      + 'join cltclient on clt_id = tke_cltid '
                      + 'join artcodebarre join k on k_id = cbi_id and k_enabled = 1 on cbi_cltid = clt_id and cbi_type = 5 '
                      + 'where oge_id = ' + IntToStr(idreduc) + ';';
    try
      que_Tmp.Open();
      if not que_Tmp.Eof then
      begin
        tmpDate := WsBaseClient.GetTime();
        tmpPassword := MD5(Entrelacement(tmpDate, WsPassword));
        Reponse := WsBaseClient.PalierUtilise(Centrale,
                                              que_Tmp.FieldByName('ofe_copalierfid').AsInteger,
                                              tmpDate,
                                              tmpPassword,
                                              que_Tmp.FieldByName('cbi_cb').AsString,
                                              CodeAdh
                                             );
        Result := Reponse.iErreur = 0;
        error := WR_REPONSE + Reponse.sMessage;
      end
      else
        error := 'Information non recupéré.';
    finally
      que_Tmp.Close();
      FreeAndNil(Reponse);
    end;
  except
    on e : Exception do
    begin
      Result := false;
      error := 'Exception : ' + e.ClassName + ' - ' + e.Message;
    end;
  end;
end;

function TDM_GSDataWebService.FlagAsSuppr(id : integer) : boolean;
begin
  try
    Que_MAJ.IB_Transaction.StartTransaction();
    Que_MAJ.ParamByName('id').AsInteger := id;
    Que_MAJ.ExecSQL();
    Que_MAJ.IB_Transaction.Commit();
    result := true;
  except
    Que_MAJ.IB_Transaction.Rollback();
    result := false;
  end;
end;

end.
