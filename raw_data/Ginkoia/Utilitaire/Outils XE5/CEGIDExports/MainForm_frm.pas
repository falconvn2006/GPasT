unit MainForm_frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons;

Const CRLF=#13+#10;
      SQL_CEGID_TIERS = 'SELECT T_TIERS, ' + CRLF +
                        ' [C1].YX_LIBELLE AS DOSSIER, '+ CRLF +
                        ' T_LIBELLE,  ' + CRLF +
                        ' T_ADRESSE1, ' + CRLF +
                        ' T_CODEPOSTAL,    '+ CRLF +
                        ' T_VILLE, '+ CRLF +
                        ' T_ENSEIGNE, '+ CRLF +
                        ' [C0].YX_LIBELLE AS RESEAU, '+ CRLF +
                        ' C3.CC_LIBELLE AS SECTEUR, '+ CRLF +
                        ' T_SECTEUR, '+ CRLF +
                        ' GCL_PRENOM + '' '' + GCL_LIBELLE AS REPRESENTANT, '+ CRLF +
                        ' T_TELEPHONE, '+ CRLF +
                        ' T_EMAIL, '+ CRLF +
                        ' T_DATEPROCLI, '+ CRLF +
                        ' T_ETATRISQUE, '+ CRLF +
                        ' RPR_RPRLIBMUL0, '+ CRLF +
                        ' C_NOM, '+ CRLF +
                        ' C_PRENOM, '+ CRLF +
                        ' C_TELEPHONE, '+ CRLF +
                        ' C_TELEX, '+ CRLF +
                        ' C_RVA, '+ CRLF +
                        ' C_FONCTION, '+ CRLF +
                        ' C2.CC_LIBELLE AS NUM_VERSION, '+ CRLF +
                        ' YTC_BOOLLIBRE1 AS VIP, '+ CRLF +
                        ' RPR_RPRLIBTEXTE9 AS CODEADH '+ CRLF +
                        ' FROM TIERS AS TIERS   '+ CRLF +
                        ' LEFT JOIN TIERSCOMPL ON (YTC_AUXILIAIRE=T_AUXILIAIRE) '+ CRLF +
                        ' LEFT JOIN PROSPECTS ON (dbo.PROSPECTS.RPR_AUXILIAIRE=T_AUXILIAIRE) '+ CRLF +
                        ' LEFT JOIN CHOIXEXT AS C0 ON (C0.YX_TYPE=''LT2'' AND C0.YX_CODE=YTC_TABLELIBRETIERS2)  '+ CRLF +
                        ' LEFT JOIN CONTACT ON C_TIERS=T_TIERS AND C_PRINCIPAL=''X'' '+ CRLF +
                        ' LEFT JOIN COMMERCIAL ON (GCL_COMMERCIAL=T_REPRESENTANT)    '+ CRLF +
                        ' JOIN CHOIXEXT AS C1 ON (C1.YX_TYPE=''LT1'' AND C1.YX_CODE=YTC_TABLELIBRETIERS1 AND C1.YX_LIBELLE<>''DIVERS'') '+ CRLF +
                        ' LEFT JOIN CHOIXCOD AS C2 ON (C2.CC_TYPE=''RL3'' AND C2.CC_CODE=RPR_RPRLIBTABLE3 ) '+ CRLF +
                        ' LEFT JOIN CHOIXCOD AS C3 ON (C3.CC_TYPE=''SCC'' AND C3.CC_CODE=T_SECTEUR ) '+ CRLF +
                        ' WHERE TIERS.T_NATUREAUXI=''CLI'' AND T_FERME=''-'' ';
      SQL_BMC_TIERS  =  'SELECT * FROM _TIERS WHERE Code__btiers=:Code__btiers';
      //-----------------------------------------
      SQL_CEGID_CONTACTS = 'SELECT C_TIERS AS TIERS, '   + CRLF +
                          '  C_NOM AS NOM,          '    + CRLF +
                          '  C_PRENOM AS PRENOM,    '    + CRLF +
                          '  C_TELEPHONE AS TELEPHONE, ' + CRLF +
                          '  C_TELEX AS MOBILE,        ' + CRLF +
                          '  RTRIM(C_RVA) AS EMAIL,    ' + CRLF +
                          '  C_FONCTION AS FONCTION,   ' + CRLF +
                          '  C_PRINCIPAL AS REFERANT   ' + CRLF +
                          '  FROM [GINKOIA2005].[dbo].[CONTACT] ' + CRLF +
                          '  WHERE C_NATUREAUXI=''CLI'' AND (C_NOM<>'''' OR C_PRENOM<>'''') ';

      SQL_BMC_CONTACTS  =  'SELECT * FROM _CONTACTS WHERE Nom=:Nom AND Prenom=:Prenom AND Code__btiers=:Code__btiers';

      //-----------------------------------------
      SQL_CEGID_APPELANTS = 'SELECT                    ' + CRLF +
                            ' ARS_LIBELLE AS NOM,      ' + CRLF +
                            ' ARS_LIBELLE2 AS PRENOM,  ' + CRLF +
                            ' ARS_EMAIL AS EMAIL,      ' + CRLF +
                            ' YX_LIBELLE AS EQUIPE,     ' + CRLF +
                            ' ARS_TYPERESSOURCE        ' + CRLF +
                            ' FROM [GINKOIA2005].[dbo].RESSOURCE ' + CRLF +
                            ' LEFT JOIN [GINKOIA2005].[dbo].CHOIXEXT ON YX_TYPE=''AEQ'' AND YX_CODE=ARS_EQUIPERESS ' + CRLF +
                            ' WHERE ARS_FERME=''-'' ';
      SQL_BMC_APPELANTS  =  'SELECT * FROM [_Tiers_Appelant] WHERE Nom__bAppelant=:Nom__bAppelant AND Prenom__bAppelant=:Prenom__bAppelant';

