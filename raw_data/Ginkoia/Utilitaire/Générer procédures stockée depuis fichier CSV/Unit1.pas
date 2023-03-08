unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, System.StrUtils, Vcl.Samples.Spin, System.IniFiles, System.Generics.Collections, System.Math;

const
   TYPE_VARCHAR = 0;
   TYPE_DATE = 1;
   TYPE_INTEGER = 2;
   TYPE_NUMERIC = 3;

type
   TParametre = class(TPanel)
      protected
         EditNom: TLabeledEdit;
         LabelType: TLabel;
         ComboBoxType: TComboBox;
         EditTaille: TEdit;

         procedure ComboBoxTypeChange(Sender: TObject);
         procedure EditTailleKeyPress(Sender: TObject; var Key: Char);

      public
         constructor Create(AOwner: TComponent; AParent: TWinControl; const nPos: Integer; const sNom: String);   reintroduce;   overload;
         destructor Destroy;   override;
   end;

  TMainForm = class(TForm)
    Panel: TPanel;
    EditFichierCSV: TLabeledEdit;
    EditNomProcedure: TLabeledEdit;
    EditCentrale: TLabeledEdit;
    BtnGenerer: TBitBtn;
    RichEdit: TRichEdit;
    BtnOuvrir: TBitBtn;
    OpenDialog: TOpenDialog;
    SpinEdit: TSpinEdit;
    LabelNbLignesMax: TLabel;
    PanelProcedure: TPanel;
    BtnCharger: TBitBtn;
    BtnEnregistrer: TBitBtn;
    CheckBoxGestionK: TCheckBox;
    EditNbKMax: TLabeledEdit;
    CheckBoxEnTete: TCheckBox;
    ScrollBox: TScrollBox;
    LabelParametres: TLabel;
    BtnMajParametres: TBitBtn;
    EditSeparateur: TLabeledEdit;
    SpinEditNbColonnes: TSpinEdit;
    LabelNbColonnes: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BtnOuvrirClick(Sender: TObject);
    procedure SpinEditNbColonnesChange(Sender: TObject);
    procedure EditNomProcedureKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditNomProcedureExit(Sender: TObject);
    procedure EditNbKMaxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditNbKMaxExit(Sender: TObject);
    procedure EditCentraleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnMajParametresClick(Sender: TObject);
    procedure BtnChargerClick(Sender: TObject);
    procedure BtnEnregistrerClick(Sender: TObject);
    procedure BtnGenererClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);

  private
    _ListeParametres: TObjectList<TParametre>;
    _nNbLignes: Integer;

    function FichierVerrouille: Boolean;
    procedure PreTraitement;
    function GetParametres: String;
    procedure ChargementParametres;
    procedure MajParametres;
    procedure Activer(const bActiver: Boolean);

  public

  end;

var
  MainForm: TMainForm;

implementation

{ TParametre }

constructor TParametre.Create(AOwner: TComponent; AParent: TWinControl; const nPos: Integer; const sNom: String);
begin
   inherited Create(AOwner);
   Parent := AParent;
   Left := 1;      Top := nPos;
   Height := 23;      Width := (AParent.Width - 25);
   BevelOuter := bvNone;
   Color := clWindow;

   EditNom := TLabeledEdit.Create(Self);
   EditNom.Parent := Self;
   EditNom.Left := 45;      EditNom.Top := 2;
   EditNom.Width := 160;
   EditNom.LabelPosition := lpLeft;
   EditNom.LabelSpacing := 8;
   EditNom.EditLabel.Font.Color := clNavy;
   EditNom.EditLabel.Caption := 'Nom :';
   EditNom.Text := sNom;

   LabelType := TLabel.Create(Self);
   LabelType.Parent := Self;
   LabelType.Left := (EditNom.Left + EditNom.Width + 25);      LabelType.Top := 7;
   LabelType.Font.Color := clNavy;
   LabelType.Caption := 'Type :';

   ComboBoxType := TComboBox.Create(Self);
   ComboBoxType.Parent := Self;
   ComboBoxType.Left := (LabelType.Left + LabelType.Width + 5);      ComboBoxType.Top := 2;
   ComboBoxType.Width := 100;
   ComboBoxType.Style := csDropDownList;
   ComboBoxType.Items.Add('varchar');
   ComboBoxType.Items.Add('date');
   ComboBoxType.Items.Add('integer');
   ComboBoxType.Items.Add('numeric');
   ComboBoxType.ItemIndex := 0;
   ComboBoxType.OnChange := ComboBoxTypeChange;

   EditTaille := TEdit.Create(Self);
   EditTaille.Parent := Self;
   EditTaille.Left := (ComboBoxType.Left + ComboBoxType.Width + 5);      EditTaille.Top := 2;
   EditTaille.Width := 50;
   EditTaille.Text := '32';
   EditTaille.ShowHint := True;
   EditTaille.OnKeyPress := EditTailleKeyPress;
