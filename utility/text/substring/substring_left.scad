include <substring_range.scad>

function substring_left( text, length = 0 ) = 
  substring_range( text, 0, length )
  ;