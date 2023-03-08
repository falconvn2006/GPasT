//---------------------------- ATTENTION ----------------------------------------------
// cette unité est commune à GINKOIA et à l'utilitaire SRDFournisseur.dll.
// Si une modification est faite sur cette unité, merci de prévenir la personne
// en charge de ce projet qu'il faut mettre à jour dans les 2 projets.
//-------------------------------------------------------------------------------------

unit RefDynISF_DM;

interface

uses
  SysUtils,
  InvokeRegistry,
  DB,
  dxmdaset,
  Classes,
  Rio,
  SOAPHTTPClient,
  IBODataset,
  get_catalog_nosymag,
  DBClient,
  DateUtils,
  Math, StrUtils,
  Variants;

type
  EInterne = class(Exception);
  EItem = class(Exception);

  TWebResult = record
    IsOK : Boolean;
    artid : string;
    artnumero : string;
    textesimple : string;
    texte : TStringList;
    warning : TStringList;
  end;

  TRefDynISF_DM = class(TDataModule)
    HTTPRIO1: THTTPRIO;
    ClientDataSet: TClientDataSet;
    ClientDataSetmodele: TStringField;
    ClientDataSetmodelenumber: TStringField;
    ClientDataSetcouleur: TStringField;
    ClientDataSetcollection: TStringField;
{$IF CompilerVersion>=22}
    procedure HTTPRIO1BeforeExecute(const MethodName: string; SOAPRequest: TStream);
{$ELSE}
    procedure HTTPRIO1BeforeExecute(const MethodName: string; var SOAPRequest: WideString);
{$ifend}
    procedure HTTPRIO1AfterExecute(const MethodName: string; SOAPResponse: TStream);

  private
    Furl, Fuser, Fpwd, Frefart, Fcodemarque, Fcollection, Fcodeadh : WideString;
    FResponse : ZIMF_GET_CATALOGS_NOSYMAG_V2Response;
    FQuery : TIBOQuery;
    FpathExe : string;

    function Importation(ListeTraite : TStringList; Full : Boolean): TWebResult; overload;

  public
    constructor Create(query: TIBOQuery; url, login, password: WideString);   reintroduce;
    function CallWebservice(refart, codemarque, collection, codeadh: WideString) : TDataSet;
    function Importation(): TWebResult; overload;
    function Importation(ListeTraite : TStringList): TWebResult; overload;
    property PathExe : string write FpathExe;
  end;

var
  DM_RefDynISF: TRefDynISF_DM;

implementation

{$R *.dfm}

constructor TRefDynISF_DM.Create(query : TIBOQuery; url,login,password : WideString);
begin
  inherited Create(nil);

  Furl := url;
  Fuser := login;
  Fpwd := password;
  FQuery := query;
  FpathExe := '';
end;

procedure TRefDynISF_DM.HTTPRIO1AfterExecute(const MethodName: string; SOAPResponse: TStream);
var
  Fichier : TFileStream;
begin
  if FpathExe <> '' then
  begin
    try
      Fichier := TFileStream.Create(IncludeTrailingPathDelimiter(FpathExe) + 'Ret-' + FormatDateTime('yyyy-mm-dd_hh-nn-ss-zzz', Now()) + '.xml', fmCreate, fmShareDenyWrite);
      SOAPResponse.Seek(0, soFromBeginning);
      Fichier.CopyFrom(SOAPResponse, SOAPResponse.Size);
    finally
      FreeAndNil(Fichier);
    end;
  end;
end;

