unit Param_Dm;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, IBDatabase, Jeton_DM,
  IBUpdateSQL, IBSQL, Dialogs;

type
  TDm_Param = class(TDataModule)
    IBQue_GenLaunch: TIBQuery;
    IBQue_GenReplication: TIBQuery;
    Ds_GenReplication: TDataSource;
    IBQue_GenReplicationREP_ID: TIntegerField;
    IBQue_GenReplicationREP_URLDISTANT: TIBStringField;
    IBQue_GenReplicationREP_PLACEEAI: TIBStringField;
    IBQue_GenReplicationREP_PLACEBASE: TIBStringField;
    IBQue_GenReplicationREP_JOUR: TIntegerField;
    IBQue_ProviderD: TIBQuery;
    IBQue_ProviderT: TIBQuery;
    IBQue_SubscriptionD: TIBQuery;
    IBQue_SubscriptionT: TIBQuery;
    Ds_ProviderD: TDataSource;
    Ds_ProviderT: TDataSource;
    Ds_SubscriptionD: TDataSource;
    Ds_SubscriptionT: TDataSource;
    IBQue_GenLaunchLAU_ID: TIntegerField;
    IBQue_GenLaunchLAU_HEURE1: TDateTimeField;
    IBQue_GenLaunchLAU_H1: TIntegerField;
    IBQue_GenLaunchLAU_HEURE2: TDateTimeField;
    IBQue_GenLaunchLAU_H2: TIntegerField;
    IBQue_GenLaunchLAU_AUTORUN: TIntegerField;
    IBQue_GenReplicationREP_PING: TIBStringField;
    IBQue_GenReplicationREP_PUSH: TIBStringField;
    IBQue_GenReplicationREP_PULL: TIBStringField;
    IBQue_GenReplicationREP_USER: TIBStringField;
    IBQue_GenReplicationREP_PWD: TIBStringField;
    IBQue_GenReplicationREP_ORDRE: TIntegerField;
    IBQue_GenReplicationREP_URLLOCAL: TIBStringField;
    Ds_GenLaunch: TDataSource;
    IBUpd_GenLaunch: TIBUpdateSQL;
    Ds_GenParamNbEssai: TDataSource;
    IBQue_GenParamNbEssai: TIBQuery;
    IBUpd_GenParamNbEssai: TIBUpdateSQL;
    Ds_GenParamDelai: TDataSource;
    IBQue_GenParamDelai: TIBQuery;
    IBQue_GenParamStart: TIBQuery;
    IBQue_GenParamEnd: TIBQuery;
    IBUpd_GenParamStart: TIBUpdateSQL;
    IBUpd_GenParamEnd: TIBUpdateSQL;
    IBUpd_GenParamDelai: TIBUpdateSQL;
    IBQue_GenParamNbEssaiPRM_ID: TIntegerField;
    IBQue_GenParamNbEssaiPRM_INTEGER: TIntegerField;
    IBQue_GenParamDelaiPRM_ID: TIntegerField;
    IBQue_GenParamDelaiPRM_INTEGER: TIntegerField;
    IBQue_GenParamStartPRM_ID: TIntegerField;
    IBQue_GenParamEndPRM_ID: TIntegerField;
    IBQue_GenParamUrl: TIBQuery;
    Ds_GenParamUrl: TDataSource;
    IBUpd_GenParamUrl: TIBUpdateSQL;
    IBQue_GenParamUrlPRM_ID: TIntegerField;
    IBQue_GenParamUrlPRM_STRING: TIBStringField;
    IBQue_GenParamSender: TIBQuery;
    IBUpd_GenParamSender: TIBUpdateSQL;
    Ds_GenParamSender: TDataSource;
    IBQue_GenParamSenderPRM_ID: TIntegerField;
    IBQue_GenParamSenderPRM_STRING: TIBStringField;
    IBUpd_GenParamDB: TIBUpdateSQL;
    IBQue_GenParamDB: TIBQuery;
    Ds_GenParamDB: TDataSource;
    IBQue_GenParamDBPRM_ID: TIntegerField;
    IBQue_GenParamDBPRM_STRING: TIBStringField;
    IBQue_GenParamUrlPRM_FLOAT: TFloatField;
    IBQue_GenParamStartPRM_FLOAT: TFloatField;
    IBQue_GenParamEndPRM_FLOAT: TFloatField;
    IBUpd_GenReplication: TIBUpdateSQL;
    IBQue_ProviderDPRO_ID: TIntegerField;
    IBQue_ProviderDPRO_NOM: TIBStringField;
    IBQue_ProviderDPRO_ORDRE: TIntegerField;
    IBQue_ProviderDPRO_LOOP: TIntegerField;
    IBQue_ProviderTPRO_ID: TIntegerField;
    IBQue_ProviderTPRO_NOM: TIBStringField;
    IBQue_ProviderTPRO_ORDRE: TIntegerField;
    IBQue_ProviderTPRO_LOOP: TIntegerField;
    IBUpd_ProviderD: TIBUpdateSQL;
    IBQue_SubscriptionDSUB_ID: TIntegerField;
    IBQue_SubscriptionDSUB_NOM: TIBStringField;
    IBQue_SubscriptionDSUB_ORDRE: TIntegerField;
    IBQue_SubscriptionDSUB_LOOP: TIntegerField;
    IBQue_SubscriptionTSUB_ID: TIntegerField;
    IBQue_SubscriptionTSUB_NOM: TIBStringField;
    IBQue_SubscriptionTSUB_ORDRE: TIntegerField;
    IBQue_SubscriptionTSUB_LOOP: TIntegerField;
    IBUpd_SubscriptionD: TIBUpdateSQL;
    IBQue_ProviderTGLR_ID: TIntegerField;
    IBSql_Req: TIBSQL;
    IBQue_SubscriptionTGLR_ID: TIntegerField;
    IBQue_GenReplicationREP_LAUID: TIntegerField;
    IBQue_Req: TIBQuery;
    IBQue_WebHStart: TIBQuery;
    IBQue_WebHEnd: TIBQuery;
    IBUpd_WebHStart: TIBUpdateSQL;
    IBUpd_WebHEnd: TIBUpdateSQL;
    IBQue_WebHStartPRM_ID: TIntegerField;
    IBQue_WebHStartPRM_FLOAT: TFloatField;
    IBQue_WebHEndPRM_ID: TIntegerField;
    IBQue_WebHEndPRM_FLOAT: TFloatField;
    IBQue_WebIntervale: TIBQuery;
    Ds_WebIntervale: TDataSource;
    IBUpd_WebIntervale: TIBUpdateSQL;
    IBQue_GenLaunchLAU_BACK: TIntegerField;
    IBQue_GenLaunchLAU_BACKTIME: TDateTimeField;
    IBQue_WebIntervalePRM_ID: TIntegerField;
    IBQue_WebIntervalePRM_FLOAT: TFloatField;
    IBQue_WebIntervalePRM_POS: TIntegerField;
    IBQue_GenParamForcerMaj: TIBQuery;
    Ds_GenParamForcerMaj: TDataSource;
    IBUpd_GenParamForcerMaj: TIBUpdateSQL;
    IBQue_GenParamForcerMajPRM_ID: TIntegerField;
    IBQue_GenParamForcerMajPRM_POS: TIntegerField;
    IBQue_WebHStartPRM_INTEGER: TIntegerField;
    IBQue_WebIntervalePRM_INTEGER: TIntegerField;
    IBQue_WebHEndPRM_INTEGER: TIntegerField;
    procedure IBQue_GenLaunchAfterPost(DataSet: TDataSet);
    procedure IBQue_GenParamNbEssaiAfterPost(DataSet: TDataSet);
    procedure IBQue_GenParamDelaiAfterPost(DataSet: TDataSet);
    procedure IBQue_GenParamEndAfterPost(DataSet: TDataSet);
    procedure IBQue_GenParamStartAfterPost(DataSet: TDataSet);
    procedure IBQue_GenParamUrlAfterPost(DataSet: TDataSet);
    procedure IBQue_GenParamSenderAfterPost(DataSet: TDataSet);
    procedure IBQue_GenParamDBAfterPost(DataSet: TDataSet);
    procedure IBQue_ProviderDAfterPost(DataSet: TDataSet);
    procedure IBQue_SubscriptionDAfterPost(DataSet: TDataSet);
    procedure IBQue_GenReplicationAfterPost(DataSet: TDataSet);
    procedure IBQue_WebHStartAfterPost(DataSet: TDataSet);
    procedure IBQue_WebHEndAfterPost(DataSet: TDataSet);
    procedure IBQue_WebIntervaleAfterPost(DataSet: TDataSet);
  private
    { Déclarations privées }
  public
    procedure StartModifyGenLaunch;
    procedure EndModifyGenLaunch;

    function PostGenRepication(aMaxOrdre:Integer;aWeb:Boolean):Boolean;
    procedure StartModifyGenReplication;
    procedure EndModifyGenReplication;

    procedure VerifOrdreReplic;
    procedure VerifOrdreWeb;

    function StartModifyWeb:Boolean;
    procedure EndModifyWeb;
    procedure StartModifyGenParam;
    procedure EndModifyGenParam;

    //Les fonctions d'activation et de désactivation
    procedure EnableProviders(aEnable,aAll:Boolean;aRepId,aProId,aGlrId:Integer);
    procedure EnableSubscribers(aEnable,aAll:Boolean;aRepId,aSubId,aGlrId:Integer);

    //Les fonctions de recherche
    function FindTSubId(aSubId,aRepId:Integer):Boolean;
    function FindTProId(aProId,aRepId:Integer):Boolean;

    //Les fonctions d'ajout
    function AddGenReplication(aLauId : Integer):Integer;
    function AddWeb(aBaseId:Integer):Boolean;
    function AddProviders(aNom:string;aLoop:Integer):Integer;
    function AddSubscribers(aNom:string;aLoop:Integer):Integer;

    //Les fonctions de modification
    function ModifyProviders(aProId:Integer;aNom:string;aLoop:Integer):Boolean;
    function ModifySubscribers(aSubId:Integer;aNom:string;aLoop:Integer):Boolean;

    //Les fonctions de suppression
    function DelGenReplication:Boolean;
    function DelWeb:Boolean;
    function DelProviders(aProId:Integer):Boolean;
    function DelSubscribers(aSubId:Integer):Boolean;

    //Les fonctions Get
    function GetRepIdPlaceEAI:string;
    function GetRepIdPlaceBase:string;
    function GetWebHStart:TDateTime;
    function GetWebHEnd:TDateTime;
    function GetReplicTpsReelStart:TDateTime;
    function GetReplicTpsReelEnd:TDateTime;

    //Les fonctions Set
    function SetRepIdPlaceEAI(aPlaceEAI:string):Boolean;
    function SetRepIdPlaceBase(aPlaceBase:string):Boolean;
    function SetWebHStart(aTime:TDateTime):Boolean;
    function SetWebHEnd(aTime:TDateTime):Boolean;
    function SetReplicTpsReelStart(aTime:TDateTime):Boolean;
    function SetReplicTpsReelEnd(aTime:TDateTime):Boolean;

    //Repositionnement sur un Id
    function LocateLauId(aLauId:Integer):Boolean;
    function LocateRepId(aRepId:Integer):Boolean;
    function LocateDProId(aProId:Integer):Boolean;
    function LocateTProId(aProId:Integer):Boolean;
    function LocateDSubId(aSubId:Integer):Boolean;
    function LocateTSubId(aSubId:Integer):Boolean;

    //Rechargement des données
    procedure RefreshGenLaunch(aBaseId : Integer);
    procedure RefreshGenReplication(aLauId : Integer);
    function RefreshWeb(aBaseId : Integer):Boolean;
    procedure RefreshGenParam(aBaseId : Integer);
    procedure RefreshProviders(aRepId : Integer);
    procedure RefreshSubscribers(aRepId : Integer);

    //Modification d'ordre
    procedure UpRepId(aWeb:Boolean);          //Pour déplacer vers le haut une réplication
    procedure DownRepId(aWeb:Boolean);        //Pour déplacer vers le bas une réplication
    procedure UpProId(aRepId : Integer);      //Pour déplacer vers le haut un provider
    procedure DownProId(aRepId : Integer);    //Pour déplacer vers le bas un provider
    procedure UpSubId(aRepId : Integer);      //Pour déplacer vers le haut un subscriber
    procedure DownSubId(aRepId : Integer);    //Pour déplacer vers le bas un subscriber
  end;

