unit Form_DialogoPadrao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ContNrs, ImgList, 
  F_Funcao, System.ImageList;

type
  TFrm_DialogoPadrao = class(TForm)
    PnlPrincipal: TPanel;
    LabelTexto: TLabel;
    PanelBotoes: TPanel;
    PanelGlyph: TPanel;
    ImageIco: TImage;
    ImageListIconKind: TImageList;
    TimerMsg: TTimer;
    procedure TimerMsgTimer(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }

    FBigSize: Boolean;
    FBotoes: TObjectList;
    FBotaoPress: Integer;
    FTipoSom: TTipoSom;

    procedure  AtualizaTamanho (ABigSize: Boolean);           // Atualiza tamanhos
    procedure  AtualizaTexto   (ATexto: string);              // Atualiza o texto do label dinamicamente
    procedure  AtualizaBotoes  (ACaptions: array of string);  // Método que cria os botoes dinamicamente
//    procedure  EMForcaHint     (var Message: TUMForcaHint); message UM_FORCAHINT; // Responde mesagem de atualizacao do hint
  protected
    procedure  BotaoClick      (Sender: TObject); virtual;    // Evento padrao de resposta do click dos botoes
    procedure  AtualizaDialogo (ATitulo: string; ATexto: string; ACaptionBotoes: array of string; AIconKind: TIconKind = ikAutomatic; ABigSize: Boolean = False); virtual; // Metodo de atualizacao da caixa de dialogo
    procedure AtualizaIcon(AIconKind: TIconKind);
  public
    { Public declarations }
    property BigSize: Boolean read FBigSize write FBigSize; // Tamanho de Tela grande
    property BotaoPress: Integer read FBotaoPress;  // Devolve o indice do botao pressiondado
    property TipoSom: TTipoSom read FTipoSom write FTipoSom; // Tipo de som a ser emitido na ativação
  end;

implementation

//uses F_Funcao;

{$R *.DFM}

procedure TFrm_DialogoPadrao.FormCreate(Sender: TObject);
begin
  FBotoes  := TObjectList.Create(True); // Lista de botoes do formulário
  FTipoSom := tsNormal;                 // Som default a ser emitido
  PanelBotoes.ControlStyle  := PanelBotoes.ControlStyle - [csParentBackground]; //egsn
end;

procedure TFrm_DialogoPadrao.FormDestroy(Sender: TObject);
begin
  // Libera objetos criados
  FBotoes.Free;
end;

procedure TFrm_DialogoPadrao.FormShow(Sender: TObject);
begin
  // Valores default
  KeyPreview  := ExistKeyPress;
  FBotaoPress := -1;
end;

procedure TFrm_DialogoPadrao.TimerMsgTimer(Sender: TObject);
begin
  Tone(2000,15);
end;

procedure TFrm_DialogoPadrao.FormActivate(Sender: TObject);
begin
  // Na ativação do form, emite som
  case FTipoSom of
    tsNenhum:;                     // Se som
    tsNormal:  Tone(800,75 );      // Normal
    tsAtencao: Tone(1450,150);     // Aviso de Atencao
    tsErro:    begin               // Aviso de Erro
                 Tone(800,50);
                 Tone(1450,150);
                 Tone(1750,150);
               end;
    tsBigErro: begin               // Aviso de Erro GRANDE
                 Tone(360,100);
                 Tone(1000,150);
                 Tone(1440,250);
                 Tone(1000,150);
                 Tone(360,100);
               end;
  end;
end;

procedure TFrm_DialogoPadrao.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Evita eventos de teclado
  Key := 0;
  KeyPreview := False;
end;

procedure TFrm_DialogoPadrao.AtualizaBotoes(ACaptions: array of string);
const
  CEspacosEntreBotoes = 2;
  CPixelsEntreBotoes  = 10;
  CLarguraBotao       = 95;
var
  QtdBotoes:            Integer;
  MaxLarguraBotao:      Integer;
  LarguraBotao:         Integer;
  LarguraForm:          Integer;
  PixelsEntreBotoes:    Integer;
  I:                    Integer;
  BotaoLeft:            Integer;
  AuxAltura:            Integer;
  AuxBotao:             TButton;//Color;
