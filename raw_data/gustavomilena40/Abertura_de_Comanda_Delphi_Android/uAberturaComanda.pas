unit uAberturaComanda;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.StrUtils, System.IOUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Memo,
  FMX.Edit, FMX.Layouts, FMX.ListBox,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Gestures,
  FMX.TabControl, System.Math, FMX.DateTimeCtrls, System.Rtti, FMX.Grid,
  MaskUtils, FMX.VirtualKeyboard, FMX.Platform,
  FMX.Ani, System.Bindings.Outputs, FMX.Bind.Editors, Data.Bind.EngExt,
  FMX.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, FMX.ComboEdit,
  uCombobox, uParametros, FMX.Objects, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.Bind.Controls,
  FMX.Bind.Navigator, FMX.ExtCtrls, FMX.Effects, FMX.Filter.Effects , System.UIConsts
{$IFDEF IOS}
    , FMX.Forms
{$ENDIF}
{$IFDEF Android}
    , FMX.Platform.Android,
  FMX.Helpers.Android,
  Androidapi.JNI.Embarcadero
{$ENDIF}
    ;

type

  TfAberturaComanda = class(TForm)
    GestureManager1: TGestureManager;
    TabControl1: TTabControl;
    tabprinc: TTabItem;
    Timer1: TTimer;
    Panel1: TPanel;
    Label5: TLabel;
    edcpf: TEdit;
    edrg: TEdit;
    Label6: TLabel;
    cbmaioridade: TCheckBox;
    lbniver: TLabel;
    eddtnasc: TDateEdit;
    edtelefone: TEdit;
    Label3: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    edcomanda: TEdit;
    Label2: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edtaxa: TEdit;
    edvalor: TEdit;
    edconsu: TEdit;
    edtaxadesc: TEdit;
    btAdcEntrada: TSpeedButton;
    Adicionar: TLabel;
    Label14: TLabel;
    SpeedButton3: TSpeedButton;
    tabparam: TTabItem;
    VertScrollBox2: TVertScrollBox;
    LayoutaInfos: TLayout;
    LayoutEntrada: TLayout;
    Rectangle4: TRectangle;
    VertScrollBox1: TVertScrollBox;
    BindingsList1: TBindingsList;
    lbValidacpf: TLabel;
    lbvalidarg: TLabel;
    lbvalidatelefone: TLabel;
    Layout2: TLayout;
    ednomecli: TEdit;
    lbvalidacomanda: TLabel;
    StyleBook1: TStyleBook;
    Line2: TLine;
    Rectangle5: TRectangle;
    SpeedButton5: TSpeedButton;
    Rectangle1: TRectangle;
    Label9: TLabel;
    Label10: TLabel;
    Line1: TLine;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    recCon: TRectangle;
    lbAvisoParaProgramadorLayoutTablet: TLabel;
    AniIndicator1: TAniIndicator;
    recLogo: TRectangle;
    Button1: TButton;
    Button2: TButton;
    edIpServidor: TEdit;
    edPortaServidor: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    Panel2: TPanel;
    BindSourceDB1: TBindSourceDB;
    FDQuery1: TFDQuery;
    LinkControlToField2: TLinkControlToField;
    edEntradaPadrao: TEdit;
    Label8: TLabel;
    LayoutTelefone: TLayout;
    LayoutCpf: TLayout;
    LayoutRG: TLayout;
    LayoutDtNasc: TLayout;
    LayoutEmail: TLayout;
    edemail: TEdit;
    Label7: TLabel;
    lbvalidaemail: TLabel;
    LayoutNome: TLayout;
    lbmensagemcli: TLabel;
    Label17: TLabel;
    edNumTablet: TEdit;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    Confirmar: TLabel;
    CKConecta: TCheckBox;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    PainelSenha: TPanel;
    Rectangle6: TRectangle;
    Lbsenha: TLabel;
    btsenha: TButton;
    edsenha: TEdit;
    Button4: TButton;
    rgb: TFillEffect;

    procedure FormGesture(Sender: TObject;
      const [Ref] EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
    procedure Timer1Timer(Sender: TObject);
    procedure edcomandaEnter(Sender: TObject);
    procedure ednomecliEnter(Sender: TObject);
    procedure edtelefoneEnter(Sender: TObject);
    procedure edcpfEnter(Sender: TObject);
    procedure edrgEnter(Sender: TObject);
    procedure edemailEnter(Sender: TObject);
    procedure edrgExit(Sender: TObject);
    procedure eddtnascEnter(Sender: TObject);

    procedure btAdcEntradaClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);

    procedure SpeedButton5Click(Sender: TObject);
    procedure edcpfExit(Sender: TObject);
    procedure edcpfKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edrgKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtelefoneExit(Sender: TObject);
    procedure edtelefoneKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edemailExit(Sender: TObject);
    procedure eddtnascExit(Sender: TObject);

    procedure Rectangle3Tap(Sender: TObject; const [Ref] Point: TPointF);
    procedure Rectangle2Tap(Sender: TObject; const [Ref] Point: TPointF);
    procedure Button2Click(Sender: TObject);
    procedure FDQuery1AfterOpen(DataSet: TDataSet);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Rectangle5Click(Sender: TObject);
    procedure Rectangle4MouseEnter(Sender: TObject);
    procedure edEntradaPadraoClick(Sender: TObject);
    procedure tabparamClick(Sender: TObject);
    procedure FrameSenhaBtSenhaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button4MouseEnter(Sender: TObject);
    procedure Button4MouseLeave(Sender: TObject);



    // procedure Panel2Click(Sender: TObject);

  private
    c: TCustomCombo;
    vAdcItems: integer;
    FKBBounds: TRectF;
    FNeedOffset: Boolean;
    Keyboard: IFMXVirtualKeyboardService;
    vCodTaxaPadrao: string;

    // variaveis para salvar a posições dos layouts e controlar as labels
    XCpf, YCpf, XRg, YRg, XFone, YFone, XNome, YNome, XEmail, YEmail, XDtNasc,
      YDtNasc: single;

    vControlaTabOrder: integer;
    // variavel para controlar se já rodou essa função
    EDcomponente: array [0 .. 3] of TEdit;
    LBcomponente: array [0 .. 3] of TLabel;

    procedure RestorePosition;
    procedure UpdateKBBounds;
    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    procedure HideVirtualKeyboard;
    procedure CallForKeyboard(open: Boolean; input: TFmxObject);
    procedure controlaTabOrder;
    procedure conectaServidorAndroid;
    procedure SalvarPosicaoComponentes;
    function VerificaDuplicidadeInfos: Boolean;
    procedure gravaArrayTedit;

