unit Main_Frm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation,

  System.Threading, System.SyncObjs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.IBDef, FireDAC.Phys.IBBase,
  FireDAC.Phys.IB, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FireDAC.Comp.DataSet, FMX.ListView,
  System.ImageList, FMX.ImgList, FMX.Layouts, FMX.ScrollBox, FMX.Memo,
  FMX.ListBox, FMX.Objects, System.Actions, FMX.ActnList, System.Sensors,
  System.Sensors.Components,

  uKernel, FMX.Menus;

type
  TFrm_Main = class(TForm)
    FDConnection: TFDConnection;
    FDQuery: TFDQuery;
    StyleBook: TStyleBook;
    VBox_Main: TVertScrollBox;
    Lay_DatabaseBloc: TLayout;
    Lab_DatabaseHeader: TLabel;
    Lay_ConfigurationBloc: TLayout;
    Lab_ProcessHeader: TLabel;
    Lay_ShopsBloc: TLayout;
    Lab_ShopsHeader: TLabel;
    Lv_Shops: TListView;
    Lay_FileBloc: TLayout;
    Lab_FileHeader: TLabel;
    Lay_ProcessKind: TLayout;
    Lay_Database: TLayout;
    Btn_DatabaseConnect: TButton;
    Edt_DatabasePath: TEdit;
    EBtn_PromptForDatabase: TEllipsesEditButton;
    Rb_ProcessCreate: TRadioButton;
    Rb_ProcessFill: TRadioButton;
    Cb_ProcessStockCalculation: TCheckBox;
    Lb_Log: TListBox;
    Lay_ProcessBloc: TLayout;
    Btn_ProcessRun: TButton;
    Lab_ProcessStep: TLabel;
    Lay_File: TLayout;
    Edt_FilePath: TEdit;
    EBtn_PromptForFile: TEllipsesEditButton;
    Btn_FileCheckRights: TButton;
    ActionList: TActionList;
    Ax_Run: TAction;
    Ax_Connect: TAction;
    Ax_CheckFile: TAction;
    Ax_PromptForDatabase: TAction;
    Ax_PromptForFile: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Lv_ShopsChange(Sender: TObject);
    procedure Cb_ProcessStockCalculationChange(Sender: TObject);
    procedure Ax_RunUpdate(Sender: TObject);
    procedure Ax_RunExecute(Sender: TObject);
    procedure Ax_ConnectExecute(Sender: TObject);
    procedure Ax_CheckFileExecute(Sender: TObject);
    procedure Ax_PromptForDatabaseExecute(Sender: TObject);
    procedure Ax_PromptForFileExecute(Sender: TObject);
  private
    CheckAll: Boolean;
    BarCodeManager: TBarCodeManager;

    function CheckedShopsID: TArray<Integer>;
    procedure DoManageParameters;
    procedure DoLog(const Text: string); overload;
    procedure DoLog(const Format: string; const Args: array of const); overload;

    procedure ListCheckedShops;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

{$R *.fmx}

uses UVersion;

procedure TFrm_Main.Ax_CheckFileExecute(Sender: TObject);
var
  Task: ITask;
