unit POS12;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfrmDevuelta = class(TForm)
    Label1: TLabel;
    lbdevuelta: TStaticText;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    recibido, devuelta : double;
  end;

var
  frmDevuelta: TfrmDevuelta;

implementation

uses POS01, POS00;

{$R *.dfm}

procedure TfrmDevuelta.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmDevuelta.FormActivate(Sender: TObject);
var
  arch : textfile;
  codigo, cod, abrir : string;
  a : integer;
  lista : tstrings;
begin
  frmMain.DisplayDevuelta(recibido, devuelta); 

  {dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select codigo_abre_caja from cajas_IP');
  dm.Query1.SQL.Add('where caja = :caj');
  dm.Query1.Parameters.ParamByName('caj').Value := frmMain.edCaja.Caption;
  dm.Query1.Open;
  codigo := dm.Query1.FieldByName('codigo_abre_caja').AsString;

  lista := TStringList.Create;
  lista.Clear;
  if pos(',',codigo) >0 then
  begin
    for a:= 1 to length(codigo) do
    begin
      if pos(',',codigo) >0 then
      begin
        cod := copy(codigo,1,pos(',',codigo)-1);
        lista.Add(cod);
      end
      else
      begin
        cod := codigo;
        lista.Add(cod);
        break;
      end;
      codigo := copy(codigo,pos(',',codigo)+1,length(codigo));
    end;
  end
  else
    lista.Add(codigo);
  abrir := '';
  for a := 0 to lista.Count-1 do
    abrir := abrir + chr(strtoint(lista[a]));
  lista.Destroy;

  assignfile(arch,'.\caja.txt');
  rewrite(arch);
  writeln(arch,chr(27)+chr(112)+chr(0)+chr(25)+chr(250));
  //writeln(arch,abrir);
  closefile(arch);

  assignfile(arch,'.\caja.bat');
  rewrite(arch);
  writeln(arch,'type .\caja.txt > prn');
  closefile(arch);

  winexec('.\caja.bat',0);}
end;

end.
