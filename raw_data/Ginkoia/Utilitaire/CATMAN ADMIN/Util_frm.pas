unit Util_frm;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, ADODB, dxmdaset, LMDControl, LMDBaseControl, LMDBaseGraphicButton,
  LMDCustomSpeedButton, LMDSpeedButton, Grids, DBGrids,variants, wwDialog,
  wwidlg, wwLookupDialogRv, ComCtrls, StdCtrls, Buttons, ExtCtrls, Mask, RzEdit,
  RzDBEdit, RzDBBnEd, RzDBButtonEditRv;

type
    TForm1 = class(TForm)
    ado: TADOConnection;
        ODI: TOpenDialog;
        Md: TdxMemData;
        MdMARQUE: TStringField;
        MdREF: TStringField;
        MdCOUL: TStringField;
        TVERIF: TADOTable;
        TVERIFTVF_MARQUE: TStringField;
        TVERIFTVF_REF: TWideStringField;
        TVERIFTVF_COUL: TWideStringField;
    md_pnc: TdxMemData;
    md_pncREF: TStringField;
    md_pncMARQUE: TStringField;
    TPNC: TADOTable;
    TPNCPNC_REF: TStringField;
    TPNCPNC_MARQUE: TStringField;
    TPNCPNC_MRKID: TIntegerField;
    MD_NIKE: TdxMemData;
    MD_NIKEREF: TStringField;
    MD_NIKECOUL: TStringField;
    TNIKE: TADOTable;
    TNIKENIK_ID: TAutoIncField;
    TNIKENIK_REF: TStringField;
    TNIKENIK_COUL: TStringField;
    TNIKENIK_PE09: TIntegerField;
    TNIKENIK_PERM: TIntegerField;
    MemD_Col: TdxMemData;
    MemD_ColMOUV: TStringField;
    MemD_ColSENS: TStringField;
    TCOL: TADOTable;
    TCOLCOL_MVT: TStringField;
    TCOLCOL_SENS: TStringField;
    TCOLCOL_TYP: TWordField;
    MemD_ColTYP: TIntegerField;
    MemD_Rep: TdxMemData;
    TREP: TADOTable;
    TREPREP_CODE: TWideStringField;
    TREPREP_OK: TIntegerField;
    MemD_RepCODE: TStringField;
    Memd_FDS: TdxMemData;
    TFDS: TADOTable;
    TFDSFDS_ID: TAutoIncField;
    TFDSFDS_MARQUE: TStringField;
    TFDSFDS_CATID: TIntegerField;
    TFDSFDS_MODELE: TStringField;
    TFDSFDS_REF: TStringField;
    TFDSFDS_DTLIM: TDateTimeField;
    TFDSFDS_CATMAN: TWordField;
    TFDSFDS_COLID: TIntegerField;
    Memd_FDSMARQUE: TStringField;
    Memd_FDSCATEGORIE: TStringField;
    Memd_FDSMODELE: TStringField;
    Memd_FDSREF: TStringField;
    Memd_FDSDATE: TDateField;
    Memd_FDSCOLLECTION: TStringField;
    TCAT: TADOTable;
    QMRK: TADOQuery;
    TCOLLEC: TADOTable;
    Memd_FDSCOLID: TIntegerField;
    Memd_FDSCATID: TIntegerField;
    TCOLLECCOL_ID: TAutoIncField;
    TCOLLECCOL_NOM: TStringField;
    TCATCAT_ID: TAutoIncField;
    TCATCAT_NOM: TStringField;
    Tmvt: TADOTable;
    TmvtCOL_MVT: TStringField;
    TmvtCOL_SENS: TStringField;
    TmvtCOL_TYP: TWordField;
    lkmvt: TwwLookupDialogRV;
    Qmvt: TADOQuery;
    QmvtCOL_MVT: TStringField;
    QmvtCOL_SENS: TStringField;
    QmvtCOL_TYP: TWordField;
    MemD_Perm: TdxMemData;
    MemD_PermREF: TStringField;
    TPERM: TADOTable;
    TPERMtmp_refmrk: TStringField;
    TPERMtmp_mrkid: TIntegerField;
    TPERMtmp_couleur: TStringField;
    MemD_PermCOULEUR: TStringField;
    TMARQUE: TADOTable;
    TMARQUEMRK_ID: TAutoIncField;
    TMARQUEMRK_NOM: TStringField;
    MemD_PermMARQUE: TStringField;
    T_PermAH09: TADOTable;
    T_PermAH09tmp_refmrk: TStringField;
    T_PermAH09tmp_mrkid: TIntegerField;
    Pgc_Catman: TPageControl;
    Tab_Catman: TTabSheet;
    Tab_Levis: TTabSheet;
    LMDSpeedButton1: TLMDSpeedButton;
    LMDSpeedButton2: TLMDSpeedButton;
    LMDSpeedButton3: TLMDSpeedButton;
    LMDSpeedButton4: TLMDSpeedButton;
    LMDSpeedButton6: TLMDSpeedButton;
    LMDSpeedButton5: TLMDSpeedButton;
    Nbt_perm: TLMDSpeedButton;
    LMDSpeedButton9: TLMDSpeedButton;
    LMDSpeedButton7: TLMDSpeedButton;
    LMDSpeedButton8: TLMDSpeedButton;
    aQue_InsertLevis: TADOQuery;
    Pan_LevisBottom: TPanel;
    Pan_LevisTop: TPanel;
    Nbt_ArticlesLevis: TLMDSpeedButton;
    Gbx_Levis: TGroupBox;
    Pan_GrpBox: TPanel;
    DBGrid1: TDBGrid;
    MemD_Levis: TdxMemData;
    Ds_Levis: TDataSource;
    MemD_LevisLEV_REF: TStringField;
    MemD_LevisLEV_LIB: TStringField;
    MemD_LevisLEV_TAILLE: TStringField;
    MemD_LevisLEV_LONG: TStringField;
    MemD_LevisLEV_COULEUR: TStringField;
    MemD_LevisLEV_EAN: TStringField;
    OD_Levis: TOpenDialog;
    aQue_DeleteLevis: TADOQuery;
    Tab_Cata: TTabSheet;
    Nbt_indMag: TLMDSpeedButton;
    MD_IM: TdxMemData;
    MD_IMCODE: TStringField;
    MD_IMBUDGET: TStringField;
    MD_IMMARGE: TStringField;
    LK_col: TwwLookupDialogRV;
    LK_uni: TwwLookupDialogRV;
    T_uni: TADOTable;
    StatusBar1: TStatusBar;
    Ds_uni: TDataSource;
    T_im: TADOTable;
    T_imIND_MAGID: TIntegerField;
    T_imIND_COLID: TIntegerField;
    T_imIND_CATID: TIntegerField;
    T_imIND_MRKID: TIntegerField;
    T_imIND_ACHAT: TFloatField;
    T_imIND_MARGE: TFloatField;
    T_imIND_UNIID: TIntegerField;
    T_uniuni_id: TIntegerField;
    T_uniuni_nom: TStringField;
    LK_cat: TwwLookupDialogRV;
    Tmrk: TADOQuery;
    Tmrkmrk_id: TAutoIncField;
    Tmrkmrk_nom: TStringField;
    LK_mrk: TwwLookupDialogRV;
    Lab_chx: TLabel;
    T_mag: TADOTable;
    Chp_: TRzDBButtonEditRv;
    rb_type1: TRadioButton;
    rb_type2: TRadioButton;
    Chk_EraseOld: TCheckBox;
        procedure LMDSpeedButton1Click(Sender: TObject);
        procedure FormCreate(Sender: TObject);
    procedure LMDSpeedButton2Click(Sender: TObject);
    procedure LMDSpeedButton3Click(Sender: TObject);
    procedure LMDSpeedButton4Click(Sender: TObject);
    procedure LMDSpeedButton5Click(Sender: TObject);
    procedure LMDSpeedButton6Click(Sender: TObject);
    procedure LMDSpeedButton7Click(Sender: TObject);
    procedure LMDSpeedButton8Click(Sender: TObject);
    procedure Nbt_permClick(Sender: TObject);
    procedure LMDSpeedButton9Click(Sender: TObject);
    procedure Nbt_ArticlesLevisClick(Sender: TObject);
    procedure Nbt_indMagClick(Sender: TObject);
    private
        { Déclarations privées }
    public
        { Déclarations publiques }
    end;

