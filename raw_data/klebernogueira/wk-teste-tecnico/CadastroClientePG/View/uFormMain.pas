unit uFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  StrUtils,
  System.Types,
  ClientesController,
  CEPController,
  uRestAPI,
  uFormMensagem;

type
  TFormMain = class(TForm)
    ButtonImportar: TButton;
    LabelDocumento: TLabel;
    EditDocumento: TEdit;
    LabelNatureza: TLabel;
    EditNatureza: TEdit;
    LabelPrimeiroNome: TLabel;
    EditPrimeiroNome: TEdit;
    LabelSobreNome: TLabel;
    EditSobreNome: TEdit;
    ButtonInserir: TButton;
    LabelCEP: TLabel;
    EditCEP: TEdit;
    LabelId: TLabel;
    EditId: TEdit;
    ButtonDeletar: TButton;
    ButtonAtualizar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonImportarClick(Sender: TObject);
    procedure EditNaturezaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditIdKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ButtonDeletarClick(Sender: TObject);
    procedure ButtonAtualizarClick(Sender: TObject);
  private
    { Private declarations }
    procedure ExecutarCEP();
    procedure ThreadCEP_Terminada(Sender: TObject);
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  oClienteController : TClientesController;
  oCEPController : TCEPController;
  oThreadCEP: TThread;

implementation
uses
   System.Generics.Collections,
   ClientesModel,
   CEPModel;

{$R *.dfm}

procedure TFormMain.ExecutarCEP();
var
   oCEPModelList : TObjectList<TCEPModel>;
   oCEPModel : TCEPModel;
   iCep : integer;
begin
   oCEPController := TCEPController.Create();
   oCEPModel := nil;
   while True do begin
      Sleep(5000);
      // buscar ceps a serem consultados
      if (oCEPController.Get(oCEPModelList)) then begin
         for iCep := 0 to oCEPModelList.Count - 1 do begin
            uRestAPI.Executar(
               'viacep.com.br/ws/' + oCEPModelList[iCep].cep + '/json/',
               oCEPModel);
            if (oCEPModel <> nil) then begin
               oCEPModel.idEndereco := oCEPModelList[iCep].idEndereco;
               oCEPController.Insert(oCEPModel);

            end;


         end;

      end;

      TThread.Synchronize(
         nil,
         procedure begin
            // interagir com componentes da tela (por exemplo)
         end
      );

   end;


end;

procedure TFormMain.ThreadCEP_Terminada(Sender: TObject);
begin
   if (Assigned(TThread(Sender).FatalException)) then begin
      // exibir ou criar logs de erros
      //Exception(TThread(Sender).FatalException).Message;

   end;

end;

procedure TFormMain.ButtonAtualizarClick(Sender: TObject);
var
   oFormMensagem : TFormMensagem;
   oClientesList : TObjectList<TClientesModel>;
   oCliente : TClientesModel;
   iItem : integer;
begin
   oCliente := TClientesModel.Create();

   oCliente.Id :=
      StrToInt(EditId.Text);
   oCliente.Natureza :=
      StrToInt(EditNatureza.Text);
   oCliente.Documento :=
      EditDocumento.Text;
   oCliente.PrimeiroNome :=
      EditPrimeiroNome.Text;
   oCliente.SobreNome :=
      EditSobreNome.Text;
   oCliente.CEP :=
      EditCEP.Text;
   if (not oClienteController.Update(oCliente)) then begin
      oClientesList := TObjectList<TClientesModel>.Create();
      oClientesList.Add(oCliente);

      oFormMensagem := TFormMensagem.Create(Self);

      if (oClienteController.MensagemErro <> '') then begin
         oFormMensagem.RichEditMensagem.Lines.Add(
            'Erro: ' + oClienteController.MensagemErro
         );
         oFormMensagem.RichEditMensagem.Lines.Add('');

      end;

      for iItem := 0 to Pred(oClientesList.Count) do begin
         if (
               (oClientesList[iItem].MensagemErro <> nil) and
               (oClientesList[iItem].MensagemErro.Count > 0)
            ) then begin
            oFormMensagem.RichEditMensagem.Lines.Add(
               '>> Item: ' + iItem.ToString());
            oFormMensagem.RichEditMensagem.Lines.AddStrings(
               oClientesList[iItem].MensagemErro
            );
            oFormMensagem.RichEditMensagem.Lines.Add('');

         end;

      end;
      if (
            (oFormMensagem.RichEditMensagem.Lines <> nil) and
            (oFormMensagem.RichEditMensagem.Lines.Count > 0)
         ) then begin
         oFormMensagem.ShowModal();

      end;

   end;