end;

procedure TParametre.ComboBoxTypeChange(Sender: TObject);
begin
   EditTaille.Visible := (ComboBoxType.ItemIndex in [TYPE_VARCHAR, TYPE_NUMERIC]);
   EditTaille.Hint := IfThen(ComboBoxType.ItemIndex = TYPE_VARCHAR, 'Taille du varchar', 'Taille du nombre');
end;

procedure TParametre.EditTailleKeyPress(Sender: TObject; var Key: Char);
begin
   if Key = '.' then
      Key := ',';
end;

destructor TParametre.Destroy;
begin
   EditTaille.Free;
   ComboBoxType.Free;
   LabelType.Free;
   EditNom.Free;

   inherited;
end;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
{$REGION 'FormCreate'}
   function GetLongueurTab: Integer;
   var
      Bitmap: TBitmap;
   begin
      Bitmap := TBitmap.Create;
      try
         Bitmap.Canvas.Font.Assign(RichEdit.Font);
         Result := Bitmap.Canvas.TextWidth('   ');
      finally
         Bitmap.Free;
      end;
   end;
{$ENDREGION}
var
   nLongueurTab: Integer;
   FichierINI: TIniFile;
begin
   _ListeParametres := TObjectList<TParametre>.Create;
   _nNbLignes := 0;
   nLongueurTab := (GetLongueurTab - 2);
   SendMessage(RichEdit.Handle, EM_SETTABSTOPS, 1, Longint(@nLongueurTab));

   FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'GenererProcedures.ini');
   try
      EditFichierCSV.Text := FichierINI.ReadString('Paramètres', 'Fichier', '');
      CheckBoxEnTete.Checked := (FichierINI.ReadInteger('Paramètres', 'En-tête', 0) = 1);
      EditSeparateur.Text := FichierINI.ReadString('Paramètres', 'Séparateur', ';');
      EditNomProcedure.Text := FichierINI.ReadString('Paramètres', 'Procédure', '');
      CheckBoxGestionK.Checked := (FichierINI.ReadInteger('Paramètres', 'Gestion K', 0) = 1);
      EditNbKMax.Text := FichierINI.ReadString('Paramètres', 'Nb K max', '10000');
      EditCentrale.Text := FichierINI.ReadString('Paramètres', 'Centrale', '');
      SpinEdit.Value := FichierINI.ReadInteger('Paramètres', 'Nb lignes max', 100);
      BtnCharger.Enabled := FichierINI.SectionExists('Procédure')
   finally
      FichierINI.Free;
   end;

   if FileExists(EditFichierCSV.Text) then
   begin
      PreTraitement;
      ChargementParametres;
      MajParametres;
      BtnGenerer.Enabled := True;
   end;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
   BtnGenerer.Left := (Width div 2) - (BtnGenerer.Width div 2);
end;

procedure TMainForm.BtnOuvrirClick(Sender: TObject);
begin
   // Si validation.
   if OpenDialog.Execute then
   begin
      EditFichierCSV.Text := OpenDialog.FileName;
      PreTraitement;
      EditNomProcedure.SetFocus;
      BtnGenerer.Enabled := True;
   end
   else
      EditFichierCSV.SetFocus;
end;

function TMainForm.FichierVerrouille: Boolean;
var
   h: Thandle;