var
    Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.LMDSpeedButton1Click(Sender: TObject);
begin
    if ODI.Execute then
    begin
        md.DelimiterChar := ';';
        md.LoadFromTextFile(ODI.files[0]);

        Tverif.open;
        md.first;
        while not md.eof do
        begin
            Tverif.insert;
            TVERIFTVF_MARQUE.asstring := MdMARQUE.asstring;
            TVERIFTVF_REF.asstring := MdREF.asstring;
            TVERIFTVF_COUL.asstring := MdCOUL.asstring;
            Tverif.post;
            md.next;
        end;

    end;
    tverif.close;
    md.close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    try
        ado.connected := true;
    except
        MessageDlg('Problème de connection avec le serveur SPORT2000', mtWarning, [], 0);

        application.terminate;
    end;
end;

procedure TForm1.LMDSpeedButton2Click(Sender: TObject);
begin
    if ODI.Execute then
    begin
        md_pnc.DelimiterChar := ';';
        md_pnc.LoadFromTextFile(ODI.files[0]);

        TPNC.open;
        md_pnc.first;
        while not md_pnc.eof do
        begin
            TPNC.insert;
            TPNCPNC_REF.asstring := md_pncREF.asstring;
            if length(TPNCPNC_REF.asstring)=5 then TPNCPNC_REF.asstring:='0'+TPNCPNC_REF.asstring;
            TPNCPNC_MARQUE.asstring := md_pncMARQUE.asstring;
            TPNCPNC_MRKID.asinteger:=0;
            TPNC.post;
            md_pnc.next;
        end;

    end;
    TPNC.close;
    md_pnc.close;
