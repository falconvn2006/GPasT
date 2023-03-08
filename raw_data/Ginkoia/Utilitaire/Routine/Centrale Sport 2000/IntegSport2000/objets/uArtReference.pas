unit uArtReference;

interface

uses
  uSynchroObjBDD;

type
  {$M+}
  TArtReference = class(TMyObject)
  private
    FCgtid: integer;
    FCdnmtqte: double;
    FTpwid: integer;
    FGltmontant: double;
    FCoeft: double;
    FVirtuel: integer;
    FMagorg: integer;
    FStocki: double;
    FModif: tdatetime;
    FUc: integer;
    FDimension: integer;
    FDepmotif: string;
    FDeptaux: double;
    FFidfin: tdatetime;
    FGltdebut: tdatetime;
    FChrono: string;
    FArchiver: integer;
    FVtfrac: integer;
    FCdnmtobli: integer;
    FArtid: integer;
    FCatalog: integer;
    FUnite: string;
    FGltmarge: double;
    FService: integer;
    FTctid: integer;
    FTvaid: integer;
    FGltpxv: double;
    FDepreciation: integer;
    FIclid2: integer;
    FDepdate: tdatetime;
    FCpfa: double;
    FIclid3: integer;
    FFiddebut: tdatetime;
    FIclid1: integer;
    FIclid6: integer;
    FFidpoint: double;
    FFidelite: integer;
    FGuelt: integer;
    FCdnmt: integer;
    FCree: tdatetime;
    FIclid4: integer;
    FIclid5: integer;
    FGltfin: tdatetime;
    FCatid: integer;
  protected
    const
    TABLE_NAME='ARTREFERENCE';
    TABLE_TRIGRAM='ARF';
    TABLE_PK='ARF_ID';
  public
    constructor create(); overload;
  published
    property Artid : integer        read FArtid        write FArtid;
    property Catid : integer        read FCatid        write FCatid; 
    property Tvaid : integer        read FTvaid        write FTvaid; 
    property Tctid : integer        read FTctid        write FTctid; 
    property Iclid1 : integer       read FIclid1       write FIclid1; 
    property Iclid2 : integer       read FIclid2       write FIclid2; 
    property Iclid3 : integer       read FIclid3       write FIclid3; 
    property Iclid4 : integer       read FIclid4       write FIclid4; 
    property Iclid5 : integer       read FIclid5       write FIclid5; 
    property Cree : tdatetime       read FCree         write FCree; 
    property Modif : tdatetime      read FModif        write FModif; 
    property Chrono : string        read FChrono       write FChrono; 
    property Dimension : integer    read FDimension    write FDimension; 
    property Depreciation : integer read FDepreciation write FDepreciation; 
    property Virtuel : integer      read FVirtuel      write FVirtuel; 
    property Service : integer      read FService      write FService; 
    property Coeft : double         read FCoeft        write FCoeft; 
    property Stocki : double        read FStocki       write FStocki; 
    property Vtfrac : integer       read FVtfrac       write FVtfrac; 
    property Cdnmt : integer        read FCdnmt        write FCdnmt; 
    property Cdnmtqte : double      read FCdnmtqte     write FCdnmtqte; 
    property Unite : string         read FUnite        write FUnite; 
    property Cdnmtobli : integer    read FCdnmtobli    write FCdnmtobli; 
    property Guelt : integer        read FGuelt        write FGuelt; 
    property Cpfa : double          read FCpfa         write FCpfa; 
    property Fidelite : integer     read FFidelite     write FFidelite; 
    property Archiver : integer     read FArchiver     write FArchiver; 
    property Fidpoint : double      read FFidpoint     write FFidpoint; 
    property Fiddebut : tdatetime   read FFiddebut     write FFiddebut; 
    property Fidfin : tdatetime     read FFidfin       write FFidfin; 
    property Deptaux : double       read FDeptaux      write FDeptaux; 
    property Depdate : tdatetime    read FDepdate      write FDepdate; 
    property Depmotif : string      read FDepmotif     write FDepmotif; 
    property Cgtid : integer        read FCgtid        write FCgtid; 
    property Gltmontant : double    read FGltmontant   write FGltmontant; 
    property Gltpxv : double        read FGltpxv       write FGltpxv; 
    property Gltmarge : double      read FGltmarge     write FGltmarge; 
    property Gltdebut : tdatetime   read FGltdebut     write FGltdebut; 
    property Gltfin : tdatetime     read FGltfin       write FGltfin; 
    property Magorg : integer       read FMagorg       write FMagorg; 
    property Catalog : integer      read FCatalog      write FCatalog; 
    property Uc : integer           read FUc           write FUc; 
    property Tpwid : integer        read FTpwid        write FTpwid; 
    property Iclid6 : integer       read FIclid6       write FIclid6;
  end;

implementation

{ TArtReference }
constructor TArtReference.create;
begin
   inherited  Create(TABLE_NAME, TABLE_TRIGRAM, TABLE_PK);
end;

end.
