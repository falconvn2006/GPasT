unit CompressGENSAUVEGRILLE_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdZLibCompressorBase,
  IdCompressorZLib, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, Zlib, FireDAC.Phys.IB, FireDAC.Phys.IBDef, Vcl.StdCtrls,
  Vcl.ComCtrls, FireDAC.Phys.IBBase, FireDAC.Comp.UI, FireDAC.DApt;

type
  TCompressThread = class(TThread)
  private
    procedure VCLInfos();
//    function CompareVersion(left, right: string): Integer;
//    function SplitString(src: string; delim: string; var dest1: string;var dest2: string): Boolean;
  protected
    FType       : integer;
    FIBFile     : TFileName;
    FInfo       : string;
    FNew        : string;
    function ZCompressBytes(aBytes: TBytes): TBytes;
//    procedure ZCompressString(const ASrc: AnsiString;var ADest: AnsiString);
    function Caractere_ZERO(aChaine: string): string;
    function ZCompressString(aText: Ansistring): Ansistring;
    function ZDecompressString(aText: string): string;
    procedure StrToFile(const FileName, SourceString : string);
    function DoCompress(aIBFile:string):integer;
    procedure DoDecompress(aIBFile:string);
    function getNewConnexion(aIBFile:string): TFDConnection;
    function getNewTransaction(): TFDTransaction;
  public
    procedure Execute; override;
    constructor Create(aIBFile:TFileName;aType:Integer;CreateSuspended:boolean;Const AEvent:TNotifyEvent=nil); reintroduce;
  end;


  TForm11 = class(TForm)
    FDConnection1: TFDConnection;
    Compress: TButton;
    FDTransaction1: TFDTransaction;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    Memo2: TMemo;
    Button1: TButton;
    edtBASE: TEdit;
    Button2: TButton;
    procedure CompressClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FThread : TCompressThread;
    // procedure FileSearch(const dirName:string);
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form11: TForm11;

implementation

{$R *.dfm}

procedure TCompressThread.VCLInfos();
begin
    Form11.Memo2.Lines.BeginUpdate;
    Form11.Memo2.Lines.Add(FInfo);
    Form11.Memo2.Lines.EndUpdate;
end;

procedure TCompressThread.Execute;
var I: integer;
begin
    try
       try
         If FType=0 then DoDeCompress(FIBFile);
         If FType=1 then DoCompress(FIBFile);
         except on E:Exception
          do
            begin
              FInfo := FIBFile + ' ' + E.MEssage;
              Synchronize(VCLInfos);
             end;
       end;
    finally
      //
    end;
end;


constructor TCompressThread.Create(aIBFile:TFileName;aType:integer;CreateSuspended:boolean;Const AEvent:TNotifyEvent=nil);
begin
    inherited Create(CreateSuspended);
    FType             := aType;
    FIbFile           := aIbFile;
    FreeOnTerminate   := true;
    OnTerminate       := AEvent;
end;

function TCompressThread.Caractere_ZERO(aChaine: string): string;
var i:Integer;
    a:integer;
begin
  result:='';
  for i:= 1 to Length(aChaine) do
    begin
      a:=Ord(aChaine[i]);
      if a=0
        then result := result + '\\DIESE_0\\'
        else result := result + aChaine[i];
    end;
end;

function TCompressThread.ZDecompressString(aText: string): string;
var
  strInput,
  strOutput: TStringStream;
  Unzipper: TZDecompressionStream;
  vText : string;
