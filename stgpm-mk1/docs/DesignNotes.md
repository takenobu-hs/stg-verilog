
Design Notes
------------

# Basic concept
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


# Architecture
  * in-order single issue
  * non pipelined
  * 7 stages
  * 32bit data word
  * N(16?) bit address space
  * byte addressing (little endian like x86)
  * dual word acessible heap
  * dual word acessible stack
  * stack heap serial chain


# Stages
  * stage 0:
    * code address gen
  * stage 1: 
    * fetch code
  * stage 2: 
    * alignment code
  * stage 3: 
    * macro decoder
    * micro decoder
    * branch control
  * stage 4: 
    * register read
    * heap address gen
    * stack access
  * stage 5: 
    * heap access
    * operation
  * stage 6: 
    * register write


# Instructions
  * Macro instructions
    * ap1, ap2, ...
    * alc1, alc2, ...
    * jumpStackTop, ...
    * primop, ...

  * Micro instructions
    * push, pop with stack
    * move registers
    * ld, st with heap
    * primitive operations


# Signal naming rule (general)
  * {block(id)}{stage}_{function}
      block ::= i, d, r, e, m, x, t, g, x
      id    ::= a, b, ...
      stage ::= 0, 1, 2, ... 6
  * example
      i0_inst
      d2_op
      m5_rd_dt


# Abbreviation
  ack    acknowledge
  addr   address
  clk    clock
  cm     static code memory
  cs     chip select
  ctl    control
  dp     datapath
  dst    destination
  dt     data
  en     enable
  fw     forwarding
  hm     heap memory
  imm    immediate
  inst   instruction
  ld     load
  mem    memory
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