{$IFDEF MSWINDOWS}
    procedure ItemClick(Sender: TObject);
{$ELSE}
    procedure ItemClick(Sender: TObject; const Point: TPointF);
{$ENDIF}
    { Private declarations }
  public
    vOrigemCombobox: string;
    procedure SetaCamposNovaComanda;
    { Public declarations }
  end;


  // INDICE DAS TAGS DOS ED
  // 0 : ESTADO INICIAL ANTES DO PRIMEIRO onENTER
  // 1 : ESTADO DE EDIÇÃO, ED ESTÁ EM FOCUS, FAZER AS VALIDAÇÕES
  // 2 e 3 : SETADO NO EXIT DOS ED PARA QUE ELE NÃO ENTRE SOZINHO NAS VALIDAÇÕES DAS TAG 1
  // 2 : CASO 2 CAMPO = VALIDO
  // 3 : CASO 3 CAMPO =  INVALIDO
  // ALGUNS EVENTOS DO ANDROID EXECUTAM 2 VEZES, ESSA TAG IMPEDE QUE O A PROGRAMAÇÃO RODE 2 VEZES

  // ANDROID NÃO PARA O CÓDIGO APÓS UM SHOWMESSAGE, ELE VAI DIRETO PRA PRÓXIMA LINHA
  // CASO UTILIZAR ESSE TIPO DE MENSAGEM, GARANTIR QUE SEJA NO FINAL DE UM BLOCO DE CÓDIGO
  // SEMPRE DAR UM EXIT OU UM ABORT DEPOIS SE NÃO VAI BUGAR TUDO
var
  fAberturaComanda: TfAberturaComanda;

implementation

uses
  ufuncoes, udm;
{$R *.fmx}
{$R *.XLgXhdpiTb.fmx ANDROID}

procedure TfAberturaComanda.eddtnascEnter(Sender: TObject);
begin
  if eddtnasc.Tag = 0 then
  begin
    // eddtnasc.text := '';
    eddtnasc.fontcolor := TAlphaColors.Black;
    eddtnasc.Tag := 1;
  end;
end;

procedure TfAberturaComanda.eddtnascExit(Sender: TObject);
  function CalcAnos(const Data1, Data2: TDateTime): integer;
  var
    D1, M1, A1, D2, M2, A2: Word;
  begin
    DecodeDate(Data1, A1, M1, D1);
    DecodeDate(Data2, A2, M2, D2);

    Result := A2 - A1;

    if (M1 > M2) or ((M1 = M2) and (D1 > D2)) then
      Dec(Result);
  end;

begin
  lbniver.Visible := false;
  if FormatDateTime('DD/MM', eddtnasc.DATE) = FormatDateTime('DD/MM', Now) then
    Timer1.Enabled := true
  ELSE
    Timer1.Enabled := false;

  cbmaioridade.ISChecked := CalcAnos(eddtnasc.DATE, DATE) >= 18;

end;

procedure TfAberturaComanda.edcomandaEnter(Sender: TObject);
begin
  if edcomanda.Tag = 0 then
  begin
    edcomanda.text := '';
    edcomanda.fontcolor := TAlphaColors.Black;
    edcomanda.Tag := 1;
  end;
end;

procedure TfAberturaComanda.ednomecliEnter(Sender: TObject);
begin
  if ednomecli.Tag = 0 then
  begin
    ednomecli.text := '';
    ednomecli.fontcolor := TAlphaColors.Black;
    ednomecli.Tag := 1;
  end;
end;

procedure TfAberturaComanda.edtelefoneEnter(Sender: TObject);
begin
  if edtelefone.Tag = 0 then
  begin
    edtelefone.text := dm.vparametroDDD_PADRAO;
    edtelefone.fontcolor := TAlphaColors.Black;
  end
  else
    edtelefone.text :=
      replacestr(replacestr(replacestr(replacestr(edtelefone.text, '(', ''),
      ')', ''), '-', ''), ' ', '');

  edtelefone.Tag := 1;
  edtelefone.SelStart := 4
end;

