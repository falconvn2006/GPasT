unit GXMainForm_frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons, inifiles;




Const CRLF=#13+#10;
      SQL_GX_TIERS = 'select  ' + CRLF +
                    ' Champ32 as T_TIERS ' + CRLF +
                    ' ,Champ18 as DOSSIER ' + CRLF +
                    ' ,Nom_Client as T_LIBELLE ' + CRLF +
                    ' ,Adresse1 as T_ADRESSE1 ' + CRLF +
                    ' ,Code_Postal as T_CODEPOSTAL ' + CRLF +
                    ' ,Nom_Ville as T_VILLE ' + CRLF +
                    ' ,Champ12 as T_ENSEIGNE ' + CRLF +
                    ' ,Champ31 as RESEAU ' + CRLF +
                    ' ,Champ13 as SECTEUR ' + CRLF +
                    ' ,Champ33 as REPRESENTANT ' + CRLF +
                    ' ,Standard as T_TELEPHONE ' + CRLF +
                    ' ,Email as T_EMAIL ' + CRLF +
                    ' ,ISNULL(Champ35,''01/01/1900'') as T_DATEPROCLI ' + CRLF +
                    ' ,Eviter as T_ETATRISQUE ' + CRLF +
                    ' ,(select(STUFF(( select DISTINCT '';''+LTRIM(RTRIM(ORDREF.Champ4)) from ORDREF where ORDREF.Egxs_N_Client=CLIENT.N_Client for xml path('''')),1,1,''''))) as RPR_RPRLIBMUL0 ' + CRLF +
                    ' ,Champ21 as NUM_VERSION ' + CRLF +
                    ' ,ISNULL(Champ8,''Non'') as VIP ' + CRLF +
                    ' ,Champ26 as CODEADH ' + CRLF +
                    ' from CLIENT ' + CRLF +
                    ' where Champ32 is not null and Champ18 is not null and Champ18 not in (''Aucun'',''Divers'') and Champ3=''client'' ';
      SQL_BMC_TIERS  =  'SELECT * FROM _Tiers WHERE Code__btiers=:Code__btiers';

      SQL_BMC_TIERS_INSERT = 'INSERT INTO _TIERS (Code__btiers, Module, Nouveau__bClient, Vip, Risque_client, Dossier, Raison__bSociale ' +
                             ', Adresse1, Code__bPostale, Ville, Enseigne, Telephone__bMagasin, Email__bmagasin, Secteur__bactivite, ID__bCommercial, Reseau, Version_Ginkoia, Code_Adh) ' +
                             'VALUES (:Code__btiers, :Module, :Nouveau__bClient, :Vip, :Risque_client, :Dossier, :Raison__bSociale ' +
                             ', :Adresse1, :Code__bPostale, :Ville, :Enseigne, :Telephone__bMagasin, :Email__bmagasin, :Secteur__bactivite, :ID__bCommercial, :Reseau, :Version_Ginkoia, :Code_Adh)';

      SQL_BMC_TIERS_UPDATE = 'UPDATE _TIERS SET Module=:Module, Nouveau__bClient=:Nouveau__bClient, Vip=:Vip, Risque_client=:Risque_client ' +
                             ', Dossier=:Dossier, Raison__bSociale=:Raison__bSociale, Adresse1=:Adresse1, Code__bPostale=:Code__bPostale, Ville=:Ville ' +
                             ', Enseigne=:Enseigne, Telephone__bMagasin=:Telephone__bMagasin, Email__bmagasin=:Email__bmagasin ' +
                             ', Secteur__bactivite=:Secteur__bactivite, ID__bCommercial=:ID__bCommercial, Reseau=:Reseau, Version_Ginkoia=:Version_Ginkoia, Code_Adh=:Code_Adh ' +
                             'WHERE Code__btiers=:Code__btiers';

      //-----------------------------------------
      SQL_GX_CONTACTS = 'select distinct ' + CRLF +
                        ' Champ32 as TIERS ' + CRLF +
                        ' ,Nom_Contact as NOM ' + CRLF +
                        ' ,Prenom_Contact as PRENOM ' + CRLF +
                        ' ,Ligne_Directe as TELEPHONE ' + CRLF +
                        ' ,Portable as MOBILE ' + CRLF +
                        ' ,Internet as EMAIL ' + CRLF +
                        ' ,Fonction as FONCTION ' + CRLF +
                        ' ,Champ1 as REFERANT ' + CRLF +
                        ' from ( ' + CRLF +
                        ' 	select  ' + CRLF +
                        ' 	c2.Champ32,Nom_Contact,Prenom_Contact,CONTACT.Ligne_Directe,CONTACT.Portable,CONTACT.Internet,Fonction,CONTACT.Champ1,CONTACT.Champ4,egxs_import ' + CRLF +
                        ' 	from CLIENT as c1 ' + CRLF +
                        ' 	inner join client as c2 on c2.EGXS_GROUPE=c1.N_Client and c2.Champ3=''client'' ' + CRLF +
                        ' 	left join CONTACT on CONTACT.N_Client=c1.N_Client or CONTACT.N_Client=c2.N_Client ' + CRLF +
                        ' 	where c1.Champ3=''DOSSIER'' ' + CRLF +
                        ' )as contact_fuse ' + CRLF +
                        ' left join ( ' + CRLF +
                        ' 	select Champ32 as code_tiers,count(Champ32) as cpt,max(egxs_import) as import ' + CRLF +
                        ' 	from CONTACT as C1 ' + CRLF +
                        ' 	left join CLIENT as C2 on C2.N_Client=C1.N_Client ' + CRLF +
                        ' 	where C1.Champ4=''Non'' or C1.Champ4 is null  ' + CRLF +
                        ' 	and Champ32 is not null ' + CRLF +
                        ' 	group by Champ32 ' + CRLF +
                        ' 	having max(egxs_import) is not null and count(Champ32)=1 ' + CRLF +
                        ' )as tempo on tempo.code_tiers=Champ32 ' + CRLF +
                        ' where contact_fuse.Champ4=''Non'' or contact_fuse.Champ4 is null  ' + CRLF +
                        ' and Champ32 is not null ' + CRLF +
                        ' and (egxs_import is null or (egxs_import=''Oui'' and tempo.import=''Oui''))';

      SQL_BMC_CONTACTS  =  'SELECT * FROM _CONTACTS WHERE Nom=:Nom AND Prenom=:Prenom AND Code__btiers=:Code__btiers';

      SQL_BMC_CONTACTS_INSERT = 'INSERT INTO _CONTACTS (Nom, Prenom, Mobile, Telephone, Email, Fonction, Code__btiers, Contact_referant) ' +
																'VALUES(:Nom, :Prenom, :Mobile, :Telephone, :Email, :Fonction, :Code__btiers, :Contact_referant)';

      SQL_BMC_CONTACTS_UPDATE = 'UPDATE _CONTACTS SET Mobile=:Mobile, Telephone=:Telephone, Email=:Email, Fonction=:Fonction ' +
      													', Contact_referant=:Contact_referant WHERE Code__btiers=:Code__btiers AND Nom=:Nom AND Prenom=:Prenom';



      //-----------------------------------------
      SQL_GX_APPELANTS = 'select ' + CRLF +
                        ' Champ32 as tiers ' + CRLF +
                        ' ,Nom_Contact as NOM ' + CRLF +
                        ' ,Prenom_Contact as PRENOM ' + CRLF +
                        ' ,CONTACT.Internet as EMAIL ' + CRLF +
                        ' ,CONTACT.Champ5 as EQUIPE ' + CRLF +
                        ' ,''SAL'' as ARS_TYPERESSOURCE --Tiers__bAppelant ' + CRLF +
                        ' from CONTACT ' + CRLF +
                        ' left join CLIENT on CLIENT.N_Client=CONTACT.N_Client ' + CRLF +
                        ' where Champ32 is not null ' + CRLF +
                        ' and CONTACT.Champ4=''Oui'' ';
      SQL_BMC_APPELANTS  =  'SELECT * FROM _Tiers_Appelant WHERE Nom__bAppelant=:Nom__bAppelant AND Prenom__bAppelant=:Prenom__bAppelant';

      SQL_BMC_APPELANTS_INSERT = 'INSERT INTO _Tiers_Appelant (Tiers__bAppelant, Nom__bAppelant, Prenom__bAppelant, Email__bAppelant, Equipe__bAppelant) ' +
																'VALUES (:Tiers__bAppelant, :Nom__bAppelant, :Prenom__bAppelant, :Email__bAppelant, :Equipe__bAppelant)';

      SQL_BMC_APPELANTS_UPDATE = 'UPDATE _Tiers_Appelant SET Tiers__bAppelant=:Tiers__bAppelant, Email__bAppelant=:Email__bAppelant ' +
																', Equipe__bAppelant=:Equipe__bAppelant WHERE Nom__bAppelant=:Nom__bAppelant AND Prenom__bAppelant=:Prenom__bAppelant';