type
  TFrm_Main = class(TForm)
    QCEGID: TFDQuery;
    QBMC: TFDQuery;
    ProgressBar1: TProgressBar;
    QCGID_MODULE: TFDQuery;
    cb_tiers: TCheckBox;
    Cb_Appelants: TCheckBox;
    cb_CONTACTS: TCheckBox;
    Image1: TImage;
    BImporter: TBitBtn;
    Label_Importation: TLabel;
    cbTRUNCATE: TCheckBox;
    procedure BExecuteClick(Sender: TObject);
    procedure BImporterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FAuto:Boolean;
    FNBJOUR:Integer;
    procedure EIExecute;
    procedure Attendre;

    procedure Delete_Tiers;
    procedure Delete_Contacts;
    procedure Delete_Appelants;

    procedure ExportImport_Tiers;
    procedure ExportImport_Contacts;
    procedure ExportImport_Appelants;
    procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

{$R *.dfm}

USes UDataMod;


procedure TFrm_Main.BExecuteClick(Sender: TObject);
begin
      ExportImport_Tiers;
end;

procedure TFrm_Main.BImporterClick(Sender: TObject);
begin
    EIExecute;
end;

procedure TFrm_Main.EIExecute;
begin
     TForm(Self).Enabled:=False;
     BImporter.Visible:=false;
     ProgressBar1.Visible:=true;
     Label_Importation.Caption:='';
     if cb_tiers.Checked and cbTRUNCATE.Checked
        then Delete_Tiers;

     if cb_tiers.Checked and cbTRUNCATE.Checked
        then Delete_Contacts;

     if cb_tiers.Checked and cbTRUNCATE.Checked
        then Delete_Appelants;

     if cb_tiers.Checked      then ExportImport_Tiers;
     if cb_CONTACTS.Checked   then ExportImport_Contacts;
     if Cb_Appelants.Checked  then ExportImport_Appelants;
     ProgressBar1.Visible:=false;
     Label_Importation.Caption:='Importation Terminée';
     If not FAuto then MessageDlg('Importation Terminée',  mtInformation, [mbOK], 0);
     TForm(Self).Enabled:=true;
end;