procedure TfAberturaComanda.edtelefoneExit(Sender: TObject);
begin
  // começo dando replace de novo na mascara mesmo tendo já feito isso no onEnter
  // pois se o dado é carregado via banco de dados ele vem com a máscara
  // alguns trechos do código não executam caso esteja sendo inputado pelo banco
  // OS FILTROS DE CARACTERES VALIDOS E INVALIDOS ESTÃO NA PROPRIEDADE FILTERCHAR
  // DO COMPONENTE, ALÍ VC INFORMA OS CARACTERES ACEITOS

  if dm.vRodandoBuscaCliente then
    edtelefone.text :=
      replacestr(replacestr(replacestr(replacestr(edtelefone.text, '(', ''),
      ')', ''), '-', ''), ' ', '');

  if edtelefone.Tag = 1 then
  begin
    if length(edtelefone.text) >= 10 then
    begin

      // setando a tag pra 2 pq esse negócio fica entrando nos outros evento sozinho
      edtelefone.Tag := 2;
      edtelefone.text := FormatMaskText('(00) 00000-0000;0;', edtelefone.text);

      lbvalidatelefone.Visible := true;
      lbvalidatelefone.text := '*';
      lbvalidatelefone.fontcolor := TAlphaColors.green;
      lbvalidatelefone.Font.Size := 12;

      if (not dm.vRodandoBuscaCliente) and (edtelefone.text <> '') then
        dm.BuscaCliente(edtelefone.text, 'F');

    end
    else if length(edtelefone.text) > 0 then
    begin
      if edtelefone.text = dm.vparametroDDD_PADRAO then
      begin
        edtelefone.text := '';
        edtelefone.Tag := 2;
        exit;

      end;

      edtelefone.Tag := 3;
      lbvalidatelefone.text := 'telefone Invalido';
      edtelefone.text := FormatMaskText('(00) 00000-0000;0;', edtelefone.text);

      lbvalidatelefone.Visible := true;
      lbvalidatelefone.fontcolor := TAlphaColors.red;
    end
    else if length(edtelefone.text) = 0 then
      lbvalidatelefone.Visible := false;

  end;

end;

procedure TfAberturaComanda.edtelefoneKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var
  novastring: string;
  i: integer;
begin
  if (length(edtelefone.text) > 11) and (edtelefone.Tag = 1) then
  begin
    novastring := edtelefone.text;
    for i := length(novastring) downto 12 do
    begin
      delete(novastring, length(novastring), 1);
    end;
    edtelefone.text := novastring;
  end;
end;

procedure TfAberturaComanda.edcpfEnter(Sender: TObject);
begin

  if edcpf.Tag = 0 then
  begin
    edcpf.text := '';
    edcpf.fontcolor := TAlphaColors.Black;

  end
  else
  begin
    edcpf.text := (replacestr(replacestr(replacestr(edcpf.text, '-', ''), '.',
      ''), '/', ''));

  end;
  edcpf.Tag := 1;
end;

procedure TfAberturaComanda.edcpfExit(Sender: TObject);

begin

  // começo dando replace de novo na mascara mesmo tendo já feito isso no onEnter
  // pois se o dado é carregado via banco de dados ele vem com a máscara
  // alguns trechos do código não executam caso esteja sendo inputado pelo banco
  // OS FILTROS DE CARACTERES VALIDOS E INVALIDOS ESTÃO NA PROPRIEDADE FILTERCHAR
  // DO COMPONENTE, ALÍ VC INFORMA OS CARACTERES ACEITOS
  
  if dm.vRodandoBuscaCliente then
    edcpf.text := (replacestr(replacestr(replacestr(edcpf.text, '-', ''), '.',
      ''), '/', ''));

  if edcpf.Tag = 1 then
  begin
    if length(edcpf.text) = 11 then
    begin
      // setando a tag pra 2 pq esse negócio fica entrando nos outros evento sozinho

      edcpf.text := FormatMaskText('000.000.000-00;0;', edcpf.text);

      if not(Verificacpf(replacestr(replacestr(replacestr(edcpf.text, '-', ''),
        '.', ''), '/', ''))) then
      begin
        lbValidacpf.Visible := true;
        lbValidacpf.text := 'CPF Invalido';
        lbValidacpf.fontcolor := TAlphaColors.red;
        edcpf.Tag := 3;
      end
      else
      begin
        edcpf.Tag := 2;
        lbValidacpf.text := '*';
        lbValidacpf.fontcolor := TAlphaColors.green;
        lbValidacpf.Font.Size := 12;
        lbValidacpf.Visible := true;
        if (not dm.vRodandoBuscaCliente) and (lbValidacpf.text <> '') then
          dm.BuscaCliente(edcpf.text, 'C');

      end;

    end
    else if length(edcpf.text) > 0 then
    begin
      edcpf.Tag := 3;
      lbValidacpf.text := 'CPF Invalido';
      lbValidacpf.Visible := true;
      lbValidacpf.fontcolor := TAlphaColors.red;
      edcpf.text := FormatMaskText('000.000.000-00;0;', edcpf.text);
    end

    else if length(edcpf.text) = 0 then
      lbValidacpf.Visible := false;

  end;

end;

procedure TfAberturaComanda.edrgEnter(Sender: TObject);
begin
  if edrg.Tag = 0 then
  begin
    edrg.text := '';
    edrg.fontcolor := TAlphaColors.Black;

  end
  else
  begin
    edrg.text := (replacestr(replacestr(replacestr(edrg.text, '-', ''), '.',
      ''), '/', ''));

  end;
  edrg.Tag := 1;
end;

procedure TfAberturaComanda.edrgExit(Sender: TObject);
begin
  // começo dando replace de novo na mascara mesmo tendo já feito isso no onEnter
  // pois se o dado é carregado via banco de dados ele vem com a máscara
  // OS FILTROS DE CARACTERES VALIDOS E INVALIDOS ESTÃO NA PROPRIEDADE FILTERCHAR
  // DO COMPONENTE, ALÍ VC INFORMA OS CARACTERES ACEITOS

  if (edrg.Tag = 1) and (length(edrg.text) = 9) then
  begin
    // setando a tag pra 2 pq esse negócio fica entrando nos outros evento sozinho
    edrg.Tag := 2;
    edrg.text := FormatMaskText('00.000.000-0;0;', edrg.text);

    lbvalidarg.Visible := true;
    lbvalidarg.text := '*';
    lbvalidarg.fontcolor := TAlphaColors.green;
    lbvalidarg.Font.Size := 12;
    if (not dm.vRodandoBuscaCliente) and (edrg.text <> '') then
      dm.BuscaCliente(edrg.text, 'R');
  end
  else if (edrg.Tag = 1) and (length(edrg.text) >0) then
  BEGIN
     lbvalidarg.Visible := true;
      lbvalidarg.fontcolor := TAlphaColors.red;
     lbvalidarg.text := 'RG incompleto!';

  END
  else
    lbvalidarg.Visible := False;
