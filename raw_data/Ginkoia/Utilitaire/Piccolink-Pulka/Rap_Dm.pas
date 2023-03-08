//------------------------------------------------------------------------------
// Nom de l'unité : Rap_Dm
// Rôle           : Utilisation de Report Builder RAP
// Auteur         : Sylvain GHEROLD
// Historique     :
// 12/02/2001 - Sylvain GHEROLD - v 1.1.0 : Modif. Initialisation
// 26/12/2000 - Sylvain GHEROLD - v 1.0.0 : Création
//------------------------------------------------------------------------------

unit Rap_Dm;

interface

uses
  Windows,
  graphics,
  SysUtils,
  Classes,
  Forms,
  Dialogs,
  StrHlder,
  IB_Components,
  IBOPipelineUnit,
  ppDB,
  ppBands,
  ppCache,
  ppClass,
  ppProd,
  ppReport,
  ppRptExp,
  ppEndUsr,
  ppComm,
  ppRelatv,
  ppDBPipe,
  ppDsgnDB,
  ppTypes,
  ppArchiv,
  ppModule,
  ppRTTI,
  ppCTDsgn,
  ppCTMain,
  ppCtrls,
  daIDE,
  daDataModule,
  daDataManager,
  daIBO,
  daDataDictionaryBuilder,
  daSQL,
  daQueryDataView,
  daPreviewDataDlg,
  raIDE,
  raFunc,
  raCodMod,
  TxtraDev,
  TxComp,

  // Composants AddOnRBuilder
  BuilderControls,
  TdArrow,
  MyChkBox,
  SgBorder;
  
type
  TDm_Rap = class( TDataModule )
    IbQ_Folder: TIB_Query;
    IbQ_Item: TIB_Query;
    IbQ_Table: TIB_Query;
    IbQ_Field: TIB_Query;
    IbQ_Join: TIB_Query;

    DS_Folder: TIB_DataSource;
    DS_Item: TIB_DataSource;
    DS_Table: TIB_DataSource;
    DS_Field: TIB_DataSource;
    DS_Join: TIB_DataSource;

    Pip_Folder: TppIBOPipeline;
    Pip_Item: TppIBOPipeline;
    Pip_Table: TppIBOPipeline;
    Pip_Field: TppIBOPipeline;
    Pip_Join: TppIBOPipeline;

    Ppr_Main: TppReport;
    ppDesign_Main: TppDesigner;
    ppRExpl_Main: TppReportExplorer;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    ppDico_Main: TppDataDictionary;
    ppArchRead_Main: TppArchiveReader;
    Str_ParamName: TStrHolder;
    Str_ParamValue: TStrHolder;
    ExtraDev_Options: TExtraOptions;

    procedure IbQ_FolderUpdateRecord( DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction );
    procedure IbQ_FolderNewRecord( IB_Dataset: TIB_DataSet );
    procedure IbQ_FolderAfterPost( IB_Dataset: TIB_Dataset );

    procedure IbQ_ItemUpdateRecord( DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction );
    procedure IbQ_ItemNewRecord( IB_Dataset: TIB_Dataset );
    procedure IbQ_ItemAfterPost( IB_Dataset: TIB_Dataset );

    procedure IbQ_TableUpdateRecord( DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction );
    procedure IbQ_TableNewRecord( IB_Dataset: TIB_Dataset );
    procedure IbQ_TableAfterPost( IB_Dataset: TIB_Dataset );

    procedure IbQ_FieldUpdateRecord( DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction );
    procedure IbQ_FieldNewRecord( IB_Dataset: TIB_Dataset );
    procedure IbQ_FieldAfterPost( IB_Dataset: TIB_Dataset );

    procedure IbQ_JoinUpdateRecord( DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction );
    procedure IbQ_JoinNewRecord( IB_Dataset: TIB_Dataset );
    procedure IbQ_JoinAfterPost( IB_Dataset: TIB_Dataset );

  private

  public
    function Initialize: Boolean;
    function ShowExplorer( ShowStandard: boolean ): Boolean;
    function ShowExplorerNoModal( ShowStandard: boolean ): Boolean;
    function GetExplorerForm : TForm;
    procedure DesignReport( RapportName: string );
    procedure Print( ShowPreview: boolean );
    function LoadReport( RapportName: string ): Boolean;
    procedure CreateAutoSearchCriteria( PipelineName, FieldName, Value: string
      );
    function GetSQLObject( var aSQL: TdaSQL; DataViewId: Integer ): Boolean;
    procedure ArchiveReport( ArchiveFileName: string );
    procedure PreviewArchivedReport( ArchiveFileName: string );
    procedure PrintArchivedReport( ArchiveFileName: string );
    procedure ShowDico;
    procedure ClearParameters;
    procedure SetParameter( ParamName, ParamValue: string );

  end;

  TRAPParamFunction = class( TraSystemFunction )
  public
    class function Category: string; override;
  end;

  TRAPGetParameterFunction = class( TRAPParamFunction )
  public
    procedure ExecuteFunction( aParams: TraParamList ); override;
    class function GetSignature: string; override;
  end;

