unit POS15;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ToolWin, ComCtrls, ExtCtrls, StdCtrls, Grids, DBGrids,
  DB, ADODB, DIMime, Mask, DBCtrls, OCXFISLib_TLB, DateUtils,iFiscal, Tfhkaif;

type
  TfrmConfig = class(TForm)
    ToolBar1: TToolBar;
    btsalir: TSpeedButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet7: TTabSheet;
    Panel29: TPanel;
    boton1: TStaticText;
    boton2: TStaticText;
    boton3: TStaticText;
    boton4: TStaticText;
    boton5: TStaticText;
    boton6: TStaticText;
    boton7: TStaticText;
    boton8: TStaticText;
    boton9: TStaticText;
    boton10: TStaticText;
    boton11: TStaticText;
    boton12: TStaticText;
    boton13: TStaticText;
    boton14: TStaticText;
    boton15: TStaticText;
    boton16: TStaticText;
    boton17: TStaticText;
    boton18: TStaticText;
    boton19: TStaticText;
    boton20: TStaticText;
    DBGrid1: TDBGrid;
    QUsuarios: TADOQuery;
    QUsuariosusu_codigo: TIntegerField;
    QUsuariosusu_nombre: TStringField;
    QUsuariosusu_clave: TStringField;
    QUsuariosusu_status: TStringField;
    QUsuariosusu_empdefault: TIntegerField;
    QUsuariosusu_realiza_cuadre: TStringField;
    QUsuariosusu_crea_NCF: TStringField;
    QUsuariosusu_modifica_precio: TStringField;
    QUsuariosusu_debajo_minimo: TStringField;
    QUsuariosusu_debajo_costo: TStringField;
    QUsuariosusu_excede_limite: TStringField;
    QUsuariosusu_factura_negativo: TStringField;
    QUsuariosusu_descuento: TStringField;
    QUsuariosusu_excede_descuento: TStringField;
    QUsuariosusu_modifica_factura: TStringField;
    QUsuariosusu_aumenta_precio: TStringField;
    QUsuariosusu_disminuye_precio: TStringField;
    QUsuariosusu_ver_costo: TStringField;
    dsUsuarios: TDataSource;
    btUsuIns: TBitBtn;
    btUsuDel: TBitBtn;
    btUsuMod: TBitBtn;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    btUsuSave: TBitBtn;
    btUsuCan: TBitBtn;
    DBGrid2: TDBGrid;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DBGrid3: TDBGrid;
    QListaUsu: TADOQuery;
    QListaUsuusu_codigo: TIntegerField;
    QListaUsuusu_nombre: TStringField;
    dsListaUsu: TDataSource;
    QSupervisor: TADOQuery;
    QSupervisorusu_codigo: TIntegerField;
    QSupervisorusu_nombre: TStringField;
    dsSuper: TDataSource;
    QCajas: TADOQuery;
    QCajasip: TStringField;
    QCajascaja: TIntegerField;
    QCajasprimer_campo: TStringField;
    dsCajas: TDataSource;
    QCajasporciento: TBCDField;
    QListaUsuusu_clave: TStringField;
    QCajasforma_numeracion: TIntegerField;
    QCajasncf_tarjeta: TStringField;
    QCajasPuerto: TStringField;
    QCajasPrecio: TStringField;
    QCajasalm_codigo: TIntegerField;
    QAlmacen: TADOQuery;
    dsAlmacen: TDataSource;
    QAlmacenalm_codigo: TIntegerField;
    QAlmacenalm_nombre: TStringField;
    QCajasemp_codigo: TIntegerField;
    QEmpresas: TADOQuery;
    QEmpresasemp_codigo: TIntegerField;
    QEmpresasemp_nombre: TStringField;
    dsEmpresas: TDataSource;
    QCajascodigo_abre_caja: TStringField;
    QCajascuenta: TStringField;
    QCajaspuerto_display: TStringField;
    QCajasTermica: TStringField;
    QCajasimprime_credito: TStringField;
    QCajasclave_empaque: TStringField;
    QCajasclave_temporal: TStringField;
    QCajasPrecio_Emp: TStringField;
    QCajasVerifica_Precio: TStringField;
    QCajasNombre: TStringField;
    QCajasTipo_Cuadre: TStringField;
    QCajasCuadrar_Empresa: TStringField;
    tsImpresoraFiscal: TTabSheet;
    BitBtn3: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    rbperiodo: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    fecha1: TDateTimePicker;
    fecha2: TDateTimePicker;
    rbrango: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    btnAnular: TSpeedButton;
    BitBtn10: TBitBtn;
    procedure btsalirClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure boton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dsUsuariosStateChange(Sender: TObject);
    procedure btUsuInsClick(Sender: TObject);
    procedure btUsuModClick(Sender: TObject);
    procedure btUsuSaveClick(Sender: TObject);
    procedure btUsuCanClick(Sender: TObject);
    procedure btUsuDelClick(Sender: TObject);
    procedure QUsuariosAfterDelete(DataSet: TDataSet);
    procedure QUsuariosAfterPost(DataSet: TDataSet);
    procedure QUsuariosBeforePost(DataSet: TDataSet);
    procedure FormActivate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure btCajaDelClick(Sender: TObject);
    procedure btCajaSaveClick(Sender: TObject);
    procedure btCajaCanClick(Sender: TObject);
    procedure QCajasAfterDelete(DataSet: TDataSet);
    procedure QCajasAfterPost(DataSet: TDataSet);
    procedure QCajasNewRecord(DataSet: TDataSet);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
  private
    { Private declarations }
    Stat, Err, X: Integer;
  public
    { Public declarations }
    procedure buscaproducto (bt : TObject);
  end;

