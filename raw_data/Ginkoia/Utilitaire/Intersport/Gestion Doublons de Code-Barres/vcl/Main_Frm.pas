unit Main_Frm;

interface

uses
  System.Classes, System.Actions, System.SysUtils, Winapi.Messages,
  Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uKernel;

type
  TFrm_Main = class(TForm)
    Lab_DatabaseHeader: TLabel;
    Btn_DatabaseConnect: TButton;
    Lab_ShopsHeader: TLabel;
    Lv_Shops: TListView;
    Lab_FileHeader: TLabel;
    Btn_FileCheckRights: TButton;
    Lab_ProcessHeader: TLabel;
    Rb_ProcessCreate: TRadioButton;
    Rb_ProcessFill: TRadioButton;
    Cb_ProcessStockCalculation: TCheckBox;
    Btn_ProcessRun: TButton;
    ActionManager: TActionManager;
    Edt_DatabasePath: TEdit;
    Edt_FilePath: TEdit;
    Ax_Run: TAction;
    Ax_Connect: TAction;
    Ax_CheckFile: TAction;
    Ax_PromptForDatabase: TAction;
    Ax_PromptForFile: TAction;
    Cb_FilteredFile: TCheckBox;
    Lv_Log: TListView;
    Lab_LogHeader: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Cb_ProcessStockCalculationClick(Sender: TObject);
    procedure Ax_RunUpdate(Sender: TObject);
    procedure Ax_ConnectExecute(Sender: TObject);
    procedure Ax_CheckFileExecute(Sender: TObject);
    procedure Lv_ShopsItemChecked(Sender: TObject; Item: TListItem);
    procedure Ax_PromptForDatabaseExecute(Sender: TObject);
    procedure Ax_PromptForFileExecute(Sender: TObject);
    procedure Edt_DatabasePathDblClick(Sender: TObject);
    procedure Edt_FilePathDblClick(Sender: TObject);
    procedure Ax_RunExecute(Sender: TObject);
    procedure Ax_ConnectUpdate(Sender: TObject);
    procedure Ax_CheckFileUpdate(Sender: TObject);
    procedure Cb_FilteredFileClick(Sender: TObject);
    procedure ProcessKindClick(Sender: TObject);
  private
    Log: TFileStream;
    CheckAll: Boolean;
    BarCodeManager: TBarCodeManager;

    function CheckedShopsID: TArray<Integer>;
    procedure DoManageParameters;
    procedure DoLog(const Text: string; TimeStamp: Boolean = True); overload;
    procedure DoLog(const Format: string; const Args: array of const;
      TimeStamp: Boolean = True); overload;
    function IsSelectedShop: Boolean;
    function CreateOrOpenLog: TFileStream;
    procedure WriteToLog(const Text: string);
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

{$R *.dfm}

uses uVersion, System.Threading;

procedure TFrm_Main.Ax_CheckFileExecute(Sender: TObject);
var
  Task: ITask;
begin
  TAction(Sender).Enabled := False;

  Edt_FilePath.Enabled := False;
  try
    Task := TTask.Create(
      procedure
      begin
        {$REGION 'Vérification des droits'}
        DoLog('Contrôle des droits de lecture/écriture du fichier %s...', [Edt_FilePath.Text]);
        try
          if BarCodeManager.CanCreateOrReadAndWrite(Edt_FilePath.Text) then
            BarCodeManager.FileName := Edt_FilePath.Text;
          DoLog('Contrôle effectué avec succès');
        except
          on E: Exception do
          begin
            DoLog('Contrôle echoué');
            DoLog(E.Message, False);
          end;
        end;
        {$ENDREGION}
      end
    );

    repeat
      case Task.Status of
        TTaskStatus.Created: Task.Start;
        TTaskStatus.WaitingToRun: ;
        TTaskStatus.Running: ;
        TTaskStatus.Completed: ;
        TTaskStatus.WaitingForChildren: ;
        TTaskStatus.Canceled: ;
        TTaskStatus.Exception: ;
      end;
      Application.ProcessMessages;
    until Task.Status = TTaskStatus.Completed;
  finally
    Edt_FilePath.Enabled := True;

    TAction(Sender).Enabled := True;
  end;
end;

procedure TFrm_Main.Ax_CheckFileUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Trim(Edt_FilePath.Text) <> '';
end;

procedure TFrm_Main.Ax_ConnectExecute(Sender: TObject);
var
  Task: ITask;
