unit Main_Dm;

interface

uses
  SysUtils, Classes, IB_Components, DB, DBClient, IBODataset, dxmdaset;

type
  TDm_Main = class(TDataModule)
    Ginkoia: TIB_Connection;
    IbT_Trans: TIB_Transaction;
    Cds_Base: TClientDataSet;
    Cds_Rapp: TClientDataSet;
    Cds_RappInd: TIntegerField;
    Cds_RappType: TIntegerField;
    Cds_RappComment: TStringField;
    Cds_RappStrType: TStringField;
    Cds_RappFichier: TStringField;
    Que_Div1: TIBOQuery;
    Que_Div2: TIBOQuery;
    Que_Div3: TIBOQuery;
    Que_Div4: TIBOQuery;
    Que_CalculeTrigger: TIBOQuery;
    Que_InfoArt: TIBOQuery;
    Cds_RappRDate: TDateTimeField;
    Cds_RappRHeure: TDateTimeField;
    Cds_LstArt: TClientDataSet;
    Cds_LstArtArtID: TIntegerField;
    Cds_LstArtChrono: TStringField;
    Cds_LstArtNom: TStringField;
    Cds_LstArtMarque: TStringField;
    Cds_LstArtStkCourant: TIntegerField;
    Cds_LstArtStkHisto: TIntegerField;
    MemD_DetailArt: TdxMemData;
    MemD_DetailArtRDIM: TIntegerField;
    MemD_DetailArtRDATE: TDateTimeField;
    MemD_DetailArtRQTE: TFloatField;
    MemD_DetailArtRSTOCKFIN: TFloatField;
    MemD_DetailArtRTYPE: TIntegerField;
    MemD_DetailArtRNUMERO: TStringField;
    MemD_DetailArtRCATEG: TStringField;
    MemD_DetailArtRCOULEUR: TStringField;
    MemD_DetailArtMAGENSEIGNE: TStringField;
    MemD_DetailArtARF_CHRONO: TStringField;
    MemD_DetailArtARTNOM: TStringField;
    MemD_DetailArtLibArt: TStringField;
    MemD_DetailArtMAGID: TIntegerField;
    MemD_DetailArtARTID: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure Cds_RappCalcFields(DataSet: TDataSet);
  private
    { Déclarations privées }
    procedure EffaceVieuxRapport;
  public
    { Déclarations publiques }
    NbJourGardeRapport: integer;
    procedure ChargeConfig;
    procedure SauveConfig;
    function TestConnexion(ACheminBase: string; const MaintientConnecte: boolean = false): boolean;
  end;

var
  Dm_Main: TDm_Main;
  ReperBase: string;
  ReperRapport: string;

implementation

uses
  IniFiles, Main_Frm, Forms;

{$R *.dfm}

function TDm_Main.TestConnexion(ACheminBase: string; const MaintientConnecte: boolean = false): boolean;
begin
  result := false;
  Ginkoia.Connected := false;
  try
    Ginkoia.Database := ACheminBase;
    Ginkoia.Connected := true;
    result := true;
  except
  end;
  if not(MaintientConnecte) then
    Ginkoia.Connected := false;
end;

procedure TDm_Main.Cds_RappCalcFields(DataSet: TDataSet);
begin
  Case Cds_Rapp.fieldbyname('Type').AsInteger of
    1: Cds_Rapp.FieldByName('StrType').AsString := 'Rech.';
    2: Cds_Rapp.FieldByName('StrType').AsString := 'Calc.';
  end;
end;

procedure TDm_Main.ChargeConfig;
var
  sFic:string;
  savInd: integer;
  FicIni:TInifile;
  TpListe: TStringList;
  i:integer;
  sBase: string;
