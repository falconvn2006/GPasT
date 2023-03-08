unit uEasy.Types;

interface

CONST CST_LAME2MAG = 'LAME2MAG';
      CST_MAG2LAME = 'MAG2LAME';

      LBL_LAME2MAG = 'Lame vers Magasin';
      LBL_MAG2LAME = 'Magasin vers Lame';

// pour recupbase
      CST_DELOS2EASY = 'DELOS2EASY';
      CST_DEJAEASY   = 'DEJAEASY';



type
     TEasyBase = packed record
        BAS_SENDER   : string;
        CAL_SYMNODE  : string;  // Tel qu'il est calculé selon le sender
        NODE_ID      : string;  // tel qu'il est enregistré dans la base ca doit etre pareil que CAL_SYMNODE
        BAS_CENTRALE : string;
        BAS_IDENT    : Integer;
        BAS_GUID     : string;
        LAST_REPLIC  : TDateTime;
     end;
     TEasyBases = array of TEasyBase;

     TNode = packed record
        NODE_ID        : string;
        NODE_GROUP_ID  : string;
        HEARTBEAT_TIME : TDateTime;
        REGISTRATION_TIME : TDateTime;
     end;
     TNodes = array of TNode;


  // --------------------------------
  // POUR LE MONITORING
  TSenderNode = record
    SENDER         : string;
    NODEID         : string;
    GUID           : string;
    NOMPOURNOUS    : string;
    HEARTBEAT_TIME : string;
  public
    Procedure Init;
  end;
  TSenderNodes = array of TSenderNode;

  TUnsentBatch    = record
    BATCHCOUNT  : Integer;
    DATACOUNT   : integer;
    STATUS      : string;
    NODEID      : string;
    OLDESTBATCH : string;
    SenderNode  : TSenderNode;
  public
    Procedure Init;
  end;
  TUnsentBatchs  = array of TUnsentBatch;
  // --------------------------------


  TLastRepicDelo = record
    HEV_DATE    : TDateTime;
    BAS_SENDER  : string;
    K_VERSION   : integer;
    K_UPDATED   : TDateTime;
  public
    Procedure Init;
  end;

  TLastRepicDelos  = array of TLastRepicDelo;
  // --------------------------------

  TKVersion = record
    K_VERSION : integer;
    DATETIME : TDateTime;
  end;

  TIndex = record
    Index : string;
    Table : string;
  end;
  TIndexs = array of TIndex;
  // --------------------------

  // pour la Grille du Backup Restore pas encore utliser...
  TBRRecord = record
    ID          : Integer;
    DOSSIER     : string;
    EASYSERVICE : String;
    EASYDIR     : String;
    PropertiesFile : String;
    IBFILE      : String;
    TIME        : integer;
    LASTBR      : TDateTime; // Tentative
    LASTBROK    : TDateTime; // BR OK
    LASTRESULT  : integer;   // Last Resultat
    // LASTOPTIM   : TDateTime; //
    // options
    // WITHOLDIB   : integer;
    COMPRESS7Z  : Integer;
    // TIME_OPTIMIZE : integer;
    // ------------------
    PAGEBUFFERS  : integer;
    InstanceName : string;

  public
    Procedure Init;
  end;
  TBRArray = array of TBRRecord;
  //------------------------

  TMyFile = record
    FileName : string;
    CreateDateTime : TDateTime;
  end;
  TMyFiles = array of TMyFile;


implementation


procedure  TBRRecord.Init;
begin
    Self.ID          :=0;
    Self.DOSSIER     :='';
    Self.EASYSERVICE :='';
    Self.EASYDIR     :='';
    Self.PropertiesFile :='';
    Self.IBFILE      :='';
    Self.LASTBROK    :=0;
    Self.TIME        :=0;
    Self.LASTBR      :=0;
    Self.LASTRESULT  :=0;
//    Self.LASTOPTIM   :=0;
//    Self.WITHOLDIB   :=0;
    Self.COMPRESS7Z  :=0;
    Self.PAGEBUFFERS := 4096;
    Self.InstanceName := '';
//    Self.TIME_OPTIMIZE := 450;
end;



procedure TLastRepicDelo.Init;
begin
    HEV_DATE    :=0;
    BAS_SENDER  :='';
    K_VERSION   :=0;
    K_UPDATED   :=0;
end;

procedure TSenderNode.Init;
begin
  Self.SENDER := '';
  Self.NODEID := '';
  Self.GUID   := '';
  Self.NOMPOURNOUS    := '';
  Self.HEARTBEAT_TIME := '';
end;


procedure TUnsentBatch.Init;
begin
  Self.BATCHCOUNT:=0;
  Self.DATACOUNT:=0;
  Self.STATUS:='';
  Self.NODEID:='';
  Self.OLDESTBATCH:='';
  Self.SenderNode.Init;
end;


end.
