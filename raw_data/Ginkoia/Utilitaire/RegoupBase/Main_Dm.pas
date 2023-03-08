unit Main_Dm;

interface

uses
  SysUtils, Classes, DB, IBODataset, IB_Components, dxmdaset;

type
  TDm_Main = class(TDataModule)
    GinBase1: TIBODatabase;
    GinBase2: TIBODatabase;
    Que_B1_Div: TIBOQuery;
    Que_B2_Div: TIBOQuery;
    MemD_Marque: TdxMemData;
    MemD_MarqueMarqueBase1: TStringField;
    MemD_MarqueMarqueBase2: TStringField;
    MemD_MarqueNomMarque: TStringField;
    MemD_ArtNewDet: TdxMemData;
    MemD_ArtNewDetMarque: TStringField;
    MemD_ArtNewDetLibelle: TStringField;
    MemD_ArtNewDetInfo: TStringField;
    Que_B1_Taille: TIBOQuery;
    Que_B2_Taille: TIBOQuery;
    Que_B1_Couleur: TIBOQuery;
    Que_B2_Couleur: TIBOQuery;
    MemD_ArtNewDetRef: TStringField;
    MemD_ArtNewDetTypeInfo: TStringField;
    MemD_ArtNewDetOrdreListe: TStringField;
    MemD_ArtAModif: TdxMemData;
    MemD_ArtAModifOrderListe: TStringField;
    MemD_ArtAModifMarque: TStringField;
    MemD_ArtAModifRef: TStringField;
    MemD_ArtAModifTypeInfo: TStringField;
    MemD_ArtAModifLibelle: TStringField;
    MemD_ArtAModifInfo: TStringField;
    Que_B1_Div2: TIBOQuery;
    MemD_ArtNewDetPxAch: TFloatField;
    MemD_ArtNewDetPxVen: TFloatField;
    MemD_ArtNewDetTailleTrav: TStringField;
    MemD_ArtNewDetCouleur: TStringField;
    MemD_MarqDiff: TdxMemData;
    MemD_MarqDiffOrdreListe: TStringField;
    MemD_MarqDiffMarque: TStringField;
    MemD_MarqDiffRef: TStringField;
    MemD_MarqDiffTypeInfo: TStringField;
    MemD_MarqDiffLibelle: TStringField;
    MemD_MarqDiffInfo: TStringField;
    MemD_ArtNewDetRayon: TStringField;
    MemD_ArtNewDetFamille: TStringField;
    MemD_ArtNewDetSFamille: TStringField;
    MemD_ArtNewDetSecteur: TStringField;
    MemD_ArtNewDetCateg: TStringField;
    MemD_ArtNewDetSCateg: TStringField;
    MemD_ArtNewDetGenre: TStringField;
    Que_NK: TIBOQuery;
    MemD_ArtNouv: TdxMemData;
    MemD_ArtNouvOrdreListe: TStringField;
    MemD_ArtNouvMarque: TStringField;
    MemD_ArtNouvRef: TStringField;
    MemD_ArtNouvTypeInfo: TStringField;
    MemD_ArtNouvLibelle: TStringField;
    MemD_ArtNouvInfo: TStringField;
    MemD_ArtNouvPcAch: TFloatField;
    MemD_ArtNouvPxVen: TFloatField;
    MemD_ArtNouvFamille: TStringField;
    MemD_ArtNouvSFamille: TStringField;
    MemD_ArtNouvSecteur: TStringField;
    MemD_ArtNouvCateg: TStringField;
    MemD_ArtNouvSCateg: TStringField;
    MemD_ArtNouvGenre: TStringField;
    MemD_ArtNouvRayon: TStringField;
    MemD_ArtNouvStock: TIntegerField;
    MemD_ArtNewDetStock: TIntegerField;
    Que_B1_Stock: TIBOQuery;
    MemD_ArtNouvDatCre: TDateField;
    MemD_ArtNewDetDatCre: TDateField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Dm_Main: TDm_Main;
  ReperBase: string;

implementation

{$R *.dfm}

procedure TDm_Main.DataModuleCreate(Sender: TObject);
begin
  ReperBase := ExtractFilePath(ParamStr(0));
  if ReperBase[Length(ReperBase)]<>'\' then
   ReperBase := ReperBase+'\';
end;

end.
