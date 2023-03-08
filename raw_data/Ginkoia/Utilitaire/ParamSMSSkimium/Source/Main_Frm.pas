unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, DB, dxmdaset, ExtCtrls,
  IB_Components, IBODataset;

type
  TFrm_Main = class(TForm)
    Lab_FaireEn1: TLabel;
    Nbt_Base: TBitBtn;
    Lab_FaireEn2: TLabel;
    Nbt_sms: TBitBtn;
    Lab_FaireEn3: TLabel;
    Nbt_affecter: TBitBtn;
    MemD_SMS: TdxMemData;
    DBGrid1: TDBGrid;
    Nbt_Exporter: TBitBtn;
    Nbt_Quitter: TBitBtn;
    OD_Load: TOpenDialog;
    MemD_SMSBase: TStringField;
    MemD_SMSetat: TIntegerField;
    Ds_SMS: TDataSource;
    MemD_SMSCodeAdh: TIntegerField;
    MemD_SMSCodeAdhImp: TStringField;
    Shape1: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    MemD_SMSNomSoc: TStringField;
    MemD_SMSNom: TStringField;
    MemD_SMSPrenom: TStringField;
    MemD_SMSEMail: TStringField;
    MemD_SMStel: TStringField;
    MemD_SMSRef: TStringField;
    MemD_SMSPass: TStringField;
    Shape7: TShape;
    Label7: TLabel;
    Database: TIB_Connection;
    Que_Tmp: TIBOQuery;
    MemD_SMSErreur: TStringField;
    SD_Save: TSaveDialog;
    procedure Nbt_BaseClick(Sender: TObject);
    procedure Nbt_smsClick(Sender: TObject);
    procedure Nbt_affecterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Nbt_ExporterClick(Sender: TObject);
  private
    { Déclarations privées }
    function DoParametre(AAdh: integer; ABase, AAccount, ALogin, APass: string; var AError: string): integer;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

uses ExportResult_Frm;

{$R *.dfm}

// Etat
// 1 Base sans compte sms associé
// 2 Compte sms sans base associé
// 3 Paramétrage compte sms invalide
// 4 Chemin de base non trouvé
// 5 attente affectation
// 6 paramétrage échoué
// 7 paramétrage réussi

function GetCsvValue(ALigne: string; APosition: integer): string;
var
  i: integer;
begin
  Result := ALigne;
  for i := 1 to APosition-1 do
  begin
    if Pos(';', Result)>0 then
      Result := Copy(Result, Pos(';', Result)+1, Length(Result))
    else
      Result := '';
  end;
  if Pos(';', Result)>0 then
    result := Copy(Result, 1, Pos(';', Result)-1);
end;

procedure TFrm_Main.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  chBrush: TColor;
  chFont: TColor;
  savBrush: TColor;
  savFont: TColor;
begin
  with TDBGrid(Sender).Canvas do
  begin
    savBrush := Brush.Color;
    savFont := Font.Color;
    chBrush := savBrush;
    chFont := savFont;
    if (TDBGrid(Sender).DataSource<>nil)
         and (TDBGrid(Sender).DataSource.DataSet.Active)
         and (TDBGrid(Sender).DataSource.DataSet.RecordCount>0) then
    begin
      // Etat
      // 1 Base sans compte sms associé
      // 2 Compte sms sans base associé
      // 3 Paramétrage compte sms invalide
      // 4 Chemin de base non trouvé
      // 5 attente affectation
      // 6 paramétrage échoué
      // 7 paramétrage réussi
      if (gdSelected in State) or (gdFocused in State) then
      begin
        chFont := clWhite;
        case TDBGrid(Sender).DataSource.DataSet.FieldByName('Etat').AsInteger of
          1: chBrush := rgb(0, 48, 96);        // bleu
          2: chBrush := rgb(96, 0, 48);        // violet
          3: chBrush := rgb(96, 48, 0);        // orange
          4: chBrush := rgb(96, 96, 0);        // jaune
          5: chBrush := rgb(0, 0, 96);         // bleu marine
          6: chBrush := rgb(96, 0, 0);         // rouge
          7: chBrush := rgb(0, 96, 0);         // vert
        end;
      end
      else begin
        chFont := clBlack;
        case TDBGrid(Sender).DataSource.DataSet.FieldByName('Etat').AsInteger of
          1: chBrush := rgb(64, 160, 255);      // bleu
          2: chBrush := rgb(255, 64, 160);      // violet
          3: chBrush := rgb(255, 160, 64);      // orange
          4: chBrush := rgb(255, 255, 64);      // jaune
          5: chBrush := rgb(96, 96, 255);       // bleu marine
          6: chBrush := rgb(255, 64, 64);       // rouge
          7: chBrush := rgb(64, 255, 64);       // vert
        end;
      end;
    end;

    Brush.Color := chBrush;
    Font.Color := chFont;
    TDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
    Brush.Color := savBrush;
    Font.Color := savFont;
  end;
