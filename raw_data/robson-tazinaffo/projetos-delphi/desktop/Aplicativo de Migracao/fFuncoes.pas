unit fFuncoes;

interface

uses IBDataBase, Funcoes, Sysutils, Forms, IBQuery, Classes, Dialogs,
  Buttons, extctrls, controls, DBEditFocus, EditFocus, MaskEditFocus, windows;

function Formulario_PesqRapida(Tabela, Campos, Condic_Especial, Filtro_Especial: String; Retorno: Integer):String;
function Formulario_Permissao(Rotina_Acesso: String; Pedir_Senha: Boolean): Boolean;
function MaximoReceber(nmDatabase: TIBDataBase; Sender: String): String;
procedure AcionaFormulariosAvulsos(Modulo, Sender: String);
procedure Formulario_Pesquisa(Tabela, Formulario: String);
function Abrevia_Unidade_Prod(Sender: String): String; // Recebe a Unidade (Ex: Caixa) retorna Abreviatura (Ex: CX);
function DefineAcesso(nmDatabase: TIBDataBase; Sender_Usuario: Integer; Sender_Componente: String): Integer;
function Sintetica_Analitica(Sender: String): String;
procedure Define_Modo_Digitacao(Sender: String);
function Max_SubTabela_Cliente(nmDatabase: TIBDataBase; Tabela, Campo, Cliente: String): Integer;
function Max_SubTabela_Funcionario(nmDatabase: TIBDataBase; Tabela, Campo, Funcionario: String): Integer;
function Valida_EAN13(Prefixo, Codigo: String): Boolean;
function RetornaNumerosString(pStr:String): String;

implementation

{$WEAKPACKAGEUNIT}


// Retorna apenas os numeros contidos em uma string
// Usado atualmente no PDV para codigo do produto
function RetornaNumerosString(pStr:String): String;
var
   I: Integer;
begin
   Result := '';
   for I := 1 to Length(pStr) do
      if pStr[I] in ['*','T','1','2','3','4','5','6','7','8','9','0'] Then
       Result := Result + pStr[I]
      else
       pStr[I] := ' ';

end;


// Descobre se a Conta é analitica ou Sintetica
function Sintetica_Analitica(Sender: String): String;
var
  X, UltimoGrau: Integer;
  Graus: Array[1..7] of String;
  Posicao_Anterior: Integer;
  PosicaoMascara: String;
begin

   PosicaoMascara := Retorna_Valores_Variaveis(ExtractFilePath(Application.ExeName), 'PosicaoMascara');

//   Sender := PreencheZeros(Sender);
   Posicao_Anterior := 0;
   for X := 1 to Length(PosicaoMascara) do begin
      if Copy(PosicaoMascara, X, 1) <> '0' then begin
         Graus[X] := Copy(Sender, Posicao_Anterior+1, StrToInt( Copy(PosicaoMascara, X, 1)));
         Posicao_Anterior := Posicao_Anterior + StrToInt( Copy(PosicaoMascara, X, 1));
         UltimoGrau := X;
//         if (StrToInt(Graus[X]) <> 0) then UltimoGrau := X;
      end;
   end;

   if (StrToInt(Graus[UltimoGrau]) <> 0) then
      result := 'A'
   else
      result := 'S';

end;

function DefineAcesso(nmDatabase: TIBDataBase; Sender_Usuario: Integer; Sender_Componente: String): Integer;
var
   SQLProcura: TIBQuery;
begin
   Result := 0;

   try
      SQLProcura := TIBQuery.Create(Application);
      SQLProcura.Name := 'QryAcessoUsuario';
      SQLProcura.DataBase := nmDataBase;
      with SQLProcura do begin
         SQL.Clear;
         SQL.Add('select ACESSO from USUARIO_ACESSO');
         SQL.Add('where USUARIO = :USUARIO');
         SQL.Add('and Upper(COMPONENTE) = :COMPONENTE');
         ParamByName('USUARIO').AsInteger := Sender_Usuario;
         ParamByName('COMPONENTE').AsString := UpperCase(Sender_Componente);
         Open;
         Result := Fields[0].AsInteger;
         Close;
      end;
   finally
      SQLProcura.Free;
   end;

end;

function Formulario_PesqRapida(Tabela, Campos, Condic_Especial, Filtro_Especial: String; Retorno: Integer):String;
var
//   MyMod: HMODULE;
   MyClass: TFormClass;
   MyForm: TForm;
   AClass, AModule: String;
   S: String;
