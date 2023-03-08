unit BAR01;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ToolWin, ActnMan, ActnCtrls, ActnMenus, XPStyleActnCtrls,
  ActnList, ExtCtrls, Buttons, ComCtrls, DIMime, DB, StdCtrls, IdMessage,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdMessageClient, IdSMTP, QRExport, QRXMLSFilt, QRPDFFilt, OCXFISLib_TLB,iFiscal,vmaxFiscal,
  Tfhkaif;

type
  TfrmMain = class(TForm)
    ActionManager1: TActionManager;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionList1: TActionList;
    aclose: TAction;
    Panel1: TPanel;
    btsalir: TSpeedButton;
    btpos: TSpeedButton;
    apos: TAction;
    aproductos: TAction;
    acategoria: TAction;
    btabrir: TSpeedButton;
    acerrar: TAction;
    btcerrar: TSpeedButton;
    aabrir: TAction;
    stBar1: TStatusBar;
    segusuarios: TAction;
    admmesas: TAction;
    admareas: TAction;
    admempresa: TAction;
    consventas: TAction;
    admcuadre: TAction;
    Memo1: TMemo;
    IdSMTP1: TIdSMTP;
    IdMessage1: TIdMessage;
    QRPDFFilter1: TQRPDFFilter;
    QRXMLSFilter1: TQRXMLSFilter;
    QRExcelFilter1: TQRExcelFilter;
    QRRTFFilter1: TQRRTFFilter;
    QRWMFFilter1: TQRWMFFilter;
    QRTextFilter1: TQRTextFilter;
    QRCSVFilter1: TQRCSVFilter;
    Image1: TImage;
    admprinter: TAction;
    Proveedores: TAction;
    Entradas: TAction;
    Salidas: TAction;
    Clientes: TAction;
    consentradas: TAction;
    admCierreTurno: TAction;
    acierrejornada: TAction;
    acancelar: TAction;
    aherramienta: TAction;
    consdev: TAction;
    actPrinterFiscal: TAction;
    procedure acloseExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure aposExecute(Sender: TObject);
    procedure aproductosExecute(Sender: TObject);
    procedure acategoriaExecute(Sender: TObject);
    procedure aabrirExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure stBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure acerrarExecute(Sender: TObject);
    procedure segusuariosExecute(Sender: TObject);
    procedure admareasExecute(Sender: TObject);
    procedure admmesasExecute(Sender: TObject);
    procedure admempresaExecute(Sender: TObject);
    procedure consventasExecute(Sender: TObject);
    procedure admcuadreExecute(Sender: TObject);
    procedure admprinterExecute(Sender: TObject);
    procedure ProveedoresExecute(Sender: TObject);
    procedure EntradasExecute(Sender: TObject);
    procedure SalidasExecute(Sender: TObject);
    procedure ClientesExecute(Sender: TObject);
    procedure consentradasExecute(Sender: TObject);
    procedure admCierreTurnoExecute(Sender: TObject);
    procedure acierrejornadaExecute(Sender: TObject);
    procedure acancelarExecute(Sender: TObject);
    procedure aherramientaExecute(Sender: TObject);
    procedure consdevExecute(Sender: TObject);
    procedure actPrinterFiscalExecute(Sender: TObject);
  private
    procedure ActivaForma(Unidad: TFormClass; Var Forma : TForm);
  public
    { Public declarations }
    Usuario, vp_cia, vp_suc : Integer;
    Nombre  : String;
    Supervisor, Cajero, Camarero : Boolean;
  end;

var
  frmMain: TfrmMain;

implementation

uses BAR03, BAR00, BAR05, BAR11, BAR14, BAR19, BAR21, BAR23, BAR25, BAR27,
  BAR04, BAR37, BAR51, BAR56, BAR59, BAR58, BAR63, BAR65, BAR67, BAR71,
  BAR45, BAR511;

{$R *.dfm}

procedure TfrmMain.acloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.CreateForm(tfrmConfirm, frmConfirm);
  frmConfirm.lbtitulo.Caption := 'Está seguro que desea salir del Sistema?';
  frmConfirm.ShowModal;
  if frmConfirm.accion = 'S' then
    Application.Terminate
  else
  begin
    frmConfirm.Release;
    abort;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  btsalir.Caption  := 'F1'+#13+'SALIR';
  btpos.Caption    := 'F2'+#13+'POS';
  btabrir.Caption  := 'ABRIR'+#13+'SESION';
  btcerrar.Caption := 'CERRAR'+#13+'SESION';
  stBar1.Panels[0].Text := 'USUARIO : '+Nombre;
  //dm.QEmpresa.Active :=true;
  dm.getParametrosPrinterFiscal();
