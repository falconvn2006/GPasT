unit MonitorConsolide_DM;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IB_Components, DB, IBODataset, IBDatabase, Main_Frm, DBClient,
  Constante_CBR;

type
  TFMonitorConsolide_DM = class(TForm)
    IbC_MonitorConsolide: TIB_Connection;
    Que_ConsoMonitor: TIBOQuery;
    CDS_SENDER: TClientDataSet;
    CDS_SRV: TClientDataSet;
    CDS_RAISON: TClientDataSet;
    CDS_HDB: TClientDataSet;
    CDS_GRP: TClientDataSet;
    CDS_FOLDER: TClientDataSet;
    CDS_SRVSRV_ID: TIntegerField;
    CDS_SRVSRV_NAME: TStringField;
    CDS_SRVSRV_IP: TStringField;
    CDS_SRVNewID: TIntegerField;
    CDS_SRVEstOrphelin: TBooleanField;
    CDS_RAISONRAISON_ID: TIntegerField;
    CDS_RAISONRAISON_NAME: TStringField;
    CDS_RAISONNewId: TIntegerField;
    CDS_RAISONEstOrphelin: TBooleanField;
    CDS_FOLDERFLD_ID: TIntegerField;
    CDS_FOLDERFLD_DATABASE: TStringField;
    CDS_FOLDERSRV_ID: TIntegerField;
    CDS_FOLDERFLD_PATH: TStringField;
    CDS_FOLDERGRP_ID: TIntegerField;
    CDS_FOLDERFLD_INSTALL: TDateTimeField;
    CDS_FOLDERNewId: TIntegerField;
    CDS_FOLDEREstOrphelin: TBooleanField;
    CDS_GRPGRP_ID: TIntegerField;
    CDS_GRPGRP_NOM: TStringField;
    CDS_GRPNewId: TIntegerField;
    CDS_GRPEstOrphelin: TBooleanField;
    CDS_SENDERSENDER_ID: TIntegerField;
    CDS_SENDERSENDER_NAME: TStringField;
    CDS_SENDERSENDER_DATA: TStringField;
    CDS_SENDERFLD_ID: TIntegerField;
    CDS_SENDERSENDER_INSTALL: TDateTimeField;
    CDS_SENDERSENDER_MAGID: TIntegerField;
    CDS_SENDERNewId: TIntegerField;
    CDS_SENDEREstOrphelin: TBooleanField;
    CDS_HDBHDB_ID: TIntegerField;
    CDS_HDBSENDER_ID: TIntegerField;
    CDS_HDBHDB_CYCLE: TDateTimeField;
    CDS_HDBHDB_OK: TIntegerField;
    CDS_HDBRAISON_ID: TIntegerField;
    CDS_HDBHDB_COMENTAIRE: TStringField;
    CDS_HDBHDB_ARCHIVER: TIntegerField;
    CDS_HDBHDB_DATE: TDateTimeField;
    CDS_HDBNewId: TIntegerField;
    CDS_HDBEstOrphelin: TBooleanField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private

    procedure RemplirCDS_SENDER(vpLastID : Integer);
    procedure RemplirCDS_FOLDER(vpLastID : Integer);
    procedure RemplirCDS_SRV(vpLastID : Integer);
    procedure RemplirCDS_GRP(vpLastID : Integer);
    procedure RemplirCDS_HDB(vpLastID : Integer);
    procedure RemplirCDS_RAISON(vpLastID : Integer);
  public
    procedure ChargerBaseConsoMonitor;
    procedure ChargerCDS(vpTable : TTypeMaTable);
  end;

var
  FMonitorConsolide_DM: TFMonitorConsolide_DM;

implementation


{$R *.dfm}

procedure TFMonitorConsolide_DM.FormCreate(Sender: TObject);
begin
  if FileExists(FMain.PathConsoMonitorBDD) then
  begin
    IbC_MonitorConsolide.Database := FMain.PathConsoMonitorBDD;
    IbC_MonitorConsolide.Connect;
  end;

  //IbC_MonitorConsolide.Connect;   //SR : Mise en commentaire