begin
   S := Tabela + '!' + Campos + '!' +
        Condic_Especial + '!' + Filtro_Especial + '!' +
        IntToStr(Retorno);

   JanelaEspera('Acessando Pesquisa Rapida');

   Salva_Valores_Variaveis(ExtractFilePath(Application.ExeName), 'Parametros_PesqRapida', S);

   AClass := 'TF_PesqRapida';
   AModule := 'pkFuncoes';

   MyClass := TFormClass(GetClass(AClass));
   if MyClass = nil then begin
      LoadPackage(AModule + '.bpl');
//      MyMod := LoadPackage(AModule + '.bpl');
//      FModList.AddObject(UpperCase(AModule), TObject(MyMod));
      MyClass := TFormClass(GetClass(AClass));
      if MyClass = nil then
         raise Exception.Create('Classe ' + AClass + ' não encontrada.');
   end;
   MyForm := MyClass.Create(Application);
   JanelaEspera('');
   MyForm.ShowModal;
   MyForm.Free;

   Result := Retorna_Valores_Variaveis(ExtractFilePath(Application.ExeName), 'Retorna_PesqRapida');

//   Screen.Cursor := crHourGlass;
//   F_PesqRapida := TF_PesqRapida.Create(Application);
//   Screen.Cursor := crDefault;
//   Result := F_PesqRapida.Mostra_Formulario(Tabela, Campos, Condic_Especial, Retorno);
//   F_PesqRapida.Free;
end;

function Formulario_Permissao(Rotina_Acesso: String; Pedir_Senha: Boolean): Boolean;
var
   MyMod: HMODULE;
   MyClass: TFormClass;
   MyForm: TForm;
   AClass, AModule: String;
begin
//   Screen.Cursor := crHourGlass;
//   F_Permissao := TF_Permissao.Create(Application);
//   Screen.Cursor := crDefault;
//   Funcionario_Retorno := '';
//   Result := F_Permissao.Mostra_Formulario(Rotina_Acesso, Pedir_Senha);
//   F_Permissao.Free;

   JanelaEspera('Acessando Tela Permissão');

   Salva_Valores_Variaveis(ExtractFilePath(Application.ExeName), 'Parametros_Permissao', Rotina_Acesso+'|'+BooleantoStr(Pedir_Senha));

   AClass := 'TF_Permissao';
   AModule := 'pkFuncoes';

   MyClass := TFormClass(GetClass(AClass));
   if MyClass = nil then begin
      MyMod := LoadPackage(AModule + '.bpl');
//      FModList.AddObject(UpperCase(AModule), TObject(MyMod));
      MyClass := TFormClass(GetClass(AClass));
      if MyClass = nil then
         raise Exception.Create('Classe ' + AClass + ' não encontrada.');
   end;
   MyForm := MyClass.Create(Application);
   JanelaEspera('');
   MyForm.ShowModal;
   MyForm.Free;

   Result := StrToBoolean(Retorna_Valores_Variaveis(ExtractFilePath(Application.ExeName), 'Retorna_Permissao'));

end;

procedure Formulario_Pesquisa(Tabela, Formulario: String);
var
   MyMod: HMODULE;
   MyClass: TFormClass;
   MyForm: TForm;
   AClass, AModule: String;
begin
   JanelaEspera('Acessando Pesquisa Avançada');

   Salva_Valores_Variaveis(ExtractFilePath(Application.ExeName), 'Parametros_Pesquisa', Tabela+'|'+Formulario);

   AClass := 'TF_Pesquisa';
   AModule := 'pkFuncoes';

   MyClass := TFormClass(GetClass(AClass));
   if MyClass = nil then begin
      MyMod := LoadPackage(AModule + '.bpl');
      MyClass := TFormClass(GetClass(AClass));
      if MyClass = nil then
         raise Exception.Create('Classe ' + AClass + ' não encontrada.');
   end;
   MyForm := MyClass.Create(Application);
   JanelaEspera('');
   MyForm.ShowModal;
   MyForm.Free;
end;



procedure AcionaFormulariosAvulsos(Modulo, Sender: String);
var
   MyMod: HMODULE;
   Componente: TComponent;
   AModule, StringTForm, StringForm: String;
   FormLogon, FormEmpresa: TComponent;
   X: Integer;