begin
  TAction(Sender).Enabled := False;

  Edt_DatabasePath.Enabled := False;
  Lv_Shops.Enabled := False;
  try
    Task := TTask.Create(
      procedure
      var
        Shops: TBarCodeManager.TShops;
        I: Integer;
        ListItem: TListItem;
        DelayedStock: TBarCodeManager.TDelayedStock;
      begin
        try
          {$REGION 'Connexion'}
          DoLog('Connexion à la base de données %s...', [Edt_DatabasePath.Text]);
          try
            Lv_Shops.Clear;
            BarCodeManager.Connect(Edt_DatabasePath.Text);
            DoLog('Connexion établie');
          except
            on E: Exception do
            begin
              DoLog('Connexion échouée');
              DoLog(E.Message, False);
              raise;
            end;
          end;
          {$ENDREGION}
          {$REGION 'Liste des magasins'}
          DoLog('Récupération de la liste des magasins...');
          try
            BarCodeManager.ListShops(Shops);
            try
              Lv_Shops.Items.BeginUpdate;
              try
                for I := 0 to Pred(Shops.Count) do
                begin
                  ListItem := Lv_Shops.Items.Add;
                  ListItem.Caption := Shops[I].Name;
                  ListItem.GroupID := Shops[I].ID;
                  ListItem.Checked := CheckAll;
                end;
              finally
                Lv_Shops.Items.EndUpdate;
              end;
            finally
              Shops.Free;
            end;
            DoLog('Récupération des magasins réussie');
          except
            on E: Exception do
            begin
              DoLog('Récupération des magasins échouée');
              DoLog(E.Message, False);
            end;
          end;
          {$ENDREGION}
          {$REGION 'Vérirication du stock'}
          DoLog('Vérification du stock');
          try
            Cb_ProcessStockCalculation.Enabled := False;
            BarCodeManager.DelayedStock(DelayedStock);
            try
              Cb_ProcessStockCalculation.Enabled := DelayedStock.State = dssEnabled;
              Cb_ProcessStockCalculation.Checked := DelayedStock.Count > 0;
              DoLog('Vérification réussie');
            finally
              DelayedStock.Free;
            end;
          except
            on E: Exception do
            begin
              DoLog('Vérification échouée');
              DoLog(E.Message, False);
            end;
          end;
          {$ENDREGION}
        except
        end;
      end
    );

    repeat
      case Task.Status of
        TTaskStatus.Created: Task.Start;
        TTaskStatus.WaitingToRun: ;
        TTaskStatus.Running: ;
        TTaskStatus.Completed: ;
        TTaskStatus.WaitingForChildren: ;
        TTaskStatus.Canceled: ;
        TTaskStatus.Exception: ;
      end;
      Application.ProcessMessages;
    until Task.Status = TTaskStatus.Completed;
  finally
    Edt_DatabasePath.Enabled := True;
    Lv_Shops.Enabled := True;

    TAction(Sender).Enabled := True;
  end;
end;

procedure TFrm_Main.Ax_ConnectUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Trim(Edt_DatabasePath.Text) <> '';
end;

