include <pop_vector_block.scad>

/// vector の各要素に対して scalar を乗算
/// @note ( 3, [ 1, 2, 3 ] ) -> [ 3, 6, 9 ]
function multiply_vector( scalar, v, internal_buffer = [ ] ) = 
  len( v ) == 0
    ? internal_buffer
    : multiply_vector( scalar, pop_vector_block( v, len( v ) - 1 ), concat( internal_buffer, [ v[ 0 ] * scalar ] )  )
  ;