end;

function TFrm_Main.DoParametre(AAdh: integer; ABase, AAccount, ALogin, APass: string; var AError: string): integer;
var
  iMagID: integer;
  iPrmID: integer;
  QueryDiv: TIBOQuery;
  bFaire: boolean;
begin
  result := 0;
  AError := '';
  iMagId := 0;
  iPrmID := 0;
  try
    try
      // connexion
      AError := 'Impossible de se connecter à la base de donnée';
      result := 1;
      Database.DatabaseName := ABase;
      Database.Connect;

      // recherche du MagID
      AError := 'MagID non trouvé';
      result := 0;
      Que_Tmp.SQL.Clear;
      Que_Tmp.SQL.Add('select idm_magid from locmailidentmag');
      Que_Tmp.SQL.Add('join gentypemail b on idm_mtyid=mty_id and mty_nom='+QuotedStr('RESERVATION SKIMIUM'));
      Que_Tmp.SQL.Add('where idm_presta= '+QuotedStr(inttostr(AAdh)));
      Que_Tmp.Open;
      Que_Tmp.First;
      if not(Que_Tmp.Eof) then
        iMagId := Que_Tmp.FieldByName('idm_magid').AsInteger;
      Que_Tmp.Close;

      if iMagId>0 then
      begin
        bFaire := true;
        AError := 'Paramètre dans GenParam non trouvé';
        result := 0;
        Que_Tmp.SQL.Clear;
        Que_Tmp.SQL.Add('select prm_id, prm_integer from GenParam');
        Que_Tmp.SQL.Add('  join K on (K_id=prm_id and K_enabled=1)');
        Que_Tmp.SQL.Add('where prm_code=50 and prm_type=3');
        Que_Tmp.SQL.Add('and prm_magid='+inttostr(iMagId));
        Que_Tmp.Open;
        Que_Tmp.First;
        if not(Que_Tmp.Eof) then
        begin
          iPrmID := Que_Tmp.FieldByName('prm_id').AsInteger;
          bFaire := (Que_Tmp.FieldByName('prm_integer').AsString<>'1');
        end;
        Que_Tmp.Close;

        if iPrmID>0 then
        begin
          if bFaire then
          begin
            AError := 'Impossible mettre à jour les paramètres SMS';
            result := 0;
            Que_Tmp.SQL.Clear;
            Que_Tmp.SQL.Add('update genparam set');
            Que_Tmp.SQL.Add('PRM_INTEGER=1,');
            Que_Tmp.SQL.Add('PRM_INFO='+QuotedStr(AAccount)+',');
            Que_Tmp.SQL.Add('PRM_STRING='+QuotedStr(ALogin+';'+APass));
            Que_Tmp.SQL.Add('where PRM_ID='+inttostr(iPrmID));
            Que_Tmp.ExecSQL;
            Que_Tmp.Close;

            Que_Tmp.SQL.Clear;
            Que_Tmp.SQL.Add('execute procedure PR_UPDATEK('+inttostr(iPrmID)+', 0)');
            Que_Tmp.ExecSQL;
            Que_Tmp.Close;
            result := 2; //tout est ok
            AError := '';
          end
          else
          begin
            result := 2; // déjà fait = ok
            AError := '';
          end;
        end;

      end;

    except
    end;
  finally
    Que_Tmp.Close;
    Database.Disconnect;
  end;
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
var
  sTmp: string;
begin
  sTmp := ExtractFilePath(ParamStr(0));
  if sTmp[Length(sTmp)]<>'\' then
    sTmp := sTmp+'\';
  OD_Load.InitialDir := sTmp;
end;

procedure TFrm_Main.Nbt_affecterClick(Sender: TObject);
var
  i: integer;
  Retour: integer;
  sError: string;
