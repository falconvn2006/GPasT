unit CA_frm;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    Db, ADODB, dxmdaset, LMDControl, LMDBaseControl, LMDBaseGraphicButton,
    LMDCustomSpeedButton, LMDSpeedButton, IBDatabase, StdCtrls, RzLabel,
    IBCustomDataSet, IBQuery;

type
    TFrm_CA = class(TForm)
        ADO: TADOConnection;
        TD: TADOTable;
        TDdos_id: TAutoIncField;
        TDdos_nom: TStringField;
        TDdos_centrale: TStringField;
        TDdos_code: TStringField;
        TDdos_magnom: TStringField;
        TDdos_ville: TStringField;
        TDdos_chemin: TStringField;
        LMDSpeedButton1: TLMDSpeedButton;
        MCA: TdxMemData;
        MCACODE: TStringField;
        MCAVILLE: TStringField;
        MCAMAGASIN: TStringField;
        MCADOSSIER: TStringField;
        MCARESULTAT: TStringField;
        IB: TIBDatabase;
        CPT: TRzLabel;
        tt: TIBTransaction;
        QCA: TIBQuery;
        MCACA: TFloatField;
        MP: TdxMemData;
        MPDEB: TDateField;
        MPFIN: TDateField;
    MCAPERIODE: TDateField;
    Per: TRzLabel;
    Qneg: TIBQuery;
        procedure FormCreate(Sender: TObject);
        procedure LMDSpeedButton1Click(Sender: TObject);
    private
        { Déclarations privées }
    public
        { Déclarations publiques }
    end;

var
    Frm_CA: TFrm_CA;

implementation

{$R *.DFM}

procedure TFrm_CA.FormCreate(Sender: TObject);
begin
    try
        ado.connected := true;
    except
        MessageDlg('Problème de connection avec le serveur SPORT2000', mtWarning, [], 0);
        application.terminate;
    end;
    mp.open;
    mp.DelimiterChar := #09;
    mp.LoadFromTextFile(ExtractFilePath(application.exename) + 'PerSp2000.csv');
end;

procedure TFrm_CA.LMDSpeedButton1Click(Sender: TObject);
var i,j: integer;
begin
    screen.cursor := crsqlwait;
    td.open;
    td.first;
    mca.open;
    mca.DelimiterChar := ';';
    while not td.eof do
    begin
        if (TDdos_centrale.asstring = 'SP') and (trim(TDdos_code.asstring) <> '') //and (trim(TDdos_code.asstring)='430303')
        then
        begin
            i := i + 1;
            cpt.caption := inttostr(i);
            Application.ProcessMessages;

            //Ouverture de la base
            try
                ib.databasename :=TDdos_chemin.asstring; //'C:\Developpement\Ginkoia\Data\ainoux\ginkoia.ib';//
                ib.open;

                j:=0;
                mp.first;
                while not mp.eof do
                begin
                    j:=j+1;
                    per.caption:=inttostr(j);
                    Application.ProcessMessages;

                    qca.params[0].asstring := trim(TDdos_code.asstring);
                    qca.params[1].asdatetime:=MPDEB.asdatetime;
                    qca.params[2].asdatetime:=MPFIN.asdatetime;
                    qca.open;

                    qneg.params[0].asstring := trim(TDdos_code.asstring);
                    qneg.params[1].asdatetime:=MPDEB.asdatetime;
                    qneg.params[2].asdatetime:=MPFIN.asdatetime;
                    qneg.open;


                    mca.append;
                    MCACA.asfloat := qca.fields[0].asfloat+qneg.fields[0].asfloat;
                    MCACODE.asstring := TDdos_code.asstring;
                    MCADOSSIER.asstring := TDdos_nom.asstring;
                    MCAVILLE.asstring := TDdos_ville.asstring;
                    MCAMAGASIN.asstring := TDdos_magnom.asstring;
                    MCARESULTAT.asstring := 'OK';
                    MCAPERIODE.asdatetime:= MPDEB.asdatetime;
                    mca.post;

                    qca.close;
                    qneg.close;
                    mp.next;

                end;
                mca.SaveToTextFile(ExtractFilePath(application.exename)+'casp2000.csv');
                ib.close;



            except
                mca.append;
                MCACODE.asstring := TDdos_code.asstring;
                MCADOSSIER.asstring := TDdos_nom.asstring;
                MCAVILLE.asstring := TDdos_ville.asstring;
                MCAMAGASIN.asstring := TDdos_magnom.asstring;
                MCARESULTAT.asstring := '***';
                mca.post;
            end;





        end;
        td.next;
    end;


    screen.cursor := crdefault;
    MessageDlg('Traitement terminé', mtInformation, [], 0);
end;

end.