type
  TFrm_Main = class(TForm)
    QGX: TFDQuery;
    QBMC: TFDQuery;
    ProgressBar1: TProgressBar;
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
    procedure FormActivate(Sender: TObject);
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
var
	inifile:TIniFile;
  test:string;
begin
		 try
     	inifile:= TIniFile.Create(ExtractFilePath( Application.ExeName ) + ChangeFileExt(ExtractFileName(Application.ExeName),'.ini'));

     	with DataMod.FDConGX.Params do
      begin
        Clear;
        Add('User_Name=' + inifile.ReadString('GX','user_name',''));
        Add('Password=' + inifile.ReadString('GX','password',''));
        Add('Server=' + inifile.ReadString('GX','server',''));
        Add('Database=' + inifile.ReadString('GX','database',''));
        Add('DriverID=' + inifile.ReadString('GX','driverid',''));
      end;

      with DataMod.FDConBMC.Params do
      begin
        Clear;
        Add('User_Name=' + inifile.ReadString('BMC','user_name',''));
        Add('Password=' + inifile.ReadString('BMC','password',''));
        Add('Server=' + inifile.ReadString('BMC','server',''));
        Add('Database=' + inifile.ReadString('BMC','database',''));
        Add('DriverID=' + inifile.ReadString('BMC','driverid',''));
      end;

      with DataMod.FDConBMC_DEV.Params do
      begin
        Clear;
        Add('User_Name=' + inifile.ReadString('BMC_dev','user_name',''));
        Add('Password=' + inifile.ReadString('BMC_dev','password',''));
        Add('Server=' + inifile.ReadString('BMC_dev','server',''));
        Add('Database=' + inifile.ReadString('BMC_dev','database',''));
        Add('DriverID=' + inifile.ReadString('BMC_dev','driverid',''));
      end;

      if(inifile.ReadBool('CONFIG','use_dev',false)=True) then
      	QBMC.Connection := DataMod.FDConBMC_DEV
      else
      	QBMC.Connection := DataMod.FDConBMC;

     finally
       inifile.Free;
     end;


     TForm(Self).Enabled:=False;
     BImporter.Visible:=false;
     ProgressBar1.Visible:=true;
     Label_Importation.Caption:='';
     if cb_tiers.Checked and cbTRUNCATE.Checked
        then Delete_Tiers;

     if cb_CONTACTS.Checked and cbTRUNCATE.Checked
        then Delete_Contacts;

     if Cb_Appelants.Checked and cbTRUNCATE.Checked
        then Delete_Appelants;

     if cb_tiers.Checked      then
     	ExportImport_Tiers;
     if cb_CONTACTS.Checked   then
     	ExportImport_Contacts;
     if Cb_Appelants.Checked  then
     	ExportImport_Appelants;
     ProgressBar1.Visible:=false;
     Label_Importation.Caption:='Importation Terminée';
     If not FAuto then MessageDlg('Importation Terminée',  mtInformation, [mbOK], 0);
     TForm(Self).Enabled:=true;
