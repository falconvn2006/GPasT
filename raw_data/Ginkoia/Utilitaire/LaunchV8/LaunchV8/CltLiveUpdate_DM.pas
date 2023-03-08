UNIT CltLiveUpdate_DM;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ScktComp, ExtCtrls, Db, IBCustomDataSet, IBQuery, IBDatabase;

TYPE
    TDm_CltLiveUpdate = CLASS(TDataModule)
        Tim_VerifProb: TTimer;
        ClientLive: TClientSocket;
        data: TIBDatabase;
        Tran: TIBTransaction;
        QryBase: TIBQuery;
        qry: TIBQuery;
        PROCEDURE ClientLiveConnect(Sender: TObject; Socket: TCustomWinSocket);
        PROCEDURE ClientLiveDisconnect(Sender: TObject;
            Socket: TCustomWinSocket);
        PROCEDURE ClientLiveError(Sender: TObject; Socket: TCustomWinSocket;
            ErrorEvent: TErrorEvent; VAR ErrorCode: Integer);
        PROCEDURE ClientLiveRead(Sender: TObject; Socket: TCustomWinSocket);
        PROCEDURE Tim_VerifProbTimer(Sender: TObject);
    PRIVATE
        { Déclarations privées }
    PUBLIC
        { Déclarations publiques }
        Fini: Boolean;
        ok: boolean;
        Vers: STRING;
        Raison: Integer;
        FUNCTION LiveUpdate(Base: STRING): Boolean;
    END;

VAR
    Dm_CltLiveUpdate: TDm_CltLiveUpdate;

IMPLEMENTATION

{$R *.DFM}

{ TDm_CltLiveUpdate }

FUNCTION TDm_CltLiveUpdate.LiveUpdate(Base: STRING): Boolean;
VAR
    Magasin: STRING;
    societe: STRING;
    LaVersion: STRING;
BEGIN
    result := false;
    Raison := 0;
    TRY
        data.databaseName := Base;
        QryBase.Open;
        Magasin := QryBase.Fields[0].AsString;
        societe := QryBase.Fields[1].AsString;
        QryBase.Close;
        Qry.Open;
        LaVersion := qry.fields[0].asstring;
        data.Connected := false;

        Vers := 'SALUT;' + Magasin + ';' + Societe + ';' + LaVersion;
        Fini := False; ok := false;
        Tim_VerifProb.Enabled := true;
        ClientLive.Open;
        WHILE NOT fini DO
            Application.processmessages;
        result := ok;
        Tim_VerifProb.Enabled := false;
    EXCEPT
    END;
END;

PROCEDURE TDm_CltLiveUpdate.ClientLiveConnect(Sender: TObject;
    Socket: TCustomWinSocket);
BEGIN
    Tim_VerifProb.Enabled := True;
    ClientLive.Socket.SendText(Vers);
END;

PROCEDURE TDm_CltLiveUpdate.ClientLiveDisconnect(Sender: TObject;
    Socket: TCustomWinSocket);
BEGIN
    fini := true;
END;

PROCEDURE TDm_CltLiveUpdate.ClientLiveError(Sender: TObject;
    Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
    VAR ErrorCode: Integer);
BEGIN
    fini := true;
    Raison := 1;
    errorcode := 0;
END;

PROCEDURE TDm_CltLiveUpdate.ClientLiveRead(Sender: TObject;
    Socket: TCustomWinSocket);
VAR
    s: STRING;
BEGIN
    TIM_VerifPROB.Enabled := false;
    S := Socket.ReceiveText;
    Ok := S = 'YES';
    ClientLive.Socket.SendText('Deconnexion');
    ClientLive.Close;
    TIM_VerifPROB.Enabled := true;
    fini := true;
END;

PROCEDURE TDm_CltLiveUpdate.Tim_VerifProbTimer(Sender: TObject);
BEGIN
    fini := true;
    Raison := 2;
END;

END.