var
  frmConfig: TfrmConfig;

implementation

uses POS09, POS01, POS00, POS03, POS08;

{$R *.dfm}

{ TfrmConfig }

procedure TfrmConfig.buscaproducto(bt: TObject);
var
  a : integer;
  busca : string;
begin
  busca := Uppercase(InputBox('Buscar Producto','Nombre del Producto',''));
  if Trim(busca) <> '' then
  begin
    Application.CreateForm(tfrmBuscaProducto, frmBuscaProducto);
    frmBuscaProducto.Precio := frmMain.PrecioCaja;
    frmBuscaProducto.QProductos.SQL.Clear;
    frmBuscaProducto.QProductos.SQL.Add('select p.pro_nombre, p.pro_precio1, e.exi_cantidad, p.pro_precio2,');
    frmBuscaProducto.QProductos.SQL.Add('p.pro_codigo, p.pro_roriginal, p.pro_servicio, p.pro_precio3, p.pro_precio4');
    frmBuscaProducto.QProductos.SQL.Add('from productos p, existencias e');
    frmBuscaProducto.QProductos.SQL.Add('where p.emp_codigo = e.emp_codigo');
    frmBuscaProducto.QProductos.SQL.Add('and p.pro_codigo = e.pro_codigo');
    frmBuscaProducto.QProductos.SQL.Add('and p.emp_codigo = :emp');
    frmBuscaProducto.QProductos.SQL.Add('and e.alm_codigo = :alm');
    frmBuscaProducto.QProductos.SQL.Add('and p.pro_nombre like '+QuotedStr('%'+busca+'%'));
    frmBuscaProducto.QProductos.SQL.Add('order by p.pro_nombre');
    frmBuscaProducto.QProductos.Parameters.ParamByName('emp').Value := frmMain.empresainv;
    frmBuscaProducto.QProductos.Open;
    frmBuscaProducto.ShowModal;
    if frmBuscaProducto.Selec = 1 then
    begin
      for a := 0 to ComponentCount -1 do
        if Components[a].ClassType = TStaticText then
          if (bt as TStaticText).Name = Components[a].Name then
          begin
            (Components[a] as TStaticText).Caption := frmBuscaProducto.QProductospro_nombre.Value;

            dm.Query1.Close;
            dm.Query1.SQL.Clear;
            dm.Query1.SQL.Add('delete from botones_caja where boton = '+QuotedStr((Components[a] as TStaticText).Name));
            dm.Query1.ExecSQL;

            dm.Query1.Close;
            dm.Query1.SQL.Clear;
            dm.Query1.SQL.Add('insert into botones_caja (boton, producto) values ('+QuotedStr((Components[a] as TStaticText).Name));
            dm.Query1.SQL.Add(','+IntToStr(frmBuscaProducto.QProductospro_codigo.Value)+')');
            dm.Query1.ExecSQL;
          end;
    end;
    frmBuscaProducto.Release;
  end
  else
  begin
    for a := 0 to ComponentCount -1 do
      if Components[a].ClassType = TStaticText then
        if (bt as TStaticText).Name = Components[a].Name then
        begin
          dm.Query1.Close;
          dm.Query1.SQL.Clear;
          dm.Query1.SQL.Add('delete from botones_caja where boton = '+QuotedStr((Components[a] as TStaticText).Name));
          dm.Query1.ExecSQL;

          (Components[a] as TStaticText).Caption := '';
        end;
  end;