begin
  sFic:='VerifStock.ini';

  savInd := -1;
  if Cds_Base.RecordCount>0 then
    savInd := Cds_Base.FieldByName('Ind').AsInteger;
  Cds_Base.DisableControls;
  Cds_Base.EmptyDataSet;
  Cds_Base.IndexFieldNames:='';
  try
    if FileExists(ReperBase+sFic) then
    begin
      TPListe := TStringList.Create;
      FicIni:=TIniFile.Create(ReperBase+sFic);
      try
        // liste des bases enregistrées
        FicIni.ReadSection('DATABASE',TpListe);
        For i:=1 to TpListe.Count do
        begin
          sBase := FicIni.ReadString('DATABASE',TPListe[i-1],'');
          Cds_Base.Append;
          Cds_Base.FieldByName('Ind').AsInteger := i;
          Cds_Base.FieldByName('Nom').AsString := TpListe[i-1];
          Cds_Base.FieldByName('Base').AsString := sBase;
          Cds_Base.Post;
        end;

        // nb de jour que l'on garde les rapports
        NbJourGardeRapport := FicIni.ReadInteger('RAPPORT','NbJourGardeRapport',60);
      finally
        FicIni.Free;
        TPListe.Free;
      end;
    end;
  finally
    if not(Cds_Base.Locate('Ind',savInd,[])) then
      Cds_Base.First;
    Cds_Base.IndexFieldNames:='Nom';
    Cds_Base.EnableControls;
  end;
end;

procedure TDm_Main.SauveConfig; 
var
  sFic:string;
  savInd: integer;
  FicIni:TInifile;
begin   
  sFic:='VerifStock.ini';

  savInd := -1;
  if Cds_Base.RecordCount>0 then
    savInd := Cds_Base.FieldByName('Ind').AsInteger;
  Cds_Base.DisableControls;
  try
    if FileExists(ReperBase+sFic) then
      DeleteFile(ReperBase+sFic);
              
    FicIni:=TIniFile.Create(ReperBase+sFic);
    try
      // base
      Cds_Base.First;
      while not(Cds_Base.Eof) do
      begin
        FicIni.WriteString('DATABASE',
                           Cds_Base.fieldbyname('Nom').AsString,
                           Cds_Base.fieldbyname('Base').AsString);
        Cds_Base.Next;
      end;

      // nb de jour que l'on garde les rapports
      FicIni.WriteInteger('RAPPORT','NbJourGardeRapport',NbJourGardeRapport);
    finally
      FicIni.Free;
    end;
  finally
    if not(Cds_Base.Locate('Ind',savInd,[])) then
      Cds_Base.First;
    Cds_Base.EnableControls;
  end;
end;

procedure TDm_Main.EffaceVieuxRapport;
var
  TPListe: TStringList;
  Book: TBookmark;
  sRep:string;
  SearchRec: TsearchRec;
  s: string;
  Resu, i: integer;
  d: TDateTime;
begin
  if not(Cds_Base.Active) or (Cds_Base.RecordCount=0) then
    exit;
  Book := Cds_Base.GetBookmark;
  Cds_Base.DisableControls;
  TPListe := TStringList.Create;
  try
    Cds_Base.First;
    while not(Cds_Base.Eof) do
    begin
      sRep := ReperRapport+Cds_Base.FieldByName('Nom').AsString+'\';
      if DirectoryExists(sRep) then
      begin
        TpListe.Clear;
        Resu := FindFirst(sRep+'*.*', faAnyfile, SearchRec);
        while resu=0 do
        begin
          s := ExtractFileName(SearchRec.Name);
          if (s<>'.') and (s<>'..') and ((SearchRec.Attr and faDirectory)<>faDirectory) then
          begin
            try
              d := FileDateToDateTime(SearchRec.Time);
              if Trunc(Date)-Trunc(d)>NbJourGardeRapport then
                TpListe.Add(sRep+s);
            except
            end;
          end;
          Resu := FindNext(SearchRec);
        end;
        FindClose(SearchRec);
        for i := 1 to TpListe.Count do
          DeleteFile(TpListe[i-1]);
      end;
      Cds_Base.Next;
    end;
  finally
    TPListe.Free;
    Cds_Base.GotoBookmark(Book);
    Cds_Base.FreeBookmark(Book);
    Cds_Base.EnableControls;
  end;
end;

procedure TDm_Main.DataModuleCreate(Sender: TObject);
begin
  // repertoire de base
  ReperBase := ExtractFilePath(ParamStr(0));
  if ReperBase[Length(ReperBase)]<>'\' then
    ReperBase:=ReperBase+'\';

  // repertoire de base de rapport (avec des sous-répertoires par nom)
  ReperRapport := ReperBase+'VerifStock\';
  if not(DirectoryExists(ReperRapport)) then
    ForceDirectories(ReperRapport);

  ChargeConfig;

  // elimine les rapports de plus de NbJourGardeRapport jours
  EffaceVieuxRapport;
end;

end.
