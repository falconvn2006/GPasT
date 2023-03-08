unit uThreadImport;

interface

Uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Phys.IBDef, FireDAC.Stan.Def,
  FireDAC.Phys.IBWrapper, FireDAC.Phys.IBBase, FireDAC.Phys, FireDAC.Stan.Intf,
  FireDAC.Phys.IB, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Pool, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.StdCtrls, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, Vcl.ComCtrls, FireDAC.Phys.FBDef, FireDAC.Phys.FB, ShellAPi,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script, System.Win.Registry,
  Vcl.ExtCtrls, Math, UWMI, System.IniFiles, System.DateUtils,ServiceControler;

Type
  TStatusMessageCall = Procedure (const info:String) of object;
  TThreadImport = class(TThread)
  private
    FStatusProc    : TStatusMessageCall;
    FStatus        : string;
    FEASYInfos     : TEASYInfos;
    FTABLENAME     : string;
    FType          : string;
    FFileNameCSV   : TFileName;
    FFileNameDONE  : TFileName;
    FNbError       : integer;
   { Déclarations privées }
  protected
    procedure StatusCallBack();
    procedure Etape_DBImport();
    procedure Etape_Rename();
  public
    procedure Execute; override;
    constructor Create(aTABLENAME:string; aType:string;
      aStatusCallBack : TStatusMessageCall;
      const AEvent: TNotifyEvent = nil); reintroduce;
    property NbError : integer read FNbError;
  end;

  // un seul thread pour désactiver les index
  TThreadDesactivation = class(TThread)
  private
  { Déclarations privées }
    FStatusProc    : TStatusMessageCall;
    FStatus        : string;
    FEASYInfos     : TEASYInfos;
    FIBFile        : string;
    FNbError       : integer;
  protected
    procedure StatusCallBack();
    procedure Etape_SYMDS_DROP_TRIGGERS();
    procedure DesactiveTRIGGER(aTRGNAME:string);
    procedure DesactiveINDEX(aIDXNAME:string);
    function FileCsvExist(aTableNAME:string):Boolean;
    procedure Execute; override;
  public
    constructor Create(aIBFile:TFileName;
      aStatusCallBack : TStatusMessageCall;
      const aEvent:TNotifyEvent=nil); reintroduce;
    property NbError : integer read FNbError;
  end;

  // un seul thread pour désactiver les index
  TThreadReactivation = class(TThread)
  private
  { Déclarations privées }
    FStatusProc    : TStatusMessageCall;
    FStatus        : string;
    FIBFile        : string;
    FEASYInfos     : TEASYInfos;
    FNbError       : integer;
  protected
    procedure Etape_SYMDS_CREATE_TRIGGERS();
    procedure StatusCallBack();
    procedure ReActiveTRIGGER(aTRGNAME:string);
    procedure ReActiveINDEX(aIDXNAME:string); // Seulement s'il n'est pas déja activé....
    procedure Execute; override;
  public
    constructor Create(aIBFile:TFileName;
      aStatusCallBack : TStatusMessageCall;
      const aEvent:TNotifyEvent=nil); reintroduce;
    property NbError : integer read FNbError;
  end;


  TThreadActiveIndex = class(TThread)
  private
  { Déclarations privées }
    FStatusProc    : TStatusMessageCall;
    FStatus        : string;
    FIBFile        : string;
    FTABLENAME     : string;
    FListindex     : TStringList;
    FNbError       : integer;
  protected
    { -- }
    procedure ActiveTABLE_INDEX();
    procedure ActiveINDEX(aIDXNAME:string);
    procedure StatusCallBack();
    procedure ListingIndex();
  public
    procedure Execute; override;
    constructor Create(aIBFile:TFileName;aTABLENAME:string;
        aStatusCallBack : TStatusMessageCall;
        const AEvent: TNotifyEvent = nil); reintroduce;
    property NbError : integer read FNbError;
  end;

implementation

Uses uProcess,UDataMod;

{ ---------------------------- TThreadImport ------------------------------------- }

constructor TThreadImport.Create(aTABLENAME:string; aType:string;
  aStatusCallBack : TStatusMessageCall;
  const AEvent: TNotifyEvent = nil);