end;

procedure TfrmConfig.btsalirClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConfig.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
  begin
    btsalirClick(Self);
    key := #0;
  end;
  if key = #13 then
  begin
    if ActiveControl.ClassType <> TDBGrid then
    begin
      Perform(wm_nextdlgctl,0,0);
      key := #0;
    end;
  end;
end;

procedure TfrmConfig.boton1Click(Sender: TObject);
begin
  buscaproducto(Sender);
end;

procedure TfrmConfig.FormCreate(Sender: TObject);
begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select b.boton, p.pro_nombre from botones_caja b, productos p');
  dm.Query1.SQL.Add('where b.producto = p.pro_codigo and p.emp_codigo = :emp');
  dm.Query1.Parameters.ParamByName('emp').Value := frmMain.empresainv;
  dm.Query1.Open;
  dm.Query1.DisableControls;
  while not dm.Query1.Eof do
  begin
    (FindComponent(dm.Query1.FieldByName('boton').AsString) as TStaticText).Caption :=
                                            dm.Query1.FieldByName('pro_nombre').AsString;
    dm.Query1.Next;
  end;
  dm.Query1.EnableControls;
end;

procedure TfrmConfig.dsUsuariosStateChange(Sender: TObject);
begin
  btUsuIns.Enabled  := dsUsuarios.State = dsBrowse;
  btUsuDel.Enabled  := btUsuIns.Enabled;
  btUsuMod.Enabled  := btUsuIns.Enabled;
  btUsuSave.Enabled := not btUsuIns.Enabled;
  btUsuCan.Enabled  := not btUsuIns.Enabled;
  DBEdit3.Enabled   := dsUsuarios.State = dsInsert;
end;

procedure TfrmConfig.btUsuInsClick(Sender: TObject);
begin
  DBEdit2.SetFocus;
  QUsuarios.Append;
end;

procedure TfrmConfig.btUsuModClick(Sender: TObject);
begin
  DBEdit2.SetFocus;
  QUsuarios.Edit;
end;

procedure TfrmConfig.btUsuSaveClick(Sender: TObject);
begin
  QUsuarios.Post;
end;

procedure TfrmConfig.btUsuCanClick(Sender: TObject);
begin
  QUsuarios.Cancel;
end;

procedure TfrmConfig.btUsuDelClick(Sender: TObject);
begin
  if MessageDlg('Está seguro?',mtConfirmation,[mbYes, mbNo],0) = mrYes then
    QUsuarios.Delete;
end;

procedure TfrmConfig.QUsuariosAfterDelete(DataSet: TDataSet);
begin
  QUsuarios.UpdateBatch;
end;

procedure TfrmConfig.QUsuariosAfterPost(DataSet: TDataSet);
begin
  QUsuarios.UpdateBatch;
end;

procedure TfrmConfig.QUsuariosBeforePost(DataSet: TDataSet);
begin
  if (QUsuariosusu_nombre.IsNull) or (Trim(QUsuariosusu_nombre.Value) = '') then
  begin
    MessageDlg('Debe especificar el nombre del usuario',mtError,[mbok],0);
    DBEdit2.SetFocus;
    Abort;
  end;
  if QUsuarios.State = dsInsert then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select max(usu_codigo) as maximo');
    dm.Query1.SQL.Add('from usuarios');
    dm.Query1.Open;
    QUsuariosusu_codigo.Value := dm.Query1.FieldByName('maximo').AsInteger + 1;
    QUsuariosusu_clave.Value := MimeEncodeString(QUsuariosusu_clave.Value);
  end;
end;

procedure TfrmConfig.FormActivate(Sender: TObject);
begin
  if not QUsuarios.Active then
  begin
    QEmpresas.Open;
    QAlmacen.Parameters.ParamByName('emp').Value := frmMain.empresainv;
    QAlmacen.Open;
    QUsuarios.Open;
    QListaUsu.Open;
    QSupervisor.Open;
    QCajas.Open;
  end;
