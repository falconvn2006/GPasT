unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, DB, DBClient, dxmdaset, Grids, DBGrids, ExtCtrls, DBCtrls, XPMan;

type
  TMainForm = class(TForm)
    Pgc_Page: TPageControl;
    Tab_Categ: TTabSheet;
    Nbt_Categ: TBitBtn;
    Lab_Categ: TLabel;
    Pgc_ResuCateg: TPageControl;
    Tab_Lectcateg: TTabSheet;
    Tab_ResuCateg: TTabSheet;
    Memo1: TMemo;
    MemD_Categ: TdxMemData;
    MemD_CategCode: TStringField;
    MemD_CategNom: TStringField;
    Ds_Categ: TDataSource;
    DBGrid1: TDBGrid;
    Nbt_ChargeCateg: TBitBtn;
    Nbt_SauveCateg: TBitBtn;
    Tab_Client: TTabSheet;
    Nbt_Client: TBitBtn;
    Lab_Client: TLabel;
    Pgc_ResuClient: TPageControl;
    Tab_LectClient: TTabSheet;
    Memo2: TMemo;
    Tab_ResuClient: TTabSheet;
    DBGrid2: TDBGrid;
    Nbt_ChargeClient: TBitBtn;
    Nbt_SauveClient: TBitBtn;
    Tab_Lect2Client: TTabSheet;
    Memo3: TMemo;
    Lab_demarrage: TLabel;
    Edt_DemarCli: TEdit;
    Lab_LonFictit: TLabel;
    Lab_Long: TLabel;
    Lab_pendant: TLabel;
    Edt_LongCli: TEdit;
    Rgr_OrdCli: TRadioGroup;
    MemD_Client: TdxMemData;
    Ds_Client: TDataSource;
    MemD_ClientCode: TStringField;
    MemD_ClientNomPre: TStringField;
    MemD_ClientSeparPre: TIntegerField;
    MemD_ClientNom: TStringField;
    MemD_ClientPrenom: TStringField;
    DBNavigator1: TDBNavigator;
    XPManifest1: TXPManifest;
    MemD_ClientNumIdent: TStringField;
    MemD_ClientsPrefect: TStringField;
    MemD_ClientAdr1_1: TStringField;
    MemD_ClientAdr1_2: TStringField;
    MemD_ClientCpVille1: TStringField;
    MemD_ClientCodePays1: TStringField;
    MemD_ClientCp1: TStringField;
    MemD_ClientVille1: TStringField;
    MemD_ClientPays1: TStringField;
    MemD_ClientTel1: TStringField;
    Nbt_Pays: TBitBtn;
    Nbt_PaysNone: TBitBtn;
    Nbt_MenageCli: TBitBtn;
    Tab_Article: TTabSheet;
    MemD_Article: TdxMemData;
    Ds_Article: TDataSource;
    Nbt_Art: TBitBtn;
    Lab_Art: TLabel;
    Label1: TLabel;
    Edt_DemarArt: TEdit;
    Label2: TLabel;
    Edt_LongArt: TEdit;
    Lab_TitLongArt: TLabel;
    Lab_LongArt: TLabel;
    Pgc_ResuArt: TPageControl;
    Tab_LectArt: TTabSheet;
    Memo4: TMemo;
    Tab_Lect2Art: TTabSheet;
    Memo5: TMemo;
    Tab_ResuArt: TTabSheet;
    DBGrid3: TDBGrid;
    Nbt_ChargArt: TBitBtn;
    Nbt_SauveArt: TBitBtn;
    DBNavigator2: TDBNavigator;
    Tab_Marq: TTabSheet;
    Nbt_Marque: TBitBtn;
    Lab_Marque: TLabel;
    Pgc_ResuMarq: TPageControl;
    Tab_LectMarq: TTabSheet;
    Memo6: TMemo;
    Tab_ResuMarq: TTabSheet;
    DBGrid4: TDBGrid;
    Nbt_ChargerMarq: TBitBtn;
    Nbt_SauverMarq: TBitBtn;
    Tab_Lect2Marq: TTabSheet;
    Memo7: TMemo;
    MemD_Marque: TdxMemData;
    Ds_Marque: TDataSource;
    MemD_MarqueCode: TStringField;
    MemD_MarqueNom: TStringField;
    MemD_Modele: TdxMemData;
    Ds_Modele: TDataSource;
    Tab_Modele: TTabSheet;
    Nbt_Modele: TBitBtn;
    Lab_Modele: TLabel;
    Pgc_Modele: TPageControl;
    Tab_LectModele: TTabSheet;
    Memo8: TMemo;
    Tab_Lect2Modele: TTabSheet;
    Memo9: TMemo;
    Tab_ResuModele: TTabSheet;
    DBGrid5: TDBGrid;
    Nbt_ChargeModele: TBitBtn;
    Nbt_SauveModele: TBitBtn;
    MemD_ModeleCode: TStringField;
    MemD_ModeleNom: TStringField;
    MemD_ArticleCode: TStringField;
    MemD_ArticleCodMarq: TStringField;
    MemD_ArticleNomMarq: TStringField;
    MemD_ArticleNomMarqFin: TStringField;
    MemD_ArticleCodModel: TStringField;
    MemD_ArticleNomModel: TStringField;
    MemD_ArticleNomModelFin: TStringField;
    MemD_ArticleCodCateg: TStringField;
    MemD_ArticleNomCategfin: TStringField;
    MemD_ArticleTaille: TStringField;
    Tab_Voir: TTabSheet;
    Nbt_Fichier: TBitBtn;
    Lab_Fichier: TLabel;
    Pgc_Fichier: TPageControl;
    Tab_LectFic: TTabSheet;
    Memo10: TMemo;
    Tab_Lect2Fic: TTabSheet;
    Memo11: TMemo;
    OD_Fichier: TOpenDialog;
    Rgr_Mtd: TRadioGroup;
    Lab_LngRStr: TLabel;
    Edt_LngRStr: TEdit;
    Nbt_RefaireFic: TBitBtn;
    BitBtn1: TBitBtn;
    Tab_Cptl: TTabSheet;
    Nbt_Cptl: TBitBtn;
    Lab_Cptl: TLabel;
    Pgc_resucptl: TPageControl;
    Tab_lectcptl: TTabSheet;
    Memo12: TMemo;
    Tab_lect2cptl: TTabSheet;
    Memo13: TMemo;
    Nbt_oups: TBitBtn;
    BitBtn2: TBitBtn;
    Nbt_exportcli: TBitBtn;
    MemD_ArticleExercice: TStringField;
    MemD_ArticleDAchat: TDateField;
    MemD_ArticlePAchat: TFloatField;
    MemD_ArticleStrDAchat: TStringField;
    TbResuCptl: TTabSheet;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    DBNavigator5: TDBNavigator;
    DBGrid6: TDBGrid;
    MemD_Cptl: TdxMemData;
    Ds_Cptl: TDataSource;
    MemD_CptlCode: TStringField;
    MemD_CptlDate1: TStringField;
    MemD_CptlDate2: TStringField;
    BitBtn5: TBitBtn;
    DBNavigator4: TDBNavigator;
    DBNavigator3: TDBNavigator;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn9: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn8: TBitBtn;
    MemD_ArticleEtat: TFloatField;
    BitBtn14: TBitBtn;
    MemD_ArticleFixation: TStringField;
    MemD_ArticlePFix: TFloatField;
    MemD_ArticleNoSerie: TStringField;
    Nbt_FaireFix: TBitBtn;
    MemD_ArticleNomFixationFin: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Nbt_CategClick(Sender: TObject);
    procedure Nbt_ChargeCategClick(Sender: TObject);
    procedure Nbt_SauveCategClick(Sender: TObject);
    procedure Nbt_ClientClick(Sender: TObject);
    procedure Edt_DemarCliKeyPress(Sender: TObject; var Key: Char);
    procedure Rgr_OrdCliClick(Sender: TObject);
    procedure Nbt_ChargeClientClick(Sender: TObject);
    procedure Nbt_SauveClientClick(Sender: TObject);
    procedure MemD_ClientBeforePost(DataSet: TDataSet);
    procedure Nbt_PaysClick(Sender: TObject);
    procedure Nbt_PaysNoneClick(Sender: TObject);
    procedure Nbt_MenageCliClick(Sender: TObject);
    procedure Nbt_ArtClick(Sender: TObject);
    procedure Nbt_MarqueClick(Sender: TObject);
    procedure Nbt_ChargerMarqClick(Sender: TObject);
    procedure Nbt_SauverMarqClick(Sender: TObject);
    procedure Nbt_ModeleClick(Sender: TObject);
    procedure Nbt_ChargeModeleClick(Sender: TObject);
    procedure Nbt_SauveModeleClick(Sender: TObject);
    procedure Nbt_RefaireFicClick(Sender: TObject);
    procedure Nbt_FichierClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Nbt_CptlClick(Sender: TObject);
    procedure Nbt_oupsClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Nbt_exportcliClick(Sender: TObject);
    procedure Nbt_ChargArtClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Nbt_SauveArtClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure Nbt_FaireFixClick(Sender: TObject);
  private
    { Déclarations privées }
    EtatFiche:boolean;
    ReperBase: String;
    ReperProlog: String;
    Fichier:string;

    procedure LireCateg(AFileName:string);
    procedure LireClient(AFileName:string);
    procedure LireArticle(AFileName:string);
    procedure LireMarque(AFileName:string);
    procedure LireGenerique(AFileName:string);
    procedure LireModele(AFileName:string);  
    procedure LireCptl(AFileName:string);
    
    procedure LireFichier(AFileName:string);

  public
    { Déclarations publiques }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}     

FUNCTION ArrondiA2(v: Double): Double;
VAR
  TpV: Currency;
  v1: integer;
  s: STRING;
  Ecart: integer;
BEGIN
  TpV := v;
  s := inttostr(Trunc(TpV * 1000));
  Ecart := 0;
  TRY
    v1 := StrToInt(s[Length(s)]);
    IF v1 >= 5 THEN
    BEGIN
      IF v < 0 THEN
        Ecart := -1
      ELSE
        Ecart := 1;
    END;
  EXCEPT
  END;
  Result := (Trunc(TpV * 100) + Ecart) / 100;
END;

procedure GetCpVille(CpVille:string; var Cp,Ville:string);
var
  i:integer;
  bOk:boolean;
begin
  Cp:='';
  Ville:=CpVille;
  if Length(CpVille)<5 then
    exit;
  bOk:=true;
  for i:=1 to 5 do
  begin
    if not(CpVille[i] in ['0'..'9']) then
      bOk:=false;
  end;
  if bOk then
  begin
    Cp:=Copy(CpVille,1,5);
    Ville:=Trim(Copy(CpVille,6,Length(CpVille)));
  end;
end;

function GetPays(ACode:string):string;
begin  
  Result:='';
  if (ACode='') or
     (ACode='F') or
     (ACode='FR') or
     (ACode='FRC') or
     (ACode='LE') or
     (ACode='$') or
     (ACode='FRF') or
     (ACode='CHE') or
     (ACode='FFR') or
     (ACode='FRR') or
     (ACode='RF') or
     (ACode='FR$') or
     (ACode='COR') or
     (ACode='.') or
     (ACode='*') or
     (ACode='FRA') or
     (ACode='F''R') or
     (ACode='FRM') or
     (ACode='FRT') or
     (ACode='FE') then
    Result:='FRANCE';

  if (ACode='DEU') or
     (ACode='ALL') or
     (ACode='AL') or
     (ACode='GER') or
     (ACode='D') or
     (ACode='DE') or
     (ACode='KOL') or
     (ACode='32') then
    Result:='ALLEMAGNE';

  if (ACode='LUX') then
    Result:='LUXEMBOURG';

  if (ACode='SUI') then
    Result:='SUISSE';

  if (ACode='AUT') then
    Result:='AUTRICHE';

  if (ACode='IRE') then
    Result:='IRLANDE';  

  if (ACode='FIN') then
    Result:='FINLANDE';

  if (ACode='NOR') then
    Result:='NORVEGE';

  if (ACode='DN') then
    Result:='DANEMARK';

  if (ACode='NDL') or
     (ACode='NED') or
     (ACode='NL') or
     (ACode='HOL') or
     (ACode='NEE') or
     (ACode='PAY') or
     (ACode='PAB') or
     (ACode='PB') or
     (ACode='PBA') or
     (ACode='HO') or
     (ACode='ND') then
    Result:='PAYS BAS';  

  if (ACode='ANG') or
     (ACode='GB') or
     (ACode='GRA') or
     (ACode='ENG') or
     (ACode='AN') or
     (ACode='RU') or
     (ACode='A') or
     (ACode='UK') or
     (ACode='BR') then
    Result:='GRANDE BRETAGNE';

  if (ACode='USA') or
     (ACode='US') then
    Result:='ETATS UNIS'; 

  if (ACode='ECO') then
    Result:='ECOSSE';

  if (ACode='ITA') or
     (ACode='I') then
    Result:='ITALIE';

  if (ACode='ESP') or
     (ACode='E') or
     (ACode='ES') or
     (ACode='SP') then
    Result:='ESPAGNE';

  if (ACode='DAN') or
     (ACode='DK') or
     (ACode='DNK') or
     (ACode='DA') then
    Result:='DANEMARK';

  if (ACode='HON') or
     (ACode='H') or
     (ACode='HUN') then
    Result:='HONGRIE';

  if (ACode='URS') then
    Result:='RUSSIE';

  if (ACode='BEL') or
     (ACode='B') or
     (ACode='BE') or
     (ACode='BL') or
     (ACode='WAL') then
    Result:='BELGIQUE';

  if (ACode='SUE') or
     (ACode='SWE') or
     (ACode='SW') then
    Result:='SUEDE';

  if (ACode='AUS') then
    Result:='AUSTRALIE';

  if (ACode='TCH') then
    Result:='TCHECOSLOVAQUIE';

  if (ACode='S A') or
    (ACode='AF') then
    Result:='AFRIQUE DU SUD';

  if (ACode='POL') then
    Result:='POLOGNE';

  if (ACode='P') or
     (ACode='POR') then
    Result:='PORTUGAL';

  if (ACode='TUN') then
    Result:='TUNISIE';
