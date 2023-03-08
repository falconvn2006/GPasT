unit GSData_TErreur;

interface

uses SysUtils, Controls, stdctrls, uLogFile;

Type
  TTypeErreur = (teNull, teArticle, teArticleInteg, teMarque, teNomenclature,
                 teOpeCom, teMultiColis, tePackage, tePrixDeVente, teFournisseur,
                 teReception, teCommande, teGetFtp, teGetFtpWarning);

  TErreur = class(TObject)
   private
    FNomFichier  : String;
    FRefErreur   : String;
    FText        : String;
    FNumeroLigne : Integer;
    FTypeErreur  : TTypeErreur;
    FDate        : TDateTime;
    FHeure       : TDateTime;
    FIdTable     : Integer;
    FNomTable    : String;

    procedure Set_NomFichier  (Const Value : String);
    procedure Set_RefErreur   (Const Value : String);
    procedure Set_Text        (Const Value : String);
    procedure Set_NumeroLigne (Const Value : Integer);
    procedure Set_TypeErreur  (Const Value : TTypeErreur);
    procedure Set_Date        (Const Value : TDateTime);
    procedure Set_Heure       (Const Value : TDateTime);
    procedure Set_IdTable     (Const Value : Integer);
    procedure Set_NomTable    (Const Value : String);
   public
    property NomFichier  : String      read FNomFichier  write Set_NomFichier;
    property RefErreur   : String      read FRefErreur   write Set_RefErreur;
    property Text        : String      read FText        write Set_Text;
    property NumeroLigne : Integer     read FNumeroLigne write Set_NumeroLigne;
    property TypeErreur  : TTypeErreur read FTypeErreur  write Set_TypeErreur;
    property Date        : TDateTime   read FDate        write Set_Date;
    property Heure       : TDateTime   read FHeure       write Set_Heure;
    property IdTable     : Integer     read FIdTable     write Set_IdTable;
    property NomTable    : String      read FNomTable    write Set_NomTable;

    Constructor Create;
    Destructor  Destroy; override;

    procedure SendToMemo(vpMemo : TMemo);
    procedure SendToMail;
    procedure SaveError;
    procedure AddError(ANomfichier, ARefErreur, AText : String;ANumeroLigne : Integer; ATypeErreur : TTypeErreur;AIdTable : Integer;ANomTable : String);
   end;




implementation

uses GSDataMain_DM , uLog;

//----------------------------------------------------------------> property

procedure TErreur.Set_NomFichier(Const Value : String);
begin
 FNomFichier := Value;
end;

procedure TErreur.Set_RefErreur(Const Value : String);
begin
 FRefErreur := Value;
end;

procedure TErreur.Set_Text(Const Value : String);
begin
 FText := Value;
end;

procedure TErreur.Set_NumeroLigne(Const Value : Integer);
begin
 FNumeroLigne := Value;
end;

procedure TErreur.Set_TypeErreur(Const Value : TTypeErreur);
begin
 FTypeErreur := Value;
end;

procedure TErreur.Set_Date(Const Value : TDateTime);
begin
 FDate := Value;
end;

procedure TErreur.Set_Heure(Const Value : TDateTime);
begin
 FHeure := Value;
end;

procedure TErreur.Set_IdTable(Const Value : Integer);
begin
 FIdTable := Value;
end;

procedure TErreur.Set_NomTable(Const Value : String);
begin
 FNomTable := Value;
end;

//---------------------------------------------------------------> procedure

constructor TErreur.Create;
begin
  Inherited;
end;

destructor TErreur.Destroy;
begin
  Inherited;
end;

procedure TErreur.SendToMemo(vpMemo : TMemo);
begin
 //
end;

procedure TErreur.SendToMail;
begin
 //
end;

procedure TErreur.SaveError;
begin
 //
end;

procedure TErreur.AddError(ANomfichier, ARefErreur, AText : String;ANumeroLigne : Integer; ATypeErreur : TTypeErreur;AIdTable : Integer;ANomTable : String);
begin
  FNomFichier  := ANomfichier;
  FRefErreur   := ARefErreur;
  FText        := AText;
  FNumeroLigne := ANumeroLigne;
  FTypeErreur  := ATypeErreur;
  FIdTable     := AIdTable;
  FDate        := Now;
  FHeure       := Now;
  FNomTable    := ANomTable;

  Log.Log( FNomFichier, '', '', 'Log', FRefErreur + '/' + IntToStr(FNumeroLigne) + ' : ' + FText, logError, False, 0, ltLocal);
end;



end.
