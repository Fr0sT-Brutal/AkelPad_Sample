        (*****************************************
            Sample plugin for AkelPad editor
                         © Fr0sT

         *****************************************)

{
 IN PROGRESS:
   ---

 TO DO:
   ---

 ???
   ---
}

library Sample;

{$R 'MainIcon.res' 'MainIcon.rc'}
{$R *.RES}

uses
  Windows, Messages, SysUtils,
  AkelDLL_h in '#AkelDefs\AkelDLL_h.pas',
//  AkelEdit_h in '#AkelDefs\AkelEdit_h.pas',
  Lang in 'Lang.pas';

// Global constants

const
  PluginName: AnsiString = 'Sample';

type
  // internal data and structures

  TAkelData = record
    hMainWnd,        // main Akel window
    hEditWnd: HWND;  // current editor window
  end;

// Interface

  // ... dialog classes ...

// Global variables

var
  AkelData: TAkelData;
  AkelParams: TAkelParams;

{$REGION 'SERVICE FUNCTIONS'}

type
  TMsgBoxIcon = (iNone, iStop, iQstn, iWarn, iInfo);

// Show message box with standard caption, given text, icon and OK button
procedure MsgBox(const Txt: string; Icon: TMsgBoxIcon = iNone);
const
  MsgBoxIconFlags: array[TMsgBoxIcon] of UINT =
    (0, MB_ICONHAND, MB_ICONQUESTION, MB_ICONEXCLAMATION, MB_ICONASTERISK);
var
  hwndParent: HWND;
begin
  hwndParent := AkelData.hMainWnd;
  // show the box, don't care about the result
  MessageBox(hwndParent, PChar(Txt), PChar(string(PluginName) + ' plugin'), MB_OK + MsgBoxIconFlags[Icon]);
end;

{$ENDREGION}

{$REGION 'SUPPORT PLUGIN FUNCTIONS'}

// initialize stuff with given PLUGINDATA members
procedure Init(var pd: TPLUGINDATA);
begin
  AkelData.hMainWnd := pd.hMainWnd;
  AkelData.hEditWnd := pd.hWndEdit;

  SetCurrLang(PRIMARYLANGID(pd.wLangModule));

  AkelParams.Init(Pointer(pd.lParam));
end;

// cleanup
procedure Finish;
begin
  // ... free resources here ...
end;

{$ENDREGION}

{$REGION 'EXPORTED PLUGIN FUNCTIONS'}

// Identification (required)
procedure DllAkelPadID(var pv: TPLUGINVERSION); cdecl;
begin
  pv.dwAkelDllVersion := AkelDLL;
  pv.dwExeMinVersion3x := MakeIdentifier(-1, -1, -1, -1);
  pv.dwExeMinVersion4x := MakeIdentifier(4, 7, 0, 0);
  pv.pPluginName := PAnsiChar(PluginName);
end;

// *** Optional functions ***

procedure Main(var pd: TPLUGINDATA); cdecl;
var fnname: string;
begin
  // Function doesn't support autoload
  pd.dwSupport := pd.dwSupport or PDS_NOAUTOLOAD;
  // Flag is set if caller wants to get PDS_* flags without function execution.
  // It is NOT a real call!
  if (pd.dwSupport and PDS_GETSUPPORT) <> 0 then
    Exit;

  // Init stuff
  Init(pd);

  // Do main job here
  fnname := Format(LangString(idFuncName), [string(PluginName), 'Main']);

  if AkelParams.Count = 0 then
    MsgBox(Format(LangString(idMsgFnWasCalled), [fnname, LangString(idParamNone)]), iInfo)
  else
    MsgBox(Format(LangString(idMsgFnWasCalled), [fnname, Format(LangString(idParamPresent), [AkelParams.ParamStr(0)])]), iInfo);

  // Cleanup
  Finish;
end;

procedure Err(var pd: TPLUGINDATA); cdecl;
var fnname: string;
begin
  // Function supports only Unicode
  pd.dwSupport := pd.dwSupport or PDS_NOANSI;
  if (pd.dwSupport and PDS_GETSUPPORT) <> 0 then
    Exit;

  // Init stuff
  Init(pd);

  fnname := Format(LangString(idFuncName), [string(PluginName), 'Err']);

  if AkelParams.Count = 0 then
    MsgBox(Format(LangString(idMsgNoParam), [fnname]), iWarn)
  else
    MsgBox(fnname + #13#10 + AkelParams.ParamStr(0), iStop);
end;

procedure Warn(var pd: TPLUGINDATA); cdecl;
var fnname: string;
begin
  // Function supports only Unicode
  pd.dwSupport := pd.dwSupport or PDS_NOANSI;
  if (pd.dwSupport and PDS_GETSUPPORT) <> 0 then
    Exit;

  // Init stuff
  Init(pd);

  fnname := Format(LangString(idFuncName), [string(PluginName), 'Warn']);

  if AkelParams.Count = 0 then
    MsgBox(Format(LangString(idMsgNoParam), [fnname]), iWarn)
  else
    MsgBox(fnname + #13#10 + AkelParams.ParamStr(0), iWarn);
end;

{$ENDREGION}

exports
  DllAkelPadID,
  Main,
  Err,
  Warn;

begin
end.
