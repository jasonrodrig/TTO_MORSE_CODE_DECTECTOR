`define no_of_items 5
// ---------signals-----------//
`define dot        3'b001
`define dash       3'b010
`define char_space 3'b011
`define word_space 3'b100
//------alphabets (a-z)-------//
`define a {`dot, `dash}
`define b {`dash, `dot, `dot, `dot}
`define c {`dash, `dot, `dash, `dot}
`define d {`dash, `dot, `dot}
`define e {`dot}
`define f {`dot, `dot, `dash, `dot}
`define g {`dash, `dash, `dot}
`define h {`dot, `dot, `dot, `dot}
`define i {`dot, `dot}
`define j {`dot, `dash, `dash, `dash}
`define k {`dash, `dot, `dash}
`define l {`dot, `dash, `dot, `dot}
`define m {`dash, `dash}
`define n {`dash, `dot}
`define o {`dash, `dash, `dash}
`define p {`dot, `dash, `dash, `dot}
`define q {`dash, `dash, `dot, `dash}
`define r {`dot, `dash, `dot}
`define s {`dot, `dot, `dot}
`define t {`dash}
`define u {`dot, `dot, `dash}
`define v {`dot, `dot, `dot, `dash}
`define w {`dot, `dash, `dash}
`define x {`dash, `dot, `dot, `dash}
`define y {`dash, `dot, `dash, `dash}
`define z {`dash, `dash, `dot, `dot}
//-------Numbers (0–9)---------//
`define zero  {`dash, `dash, `dash, `dash, `dash}
`define one   {`dot,  `dash, `dash, `dash, `dash}
`define two   {`dot,  `dot,  `dash, `dash, `dash}
`define three {`dot,  `dot,  `dot,  `dash, `dash}
`define four  {`dot,  `dot,  `dot,  `dot,  `dash}
`define five  {`dot,  `dot,  `dot,  `dot,  `dot}
`define six   {`dash, `dot,  `dot,  `dot,  `dot}
`define seven {`dash, `dash, `dot,  `dot,  `dot}
`define eight {`dash, `dash, `dash, `dot,  `dot}
`define nine  {`dash, `dash, `dash, `dash, `dot}

