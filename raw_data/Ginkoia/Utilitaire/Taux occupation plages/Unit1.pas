unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Buttons, Data.DB, Vcl.ComCtrls, REST.Backend.EMSServices, FireDAC.Stan.Intf, FireDAC.Stan.Option, System.Math,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.VCLUI.Wait,
  FireDAC.Phys.IBBase, FireDAC.Comp.UI, FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Backend.EMSFireDAC, System.INIFiles;

type
  TMainForm = class(TForm)
    BtnCalculer: TBitBtn;
    edBaseLocale: TEdit;
    btSelectLocalBase: TSpeedButton;
    odBaseLocale: TOpenDialog;
    Label1: TLabel;
    ListView: TListView;
    FDConnection: TFDConnection;
    FDQueryBase: TFDQuery;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDPhysIBDriverLink: TFDPhysIBDriverLink;
    FDQuery: TFDQuery;
    LabelEtape: TLabel;
    ProgressBar: TProgressBar;
    BtnExporter: TBitBtn;
    SaveDialog: TSaveDialog;

    procedure FormCreate(Sender: TObject);
    procedure btSelectLocalBaseClick(Sender: TObject);
    procedure BtnCalculerClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExporterClick(Sender: TObject);

  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
var
  FichierINI: TIniFile;
begin
  FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'TauxOccupationPlages.ini');
  try
    edBaseLocale.Text := FichierINI.ReadString('Paramètres', 'Base', '');
  finally
    FichierINI.Free;
  end;
end;

procedure TMainForm.btSelectLocalBaseClick(Sender: TObject);
begin
  if edBaseLocale.Text <> '' then
    odBaseLocale.InitialDir := ExtractFilePath(edBaseLocale.Text);

  // Sélection de la base.
  if odBaseLocale.Execute then
    edBaseLocale.Text := odBaseLocale.FileName;
end;

procedure TMainForm.BtnCalculerClick(Sender: TObject);
var
  Ligne: TListItem;
  iPlageDebut, iPlageFin, iKCourant: Int64;
  sPlage, sPlageDebut, sPlageFin: String;