begin
  inherited Create(true);
  FreeOnTerminate := true;
  FStatusProc     := aStatusCallBack;
  FTABLENAME      := UpperCase(aTableName);
  FType           := aType;
  FFileNameCSV    := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+  aType +'\' + aTableName + '.csv';
  FFileNameDone   := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+  aType +'\' + aTableName + '.done';

  FEASYInfos      := WMI_GetServicesEASY;
  OnTerminate     := AEvent;
end;

procedure TThreadImport.Etape_Rename();
var chaine:string;
    merror:string;
    a:cardinal;
begin
     try
        try
          If not(RenameFile(FFileNameCSV, FFileNameDone))
            then
              begin
                raise Exception.Create('Erreur au renommage');
              end;
          // FStatus:=Format('Renommage de la base %s en %s : [OK]',[ExtractFileName(FGINKOIA_IB),ExtractFileName(FSAV)]);
          // Synchronize(StatusCallBack);
        Except On E:Exception do
          begin
            inc(FnbError);
            raise;
          end;
        end;
     finally
        // Synchronize(StatusCallBack);
     end;
end;

procedure TThreadImport.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;


procedure TThreadImport.Etape_DBImport();
var vParams:string;
    vCall:string;
    merror  : string;
    a       : cardinal;
begin
    // dbimport %s --force --format=CSV --table %s
    FStatus := Format('Import %s / %s',[FTABLENAME,FType]);
    Synchronize(StatusCallBack);
    try
      vParams := Format('%s --force --format=CSV --table %s',[FFileNameCSV,FTABLENAME,FTABLENAME]);
      vCall   := Format('%s\bin\dbimport.bat',[FEASYInfos.Directory]);
      a:=ExecAndWaitProcess(merror,vCall,vParams);
      FStatus := merror;
    finally

    end;
end;

procedure TThreadImport.Execute;
begin
  try
    try
      // GetInfos();
      if FileExists(FFileNameCSV)
        then
          begin
            Etape_DBImport();
            Etape_Rename();
          end
      else
        begin

          // Fichier pas là !
        end;
    Except
      //
    end;
  finally
  end;
end;

constructor TThreadActiveIndex.Create(aIBFile:TFileName;aTABLENAME:string;
    aStatusCallBack : TStatusMessageCall;
    Const AEvent: TNotifyEvent = nil);
begin
  inherited Create(true);
  FreeOnTerminate := true;
  FIBFile     := aIBFile;
  FTableName  := aTableName;
  FStatusProc := aStatusCallBack;
  FListindex  := TStringList.Create();
  OnTerminate := AEvent;
end;


procedure TThreadActiveIndex.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;


procedure TThreadActiveIndex.ActiveTABLE_INDEX();
var i:integer;
begin
  for I := 0 to FListindex.Count-1 do
    begin
        ActiveINDEX(FListindex.Strings[i]);
    end;
end;

procedure TThreadActiveIndex.ActiveINDEX(aIDXNAME:string);
var vCnx:TFDConnection;
    vQuery:TFDQuery;
begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FIBFile);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    try
      try
        FStatus := Format('Activation Index %s',[aIDXNAME]);
        Synchronize(StatusCallBack);

        vQuery.Close;
        vQuery.SQL.Clear;
        vQuery.SQL.Add(Format('ALTER INDEX %s ACTIVE;',[UpperCase(aIDXNAME)]));
        vQuery.ExecSQL;
        vQuery.Close;
      Except
        raise Exception.Create('Erreur Activation Index');
      end;
    finally
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;


procedure TThreadActiveIndex.ListingIndex();
var vCnx:TFDConnection;
    vQuery:TFDQuery;
begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FIBFile);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    try
      try
        vQuery.Close;
        vQuery.SQL.Clear;
        vQuery.SQL.Add('SELECT RDB$INDEX_NAME FROM RDB$INDICES WHERE RDB$RELATION_NAME=:TABLE_NAME AND RDB$INDEX_INACTIVE=1');
        vQuery.ParamByName('TABLE_NAME').asstring := FTABLENAME;
        vQuery.Open();
        while not(vQuery.eof) do
          begin
            FListindex.Add(vQuery.FieldByName('RDB$INDEX_NAME').AsString);
            vQuery.Next;
          end;
        vQuery.Close;
      Except

      end;
    finally
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;

