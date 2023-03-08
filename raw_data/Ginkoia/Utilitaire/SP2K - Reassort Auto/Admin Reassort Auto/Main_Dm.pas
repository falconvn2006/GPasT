//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

unit Main_Dm;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, ADODB, wwDialog, wwidlg, wwLookupDialogRv, uDefs, iniCfg_Frm;

type
  TDm_Main = class(TDataModule)
    ADOConnection: TADOConnection;
    Ds_mag: TDataSource;
    Qmag: TADOQuery;
    Qmagmag_id: TAutoIncField;
    Qmagmag_actif: TIntegerField;
    Qmagmag_dateactivation: TDateTimeField;
    Qmagmag_code: TStringField;
    Qmagmag_nom: TStringField;
    Qmagmag_ville: TStringField;
    Qmagmag_cheminbase: TStringField;
    Qmagmag_dosid: TIntegerField;
    Qmagdos_nom: TStringField;
    Qmagmag_senderid: TIntegerField;
    Qdos: TADOQuery;
    QdosDOS_ID: TAutoIncField;
    QdosDOS_NOM: TStringField;
    QdosDOS_COMMENT: TStringField;
    QdosDOS_ENABLED: TIntegerField;
    QdosDOS_GUID: TStringField;
    QdosDOS_UNIID: TIntegerField;
    Ds_Dos: TDataSource;
    Qreg: TADOQuery;
    QregREG_NOM: TStringField;
    QregREG_ID: TAutoIncField;
    Ds_Reg: TDataSource;
    Tmag: TADOTable;
    TmagMAG_ID: TAutoIncField;
    TmagMAG_DOSID: TIntegerField;
    TmagMAG_REGID: TIntegerField;
    TmagMAG_TYMID: TIntegerField;
    TmagMAG_CODE: TStringField;
    TmagMAG_NOM: TStringField;
    TmagMAG_DIRECTEUR: TStringField;
    TmagMAG_VILLE: TStringField;
    TmagMAG_LEARDERSHIP: TIntegerField;
    TmagMAG_ENABLED: TIntegerField;
    TmagMAG_CHEMINBASE: TStringField;
    TmagMAG_DATEACTIVATION: TDateTimeField;
    TmagMAG_ACTIF: TIntegerField;
    TmagMAG_X: TSmallintField;
    TmagMAG_Y: TSmallintField;
    TmagMAG_INDICGENERAL: TWordField;
    TmagMAG_SENDERID: TIntegerField;
    TmagMAG_RAPPINTEG: TIntegerField;
    TmagMAG_CATMAN: TIntegerField;
    Ds_TMag: TDataSource;
    Que_LstMarques: TADOQuery;
    Ds_LstMarque: TDataSource;
    Que_LstMarquesRAM_ID: TAutoIncField;
    Que_LstMarquesRAM_MRKID: TIntegerField;
    Que_LstMarquesRAM_TRIGRAM: TStringField;
    Que_LstMarquesRAM_ACTIF: TWordField;
    Que_LstMarquesRAM_STK: TWordField;
    Que_LstMarquesRAM_VTE: TWordField;
    Que_LstMarquesRAM_REPFTP: TStringField;
    Que_LstMarquesMRK_NOM: TStringField;
    Tbl_Marque: TADOTable;
    Ds_Marque: TDataSource;
    Que_MrkSP2000: TADOQuery;
    Que_MrkSP2000MRK_ID: TAutoIncField;
    Que_MrkSP2000MRK_NOM: TStringField;
    Ds_MrkSP2000: TDataSource;
    Que_LstArticle: TADOQuery;
    Ds_LstArticle: TDataSource;
    Tbl_Article: TADOTable;
    Ds_Article: TDataSource;
    Que_LstMrkRea: TADOQuery;
    Ds_LstMrkRea: TDataSource;
    Que_LstArticleREA_ID: TAutoIncField;
    Que_LstArticleREA_LIB: TStringField;
    Que_LstArticleREA_REF: TStringField;
    Que_LstArticleREA_TAILLE: TStringField;
    Que_LstArticleREA_COULEUR: TStringField;
    Que_LstArticleREA_DIV1: TStringField;
    Que_LstArticleREA_DIV2: TStringField;
    Que_LstArticleREA_EAN: TStringField;
    Que_LstMrkReaRAM_MRKID: TIntegerField;
    Que_LstMrkReaMRK_NOM: TStringField;
    OD_FileCsv: TOpenDialog;
    Tbl_ArticleREA_ID: TAutoIncField;
    Tbl_ArticleREA_LIB: TStringField;
    Tbl_ArticleREA_REF: TStringField;
    Tbl_ArticleREA_TAILLE: TStringField;
    Tbl_ArticleREA_COULEUR: TStringField;
    Tbl_ArticleREA_DIV1: TStringField;
    Tbl_ArticleREA_DIV2: TStringField;
    Tbl_ArticleREA_EAN: TStringField;
    Tbl_ArticleREA_MRKID: TIntegerField;
    Tbl_Magasin: TADOTable;
    Ds_Magasin: TDataSource;
    Que_UpdateMrkMag: TADOQuery;
    Que_LstMrkMagasin: TADOQuery;
    Tbl_Histo: TADOTable;
    Que_LstMagInit: TADOQuery;
    Que_LstMagInitREM_MAGID: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Déclarations privées }
  public
      { Déclarations publiques }
      // Ouverture de la base de données
      function OpenDatabase : Boolean;



  end;

