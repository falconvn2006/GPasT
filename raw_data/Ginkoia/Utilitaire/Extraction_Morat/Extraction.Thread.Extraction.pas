unit Extraction.Thread.Extraction;

interface

uses
  System.Classes,
  System.SysUtils,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.IB,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Extraction.Ressourses;

type
  TArticle = record
    Sku_Ginkoia           : string[64];
    Sku_Fournisseur       : string[64];
    Designation           : string[64];
    Stock                 : Double;
    Date_Creation         : string[8];
    Date_Modification     : string[8];
    Id_Produit            : Integer;
    Id_Taille             : Integer;
    Id_Couleur            : Integer;
    Prix_Achat            : Currency;
  end;

  TDescription = record
    Sku_Ginkoia           : string[64];
    Sku_Fournisseur       : string[64];
    Designation           : string[64];
    Description           : string[255];
    Id_Produit            : Integer;
    Id_Taille             : Integer;
    Id_Couleur            : Integer;
  end;

  TThreadExtraction = class(TThread)
  strict private
    { Déclarations privées }
    FDConnection          : TFDConnection;
    FDTransaction         : TFDTransaction;
    FDPhysIBDriverLink    : TFDPhysIBDriverLink;
    QueArticles           : TFDQuery;
    procedure ExportDataSetToDVS(DataSet: TDataSet; const FileName: TFileName; const TxtMsg: string);
  protected
    procedure Execute(); override;
  public
    { Déclarations publiques }
    BaseDonnees           : TFileName;
    FichierArticles       : TFileName;
    LblProgression        : ^TLabel;
    PbProgression         : ^TProgressBar;
    ImgArticles           : ^TImage;
    iMagId                : Integer;
    ExtraireArticles      : Boolean;
  end;

implementation

{ TThreadExtraction }

procedure TThreadExtraction.Execute();
var
  Champ       : TField;
  Article     : TArticle;
  Description : TDescription;
begin
  FDConnection            := TFDConnection.Create(nil);
  FDTransaction           := TFDTransaction.Create(nil);
  FDPhysIBDriverLink      := TFDPhysIBDriverLink.Create(nil);
  QueArticles             := TFDQuery.Create(nil);

  try
    LblProgression.Caption := RS_CONNEXION;

    {$REGION 'Paramètrage de la connexion'}
    FDConnection.Params.Clear();
    FDConnection.Params.Add('DriverID=IB');
    FDConnection.Params.Add('User_Name=ginkoia');
    FDConnection.Params.Add('Password=ginkoia');
    FDConnection.Params.Add('Protocol=TCPIP');
    FDConnection.Params.Add('Server=localhost');
    FDConnection.Params.Add('Port=3050');
    FDConnection.Params.Add(Format('Database=%s', [BaseDonnees]));
    FDConnection.Transaction := FDTransaction;

    FDTransaction.Connection := FDConnection;

    QueArticles.Connection              := FDConnection;
    QueArticles.Transaction             := FDTransaction;
    QueArticles.FetchOptions.Mode       := fmAll;
    {$ENDREGION 'Paramètrage de la connexion'}

    try
      // Ouverture de la connexion
      FDConnection.Open();

      // Si l'arrêt du thread est demandée : on arrête
      if Self.Terminated then
        Exit;

      {$REGION 'Extraction des articles'}
      if Self.ExtraireArticles then
      begin
        ImgArticles.Picture.Bitmap.LoadFromResourceName(HInstance, 'ENCOURS');
        LblProgression.Caption  := RS_EXT_ARTICLES;
        PbProgression.Position  := 0;

        // Création de la requête d'extraction des articles
        QueArticles.SQL.Clear();
        QueArticles.SQL.Add('SELECT CBI_CB AS SKU, STC_QTE AS QTESTOCK');
        QueArticles.SQL.Add('FROM AGRSTOCKCOUR');
        QueArticles.SQL.Add('  JOIN ARTREFERENCE ON (STC_ARTID = ARF_ARTID)');
        QueArticles.SQL.Add('  JOIN ARTCODEBARRE ON (CBI_ARFID = ARF_ID AND CBI_TGFID = STC_TGFID AND CBI_COUID = STC_COUID AND CBI_TYPE = 1)');
        QueArticles.SQL.Add('  JOIN K KCBI ON (KCBI.K_ID = CBI_ID AND KCBI.K_ENABLED = 1)');
        QueArticles.SQL.Add('WHERE STC_QTE <> 0');
        QueArticles.SQL.Add('  AND STC_MAGID = :MAGID');
        QueArticles.SQL.Add('ORDER BY STC_MAGID, CBI_CB;');
        QueArticles.ParamByName('MAGID').AsInteger  := iMagId;

        // Exécution de la requête d'extraction
        QueArticles.Open();

        // Si l'arrêt du thread est demandée : on arrête
        if Terminated then
          Exit;

        // Enregistrement du résultat
        ExportDataSetToDVS(QueArticles, FichierArticles, RS_ENR_ARTICLES);
        QueArticles.Close();

        // Si l'arrêt du thread est demandée : on arrête
        if Terminated then
          Exit;

        ImgArticles.Picture.Bitmap.LoadFromResourceName(HInstance, 'AGT_ACTION_SUCCESS');
      end;
      {$ENDREGION 'Extraction des articles'}

      LblProgression.Caption := RS_TERMINEE;
    except
      on E: Exception do
      begin
        LblProgression.Caption    := Format('Erreur : %s - %s', [E.ClassName, E.Message]);
        LblProgression.Hint       := LblProgression.Caption;
        LblProgression.Font.Color := $0000FF;
      end;
    end;
  finally
    FDConnection.Free();
    FDTransaction.Free();
    FDPhysIBDriverLink.Free();
    QueArticles.Free();
  end;
end;

procedure TThreadExtraction.ExportDataSetToDVS(DataSet: TDataSet;
  const FileName: TFileName; const TxtMsg: string);
var
  fld: TField;
  lst: TStringList;
  wasActive: Boolean;
  writer: TTextWriter;
begin
  writer := TStreamWriter.Create(FileName);
  try
    lst := TStringList.Create();
    try
      wasActive := DataSet.Active;
      try
        DataSet.Active          := True;
        PbProgression.Max       := DataSet.RecordCount;
        PbProgression.Position  := 0;
//        PbProgression.Style     := pbstNormal;
        DataSet.GetFieldNames(lst);
        lst.Delimiter           := ';';
        lst.StrictDelimiter     := True;
//        writer.WriteLine(lst.DelimitedText);
        DataSet.First();
        while not DataSet.Eof do
        begin
          lst.Clear();
          for fld in DataSet.Fields do
          begin
            lst.Add(StringReplace(StringReplace(fld.Text, sLineBreak, ' ', [rfReplaceAll]), #10, ' ', [rfReplaceAll]));
          end;
          writer.WriteLine(lst.DelimitedText);
          DataSet.Next();
          PbProgression.StepBy(1);
          LblProgression.Caption := Format(TxtMsg, [PbProgression.Position, DataSet.RecordCount]);

          // Si l'arrêt du thread est demandée : on arrête
          if Terminated then
            Exit;
        end;
      finally
        DataSet.Active := wasActive;
      end;
    finally
      lst.Free();
    end;
  finally
    writer.Free();
  end;
end;

end.
