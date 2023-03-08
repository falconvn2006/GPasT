unit U_Modele;

interface

Uses
  System.SysUtils, System.Classes, System.Contnrs, DBClient,
  DB, System.StrUtils;

Type
  TGenerique = Class(TComponent)
  private

    procedure CSV_To_ClientDataSet(FichCsv:String;CDS:TClientDataSet;Index:String;const Delimiter: Char);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  End;

  TLigneTaille = Class(TGenerique)
  private
    FCode_GT : string;
    FNom : string;
    FCodeIS : string;
    FCode : string;
    FCentrale : Integer;
    FCorres : string;
    FOrdreaff : Double;
    FActif : Integer;

  published
    property Code_GT : string read FCode_GT write FCode_GT;
    property Nom : string read FNom write FNom;
    property CodeIS : string read FCodeIS write FCodeIS;
    property Code : string read FCode write FCode;
    property Centrale : Integer read FCentrale write FCentrale;
    property Corres : string read FCorres write FCorres;
    property Ordreaff : Double read FOrdreaff write FOrdreaff;
    property Actif : Integer read FActif write FActif;

  End;

  TGrilleTaille = Class(TGenerique)
  private
    FCode : string;
    FNom : string;
    FCodeIS : string;
    FType_Grille : string;
    FCode_TypeGT : string;
    FCodeIS_TypeGT : string;
    FCentrale_TypeGT : Integer;
    FCentrale : Integer;
    FListLigneTaille : TObjectList;
  public
    function LoadFromFile(aChemin, aName, aCol, aCle : string):Boolean;

  published


  End;

  TArticle = Class(TGenerique)
  private
    FCODE : string;
    FCODE_MRQ : string;

  End;

implementation

{ TGenerique }

constructor TGenerique.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TGenerique.Destroy;
begin

  inherited;
end;

Procedure TGenerique.CSV_To_ClientDataSet(FichCsv:String;CDS:TClientDataSet;Index:String;
  const Delimiter: Char);
//Transfert le contenu du CSV dans un clientdataset en prenant la ligne d'entête pour la création des champs
Var
  Donnees	  : TStringList;    //Charge le fichier csv
  InfoLigne : TStringList;    //Découpe la ligne en cours de traitement
  I,J       : Integer;        //Variable de boucle
  Chaine    : String;         //Variable de traitement des lignes
Begin
  try
    //Création des variables
    Donnees   := TStringList.Create;
    InfoLigne := TStringList.Create;

    //Chargement du csv
    Donnees.LoadFromFile(FichCsv);

    //Traitement de la ligne d'entête
    InfoLigne.Clear;
    InfoLigne.Delimiter := Delimiter;
    InfoLigne.DelimitedText := Donnees.Strings[0];
    for I := 0 to InfoLigne.Count - 1 do
      Begin
        CDS.FieldDefs.Add(Trim(InfoLigne.Strings[I]),ftString,255);
      End;
    CDS.CreateDataSet;
    //CDS.AddIndex('idx', Index, []);

    //Traitement des lignes de données
    CDS.Open;

    for I := 1 to Donnees.Count - 1 do
      begin
        InfoLigne.Clear;
        InfoLigne.Delimiter := Delimiter;
        InfoLigne.QuoteChar := '''';
        Chaine  := LeftStr(QuotedStr(Donnees.Strings[I]),length(QuotedStr(Donnees.Strings[I]))-1);
        Chaine  := ReplaceStr( Chaine, Delimiter, '''' + Delimiter + '''' );
        Chaine  := Chaine + '''';

        InfoLigne.DelimitedText := Chaine;
        CDS.Insert;
        for J := 0 to CDS.FieldCount - 1 do
          Begin
            CDS.Fields[J].AsString  := InfoLigne.Strings[J];
          End;
        CDS.Post;
      end;
    //CDS.Close;

    //Suppression des variables en mémoire
    Donnees.free;
    InfoLigne.Free;
  except
    on E:Exception do
    begin
      Exit;
    end;
  end;
End;

{ TGrilleTaille }

function TGrilleTaille.LoadFromFile(aChemin, aName, aCol, aCle: string): Boolean;
var
  slTmp : TStringList;
  cdsTmp : TClientDataSet;
begin

end;

end.