begin

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    MemD_SMS.First;
    While not(MemD_SMS.Eof) do
    begin
      if MemD_SMS.FieldByName('etat').AsInteger=5 then
      begin
        Retour := DoParametre(MemD_SMS.FieldByName('CodeAdh').AsInteger,
                           MemD_SMS.FieldByName('Base').AsString,
                           MemD_SMS.FieldByName('Ref').AsString,
                           MemD_SMS.FieldByName('EMail').AsString,
                           MemD_SMS.FieldByName('Pass').AsString,
                           sError);
        MemD_SMS.Edit;
        case Retour of
          0:
          begin
            MemD_SMS.FieldByName('etat').AsInteger := 6;
            MemD_SMS.FieldByName('Erreur').AsString := sError;
          end;
          1:
          begin
            MemD_SMS.FieldByName('etat').AsInteger := 4;
            MemD_SMS.FieldByName('Erreur').AsString := sError;
          end;
          2:
          begin
            MemD_SMS.FieldByName('etat').AsInteger := 7;
          end;
        end;
        MemD_SMS.Post;
      end;
      MemD_SMS.Next;
    end;
  finally
    Application.ProcessMessages;
  Screen.Cursor := crDefault;
  end;

  // etape suivante
  Nbt_exporter.Enabled := true;
end;

procedure TFrm_Main.Nbt_BaseClick(Sender: TObject);
var
  LstTmp: TStringList;
  sFic: string;
  i: integer;
  sCodeAdh: string;
begin
  OD_Load.Title := 'Charge la config des bases Skimium (Skimium base Ginkoia.csv)';
  if not(OD_Load.Execute) then
    exit;

  sFic := OD_Load.FileName;
  LstTmp := TStringList.Create;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    LstTmp.LoadFromFile(sFic);
    MemD_SMS.Close;
    MemD_SMS.Open;

    // Etat
    // 1 Base sans compte sms associé
    // 2 Compte sms sans base associé
    // 3 Paramétrage compte sms invalide
    // 4 Chemin de base non trouvé
    // 5 attente affectation
    // 6 paramétrage échoué
    // 7 paramétrage réussi
    for i := 2 to LstTmp.Count do
    begin
      if Trim(LstTmp[i-1])<>'' then
      begin
        MemD_SMS.Append;
        sCodeAdh := GetCsvValue(LstTmp[i-1], 2);
        MemD_SMS.FieldByName('CodeAdh').AsInteger := StrToIntDef(sCodeAdh, 0);
        MemD_SMS.FieldByName('CodeAdhImp').AsString := sCodeAdh;
        MemD_SMS.FieldByName('Base').AsString := GetCsvValue(LstTmp[i-1], 1);
        MemD_SMS.FieldByName('etat').AsInteger := 1;
        MemD_SMS.Post;
      end;
    end;
  finally
    FreeAndNil(LstTmp);
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;

  // etape suivante
  Lab_FaireEn2.Enabled := true;
  Nbt_sms.Enabled := true;
end;

procedure TFrm_Main.Nbt_ExporterClick(Sender: TObject);
var
  bEtat1: boolean;
  bEtat2: boolean;
  bEtat3: boolean;
  bEtat4: boolean;
  bEtat6: boolean;
  bEtat7: boolean;
  LstTmp: TStringList;
  sFic: string;
  sErreur: string;