begin
// Se a tela de logon do Usuario ou que altera Empresa estiver
// sendo utilizada não é permitido abrir outros formularios

    FormLogon := Application.FindComponent('F_Logon');
    FormEmpresa := Application.FindComponent('F_AlteraEmpresa');
//   if (F_Logon <> nil) or (F_AlteraEmpresa <> nil) then begin
    if (FormLogon <> nil) or (FormEmpresa <> nil) then begin
       Exit;
    end;

    Screen.Cursor := crHourGlass;

//    JanelaEspera('Acessando tela ' + (Sender as TMenuITem).Caption);

    StringTForm := 'T'+Sender;
    StringForm := Sender;
    Componente := Application.FindComponent(StringForm);
//    AModule := Lista_Packages.Strings[(Sender as TMenuItem).Tag];
    try
       if Componente = nil then begin
//          ShowMessage(AModule);

          MyMod := LoadPackage(Modulo + '.bpl');
//          FModList.AddObject(UpperCase(AModule), TObject(MyMod));
//          MyMod := LoadPackage('pkGeral.bpl');
//          FModList.AddObject(UpperCase('pkGeral'), TObject(MyMod));

          TFormClass(FindClass(StringTForm)).Create(Application);
          Componente := Application.FindComponent(StringForm);
          if (Componente as TForm).WindowState <> wsMaximized then begin
             (Componente as TForm).Top := 0;
             (Componente as TForm).Left := 0;
          end;

// Muda o Modo de Edição

{          with (Componente as TForm) do begin
             for X := 0 to ComponentCount -1 do begin

                if (Components[X] is TDBEditFocus) then begin
                   if (Components[X] as TDBEditFocus).CharCase <> dbcNormal then begin
                      continue;
                   end;
                   if Modo_Digitacao = 1 then begin
                      (Components[X] as TDBEditFocus).CharCase := dbcNormal;
                   end else if Modo_Digitacao = 2 then begin
                      (Components[X] as TDBEditFocus).CharCase := dbcFirstCase;
                   end else if Modo_Digitacao = 3 then begin
                      (Components[X] as TDBEditFocus).CharCase := dbcUpperCase;
                   end else if Modo_Digitacao = 4 then begin
                      (Components[X] as TDBEditFocus).CharCase := dbcLowerCase;
                   end;
                end;

                if (Components[X] is TEditFocus) then begin
                  if (Components[X] as TEditFocus).CharCase <> ccNormal then begin
                     continue;
                  end;
                   if Modo_Digitacao = 1 then begin
                      (Components[X] as TEditFocus).CharCase := ccNormal;
                   end else if Modo_Digitacao = 2 then begin
                      (Components[X] as TEditFocus).CharCase := ccFirstCase;
                   end else if Modo_Digitacao = 3 then begin
                      (Components[X] as TEditFocus).CharCase := ccUpperCase;
                   end else if Modo_Digitacao = 4 then begin
                      (Components[X] as TEditFocus).CharCase := ccLowerCase;
                   end;
                end;

                if (Components[X] is TMaskEditFocus) then begin
                   if Modo_Digitacao = 1 then begin
                      (Components[X] as TMaskEditFocus).CharCase := mcNormal;
                   end else if Modo_Digitacao = 2 then begin
                      (Components[X] as TMaskEditFocus).CharCase := mcFirstCase;
                   end else if Modo_Digitacao = 3 then begin
                      (Components[X] as TMaskEditFocus).CharCase := mcUpperCase;
                   end else if Modo_Digitacao = 4 then begin
                      (Components[X] as TMaskEditFocus).CharCase := mcLowerCase;
                   end;
                end;
             end;
          end;}

          Screen.Cursor := crDefault;
          JanelaEspera('');
          if (Componente as TForm).FormStyle <> fsNormal then
             (Componente as TForm).Show
          else
             (Componente as TForm).ShowModal;

       end else begin
          if (Componente as TForm).WindowState <> wsMaximized then begin
             (Componente as TForm).Top := 0;
             (Componente as TForm).Left := 0;
          end;
          Screen.Cursor := crDefault;
          JanelaEspera('');
          if (Componente as TForm).FormStyle <> fsNormal then
             (Componente as TForm).Show
          else
             (Componente as TForm).ShowModal;
       end;
    except
       MessageBox(Application.Handle, 'Não foi possível acessar o Menu desejado.' + #13 +
                  'Contate seu Revendedor.', 'Erro', MB_OK+MB_ICONERROR);
    end;