end;

procedure TfAberturaComanda.edrgKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var
  novastring: string;
  i: integer;
begin
  if (length(edrg.text) > 9) and (edrg.Tag = 1) then
  begin
    novastring := edrg.text;
    for i := length(novastring) downto 10 do
    begin
      delete(novastring, length(novastring), 1);
    end;
    edrg.text := novastring;
  end;

end;

procedure TfAberturaComanda.edemailEnter(Sender: TObject);
begin
  if edemail.Tag = 0 then
  begin
    edemail.text := '';
    edemail.fontcolor := TAlphaColors.Black;
    edemail.Tag := 1;
  end;
end;

procedure TfAberturaComanda.edemailExit(Sender: TObject);
begin
  if  length(edemail.text) > 0 then
  begin
    if not ValidaEMail(edemail.text) then
    begin
      lbvalidaemail.text := 'E-mail Invalido';
      lbvalidaemail.Visible := true;
      lbvalidaemail.fontcolor := TAlphaColors.red;
      edemail.Tag := 3;

    end
    else
    begin
      lbvalidaemail.Visible := true;
      lbvalidaemail.text := '*';
      lbvalidaemail.fontcolor := TAlphaColors.green;
      lbvalidaemail.Font.Size := 12;
      edemail.Tag := 2;

      if (not dm.vRodandoBuscaCliente) and (edemail.text <> '') then
        dm.BuscaCliente(edemail.text, 'E');
    end;
  end
  else
    lbvalidaemail.Visible := False;

end;

procedure TfAberturaComanda.edEntradaPadraoClick(Sender: TObject);
begin
  fAberturaComanda.Focused := nil;
  if dm.SQLConnection1.Connected then
  begin
    dm.CDS_TBPROD.CLOSE;
    dm.CDS_TBPROD.open;

    while (NOT dm.CDS_TBPROD.Eof) and (vAdcItems <> 1) do
    BEGIN

      c.AddItem(dm.CDS_TBPRODCODIGO.asstring, dm.CDS_TBPRODDESCRICAO.asstring);
      dm.CDS_TBPROD.Next;

    END;
    vAdcItems := 1;
    c.ShowMenu('edEntradaPadrao');
  end;

end;

procedure TfAberturaComanda.FDQuery1AfterOpen(DataSet: TDataSet);
begin
  // após conectar no banco local Employees.s3db tenta conectar no servidor android

  // conectaServidorAndroid;
end;

procedure TfAberturaComanda.FormCreate(Sender: TObject);
begin
  lbAvisoParaProgramadorLayoutTablet.Visible := false;
  // configuração do combobox
  c := TCustomCombo.Create(fAberturaComanda);
  c.BackgroundColor := $FFAAAAAA;
  c.ItemBackgroundColor := $FFF2F2F8;
  c.OnClick := ItemClick;

  // configuração dos scroll
  VertScrollBox1.OnCalcContentBounds := CalcContentBoundsProc;
  VertScrollBox2.OnCalcContentBounds := CalcContentBoundsProc;

  if dm.FDConnection1.Connected then // se conectado no banco local
    FDQuery1.open();

  AniIndicator1.Enabled := true;
  AniIndicator1.Visible := true;

  vControlaTabOrder := 0;

  SalvarPosicaoComponentes;
  SetaCamposNovaComanda;
  gravaArrayTedit;


  // {$ifdef Android 10" Tablet }
  // Application.FormFactor.Orientations := [TFormOrientation.InvertedLandscape];
  // showmessage('entrooooo');
  // {$endif}
  // {$ifdef Android 5" Phone }
  // Application.FormFactor.Orientations := [TFormOrientation.InvertedLandscape];
  // if Application.FormFactor.
  // showmessage('entrooooo');
  // {$endif}

end;

procedure TfAberturaComanda.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;

procedure TfAberturaComanda.FormGesture(Sender: TObject;
  const [Ref] EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  case EventInfo.GestureID of
    sgiLeft:
      begin
        if TabControl1.ActiveTab <> TabControl1.Tabs[TabControl1.TabCount - 1]
        then
          TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex + 1];
        Handled := true;
      end;

    sgiRight:
      begin
        if TabControl1.ActiveTab <> TabControl1.Tabs[0] then
          TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex - 1];
        Handled := true;
      end;
  end;

end;

procedure TfAberturaComanda.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);

begin

  if (Key = vkReturn) then
  begin
    Key := vkTab;
    KeyDown(Key, KeyChar, Shift);
  end;

end;

procedure TfAberturaComanda.FormShow(Sender: TObject);
begin
  if CKConecta.ISChecked then
    conectaServidorAndroid;
end;

procedure TfAberturaComanda.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
begin
  FKBBounds.Create(0, 0, 0, 0);
  FNeedOffset := false;
  RestorePosition;
end;

procedure TfAberturaComanda.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
begin
  FKBBounds := TRectF.Create(Bounds);
  FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
  FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
  UpdateKBBounds;
end;

procedure TfAberturaComanda.FrameSenhaBtSenhaClick(Sender: TObject);
begin
  if UpperCase(EdSenha.text) = 'ADM%BBI' then
  BEGIN
    painelSenha.Visible := false;
    TabControl1.ActiveTab := tabparam;
    Panel1.Enabled := true;
  END
  else
  begin
    painelSenha.Visible := false;
    Panel1.Enabled := true;
  end;

