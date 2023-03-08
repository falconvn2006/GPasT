unit GlobalVar;

interface
uses
 MyTypes,Chartext,vect,plin;
var
 Error:           boolean;
 Fname:            string;
 MyTime:          extended;
 f:              TextFile;
 myf:              MyText;
 flag:             my_int;
 now_iter:         my_int;
 now_run:          my_int;
 max_iter:         my_int;
// my_chain:          chain;
 tur_sell_n:       my_int;
 code_array:      p_arr_2;
 Vector_for_coding_genotypes: vector;
 max_size_buf:        pls;
 det_cost:            pls;
 revenue:      a_function;
 alloc_cost:   a_function;
 amort:           my_real;
 inv_coef:        my_real;
 result:         textfile;
 help:           textfile;
implementation

end.