begin
  QtdBotoes       := High(ACaptions) + 1;  // Quantidade de botoes a serem criados
  MaxLarguraBotao := 1;                    // Maior largura dos botoes

  // Varre os botoes a serem criados (Calculo da maior largura do botao)
  for I := 0 to QtdBotoes-1 do
  begin
    // Calcula a largura que o botao deve ter em pixels
    PixelsText('    '+ACaptions[I]+'    ',PanelBotoes.Font,LarguraBotao,AuxAltura);  //egsn
    // Se a largura do botoa for maior que a maior largura de botao
    if LarguraBotao > MaxLarguraBotao then
      // Guarda a maior largura como sendo a largura do botao calculada
      MaxLarguraBotao := LarguraBotao;
  end;

  // Se a maior largura for menor que a largura padrão do botão
  if MaxLarguraBotao < CLarguraBotao then
   // Guarda a maior largura como sendo a largura padrão
   MaxLarguraBotao := CLarguraBotao;

  // Recalcula a largura do form
  LarguraForm := (QtdBotoes * MaxLarguraBotao) +
                 ((QtdBotoes - 1 + CEspacosEntreBotoes) * CPixelsEntreBotoes);

  // Se a largura do form, for maior que a largura atual do form
  if LarguraForm > Self.ClientWidth then
  begin
    // Redimensiona o formulario
    AutoSize := False;
    try
      ClientWidth := LarguraForm;
    finally
      AutoSize := True;
      Refresh;
    end;

    // Numero de Pixels entre os botoes sera a padrão
    PixelsEntreBotoes := CPixelsEntreBotoes;
  end
  else
    // Calcula o Numero de Pixels entre os botoes
    PixelsEntreBotoes := Trunc((Self.ClientWidth - (QtdBotoes*MaxLarguraBotao)) /
                               (QtdBotoes - 1 + CEspacosEntreBotoes));

  // Cria os botoes
  FBotoes.Clear;
  for I := 0 to (QtdBotoes - 1) do
  begin
    AuxBotao := TButton.Create(nil);
    FBotoes.Add(AuxBotao);
    with AuxBotao do
    begin
      Parent              := PanelBotoes;
//      BevelSizeIn         := 3;
//      BevelSizeOut        := 2;
//      BevelStyleIn        := bbRaised;
//      BevelStyleOut       := bbRaised;
//      ColorOnFocus        := clBtnFace;
//      ColorOnNoFocus      := clBtnFace;
//      GradColorOnFocus    := False;
//      GradColorOnNoFocus  := False;
//      FontOnFocus.Assign  (PanelBotoes.Font);
//      FontOnFocus.Color   := clBlack;
//      FontOnNoFocus.Assign(PanelBotoes.Font);
      Caption             := ACaptions[I];
      TabOrder            := I;
      OnClick             := BotaoClick;
      BotaoLeft           := PixelsEntreBotoes +
                             (I*MaxLarguraBotao) + (I*PixelsEntreBotoes);
      if AuxAltura = 0 then AuxAltura := 13;
      SetBounds(BotaoLeft ,2,MaxLarguraBotao,AuxAltura*2);
    end;
  end;
end;

//procedure TEstalo_Frm_DialogoPadrao.EMForcaHint(var Message: TUMForcaHint);
//begin
//  // Responde a mensagem EM_FORCAHINT e Chama a Exibicao do Hint
//  DisplayHint(Message.Sender,1500);
//end;

procedure TFrm_DialogoPadrao.AtualizaTamanho(ABigSize: Boolean);
const
  FontSize: array [False..True] of Byte   = (8,20);
  FColor:   array [False..True] of TColor = (clBtnFace,clYellow);
begin
  // Tamanho da Fonte da Mensagem
  LabelTexto.Font.Size  := FontSize[ABigSize];
  PanelBotoes.Font.Size := FontSize[ABigSize];
  Self.Color            := FColor[ABigSize];  
end;

procedure TFrm_DialogoPadrao.AtualizaTexto(ATexto: string);
var
//  MaxTamanhoLinha:      Integer;
  MaxTamanhoLinhaTexto: Integer;
  TamanhoLinha:         Integer;
  Linha:                string;
  I:                    Integer;
  AuxHeight:            Integer;
  QtdeLinhas:           Integer; //egsn