end;

{ Recebe o Paramentro 'R' ou 'S' para identificar
 se a inclusão é original do formulário de Contas
 a Receber ou Saida, e retorna o maior numero deles}
function MaximoReceber(nmDatabase: TIBDataBase; Sender: String): String;
var
   SQLMaximo: TIBQuery;
   Parte: String;
   Empresa_Padrao: String;
begin

   Empresa_Padrao := Retorna_Valores_Variaveis(ExtractFilePath(Application.ExeName), 'Empresa_Padrao');

   SQLMaximo := TIBQuery.Create(Application);
   SQLMaximo.Name := 'QryMaximo';
   SQLMaximo.DataBase := nmDataBase;

   with SQLMaximo do
      begin
         SQL.Clear;
         if Sender = 'R' then begin
            SQL.Add('select max(LANCAMENTO) from CONTAS_RECEBER');
            SQL.Add('where LANCAMENTO like :LANCAMENTO');
            SQL.Add('and LOJA = :LOJA');
            ParamByName('LOJA').AsInteger := StrToInt(Empresa_Padrao);
            ParamByName('LANCAMENTO').AsString := '%0';
            Open;
         end else begin
            SQL.Add('select max(RECEBER) from DADOS_PDV_R');
            SQL.Add('where RECEBER like :RECEBER');
            SQL.Add('and LOJA = :LOJA');
            ParamByName('LOJA').AsInteger := StrToInt(Empresa_Padrao);
            ParamByName('RECEBER').AsString := '%1';
            Open;
         end;
         Parte := Copy(Fields[0].AsString, 1, length(Fields[0].AsString)-1);
         if Parte = '' then begin
            Parte := '1'
         end else begin
            Parte := IntToStr((StrToInt(Parte)+1));
         end;
         if Sender = 'R' then begin
            Parte := Parte + '0';
         end else begin
            Parte := Parte + '1';
         end;
         Result := StrZero(Parte, 9);
         Close;
      end;

   SQLMaximo.Free;

end;

function Abrevia_Unidade_Prod(Sender: String): String; // Recebe a Unidade (Ex: Caixa) retorna Abreviatura (Ex: CX);
var
   Lista_Unidade: TStringList;
   X: Integer;
   Found: Boolean;
begin

   if Trim(Sender) = '' then begin
      Result := 'UN';
      Exit;
   end;

   if not FileExists(ExtractFilePath(Application.ExeName)+'textos\unidade.txt') then begin
      Result := Sender;
      Exit;
   end;

   Lista_Unidade := TStringList.Create;

   Lista_Unidade.Clear;
   Lista_Unidade.LoadFromFile(ExtractFilePath(Application.ExeName)+'textos\unidade.txt');

   Found := False;
   for X := 0 to Lista_Unidade.Count - 1 do begin
      if Piece(Lista_Unidade.Strings[X], ';', 1) = Sender then begin
         Found := True;
         Result := Piece(Lista_Unidade.Strings[X], ';', 2);
         Break;
      end;
   end;

   if not Found then Result := Sender;

   Lista_Unidade.Free;

end;

procedure Define_Modo_Digitacao(Sender: String); // Desabilita Botoes de Edição
var
   Formulario: TComponent;
   X: Integer;
   Modo_Digitacao: Integer;