end;

procedure TfrmConfig.BitBtn1Click(Sender: TObject);
begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('insert into clave_supervisor_caja');
  dm.Query1.SQL.Add('(usu_codigo, clave)');
  dm.Query1.SQL.Add('values (:usu, :cla)');
  dm.Query1.Parameters.ParamByName('usu').Value := QListaUsuusu_codigo.Value;
  dm.Query1.Parameters.ParamByName('cla').Value := MimeDecodeString(QListaUsuusu_clave.Value);
  dm.Query1.ExecSQL;
  QListaUsu.Close;
  QListaUsu.Open;
  QSupervisor.Close;
  QSupervisor.Open;
end;

procedure TfrmConfig.BitBtn2Click(Sender: TObject);
begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('delete from clave_supervisor_caja');
  dm.Query1.SQL.Add('where usu_codigo = :usu');
  dm.Query1.Parameters.ParamByName('usu').Value := QSupervisorusu_codigo.Value;
  dm.Query1.ExecSQL;
  QListaUsu.Close;
  QListaUsu.Open;
  QSupervisor.Close;
  QSupervisor.Open;
end;

procedure TfrmConfig.btCajaDelClick(Sender: TObject);
begin
  QCajas.Delete;
end;

procedure TfrmConfig.btCajaSaveClick(Sender: TObject);
begin
  QCajas.Post;
end;

procedure TfrmConfig.btCajaCanClick(Sender: TObject);
begin
  QCajas.Cancel;
end;

procedure TfrmConfig.QCajasAfterDelete(DataSet: TDataSet);
begin
  QCajas.UpdateBatch;
end;

procedure TfrmConfig.QCajasAfterPost(DataSet: TDataSet);
begin
  QCajas.UpdateBatch;
end;

procedure TfrmConfig.QCajasNewRecord(DataSet: TDataSet);
begin
  QCajasforma_numeracion.Value := 0;
  QCajasncf_tarjeta.Value := 'C';
  QCajasPuerto.Value := 'PRN';
  QCajasPrecio.Value := 'Precio1';
  QCajasimprime_credito.Value := 'True';
  QCajasclave_empaque.Value := 'False';
  QCajasclave_temporal.Value := 'False';
end;

procedure TfrmConfig.BitBtn3Click(Sender: TObject);
var
  err : integer;
  arch : textfile;
  puerto : string;

  procedure Epson();
  var
    DriverFiscal1 : TDriverFiscal;
  begin
    DriverFiscal1 := TDriverFiscal.Create(Self);
    DriverFiscal1.SerialNumber := '27-0163848-435';
    try
      err := DriverFiscal1.IF_OPEN(puerto, Impresora.Velocidad);
      err := DriverFiscal1.IF_WRITE('@DailyCloseX|P');
      err := DriverFiscal1.IF_CLOSE;
    finally
      DriverFiscal1.Destroy;
    end;
  end;
    //*
  procedure Tecnologia_Tfhkaif();
   //cubre las BIXOLON/HKA80
   Var
     Stat: Integer;
     Respuesta: Boolean;
  begin
    if not Impresora.isConected then
      OpenFpctrl(pchar(PuertoSerial[Impresora.Puerto -1]));

    if Not CheckFprinter Then
      begin
        ShowMessage('Impresora NO conectada');
        Abort;
      end
    else Impresora.isConected :=true;
      SendCmd(Stat, Err, 'I0X0');

  end;
begin
  if MessageDlg('Está seguro que desea cerrar el turno?', mtConfirmation, [mbyes, mbno], 0) = mrYes then
  begin
    Puerto := PuertoSerial[Impresora.Puerto -1];

    case  Impresora.IDPrinter of
      1 : {EPSON (TMU-220)} Epson();
      // 2 : {CITIZEN ( CT-S310 )}
      // 3 : {CITIZEN (GSX-190)}
      //4 : {STAR (TSP650FP)}
      5 : {Bixolon SRP-350iiHG}  Tecnologia_Tfhkaif();
    end;
  end;

end;