end;

procedure TFMonitorConsolide_DM.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := CaFree;
end;

//------------------------------------------------------------------------------
//                                                           +-----------------+
//                                                           |   REMPLIR CDS   |
//                                                           +-----------------+
//------------------------------------------------------------------------------

//-------------------------------------------------> ChargerBaseConsoMonitor

procedure TFMonitorConsolide_DM.ChargerBaseConsoMonitor;
begin
  // on va charger la base consoMonitor sans tenir compte du lastId
  RemplirCDS_SENDER(0);
  RemplirCDS_FOLDER(0);
  RemplirCDS_SRV(0);
  RemplirCDS_GRP(0);
  RemplirCDS_HDB(0);
  RemplirCDS_RAISON(0);
end;

//--------------------------------------------------------------> ChargerCDS

procedure TFMonitorConsolide_DM.ChargerCDS(vpTable : TTypeMaTable);
begin
  case vpTable.TypeProvenance of
    tpEmetteur : RemplirCDS_SENDER(vpTable.Last_Id);
    tpDossier  : RemplirCDS_FOLDER(vpTable.Last_Id);
    tpSRV      : RemplirCDS_SRV(vpTable.Last_Id);
    tpGRP      : RemplirCDS_GRP(vpTable.Last_Id);
    tpHDB      : RemplirCDS_HDB(vpTable.Last_Id);
    tpRAISON   : RemplirCDS_RAISON(vpTable.Last_Id);
  end
end;

{$REGION ' Remplir les CDS '}
//-------------------------------------------------------> RemplirCDS_SENDER

procedure TFMonitorConsolide_DM.RemplirCDS_SENDER(vpLastID : Integer);
begin
  with Que_ConsoMonitor do
  begin
    Close;
    SQL.Clear;
    CDS_SENDER.EmptyDataSet;

    try
      SQL.Add(' select *');
      SQL.Add(' from  SENDER');
      SQL.Add(' where SENDER_ID > :LASTID');

      ParamCheck := True;
      ParamByName('LASTID').AsInteger := vpLastId;

      Open;

      while not EoF do
      begin
        try
          CDS_SENDER.Append;

          CDS_SENDER.FieldByName('SENDER_ID').AsInteger       := FieldByName('SENDER_ID').AsInteger;
          CDS_SENDER.FieldByName('SENDER_NAME').AsString      := FieldByName('SENDER_NAME').AsString;
          CDS_SENDER.FieldByName('SENDER_DATA').AsString      := FieldByName('SENDER_DATA').AsString;
          CDS_SENDER.FieldByName('FLD_ID').AsInteger          := FieldByName('FLD_ID').AsInteger;
          CDS_SENDER.FieldByName('SENDER_INSTALL').AsDateTime := FieldByName('SENDER_INSTALL').AsDateTime;
          CDS_SENDER.FieldByName('SENDER_MAGID').AsInteger    := FieldByName('SENDER_MAGID').AsInteger;
          CDS_SENDER.FieldByName('NewID').AsInteger           := 0;
          CDS_SENDER.FieldByName('EstOrphelin').AsBoolean     := True;

          CDS_SENDER.Post;
        except
          CDS_SENDER.Cancel;
        end;

        Next;
      end;

      Close;
    except
      //
    end;
  end;
end;

//----------------------------------------------------------> RemplirCDS_SRV