var
  Dm_Param: TDm_Param;

implementation

{$R *.dfm}

{ TDm_Param }

function TDm_Param.AddGenReplication(aLauId : Integer):Integer;
begin
  Result := 0;
  try
    IBQue_GenReplication.Append;
    IBQue_GenReplicationREP_ID.AsInteger := Dm_Jeton.MainNewK('GENREPLICATION');
    IBQue_GenReplicationREP_URLDISTANT.AsString := '';
    IBQue_GenReplicationREP_PLACEEAI.AsString := '';
    IBQue_GenReplicationREP_PLACEBASE.AsString := '';
    IBQue_GenReplicationREP_PING.AsString := 'Ping';
    IBQue_GenReplicationREP_PUSH.AsString := 'Push';
    IBQue_GenReplicationREP_PULL.AsString := 'PullSubscription';
    IBQue_GenReplicationREP_USER.AsString := '';
    IBQue_GenReplicationREP_PWD.AsString := '';
    IBQue_GenReplicationREP_URLLOCAL.AsString := 'http://localhost:668/DelosEaiBin/DelosQPMAgent.dll/';
    IBQue_GenReplicationREP_LAUID.AsInteger := aLauId;
    IBQue_GenReplicationREP_JOUR.AsInteger := 0;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de l''ajout d''une réplication. (' + e.Message + ')');
    end;
  end;
  Result := IBQue_GenReplicationREP_ID.AsInteger;
end;

function TDm_Param.AddProviders(aNom: string; aLoop: Integer): Integer;
var
  iOrdre,
  id      : Integer;
begin
  IBQue_Req.Close;
  IBQue_Req.SQL.Clear;
  IBQue_Req.SQL.Add('Select MAX(PRO_ORDRE) AS Ordre From GENPROVIDERS Join K on (K_ID = PRO_ID and K_ENABLED = 1)');
  IBQue_Req.Open;
  iOrdre := IBQue_Req.FieldByName('Ordre').AsInteger;
  IBQue_Req.Close;

  IBSql_Req.Close;
  IBSql_Req.SQL.Clear;
  IBSql_Req.SQL.Add('INSERT INTO GENPROVIDERS (PRO_ID, PRO_NOM, PRO_ORDRE, PRO_LOOP) ');
  IBSql_Req.SQL.Add('VALUES (:PRO_ID, :PRO_NOM, :PRO_ORDRE, :PRO_LOOP)');
  id := Dm_Jeton.MainNewK('GENPROVIDERS');
  IBSql_Req.ParamByName('PRO_ID').AsInteger     := id;
  IBSql_Req.ParamByName('PRO_NOM').AsString     := aNom;
  IBSql_Req.ParamByName('PRO_ORDRE').AsInteger  := iOrdre + 1;
  IBSql_Req.ParamByName('PRO_LOOP').AsInteger   := aLoop;
  IBSql_Req.ExecQuery;
  Result := id;