end;


procedure TFrm_Main.ExportImport_Appelants;
var existe:Boolean;
begin
   //------------------------------
   Label_Importation.Caption:='Appelants...';
   //DataMod.FDConCEGID.Open;

   QGX.Close;
   QGX.SQL.Clear;
   QGX.SQL.Text:=SQL_GX_APPELANTS;
   QGX.open;


   //------------------------------

   ProgressBar1.Position:=0;
   ProgressBar1.Max:=QGX.RecordCount;
   try
      while not(QGX.Eof) do
      begin
          QBMC.Close;
          QBMC.SQL.Clear;
          QBMC.SQL.Text:=SQL_BMC_APPELANTS;
          QBMC.ParamByName('Nom__bAppelant').AsString:=QGX.FieldByName('NOM').asstring;
          QBMC.ParamByName('Prenom__bAppelant').AsString:=QGX.FieldByName('PRENOM').asstring;
          QBMC.Open;

          if QBMC.RecordCount=0 then
            existe := False
          else
            existe := true;

          QBMC.Close;
          QBMC.SQL.Text := '';

          if existe then
						QBMC.SQL.Text := SQL_BMC_APPELANTS_UPDATE
          else
          	QBMC.SQL.Text := SQL_BMC_APPELANTS_INSERT;




          QBMC.ParamByName('Tiers__bAppelant').AsString:=QGX.FieldByName('ARS_TYPERESSOURCE').asstring;
          QBMC.ParamByName('Nom__bAppelant').AsString:=QGX.FieldByName('NOM').asstring;
          QBMC.ParamByName('Prenom__bAppelant').AsString:=QGX.FieldByName('PRENOM').asstring;
          QBMC.ParamByName('Email__bAppelant').AsString:=QGX.FieldByName('EMAIL').asstring;
          QBMC.ParamByName('Equipe__bAppelant').AsString:=QGX.FieldByName('EQUIPE').asstring;

					QBMC.ExecSQL;

          ProgressBar1.Position:=QGX.RecNo;
          Application.ProcessMessages;
          QGX.Next;
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
var existe:Boolean;
begin
   //------------------------------
   Label_Importation.Caption:='Contacts...';
   //DataMod.FDConCEGID.Open;

   QGX.Close;
   QGX.SQL.Clear;
   QGX.SQL.Text:=SQL_GX_CONTACTS;
   QGX.open;

   //------------------------------

   ProgressBar1.Position:=0;
   ProgressBar1.Max:=QGX.RecordCount;
   try
      while not(QGX.Eof) do
      begin
          QBMC.Close;
          QBMC.SQL.Clear;
          QBMC.SQL.Text:=SQL_BMC_CONTACTS;
          QBMC.ParamByName('Code__btiers').AsString:=QGX.FieldByName('TIERS').asstring;
          QBMC.ParamByName('Nom').AsString:=QGX.FieldByName('NOM').asstring;
          QBMC.ParamByName('Prenom').AsString:=QGX.FieldByName('PRENOM').asstring;
          QBMC.Open;


          if QBMC.RecordCount=0 then
            existe := False
          else
            existe := true;

          QBMC.Close;
          QBMC.SQL.Text := '';

          if existe then
						QBMC.SQL.Text := SQL_BMC_CONTACTS_UPDATE
          else
          	QBMC.SQL.Text := SQL_BMC_CONTACTS_INSERT;


          QBMC.ParamByName('Nom').AsString:=QGX.FieldByName('NOM').asstring;
          QBMC.ParamByName('Prenom').AsString:=QGX.FieldByName('PRENOM').asstring;
          QBMC.ParamByName('Mobile').AsString:=QGX.FieldByName('MOBILE').asstring;
          QBMC.ParamByName('Telephone').AsString:=QGX.FieldByName('TELEPHONE').asstring;
          QBMC.ParamByName('Email').AsString:=QGX.FieldByName('EMAIL').asstring;
          QBMC.ParamByName('Fonction').AsString:=QGX.FieldByName('FONCTION').asstring;
          QBMC.ParamByName('Code__btiers').AsString:=QGX.FieldByName('TIERS').asstring;

          if QGX.FieldByName('REFERANT').AsString='Oui' then
          	QBMC.ParamByName('Contact_referant').AsString:='Référant'
          else
            QBMC.ParamByName('Contact_referant').AsString:='';

          QBMC.ExecSQL;

          ProgressBar1.Position:=QGX.RecNo;
          Application.ProcessMessages;
          QGX.Next;
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
    existe:Boolean;
