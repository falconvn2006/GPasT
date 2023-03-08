unit UPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, CheckLst, Mask, Registry, ComCtrls,
  IBServices, DateUtils, RXShell, Menus, jpeg, ExtDlgs,
  rxAppEvent, rxToolEdit;

type
  THorario = packed record
    Hora: TTime;
    Feito: Boolean;
    Agendado: Boolean;
  end;

  TFPrincipal = class(TForm)
    Panel2: TPanel;
    sbSair: TSpeedButton;
    Timer: TTimer;
    Backup: TIBBackupService;
    PopupMenu: TPopupMenu;
    BackupMenuItem: TMenuItem;
    InicializaBackup1: TMenuItem;
    Exit1: TMenuItem;
    N3: TMenuItem;
    Sobre1: TMenuItem;
    RxTrayIcon1: TRxTrayIcon;
    AppEvents: TAppEvents;
    TimerDelecao: TTimer;
    sbIniciar: TSpeedButton;
    sbDeletar: TSpeedButton;
    OpenPictureDialog1: TOpenPictureDialog;
    PopupMenu1: TPopupMenu;
    Excluir1: TMenuItem;
    PageControl1: TPageControl;
    tsPrincipal: TTabSheet;
    Panel3: TPanel;
    reStatus: TRichEdit;
    Panel4: TPanel;
    Memo1: TMemo;
    Panel5: TPanel;
    tsConfigura: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    sbBuscaBase: TSpeedButton;
    Image1: TImage;
    Label8: TLabel;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    Panel7: TPanel;
    PanelDias: TPanel;
    Panel8: TPanel;
    Button1: TButton;
    Button2: TButton;
    clbSemana: TCheckListBox;
    Panel9: TPanel;
    clbHorarios: TCheckListBox;
    Panel10: TPanel;
    Button3: TButton;
    Button4: TButton;
    eDirBackup: TDirectoryEdit;
    Panel6: TPanel;
    sbOk: TSpeedButton;
    sbCancelar: TSpeedButton;
    CheckBox1: TCheckBox;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    cbDias: TComboBox;
    EditUltima: TMaskEdit;
    CheckInforma: TCheckBox;
    cbInferior: TComboBox;
    eBase: TListBox;
    tsRestaura: TTabSheet;
    Button5: TButton;
    ListBox1: TListBox;
    procedure sbBuscaBaseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbCancelarClick(Sender: TObject);
    procedure sbOkClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure sbSairClick(Sender: TObject);
    procedure AppEventsMinimize(Sender: TObject);
    procedure AppEventsRestore(Sender: TObject);
    procedure AppEventsActivate(Sender: TObject);
    procedure BackupMenuItemClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Sobre1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure RxTrayIcon1DblClick(Sender: TObject);
    procedure TimerDelecaoTimer(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure sbIniciarClick(Sender: TObject);
    procedure sbDeletarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Excluir1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    // Parte do monitor *************************************
    PodeMinimizar: boolean;
    Horarios: array[0..23] of THorario;
    function DoBackup: Boolean;
    procedure AddStatusLine(S: string; Cor: TColor = clWindowText; Tamanho: byte = 10);
    // ******************************************************
    procedure Salva_Configuracao(PathExecutavel, Variavel, Valor: String);
    function Retorna_Configuracao(PathExecutavel, Variavel: String): String;
    procedure Cria_VariaveisBackup;
    function Ordenacampos(APosicao: Integer; ASeparador,ALinha: String): String;
    procedure RetornaItems;
    procedure ExecutaBackup;
    function StrToBoolean(Sender: String):Boolean;
    function BooleanToStr(Sender: Boolean):String;
    function Piece(Origem: String; Separa: String; Posic: Integer): String;
    procedure DirList( ASource : string; ADirList : TStringList );
    procedure ApagaPasta(pasta: string);
  public

  end;

var
  FPrincipal: TFPrincipal;
  PathBase, PathExecutavel: String; // Pasta onde esta o gdb/fdb
  Itens: Integer;

const
  Dia: array[1..7] of string = ('Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado');

implementation

uses uSobre;

{$R *.dfm}

procedure TFPrincipal.ApagaPasta(pasta: string);
var
Arquivo: TSearchRec;
begin
if FindFirst(pasta+'*.*', 0, Arquivo) = 0 then
begin
repeat
DeleteFile(pasta+Arquivo.Name);
until FindNext(Arquivo) <> 0;
FindClose(Arquivo);
end;
if (RemoveDir(pasta) = TRUE) then
showmessage('Pasta apagada com sucesso!')
else
showmessage('Falha ao apagar a pasta');
end;


// Parte do monitor *************************************

function TFPrincipal.StrToBoolean(Sender: String):Boolean;
begin
   if (Sender = 'True') or (Sender = 'Verdadeiro') then
      Result := True
   else
      Result := False;
end;

function TFPrincipal.BooleanToStr(Sender: Boolean):String;
begin
   if Sender then
      Result := 'True'
   else
      Result := 'False';
end;


function TFPrincipal.Piece(Origem: String; Separa: String; Posic: Integer): String;
var
   pi,pf,i,l,quantos : Word;
begin
   l := length(Origem);
   quantos := 0;
   pi := 1;
   pf := l;
   try
      for i := 1 to l do begin
         if Origem[i] = Separa then begin
            quantos := quantos + 1;
            if quantos <= (posic-1) then pi := i+1;
            if quantos = posic then begin
               if (i = l) then pf := i else begin
                  pf := i-1;
                  exit;
               end;
            end;
         end;
      end;
   finally
      if (Posic > (quantos + 1)) or (Copy(Origem,pi,pf-pi+1) = Separa) then result := ''
      else Result := Copy(Origem,pi,pf-pi+1);
   end;
end;

// Pega dados do campo ordem que está no USUARIO_ACESSO para determinar a ordem
// nos relatórios...
function TFPrincipal.Ordenacampos(APosicao: Integer; ASeparador,ALinha: String): String;
var
  sAux: TStringList;
begin
  Result:='';
  sAux:=TStringList.Create;
  sAux.Text:=StringReplace(ALinha,ASeparador,#13#10,[rfReplaceAll, rfIgnoreCase]);
  if APosicao <= sAux.Count then
    Result:=sAux.Strings[APosicao-1];
  sAux.Free;
end;

procedure TFPrincipal.RetornaItems;
var
   X: Integer;
   Bases: String;
begin
   for X := 1 to 999 do begin
      if Trim(Ordenacampos(X,';',Retorna_Configuracao(PathBase,'Dias'))) = '' then begin
         break;
         exit;
      end;

      clbSemana.Checked[StrToInt(Trim(Ordenacampos(X,';',Retorna_Configuracao(PathBase,'Dias'))))] := True;
   end;

   for X := 1 to 999 do begin
      if Trim(Ordenacampos(X,';',Retorna_Configuracao(PathBase,'Horarios'))) = '' then begin
         break;
         exit;
      end;

      clbHorarios.Checked[StrToInt(Trim(Ordenacampos(X,';',Retorna_Configuracao(PathBase,'Horarios'))))] := True;
   end;

   eDirBackup.Text := Retorna_Configuracao(PathBase,'Destino');
   CheckBox1.Checked := StrToBoolean(Retorna_Configuracao(PathBase,'Iniciar'));
   EditUltima.Text := Retorna_Configuracao(PathBase,'UltimaData');
   CheckInforma.Checked := StrToBoolean(Retorna_Configuracao(PathBase,'Informar'));

   Timer.Enabled := True;

end;

procedure TFPrincipal.Cria_VariaveisBackup;
var
   Lista_Variaveis: TStringList;
begin
   PathBase := ExtractFilePath(Application.ExeName);
   Lista_Variaveis := TStringList.Create;

   Lista_Variaveis.Clear;
   Lista_Variaveis.Add('Base');
   Lista_Variaveis.Add('Destino');
   Lista_Variaveis.Add('Dias');
   Lista_Variaveis.Add('Horarios');
   Lista_Variaveis.Add('Iniciar');
   Lista_Variaveis.Add('DiasDelete');
   Lista_Variaveis.Add('UltimaData');
   Lista_Variaveis.Add('Informar');
   Lista_Variaveis.Add('Inferior');

   Lista_Variaveis.SaveToFile(PathBase+'fbbackup.cfg');
   Lista_Variaveis.Free;

end;


procedure TFPrincipal.Salva_Configuracao(PathExecutavel, Variavel, Valor: String);
var
   Lista_Variaveis: TStringList;
   X: Integer;
   Found: Boolean;
begin
   Lista_Variaveis := TStringList.Create;

   Lista_Variaveis.LoadFromFile(PathExecutavel+'fbbackup.cfg');

   Found := False;

   for X := 0 to Lista_Variaveis.Count - 1 do begin
      if Piece(Lista_Variaveis.Strings[X], '#', 1) = Variavel then begin
         if Trim(Valor) = '' then
            Lista_Variaveis[X] := Variavel
         else
            Lista_Variaveis[X] := Variavel + '#' + Valor;
         Found := True;
         Break;
      end;
   end;

   Lista_Variaveis.SaveToFile(PathExecutavel+'fbbackup.cfg');

   Lista_Variaveis.Free;


end;

function TFPrincipal.Retorna_Configuracao(PathExecutavel, Variavel: String): String;
var
   Lista_Variaveis: TStringList;
   X: Integer;
begin
   Result := '';

   Lista_Variaveis := TStringList.Create;

   Lista_Variaveis.LoadFromFile(PathExecutavel+'fbbackup.cfg');

   for X := 0 to Lista_Variaveis.Count - 1 do begin
      if Piece(Lista_Variaveis.Strings[X], '#', 1) = Variavel then begin
         Result := Piece(Lista_Variaveis.Strings[X], '#', 2);
         Break;
      end;
   end;

   Lista_Variaveis.Free;

end;

function TFPrincipal.DoBackup: Boolean;
var
  reg: TRegistry;
  Dir: String;
begin
   Result := true;

   try

    Dir := Retorna_Configuracao(PathBase,'Destino') + '\' + FormatDateTime('dd-mm-yy', now);
    if not DirectoryExists(Dir) then begin
       ForceDirectories(Dir);
    end;

    ForceDirectories(Dir);
    Backup.DatabaseName := Retorna_Configuracao(PathBase,'Base');
    Backup.BackupFile.Clear;
    Memo1.Lines.Clear;
//    Backup.BackupFile.Add(ChangeFileExt(Retorna_Configuracao(PathBase,'Destino') + '\' + FormatDateTime('ddmmyynnhh', now), '.fbk'));
    Backup.BackupFile.Add(ChangeFileExt(Dir + '\' + FormatDateTime('ddmmyynnhh', now), '.fbk'));
    Backup.Active := true;
    AddStatusLine(Format('Backup Iniciado às %s horas', [FormatDateTime('hh:nn:ss', now)]), clGreen);
    Backup.ServiceStart;
    while not Backup.Eof do
      Memo1.Lines.Add(BackUp.GetNextLine);
      Backup.Active := false;
   except
    ShowMessage('O sistema não pode executar o backup agendado.' +#13+
                'Entre em contato com o administrador do sistema!!');
    Result := false;
   end;
   AddStatusLine(Format('Backup Finalizado às %s horas', [FormatDateTime('hh:nn:ss', now)]), clGreen);

end;



procedure TFPrincipal.Excluir1Click(Sender: TObject);
begin
  EBase.Items.Delete(EBase.ItemIndex);

end;

procedure TFPrincipal.ExecutaBackup;
var
   Dir: String;
begin
   reStatus.Lines.Clear;
   AddStatusLine('Aguarde o término do backup...');
   try

    Dir := Retorna_Configuracao(PathBase,'Destino') + '\' + FormatDateTime('dd-mm-yy', now);
    if not DirectoryExists(Dir) then begin
       ForceDirectories(Dir);
    end;

    ForceDirectories(Dir);
//    ForceDirectories(Retorna_Configuracao(PathBase,'Destino'));
    Backup.DatabaseName := Retorna_Configuracao(PathBase,'Base');
    Backup.BackupFile.Clear;
    Backup.BackupFile.Add(ChangeFileExt(Dir + '\' + FormatDateTime('ddmmyy-hhmm', now), '.fbk'));
    Backup.Active := true;
    AddStatusLine(Format('Backup Iniciado às %s horas', [FormatDateTime('hh:nn:ss', now)]), clGreen);
    Backup.ServiceStart;
    Memo1.Lines.Clear;
    while not Backup.Eof do
      Memo1.Lines.Add(BackUp.GetNextLine);
    Backup.Active := false;
   except
       ShowMessage('O sistema não pode executar o backup agendado.' +#13+
                   'Entre em contato com o administrador do sistema!!');
   end;
   AddStatusLine(Format('Backup Finalizado às %s horas', [FormatDateTime('hh:nn:ss', now)]), clGreen);

end;


procedure TFPrincipal.AddStatusLine(S: string; Cor: TColor; Tamanho: byte);
begin
  reStatus.SelAttributes.Color := Cor;
  reStatus.SelAttributes.Size := Tamanho;
  reStatus.Lines.Add(S);
end;

// *********************************************************

procedure TFPrincipal.sbBuscaBaseClick(Sender: TObject);
begin
  with TOpenDialog.Create(Self) do
    begin
      Filter := 'FireBird/InterBase Database(*.gdb;*.fdb)|*.gdb;*.fdb';
//      if FileExists(PathExecutavel + 'firebird.conf') then begin
//      end else
//        eBase.Items.Add('dados.gdb');
//        eBase.Items.Add('imagens.gdb');
//      begin
        if Execute then eBase.Items.Add(FileName);
//      end;

    end;
end;

procedure TFPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caNone;
//   FPrincipal := nil;
   Application.Minimize;
end;

procedure TFPrincipal.FormCreate(Sender: TObject);
begin
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  PathBase := ExtractFilePath(Application.ExeName);
  PathExecutavel := ExtractFilePath(Application.ExeName);

end;

procedure TFPrincipal.sbCancelarClick(Sender: TObject);
begin
  Application.Minimize;
//  Close;
end;

procedure TFPrincipal.sbOkClick(Sender: TObject);
var
  reg: TRegistry;
  i, X: integer;
  Dias_Cfg,Horarios_Cfg, Bases: String;

begin
  Dias_Cfg := '';
  Horarios_Cfg := '';
  Bases := '';

  // Salva Dias
  for X := 0 to (clbSemana.Items.Count - 1) do begin
     if  clbSemana.Checked[X] then begin
        Dias_Cfg := Dias_Cfg + IntToStr(X) + ';';
     end;
  end;

  // Salva Horarios
  for i := 0 to (clbHorarios.Items.Count - 1) do begin
     if  clbHorarios.Checked[i] then begin
        Horarios_Cfg := Horarios_Cfg + IntToStr(i) + ';';
     end;
  end;

  Salva_Configuracao(PathBase,'Base','');

  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
//  Salva_Configuracao(PathBase,'Base',Trim(eBase.Text));

  for X := 0 to eBase.Items.Count -1 do begin
     if Trim(eBase.Items.Strings[X]) <> '' then
        Bases := Bases + Trim(eBase.Items.Strings[X]) + ',';
  end;

//  ShowMEssage(Bases);

  Salva_Configuracao(PathBase,'Base',Bases);
  Salva_Configuracao(PathBase,'Destino',Trim(eDirBackup.Text));
  Salva_Configuracao(PathBase,'Dias',Dias_Cfg);
  Salva_Configuracao(PathBase,'Horarios',Horarios_Cfg);
  Salva_Configuracao(PathBase,'Iniciar',BooleanToStr(CheckBox1.Checked));
  Salva_Configuracao(PathBase,'DiasDelete',Trim(cbDias.Text));
  Salva_Configuracao(PathBase,'UltimaData',DateToStr(date));
  Salva_Configuracao(PathBase,'Informar',BooleanToStr(CheckInforma.Checked));
  Salva_Configuracao(PathBase,'Inferior',Trim(cbDias.Text));
  Application.Minimize;

end;

procedure TFPrincipal.TimerTimer(Sender: TObject);
var
  i: integer;
begin
  // Salva Horarios
  for i := 0 to (clbHorarios.Items.Count - 1) do begin
     if  clbHorarios.Checked[i] = True then begin
        if Trim(clbHorarios.Items.Strings[i]) = FormatDateTime('hh:mm',now) then begin
           Timer.Enabled := false;
           ExecutaBackup;
           Timer.Enabled := true;
           Break;
        end;
     end;
  end;


end;

procedure TFPrincipal.sbSairClick(Sender: TObject);
begin
  Application.Minimize;
//   Close;
end;

procedure TFPrincipal.AppEventsMinimize(Sender: TObject);
begin
  if NewStyleControls then ShowWindow(Application.Handle, SW_HIDE);

end;

procedure TFPrincipal.AppEventsRestore(Sender: TObject);
begin
  if NewStyleControls then ShowWindow(Application.Handle, SW_SHOW);

end;

procedure TFPrincipal.AppEventsActivate(Sender: TObject);
begin
  if Screen.ActiveForm <> nil then Screen.ActiveForm.BringToFront;

end;

procedure TFPrincipal.BackupMenuItemClick(Sender: TObject);
begin
  Application.Restore;
  Application.BringToFront;

end;

procedure TFPrincipal.FormActivate(Sender: TObject);
begin
  if PodeMinimizar then
  begin
    Application.Minimize;
    PodeMinimizar := False;
  end;

end;

procedure TFPrincipal.FormShow(Sender: TObject);
var
   X: Integer;
   Bases: String;
begin
  PodeMinimizar := True;

  // Pega o caminho dos bancos de dados dentro da mesma pasta e salva no arquivo
  // de configuração
  eBase.Items.Clear;

//  if FileExists(ExtractFilePath(Application.ExeName) + 'firebird.conf') then
//  begin
//    eBase.Items.Add('dados.gdb');
//    eBase.Items.Add('imagem.gdb');
//  end else begin
    eBase.Items.Add(ExtractFilePath(Application.ExeName) + 'dados.gdb');
    eBase.Items.Add(ExtractFilePath(Application.ExeName) + 'imagem.gdb');
//  end;

  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';

  for X := 0 to eBase.Items.Count -1 do begin
     if Trim(eBase.Items.Strings[X]) <> '' then
        Bases := Bases + Trim(eBase.Items.Strings[X]) + ',';
  end;

  // *******************************************************************************


  if not FileExists(PathBase + 'fbbackup.cfg') then begin
     Cria_VariaveisBackup;
     Salva_Configuracao(PathBase,'Base','');
     Salva_Configuracao(PathBase,'Base',Bases);
     exit;
  end;

  Salva_Configuracao(PathBase,'Base','');
  Salva_Configuracao(PathBase,'Base',Bases);

  if (Trim(Retorna_Configuracao(PathBase,'Base')) = '') or
     (Trim(Retorna_Configuracao(PathBase,'Dias')) = '') then begin
     ShowMessage('Ainda não existem backups agendados...');
     exit;
  end;



   // Se o dia atual é igual ao previsto para excluir backups antigos
   if date >= (StrToDate(Trim(Retorna_Configuracao(PathBase,'UltimaData'))) + StrToInt(Retorna_Configuracao(PathBase,'DiasDelete'))) then begin
      if StrToBoolean(Retorna_Configuracao(PathBase,'Informar')) = True then begin
         if MessageBox(Application.Handle, pchar('O sistema executará agora a limpeza da pasta de backups.'+#13+#10+
                      'Confirma a exclusão dos arquivos de backup ?'),
                      'Atenção!', MB_YESNO+MB_ICONQUESTION) = idNo then Exit;
      end;

      sbDeletarClick(Sender);
   end;

  Itens := 0;
  RetornaItems;


end;

procedure TFPrincipal.Sobre1Click(Sender: TObject);
begin
  with TFrmSobre.Create(Self) do
    try
       ShowModal;
    finally
       Free;
    end;

end;

procedure TFPrincipal.Exit1Click(Sender: TObject);
begin
  Application.Terminate;

end;

procedure TFPrincipal.RxTrayIcon1DblClick(Sender: TObject);
begin
  Application.Restore;
  Application.BringToFront;

end;

procedure TFPrincipal.TimerDelecaoTimer(Sender: TObject);
var
  X: Integer;
  SR: TSearchRec;
  I: integer;

begin
   if StrToInt(cbDias.Text) = 0 then begin
      TimerDelecao.Enabled := False;
      exit;
   end;

   if Trim(Retorna_Configuracao(PathBase,'UltimaData')) <> '' then begin
      // Se o dia atual é igual ao previsto para excluir backups antigos
      if date >= (StrToDate(Trim(Retorna_Configuracao(PathBase,'UltimaData'))) + StrToInt(Retorna_Configuracao(PathBase,'DiasDelete'))) then begin
         sbDeletarClick(Sender);
      end;
   end;
end;

procedure TFPrincipal.CheckBox1Click(Sender: TObject);
var
  Reg, Reg1, Reg2: Tregistry;
begin
{    if CheckBox1.Checked = True then begin
       Reg1:=Tregistry.create;
       with Reg1 do begin
          rootkey:=HKEY_CURRENT_USER;
          Openkey('Software\Snake\FBBackup', False);
          Reg1.WriteString('Inicia', 'True');
          closekey;
          Reg1.free;
       end;
    end else begin
       // Chave 2
       Reg1:=Tregistry.create;
       with Reg1 do begin
          rootkey:=HKEY_CURRENT_USER;
          Openkey('Software\Snake\FBBackup', True);
          Reg1.WriteString('Inicia', 'False');
          closekey;
          Reg1.free;
       end;
    end;  }

    // Tira ou coloca na inicialização
    if CheckBox1.Checked = True then begin
     Reg1:=Tregistry.create;
     with Reg1 do begin
        rootkey:=HKEY_LOCAL_MACHINE;
        Openkey('Software\Microsoft\Windows\CurrentVersion\Run', false);
//        Reg1.WriteString('!SnakeSafe', 'C:\Arquivos de programas\SnakeSafe 2.0\Snake.exe');
        Reg1.WriteString('!BackupFB', ExtractFilePath(Application.Exename) + 'fbBackup.exe');
        closekey;
        reg1.free;
     end;
    end else begin
     // Chave principal
     Reg1:=Tregistry.create;
     with Reg1 do begin
        rootkey:=HKEY_LOCAL_MACHINE;
        Openkey('Software\Microsoft\Windows\CurrentVersion\Run', false);
        DeleteValue('!BackupFB');
        closekey;
        reg1.free;
     end;
    end;

end;

procedure TFPrincipal.sbIniciarClick(Sender: TObject);
var
   X, Y: Integer;
   Bases, NomeBanco, Dir: String;

begin
//   ExecutaBackup;
   PageControl1.ActivePageIndex := 0;

   reStatus.Lines.Clear;
   AddStatusLine('Aguarde o término do backup...');
   Bases := Retorna_Configuracao(PathBase,'Base');

   try

      NomeBanco := '';

       Dir := Retorna_Configuracao(PathBase,'Destino') + '\' + FormatDateTime('dd-mm-yy', now);
       if not DirectoryExists(Dir) then begin
          ForceDirectories(Dir);
       end;


      for X := 1 to 99 do begin

          if Trim(piece(Bases,',',X)) = '' then begin
             AddStatusLine(Format('Backup Finalizado às %s horas', [FormatDateTime('hh:nn:ss', now)]), clGreen);
             exit;
          end;

          NomeBanco :=  piece(Bases,',',X);

          for Y := 1 to 99 do begin
             if piece(Trim(NomeBanco),'\',Y) = '' then begin
                NomeBanco := Trim(piece(Trim(NomeBanco),'\',Y-1));
                break;
             end;
          end;


//          ForceDirectories(Retorna_Configuracao(PathBase,'Destino') + '\' + Dir);
          ForceDirectories(Dir);
          Backup.DatabaseName := piece(Bases,',',X);
          Backup.BackupFile.Clear;
//          Backup.BackupFile.Add(ChangeFileExt(Retorna_Configuracao(PathBase,'Destino') + '\' + Dir + '\' + FormatDateTime('ddmmyy-hhmm', now) + '-' + NomeBanco , '.fbk'));
          Backup.BackupFile.Add(ChangeFileExt(Dir + '\' + FormatDateTime('ddmmyy-hhmm', now) + '-' + NomeBanco , '.fbk'));
          AddStatusLine(Format('Backup de ' + NomeBanco + ' Iniciado às %s horas', [FormatDateTime('hh:nn:ss', now)]), clRed);
          Backup.Active := true;
          Backup.ServiceStart;
          Memo1.Lines.Clear;
          while not Backup.Eof do
            Memo1.Lines.Add(BackUp.GetNextLine);
          Backup.Active := false;
      end;
   except
      on E: Exception do begin
         showmessage('O sistema não pode executar o backup agendado.' +#13+#10+
                     'Verifique as configurações do aplicativo e do banco de dados!!'
                     +#13+#10+ E.Message);
      end;
   end;



end;


procedure TFPrincipal.DirList( ASource : string; ADirList : TStringList );
var
   SearchRec : TSearchRec;
   Result : integer;
begin
   Result := FindFirst( ASource, faAnyFile, SearchRec );
   if Result = 0 then
   while (Result = 0) do
   begin
   if (SearchRec.Name+' ')[1] = '.' then
   // Se pegou nome de SubDiretorio
   begin
   Result := FindNext( SearchRec );
   Continue;
   end;
   ADirList.Add( SearchRec.Name );
   Result := FindNext( SearchRec );
   end;
   FindClose( SearchRec );
   ADirList.Sort;
end;



procedure TFPrincipal.sbDeletarClick(Sender: TObject);
var
  SR: TSearchRec;
  I,W, X: integer;
  Arquivo: String;
  Inferior: TDateTime;
  Dia_Atual: TDateTime;
  Dias_Inferior: Integer;
  Final: TDateTime; // Finaliza o while neste ponto

  contador: Integer;
  lista: TStringlist;

begin
   TimerDelecao.Enabled := False;
   if Trim(Retorna_Configuracao(PathBase,'DiasDelete')) <> '' then begin
      Dia_Atual := date - 2;
      Final := date - StrToInt(Retorna_Configuracao(PathBase,'Inferior'));
      Dias_Inferior := StrToInt(Retorna_Configuracao(PathBase,'Inferior'));

      lista:= TStringlist.create;
//      DirList(Retorna_Configuracao(PathBase,'Destino') + '\' + '*.fbk', lista);
      DirList(Retorna_Configuracao(PathBase,'Destino') + '\' + '*.fbk', lista);

      for X := 0 to lista.Count -1 do begin
         if StrToDate(copy(lista.Strings[X],1,2) + '/' +
                      copy(lista.Strings[X],3,2) + '/' +
                      copy(lista.Strings[X],5,2) + '/' )  <  Final then begin

            Arquivo := Retorna_Configuracao(PathBase,'Destino') + '\' + lista.Strings[X];
            // Exclui arquivos do diretorio tef ********************************
            W := FindFirst(Arquivo,faAnyFile, SR);
            while W = 0 do begin
            if (SR.Attr and faDirectory) <> faDirectory then
            if not DeleteFile(Retorna_Configuracao(PathBase,'Destino') + '\' + SR.Name) then
            ShowMessage('Erro ao excluir arquivos de importação!' + #13+
                        'Arquivos: ' + SR.Name);
            W := FindNext(SR);
            end;
         end;
      end;

      Salva_Configuracao(PathBase,'UltimaData',DateToStr(date));
      EditUltima.Text := Retorna_Configuracao(PathBase,'UltimaData');
      lista.Clear;
   end;

end;

procedure TFPrincipal.Button1Click(Sender: TObject);
var
   X: Integer;
begin
   for X := 0 to clbSemana.Items.Count -1 do begin
       clbSemana.Checked[X] := True;
   end;

end;

procedure TFPrincipal.Button2Click(Sender: TObject);
var
   X: Integer;
begin
   for X := 0 to clbSemana.Items.Count -1 do begin
       clbSemana.Checked[X] := False;
   end;

end;

procedure TFPrincipal.Button3Click(Sender: TObject);
var
   X: Integer;
begin
   for X := 0 to clbHorarios.Items.Count -1 do begin
       clbHorarios.Checked[X] := True;
   end;

end;

procedure TFPrincipal.Button4Click(Sender: TObject);
var
   X: Integer;
begin
   for X := 0 to clbHorarios.Items.Count -1 do begin
       clbHorarios.Checked[X] := False;
   end;

end;

procedure TFPrincipal.Button5Click(Sender: TObject);
var
  SR: TSearchRec;
  I,W, X: integer;
  Arquivo: String;
  Inferior: TDateTime;
  Dia_Atual: TDateTime;
  Dias_Inferior: Integer;
  Final: TDateTime; // Finaliza o while neste ponto

  contador: Integer;
  lista: TStringlist;

begin
   TimerDelecao.Enabled := False;
   if Trim(Retorna_Configuracao(PathBase,'DiasDelete')) <> '' then begin
      Dia_Atual := date - 2;
      Final := date - StrToInt(Retorna_Configuracao(PathBase,'Inferior'));
      Dias_Inferior := StrToInt(Retorna_Configuracao(PathBase,'Inferior'));

      lista:= TStringlist.create;
      DirList(Retorna_Configuracao(PathBase,'Destino') + '\*.*', lista);

      for X := 0 to lista.Count -1 do begin
         Arquivo := Retorna_Configuracao(PathBase,'Destino') + '\' + lista.Strings[X];
         if Trim(piece(Arquivo,'.',2)) = '' then begin
            ShowMessage('Arquivo: ' + Arquivo);
            ApagaPasta(Arquivo);
         end;
      end;

      Salva_Configuracao(PathBase,'UltimaData',DateToStr(date));
      EditUltima.Text := Retorna_Configuracao(PathBase,'UltimaData');
      lista.Clear;
   end;




end;

end.

