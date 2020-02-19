include <pop_vector_block.scad>

function translate_vector( translation, v, internal_buffer = [ ] ) = 
  len( v ) == 0
    ? internal_buffer
    : translate_vector( translation, pop_vector_block( v, len( v ) - 1 ), concat( internal_buffer, [ v[ 0 ] + translation ] )  )
  ;
