;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; config options

config := {}
config.shiftwidth := 4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; globals

SetWorkingDir %A_ScriptDir%
window_states := {}
Read2ini() ;Read ini from vim.ini , to remenber windows_state when script Reload

normal := {}
normal.on := true
normal.action := ""
normal.repeat := ""
normal.motion := ""
normal.multiplier := ""
normal.ar_count := 0
normal.mr_count := 0

insert := {}
insert.on := false

visual := {}
visual.on := false
visual.action := ""
visual.repeat := ""
visual.motion := ""
visual.multiplier := ""
visual.ar_count := 0
visual.mr_count := 0

reg := {}
reg.on := false
reg.current := ""
reg.append := false

__pmode := "suspended"
__mode := "suspended"

temp := {}
temp.caret := {}
temp.caret.x := 0
temp.caret.y := 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; window handling

; start suspended
Mode("suspended")
Suspend On

SetTitleMatchMode RegEx 

; Shell hook that suspends the script when a new window gets focus
; (to prevent accidental usage)
Gui +LastFound 
hWnd := WinExist()
DllCall( "RegisterShellHookWindow", UInt, Hwnd )
MsgNum := DllCall( "RegisterWindowMessage", Str, "SHELLHOOK" )
OnMessage( MsgNum, "ChangeState" )
Return

ChangeState(wParam, lParam )
{
    global window_states
    global title
	global titleStr
	title := lParam
	IfNotInString,titleStr,%title%
		titleStr := titleStr "." title
	;ToolTip % titleStr
    ;WinGetTitle title, ahk_id %lParam%
    ;if (wParam=4) ;HSHELL_WINDOWACTIVATED
    ;{ 
        if (!window_states[title] || window_states[title] == "suspended") 
        {
            Suspend On
            window_states[title] := "suspended"
        }
        else
        {
            Suspend Off
        }
        Mode(window_states[title])
    ;}
}

; Toggle script 
F12::
#u::
    global window_states
    global title
    Suspend Toggle
    if (!window_states[title] || window_states[title] == "suspended")
    {
        Mode("n")
    }
    else
    {
        Mode("suspended")
    }
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Hotkeys

#UseHook On

Esc::
    Mode("n")
    Clear()
return

i::
    if (insert.on) 
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "i"
        reg.on := false
        return
    }
    if (normal.on)
    {
        Mode("i")
    }
return

+I::
    if (insert.on) 
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "i"
        reg.on := false
        reg.append := true
        return
    }
    if (normal.on)
    {
        Mode("i")
        Send {Home}
    }
return

v::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := A_ThisHotKey
        reg.on := false
        return
    }
    if (normal.on)
    {
        Mode("v")
    }
return

+V::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := A_ThisHotKey
        reg.on := false
        reg.append := false
        return
    }
return

"::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "unnamed"
        reg.on := false
        return
    }

    if (normal.on || visual.on)
    {
        if (!reg.on)
            reg.on := true
    }
return

; ++::
; +*::
;     if (insert.on)
;         Send %A_ThisHotKey%
; 
;     if (reg.on)
;     {
;         reg.current := "selection"
;         reg.on := false
;         return
;     }
; return

+_::
   if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "blackhole"
        reg.on := false
        return
    } 
return

h::
j::
k::
l::
   if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := A_ThisHotKey
        reg.on := false
        return
    }

    if (normal.on)
    {
        if (NAction()) 
        {
            normal.motion := A_ThisHotKey 
            DoNormalCommand()
        }
        else
        {
            normal.action := A_ThisHotKey
            DoNormalCommand()
        }
    }
    if (visual.on)
    {
        visual.action := A_ThisHotKey
        DoVisualCommand()
    }
return

+H::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "h"
        reg.on := false
        reg.append := true
        return
    }
return

+J::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "j"
        reg.on := false
        reg.append := true
        return
    }
    if (normal.on)
    {
        if (!NAction())
        {
            normal.action := A_ThisHotKey
        }
        DoNormalCommand()
    }
return

+K::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "k"
        reg.on := false
        reg.append := true
        return
    }
return

+L::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "l"
        reg.on := false
        reg.append := true
        return
    }
return

