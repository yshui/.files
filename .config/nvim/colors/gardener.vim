" Vim color file
" Original Maintainer: Anders Korte <anderskorte@eml.cc>

"    Modified: by entheon <jazzworksweb@yahoo.com>
" Last Change: 13 Sept 2005

" Gardener v1.1
" A modification of the Guardian colorscheme v1.2

"   'For code surgeons and web gardeners everywhere'

" A nice earthy  color scheme which is easy on  the eyes. It
" has  as it's  base a  dark background  monocrhomatic khaki
" scheme with dabs of color thrown  in here and there on the
" keywords. Plus  lots of  extra config  options so  you can
" tweak  it to  your liking  and or  make it  more like  the
" original Guardian scheme. All the defaults are what I like
" but if you want to change stuff just set the right var and
" it will change pretty much  immediately, you might have to
" move out of and back into your buffer for it to refresh.


" Features:
"   256 Color XTerm Compatibility
"   Richer Syntax
"   Black Background
"   Functions
"   No Italics
"   Purple Booleans
"   Swapped Status Line Colors
"   Other minor tweaks

" Change Log:
"   changed the  ghastly puke  salmon red  to green  like it
"   should have been in the  first place esp considering the
"   name  Gardener, now  all  vimsters can  truly frolic  in
"   their Vim Gardens

" Options:
"   g:gardener_light_comments
"       if  this var  exists then  comments are  white on  a
"       gray-blue  background  if it  is  not  set then  the
"       comments default  to medium grey with  no background
"       color, I can't stand bg colors but some people might
"       like it, so I left it as an option.
"
"   g:gardener_soil
"       This  is a  GUI  only option  because  there are  no
"       colors that work  even in the 256  color XTerm. This
"       option gives you a  brownish background instead of a
"       black background. I think the black background gives
"       better contrast and thus is  easier to read from. if
"       you disagree then you've got this option
"
"   g:gardener_setnum
"       turns the background of the line numbers black

" Using The Options:
"       To enable a feature add the line
"           let g:gardenter_some_feature=1
"       to your ~/.vimrc 
"       To disable the feature temporarily run the command
"           :unlet g:gardener_some_feature
"       To  disable the  feature permanently,  simply remove
"       the line from your .vimrc file.

set background=dark
hi clear
syntax reset

" Colors for the User Interface.
if exists("g:gardener_setnum")
    hi linenr       guibg=black       guifg=#808080    gui=bold     cterm=BOLD   ctermfg=235   ctermbg=244
else
    hi linenr       guibg=#262626     guifg=#808080    gui=bold     cterm=BOLD   ctermfg=244   ctermbg=235
endif

hi Cursor           guibg=#cc4455     guifg=white      gui=bold     cterm=BOLD   ctermfg=255   ctermbg=167
hi link CursorIM Cursor
hi Normal           guibg=gray15          guifg=white      gui=none     cterm=NONE   ctermfg=white ctermbg=none
hi NonText          guibg=gray10     guifg=#ffeecc    gui=bold     cterm=NONE   ctermfg=230   ctermbg=none
hi Visual           guibg=#557799     guifg=white      gui=none     cterm=NONE   ctermfg=255   ctermbg=68

hi Directory        guibg=bg          guifg=#337700    gui=none     cterm=NONE   ctermfg=222    ctermbg=NONE

hi IncSearch        guibg=#0066cc     guifg=white      gui=none     cterm=NONE   ctermfg=255   ctermbg=25
hi link Seach IncSearch

hi SpecialKey       guibg=bg          guifg=fg         gui=none 
hi Titled           guibg=bg          guifg=fg         gui=none 

hi ErrorMsg         guibg=bg          guifg=#ff0000    gui=bold     cterm=BOLD   ctermfg=196   ctermbg=NONE
hi ModeMsg          guibg=bg          guifg=#ffeecc    gui=none     cterm=NONE   ctermfg=230   ctermbg=NONE
hi link MoreMsg ModeMsg
hi Question         guibg=bg          guifg=#ccffcc    gui=bold        cterm=NONE   ctermfg=194   ctermbg=NONE
hi link WarningMsg ErrorMsg

