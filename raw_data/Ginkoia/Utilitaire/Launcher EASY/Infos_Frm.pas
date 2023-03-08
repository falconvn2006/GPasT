unit Infos_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls,
  FireDAC.Phys.IBDef, FireDAC.Stan.Def,
  FireDAC.Phys.IBWrapper, FireDAC.Phys.IBBase, FireDAC.Phys, FireDAC.Stan.Intf,
  FireDAC.Phys.IB, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Pool, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, FireDAC.Phys.FBDef, FireDAC.Phys.FB, ShellAPi,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script, Upost,
  Vcl.Buttons, UWMI, Vcl.Grids, System.JSON, Vcl.Samples.Spin;

type
  TParamsInfos = record
    BR     : Integer;
    OPTIM  : Integer;
    OPTIM_CRON_HR : integer;
    OPTIM_STRING  : string;
    STOCK  : integer;
  end;
  TFrm_Infos = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    teNODEID: TEdit;
    teBASIDENT: TEdit;
    Label4: TLabel;
    tePLAGE: TEdit;
    Label5: TLabel;
    teGENERALID: TEdit;
    Label6: TLabel;
    teIBFILE: TEdit;
    Label7: TLabel;
    teSENDER: TEdit;
    Label8: TLabel;
    teGUID: TEdit;
    Button1: TButton;
    tyVersion: TEdit;
    Label10: TLabel;
    teVERSION: TEdit;
    PageControl1: TPageControl;
    tsDB: TTabSheet;
    TabSheet2: TTabSheet;
    Label11: TLabel;
    BFERMER: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    teEASYSERVICE: TEdit;
    Label12: TLabel;
    teEASYPATH: TEdit;
    Label13: TLabel;
    teEASYFileProperties: TEdit;
    Label14: TLabel;
    teRegsitrationURL: TEdit;
    Label15: TLabel;
    teBACKRES: TEdit;
    Bevel1: TBevel;
    Label16: TLabel;
    teNOMPOURNOUS: TEdit;
    Label17: TLabel;
    teNBTRGSYM: TEdit;
    Label18: TLabel;
    Label3: TLabel;
    teGROUPE: TEdit;
    Label9: TLabel;
    teEASY_Grp_File: TEdit;
    Param: TTabSheet;
    GroupBox1: TGroupBox;
    cbOptim: TCheckBox;
    seOPTIM: TSpinEdit;
    Label19: TLabel;
    Label20: TLabel;
    GroupBox2: TGroupBox;
    cbBR: TCheckBox;
    GroupBox3: TGroupBox;
    cbRecalcStock: TCheckBox;
    cbSWEEP: TCheckBox;
    cbIDXGINKOIA: TCheckBox;
    cbPREPURGESYMDS: TCheckBox;
    cbIDXSYMDS: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BFERMERClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbBRClick(Sender: TObject);
  private
    FIBFile: TFileName;
    FBAS_ID : integer;
    SE_EASY: TEASYInfos;
    FGinkoiaPath: String;
    FParamsInfos : TParamsInfos;
    procedure ValideParams();
    procedure SetIBFile(aValue: TFileName);
    procedure GetDBInfos();



    function UPSERT_PARAM(aCODE,aType:integer;aINFO:string;aINTEGER:Integer;aString:string;aFLOAT:double):boolean;
    // procedure GetNewYellis();
    // procedure ListProgrammes();
    { Déclarations privées }
  public
    property IBFile: TFileName read FIBFile write SetIBFile;
    { Déclarations publiques }
  end;

var
  Frm_Infos: TFrm_Infos;

implementation

{$R *.dfm}

USes uDataMod, uMainForm;