end;

function TDm_Param.AddSubscribers(aNom: string; aLoop: Integer): Integer;
var
  iOrdre,
  id      : Integer;
begin
  IBQue_Req.Close;
  IBQue_Req.SQL.Clear;
  IBQue_Req.SQL.Add('Select MAX(SUB_ORDRE) AS Ordre From GENSUBSCRIBERS Join K on (K_ID = SUB_ID and K_ENABLED = 1)');
  IBQue_Req.Open;
  iOrdre := IBQue_Req.FieldByName('Ordre').AsInteger;
  IBQue_Req.Close;

  IBSql_Req.Close;
  IBSql_Req.SQL.Clear;
  IBSql_Req.SQL.Add('INSERT INTO GENSUBSCRIBERS (SUB_ID, SUB_NOM, SUB_ORDRE, SUB_LOOP) ');
  IBSql_Req.SQL.Add('VALUES (:SUB_ID, :SUB_NOM, :SUB_ORDRE, :SUB_LOOP)');
  id := Dm_Jeton.MainNewK('GENSUBSCRIBERS');
  IBSql_Req.ParamByName('SUB_ID').AsInteger     := id;
  IBSql_Req.ParamByName('SUB_NOM').AsString     := aNom;
  IBSql_Req.ParamByName('SUB_ORDRE').AsInteger  := iOrdre + 1;
  IBSql_Req.ParamByName('SUB_LOOP').AsInteger   := aLoop;
  IBSql_Req.ExecQuery;
  Result := id;
end;

function TDm_Param.AddWeb(aBaseId:Integer): Boolean;
begin
  IBQue_WebHStart.Append;
  IBQue_WebHStartPRM_ID.AsInteger       := Dm_Jeton.MainNewK('GENPARAM');
  IBQue_WebHStartPRM_INTEGER.AsInteger  := aBaseId;
  IBQue_WebHStart.Post;
  IBQue_WebHStart.Edit;

  IBQue_WebHEnd.Append;
  IBQue_WebHEndPRM_ID.AsInteger       := Dm_Jeton.MainNewK('GENPARAM');
  IBQue_WebHEndPRM_INTEGER.AsInteger  := aBaseId;
  IBQue_WebHEnd.Post;
  IBQue_WebHEnd.Edit;

  IBQue_WebIntervale.Append;
  IBQue_WebIntervalePRM_ID.AsInteger      := Dm_Jeton.MainNewK('GENPARAM');
  IBQue_WebIntervalePRM_INTEGER.AsInteger := aBaseId;
  IBQue_WebIntervale.Post;
  IBQue_WebIntervale.Edit;
end;

function TDm_Param.DelGenReplication: Boolean;
var
  i,
  id : Integer;
begin
  try
    id := IBQue_GenReplicationREP_ID.AsInteger;

    //Démarre une transaction
    if Dm_Jeton.Tra_Ginkoia.InTransaction then
      Dm_Jeton.Tra_Ginkoia.Commit;
    Dm_Jeton.Tra_Ginkoia.StartTransaction;

    IBQue_ProviderT.Open;
    while not IBQue_ProviderT.Eof do
    begin
      Dm_Jeton.MainDeleteK(IBQue_ProviderTGLR_ID.AsInteger);  //Suppression des lignes  GenLiairepli
      IBQue_ProviderT.Next;
    end;
    Dm_Jeton.MainDeleteK(id);    //Suppression enregistrement GenReplication

    Dm_Jeton.Tra_Ginkoia.Commit;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la suppression d''une Réplication. (' + e.Message + ')');
      Dm_Jeton.Tra_Ginkoia.Rollback;
    end;
  end;
end;

function TDm_Param.DelProviders(aProId: Integer): Boolean;
begin
  try
    IBQue_Req.Close;
    IBQue_Req.SQL.Clear;
    IBQue_Req.SQL.Add('Select GLR_ID ');
    IBQue_Req.SQL.Add('From GENLIAIREPLI ');
    IBQue_Req.SQL.Add(' Join K on (K_ID =GLR_ID and K_ENABLED = 1) ');
    IBQue_Req.SQL.Add('Where GLR_PROSUBID = :proid ');
    IBQue_Req.ParamByName('proid').AsInteger := aProId;
    IBQue_Req.Open;

    if IBQue_Req.IsEmpty then
    begin
      //Démarre une transaction
      if Dm_Jeton.Tra_Ginkoia.InTransaction then
        Dm_Jeton.Tra_Ginkoia.Commit;
      Dm_Jeton.Tra_Ginkoia.StartTransaction;

      Dm_Jeton.MainDeleteK(aProId);

      Dm_Jeton.Tra_Ginkoia.Commit;
      Result := True;
    end
    else
    begin
      Result := False;
    end;
    IBQue_Req.Close;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la suppression d''un Provider. (' + e.Message + ')');
      Dm_Jeton.Tra_Ginkoia.Rollback;
    end;
  end;
end;

function TDm_Param.DelSubscribers(aSubId: Integer): Boolean;
begin
  try
    IBQue_Req.Close;
    IBQue_Req.SQL.Clear;
    IBQue_Req.SQL.Add('Select GLR_ID ');
    IBQue_Req.SQL.Add('From GENLIAIREPLI ');
    IBQue_Req.SQL.Add(' Join K on (K_ID =GLR_ID and K_ENABLED = 1) ');
    IBQue_Req.SQL.Add('Where GLR_PROSUBID = :subid ');
    IBQue_Req.ParamByName('subid').AsInteger := aSubId;
    IBQue_Req.Open;

    if IBQue_Req.IsEmpty then
    begin
      //Démarre une transaction
      if Dm_Jeton.Tra_Ginkoia.InTransaction then
        Dm_Jeton.Tra_Ginkoia.Commit;
      Dm_Jeton.Tra_Ginkoia.StartTransaction;

      Dm_Jeton.MainDeleteK(aSubId);

      Dm_Jeton.Tra_Ginkoia.Commit;
      Result := True;
    end
    else
    begin
      Result := False;
    end;
    IBQue_Req.Close;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la suppression d''un Subscriber. (' + e.Message + ')');
      Dm_Jeton.Tra_Ginkoia.Rollback;
    end;
  end;
end;

function TDm_Param.DelWeb: Boolean;
begin
  try
    Dm_Jeton.MainDeleteK(IBQue_WebHStartPRM_ID.AsInteger);
    Dm_Jeton.MainDeleteK(IBQue_WebHEndPRM_ID.AsInteger);
    Dm_Jeton.MainDeleteK(IBQue_WebIntervalePRM_ID.AsInteger);
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la suppression du Web. (' + e.Message + ')');
      Dm_Jeton.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TDm_Param.DownProId(aRepId : Integer);
var
  idD,                //Id du Provider de la liste disponible
  idT : Integer;      //Id du Provider de la liste traité
