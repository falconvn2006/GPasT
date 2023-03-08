unit EnderecosModel;

interface
uses Classes;

type
   TEnderecosModel = class
      private
         FNatureza: Int8;
         FDocumento: string;
         FPrimeiroNome: string;
         FSobreNome: string;
         FMensagemErro: TStringList;
      public
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

   end;

implementation

end.
