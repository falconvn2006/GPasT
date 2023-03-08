unit uClassGinkoia;

interface

Uses
  Contnrs;

Type
  TGnk = Class(TObject)
  private
    FDOSS_ID: Integer;
    FK_ENABLED: Integer;
  published
    property DOSS_ID: Integer read FDOSS_ID write FDOSS_ID;
    property K_ENABLED: Integer read FK_ENABLED write FK_ENABLED;
  End;

  TGnkGenProviders = Class(TGnk)
  private
    FPRO_ID: Integer;
    FPRO_NOM: string;
    FPRO_ORDRE: Integer;
    FPRO_LOOP: Integer;
  published
    property PRO_ID: Integer read FPRO_ID write FPRO_ID;
    property PRO_NOM: string read FPRO_NOM write FPRO_NOM;
    property PRO_ORDRE: Integer read FPRO_ORDRE write FPRO_ORDRE;
    property PRO_LOOP: Integer read FPRO_LOOP write FPRO_LOOP;
  End;

  TGnkGenSubscribers = Class(TGnk)
  private
    FSUB_ID: Integer;
    FSUB_NOM: string;
    FSUB_ORDRE: Integer;
    FSUB_LOOP: Integer;
  published
    property SUB_ID: Integer read FSUB_ID write FSUB_ID;
    property SUB_NOM: string read FSUB_NOM write FSUB_NOM;
    property SUB_ORDRE: Integer read FSUB_ORDRE write FSUB_ORDRE;
    property SUB_LOOP: Integer read FSUB_LOOP write FSUB_LOOP;
  End;

  TGnkGenLiaiRepli = Class(TGnk)
  private
    FGLR_ID: Integer;
    FGLR_PROSUBID: Integer;
    FGLR_REPID: Integer;
    FGLR_LASTVERSION: string;
  published
    property GLR_ID: Integer read FGLR_ID write FGLR_ID;
    property GLR_REPID: Integer read FGLR_REPID write FGLR_REPID;
    property GLR_PROSUBID: Integer read FGLR_PROSUBID write FGLR_PROSUBID;
    property GLR_LASTVERSION: string read FGLR_LASTVERSION write FGLR_LASTVERSION;
  End;

  TGnkGenReplication = Class(TGnk)
  private
    FREP_ID: Integer;
    FREP_PUSH: string;
    FREP_PLACEBASE: string;
    FREP_PLACEEAI: string;
    FREP_URLLOCAL: string;
    FREP_USER: string;
    FREP_LAUID: Integer;
    FREP_PULL: string;
    FREP_PWD: string;
    FREP_URLDISTANT: string;
    FREP_PING: string;
    FREP_ORDRE: Integer;
    FREP_JOUR: Integer;
    FREP_EXEFINREPLIC: string;
    //FListGnkGenLiaiRepli: TObjectList<TGnkGenLiaiRepli>;
  published
    property REP_ID: Integer read FREP_ID write FREP_ID;
    property REP_LAUID: Integer read FREP_LAUID write FREP_LAUID;
    property REP_PING: string read FREP_PING write FREP_PING;
    property REP_PUSH: string read FREP_PUSH write FREP_PUSH;
    property REP_PULL: string read FREP_PULL write FREP_PULL;
    property REP_USER: string read FREP_USER write FREP_USER;
    property REP_PWD: string read FREP_PWD write FREP_PWD;
    property REP_ORDRE: Integer read FREP_ORDRE write FREP_ORDRE;
    property REP_URLLOCAL: string read FREP_URLLOCAL write FREP_URLLOCAL;
    property REP_URLDISTANT: string read FREP_URLDISTANT write FREP_URLDISTANT;
    property REP_PLACEEAI: string read FREP_PLACEEAI write FREP_PLACEEAI;
    property REP_PLACEBASE: string read FREP_PLACEBASE write FREP_PLACEBASE;
    property REP_JOUR: Integer read FREP_JOUR write FREP_JOUR;
    property REP_EXEFINREPLIC: string read FREP_EXEFINREPLIC write FREP_EXEFINREPLIC;
  End;

implementation

end.
