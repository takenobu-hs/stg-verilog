
Design Notes
------------

# Basic concept
  * model
    * subset of STG abstract machine
    * referencing GHC's STG concrete implementation
    * single thread
    * no hardware GC

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
  * N bit address space
  * byte addressing (little endian like x86)


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
    * (stack access)
  * stage 5: 
    * heap access
    * operation
    * (stack access)
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


# Signale nameing rule (general)
  * {block}_{stage}_{function}


# Abbreviation
  ack    acknouledge
  addr   address
  clk    clock
  cs     chip select
  ctl    control
  dp     datapath
  dst    destination
  fw     forwarding
  imm    immediate
  inst   instruction
  mem    memory
  op     operation
  pc     program counter
  rd     read
  re     read enable
  reg    register
  req    request
  rst    reset
  sel    select
  src    source
  vld    valid
  we     write enable
  wt     write



