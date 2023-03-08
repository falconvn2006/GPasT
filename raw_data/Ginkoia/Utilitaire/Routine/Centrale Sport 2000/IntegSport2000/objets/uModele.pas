unit uModele;

interface

uses Classes, Contnrs, SysUtils, StrUtils,
  uSynchroObjBDD, uCollection, uGestionBDD;

type
  EGetFournId = FUNCTION (idfournisseur, fournisseur, adr1, adr2 : string; mrkid : integer): integer of object;

  {$M+}
  TModele = class(TMyObject)
  private
    FIdref: Integer;
    FNom: string;
    FOrigine: integer;
    FDescription: string;
    FMrkid: Integer;
    FRefMrk: string;
    FSsfId: integer;
    FPub: integer;
    FGtfId: integer;
    FSession: string;
    FGreId: integer;
    FTheme: string;
    FGamme: string;
    FCodeCentrale: integer;
    FTailles: string;
    FPos: integer;
    FGampf: integer;
    FPoint: integer;
    FGamProduit: integer;
    FRefRemplace: integer;
    FGarId: integer;
    FCodeGs: integer;
    FComent1: string;
    FComent2: string;
    FComent3: string;
    FComent4: string;
    FComent5: string;
    FCodeDouanier: string;
    FCptAna: string;
    FDimId: integer;
    FCode: integer;
    FFedas: integer;
    FPxetiqu: integer;
    //FPxcentrale: integer;
    FActId: integer;
    FFusArtId: integer;
    FMultiColi: integer;
    FFds: integer;
    FPreEtq: integer;
    FCodeDouane: integer;
    FPayId: integer;
    FPoids: integer;
    FEcoPart: string;

    FIdRefOrigine: Integer;
    FMrkNom: String;
    FArfID: Integer;
    FArfChrono: String;
    FArchive: Boolean;

    FListCollection: TObjectList;
    FlistprixAchat: TObjectList;
    FListprixVente: TObjectList;
    FListeTailles: TObjectList;
    FEGetFournId: EGetFournId;
    FFusionEtGrilleTailleDiff: Boolean;
    FChronoSourceFusion: String;

//    Fxml_idfournisseur : string;
//    Fxml_fournisseur : string;
//    Fxml_adr1 : string;
//    Fxml_adr2 : string;

  protected
    const
      TABLE_NAME = 'ARTARTICLE';
      TABLE_TRIGRAM = 'ART';
      TABLE_PK = 'ART_ID';

    function getListCollection(): TObjectList;
    function getListprixVente(): TObjectList;
    function getListprixAchat(): TObjectList;

  public
    property IdRefOrigine: Integer read FIdRefOrigine write FIdRefOrigine;
    property MrkNom: String read FMrkNom write FMrkNom;
    property ArfID: Integer read FArfID write FArfID;
    property ArfChrono: String read FArfChrono write FArfChrono;
    property Archive: Boolean read FArchive write FArchive;
    property listPrixAchat: TObjectList read getlistprixAchat write FlistprixAchat;
    property listPrixVente: TObjectList read getListprixVente write FListprixVente;
    property listCollection: TObjectList read getListCollection write FListCollection;
    property ListeTailles: TObjectList read FListeTailles write FListeTailles;
    property GetFournIdMethode: EGetFournId read FEGetFournId write FEGetFournId;
    property FusionEtGrilleTailleDiff: Boolean read FFusionEtGrilleTailleDiff write FFusionEtGrilleTailleDiff;
    property ChronoSourceFusion: String read FChronoSourceFusion write FChronoSourceFusion;

    constructor Create;   overload;
//    procedure doLoadFromIdrefRefmrk(aQuery: TMyQuery);
    procedure doLoad(aQuery: TMyQuery; aDefault: Boolean = True);   override;
    destructor Destroy;   override;

  published
    property Idref: integer        read FIdref        write FIdref;
    property Nom: string           read FNom          write FNom;
    property Origine: integer      read FOrigine      write FOrigine;
    property Description: string   read FDescription  write FDescription;
    property Mrkid: integer        read FMrkid        write FMrkid;
    property RefMrk: string        read FRefMrk       write FRefMrk;
    property SsfId: integer        read FSsfId        write FSsfId;
    property Pub: integer          read FPub          write FPub;
    property GtfId: integer        read FGtfId        write FGtfId;
    property Session: string       read FSession      write FSession;
    property GreId: integer        read FGreId        write FGreId;
    property Theme: string         read FTheme        write FTheme;
    property Gamme: string         read FGamme        write FGamme;
    property CodeCentrale: integer read FCodeCentrale write FCodeCentrale;
    property Tailles: string       read FTailles      write FTailles;
    property Pos: integer          read FPos          write FPos;
    property Gampf: integer        read FGampf        write FGampf;
    property Point: integer        read FPoint        write FPoint;
    property GamProduit: integer   read FGamProduit   write FGamProduit;
    property RefRemplace: integer  read FRefRemplace  write FRefRemplace;
    property GarId: integer        read FGarId        write FGarId;
    property CodeGs: integer       read FCodeGs       write FCodeGs;
    property Coment1: string       read FComent1      write FComent1;
    property Coment2: string       read FComent2      write FComent2;
    property Coment3: string       read FComent3      write FComent3;
    property Coment4: string       read FComent4      write FComent4;
    property Coment5: string       read FComent5      write FComent5;
    property CodeDouanier: string  read FCodeDouanier write FCodeDouanier;
    property CptAna: string        read FCptAna       write FCptAna;
    property DimId: integer        read FDimId        write FDimId;
    property Code: integer         read FCode         write FCode;
    property Fedas: integer        read FFedas        write FFedas;
    property Pxetiqu: integer     read FPxetiqu     write FPxetiqu;
    //property Pxcentrale: integer   read FPxcentrale   write FPxcentrale;
    property ActId: integer        read FActId        write FActId;
    property FusArtId: integer     read FFusArtId     write FFusArtId;
    property MultiColi: integer    read FMultiColi    write FMultiColi;
    property Fds: integer          read FFds          write FFds;
    property PreEtq: integer       read FPreEtq       write FPreEtq;
    property CodeDouane: integer   read FCodeDouane   write FCodeDouane;
    property PayId: integer       read FPayId       write FPayId;
    property Poids: integer        read FPoids        write FPoids;
    property EcoPart: string       read FEcoPart      write FEcoPart;
  end;
  {$M-}

  TListeModeles = class(TObjectList)
    public
      function Add(Modele: TModele): Integer;
      function GetModeleIDRef(const nIDRef: Integer): TModele;
      function GetModeleID(const nID: Integer): TModele;
  end;