end;

procedure TFormMain.ButtonDeletarClick(Sender: TObject);
var
   oFormMensagem : TFormMensagem;
   oCliente : TClientesModel;
begin
   oCliente := TClientesModel.Create();

   oCliente.Id :=
      StrToInt(EditId.Text);
   if (not oClienteController.Delete(oCliente)) then begin
      oFormMensagem := TFormMensagem.Create(Self);

      if (oClienteController.MensagemErro <> '') then begin
         oFormMensagem.RichEditMensagem.Lines.Add(
            'Erro: ' + oClienteController.MensagemErro
         );
         oFormMensagem.RichEditMensagem.Lines.Add('');

         oFormMensagem.ShowModal();

      end;

   end;


end;

procedure TFormMain.ButtonImportarClick(Sender: TObject);
var
   oFormMensagem : TFormMensagem;
   oClientesList : TObjectList<TClientesModel>;
   oCliente : TClientesModel;
   oFile : TStringList;
   oFileLine : TStringDynArray;
   oOpenDialog: TOpenDialog;
   iItem, iAux: Integer;
   bResult: boolean;
   sFileImportar: string;
begin
   oCliente := TClientesModel.Create();

   if (Sender <> nil) then begin
      bResult := true;
      if (Sender = ButtonInserir) then begin
         oCliente.Id :=
            StrToInt(EditId.Text);
         oCliente.Natureza :=
            StrToInt(EditNatureza.Text);
         oCliente.Documento :=
            EditDocumento.Text;
         oCliente.PrimeiroNome :=
            EditPrimeiroNome.Text;
         oCliente.SobreNome :=
            EditSobreNome.Text;
         oCliente.CEP :=
            EditCEP.Text;

         bResult :=
            oClienteController.Insert(oCliente);

         oClientesList := TObjectList<TClientesModel>.Create();
         oClientesList.Add(oCliente);

      end
      else begin
         oOpenDialog := TOpenDialog.Create(Self);
         oClientesList := TObjectList<TClientesModel>.Create();

         sFileImportar := '';
         if (oOpenDialog.Execute(Self.Handle)) then begin
            sFileImportar := oOpenDialog.FileName;

         end
         else begin
            bResult := False;
            oClienteController.MensagemErro := 
               'Abandonado pelo Operador';

         end;
         if (sFileImportar <> '') then begin
            oFile := TStringList.Create();

            oFile.LoadFromFile(sFileImportar);
            if (oFile.Count > 0) then begin
               oFileLine := SplitString(oFile[0], ';');
               if (
                     (oFileLine = nil) or
                     (High(oFileLine) + 1 < 6)
                  ) then begin
                  bResult := False;
                  oClienteController.MensagemErro :=
                     'LayOut Inválido' + #13 +
                     'Esperado: Codigo;Natureza;Documento;PrimeiroNome;SobreNome;CEP';
               end
               else begin
                  for iItem := 0 to Pred(oFile.Count) do begin
                     if (Trim(oFile[iItem]) <> '') then begin
                        oFileLine := SplitString(oFile[iItem], ';');
                        if (
                              (oFileLine <> nil) and
                              (High(oFileLine) + 1 > 5)
                           ) then begin
                           iAux := 0;
                           if (TryStrToInt(oFileLine[0], iAux)) then
                              oCliente.Id :=
                                 iAux
                           else
                              oCliente.Id := 0;
                           if (TryStrToInt(oFileLine[1], iAux)) then
                              oCliente.Natureza :=
                                 iAux
                           else
                              oCliente.Natureza := 0;
                           iAux := 0;
                           oCliente.Documento :=
                              oFileLine[2];
                           oCliente.PrimeiroNome :=
                              oFileLine[3];
                           oCliente.SobreNome :=
                              oFileLine[4];
                           oCliente.CEP :=
                              oFileLine[5];

                           oClientesList.Add(oCliente);
                           oCliente := TClientesModel.Create();

                        end;

                     end;
                     
                  end;
                     
                  bResult :=
                     oClienteController.InsertLote(oClientesList);
               
               end;

            end;
               
         end;

