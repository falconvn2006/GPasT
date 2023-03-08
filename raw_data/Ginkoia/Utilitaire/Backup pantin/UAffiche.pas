UNIT UAffiche;

INTERFACE

USES Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
    Buttons, ExtCtrls,dialogs, DB, Grids, DBGrids, dxmdaset;

TYPE
    TFrm_Affiche = CLASS(TForm)
        OKBtn: TButton;
        Bevel1: TBevel;
        mem: TMemo;
    Bevel2: TBevel;
    memd_log: TdxMemData;
    memd_logDATE: TDateTimeField;
    memd_logACTION: TStringField;
    memd_logPATH: TStringField;
    memd_logLOGMESSAGE: TStringField;
    dbg_Log: TDBGrid;
    ds_log: TDataSource;
    PRIVATE
    { Private declarations }
    PUBLIC
    { Public declarations }
    END;

VAR
    Frm_Affiche: TFrm_Affiche;

IMPLEMENTATION

{$R *.DFM}

END.