var
    Dm_Main: TDm_Main;

implementation

{$R *.DFM}

procedure TDm_Main.DataModuleCreate(Sender: TObject);
begin
  //Ouverture de la connexion
  OpenDatabase;

  //Ouverture des Query
  qmag.Open;
  qdos.open;
  qreg.Open;
  tmag.Open;
  Que_LstMarques.Open;
  Tbl_Marque.Open;
  Que_MrkSP2000.Open;
  Que_LstMrkRea.Open;
  Que_LstArticle.Parameters.ParamByName('MRKID').Value  := Que_LstMrkRea.FieldByName('RAM_MRKID').AsInteger;
  Que_LstArticle.Open;
  Tbl_Article.Open;
  Tbl_Magasin.Open;
  Tbl_Histo.open;
end;

procedure TDm_Main.DataModuleDestroy(Sender: TObject);
begin
  //Fermeture des Query
  qmag.Close;
  qdos.Close;
  qreg.Close;
  tmag.Close;
  Que_LstMarques.Close;
  Tbl_Marque.Close;
  Que_MrkSP2000.Close;
  Tbl_Article.Close;
  Que_LstArticle.Close;
  Que_LstMrkRea.Close;
  Tbl_Magasin.Close;
  Tbl_Histo.Close;
  //Fermeture de la connxion
  ADOConnection.Connected:=False;
end;

function TDm_Main.OpenDatabase: Boolean;
begin
  Result := False;
  With ADOConnection do
  Try
    Connected := False;

//    if IniStruct.IsDevMode then
//    begin
//      //Dev
//      ConnectionString := 'Provider=SQLOLEDB.1;' +
//                          'Password=' + IniStruct.PasswordDev + ';' +
//                          'Persist Security Info=True;' +
//                          'User ID=' + IniStruct.LoginDev + ';' +
//                          'Initial Catalog=' + IniStruct.CatalogDev + ';' +
//                          'Data Source=' + IniStruct.ServerDev;
//    end
//    else
//    begin
//      //Prd
//      ConnectionString := 'Provider=SQLOLEDB.1;' +
//                          'Password=' + IniStruct.PasswordPrd + ';' +
//                          'Persist Security Info=True;' +
//                          'User ID=' + IniStruct.LoginPrd + ';' +
//                          'Initial Catalog=' + IniStruct.CatalogPrd + ';' +
//                          'Data Source=' + IniStruct.ServerPrd;
//    end;
    ConnectionString := IniCfg.MsSqlConnectionString;
    Connected := True;

    Que_LstMagInit.Close;
    Que_LstMagInit.Open;

    Result := True;
  Except on E:Exception do
    raise Exception.Create('OpenDatabase -> ' + E.Message);
  end;
end;

END.

