
Design Notes
============

Basic concept
-------------
  * model
    * subset of STG abstract machine
    * referencing GHC's STG concrete implementation
    * single thread
    * no hardware GC
    * no floating point

  * implementation
    * simple hardware
    * low performance (low throughput, latency, frequency)
    * semantics oriented macro instructions
    * accessible from outside
    * synthesizable (potentially)


Architecture
------------
  * basic
    * in-order single issue
    * non pipelined
    * 7 stages
    * 32bit data word

  * memory/addressing
    * N(16?) bit address space
    * byte addressing (little endian like x86)
    * dual word accessible heap
    * dual word accessible stack
    * stack-heap serial chain
    * address mapping for registers, heap and stack
    * info-table access (T.B.D.)

  * system
    * system call/exception (T.B.D.)


Stages
------
  * stage 1:
    * code address gen
  * stage 2: 
    * fetch code
  * stage 3: 
    * alignment code
  * stage 4: 
    * macro decoder
    * micro decoder
    * branch control
  * stage 5: 
    * register read
    * heap address gen
    * stack access
  * stage 6: 
    * heap access
    * operation
  * stage 7: 
    * register write


Instructions
------------
  * Macro instructions
    * ap1, ap2, ...
    * aloc1, aloc2, ...
    * enter, jumpStackTop, ...
    * primop, ...

  * Micro instructions
    * push, pop with stack
    * move registers
    * ld, st with heap
    * primitive operations


Instruction mapping
-------------------
  * basic
    * variable length 1 to 4
    * map all 0 to nop (or halt)
    * represent info-table with nop
    * fast branch decoding

  * mapping
    * {length}{macro/micro}{...}


Signal naming rule (general)
----------------------------
```
  * {block(id)}{stage}_{function}
    * block ::= i, d, r, e, m, x, t, g, x
    * id    ::= a, b, ...
    * stage ::= 0, 1, 2, ... 6
  * example
      i0_inst
      d2_op
      m5_rd_dt
```


Abbreviation
------------
```
  ack    acknowledge
  adrs   address
  asc    access
  clk    clock
  cm     static code memory
  cs     chip select
  ctl    control
  dp     datapath
  dst    destination
  dt     data
  en     enable
  ev     even
  fw     forwarding
  hm     heap memory
  imm    immediate
  inst   instruction
  ld     load
  mem    memory
  od     odd
  op     operation
  pc     program counter
  rd     read
  re     read enable
  reg    register
  req    request
  rst    reset
  sel    select
  sm     stack memory
  src    source
  st     store
  vld    valid
  we     write enable
  wt     write
```


Performance issue of STG
------------------------
  * longest-path: read stack (top) -> read heap (info-ptr) -> jump to code
  * to store multi words to heap (aligned to dual word?)
  * to store multi words to stack
  * pre address modification of Hp


References
----------
  * STG
    * https://ghc.haskell.org/trac/ghc/wiki/Commentary/Rts/HaskellExecution
    * https://ghc.haskell.org/trac/ghc/wiki/Commentary/Compiler/StgSynType
    * https://ghc.haskell.org/trac/ghc/wiki/Commentary/Rts/Storage/HeapObjects
    * https://ghc.haskell.org/trac/ghc/wiki/Commentary/Compiler/GeneratedCode
    * https://github.com/quchen/stgi