procedure TThreadActiveIndex.Execute;
begin
  try
    try
      // On passe en actif uniquement ceux qui ne sont pas déjà activés !!
      ListingIndex();
      ActiveTABLE_INDEX();

    Except
      //
    end;
  finally
  end;
end;


constructor TThreadDesActivation.Create(aIBFile:TFileName;
    aStatusCallBack : TStatusMessageCall;
    Const aEvent:TNotifyEvent=nil);
begin
  inherited Create(true);
  FNbError        := 0;
  FIBFile         := aIBFILE;
  FStatusProc     := aStatusCallBack;
  FEASYInfos      := WMI_GetServicesEASY;

  FreeOnTerminate := true;

  OnTerminate := AEvent;

end;

procedure TThreadReActivation.Execute;
begin
  try
    try
      FStatus:='Désactivation des Triggers';
      Synchronize(StatusCallBack);
      ReActiveTrigger('AGRRAL_AD');
      ReActiveTrigger('ARTCODEBARRE_AI');
      ReActiveTrigger('ARTCOLART_AI');
      ReActiveTrigger('ARTRECALCULE_AI');
      ReActiveTrigger('ARTRELATIONAXE_AI');
      ReActiveTrigger('CLTCLIENT_AD');
      ReActiveTrigger('CLTCLIENT_AI');
      ReActiveTrigger('CLTCLIENT_AU');
      ReActiveTrigger('GENHISTOEVT_AI0');
      ReActiveTrigger('GENPOSTE_BECOLLECTOR_AI');
      ReActiveTrigger('INVENTETEL_AI');
      ReActiveTrigger('INVSESSIONL_AI');
      ReActiveTrigger('LOCNKCOMPOSITION_BI');
      ReActiveTrigger('LOCNKFAMILLE_ID_BI');
      ReActiveTrigger('LOCNKRAYON_ID_BI');
      ReActiveTrigger('LOCRESERVATIONSOUSLIGNE_BI');
      ReActiveTrigger('MAJ_CLTBONACHAT_BI');
      ReActiveTrigger('MAJ_CLTBONACHAT_BU');
      ReActiveTrigger('MAJ_CLTFIDELITE_BI');
      ReActiveTrigger('MAJ_CLTFIDELITE_BU');
      ReActiveTrigger('MAJ_CLTIDPRO_FCE_I');
      ReActiveTrigger('MAJ_CLTPASS_FCE_I');
      ReActiveTrigger('MAJ_CLTPASS_TKE_I');
      ReActiveTrigger('MAJ_DATECESSION_ARL_U');
      ReActiveTrigger('MAJ_ENSEIGNE_AU');
      ReActiveTrigger('MAJ_HISTOSTA_ARL_U');
      ReActiveTrigger('MAJ_KTBL_K_U');
      ReActiveTrigger('MAJ_LOC_RSLIDENT_BI');
      ReActiveTrigger('MAJ_NUM_RVS_BI');
      ReActiveTrigger('MAJ_STKPUMP_BL_I');
      ReActiveTrigger('MAJ_STKPUMP_BL_U');
      ReActiveTrigger('MAJ_STKPUMP_BR_I');
      ReActiveTrigger('MAJ_STKPUMP_BR_U');
      ReActiveTrigger('MAJ_STKPUMP_BT_I');
      ReActiveTrigger('MAJ_STKPUMP_BT_U');
      ReActiveTrigger('MAJ_STKPUMP_CD_I');
      ReActiveTrigger('MAJ_STKPUMP_CD_U');
      ReActiveTrigger('MAJ_STKPUMP_FAC_I');
      ReActiveTrigger('MAJ_STKPUMP_FAC_U');
      ReActiveTrigger('MAJ_STKPUMP_RET_I');
      ReActiveTrigger('MAJ_STKPUMP_RET_U');
      ReActiveTrigger('MAJ_STKPUMP_TKE_I');
      ReActiveTrigger('MAJ_STKPUMP_TKE_U');
      ReActiveTrigger('MAJ_TARCLGFOURN_I');
      ReActiveTrigger('MAJ_TARPXVENTE_I');
      ReActiveTrigger('MAJ_WEBRAL_I');
      ReActiveTrigger('MAJ_WEBRAL_U');
      ReActiveTrigger('MIGRESUPCB_AI');
      ReActiveTrigger('"Maj_RAL_ANNUL_I"');
      ReActiveTrigger('"Maj_RAL_ANNUL_U"');
      ReActiveTrigger('"Maj_RAL_BCDE_I"');
      ReActiveTrigger('"Maj_RAL_BCDE_U"');
      ReActiveTrigger('"Maj_RAL_BR_U"');
      ReActiveTrigger('NEGBL_BI');
      ReActiveTrigger('NEGDEVIS_BI');
      ReActiveTrigger('NEGFACTURE_BI');
      ReActiveTrigger('PLXCOULEUR_AI');
      ReActiveTrigger('PLXTAILLESTRAV_AI');
      ReActiveTrigger('PLXTAILLESTRAV_REF_AI');
      ReActiveTrigger('SUPPR_TARIFTO_LMT_I');
      ReActiveTrigger('UILGRPGINKOIAMAG_AI');
      ReActiveTrigger('UILUSERS_AI');

      FStatus:='RéActivation des INDEX';
      Synchronize(StatusCallBack);

      // Table K
      ReActiveINDEX('K_2');
      ReActiveINDEX('K_3');
      ReActiveINDEX('IDX_K_KRH_ID');
      ReActiveINDEX('IDX_K_KTB_ID');
      ReActiveINDEX('IDX_K_K_VERSION');
      // AGRHISTOSTOCK
      ReActiveINDEX('AGRHISTOSTOCK_IDX1');
      ReActiveINDEX('INX_AGRSTAT2');
      ReActiveINDEX('IDX_AGRMVT_ARTICLE');

      // AGRMOUVEMENT
      ReActiveINDEX('AGRMOUVEMENT_IDX1');
      ReActiveINDEX('AGRMOUVEMENT_IDX3');
      ReActiveINDEX('IDX_AGRMVT_CLTID');
      ReActiveINDEX('IDX_AGRMVT_MVTLIG');
      ReActiveINDEX('IDX_AGRMVT_CLTID');
      ReActiveINDEX('IDX_AGRMVT_MVTLIG');

      // CSHTICKETL
      ReActiveINDEX('INX_CSHTKLGENE');
      ReActiveINDEX('INX_CSHTKLLOTID');
      ReActiveINDEX('INX_CSHTKLSTAT');
      ReActiveINDEX('INX_CSHTKLTKEID');

      // ARTCODEBARRE
      ReActiveINDEX('INX_ARTCBIARLID');
      ReActiveINDEX('INX_ARTCBICB');
      ReActiveINDEX('INX_ARTCBICLT');
      ReActiveINDEX('INX_ARTCBIMATID');

      // CLTCLIENT
      ReActiveINDEX('IDX_CLTMAGIDPF');
      ReActiveINDEX('INX_CLTCLTADRID');
      ReActiveINDEX('INX_CLTCLTAFADRID');
      ReActiveINDEX('INX_CLTCLTCIVID');
      ReActiveINDEX('INX_CLTCLTCLTID');
      ReActiveINDEX('INX_CLTCLTCPAID');
      ReActiveINDEX('INX_CLTCLTGCLID');
      ReActiveINDEX('INX_CLTCLTICLID1');
      ReActiveINDEX('INX_CLTCLTICLID2');
      ReActiveINDEX('INX_CLTCLTICLID3');
      ReActiveINDEX('INX_CLTCLTICLID4');
      ReActiveINDEX('INX_CLTCLTICLID5');
      ReActiveINDEX('INX_CLTCLTIDTHEO');
      ReActiveINDEX('INX_CLTCLTMRGID');
      ReActiveINDEX('INX_CLTCLTPRENOM');
      ReActiveINDEX('INX_CLTENFANT');
      ReActiveINDEX('INX_CLTIDDESC');
      ReActiveINDEX('INX_CLTIDREF');
      ReActiveINDEX('INX_CLTRECH');
      ReActiveINDEX('INX_CLTTYPE');

      // GENIMPORT
      ReActiveINDEX('INX_GENCHERCHE');
      ReActiveINDEX('INX_GENIMPORT');

      // CSHTICKET
      ReActiveINDEX('INX_CSHTKECHEFCLTID');
      ReActiveINDEX('INX_CSHTKECLTID');
      ReActiveINDEX('INX_CSHTKECTEID');
      ReActiveINDEX('INX_CSHTKEDPV');
      ReActiveINDEX('INX_CSHTKENUM');
      ReActiveINDEX('INX_CSHTKESEQUENCE');
      ReActiveINDEX('INX_CSHTKEUSRID');

      // RECBRL
      ReActiveINDEX('INX_BRLBRCID');
      ReActiveINDEX('INX_RECBRLART');
      ReActiveINDEX('INX_RECBRLCDLID');
      ReActiveINDEX('INX_RECBRLRPEID');



      Etape_SYMDS_CREATE_TRIGGERS();

    Except
      On E:Exception
        do
           begin
             FStatus := 'Erreur' + E.Message;
             Synchronize(StatusCallBack);
             Inc(FNbError);
             raise;
           end;
    end;
  finally

  end;
