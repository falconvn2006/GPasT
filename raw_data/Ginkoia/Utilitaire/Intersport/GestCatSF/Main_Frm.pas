unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Grids, DBGrids, RzDBGrid, IB_Components, dxmdaset,
  DB, DBClient, StdCtrls, ExtCtrls, Outline, ImgList, IB_Process, IB_Script,
  IBODataset, IB_Access;

type
  TFrm_Main = class(TForm)
    GrpPan_Info: TGridPanel;
    Ds_CSV: TDataSource;
    MemD_CSV: TdxMemData;
    DB: TIB_Connection;
    Img_ValidDB: TImage;
    Lab_DBPath: TLabel;
    Chp_DBPath: TEdit;
    Btn_DBPath: TButton;
    Img_ValidCSV: TImage;
    Lab_CSVPath: TLabel;
    Chp_CSVPath: TEdit;
    Btn_CSVPath: TButton;
    Imgl_State: TImageList;
    MemD_CSVCodeFedas: TStringField;
    MemD_CSVCategorie: TStringField;
    GridPanel1: TGridPanel;
    Btn_StartProcess: TButton;
    Pb_Process: TProgressBar;
    Dbg_CSV: TRzDBGrid;
    Transaction: TIB_Transaction;
    IBS_Create: TIB_Script;
    IBS_Destroy: TIB_Script;
    SP: TIB_StoredProc;
    MemD_CSVState: TStringField;
    procedure DBPathChange(const ASender: TObject);
    procedure DBPathBrowse(const ASender: TObject);
    procedure CSVPathChange(const ASender: TObject);
    procedure CSVPathBrowse(const ASender: TObject);
    procedure CSVLoad(const AFilename: String );
    procedure FormCreate(Sender: TObject);
    procedure StartProcess(const ASender: TObject);
    procedure Dbg_CSVKeyPress(Sender: TObject; var Key: Char);
    procedure CheckFields;
  private
    { Déclarations privées }
    DB_Valid, CSV_Valid: Boolean;
    function IsDBReady(const AFilename: String; const AUsername: String = 'sysdba'; const APassword: String = 'masterkey' ): Boolean;
    function  CreateSP(const ADatabase: TIB_Connection): Boolean;
    function  DestroySP(const ADatabase: TIB_Connection): Boolean;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

const
  RS_ROW_ADD      = 'Ajouter';
  RS_ROW_IGNORE   = 'Ignorer';
  RS_ROW_SUCCESS  = 'Traité';
  RS_ROW_IGNORED  = 'Ignoré';
  RS_ROW_FAILURE  = 'Echec';
  RS_ROW_PROGRESS = 'En cours...';

implementation

uses StrUtils;

{$R *.dfm}

{ TForm1 }

procedure TFrm_Main.CheckFields;
begin
  Pb_Process.Enabled        := DB_Valid and CSV_Valid;
  Btn_StartProcess.Enabled  := CSV_Valid and CSV_Valid;
  Dbg_CSV.Enabled           := CSV_Valid;
  if CSV_Valid then
    CSVLoad( Chp_CSVPath.Text );
end;

function TFrm_Main.CreateSP(const ADatabase: TIB_Connection): Boolean;
begin
  Result := False;
  try
    if ADatabase.Connected then begin
      IBS_Create.Execute;
      Result := True;
    end;
  except
    on E: Exception do
      raise Exception.CreateFmt( '%s(%s) -> %s',[ 'CreateSP', ADatabase.Database, E.Message ]);
  end;
end;

procedure TFrm_Main.CSVLoad(const AFilename: String);
begin
  MemD_CSV.Close;
  MemD_CSV.Open;

  MemD_CSV.DisableControls;
  MemD_CSV.ReadOnly := False;
  MemD_CSV.LoadFromTextFile( AFilename );
  MemD_CSV.First;
  while not MemD_CSV.Eof do begin
    MemD_CSV.Edit;
    MemD_CSVState.AsString := RS_ROW_ADD; //Par défaut
    MemD_CSV.Post;
    MemD_CSV.Next;
  end;
  MemD_CSV.ReadOnly := True;
  MemD_CSV.EnableControls;
  MemD_CSV.First;
end;

procedure TFrm_Main.CSVPathBrowse(const ASender: TObject);
var
  sPath: String;
begin
  if PromptForFileName( sPath, '*.csv', '', 'Gestion de la cat/ssf' ) then begin
    Chp_CSVPath.Text := sPath;
    CSVPathChange( nil );
  end;
end;

procedure TFrm_Main.CSVPathChange(const ASender: TObject);
begin
  Img_ValidCSV.Picture := nil;

  CSV_Valid := FileExists( Chp_CSVPath.Text );
  if CSV_Valid then
    Imgl_State.GetBitmap( 1, Img_ValidCSV.Picture.Bitmap )
  else
    Imgl_State.GetBitmap( 0, Img_ValidCSV.Picture.Bitmap );

  CheckFields;