begin
  TAction(Sender).Enabled := False;
  Lay_FileBloc.Enabled := False;

  Task := TTask.Create(
    procedure
    begin
      try
        {$REGION 'Vérification des droits'}
        DoLog('Contrôle des droits de lecture/écriture...');
        try
          if BarCodeManager.CanCreateOrReadAndWrite(Edt_FilePath.Text) then
            BarCodeManager.FileName := Edt_FilePath.Text;
          DoLog('Contrôle effectué avec succès');
        except
          DoLog('Contrôles echoué');
        end;
        {$ENDREGION}
      finally
        Lay_FileBloc.Enabled := True;
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
  TAction(Sender).Enabled := True;
  Invalidate;
end;

procedure TFrm_Main.Ax_ConnectExecute(Sender: TObject);
var
  Task: ITask;
begin
  TAction(Sender).Enabled := False;
  Lay_DatabaseBloc.Enabled := False;
  Cb_ProcessStockCalculation.Enabled := False;
  Lay_ShopsBloc.Enabled := False;

  Task := TTask.Create(
    procedure
    var
      Shops: TBarCodeManager.TShops;
      Count, I: Integer;
      ListViewItem: TListViewItem;
      DelayedStock: TBarCodeManager.TDelayedStock;
    begin
      try
        try
          {$REGION 'Connexion'}
          DoLog('Connexion à la base de données...');
          try
            Lv_Shops.Items.Clear;
            BarCodeManager.Connect(Edt_DatabasePath.Text);
            DoLog('Connexion établie');
          except
            DoLog('Connexion échouée');
            raise;
          end;
          {$ENDREGION}
          {$REGION 'Liste des magasins'}
          DoLog('Récupération de la liste des magasins...');
          try
            BarCodeManager.ListShops(Shops);
            try
              Lv_Shops.BeginUpdate;
              try
                Count := Pred(Shops.Count);
                for I := 0 to Count do
                begin
                  ListViewItem := Lv_Shops.Items.Add;
                  ListViewItem.Text := Shops[I].Name;
                  ListviewItem.Detail := Shops[I].ID.ToString;
                  ListviewItem.Checked := CheckAll;
                end;
              finally
                Lv_Shops.EndUpdate;
              end;
            finally
              Shops.Free;
            end;
            DoLog('Récupération des magasins réussie');
            Lay_ShopsBloc.Enabled := True;
          except
            DoLog('Récupération des magasins échouée');
          end;
          {$ENDREGION}
          {$REGION 'Vérification du stock'}
          DoLog('Vérification du stock');
          try
            Cb_ProcessStockCalculation.Enabled := False;
            BarCodeManager.DelayedStock(DelayedStock);
            try
              Cb_ProcessStockCalculation.Enabled := DelayedStock.State = dssEnabled;
              Cb_ProcessStockCalculation.IsChecked := DelayedStock.Count > 0;
              DoLog('Vérification réussie');
            finally
              DelayedStock.Free;
            end;
          except
            DoLog('Vérification échouée');
          end;
          {$ENDREGION}
        except
        end;
      finally
        Lay_DatabaseBloc.Enabled := True;
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
  TAction(Sender).Enabled := True;
  Invalidate;
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
      TOpenOption.ofFileMustExist, TOpenOption.ofDontAddToRecent,
      TOpenOption.ofForceShowHidden];
    OpenDialog.Title := 'Sélectionner un fichier code-barres ISF...';
    OpenDialog.Filter := 'Fichiers code-barre ISF.BARCODES.CSV|isf.barcodes.csv|Fichiers CSV (*.csv)|*.csv|Tous les fichiers (*.*)|*.*';
    OpenDialog.DefaultExt := 'isf.barcodes.csv';

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
  Lay_ProcessBloc.Enabled := False;
  Lay_ConfigurationBloc.Enabled := False;
  Lay_ShopsBloc.Enabled := False;
  Lay_DatabaseBloc.Enabled := False;
  Lay_FileBloc.Enabled := False;

  Task := TTask.Create(
    procedure
    begin
      try
        DoLog('Démarrage du traitement...');
        try
          BarCodeManager.Database := Edt_DatabasePath.Text;
          BarCodeManager.FileName := Edt_FilePath.Text;
          BarCodeManager.ShopsID := CheckedShopsID;

          if Cb_ProcessStockCalculation.IsChecked then
            BarCodeManager.ExecuteStockCalculation();

          if Rb_ProcessCreate.IsChecked then
            BarCodeManager.ExecuteCreate
          else
            BarCodeManager.ExecuteComplete;
          DoLog('Traitement réussi');
        except
          DoLog('Traitement échoué');
        end;
      finally
        Lay_FileBloc.Enabled := True;
        Lay_DatabaseBloc.Enabled := True;
        Lay_ShopsBloc.Enabled := True;
        Lay_ConfigurationBloc.Enabled := True;
        Lay_ProcessBloc.Enabled := True;
      end
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
  TAction(Sender).Enabled := True;
  Invalidate;
end;

procedure TFrm_Main.Ax_RunUpdate(Sender: TObject);
begin
  Ax_Run.Enabled := (BarCodeManager.FileName <> '') and
                    (BarCodeManager.Connected) and
                    (Lv_Shops.Items.CheckedCount(True) > 0);
end;

procedure TFrm_Main.Cb_ProcessStockCalculationChange(Sender: TObject);
begin
  if Cb_ProcessStockCalculation.IsChecked then
    DoLog('Recalcul des stocks actif')
  else
    DoLog('Recalcul des stocks inactif');
end;

function TFrm_Main.CheckedShopsID: TArray<Integer>;
var
  I: Integer;
begin
  Result := Lv_Shops.Items.CheckedIndexes(True);
  for I := Low(Result) to High(Result) do
    Result[I] := Lv_Shops.Items[Result[I]].Detail.ToInteger;
end;

procedure TFrm_Main.DoLog(const Text: string);
var
  DateTimeStr: string;
  ListBoxItem: TListBoxItem;
begin
  Lb_Log.BeginUpdate;
  try                   
    Lab_ProcessStep.Text := Text;

    ListBoxItem := TListBoxItem.Create(Lb_Log);  
    DateTimeToString(DateTimeStr, 'yyy-mm-dd hh:nn:ss (zzz)', Now);
    ListBoxItem.Text := DateTimeStr + ': ' + Text;
    ListBoxItem.Selectable := False;
    Lb_Log.AddObject(ListBoxItem);
  finally
    Lb_Log.EndUpdate;
  end;
  Lb_Log.ScrollToItem(ListBoxItem);
end;

procedure TFrm_Main.DoLog(const Format: string; const Args: array of const);
begin
  DoLog(System.SysUtils.Format(Format, Args));
end;

procedure TFrm_Main.DoManageParameters;
var
  Value: string;
begin
  if FindCmdLineSwitch('database', Value) or FindCmdLineSwitch('d', Value) then
    Edt_DatabasePath.Text := Value;
  if FindCmdLineSwitch('file', Value) or FindCmdLineSwitch('f', Value) then
    Edt_FilePath.Text := Value;
    
  Rb_ProcessCreate.IsChecked := FindCmdLineSwitch('create', True) and (not FindCmdLineSwitch('fill', True));
  Rb_ProcessFill.IsChecked := FindCmdLineSwitch('fill', True) and (not FindCmdLineSwitch('create', True));
  Cb_ProcessStockCalculation.IsChecked := FindCmdLineSwitch('stock', True);
  CheckAll := FindCmdLineSwitch('checkall', True);
end;

procedure TFrm_Main.ListCheckedShops;
var
  CheckedIndexes: TArray<Integer>;
  StringList: TStringList;
  I: Integer;
begin
  CheckedIndexes := Lv_Shops.Items.CheckedIndexes(True);

  StringList := TStringList.Create;
  try
    StringList.StrictDelimiter := True;
    StringList.Delimiter := ',';
    for I in CheckedIndexes do
//      StringList.Add(Lv_Shops.Items[I].Detail);
//      StringList.Add(Lv_Shops.Items[I].Text);
      StringList.Add(Format('%s (%s)', [Lv_Shops.Items[I].Text, Lv_Shops.Items[I].Detail]));
    case Length(CheckedIndexes) of
      0:
        DoLog('Veuillez sélectionner au moins un magasin');
      1:
        DoLog('Magasin sélectionné: %s', [StringList.DelimitedText]);
      else
        DoLog('Magasins sélectionnés: %s', [StringList.DelimitedText]);
    end;

  finally
    StringList.Free;
  end;
end;

procedure TFrm_Main.Lv_ShopsChange(Sender: TObject);
begin
  ListCheckedShops;
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
var
  VersionStr: string;
begin
  VersionStr := {$IFDEF DEBUG}GetAppVersion{$ELSE}GetAppVersion([vfMajor, vfMinor, vfRelease]){$ENDIF};
  Caption := Format('%s (%s)', [Caption, VersionStr]);
  DoLog('Démarrage de l''application');
  DoLog('Version: %s', [VersionStr]);

  BarCodeManager := TBarCodeManager.Create;
  DoManageParameters;
end;

procedure TFrm_Main.FormDestroy(Sender: TObject);
begin
  BarCodeManager.Free;
end;

end.