end;


procedure TThreadReActivation.Etape_SYMDS_CREATE_TRIGGERS();
var vParams:string;
    vCall:string;
    merror  : string;
    a       : cardinal;
begin
    // dbimport %s --force --format=CSV --table %s
    FStatus := 'Réactivation des Triggers SYMDS';
    Synchronize(StatusCallBack);
    try
      vParams := 'sync-triggers';
      vCall   := Format('%s\bin\symadmin.bat',[FEASYInfos.Directory]);
      a:=ExecAndWaitProcess(merror,vCall,vParams);
      FStatus := merror;
    finally

    end;
end;




procedure TThreadReActivation.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;

procedure TThreadReActivation.ReActiveTRIGGER(aTRGNAME:string);
var vCnx:TFDConnection;
    vQuery:TFDQuery;
begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FIBFile);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    try
      try
        FStatus := Format('Activation Trigger %s',[aTRGNAME]);
        Synchronize(StatusCallBack);
        vQuery.Close;
        vQuery.SQL.Clear;
        vQuery.SQL.Add(Format('ALTER TRIGGER %s ACTIVE;',[aTRGNAME]));
        vQuery.OptionsIntf.UpdateOptions.ReadOnly := False;
        vQuery.ExecSQL;
        vQuery.Close;
      Except

      end;
    finally
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;

