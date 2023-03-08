unit Bib.Functions;

interface
uses
  Winapi.Windows,  System.SysUtils, Registry,IdHashMessageDigest,
  Winapi.WinInet, WinApi.ShellApi, Vcl.Forms, Vcl.Controls;

Type
  TMsg = class
  Public
   const YNInf2:Integer = MB_YESNO+MB_ICONINFORMATION+MB_DEFBUTTON2;
   const YNInf:Integer = MB_YESNO+MB_ICONINFORMATION+MB_DEFBUTTON1;
   const OkInf:Integer = MB_OK+MB_ICONINFORMATION+MB_DEFBUTTON1;
   const OkErr:Integer = MB_OK+MB_ICONERROR+MB_DEFBUTTON1;
  end;

  TFunctions = class(TMsg)
  public
    procedure Msg(Msg:String;Icone:Integer;ParaApp:Boolean=False);
    function identificaVersaoArquivo(pachArquivo: String): String;
  end;

Var Fnc:TFunctions;

implementation


{ TFunctions }

function TFunctions.identificaVersaoArquivo(pachArquivo: String): String;
var
  nTamanhoInfo, nTamanhoValor, Handle: Cardinal;
  pInfoVersao: Pointer;
  pValorVersao: PVSFixedFileInfo;
begin
  nTamanhoInfo := GetFileVersionInfoSize(PChar(pachArquivo), Handle);
  GetMem(pInfoVersao, nTamanhoInfo);
  try
    GetFileVersionInfo(PChar(pachArquivo), 0, nTamanhoInfo, pInfoVersao);
    VerQueryValue(pInfoVersao, '\', Pointer(pValorVersao), nTamanhoValor);

    result := Format('%d.%d.%d.%d', [
      HiWord(pValorVersao^.dwFileVersionMS),
      LoWord(pValorVersao^.dwFileVersionMS),
      HiWord(pValorVersao^.dwFileVersionLS),
      LoWord(pValorVersao^.dwFileVersionLS)]);
  finally
    FreeMem(pInfoVersao, nTamanhoInfo);
  end;
end;

procedure TFunctions.Msg(Msg: String; Icone: Integer; ParaApp: Boolean);
begin
  Application.MessageBox(PChar(Msg),'SPA - Sistema Projeletric de Atualização de Versão',Icone);
  if ParaApp then
    Application.Terminate;
end;

end.