procedure TFrm_Main.ExportImport_Appelants;
begin
   //------------------------------
   Label_Importation.Caption:='Appelants...';
   DataMod.FDConCEGID.Open;

   QCEGID.Close;
   QCEGID.SQL.Clear;
   QCEGID.SQL.Text:=SQL_CEGID_APPELANTS;
   QCEGID.open;

   //------------------------------

   ProgressBar1.Position:=0;
   ProgressBar1.Max:=QCEGID.RecordCount;
   try
      while not(QCEGID.Eof) do
      begin
          QBMC.Close;
          QBMC.SQL.Clear;
          QBMC.SQL.Text:=SQL_BMC_APPELANTS;
          QBMC.ParamByName('Nom__bAppelant').AsString:=QCEGID.FieldByName('NOM').asstring;
          QBMC.ParamByName('Prenom__bAppelant').AsString:=QCEGID.FieldByName('PRENOM').asstring;
          QBMC.Open;
          if QBMC.RecordCount=1 then
            begin
                QBMC.Edit;
            end;
          if QBMC.RecordCount=0 then
            begin
                 QBMC.Insert;
                 QBMC.FieldByName('Nom__bAppelant').AsString:=QCEGID.FieldByName('NOM').asstring;
                 QBMC.FieldByName('Prenom__bAppelant').AsString:=QCEGID.FieldByName('PRENOM').asstring;
            end;
          if (QBMC.State in [dsEdit,dsInsert]) then
            begin
                QBMC.FieldByName('Tiers__bAppelant').AsString:=QCEGID.FieldByName('ARS_TYPERESSOURCE').asstring;
                QBMC.FieldByName('Email__bAppelant').AsString:=QCEGID.FieldByName('EMAIL').AsString;
                QBMC.FieldByName('Equipe__bAppelant').AsString:=QCEGID.FieldByName('EQUIPE').AsString;
                QBMC.post;
            end;
          ProgressBar1.Position:=QCEGID.RecNo;
          Application.ProcessMessages;
          QCEGID.Next;
      end;
   finally

   end;
end;

procedure TFrm_Main.Delete_Contacts;
begin
    Label_Importation.Caption:='Delete Contacts...';
    QBMC.Close;
    QBMC.SQL.Clear;
    QBMC.SQL.Text:='TRUNCATE TABLE [_Contacts]';
    QBMC.ExecSQL;
end;

procedure TFrm_Main.Delete_Appelants;
begin
    Label_Importation.Caption:='Delete Tiers_Appelant...';
    QBMC.Close;
    QBMC.SQL.Clear;
    QBMC.SQL.Text:='TRUNCATE TABLE [_Tiers_Appelant]';
    QBMC.ExecSQL;
end;

procedure TFrm_Main.ExportImport_Contacts;
begin
   //------------------------------
   Label_Importation.Caption:='Contacts...';
   DataMod.FDConCEGID.Open;

   QCEGID.Close;
   QCEGID.SQL.Clear;
   QCEGID.SQL.Text:=SQL_CEGID_CONTACTS;
   QCEGID.open;

   //------------------------------

   ProgressBar1.Position:=0;
   ProgressBar1.Max:=QCEGID.RecordCount;
   try
      while not(QCEGID.Eof) do
      begin
          QBMC.Close;
          QBMC.SQL.Clear;
          QBMC.SQL.Text:=SQL_BMC_CONTACTS;
          QBMC.ParamByName('Code__btiers').AsString:=QCEGID.FieldByName('TIERS').asstring;
          QBMC.ParamByName('Nom').AsString:=QCEGID.FieldByName('NOM').asstring;
          QBMC.ParamByName('Prenom').AsString:=QCEGID.FieldByName('PRENOM').asstring;
          QBMC.Open;
          if QBMC.RecordCount=1 then
            begin
                QBMC.Edit;
            end;
          if QBMC.RecordCount=0 then
            begin
                 QBMC.Insert;
                 QBMC.FieldByName('Code__btiers').AsString:=QCEGID.FieldByName('TIERS').asstring;
                 QBMC.FieldByName('Nom').AsString:=QCEGID.FieldByName('NOM').asstring;
                 QBMC.FieldByName('Prenom').AsString:=QCEGID.FieldByName('PRENOM').asstring;
            end;
          if (QBMC.State in [dsEdit,dsInsert]) then
            begin
                QBMC.FieldByName('Mobile').AsString:=QCEGID.FieldByName('MOBILE').AsString;
                QBMC.FieldByName('Telephone').AsString:=QCEGID.FieldByName('TELEPHONE').AsString;
                QBMC.FieldByName('Email').AsString:=QCEGID.FieldByName('EMAIL').AsString;
                QBMC.FieldByName('Fonction').AsString:=QCEGID.FieldByName('FONCTION').AsString;
                if QCEGID.FieldByName('REFERANT').AsString='X'
                  then QBMC.FieldByName('Contact_referant').asstring:='Référant'
                  else QBMC.FieldByName('Contact_referant').asstring:='';
                //--------------------------------------------------------------
                QBMC.post;
            end;
          ProgressBar1.Position:=QCEGID.RecNo;
          Application.ProcessMessages;
          QCEGID.Next;
      end;
   finally

   end;