begin
//   Result := False;
   h := CreateFile(PChar(EditFichierCSV.Text), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
   try
      Result := (h = INVALID_HANDLE_VALUE);
   finally
      CloseHandle(h)
   end;
end;

procedure TMainForm.PreTraitement;
var
   F: TextFile;
   szLigne: String;
   nIndex, nPos, i: Integer;
begin
   SpinEditNbColonnes.OnChange := nil;
   try
      SpinEditNbColonnes.Value := 1;
      if FichierVerrouille then
      begin
         Application.MessageBox('Erreur :  le fichier CSV est verrouillé en lecture !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
         Exit;
      end;

      // Lecture du nombre de lignes du fichier.
      AssignFile(F, EditFichierCSV.Text);
      try
         _nNbLignes := 0;      szLigne := '';
         Reset(F);
         while not Eof(F) do
         begin
            Readln(F, szLigne);
            if Length(szLigne) > 0 then
               Inc(_nNbLignes);
         end;
      finally
         CloseFile(F);
      end;

      if szLigne <> '' then
      begin
         SpinEditNbColonnes.Value := 1;
         nIndex := Pos(EditSeparateur.Text, szLigne);
         while nIndex > 0 do
         begin
            SpinEditNbColonnes.Value := SpinEditNbColonnes.Value + 1;
            szLigne := Copy(szLigne, nIndex + 1, Length(szLigne));
            nIndex := Pos(EditSeparateur.Text, szLigne);
         end;

         _ListeParametres.Clear;
         nPos := 1;
         for i:=1 to SpinEditNbColonnes.Value do
         begin
            _ListeParametres.Add(TParametre.Create(Self, ScrollBox, nPos, 'Param' + IntToStr(i)));
            nPos := (_ListeParametres[_ListeParametres.Count - 1].Top + _ListeParametres[_ListeParametres.Count - 1].Height + 2);
         end;
      end;
   finally
      SpinEditNbColonnes.OnChange := SpinEditNbColonnesChange;
   end;
end;

procedure TMainForm.SpinEditNbColonnesChange(Sender: TObject);
var
   i, nNb, nPos: Integer;
begin
   if _ListeParametres.Count > SpinEditNbColonnes.Value then
   begin
      for i:=Pred(_ListeParametres.Count) downto SpinEditNbColonnes.Value do
         _ListeParametres.Delete(i);
   end
   else if _ListeParametres.Count < SpinEditNbColonnes.Value then
   begin
      nNb := (SpinEditNbColonnes.Value - _ListeParametres.Count);
      nPos := (_ListeParametres[_ListeParametres.Count - 1].Top + _ListeParametres[_ListeParametres.Count - 1].Height + 2);
      for i:=1 to nNb do
      begin
         _ListeParametres.Add(TParametre.Create(Self, ScrollBox, nPos, 'Param' + IntToStr(_ListeParametres.Count + 1)));
         nPos := (_ListeParametres[_ListeParametres.Count - 1].Top + _ListeParametres[_ListeParametres.Count - 1].Height + 2);
      end;
   end;
end;

function TMainForm.GetParametres: String;
var
   i: Integer;
begin
   Result := '';
   for i:=0 to Pred(_ListeParametres.Count) do
   begin
      Result := Result + '   ' + _ListeParametres[i].EditNom.Text + ' ' + _ListeParametres[i].ComboBoxType.Items[_ListeParametres[i].ComboBoxType.ItemIndex];
      if(_ListeParametres[i].ComboBoxType.ItemIndex in [TYPE_VARCHAR, TYPE_NUMERIC]) then
         Result := Result + '(' + _ListeParametres[i].EditTaille.Text + ')';
      Result := Result + IfThen(i < Pred(_ListeParametres.Count), ',' + #13#10, ')');
   end;
end;

procedure TMainForm.ChargementParametres;
var
   FichierINI: TIniFile;
   Liste: TStringList;
   i, nIndex, nType: Integer;
   sTmp: String;
begin
   FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'GenererProcedures.ini');
   Liste := TStringList.Create;
   try
      FichierINI.ReadSectionValues('Paramètres procédure', Liste);
      if _ListeParametres.Count = Liste.Count then
      begin
         for i:=0 to Pred(Liste.Count) do
         begin
            sTmp := Liste[i];
            nIndex := Pos('=', sTmp);
            if nIndex > 0 then
            begin
               sTmp := Copy(sTmp, nIndex + 1, Length(sTmp));
               nIndex := Pos('¤', sTmp);
               if nIndex > 0 then
               begin
                  _ListeParametres[i].EditNom.Text := LeftStr(sTmp, nIndex - 1);
                  sTmp := Copy(sTmp, nIndex + 1, Length(sTmp));
                  nIndex := Pos('¤', sTmp);
                  if nIndex > 0 then
                  begin
                     if TryStrToInt(LeftStr(sTmp, nIndex - 1), nType) then
                     begin
                        _ListeParametres[i].ComboBoxType.ItemIndex := nType;
                        _ListeParametres[i].ComboBoxTypeChange(nil);
                     end;
                     _ListeParametres[i].EditTaille.Text := Copy(sTmp, nIndex + 1, Length(sTmp));
                  end;
               end;
            end;
         end;
      end;
   finally
      Liste.Free;
      FichierINI.Free;
   end;
end;

procedure TMainForm.EditNomProcedureKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   // Si validation.
   if Key = VK_RETURN then
      EditCentrale.SetFocus;
end;

procedure TMainForm.EditNomProcedureExit(Sender: TObject);
begin
   MajParametres;
end;

procedure TMainForm.MajParametres;
var
   i, j: Integer;
begin
   if EditNomProcedure.Text <> '' then
   begin
      if RichEdit.Lines.Count = 0 then
      begin
         RichEdit.Clear;
         RichEdit.Lines.Add('create procedure ' + UpperCase(EditNomProcedure.Text) + '_3(');
         RichEdit.Lines.Add(GetParametres);
         if CheckBoxGestionK.Checked then
         begin
            RichEdit.Lines.Add('returns(');
            RichEdit.Lines.Add('   AJOUT integer)');
         end;
         RichEdit.Lines.Add('as');
         RichEdit.Lines.Add('begin');
         if CheckBoxGestionK.Checked then
            RichEdit.Lines.Add('   AJOUT = 0;');
         RichEdit.Lines.Add('   ');
         if CheckBoxGestionK.Checked then
         begin
            RichEdit.Lines.Add('   ');
            RichEdit.Lines.Add('   suspend;');
         end;
         RichEdit.Lines.Add('end;');
      end
      else
      begin
         RichEdit.Lines[0] := 'create procedure ' + UpperCase(EditNomProcedure.Text) + '_3(';
         for i:=Pred(RichEdit.Lines.Count) downto 2 do
         begin
            if LowerCase(LeftStr(RichEdit.Lines[i], 2)) = 'as' then
            begin
               for j:=Pred(i) downto 2 do
                  RichEdit.Lines.Delete(j);
               Break;
            end;
         end;
         RichEdit.Lines[1] := GetParametres;
         i := Succ(_ListeParametres.Count);
         if i < RichEdit.Lines.Count then
         begin
            while LowerCase(LeftStr(RichEdit.Lines[i], 2)) <> 'as' do
            begin
               RichEdit.Lines.Delete(i);
               if i >= RichEdit.Lines.Count then
                  Break;
            end;
         end;
      end;
   end;
end;

procedure TMainForm.EditNbKMaxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   // Si validation.
   if Key = VK_RETURN then
      EditCentrale.SetFocus;
end;

procedure TMainForm.EditNbKMaxExit(Sender: TObject);
var
   nMax: Integer;
begin
   if not TryStrToInt(EditNbKMax.Text, nMax) then
      EditNbKMax.Text := '10000';
end;

procedure TMainForm.EditCentraleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   // Si validation.
   if Key = VK_RETURN then
      RichEdit.SetFocus;
end;

procedure TMainForm.BtnMajParametresClick(Sender: TObject);
begin
   MajParametres;
   RichEdit.SetFocus;
end;

procedure TMainForm.BtnChargerClick(Sender: TObject);
var
   FichierINI: TIniFile;
   i: Integer;
   Lignes: TStringList;
begin
   MajParametres;
   FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'GenererProcedures.ini');
   try
      for i:=Pred(RichEdit.Lines.Count) downto 0 do
      begin
         if RichEdit.Lines[i] = 'as' then
         begin
            RichEdit.Lines.Delete(i);
            Break;
         end;

         RichEdit.Lines.Delete(i);
      end;

      Lignes := TStringList.Create;
      try
         FichierINI.ReadSectionValues('Procédure', Lignes);
         for i:=0 to Pred(Lignes.Count) do
            Lignes[i] := Copy(Lignes[i], Pos('=§', Lignes[i]) + 2, Length(Lignes[i]));
         RichEdit.Lines.AddStrings(Lignes);
      finally
         Lignes.Free;
      end;

      RichEdit.SelStart := 0;
   finally
      FichierINI.Free;
   end;

   RichEdit.SetFocus;
end;

procedure TMainForm.BtnEnregistrerClick(Sender: TObject);
var
   FichierINI: TIniFile;
   bDebut: Boolean;
   i: Integer;
begin
   FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'GenererProcedures.ini');
   try
      FichierINI.EraseSection('Procédure');
      bDebut := False;
      for i:=0 to Pred(RichEdit.Lines.Count) do
      begin
         if not bDebut then
         begin
            if RichEdit.Lines[i] = 'as' then
               bDebut := True;
         end;

         if bDebut then
            FichierINI.WriteString('Procédure', IntToStr(i), '§' + RichEdit.Lines[i]);
      end;

      BtnCharger.Enabled := FichierINI.SectionExists('Procédure')
   finally
      FichierINI.Free;
   end;

   RichEdit.SetFocus;