end;



procedure TfAberturaComanda.UpdateKBBounds;
var
  LFocused: TControl;
  LFocusRect: TRectF;
  LFocused2: TControl;
  LFocusRect2: TRectF;
begin
  FNeedOffset := false;
  if Assigned(Focused) then
  begin

    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;

    if TabControl1.ActiveTab = tabprinc then
      LFocusRect.Offset(VertScrollBox1.ViewportPosition)
    else if TabControl1.ActiveTab = tabparam then
      LFocusRect.Offset(VertScrollBox2.ViewportPosition);

    if (LFocusRect.IntersectsWith(TRectF.Create(FKBBounds))) and
      (LFocusRect.Bottom > FKBBounds.Top) then
    begin
      if TabControl1.ActiveTab = tabprinc then
      begin
        FNeedOffset := true;
        LayoutaInfos.Align := TAlignLayout.Horizontal;
        VertScrollBox1.RealignContent;
        Application.ProcessMessages;
        VertScrollBox1.ViewportPosition :=
          PointF(VertScrollBox1.ViewportPosition.X,
          LFocusRect.Bottom - FKBBounds.Top);
      end
      else if TabControl1.ActiveTab = tabparam then
      begin
        FNeedOffset := true;
        LayoutEntrada.Align := TAlignLayout.Horizontal;
        VertScrollBox2.RealignContent;
        Application.ProcessMessages;
        VertScrollBox2.ViewportPosition :=
          PointF(VertScrollBox2.ViewportPosition.X,
          LFocusRect.Bottom - FKBBounds.Top);

      end;
    end;

  end;

  if not FNeedOffset then
    RestorePosition;
end;

procedure TfAberturaComanda.Rectangle2Tap(Sender: TObject;
  const [Ref] Point: TPointF);
begin
  btAdcEntrada.OnClick(nil);
end;

procedure TfAberturaComanda.Rectangle3Tap(Sender: TObject;
  const [Ref] Point: TPointF);
begin
  SpeedButton3.OnClick(nil);
end;

procedure TfAberturaComanda.Rectangle4MouseEnter(Sender: TObject);
begin

  fAberturaComanda.Focused := nil;

  if TPlatformServices.Current.SupportsPlatformService
    (IFMXVirtualKeyboardService, IInterface(Keyboard)) then
    Keyboard.HideVirtualKeyboard;



end;

procedure TfAberturaComanda.Rectangle5Click(Sender: TObject);
begin
  SpeedButton5.OnClick(nil);
end;

procedure TfAberturaComanda.RestorePosition;
begin
  if TabControl1.ActiveTab = tabprinc then
  begin
    VertScrollBox1.ViewportPosition :=
      PointF(VertScrollBox1.ViewportPosition.X, 0);
    LayoutaInfos.Align := TAlignLayout.Client;
    VertScrollBox1.RealignContent;
  end
  else if TabControl1.ActiveTab = tabparam then
  begin
    VertScrollBox2.ViewportPosition :=
      PointF(VertScrollBox2.ViewportPosition.X, 0);
    // Layout2.Align := TAlignLayout.Client;
    VertScrollBox2.RealignContent;
  end
end;

procedure TfAberturaComanda.SetaCamposNovaComanda;
begin
  // configuração labels e eds
  if dm.SQLConnection1.Connected then
    controlaTabOrder;

  dm.vRodandoBuscaCliente := false;
  dm.vAchouNaTBcli := false;
  dm.vAchouNaTBvip := false;
  dm.vcodcli := '';
  lbValidacpf.Visible := false;
  lbvalidarg.Visible := false;
  lbvalidaemail.Visible := false;
  lbvalidatelefone.Visible := false;
  lbniver.Visible := false;
  lbmensagemcli.Visible := false;
  lbvalidacomanda.Visible := false;

  edtelefone.Tag := 0;

  if dm.SQLConnection1.Connected then
    edtelefone.text := '(' + dm.vparametroDDD_PADRAO + ')';

  edtelefone.fontcolor := TAlphaColors.Gainsboro;

  eddtnasc.Tag := 0;
  eddtnasc.DATE := Now;
  eddtnasc.fontcolor := TAlphaColors.Gainsboro;

  ednomecli.Tag := 0;
  ednomecli.text := 'Nome';
  ednomecli.fontcolor := TAlphaColors.Gainsboro;

  edcpf.Tag := 0;
  edcpf.text := 'CPF';
  edcpf.fontcolor := TAlphaColors.Gainsboro;

  edrg.Tag := 0;
  edrg.text := 'RG';
  edrg.fontcolor := TAlphaColors.Gainsboro;

  edemail.Tag := 0;
  edemail.text := 'Email';
  edemail.fontcolor := TAlphaColors.Gainsboro;

  edcomanda.text := '';

  if dm.SQLConnection1.Connected then
  begin
    Label10.text := dm.ConsultaComandasAbertas;

    dm.CDS_TBPROD.CLOSE;
    dm.CDS_TBPROD.open;
    FDQuery1.CLOSE;
    FDQuery1.open;
    if edEntradaPadrao.text <> '' then
    begin
      dm.CDS_TBPROD.Locate('CODIGO', FDQuery1.FieldByName('CodEntradaPadrao')
        .asstring, []);
      edtaxa.text := dm.CDS_TBPRODCODIGO.asstring;
      edtaxadesc.text := dm.CDS_TBPRODDESCRICAO.asstring;
      edvalor.text := FormatCurr('#,###,##0.00', dm.CDS_TBPRODPVENDAA.Asfloat);
      edconsu.text := FormatCurr('#,###,##0.00',
        dm.CDS_TBPRODVR_CREDITO.Asfloat);

    end;

  end;