(*         oCliente.Natureza := -1;
         oCliente.Documento := '250665074ABC#!@';
         oClientesList.Add(oCliente);

         oCliente := TClientesModel.Create();
         oCliente.Natureza := -2;
         oCliente.Documento := '000000001';
         oClientesList.Add(oCliente);*)


      end;

      if (not bResult) then begin
         oFormMensagem := TFormMensagem.Create(Self);

         if (oClienteController.MensagemErro <> '') then begin
            oFormMensagem.RichEditMensagem.Lines.Add(
               'Erro: ' + oClienteController.MensagemErro
            );
            oFormMensagem.RichEditMensagem.Lines.Add('');

         end;

         for iItem := 0 to Pred(oClientesList.Count) do begin
            if (
                  (oClientesList[iItem].MensagemErro <> nil) and
                  (oClientesList[iItem].MensagemErro.Count > 0)
               ) then begin
               oFormMensagem.RichEditMensagem.Lines.Add(
                  '>> Item: ' + iItem.ToString());
               oFormMensagem.RichEditMensagem.Lines.AddStrings(
                  oClientesList[iItem].MensagemErro
               );
               oFormMensagem.RichEditMensagem.Lines.Add('');

            end;

         end;
         if (
               (oFormMensagem.RichEditMensagem.Lines <> nil) and
               (oFormMensagem.RichEditMensagem.Lines.Count > 0)
            ) then begin
            oFormMensagem.ShowModal();

         end;


      end;

   end;

end;

procedure TFormMain.EditIdKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Trim(EditId.Text) = '') then begin
      EditId.Text := '0';
      EditId.SelectAll();

   end;

end;

procedure TFormMain.EditNaturezaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Trim(EditNatureza.Text) = '') then begin
      EditNatureza.Text := '0';
      EditNatureza.SelectAll();

   end;

end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
   Self.Caption := 'Cadastro Cliente';
   Self.Position := poDesktopCenter;

   Self.EditId.Text := '0';
   Self.EditId.MaxLength := 15;
   Self.EditId.NumbersOnly := true;

   Self.EditNatureza.Text := '0';
   Self.EditNatureza.MaxLength := 2;
   Self.EditNatureza.NumbersOnly := true;

   Self.EditDocumento.Text := '';
   Self.EditDocumento.MaxLength := 20;

   Self.EditPrimeiroNome.Text := '';
   Self.EditPrimeiroNome.MaxLength := 100;

   Self.EditSobreNome.Text := '';
   Self.EditSobreNome.MaxLength := 100;

   Self.EditCEP.Text := '0';
   Self.EditCEP.MaxLength := 8;

   Self.BorderIcons := Self.BorderIcons - [biMaximize];

   oClienteController := TClientesController.Create();
   oCEPController := TCEPController.Create();

   oThreadCEP := TThread.CreateAnonymousThread(ExecutarCEP);

   oThreadCEP.OnTerminate := ThreadCEP_Terminada;
   oThreadCEP.Start();

end;

end.