end;

procedure TForm1.LMDSpeedButton3Click(Sender: TObject);
begin
      if ODI.Execute then
    begin
        md_nike.DelimiterChar := ';';
        md_nike.LoadFromTextFile(ODI.files[0]);

        Tnike.open;
        md_nike.first;
        while not md_nike.eof do
        begin
            Tnike.insert;
            TNIKENIK_REF.asstring:=MD_NIKEREF.asstring;
            TNIKENIK_COUL.asstring:=MD_NIKECOUL.asstring;
            TNIKENIK_PE09.asinteger:=1;
            Tnike.post;
            md_nike.next;
        end;

    end;
    Tnike.close;
    md_nike.close;
end;

procedure TForm1.LMDSpeedButton4Click(Sender: TObject);
begin
        if ODI.Execute then
    begin
        md_nike.DelimiterChar := ';';
        md_nike.LoadFromTextFile(ODI.files[0]);

        Tnike.open;
        md_nike.first;
        while not md_nike.eof do
        begin
            Tnike.insert;
            TNIKENIK_REF.asstring:=MD_NIKEREF.asstring;
            TNIKENIK_COUL.asstring:=MD_NIKECOUL.asstring;
            TNIKENIK_PERM.asinteger:=1;
            Tnike.post;
            md_nike.next;
        end;

    end;
    Tnike.close;
    md_nike.close;
end;