begin
  try
    //afin de garder la position actuel
    idD := IBQue_ProviderDPRO_ID.AsInteger;
    idT := IBQue_ProviderTPRO_ID.AsInteger;

    //Démarre une transaction
    if Dm_Jeton.Tra_Ginkoia.InTransaction then
      Dm_Jeton.Tra_Ginkoia.Commit;
    Dm_Jeton.Tra_Ginkoia.StartTransaction;

    IBQue_ProviderD.Open;
    LocateDProId(idD);
    if not IBQue_ProviderD.Eof then    //Si nous ne somme pas à la fin
    begin
      IBQue_ProviderD.Edit;
      IBQue_ProviderDPRO_ORDRE.AsInteger := IBQue_ProviderDPRO_ORDRE.AsInteger + 1;
      IBQue_ProviderD.Post;

      IBQue_ProviderD.Next;

      IBQue_ProviderD.Edit;
      IBQue_ProviderDPRO_ORDRE.AsInteger := IBQue_ProviderDPRO_ORDRE.AsInteger - 1;
      IBQue_ProviderD.Post;
    end;

    Dm_Jeton.Tra_Ginkoia.Commit;

    RefreshProviders(aRepId);   //On ne refresh que le Providers

    LocateDProId(idD);          //On se repositionne sur pour les 2 grilles
    LocateTProId(idT);
  except on e:Exception do
    begin
      ShowMessage('Erreur lors du changement d''ordre d''un Provider. (' + e.Message + ')');
      Dm_Jeton.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TDm_Param.DownRepId;
var
  i,
  id  : Integer;
begin
  try
    id := IBQue_GenReplicationREP_ID.AsInteger;     //Récupère l'Id de l'enregistrement courrant

    //Démarre une transaction
    if Dm_Jeton.Tra_Ginkoia.InTransaction then
      Dm_Jeton.Tra_Ginkoia.Commit;
    Dm_Jeton.Tra_Ginkoia.StartTransaction;

    IBQue_GenReplication.Open;
    LocateRepId(id);
    if aWeb then
    begin
      if not IBQue_GenReplication.Eof then    //Si nous ne somme pas à la fin
      begin
        IBQue_GenReplication.Edit;
        IBQue_GenReplicationREP_ORDRE.AsInteger := IBQue_GenReplicationREP_ORDRE.AsInteger - 1;
        IBQue_GenReplication.Post;

        IBQue_GenReplication.Next;

        IBQue_GenReplication.Edit;
        IBQue_GenReplicationREP_ORDRE.AsInteger := IBQue_GenReplicationREP_ORDRE.AsInteger + 1;
        IBQue_GenReplication.Post;
      end;
    end
    else
    begin
      if not IBQue_GenReplication.Eof then    //Si nous ne somme pas à la fin
      begin
        IBQue_GenReplication.Edit;
        IBQue_GenReplicationREP_ORDRE.AsInteger := IBQue_GenReplicationREP_ORDRE.AsInteger + 1;
        IBQue_GenReplication.Post;

        IBQue_GenReplication.Next;

        IBQue_GenReplication.Edit;
        IBQue_GenReplicationREP_ORDRE.AsInteger := IBQue_GenReplicationREP_ORDRE.AsInteger - 1;
        IBQue_GenReplication.Post;
      end;
    end;

    Dm_Jeton.Tra_Ginkoia.Commit;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors du changement d''ordre d''une réplication. (' + e.Message + ')');
      Dm_Jeton.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TDm_Param.DownSubId(aRepId : Integer);
var
  idD,                //Id du Subscriber de la liste disponible
  idT : Integer;      //Id du Subscriber de la liste traité
begin
  try
    //afin de garder la position actuel
    idD := IBQue_SubscriptionDSUB_ID.AsInteger;
    idT := IBQue_SubscriptionTSUB_ID.AsInteger;

    //Démarre une transaction
    if Dm_Jeton.Tra_Ginkoia.InTransaction then
      Dm_Jeton.Tra_Ginkoia.Commit;

    Dm_Jeton.Tra_Ginkoia.StartTransaction;

    IBQue_SubscriptionD.Open;
    LocateDSubId(idD);
    if not IBQue_SubscriptionD.Eof then    //Si nous ne somme pas à la fin
    begin
      IBQue_SubscriptionD.Edit;
      IBQue_SubscriptionDSUB_ORDRE.AsInteger := IBQue_SubscriptionDSUB_ORDRE.AsInteger + 1;
      IBQue_SubscriptionD.Post;

      IBQue_SubscriptionD.Next;

      IBQue_SubscriptionD.Edit;
      IBQue_SubscriptionDSUB_ORDRE.AsInteger := IBQue_SubscriptionDSUB_ORDRE.AsInteger - 1;
      IBQue_SubscriptionD.Post;
    end;

    Dm_Jeton.Tra_Ginkoia.Commit;

    RefreshSubscribers(aRepId);   //On ne refresh que le Subscribers

    LocateDSubId(idD);          //On se repositionne sur pour les 2 grilles
    LocateTSubId(idT);
  except on e:Exception do
    begin
      ShowMessage('Erreur lors du changement d''ordre d''un Subscriber. (' + e.Message + ')');
      Dm_Jeton.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TDm_Param.EnableProviders(aEnable, aAll: Boolean;aRepId,aProId,aGlrId:Integer);
begin
  if aAll then    //Tout les Providers
  begin
    if aEnable then   //Activer
    begin
      IBQue_ProviderD.Open;
      IBQue_ProviderT.Open;
      IBQue_ProviderD.First;

      IBSql_Req.Close;
      IBSql_Req.SQL.Clear;
      IBSql_Req.SQL.Add('INSERT INTO GENLIAIREPLI (GLR_ID, GLR_REPID, GLR_PROSUBID, GLR_LASTVERSION) ');
      IBSql_Req.SQL.Add('VALUES (:GLR_ID, :GLR_REPID, :GLR_PROSUBID, Null)');

      While not IBQue_ProviderD.Eof do    //Si nous ne somme pas à la fin
      begin
        if not IBQue_ProviderT.Locate('PRO_ID',IBQue_ProviderDPRO_ID.AsInteger,[]) then
        begin
          IBSql_Req.Close;
          IBSql_Req.ParamByName('GLR_ID').AsInteger := Dm_Jeton.MainNewK('GENLIAIREPLI');
          IBSql_Req.ParamByName('GLR_REPID').AsInteger := aRepId;
          IBSql_Req.ParamByName('GLR_PROSUBID').AsInteger := IBQue_ProviderDPRO_ID.AsInteger;
          IBSql_Req.ExecQuery;
        end;
        IBQue_ProviderD.Next;
      end;
    end
    else
    begin
      IBQue_ProviderT.Open;
      IBQue_ProviderT.First;
      While not IBQue_ProviderT.Eof do    //Si nous ne somme pas à la fin
      begin
        Dm_Jeton.MainDeleteK(IBQue_ProviderTGLR_ID.AsInteger);
        IBQue_ProviderT.Next;
      end;
    end;
  end
  else
  begin
    if aEnable then   //Activer
    begin
      IBQue_ProviderT.Open;
      if not IBQue_ProviderT.Locate('PRO_ID',aProId,[]) then
      begin
        IBSql_Req.Close;
        IBSql_Req.SQL.Clear;
        IBSql_Req.SQL.Add('INSERT INTO GENLIAIREPLI (GLR_ID, GLR_REPID, GLR_PROSUBID, GLR_LASTVERSION) ');
        IBSql_Req.SQL.Add('VALUES (:GLR_ID, :GLR_REPID, :GLR_PROSUBID, Null)');

        IBSql_Req.ParamByName('GLR_ID').AsInteger := Dm_Jeton.MainNewK('GENLIAIREPLI');
        IBSql_Req.ParamByName('GLR_REPID').AsInteger := aRepId;
        IBSql_Req.ParamByName('GLR_PROSUBID').AsInteger := aProId;
        IBSql_Req.ExecQuery;
      end;
    end
    else
    begin
      Dm_Jeton.MainDeleteK(aGlrId);
    end;
  end;
end;

