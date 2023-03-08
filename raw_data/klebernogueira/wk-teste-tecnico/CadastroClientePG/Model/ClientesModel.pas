unit ClientesModel;

interface
uses Classes;

type
   TClientesModel = class
      private
         FId: Int32;
         FNatureza: Int8;
         FDocumento: string;
         FPrimeiroNome: string;
         FSobreNome: string;
         FCEP: string;
         FMensagemErro: TStringList;
      public
         property Id: Int32
            read FId
            write FId;
         property MensagemErro: TStringList
            read FMensagemErro
            write FMensagemErro;
         property Natureza: Int8
            read FNatureza
            write FNatureza;
         property Documento: string
            read FDocumento
            write FDocumento;
         property PrimeiroNome: string
            read FPrimeiroNome
            write FPrimeiroNome;
         property SobreNome: string
            read FSobreNome
            write FSobreNome;
         property CEP: string
            read FCEP
            write FCEP;

   end;

implementation

end.
