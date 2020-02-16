include <substring_range.scad>

function substring_right( text, length = 0 ) = 
  let( end = len( text ) )
    substring_range( text, end - length, end )
  ;