procedure TDm_Param.EnableSubscribers(aEnable, aAll: Boolean; aRepId, aSubId, aGlrId: Integer);
begin
  if aAll then    //Tout les Subscribers
  begin
    if aEnable then   //Activer
    begin
      IBQue_SubscriptionD.Open;
      IBQue_SubscriptionT.Open;
      IBQue_SubscriptionD.First;

      IBSql_Req.Close;
      IBSql_Req.SQL.Clear;
      IBSql_Req.SQL.Add('INSERT INTO GENLIAIREPLI (GLR_ID, GLR_REPID, GLR_PROSUBID, GLR_LASTVERSION) ');
      IBSql_Req.SQL.Add('VALUES (:GLR_ID, :GLR_REPID, :GLR_PROSUBID, Null)');

      While not IBQue_SubscriptionD.Eof do    //Si nous ne somme pas à la fin
      begin
        if not IBQue_SubscriptionT.Locate('SUB_ID',IBQue_SubscriptionDSUB_ID.AsInteger,[]) then
        begin
          IBSql_Req.Close;
          IBSql_Req.ParamByName('GLR_ID').AsInteger := Dm_Jeton.MainNewK('GENLIAIREPLI');
          IBSql_Req.ParamByName('GLR_REPID').AsInteger := aRepId;
          IBSql_Req.ParamByName('GLR_PROSUBID').AsInteger := IBQue_SubscriptionDSUB_ID.AsInteger;
          IBSql_Req.ExecQuery;
        end;
        IBQue_SubscriptionD.Next;
      end;
      IBSql_Req.Close;
      IBSql_Req.SQL.Clear;
    end
    else
    begin
      IBQue_SubscriptionT.Open;
      IBQue_SubscriptionT.First;
      While not IBQue_SubscriptionT.Eof do    //Si nous ne somme pas à la fin
      begin
        Dm_Jeton.MainDeleteK(IBQue_SubscriptionTGLR_ID.AsInteger);
        IBQue_SubscriptionT.Next;
      end;
    end;
  end
  else
  begin
    if aEnable then   //Activer
    begin
      IBQue_SubscriptionT.Open;
      if not IBQue_SubscriptionT.Locate('SUB_ID',aSubId,[]) then
      begin
        IBSql_Req.Close;
        IBSql_Req.SQL.Clear;
        IBSql_Req.SQL.Add('INSERT INTO GENLIAIREPLI (GLR_ID, GLR_REPID, GLR_PROSUBID, GLR_LASTVERSION) ');
        IBSql_Req.SQL.Add('VALUES (:GLR_ID, :GLR_REPID, :GLR_PROSUBID, Null)');
        IBSql_Req.ParamByName('GLR_ID').AsInteger := Dm_Jeton.MainNewK('GENLIAIREPLI');
        IBSql_Req.ParamByName('GLR_REPID').AsInteger := aRepId;
        IBSql_Req.ParamByName('GLR_PROSUBID').AsInteger := aSubId;
        IBSql_Req.ExecQuery;
      end;
    end
    else
    begin
      Dm_Jeton.MainDeleteK(aGlrId);
    end;
  end;
end;

procedure TDm_Param.EndModifyGenLaunch();
begin
  try
    IBQue_GenLaunch.Post;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la validation des modifications de GenLaunch. (' + e.Message + ')');
    end;
  end;
end;

procedure TDm_Param.EndModifyGenParam;
begin
  try
    IBQue_GenParamNbEssai.Post;
    IBQue_GenParamDelai.Post;
    IBQue_GenParamStart.Post;
    IBQue_GenParamEnd.Post;
    IBQue_GenParamUrl.Post;
    IBQue_GenParamSender.Post;
    IBQue_GenParamDB.Post;
    IBQue_GenParamForcerMaj.Post;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la validation des modifications de GenParam. (' + e.Message + ')');
    end;
  end;
end;

procedure TDm_Param.EndModifyGenReplication;
begin
  try
    IBQue_GenReplication.Post;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la validation des modifications de GenReplication. (' + e.Message + ')');
    end;
  end;
end;

procedure TDm_Param.EndModifyWeb;
begin
  try
    IBQue_WebHStart.Post;
    IBQue_WebHEnd.Post;
    IBQue_WebIntervale.Post;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la validation des modifications de GenParam. (' + e.Message + ')');
    end;
  end;
end;

function TDm_Param.FindTProId(aProId,aRepId: Integer): Boolean;
begin
  IBQue_Req.Close;
  IBQue_Req.SQL.Clear;
  IBQue_Req.SQL.Add('Select GLR_ID ');
  IBQue_Req.SQL.Add('From GENLIAIREPLI ');
  IBQue_Req.SQL.Add(' Join K on (K_ID =GLR_ID and K_ENABLED = 1) ');
  IBQue_Req.SQL.Add('Where GLR_PROSUBID = :proid ');
  IBQue_Req.SQL.Add('And GLR_REPID = :repid ');
  IBQue_Req.ParamByName('proid').AsInteger := aProId;
  IBQue_Req.ParamByName('repid').AsInteger := aRepId;
  IBQue_Req.Open;
  if not IBQue_Req.IsEmpty then
    Result := True
  else
    Result := False;
  IBQue_Req.Close;
end;

function TDm_Param.FindTSubId(aSubId, aRepId: Integer): Boolean;
begin
  IBQue_Req.Close;
  IBQue_Req.SQL.Clear;
  IBQue_Req.SQL.Add('Select GLR_ID ');
  IBQue_Req.SQL.Add('From GENLIAIREPLI ');
  IBQue_Req.SQL.Add(' Join K on (K_ID =GLR_ID and K_ENABLED = 1) ');
  IBQue_Req.SQL.Add('Where GLR_PROSUBID = :subid ');
  IBQue_Req.SQL.Add('And GLR_REPID = :repid ');
  IBQue_Req.ParamByName('subid').AsInteger := aSubId;
  IBQue_Req.ParamByName('repid').AsInteger := aRepId;
  IBQue_Req.Open;
  if not IBQue_Req.IsEmpty then
    Result := True
  else
    Result := False;
  IBQue_Req.Close;
end;

function TDm_Param.GetRepIdPlaceBase: string;
begin
  Result := IBQue_GenReplicationREP_PLACEBASE.AsString;
end;

function TDm_Param.GetRepIdPlaceEAI: string;
begin
  Result := IBQue_GenReplicationREP_PLACEEAI.AsString;
end;

function TDm_Param.GetReplicTpsReelEnd: TDateTime;
begin
  Result := FloatToDateTime(IBQue_GenParamEndPRM_FLOAT.AsFloat);
end;

function TDm_Param.GetReplicTpsReelStart: TDateTime;
begin
  Result := FloatToDateTime(IBQue_GenParamStartPRM_FLOAT.AsFloat);
end;

function TDm_Param.GetWebHEnd: TDateTime;
begin
  Result := FloatToDateTime(IBQue_WebHEndPRM_FLOAT.AsFloat);
end;

function TDm_Param.GetWebHStart: TDateTime;
begin
  Result := FloatToDateTime(IBQue_WebHStartPRM_FLOAT.AsFloat);
end;

procedure TDm_Param.IBQue_GenLaunchAfterPost(DataSet: TDataSet);
begin
  Dm_Jeton.MainModifK(IBQue_GenLaunchLAU_ID.AsInteger);
end;

procedure TDm_Param.IBQue_GenParamDBAfterPost(DataSet: TDataSet);
begin
  Dm_Jeton.MainModifK(IBQue_GenParamDBPRM_ID.AsInteger);
end;

procedure TDm_Param.IBQue_GenParamDelaiAfterPost(DataSet: TDataSet);
begin
  Dm_Jeton.MainModifK(IBQue_GenParamDelaiPRM_ID.AsInteger);
end;

procedure TDm_Param.IBQue_GenParamEndAfterPost(DataSet: TDataSet);
begin
  Dm_Jeton.MainModifK(IBQue_GenParamEndPRM_ID.AsInteger);