end;

procedure TfAberturaComanda.btAdcEntradaClick(Sender: TObject);

begin

  dm.CDS_TBPROD.CLOSE;
  dm.CDS_TBPROD.open;

  while (NOT dm.CDS_TBPROD.Eof) and (vAdcItems <> 1) do
  BEGIN

    c.AddItem(dm.CDS_TBPRODCODIGO.asstring, dm.CDS_TBPRODDESCRICAO.asstring);
    dm.CDS_TBPROD.Next;

  END;
  vAdcItems := 1;
  c.ShowMenu('btAdcEntrada');

end;

procedure TfAberturaComanda.SpeedButton3Click(Sender: TObject);
begin
  edtaxa.text := '';
  edtaxadesc.text := '';
  edvalor.text := '';
  edconsu.text := '';
end;

procedure TfAberturaComanda.SpeedButton5Click(Sender: TObject);

  function ValidaInformacoes: Boolean;
  var
    i: integer;

  begin

    Result := true;


       // Verifica se informou o número da comanda
    if Trim(edcomanda.text) = '' then
    begin
      showmessage('Informe o número da Comanda.');
      edcomanda.SetFocus;
      Result := false;
      exit;
    end;

    ///////////////////////////////////////////////////////////////////////////////////

    // Verifica se informou um cliente
    if (ednomecli.text = '') or (ednomecli.Tag = 0) then
    begin
      showmessage('Informe o Cliente.');
      ednomecli.SetFocus;
      Result := false;
      exit;
    end;


    // verifica se o operador clicou nos campos
    // se não clicou a tag continua sendo 0
    // usuário pode deixar o capo em branco se quiser
    // se tag = 0 limpa os campos para não gravar a mascara padrão
    // O Campo do vParametroBUSCA_CLIENTE_POR  é obrigratório

    for i := 0 to length(EDcomponente) - 1 do
    BEGIN
      if (dm.vParametroBUSCA_CLIENTE_POR = EDcomponente[i].HINT) and
        ((EDcomponente[i].Tag = 0) or (EDcomponente[i].text = '')) then
      BEGIN
        EDcomponente[i].text := '';
        EDcomponente[i].SetFocus;
        LBcomponente[i].Visible := true;
        LBcomponente[i].text := 'Informar campo obrigatório';
        Result := false;
        exit;

      END
      ELSE IF EDcomponente[i].Tag = 0 THEN
        EDcomponente[i].text := '';

    END;


    if eddtnasc.Tag = 0 then
      eddtnasc.text := '';
    ///////////////////////////////////////////////////////////////////////////////////

    // verifica se algum ED está com a TAG 3, caso esteja campo = invalido

    for i := 0 to length(EDcomponente) - 1 do
    begin
      if EDcomponente[i].Tag = 3 then
      begin
        EDcomponente[i].SetFocus;
        Result := false;
        exit;
      end;
    end;


    /// ////////////////////////////////////////////////////////////////////////////////



    // Verifica se o número da comanda está bloqueado  OU ABERTA  ou tem saida pendente
    if not dm.VerificaComanda(edcomanda.text) then
    begin
      edcomanda.SetFocus;
      Result := false;
      exit;
    end;

    /// ///////////////////////////////////////////////////////////////////////////////

    // VERIFICA ITEM OBRIGRATÓRIO
    if dm.VParametroUTILIZA_ITEM_OBRIGATORIO = 'S' then
    BEGIN
      if edtaxa.text = '' then
      begin
        showmessage('Atenção! Informe a entrada.');
        Result := false;
        exit;

      end;
    END;

    // cliente é validado primeiro quando puxa todos os dados na func busca_cliente
    // usuário pode alterar as informações antes de confirmar por isso valida de novo
    if dm.vcodcli <> '' then
      if not dm.valida_cliente then
      begin
        Result := false;
        exit
      end;

    /// ////////////////////////////////////////////////////////////////////////////////
    // VERIFICA A DUPLCIDADE DAS INFORMAÇÕES NO CADASTRO CASO A INFORMAÇÃO N SEJA O PARAMETRO PRINCIPAL DE BUSCA
    if not VerificaDuplicidadeInfos then
    begin
      Result := false;
      exit;
    end;
  end;

// fim função
/// /////////////////////////////////////////////////////////////////////////////
begin

  fAberturaComanda.Focused := nil; // nenhum campo focado
  if ValidaInformacoes then
  begin

    if dm.vcodcli = '' then // se não achou codcli grava cli no banco
      dm.gravaCliente;

    dm.gravacomanda;
    dm.gravaitens;
    SetaCamposNovaComanda;

    showmessage('Comanda Cofirmada com Sucesso!');
  end
  else
  begin
    showmessage('Comanda não confirmada. ' + chr(13) +
      'Favor verificar as informações');


    exit;

  end;


end;

procedure TfAberturaComanda.tabparamClick(Sender: TObject);
begin
  painelSenha.Visible := true;
  TabControl1.ActiveTab := tabprinc;
  Panel1.Enabled := false;
end;

procedure TfAberturaComanda.Timer1Timer(Sender: TObject);
begin
  if lbniver.Visible then
    lbniver.Visible := false
  else
    lbniver.Visible := true;
end;


procedure TfAberturaComanda.Button1Click(Sender: TObject);