procedure TThreadReActivation.ReActiveINDEX(aIDXNAME:string);
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    vDoActive : Boolean;
begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FIBFile);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    try
      try
        FStatus := Format('RéActivation Index %s',[aIDXNAME]);
        Synchronize(StatusCallBack);

        // On réactive seulement s'il n'est pas déja actif.....
        vQuery.Close;
        vQuery.SQL.Clear;
        vQuery.SQL.Add('SELECT RDB$INDEX_NAME FROM RDB$INDICES WHERE RDB$INDEX_NAME=:IDXNAME AND RDB$INDEX_INACTIVE=1');
        vQuery.ParamByName('IDXNAME').AsString := aIDXNAME;
        vQuery.Open();
        vDoActive := false;
        if not(vQuery.IsEmpty) then
          begin
            vDoActive := true;
          end;

        if vDoActive then
          begin
            FStatus := Format('Ré-Activation Index %s : ...',[aIDXNAME]);
            Synchronize(StatusCallBack);
            vQuery.Close;
            vQuery.SQL.Clear;
            vQuery.SQL.Add(Format('ALTER INDEX %s ACTIVE;',[UpperCase(aIDXNAME)]));
            vQuery.OptionsIntf.UpdateOptions.ReadOnly := False;
            vQuery.ExecSQL;
            vQuery.Close;
            FStatus := Format('Ré-Activation Index %s : OK',[aIDXNAME]);
            Synchronize(StatusCallBack);
          end
          else
            begin
              FStatus := Format('Ré-Activation Index %s => pas la peine déjà actif.',[aIDXNAME]);
              Synchronize(StatusCallBack);
            end;
          
      Except
         On E:Exception do
          begin 
             FStatus := Format('Erreur Ré-Activation Index %s : %s',[aIDXNAME,E.Message]);
             Synchronize(StatusCallBack);
          end;
      end;
    finally
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;


constructor TThreadReActivation.Create(aIBFile:TFileName;
    aStatusCallBack : TStatusMessageCall;
    Const aEvent:TNotifyEvent=nil);
begin
  inherited Create(true);
  FNbError        := 0;
  FIBFile         := aIBFILE;
  FStatusProc     := aStatusCallBack;
  FEASYInfos      := WMI_GetServicesEASY;
  FreeOnTerminate := true;
  OnTerminate := AEvent;
