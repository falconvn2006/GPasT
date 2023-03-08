unit DAC_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision: 1$
// File generated on 22/12/1999 00:05:11 from Type Library described below.

// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
// ************************************************************************ //
// Type Lib: D:\Data\Delphi\Tools\Dac\DAC.tlb (1)
// IID\LCID: {22C1B806-8E17-11D3-B903-0080AD98A915}\0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\STDOLE2.TLB)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses Windows, ActiveX, Classes, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  DACMajorVersion = 1;
  DACMinorVersion = 0;

  LIBID_DAC: TGUID = '{22C1B806-8E17-11D3-B903-0080AD98A915}';

  IID_IDacDatabase: TGUID = '{22C1B807-8E17-11D3-B903-0080AD98A915}';
  IID_IDacQuery: TGUID = '{22C1B809-8E17-11D3-B903-0080AD98A915}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IDacDatabase = interface;
  IDacDatabaseDisp = dispinterface;
  IDacQuery = interface;
  IDacQueryDisp = dispinterface;

// *********************************************************************//
// Interface: IDacDatabase
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {22C1B807-8E17-11D3-B903-0080AD98A915}
// *********************************************************************//
  IDacDatabase = interface(IDispatch)
    ['{22C1B807-8E17-11D3-B903-0080AD98A915}']
    procedure Close; safecall;
    procedure Commit; safecall;
    function  GetConnected: WordBool; safecall;
    procedure Open; safecall;
    procedure Rollback; safecall;
    procedure SetParams(const Value: WideString); safecall;
    procedure StartTransaction; safecall;
    function  GetInstance: Integer; safecall;
    function  GetTableNames: WideString; safecall;
    function  GetIndexDefs(const Table: WideString): WideString; safecall;
    function  GetFieldDefs(const Table: WideString): WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  IDacDatabaseDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {22C1B807-8E17-11D3-B903-0080AD98A915}
// *********************************************************************//
  IDacDatabaseDisp = dispinterface
    ['{22C1B807-8E17-11D3-B903-0080AD98A915}']
    procedure Close; dispid 1610743808;
    procedure Commit; dispid 1610743809;
    function  GetConnected: WordBool; dispid 1610743810;
    procedure Open; dispid 1610743811;
    procedure Rollback; dispid 1610743812;
    procedure SetParams(const Value: WideString); dispid 1610743813;
    procedure StartTransaction; dispid 1610743814;
    function  GetInstance: Integer; dispid 1610743815;
    function  GetTableNames: WideString; dispid 1610743816;
    function  GetIndexDefs(const Table: WideString): WideString; dispid 1610743817;
    function  GetFieldDefs(const Table: WideString): WideString; dispid 1610743818;
  end;

// *********************************************************************//
// Interface: IDacQuery
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {22C1B809-8E17-11D3-B903-0080AD98A915}
// *********************************************************************//
  IDacQuery = interface(IDispatch)
    ['{22C1B809-8E17-11D3-B903-0080AD98A915}']
    procedure Close; safecall;
    procedure ExecSQL; safecall;
    function  EOF: WordBool; safecall;
    function  FieldCount: Integer; safecall;
    function  GetActive: WordBool; safecall;
    function  GetFieldAsString(const FieldName: WideString): WideString; safecall;
    function  GetFieldName(Index: Integer): WideString; safecall;
    function  GetFieldNoAsString(Index: Integer): WideString; safecall;
    function  GetParamName(Index: Integer): WideString; safecall;
    function  GetParamAsString(const ParamName: WideString): WideString; safecall;
    function  GetParamNoAsString(Index: Integer): WideString; safecall;
    procedure Next; safecall;
    procedure Open; safecall;
    function  ParamCount: Integer; safecall;
    procedure Prepare; safecall;
    function  Prepared: WordBool; safecall;
    procedure SetDatabase(const Database: IDacDatabase); safecall;
    procedure SetFieldAsString(const FieldName: WideString; const Value: WideString); safecall;
    procedure SetFieldNoAsString(Index: Integer; const Value: WideString); safecall;
    procedure SetParamAsString(const ParamName: WideString; const Value: WideString); safecall;
    procedure SetParamNoAsString(Index: Integer; const Value: WideString); safecall;
    procedure SetSQL(const Value: WideString); safecall;
    procedure SetParamTypeNo(Index: Integer; const Value: WideString); safecall;
    procedure SetParamType(const ParamName: WideString; const Value: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IDacQueryDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {22C1B809-8E17-11D3-B903-0080AD98A915}
// *********************************************************************//
  IDacQueryDisp = dispinterface
    ['{22C1B809-8E17-11D3-B903-0080AD98A915}']
    procedure Close; dispid 1610743808;
    procedure ExecSQL; dispid 1610743809;
    function  EOF: WordBool; dispid 1610743810;
    function  FieldCount: Integer; dispid 1610743811;
    function  GetActive: WordBool; dispid 1610743812;
    function  GetFieldAsString(const FieldName: WideString): WideString; dispid 1610743813;
    function  GetFieldName(Index: Integer): WideString; dispid 1610743814;
    function  GetFieldNoAsString(Index: Integer): WideString; dispid 1610743815;
    function  GetParamName(Index: Integer): WideString; dispid 1610743816;
    function  GetParamAsString(const ParamName: WideString): WideString; dispid 1610743817;
    function  GetParamNoAsString(Index: Integer): WideString; dispid 1610743818;
    procedure Next; dispid 1610743819;
    procedure Open; dispid 1610743820;
    function  ParamCount: Integer; dispid 1610743821;
    procedure Prepare; dispid 1610743822;
    function  Prepared: WordBool; dispid 1610743823;
    procedure SetDatabase(const Database: IDacDatabase); dispid 1610743824;
    procedure SetFieldAsString(const FieldName: WideString; const Value: WideString); dispid 1610743825;
    procedure SetFieldNoAsString(Index: Integer; const Value: WideString); dispid 1610743826;
    procedure SetParamAsString(const ParamName: WideString; const Value: WideString); dispid 1610743827;
    procedure SetParamNoAsString(Index: Integer; const Value: WideString); dispid 1610743828;
    procedure SetSQL(const Value: WideString); dispid 1610743829;
    procedure SetParamTypeNo(Index: Integer; const Value: WideString); dispid 1;
    procedure SetParamType(const ParamName: WideString; const Value: WideString); dispid 2;
  end;

implementation

uses ComObj;

end.