begin

  if FDQuery1.State = dsinsert then
    FDQuery1.post
  else
  begin

    // if pra não deixar salvar o  vCodTaxaPadrao em branco
    if vCodTaxaPadrao = '' then
      vCodTaxaPadrao := FDQuery1.FieldByName('CodEntradaPadrao').asstring;

    dm.FDConnection1.ExecSQL('update tbconfiguracoes set ipServidorAndroid = ' +
      quotedstr(edIpServidor.text) + ', portaServidorAndroid = ' +
      quotedstr(edPortaServidor.text) + ', DescEntradaPadrao = ' +
      quotedstr(edEntradaPadrao.text) + ', CodEntradaPadrao =  ' +
      quotedstr(vCodTaxaPadrao) + ', NumeroTablet = ' +
      ifthen(edNumTablet.text = '', 'null', edNumTablet.text) +
      ', ConectaAutomatico = ' + booltostr(CKConecta.ISChecked));
  end;

  SetaCamposNovaComanda;

end;

procedure TfAberturaComanda.Button2Click(Sender: TObject);
begin

  dm.SQLConnection1.CLOSE;
  FDQuery1.CLOSE();
  FDQuery1.open();

  if FDQuery1.Active then
    conectaServidorAndroid;

  if dm.SQLConnection1.Connected then
  begin
    showmessage('CONECTADO AO SERVIDOR COM SUCESSO!');

  end

end;



procedure TfAberturaComanda.Button4MouseEnter(Sender: TObject);
begin
edsenha.Password :=false;
end;

procedure TfAberturaComanda.Button4MouseLeave(Sender: TObject);
begin
edsenha.Password :=true;
end;

procedure TfAberturaComanda.CalcContentBoundsProc(Sender: TObject;
  var ContentBounds: TRectF);
begin
  if FNeedOffset and (FKBBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom,
      2 * ClientHeight - FKBBounds.Top);
  end;
end;

procedure TfAberturaComanda.HideVirtualKeyboard;
{$IFDEF Android}
var

  TextView: JFMXTextEditorProxy;
{$ENDIF}
begin
{$IFDEF IOS}
  try
    Screen.ActiveForm.Focused := nil;
  except
  end;
{$ENDIF}
{$IFDEF Android}
  try
    begin
      TextView := MainActivity.getTextEditorProxy;
      CallInUIThread(
        procedure
        begin
          TextView.setFocusable(false);
          TextView.setFocusableInTouchMode(false);
          TextView.showSoftInput(false);
          TextView.clearFocus;
          TextView.setFocusable(true);
          TextView.setFocusableInTouchMode(true);
        end);
    end
  except
  end;
{$ENDIF}
end;

procedure TfAberturaComanda.CallForKeyboard(open: Boolean; input: TFmxObject);
begin
  if open then
  begin
    Keyboard.ShowVirtualKeyboard(input);
  end
  else
  begin
    if TVirtualKeyBoardState.Visible in Keyboard.GetVirtualKeyBoardState then
      Keyboard.HideVirtualKeyboard;
  end;
end;

