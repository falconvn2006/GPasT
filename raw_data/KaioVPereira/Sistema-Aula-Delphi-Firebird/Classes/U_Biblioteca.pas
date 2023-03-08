unit U_Biblioteca;

interface
  uses IniFiles, System.SysUtils, Vcl.Forms;

  procedure ArqIni(pLocal, pSessao, pSubsessao: String; pValor:String);

  function GetArqIni (pLocal, Psessao, pSubsessao: String): string;

implementation

uses U_FormMain;

  //Procedure que gera o arquivo ini
  procedure ArqIni(pLocal, pSessao, pSubsessao: String; pValor:String);
  var vArquivo: TiniFile;
    begin
      vArquivo := TiniFile.Create(pLocal);
      vArquivo.WriteString(pSessao, pSubsessao, pValor);
      vArquivo.Free;
    end;

  //Function que lê o arquivo ini e gera o arquivo também
  function GetArqIni (pLocal, Psessao, pSubsessao: String): string;
  var vArquivo : TIniFile;
    begin
      vArquivo := TIniFile.Create(pLocal);
      Result := vArquivo.ReadString(pSessao, pSubsessao, '');
      vArquivo.Free;
    end;

end.