end;

procedure TMainForm.LireClient(AFileName:string);
var
  Stream:TMemoryStream;
  Cnt: integer;
  b: byte;
  lu: byte;
  s: String;
  LigneDec: String;
  LigneStr: String;
  LigneDes: String;
  NbMax,i :integer;
  Nb9: integer;
  bStop: boolean;

  Compte:integer;

  P, Start: PByte;

  procedure TraiteLigne(TpS:string);
  var
    sCode:string;
    sNomPre:string;
    sNumIdent:string;
    sPrefect:string;
    Adr1_1:string;
    Adr1_2:string;
    CpVille1:string;
    Cp1:string;
    Ville1:string;
    CodePays1:string;
    Pays1:string;
    Tel1:string;
    Lng:string;
    ij:integer;
  begin
    if (Length(Tps)>=8) and (TpS[7]=#1) then
    begin
      Lng:='';
      for ij:=1 to Length(TpS) do
      begin
        if TpS[ij]=#0 then
          Lng:=Lng+chr(255)
        else
          LnG:=Lng+Tps[ij];
      end;
      //SetString(TpS,PChar(pDeb),PChar(pFin));
      memo3.Lines.Add(Copy(Lng,1,600));

      sCode:=Trim(Copy(TpS,1,6));
      sNomPre:=Trim(Copy(Tps,9,30));
      sNumIdent:=Trim(Copy(Tps,39,15));
      sPrefect:=Trim(Copy(Tps,54,20));
      Adr1_1:=Trim(Copy(Tps,74,30));
      Adr1_2:=Trim(Copy(Tps,104,30));
      CpVille1:=Trim(Copy(Tps,134,46));
      GetCpVille(CpVille1,Cp1,Ville1);
      CodePays1:=Trim(Copy(Tps,180,3)); 
      Tel1:='';

      MemD_Client.Append;
      MemD_Client.FieldByName('Code').AsString:=sCode;
      MemD_Client.FieldByName('NomPre').AsString:=sNomPre;
      if pos(' ',sNomPre)>0 then
        MemD_Client.FieldByName('SeparPre').AsInteger:=1
      else
        MemD_Client.FieldByName('SeparPre').AsInteger:=0;
      MemD_Client.FieldByName('NumIdent').AsString:=sNumIdent;
      MemD_Client.FieldByName('sPrefect').AsString:=sPrefect;
      MemD_Client.FieldByName('Adr1_1').AsString:=Adr1_1;
      MemD_Client.FieldByName('Adr1_2').AsString:=Adr1_2;
      MemD_Client.FieldByName('CpVille1').AsString:=CpVille1;
      MemD_Client.FieldByName('Cp1').AsString:=Cp1;
      MemD_Client.FieldByName('Ville1').AsString:=Ville1;
      MemD_Client.FieldByName('CodePays1').AsString:=CodePays1;
      CodePays1:=UpperCase(CodePays1);
      Pays1:=GetPays(UpperCase(CodePays1));

      MemD_Client.FieldByName('Pays1').AsString:=Pays1;
      MemD_Client.FieldByName('Tel1').AsString:=CodePays1;
      MemD_Client.Post;
    end;
  end;

begin 
  MemD_Client.Active:=false;
  MemD_Client.Active:=true;
  MemD_Client.SortedField:='';

  Memo2.Clear;
  Memo3.Clear;
  NbMax := 30;
  LigneDec := '';
  LigneStr := '';
  LigneDes := '';
  for i:=1 to NbMax do
  begin
    s:=inttostr(i);
    s:=s[Length(s)];
    while Length(s)<4 do
      s:=' '+s;
    LigneDec:=LigneDec+s;
    s:=inttostr(i);
    s:=s[Length(s)];
    LigneStr:=LigneStr+s;
  end;
  LigneDec := LigneDec+ '    ';
  Memo2.Lines.Add(LigneDec+LigneStr);

  LigneStr:='';
  for i:=1 to 60 do begin
    s:=inttostr(i);
    while Length(s)<10 do
      s:=' '+s;
    LigneStr:=LigneStr+s;
  end;
  Memo3.Lines.Add(LigneStr);  
  LigneStr:='';
  for i:=1 to 600 do
  begin  
    s:=inttostr(i);
    s:=s[Length(s)];
    LigneStr:=LigneStr+s;
  end;
  Memo3.Lines.Add(LigneStr);


  Stream := TMemoryStream.Create;
  Memo2.Lines.BeginUpdate;
  Memo3.Lines.BeginUpdate;
  MemD_Client.DisableControls;
  try
    Stream.LoadFromFile(AFileName);
    Stream.Seek(0, soFromBeginning);
    Lab_Long.Caption:=FormatFloat('#,##0',Stream.Size);

    P := Stream.Memory;
    if P <> nil then
    begin
      Compte:=0;
      while (Compte<=Stream.Size) do
      begin 
        Start:=P;
        while (P^<>10) and (Compte<=Stream.Size) do
        begin
          Inc(P);
          inc(Compte);
        end;
        SetString(s,PChar(Start),PChar(p)-PChar(Start));
        TraiteLigne(s);

        if P^ = 10 then
        begin
          Inc(P);
          inc(Compte);
        end;
      end;
    end;

    Stream.Seek(StrToIntDef(Edt_DemarCli.Text,0), soFromBeginning);

    Cnt := 0;
    LigneDec := '';
    LigneStr := ''; 
    LigneDes := '';

    Nb9 := 0;
    bStop:=false;
    Compte:=0;
    repeat
      inc(Compte);
      lu := Stream.Read(b,Sizeof(Byte));
      if lu=SizeOf(Byte) then
      begin

        Inc(Cnt);
        s:=inttostr(b);
        while Length(s)<4 do
          s:=' '+s;
        LigneDec := LigneDec+s;
        if b<32 then
        begin
          LigneStr := LigneStr+' ';
          LigneDes := LigneDes+'    ';
        end
        else begin
          LigneStr := LigneStr+Chr(b);
          s:=Chr(b);
          While Length(s)<4 do
            s:=' '+s;
          LigneDes := LigneDes+s;
        end;
        if Cnt= NbMax then
        begin
          LigneDec := LigneDec+ '    ';
          Memo2.Lines.Add(LigneDec+LigneStr);
          Memo2.Lines.Add(LigneDes);
          LigneDec := '';
          LigneStr := '';
          LigneDes := '';
          Cnt:=0;
        end;
        if b=9 then  //au bout de 3 "9", j'arrete de lire
          Inc(Nb9)
        else
          Nb9 := 0;
        if Nb9=3 then
          bStop:=true;
      end;
    until (lu<>Sizeof(Byte)) or bStop or (Compte=StrToIntDef(Edt_LongCli.Text,20000));

    if LigneDec<>'' then begin
      While Length(LigneDec)< (4*NbMax) do
        LigneDec:=LigneDec+' ';
      LigneDec := LigneDec+ '    ';
      Memo2.Lines.Add(LigneDec+LigneStr);
      Memo2.Lines.Add(LigneDes);
    end;
  finally            
    case Rgr_OrdCli.ItemIndex of
      0:MemD_Client.SortedField:='Code';
      1:MemD_Client.SortedField:='NomPre';
    end;
    MemD_Client.First;
    MemD_Client.EnableControls;
    Memo3.Lines.EndUpdate;
    Memo2.Lines.EndUpdate;
    Stream.Free;
  end;
end;

procedure TMainForm.LireGenerique(AFileName:string);
var
  Stream:TMemoryStream;
  Cnt: integer;
  b: byte;
  lu: byte;
  s: String;
  LigneDec: String;
  LigneStr: String;
  LigneDes: String;
  NbMax,i :integer;
  Nb9: integer;
  bStop: boolean;

  Compte:integer;

  P, Start: PByte;
  TailleRec:integer;

  procedure TraiteLigne(TpS:string);
  var
    Lng:string;
    ij:integer;
  begin
    if (Length(Tps)>=13) and (TpS[14]=#1) then
    begin
      Lng:='';
      for ij:=1 to Length(TpS) do
      begin
        if TpS[ij]=#0 then
          Lng:=Lng+chr(255)
        else
          LnG:=Lng+Tps[ij];
      end;
      //SetString(TpS,PChar(pDeb),PChar(pFin));
      memo5.Lines.Add(Copy(Lng,1,600));

    end;
  end;

begin 
 // MemD_Article.Active:=false;
 // MemD_Article.Active:=true;
 // MemD_Article.SortedField:='';

  Memo4.Clear;
  Memo5.Clear;
  NbMax := 30;
  LigneDec := '';
  LigneStr := '';
  LigneDes := '';
  for i:=1 to NbMax do
  begin
    s:=inttostr(i);
    s:=s[Length(s)];
    while Length(s)<4 do
      s:=' '+s;
    LigneDec:=LigneDec+s;
    s:=inttostr(i);
    s:=s[Length(s)];
    LigneStr:=LigneStr+s;
  end;
  LigneDec := LigneDec+ '    ';
  Memo4.Lines.Add(LigneDec+LigneStr);

  LigneStr:='';
  for i:=1 to 60 do begin
    s:=inttostr(i);
    while Length(s)<10 do
      s:=' '+s;
    LigneStr:=LigneStr+s;
  end;
  Memo5.Lines.Add(LigneStr);
  LigneStr:='';
  for i:=1 to 600 do
  begin  
    s:=inttostr(i);
    s:=s[Length(s)];
    LigneStr:=LigneStr+s;
  end;
  Memo5.Lines.Add(LigneStr);


  Stream := TMemoryStream.Create;
  Memo4.Lines.BeginUpdate;
  Memo5.Lines.BeginUpdate;

 // MemD_Article.DisableControls;
  try
    Stream.LoadFromFile(AFileName);
    Stream.Seek(0, soFromBeginning);
    Lab_LongArt.Caption:=FormatFloat('#,##0',Stream.Size);

  (*  P := Stream.Memory;
    if P <> nil then
    begin
      Compte:=0;
      while (Compte<=Stream.Size) do
      begin 
        Start:=P;
        while (P^<>10) and (Compte<=Stream.Size) do
        begin
          Inc(P);
          inc(Compte);
        end;
        SetString(s,PChar(Start),PChar(p)-PChar(Start));
        TraiteLigne(s);

        if P^ = 10 then
        begin
          Inc(P);
          inc(Compte);
        end;
      end;
    end;    *)

    TailleRec:=195;

    repeat 
      SetString(S, nil, TailleRec); 
      lu := Stream.Read(Pointer(S)^, TailleRec);
      TraiteLigne(s);
    until (lu<>TailleRec);

    Stream.Seek(StrToIntDef(Edt_DemarArt.Text,0), soFromBeginning);   

    Cnt := 0;
    LigneDec := '';
    LigneStr := ''; 
    LigneDes := '';

    Nb9 := 0;
    bStop:=false;
    Compte:=0;
    repeat
      inc(Compte);
      lu := Stream.Read(b,Sizeof(Byte));
      if lu=SizeOf(Byte) then
      begin

        Inc(Cnt);
        s:=inttostr(b);
        while Length(s)<4 do
          s:=' '+s;
        LigneDec := LigneDec+s;
        if b<32 then
        begin
          LigneStr := LigneStr+' ';
          LigneDes := LigneDes+'    ';
        end
        else begin
          LigneStr := LigneStr+Chr(b);
          s:=Chr(b);
          While Length(s)<4 do
            s:=' '+s;
          LigneDes := LigneDes+s;
        end;
        if Cnt= NbMax then
        begin
          LigneDec := LigneDec+ '    ';
          Memo4.Lines.Add(LigneDec+LigneStr);
          Memo4.Lines.Add(LigneDes);
          LigneDec := '';
          LigneStr := '';
          LigneDes := '';
          Cnt:=0;
        end;
        if b=9 then  //au bout de 3 "9", j'arrete de lire
          Inc(Nb9)
        else
          Nb9 := 0;
        if Nb9=3 then
          bStop:=true;
      end;
    until (lu<>Sizeof(Byte)) or bStop or (Compte=StrToIntDef(Edt_LongArt.Text,20000));

    if LigneDec<>'' then begin
      While Length(LigneDec)< (4*NbMax) do
        LigneDec:=LigneDec+' ';
      LigneDec := LigneDec+ '    ';
      Memo4.Lines.Add(LigneDec+LigneStr);
      Memo4.Lines.Add(LigneDes);
    end;
  finally            
   (* case Rgr_OrdCli.ItemIndex of
      0:MemD_Client.SortedField:='Code';
      1:MemD_Client.SortedField:='NomPre';
    end;
    MemD_Article.First;
    MemD_Article.EnableControls;   *)
    Memo4.Lines.EndUpdate;
    Memo5.Lines.EndUpdate;
    Stream.Free;
  end;
end;        

procedure TMainForm.LireFichier(AFileName:string);
var
  Stream:TMemoryStream;
  Cnt: integer;
  b: byte;
  lu: byte;
  s: String;
  LigneDec: String;
  LigneStr: String;
  LigneDes: String;
  NbMax,i :integer;
  Nb9: integer;
  bStop: boolean;

  Compte:integer;

  P, Start: PByte;
  TailleRec:integer;

  procedure TraiteLigne(TpS:string);
  var
    Lng:string;
    ij:integer;
  begin
      Lng:='';
      for ij:=1 to Length(TpS) do
      begin
        if TpS[ij]=#0 then
          Lng:=Lng+chr(255)
        else
          LnG:=Lng+Tps[ij];
      end;
      memo11.Lines.Add(Copy(Lng,1,600));

  end;

begin
  Memo10.Clear;
  Memo11.Clear;
  NbMax := 81;
  LigneDec := '';
  LigneStr := '';
  LigneDes := '';
  for i:=1 to NbMax do
  begin
    s:=inttostr(i);
    s:=s[Length(s)];
    while Length(s)<4 do
      s:=' '+s;
    LigneDec:=LigneDec+s;
    s:=inttostr(i);
    s:=s[Length(s)];
    LigneStr:=LigneStr+s;
  end;
  LigneDec := LigneDec+ '    ';
  Memo10.Lines.Add(LigneDec+LigneStr);

  LigneStr:='';
  for i:=1 to 60 do begin
    s:=inttostr(i);
    while Length(s)<10 do
      s:=' '+s;
    LigneStr:=LigneStr+s;
  end;
  Memo11.Lines.Add(LigneStr);
  LigneStr:='';
  for i:=1 to 600 do
  begin  
    s:=inttostr(i);
    s:=s[Length(s)];
    LigneStr:=LigneStr+s;
  end;
  Memo11.Lines.Add(LigneStr);


  Stream := TMemoryStream.Create;
  Memo10.Lines.BeginUpdate;
  Memo11.Lines.BeginUpdate;

 // MemD_Article.DisableControls;
  try
    Stream.LoadFromFile(AFileName);
    Stream.Seek(0, soFromBeginning);
    Lab_LongArt.Caption:=FormatFloat('#,##0',Stream.Size);

    if Rgr_Mtd.ItemIndex = 0 then
    begin
      P := Stream.Memory;
      if P <> nil then
      begin
        Compte:=0;
        while (Compte<=Stream.Size) do
        begin
          Start:=P;
          while (P^<>10) and (Compte<=Stream.Size) do
          begin
            Inc(P);
            inc(Compte);
          end;
          SetString(s,PChar(Start),PChar(p)-PChar(Start));
          TraiteLigne(s);

          if P^ = 10 then
          begin
            Inc(P);
            inc(Compte);
          end;
        end;
      end;
    end;

    if Rgr_Mtd.ItemIndex = 1 then
    begin
      TailleRec:=StrToIntDef(Edt_LngRStr.Text,10);
      if TailleRec<=0 then
        TailleRec:=10;

      repeat
        SetString(S, nil, TailleRec);
        lu := Stream.Read(Pointer(S)^, TailleRec);
        TraiteLigne(s);
      until (lu<>TailleRec);
    end;

    Stream.Seek(StrToIntDef(Edt_DemarArt.Text,0), soFromBeginning);   

    Cnt := 0;
    LigneDec := '';
    LigneStr := ''; 
    LigneDes := '';

    Nb9 := 0;
    bStop:=false;
    Compte:=0;
    repeat
      inc(Compte);
      lu := Stream.Read(b,Sizeof(Byte));
      if lu=SizeOf(Byte) then
      begin

        Inc(Cnt);
        s:=inttostr(b);
        while Length(s)<4 do
          s:=' '+s;
        LigneDec := LigneDec+s;
        if b<32 then
        begin
          LigneStr := LigneStr+' ';
          LigneDes := LigneDes+'    ';
        end
        else begin
          LigneStr := LigneStr+Chr(b);
          s:=Chr(b);
          While Length(s)<4 do
            s:=' '+s;
          LigneDes := LigneDes+s;
        end;
        if Cnt= NbMax then
        begin
          LigneDec := LigneDec+ '    ';
          Memo10.Lines.Add(LigneDec+LigneStr);
          Memo10.Lines.Add(LigneDes);
          LigneDec := '';
          LigneStr := '';
          LigneDes := '';
          Cnt:=0;
        end;
        if b=9 then  //au bout de 3 "9", j'arrete de lire
          Inc(Nb9)
        else
          Nb9 := 0;
        if Nb9=3 then
          bStop:=true;
      end;
    until (lu<>Sizeof(Byte)) or bStop or (Compte=StrToIntDef(Edt_LongArt.Text,20000));

    if LigneDec<>'' then begin
      While Length(LigneDec)< (4*NbMax) do
        LigneDec:=LigneDec+' ';
      LigneDec := LigneDec+ '    ';
      Memo10.Lines.Add(LigneDec+LigneStr);
      Memo10.Lines.Add(LigneDes);
    end;
  finally
    Memo10.Lines.EndUpdate;
    Memo11.Lines.EndUpdate;
    Stream.Free;
  end;
end;

procedure TMainForm.LireModele(AFileName:string);
var
  Stream:TMemoryStream;
  Cnt: integer;
  b: byte;
  lu: byte;
  s: String;
  LigneDec: String;
  LigneStr: String;
  LigneDes: String;
  NbMax,i :integer;
  Nb9: integer;
  bStop: boolean;

  Compte:integer;

  P, Start: PByte;
  TailleRec:integer;

  procedure TraiteLigne(TpS:string);
  var
    Lng:string;
    ij:integer;
    sCode:string;
    sNom:string;
  begin
    if (Length(Tps)>=9) and (TpS[9]=#1) then
    begin
      Lng:='';
      for ij:=1 to Length(TpS) do
      begin
        if TpS[ij]=#0 then
          Lng:=Lng+chr(255)
        else
          LnG:=Lng+Tps[ij];
      end;
      memo9.Lines.Add(Copy(Lng,1,600));
      sCode:=Trim(Copy(Tps,4,5));
      sNom:=Trim(Copy(Tps,11,30));

      MemD_Modele.Append;
      MemD_Modele.fieldbyname('Code').AsString:=sCode;
      MemD_Modele.fieldbyname('Nom').AsString:=sNom;
      MemD_Modele.Post;

    end;
  end;

begin 
  MemD_Modele.Active:=false;
  MemD_Modele.Active:=true;
  MemD_Modele.SortedField:='';

  Memo8.Clear;
  Memo9.Clear;
  NbMax := 30;
  LigneDec := '';
  LigneStr := '';
  LigneDes := '';
  for i:=1 to NbMax do
  begin
    s:=inttostr(i);
    s:=s[Length(s)];
    while Length(s)<4 do
      s:=' '+s;
    LigneDec:=LigneDec+s;
    s:=inttostr(i);
    s:=s[Length(s)];
    LigneStr:=LigneStr+s;
  end;
  LigneDec := LigneDec+ '    ';
  Memo8.Lines.Add(LigneDec+LigneStr);

  LigneStr:='';
  for i:=1 to 60 do begin
    s:=inttostr(i);
    while Length(s)<10 do
      s:=' '+s;
    LigneStr:=LigneStr+s;
  end;
  Memo9.Lines.Add(LigneStr);
  LigneStr:='';
  for i:=1 to 600 do
  begin  
    s:=inttostr(i);
    s:=s[Length(s)];
    LigneStr:=LigneStr+s;
  end;
  Memo9.Lines.Add(LigneStr);


  Stream := TMemoryStream.Create;
  Memo8.Lines.BeginUpdate;
  Memo9.Lines.BeginUpdate;

 // MemD_Article.DisableControls;
  try
    Stream.LoadFromFile(AFileName);
    Stream.Seek(0, soFromBeginning);
    Lab_LongArt.Caption:=FormatFloat('#,##0',Stream.Size);

   (* P := Stream.Memory;
    if P <> nil then
    begin
      Compte:=0;
      while (Compte<=Stream.Size) do
      begin 
        Start:=P;
        while (P^<>10) and (Compte<=Stream.Size) do
        begin
          Inc(P);
          inc(Compte);
        end;
        SetString(s,PChar(Start),PChar(p)-PChar(Start));
        TraiteLigne(s);

        if P^ = 10 then
        begin
          Inc(P);
          inc(Compte);
        end;
      end;
    end;       *)

    TailleRec:=74;

    repeat 
      SetString(S, nil, TailleRec); 
      lu := Stream.Read(Pointer(S)^, TailleRec);
      TraiteLigne(s);
    until (lu<>TailleRec);    

    Stream.Seek(StrToIntDef(Edt_DemarArt.Text,0), soFromBeginning);   

    Cnt := 0;
    LigneDec := '';
    LigneStr := ''; 
    LigneDes := '';

    Nb9 := 0;
    bStop:=false;
    Compte:=0;
    repeat
      inc(Compte);
      lu := Stream.Read(b,Sizeof(Byte));
      if lu=SizeOf(Byte) then
      begin

        Inc(Cnt);
        s:=inttostr(b);
        while Length(s)<4 do
          s:=' '+s;
        LigneDec := LigneDec+s;
        if b<32 then
        begin
          LigneStr := LigneStr+' ';
          LigneDes := LigneDes+'    ';
        end
        else begin
          LigneStr := LigneStr+Chr(b);
          s:=Chr(b);
          While Length(s)<4 do
            s:=' '+s;
          LigneDes := LigneDes+s;
        end;
        if Cnt= NbMax then
        begin
          LigneDec := LigneDec+ '    ';
          Memo8.Lines.Add(LigneDec+LigneStr);
          Memo8.Lines.Add(LigneDes);
          LigneDec := '';
          LigneStr := '';
          LigneDes := '';
          Cnt:=0;
        end;
        if b=9 then  //au bout de 3 "9", j'arrete de lire
          Inc(Nb9)
        else
          Nb9 := 0;
        if Nb9=3 then
          bStop:=true;
      end;
    until (lu<>Sizeof(Byte)) or bStop or (Compte=StrToIntDef(Edt_LongArt.Text,20000));

    if LigneDec<>'' then begin
      While Length(LigneDec)< (4*NbMax) do
        LigneDec:=LigneDec+' ';
      LigneDec := LigneDec+ '    ';
      Memo8.Lines.Add(LigneDec+LigneStr);
      Memo8.Lines.Add(LigneDes);
    end;
  finally
    MemD_Modele.SortedField:='Code';
    MemD_Modele.First;
    MemD_Modele.EnableControls;
    Memo8.Lines.EndUpdate;
    Memo9.Lines.EndUpdate;
    Stream.Free;
  end;
end;

procedure TMainForm.LireMarque(AFileName:string);
var
  Stream:TMemoryStream;
  Cnt: integer;
  b: byte;
  lu: byte;
  s: String;
  LigneDec: String;
  LigneStr: String;
  LigneDes: String;
  NbMax,i :integer;
  Nb9: integer;
  bStop: boolean;

  Compte:integer;

  P, Start: PByte;
  TailleRec:integer;

  procedure TraiteLigne(TpS:string);
  var
    Lng:string;
    ij:integer;
    sCode:string;
    sNom:string;
  begin
    if (Length(Tps)>=3) and (TpS[4]=#1) then
    begin
      Lng:='';
      for ij:=1 to Length(TpS) do
      begin
        if TpS[ij]=#0 then
          Lng:=Lng+chr(255)
        else
          LnG:=Lng+Tps[ij];
      end;
      //SetString(TpS,PChar(pDeb),PChar(pFin));
      memo7.Lines.Add(Copy(Lng,1,600));
      sCode:=Trim(Copy(TpS,1,3));
      sNom:=Trim(Copy(TpS,8,20));

      MemD_Marque.Append;
      MemD_Marque.FieldByName('Code').AsString:=sCode;
      MemD_Marque.FieldByName('Nom').AsString:=sNom;
      MemD_Marque.Post;

    end;
  end;

begin 
  MemD_Marque.Active:=false;
  MemD_Marque.Active:=true;
  MemD_Marque.SortedField:='';

  Memo6.Clear;
  Memo7.Clear;
  NbMax := 30;
  LigneDec := '';
  LigneStr := '';
  LigneDes := '';
  for i:=1 to NbMax do
  begin
    s:=inttostr(i);
    s:=s[Length(s)];
    while Length(s)<4 do
      s:=' '+s;
    LigneDec:=LigneDec+s;
    s:=inttostr(i);
    s:=s[Length(s)];
    LigneStr:=LigneStr+s;
  end;
  LigneDec := LigneDec+ '    ';
  Memo6.Lines.Add(LigneDec+LigneStr);

  LigneStr:='';
  for i:=1 to 60 do begin
    s:=inttostr(i);
    while Length(s)<10 do
      s:=' '+s;
    LigneStr:=LigneStr+s;
  end;
  Memo7.Lines.Add(LigneStr);
  LigneStr:='';
  for i:=1 to 600 do
  begin  
    s:=inttostr(i);
    s:=s[Length(s)];
    LigneStr:=LigneStr+s;
  end;
  Memo7.Lines.Add(LigneStr);


  Stream := TMemoryStream.Create;
  Memo6.Lines.BeginUpdate;
  Memo7.Lines.BeginUpdate;

  MemD_Marque.DisableControls;
  try
    Stream.LoadFromFile(AFileName);
    Stream.Seek(0, soFromBeginning);

   (* P := Stream.Memory;
    if P <> nil then
    begin
      Compte:=0;
      while (Compte<=Stream.Size) do
      begin 
        Start:=P;
        while (P^<>10) and (Compte<=Stream.Size) do
        begin
          Inc(P);
          inc(Compte);
        end;
        SetString(s,PChar(Start),PChar(p)-PChar(Start));
        TraiteLigne(s);

        if P^ = 10 then
        begin
          Inc(P);
          inc(Compte);
        end;
      end;
    end;  *)

    TailleRec:=37;

    repeat 
      SetString(S, nil, TailleRec); 
      lu := Stream.Read(Pointer(S)^, TailleRec);
      TraiteLigne(s);
    until (lu<>TailleRec);

    Stream.Seek(StrToIntDef(Edt_DemarArt.Text,0), soFromBeginning);   

    Cnt := 0;
    LigneDec := '';
    LigneStr := ''; 
    LigneDes := '';

    Nb9 := 0;
    bStop:=false;
    Compte:=0;
    repeat
      inc(Compte);
      lu := Stream.Read(b,Sizeof(Byte));
      if lu=SizeOf(Byte) then
      begin

        Inc(Cnt);
        s:=inttostr(b);
        while Length(s)<4 do
          s:=' '+s;
        LigneDec := LigneDec+s;
        if b<32 then
        begin
          LigneStr := LigneStr+' ';
          LigneDes := LigneDes+'    ';
        end
        else begin
          LigneStr := LigneStr+Chr(b);
          s:=Chr(b);
          While Length(s)<4 do
            s:=' '+s;
          LigneDes := LigneDes+s;
        end;
        if Cnt= NbMax then
        begin
          LigneDec := LigneDec+ '    ';
          Memo6.Lines.Add(LigneDec+LigneStr);
          Memo6.Lines.Add(LigneDes);
          LigneDec := '';
          LigneStr := '';
          LigneDes := '';
          Cnt:=0;
        end;
        if b=9 then  //au bout de 3 "9", j'arrete de lire
          Inc(Nb9)
        else
          Nb9 := 0;
        if Nb9=3 then
          bStop:=true;
      end;
    until (lu<>Sizeof(Byte)) or bStop or (Compte=StrToIntDef(Edt_LongArt.Text,20000));

    if LigneDec<>'' then begin
      While Length(LigneDec)< (4*NbMax) do
        LigneDec:=LigneDec+' ';
      LigneDec := LigneDec+ '    ';
      Memo6.Lines.Add(LigneDec+LigneStr);
      Memo6.Lines.Add(LigneDes);
    end;
  finally             
    MemD_Marque.SortedField:='Code';
    MemD_Marque.First;
    MemD_Marque.EnableControls;
    Memo6.Lines.EndUpdate;
    Memo7.Lines.EndUpdate;
    Stream.Free;
  end;
end;

procedure TMainForm.LireArticle(AFileName:string);
var
  Stream:TMemoryStream;
  Cnt: integer;
  b: byte;
  lu: byte;
  s: String;
  LigneDec: String;
  LigneStr: String;
  LigneDes: String;
  NbMax,i :integer;
  Nb9: integer;
  bStop: boolean;

  Compte:integer;

  P, Start: PByte;
  TailleRec:integer;

  procedure TraiteLigne(TpS:string);
  var
    Lng:string;
    ij:integer;
    sCode:string;
    sCodMarq:string;
    sNomMarq:string;
    sCodModel:string;
    sNomModel:string;
    sCodCateg:string;
    sNomCateg:string;
    sTaille:string;
    sExercice:string;
    sAchat:string;
    sAchat2:string;  
    sEtat:string;
    sEtat2:string;
    c:char;
    vAchat:Double;
    b:byte;   
    vEtat:Double;
    sFix:string;
    sPFix:string;
    sPFix2:string;
    vPFix:Double;
    sNoSerie:string;
  begin
    if (Length(Tps)>=13) and (TpS[14]=#1) then
    begin
      Lng:='';
      for ij:=1 to Length(TpS) do
      begin
        if TpS[ij]=#0 then
          Lng:=Lng+chr(255)
        else
          LnG:=Lng+Tps[ij];
      end;
      //SetString(TpS,PChar(pDeb),PChar(pFin));
      memo5.Lines.Add(Copy(Lng,1,600));
      

      sCode:=Trim(Copy(TpS,1,13));
      sCodMarq:=Trim(Copy(TpS,28,3));
      sNomMarq:=Trim(Copy(TpS,31,10));
      sCodModel:=Trim(Copy(TpS,41,5));
      sNomModel:=Trim(Copy(TpS,46,15));
      sFix:=Trim(Copy(TpS,61,10));
      sCodCateg:=Trim(Copy(TpS,99,5));   
      sNoSerie:=Trim(Copy(TpS,110,15));
      sNomCateg:='';
      sTaille:=Trim(Copy(TpS,92,7));
      sExercice:=Trim(Copy(TpS,106,4));
      sAchat:=Trim(Copy(TpS,71,5));
      sAchat2:='';
      for ij:=1 to Length(sAchat) do
      begin
        b:=Ord(sAchat[ij]);
        sAchat2:=sAchat2+inttohex(b,2);
      end;
      sAchat2:=UpperCase(sAchat2);
      vAchat:=0;
      if Length(sAchat2)>0 then
      begin
        if sAchat2[1]='B' then
          sAchat:='-'
        else
          sAchat:='';
        for ij:=2 to Length(sAchat2) do
        begin
          c:=sAchat2[ij];
          case c of
            '0'..'9':sAchat:=sAchat+c;
            'A':sAchat:=sAchat+DecimalSeparator;
          end;
        end;
        vAchat:=StrToFloatDef(sAchat,-1);
      end;
      
      sEtat:=Trim(Copy(TpS,87,5));
      sEtat2:='';
      for ij:=1 to Length(sEtat) do
      begin
        b:=Ord(sEtat[ij]);
        sEtat2:=sEtat2+inttohex(b,2);
      end;
      sEtat2:=UpperCase(sEtat2);
      vEtat:=0;
      if Length(sEtat2)>0 then
      begin
        if sEtat2[1]='B' then
          sEtat:='-'
        else
          sEtat:='';
        for ij:=2 to Length(sEtat2) do
        begin
          c:=sEtat2[ij];
          case c of
            '0'..'9':sEtat:=sEtat+c;
            'A':sEtat:=sEtat+DecimalSeparator;
          end;
        end;
        vEtat:=StrToFloatDef(sEtat,-1);
      end;

      sPFix:=Trim(Copy(TpS,79,5));
      sPFix2:='';
      for ij:=1 to Length(sPFix) do
      begin
        b:=Ord(sPFix[ij]);
        sPFix2:=sPFix2+inttohex(b,2);
      end;
      sPFix2:=UpperCase(sPFix2);
      vPFix:=0;
      if Length(sPFix2)>0 then
      begin
        if sPFix2[1]='B' then
          sPFix:='-'
        else
          sPFix:='';
        for ij:=2 to Length(sPFix2) do
        begin
          c:=sPFix2[ij];
          case c of
            '0'..'9':sPFix:=sPFix+c;
            'A':sPFix:=sPFix+DecimalSeparator;
          end;
        end;
        vPFix:=StrToFloatDef(sPFix,-1);
      end;

      MemD_Article.Append;
      MemD_Article.FieldByName('Code').AsString:=sCode;
      MemD_Article.FieldByName('CodMarq').AsString:=sCodMarq;
      MemD_Article.FieldByName('NomMarq').AsString:=sNomMarq;
      MemD_Article.FieldByName('CodModel').AsString:=sCodModel;
      MemD_Article.FieldByName('NomModel').AsString:=sNomModel;
      MemD_Article.FieldByName('CodCateg').AsString:=sCodCateg;
      MemD_Article.FieldByName('Taille').AsString:=sTaille;
      MemD_Article.FieldByName('Exercice').AsString:=sExercice;
      MemD_Article.FieldByName('PAchat').AsFloat:=vAchat;
      MemD_Article.FieldByName('Etat').AsFloat:=vEtat;
      MemD_Article.FieldByName('Fixation').AsString:=sFix;
      MemD_Article.FieldByName('PFix').AsFloat:=vPFix;  
      MemD_Article.FieldByName('NoSerie').AsString:=sNoSerie;
      MemD_Article.Post;

    end;
  end;

begin 
  MemD_Article.Active:=false;
  MemD_Article.Active:=true;
  MemD_Article.SortedField:='';

  Memo4.Clear;
  Memo5.Clear;
  NbMax := 195;
  LigneDec := '';
  LigneStr := '';
  LigneDes := '';
  for i:=1 to NbMax do
  begin
    s:=inttostr(i);
    s:=s[Length(s)];
    while Length(s)<4 do
      s:=' '+s;
    LigneDec:=LigneDec+s;
    s:=inttostr(i);
    s:=s[Length(s)];
    LigneStr:=LigneStr+s;
  end;
  LigneDec := LigneDec+ '    ';
  Memo4.Lines.Add(LigneDec+LigneStr);

  LigneStr:='';
  for i:=1 to 60 do begin
    s:=inttostr(i);
    while Length(s)<10 do
      s:=' '+s;
    LigneStr:=LigneStr+s;
  end;
  Memo5.Lines.Add(LigneStr);
  LigneStr:='';
  for i:=1 to 600 do
  begin  
    s:=inttostr(i);
    s:=s[Length(s)];
    LigneStr:=LigneStr+s;
  end;
  Memo5.Lines.Add(LigneStr);


  Stream := TMemoryStream.Create;
  Memo4.Lines.BeginUpdate;
  Memo5.Lines.BeginUpdate;

  MemD_Article.DisableControls;
  try
    Stream.LoadFromFile(AFileName);
    Stream.Seek(0, soFromBeginning);
    Lab_LongArt.Caption:=FormatFloat('#,##0',Stream.Size);

  (*  P := Stream.Memory;
    if P <> nil then
    begin
      Compte:=0;
      while (Compte<=Stream.Size) do
      begin 
        Start:=P;
        while (P^<>10) and (Compte<=Stream.Size) do
        begin
          Inc(P);
          inc(Compte);
        end;
        SetString(s,PChar(Start),PChar(p)-PChar(Start));
        TraiteLigne(s);

        if P^ = 10 then
        begin
          Inc(P);
          inc(Compte);
        end;
      end;
    end;    *)

    TailleRec:=195;

    repeat 
      SetString(S, nil, TailleRec); 
      lu := Stream.Read(Pointer(S)^, TailleRec);
      TraiteLigne(s);
    until (lu<>TailleRec);

    Stream.Seek(StrToIntDef(Edt_DemarArt.Text,0), soFromBeginning);   

    Cnt := 0;
    LigneDec := '';
    LigneStr := ''; 
    LigneDes := '';

    Nb9 := 0;
    bStop:=false;
    Compte:=0;
    repeat
      inc(Compte);
      lu := Stream.Read(b,Sizeof(Byte));
      if lu=SizeOf(Byte) then
      begin

        Inc(Cnt);
        s:=inttohex(b,2);
        while Length(s)<4 do
          s:=' '+s;
        LigneDec := LigneDec+s;
        if b<32 then
        begin
          LigneStr := LigneStr+' ';
          LigneDes := LigneDes+'    ';
        end
        else begin
          LigneStr := LigneStr+Chr(b);
          s:=Chr(b);
          While Length(s)<4 do
            s:=' '+s;
          LigneDes := LigneDes+s;
        end;
        if Cnt= NbMax then
        begin
          LigneDec := LigneDec+ '    ';
          Memo4.Lines.Add(LigneDec+LigneStr);
          Memo4.Lines.Add(LigneDes);
          LigneDec := '';
          LigneStr := '';
          LigneDes := '';
          Cnt:=0;
        end;
        if b=9 then  //au bout de 3 "9", j'arrete de lire
          Inc(Nb9)
        else
          Nb9 := 0;
        if Nb9=3 then
          bStop:=true;
      end;
    until (lu<>Sizeof(Byte)) or bStop or (Compte=StrToIntDef(Edt_LongArt.Text,20000));

    if LigneDec<>'' then begin
      While Length(LigneDec)< (4*NbMax) do
        LigneDec:=LigneDec+' ';
      LigneDec := LigneDec+ '    ';
      Memo4.Lines.Add(LigneDec+LigneStr);
      Memo4.Lines.Add(LigneDes);
    end;
  finally
    MemD_Article.SortedField:='Code';
    MemD_Article.First;
    MemD_Article.EnableControls;
    Memo4.Lines.EndUpdate;
    Memo5.Lines.EndUpdate;
    Stream.Free;
  end;
end;       

procedure TMainForm.LireCptl(AFileName:string);
var
  Stream:TMemoryStream;
  Cnt: integer;
  b: byte;
  lu: byte;
  s: String;
  LigneDec: String;
  LigneStr: String;
  LigneDes: String;
  NbMax,i :integer;
  Nb9: integer;
  bStop: boolean;

  Compte:integer;

  P, Start: PByte;
  TailleRec:integer;

  procedure TraiteLigne(TpS:string);
  var
    Lng:string;
    ij:integer;
    sCode:string;
    sDate1:string;
    sDate2:string;
  begin
    if (Length(Tps)>=10) and (TpS[10]=#1) then
    begin
      Lng:='';
      for ij:=1 to Length(TpS) do
      begin
        if TpS[ij]=#0 then
          Lng:=Lng+chr(255)
        else
          LnG:=Lng+Tps[ij];
      end;
      //SetString(TpS,PChar(pDeb),PChar(pFin));
      memo13.Lines.Add(Copy(Lng,1,600));  
      sCode:=Trim(Copy(TpS,1,8));
      sDate1:=Trim(Copy(TpS,20,8));
      sDate2:=Trim(Copy(TpS,84,8));

      if Length(sCode)<=5 then
      begin
        MemD_Cptl.Append;
        MemD_Cptl.FieldByName('Code').AsString:=sCode;
        MemD_Cptl.FieldByName('Date1').AsString:=sDate1;
        MemD_Cptl.FieldByName('Date2').AsString:=sDate2;
        MemD_Cptl.Post;
      end;

    end;
  end;

begin 
  MemD_Cptl.Active:=false;
  MemD_Cptl.Active:=true;
  MemD_Cptl.SortedField:='';

  Memo12.Clear;
  Memo13.Clear;
  NbMax := 139;
  LigneDec := '';
  LigneStr := '';
  LigneDes := '';
  for i:=1 to NbMax do
  begin
    s:=inttostr(i);
    s:=s[Length(s)];
    while Length(s)<4 do
      s:=' '+s;
    LigneDec:=LigneDec+s;
    s:=inttostr(i);
    s:=s[Length(s)];
    LigneStr:=LigneStr+s;
  end;
  LigneDec := LigneDec+ '    ';
  Memo12.Lines.Add(LigneDec+LigneStr);

  LigneStr:='';
  for i:=1 to 60 do begin
    s:=inttostr(i);
    while Length(s)<10 do
      s:=' '+s;
    LigneStr:=LigneStr+s;
  end;
  Memo13.Lines.Add(LigneStr);
  LigneStr:='';
  for i:=1 to 600 do
  begin  
    s:=inttostr(i);
    s:=s[Length(s)];
    LigneStr:=LigneStr+s;
  end;
  Memo13.Lines.Add(LigneStr);


  Stream := TMemoryStream.Create;
  Memo12.Lines.BeginUpdate;
  Memo13.Lines.BeginUpdate;

  MemD_Cptl.DisableControls;
  try
    Stream.LoadFromFile(AFileName);
    Stream.Seek(0, soFromBeginning);
    Lab_LongArt.Caption:=FormatFloat('#,##0',Stream.Size);

   (* P := Stream.Memory;
    if P <> nil then
    begin
      Compte:=0;
      while (Compte<=Stream.Size) do
      begin 
        Start:=P;
        while (P^<>10) and (Compte<=Stream.Size) do
        begin
          Inc(P);
          inc(Compte);
        end;
        SetString(s,PChar(Start),PChar(p)-PChar(Start));
        TraiteLigne(s);

        if P^ = 10 then
        begin
          Inc(P);
          inc(Compte);
        end;
      end;
    end;   *)

    TailleRec:=139;

    repeat 
      SetString(S, nil, TailleRec); 
      lu := Stream.Read(Pointer(S)^, TailleRec);
      TraiteLigne(s);
    until (lu<>TailleRec);

    Stream.Seek(StrToIntDef(Edt_DemarArt.Text,0), soFromBeginning);   

    Cnt := 0;
    LigneDec := '';
    LigneStr := ''; 
    LigneDes := '';

    Nb9 := 0;
    bStop:=false;
    Compte:=0;
    repeat
      inc(Compte);
      lu := Stream.Read(b,Sizeof(Byte));
      if lu=SizeOf(Byte) then
      begin

        Inc(Cnt);
        s:=inttostr(b);
        while Length(s)<4 do
          s:=' '+s;
        LigneDec := LigneDec+s;
        if b<32 then
        begin
          LigneStr := LigneStr+' ';
          LigneDes := LigneDes+'    ';
        end
        else begin
          LigneStr := LigneStr+Chr(b);
          s:=Chr(b);
          While Length(s)<4 do
            s:=' '+s;
          LigneDes := LigneDes+s;
        end;
        if Cnt= NbMax then
        begin
          LigneDec := LigneDec+ '    ';
          Memo12.Lines.Add(LigneDec+LigneStr);
          Memo12.Lines.Add(LigneDes);
          LigneDec := '';
          LigneStr := '';
          LigneDes := '';
          Cnt:=0;
        end;
        if b=9 then  //au bout de 3 "9", j'arrete de lire
          Inc(Nb9)
        else
          Nb9 := 0;
        if Nb9=3 then
          bStop:=true;
      end;
    until (lu<>Sizeof(Byte)) or bStop or (Compte=StrToIntDef(Edt_LongArt.Text,20000));

    if LigneDec<>'' then begin
      While Length(LigneDec)< (4*NbMax) do
        LigneDec:=LigneDec+' ';
      LigneDec := LigneDec+ '    ';
      Memo12.Lines.Add(LigneDec+LigneStr);
      Memo12.Lines.Add(LigneDes);
    end;
  finally          
    MemD_Cptl.SortedField:='Code';
    MemD_Cptl.First;
    MemD_Cptl.EnableControls;
    Memo12.Lines.EndUpdate;
    Memo13.Lines.EndUpdate;
    Stream.Free;
  end;
end;

procedure TMainForm.MemD_ClientBeforePost(DataSet: TDataSet);
var
  s:string;
  sPre:string;
  sNom:string;
  i:integer;
  LPos:integer;
  Nb:integer;
  OuArret:integer;
begin
  OuArret:=MemD_Client.FieldByName('SeparPre').AsInteger;
  s:=MemD_Client.FieldByName('NomPre').AsString;
  if OuArret=0 then
  begin
    sNom:=s;
    sPre:='';
  end
  else
  begin
    LPos:=-1;
    i:=Length(s);
    Nb:=0;
    while (i>=1) and (LPos=-1) do
    begin
      if s[i]=' ' then
        inc(nb);
      if nb=OuArret then
        lPos:=i;
      dec(i);
    end;
    if lpos=-1 then
    begin
      sNom:='';
      sPre:=s;
    end
    else
    begin  
      sNom:=Trim(Copy(s,1,Lpos-1));
      sPre:=Trim(Copy(s,lpos,Length(s)));
    end;
  end;
  MemD_Client.FieldByName('Nom').AsString:=sNom;
  MemD_Client.FieldByName('Prenom').AsString:=sPre;
end;

procedure TMainForm.LireCateg(AFileName:string);
var
  Stream:TMemoryStream;
  Cnt: integer;
  b1, b2: byte;
  b: byte;
  lu: byte;
  s: String;
  LigneDec: String;
  LigneStr: String;
  LigneDes: String;
  NbMax,i :integer;
  Nb9: integer;
  bStop: boolean;

  NbCode:integer;
  OkCode:boolean;
  sCode:string;

  NbNom:integer;
  OkNom:boolean;
  sNom:string;
begin
  MemD_Categ.Active:=false;
  MemD_Categ.Active:=true;
  MemD_Categ.SortedField:='';
  Memo1.Clear;
  NbMax := 30;
  LigneDec := '';
  LigneStr := '';
  LigneDes := '';
  for i:=1 to NbMax do
  begin
    s:=inttostr(i);
    s:=s[Length(s)];
    while Length(s)<4 do
      s:=' '+s;
    LigneDec:=LigneDec+s;
    s:=inttostr(i);
    s:=s[Length(s)];
    LigneStr:=LigneStr+s;
  end;
  LigneDec := LigneDec+ '    ';
  Memo1.Lines.Add(LigneDec+LigneStr);

  Stream := TMemoryStream.Create;
  Memo1.Lines.BeginUpdate;
  MemD_Categ.DisableControls;
  try
    Stream.LoadFromFile(AFileName);
    Stream.Seek(0, soFromBeginning);
    Cnt := 0;
    LigneDec := '';
    LigneStr := ''; 
    LigneDes := '';

    NbCode:=0;
    OkCode:=true;
    sCode:='';
    NbNom:=0;
    OkNom:=false;
    sNom:='';

    Nb9 := 0;
    bStop:=false;
    b1:=0;
    b2:=0;
    repeat
      lu := Stream.Read(b,Sizeof(Byte));
      if lu=SizeOf(Byte) then
      begin

        //code categ
        if (b2=32) and (b1=10) then
        begin
          sCode:='';
          NbCode:=0;
          OkCode:=true;
        end;
        if OkCode then
        begin
          sCode:=sCode+Chr(b);
          Inc(NbCode);
        end;
        if NbCode=5 then
        begin
          sCode:=Trim(sCode);
          OkCode:=false;
          NbCode:=0;
        end;

        //nom categ
        if (b2=1) and (b1=155) then
        begin                     
          sNom:='';
          NbNom:=0;
          OkNom:=true;
        end;
        if OkNom then
        begin  
          sNom:=sNom+Chr(b);
          Inc(NbNom);
        end; 
        if NbNom=30 then
        begin
          sNom:=Trim(sNom);
          OkNom:=false;
          NbNom:=0;
          MemD_Categ.Append;
          MemD_Categ.fieldbyname('Code').AsString:=sCode;
          MemD_Categ.fieldbyname('Nom').AsString:=sNom;
          MemD_Categ.Post;
        end;

        Inc(Cnt);
        s:=inttostr(b);
        while Length(s)<4 do
          s:=' '+s;
        LigneDec := LigneDec+s;
        if b<32 then
        begin
          LigneStr := LigneStr+' ';
          LigneDes := LigneDes+'    ';
        end
        else begin
          LigneStr := LigneStr+Chr(b);
          s:=Chr(b);
          While Length(s)<4 do
            s:=' '+s;
          LigneDes := LigneDes+s;
        end;
        if Cnt= NbMax then
        begin
          LigneDec := LigneDec+ '    ';
          Memo1.Lines.Add(LigneDec+LigneStr); 
          Memo1.Lines.Add(LigneDes);
          LigneDec := '';
          LigneStr := '';
          LigneDes := '';
          Cnt:=0;
        end;
        if b=9 then  //au bout de 3 "9", j'arrete de lire
          Inc(Nb9)
        else
          Nb9 := 0;
        if Nb9=3 then
          bStop:=true;
        b2:=b1;
        b1:=b;
      end;
    until (lu<>Sizeof(Byte)) or bStop;
    if LigneDec<>'' then begin
      While Length(LigneDec)< (4*NbMax) do
        LigneDec:=LigneDec+' ';
      LigneDec := LigneDec+ '    ';
      Memo1.Lines.Add(LigneDec+LigneStr);
      Memo1.Lines.Add(LigneDes);
    end;
  finally                
    MemD_Categ.SortedField:='Nom';
    MemD_Categ.First;
    MemD_Categ.EnableControls;
    Memo1.Lines.EndUpdate;
    Stream.Free;
  end;
end;

procedure TMainForm.Nbt_ArtClick(Sender: TObject);
begin   
  if FileExists(ReperProlog+'SK00ARTL.D') then
  begin
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    try
      LireArticle(ReperProlog+'SK00ARTL.D');
    finally
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  end;
end;

procedure TMainForm.Nbt_CategClick(Sender: TObject);
begin
  if FileExists(ReperProlog+'SK00CATE.D') then
  begin
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    try
      LireCateg(ReperProlog+'SK00CATE.D');
    finally
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  end;
end;

procedure TMainForm.Nbt_ChargArtClick(Sender: TObject);
var
  sFic:string;
begin
  sFic:=ReperBase+'Article_Int.csv';
  if not(FileExists(sFic)) then
  begin
    MessageDlg('Fichier inexistant !',mterror,[mbok],0);
    exit;
  end;
  try
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    MemD_Article.DisableControls;
    MemD_Article.SortedField:='';
    try
      MemD_Article.Active:=false;
      MemD_Article.Active:=true;
      MemD_Article.LoadFromTextFile(sFic);
    finally
      MemD_Article.SortedField:='Code';
      MemD_Article.EnableControls;
      MemD_Article.First;
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  except
    on E:Exception do
      MessageDlg(E.Message,mterror,[mbok],0);
  end;
end;

procedure TMainForm.Nbt_ChargeCategClick(Sender: TObject);
var
  sFic:string;
begin
  sFic:=ReperBase+'Categ_Int.csv';
  if not(FileExists(sFic)) then
  begin
    MessageDlg('Fichier inexistant !',mterror,[mbok],0);
    exit;
  end;
  try
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    MemD_Categ.DisableControls;
    MemD_Categ.SortedField:='';
    try
      MemD_Categ.Active:=false;
      MemD_Categ.Active:=true;
      MemD_Categ.LoadFromTextFile(sFic);
    finally                       
      MemD_Categ.SortedField:='Nom';
      MemD_Categ.EnableControls;
      MemD_Categ.First;
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  except
    on E:Exception do
      MessageDlg(E.Message,mterror,[mbok],0);
  end;
end;

procedure TMainForm.Nbt_ChargeClientClick(Sender: TObject);
var
  sFic:string;
begin
  sFic:=ReperBase+'Client_Int.csv';
  if not(FileExists(sFic)) then
  begin
    MessageDlg('Fichier inexistant !',mterror,[mbok],0);
    exit;
  end;
  try
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    MemD_Client.DisableControls;
    MemD_Client.SortedField:='';
    try
      MemD_Client.Active:=false;
      MemD_Client.Active:=true;
      MemD_Client.LoadFromTextFile(sFic);
    finally
      case Rgr_OrdCli.ItemIndex of
        0:MemD_Client.SortedField:='Code';
        1:MemD_Client.SortedField:='NomPre';
      end;
      MemD_Client.EnableControls;
      MemD_Client.First;
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  except
    on E:Exception do
      MessageDlg(E.Message,mterror,[mbok],0);
  end;
end;

procedure TMainForm.Nbt_ChargeModeleClick(Sender: TObject);
var
  sFic:string;
begin
  sFic:=ReperBase+'Modele_Int.csv';
  if not(FileExists(sFic)) then
  begin
    MessageDlg('Fichier inexistant !',mterror,[mbok],0);
    exit;
  end;
  try
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    MemD_Modele.DisableControls;
    MemD_Modele.SortedField:='';
    try
      MemD_Modele.Active:=false;
      MemD_Modele.Active:=true;
      MemD_Modele.LoadFromTextFile(sFic);
    finally
      MemD_Modele.SortedField:='Code';
      MemD_Modele.EnableControls;
      MemD_Modele.First;
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  except
    on E:Exception do
      MessageDlg(E.Message,mterror,[mbok],0);
  end;
end;

procedure TMainForm.Nbt_ChargerMarqClick(Sender: TObject);
var
  sFic:string;
begin
  sFic:=ReperBase+'Marque_Int.csv';
  if not(FileExists(sFic)) then
  begin
    MessageDlg('Fichier inexistant !',mterror,[mbok],0);
    exit;
  end;
  try
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    MemD_Marque.DisableControls;
    MemD_Marque.SortedField:='';
    try
      MemD_Marque.Active:=false;
      MemD_Marque.Active:=true;
      MemD_Marque.LoadFromTextFile(sFic);
    finally
      MemD_Marque.SortedField:='Code';
      MemD_Marque.EnableControls;
      MemD_Marque.First;
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  except
    on E:Exception do
      MessageDlg(E.Message,mterror,[mbok],0);
  end;
end;

procedure TMainForm.Nbt_ClientClick(Sender: TObject);
begin
  if FileExists(ReperProlog+'SK00CLIF.D') then
  begin
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    try
      LireClient(ReperProlog+'SK00CLIF.D');
    finally
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  end;
end;

procedure TMainForm.Nbt_CptlClick(Sender: TObject);
begin  
  if FileExists(ReperProlog+'SK00CPTL.D') then
  begin
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    try
      LireCptl(ReperProlog+'SK00CPTL.D');
    finally
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  end;
end;

procedure TMainForm.Nbt_exportcliClick(Sender: TObject);
var
  sFic:string;
  TPListe:TStringList;
  sLigne:string;
begin
  if not(MemD_Client.Active) then
    exit;
  sFic:=ReperBase+'ImportClient\Clients.csv';
  Screen.Cursor:=crHourGlass;
  Application.ProcessMessages;
  MemD_Client.DisableControls;
  TPListe:=TStringList.Create;
  try
    sLigne:='Code;'+
            'Type;'+
            'Nom;'+
            'Prenom;'+
            'Civ;'+
            'Adr1;'+
            'Adr2;'+
            'Adr3;'+
            'Cp;'+
            'Ville;'+   //10
            'Pays;'+
            'CodeCompta;'+
            'Comment;'+
            'Tel;'+
            'Fax;'+
            'Port;'+
            'EMail;'+
            'CBNat;'+
            'Class1;'+
            'Class2;'+  //20
            'Class3;'+
            'Class4;'+
            'Class5';
    TPListe.Add(sLigne);
    with MemD_Client do
    begin
      First;
      while not(Eof) do
      begin
        sLigne:=fieldbyname('Code').AsString+';'+
                'PART;'+
                fieldbyname('Nom').AsString+';'+
                fieldbyname('Prenom').AsString+';'+
                ';'+
                fieldbyname('Adr1_1').AsString+';'+
                fieldbyname('Adr1_2').AsString+';'+
                ';'+
                fieldbyname('Cp1').AsString+';'+
                fieldbyname('Ville1').AsString+';'+
                fieldbyname('Pays1').AsString+';'+
                ';'+
                ';'+  //comment
                ';'+  //tel
                ';'+  //fax
                ';'+  //port
                ';'+  //email
                ';'+  //CBNat
                ';'+  //Class1
                ';'+  //Class2
                ';'+  //Class3
                ';';  //Class4  Class5
        TPListe.Add(sLigne);
        Next;
      end;
    end;
    TPListe.SaveToFile(sFic);

  finally
    TPListe.Free;
    MemD_Client.First;
    MemD_Client.EnableControls;
    Screen.Cursor:=crDefault;
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.Nbt_FaireFixClick(Sender: TObject);
begin    
  if not(MemD_Modele.Active) then
    Nbt_ChargeModeleClick(Nbt_ChargeModele);
  if not(MemD_Modele.Active) then
    exit;
  Screen.Cursor:=crHourGlass;
  MemD_Article.DisableControls;
  Application.ProcessMessages;
  try
    with MemD_Article do
    begin
      First;
      while not(Eof) do
      begin
        if (fieldbyname('Fixation').AsString<>'') then
        begin
          if MemD_Modele.Locate('Code',fieldbyname('Fixation').AsString,[]) then
          begin
            Edit;
            fieldbyname('NomFixationFin').AsString:=MemD_Modele.fieldbyname('Nom').AsString;
            Post;
          end
          else
          begin   
            Edit;
            fieldbyname('NomFixationFin').AsString:=fieldbyname('Fixation').AsString;
            Post;
          end;
        end;
        Next;
      end;
    end;
  finally
    MemD_Article.First;
    MemD_Article.EnableControls;
    Screen.Cursor:=crDefault;
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.Nbt_FichierClick(Sender: TObject);
begin
  if OD_Fichier.Execute then
  begin
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    Fichier:=OD_Fichier.FileName;
    Lab_Fichier.Caption:=ExtractfileName(Fichier);
    try
      LireFichier(Fichier);
    finally
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  end;
end;

procedure TMainForm.Nbt_MarqueClick(Sender: TObject);
begin
  if FileExists(ReperProlog+'SK00MAR.D') then
  begin
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    try
      LireMarque(ReperProlog+'SK00MAR.D');
    finally
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  end;
end;

procedure TMainForm.Nbt_MenageCliClick(Sender: TObject);
begin 
  if not(MemD_Client.Active) then
    exit;
  Screen.Cursor:=crHourGlass;
  MemD_Client.DisableControls;
  Application.ProcessMessages;
  try
    MemD_Client.First;
    while not(MemD_Client.Eof) do begin
      MemD_Client.Edit;

      if MemD_Client.FieldByName('Adr1_1').AsString='' then
      begin
        MemD_Client.FieldByName('Adr1_1').AsString:=MemD_Client.FieldByName('Adr1_2').AsString;
        MemD_Client.FieldByName('Adr1_2').AsString:='';
      end;
      
      if (MemD_Client.FieldByName('Adr1_2').AsString='FR') or (MemD_Client.FieldByName('Adr1_2').AsString='F') then
        MemD_Client.FieldByName('Adr1_2').AsString:='';

      MemD_Client.Post;
      MemD_Client.Next;
    end;
  finally
    MemD_Client.EnableControls;
    Screen.Cursor:=crDefault;
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.Nbt_ModeleClick(Sender: TObject);
begin
  if FileExists(ReperProlog+'SK00MODL.D') then
  begin
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    try
      LireModele(ReperProlog+'SK00MODL.D');
    finally
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  end;
end;

procedure TMainForm.Nbt_oupsClick(Sender: TObject);
type
  toto=packed record
    txt:string[10];
    separ1:string[2];
    ps1:single; 
    separ2:string[2];
    ps2:single;
    separ3:string[2];
    pd1:double; 
    separ4:string[2];
    pd2:double;
    separ5:string[2];
    pr1:real48;
    separ6:string[2];
    pr2:real48;   
    separ7:string[2];
    pi1:integer; 
    separ8:string[2];
    pi2:real48;
  end;

var
  Stream:TFileStream;
  it:toto;
begin
  Stream:=TFileStream.Create(ReperProlog+'AA2TEST.D',fmcreate);
  try
    it.txt:='21130';
    while Length(it.txt)<10 do
      it.Txt:=it.txt+' ';
    it.separ1:=#0#0;
    it.separ2:=#0#0;
    it.separ3:=#0#0;
    it.separ4:=#0#0;
    it.separ5:=#0#0;
    it.separ6:=#0#0;
    it.separ7:=#0#0;
    it.separ8:=#0#0;
    it.ps1:=91.32;
    it.ps2:=Round(it.ps1*655.957)/100;
    it.pd1:=91.32;
    it.pd2:=Round(it.pd1*655.957)/100;
    it.pr1:=91.32;
    it.pr2:=Round(it.pr1*655.957)/100;
    it.pi1:=9132;
    it.pi2:=Round(it.pi1*655.957);
    stream.Write(it,Sizeof(toto));
    
    it.txt:='11018';
    while Length(it.txt)<10 do
      it.Txt:=it.txt+' ';
    it.separ1:=#0#0;
    it.separ2:=#0#0;
    it.separ3:=#0#0;
    it.separ4:=#0#0;
    it.separ5:=#0#0;
    it.separ6:=#0#0;
    it.separ7:=#0#0;
    it.separ8:=#0#0;
    it.ps1:=54.88;
    it.ps2:=Round(it.ps1*655.957)/100;
    it.pd1:=54.88;
    it.pd2:=Round(it.pd1*655.957)/100;
    it.pr1:=54.88;
    it.pr2:=Round(it.pr1*655.957)/100;
    it.pi1:=5488;
    it.pi2:=Round(it.pi1*655.957);
    stream.Write(it,Sizeof(toto));
    
    it.txt:='21129';
    while Length(it.txt)<10 do
      it.Txt:=it.txt+' ';
    it.separ1:=#0#0;
    it.separ2:=#0#0;
    it.separ3:=#0#0;
    it.separ4:=#0#0;
    it.separ5:=#0#0;
    it.separ6:=#0#0;
    it.separ7:=#0#0;
    it.separ8:=#0#0;
    it.ps1:=91.32;
    it.ps2:=Round(it.ps1*655.957)/100;
    it.pd1:=91.32;
    it.pd2:=Round(it.pd1*655.957)/100;
    it.pr1:=91.32;
    it.pr2:=Round(it.pr1*655.957)/100;
    it.pi1:=9132;
    it.pi2:=Round(it.pi1*655.957);
    stream.Write(it,Sizeof(toto));  
    
    it.txt:='21128';
    while Length(it.txt)<10 do
      it.Txt:=it.txt+' ';
    it.separ1:=#0#0;
    it.separ2:=#0#0;
    it.separ3:=#0#0;
    it.separ4:=#0#0;
    it.separ5:=#0#0;
    it.separ6:=#0#0;
    it.separ7:=#0#0;
    it.separ8:=#0#0;
    it.ps1:=91.32;
    it.ps2:=Round(it.ps1*655.957)/100;
    it.pd1:=91.32;
    it.pd2:=Round(it.pd1*655.957)/100;
    it.pr1:=91.32;
    it.pr2:=Round(it.pr1*655.957)/100;
    it.pi1:=9132;
    it.pi2:=Round(it.pi1*655.957);
    stream.Write(it,Sizeof(toto));
  finally
    Stream.Free;
  end;
end;

procedure TMainForm.Nbt_PaysClick(Sender: TObject);
begin
  if not(MemD_Client.Active) then
    exit;
  Screen.Cursor:=crHourGlass;
  MemD_Client.DisableControls;
  Application.ProcessMessages;
  try
    MemD_Client.First;
    while not(MemD_Client.Eof) do begin
      MemD_Client.Edit;
      MemD_Client.FieldByName('Pays1').AsString:=GetPays(UpperCase(MemD_Client.FieldByName('CodePays1').AsString));
      MemD_Client.Post;
      MemD_Client.Next;
    end;
  finally
    MemD_Client.EnableControls;
    Screen.Cursor:=crDefault;
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.Nbt_PaysNoneClick(Sender: TObject);
var
  bStop:boolean;
  i:integer;
begin
  if not(MemD_Client.Active) then
    exit;
  Screen.Cursor:=crHourGlass;
  MemD_Client.DisableControls;
  Application.ProcessMessages;
  try
    bStop:=false;
    repeat
      MemD_Client.Next;
      if MemD_Client.fieldbyname('Pays1').AsString='' then
        bStop:=true;
    until (MemD_Client.Eof) or bStop;

    for i:=1 to DBGrid2.Columns.Count do
    begin
      if DBGrid2.Columns[i-1].Field.FieldName='Pays1' then
        DBGrid2.SelectedField:=DBGrid2.Columns[i-1].Field;
    end;
  finally
    MemD_Client.EnableControls;
    Screen.Cursor:=crDefault;
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.Nbt_RefaireFicClick(Sender: TObject);
begin
  if (Fichier='') or not(FileExists(Fichier)) then
    exit;              
  Screen.Cursor:=crHourGlass;
  Application.ProcessMessages;
  Fichier:=OD_Fichier.FileName;
  try
    LireFichier(Fichier);
  finally
    Application.ProcessMessages;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TMainForm.Nbt_SauveArtClick(Sender: TObject);
var
  sFic:string;
begin
  if not(MemD_Article.Active) then
    exit;
  sFic:=ReperBase+'Article_Int.csv';
  try
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    try
      MemD_Article.SaveToTextFile(sFic);
    finally
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  except
    on E:Exception do
      MessageDlg(E.Message,mterror,[mbok],0);
  end;
end;

procedure TMainForm.Nbt_SauveCategClick(Sender: TObject);
var
  sFic:string;
begin  
  if not(MemD_Categ.Active) then
    exit;
  sFic:=ReperBase+'Categ_Int.csv';
  try
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    try
      MemD_Categ.SaveToTextFile(sFic);
    finally
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  except
    on E:Exception do
      MessageDlg(E.Message,mterror,[mbok],0);
  end;
end;

procedure TMainForm.Nbt_SauveClientClick(Sender: TObject);
var
  sFic:string;
begin
  if not(MemD_Client.Active) then
    exit;
  sFic:=ReperBase+'Client_Int.csv';
  try
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    try
      MemD_Client.SaveToTextFile(sFic);
    finally
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  except
    on E:Exception do
      MessageDlg(E.Message,mterror,[mbok],0);
  end;
end;

procedure TMainForm.Nbt_SauveModeleClick(Sender: TObject);
var
  sFic:string;
begin  
  if not(MemD_Modele.Active) then
    exit;
  sFic:=ReperBase+'Modele_Int.csv';
  try
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    try
      MemD_Modele.SaveToTextFile(sFic);
    finally
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  except
    on E:Exception do
      MessageDlg(E.Message,mterror,[mbok],0);
  end;
end;

procedure TMainForm.Nbt_SauverMarqClick(Sender: TObject);
var
  sFic:string;
begin  
  if not(MemD_Marque.Active) then
    exit;
  sFic:=ReperBase+'Marque_Int.csv';
  try
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    try
      MemD_Marque.SaveToTextFile(sFic);
    finally
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  except
    on E:Exception do
      MessageDlg(E.Message,mterror,[mbok],0);
  end;
end;

procedure TMainForm.Rgr_OrdCliClick(Sender: TObject);
begin
  if not(MemD_Client.Active) then
    exit;
  Screen.Cursor:=crHourGlass;
  Application.ProcessMessages;
  MemD_Client.DisableControls;
  try
    case Rgr_OrdCli.ItemIndex of
      0:MemD_Client.SortedField:='Code';
      1:MemD_Client.SortedField:='NomPre';
    end;
  finally
    MemD_Client.First;
    MemD_Client.EnableControls;
    Application.ProcessMessages;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TMainForm.BitBtn10Click(Sender: TObject);
begin
  if not(MemD_Categ.Active) then
    Nbt_ChargeCategClick(Nbt_ChargeCateg);
  if not(MemD_Categ.Active) then
    exit;
  Screen.Cursor:=crHourGlass;
  MemD_Article.DisableControls;
  Application.ProcessMessages;
  try
    with MemD_Article do
    begin
      First;
      while not(Eof) do
      begin
        if MemD_Categ.Locate('Code',fieldbyname('CodCateg').AsString,[]) then
        begin
          Edit;
          fieldbyname('NomCategFin').AsString:=MemD_Categ.fieldbyname('Nom').AsString;
          Post;
        end;
        Next;
      end;
    end;
  finally
    MemD_Article.First;
    MemD_Article.EnableControls;
    Screen.Cursor:=crDefault;
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.BitBtn11Click(Sender: TObject);
var
  bStop:boolean;
  i:integer;
begin
  if not(MemD_Article.Active) then
    exit;
  Screen.Cursor:=crHourGlass;
  MemD_Article.DisableControls;
  Application.ProcessMessages;
  try
    bStop:=false;
    repeat
      MemD_Article.Next;
      if MemD_Article.fieldbyname('NomCategFin').AsString='' then
        bStop:=true;
    until (MemD_Article.Eof) or bStop;
  finally
    MemD_Article.EnableControls;
    Screen.Cursor:=crDefault;
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.BitBtn12Click(Sender: TObject);
var
  yy,mm,dd:word;
  s:string;
  d:TDateTime;
begin   
  if not(MemD_Cptl.Active) then
    BitBtn3Click(BitBtn3);
  if not(MemD_Cptl.Active) then
    exit;
  Screen.Cursor:=crHourGlass;
  MemD_Article.DisableControls;
  Application.ProcessMessages;
  try
    with MemD_Article do
    begin
      First;
      while not(Eof) do
      begin
        if MemD_Cptl.Locate('Code',fieldbyname('Code').AsString,[]) then
        begin
          s:=MemD_Cptl.fieldbyname('Date1').AsString;
          d:=0;
          if Length(s)<>8 then
          begin
            if fieldbyname('Exercice').AsString<>'' then
            begin
              try
                yy:=strtoint(fieldbyname('Exercice').AsString);
                mm:=11;
                dd:=1;
                d:=EncodeDate(yy,mm,dd);
              except
                d:=0;
              end;
            end;
          end
          else
          begin
            try
              yy:=strtoint(copy(s,1,4));
              mm:=strtoint(copy(s,5,2));
              dd:=strtoint(copy(s,7,2));
              d:=EncodeDate(yy,mm,dd);
            except
              d:=0;
            end;
          end;
          Edit;
          fieldbyname('StrDAchat').AsString:=MemD_Cptl.fieldbyname('Date1').AsString;
          if d<>0 then
            fieldbyname('DAchat').AsDateTime:=d;
          Post;
        end
        else
        begin  
          if fieldbyname('Exercice').AsString<>'' then
          begin
            d:=0;
            try
              yy:=strtoint(fieldbyname('Exercice').AsString);
              mm:=11;
              dd:=1;
              d:=EncodeDate(yy,mm,dd);
            except
              d:=0;
            end;  
            if d<>0 then
            begin
              Edit;
              fieldbyname('DAchat').AsDateTime:=d;
              Post;
            end;
          end;
        end;
        Next;
      end;
    end;
  finally
    MemD_Article.First;
    MemD_Article.EnableControls;
    Screen.Cursor:=crDefault;
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.BitBtn13Click(Sender: TObject);
var
  bStop:boolean;
  i:integer;
begin
  if not(MemD_Article.Active) then
    exit;
  Screen.Cursor:=crHourGlass;
  MemD_Article.DisableControls;
  Application.ProcessMessages;
  try
    bStop:=false;
    repeat
      MemD_Article.Next;
      if MemD_Article.fieldbyname('StrDAchat').AsString='' then
        bStop:=true;
    until (MemD_Article.Eof) or bStop;
  finally
    MemD_Article.EnableControls;
    Screen.Cursor:=crDefault;
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.BitBtn14Click(Sender: TObject);
var
  sFic:string;
  TPListe:TStringList;
  sLigne:string;
begin
  if not(MemD_Article.Active) then
    exit;

  //articles
  sFic:=ReperBase+'ImportArticle\Articles.csv';
  Screen.Cursor:=crHourGlass;
  Application.ProcessMessages;
  MemD_Article.DisableControls;
  TPListe:=TStringList.Create;
  try
    sLigne:='CODE;'+
            'LIBELLE;'+
            'REFMARQUE;'+
            'NUMSERIE;'+
            'CATEGORIE;'+
            'COMMENTAIRE;'+
            'MARQUE;'+
            'GRILLETAILLE;'+
            'TAILLE;'+
            'CB1;'+
            'CB2;'+
            'CB3;'+
            'CB4;'+
            'STATUT;'+
            'DATEACHAT;'+
            'PRIXACHAT;'+
            'PRIXVENTE;'+
            'DATECESSION;'+
            'PRIXCESSION;'+
            'DUREEAMT;'+
            'LOCFOURNISSEUR;'+
            'SOUSFICHE;'+
            'SFCODE;'+
            'RESULTAT';
    TPListe.Add(sLigne);
    with MemD_Article do
    begin
      First;
      while not(Eof) do
      begin
        if (ArrondiA2(fieldbyname('Etat').AsFloat)=0.0) and not(fieldbyname('DAchat').IsNull) then
        begin
          sLigne:=fieldbyname('Code').AsString+';'+                // CODE
                  fieldbyname('NomModelFin').AsString+';'+         // LIBELLE
                  ';'+                                             // REFMARQUE
                  fieldbyname('NoSerie').AsString+';'+                                             // NUMSERIE
                  fieldbyname('NomCategFin').AsString+';'+         // CATEGORIE
                  ';'+                                             // COMMENTAIRE
                  fieldbyname('NomMarqFin').AsString+';'+          // MARQUE
                  fieldbyname('NomCategFin').AsString+';'+         // GRILLETAILLE
                  fieldbyname('Taille').AsString+';'+              // TAILLE
                  ';'+             // CB1
                  ';'+                                             // CB2
                  ';'+                                             // CB3
                  ';'+                                             // CB4
                  'LOCATION;'+                                     // STATUT
                  DateToStr(fieldbyname('DAchat').AsDateTime)+';'+ // DATEACHAT
                  FloatToStr(fieldbyname('PAchat').AsFloat)+';'+   // PRIXACHAT
                  '0;'+                                             // PRIXVENTE
                  ';'+                                             // DATECESSION
                  ';'+                                             // PRIXCESSION
                  '3;'+                                            // DUREEAMT
                  'N;'+                                             // LOCFOURNISSEUR
                  'N;'+                                             // SOUSFICHE
                  ';'+                                             // SFCODE
                  '';                                              // RESULTAT
          TPListe.Add(sLigne);
        end;
        Next;
      end;
    end;
    TPListe.SaveToFile(sFic); 
  finally
    TPListe.Free;
    MemD_Article.First;
    MemD_Article.EnableControls;
    Screen.Cursor:=crDefault;
    Application.ProcessMessages;
  end;

  //fixation

  sFic:=ReperBase+'ImportArticle\fixation.csv';
  Screen.Cursor:=crHourGlass;
  Application.ProcessMessages;
  MemD_Article.DisableControls;
  TPListe:=TStringList.Create;
  try
    sLigne:='CODE;'+
            'LIBELLE;'+
            'REFMARQUE;'+
            'NUMSERIE;'+
            'CATEGORIE;'+
            'COMMENTAIRE;'+
            'MARQUE;'+
            'GRILLETAILLE;'+
            'TAILLE;'+
            'CB1;'+
            'CB2;'+
            'CB3;'+
            'CB4;'+
            'STATUT;'+
            'DATEACHAT;'+
            'PRIXACHAT;'+
            'PRIXVENTE;'+
            'DATECESSION;'+
            'PRIXCESSION;'+
            'DUREEAMT;'+
            'LOCFOURNISSEUR;'+
            'SOUSFICHE;'+
            'SFCODE;'+
            'RESULTAT';
    TPListe.Add(sLigne);
    with MemD_Article do
    begin
      First;
      while not(Eof) do
      begin
        if (ArrondiA2(fieldbyname('Etat').AsFloat)=0.0)
            and not(fieldbyname('DAchat').IsNull)
            and (ArrondiA2(fieldbyname('PFix').AsFloat)<>0.0)
            and (fieldbyname('Fixation').AsString<>'') then
        begin
          sLigne:=fieldbyname('Fixation').AsString+'-'+fieldbyname('Code').AsString+';'+                // CODE
                  fieldbyname('NomFixationFin').AsString+';'+         // LIBELLE
                  ';'+                                             // REFMARQUE
                  ';'+                                             // NUMSERIE
                  fieldbyname('NomCategFin').AsString+';'+         // CATEGORIE
                  ';'+                                             // COMMENTAIRE
                  fieldbyname('NomMarqFin').AsString+';'+          // MARQUE
                  ';'+                                             // GRILLETAILLE
                  ';'+              // TAILLE
                  ';'+             // CB1
                  ';'+                                             // CB2
                  ';'+                                             // CB3
                  ';'+                                             // CB4
                  'LOCATION;'+                                     // STATUT
                  DateToStr(fieldbyname('DAchat').AsDateTime)+';'+ // DATEACHAT
                  FloatToStr(fieldbyname('PFix').AsFloat)+';'+   // PRIXACHAT
                  '0;'+                                             // PRIXVENTE
                  ';'+                                             // DATECESSION
                  ';'+                                             // PRIXCESSION
                  '3;'+                                            // DUREEAMT
                  'N;'+                                             // LOCFOURNISSEUR
                  'O;'+                                             // SOUSFICHE
                  fieldbyname('Code').AsString+';'+                                             // SFCODE
                  '';                                              // RESULTAT
          TPListe.Add(sLigne);
        end;
        Next;
      end;
    end;
    TPListe.SaveToFile(sFic);

  finally
    TPListe.Free;
    MemD_Article.First;
    MemD_Article.EnableControls;
    Screen.Cursor:=crDefault;
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.BitBtn1Click(Sender: TObject);
type
  toto=packed record
    txt:string[10];
    separ1:string[2];
    ps1:single; 
    separ2:string[2];
    ps2:single;
    separ3:string[2];
    pd1:double; 
    separ4:string[2];
    pd2:double;
    separ5:string[2];
    pr1:real48;
    separ6:string[2];
    pr2:real48;   
    separ7:string[2];
    pi1:integer; 
    separ8:string[2];
    pi2:real48;
  end;

var
  Stream:TFileStream;
  it:toto;
begin
  Stream:=TFileStream.Create(ReperProlog+'AATEST.D',fmcreate);
  try
    it.txt:='62096';
    while Length(it.txt)<10 do
      it.Txt:=it.txt+' ';
    it.separ1:=#0#0;
    it.separ2:=#0#0;
    it.separ3:=#0#0;
    it.separ4:=#0#0;
    it.separ5:=#0#0;
    it.separ6:=#0#0;
    it.separ7:=#0#0;
    it.separ8:=#0#0;
    it.ps1:=22.22;
    it.ps2:=Round(it.ps1*655.957)/100;
    it.pd1:=22.22;
    it.pd2:=Round(it.pd1*655.957)/100;
    it.pr1:=22.22;
    it.pr2:=Round(it.pr1*655.957)/100;
    it.pi1:=2222;
    it.pi2:=Round(it.pi1*655.957);
    stream.Write(it,Sizeof(toto));
    
    it.txt:='62095';
    while Length(it.txt)<10 do
      it.Txt:=it.txt+' ';
    it.separ1:=#0#0;
    it.separ2:=#0#0;
    it.separ3:=#0#0;
    it.separ4:=#0#0;
    it.separ5:=#0#0;
    it.separ6:=#0#0;
    it.separ7:=#0#0;
    it.separ8:=#0#0;
    it.ps1:=22.22;
    it.ps2:=Round(it.ps1*655.957)/100;
    it.pd1:=22.22;
    it.pd2:=Round(it.pd1*655.957)/100;
    it.pr1:=22.22;
    it.pr2:=Round(it.pr1*655.957)/100;
    it.pi1:=2222;
    it.pi2:=Round(it.pi1*655.957);
    stream.Write(it,Sizeof(toto));
    
    it.txt:='62094';
    while Length(it.txt)<10 do
      it.Txt:=it.txt+' ';
    it.separ1:=#0#0;
    it.separ2:=#0#0;
    it.separ3:=#0#0;
    it.separ4:=#0#0;
    it.separ5:=#0#0;
    it.separ6:=#0#0;
    it.separ7:=#0#0;
    it.separ8:=#0#0;
    it.ps1:=23.90;
    it.ps2:=Round(it.ps1*655.957)/100;
    it.pd1:=23.90;
    it.pd2:=Round(it.pd1*655.957)/100;
    it.pr1:=23.90;
    it.pr2:=Round(it.pr1*655.957)/100;
    it.pi1:=2390;
    it.pi2:=Round(it.pi1*655.957);
    stream.Write(it,Sizeof(toto));  
    
    it.txt:='62093';
    while Length(it.txt)<10 do
      it.Txt:=it.txt+' ';
    it.separ1:=#0#0;
    it.separ2:=#0#0;
    it.separ3:=#0#0;
    it.separ4:=#0#0;
    it.separ5:=#0#0;
    it.separ6:=#0#0;
    it.separ7:=#0#0;
    it.separ8:=#0#0;
    it.ps1:=23.90;
    it.ps2:=Round(it.ps1*655.957)/100;
    it.pd1:=23.90;
    it.pd2:=Round(it.pd1*655.957)/100;
    it.pr1:=23.90;
    it.pr2:=Round(it.pr1*655.957)/100;
    it.pi1:=2390;
    it.pi2:=Round(it.pi1*655.957);
    stream.Write(it,Sizeof(toto)); 
    
    it.txt:='50481';
    while Length(it.txt)<10 do
      it.Txt:=it.txt+' ';
    it.separ1:=#0#0;
    it.separ2:=#0#0;
    it.separ3:=#0#0;
    it.separ4:=#0#0;
    it.separ5:=#0#0;
    it.separ6:=#0#0;
    it.separ7:=#0#0;
    it.separ8:=#0#0;
    it.ps1:=51.30;
    it.ps2:=Round(it.ps1*655.957)/100;
    it.pd1:=51.30;
    it.pd2:=Round(it.pd1*655.957)/100;
    it.pr1:=51.30;
    it.pr2:=Round(it.pr1*655.957)/100;
    it.pi1:=5130;
    it.pi2:=Round(it.pi1*655.957);
    stream.Write(it,Sizeof(toto));
  finally
    Stream.Free;
  end;
end;

procedure TMainForm.BitBtn2Click(Sender: TObject);
var
  Stream:TMemoryStream;
  Position:integer;
  i:integer;
  tpliste:tstringList;
  resu:integer;
  SearchRec:TsearchRec;
  s:string;
  v1:Single;
  v2:Double;
  v3:Extended;
  v4:Currency;
  lu:integer;
begin
  Screen.Cursor:=crHourGlass;
  Application.ProcessMessages;
  TPListe:=TStringList.Create;
  try
    Memo10.Clear;
    resu:=FindFirst(ReperProlog+'*.D',faAnyFile,SearchRec);
    while resu=0 do
    begin
      s:=SearchRec.Name;
      if (s<>'.') and (s<>'..') and ((Searchrec.Attr and faDirectory)<>faDirectory) then
        TPListe.Add(s);
      resu:=FindNext(SearchRec);
    end;
    FindClose(SearchRec);

    TPListe.Sort;
    for i:=1 to TPListe.Count do
    begin
      Memo10.Lines.Add('----------------------------------------');
      Memo10.Lines.Add('Fichier: '+TPListe[i-1]);
      Memo10.Lines.Add('----------------------------------------');
      Application.ProcessMessages;
      Stream:=TMemoryStream.Create;
      try
        Stream.LoadFromFile(ReperProlog+TPListe[i-1]);
        Position:=0;
        while Position<Stream.Size-4 do begin
          Stream.Seek(Position,soFromBeginning);
          try
            lu:=Stream.Read(v1,Sizeof(Single));
            if lu=sizeof(Single) then begin
              if (ArrondiA2(v1)=91.32) then
              begin
                Memo10.Lines.Add('Trouver Single 91.32  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (ArrondiA2(v1)=54.88) then
              begin
                Memo10.Lines.Add('Trouver Single 54.88  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (ArrondiA2(v1)=22.00) then
              begin
                Memo10.Lines.Add('Trouver Single 22.00  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (ArrondiA2(v1)=23.90) then
              begin
                Memo10.Lines.Add('Trouver Single 23.90  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;     
              if (ArrondiA2(v1)=51.30) then
              begin
                Memo10.Lines.Add('Trouver Single 51.30  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;

              if (ArrondiA2(v1)=599.02) then
              begin
                Memo10.Lines.Add('Trouver Single 599.02  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (ArrondiA2(v1)=359.99) then
              begin
                Memo10.Lines.Add('Trouver Single 359.99  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (ArrondiA2(v1)=144.31) then
              begin
                Memo10.Lines.Add('Trouver Single 144.31  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (ArrondiA2(v1)=156.77) then
              begin
                Memo10.Lines.Add('Trouver Single 156.77  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;    
              if (ArrondiA2(v1)=336.51) then
              begin
                Memo10.Lines.Add('Trouver Single 336.51  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;

            end;
          except
          end;
          Stream.Seek(Position,soFromBeginning);
          try
            lu:=Stream.Read(v2,Sizeof(Double));
            if lu=sizeof(Double) then begin
              if (v2=91.32) then
              begin
                Memo10.Lines.Add('Trouver Double 91.32  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (v2=54.88) then
              begin
                Memo10.Lines.Add('Trouver Double 54.88  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (v2=22.00) then
              begin
                Memo10.Lines.Add('Trouver Double 22.00  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (v2=23.90) then
              begin
                Memo10.Lines.Add('Trouver Double 23.90  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;     
              if (v2=51.30) then
              begin
                Memo10.Lines.Add('Trouver Double 51.30  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;

              if (ArrondiA2(v2)=599.02) then
              begin
                Memo10.Lines.Add('Trouver Double 599.02  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (ArrondiA2(v2)=359.99) then
              begin
                Memo10.Lines.Add('Trouver Double 359.99  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (ArrondiA2(v2)=144.31) then
              begin
                Memo10.Lines.Add('Trouver Double 144.31  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (ArrondiA2(v2)=156.77) then
              begin
                Memo10.Lines.Add('Trouver Double 156.77  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;    
              if (ArrondiA2(v2)=336.51) then
              begin
                Memo10.Lines.Add('Trouver Double 336.51  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;

            end;
          except
          end;     
          Stream.Seek(Position,soFromBeginning);
          try
            lu:=Stream.Read(v3,Sizeof(Extended));
            if lu=sizeof(Double) then begin
              if (v2=91.32) then
              begin
                Memo10.Lines.Add('Trouver Double 91.32  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (v2=54.88) then
              begin
                Memo10.Lines.Add('Trouver Double 54.88  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (v2=22.00) then
              begin
                Memo10.Lines.Add('Trouver Double 22.00  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (v2=23.90) then
              begin
                Memo10.Lines.Add('Trouver Double 23.90  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;     
              if (v2=51.30) then
              begin
                Memo10.Lines.Add('Trouver Double 51.30  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;

              if (ArrondiA2(v2)=599.02) then
              begin
                Memo10.Lines.Add('Trouver Double 599.02  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (ArrondiA2(v2)=359.99) then
              begin
                Memo10.Lines.Add('Trouver Double 359.99  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (ArrondiA2(v2)=144.31) then
              begin
                Memo10.Lines.Add('Trouver Double 144.31  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;
              if (ArrondiA2(v2)=156.77) then
              begin
                Memo10.Lines.Add('Trouver Double 156.77  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;    
              if (ArrondiA2(v2)=336.51) then
              begin
                Memo10.Lines.Add('Trouver Double 336.51  position: '+inttostr(Position));
                Application.ProcessMessages;
              end;

            end;
          except
          end;
          Inc(Position);
        end;
      finally
        Stream.Free;
        Stream:=nil;
      end;
    end;

  finally
    TPListe.Free;
    TPListe:=nil;
    Screen.Cursor:=crDefault;
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.BitBtn3Click(Sender: TObject);
var
  sFic:string;
begin
  sFic:=ReperBase+'Cptl_Int.csv';
  if not(FileExists(sFic)) then
  begin
    MessageDlg('Fichier inexistant !',mterror,[mbok],0);
    exit;
  end;
  try
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    MemD_Cptl.DisableControls;
    MemD_Cptl.SortedField:='';
    try
      MemD_Cptl.Active:=false;
      MemD_Cptl.Active:=true;
      MemD_Cptl.LoadFromTextFile(sFic);
    finally
      MemD_Cptl.SortedField:='Code';
      MemD_Cptl.EnableControls;
      MemD_Cptl.First;
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  except
    on E:Exception do
      MessageDlg(E.Message,mterror,[mbok],0);
  end;
end;

procedure TMainForm.BitBtn4Click(Sender: TObject);
var
  sFic:string;
begin
  if not(MemD_Cptl.Active) then
    exit;
  sFic:=ReperBase+'Cptl_Int.csv';
  try
    Screen.Cursor:=crHourGlass;
    Application.ProcessMessages;
    try
      MemD_Cptl.SaveToTextFile(sFic);
    finally
      Application.ProcessMessages;
      Screen.Cursor:=crDefault;
    end;
  except
    on E:Exception do
      MessageDlg(E.Message,mterror,[mbok],0);
  end;
end;

procedure TMainForm.BitBtn5Click(Sender: TObject);
var
  bOk:boolean;
begin
  MemD_Cptl.DisableControls;
  Screen.Cursor:=crHourGlass;
  Application.ProcessMessages;
  try
    bOk:=false;
    MemD_Cptl.First;
    while not(bOk) and not(MemD_Cptl.Eof) do begin
      if MemD_Cptl.FieldByName('Date1').AsString<>MemD_Cptl.FieldByName('Date2').AsString then
        bOk:=true;
      if not(bOk) then
        MemD_Cptl.Next;
    end;
  finally
    MemD_Cptl.EnableControls;
    Screen.Cursor:=crDefault;
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.BitBtn6Click(Sender: TObject);
begin
  if not(MemD_Marque.Active) then
    Nbt_ChargerMarqClick(Nbt_ChargerMarq);
  if not(MemD_Marque.Active) then
    exit;
  Screen.Cursor:=crHourGlass;
  MemD_Article.DisableControls;
  Application.ProcessMessages;
  try
    with MemD_Article do
    begin
      First;
      while not(Eof) do
      begin
        if MemD_Marque.Locate('Code',fieldbyname('CodMarq').AsString,[]) then
        begin
          Edit;
          fieldbyname('NomMarqFin').AsString:=MemD_Marque.fieldbyname('Nom').AsString;
          Post;
        end;
        Next;
      end;
    end;
  finally
    MemD_Article.First;
    MemD_Article.EnableControls;
    Screen.Cursor:=crDefault;
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.BitBtn7Click(Sender: TObject);
var
  bStop:boolean;
  i:integer;
begin
  if not(MemD_Article.Active) then
    exit;
  Screen.Cursor:=crHourGlass;
  MemD_Article.DisableControls;
  Application.ProcessMessages;
  try
    bStop:=false;
    repeat
      MemD_Article.Next;
      if MemD_Article.fieldbyname('NomMarqFin').AsString='' then
        bStop:=true;
    until (MemD_Article.Eof) or bStop;
  finally
    MemD_Article.EnableControls;
    Screen.Cursor:=crDefault;
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.BitBtn8Click(Sender: TObject);
begin
  if not(MemD_Modele.Active) then
    Nbt_ChargeModeleClick(Nbt_ChargeModele);
  if not(MemD_Modele.Active) then
    exit;
  Screen.Cursor:=crHourGlass;
  MemD_Article.DisableControls;
  Application.ProcessMessages;
  try
    with MemD_Article do
    begin
      First;
      while not(Eof) do
      begin
        if MemD_Modele.Locate('Code',fieldbyname('CodModel').AsString,[]) then
        begin
          Edit;
          fieldbyname('NomModelFin').AsString:=MemD_Modele.fieldbyname('Nom').AsString;
          Post;
        end;
        Next;
      end;
    end;
  finally
    MemD_Article.First;
    MemD_Article.EnableControls;
    Screen.Cursor:=crDefault;
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.BitBtn9Click(Sender: TObject);
var
  bStop:boolean;
  i:integer;
begin
  if not(MemD_Article.Active) then
    exit;
  Screen.Cursor:=crHourGlass;
  MemD_Article.DisableControls;
  Application.ProcessMessages;
  try
    bStop:=false;
    repeat
      MemD_Article.Next;
      if MemD_Article.fieldbyname('NomModelFin').AsString='' then
        bStop:=true;
    until (MemD_Article.Eof) or bStop;
  finally
    MemD_Article.EnableControls;
    Screen.Cursor:=crDefault;
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.Edt_DemarCliKeyPress(Sender: TObject; var Key: Char);
begin
  if (Ord(Key)>=32) and (not(Key in ['0'..'9'])) then
    Key:=#7;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  if EtatFiche then
    exit;
  EtatFiche:=true;
  Application.ProcessMessages;
  Align:=alnone;
  Application.ProcessMessages;
  ReAlign;
  Application.ProcessMessages;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  EtatFiche := False;
  ReperBase := ExtractFilePath(ParamStr(0));
  if (ReperBase[Length(ReperBase)]<>'\') then
    ReperBase:=ReperBase+'\';
  ReperProlog := ReperBase+'Prolog\';

  Memo1.Clear;
  if FileExists(ReperProlog+'SK00CATE.D') then
  begin
    Nbt_Categ.Enabled:=true;
    Lab_Categ.Caption := 'Fichier "SK00CATE.D" trouvé';
  end
  else
  begin
    Nbt_Categ.Enabled:=false;
    Lab_Categ.Caption := 'Fichier non trouvé: "SK00CATE.D" dans le répertoire "Prolog"';
  end;

  Memo2.Clear;
  Memo3.Clear;
  if FileExists(ReperProlog+'SK00CLIF.D') then
  begin
    Nbt_Client.Enabled:=true;
    Lab_Client.Caption := 'Fichier "SK00CLIF.D" trouvé';
  end
  else
  begin
    Nbt_Client.Enabled:=false;
    Lab_Client.Caption := 'Fichier non trouvé: "SK00CLIF.D" dans le répertoire "Prolog"';
  end;
  Lab_Long.Caption:='';

  Memo3.Clear;
  Memo4.Clear;
  if FileExists(ReperProlog+'SK00ARTL.D') then
  begin
    Nbt_Art.Enabled:=true;
    Lab_Art.Caption := 'Fichier "SK00ARTL.D" trouvé';
  end
  else
  begin
    Nbt_Art.Enabled:=false;
    Lab_Art.Caption := 'Fichier non trouvé: "SK00ARTL.D" dans le répertoire "Prolog"';
  end;
  Lab_LongArt.Caption:='';    

  Memo6.Clear;
  Memo7.Clear;
  if FileExists(ReperProlog+'SK00MAR.D') then
  begin
    Nbt_Marque.Enabled:=true;
    Lab_Marque.Caption := 'Fichier "SK00MAR.D" trouvé';
  end
  else
  begin
    Nbt_Marque.Enabled:=false;
    Lab_Marque.Caption := 'Fichier non trouvé: "SK00MAR.D" dans le répertoire "Prolog"';
  end;

  Memo8.Clear;
  Memo9.Clear;
  if FileExists(ReperProlog+'SK00MODL.D') then
  begin
    Nbt_Modele.Enabled:=true;
    Lab_Modele.Caption := 'Fichier "SK00MODL.D" trouvé';
  end
  else
  begin
    Nbt_Modele.Enabled:=false;
    Lab_Modele.Caption := 'Fichier non trouvé: "SK00MODL.D" dans le répertoire "Prolog"';
  end;

  Fichier:='';
  OD_Fichier.InitialDir:=ReperProlog;
  Memo10.Clear;
  Memo11.Clear; 
  Lab_Fichier.Caption := ''; 

  Memo12.Clear;
  Memo13.Clear;
  if FileExists(ReperProlog+'SK00CPTL.D') then
  begin
    Nbt_Cptl.Enabled:=true;
    Lab_Cptl.Caption := 'Fichier "SK00CPTL.D" trouvé';
  end
  else
  begin
    Nbt_Cptl.Enabled:=false;
    Lab_Cptl.Caption := 'Fichier non trouvé: "SK00CPTL.D" dans le répertoire "Prolog"';
  end;

end;

end.