procedure TfAberturaComanda.edcpfKeyUp(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
var
  novastring: string;
  i: integer;
begin
  if (length(edcpf.text) > 11) and (edcpf.Tag = 1) then
  begin
    novastring := edcpf.text;
    for i := length(novastring) downto 12 do
    begin
      delete(novastring, length(novastring), 1);
    end;
    edcpf.text := novastring;
  end;

end;

{$IFDEF win32 or win64}

procedure TfAberturaComanda.ItemClick(Sender: TObject);
begin
  c.HideMenu;

  dm.CDS_TBPROD.Locate('CODIGO', c.codItem, []);

  if c.Origem = 'btAdcEntrada' then
  begin
    edtaxa.text := dm.CDS_TBPRODCODIGO.asstring;
    edtaxadesc.text := dm.CDS_TBPRODDESCRICAO.asstring;
    edvalor.text := FormatCurr('#,###,##0.00', dm.CDS_TBPRODPVENDAA.Asfloat);
    edconsu.text := FormatCurr('#,###,##0.00', dm.CDS_TBPRODVR_CREDITO.Asfloat);
  end
  else if c.Origem = 'edEntradaPadrao' then
  begin
    edEntradaPadrao.text := dm.CDS_TBPRODDESCRICAO.asstring;
    vCodTaxaPadrao := dm.CDS_TBPRODCODIGO.asstring;
  end;
end;
{$ELSE}

// ESSA FUNÇÃO PRECISA REPETIR DUAS VEZES MESMO 1 PRA ANDROID 1 PRA WINDERSON
procedure TfAberturaComanda.ItemClick(Sender: TObject; const Point: TPointF);
begin
  c.HideMenu;

  dm.CDS_TBPROD.Locate('CODIGO', c.codItem, []);

  if c.Origem = 'btAdcEntrada' then
  begin
    edtaxa.text := dm.CDS_TBPRODCODIGO.asstring;
    edtaxadesc.text := dm.CDS_TBPRODDESCRICAO.asstring;
    edvalor.text := FormatCurr('#,###,##0.00', dm.CDS_TBPRODPVENDAA.Asfloat);
    edconsu.text := FormatCurr('#,###,##0.00', dm.CDS_TBPRODVR_CREDITO.Asfloat);
  end
  else if c.Origem = 'edEntradaPadrao' then
  begin
    edEntradaPadrao.text := dm.CDS_TBPRODDESCRICAO.asstring;
    vCodTaxaPadrao := dm.CDS_TBPRODCODIGO.asstring;
  end;

end;

{$ENDIF}

Procedure TfAberturaComanda.conectaServidorAndroid;
begin
  // pega os parametros ip e a porta salvos no banco interno
  // e passa pro componente de conexão com o servidor

  dm.SQLConnection1.Params.Values['HostName'] :=
    FDQuery1.FieldByName('ipServidorAndroid').asstring;
  dm.SQLConnection1.Params.Values['Port'] :=
    FDQuery1.FieldByName('PortaServidorAndroid').asstring;
  try
    dm.SQLConnection1.open;
  except
    On E: Exception do
    begin
      showmessage(E.Message + chr(13) + 'Entre em contato com a Bitbye');
      exit;
    end;
  end;

  if dm.SQLConnection1.Connected then
  begin
    recCon.Fill.Color := TAlphaColors.green;
    AniIndicator1.Enabled := false;
    AniIndicator1.Visible := false
  end
  else
    recCon.Fill.Color := TAlphaColors.red;

end;

procedure TfAberturaComanda.controlaTabOrder;
begin
  // Função controla a ordem dos TabOrder
  // o campo do parametro vParametroBUSCA_CLIENTE_POR deve ser sempre o tabOrder = 1
  // taborder = 0 : edcomanda
  // por padrão deixei no componente o CPF como tabOrder = 1   então n precisa mexer nele
  // ednome.taborder sempre será 2

  // 13/10/2022
  // Função alterada para também controlar a posição dos componentes na tela
  if vControlaTabOrder = 0 then
  begin
    if dm.vParametroBUSCA_CLIENTE_POR = 'F' then
    begin
      LayoutTelefone.TabOrder := 1;
      LayoutCpf.TabOrder := 3;

      LayoutCpf.Position.X := XFone;
      LayoutCpf.Position.y := YFone;

      LayoutTelefone.Position.X := XCpf;
      LayoutTelefone.Position.y := YCpf;

    end
    else if dm.vParametroBUSCA_CLIENTE_POR = 'R' then
    begin

      LayoutRG.TabOrder := 1;
      LayoutCpf.TabOrder := 6;

      LayoutCpf.Position.X := XRg;
      LayoutCpf.Position.y := YRg;

      LayoutRG.Position.X := XCpf;
      LayoutRG.Position.y := YCpf;

    end
    else if dm.vParametroBUSCA_CLIENTE_POR = 'E' then
    begin
      // como email é um campo grande tem que mexer em todos os outros campos

      LayoutEmail.TabOrder := 1;
      LayoutCpf.TabOrder := 5;

      LayoutCpf.Position.X := XFone;
      LayoutCpf.Position.y := YFone;

      LayoutRG.Position.X := XDtNasc;
      LayoutRG.Position.y := YDtNasc;

      LayoutEmail.Position.X := XCpf;
      LayoutEmail.Position.y := YCpf;

      LayoutTelefone.Position.X := XEmail;
      LayoutTelefone.Position.y := YEmail;

      LayoutDtNasc.Position.y := YEmail;

    end;

  end;
  vControlaTabOrder := 1;
end;



procedure TfAberturaComanda.SalvarPosicaoComponentes;
begin
  // essa proc não é realmente nescessária mas achei intessante a ideia de salvar as
  // posições dos layouts, pode servir pra mais coisas no futuro

  XCpf := LayoutCpf.Position.X;
  YCpf := LayoutCpf.Position.y;

  XRg := LayoutRG.Position.X;
  YRg := LayoutRG.Position.y;

  XFone := LayoutTelefone.Position.X;
  YFone := LayoutTelefone.Position.y;

  XNome := LayoutNome.Position.X;
  YNome := LayoutNome.Position.y;

  XEmail := LayoutEmail.Position.X;
  YEmail := LayoutEmail.Position.y;

  XDtNasc := LayoutDtNasc.Position.X;
  YDtNasc := LayoutDtNasc.Position.y;

end;

////////////////////////////////////////////////////
procedure TfAberturaComanda.gravaArrayTedit();
var
  i: integer;
const
  aux: array [0 .. 3] of string = ('edtelefone', 'edcpf', 'edrg', 'edemail');
  aux2: array [0 .. 3] of string = ('lbvalidatelefone', 'lbvalidacpf',
    'lbvalidarg', 'lbvalidaemail');
begin
  // salva os campos de validação nesses array que recebem o componente
  // facilitando assim a validação dos campos
  // eu uso a propriedade style name e hint como um campo de suporte
  // style name = guarda o nome do campo na TBCLI
  // hint = guarda o parametro de busca correspondente
  for i := 0 to length(aux) - 1 do
  begin
    EDcomponente[i] := TEdit(FindComponent(aux[i]));
    LBcomponente[i] := TLabel(FindComponent(aux2[i]));
  end;

end;

/// ////////////////////////////////////////////////////////////
function TfAberturaComanda.VerificaDuplicidadeInfos: Boolean;
var
  i: integer;
  nomeCampo: string;
begin
  Result := true;
  // eu uso a propriedade style name e hint de maneira errada aqui
  // uso como um campo de suporte, style name = guarda o nome do campo na TBCLI
  // hint = guarda o parametro de busca correspondente

  for i := 0 to length(EDcomponente) - 1 do
  begin

    if (dm.vParametroBUSCA_CLIENTE_POR <> EDcomponente[i].HINT) and
      (dm.validaCampo(EDcomponente[i].text, EDcomponente[i].stylename) <> '')
      and (dm.vAchouNaTBcli = false) and (dm.vAchouNaTBvip = false) AND
      (EDcomponente[i].text <> '') and (EDcomponente[i].Tag <> 0) then
    begin
      LBcomponente[i].Visible := true;
      LBcomponente[i].fontcolor := TAlphaColors.red;

      if EDcomponente[i].stylename = 'cgc' then
        nomeCampo := 'CPF'
      else if EDcomponente[i].stylename = 'insc' then
        nomeCampo := 'RG'
      else if EDcomponente[i].stylename = 'fone' then
        nomeCampo := 'Telefone';

      LBcomponente[i].text := nomeCampo + ' já cadastrado para outro cliente!';
      EDcomponente[i].SetFocus;
      Result := false;
      exit;
    end;

  end;

end;

end.
