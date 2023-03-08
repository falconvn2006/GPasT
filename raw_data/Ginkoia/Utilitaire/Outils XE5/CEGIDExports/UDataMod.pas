//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT UDataMod;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
    FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
    FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Comp.Client,
    FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.IBBase, FireDAC.Phys.IB,
    FireDAC.Stan.ExprFuncs, FireDAC.Comp.ScriptCommands, FireDAC.Comp.Script,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef;

TYPE
    TDataMod = CLASS(TDataModule)
    FDConBMC: TFDConnection;
    FDTransBMC: TFDTransaction;
    FDConCEGID: TFDConnection;
    FDTransCEGID: TFDTransaction;
    FDConGX: TFDConnection;
    FDTransGX: TFDTransaction;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDConBMC_DEV: TFDConnection;
    FDTransBMC_DEV: TFDTransaction;

    PRIVATE
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
    END;

VAR
    DataMod: TDataMod;

IMPLEMENTATION
{$R *.DFM}

//Uses UCommun;


END.