end;

procedure TDm_Param.IBQue_GenParamNbEssaiAfterPost(DataSet: TDataSet);
begin
  Dm_Jeton.MainModifK(IBQue_GenParamNbEssaiPRM_ID.AsInteger);
end;

procedure TDm_Param.IBQue_GenParamSenderAfterPost(DataSet: TDataSet);
begin
  Dm_Jeton.MainModifK(IBQue_GenParamSenderPRM_ID.AsInteger);
end;

procedure TDm_Param.IBQue_GenParamStartAfterPost(DataSet: TDataSet);
begin
  Dm_Jeton.MainModifK(IBQue_GenParamStartPRM_ID.AsInteger);
end;

procedure TDm_Param.IBQue_GenParamUrlAfterPost(DataSet: TDataSet);
begin
  Dm_Jeton.MainModifK(IBQue_GenParamUrlPRM_ID.AsInteger);
end;

procedure TDm_Param.IBQue_GenReplicationAfterPost(DataSet: TDataSet);
begin
  Dm_Jeton.MainModifK(IBQue_GenReplicationREP_ID.AsInteger);
end;

procedure TDm_Param.IBQue_ProviderDAfterPost(DataSet: TDataSet);
begin
  Dm_Jeton.MainModifK(IBQue_ProviderDPRO_ID.AsInteger);
end;

procedure TDm_Param.IBQue_SubscriptionDAfterPost(DataSet: TDataSet);
begin
  Dm_Jeton.MainModifK(IBQue_SubscriptionDSUB_ID.AsInteger);
end;

procedure TDm_Param.IBQue_WebHEndAfterPost(DataSet: TDataSet);
begin
  Dm_Jeton.MainModifK(IBQue_WebHEndPRM_ID.AsInteger);
end;

procedure TDm_Param.IBQue_WebHStartAfterPost(DataSet: TDataSet);
begin
  Dm_Jeton.MainModifK(IBQue_WebHStartPRM_ID.AsInteger);
end;

procedure TDm_Param.IBQue_WebIntervaleAfterPost(DataSet: TDataSet);
begin
  Dm_Jeton.MainModifK(IBQue_WebIntervalePRM_ID.AsInteger);
end;

function TDm_Param.LocateLauId(aLauId: Integer): Boolean;
begin
  Result := IBQue_GenLaunch.Locate('LAU_ID',aLauId,[]);
end;

function TDm_Param.LocateDProId(aProId: Integer): Boolean;
begin
  Result := IBQue_ProviderD.Locate('PRO_ID',aProId,[]);
end;

function TDm_Param.LocateTProId(aProId: Integer): Boolean;
begin
  Result := IBQue_ProviderT.Locate('PRO_ID',aProId,[]);
end;

function TDm_Param.LocateRepId(aRepId:Integer): Boolean;
begin
  Result := IBQue_GenReplication.Locate('REP_ID',aRepId,[]);
end;

function TDm_Param.LocateDSubId(aSubId: Integer): Boolean;
begin
  Result := IBQue_SubscriptionD.Locate('SUB_ID',aSubId,[]);
end;

function TDm_Param.LocateTSubId(aSubId: Integer): Boolean;
begin
  Result := IBQue_SubscriptionT.Locate('SUB_ID',aSubId,[]);
end;

function TDm_Param.ModifyProviders(aProId: Integer; aNom: string;
  aLoop: Integer): Boolean;
begin
  IBSql_Req.Close;
  IBSql_Req.SQL.Clear;
  IBSql_Req.SQL.Add('Update GENPROVIDERS Set PRO_NOM = :NOM, PRO_LOOP = :LOOP Where PRO_ID = :PROID');
  IBSql_Req.ParamByName('PROID').AsInteger  := aProId;
  IBSql_Req.ParamByName('NOM').AsString     := aNom;
  IBSql_Req.ParamByName('LOOP').AsInteger   := aLoop;
  IBSql_Req.ExecQuery;
end;

function TDm_Param.ModifySubscribers(aSubId: Integer; aNom: string;
  aLoop: Integer): Boolean;
begin
  IBSql_Req.Close;
  IBSql_Req.SQL.Clear;
  IBSql_Req.SQL.Add('Update GENSUBSCRIBERS Set SUB_NOM = :NOM, SUB_LOOP = :LOOP Where SUB_ID = :SUBID');
  IBSql_Req.ParamByName('SUBID').AsInteger  := aSubId;
  IBSql_Req.ParamByName('NOM').AsString     := aNom;
  IBSql_Req.ParamByName('LOOP').AsInteger   := aLoop;
  IBSql_Req.ExecQuery;
end;

function TDm_Param.PostGenRepication(aMaxOrdre:Integer;aWeb:Boolean): Boolean;
begin
  IBSql_Req.Close;
  IBSql_Req.SQL.Clear;
  IBSql_Req.SQL.Add('INSERT INTO GENREPLICATION (REP_ID, REP_LAUID, REP_PING, '+
                    'REP_PUSH, REP_PULL, REP_USER, REP_PWD, REP_ORDRE, '+
                    'REP_URLLOCAL, REP_URLDISTANT, REP_PLACEEAI, '+
                    'REP_PLACEBASE, REP_JOUR) VALUES (:REP_ID, :REP_LAUID, '+
                    ':REP_PING, :REP_PUSH, :REP_PULL, :REP_USER, :REP_PWD, '+
                    ':REP_ORDRE, :REP_URLLOCAL, :REP_URLDISTANT, :REP_PLACEEAI, '+
                    ':REP_PLACEBASE, :REP_JOUR)');
  IBSql_Req.ParamByName('REP_ID').AsInteger         := IBQue_GenReplicationREP_ID.AsInteger;
  IBSql_Req.ParamByName('REP_LAUID').AsInteger      := IBQue_GenReplicationREP_LAUID.AsInteger;
  IBSql_Req.ParamByName('REP_PING').AsString        := IBQue_GenReplicationREP_PING.AsString;
  IBSql_Req.ParamByName('REP_PUSH').AsString        := IBQue_GenReplicationREP_PUSH.AsString;
  IBSql_Req.ParamByName('REP_PULL').AsString        := IBQue_GenReplicationREP_PULL.AsString;
  IBSql_Req.ParamByName('REP_USER').AsString        := IBQue_GenReplicationREP_USER.AsString;
  IBSql_Req.ParamByName('REP_PWD').AsString         := IBQue_GenReplicationREP_PWD.AsString;

  if aWeb then
    IBSql_Req.ParamByName('REP_ORDRE').AsInteger      := aMaxOrdre - 1
  else
    IBSql_Req.ParamByName('REP_ORDRE').AsInteger      := aMaxOrdre + 1;

  IBSql_Req.ParamByName('REP_URLLOCAL').AsString    := IBQue_GenReplicationREP_URLLOCAL.AsString;
  IBSql_Req.ParamByName('REP_URLDISTANT').AsString  := IBQue_GenReplicationREP_URLDISTANT.AsString;
  IBSql_Req.ParamByName('REP_PLACEEAI').AsString    := IBQue_GenReplicationREP_PLACEEAI.AsString;
  IBSql_Req.ParamByName('REP_PLACEBASE').AsString   := IBQue_GenReplicationREP_PLACEBASE.AsString;
  IBSql_Req.ParamByName('REP_JOUR').AsInteger       := IBQue_GenReplicationREP_JOUR.AsInteger;
  IBSql_Req.ExecQuery;
end;

procedure TDm_Param.RefreshGenLaunch(aBaseId : Integer);
begin
  try
    IBQue_GenLaunch.Close;
    IBQue_GenLaunch.ParamByName('BASID').AsInteger := aBaseId;
    IBQue_GenLaunch.Open;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la récupération des données GenLaunch. (' + e.Message + ')');
    end;
  end;