procedure TfrmConfig.BitBtn6Click(Sender: TObject);
begin
  case  Impresora.IDPrinter of
    1 : {EPSON (TMU-220)} WinExec('EPSONDllExtraccionLV.exe', 1);
    // 2 : {CITIZEN ( CT-S310 )}
    // 3 : {CITIZEN (GSX-190)}
    //4 : {STAR (TSP650FP)}
    5 : {Bixolon SRP-350iiHG} WinExec('BixolonExtracionLV.bat', 0);
  end;

end;

procedure TfrmConfig.BitBtn7Click(Sender: TObject);
var
  err, error: integer;
  arch : textfile;
  puerto : string;


  procedure Epson;
  var   DriverFiscal1 : TDriverFiscal;
  begin
    DriverFiscal1 := TDriverFiscal.Create(Self);
    DriverFiscal1.SerialNumber := '27-0163848-435';
    err := DriverFiscal1.IF_OPEN(PuertoSerial[Impresora.Puerto -1], Impresora.Velocidad);
    err := DriverFiscal1.IF_WRITE('@TicketCancel');
    err := DriverFiscal1.IF_CLOSE;
    DriverFiscal1.Destroy;
  end;

  procedure Tecnologia_Tfhkaif;
  begin
    if not Impresora.isConected then
      OpenFpctrl(pchar(PuertoSerial[Impresora.Puerto -1]));

    if Not CheckFprinter Then
      begin
        ShowMessage('Impresora NO conectada');
        Abort;
      end
    else Impresora.isConected :=true;


    SendCmd(stat, err, '7');
    //CloseFpctrl;
  end;

begin
  //Cancela documentos
  Puerto := PuertoSerial[Impresora.Puerto -1];
  case  Impresora.IDPrinter of
    1 : {EPSON (TMU-220)} Epson;
    // 2 : {CITIZEN ( CT-S310 )}
    // 3 : {CITIZEN (GSX-190)}
    //4 : {STAR (TSP650FP)}
    5 : {Bixolon SRP-350iiHG} Tecnologia_Tfhkaif;
  end;

end;

procedure TfrmConfig.BitBtn4Click(Sender: TObject);
var
  err, dias, cant : integer;
  arch : textfile;
  puerto, ano1, mes1, dia1, ano2, mes2, dia2, vfecha1, vfecha2 : string;
  DriverFiscal1 : TDriverFiscal;


  procedure Epson;
  Begin

    DriverFiscal1 := TDriverFiscal.Create(Self);
    DriverFiscal1.SerialNumber := '27-0163848-435';

    err := DriverFiscal1.IF_OPEN(PuertoSerial[Impresora.Puerto -1], Impresora.Velocidad);
    err := DriverFiscal1.IF_WRITE('@DailyCloseZ|P');
    err := DriverFiscal1.IF_CLOSE;

    DriverFiscal1.Destroy;
  End;


  procedure Tecnologia_Tfhkaif;
  Begin

    if not Impresora.isConected then
      OpenFpctrl(pchar(PuertoSerial[Impresora.Puerto -1]));

    if Not CheckFprinter Then
      begin
        ShowMessage('Impresora NO conectada');
        Abort;
      end
    else Impresora.isConected :=true;

    SendCmd(Stat, Err, 'I0Z0');
   // CloseFpctrl;
  End;

begin
  //CierreJornada por dia
  if MessageDlg('Está seguro que desea cerrar el la Jornada Fiscal?', mtConfirmation, [mbyes, mbno], 0) = mrYes then
  begin

    case  Impresora.IDPrinter of
      1 : {EPSON (TMU-220)} Epson;
      // 2 : {CITIZEN ( CT-S310 )}
      // 3 : {CITIZEN (GSX-190)}
      //4 : {STAR (TSP650FP)}
      5 : {Bixolon SRP-350iiHG} Tecnologia_Tfhkaif;
    end;


  end;

end;