1::
2::
3::
4::
5::
6::
7::
8::
9::
    if (reg.on)
    {
        reg.current := "n" . A_ThisHotKey
        reg.on := false
        return
    }
    if (normal.on)
    {
        if (NAction())
        {
            normal.multiplier := A_ThisHotKey
            normal.mr_count := normal.mr_count * 10 + A_ThisHotKey
        }
        else
        {
            normal.repeat := A_ThisHotKey
            normal.ar_count := normal.ar_count * 10 + A_ThisHotKey 
        }
    }
    if (visual.on)
    {
        if (VAction())
        {
            visual.multiplier := A_ThisHotKey
            visual.mr_count := visual.mr_count * 10 + A_ThisHotKey
        }
        else
        {
            visual.repeat := A_ThisHotKey
            visual.ar_count := visual.ar_count * 10 + A_ThisHotKey 
        }
    }

    if (insert.on) 
        Send %A_ThisHotKey%
return

0::
    if (insert.on) 
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "n" . A_ThisHotKey
        reg.on := false
        return
    }

    if (normal.on) 
    {
        if (NAction()) 
        {
            if (normal.mr_count > 0)
            {
                normal.mr_count := normal.mr_count * 10
            }
            else
            {
                normal.motion := "0"
                DoNormalCommand()
            }
        }
        else
        {
            if (normal.ar_count > 0)
            {
                normal.ar_count := normal.ar_count * 10 
            }
            else
            {
                normal.action := "0"
                DoNormalCommand()
            }
        }
    }
return

+6::
    if (insert.on)
        Send %A_ThisHotKey%

    if (normal.on)
    {
        if (NAction()) 
        {
            normal.motion := "+6"
            DoNormalCommand()
        }
        else
        {
            normal.action := "+6"
            DoNormalCommand()
        }
    }
return

+4::
    if (insert.on)
        Send %A_ThisHotKey%

    if (normal.on)
    {
        if (NAction())
        {
            normal.motion := "+4"
            DoNormalCommand()
        }
        else
        {
            normal.action := "+4"
            DoNormalCommand()
        }
    }
return

d::
    if (insert.on) 
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "d"
        reg.on := false
        return
    }

    if (normal.on) 
    {
        if (NAction())
        {
            normal.motion := "d"
            DoNormalCommand()
        }
        else
        {
            normal.action := "d"
        }
    }
return

+D::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "d"
        reg.on := false
        reg.append := true
        return
    }

    if (normal.on)
    {
        if (!NAction())
        {
            normal.action := "+D"
        }
        DoNormalCommand()
    }
return

+C::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "c"
        reg.on := false
        reg.append := true
        return
    }

    if (normal.on)
    {
        if (!NAction())
        {
            normal.action := "+C"
        }
        DoNormalCommand()
    }
return

c::
    if (insert.on) 
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "c"
        reg.on := false
        return
    }

    if (normal.on) 
    {
        if (NAction())
        {
            normal.motion := "c"
            DoNormalCommand()
        }
        else
        {
            normal.action := "c"
        }
    }
return

s::
+S::
    if (insert.on)
        Send %A_ThisHotkey%

    if (reg.on)
    {
        reg.current := "s"
        reg.on := false
        reg.append := (A_ThisHotKey != "s")
        return
    }
    if (normal.on)
    {
        if (!NAction())
        {
            normal.action := A_ThisHotkey
        }
        DoNormalCommand()
    }
return

y::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "y"
        reg.on := false
        return
    }
    
    if (normal.on)
    {
        if (NAction())
        {
            normal.motion := "y"
            DoNormalCommand()
        }
        else
        {
            normal.action := "y"
        }
    }
return

+Y::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "y"
        reg.on := false
        reg.append := true
        return
    }

    if (normal.on)
    {
        if (!NAction())
        {
            normal.action := "+Y"
        }
        DoNormalCommand()
    }
return

p::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := A_ThisHotKey
        reg.on := false
        return
    }

    if (normal.on && !NAction())
    {
        normal.action := "p"
        DoNormalCommand()
    }
    if (visual.on && !VAction())
    {
        visual.action := "p"
        DoVisualCommand()
    }
return

+P::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := A_ThisHotKey
        reg.on := false
        reg.append := true
        return
    }

    if (normal.on && !NAction())
    {
        normal.action := A_ThisHotkey 
        DoNormalCommand()
    }
return

+W::
w::
    if (reg.on)
    {
        reg.current := A_ThisHotKey
        reg.on := false
        reg.append := (A_ThisHotKey != "w")
        return
    }

    if (normal.on)
    {
        if (NAction()) {
            normal.motion := "w"
            DoNormalCommand()
        }
        else
        {
            normal.action := "w"
            DoNormalCommand()
        }
    }

    if (insert.on)
        Send %A_ThisHotKey%