end;

procedure TDm_Param.RefreshGenParam(aBaseId: Integer);
begin
  try
    IBQue_GenParamNbEssai.Close;
    IBQue_GenParamNbEssai.ParamByName('BASID').AsInteger := aBaseId;
    IBQue_GenParamNbEssai.Open;

    IBQue_GenParamDelai.Close;
    IBQue_GenParamDelai.ParamByName('BASID').AsInteger := aBaseId;
    IBQue_GenParamDelai.Open;

    IBQue_GenParamStart.Close;
    IBQue_GenParamStart.ParamByName('BASID').AsInteger := aBaseId;
    IBQue_GenParamStart.Open;

    IBQue_GenParamEnd.Close;
    IBQue_GenParamEnd.ParamByName('BASID').AsInteger := aBaseId;
    IBQue_GenParamEnd.Open;

    IBQue_GenParamUrl.Close;
    IBQue_GenParamUrl.ParamByName('BASID').AsInteger := aBaseId;
    IBQue_GenParamUrl.Open;

    IBQue_GenParamSender.Close;
    IBQue_GenParamSender.ParamByName('BASID').AsInteger := aBaseId;
    IBQue_GenParamSender.Open;

    IBQue_GenParamDB.Close;
    IBQue_GenParamDB.ParamByName('BASID').AsInteger := aBaseId;
    IBQue_GenParamDB.Open;

    IBQue_GenParamForcerMaj.Close;
    IBQue_GenParamForcerMaj.ParamByName('BASID').AsInteger := aBaseId;
    IBQue_GenParamForcerMaj.Open;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la récupération des données GenParam. (' + e.Message + ')');
    end;
  end;
end;

procedure TDm_Param.RefreshGenReplication(aLauId : Integer);
begin
  try
    IBQue_GenReplication.Close;
    IBQue_GenReplication.ParamByName('LAUID').AsInteger := aLauId;
    IBQue_GenReplication.Open;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la récupération des données GenReplication. (' + e.Message + ')');
    end;
  end;
end;

procedure TDm_Param.RefreshProviders(aRepId: Integer);
begin
  try
    IBQue_ProviderD.Close;
    IBQue_ProviderD.Open;
    IBQue_ProviderD.FetchAll;

    IBQue_ProviderT.Close;
    IBQue_ProviderT.ParamByName('REPID').AsInteger := aRepId;
    IBQue_ProviderT.Open;
    IBQue_ProviderT.FetchAll;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la récupération des Providers. (' + e.Message + ')');
    end;
  end;
end;

procedure TDm_Param.RefreshSubscribers(aRepId: Integer);
begin
  try
    IBQue_SubscriptionD.Close;
    IBQue_SubscriptionD.Open;
    IBQue_SubscriptionD.FetchAll;

    IBQue_SubscriptionT.Close;
    IBQue_SubscriptionT.ParamByName('REPID').AsInteger := aRepId;
    IBQue_SubscriptionT.Open;
    IBQue_SubscriptionT.FetchAll;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la récupération des Subscribers. (' + e.Message + ')');
    end;
  end;
end;

function TDm_Param.RefreshWeb(aBaseId: Integer):Boolean;
begin
  try
    IBQue_WebHStart.Close;
    IBQue_WebHStart.ParamByName('BASID').AsInteger := aBaseId;
    IBQue_WebHStart.Open;

    IBQue_WebHEnd.Close;
    IBQue_WebHEnd.ParamByName('BASID').AsInteger := aBaseId;
    IBQue_WebHEnd.Open;

    IBQue_WebIntervale.Close;
    IBQue_WebIntervale.ParamByName('BASID').AsInteger := aBaseId;
    IBQue_WebIntervale.Open;

    if IBQue_WebHStart.IsEmpty AND IBQue_WebHEnd.IsEmpty AND IBQue_WebIntervale.IsEmpty then
      Result := False
    else
      Result := True;

  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la récupération des données Web. (' + e.Message + ')');
    end;
  end;
end;

function TDm_Param.SetRepIdPlaceBase(aPlaceBase: string): Boolean;
begin
  Result := False;
  try
    IBQue_GenReplicationREP_PLACEBASE.AsString := aPlaceBase;
    Result := True;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de l''affectation du chemain de la base. (' + e.Message + ')');
      Result := False;
    end;
  end;
end;

function TDm_Param.SetRepIdPlaceEAI(aPlaceEAI: string): Boolean;
begin
  Result := False;
  try
    IBQue_GenReplicationREP_PLACEEAI.AsString := aPlaceEAI;
    Result := True;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de l''affectation du chemain des fichiers EAI. (' + e.Message + ')');
      Result := False;
    end;
  end;
end;

function TDm_Param.SetReplicTpsReelEnd(aTime: TDateTime): Boolean;
begin
  Result := False;
  try
    IBQue_GenParamEndPRM_FLOAT.AsFloat := aTime;
    Result := True;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de l''affectation de l''heure de fin de la réplication temps réel. (' + e.Message + ')');
      Result := False;
    end;
  end;
end;

function TDm_Param.SetReplicTpsReelStart(aTime: TDateTime): Boolean;
begin
  Result := False;
  try
    IBQue_GenParamStartPRM_FLOAT.AsFloat := aTime;
    Result := True;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de l''affectation de l''heure de début de la réplication temps réel. (' + e.Message + ')');
      Result := False;
    end;
  end;
end;

function TDm_Param.SetWebHEnd(aTime: TDateTime): Boolean;
begin
  Result := False;
  try
    IBQue_WebHEndPRM_FLOAT.AsFloat := aTime;
    Result := True;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de l''affectation de l''heure de fin du Web. (' + e.Message + ')');
      Result := False;
    end;
  end;
end;

function TDm_Param.SetWebHStart(aTime: TDateTime): Boolean;
begin
  Result := False;
  try
    IBQue_WebHStartPRM_FLOAT.AsFloat := aTime;
    Result := True;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de l''affectation de l''heure de début du Web. (' + e.Message + ')');
      Result := False;
    end;
  end;
end;

procedure TDm_Param.StartModifyGenLaunch;
begin
  try
    IBQue_GenLaunch.Edit;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors du lancement des modifications de GenLaunch. (' + e.Message + ')');
    end;
  end;
end;

procedure TDm_Param.StartModifyGenParam;
begin
  try
    IBQue_GenParamNbEssai.Edit;
    IBQue_GenParamDelai.Edit;
    IBQue_GenParamStart.Edit;
    IBQue_GenParamEnd.Edit;
    IBQue_GenParamUrl.Edit;
    IBQue_GenParamSender.Edit;
    IBQue_GenParamDB.Edit;
    IBQue_GenParamForcerMaj.Edit;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors du lancement des modifications de GenParam. (' + e.Message + ')');
    end;
  end;
end;

procedure TDm_Param.StartModifyGenReplication;
begin
  try
    IBQue_GenReplication.Edit;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors du lancement des modifications de GenReplication. (' + e.Message + ')');
    end;
  end;
end;

function TDm_Param.StartModifyWeb:Boolean;
begin
  try
    if not IBQue_WebHStart.IsEmpty then
    begin
      IBQue_WebHStart.Edit;
      IBQue_WebHEnd.Edit;
      IBQue_WebIntervale.Edit;
      Result := True;
    end
    else
    begin
      Result := False;
    end;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors du lancement des modifications du Web. (' + e.Message + ')');
    end;
  end;
end;