{
  procedure TFrm_Infos.ListProgrammes();
  Var  ListItem: TListItem;
  Rec: TSearchRec;
  begin
  ListView1.Items.BeginUpdate;
  ListView1.Clear;
  if FindFirst(FGinkoiaPath + '\*.exe', faAnyFile, Rec) = 0 then try
  repeat
  if (Rec.Name = '.') or (Rec.Name = '..') then
  continue;
  if (Rec.Attr and faVolumeID) = faVolumeID then
  continue;
  if (Rec.Attr and faHidden) = faHidden then
  continue;
  if (Rec.Attr and faDirectory) = faDirectory then
  Continue;

  ListItem := ListView1.Items.Add;
  ListItem.Caption := Rec.Name;
  ListItem.SubItems.Add(FileVersion(FGinkoiaPath + '\' + Rec.Name));
  Application.ProcessMessages;
  until FindNext(Rec) <> 0;
  finally
  FindClose(Rec);
  end;
  ListView1.Items.EndUpdate;
  end;
}

procedure TFrm_Infos.SetIBFile(aValue: TFileName);
begin
  FIBFile := aValue;
  teIBFILE.Text := FIBFile;
  GetDBInfos();
end;

procedure TFrm_Infos.BFERMERClick(Sender: TObject);
begin
  ValideParams;
  Close;
end;

procedure TFrm_Infos.BitBtn1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'Open', PWideChar(Format('http://localhost:%d/app', [SE_EASY.http])), nil, nil, SW_SHOWNORMAL);
end;

procedure TFrm_Infos.BitBtn2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'Open', PWideChar(SE_EASY.Directory + '\bin\symcc.bat'), nil, nil, SW_HIDE);
end;

procedure TFrm_Infos.Button1Click(Sender: TObject);
begin
  // GetNewYellis();
  tyVersion.Text := YellisConnexion.GetVersion(teGUID.Text);
end;


procedure TFrm_Infos.cbBRClick(Sender: TObject);
begin
  //
end;

procedure TFrm_Infos.ValideParams;
var vChaineOPTIM:string;
begin
   try
     vChaineOPTIM := '';
     if cbSWEEP.Checked
       then vChaineOPTIM := vChaineOPTIM+'1'
       else vChaineOPTIM := vChaineOPTIM+'0';

     if cbIDXGINKOIA.Checked
       then vChaineOPTIM := vChaineOPTIM+'1'
       else vChaineOPTIM := vChaineOPTIM+'0';

     if cbPREPURGESYMDS.Checked
       then vChaineOPTIM := vChaineOPTIM+'1'
       else vChaineOPTIM := vChaineOPTIM+'0';

     if cbIDXSYMDS.Checked
       then vChaineOPTIM := vChaineOPTIM+'1'
       else vChaineOPTIM := vChaineOPTIM+'0';

     // Si on a fait des Modifs Seulement....
     if (FParamsInfos.BR=-1) or                     // Si on pas de valeur
        ((FParamsInfos.BR=0) and (cbBR.Checked)) or     // Si différent
        ((FParamsInfos.BR=1) and not(cbBR.Checked))   // Si Différent
       then
         begin
           if cbBR.Checked
             then UPSERT_PARAM(5,80,'Tuile du B/R',1,'',0)
             else UPSERT_PARAM(5,80,'Tuile du B/R',0,'',0);
         end;
    if (FParamsInfos.OPTIM=-1) or
        (FParamsInfos.OPTIM_CRON_HR=-1)  or
        ((FParamsInfos.OPTIM=0) and (cbOptim.Checked)) or
        ((FParamsInfos.OPTIM=1) and not(cbOptim.Checked)) or
        (FParamsInfos.OPTIM_CRON_HR<>seOPTIM.Value) or
        (FParamsInfos.OPTIM_STRING<>vChaineOPTIM)
      then
        begin
           if cbOptim.Checked
              then UPSERT_PARAM(6,80,'Tuile de l''optimisation',1,vChaineOPTIM,seOPTIM.Value)
              else UPSERT_PARAM(6,80,'Tuile de l''optimisation',0,vChaineOPTIM,seOPTIM.Value);
        end;

     if (FParamsInfos.Stock=-1) or                     // Si on pas de valeur
        ((FParamsInfos.Stock=0) and (cbRecalcStock.Checked)) or     // Si différent
        ((FParamsInfos.Stock=1) and not(cbRecalcStock.Checked))   // Si Différent
       then
         begin
            if cbRecalcStock.Checked
              then UPSERT_PARAM(7,80,'Tuile du recalcul du stock',1,'',0)
              else UPSERT_PARAM(7,80,'Tuile du recalcul du stock',0,'',0);
         end;

   Except on E:Exception do
      begin
         MessageDlg(E.Message,  mtError, [mbOK], 0);
         raise;
      end;
   end;