return

a::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := A_ThisHotKey
        reg.on := false
        return
    }

    if (normal.on)
    {
        if (NAction())
        {
            ; TODO
        }
        else
        {
            normal.action := "a"
            DoNormalCommand()
        }
    }
return

+A::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "a"
        reg.on := false
        reg.append := true
        return
    }

    if (normal.on)
    {
        if (!NAction())
        {
            normal.action := "+A"
            DoNormalCommand()
        }
    }
return

b::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := A_ThisHotKey
        reg.on := false
        return
    }

    if (normal.on)
    {
        if (NAction())
        {
            ; TODO
        }
        else
        {
            normal.action := "b"
            DoNormalCommand()
        }
    }
return

+B::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "b"
        reg.on := false
        reg.append := true
        return
    }

    if (normal.on)
    {
        if (NAction())
        {
            ; TODO
        }
        else
        {
            normal.action := "b"
            DoNormalCommand()
        }
    }
return

e::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "e"
        reg.on := false
        return
    }

    if (normal.on)
    {
        if (NAction())
        {
            ; TODO
        }
        else
        {
            normal.action := "e"
            DoNormalCommand()
        }
    }
return

+E::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "e"
        reg.on := false
        reg.append := true
        return
    }

    if (normal.on)
    {
        if (NAction())
        {
            ; TODO
        }
        else
        {
            normal.action := "e"
            DoNormalCommand()
        }
    }
return

f::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "f"
        reg.on := false
        return
    }
return

+F::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "f"
        reg.on := false
        reg.append := true
        return
    }
return

g::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "g"
        reg.on := false
        return
    }
return

+G::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "g"
        reg.on := false
        reg.append := true
        return
    }
return

m::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "m"
        reg.on := false
        return
    }
return

+M::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "m"
        reg.on := false
        reg.append := true
        return
    }
return

n::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "n"
        reg.on := false
        return
    }
    if (normal.on)
    {
        Send {F3}
    }
return

+N::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "n"
        reg.on := false
        reg.append := true
        return
    }
    if (normal.on)
    {
        Send +{F3}
    }
return

o::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "o"
        reg.on := false
        return
    }
    if (normal.on)
    {
        if (!NAction())
        {
            normal.action := "o"
        }
        DoNormalCommand()
    }
return

+O::
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "O"
        reg.on := false
        reg.append := true
        return
    }
    if (normal.on)
    {
        if (!NAction())
        {
            normal.action := A_ThisHotKey
        }
        DoNormalCommand()
    }
return

q::
+Q:: 
    if (insert.on)
        Send %A_ThisHotKey%

    if (reg.on)
    {
        reg.current := "q"
        reg.on := false
        reg.append := (A_ThisHotKey != "q")
        return
    }
return

t::
+T::
    if (insert.on)
        Send %A_ThisHotKey%
    
    if (reg.on)
    {
        reg.current := "t"
        reg.on := false
        reg.append := (A_ThisHotKey != "t")
        return
    } 
return

u::
    if (insert.on)
        Send %A_ThisHotKey%
    
    if (reg.on)
    {
        reg.current := "u"
        reg.on := false
        return
    }
    if (normal.on)
    {
        normal.action := "u"
        DoNormalCommand()
    }
return

+U::
    if (insert.on)
        Send %A_ThisHotKey%
    
    if (reg.on)
    {
        reg.current := "u"
        reg.on := false
        reg.append := true
        return
    }
return

x::
    if (insert.on)
        Send %A_ThisHotKey%
    
    if (reg.on)
    {
        reg.current := "x"
        reg.on := false
        return
    }
    if (normal.on)
    {
        if (!NAction())
        {
            normal.action := "x"
        }
        DoNormalCommand()
    }
return

+X::
    if (insert.on)
        Send %A_ThisHotKey%
    
    if (reg.on)
    {
        reg.current := "x"
        reg.on := false
        reg.append := true
        return
    }
    if (normal.on)
    {
        if (!NAction())
        {
            normal.action := "+X"
        }
        DoNormalCommand()
    }
return

z::
+Z::
    if (insert.on)
        Send %A_ThisHotKey%
    
    if (reg.on)
    {
        reg.current := "z"
        reg.on := false
        reg.append := (A_ThisHotKey != "z")
        return
    }
return

