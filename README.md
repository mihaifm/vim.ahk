Supported commands:
===========

Esc
i
I
v

visual mode
    h j k l
    numeric multipliers (except 0) 
    >
    <

normal mode
    {motion}
        h j k l
        numeric multipliers
        w                           //limited: word boundaries
        0                   
        ^
        $
 
    d{motion}
    dd
    D
    
    y{motion}                       
    yy                              //limited: moves cursor
    Y

    c{motion}
    cc                              //limited: doesn't preserve indentation
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

    o                               //limited: no multipliers
    O

    u

    x
    X                               //limited: deletes beginning of line

    J                               //limited: does work with indentation

    >>

    <<                              //limited: deletes everything, not just indentation

registers
    named: a-z, A-Z
    numbered: 0, 1, 2-9
    blackhole: _