end;

procedure TFrm_Main.Dbg_CSVKeyPress(Sender: TObject; var Key: Char);
begin
  if ( Key = ' ' ) and ( MemD_CSV.RecNo >= 0 ) then begin
    MemD_CSV.DisableControls;
    MemD_CSV.ReadOnly := False;
    MemD_CSV.Edit;

    case AnsiIndexText( MemD_CSVState.AsString, [ RS_ROW_ADD, RS_ROW_IGNORE ]) of
      0: MemD_CSVSTATE.AsString := RS_ROW_IGNORE;
      1: MemD_CSVSTATE.AsString := RS_ROW_ADD;
    end;

    MemD_CSV.Post;
    MemD_CSV.ReadOnly := True;
    MemD_CSV.EnableControls;
  end;
end;

procedure TFrm_Main.DBPathBrowse(const ASender: TObject);
var
  sPath: String;
begin
  if PromptForFileName( sPath, '*.ib', '', 'Base de données' ) then
    Chp_DBPath.Text := sPath;
end;

procedure TFrm_Main.DBPathChange(const ASender: TObject);
begin
  Img_ValidDB.Picture := nil;

  DB_Valid := IsDBReady( Chp_DBPath.Text );
  if DB_Valid then
    Imgl_State.GetBitmap( 1, Img_ValidDB.Picture.Bitmap )
  else
    Imgl_State.GetBitmap( 0, Img_ValidDB.Picture.Bitmap );

  CheckFields;
end;

function TFrm_Main.DestroySP(const ADatabase: TIB_Connection): Boolean;
begin
  Result := False;
  try
    if ADatabase.Connected then begin
      IBS_Destroy.Execute;
      Result := True;
    end;
  except
    on E: Exception do
      raise Exception.CreateFmt( '%s(%s) -> %s',[ 'DestroySP', ADatabase.Database, E.Message ]);
  end;
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
begin
  DBPathChange( nil );
  CSVPathChange( nil );
end;

function TFrm_Main.IsDBReady(const AFilename, AUsername,
  APassword: String): Boolean;
begin
  Result := False;
  try
    DB.Close;
    DB.Database := AFilename;
    DB.Params.Values[ 'USER NAME' ] := AUsername;
    DB.Params.Values[ 'PASSWORD'  ] := APassword;
    DB.Open;
    Result := DB.Connected;
  except
//    on E: Exception do
//      raise Exception.CreateFmt( '%s(%s,%s,%s) -> %s',[ 'IsDBReady', AFilename, AUsername, APassword, E.Message ]);
  end;
end;

procedure TFrm_Main.StartProcess(const ASender: TObject);
begin
  try
    Btn_StartProcess.Enabled := False;
    try
      Transaction.StartTransaction;
      // Ajout de la SP
      if not CreateSP( DB ) then
        raise Exception.Create( 'Impossible de créer la procédure stockée' );

      Pb_Process.Position := 0;
      Pb_Process.Max := MemD_CSV.RecordCount;
      Pb_Process.Step := 1;
      MemD_CSV.DisableControls;
      MemD_CSV.ReadOnly := False;
      /////////////// DEBUT traitement ///////////////
      MemD_CSV.First;
      while not MemD_CSV.Eof do begin
        Pb_Process.StepIt;
        // Si l'état est "Ajouter" => intégration
        if SameText( MemD_CSVState.AsString, RS_ROW_ADD ) then begin
          MemD_CSV.Edit;
          MemD_CSVState.AsString := RS_ROW_PROGRESS;
          MemD_CSV.Post;

          SP.ParamValues[ 'CODEFEDAS' ] := MemD_CSVCODEFEDAS.AsString;
          SP.ParamValues[ 'CATEGORIE' ] := MemD_CSVCategorie.AsString;
          MemD_CSV.Edit;
          try
            SP.Execute; // execute procedure
            MemD_CSVState.AsString := RS_ROW_SUCCESS;
          except
            on E: Exception do
            MemD_CSVState.AsString := RS_ROW_FAILURE;
          end;
          MemD_CSV.Post;
        end
        else begin
          MemD_CSV.Edit;
          MemD_CSVState.AsString := RS_ROW_IGNORED;
          MemD_CSV.Post;
        end;

        MemD_CSV.Next;
      end;
      /////////////// FIN traitement ///////////////
      MemD_CSV.ReadOnly := True;
      MemD_CSV.EnableControls;
      if DestroySP( DB ) then
        Transaction.Commit
      else
        raise Exception.Create( 'Impossible de supprimer la procédure stockée' );

      MessageDlg( 'Intégration du fichier d''initialisation terminé !', mtInformation, [mbOK], 0 );

    except
      on E: Exception do begin
        Transaction.Rollback;
        ShowMessageFmt( '%s -> %s',[ 'StartProcess', E.Message ]);
      end;
    end;
  finally
    Btn_StartProcess.Enabled := True;
  end;
end;

end.