procedure TForm1.LMDSpeedButton5Click(Sender: TObject);
begin
    if ODI.Execute then
    begin
        Memd_FDS.DelimiterChar := ';';
        Memd_FDS.LoadFromTextFile(ODI.files[0]);
        Tcat.open;
        Tcollec.open;
        screen.cursor:=crsqlwait;
        //Verif marque te collection
        Memd_FDS.first;
        while not Memd_FDS.eof do
        begin
            if not tcat.Locate('cat_nom',Memd_FDSCATEGORIE.AsString,[]) then
            begin
                screen.cursor:=crdefault;
                messagedlg('Catégorie inconnue : '+Memd_FDSCATEGORIE.AsString,mtWarning,[],0);
                EXIT;
            end;

            if not tcollec.Locate('col_nom',Memd_FDSCOLLECTION.AsString,[]) then
            begin
                screen.cursor:=crdefault;
                messagedlg('Collection inconnue : '+Memd_FDSCOLLECTION.AsString,mtWarning,[],0);
                EXIT;
            end;

            qmrk.close;
            qmrk.Parameters[0].Value:=Memd_FDSMARQUE.asstring;
            qmrk.Open;
            if qmrk.eof then
            begin
                screen.cursor:=crdefault;
                messagedlg('Marque inconnue : '+Memd_FDSMARQUE.asstring,mtWarning,[],0);
                qmrk.Close;
                EXIT;
            end;
            qmrk.close;

            memd_fds.edit;
            Memd_FDSCOLID.asinteger:=TCOLLECCOL_ID.asinteger;
            Memd_FDSCATID.asinteger:=TCATCAT_ID.AsInteger;
            memd_fds.post;

            Memd_FDS.next;
        end;



        //Insertion dans la table  (sauf s'il existe déja)
        TFDS.open;
        Memd_FDS.first;
        while not Memd_FDS.eof do
        begin
            if not tfds.locate('fds_marque;fds_ref',VarArrayOf([Memd_FDSMARQUE.asstring,Memd_FDSREF.asstring]),[]) then
            begin
              TFDS.insert;
              TFDSFDS_MARQUE.AsString:=Memd_FDSMARQUE.asstring;
              TFDSFDS_CATID.asinteger:=Memd_FDSCATID.asinteger;
              TFDSFDS_MODELE.asstring:=Memd_FDSMODELE.asstring;
              TFDSFDS_REF.asstring:=Memd_FDSREF.asstring;
              TFDSFDS_DTLIM.asdatetime:=Memd_FDSDATE.asdatetime;
              TFDSFDS_CATMAN.asinteger:=0;
              TFDSFDS_COLID.asinteger:=Memd_FDSCOLID.asinteger;
              TFDS.post;

            end;
            Memd_FDS.next;
        end;
        screen.cursor:=crdefault;
    end;
    TFDS.close;
    Memd_FDS.close;

end;

procedure TForm1.LMDSpeedButton6Click(Sender: TObject);
begin
     if ODI.Execute then
    begin
        memd_col.DelimiterChar := ';';
        memd_col.LoadFromTextFile(ODI.files[0]);

        Tcol.open;
        memd_col.first;
        while not memd_col.eof do
        begin
            Tcol.insert;
            TCOLCOL_MVT.asstring:=MemD_ColMOUV.asstring;
            TCOLCOL_TYP.asinteger:=MemD_Coltyp.asinteger;
             TCOLCOL_SENS.asstring:= MemD_ColSENS.asstring;

            Tcol.post;
            memd_col.next;
        end;

    end;
    Tcol.close;
    memd_col.close;
end;

procedure TForm1.LMDSpeedButton7Click(Sender: TObject);
begin
 if ODI.Execute then
    begin
        memd_rep.DelimiterChar := ';';
        memd_rep.LoadFromTextFile(ODI.files[0]);

        Trep.open;
        memd_rep.first;
        while not memd_rep.eof do
        begin
            Trep.insert;
            IF length(MemD_RepCODE.asstring)=6 then
                  TREPREP_CODE.asstring := MemD_RepCODE.asstring
            else
                  TREPREP_CODE.asstring := '0'+MemD_RepCODE.asstring;
            Trep.post;
            memd_rep.next;
        end;

    end;
    trep.close;
    memd_rep.close;
end;

procedure TForm1.LMDSpeedButton8Click(Sender: TObject);
begin
lkmvt.execute;
end;