begin
    Label_Importation.Caption:='Tiers...';
    //


   QGX.Close;
   QGX.SQL.Clear;
   QGX.SQL.Text:=SQL_GX_TIERS;
   QGX.open;
   //------------------------------

   ModulesList := TStringList.Create;
   ProgressBar1.Position:=0;
   ProgressBar1.Max:=QGX.RecordCount;
   try

      while not(QGX.Eof) do
      begin
          QBMC.Close;
          QBMC.SQL.Clear;
          QBMC.SQL.Text:=SQL_BMC_TIERS;
          QBMC.ParamByName('Code__btiers').AsString:=QGX.FieldByName('T_TIERS').asstring;
          QBMC.Open;

          if QBMC.RecordCount=0 then
            existe := False
          else
            existe := true;

          QBMC.Close;
          QBMC.SQL.Text := '';

          if existe then
						QBMC.SQL.Text := SQL_BMC_TIERS_UPDATE
          else
          	QBMC.SQL.Text := SQL_BMC_TIERS_INSERT;

          QBMC.ParamByName('Code__btiers').AsString:=QGX.FieldByName('T_TIERS').asstring;
          QBMC.ParamByName('Vip').AsString:=QGX.FieldByName('VIP').asstring;
          QBMC.ParamByName('Dossier').AsString:=QGX.FieldByName('DOSSIER').asstring;
          QBMC.ParamByName('Raison__bSociale').AsString:=QGX.FieldByName('T_LIBELLE').asstring;
          QBMC.ParamByName('Adresse1').AsString:=QGX.FieldByName('T_ADRESSE1').asstring;
          QBMC.ParamByName('Code__bPostale').AsString:=QGX.FieldByName('T_CODEPOSTAL').asstring;
          QBMC.ParamByName('Ville').AsString:=QGX.FieldByName('T_VILLE').asstring;
          QBMC.ParamByName('Enseigne').AsString:=QGX.FieldByName('T_ENSEIGNE').asstring;
          QBMC.ParamByName('Telephone__bMagasin').AsString:=QGX.FieldByName('T_TELEPHONE').asstring;
          QBMC.ParamByName('Email__bmagasin').AsString:=QGX.FieldByName('T_EMAIL').asstring;
          QBMC.ParamByName('Secteur__bactivite').AsString:=QGX.FieldByName('SECTEUR').asstring;
          QBMC.ParamByName('ID__bCommercial').AsString:=QGX.FieldByName('REPRESENTANT').asstring;
          QBMC.ParamByName('Reseau').AsString:=QGX.FieldByName('RESEAU').asstring;
          QBMC.ParamByName('Version_Ginkoia').AsString:=QGX.FieldByName('NUM_VERSION').asstring;
          QBMC.ParamByName('Code_Adh').AsString:=QGX.FieldByName('CODEADH').asstring;

          Split(';',QGX.FieldByName('RPR_RPRLIBMUL0').asstring, ModulesList);
          if(ModulesList.Count>0) then
          begin
            for I := 0 to ModulesList.Count-1 do
              QBMC.ParamByName('Module').AsString:=QBMC.ParamByName('Module').AsString + ModulesList.Strings[i] + #13+#10;
          end
          else
              QBMC.ParamByName('Module').AsString:='';

          if QGX.FieldByName('T_DATEPROCLI').asDateTime>Now()-Fnbjour then
	          QBMC.ParamByName('Nouveau__bClient').AsString:='Nouveau'
          else
          	QBMC.ParamByName('Nouveau__bClient').AsString:='';

          If (QGX.FieldByName('T_ETATRISQUE').asstring='Oui') then
          	QBMC.ParamByName('Risque_client').AsString :='Rouge'
          else If (QGX.FieldByName('T_ETATRISQUE').asstring='Non') then
          	QBMC.ParamByName('Risque_client').AsString :='Vert'
          else
          	QBMC.ParamByName('Risque_client').AsString:='';

          QBMC.ExecSQL;

          ProgressBar1.Position:=QGX.RecNo;
          Application.ProcessMessages;
          QGX.Next;
      end;
   finally
     ModulesList.Free;
   end;
end;



procedure TFrm_Main.FormActivate(Sender: TObject);
begin
  if FAuto then
  begin
    Application.ProcessMessages;
    EIExecute;
    Application.Terminate;
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
      Caption:='GX2BMC :: NewClient ' + FormatDateTime('dd/mm/yyyy',Now()-FNBJOUR);

      Application.ShowMainForm:=true;
      ShowWindow(Application.Handle, SW_SHOW);
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
   ListOfStrings.QuoteChar := #0;
   ListOfStrings.StrictDelimiter := True;
   ListOfStrings.Delimiter     := Delimiter;
   ListOfStrings.DelimitedText := Str;
end;

end.
