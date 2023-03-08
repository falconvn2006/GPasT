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
  ActionRv;

type
  TDm_First = class(TDataModule)
    Grd_Que: TGroupDataRv;
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

end.