procedure TForm1.LMDSpeedButton9Click(Sender: TObject);
begin
 IF ODI.Execute THEN
    BEGIN
        memd_perm.DelimiterChar := ';';
        memd_perm.LoadFromTextFile(ODI.files[0]);
        tmarque.open;
        T_PermAH09.open;
        memd_perm.first;
        WHILE NOT memd_perm.eof DO
        BEGIN
            tmarque.Locate('MRK_NOM',MemD_PermMARQUE.asstring,[]);
            // test si deja existant
            if not T_PermAH09.locate('tmp_refmrk;tmp_mrkid',VarArrayOf([MemD_PermREF.asstring,TMARQUEMRK_ID.asinteger]),[]) then
            begin
              T_PermAH09.insert;
              T_PermAH09tmp_mrkid.asinteger := TMARQUEMRK_ID.asinteger;
              T_PermAH09tmp_refmrk.asstring := MemD_PermREF.asstring;
              T_PermAH09.post;
            end;
            memd_perm.next;
        END;

    END;
    T_PermAH09.close;
    tmarque.close;
    memd_perm.close;
end;

procedure TForm1.Nbt_ArticlesLevisClick(Sender: TObject);
var
  lstFile,lstLigne, lstEntete : TStringList;
  i, j : integer;
begin
//  if OuiNonHP('Attention le référentiel article existant sera supprimé.' + #13#10 + 'Intégration du nouveau catalogue ?',False,True,0,0) then
  if MessageDlg('Attention le référentiel article existant sera supprimé.' + #13#10 + 'Intégration du nouveau catalogue ?',mtConfirmation,[mbYes,mbNo],0) = mrYes then

  begin
    if OD_Levis.Execute then
    begin
      // récupération du fichier
      lstFile := TStringList.Create;
      lstLigne := TStringList.Create;
      lstEntete := TStringList.Create;
      try
        MemD_Levis.Close;
        MemD_Levis.Open;

        lstFile.LoadFromFile(OD_Levis.FileName);

        lstEntete.Text := StringReplace(lstFile[0],';',#13#10,[rfReplaceAll]);

        for i := 1 to lstFile.Count - 1 do
        begin
          lstLigne.Text := StringReplace(lstFile[i],';',#13#10,[rfReplaceAll]);

          With MemD_Levis do
          begin
            Append;
            for j := 0 to lstEntete.Count - 1 do
            if Trim(lstEntete[j]) <> '' then
              FieldByName(lstEntete[j]).AsString := lstLigne[j];
            Post;
          end; // with
        end; // for i

        // copie des données dans la base SQL SERVEUR
        With aQue_InsertLevis do
        begin
          ado.BeginTrans;

          // Suppression des données de la table LEVIS
          if Chk_EraseOld.Checked then
          begin
            aQue_DeleteLevis.Close;
            if rb_type1.Checked then
              aQue_DeleteLevis.Parameters.ParamByName('PLEVTYP').Value := 1
            else
              aQue_DeleteLevis.Parameters.ParamByName('PLEVTYP').Value := 2;
            aQue_DeleteLevis.ExecSQL;
          end;

          MemD_Levis.First;
          try
            while Not MemD_Levis.EOF do
            begin
              Close;
              ParamCheck := True;
              With Parameters do
              begin

                ParamByName('PLEVREF').Value := MemD_Levis.FieldByName('LEV_REF').AsString;
                ParamByName('PLEVLIB').Value := MemD_Levis.FieldByName('LEV_LIB').AsString;
                ParamByName('PLEVTAILLE').Value := MemD_Levis.FieldByName('LEV_TAILLE').AsString;
                ParamByName('PLEVLONG').Value := MemD_Levis.FieldByName('LEV_LONG').AsString;
                ParamByName('PLEVCOULEUR').Value := MemD_Levis.FieldByName('LEV_COULEUR').AsString;
                ParamByName('PLEVEAN').Value := MemD_Levis.FieldByName('LEV_EAN').AsString;
                if rb_type1.Checked then
                  ParamByName('PLEVTYP').Value := 1
                else
                  ParamByName('PLEVTYP').Value := 2;
              end;
              ExecSQL;
              MemD_Levis.Next;
            end; // while

            Ado.CommitTrans;
          Except on E:Exception do
            begin
              ado.RollbackTrans;
              ShowMessage('Erreur d''intégration dans la base SQL SERVEUR : ' + E.Message);
              Exit;
            end;
          end;
        end; // with

      finally
        lstFile.Free;
        lstLigne.Free;
        lstEntete.Free;
      end; // try

    end; // if
  end; // if ouinon

end;

procedure TForm1.Nbt_indMagClick(Sender: TObject);
var ps:integer;
tmp:string;
begin
    //Indicateurs magasins

     t_mag.Close;
     t_mag.open;







    if ODI.Execute then
    begin
        lab_chx.visible:=true;
        lab_chx.caption:= ODI.files[0];

        md_IM.DelimiterChar := ';';
        md_im.LoadFromTextFile(ODI.files[0]);

        t_mag.Open;
        while not md_IM.eof do
        begin
            if length(MD_IMCODE.asstring)=5 then
            begin
             md_im.edit;
             MD_IMCODE.asstring:='0'+MD_IMCODE.asstring;
             md_im.Post;
            end;

            if length(MD_IMCODE.asstring)=4 then
            begin
             md_im.edit;
             MD_IMCODE.asstring:=MD_IMCODE.asstring+'0';
             md_im.Post;
            end;



            if not t_mag.locate('mag_code',MD_IMCODE.asstring,[]) then
            begin
               showmessage('Mag non trouvé : '+ MD_IMCODE.asstring);
               Exit;
            end;


            md_IM.next;
        end;
        md_im.First;
        if not lk_col.execute then exit;
        if not lk_cat.execute then exit;
        if not lk_mrk.execute then exit;

        t_im.open;
        while not md_IM.eof do
        begin
            ps:=pos (' ',MD_IMBUDGET.asstring);
            if ps<>0 then
            begin
              md_im.edit;
              tmp:=MD_IMBUDGET.asstring;
              delete (tmp,ps,1);
              MD_IMBUDGET.asstring:=tmp;
              md_im.Post;
            end;

            ps:=pos ('%',MD_IMMARGE.asstring);
            if ps<>0 then
            begin
              md_im.edit;
              tmp:=MD_IMMARGE.asstring;
              delete (tmp,ps,1);
              MD_IMMARGE.asstring:=tmp;
              md_im.Post;



            end;

            t_mag.locate('mag_code',MD_IMCODE.asstring,[]);

            t_im.Insert;
            T_imIND_MAGID.asinteger:= t_mag.FieldByName('mag_id').asinteger;
            T_imIND_COLID.asinteger:= TCOLLECCOL_ID.asinteger;
            T_imIND_CATID.asinteger:= TCATCAT_ID.asinteger;
            T_imIND_MRKID.asinteger:=Tmrkmrk_id.asinteger;

            if MD_IMBUDGET.asstring<>'' then
               T_imIND_ACHAT.asfloat:= MD_IMBUDGET.asfloat
            else
               T_imIND_ACHAT.asfloat:=0;

            if MD_IMMARGE.Asstring<>'' then
                  T_imIND_MARGE.asfloat:=MD_IMMARGE.AsFloat
            else
            T_imIND_MARGE.asfloat:=0;

            T_imIND_UNIID.asinteger:=T_uniuni_id.asinteger;

            t_im.Post;



            md_IM.next;
        end;

    end;
    t_im.close;
    md_IM.close;
end;

procedure TForm1.Nbt_permClick(Sender: TObject);
begin
 IF ODI.Execute THEN
    BEGIN
        memd_perm.DelimiterChar := ';';
        memd_perm.LoadFromTextFile(ODI.files[0]);
        tmarque.open;
        Tperm.open;
        memd_perm.first;
        WHILE NOT memd_perm.eof DO
        BEGIN



            Tperm.insert;
            tmarque.Locate('MRK_NOM',MemD_PermMARQUE.asstring,[]);
            TPERMtmp_mrkid.asinteger := TMARQUEMRK_ID.asinteger;
            TPERMtmp_refmrk.asstring := MemD_PermREF.asstring;
            if MemD_PermMARQUE.asstring='NIKE' then
              TPERMtmp_couleur.asstring:=MemD_PermCOULEUR.asstring
            else
              TPERMtmp_couleur.asstring:='';
            Tperm.post;
            memd_perm.next;
        END;

    END;
    tperm.close;
    tmarque.close;
    memd_perm.close;
end;

end.