var
  Dm_Rap            : TDm_Rap;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
ResourceString
  InfLoadingMessage = 'Veuillez patienter...';


implementation

uses
  Main_Dm,
  ConstStd;

{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

function TDm_Rap.Initialize: Boolean;
begin
  if ( Dm_Rap = nil ) then
   with CreateMessageDialog(InfLoadingMessage, mtInformation , [])
   do begin
     Font.Name := 'Verdana';
     Font.Color := $00820000;
     Font.Style := [fsBold];
     Height := Height - 40;
     Show; Repaint;
     try
      Dm_Rap := TDm_Rap.Create( Application );
      if not Dm_Main.IsKManagementActive then
        with Dm_Rap do begin
          IbQ_Folder.Close;
          IbQ_Folder.SQL.CommaText := 'SELECT * FROM RAPFOLDER';
          IbQ_Folder.JoinLinks.Clear;

          IbQ_Item.Close;
          IbQ_Item.SQL.CommaText := 'SELECT * FROM RAPITEM';
          IbQ_Item.JoinLinks.Clear;

          IbQ_Table.Close;
          IbQ_Table.SQL.CommaText := 'SELECT * FROM RAPTABLE';
          IbQ_Table.JoinLinks.Clear;

          IbQ_Field.Close;
          IbQ_Field.SQL.CommaText := 'SELECT * FROM RAPFIELD';
          IbQ_Field.JoinLinks.Clear;

          IbQ_Join.Close;
          IbQ_Join.SQL.CommaText := 'SELECT * FROM RAPJOIN';
          IbQ_Join.JoinLinks.Clear;
        end;

      daAddIBOGlobalDatabase( Dm_Main.Database );
      daAddIBOGlobalTransaction( Dm_Main.Database, Dm_Main.IbT_Select );

      Result := True;
     except
      Result := False;
      ERRMess( ErrInitRap, '' );
     end;
    Free;
  end
  else
    Result := True;
end;

function TDm_Rap.ShowExplorer( ShowStandard: boolean ): Boolean;
begin
  Result := Initialize;
  if not Result then Abort;

  with Dm_Rap do begin
    IbQ_Folder.Filtered := not ShowStandard;
    IbQ_Item.Filtered := not ShowStandard;

    if not ShowStandard then begin
      ppDesign_Main.RapInterface := [ ];
      ppDico_Main.AllowManualJoins := False;
    end
    else begin
      ppDesign_Main.RapInterface := [ riDialog, riNotebookTab ];
      ppDico_Main.AllowManualJoins := True;
    end;

    if not ppRExpl_Main.Execute then begin
      Result := False;
      ERRMESS( ppRExpl_Main.ErrorMessage, '' );
    end;

    IbQ_Folder.Filtered := False;
    IbQ_Item.Filtered := False;
  end;
end;

function TDm_Rap.ShowExplorerNoModal( ShowStandard: boolean ): Boolean;
begin
  Result := Initialize;
  if not Result then Abort;

  with Dm_Rap do begin
    IbQ_Folder.Filtered := not ShowStandard;
    IbQ_Item.Filtered := not ShowStandard;

    if not ShowStandard then begin
      ppDesign_Main.RapInterface := [ ];
      ppDico_Main.AllowManualJoins := False;
    end
    else begin
      ppDesign_Main.RapInterface := [ riDialog, riNotebookTab ];
      ppDico_Main.AllowManualJoins := True;
    end;

    try
      ppRExpl_Main.Show;
    except
      Result := False;
      ERRMESS( ppRExpl_Main.ErrorMessage, '' );
    end;

  end;
end;

function TDm_Rap.GetExplorerForm : TForm;
begin
  Result := nil;
  if ppRExpl_Main.Form<>nil then Result := ppRExpl_Main.Form;
end;


procedure TDm_Rap.DesignReport( RapportName: string );
begin
  if not Initialize then Abort;
  with Dm_Rap do begin
    Ppr_Main.Template.DatabaseSettings.Name := RapportName;
    try
      Ppr_Main.Template.LoadFromDatabase;
      ppDesign_Main.ShowModal;
    except
      ERRMess( ErrDesignReport, RapportName );
    end;
  end;
end;

procedure TDm_Rap.Print( ShowPreview: boolean );
begin
  if not Initialize then Abort;
  with Dm_Rap do begin
    if ShowPreview then
      Ppr_Main.DeviceType := dtScreen
    else
      Ppr_Main.DeviceType := dtPrinter;
    Ppr_Main.Print;
  end;
end;

function TDm_Rap.LoadReport( RapportName: string ): Boolean;
var
  MemFilter : Boolean;
begin
  Result := Initialize;
  with Dm_Rap do begin
    if not Result then Abort;

    MemFilter := IbQ_Folder.Filtered;
    IbQ_Folder.Filtered := False;
    IbQ_Item.Filtered := False;

    Ppr_Main.Template.DatabaseSettings.Name := RapportName;
    if Ppr_Main.AutoSearchFieldCount > 0 then Ppr_Main.FreeAutoSearchFields;
    try
      Ppr_Main.Template.LoadFromDatabase;
      ClearParameters;
    except
      ERRMess( ErrLoadReport, RapportName );
      Result := False;
    end;

    IbQ_Folder.Filtered := MemFilter;
    IbQ_Item.Filtered := MemFilter;

  end;
end;

procedure TDm_Rap.CreateAutoSearchCriteria( PipelineName, FieldName, Value:
  string );
begin
  if Dm_Rap <> nil then
    with Dm_Rap do begin
      Ppr_Main.CreateAutoSearchCriteria( PipelineName, FieldName, soLike,
        Value, True );
    end;
end;

function TDm_Rap.GetSQLObject( var aSQL: TdaSQL; DataViewId: Integer ):
  Boolean;
var
  lDataModule       : TdaDataModule;
  lDataView         : TdaDataView;
begin
  Result := False;
  if Dm_Rap <> nil then
    with Dm_Rap do begin
      aSQL := nil;
      lDataModule := daGetDataModule( Ppr_Main );
      if ( lDataModule <> nil ) then begin
        lDataView := lDataModule.DataViews[ DataViewId ];
        if ( lDataView <> nil ) and ( lDataView is TdaQueryDataView ) then
          aSQL := TdaQueryDataView( lDataView ).SQL;
      end;
      Result := ( aSQL <> nil );
    end;
end;

procedure TDm_Rap.ArchiveReport( ArchiveFileName: string );
begin
  if not Initialize then Abort;
  with Dm_Rap do begin
    Ppr_Main.ArchiveFileName := ArchiveFileName;
    Ppr_Main.AllowPrintToArchive := True;
    Ppr_Main.ShowPrintDialog := False;
    Ppr_Main.DeviceType := dtArchive;
    Ppr_Main.Print;
  end;
end;

procedure TDm_Rap.PreviewArchivedReport( ArchiveFileName: string );
begin
  if not Initialize then Abort;
  with Dm_Rap do begin
    try
      ppArchRead_Main.ArchiveFileName := ArchiveFileName;
      ppArchRead_Main.DeviceType := dtScreen;
      ppArchRead_Main.Print;
    except
      ERRMess( ErrLoadReport, ArchiveFileName );
    end;
  end;
end;

procedure TDm_Rap.PrintArchivedReport( ArchiveFileName: string );
begin
  if not Initialize then Abort;
  with Dm_Rap do begin
    try
      ppArchRead_Main.ArchiveFileName := ArchiveFileName;
      ppArchRead_Main.DeviceType := dtPrinter;
      ppArchRead_Main.Print;
    except
      ERRMess( ErrLoadReport, ArchiveFileName );
    end;
  end;
end;

procedure TDm_Rap.ShowDico;
var
  lForm             : TdaDataDictionaryBuilderForm;
begin
  lForm := nil;
  if not Initialize then Abort;
  with Dm_Rap do begin
    try
      lForm := TdaDataDictionaryBuilderForm.Create( Application );
      lForm.DataDictionary := ppDico_Main;

      if lForm.ValidSettings then
        lForm.ShowModal
      else
        ERRMess( lForm.ErrorMessage, '' );
    finally
      lForm.Free;
    end;
  end;
end;

procedure TDm_Rap.ClearParameters;
begin
  Str_ParamName.Strings.Clear;
  Str_ParamValue.Strings.Clear;
end;

procedure TDm_Rap.SetParameter( ParamName, ParamValue: string );
var
  i                 : Integer;
begin
  i := Str_ParamName.Strings.IndexOf( ParamName );
  if i <> -1 then
    Str_ParamValue.Strings[ i ] := ParamValue
  else begin
    Str_ParamName.Strings.Add( ParamName );
    Str_ParamValue.Strings.Add( ParamValue );
  end
end;

class function TRAPParamFunction.Category: string;
begin
  Result := 'Paramètres';
end;

class function TRAPGetParameterFunction.GetSignature: string;
begin
  Result := 'function GetParameter(ParamName:string): string;';
end;

procedure TRAPGetParameterFunction.ExecuteFunction( aParams: TraParamList );
var
  lsResult          : string;
  ParamName         : string;
  i                 : integer;
begin
  GetParamValue( 0, ParamName );
  i := Dm_Rap.Str_ParamName.Strings.IndexOf( ParamName );
  if i <> -1 then
    lsResult := Dm_Rap.Str_ParamValue.Strings[ i ]
  else
    lsResult := ErrParamNotDefined;

  SetParamValue( 1, lsResult );
end;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

procedure TDm_Rap.IbQ_FolderUpdateRecord( DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction );
begin
  Dm_Main.IB_UpdateRecord( 'RAPFOLDER', IbQ_Folder, UpdateKind, UpdateAction );
end;

procedure TDm_Rap.IbQ_ItemUpdateRecord( DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction );
begin
  Dm_Main.IB_UpdateRecord( 'RAPITEM', IbQ_Item, UpdateKind, UpdateAction );
end;

procedure TDm_Rap.IbQ_TableUpdateRecord( DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction );
begin
  Dm_Main.IB_UpdateRecord( 'RAPTABLE', IbQ_Table, UpdateKind, UpdateAction );
end;

procedure TDm_Rap.IbQ_FieldUpdateRecord( DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction );
begin
  Dm_Main.IB_UpdateRecord( 'RAPFIELD', IbQ_Field, UpdateKind, UpdateAction );
end;

procedure TDm_Rap.IbQ_JoinUpdateRecord( DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction );
begin
  Dm_Main.IB_UpdateRecord( 'RAPJOIN', IbQ_Join, UpdateKind, UpdateAction );
end;

procedure TDm_Rap.IbQ_FolderNewRecord( IB_Dataset: TIB_DataSet );
begin
  if not Dm_Main.IB_MajPkKey( IbQ_Folder, 'FLR_ID' ) then abort;
end;

procedure TDm_Rap.IbQ_ItemNewRecord( IB_Dataset: TIB_Dataset );
begin
  if not Dm_Main.IB_MajPkKey( IbQ_Item, 'ITM_ID' ) then abort;
end;

procedure TDm_Rap.IbQ_TableNewRecord( IB_Dataset: TIB_Dataset );
begin
  if not Dm_Main.IB_MajPkKey( IbQ_Table, 'TAB_ID' ) then abort;
end;

procedure TDm_Rap.IbQ_FieldNewRecord( IB_Dataset: TIB_Dataset );
begin
  if not Dm_Main.IB_MajPkKey( IbQ_Field, 'FLD_ID' ) then abort;
end;

procedure TDm_Rap.IbQ_JoinNewRecord( IB_Dataset: TIB_Dataset );
begin
  if not Dm_Main.IB_MajPkKey( IbQ_Join, 'JON_ID' ) then abort;
end;

procedure TDm_Rap.IbQ_FolderAfterPost( IB_Dataset: TIB_Dataset );
begin
  Dm_Main.IB_UpDateCache( IbQ_Folder );
end;

procedure TDm_Rap.IbQ_ItemAfterPost( IB_Dataset: TIB_Dataset );
begin
  Dm_Main.IB_UpDateCache( IbQ_Item );
end;

procedure TDm_Rap.IbQ_JoinAfterPost( IB_Dataset: TIB_Dataset );
begin
  Dm_Main.IB_UpDateCache( IbQ_Join );
end;

procedure TDm_Rap.IbQ_TableAfterPost( IB_Dataset: TIB_Dataset );
begin
  Dm_Main.IB_UpDateCache( IbQ_Table );
end;

procedure TDm_Rap.IbQ_FieldAfterPost( IB_Dataset: TIB_Dataset );
begin
  Dm_Main.IB_UpDateCache( IbQ_Field );
end;

initialization
  raRegisterFunction( 'GetParameter', TRAPGetParameterFunction );
finalization
  raUnRegisterFunction( 'GetParameter' );

end.