end;

procedure TfrmMain.aposExecute(Sender: TObject);
begin
  if Usuario > 0 then
  begin
    Application.CreateForm(tfrmPOS, frmPOS);
    frmPOS.Showmodal;
    frmPOS.release;
  end;
end;

procedure TfrmMain.aproductosExecute(Sender: TObject);
begin
  activaforma(TfrmProductos, tform(frmProductos));
  Panel1.Enabled := false;
{  Application.CreateForm(tfrmProductos, frmProductos);
  frmProductos.ShowModal;
  frmProductos.Release; //}
end;

procedure TfrmMain.acategoriaExecute(Sender: TObject);
begin
  activaforma(TfrmCategorias, tform(frmCategorias));
  Panel1.Enabled := false;
{  Application.CreateForm(tfrmCategorias, frmCategorias);
  frmCategorias.ShowModal;
  frmCategorias.Release; //}
end;

procedure TfrmMain.aabrirExecute(Sender: TObject);
var
vl_cont_pago : String;
begin
  Application.CreateForm(tfrmAcceso, frmAcceso);
  frmAcceso.ShowModal;
  if frmAcceso.Acepto = 1 then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    DM.Query1.SQL.Add('select isnull(par_controlar,''False'') par_controlar from parametros where emp_codigo = 1');
    DM.Query1.Open;
    if dm.Query1.IsEmpty then vl_cont_pago := 'False' else vl_cont_pago := DM.Query1.fieldbyname('par_controlar').Text;
    if vl_cont_pago = 'True' then
      begin
        dm.Query1.close;
        dm.Query1.SQL.clear;
        dm.Query1.SQL.add('select count(*) as cant from control_pagos');
        dm.Query1.Open;
        if dm.Query1.FieldByName('cant').Value = 0 then
        begin
          MessageDlg('COMUNIQUESE URGENTEMENTE CON EL LIC. VICTOR ESTEBAN TEL.:809-240-5197 CEL.:809-869-2161 E.:randyesteban01@hotmail.com',mtError,[mbok],0);
          Application.Terminate;
        end
        else
        begin
          dm.Query1.close;
          dm.Query1.SQL.clear;
          dm.Query1.SQL.add('select count(*) as cant from control_pagos');
          dm.Query1.SQL.add('where pag_fecha <= :fec');
          dm.Query1.SQL.add('and pag_status = '+QuotedStr('PEN'));
          dm.Query1.Parameters.ParamByName('fec').Value := Date;
          dm.Query1.Open;
          if dm.Query1.FieldByName('cant').Value > 0 then
          begin
            MessageDlg('COMUNIQUESE URGENTEMENTE CON EL LIC. VICTOR ESTEBAN TEL.:809-240-5197 CEL.:809-869-2161 E.:randyesteban01@hotmail.com',mtError,[mbok],0);
            Application.Terminate;
          end;
        end;
        END;

    dm.Query1.close;
    dm.Query1.sql.clear;
    dm.Query1.sql.add('select usu_codigo UsuarioID, usu_nombre Nombre, usu_supervisor Supervisor, usu_cajero Cajero, usu_camarero Camarero, usu_status Estatus from Usuarios');
   {if (copy(frmAcceso.edclave.Text,1,1) = ';') or (copy(frmAcceso.edclave.Text,1,1) = 'Ñ') then
    begin
      dm.Query1.sql.add('where tarjetaUsuarioID = :cla');
      dm.Query1.Parameters.parambyname('cla').Value := copy(frmAcceso.edclave.Text,2,10);
    end
    else
    begin}
      dm.Query1.sql.add('where usu_Clave = :cla');
      dm.Query1.Parameters.parambyname('cla').Value := MimeEncodeString(frmAcceso.edclave.Text);
   // end;
    dm.Query1.open;
    if dm.Query1.recordcount = 0 then
    begin
      showmessage('ESTE USUARIO NO EXISTE');
    end
    else if dm.Query1.FieldbyName('Estatus').AsString <> 'ACT' then
    begin
      showmessage('ESTE USUARIO NO ESTA ACTIVO');
    end
    else
    begin
      Usuario    := dm.Query1.FieldbyName('UsuarioID').AsInteger;
      Nombre     := dm.Query1.FieldbyName('Nombre').AsString;
      Supervisor := dm.Query1.FieldbyName('Supervisor').AsBoolean;
      Cajero     := dm.Query1.FieldbyName('Cajero').AsBoolean;
      Camarero   := dm.Query1.FieldbyName('Camarero').AsBoolean;
      btabrir.Enabled  := frmMain.Usuario = 0;
      btcerrar.Enabled := frmMain.Usuario > 0;
      aabrir.Enabled   := frmMain.Usuario = 0;
      acerrar.Enabled  := frmMain.Usuario > 0;
      btpos.Enabled    := frmMain.Usuario > 0;
      stBar1.Panels[0].Text := 'USUARIO : '+Nombre;
      aproductos.Enabled  := Supervisor;
      acategoria.Enabled  := Supervisor;
      segusuarios.Enabled := Supervisor;
      admmesas.Enabled    := Supervisor;
      admareas.Enabled    := Supervisor;
      consventas.Enabled  := Supervisor;
      admempresa.Enabled  := Supervisor;
      admcuadre.Enabled   := Supervisor;
      admprinter.Enabled  := supervisor;
      Proveedores.Enabled := supervisor;
      Entradas.Enabled    := supervisor;
      Salidas.Enabled     := supervisor;
      //Enviando Mail
      {dm.Query1.close;
      dm.Query1.SQL.clear;
      dm.Query1.SQL.add('select fecha from Email where fecha = :fec');
      dm.Query1.Parameters.ParamByName('fec').DataType := ftDate;
      dm.Query1.Parameters.ParamByName('fec').Value    := Date;
      dm.Query1.Open;
      if dm.Query1.RecordCount = 0 then
      begin
        Screen.Cursor := crHourGlass;

        Memo1.Lines.Clear;
        Memo1.Lines.Add('Empresa: '+dm.QEmpresaNombre.Value);
        Memo1.Lines.Add('RNC: '+dm.QEmpresaRNC.Value);
        Memo1.Lines.Add('Direccion: '+dm.QEmpresaDireccion.Value);
        Memo1.Lines.Add('Telefono: '+dm.QEmpresaTelefono.Value);
        Memo1.Lines.Add('Correo: '+dm.QEmpresaCorreo.Value);

        IdMessage1.From.Address := 'edgard.cepeda@gmail.com';
        IdMessage1.Recipients.EMailAddresses := 'edgard.cepeda@gmail.com';

        IdMessage1.Subject := DateToStr(Date)+' SIGMA BAR : '+dm.QEmpresaNombre.Value;
        IdMessage1.Body.Text := Memo1.Lines.Text;

        try
          IdSMTP1.Connect();
          IdSMTP1.Send(IdMessage1);

          dm.Query1.close;
          dm.Query1.SQL.clear;
          dm.Query1.SQL.add('insert into email (Fecha)');
          dm.Query1.SQL.add('values (:fec)');
          dm.Query1.Parameters.ParamByName('fec').DataType := ftDate;
          dm.Query1.Parameters.ParamByName('fec').Value    := Date;
          dm.Query1.ExecSQL;

          IdSMTP1.Disconnect;
        except
        end;

        Screen.Cursor := crDefault;

      end;}

    end;
          dm.Query1.close;
          dm.Query1.SQL.clear;
          dm.Query1.SQL.add('select top 1 emp_codigo from EmpAccesos where usu_codigo ='+IntToStr(Usuario));
          dm.Query1.SQL.add('order by emp_codigo');
          dm.Query1.Open;
          if dm.Query1.RecordCount > 0 then
          vp_cia := DM.Query1.Fields.FieldByName('emp_codigo').Value;
          dm.Query1.Close;
          dm.Query1.SQL.clear;
          dm.Query1.SQL.add('select top 1 suc_codigo from Sucursal_Acceso where usu_codigo ='+IntToStr(Usuario));
          dm.Query1.SQL.add('and emp_codigo = '+IntToStr(vp_cia)+ ' order by emp_codigo');
          dm.Query1.Open;
          if dm.Query1.RecordCount > 0 then
          vp_suc := DM.Query1.Fields.FieldByName('suc_codigo').Value;
  end;
  frmAcceso.Release;
end;


procedure TfrmMain.FormActivate(Sender: TObject);
begin
  btabrir.Enabled  := Usuario = 0;
  btcerrar.Enabled := Usuario > 0;
  btpos.Enabled := Usuario > 0;
  aabrir.Enabled  := Usuario = 0;
  acerrar.Enabled := Usuario > 0;
  Panel1.SetFocus;
end;

procedure TfrmMain.stBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
with StBAr1.Canvas do
  begin
    if Panel.Index = 0 then
    begin
      Brush.Color := clSkyBlue;
      FillRect(Rect);
      Font.Color := clBlack;
      Font.Style := Font.Style + [fsBold];
      TextOut(Rect.left + 5, Rect.top + 2, Panel.Text);
    end
    else if Panel.Index = 1 then
    begin
      Font.Color := clBlack;
      Font.Style := Font.Style + [fsBold];
      TextOut(Rect.left, Rect.top, Panel.Text);
    end
    else if Panel.Index = 4 then
    begin
      Brush.Color := clSkyBlue;
      FillRect(Rect);
      Font.Color := clBlack;
      Font.Style := Font.Style + [fsBold];
      TextOut(Rect.left + 5, Rect.top + 2, Panel.Text);
    end
    else
      TextOut(Rect.left, Rect.top, Panel.Text);
  end;
end;

procedure TfrmMain.acerrarExecute(Sender: TObject);
begin
  Usuario := 0;
  Nombre  := '';
  Supervisor := False;
  Cajero     := False;
  Camarero   := False;
  btabrir.Enabled  := Usuario = 0;
  btcerrar.Enabled := Usuario > 0;
  aabrir.Enabled  := Usuario = 0;
  acerrar.Enabled := Usuario > 0;
  btpos.Enabled    := frmMain.Usuario > 0;
  stBar1.Panels[0].Text := 'USUARIO : '+Nombre;

  frmMain.aproductos.Enabled  := frmMain.Supervisor;
  frmMain.acategoria.Enabled  := frmMain.Supervisor;
  frmMain.segusuarios.Enabled := frmMain.Supervisor;
  frmMain.admmesas.Enabled    := frmMain.Supervisor;
  frmMain.admareas.Enabled    := frmMain.Supervisor;
  frmMain.consventas.Enabled  := frmMain.Supervisor;
  frmMain.admempresa.Enabled  := frmMain.Supervisor;

end;

procedure TfrmMain.segusuariosExecute(Sender: TObject);
begin
  activaforma(TfrmUsuarios, tform(frmUsuarios));
  Panel1.Enabled := true;
{  Application.CreateForm(tfrmUsuarios, frmUsuarios);
  frmUsuarios.ShowModal;
  frmUsuarios.Release; //}
end;

procedure TfrmMain.admareasExecute(Sender: TObject);
begin
  activaforma(TfrmAreas, tform(frmAreas));
  Panel1.Enabled := false;
//  Application.CreateForm(tfrmAreas, frmAreas);
//  frmAreas.ShowModal;
//  frmAreas.Release;
end;

procedure TfrmMain.admmesasExecute(Sender: TObject);
begin
  activaforma(TfrmMesas, tform(frmMesas));
  Panel1.Enabled := true;
{  Application.CreateForm(tfrmMesas, frmMesas);
  frmMesas.ShowModal;
  frmMesas.Release; //}
end;

procedure TfrmMain.admempresaExecute(Sender: TObject);
begin
  activaforma(TfrmEmpresa, tform(frmEmpresa));
  Panel1.Enabled := false;
{  Application.CreateForm(tfrmEmpresa, frmEmpresa);
  frmEmpresa.ShowModal;
  frmEmpresa.Release; //}
end;

procedure TfrmMain.consventasExecute(Sender: TObject);
begin
  activaforma(tfrmConsVentasMod, tform(frmConsVentasMod));
  frmMain.Panel1.Enabled := false;
//  activaforma(tfrmConsVentas, tform(frmConsVentas));
//  frmMain.Panel1.Enabled := false;
{    Application.CreateForm(tfrmConsVentas, frmConsVentas);
  frmConsVentas.ShowModal;
  frmConsVentas.Release;  //}
end;

procedure TfrmMain.admcuadreExecute(Sender: TObject);
begin
  Application.CreateForm(tfrmCuadre, frmCuadre);
  frmCuadre.ShowModal;
  frmCuadre.Release;
end;

procedure TfrmMain.admprinterExecute(Sender: TObject);
begin
  activaforma(TfrmImpresoraRemota, tform(frmImpresoraRemota));
  Panel1.Enabled := false;
{  Application.CreateForm(tfrmImpresoraRemota, frmImpresoraRemota);
  try
    frmImpresoraRemota.ShowModal;
  finally
    frmImpresoraRemota.Release;
  end; //}
end;

procedure TfrmMain.ProveedoresExecute(Sender: TObject);
begin
  activaforma(TfrmProveedores, tform(frmProveedores));
  Panel1.Enabled := false;
{  Application.CreateForm(tfrmProveedores, frmProveedores);
  try
    frmProveedores.ShowModal;
  finally
    frmProveedores.Release;
  end; //}
end;

procedure TfrmMain.EntradasExecute(Sender: TObject);
begin
  activaforma(TfrmEntradas, tform(frmEntradas));
  Panel1.Enabled := false;
{  Application.CreateForm(tfrmEntradas, frmEntradas);
  try
    frmEntradas.ShowModal;
  finally
    frmEntradas.Release;
  end; //}
end;

procedure TfrmMain.SalidasExecute(Sender: TObject);
begin
  activaforma(TfrmSalidas, tform(frmSalidas));
  frmMain.Panel1.Enabled := true;
{  Application.CreateForm(tfrmSalidas, frmSalidas);
  try
    frmSalidas.ShowModal;
  finally
    frmSalidas.Release;
  end; //}
end;

procedure TfrmMain.ClientesExecute(Sender: TObject);
begin
  activaforma(TfrmClientes, tform(frmClientes));
  Panel1.Enabled := false;
{  Application.CreateForm(tfrmClientes, frmClientes);
  try
    frmClientes.ShowModal;
  finally
    frmClientes.Release;
  end; //}
end;

procedure TfrmMain.consentradasExecute(Sender: TObject);
begin
  activaforma(TfrmConsultaEnttrada, tform(frmConsultaEnttrada));
  Panel1.Enabled := false;
{  Application.CreateForm(tfrmConsultaEnttrada, frmConsultaEnttrada);
  frmConsultaEnttrada.ShowModal;
  frmConsultaEnttrada.Release; //}
end;

procedure TfrmMain.ActivaForma(Unidad: TFormClass; var Forma: TForm);
Var
  Indice : Integer;
  creada : Boolean;
begin
  creada := False;
  for Indice := 0 to frmMain.MDIChildCount-1 do
    If (MDIChildren[Indice] = TForm(Forma)) Then
    Begin
       creada := True;
       Break;
    End;
  If Not creada Then
  begin
     Application.CreateForm(Unidad, Forma);
     Forma.BringToFront;
  end
  Else
     MDIChildren[Indice].BringToFront;
end;




procedure TfrmMain.admCierreTurnoExecute(Sender: TObject);
var
  err : integer;
  arch : textfile;
  puerto : string;
  DriverFiscal1 : TDriverFiscal;
begin
  if MessageDlg('Está seguro que desea cerrar el turno?', mtConfirmation, [mbyes, mbno], 0) = mrYes then
  begin
    AssignFile(arch, 'puerto.ini');
    reset(arch);
    readln(arch, puerto);
    closefile(arch);

    DriverFiscal1 := TDriverFiscal.Create(Self);
    DriverFiscal1.SerialNumber := '27-0163848-435';

    err := DriverFiscal1.IF_OPEN(puerto, 9600);
    err := DriverFiscal1.IF_WRITE('@DailyCloseX|P');
    err := DriverFiscal1.IF_CLOSE;

    DriverFiscal1.Destroy;
  end;
end;

procedure TfrmMain.acierrejornadaExecute(Sender: TObject);
begin
  Application.CreateForm(tfrmCierreJornadaFiscal, frmCierreJornadaFiscal);
end;

procedure TfrmMain.acancelarExecute(Sender: TObject);
var
  err, error: integer;
  arch : textfile;
  puerto : string;
  DriverFiscal1 : TDriverFiscal;
begin
  AssignFile(arch, 'puerto.ini');
  reset(arch);
  readln(arch, puerto);
  closefile(arch);

  DriverFiscal1 := TDriverFiscal.Create(Self);
  DriverFiscal1.SerialNumber := '27-0163848-435';

  err := DriverFiscal1.IF_OPEN(puerto, 9600);
  err := DriverFiscal1.IF_WRITE('@TicketCancel');
  err := DriverFiscal1.IF_CLOSE;

  DriverFiscal1.Destroy;

end;

procedure TfrmMain.aherramientaExecute(Sender: TObject);
begin
  WinExec('EPSONDllExtraccionLV.exe', 1);
end;

procedure TfrmMain.consdevExecute(Sender: TObject);
begin
 Application.CreateForm(tfrmConsDev, frmConsDev);
  frmConsDev.ShowModal;
  frmConsDev.Release;
end;

procedure TfrmMain.actPrinterFiscalExecute(Sender: TObject);
begin
  activaforma(TfrmConfImpFiscal, tform(frmConfImpFiscal));
  Panel1.Enabled := false;
end;

end.
