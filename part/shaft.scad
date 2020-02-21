include <pipe.scad>

module shaft
( diameter
, length
// --- optional detail level-1 ( highest )
, chamfering_angle  = 45
, chamfering_length = 0
, chamfering_type   = "C"

// --- optional for detail level-0 ( lowest )
, top_chamfering_angle      = [ ]
, bottom_chamfering_angle   = [ ]
, top_chamfering_length     = [ ]
, bottom_chamfering_length  = [ ]
, top_chamfering_type       = [ ]
, bottom_chamfering_type    = [ ]
)
{
  let
  ( top_chamfering_angle      = top_chamfering_angle      > 0 ? top_chamfering_angle      : chamfering_angle
  , bottom_chamfering_angle   = bottom_chamfering_angle   > 0 ? bottom_chamfering_angle   : chamfering_angle
  , top_chamfering_length     = top_chamfering_length     > 0 ? top_chamfering_length     : chamfering_length
  , bottom_chamfering_length  = bottom_chamfering_length  > 0 ? bottom_chamfering_length  : chamfering_length
  , top_chamfering_type       = top_chamfering_type       > 0 ? top_chamfering_type       : chamfering_type
  , bottom_chamfering_type    = bottom_chamfering_type    > 0 ? bottom_chamfering_type    : chamfering_type
  )
    pipe
    ( 0
    , diameter
    , length

    , inner_bottom_chamfering_angle   = 0
    , inner_top_chamfering_angle      = 0
    , inner_bottom_chamfering_length  = 0
    , inner_top_chamfering_length     = 0
    , inner_bottom_chamfering_type    = [ ]
    , inner_top_chamfering_type       = [ ]

    , outer_bottom_chamfering_angle   = top_chamfering_angle
    , outer_top_chamfering_angle      = bottom_chamfering_angle
    , outer_bottom_chamfering_length  = top_chamfering_length
    , outer_top_chamfering_length     = bottom_chamfering_length
    , outer_bottom_chamfering_type    = top_chamfering_type
    , outer_top_chamfering_type       = bottom_chamfering_type
    );
}