begin
  if Not(SD_Save.Execute) then
    exit;

  sFic := SD_Save.FileName;

  Frm_ExportResult := TFrm_ExportResult.Create(Self);
  try
    if Frm_ExportResult.ShowModal<>mrok then
      exit;

    bEtat1 := Frm_ExportResult.Chk_Etat1.Checked;
    bEtat2 := Frm_ExportResult.Chk_Etat2.Checked;
    bEtat3 := Frm_ExportResult.Chk_Etat3.Checked;
    bEtat4 := Frm_ExportResult.Chk_Etat4.Checked;
    bEtat6 := Frm_ExportResult.Chk_Etat6.Checked;
    bEtat7 := Frm_ExportResult.Chk_Etat7.Checked;

    LstTmp := TStringList.Create;
    try
      LstTmp.Add('CodeAdh;Base;NomSoc;NomConact;PrenomContact;Tel;EMail;Ref;Pass;Erreur');
      MemD_SMS.First;
      while not(MemD_SMS.Eof) do
      begin
        case MemD_SMS.FieldByName('etat').AsInteger of
          1:
          begin
            if bEtat1 then
            begin
              sErreur := 'Base sans compte sms associé';
              LstTmp.Add(MemD_SMS.FieldByName('CodeAdhImp').AsString+';'+
                         MemD_SMS.FieldByName('Base').AsString+';'+
                         MemD_SMS.FieldByName('NomSoc').AsString+';'+
                         MemD_SMS.FieldByName('Nom').AsString+';'+
                         MemD_SMS.FieldByName('Prenom').AsString+';'+
                         MemD_SMS.FieldByName('Tel').AsString+';'+
                         MemD_SMS.FieldByName('EMail').AsString+';'+
                         MemD_SMS.FieldByName('Ref').AsString+';'+
                         MemD_SMS.FieldByName('Pass').AsString+';'+
                         sErreur);
            end;
          end;
          2:
          begin
            if bEtat2 then
            begin
              sErreur := 'Compte sms sans base associé';
              LstTmp.Add(MemD_SMS.FieldByName('CodeAdhImp').AsString+';'+
                         MemD_SMS.FieldByName('Base').AsString+';'+
                         MemD_SMS.FieldByName('NomSoc').AsString+';'+
                         MemD_SMS.FieldByName('Nom').AsString+';'+
                         MemD_SMS.FieldByName('Prenom').AsString+';'+
                         MemD_SMS.FieldByName('Tel').AsString+';'+
                         MemD_SMS.FieldByName('EMail').AsString+';'+
                         MemD_SMS.FieldByName('Ref').AsString+';'+
                         MemD_SMS.FieldByName('Pass').AsString+';'+
                         sErreur);
            end;
          end;
          3:
          begin
            if bEtat3 then
            begin
              sErreur := 'Paramétrage compte sms invalide';
              LstTmp.Add(MemD_SMS.FieldByName('CodeAdhImp').AsString+';'+
                         MemD_SMS.FieldByName('Base').AsString+';'+
                         MemD_SMS.FieldByName('NomSoc').AsString+';'+
                         MemD_SMS.FieldByName('Nom').AsString+';'+
                         MemD_SMS.FieldByName('Prenom').AsString+';'+
                         MemD_SMS.FieldByName('Tel').AsString+';'+
                         MemD_SMS.FieldByName('EMail').AsString+';'+
                         MemD_SMS.FieldByName('Ref').AsString+';'+
                         MemD_SMS.FieldByName('Pass').AsString+';'+
                         sErreur);
            end;
          end;
          4:
          begin
            if bEtat4 then
            begin
              sErreur := 'Chemin de base non trouvé';
              LstTmp.Add(MemD_SMS.FieldByName('CodeAdhImp').AsString+';'+
                         MemD_SMS.FieldByName('Base').AsString+';'+
                         MemD_SMS.FieldByName('NomSoc').AsString+';'+
                         MemD_SMS.FieldByName('Nom').AsString+';'+
                         MemD_SMS.FieldByName('Prenom').AsString+';'+
                         MemD_SMS.FieldByName('Tel').AsString+';'+
                         MemD_SMS.FieldByName('EMail').AsString+';'+
                         MemD_SMS.FieldByName('Ref').AsString+';'+
                         MemD_SMS.FieldByName('Pass').AsString+';'+
                         sErreur);
            end;
          end;
          6:
          begin
            if bEtat6 then
            begin
              sErreur := MemD_SMS.FieldByName('Erreur').AsString;
              LstTmp.Add(MemD_SMS.FieldByName('CodeAdhImp').AsString+';'+
                         MemD_SMS.FieldByName('Base').AsString+';'+
                         MemD_SMS.FieldByName('NomSoc').AsString+';'+
                         MemD_SMS.FieldByName('Nom').AsString+';'+
                         MemD_SMS.FieldByName('Prenom').AsString+';'+
                         MemD_SMS.FieldByName('Tel').AsString+';'+
                         MemD_SMS.FieldByName('EMail').AsString+';'+
                         MemD_SMS.FieldByName('Ref').AsString+';'+
                         MemD_SMS.FieldByName('Pass').AsString+';'+
                         sErreur);
            end;
          end;
          7:
          begin
            if bEtat7 then
            begin
              LstTmp.Add(MemD_SMS.FieldByName('CodeAdhImp').AsString+';'+
                         MemD_SMS.FieldByName('Base').AsString+';'+
                         MemD_SMS.FieldByName('NomSoc').AsString+';'+
                         MemD_SMS.FieldByName('Nom').AsString+';'+
                         MemD_SMS.FieldByName('Prenom').AsString+';'+
                         MemD_SMS.FieldByName('Tel').AsString+';'+
                         MemD_SMS.FieldByName('EMail').AsString+';'+
                         MemD_SMS.FieldByName('Ref').AsString+';'+
                         MemD_SMS.FieldByName('Pass').AsString+';'+
                         '');
            end;
          end;
        end;
        MemD_SMS.Next;
      end;
      MemD_SMS.First;
      LstTmp.SaveToFile(sFic);
    finally
      LstTmp.Free;
      LstTmp := nil;
    end;
  finally
    FreeAndNil(Frm_ExportResult);
  end;