end;

procedure TThreadDesActivation.Execute;
var vNBT:integer;
begin
  try
    try
      if ServiceGetStatus(PChar(''),PChar('EASY'))=4
        then
          begin
            If ServiceStop('','EASY') then
              raise Exception.Create('Impossible d''arrêter le Service');
          end;
      if ServiceGetStatus(PChar(''),PChar('EASY'))<>1
        then
          begin
             raise Exception.Create('Erreur sur le Service EASY');
          end;

      FStatus:='Désactivation des Triggers GINKOIA';
      Synchronize(StatusCallBack);
      DesactiveTrigger('AGRRAL_AD');
      DesactiveTrigger('ARTCODEBARRE_AI');
      DesactiveTrigger('ARTCOLART_AI');
      DesactiveTrigger('ARTRECALCULE_AI');
      DesactiveTrigger('ARTRELATIONAXE_AI');
      DesactiveTrigger('CLTCLIENT_AD');
      DesactiveTrigger('CLTCLIENT_AI');
      DesactiveTrigger('CLTCLIENT_AU');
      DesactiveTrigger('GENHISTOEVT_AI0');
      DesactiveTrigger('GENPOSTE_BECOLLECTOR_AI');
      DesactiveTrigger('INVENTETEL_AI');
      DesactiveTrigger('INVSESSIONL_AI');
      DesactiveTrigger('LOCNKCOMPOSITION_BI');
      DesactiveTrigger('LOCNKFAMILLE_ID_BI');
      DesactiveTrigger('LOCNKRAYON_ID_BI');
      DesactiveTrigger('LOCRESERVATIONSOUSLIGNE_BI');
      DesactiveTrigger('MAJ_CLTBONACHAT_BI');
      DesactiveTrigger('MAJ_CLTBONACHAT_BU');
      DesactiveTrigger('MAJ_CLTFIDELITE_BI');
      DesactiveTrigger('MAJ_CLTFIDELITE_BU');
      DesactiveTrigger('MAJ_CLTIDPRO_FCE_I');
      DesactiveTrigger('MAJ_CLTPASS_FCE_I');
      DesactiveTrigger('MAJ_CLTPASS_TKE_I');
      DesactiveTrigger('MAJ_DATECESSION_ARL_U');
      DesactiveTrigger('MAJ_ENSEIGNE_AU');
      DesactiveTrigger('MAJ_HISTOSTA_ARL_U');
      DesactiveTrigger('MAJ_KTBL_K_U');
      DesactiveTrigger('MAJ_LOC_RSLIDENT_BI');
      DesactiveTrigger('MAJ_NUM_RVS_BI');
      DesactiveTrigger('MAJ_STKPUMP_BL_I');
      DesactiveTrigger('MAJ_STKPUMP_BL_U');
      DesactiveTrigger('MAJ_STKPUMP_BR_I');
      DesactiveTrigger('MAJ_STKPUMP_BR_U');
      DesactiveTrigger('MAJ_STKPUMP_BT_I');
      DesactiveTrigger('MAJ_STKPUMP_BT_U');
      DesactiveTrigger('MAJ_STKPUMP_CD_I');
      DesactiveTrigger('MAJ_STKPUMP_CD_U');
      DesactiveTrigger('MAJ_STKPUMP_FAC_I');
      DesactiveTrigger('MAJ_STKPUMP_FAC_U');
      DesactiveTrigger('MAJ_STKPUMP_RET_I');
      DesactiveTrigger('MAJ_STKPUMP_RET_U');
      DesactiveTrigger('MAJ_STKPUMP_TKE_I');
      DesactiveTrigger('MAJ_STKPUMP_TKE_U');
      DesactiveTrigger('MAJ_TARCLGFOURN_I');
      DesactiveTrigger('MAJ_TARPXVENTE_I');
      DesactiveTrigger('MAJ_WEBRAL_I');
      DesactiveTrigger('MAJ_WEBRAL_U');
      DesactiveTrigger('MIGRESUPCB_AI');
      DesactiveTrigger('"Maj_RAL_ANNUL_I"');
      DesactiveTrigger('"Maj_RAL_ANNUL_U"');
      DesactiveTrigger('"Maj_RAL_BCDE_I"');
      DesactiveTrigger('"Maj_RAL_BCDE_U"');
      DesactiveTrigger('"Maj_RAL_BR_U"');
      DesactiveTrigger('NEGBL_BI');
      DesactiveTrigger('NEGDEVIS_BI');
      DesactiveTrigger('NEGFACTURE_BI');
      DesactiveTrigger('PLXCOULEUR_AI');
      DesactiveTrigger('PLXTAILLESTRAV_AI');
      DesactiveTrigger('PLXTAILLESTRAV_REF_AI');
      DesactiveTrigger('SUPPR_TARIFTO_LMT_I');
      DesactiveTrigger('UILGRPGINKOIAMAG_AI');
      DesactiveTrigger('UILUSERS_AI');

      FStatus:='Désactivation des INDEX';
      Synchronize(StatusCallBack);

      Etape_SYMDS_DROP_TRIGGERS();

      // Table K
      DesactiveINDEX('K_2');
      DesactiveINDEX('K_3');
      DesactiveINDEX('IDX_K_KRH_ID');
      DesactiveINDEX('IDX_K_KTB_ID');
      DesactiveINDEX('IDX_K_K_VERSION');

      // AGRHISTOSTOCK
      DesactiveINDEX('AGRHISTOSTOCK_IDX1');
      DesactiveINDEX('INX_AGRSTAT2');
      DesactiveINDEX('IDX_AGRMVT_ARTICLE');

      // AGRMOUVEMENT
      DesactiveINDEX('AGRMOUVEMENT_IDX1');
      DesactiveINDEX('AGRMOUVEMENT_IDX3');
      DesactiveINDEX('IDX_AGRMVT_CLTID');
      DesactiveINDEX('IDX_AGRMVT_MVTLIG');
      DesactiveINDEX('IDX_AGRMVT_CLTID');
      DesactiveINDEX('IDX_AGRMVT_MVTLIG');

      // CSHTICKETL
      DesactiveINDEX('INX_CSHTKLGENE');
      DesactiveINDEX('INX_CSHTKLLOTID');
      DesactiveINDEX('INX_CSHTKLSTAT');
      DesactiveINDEX('INX_CSHTKLTKEID');

      // ARTCODEBARRE
      DesactiveINDEX('INX_ARTCBIARLID');
      DesactiveINDEX('INX_ARTCBICB');
      DesactiveINDEX('INX_ARTCBICLT');
      DesactiveINDEX('INX_ARTCBIMATID');

      // CLTCLIENT
      DesactiveINDEX('IDX_CLTMAGIDPF');
      DesactiveINDEX('INX_CLTCLTADRID');
      DesactiveINDEX('INX_CLTCLTAFADRID');
      DesactiveINDEX('INX_CLTCLTCIVID');
      DesactiveINDEX('INX_CLTCLTCLTID');
      DesactiveINDEX('INX_CLTCLTCPAID');
      DesactiveINDEX('INX_CLTCLTGCLID');
      DesactiveINDEX('INX_CLTCLTICLID1');
      DesactiveINDEX('INX_CLTCLTICLID2');
      DesactiveINDEX('INX_CLTCLTICLID3');
      DesactiveINDEX('INX_CLTCLTICLID4');
      DesactiveINDEX('INX_CLTCLTICLID5');
      DesactiveINDEX('INX_CLTCLTIDTHEO');
      DesactiveINDEX('INX_CLTCLTMRGID');
      DesactiveINDEX('INX_CLTCLTPRENOM');
      DesactiveINDEX('INX_CLTENFANT');
      DesactiveINDEX('INX_CLTIDDESC');
      DesactiveINDEX('INX_CLTIDREF');
      DesactiveINDEX('INX_CLTRECH');
      DesactiveINDEX('INX_CLTTYPE');

      // GENIMPORT
      DesactiveINDEX('INX_GENCHERCHE');
      DesactiveINDEX('INX_GENIMPORT');

      // CSHTICKET
      DesactiveINDEX('INX_CSHTKECHEFCLTID');
      DesactiveINDEX('INX_CSHTKECLTID');
      DesactiveINDEX('INX_CSHTKECTEID');
      DesactiveINDEX('INX_CSHTKEDPV');
      DesactiveINDEX('INX_CSHTKENUM');
      DesactiveINDEX('INX_CSHTKESEQUENCE');
      DesactiveINDEX('INX_CSHTKEUSRID');

      // RECBRL
      DesactiveINDEX('INX_BRLBRCID');
      DesactiveINDEX('INX_RECBRLART');
      DesactiveINDEX('INX_RECBRLCDLID');
      DesactiveINDEX('INX_RECBRLRPEID');

      // Si il reste des Triggers c'est Mauvais....
      vNBT := DataMod.NbTriggersGINKOIA_Actifs(FIBFile);
      If vNBT>0
        then raise Exception.Create(Format('Il reste des triggers : %d',[vNBT]));

      Sleep(5000);

    Except
      On E:Exception
        do
           begin
             FStatus := 'Erreur' + E.Message;
             Synchronize(StatusCallBack);
             Inc(FNbError);
             raise;
           end;
    end;
  finally

  end;
