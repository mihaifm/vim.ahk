### Description

**Vim.ahk** is a script that attempts to mimic Vim commands inside Windows applications. 

The script is experimental and only supports a small subset of Vim commands.

**[Demo](http://www.youtube.com/watch?v=z8sj_t23n_s)**

### Usage

Vim.ahk was created with [Autohotkey_L](http://l.autohotkey.net/).

In order to use it, install [Autohotkey_L](http://l.autohotkey.net/), then run the **vim.ahk** file.

Alternativelly, run **vim.ahk.exe**, which is a compiled version of the script. This does not require [Autohotkey_L](http://l.autohotkey.net/) to be installed.

### Modes

Vim.ahk supports the following modes:

* Suspended 

In this mode the script does nothing. To activate the script, press the <kbd>F12</kbd> key.     
This key can be easily changed within the script (just search for F12 and replace it with the key of you choice).   
Other good candidates are: CapsLock, F8 or the ContextMenu key. 

* Normal
* Insert
* Visual

Regular Vim modes.

By default, the script starts in Suspended mode. It remembers the mode for each individual window, so each window will have it's own mode.

### Supported commands

    Esc
    i
    I
    v

    normal mode
        {motion}
            h j k l
            numeric multipliers
            w                           
            0                   
            ^
            $
 
        d{motion}
        dd
        D
        
        y{motion}                       
        yy                              
        Y

        c{motion}
        cc                              
        C

        p
        
        s
        S

        a
        A

        b

        e

        n                              
        N

        o                               
        O

        u

        x
        X                               

        J                               

        >>

        <<                              

    visual mode
        h j k l
        numeric multipliers (except 0) 
        >
        <

    registers
        named: a-z, A-Z
        numbered: 0, 1, 2-9
        blackhole: _

### Limitations

    w - word boundaries
    yy - moves cursor
    cc - doesn't preserve indentation
    o - no multipliers
    X - deletes beginning of line
    << - deletes everything, not just indentation