procedure TFMonitorConsolide_DM.RemplirCDS_SRV(vpLastID : Integer);
begin
  with Que_ConsoMonitor do
  begin
    Close;
    SQL.Clear;
    CDS_SRV.EmptyDataSet;

    try
      SQL.Add(' select *');
      SQL.Add(' from  SRV');
      SQL.Add(' where SRV_ID > :LASTID');

      ParamCheck := True;
      ParamByName('LASTID').AsInteger := vpLastId;

      Open;

      while not EoF do
      begin
        try
          CDS_SRV.Append;

          CDS_SRV.FieldByName('SRV_ID').AsInteger      := FieldByName('SRV_ID').AsInteger;
          CDS_SRV.FieldByName('SRV_NAME').AsString     := FieldByName('SRV_NAME').AsString;
          CDS_SRV.FieldByName('SRV_IP').AsString       := FieldByName('SRV_IP').AsString;
          CDS_SRV.FieldByName('NewID').AsInteger       := 0;
          CDS_SRV.FieldByName('EstOrphelin').AsBoolean := True;

          CDS_SRV.Post;
        except
          CDS_SRV.Cancel;
        end;

        Next;
      end;

      Close;
    except
      //
    end;
  end;
end;

//----------------------------------------------------------> RemplirCDS_GRP

procedure TFMonitorConsolide_DM.RemplirCDS_GRP(vpLastID : Integer);
begin
  with Que_ConsoMonitor do
  begin
    Close;
    SQL.Clear;
    CDS_GRP.EmptyDataSet;

    try
      SQL.Add(' select *');
      SQL.Add(' from  GRP');
      SQL.Add(' where GRP_ID > :LASTID');

      ParamCheck := True;
      ParamByName('LASTID').AsInteger := vpLastId;

      Open;

      while not EoF do
      begin
        try
          CDS_GRP.Append;

          CDS_GRP.FieldByName('GRP_ID').AsInteger      := FieldByName('GRP_ID').AsInteger;
          CDS_GRP.FieldByName('GRP_NOM').AsString      := FieldByName('GRP_NOM').AsString;
          CDS_GRP.FieldByName('NewID').AsInteger       := 0;
          CDS_GRP.FieldByName('EstOrphelin').AsBoolean := True;

          CDS_GRP.Post;
        except
          CDS_GRP.Cancel;
        end;

        Next;
      end;

      Close;
    except
      //
    end;
  end;
end;

//-------------------------------------------------------> RemplirCDS_FOLDER

procedure TFMonitorConsolide_DM.RemplirCDS_FOLDER(vpLastID : Integer);
begin
  try
    Que_ConsoMonitor.Close;
    Que_ConsoMonitor.SQL.Clear;
    CDS_FOLDER.EmptyDataSet;

    Que_ConsoMonitor.SQL.Add(' select *');
    Que_ConsoMonitor.SQL.Add(' from  FOLDER');
    Que_ConsoMonitor.SQL.Add(' where FLD_ID > :LASTID');

    Que_ConsoMonitor.ParamCheck := True;
    Que_ConsoMonitor.ParamByName('LASTID').AsInteger := vpLastId;

    Que_ConsoMonitor.Open;

    while not EoF do
    begin
      try
        CDS_FOLDER.Append;

        CDS_FOLDER.FieldByName('FLD_ID').AsInteger       := Que_ConsoMonitor.FieldByName('FLD_ID').AsInteger;
        CDS_FOLDER.FieldByName('FLD_DATABASE').AsString  := Que_ConsoMonitor.FieldByName('FLD_DATABASE').AsString;
        CDS_FOLDER.FieldByName('SRV_ID').AsInteger       := Que_ConsoMonitor.FieldByName('SRV_ID').AsInteger;
        CDS_FOLDER.FieldByName('FLD_PATH').AsString      := Que_ConsoMonitor.FieldByName('FLD_PATH').AsString;
        CDS_FOLDER.FieldByName('GRP_ID').AsInteger       := Que_ConsoMonitor.FieldByName('GRP_ID').AsInteger;
        CDS_FOLDER.FieldByName('FLD_INSTALL').AsDateTime := Que_ConsoMonitor.FieldByName('FLD_INSTALL').AsDateTime;
        CDS_FOLDER.FieldByName('NewID').AsInteger        := 0;
        CDS_FOLDER.FieldByName('EstOrphelin').AsBoolean  := True;

        CDS_FOLDER.Post;
      except
        CDS_FOLDER.Cancel;
      end;

      Que_ConsoMonitor.Next;
    end;

    Que_ConsoMonitor.Close;
  except
    //
  end;
