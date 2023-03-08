unit untConectar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmConectar = class(TForm)
    btnConectar: TButton;
    edtPorta: TEdit;
    lblPorta: TLabel;
    edtServidor: TEdit;
    lblServidor: TLabel;
    btnFechar: TButton;
    procedure btnFecharClick(Sender: TObject);
    procedure btnConectarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConectar: TfrmConectar;

implementation

{$R *.dfm}

uses ClientClassesUnit1, ClientModuleUnit1, untCliente;

procedure TfrmConectar.btnConectarClick(Sender: TObject);
begin
  with ClientModule1 do
  begin
    if btnConectar.Caption = 'Conectar' then
    begin
      SQLConnection1.Close;
      SQLConnection1.Params.Clear;
      SQLConnection1.Params.Add('DriverUnit=Data.DBXDataSnap');
      SQLConnection1.Params.Add('HostName=' + edtServidor.Text);
      SQLConnection1.Params.Add('Port=' + edtPorta.Text);
      SQLConnection1.Params.Add('CommunicationProtocol=tcp/ip');
      SQLConnection1.Params.Add('DatasnapContext=datasnap/');
      SQLConnection1.Params.Add('DriverAssemblyLoader=Borland.Data.TDBXClientDriverLoader,Borland.Data.DbxClientDriver,Version=21.0.0.0,Culture=neutral,PublicKeyToken=91d62ebb5b0d1b1b');
      SQLConnection1.Params.Add('Filters={}');
      SQLConnection1.Connected := true;
      cdsPessoa.Open;
      if SQLConnection1.Connected then
      begin
        frmCliente.lblTotalRegistros.Caption := 'Total de registros: ' + IntToStr(ClientModule1.cdsPessoa.RecordCount);
        btnConectar.Caption := 'Desconectar';
      end;
    end
    else
    begin
      SQLConnection1.Connected := false;
      SQLConnection1.Close;
      cdsPessoa.Close;
      btnConectar.Caption := 'Conectar';
    end;
  end;
end;

procedure TfrmConectar.btnFecharClick(Sender: TObject);
begin
  Close;
end;

end.