{$IF CompilerVersion>=22}
  procedure TRefDynISF_DM.HTTPRIO1BeforeExecute(const MethodName: string; SOAPRequest: TStream);
  var
    Fichier : TFileStream;
  begin
    if FpathExe <> '' then
    begin
      try
        Fichier := TFileStream.Create(IncludeTrailingPathDelimiter(FpathExe) + 'Ask-' + FormatDateTime('yyyy-mm-dd_hh-nn-ss-zzz', Now()) + '.xml', fmCreate, fmShareDenyWrite);
        SOAPRequest.Seek(0, soFromBeginning);
        Fichier.CopyFrom(SOAPRequest, SOAPRequest.Size);
      finally
        FreeAndNil(Fichier);
      end;
    end;
  end;
{$ELSE}
  procedure TRefDynISF_DM.HTTPRIO1BeforeExecute(const MethodName: string; var SOAPRequest: WideString);
  var MyText : TStringlist;
  begin
    // Correctopn Ereur Delphi 2007

    SOAPRequest := StringReplace(SOAPRequest,'<IsInput>','<IsInput xmlns="">',[]);

    //------------------------------
    if FpathExe <> '' then
    begin
      if not DirectoryExists(ExtractFilePath(FpathExe) + 'Logs') then
       ForceDirectories(ExtractFilePath(FpathExe) + 'Logs');
      MyText:=TStringList.Create;
      try
        MyText.Add(SOAPRequest);
        MyText.SaveToFile(IncludeTrailingPathDelimiter(FpathExe) + 'Ask-' + FormatDateTime('yyyy-mm-dd_hh-nn-ss-zzz', Now()) + '.xml');
      finally
        FreeAndNil(MyText);
      end;
    end;
  end;
{$ifend}

function TRefDynISF_DM.CallWebservice(refart, codemarque, collection, codeadh: WideString): TDataSet;
var
  vSaiso,vSaisj : string;
  vInput : ZIMF_GET_CATALOGS_NOSYMAG_V2;
  vClient : zimws_get_catalog_nosymag_v2;

  vCptmodele : Integer;
begin
  Frefart := refart;
  Fcodemarque := codemarque;
  Fcollection := collection;
  Fcodeadh := codeadh;

  if (Length(Fcollection) > 0) then
  begin
    vSaiso := Copy(Fcollection, 1, 2);
    vSaisj := Copy(Fcollection, 3, 4);
  end
  else
  begin
    vSaiso := '';
    vSaisj := '';
  end;

  vInput := ZIMF_GET_CATALOGS_NOSYMAG_V2.Create();
  vInput.IS_INPUT := ZIM_S_GET_CAT_NOSYMAG_INPUT.Create();
  vInput.IS_INPUT.Idnlf := Frefart;
  vInput.IS_INPUT.BRAND_ID := Fcodemarque;
  vInput.IS_INPUT.Saiso := vSaiso;
  vInput.IS_INPUT.Saisj := vSaisj;
  vInput.IS_INPUT.Sort1 := Fcodeadh;

  HTTPRIO1.HTTPWebNode.UserName := Fuser;
  HTTPRIO1.HTTPWebNode.Password := Fpwd;

  vClient := Getzimws_get_catalog_nosymag_v2(False, Furl, HTTPRIO1);

  FreeAndNil(FResponse);
  FResponse := vClient.ZIMF_GET_CATALOGS_NOSYMAG_V2(vInput);

  ClientDataSet.Close;
  ClientDataSet.Open;

  for vCptmodele := 0 to Length(FResponse.ES_CATALOGS.Cataloglist.Catalog.Modellist.Model) - 1 do
  begin
    ClientDataSet.Append;
    ClientDataSet.FieldByName('modele').AsString := FResponse.ES_CATALOGS.Cataloglist.Catalog.Modellist.Model[vCptmodele].Denotation;
    ClientDataSet.FieldByName('modelenumber').AsString := Trim(FResponse.ES_CATALOGS.Cataloglist.Catalog.Modellist.Model[vCptmodele].Modelnumber);
    ClientDataSet.FieldByName('couleur').AsString := Trim(FResponse.ES_CATALOGS.Cataloglist.Catalog.Modellist.Model[vCptmodele].Colorlist.Color.Colordenotation);
    ClientDataSet.FieldByName('collection').AsString := Trim(FResponse.ES_CATALOGS.Cataloglist.Catalog.Modellist.Model[vCptmodele].Coll);
    ClientDataSet.Post;
  end;

  Result := ClientDataSet;
end;