procedure TfrmConfig.BitBtn5Click(Sender: TObject);
var
  err, dias, cant : integer;
  arch : textfile;
  puerto, ano1, mes1, dia1, ano2, mes2, dia2, vfecha1, vfecha2 : string;


  procedure Tecnologia_Tfhkaif_PorFecha;
  Begin
    if not Impresora.isConected then
      OpenFpctrl(pchar(PuertoSerial[Impresora.Puerto -1]));

    if Not CheckFprinter Then
      begin
        ShowMessage('Impresora NO conectada');
        Abort;
      end
    else Impresora.isConected :=true;

    SendCmd(Stat, Err, PChar('Rz0' + FormatDateTime('yymmdd', Fecha1.Date) + '0' + FormatDateTime('yymmdd', Fecha2.Date)));
    //CloseFpctrl;
  End;

   procedure Epson();
    var
           DriverFiscal1 : TDriverFiscal;
   begin
     DriverFiscal1 := TDriverFiscal.Create(Self);
     DriverFiscal1.SerialNumber := '27-0163848-435';
     err := DriverFiscal1.IF_OPEN(PuertoSerial[Impresora.Puerto -1], Impresora.Velocidad);
     err := DriverFiscal1.IF_WRITE('@DailyCloseByDate|'+vfecha1+'|'+vfecha2+'|F|P');
     err := DriverFiscal1.IF_WRITE('@GetNextDailyCloseReportData');

     dias := DaysBetween(fecha1.Date, fecha2.Date);
     cant := 1;
     while (cant <= dias+1) do
     begin
       err := DriverFiscal1.IF_WRITE('@GetNextDailyCloseReportData');
       cant := cant + 1;
     end;
     err := DriverFiscal1.IF_WRITE('@CloseDailyCloseReport');
     err := DriverFiscal1.IF_CLOSE;

     DriverFiscal1.Destroy;
   end;

begin
  if MessageDlg('Está seguro que desea cerrar el la Jornada Fiscal?', mtConfirmation, [mbyes, mbno], 0) = mrYes then
  begin


    if Fecha1.date > Fecha2.Date  Then
    Begin
      ShowMessage('La fecha de inicio no puede ser mayor a la fecha de termino');
      exit;
    End;

    ano1 := inttostr(YearOf(fecha1.Date));
    mes1 := FormatFloat('00', MonthOf(fecha1.Date));
    dia1 := FormatFloat('00', DayOf(fecha1.Date));

    ano2 := inttostr(YearOf(fecha2.Date));
    mes2 := FormatFloat('00', MonthOf(fecha2.Date));
    dia2 := FormatFloat('00', DayOf(fecha2.Date));

    vfecha1 := dia1+mes1+ano1;
    vfecha2 := dia2+mes2+ano2;
      case  Impresora.IDPrinter of
    1 : {EPSON (TMU-220)} Epson;
    // 2 : {CITIZEN ( CT-S310 )}
    // 3 : {CITIZEN (GSX-190)}
    //4 : {STAR (TSP650FP)}
    5 : {Bixolon SRP-350iiHG} Tecnologia_Tfhkaif_PorFecha;
  end;
  end;

end;

procedure TfrmConfig.BitBtn8Click(Sender: TObject);
var
  err, dias, cant : integer;
  arch : textfile;
  puerto, ano1, mes1, dia1, ano2, mes2, dia2, vfecha1, vfecha2 : string;
  DriverFiscal1 : TDriverFiscal;
  desde, hasta : integer;


  procedure EpsonPorNumero;
  begin

DriverFiscal1 := TDriverFiscal.Create(Self);
    DriverFiscal1.SerialNumber := '27-0163848-435';

    desde := strtoint(edit1.text);
    hasta := strtoint(edit2.text);

    err := DriverFiscal1.IF_OPEN(PuertoSerial[Impresora.Puerto -1], Impresora.Velocidad);
    err := DriverFiscal1.IF_WRITE('@DailyCloseByNumber|'+inttostr(desde)+'|'+inttostr(hasta)+'|R|P');

    dias := hasta - desde;
    cant := 1;

    err := DriverFiscal1.IF_OPEN(PuertoSerial[Impresora.Puerto -1], Impresora.Velocidad);
    err := DriverFiscal1.IF_WRITE('@DailyCloseByDate|'+vfecha1+'|'+vfecha2+'|R|P');
    err := DriverFiscal1.IF_WRITE('@GetNextDailyCloseReportData');

      dias := hasta - desde;
    cant := 1;
    while (cant <= dias+1) do
    begin
      err := DriverFiscal1.IF_WRITE('@GetNextDailyCloseReportData');
      cant := cant + 1;
    end;
    err := DriverFiscal1.IF_WRITE('@CloseDailyCloseReport');

    err := DriverFiscal1.IF_CLOSE;

    DriverFiscal1.Destroy;
  end;


  procedure Tecnologia_Tfhkaif_PorNumero;
  Begin

    if not Impresora.isConected then
      OpenFpctrl(pchar(PuertoSerial[Impresora.Puerto -1]));

    if Not CheckFprinter Then
      begin
        ShowMessage('Impresora NO conectada');
        Abort;
      end
    else Impresora.isConected :=true;
    SendCmd(Stat, Err, PChar('RZ' + Format('%.*d', [7, StrToInt(Edit1.Text)]) + Format('%.*d', [7, StrToInt(Edit2.Text)])));
    //CloseFpctrl;
  End;