hi StatusLineNC     guibg=#ffeecc	  guifg=black	   gui=none    cterm=NONE   ctermfg=16    ctermbg=229
hi StatusLine       guibg=#cc4455	  guifg=white	   gui=bold      cterm=BOLD   ctermfg=255   ctermbg=167
hi VertSplit        guibg=#ffeecc	  guifg=black	   gui=none       cterm=NONE   ctermfg=16    ctermbg=229

hi DiffAdd          guibg=#446688     guifg=fg	       gui=none         cterm=NONE   ctermfg=255   ctermbg=60
hi DiffChange       guibg=#558855     guifg=fg	       gui=none         cterm=NONE   ctermfg=255   ctermbg=none
hi DiffDelete       guibg=#884444     guifg=fg	       gui=none         cterm=NONE   ctermfg=255   ctermbg=95
hi DiffText         guibg=#884444     guifg=fg	       gui=bold         cterm=BOLD   ctermfg=255   ctermbg=95

" Colors for Syntax Highlighting.
if exists("g:gardener_light_comments")
    hi Comment          guibg=#334455     guifg=#dddddd    gui=none         cterm=NONE   ctermfg=253   ctermbg=60
else
    hi Comment          guibg=bg          guifg=#888888    gui=none            cterm=NONE   ctermfg=244   ctermbg=NONE
endif


hi Define	        guibg=bg          guifg=#66ccdd    gui=bold    cterm=BOLD   ctermfg=147  ctermbg=NONE
hi Conditional      guibg=bg          guifg=#aadd55    gui=bold    cterm=BOLD   ctermfg=149  ctermbg=NONE

hi Constant         guibg=bg          guifg=white      gui=bold  cterm=BOLD   ctermfg=255  ctermbg=NONE
hi Identifier       guibg=bg          guifg=#ffddaa    gui=none  cterm=NONE   ctermfg=223  ctermbg=NONE       
hi String           guibg=bg          guifg=#ffffcc    gui=none  cterm=NONE   ctermfg=230  ctermbg=0x202020   
hi Character        guibg=bg          guifg=#ffffcc    gui=bold  cterm=BOLD   ctermfg=230  ctermbg=NONE       
hi Number           guibg=bg          guifg=#bbddff    gui=bold  cterm=BOLD   ctermfg=153  ctermbg=NONE       
hi Boolean          guibg=bg          guifg=#ff55ff    gui=bold  cterm=NONE   ctermfg=207  ctermbg=NONE       
hi Float            guibg=bg          guifg=#bbddff    gui=bold  cterm=BOLD   ctermfg=153  ctermbg=NONE       

hi Function         guibg=bg          guifg=#ffffaa    gui=bold  cterm=BOLD   ctermfg=229  ctermbg=NONE       
hi Statement        guibg=bg          guifg=#ffffcc    gui=bold  cterm=BOLD   ctermfg=230  ctermbg=NONE       

hi Repeat           guibg=bg          guifg=#ff9900    gui=bold  cterm=BOLD   ctermfg=208  ctermbg=NONE       
hi Label            guibg=bg          guifg=#ffccff    gui=bold  cterm=BOLD   ctermfg=225  ctermbg=NONE       
hi Operator         guibg=bg          guifg=#cc9966    gui=bold  cterm=BOLD   ctermfg=173  ctermbg=NONE       
hi Keyword          guibg=bg          guifg=#66ffcc    gui=bold  cterm=BOLD   ctermfg=86   ctermbg=NONE       
hi Exception        guibg=bg          guifg=#66ffcc    gui=bold  cterm=BOLD   ctermfg=86   ctermbg=NONE       

