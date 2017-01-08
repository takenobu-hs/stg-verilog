

// `timescale 1ns / 100ps


/* basic configuration */
`define SP1_BYTE_BITS            8
`define SP1_WORD_ABITS           2
`define SP1_WORD_WIDTH          (`SP1_BYTE_BITS << `SP1_WORD_ABITS)
`define SP1_WORD_BYTES          (`SP1_WORD_WIDTH / `SP1_BYTE_BITS)

/* heap configuration */
`define SP1_HEAP_ABITS          12
`define SP1_HEAP_BYTES          (1<<`SP1_HEAP_ABITS)
`define SP1_HEAP_WORDS          (`SP1_HEAP_BYTES / `SP1_WORD_BYTES)

