if exists("b:current_syntax")
  finish
endif

syn keyword miteKeywords afn fn if while loop until else break continue
syn match miteRef "\(ro\|nom\)\=\(&\|\^\)\="
syn keyword miteBuiltinTypes auto num bool string
syn keyword miteConstants true false
syn match miteNumber display "\<[0-9][0-9_]*"
syn match miteOperator display "\%(+\|-\|/\|*\|=\|\^\|&\||\|!\|>\|<\|%\)=\?"
syn match miteOperator display "&&\|||"
syn region miteString start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=miteEscape,@Spell
syn match miteEscape display contained /\\\([nrt0\\'"]\|x\x\{2}\)/

hi def link miteRef StorageClass
hi def link miteKeywords Keyword
hi def link miteBuiltinTypes Type
hi def link miteConstants Constant
hi def link miteNumber Number
hi def link miteOperator Operator
hi def link miteString String
hi def link miteEscape Special