+>::
    if (insert.on)
        Send %A_ThisHotKey%

    if (normal.on)
    {
        if (NAction())
        {
            normal.motion := A_ThisHotKey
            DoNormalCommand()
        }
        else
        {
            normal.action := A_ThisHotKey
        }
    }
    if (visual.on)
    {
        visual.action := A_ThisHotKey
        DoVisualCommand()
    }
return

+<::
    if (insert.on)
        Send %A_ThisHotKey%

    if (normal.on)
    {
        if (NAction())
        {
            normal.motion := A_ThisHotKey
            DoNormalCommand()
        }
        else
        {
            normal.action := A_ThisHotKey
        }
    }
    if (visual.on)
    {
        visual.action := A_ThisHotKey
        DoVisualCommand()
    }
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Normal mode command processing 

DoNormalCommand()
{
    global 

    enter_insert := false

    if (normal.ar_count == 0)
        normal.ar_count := 1
    if (normal.mr_count == 0)
        normal.mr_count := 1

    total_count := normal.ar_count * normal.mr_count

    if (normal.action == "x")
    {
        normal.action := "d"
        normal.motion := "l"
    }
    if (normal.action == "+X")
    {
        normal.action := "d"
        normal.motion := "h"
    }
    if (normal.action == "+S")
    {
        normal.action := "c"
        normal.motion := "c"
    }

    if (normal.action == "s")
    {
        normal.action := "c"
        normal.motion := "l"
    }
    
    if (normal.action == "c")
    {
        normal.action := "d"
        enter_insert := true
    }

    if (normal.motion == "c")
    {
        normal.motion := "d"
    }

    if (normal.action == "+C")
    {
        normal.action := "+D"
        enter_insert := true
    }

    if (normal.action == "+D")
    {
        normal.action := "d"
        normal.motion := "+4"
    }

    if (normal.action == "+Y")
    {
        normal.action := "y"
        normal.motion := "+4"
    }

    if (normal.action == "d")
    {
        if (normal.motion = "w")
        {
            Loop % total_count
            {
                Send ^+{Right}
            }
            Send +{Right}
            Send ^x
            StoreClipboard()
        }
        if (normal.motion == "0")
        {
            Send +{End}+{Home}+{Home}^x
            StoreClipboard()
        }
        if (normal.motion == "+6")
        {
            Send +{End}+{Home}^x
            StoreClipboard()
        }
        if (normal.motion == "+4")
        {
            Send +{End}
            Loop % total_count - 1
            {
                Send +{Down}
            }
            Send +{End}^x
            StoreClipboard()
        }
        if (normal.motion == "h")
        {
            Loop % total_count
            {
                Send +{Left}
            }
            Send ^x
            StoreClipboard()
        }
        if (normal.motion == "l")
        {
            Loop % total_count
            {
                Send +{Right}
            }
            Send ^x
            StoreClipboard()
        }
        if (normal.motion == "j")
        {
            Send {Home}  
            Loop % total_count
            {
                Send +{Down}
            }
            Send +{End}^x
            StoreClipboard()
            Send {Home}{Backspace}
        }
        if (normal.motion == "k")
        {
            Send {End}  
            Loop % total_count
            {
                Send +{Up}
            }
            Send +{Home}^x
            StoreClipboard()
            Send {Home}{Backspace}
        }
        if (normal.motion == "d")
        {
            Send {End}

            ; detect indentation lines
            Clipboard := ""
            Send +{Home}^c

            hasindent := RegExMatch(Clipboard, "^[\t ]+$")

            if (hasindent)
                Send {Home}{Home}
            else
                Send {Home}

            Loop % total_count - 1
            {
                Send +{Down}
            }
            Send +{End}^c
            Clipboard := "`n" . Clipboard

            StoreClipboard()

            isempty := RegExMatch(Clipboard, "^$")

            if ((isempty || Clipboard == "") && (total_count == 1))
            {
                if (!enter_insert)
                    Send {Backspace}
            }
            else
            {
                Send {Backspace}
                if (!enter_insert)
                   Send {Backspace} 
            }

            if (!enter_insert)
               Send {Down}{Home} 
        }
    }

    if (normal.action == "y")
    {
        if (normal.motion == "w")
        {
            
            Loop % total_count
            {
                Send ^+{Right}
            }
            Send +{Right}
            Send ^c
            StoreClipboard()
            Send {Left}
        }
        if (normal.motion == "0")
        {
            Send +{End}+{Home}+{Home}^c
            StoreClipboard()
            Send {Right}
        }
        if (normal.motion == "+6")
        {
            Send +{End}+{Home}^c
            StoreClipboard()
            Send {Right}
        }
        if (normal.motion == "+4")
        {
            Send +{End}
            Loop % total_count - 1
            {
                Send +{Down}
            }
            Send +{End}^c
            StoreClipboard()
            Send {Left}
        }
        if (normal.motion == "h")
        {
            Loop % total_count
            {
                Send +{Left}
            }
            Send ^c{Right}
            StoreClipboard()
        }
        if (normal.motion == "l")
        {
            Loop % total_count
            {
                Send +{Right}
            }
            Send ^c{Left}
            StoreClipboard()
        }
        if (normal.motion == "j")
        {
            Send {Home}  
            Loop % total_count
            {
                Send +{Down}
            }
            Send +{End}^c{Left}
            StoreClipboard()
        }
        if (normal.motion == "k")
        {
            Send {End}  
            Loop % total_count
            {
                Send +{Up}
            }
            Send +{Home}^c{Right}{Home}
            StoreClipboard()
        }
        if (normal.motion == "y")
        {
            Send {Home}  
            Loop % total_count - 1
            {
                Send +{Down}
            }
            Send +{End}^c{Left}

            Clipboard := "`n" . Clipboard

            StoreClipboard()
        }
    }

    if (normal.action == "w")
    {
        Loop % total_count
        {
            Send ^{Right}
        }
    }

    if (normal.action == "0")
    {
        Send {End}{Home}{Home}
    }

    if (normal.action == "+6")
    {
        Send {End}{Home}
    }

    if (normal.action == "+4")
    {
        Send {End}
    }

    if (normal.action == "h")
    {
        Loop % total_count
        {
            Send {Left}
        }
    }
    if (normal.action == "j")
    {
        Loop % total_count
        {
            Send {Down}
        }
    }
    if (normal.action == "k")
    {
        Loop % total_count
        {
            Send {Up}
        }
    }
    if (normal.action == "l")
    {
        Loop % total_count
        {
            Send {Right}
        }
    }
    if (normal.action == "p")
    {
        RestoreClipboard()

        tempos := InStr(Clipboard, "`n")

        if (tempos == 1) ;first character
            Send {End}

        Loop % total_count
        {
            Send ^v
        }
    }
    if (normal.action == "a")
    {
        Send {Right}
        enter_insert := true
    }
    if (normal.action == "+A")
    {
        Send {End}
        enter_insert := true
    }
    if (normal.action == "b")
    {
        Loop % total_count
        {
            Send ^{Left}
        }
    }
    if (normal.action == "e")
    {
        Loop % total_count
        {
            Send ^+{Right}
        }
        Send {Right}
    }
    if (normal.action == "o")
    {
        Send {End}{Enter}
        enter_insert := true
    }
    if (normal.action == "+O")
    {
        Send {Home}{Enter}{Up}
        enter_insert := true
    }
    if (normal.action == "u")
    {
        Send ^z
        ; TODO - better implementation that takes into account extra backspaces
    }
    if (normal.action == "+J")
    {
        Loop % total_count
        {
            ; TODO - this is very limited right now
            Send {End}{Down}{Home}{Home}{Backspace}
        }
    }
    if (normal.action == "+>")
    {
        if (normal.motion == "+>")
        {
            Loop % total_count
            {
                Send {Home}{Home}
                Loop % config.shiftwidth 
                {
                    Send {Space}
                }

                if (A_Index < total_count)
                    Send {Down}
            }
        }
    }
    if (normal.action == "+<")
    {
        if (normal.motion == "+<")
        {
            Loop % total_count
            {
                Send {Home}{Home}
                Loop % config.shiftwidth 
                {
                    Send {Delete}
                }

                if (A_Index < total_count)
                    Send {Down}
            }
        }
    }

    if (enter_insert)
        Mode("i")

    Clear()
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Visual mode command processing

DoVisualCommand()
{
    global

    if (visual.ar_count == 0)
        visual.ar_count := 1
    if (visual.mr_count == 0)
        visual.mr_count := 1

    total_count := visual.ar_count * visual.mr_count

    if (visual.action == "h")
    {
        Loop % total_count
        {
            Send +{Left}
        }
    }
    if (visual.action == "j")
    {
        Loop % total_count
        {
            Send +{Down}
        }
    }
    if (visual.action == "k")
    {
        Loop % total_count
        {
            Send +{Up}
        }
    }
    if (visual.action == "l")
    {
        Loop % total_count
        {
            Send +{Right}
        }
    }
    if (visual.action == "p")
    {
        RestoreClipboard()
        Loop % total_count
        {
            Send ^v
        }
    }
    if (visual.action == "+>")
    {
        lines := CountVisualLines()

        Send {Left}
        Loop % lines
        {
            Send {Home}{Home}
            Loop % config.shiftwidth
            {
                Send {Space}
            }

            if (A_Index < lines)
                Send {Down}
        }

        Mode("n")
        return
    }
    if (visual.action == "+<")
    {
        lines := CountVisualLines()

        Send {Left}
        Loop % lines
        {
            Send {Home}{Home}
            Loop % config.shiftwidth
            {
                Send {Delete}
            }

            if (A_Index < lines)
                Send {Down}
        }

        Mode("n")
        return
    }

    Clear()
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clipboard handling

StoreClipboard()
{
    global

    if (reg.current == "")
    {   
        reg.current := "unnamed"
    }
    
    if (reg.current == "blackhole")
    {
        Clipboard := ""
        return
    }

    if (reg.append)
        reg[reg.current] := reg[reg.current] . Clipboard
    else
        reg[reg.current] := Clipboard

    if (normal.action == "y" || visual.action == "y")
    {
        reg.current := "n0"
        reg[reg.current] := Clipboard
    }
    if (normal.action == "d" || visual.action == "d")
    {
        ;shift registers
        Loop 
        {
            if (A_Index < 2)
                continue

            temp1 := "n" . (10 - A_Index)
            temp2 := "n" . (10 - A_Index - 1)

            reg[temp1] := reg[temp2]

            if (A_Index == 8)
                break
        }

        reg.current := "n1"
        reg[reg.current] := Clipboard
    }
}

RestoreClipboard()
{
    global

    if (reg.current == "")
        reg.current := "unnamed"

    Clipboard := reg[reg.current]
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Cleanup

Clear()
{
    global

    normal.action := ""
    normal.repeat := ""
    normal.motion := ""
    normal.multiplier := ""

    normal.ar_count := 0
    normal.mr_count := 0

    visual.action := ""
    visual.repeat := ""
    visual.motion := ""
    visual.multiplier := ""

    visual.ar_count := 0
    visual.mr_count := 0

    reg.on := false
    reg.append := false
    reg.current := ""
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helper methods

NAction()
{
    global normal
    return normal.action != ""
}

VAction()
{
    global visual
    return visual.action != ""
}

Mode(param)
{
    global 
    if (param)
    {
        __pmode := window_states[title] 
        __mode := param
        window_states[title] := param
    }

    if (__mode == "suspended")
    {
        ChangeIcon("suspended")    
    }

    if (__mode == "i")
    {
        insert.on := true
        visual.on := false
        normal.on := false
        
        ChangeIcon("i") 
    }

    if (__mode == "n")
    {
        insert.on := false
        visual.on := false
        normal.on := true
        
        ChangeIcon("n")
    }

    if (__mode == "v")
    {
        insert.on := false
        visual.on := true
        normal.on := false

        ChangeIcon("v")
    }

    Clear()
	Write2ini() ; Write window_states 2 ini
    return __mode
}

ChangeIcon(mode)
{
    if (FileExist("icons/" . mode . ".ico"))
        Menu Tray, Icon, % "icons/" . mode . ".ico",, 1
}

SaveCaretPos()
{
    global
    temp.caret.x := A_CaretX
    temp.caret.y := A_CaretY
}

CountVisualLines()
{
    global
    clipbkp := Clipboard

    Clipboard := ""
    Send ^c

    cliprep := RegExReplace(Clipboard, "\R", "", NumRepl)
    Clipboard := clipbkp

    return (NumRepl + 1)
}

Write2ini() ; Write window_states 2 ini
{
	global
	StringSplit,titleArray,titleStr,.,
	Loop % titleArray0
	{
		key2ini := titleArray%a_index%
		if key2ini = 
			continue
		value2ini := window_states[key2ini] 
		;ToolTip  key2ini - %key2ini% `nvalue2ini - %value2ini%
		IniWrite,%value2ini%,vim.ini,iniStr,%key2ini%
	}
}

Read2ini() ;Read ini from vim.ini , to remenber windows_state when script Reload
{
	IniRead, iniStr, vim.ini, iniStr,
	StringSplit,iniArray,iniStr,`n,
	Loop % iniArray0
	{
		StringSplit, tempArray, iniArray%A_Index%, =,
		window_states[tempArray1]:= tempArray2
	}
}