end;


//----------------------------------------------------------> RemplirCDS_HDB

procedure TFMonitorConsolide_DM.RemplirCDS_HDB(vpLastID : Integer);
begin
  with Que_ConsoMonitor do
  begin
    Close;
    SQL.Clear;
    CDS_HDB.EmptyDataSet;

    try
      SQL.Add(' select *');
      SQL.Add(' from  HDB');
      SQL.Add(' where HDB_ID > :LASTID');
      SQL.Add(' and   HDB_CYCLE >= :PCYCLE');

      ParamCheck := True;
      ParamByName('LASTID').AsInteger  := vpLastId;

      ParamByName('PCYCLE').AsDateTime := encodeDate(2013, 01, 01);

      Open;

      while not EoF do
      begin
        try
          CDS_HDB.Append;

          CDS_HDB.FieldByName('HDB_ID').AsInteger        := FieldByName('HDB_ID').AsInteger;
          CDS_HDB.FieldByName('SENDER_ID').AsInteger     := FieldByName('SENDER_ID').AsInteger;
          CDS_HDB.FieldByName('HDB_CYCLE').AsDateTime    := FieldByName('HDB_CYCLE').AsDateTime;
          CDS_HDB.FieldByName('HDB_OK').AsInteger        := FieldByName('HDB_OK').AsInteger;
          CDS_HDB.FieldByName('RAISON_ID').AsInteger     := FieldByName('RAISON_ID').AsInteger;
          CDS_HDB.FieldByName('HDB_COMENTAIRE').AsString := FieldByName('HDB_COMENTAIRE').AsString;
          CDS_HDB.FieldByName('HDB_ARCHIVER').AsInteger  := FieldByName('HDB_ARCHIVER').AsInteger;
          CDS_HDB.FieldByName('HDB_DATE').AsDateTime     := FieldByName('HDB_DATE').AsDateTime;
          CDS_HDB.FieldByName('NewID').AsInteger         := 0;
          CDS_HDB.FieldByName('EstOrphelin').AsBoolean   := True;

          CDS_HDB.Post;
        except
          CDS_HDB.Cancel;
        end;

        Next;
      end;

      Close;
    except
      // on E : Exception do showMessage(E.Message);
    end;
  end;
end;

//-------------------------------------------------------> RemplirCDS_RAISON

procedure TFMonitorConsolide_DM.RemplirCDS_RAISON(vpLastID : Integer);
begin
  with Que_ConsoMonitor do
  begin
    Close;
    SQL.Clear;
    CDS_RAISON.EmptyDataSet;

    try
      SQL.Add(' select *');
      SQL.Add(' from  RAISON');
      SQL.Add(' where RAISON_ID > :LASTID');

      ParamCheck := True;
      ParamByName('LASTID').AsInteger := vpLastId;

      Open;

      while not EoF do
      begin
        try
          CDS_RAISON.Append;

          CDS_RAISON.FieldByName('RAISON_ID').AsInteger   := FieldByName('RAISON_ID').AsInteger;
          CDS_RAISON.FieldByName('RAISON_NAME').AsString  := FieldByName('RAISON_NAME').AsString;
          CDS_RAISON.FieldByName('NewID').AsInteger       := 0;
          CDS_RAISON.FieldByName('EstOrphelin').AsBoolean := True;

          CDS_RAISON.Post;
        except
          CDS_RAISON.Cancel;
        end;

        Next;
      end;

      Close;
    except
      //
    end;
  end;
end;
{$ENDREGION ' Remplir les CDS '}

end.