end;

function TFrm_Infos.UPSERT_PARAM(aCODE,aType:integer;aINFO:string;aINTEGER:Integer;aString:string;aFLOAT:double):boolean;
var vQuerySelect : TFDQuery;
    vQueryInsert : TFDQuery;
    vProc  : TFDStoredProc;
    vPRM_ID : integer;
    vDoInsert : boolean;
    vDoUpdate : boolean;
begin
  if IBFile = '' then exit;
  vPRM_ID := 0;
  vQuerySelect := TFDQuery.Create(nil);
  vQueryInsert := TFDQuery.Create(nil);
  vProc        := TFDStoredProc.Create(nil);
  vDoUpdate    := false;
  vDoInsert    := false;

  try
    try
      // DataMod.FDcon.Params.Database := IBFile;
      vQuerySelect.Connection := DataMod.FDcon;
      vQueryInsert.Connection := DataMod.FDcon;
      // vQuerySelect.Transaction := DataMod.FDtrans;

      vProc.Connection := DataMod.FDCon;
      // vProc.Transaction := DataMod.FDtrans;

      vQuerySelect.Close;
      vQuerySelect.SQL.Clear();
      vQuerySelect.SQL.Add('SELECT PRM_ID FROM GENPARAM JOIN K ON K_ID=PRM_ID AND K_ENABLED=1 WHERE PRM_TYPE=:PRMTYPE AND PRM_CODE=:PRMCODE AND PRM_POS=:PRMBASID');
      vQuerySelect.ParamByName('PRMTYPE').AsInteger := aTYPE;
      vQuerySelect.ParamByName('PRMCODE').AsInteger := aCODE;
      vQuerySelect.ParamByName('PRMBASID').AsInteger := FBAS_ID;
      vQuerySelect.Open();
      if vQuerySelect.eof
        then vDoInsert := true
        else
          begin
              vDoUpdate := true;
              vPRM_ID   := vQuerySelect.FieldByName('PRM_ID').AsInteger;
          end;
      vQuerySelect.Close;

      {INSERT}
      if vDoInsert then
        begin
          vProc.StoredProcName:='PR_NEWK';
          vProc.Prepare();
          vProc.ParamByName('TABLENAME').AsString := UpperCase('GENPARAM');
          vProc.Open();
          vPRM_ID := vProc.FieldByName('ID').AsInteger;
          //*********************************************************************/
          vQueryInsert.Close();
          vQueryInsert.SQL.Add('');
          vQueryInsert.Close;
          vQueryInsert.SQL.Clear;
          vQueryInsert.SQL.Add('INSERT INTO GENPARAM (PRM_ID, PRM_CODE, PRM_INTEGER, PRM_FLOAT, PRM_STRING, PRM_TYPE, PRM_MAGID, PRM_INFO, PRM_POS) ');
          vQueryInsert.SQL.Add(' VALUES (:PRMID, :PRMCODE, :PRMINTEGER, :PRMFLOAT, :PRMSTRING, :PRMTYPE, :PRMMAGID, :PRMINFO, :PRMPOS)              ');
          try
            vQueryInsert.ParamByName('PRMID').AsInteger      := vPRM_ID;
            vQueryInsert.ParamByName('PRMCODE').AsInteger    := aCODE;
            vQueryInsert.ParamByName('PRMINTEGER').asinteger := aINTEGER;
            vQueryInsert.ParamByName('PRMTYPE').AsInteger    := aTYPE;
            vQueryInsert.ParamByName('PRMSTRING').AsString   := aString;
            vQueryInsert.ParamByName('PRMINFO').AsString     := aINFO;
            vQueryInsert.ParamByName('PRMFLOAT').AsFloat     := aFLOAT;
            vQueryInsert.ParamByName('PRMMAGID').asinteger   := 0;
            vQueryInsert.ParamByName('PRMPOS').Asinteger     := FBAS_ID;
            vQueryInsert.ExecSQL;
          finally

          end;
        end;

      {UPDATE}
      if vDoUpdate then
        begin
          vProc.StoredProcName:='PR_UPDATEK';
          vProc.Prepare();
          vProc.ParamByName('K_ID').Asinteger  := vPRM_ID;
          vProc.ParamByName('SUPRESSION').Asinteger := 0;
          vProc.ExecProc();
          vQueryInsert.Close;
          vQueryInsert.SQL.Clear;
          vQueryInsert.SQL.Add('UPDATE GENPARAM SET PRM_INTEGER=:PRMINTEGER, PRM_FLOAT=:PRMFLOAT, PRM_STRING=:PRMSTRING ');
          vQueryInsert.SQL.Add('  WHERE PRM_ID=:PRMID ');
          try
            vQueryInsert.ParamByName('PRMINTEGER').asinteger := aINTEGER;
            vQueryInsert.ParamByName('PRMSTRING').AsString   := aString;
            vQueryInsert.ParamByName('PRMFLOAT').AsFloat     := aFLOAT;
            vQueryInsert.ParamByName('PRMID').asinteger      := vPRM_ID;
            vQueryInsert.ExecSQL;
          finally
          end;
        end;
    except
      On E: EIBNativeException Do
      begin
        // do raise;
        // FShutdown :=true;

      end;
    end;
  Finally
    vQuerySelect.DisposeOf;
    vQueryInsert.DisposeOf;
    // DataMod.FDcon.Connected := false;
  end;