begin
  if MessageDlg('Está seguro que desea cerrar el la Jornada Fiscal?', mtConfirmation, [mbyes, mbno], 0) = mrYes then
  begin
      if Trim(Edit1.Text) = ''  Then
    Begin
      ShowMessage('El numero de inicio no puede estar en blanco');
      exit;
    End;
    if Trim(Edit2.Text) = ''  Then
    Begin
      ShowMessage('El numero de inicio no puede estar en blanco');
      exit;
    End;

      case  Impresora.IDPrinter of
    1 : {EPSON (TMU-220)} EpsonPorNumero;
    // 2 : {CITIZEN ( CT-S310 )}
    // 3 : {CITIZEN (GSX-190)}
    //4 : {STAR (TSP650FP)}
    5 : {Bixolon SRP-350iiHG} Tecnologia_Tfhkaif_PorNumero;
  end;


  end;

end;

procedure TfrmConfig.BitBtn9Click(Sender: TObject);
  procedure Tecnologia_Tfhkaif ;
  Begin
    if not Impresora.isConected then
      OpenFpctrl(pchar(PuertoSerial[Impresora.Puerto -1]));

    if Not CheckFprinter Then
      begin
        ShowMessage('Impresora NO conectada');
        Abort;
      end
    else Impresora.isConected :=true;

    SendCmd(Stat, Err, 'RU');
    //CloseFpctrl;
  End;

begin
//re-impresion de documentos
  case  Impresora.IDPrinter of
   // 1 : {EPSON (TMU-220)} Epson();
    // 2 : {CITIZEN ( CT-S310 )}
    // 3 : {CITIZEN (GSX-190)}
    //4 : {STAR (TSP650FP)}
    5 : {Bixolon SRP-350iiHG}  Tecnologia_Tfhkaif();
  end;

end;

procedure TfrmConfig.BitBtn10Click(Sender: TObject);
begin
  Application.CreateForm(tfrmAcceso, frmAcceso);
  frmAcceso.lbtitulo.Caption := 'Digite la clave del Supervisor';
  frmAcceso.ShowModal;
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select usu_codigo, clave from clave_supervisor_caja');
  dm.Query1.SQL.Add('where clave = :cla');
  DM.Query1.SQL.Add('and usu_codigo IN (select usu_codigo from usuarios where usu_status = '+QuotedStr('ACT')+')');
  dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
  dm.Query1.Open;
  if dm.Query1.RecordCount = 0 then
  begin
    MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);

  end
  else
  begin
    Application.CreateForm(tfrmAnular, frmAnular);
    frmAnular.supervisor := dm.Query1.FieldByName('usu_codigo').AsInteger;
    frmAnular.btimprimir.Visible := False;
    frmAnular.QTicket.Close;
    frmAnular.QTicket.SQL.Add('order by fecha desc, ticket desc');
    frmAnular.QTicket.Parameters.ParamByName('usu').Value     := dm.Usuario;
    frmAnular.QTicket.Parameters.ParamByName('fec1').DataType := ftDateTime;
    frmAnular.QTicket.Parameters.ParamByName('fec1').Value    := frmAnular.hora1.DateTime;
    frmAnular.QTicket.Parameters.ParamByName('fec2').DataType := ftDateTime;
    frmAnular.QTicket.Parameters.ParamByName('fec2').Value    := frmAnular.hora2.DateTime;
    frmAnular.QTicket.Parameters.ParamByName('caj').Value     := StrToInt(frmMain.edcaja.Caption);
    frmAnular.QTicket.Open;
    frmAnular.ShowModal;
    frmAnular.Release;
  end;
  frmAcceso.Release;

end;

end.