end;

procedure TMainForm.Activer(const bActiver: Boolean);
begin
   EditFichierCSV.Enabled := bActiver;
   BtnOuvrir.Enabled := bActiver;
   CheckBoxEnTete.Enabled := bActiver;
   EditSeparateur.Enabled := bActiver;
   EditNomProcedure.Enabled := bActiver;
   CheckBoxGestionK.Enabled := bActiver;
   EditNbKMax.Enabled := bActiver;
   EditCentrale.Enabled := bActiver;
   SpinEdit.Enabled := bActiver;
   ScrollBox.Enabled := bActiver;
   BtnMajParametres.Enabled := bActiver;
   RichEdit.Enabled := bActiver;
   BtnCharger.Enabled := bActiver;
   BtnEnregistrer.Enabled := bActiver;
   BtnGenerer.Enabled := bActiver;
end;

procedure TMainForm.BtnGenererClick(Sender: TObject);
{$REGION 'BtnGenererClick'}
   function FormateDate(const sDate: String): String;
   begin
      Result := sDate;
      if((Length(sDate) = 10) or (Length(sDate) = 19)) and (sDate[3] = '/') and (sDate[6] = '/') then
      begin
         Result := Copy(sDate, 7, 4) + '-' + Copy(sDate, 4, 2) + '-' + LeftStr(sDate, 2);
         if Length(sDate) = 19 then
            Result := Result + ' ' + Copy(sDate, 12, Length(sDate));
      end;
   end;

   procedure FormaterParametre(const nParam: Integer; sParam: String; var sLigneParam: String);
   begin
      sParam := StringReplace(sParam, '''', '''''', [rfReplaceAll]);
      if nParam < _ListeParametres.Count then
      begin
         // Si nombre.
         if(_ListeParametres[nParam].ComboBoxType.ItemIndex in [TYPE_INTEGER, TYPE_NUMERIC]) then
            sLigneParam := sLigneParam + StringReplace(sParam, ',', '.', [])
         else if _ListeParametres[nParam].ComboBoxType.ItemIndex = TYPE_DATE then
         begin
            if sParam = '' then
               sLigneParam := sLigneParam + 'null'
            else
               sLigneParam := sLigneParam + '''' + FormateDate(sParam) + '''';
         end
         else
            sLigneParam := sLigneParam + '''' + sParam + '''';
      end
      else
         sLigneParam := sLigneParam + '''' + sParam + '''';
   end;

   function FormaterParametres(szLigne: String): String;
   var
      nParam, nIndex: Integer;
   begin
      Result := '';
      nParam := 0;
      while szLigne <> '' do
      begin
         nIndex := Pos(EditSeparateur.Text, szLigne);
         if nIndex > 0 then
         begin
            FormaterParametre(nParam, LeftStr(szLigne, nIndex - 1), Result);
            szLigne := Copy(szLigne, nIndex + 1, Length(szLigne));
            if(szLigne <> '') and (nParam < Pred(SpinEditNbColonnes.Value)) then
               Result := Result + ', ';
         end
         else
         begin
            FormaterParametre(nParam, szLigne, Result);
            szLigne := '';
         end;

         Inc(nParam);
         if nParam >= SpinEditNbColonnes.Value then
            Break;
      end;

      if nParam < SpinEditNbColonnes.Value then
         Result := Result + DupeString(', ''''', (SpinEditNbColonnes.Value - nParam));
   end;
{$ENDREGION}
var
   ListeProcedures1: TObjectList<TStringList>;
   Procedure2, ListeNomProcedures1, ListeNomProcedures2, Fichier: TStringList;
   F: TextFile;
   nLigne, i, nNumProc1, nNbExec: Integer;
   szLigne, szNom: String;
