unit datamodule;

interface



uses
  SysUtils, Classes, DB, DBClient;

type
  TXLMDataModule = class(TDataModule)
    DSCentrale: TClientDataSet;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Déclarations privées }
    sFile : String ;
  public
    { Déclarations publiques }
  end;

var
  XLMDataModule: TXLMDataModule;

implementation

Const 
  FILENAME = 'Pprs.xml';


{$R *.dfm}

procedure TXLMDataModule.DataModuleCreate(Sender: TObject);
begin
  sFile :=  IncludeTrailingPathDelimiter(Extractfilepath(Paramstr(0)))+FILENAME ;
  DSCentrale.FileName := sFile ;
  With DSCentrale do
   BEGIN
     Indexdefs.Add('Centraleidx', 'CENTRALE', [ixCaseInsensitive]);
     IndexName := 'Centraleidx' ;
     With TStringField.Create(Self) do
      begin
        Name := 'PCentrale' ;
        FieldKind := fkData ;
        Fieldname := 'CENTRALE' ;
        Size := 50 ;
        Dataset := DSCentrale ;
      end;
     With TStringField.Create(Self) do
      begin
        Name := 'PEmail' ;
        FieldKind := fkData ;
        Fieldname := 'EMAIL' ;
        Size := 50 ;
        Dataset := DSCentrale ;
      end;      
     With TStringField.Create(Self) do
      begin
        Name := 'PMdp' ;
        FieldKind := fkData ;
        Fieldname := 'MDP' ;
        Size := 50 ;
        Dataset := DSCentrale ;
      end;
     With TStringField.Create(Self) do
      begin
        Name := 'PArchive' ;
        FieldKind := fkData ;
        Fieldname := 'ARCHIVE' ;
        Size := 50 ;
        Dataset := DSCentrale ;
      end;      
     With TStringField.Create(Self) do
      begin
        Name := 'PAmdp' ;
        FieldKind := fkData ;
        Fieldname := 'AMDP' ;
        Size := 50 ;
        Dataset := DSCentrale ;
      end;      
     With TStringField.Create(Self) do
      begin
        Name := 'PPop3' ;
        FieldKind := fkData ;
        Fieldname := 'POP3' ;
        Size := 50 ;
        Dataset := DSCentrale ;
      end;      
     With TIntegerField.Create(Self) do
      begin
        Name := 'PPop3port' ;
        FieldKind := fkData ;
        Fieldname := 'POP3PORT' ;
        Dataset := DSCentrale ;
      end;      
     With TStringField.Create(Self) do
      begin
        Name := 'PSmtp' ;
        FieldKind := fkData ;
        Fieldname := 'SMTP' ;
        Size := 50 ;
        Dataset := DSCentrale ;
      end;
     With TIntegerField.Create(Self) do
      begin
        Name := 'PSmtpport' ;
        FieldKind := fkData ;
        Fieldname := 'SMTPPORT' ;
        Dataset := DSCentrale ;
      end;   
     With TBooleanField.Create(Self) do
      begin
        Name := 'PSSL' ;
        FieldKind := fkData ;
        Fieldname := 'SSL' ;
        Dataset := DSCentrale ;
      end;         
     With TIntegerField.Create(Self) do
      begin
        Name := 'PDelay' ;
        FieldKind := fkData ;
        Fieldname := 'DELAY' ;
        Dataset := DSCentrale ;
      end;
   END;


   if FileExists(sFile) then
    DSCentrale.Open else
     DSCentrale.CreateDataSet ;

   DSCentrale.AggregatesActive := True ;  
   

end;

end.
