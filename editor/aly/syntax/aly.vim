if exists('b:current_syntax')
  finish
endif

syntax region alyCommentLine1 start=";" end="$"
syntax region alyCommentLine2 start="#" end="$"

syntax keyword alyPrimitiveTypes
  \ integer

syntax keyword alyKeywords
  \ if
  \ else
  \ ext

syntax match alyOperators "?\|+\|-\|\*\|;\|:\|,\|<\|>\|&\||\|!\|\~\|%\|=\|\.\|/\(/\|*\)\@!"

syntax match alyNumber "\v<\d+>"


highlight default link alyPrimitiveTypes Type
highlight default link alyKeywords       Keyword
highlight default link alyNumber         Number
highlight default link alyCommentLine1   Comment
highlight default link alyCommentLine2   Comment
highlight default link alyOperators      Operator

let b:current_syntax = 'aly'