begin
  Result:= '';
  if (Ord(aText[1])<>120) and (Ord(aText[2])<>156) then
    begin
      Result := aText;
      exit;
    end;
  vText := StringReplace(aText,'\\DIESE_0\\',#0,[rfReplaceAll]);
  strInput:= TStringStream.Create(vText);
  strOutput:= TStringStream.Create('');
  try
    Unzipper:= TZDecompressionStream.Create(strInput);
    try
      strOutput.CopyFrom(Unzipper, 0);
    finally
      Unzipper.Free;
    end;
    Result:= strOutput.DataString;
  finally
    strInput.Free;
    strOutput.Free;
  end;
end;

function TCompressThread.ZCompressBytes(aBytes: TBytes): TBytes;
var
  strInput,
  strOutput: TBytesStream;
  Zipper: TZCompressionStream;
  i:Integer;
begin
  strInput:= TBytesStream.Create(aBytes);
  strOutput:= TBytesStream.Create();
  try
    Zipper:= TZCompressionStream.Create(clDefault,strOutput);
    try
      Zipper.CopyFrom(strInput,strInput.Size);
    finally
      Zipper.Free;
    end;
    Result := strOutput.Bytes;
  finally
    strInput.Free;
    strOutput.Free;
  end;
end;


function TCompressThread.ZCompressString(aText: Ansistring): Ansistring;
var
  strInput,
  strOutput: TStringStream;
  Zipper: TZCompressionStream;
begin
  Result:= '';
  strInput:= TStringStream.Create(aText,TEncoding.ANSI);
  strOutput:= TStringStream.Create('',TEncoding.ANSI);
  try
    Zipper:= TZCompressionStream.Create(strOutput);
    try
      Zipper.CopyFrom(strInput, strInput.Size);
    finally
      Zipper.Free;
    end;
    Result:= Caractere_ZERO(strOutput.DataString);
  finally
    strInput.Free;
    strOutput.Free;
  end;
end;


{
procedure TCompressThread.ZCompressString(const ASrc: AnsiString;var ADest: AnsiString);
var vDest: TStringStream;
    vSource: TStream;
    vCompressor: TZCompressionStream;
begin
  // create the stream to hold the compression result
  vDest := TStringStream.Create('');
  try
	// create the compressor stream, we choose to use maximum compression level.
	// Note that we also pass vDest to the constructor.
	vCompressor := TZCompressionStream.Create(clDefault, vDest);
	try
	  // create stream that provide string data bytes to compress
	  vSource := TStringStream.Create(ASrc);
	  try
		// feed the content of the vSource stream to our compressor
		vCompressor.CopyFrom(vSource, 0);
	  finally
		vSource.Free;  // we are finished with vSource stream.
	  end;
	finally
	  // we are finished with the compressor. This also force it to compress
	  // the still buffered data and flush the result to vDest stream.
	  vCompressor.Free;
	end;

	vDest.Position := 0;

	// get the string from the vDest stream
	ADest := vDest.DataString;
  finally
	vDest.Free;
  end;
end;
}



function TCompressThread.getNewTransaction(): TFDTransaction;
begin
    result:=nil;
    try
       Result := TFDTransaction.Create(nil);
      except
        on E:Exception do
        begin
          if Assigned(result) then
            begin
              result.DisposeOf ;
              result := nil ;
            end;
          raise ;
        end;
    end;
end;


function TCompressThread.getNewConnexion(aIBFile:string): TFDConnection;
begin
  result:=nil;
  try
    try
      Result := TFDConnection.Create(nil);
      Result.Params.Clear;
      Result.Params.Add('DriverID=IB') ;
      Result.Params.Add('Server=localhost') ;
      Result.Params.Add('Protocol=TCPIP') ;
      Result.Params.Add('Port=3050') ;
      Result.Params.Add('Database='  + aIBFile) ;
      Result.Params.Add('User_Name=GINKOIA');
      Result.Params.Add('Password=ginkoia');
      Result.Params.Add('CharacterSet=NONE');
     finally
      //
    end;
  except
    on E:Exception do
    begin
      if Assigned(result) then
        begin
          result.DisposeOf ;
          result := nil ;
        end;
      raise ;
    end;
  end;
end;

procedure TCompressThread.StrToFile(const FileName, SourceString : string);
var
  Stream : TFileStream;
begin
  Stream:= TFileStream.Create(FileName, fmCreate);
  try
    Stream.WriteBuffer(Pointer(SourceString)^, Length(SourceString));
  finally
    Stream.Free;
  end;
end;

procedure TCompressThread.DoDeCompress(aIBFile:string);
var vConnection : TFDConnection;
    vTrans      : TFDTransaction;
    vQuery      : TFDQuery;
    vConfig     : Ansistring;
    zConfig     : Ansistring;
    kQuery      : TFDQuery;
    vVersion    : string;
    vGSG_ID     : integer;
begin
    vConnection := GetNewConnexion(aIBFile);

    vTrans      := getNewTransaction();
    vTrans.Connection := vConnection;

    vQuery      := TFDQuery.Create(nil);
    kQuery      := TFDQuery.Create(nil);
    try
       vQuery.Connection := vConnection;
       vQuery.Transaction := vTrans;
       kQuery.Connection := vConnection;
       kQuery.Transaction := vTrans;
       vTrans.StartTransaction;
       try
         vQuery.Close();
         vQuery.SQL.Clear;
         vQuery.SQL.Add('SELECT RDB$RELATION_NAME FROM RDB$RELATIONS WHERE RDB$RELATION_NAME =:TABLENAME');
         vQuery.ParamByName('TABLENAME').asstring:='GENSAUVEGRILLE';
         vQuery.Open();
         if vQuery.eof then
            begin
               FInfo := Format('%s : %s n''existe pas => EXIT',[aIBFile, 'GENSAUVEGRILLE']);
               Synchronize(VCLInfos);
               exit;
            end;

         vQuery.Close();
         vQuery.SQL.Clear;
         vQuery.SQL.Add('SELECT GSG_ID, GSG_CONFIGURATION FROM GENSAUVEGRILLE WHERE GSG_CONFIGURATION IS NOT NULL AND GSG_ID<>0');
         vQuery.Open();
         while not(vQuery.Eof) do
          begin
            vGSG_ID := vQuery.FieldByName('GSG_ID').Asinteger;
            vConfig := vQuery.FieldByName('GSG_CONFIGURATION').AsString;
            zConfig := ZDecompressString(vConfig);
//            StrToFile(ExtractFilePath(FIBFile)+ Format('_%d.txt',[vGSG_ID]), zConfig);
          end;
         Synchronize(VCLINfos);
         vTrans.Commit;
       Except
        On E:Exception
          do
            Begin
               vTrans.Rollback;
               FInfo := aIBFile + ' ' + E.MEssage;
               Synchronize(VCLInfos);
            End;
       end;
       vQuery.Close();
       kQuery.Close();
    finally
       kQuery.DisposeOf;
       vQuery.DisposeOf;
       vTrans.DisposeOf;
       vConnection.DisposeOf;
    end;
end;


function TCompressThread.DoCompress(aIBFile:string):integer;
var vConnection : TFDConnection;
    vTrans      : TFDTransaction;
    vQuery      : TFDQuery;
    vConfig     : string;
    zConfig     : string;
    cConfig     : String;
    kQuery      : TFDQuery;
    vVersion    : string;
    vGSG_ID     : integer;
begin
    result:=0;
    vConnection := GetNewConnexion(aIBFile);

    vTrans      := getNewTransaction();
    vTrans.Connection := vConnection;

    vQuery      := TFDQuery.Create(nil);
    kQuery      := TFDQuery.Create(nil);
    try
       vQuery.Connection := vConnection;
       vQuery.Transaction := vTrans;
       kQuery.Connection := vConnection;
       kQuery.Transaction := vTrans;
       vTrans.StartTransaction;
       try
         vQuery.Close();
         vQuery.SQL.Clear;
         vQuery.SQL.Add('SELECT RDB$RELATION_NAME FROM RDB$RELATIONS WHERE RDB$RELATION_NAME =:TABLENAME');
         vQuery.ParamByName('TABLENAME').asstring:='GENSAUVEGRILLE';
         vQuery.Open();
         if vQuery.eof then
            begin
               FInfo := Format('%s : %s n''existe pas => EXIT',[aIBFile, 'GENSAUVEGRILLE']);
               Synchronize(VCLInfos);
               exit;
            end;

         vQuery.Close();
         vQuery.SQL.Clear;
         vQuery.SQL.Add('SELECT GSG_ID, GSG_CONFIGURATION FROM GENSAUVEGRILLE WHERE GSG_CONFIGURATION IS NOT NULL AND GSG_ID<>0');
         vQuery.Open();
         while not(vQuery.Eof) do
          begin
            vGSG_ID := vQuery.FieldByName('GSG_ID').Asinteger;
            vConfig := vQuery.FieldByName('GSG_CONFIGURATION').AsString;
            // Si déjà compressé
            if (Ord(vConfig[1])=120) and (Ord(vConfig[2])=156)
               then
                  begin
                     FInfo := Format('%s : record déja compressé',[aIBFile]);
                     Synchronize(VCLINfos);
                     vQuery.Next;
                     Continue;
                  end;
            // bConfig := vQuery.FieldByName('GSG_CONFIGURATION').AsBytes;

            zConfig := ZCompressString(vConfig);
            // zConfig := ZCompressBytes(bConfig);
            vQuery.Edit;
            // vQuery.FieldByName('GSG_CONFIGURATION').AsBytes := zConfig;  // zConfig;
            vQuery.FieldByName('GSG_CONFIGURATION').AsString := zConfig;

            FInfo := Format('%s : %d => %d',[aIBFile,Length(vconfig),Length(zConfig)]);
            Synchronize(VCLINfos);
            vQuery.Post;

            cConfig := ZDecompressString(zConfig);
            // StrToFile(ExtractFilePath(FIBFile)+ Format('%d.txt',[vGSG_ID]), cConfig);
            Inc(Result);

            if cConfig<>vConfig
              then raise Exception.Create('Message d''erreur');

            // Mouvement
            kQuery.Close();
            kQuery.SQL.Clear;
            kQuery.SQL.Add(Format('EXECUTE PROCEDURE PR_UPDATEK(%d,0)',[vQUery.FieldByName('GSG_ID').asinteger]));
            kQuery.ExecSQL;
            vQuery.Next;
          end;
         FInfo := Format('%s : %d ligne(s) traitée(s)',[aIBFile, Result ]);
         Synchronize(VCLINfos);

         vTrans.Commit;

       Except
        On E:Exception
          do
            Begin
               vTrans.Rollback;
               FInfo := aIBFile + ' ' + E.MEssage;
               Synchronize(VCLInfos);
            End;
       end;
       vQuery.Close();
       kQuery.Close();
    finally
       kQuery.DisposeOf;
       vQuery.DisposeOf;
       vTrans.DisposeOf;
       vConnection.DisposeOf;
    end;
end;


procedure TForm11.Button1Click(Sender: TObject);
var
  openDialog : topendialog;    // Open dialog variable
begin
  // Create the open dialog object - assign to our open dialog variable
  openDialog := TOpenDialog.Create(self);
  try
    openDialog.InitialDir := GetCurrentDir;
    openDialog.Options := [ofFileMustExist];
    openDialog.Filter :=
      'Interbase files|*.ib';
    openDialog.FilterIndex := 1;
    edtBASE.Text := '';
    if openDialog.Execute
    then
        begin
            edtBASE.Text := openDialog.FileName
        end;

    // Free up the dialog
  finally
    openDialog.Free;
  end;
end;

procedure TForm11.Button2Click(Sender: TObject);
begin
    if edtBASE.Text<>'' then
      begin
        Compress.Enabled:=False;
        FThread := TCompressThread.Create(edtBASE.Text,0,True,nil);
        FThread.Resume;
      end;
end;

procedure TForm11.CompressClick(Sender: TObject);
begin
    if edtBASE.Text<>'' then
      begin
        Compress.Enabled:=False;
        FThread := TCompressThread.Create(edtBASE.Text,1,True,nil);
        FThread.Resume;
      end;
end;

end.
