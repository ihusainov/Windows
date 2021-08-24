
;-------------------------------------------------------------------
;Windows Registry Editor Version 5.00

;[HKEY_CLASSES_ROOT\appurl]
;@="URL:AutoHotKey AppURL Protocol"
;"URL Protocol"=""

;[HKEY_CLASSES_ROOT\appurl\DefaultIcon]
;@="appurl.exe,1"

;[HKEY_CLASSES_ROOT\appurl\shell]

;[HKEY_CLASSES_ROOT\appurl\shell\open]

;[HKEY_CLASSES_ROOT\appurl\shell\open\command]
;@="\"C:\\Program Files\\AutoHotKeyAppURL\\appurl.exe\" \"%1\""
;-------------------------------------------------------------------

if 0 != 1 ;Check %0% to see how many parameters were passed in
{
    msgbox ERROR: There are %0% parameters. There should be 1 parameter exactly.
}
else
{
    param = %1%  ;Fetch the contents of the command line argument

    appurl := "appurl://" ; This should be the URL Protocol that you registered in the Windows Registry

    IfInString, param, %appurl%
    {
        arglen := StrLen(param) ;Length of entire argument
        applen := StrLen(appurl) ;Length of appurl
        len := arglen - applen ;Length of argument less appurl
        StringRight, param, param, len ; Remove appurl portion from the beginning of parameter
    }

    Run, %param%

}

send ^{f5}
Sleep 10000
send ^{f5}