end;

procedure TFrm_Main.Delete_Tiers;
begin
    Label_Importation.Caption:='Delete Tiers...';
    QBMC.Close;
    QBMC.SQL.Clear;
    QBMC.SQL.Text:='TRUNCATE TABLE [_Tiers]';
    QBMC.ExecSQL;
end;

procedure TFrm_Main.ExportImport_Tiers;
var ModulesList:TStringList;
    i:Integer;
begin
    Label_Importation.Caption:='Tiers...';
    //
    DataMod.FDConCEGID.Open;

    QCGID_MODULE.Close;
    QCGID_MODULE.SQL.Clear;
    QCGID_MODULE.SQL.text:='SELECT * FROM CHOIXCOD WHERE CC_TYPE=''RM0''';
    QCGID_MODULE.open;


   QCEGID.Close;
   QCEGID.SQL.Clear;
   QCEGID.SQL.Text:=SQL_CEGID_TIERS;
   QCEGID.open;
   //------------------------------

   ModulesList := TStringList.Create;
   ProgressBar1.Position:=0;
   ProgressBar1.Max:=QCEGID.RecordCount;
   try

      while not(QCEGID.Eof) do
      begin
          QBMC.Close;
          QBMC.SQL.Clear;
          QBMC.SQL.Text:=SQL_BMC_TIERS;
          QBMC.ParamByName('Code__btiers').AsString:=QCEGID.FieldByName('T_TIERS').asstring;
          QBMC.Open;
          if QBMC.RecordCount=1 then
            begin
                QBMC.Edit;
            end;
          if QBMC.RecordCount=0 then
            begin
                 QBMC.Insert;
                 QBMC.FieldByName('Code__btiers').AsString:=QCEGID.FieldByName('T_TIERS').asstring;
            end;
          if (QBMC.State in [dsEdit,dsInsert]) then
            begin
                Split(';',QCEGID.FieldByName('RPR_RPRLIBMUL0').asstring, ModulesList);
                QBMC.FieldByName('MODULE').asstring:='';
                for I := 0 to ModulesList.Count-1 do
                  begin
                      if QCGID_MODULE.Locate('CC_CODE', ModulesList.Strings[i],[])
                        then QBMC.FieldByName('MODULE').asstring:=QBMC.FieldByName('MODULE').asstring + QCGID_MODULE.FieldByName('CC_LIBELLE').AsString + #13+#10;
                  end;
                 if QCEGID.FieldByName('T_DATEPROCLI').asDateTime>Now()-Fnbjour
                  then QBMC.FieldByName('Nouveau__bClient').asstring:='Nouveau'
                  else QBMC.FieldByName('Nouveau__bClient').asstring:='';

                 If (QCEGID.FieldByName('VIP').asstring='X')
                   then QBMC.FieldByName('VIP').AsString  :='Oui'
                   else QBMC.FieldByName('VIP').AsString  :='Non';

                 If (QCEGID.FieldByName('T_ETATRISQUE').asstring='O')
                   then QBMC.FieldByName('Risque_client').AsString :='Orange';

                 If (QCEGID.FieldByName('T_ETATRISQUE').asstring='V')
                   then QBMC.FieldByName('Risque_client').AsString :='Vert';

                 If (QCEGID.FieldByName('T_ETATRISQUE').asstring='R')
                   then QBMC.FieldByName('Risque_client').AsString :='Rouge';

                 If (QCEGID.FieldByName('T_ETATRISQUE').asstring='')
                   then QBMC.FieldByName('Risque_client').AsString :='';

                QBMC.FieldByName('Dossier').AsString            := QCEGID.FieldByName('DOSSIER').asstring;
                QBMC.FieldByName('Raison__bSociale').AsString   := QCEGID.FieldByName('T_LIBELLE').asstring;
                QBMC.FieldByName('Adresse1').AsString           := QCEGID.FieldByName('T_ADRESSE1').asstring;
                QBMC.FieldByName('Code__bPostale').AsString     := QCEGID.FieldByName('T_CODEPOSTAL').asstring;
                QBMC.FieldByName('Ville').AsString              := QCEGID.FieldByName('T_VILLE').asstring;
                QBMC.FieldByName('Enseigne').AsString           := QCEGID.FieldByName('T_ENSEIGNE').asstring;
                QBMC.FieldByName('Telephone__bMagasin').AsString:= QCEGID.FieldByName('T_TELEPHONE').asstring;
                QBMC.FieldByName('Email__bmagasin').AsString    := QCEGID.FieldByName('T_EMAIL').asstring;

                QBMC.FieldByName('Secteur__bactivite').AsString:=QCEGID.FieldByName('SECTEUR').asstring;
                QBMC.FieldByName('ID__bCommercial').AsString:=Trim(QCEGID.FieldByName('REPRESENTANT').asstring);
                QBMC.FieldByName('Reseau').AsString:=QCEGID.FieldByName('RESEAU').AsString;
                QBMC.FieldByName('Version_Ginkoia').AsString:=QCEGID.FieldByName('NUM_VERSION').AsString;

                QBMC.FieldByName('Code_Adh').AsString:=QCEGID.FieldByName('CODEADH').AsString;

                QBMC.post;
            end;
          ProgressBar1.Position:=QCEGID.RecNo;
          Application.ProcessMessages;
          QCEGID.Next;
      end;
   finally
     ModulesList.Free;
   end;
