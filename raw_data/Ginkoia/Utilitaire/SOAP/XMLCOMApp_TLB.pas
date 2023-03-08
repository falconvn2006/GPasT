unit XMLCOMApp_TLB;

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

// PASTLWTR : 1.2
// File generated on 31/12/2002 16:33:25 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files\e-delos\Projects\ComPubs\ComServer\ComServer.tlb (1)
// LIBID: {67BD2CB5-C76E-4E7F-8AB3-FF326E0393FB}
// LCID: 0
// Helpfile: 
// HelpString: XMLCOMApp Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WRITEABLECONST ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  XMLCOMAppMajorVersion = 1;
  XMLCOMAppMinorVersion = 0;

  LIBID_XMLCOMApp: TGUID = '{67BD2CB5-C76E-4E7F-8AB3-FF326E0393FB}';

  IID_IXMLCOMApp: TGUID = '{276BBE89-6FA0-40DD-BAB4-54940E55CBC9}';
  CLASS_XMLCOMApp: TGUID = '{B833CA83-BDD7-451A-9768-2E022FF22DEA}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IXMLCOMApp = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  XMLCOMApp = IXMLCOMApp;


// *********************************************************************//
// Interface: IXMLCOMApp
// Flags:     (256) OleAutomation
// GUID:      {276BBE89-6FA0-40DD-BAB4-54940E55CBC9}
// *********************************************************************//
  IXMLCOMApp = interface(IUnknown)
    ['{276BBE89-6FA0-40DD-BAB4-54940E55CBC9}']
    function Invoke(const SoapRequest: WideString): WideString; stdcall;
  end;

// *********************************************************************//
// The Class CoXMLCOMApp provides a Create and CreateRemote method to          
// create instances of the default interface IXMLCOMApp exposed by              
// the CoClass XMLCOMApp. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoXMLCOMApp = class
    class function Create: IXMLCOMApp;
    class function CreateRemote(const MachineName: WideString): IXMLCOMApp;
  end;

implementation

uses ComObj;

class function CoXMLCOMApp.Create: IXMLCOMApp;
begin
  Result := CreateComObject(CLASS_XMLCOMApp) as IXMLCOMApp;
end;

class function CoXMLCOMApp.CreateRemote(const MachineName: WideString): IXMLCOMApp;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XMLCOMApp) as IXMLCOMApp;
end;

end.
