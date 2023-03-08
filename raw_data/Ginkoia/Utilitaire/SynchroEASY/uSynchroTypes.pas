unit uSynchroTypes;

interface

Uses  Windows, Messages, SysUtils, Variants, Classes, StdCtrls, magwmi, magsubs1, Registry,
      ShellAPi,inifiles,Tlhelp32, WinSvc,Forms, StrUtils, IOUtils,ServiceControler, Controls,
      FireDAC.Comp.Client,IdText, IdFTP, IdFTPCommon, IdExplicitTLSClientServerBase, IdAllFTPListParsers,
      IdBaseComponent, IdComponent, IdRawBase, IdRawClient, IdIcmpClient,Vcl.ComCtrls,
      IdHashMessageDigest, idHash,ShlObj;

type
  TStatusMessageCall = Procedure (const info:String) of object;

implementation

end.