end;



procedure TFrm_Main.FormCreate(Sender: TObject);
var i:Integer;
    param:string;
    value:string;
begin
     FAuto:=false;
     FNBJOUR:=365;
     //-------------------------------------------------------------------------
       for i :=1 to ParamCount do
        begin
              // Debug
             If lowercase(ParamStr(i))='-auto'  then FAuto:=true;
             param:=Copy(ParamStr(i),1,Pos('=',ParamStr(i))-1);
             value:=Copy(ParamStr(i),Pos('=',ParamStr(i))+1,length(ParamStr(i)));
             If lowercase(param)='-nbjour'  then FNBJOUR:=StrToIntDef(value,365);
        end;
      Caption:='CEGID2BMC :: NewClient ' + FormatDateTime('dd/mm/yyyy',Now()-FNBJOUR);
      If FAuto
          then
              begin
                   ShowWindow(Application.Handle, SW_HIDE);
                   EIExecute;
                   Application.ProcessMessages;
                   // Attendre;
                   Application.Terminate;
              end
          else
              begin
                   Application.ShowMainForm:=true;
                   ShowWindow(Application.Handle, SW_SHOW);
              end;
end;

procedure TFrm_Main.Attendre;
var Ticks: DWORD;
begin
     Ticks := 0;
     while (Ticks = GetTickCount) do  Sleep(10);
end;

procedure TFrm_Main.Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter     := Delimiter;
   ListOfStrings.DelimitedText := Str;
end;

end.