begin
  if edBaseLocale.Text = '' then
    btSelectLocalBaseClick(Sender);

  btSelectLocalBase.Enabled := False;
  BtnCalculer.Enabled := False;
  ProgressBar.Position := 0;
  ProgressBar.Show;
  LabelEtape.Show;
  BtnExporter.Enabled := False;
  ListView.Clear;
  Application.ProcessMessages;
  try
    // Connexion.
    FDConnection.Close;
    FDConnection.Params.Database := edBaseLocale.Text;
    try
      FDConnection.Open;
    except
    on E: Exception do
      begin
        Application.MessageBox(PChar('Erreur :  la connexion a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;

    // Recherche des bases.
    FDQueryBase.Close;
    FDQueryBase.SQL.Clear;
    FDQueryBase.SQL.Add('select BAS_ID, BAS_IDENT, BAS_SENDER, BAS_PLAGE');
    FDQueryBase.SQL.Add('from GENBASES');
    FDQueryBase.SQL.Add('where BAS_ID <> 0');
    FDQueryBase.SQL.Add('order by BAS_ID');
    try
      FDQueryBase.Open;
    except
      on E: Exception do
      begin
        Application.MessageBox(PChar('Erreur :  la recherche des bases a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;
    if not FDQueryBase.IsEmpty then
    begin
      ProgressBar.Max := FDQueryBase.RecordCount;

      FDQueryBase.First;
      while not FDQueryBase.Eof do
      begin
        LabelEtape.Caption := 'Traitement en cours [' + FDQueryBase.FieldByName('BAS_SENDER').AsString + '] ...';
        Application.ProcessMessages;

        Ligne := ListView.Items.Add;
        Ligne.Caption := FDQueryBase.FieldByName('BAS_ID').AsString;
        Ligne.SubItems.Add(FDQueryBase.FieldByName('BAS_IDENT').AsString);
        Ligne.SubItems.Add(FDQueryBase.FieldByName('BAS_SENDER').AsString);

        // Bornes de la plage.
        iPlageDebut := -1;      iPlageFin := -1;
        sPlage := FDQueryBase.FieldByName('BAS_PLAGE').AsString;
        sPlageDebut := StringReplace(Copy(sPlage, Pos('[', sPlage) + 1, Pos('_', sPlage) - (Pos('[', sPlage) + 1)), 'M', '000000', [rfReplaceAll]);
        sPlageFin := StringReplace(Copy(sPlage, Pos('_', sPlage) + 1, Pos(']', sPlage) - (Pos('_', sPlage) + 1)), 'M', '000000', [rfReplaceAll]);
        if not TryStrToInt64(sPlageDebut, iPlageDebut) then
          iPlageDebut := -1;
        if not TryStrToInt64(sPlageFin, iPlageFin) then
          iPlageFin := -1;
        Ligne.SubItems.Add(FormatFloat(',##0', iPlageDebut));
        Ligne.SubItems.Add(FormatFloat(',##0', iPlageFin));
        Ligne.SubItems.Add(FormatFloat(',##0', RoundTo((iPlageFin - iPlageDebut) / 1000000, -2)) + ' M');

        // Recherche du K courant.
        FDQuery.Close;
        FDQuery.SQL.Clear;
        FDQuery.SQL.Add('select max(K_ID)');
        FDQuery.SQL.Add('from K');
        FDQuery.SQL.Add('where K_ID >= :BorneDebut');
        FDQuery.SQL.Add('and K_ID < :BorneFin');
        try
          FDQuery.ParamByName('BorneDebut').AsLargeInt := iPlageDebut;
          FDQuery.ParamByName('BorneFin').AsLargeInt := iPlageFin;
          FDQuery.Open;
        except
          on E: Exception do
          begin
            Application.MessageBox(PChar('Erreur :  la recherche du K courant a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
            Exit;
          end;
        end;
        if(not FDQuery.IsEmpty) and (FDQuery.Fields[0].AsLargeInt > 0) then
          iKCourant := FDQuery.Fields[0].AsLargeInt
        else
          iKCourant := iPlageDebut;
        Ligne.SubItems.Add(FormatFloat(',##0', iKCourant));

        Ligne.SubItems.Add(FloatToStr(RoundTo(100 * (iKCourant - iPlageDebut) / (iPlageFin - iPlageDebut), -3)) + ' %');
        Ligne.SubItems.Add(FormatFloat(',##0', (iPlageFin - iKCourant)));
        ProgressBar.Position := ProgressBar.Position + 1;
        Application.ProcessMessages;

        FDQueryBase.Next;
      end;
    end;
  finally
    FDConnection.Close;
    ProgressBar.Hide;
    LabelEtape.Hide;
    btSelectLocalBase.Enabled := True;
    BtnCalculer.Enabled := True;
    BtnExporter.Enabled := True;
  end;
end;

procedure TMainForm.BtnExporterClick(Sender: TObject);
var
  F: TextFile;
  sLigne: String;
  i, j: Integer;
begin
  if SaveDialog.Execute then
  begin
    // Export.
    AssignFile(F, SaveDialog.FileName);
    try
      Rewrite(F);

      // En-tête.
      sLigne := '';
      for i:=0 to Pred(ListView.Columns.Count) do
        sLigne := sLigne + ListView.Columns[i].Caption + ';';
      Writeln(F, sLigne);

      // Lignes.
      for i:=0 to Pred(ListView.Items.Count) do
      begin
        sLigne := ListView.Items[i].Caption + ';';
        for j:=0 to Pred(ListView.Items[i].SubItems.Count) do
          sLigne := sLigne + ListView.Items[i].SubItems[j] + ';';
        Writeln(F, sLigne);
      end;
    finally
      CloseFile(F);
    end;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  FichierINI: TIniFile;
begin
  FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'TauxOccupationPlages.ini');
  try
    FichierINI.WriteString('Paramètres', 'Base', edBaseLocale.Text);
  finally
    FichierINI.Free;
  end;
end;

end.

