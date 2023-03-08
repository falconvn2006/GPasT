unit AcertaNome;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    BitBtn1: TBitBtn;
    listaOriginal: TListBox;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    ListaAcertada: TListBox;
    btnUpdate: TButton;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses funcoes;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
   if OpenDialog1.Execute then begin
      listaOriginal.Items.LoadFromFile(OpenDialog1.FileName);
   end;

end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
   X: Integer;
   NomeAcertado: String;
   Tamanho: Integer;
   SQL1, SQL2, SQLUpdate: String;
begin
    SQL1 := 'update clientes_tb set sexo_cli = ''F'' where Upper(substring( rtrim(nome_cli),1,';
    for X := 0 to listaOriginal.Count -1 do begin
        // Remove Acentuação e deixa tudo Maiúsculo
        NomeAcertado :=  UpperCase(AnsiToAscii(Trim(listaOriginal.Items.Strings[X])));
        Tamanho := Length(UpperCase(AnsiToAscii(Trim(listaOriginal.Items.Strings[X]))));
//        ListaAcertada.Items.Add( UpperCase(AnsiToAscii(Trim(listaOriginal.Items.Strings[X]))) );
        SQLUpdate := 'update clientes_tb set sexo_cli = ''F'' where Upper(substring( rtrim(nome_cli),1,' +
                      IntToStr(Tamanho) + ')) = ' + ''''+ NomeAcertado + '''' + 'and pessoa_cli <> ''J'' ';

//        ListaAcertada.Items.Add( UpperCase(AnsiToAscii(Trim(listaOriginal.Items.Strings[X]))) );
        ListaAcertada.Items.Add( SQLUpdate );

    end;

end;

procedure TForm1.btnUpdateClick(Sender: TObject);
var
   X: Integer;
begin
    // Gera uma arquivo texto ou SQL já acertando o sexo de acordo com o nome 
    if SaveDialog1.Execute then begin
       ListaAcertada.Items.SaveToFile(SaveDialog1.FileName);
    end;

end;

end.