end;

procedure TThreadDesActivation.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;

procedure TThreadDesActivation.Etape_SYMDS_DROP_TRIGGERS();
var vParams:string;
    vCall:string;
    merror  : string;
    a       : cardinal;
begin
    // dbimport %s --force --format=CSV --table %s
    FStatus := 'Suppression des Triggers SYMDS';
    Synchronize(StatusCallBack);
    try
      vParams := 'drop-triggers';
      vCall   := Format('%s\bin\symadmin.bat',[FEASYInfos.Directory]);
      a:=ExecAndWaitProcess(merror,vCall,vParams);
      FStatus := merror;
      Sleep(5000);
    finally

    end;
end;

procedure TThreadDesActivation.DesactiveTRIGGER(aTRGNAME:string);
var vCnx:TFDConnection;
    vQuery:TFDQuery;
begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FIBFile);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    try
      try
        FStatus := Format('Désactivation Trigger %s',[aTRGNAME]);
        Synchronize(StatusCallBack);
        vQuery.Close;
        vQuery.SQL.Clear;
        vQuery.SQL.Add(Format('ALTER TRIGGER %s INACTIVE;',[aTRGNAME]));
        vQuery.OptionsIntf.UpdateOptions.ReadOnly := False;
        vQuery.ExecSQL;
        vQuery.Close;
      Except

      end;
    finally
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;