procedure TFrm_Main.Ax_PromptForDatabaseExecute(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Options := [TOpenOption.ofHideReadOnly,
      TOpenOption.ofExtensionDifferent, TOpenOption.ofPathMustExist,
      TOpenOption.ofFileMustExist, TOpenOption.ofDontAddToRecent,
      TOpenOption.ofForceShowHidden];
    OpenDialog.Title := 'Sélectionner une base de données Interbase...';
    OpenDialog.Filter := 'Base de données Interbase (*.ib; *.gdb)|*.ib; *.gdb|Tous les fichiers (*.*)|*.*';
    OpenDialog.DefaultExt := '*.ib; *.gdb';

    if not OpenDialog.Execute then
      Exit;

    Edt_DatabasePath.Text := OpenDialog.FileName;
  finally
    OpenDialog.Free;
  end;
end;

procedure TFrm_Main.Ax_PromptForFileExecute(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Options := [TOpenOption.ofHideReadOnly,
      TOpenOption.ofExtensionDifferent, TOpenOption.ofPathMustExist,
      TOpenOption.ofFileMustExist, TOpenOption.ofCreatePrompt,
      TOpenOption.ofDontAddToRecent, TOpenOption.ofForceShowHidden];
    OpenDialog.Title := 'Sélectionner un fichier code-barres ISF...';
    OpenDialog.Filter := 'Fichiers code-barre ISF.BARCODES.CSV|*.isf.barcodes.csv|Fichiers CSV (*.csv)|*.csv|Tous les fichiers (*.*)|*.*';
    OpenDialog.DefaultExt := '*.isf.barcodes.csv';

    if not OpenDialog.Execute then
      Exit;

    Edt_FilePath.Text := OpenDialog.FileName;
  finally
    OpenDialog.Free;
  end;
end;

procedure TFrm_Main.Ax_RunExecute(Sender: TObject);
var
  Task: ITask;
begin
  TAction(Sender).Enabled := False;

  Edt_DatabasePath.Enabled := False;
  Btn_DatabaseConnect.Enabled := False;
  Lv_Shops.Enabled := False;
  Edt_FilePath.Enabled := False;
  Btn_FileCheckRights.Enabled := False;
  Rb_ProcessCreate.Enabled := False;
  Rb_ProcessFill.Enabled := False;
  Cb_FilteredFile.Enabled := False;
  Cb_ProcessStockCalculation.Enabled := False;
  try
    Task := TTask.Create(
      procedure
      begin
        DoLog('Démarrage du traitement...');
        try
          BarCodeManager.Database := Edt_DatabasePath.Text;
          BarCodeManager.FileName := Edt_FilePath.Text;
          BarCodeManager.ShopsID := CheckedShopsID;

          if Cb_ProcessStockCalculation.Checked then
            BarCodeManager.ExecuteStockCalculation();

          if Rb_ProcessCreate.Checked then
            BarCodeManager.ExecuteCreate
          else
            BarCodeManager.ExecuteComplete(Cb_FilteredFile.Checked);
          DoLog('Traitement réussi');
        except
          on E: Exception do
          begin
            DoLog('Traitement échoué');
            DoLog(E.Message, False);
          end;
        end;
      end
    );
    repeat
      case Task.Status of
        TTaskStatus.Created: Task.Start;
        TTaskStatus.WaitingToRun: ;
        TTaskStatus.Running: ;
        TTaskStatus.Completed: ;
        TTaskStatus.WaitingForChildren: ;
        TTaskStatus.Canceled: ;
        TTaskStatus.Exception: ;
      end;
      Application.ProcessMessages;
    until Task.Status = TTaskStatus.Completed;
  finally
    Edt_DatabasePath.Enabled := True;
    Btn_DatabaseConnect.Enabled := True;
    Lv_Shops.Enabled := True;
    Edt_FilePath.Enabled := True;
    Btn_FileCheckRights.Enabled := True;
    Rb_ProcessCreate.Enabled := True;
    Rb_ProcessFill.Enabled := True;
    Cb_FilteredFile.Enabled := True;
    Cb_ProcessStockCalculation.Enabled := True;

    TAction(Sender).Enabled := True;
  end;
end;

procedure TFrm_Main.Ax_RunUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (BarCodeManager.FileName <> '') and                   // Fichier validé
    (BarCodeManager.Connected) and                        // Base de données connectée
    (IsSelectedShop) and                                  // Au moins un magasin sélectionné
    (Rb_ProcessCreate.Checked or Rb_ProcessFill.Checked); // Type de traitement sélectionné
end;

procedure TFrm_Main.Cb_FilteredFileClick(Sender: TObject);
begin
  if Cb_FilteredFile.Checked then
    DoLog('Traitement: Complétion filtrée ')
  else
    DoLog('Traitement: Complétion brute');
end;

procedure TFrm_Main.Cb_ProcessStockCalculationClick(Sender: TObject);
begin
  if Cb_ProcessStockCalculation.Checked then
    DoLog('Recalcul des stocks actif')
  else
    DoLog('Recalcul des stocks inactif');
end;

function TFrm_Main.CheckedShopsID: TArray<Integer>;
var
  Count, I, Index: Integer;
begin
  // Récupération du nombre de magasin sélectionné
  Count := 0;
  for I := 0 to Pred(Lv_Shops.Items.Count) do
    if Lv_Shops.Items[I].Checked then
      Inc(Count);

  // Génération du tableau de retour
  SetLength(Result, Count);
  Index := 0;
  for I := 0 to Pred(Lv_Shops.Items.Count) do
    if Lv_Shops.Items[I].Checked then
    begin
      Result[Index] := Lv_Shops.Items[I].GroupID;
      Inc(Index);
      if Index = Count then
        Break;
    end;
end;

function TFrm_Main.CreateOrOpenLog: TFileStream;
var
  DateTimeStr: string;
  FileName: TFileName;
  FileMode: Word;
begin
  DateTimeToString(DateTimeStr, 'yyyy-mm-dd_hh-nn-ss-zzz', Now);
  FileName := ChangeFileExt(ParamStr(0), '_' + DateTimeStr + '.log');

  if FileExists(FileName) then
    FileMode := fmOpenWrite
  else
    FileMode := fmCreate;

  Result := TFileStream.Create(FileName, FileMode or fmShareDenyWrite);
  Result.Seek(0, TSeekOrigin.soEnd);
end;

procedure TFrm_Main.DoLog(const Text: string; TimeStamp: Boolean);
const
  DateTimeFormat = 'yyyy-mm-dd hh:nn:ss (zzz)';
var
  StringList: TStringList;
  I: Integer;
  DateTimeStr, FormatedText: string;
  ListItem: TListItem;
begin
  StringList := TStringList.Create;
  try
    StringList.Text := Text;
    for I := 0 to Pred(StringList.Count) do
    begin
      if Lv_Log.Items.Count > 0 then
        FormatedText := #13#10;

      ListItem := Lv_Log.Items.Add;
      ListItem.MakeVisible(False);

      if TimeStamp then
      begin
        DateTimeToString(DateTimeStr, DateTimeFormat, Now);
        ListItem.Caption := DateTimeStr;
        FormatedText := FormatedText + DateTimeStr;
      end
      else
        FormatedText := FormatedText + StringOfChar(' ', 25);

      ListItem.SubItems.Add(StringList[I]);
      Lv_Log.Columns[0].Width := -2;
      Lv_Log.Columns[1].Width := -2;

      FormatedText := FormatedText + #9 + StringList[I];

      WriteToLog(FormatedText);
    end;
  finally
    StringList.Free;
  end;
end;

procedure TFrm_Main.DoLog(const Format: string; const Args: array of const;
  TimeStamp: Boolean);
begin
  DoLog(System.SysUtils.Format(Format, Args), TimeStamp);
end;

procedure TFrm_Main.DoManageParameters;
var
  Value: string;
begin
  if FindCmdLineSwitch('database', Value) or FindCmdLineSwitch('d', Value) then
    Edt_DatabasePath.Text := Value;
  if FindCmdLineSwitch('file', Value) or FindCmdLineSwitch('f', Value) then
    Edt_FilePath.Text := Value;

  Rb_ProcessCreate.Checked := FindCmdLineSwitch('create', True) and (not FindCmdLineSwitch('fill', True));
  Rb_ProcessFill.Checked := FindCmdLineSwitch('fill', True) and (not FindCmdLineSwitch('create', True));
  Cb_ProcessStockCalculation.Checked := FindCmdLineSwitch('stock', True);
  Cb_FilteredFile.Checked := FindCmdLineSwitch('custom', True);
  CheckAll := FindCmdLineSwitch('checkall', True);
end;

procedure TFrm_Main.Edt_DatabasePathDblClick(Sender: TObject);
begin
  Ax_PromptForDatabase.Execute;
end;

procedure TFrm_Main.Edt_FilePathDblClick(Sender: TObject);
begin
  Ax_PromptForFile.Execute;
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
var
  VersionStr: string;
  StringList: TStringList;
  I: Integer;
begin
  Log := CreateOrOpenLog;

  VersionStr := {$IFDEF DEBUG}GetAppVersion{$ELSE}GetAppVersion([vfMajor, vfMinor, vfRelease]){$ENDIF};
  Caption := Format('%s (%s)', [Caption, VersionStr]);
  DoLog('Démarrage de l''application');
  DoLog('Version: %s', [VersionStr]);

  {$REGION 'Default UI'}
  Cb_ProcessStockCalculation.Enabled := False;
  Cb_FilteredFile.Enabled := False;
  {$ENDREGION}

  BarCodeManager := TBarCodeManager.Create;

  if ParamCount > 1 then
  begin
    StringList := TStringList.Create;
    try
      StringList.Delimiter := ' ';
      StringList.StrictDelimiter := True;
      for I := 1 to ParamCount do
        StringList.Add(ParamStr(I));
      DoLog('Paramètres: %s', [StringList.DelimitedText]);
    finally
      StringList.Free;
    end;
    DoManageParameters;
  end;
end;

procedure TFrm_Main.FormDestroy(Sender: TObject);
begin
  BarCodeManager.Free;
  DoLog('Fermeture de l''application');
  Log.Free;
end;

function TFrm_Main.IsSelectedShop: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Pred(Lv_Shops.Items.Count) do
    if Lv_Shops.Items[I].Checked then
      Exit(True);
end;

procedure TFrm_Main.Lv_ShopsItemChecked(Sender: TObject; Item: TListItem);
begin
  if Item.GroupID < 0 then
    Exit;

  if Item.Checked then
    DoLog('Magasin sélectionné: %s (%d)', [Item.Caption, Item.GroupID])
  else
    DoLog('Magasin désélectionné: %s (%d)', [Item.Caption, Item.GroupID]);
end;

procedure TFrm_Main.ProcessKindClick(Sender: TObject);
begin
  if Sender = Rb_ProcessCreate then
    DoLog('Traitement: Génération du fichier avec les codes-barres de la base d''origine')
  else
    if Sender = Rb_ProcessFill then
      DoLog('Traitement: Complétion du fichier en fonction des codes-barres de la base de destination');

  Cb_FilteredFile.Enabled := Rb_ProcessFill.Checked;
end;

procedure TFrm_Main.WriteToLog(const Text: string);
var
  StreamWriter: TStreamWriter;
begin
  StreamWriter := TStreamWriter.Create(Log, TEncoding.UTF8);
  try
    StreamWriter.Write(Text);
  finally
    StreamWriter.Free;
  end;
end;

end.
