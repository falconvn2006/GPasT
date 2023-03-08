unit uCommon_Type;

interface

uses classes;

TYPE

  TFTPData = record
    Host ,
    User ,
    Psw  : String;
    Port : Integer;

    // chemin sur le FTP
    FTPDirectory ,
    // Filtre des fichiers a récupérer (ex: *.xml ou *.* ou *.txt)
    FileFilter   ,

    // Chemin sur le PC
    SourcePath   ,         // dans le cas des upload de fichier
    SavePath     : String; // dans le cas des download de fichier

    bDeleteFile : Boolean; // Supprime t on les fichiers après traitement ?
    bArchiveFile : Boolean; // Après un upload, archive les fichiers
    FileList : TStringList; // Liste des fichiers à traiter
  end;

  stParam = RECORD
    // Infos pour les commandes
    iPseudoLivr: integer;
    iVendeur: integer;
    iMagID: integer;
    iProjet: integer;
    iTypeCDV: integer;
    iTarif: integer;

    // FTP
    sFTPHost, sFTPUser, sFTPPwd, sFTPPort: STRING;

    iFTPNbTry: Integer;

    bDelFTPFiles: boolean;

    // Reception
    FTPGetFolder: STRING; // dossier sur le serveur FTP contenant les fichiers à GET

    // Envoi
    bFTPValidEnvoi: Boolean; // Vérif ou non du fichier envoyé par un get
    sFTPSendFolder: STRING; // dossier sur le serveur FTP où déposer les fichiers à PUT
    sFTPSendExtention: STRING; // Type des fichiers à envoyer

    // EMail
    sSMTPHost: STRING;
    sSMTPUser: STRING;
    sSMTPPwd: STRING;
    sSMTPPort: STRING;
    sMailDest: STRING;
    sMailExp: STRING;
    sMailSecu : Integer;

    // Chemins locaux pour get/send ftp
    sGetFolder: STRING;
    sToSendFolder: STRING;
    sSentFolder: STRING;

    bSend, bGet: Boolean;
    sTypeSend, sTypeGet: STRING;

    // Informations de dernier traitement
    dtLastTime, dtCurrentTime: TDateTime;

    sURLGet, sLoginGet, sPassGet: STRING;
    sURLSend, sLoginSend, sPassSend: STRING;

    sLocalFolderGet: STRING;
    sLocalFolderSend: STRING;

    iAssID, iAsfId: Integer;
    iCodeSite: Integer;
    sNomSite: STRING;

    FTPGenCSV ,
    FTPGenGet ,
    FTPGenFacture : TFTPData;
  END;

  stIniParam = RECORD
    iNbErreurFTPBeforePrompt: integer;

    // DB
    sDBPath: STRING;

    iDelOldLogAge: integer;
    bDelOldLog: boolean;
    iNiveauLog: integer;

    dtHier: TDateTime;
    iNbJourHier: Integer;

    iMarketId : Integer;

    //TimeOut
    iConnect  : Integer;
    iTransfer : Integer;
    iRead     : Integer;

    //vte privé
    NbJrsGardeTraite:integer;
    NbJrsGardeErreur:integer;
  END;
  stMontant = RECORD
    fTVA: double;
    fMontantTVA: double;
    fMontantTTC: double;
  END;

  tbMontant = ARRAY OF stMontant;

  stUneAdresse = RECORD
    sAdr_Civ: STRING;
    sAdr_Nom: STRING;
    sAdr_Prenom: STRING;
    sAdr_Ste: STRING;
    sAdr_Adr1: STRING;
    sAdr_Adr2: STRING;
    sAdr_Adr3: STRING;
    sAdr_CP: STRING;
    sAdr_Ville: STRING;
    sAdr_Pays: STRING;
    sAdr_PaysISO: STRING;
    sAdr_Tel: STRING;
    sAdr_Gsm: STRING;
    sAdr_Fax: STRING;
  END;

  stArticleInfos = RECORD
    iArfId, iArtId, iTgfId, iCouId: integer;
    fPxAchat, fPxBrut, fTVA: double;
    IsValide : Boolean;
  END;

  tbArticles = ARRAY OF stArticleInfos;

  stLotInfos = RECORD
    iLotId, iNumLot: Integer;
    fRemise, fPxBrut, fPxNet: Double;

    tabArticles: tbArticles;
  END;

implementation

end.
