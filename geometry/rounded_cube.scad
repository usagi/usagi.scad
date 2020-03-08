module rounded_cube( size, radius = 0, center = false )
{
  let
  ( center = 
    [ center == true || center[ 0 ]
    , center == true || center[ 1 ]
    , center == true || center[ 2 ]
    ]
  )
  translate
  ( [ center[ 0 ] ? -size[ 0 ] / 2 + radius : radius
    , center[ 1 ] ? -size[ 1 ] / 2 + radius : radius
    , center[ 2 ] ? -size[ 2 ] / 2 + radius : radius
    ]
  )
    minkowski()
    {
      cube( size - [ radius, radius, radius ] * 2 );
      sphere( r = radius );
    }
}