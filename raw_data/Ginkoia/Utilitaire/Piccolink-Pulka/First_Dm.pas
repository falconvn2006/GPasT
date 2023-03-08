//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

unit First_Dm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActionRv, Db, DBTables, Wwquery, Wwtable;

type
  TDm_First = class(TDataModule)
    Grd_Que: TGroupDataRv;
    Database1: TDatabase;
    Vrac: TwwQuery;
    Client: TwwQuery;
    article: TwwQuery;
    articlemanu: TStringField;
    articleauto: TStringField;
    articlecateg: TStringField;
    articlefourn: TStringField;
    articletitre: TStringField;
    articlecleo003: TStringField;
    Vraccode: TStringField;
    VracClient: TStringField;
    Vracchrono: TStringField;
    VracArticle: TStringField;
    Vraccleo017: TStringField;
    Vroc: TwwTable;
    Clientclec006: TStringField;
    Clientnom1: TStringField;
    Clientvid: TStringField;
    Clientpre: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure Refresh;
  end;

var
  Dm_First: TDm_First;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

implementation

{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------
procedure TDm_First.Refresh;
begin
  Grd_Que.Refresh;
end;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

procedure TDm_First.DataModuleCreate(Sender: TObject);
begin
  Grd_Que.Open;
end;

procedure TDm_First.DataModuleDestroy(Sender: TObject);
begin
  Grd_Que.Close;
end;

//FUNCTION Tdm_First.AlignLeft( Chaine: STRING; Pad: char; Lg: integer ): STRING;
//VAR
//    i: integer;
//    t: STRING;
//BEGIN
//    IF Pad = '' THEN Pad := #32;
//    IF length( Chaine ) > Lg THEN
//        result := copy( chaine, 1, Lg )
//    ELSE
//        result := Strs( Pad, Lg - length( Chaine ) ) + chaine;
//END;


end.