procedure TDm_Param.UpProId(aRepId : Integer);
var
  idD,                //Id du Provider de la liste disponible
  idT : Integer;      //Id du Provider de la liste traité
begin
  try
    //afin de garder la position actuel
    idD := IBQue_ProviderDPRO_ID.AsInteger;
    idT := IBQue_ProviderTPRO_ID.AsInteger;

    //Démarre une transaction
    if Dm_Jeton.Tra_Ginkoia.InTransaction then
      Dm_Jeton.Tra_Ginkoia.Commit;
    Dm_Jeton.Tra_Ginkoia.StartTransaction;

    IBQue_ProviderD.Open;
    LocateDProId(idD);
    if IBQue_ProviderDPRO_ORDRE.AsInteger > 1 then    //Si nous ne somme pas au début
    begin
      IBQue_ProviderD.Edit;
      IBQue_ProviderDPRO_ORDRE.AsInteger := IBQue_ProviderDPRO_ORDRE.AsInteger - 1;
      IBQue_ProviderD.Post;

      IBQue_ProviderD.Prior;

      IBQue_ProviderD.Edit;
      IBQue_ProviderDPRO_ORDRE.AsInteger := IBQue_ProviderDPRO_ORDRE.AsInteger + 1;
      IBQue_ProviderD.Post;
    end;

    Dm_Jeton.Tra_Ginkoia.Commit;

    RefreshProviders(aRepId);   //On ne refresh que le Providers

    LocateDProId(idD);          //On se repositionne sur pour les 2 grilles
    LocateTProId(idT);
  except on e:Exception do
    begin
      ShowMessage('Erreur lors du changement d''ordre d''un Provider. (' + e.Message + ')');
      Dm_Jeton.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TDm_Param.UpRepId(aWeb:Boolean);
var
  i,
  id  : Integer;
begin
  try
    id := IBQue_GenReplicationREP_ID.AsInteger;     //Récupère l'Id de l'enregistrement courrant

    //Démarre une transaction
    if Dm_Jeton.Tra_Ginkoia.InTransaction then
      Dm_Jeton.Tra_Ginkoia.Commit;
    Dm_Jeton.Tra_Ginkoia.StartTransaction;

    IBQue_GenReplication.Open;
    LocateRepId(id);
    if aWeb then
    begin
      if IBQue_GenReplicationREP_ORDRE.AsInteger < -1 then    //Si nous ne somme pas au début
      begin
        IBQue_GenReplication.Edit;
        IBQue_GenReplicationREP_ORDRE.AsInteger := IBQue_GenReplicationREP_ORDRE.AsInteger + 1;
        IBQue_GenReplication.Post;

        IBQue_GenReplication.Prior;

        IBQue_GenReplication.Edit;
        IBQue_GenReplicationREP_ORDRE.AsInteger := IBQue_GenReplicationREP_ORDRE.AsInteger - 1;
        IBQue_GenReplication.Post;
      end;
    end
    else
    begin
      if IBQue_GenReplicationREP_ORDRE.AsInteger > 1 then    //Si nous ne somme pas au début
      begin
        IBQue_GenReplication.Edit;
        IBQue_GenReplicationREP_ORDRE.AsInteger := IBQue_GenReplicationREP_ORDRE.AsInteger - 1;
        IBQue_GenReplication.Post;

        IBQue_GenReplication.Prior;

        IBQue_GenReplication.Edit;
        IBQue_GenReplicationREP_ORDRE.AsInteger := IBQue_GenReplicationREP_ORDRE.AsInteger + 1;
        IBQue_GenReplication.Post;
      end;
    end;

    Dm_Jeton.Tra_Ginkoia.Commit;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors du changement d''ordre d''une réplication. (' + e.Message + ')');
      Dm_Jeton.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TDm_Param.UpSubId(aRepId : Integer);
var
  idD,                //Id du Provider de la liste disponible
  idT : Integer;      //Id du Provider de la liste traité
begin
  try
    //afin de garder la position actuel
    idD := IBQue_SubscriptionDSUB_ID.AsInteger;
    idT := IBQue_SubscriptionTSUB_ID.AsInteger;

    //Démarre une transaction
    if Dm_Jeton.Tra_Ginkoia.InTransaction then
      Dm_Jeton.Tra_Ginkoia.Commit;
    Dm_Jeton.Tra_Ginkoia.StartTransaction;

    IBQue_SubscriptionD.Open;
    LocateDSubId(idD);
    if IBQue_SubscriptionDSUB_ORDRE.AsInteger > 1 then    //Si nous ne somme pas au début
    begin
      IBQue_SubscriptionD.Edit;
      IBQue_SubscriptionDSUB_ORDRE.AsInteger := IBQue_SubscriptionDSUB_ORDRE.AsInteger - 1;
      IBQue_SubscriptionD.Post;

      IBQue_SubscriptionD.Prior;

      IBQue_SubscriptionD.Edit;
      IBQue_SubscriptionDSUB_ORDRE.AsInteger := IBQue_SubscriptionDSUB_ORDRE.AsInteger + 1;
      IBQue_SubscriptionD.Post;
    end;

    Dm_Jeton.Tra_Ginkoia.Commit;

    RefreshSubscribers(aRepId);   //On ne refresh que le Subscribers

    LocateDSubId(idD);          //On se repositionne sur pour les 2 grilles
    LocateTSubId(idT);
  except on e:Exception do
    begin
      ShowMessage('Erreur lors du changement d''ordre d''un Subscriber. (' + e.Message + ')');
      Dm_Jeton.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TDm_Param.VerifOrdreReplic;
var
  i : Integer;
begin
  try
    //Démarre une transaction
    if Dm_Jeton.Tra_Ginkoia.InTransaction then
      Dm_Jeton.Tra_Ginkoia.Commit;
    Dm_Jeton.Tra_Ginkoia.StartTransaction;
      //Boucle pour s'assurer que les ordres des Réplications se suivent bien
    i := 1;
    IBQue_GenReplication.Open;
    IBQue_GenReplication.First;
    while (not IBQue_GenReplication.Eof) or (IBQue_GenReplication.RecordCount >= i)   do
    begin
      IBQue_GenReplication.Edit;
      IBQue_GenReplicationREP_ORDRE.AsInteger := i;
      IBQue_GenReplication.Post;
      IBQue_GenReplication.Next;
      Inc(i);
    end;
    Dm_Jeton.Tra_Ginkoia.Commit;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la vérification de l''ordre des Réplications. (' + e.Message + ')');
      Dm_Jeton.Tra_Ginkoia.Rollback;
    end;
  end;
end;

procedure TDm_Param.VerifOrdreWeb;
var
  i : Integer;
begin
  try
    //Démarre une transaction
    if Dm_Jeton.Tra_Ginkoia.InTransaction then
      Dm_Jeton.Tra_Ginkoia.Commit;
    Dm_Jeton.Tra_Ginkoia.StartTransaction;
      //Boucle pour s'assurer que les ordres des Réplications se suivent bien
    i := -1;
    IBQue_GenReplication.Open;
    IBQue_GenReplication.First;
    while (not IBQue_GenReplication.Eof) or (IBQue_GenReplication.RecordCount >= ABS(i))   do
    begin
      IBQue_GenReplication.Edit;
      IBQue_GenReplicationREP_ORDRE.AsInteger := i;
      IBQue_GenReplication.Post;
      IBQue_GenReplication.Next;
      Dec(i);
    end;
    Dm_Jeton.Tra_Ginkoia.Commit;
  except on e:Exception do
    begin
      ShowMessage('Erreur lors de la vérification de l''ordre des Réplications. (' + e.Message + ')');
      Dm_Jeton.Tra_Ginkoia.Rollback;
    end;
  end;
end;

end.