end;

{
  procedure TFrm_Infos.GetNewYellis();
  var LJsonObj  : TJSONObject;
  vJson     : string;
  begin
  vJson := YellisConnexion.GetVersion(teGUID.Text);
  tyVersion.Text := '';
  tyRevision.Text := '';
  try
  LJsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(vjson),0) as TJSONObject;
  try
  if LJsonObj<>nil then
  begin
  tyVersion.Text  := (LJsonObj.Get('version').JsonValue).Value;
  If not(LJsonObj.Get('revision').JsonValue Is TJSONNull)
  then tyVersion.Text := (LJsonObj.Get('revision').JsonValue).Value;
  end
  finally
  LJsonObj.DisposeOf;
  end;
  Except
  //
  end;
  end;
}

procedure TFrm_Infos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Frm_Launcher.LOCKINFO := false;
  Frm_Launcher.tmDBTimer(Self);
  Action := caFree;
end;

procedure TFrm_Infos.FormCreate(Sender: TObject);
var i:integer;
    vName : string;
    vGrp : string;
begin
  Screen.Cursor := crHourGlass;
  // par defaut on ne sait pas
  FParamsInfos.BR    := -1;
  FParamsInfos.OPTIM := -1;
  FParamsInfos.OPTIM_CRON_HR := -1;
  FParamsInfos.OPTIM_STRING := '1000';
  FParamsInfos.STOCK := -1;

  SE_EASY := WMI_GetServicesEASY();
  // ------------------------------
  teEASYSERVICE.Text := SE_EASY.ServiceName;
  teEASYPATH.Text := SE_EASY.Directory;

  teEASYFileProperties.Text := SE_EASY.PropertiesFile;
  teRegsitrationURL.Text := SE_EASY.registration_url;

  //---------------------------------
  vName := ExtractFileName(SE_EASY.PropertiesFile);
  //---------------------------------
  i := Pos('-',vName);
  teEASY_Grp_File.Text := Copy(vName,1,i-1);

  FGinkoiaPath := ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(VGSE.Base0)));
  // ListProgrammes();
  Screen.Cursor := crDefault;

  cbBR.Checked          := true;
  cbOptim.Checked       := false;
  cbSWEEP.Checked       := true;
  cbIDXGINKOIA.Checked  := false;
  cbPREPURGESYMDS.Checked  := false;
  cbIDXSYMDS.Checked       := false;
  seOPTIM.Value         := 24;
  cbRecalcStock.Checked := false;



