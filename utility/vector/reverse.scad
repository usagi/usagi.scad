include <shift_vector.scad>
include <pop_vector_block.scad>

/// vector を逆順で取得
/// @param v 逆順にしたい元の vector
/// @param internal_buffer 内部バッファー ( 明示的に引数として与える必要はありません )
function reverse( v, internal_buffer = [ ] ) = 
  len( v ) == 0
    ? internal_buffer
    : reverse(  shift_vector( v, len( v ) - 1 ) , concat( internal_buffer, pop_vector_block( v, 1 ) ) )
  ;