begin
//  MaxTamanhoLinha      := Constraints.MaxWidth - PanelGlyph.Width - 10; // Largura maxima da linha
  MaxTamanhoLinhaTexto := 1;                                            // Maior tamanho de linha

  // Texto a ser colocado no label, terá uma linha em branco antes e outra após
  ATexto := ';'+ATexto+';';

  // Transforma os ponto e virgula em quebra de linha
  ATexto := StringTran(ATexto,';',#13);

  // Varre o texto caracter a caracter a procura de quebra de linhas
  Linha := '';
  QtdeLinhas := 0;
  for I := 1 to Length(ATexto) do
  begin
    // Se qubrou linha ou o texto acabou
    if (ATexto[I] = #13) or (I = Length(ATexto)) then
    begin
      // Se a linha nao esta vazia
      if Linha <> '' then
      begin
        // Calcula o tamanho da linha em pixels
        PixelsText(Linha,LabelTexto.Font,TamanhoLinha,AuxHeight,Self);
        // espaço extra
        TamanhoLinha := TamanhoLinha + 10; //egsn
        // Se a largura da linha for maior que a maior largura de linha
        if TamanhoLinha > MaxTamanhoLinhaTexto then
         // Guarda a maior largura como sendo a largura da linha calculada
          MaxTamanhoLinhaTexto := TamanhoLinha;
      end;

      // Limpa a linha
      Linha := '';
      // atualiza a quantidade de linhas //egsn
      QtdeLinhas := QtdeLinhas + 1; //egsn
      // Proximo carater do texto
      Continue;
    end;
    // Monta a linha
    Linha := Linha + ATexto[I]
  end;

  // Se o maior tamanho de linha do texto for maior que o maior tamnaho de linha permitido
//  if MaxTamanhoLinhaTexto > MaxTamanhoLinha then
    // Coloca o maior tamanho de linha do texto como o maximo permitido
//    MaxTamanhoLinhaTexto := MaxTamanhoLinha;


  // Redimensiona o formulario de acordo com o maior tamanho de linha
  AutoSize := False;
  try
    ClientWidth    := MaxTamanhoLinhaTexto + 50;
    PnlPrincipal.Height := ((QtdeLinhas * AuxHeight) + 30) + PanelBotoes.Height;//egsn
  finally
    AutoSize := True;
    Refresh;
  end;

  // Mostra o texto no label
  LabelTexto.Caption := ATexto;
end;

procedure TFrm_DialogoPadrao.AtualizaDialogo(ATitulo: string; ATexto: string; ACaptionBotoes: array of string; AIconKind: TIconKind = ikAutomatic; ABigSize: Boolean = False);
begin
  // Atualçiza a caixa de dialogo
  Caption := ATitulo;
  AtualizaTamanho(ABigSize);
  AtualizaTexto(ATexto);
  AtualizaBotoes(ACaptionBotoes);
  AtualizaIcon(AIconKind);//egsn
  TimerMsg.Enabled := ABigSize;
end;

procedure TFrm_DialogoPadrao.AtualizaIcon(AIconKind: TIconKind); //egsn
var im: TIcon;
    imageIndex: byte;
begin
  // se é automático, tenta adivinhar o icone
  if AIconKind = ikAutomatic then
  begin
    // caso a mensagem possua '?'
    if pos('?', LabelTexto.Caption) > 0 then
      // deve ser uma pergunta
      imageIndex := ord(ikQuestion)
    // caso a mensagem possua '!'
    else if pos('!', LabelTexto.Caption) > 0 then
      // deve ser uma alerta
      imageIndex := ord(ikWarn)
    else
      // caso contrário, deixa o icone de informação...
      imageIndex := ord(ikInfo);
  end else
    // se foi passado o tipo diferente de automático, pega a imagem correta
    imageIndex := ord(AIconKind);

  // cria o icon
  im := TIcon.Create;
  // obtem a partir do imageList
  ImageListIconKind.GetIcon(imageIndex, im, dsTransparent, itImage);
  // seta no TPicture
  ImageIco.Picture.Assign(im);
  // seta como transparente
  ImageIco.Transparent := True;
end;

procedure TFrm_DialogoPadrao.BotaoClick(Sender: TObject);
begin
  // Guarda o indice do botao pressionado
  FBotaoPress       := TButton(Sender).TabOrder; //Color
  TimerMsg.Enabled  := False;

  // VerifyClose o formulario
  Close;
end;

end.