function TRefDynISF_DM.Importation(ListeTraite : TStringList; Full : Boolean): TWebResult;
var
  vFouid, vColid : Integer;

  vCptModel, vCptItem, vCptAttribut, vCpt : Integer;

  vModelErreur : Integer;
  vListeErreur, vListeInsert, vListeUpdate, vListeFusion, vListeWarning: TStringList;
  vTmp, vLastArtId, vLastArtNumero : string;
  vNewInsert : Integer;

  vModel : ZIM_S_NOSYMAG_MODEL;
  vItem : ZIM_S_NOSYMAG_ITEM;
{$IF CompilerVersion<22}
  vAttribut : item2;
{$ELSE}
  vAttribut : ZIM_S_NOSYMAG_MODELATTRIBUT;
{$ifend}
  Catalog : ZIM_S_NOSYMAG_CATALOG;
  vActif, vVisible, vModif, vCentrale, vCol : Integer;
  vAAT_ID, vAAV_ID : Integer;
  vPrixAchatGeneral : Currency;

  vPrixIncontournableOK : Integer;
begin
  try
    Result.IsOK := True;
    Result.artid := '';
    Result.artnumero := '';
    Result.textesimple := '';

    vModelErreur := 0;
    vListeErreur := TStringList.Create();
    vListeInsert := TStringList.Create();
    vListeUpdate := TStringList.Create();
    vListeFusion := TStringList.Create();
    vListeWarning := TStringList.Create();
    vTmp := '';
    vLastArtId := '';
    vLastArtNumero := '';

    vPrixIncontournableOK := 0;

    Catalog := FResponse.ES_CATALOGS.Cataloglist.Catalog;

    {$REGION 'fournisseur'}
    vFouid := -1;

    FQuery.SQL.Clear;
    FQuery.SQL.Add('SELECT FOU_ID FROM ARTFOURN');
    FQuery.SQL.Add('JOIN K ON K_ID=FOU_ID AND K_ENABLED=1');
    FQuery.SQL.Add('WHERE FOU_ERPNO=:SUPPLIERERP AND FOU_ACTIVE=1 AND FOU_CENTRALE=1');
    FQuery.ParamByName('SUPPLIERERP').AsString := catalog.Catalogadditional.Additional.Suppliererp;
    try
      FQuery.IB_Transaction.StartTransaction;
      FQuery.Open();

      if not FQuery.Eof then
        vFouid := FQuery.FieldByName('FOU_ID').AsInteger
      else
      begin
        FQuery.Close();
        FQuery.SQL.Clear;
        FQuery.SQL.Add('SELECT FOU_ID FROM ARTFOURN');
        FQuery.SQL.Add('JOIN K ON K_ID=FOU_ID AND K_ENABLED=1');
        FQuery.SQL.Add('WHERE FOU_CODE=:SUPPLIERCODE AND FOU_ACTIVE=1 AND FOU_CENTRALE=1');
        if(catalog.Catalogadditional.Additional.Supplierkey <> '') then
          FQuery.ParamByName('SUPPLIERCODE').AsString := catalog.Catalogadditional.Additional.Supplierkey
        else
          FQuery.ParamByName('SUPPLIERCODE').AsString := catalog.Supplierkey;
        FQuery.Open();

        if not FQuery.Eof then
          vFouid := FQuery.FieldByName('FOU_ID').AsInteger;
      end;
    finally
      FQuery.Close();
      FQuery.IB_Transaction.Rollback;
    end;

    if(vFouid <= 0) then
      raise EInterne.Create('Fournisseur introuvable');

    {$ENDREGION}


    for vCptModel:=0 to Length(Catalog.Modellist.Model) - 1 do
    begin
      vModel := Catalog.Modellist.Model[vCptModel];
      vNewInsert := 0;
      vPrixAchatGeneral := 0;

      if(Full or ((Assigned(ListeTraite)) and (ListeTraite.IndexOf(Trim(vModel.Modelnumber)+';'+Trim(vModel.Colorlist.Color.Colordenotation)+';'+Trim(vModel.Coll)) <> -1))) then
      begin
        try
          {$REGION 'Collection'}
            vColid := -1;

            FQuery.SQL.Clear;
            FQuery.SQL.Add('SELECT COL_ID FROM ARTCOLLECTION');
            FQuery.SQL.Add('JOIN K ON K_ID=COL_ID AND K_ENABLED=1');
            FQuery.SQL.Add('WHERE COL_CODE=:COLL AND COL_CENTRALE=1 AND COL_ACTIVE=1');
            FQuery.ParamByName('COLL').AsString := vModel.Coll;
            try
              FQuery.IB_Transaction.StartTransaction;
              FQuery.Open();

              if not FQuery.Eof then
                vColid := FQuery.FieldByName('COL_ID').AsInteger
            finally
              FQuery.Close();
              FQuery.IB_Transaction.Rollback;
            end;

            if(vColid <= 0) then
              raise EInterne.Create('Collection introuvable ' + vModel.Coll);

          {$ENDREGION}

          if (StrToFloat(StringReplace(vModel.Recommendedsalesprice.DecimalString, '.', DecimalSeparator, [])) <= 0) then
            raise EInterne.Create('Recommendedsalesprice incorrect');

          FQuery.SQL.Clear;
          FQuery.SQL.Add('select ARTID, ARFCHRONO, ERREUR, NEWINSERT from REFDYNINTERSPORT_NEWARTICLE( ');
          FQuery.SQL.Add(':SORT1,');
          FQuery.SQL.Add(':MODNUMBER,');
          FQuery.SQL.Add(':MODNUMBEROLD,');
          FQuery.SQL.Add(':MODNUMBEROLD2,');
          FQuery.SQL.Add(':MODNUMBEROLD3,');
          FQuery.SQL.Add(':MODNUMBEROLD4,');
          FQuery.SQL.Add(':MODNUMBEROLD5,');
          FQuery.SQL.Add(':BRANDNUMBER,');
          FQuery.SQL.Add(':MODDENOTATION,');
          FQuery.SQL.Add(':MODDENOTATIONLONG,');
          FQuery.SQL.Add(':FEDASOLD,');
          FQuery.SQL.Add(':FEDAS,');
          FQuery.SQL.Add(':UNIVERSCODEOLD,');
          FQuery.SQL.Add(':UNIVERSCODE,');
          FQuery.SQL.Add(':COLORNUMBER,');
          FQuery.SQL.Add(':COLORNUMBEROLD,');
          FQuery.SQL.Add(':COLORDENOTATION,');
          FQuery.SQL.Add(':COLUMNX,');
          FQuery.SQL.Add(':SIZELABEL,');
          FQuery.SQL.Add(':SIZERANGE,');
          FQuery.SQL.Add(':SMU,');
          FQuery.SQL.Add(':FOUID,');
          FQuery.SQL.Add(':EAN,');
          FQuery.SQL.Add(':PURCHASEPRICE,');
          FQuery.SQL.Add(':RECOMMENDEDSALEPRICE,');
          FQuery.SQL.Add(':VAT,');
          FQuery.SQL.Add(':COLLID,');
          FQuery.SQL.Add(':MODECREATION,');
          FQuery.SQL.Add(':PURCHASEPRICE_GENERAL,');
          FQuery.SQL.Add(':RECOMMENDEDSALEPRICE_GENERAL,');
          FQuery.SQL.Add(':NOMENCLATUREDOUANE,');
          FQuery.SQL.Add(':POIDS,');
          FQuery.SQL.Add(':ECOPARTICIPATION,');
          FQuery.SQL.Add(':ECOMOBILIER,');
          FQuery.SQL.Add(':CODEPAYS,');
          FQuery.SQL.Add(':CODEGENRE,');
          FQuery.SQL.Add(':PRIXINCONTOU,');
          FQuery.SQL.Add(':INCONTOUSTART,');
          FQuery.SQL.Add(':INCONTOUEND);');

          FQuery.ParamByName('SORT1').AsString := Fcodeadh;
          FQuery.ParamByName('MODNUMBER').AsString := vModel.MODELNUMBER;
          FQuery.ParamByName('MODNUMBEROLD').AsString := vModel.MODELNUMBEROLD;
          FQuery.ParamByName('MODNUMBEROLD2').AsString := vModel.MODELNUMBEROLD2;
          FQuery.ParamByName('MODNUMBEROLD3').AsString := vModel.MODELNUMBEROLD3;
          FQuery.ParamByName('MODNUMBEROLD4').AsString := vModel.MODELNUMBEROLD4;
          FQuery.ParamByName('MODNUMBEROLD5').AsString := vModel.MODELNUMBEROLD5;
          FQuery.ParamByName('BRANDNUMBER').AsString := vModel.Brandnumber;
          FQuery.ParamByName('MODDENOTATION').AsString := vModel.Denotation;
          FQuery.ParamByName('MODDENOTATIONLONG').AsString := vModel.Denotationlong;
          FQuery.ParamByName('FEDASOLD').AsString := vModel.FEDASOLD;
          FQuery.ParamByName('FEDAS').AsString := vModel.FEDAS;
          FQuery.ParamByName('UNIVERSCODEOLD').AsString := vModel.UNIVERSCODEOLD;
          FQuery.ParamByName('UNIVERSCODE').AsString := vModel.UNIVERSCODE;
          FQuery.ParamByName('COLORNUMBER').AsString := vModel.Colorlist.Color.COLORNUMBER;
          FQuery.ParamByName('COLORNUMBEROLD').AsString := vModel.Colorlist.Color.COLORNUMBEROLD;
          FQuery.ParamByName('COLORDENOTATION').AsString := vModel.Colorlist.Color.Colordenotation;
          FQuery.ParamByName('SIZERANGE').AsString := vModel.Sizerange;
          FQuery.ParamByName('FOUID').AsInteger := vFouid;
          FQuery.ParamByName('RECOMMENDEDSALEPRICE_GENERAL').AsFloat := StrToFloat(StringReplace(vModel.Recommendedsalesprice.DecimalString , '.', DecimalSeparator, []));
          FQuery.ParamByName('VAT').AsString := vModel.Vat;
          FQuery.ParamByName('COLLID').AsInteger := vColid;
          FQuery.ParamByName('NOMENCLATUREDOUANE').AsString := vModel.Nomenclaturedouaniere;
          FQuery.ParamByName('POIDS').AsString := StringReplace(vModel.Poids.DecimalString , '.', DecimalSeparator, []);
          FQuery.ParamByName('ECOPARTICIPATION').AsString := vModel.Ecoparticipation;
          FQuery.ParamByName('ECOMOBILIER').AsString := vModel.Ecomob;
          FQuery.ParamByName('CODEPAYS').AsString := vModel.Paysorigine;
          FQuery.ParamByName('CODEGENRE').AsString := vModel.ZZGENRE_AGE;

          if(StrToFloat(StringReplace(vModel.Salespriceisf.DecimalString , '.', DecimalSeparator, [])) > 0) then
          begin
            try
              if((VarToDateTime(vModel.Validto + ' 23:59:59') >= Now) and (VarToDateTime(vModel.Validfrom) <= VarToDateTime(vModel.Validto))) then
                vPrixIncontournableOK := 1
              else
                vPrixIncontournableOK := -1;
            except
              vPrixIncontournableOK := -1;
            end;
          end
          else
            vPrixIncontournableOK := 0;

          case vPrixIncontournableOK of
            0 :
              begin
                FQuery.ParamByName('PRIXINCONTOU').AsFloat := -1;
                FQuery.ParamByName('INCONTOUSTART').AsDate := Now;
                FQuery.ParamByName('INCONTOUEND').AsDate := Now;
              end;
            1 :
              begin
                FQuery.ParamByName('PRIXINCONTOU').AsFloat := StrToFloat(StringReplace(vModel.Salespriceisf.DecimalString , '.', DecimalSeparator, []));
                FQuery.ParamByName('INCONTOUSTART').AsDate := VarToDateTime(vModel.Validfrom);
                FQuery.ParamByName('INCONTOUEND').AsDate := VarToDateTime(vModel.Validto);
              end;
            -1 :
              begin
                vTmp := '      - ref ' + vModel.Modelnumber + ' : prix incontournable invalide (';
                vTmp := vTmp + 'px=' + StringReplace(vModel.Salespriceisf.DecimalString , '.', DecimalSeparator, []);
                vTmp := vTmp + '; from=' + vModel.Validfrom;
                vTmp := vTmp + '; to=' + vModel.Validto + ')';
                vListeWarning.Append(vTmp);
              end;
          end;

          for vCptItem := 0 to Length(vModel.Colorlist.Color.Itemlist.ITEM) - 1 do
          begin
            vItem := vModel.Colorlist.Color.Itemlist.ITEM[vCptItem];

            if(StrToFloat(StringReplace(vItem.PURCHASEPRICE.DecimalString , '.', DecimalSeparator, [])) <= 0) then
              raise EItem.Create('PURCHASEPRICE incorrect');
            if(StrToFloat(StringReplace(vItem.RETAILPRICE.DecimalString , '.', DecimalSeparator, [])) <= 0) then
              raise EItem.Create('RETAILPRICE incorrect');
            if(vPrixAchatGeneral = 0) then
              vPrixAchatGeneral := StrToFloat(StringReplace(vItem.PURCHASEPRICE.DecimalString , '.', DecimalSeparator, []));

            FQuery.ParamByName('COLUMNX').AsString := vItem.COLUMNX;
            FQuery.ParamByName('SIZELABEL').AsString := vItem.SIZELABEL;
            FQuery.ParamByName('SMU').AsString := vItem.SMU;
            FQuery.ParamByName('EAN').AsString := vItem.EAN;
            FQuery.ParamByName('PURCHASEPRICE').AsFloat := StrToFloat(StringReplace(vItem.PURCHASEPRICE.DecimalString , '.', DecimalSeparator, []));
            FQuery.ParamByName('PURCHASEPRICE_GENERAL').AsFloat := vPrixAchatGeneral;
            FQuery.ParamByName('RECOMMENDEDSALEPRICE').AsFloat := StrToFloat(StringReplace(vItem.RETAILPRICE.DecimalString , '.', DecimalSeparator, []));
            FQuery.ParamByName('MODECREATION').AsInteger := vNewInsert;
            try
              FQuery.IB_Transaction.StartTransaction;
              FQuery.Open;

              if not FQuery.IsEmpty then
              begin
                if FQuery.FieldByName('ERREUR').AsString = '' then
                begin
                  vNewInsert := max(vNewInsert,FQuery.FieldByName('NEWINSERT').AsInteger);
                  vLastArtId := FQuery.FieldByName('ARTID').AsString;
                  vLastArtNumero := FQuery.FieldByName('ARFCHRONO').AsString;

                  if vNewInsert > 0 then
                  begin
                    if vListeInsert.IndexOf(FQuery.FieldByName('ARFCHRONO').AsString) = -1 then
                      vListeInsert.Append(FQuery.FieldByName('ARFCHRONO').AsString);
                  end
                  else
                  begin
                    if vLastArtId = '0' then
                    begin
                      if vListeFusion.IndexOf(FQuery.FieldByName('ARFCHRONO').AsString) = -1 then
                        vListeFusion.Append(FQuery.FieldByName('ARFCHRONO').AsString);
                    end
                    else if vListeUpdate.IndexOf(FQuery.FieldByName('ARFCHRONO').AsString) = -1 then
                      vListeUpdate.Append(FQuery.FieldByName('ARFCHRONO').AsString);
                  end;
                end
                else
                  raise EItem.Create(FQuery.FieldByName('ERREUR').AsString);
              end
              else
                raise EItem.Create('Erreur procédure stockée');

              FQuery.Close;
              FQuery.IB_Transaction.Commit;
            except
              FQuery.IB_Transaction.Rollback;
              raise;
            end;
          end;

          if(vNewInsert > 0) then
          begin
            for vCptAttribut := 0 to Length(vModel.Modelattributlist.MODELATTRIBUT) - 1 do
            begin
              vAttribut := vModel.Modelattributlist.MODELATTRIBUT[vCptAttribut];

              if(Trim(vAttribut.ATTRIBUT) = '') then
                Continue;

              if(Trim(UpperCase(vAttribut.ATTRIBUT)) = 'PREMIERPRIX') then
                vActif := 0
              else
                vActif := 1;

              vVisible := 1;
              vModif := 0;
              vCentrale := 1;

              FQuery.SQL.Clear;
              FQuery.SQL.Add('SELECT * FROM MSS_SETATTRIBUTS(:PAATNOM, :PAATACTIF, :PAATVISIBLE, :PAATMODIF, :PAATCENTRALE, :PCANUPDATE)');
              FQuery.ParamByName('PAATNOM').AsString := Trim(UpperCase(vAttribut.ATTRIBUT));
              FQuery.ParamByName('PAATACTIF').AsInteger := vActif;
              FQuery.ParamByName('PAATVISIBLE').AsInteger := vVisible;
              FQuery.ParamByName('PAATMODIF').AsInteger := vModif;
              FQuery.ParamByName('PAATCENTRALE').AsInteger := vCentrale;
              FQuery.ParamByName('PCANUPDATE').AsInteger := 0;
              try
                FQuery.IB_Transaction.StartTransaction;
                FQuery.Open();
                vAAT_ID := FQuery.FieldByName('AAT_ID').AsInteger;
                FQuery.Close();
                FQuery.IB_Transaction.Commit;
              except
                FQuery.IB_Transaction.Rollback;
                raise EItem.Create('Echec création attribut "' + vAttribut.ATTRIBUT + '"');
              end;

              FQuery.SQL.Clear;
              FQuery.SQL.Add('Select * from MSS_SETARTATTRIBVAL(:PAAVAATID, :PAAVCODE, :PAAVNOM, :PAAVACTIF, :PAAVCENTRALE, :PCANUPDATE)');
              FQuery.ParamByName('PAAVAATID').AsInteger := vAAT_ID;
              FQuery.ParamByName('PAAVCODE').AsString := Trim(UpperCase(vAttribut.CODEVALEUR));
              FQuery.ParamByName('PAAVNOM').AsString := Trim(UpperCase(vAttribut.DENOTATIONVALEUR));
              FQuery.ParamByName('PAAVACTIF').AsInteger := 1;
              FQuery.ParamByName('PAAVCENTRALE').AsInteger := 1;
              FQuery.ParamByName('PCANUPDATE').AsInteger := 0;
              try
                FQuery.IB_Transaction.StartTransaction;
                FQuery.Open();
                vAAV_ID := FQuery.FieldByName('AAV_ID').AsInteger;
                FQuery.Close();
                FQuery.IB_Transaction.Commit;
              except
                FQuery.IB_Transaction.Rollback;
                raise EItem.Create('Echec création valeur attribut "' + vAttribut.ATTRIBUT + '"');
              end;

              // Recherche de l'attribut.
              FQuery.Close;
              FQuery.SQL.Clear;
              FQuery.SQL.Add('select AAT_COLLECTION');
              FQuery.SQL.Add('from ARTATTRIBUT');
              FQuery.SQL.Add('join K on (K_ID = AAT_ID and K_ENABLED = 1)');
              FQuery.SQL.Add('where AAT_NOM = :NOM');
              try
                FQuery.ParamByName('NOM').AsString := Trim(UpperCase(vAttribut.ATTRIBUT));
                FQuery.Open;
              except
                raise EItem.Create('Échec recherche attribut "' + Trim(UpperCase(vAttribut.ATTRIBUT)) + '"');
              end;
              if FQuery.IsEmpty then
                raise EItem.Create('Attribut "' + Trim(UpperCase(vAttribut.ATTRIBUT)) + '" inconnu')
              else
              begin
                if FQuery.FieldByName('AAT_COLLECTION').AsInteger = 0 then
                  vCol := 0
                else
                  vCol := vColid;
              end;

              FQuery.SQL.Clear;
              FQuery.SQL.Add('SELECT * FROM MSS_SETARTATTRIBRELATION(:PAARARTID, :PAARAATID, :PAARAAVID, :PAARCOLID, :PAARMAGID, :PAARDTDEB, :PAARDTFIN, :PAARCURRENT, :PCANUPDATE)');
              FQuery.ParamByName('PAARARTID').AsInteger := StrToInt(vLastArtId);
              FQuery.ParamByName('PAARAATID').AsInteger := vAAT_ID;
              FQuery.ParamByName('PAARAAVID').AsInteger := vAAV_ID;
              FQuery.ParamByName('PAARCOLID').AsInteger := vCol;
              FQuery.ParamByName('PAARMAGID').AsInteger := 0;
              FQuery.ParamByName('PAARDTDEB').AsDateTime := Now;
              FQuery.ParamByName('PAARDTFIN').AsDateTime := EncodeDateTime(2100,01,01,23,59,59,99);
              FQuery.ParamByName('PAARCURRENT').AsInteger := 1;
              FQuery.ParamByName('PCANUPDATE').AsInteger := 0;
              try
                FQuery.IB_Transaction.StartTransaction;
                FQuery.Open();
                FQuery.Close();
                FQuery.IB_Transaction.Commit;
              except
                FQuery.IB_Transaction.Rollback;
                raise EItem.Create('Echec création relation attribut "' + vAttribut.ATTRIBUT + '"');
              end;
            end;
          end;
        except
          on E: Exception do
          begin
            vTmp := '      - ref ' + vModel.Modelnumber;
            if(E.ClassType = EItem) then
              vTmp := vTmp + ', taille ' + vItem.SIZELABEL;
            vTmp := vTmp + ' : ' + E.Message;
            vListeErreur.Append(vTmp);
            Inc(vModelErreur);
          end;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      vListeErreur.Append('      - ' + E.Message);
      vModelErreur := Length(Catalog.Modellist.Model);
    end;
  end;

  if (vModelErreur > 0) then
  begin
    vListeErreur.Insert(0,IntToStr(vModelErreur) + ' modèle(s) en erreur :');
    Result.IsOK := False;
    Result.textesimple := IntToStr(vModelErreur) + ' erreur(s) : ' + vListeErreur[1];
  end
  else
    vListeErreur.Insert(0,'0 modèle en erreur');

  if(vListeFusion.Count > 0) then
  begin
    for vCpt := 0 to Pred(vListeFusion.Count) do
      vListeErreur.Insert(vCpt, '    ' + vListeFusion[vCpt]);
    vListeErreur.Insert(0, IntToStr(vListeFusion.Count) + IfThen(vListeFusion.Count > 1, ' modèles fusionnés non mis à jour :', ' modèle fusionné non mis à jour :'));
  end;

  if(vListeUpdate.Count > 0) then
  begin
    for vCpt := 0 to vListeUpdate.Count - 1 do
    begin
      vListeErreur.Insert(vCpt,'    ' + vListeUpdate[vCpt]);
    end;
    vListeErreur.Insert(0,IntToStr(vListeUpdate.Count) + ' modèle(s) mis à jour :');
  end;

  if (vListeInsert.Count > 0) then
  begin
    vTmp := IntToStr(vListeInsert.Count) + ' modèle(s) ajouté(s) : [' + vListeInsert[0] + ']';
    if(vListeInsert.Count > 1) then
      vTmp := vTmp + ' à [' + vListeInsert[vListeInsert.Count - 1] + ']';

    vListeErreur.Insert(0,vTmp);
  end;

  Result.artid := vLastArtId;
  Result.artnumero := vLastArtNumero;
  Result.texte := vListeErreur;
  Result.warning := vListeWarning;
end;

function TRefDynISF_DM.Importation(): TWebResult;
begin
  Result := Importation(nil,True);
end;

function TRefDynISF_DM.Importation(ListeTraite : TStringList): TWebResult;
begin
  Result := Importation(ListeTraite,False);
end;

end.