end;





procedure TFrm_Infos.GetDBInfos();
var vQuery: TFDQuery;

begin
  if IBFile = '' then
    exit;
  FBAS_ID := 0;
  vQuery := TFDQuery.Create(nil);
  try
    try
      DataMod.FDcon.Params.Database := IBFile;
      vQuery.Connection := DataMod.FDcon;
      vQuery.Transaction := DataMod.FDtrans;
      vQuery.Transaction.Options.ReadOnly := true;
      vQuery.Close;

      // Recup du BAS_ID (on en a besoin pour GENHISTOEVT)
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT BAS_ID, BAS_IDENT, BAS_NOM, BAS_PLAGE, BAS_SENDER, BAS_NOMPOURNOUS, BAS_GUID FROM GENPARAMBASE        ');
      vQuery.SQL.Add(' JOIN GENBASES ON BAS_IDENT=PAR_STRING ');
      vQuery.SQL.Add(' JOIN K ON K_ID=BAS_ID AND K_ENABLED=1 ');
      vQuery.SQL.Add('WHERE PAR_NOM=''IDGENERATEUR''         ');
      vQuery.Open();
      If (vQuery.RecordCount = 1) then
      begin
        FBAS_ID := vQuery.FieldByName('BAS_ID').Asinteger;
        teBASIDENT.Text := vQuery.FieldByName('BAS_IDENT').Asstring;
        teSENDER.Text := vQuery.FieldByName('BAS_SENDER').Asstring;
        teGUID.Text := vQuery.FieldByName('BAS_GUID').Asstring;
        tePLAGE.Text := vQuery.FieldByName('BAS_PLAGE').Asstring;
        teNOMPOURNOUS.Text := vQuery.FieldByName('BAS_NOMPOURNOUS').Asstring;
      end;

      vQuery.Close;
      // Recup du BAS_ID (on en a besoin pour GENHISTOEVT)
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT * FROM GENVERSION        ');
      vQuery.SQL.Add('ORDER BY VER_DATE DESC ROWS 1   ');
      vQuery.Open();
      If (vQuery.RecordCount = 1) then
      begin
        teVERSION.Text := vQuery.FieldByName('VER_VERSION').Asstring;
      end;

      tyVersion.Text := YellisConnexion.GetVersion(teGUID.Text);
      // GetNewYellis();

      // Ou est GENERAL_ID
      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT GEN_ID(GENERAL_ID,0) FROM RDB$DATABASE ');
      vQuery.Open();
      If (vQuery.RecordCount = 1) then
      begin
        teGENERALID.Text := FormatFloat(',0', vQuery.Fields[0].AsFloat);
        // AnalysePlage(vBASPLAGE,vQuery.Fields[0].asinteger);
      end;

      // Recup de l'Horaire du Backup (attention ce n'est pas LAU_HEURE1 mais LAU_BACKTIME
      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT * FROM GenLaunch ');
      vQuery.SQL.Add('Join k on (K_ID = LAU_ID and K_Enabled=1) ');
      vQuery.SQL.Add('  WHERE LAU_BASID=:BASID');
      vQuery.ParamByName('BASID').Asinteger := FBAS_ID;
      vQuery.Open();
      If (vQuery.RecordCount = 1) then
      begin
        teBACKRES.Text := '23:00';
        If (vQuery.FieldByName('LAU_BACK').Asinteger = 1) then
        begin
          teBACKRES.Text := FormatDateTime('HH:mm', vQuery.FieldByName('LAU_BACKTIME').AsDateTime);
        end;
      end;

      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT COUNT(*) FROM RDB$TRIGGERS WHERE RDB$SYSTEM_FLAG=0 AND RDB$TRIGGER_NAME LIKE ''SYM_%'' AND RDB$RELATION_NAME NOT LIKE ''SYM_%''');
      vQuery.Open();
      If (vQuery.RecordCount = 1) then
      begin
        teNBTRGSYM.Text := vQuery.Fields[0].Asstring;
      end;

      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT * FROM GENPARAM JOIN K ON K_ID=PRM_ID AND K_ENABLED=1 WHERE PRM_TYPE=80 AND PRM_CODE=5 AND PRM_POS=:BASID');
      vQuery.ParamByName('BASID').AsInteger := FBAS_ID;
      vQuery.Open();
      If (vQuery.RecordCount = 1) then
        begin
          FParamsInfos.BR := vQuery.FieldByName('PRM_INTEGER').AsInteger;
          cbBR.Checked := vQuery.FieldByName('PRM_INTEGER').AsInteger=1;
        end;

      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT * FROM GENPARAM JOIN K ON K_ID=PRM_ID AND K_ENABLED=1 WHERE PRM_TYPE=80 AND PRM_CODE=6 AND PRM_POS=:BASID');
      vQuery.ParamByName('BASID').AsInteger := FBAS_ID;
      vQuery.Open();
      If (vQuery.RecordCount = 1) then
        begin
          FParamsInfos.OPTIM := vQuery.FieldByName('PRM_INTEGER').AsInteger;
          FParamsInfos.OPTIM_CRON_HR := vQuery.FieldByName('PRM_FLOAT').AsInteger;
          FParamsInfos.OPTIM_STRING := vQuery.FieldByName('PRM_STRING').Asstring;
          cbOptim.Checked := vQuery.FieldByName('PRM_INTEGER').AsInteger=1;
          seOPTIM.Value   := vQuery.FieldByName('PRM_FLOAT').AsInteger;
          try
            cbSWEEP.Checked         := FParamsInfos.OPTIM_STRING[1]='1';
            cbIDXGINKOIA.Checked    := FParamsInfos.OPTIM_STRING[2]='1';
            cbPREPURGESYMDS.Checked := FParamsInfos.OPTIM_STRING[3]='1';
            cbIDXSYMDS.Checked      := FParamsInfos.OPTIM_STRING[4]='1';
          except
            // C'est probablement parce que la chaine est "vide" ou mal formaté
          end;



        end;

      vQuery.Close;
      vQuery.SQL.Clear();
      vQuery.SQL.Add('SELECT * FROM GENPARAM JOIN K ON K_ID=PRM_ID AND K_ENABLED=1 WHERE PRM_TYPE=80 AND PRM_CODE=7 AND PRM_POS=:BASID');
      vQuery.ParamByName('BASID').AsInteger := FBAS_ID;
      vQuery.Open();
      If (vQuery.RecordCount = 1) then
        begin
          FParamsInfos.STOCK    := vQuery.FieldByName('PRM_INTEGER').AsInteger;
          cbRecalcStock.Checked := vQuery.FieldByName('PRM_INTEGER').AsInteger=1;
        end;

      try
        vQuery.Close;
        vQuery.SQL.Clear();
        vQuery.SQL.Add('SELECT * FROM SYM_NODE N ');
        vQuery.SQL.Add(' JOIN SYM_NODE_IDENTITY I ON I.NODE_ID=N.NODE_ID ');
        vQuery.Open();
        If (vQuery.RecordCount = 1) then
        begin
          teGROUPE.Text := vQuery.FieldByName('NODE_GROUP_ID').Asstring;
          teNODEID.Text := vQuery.FieldByName('NODE_ID').Asstring;
        end;
      except
        teNODEID.Text := 'EASY n''est pas installé sur la base';
      end;

    except
      On E: EIBNativeException Do
      begin
        // do raise;
        // FShutdown :=true;

      end;
    end;
  Finally
    vQuery.Free;
    DataMod.FDcon.Connected := false;
  end;
end;

end.