hi PreProc	        guibg=bg          guifg=#ffcc99    gui=bold            cterm=BOLD   ctermfg=222   ctermbg=NONE
hi Include	        guibg=bg          guifg=#99cc99    gui=bold            cterm=BOLD   ctermfg=114   ctermbg=NONE
hi link Macro Include
hi link PreCondit Include

hi Type		        guibg=bg	      guifg=#ccffaa    gui=bold     cterm=BOLD   ctermfg=193   ctermbg=NONE
hi Structure	    guibg=bg	      guifg=#99ff99    gui=bold             cterm=BOLD   ctermfg=114   ctermbg=NONE
hi Typedef	        guibg=bg	      guifg=#99cc99    gui=italic           cterm=BOLD   ctermfg=114   ctermbg=NONE

hi StorageClass	    guibg=bg	      guifg=#99cc99    gui=bold             cterm=BOLD   ctermfg=78    ctermbg=NONE
hi Special	        guibg=bg	      guifg=#bbddff	   gui=bold         cterm=BOLD   ctermfg=153   ctermbg=NONE
hi SpecialChar	    guibg=bg	      guifg=#bbddff	   gui=bold         cterm=BOLD   ctermfg=153   ctermbg=NONE
hi Tag		        guibg=bg	      guifg=#bbddff	   gui=bold cterm=BOLD   ctermfg=153   ctermbg=NONE     
hi Delimiter	    guibg=bg	      guifg=fg	       gui=bold             cterm=BOLD   ctermfg=255   ctermbg=NONE
hi SpecialComment   guibg=#334455     guifg=#dddddd	   gui=italic               cterm=BOLD   ctermfg=253   ctermbg=24
hi Debug	        guibg=bg          guifg=#ff9999	   gui=none                 cterm=NONE   ctermfg=210   ctermbg=NONE

hi Underlined       guibg=bg          guifg=#99ccff    gui=underline

hi Title            guibg=#445566     guifg=white	   gui=bold                cterm=BOLD   ctermfg=255   ctermbg=60
hi Ignore           guibg=bg	      guifg=#cccccc    gui=italic          cterm=NONE   ctermfg=251   ctermbg=NONE
hi Error            guibg=#ff0000     guifg=white	   gui=bold                cterm=NONE   ctermfg=255   ctermbg=196
hi Todo	            guibg=#556677     guifg=#ff0000    gui=bold            cterm=NONE   ctermfg=196   ctermbg=60

hi htmlH1           guibg=bg          guifg=#ffffff    gui=bold         cterm=BOLD   ctermfg=255   ctermbg=NONE
hi htmlH2           guibg=bg          guifg=#dadada    gui=bold         cterm=BOLD   ctermfg=253   ctermbg=NONE
hi htmlH3           guibg=bg          guifg=#c6c6c6    gui=bold         cterm=BOLD   ctermfg=251   ctermbg=NONE
hi htmlH4           guibg=bg          guifg=#b2b2b2    gui=bold         cterm=BOLD   ctermfg=249   ctermbg=NONE
hi htmlH5           guibg=bg          guifg=#9e9e9e    gui=bold         cterm=BOLD   ctermfg=247   ctermbg=NONE
hi htmlH6           guibg=bg          guifg=#8a8a8a    gui=bold         cterm=BOLD   ctermfg=245   ctermbg=NONE
hi Pmenu            guifg=gray15
hi Linear           cterm=NONE   ctermfg=248   ctermbg=NONE


let g:colors_name = "gardener"
let colors_name   = "gardener"
autocmd FileType c,cpp,javascript highlight ExtraWhitespace ctermbg=red guibg=red
autocmd FileType c,cpp,javascript match ExtraWhitespace /\s\+$/
hi ColorColumn ctermbg=red

hi Variable    cterm=BOLD   ctermfg=210 ctermbg=NONE guifg=White guibg=NONE
hi Member      ctermfg=117 ctermbg=NONE guifg=#005f00
