include <Cherry_MX.scad>
include <../../../../utility/vector/concat_without_duplication.scad>

/// @note UHMWPE:=Ultra High Molecular Weight Polyethylene 超高分子量ポリエチレン は材料名がそのまま製品名にもついているぱたーんです。
///       やや特徴的でこれはこれで有用そうな気がしたので形状だけは再現しやすく用意してみました。(おおよその形状はスカートの背面部の無い Cherry MX Red です)
///       材料まで本物で作るのは素人どころか玄人でも難しいです。
/// @ref https://invyr.com/products/invyr-uhmwpe-linear-stems-110-pack
reference_switch_parameters_Invyr_UHMWPE_Linear = 
  [ [ "Invyr UHMWPE Linear"
    , concat_without_duplication
      ( reference_switch_parameters_Cherry_MX_Red[ 0 ][ 1 ]
      , [ [ "stem_skirt_height", [ 6.40, 0.00, 5.00 ] ]
        , [ "stem_color", to_RGB_from_HSL( [ 0, 1, 1 ] ) ]
        ]
      )
    ]
  ];
