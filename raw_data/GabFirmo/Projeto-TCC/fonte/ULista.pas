unit ULista;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, CRGrid, Vcl.Mask, Vcl.DBCtrls;

type
  Tfrm_lista = class(TForm)
    Image1: TImage;
    btn_voltar: TButton;
    CRDBGrid1: TCRDBGrid;
    RadioGroup1: TRadioGroup;
    btn_editar: TButton;
    txt_buscar: TEdit;
    btn_buscar: TButton;
    lb_buscar: TLabel;
    btn_buscarTudo: TButton;
    procedure btn_voltarClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure btn_buscarClick(Sender: TObject);
    procedure BuscarTudo;
    procedure btn_buscarTudoClick(Sender: TObject);
    procedure btn_editarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_lista: Tfrm_lista;

implementation

{$R *.dfm}

uses UPrincipal, UDM, UCadastroEPI;

procedure Tfrm_lista.btn_buscarClick(Sender: TObject);
begin
  with DM.UniTable1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from EPI');
    case RadioGroup1.ItemIndex of
    0:
      begin
        SQL.Add('where nome_prod like :nome');
        ParamByName('nome').Value := '%' + txt_buscar.Text + '%';
      end;
    1:
      begin
        SQL.Add('where tipo_prod = :tipo');
        ParamByName('tipo').Value := txt_buscar.Text;
      end;
    end;
    Open;
    Refresh;
  end;
end;

procedure Tfrm_lista.btn_buscarTudoClick(Sender: TObject);
begin
  BuscarTudo;
end;



procedure Tfrm_lista.btn_editarClick(Sender: TObject);
begin
  dm.UniTable1.Edit;
  frm_cadastroepi.visible:= true;
end;

procedure Tfrm_lista.btn_voltarClick(Sender: TObject);
begin
  frm_lista.visible:= false;
  frm_principal.visible:= true;
  txt_buscar.Text:=('');
end;



procedure Tfrm_lista.BuscarTudo;
begin
  dm.UniTable1.Close;
  dm.UniTable1.SQL.Clear;
  dm.UniTable1.SQL.Add('select * from EPI');
  dm.UniTable1.Open;
end;


procedure Tfrm_lista.RadioGroup1Click(Sender: TObject);
begin
  case RadioGroup1.ItemIndex of
    0:
    begin
    txt_buscar.Clear;
    txt_buscar.SetFocus;
    end;

  1:
    begin
    txt_buscar.Clear;
    txt_buscar.SetFocus;
    end;
  end;
end;



end.