begin
   // Vérifications.
   if not FileExists(EditFichierCSV.Text) then
   begin
      BtnOuvrirClick(Sender);
      Exit;
   end;
   if EditNomProcedure.Text = '' then
   begin
      Application.MessageBox('Attention :  il faut saisir un nom de procédure stockée !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
      EditNomProcedure.SetFocus;
      Exit;
   end;
   if(_nNbLignes = 0) or (_ListeParametres.Count = 0) then
   begin
      PreTraitement;
      MajParametres;
      RichEdit.SetFocus;
      Exit;
   end;

   Activer(False);
   Application.ProcessMessages;
   try
      Fichier := TStringList.Create;
      ListeNomProcedures1 := TStringList.Create;
      ListeProcedures1 := TObjectList<TStringList>.Create;
      ListeNomProcedures2 := TStringList.Create;
      Procedure2 := TStringList.Create;
      try
         // Procédure 1 (procédure principale).
         nNumProc1 := 0;
         ListeNomProcedures1.Add(UpperCase(EditNomProcedure.Text) + '_1');
         ListeProcedures1.Add(TStringList.Create);
         ListeProcedures1[nNumProc1].Add('create procedure ' + UpperCase(EditNomProcedure.Text) + '_1');
         if CheckBoxGestionK.Checked then
         begin
            ListeProcedures1[nNumProc1].Add('returns(');
            ListeProcedures1[nNumProc1].Add('   RESTE integer)');
         end;
         ListeProcedures1[nNumProc1].Add('as');
         ListeProcedures1[nNumProc1].Add('   declare variable PANTIN integer;');
         ListeProcedures1[nNumProc1].Add('   declare variable NB integer;');
         if CheckBoxGestionK.Checked then
         begin
            ListeProcedures1[nNumProc1].Add('   declare variable NB_K integer;');
            ListeProcedures1[nNumProc1].Add('   declare variable NB_K_MAX integer;');
         end;
         ListeProcedures1[nNumProc1].Add('begin');
         if CheckBoxGestionK.Checked then
         begin
            ListeProcedures1[nNumProc1].Add('   RESTE = 1;');
            ListeProcedures1[nNumProc1].Add('   ');
         end;
         ListeProcedures1[nNumProc1].Add('   select RETOUR from BN_ONLY_PANTIN into :PANTIN;');
         ListeProcedures1[nNumProc1].Add('   if(:PANTIN = 0) then');
         ListeProcedures1[nNumProc1].Add('      exit;');
         ListeProcedures1[nNumProc1].Add('   ');
         if EditCentrale.Text <> '' then
         begin
            ListeProcedures1[nNumProc1].Add('   select count(*)');
            ListeProcedures1[nNumProc1].Add('   from UILGRPGINKOIA');
            ListeProcedures1[nNumProc1].Add('   join K on (K_ID = UGG_ID and K_ENABLED = 1)');
            ListeProcedures1[nNumProc1].Add('   join UILGRPGINKOIAMAG on (UGG_ID = UGM_UGGID)');
            ListeProcedures1[nNumProc1].Add('   join K on (K_ID = UGM_ID and K_ENABLED = 1)');
            ListeProcedures1[nNumProc1].Add('   where UGG_NOM = ''' + EditCentrale.Text + '''');
            ListeProcedures1[nNumProc1].Add('   into :NB;');
            ListeProcedures1[nNumProc1].Add('   ');
            ListeProcedures1[nNumProc1].Add('   if(:NB = 0) then');
            ListeProcedures1[nNumProc1].Add('      exit;');
            ListeProcedures1[nNumProc1].Add('   ');
         end;
         if CheckBoxGestionK.Checked then
         begin
            ListeProcedures1[nNumProc1].Add('   NB_K = 0;      NB_K_MAX = ' + EditNbKMax.Text + ';');
            ListeProcedures1[nNumProc1].Add('   ');
         end;
         nNbExec := 0;

         if FichierVerrouille then
         begin
            Application.MessageBox('Erreur :  le fichier CSV est verrouillé en lecture !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
            Exit;
         end;

         // Parcours du fichier.
         AssignFile(F, EditFichierCSV.Text);
         try
            nLigne := 0;
            Reset(F);

            // Si ligne d'en-tête.
            if CheckBoxEnTete.Checked then
            begin
               if not Eof(F) then
                  Readln(F, szLigne);
            end;

            while not Eof(F) do
            begin
               Readln(F, szLigne);
               szLigne := FormaterParametres(szLigne);
               Inc(nLigne);

               if Length(szLigne) > 0 then
               begin
                  // Si nb lignes maximum dépassé pour procédure 2.
                  if _nNbLignes > SpinEdit.Value then
                  begin
                     // Si nouvelle procédure 2.
                     if(nLigne = 1) or ((nLigne mod SpinEdit.Value) = 0) then
                     begin
                        if ListeNomProcedures2.Count > 0 then
                        begin
                           if CheckBoxGestionK.Checked then
                           begin
                              Procedure2.Add('   ');
                              Procedure2.Add('   suspend;');
                           end;

                           Procedure2.Add('end;');
                           Procedure2.Add('<---->');
                        end;

                        // Nouvelle procédure 2.
                        szNom := UpperCase(EditNomProcedure.Text) + '_2_' + IntToStr(ListeNomProcedures2.Count + 1);
                        if CheckBoxGestionK.Checked then
                        begin
                           ListeProcedures1[nNumProc1].Add('   select NB_K from ' + szNom + ' into :NB;');
                           ListeProcedures1[nNumProc1].Add('   NB_K = :NB_K + :NB;');
                           ListeProcedures1[nNumProc1].Add('   if(:NB_K >= :NB_K_MAX) then');
                           ListeProcedures1[nNumProc1].Add('   begin');
                           ListeProcedures1[nNumProc1].Add('      suspend;');
                           ListeProcedures1[nNumProc1].Add('      exit;');
                           ListeProcedures1[nNumProc1].Add('   end');
                        end
                        else
                           ListeProcedures1[nNumProc1].Add('   execute procedure ' + szNom + ';');
                        Inc(nNbExec);

                        ListeNomProcedures2.Add(szNom);
                        Procedure2.Add('create procedure ' + szNom);
                        if CheckBoxGestionK.Checked then
                        begin
                           Procedure2.Add('returns(');
                           Procedure2.Add('   NB_K integer)');
                        end;
                        Procedure2.Add('as');
                        Procedure2.Add('   declare variable AJOUT integer;');
                        Procedure2.Add('begin');
                        if CheckBoxGestionK.Checked then
                        begin
                           Procedure2.Add('   NB_K = 0;');
                           Procedure2.Add('   ');
                        end;
                     end;

                     // Appel de la procédure 3.
                     if CheckBoxGestionK.Checked then
                        Procedure2.Add('   select AJOUT from ' + UpperCase(EditNomProcedure.Text) + '_3(' + szLigne + ') into :AJOUT;      NB_K = :NB_K + :AJOUT;')
                     else
                        Procedure2.Add('   execute procedure ' + UpperCase(EditNomProcedure.Text) + '_3(' + szLigne + ');');

                     // Si nb lignes maximum dépassé pour procédure 1.
                     if nNbExec >= SpinEdit.Value then
                     begin
                        ListeProcedures1[nNumProc1].Add('   ');
                        szNom := UpperCase(EditNomProcedure.Text) + '_1_' + IntToStr(ListeNomProcedures1.Count + 1);
                        if CheckBoxGestionK.Checked then
                        begin
                           ListeProcedures1[nNumProc1].Add('   select NB_K from ' + szNom + '(:NB_K, :NB_K_MAX) into :NB;');
                           ListeProcedures1[nNumProc1].Add('   NB_K = :NB_K + :NB;');
                           ListeProcedures1[nNumProc1].Add('   if(:NB_K >= :NB_K_MAX) then');
                           ListeProcedures1[nNumProc1].Add('   begin');
                           ListeProcedures1[nNumProc1].Add('      suspend;');
                           ListeProcedures1[nNumProc1].Add('      exit;');
                           ListeProcedures1[nNumProc1].Add('   end');
                           ListeProcedures1[nNumProc1].Add('   ');
                           ListeProcedures1[nNumProc1].Add('   RESTE = 0;');
                           ListeProcedures1[nNumProc1].Add('   suspend;');
                        end
                        else
                           ListeProcedures1[nNumProc1].Add('   execute procedure ' + szNom + ';');
                        ListeProcedures1[nNumProc1].Add('end;');
                        ListeProcedures1[nNumProc1].Add('<---->');

                        // Nouvelle procédure 1.
                        ListeNomProcedures1.Add(szNom);
                        Inc(nNumProc1);
                        ListeProcedures1.Add(TStringList.Create);
                        ListeProcedures1[nNumProc1].Add('create procedure ' + szNom + IfThen(CheckBoxGestionK.Checked, '('));
                        if CheckBoxGestionK.Checked then
                        begin
                           ListeProcedures1[nNumProc1].Add('   NBK integer,');
                           ListeProcedures1[nNumProc1].Add('   NB_K_MAX integer)');
                           ListeProcedures1[nNumProc1].Add('returns(');
                           ListeProcedures1[nNumProc1].Add('   NB_K integer)');
                        end;
                        ListeProcedures1[nNumProc1].Add('as');
                        ListeProcedures1[nNumProc1].Add('   declare variable NB integer;');
                        ListeProcedures1[nNumProc1].Add('begin');
                        if CheckBoxGestionK.Checked then
                        begin
                           ListeProcedures1[nNumProc1].Add('   NB_K = :NBK;');
                           ListeProcedures1[nNumProc1].Add('   ');
                        end;

                        nNbExec := 0;
                     end;
                  end
                  else
                  begin
                     // Appel de la procédure 3.
                     if CheckBoxGestionK.Checked then
                        ListeProcedures1[nNumProc1].Add('   select AJOUT from ' + UpperCase(EditNomProcedure.Text) + '_3(' + szLigne + ') into :AJOUT;      NB_K = :NB_K + :AJOUT;')
                     else
                        ListeProcedures1[nNumProc1].Add('   execute procedure ' + UpperCase(EditNomProcedure.Text) + '_3(' + szLigne + ');');
                  end;
               end;
            end;

            if ListeNomProcedures2.Count > 0 then
            begin
               if CheckBoxGestionK.Checked then
               begin
                  Procedure2.Add('   ');
                  Procedure2.Add('   suspend;');
               end;

               Procedure2.Add('end;');
               Procedure2.Add('<---->');
            end;
         finally
            CloseFile(F);
         end;

         // Si une seule procédure 1.
         if nNumProc1 = 0 then
         begin
            if CheckBoxGestionK.Checked then
            begin
               ListeProcedures1[nNumProc1].Add('   RESTE = 0;');
               ListeProcedures1[nNumProc1].Add('   suspend;');
            end;
         end
         else
         begin
            if CheckBoxGestionK.Checked then
            begin
               ListeProcedures1[nNumProc1].Add('   ');
               ListeProcedures1[nNumProc1].Add('   suspend;');
            end;
         end;
         ListeProcedures1[nNumProc1].Add('end;');
         ListeProcedures1[nNumProc1].Add('<---->');

         // Génération du fichier.
         Fichier.Assign(RichEdit.Lines);      // Procédure 3.
         Fichier.Add('<---->');
         if ListeNomProcedures2.Count > 0 then
            Fichier.AddStrings(Procedure2);
         for i:=Pred(ListeProcedures1.Count) downto 0 do
            Fichier.AddStrings(ListeProcedures1[i]);
         if CheckBoxGestionK.Checked then
            Fichier.Add('select RESTE from ' + UpperCase(EditNomProcedure.Text) + '_1;')      // Exécution de la procédure principale (avec RESTE = 1 si traitement inachevé).
         else
            Fichier.Add('execute procedure ' + UpperCase(EditNomProcedure.Text) + '_1;');      // Exécution de la procédure principale.
         Fichier.Add('<---->');
         for i:=0 to Pred(ListeNomProcedures1.Count) do
         begin
            Fichier.Add('drop procedure ' + ListeNomProcedures1[i] + ';');
            Fichier.Add('<---->');
         end;
         for i:=0 to Pred(ListeNomProcedures2.Count) do
         begin
            Fichier.Add('drop procedure ' + ListeNomProcedures2[i] + ';');
            Fichier.Add('<---->');
         end;
         Fichier.Add('drop procedure ' + UpperCase(EditNomProcedure.Text) + '_3;');

         // Enregistrement du fichier.
         Fichier.SaveToFile(ExtractFilePath(EditFichierCSV.Text) + EditNomProcedure.Text + '.sql');
      finally
         Procedure2.Free;
         ListeNomProcedures2.Free;
         ListeProcedures1.Free;
         ListeNomProcedures1.Free;
         Fichier.Free;
      end;
   finally
      Activer(True);
   end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
   FichierINI: TIniFile;
   nMax, i: Integer;
begin
   FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'GenererProcedures.ini');
   try
      FichierINI.WriteString('Paramètres', 'Fichier', EditFichierCSV.Text);
      FichierINI.WriteInteger('Paramètres', 'En-tête', IfThen(CheckBoxEnTete.Checked, 1, 0));
      FichierINI.WriteString('Paramètres', 'Séparateur', EditSeparateur.Text);
      FichierINI.WriteString('Paramètres', 'Procédure', EditNomProcedure.Text);
      FichierINI.WriteInteger('Paramètres', 'Gestion K', IfThen(CheckBoxGestionK.Checked, 1, 0));
      if not TryStrToInt(EditNbKMax.Text, nMax) then
         nMax := 10000;
      FichierINI.WriteInteger('Paramètres', 'Nb K max', nMax);
      FichierINI.WriteString('Paramètres', 'Centrale', EditCentrale.Text);
      FichierINI.WriteInteger('Paramètres', 'Nb lignes max', SpinEdit.Value);
      FichierINI.EraseSection('Paramètres procédure');
      for i:=0 to Pred(_ListeParametres.Count) do
         FichierINI.WriteString('Paramètres procédure', IntToStr(i + 1), _ListeParametres[i].EditNom.Text + '¤' + IntToStr(_ListeParametres[i].ComboBoxType.ItemIndex) + '¤' + IfThen((_ListeParametres[i].ComboBoxType.ItemIndex in [TYPE_VARCHAR, TYPE_NUMERIC]), _ListeParametres[i].EditTaille.Text));
   finally
      FichierINI.Free;
   end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
   _ListeParametres.Free;
end;

end.