implementation

{ TModele }

constructor TModele.Create;
begin
  inherited Create(TABLE_NAME, TABLE_TRIGRAM, TABLE_PK);
  FListeTailles := TObjectList.Create;
  FFusionEtGrilleTailleDiff := False;
end;

{procedure TModele.doLoadFromIdrefRefmrk(aQuery: TMyQuery);
var
  request: String;
  position: Integer;
begin
  aQuery.Close;
  request := dogetQry(tqSelect);
  position := AnsiPos('where', request);
  request := AnsiLeftStr(request, position - 1);
  request := request + ' join artreference on arf_artid = art_id ';
  request := request + ' join k on ' + TABLE_PK + ' = k_id AND K_ENABLED = 1';
  request := request + ' where art_idref = :IDREF and art_refmrk = :REFMRK and ARF_ARCHIVER = 0';  //and art_mrkid=:mrkid and art_gtfid=:gtfid
  request := request + ' order by ARF_CREE desc rows 1';  // si plusieurs retour, on prend la fiche la plus récente
  aQuery.SQL.Text := request;
  aQuery.ParamByName('IDREF').AsInteger := IDREF;
  aQuery.ParamByName('REFMRK').AsString := REFMRK;
  //aQuery.ParamByName('mrkid').AsInteger := mrkid;
  // la grille de taille n est pas considérée pour le rapprochement, uniquement les tailles
  //aQuery.ParamByName('gtfid').AsInteger := gtfid;
  aQuery.Open;
  if not aQuery.IsEmpty then
  begin
     fillObjectWithQuery(Self, aQuery, FTrigram);
     FExist := True;
  end
  else
     FExist := False;
  aQuery.Close;
end; }

procedure TModele.doLoad(aQuery: TMyQuery; aDefault: Boolean);
begin
  inherited;

  if FId > 0 then
  begin
    // Recherche du modèle.
    aQuery.Close;
    aQuery.SQL.Clear;
    aQuery.SQL.Add('select ARF_ID, ARF_CHRONO, ARF_ARCHIVER');
    aQuery.SQL.Add('from ARTREFERENCE');
    aQuery.SQL.Add('join K on (K_ID = ARF_ID and K_ENABLED = 1)');
    aQuery.SQL.Add('where ARF_ARTID = :ARTID');
    try
      aQuery.ParamByName('ARTID').AsInteger := FId;
      aQuery.Open;
    except
      on E: Exception do
      begin

        Exit;
      end;
    end;
    if not aQuery.IsEmpty then
    begin
      FArfID := aQuery.FieldByName('ARF_ID').AsInteger;
      FArfChrono := aQuery.FieldByName('ARF_CHRONO').AsString;
      FArchive := (aQuery.FieldByName('ARF_ARCHIVER').AsInteger = 1);
    end;
  end;
end;

function TModele.getListCollection(): TObjectList;
begin
   if (self.FListCollection = nil) then
   begin
       self.FListCollection := TObjectList.create();
   end;
   result := self.FListCollection;
end;

function TModele.getListprixVente(): TObjectList;
begin
   if (self.FListprixVente = nil) then
   begin
       self.FListprixVente := TObjectList.create();
   end;
   result := self.FListprixVente;
end;

function TModele.getListprixAchat(): TObjectList;
begin
   if (self.FListprixAchat = nil) then
   begin
       self.FListprixAchat := TObjectList.create();
   end;
   result := self.FListprixAchat;
end;

destructor TModele.Destroy;
begin
  FListeTailles.Free;

  inherited;
end;

{ TListeModeles }

function TListeModeles.Add(Modele: TModele): Integer;
var
  bExiste: Boolean;
  i: Integer;
begin
  if not Assigned(Modele) then
    raise Exception.Create('Erreur :  pas de TModele !');

  Result := Count;      bExiste := False;
  for i:=0 to Pred(Count) do
  begin
    if(Items[i] is TModele) and (TModele(Items[i]).IdRefOrigine = Modele.IdRefOrigine) then
    begin
      bExiste := True;
      Break;
    end;
  end;

  if not bExiste then
    Result := inherited Add(Modele);
end;

function TListeModeles.GetModeleIDRef(const nIDRef: Integer): TModele;
var
  i: Integer;
begin
  Result := nil;
  for i:=0 to Pred(Count) do
  begin
    if(Items[i] is TModele) and (TModele(Items[i]).IdRefOrigine = nIDRef) then
    begin
      Result := TModele(Items[i]);
      Break;
    end;
  end;
end;

function TListeModeles.GetModeleID(const nID: Integer): TModele;
var
  i: Integer;
begin
  Result := nil;
  for i:=0 to Pred(Count) do
  begin
    if(Items[i] is TModele) and (TModele(Items[i]).Id = nID) then
    begin
      Result := TModele(Items[i]);
      Break;
    end;
  end;
end;

end.