end;

procedure TFrm_Main.Nbt_smsClick(Sender: TObject);
var
  LstTmp: TStringList;
  sFic: string;
  i, j: integer;
  sCodeAdh: string;
  iCodeAdh: integer;
  sTmp1, sTmp2: string;
begin
  OD_Load.Title := 'Charge la config des comptes sms (Compte essendex.csv)';
  if not(OD_Load.Execute) then
    exit;

  sFic := OD_Load.FileName;
  LstTmp := TStringList.Create;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  MemD_SMS.DisableControls;
  try
    LstTmp.LoadFromFile(sFic);

    // Etat
    // 1 Base sans compte sms associé
    // 2 Compte sms sans base associé
    // 3 Paramétrage compte sms invalide
    // 4 Chemin de base non trouvé
    // 5 attente affectation
    // 6 paramétrage échoué
    // 7 paramétrage réussi
    for i := 2 to LstTmp.Count do
    begin
      if Trim(LstTmp[i-1])<>'' then
      begin
        sCodeAdh := GetCsvValue(LstTmp[i-1], 8);
        iCodeAdh := StrToIntDef(sCodeAdh, 0);
        if (iCodeAdh=0) or not(MemD_SMS.Locate('CodeAdh', iCodeAdh, [])) then
        begin
          MemD_SMS.Append;
          MemD_SMS.FieldByName('CodeAdh').AsInteger := iCodeAdh;
          MemD_SMS.FieldByName('CodeAdhImp').AsString := sCodeAdh;
          MemD_SMS.FieldByName('etat').AsInteger := 2;
          MemD_SMS.FieldByName('NomSoc').AsString := GetCsvValue(LstTmp[i-1], 1);
          MemD_SMS.FieldByName('Nom').AsString := GetCsvValue(LstTmp[i-1], 2);
          MemD_SMS.FieldByName('Prenom').AsString := GetCsvValue(LstTmp[i-1], 3);
          MemD_SMS.FieldByName('EMail').AsString := GetCsvValue(LstTmp[i-1], 4);
          MemD_SMS.FieldByName('Tel').AsString := GetCsvValue(LstTmp[i-1], 5);
          MemD_SMS.FieldByName('Ref').AsString := GetCsvValue(LstTmp[i-1], 6);
          MemD_SMS.FieldByName('Pass').AsString := GetCsvValue(LstTmp[i-1], 7);
          MemD_SMS.Post;
        end
        else
        begin
          MemD_SMS.Edit;
          MemD_SMS.FieldByName('CodeAdh').AsInteger := iCodeAdh;
          MemD_SMS.FieldByName('CodeAdhImp').AsString := sCodeAdh;
          if (Trim(GetCsvValue(LstTmp[i-1], 4))<>'')     // mail
             and (Trim(GetCsvValue(LstTmp[i-1], 6))<>'')   // Account
             and (Trim(GetCsvValue(LstTmp[i-1], 7))<>'') then   // pass
            MemD_SMS.FieldByName('etat').AsInteger := 5
          else
            MemD_SMS.FieldByName('etat').AsInteger := 3;
          MemD_SMS.FieldByName('NomSoc').AsString := GetCsvValue(LstTmp[i-1], 1);
          MemD_SMS.FieldByName('Nom').AsString := GetCsvValue(LstTmp[i-1], 2);
          MemD_SMS.FieldByName('Prenom').AsString := GetCsvValue(LstTmp[i-1], 3);
          MemD_SMS.FieldByName('EMail').AsString := GetCsvValue(LstTmp[i-1], 4);
          MemD_SMS.FieldByName('Tel').AsString := GetCsvValue(LstTmp[i-1], 5);
          MemD_SMS.FieldByName('Ref').AsString := GetCsvValue(LstTmp[i-1], 6);
          MemD_SMS.FieldByName('Pass').AsString := GetCsvValue(LstTmp[i-1], 7);
          MemD_SMS.Post;
        end;
      end;
    end;
  finally
    MemD_SMS.First;
    MemD_SMS.EnableControls;
    FreeAndNil(LstTmp);
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;

  // etape suivante
  Lab_FaireEn3.Enabled := true;
  Nbt_affecter.Enabled := true;
end;

end.