function TThreadDesActivation.FileCsvExist(aTableNAME:string):Boolean;
var vRef, vNew,vAgr:boolean;
begin
    vRef := FileExists(Format('%s\ref\%s.csv',[ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))),aTableNAME]));
    vNew := FileExists(Format('%s\new\%s.csv',[ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))),aTableNAME]));
    vAgr := FileExists(Format('%s\agr\%s.csv',[ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))),aTableNAME]));

    result := vREF or vNew or vAgr;
end;


procedure TThreadDesActivation.DesActiveINDEX(aIDXNAME:string);
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    vTABLENAME : string;
begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FIBFile);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    try
      try
        // FStatus := Format('Désactivation Index %s',[aIDXNAME]);
        // Synchronize(StatusCallBack);

        // Recup de la TABLE
        vQuery.Close;
        vQuery.SQL.Clear;
        vQuery.SQL.Add('SELECT RDB$RELATION_NAME FROM RDB$INDICES WHERE RDB$INDEX_NAME=:IDX_NAME ');
        vQuery.ParamByName('IDX_NAME').asstring := aIDXNAME;
        vQuery.Open();
        If not(vQuery.eof) then
          begin
            vTABLENAME := vQuery.FieldByName('RDB$RELATION_NAME').AsString;
          end;
        vQuery.Close;

        // Controle est-ce qu'il y a bien un fichier TABLE.csv
        If (FileCsvExist(vTABLENAME))
          then
            begin
              FStatus := Format('Désactivation Index %s',[aIDXNAME]);
              Synchronize(StatusCallBack);

              vQuery.Close;
              vQuery.SQL.Clear;
              vQuery.SQL.Add(Format('ALTER INDEX %s INACTIVE;',[UpperCase(aIDXNAME)]));
              vQuery.OptionsIntf.UpdateOptions.ReadOnly := False;
              vQuery.ExecSQL;
              vQuery.Close;
            end
          else
            begin
              FStatus := Format('Aucun fichier %s.csv => on ne désactive pas l''index %s',[vTABLENAME,aIDXNAME]);
              Synchronize(StatusCallBack);
            end;
      Except

      end;
    finally
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;













end.