begin
   Modo_Digitacao := StrToInt(Retorna_Valores_Variaveis(ExtractFilePath(Application.ExeName), 'Modo_Digitacao'));
   
   Formulario := Application.FindComponent(Sender);
   if Formulario = nil then begin
      MessageBox(Application.Handle, 'Não é possível executar esta função.'+#13+#10+'Contate o Revendedor',
         'Erro', MB_OK+MB_ICONERROR);
      Exit;
   end;

   with (Formulario as TForm) do begin
      for X := 0 to ComponentCount -1 do begin
         if (Components[X] is TDBEditFocus) then begin
            if (Components[X] as TDBEditFocus).CharCase <> dbcNormal then begin
               continue;
            end;
            if Modo_Digitacao = 1 then begin
               (Components[X] as TDBEditFocus).CharCase := dbcNormal;
            end else if Modo_Digitacao = 2 then begin
               (Components[X] as TDBEditFocus).CharCase := dbcFirstCase;
            end else if Modo_Digitacao = 3 then begin
               (Components[X] as TDBEditFocus).CharCase := dbcUpperCase;
            end else if Modo_Digitacao = 4 then begin
               (Components[X] as TDBEditFocus).CharCase := dbcLowerCase;
            end;
         end;
         if (Components[X] is TEditFocus) then begin
            if (Components[X] as TEditFocus).CharCase <> ccNormal then begin
               continue;
            end;
            if Modo_Digitacao = 1 then begin
               (Components[X] as TEditFocus).CharCase := ccNormal;
            end else if Modo_Digitacao = 2 then begin
               (Components[X] as TEditFocus).CharCase := ccFirstCase;
            end else if Modo_Digitacao = 3 then begin
               (Components[X] as TEditFocus).CharCase := ccUpperCase;
            end else if Modo_Digitacao = 4 then begin
               (Components[X] as TEditFocus).CharCase := ccLowerCase;
            end;
         end;
         if (Components[X] is TMaskEditFocus) then begin
            if Modo_Digitacao = 1 then begin
               (Components[X] as TMaskEditFocus).CharCase := mcNormal;
            end else if Modo_Digitacao = 2 then begin
               (Components[X] as TMaskEditFocus).CharCase := mcFirstCase;
            end else if Modo_Digitacao = 3 then begin
               (Components[X] as TMaskEditFocus).CharCase := mcUpperCase;
            end else if Modo_Digitacao = 4 then begin
               (Components[X] as TMaskEditFocus).CharCase := mcLowerCase;
            end;
         end;
      end;
   end;

end;

function Max_SubTabela_Cliente(nmDatabase: TIBDataBase; Tabela, Campo, Cliente: String): Integer;
var
   SQLComando: TIBQuery;
begin
   SQLComando := TIBQuery.Create(Application);
   try
      SQLComando := TIBQuery.Create(Application);
//      SQLComando.Name := 'QryAcessoUsuario';
      SQLComando.DataBase := nmDataBase;
      with SQLComando do begin
         SQL.Clear;
         SQL.Add('select max('+Campo+') from ' + Tabela);
         SQL.Add('where CLIENTE = ' + Cliente);
         Open;
         result := Fields[0].AsInteger + 1
      end;
   finally
      SQLComando.Free;
   end;

end;

function Max_SubTabela_Funcionario(nmDatabase: TIBDataBase; Tabela, Campo, Funcionario: String): Integer;
var
   SQLComando: TIBQuery;
begin
   SQLComando := TIBQuery.Create(Application);
   try
      SQLComando := TIBQuery.Create(Application);
      SQLComando.DataBase := nmDataBase;
      with SQLComando do begin
         SQL.Clear;
         SQL.Add('select max('+Campo+') from ' + Tabela);
         SQL.Add('where FUNCIONARIO = ' + Funcionario);
         Open;
         result := Fields[0].AsInteger + 1
      end;
   finally
      SQLComando.Free;
   end;

end;


function Valida_EAN13(Prefixo, Codigo: String): Boolean;

function getEANOwn(Nr : String) : String;
   var i,fak,sum : Integer;
       tmp   : String;
begin
     sum := 0;
//     tmp := copy(nr,1,Length(Nr)-1);
     tmp := copy(nr,1,Length(Nr));
     fak := Length(tmp);
	  for i:=1 to length(tmp) do
			begin
         if (fak mod 2) = 0 then
            sum := sum + (StrToInt(tmp[i])*1)
         else
            sum := sum + (StrToInt(tmp[i])*3);
         dec(fak);
			end;
     if (sum mod 10) = 0 then
        result := tmp+'0'
     else
		  result := tmp+IntToStr(10-(sum mod 10));
end;

var
   Compara_Codigo: String;
begin

   if Length(Prefixo) > 3 then
      Compara_Codigo := Copy(Codigo, 1, 7)
   else
      Compara_Codigo := Copy(Codigo, 2, 3);

   if Prefixo = Compara_Codigo then begin
      if Codigo = getEANOwn(Copy(Codigo, 1, 12)) then begin
         result := True;
      end else begin
         result := False;
      end;
   end else begin
      result := False;
   end;

   if not result then begin
      MessageBox(Application.Handle, 'Este produto não pertence a este estabelecimento.',
         'Erro', MB_OK+MB_ICONERROR);
   end;


end;

end.
