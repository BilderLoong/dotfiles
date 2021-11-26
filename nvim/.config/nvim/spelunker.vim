" Turn off Vim's spell as it highlights the same words. source: https://github.com/kamykn/spelunker.vim
	set nospell

	" Highlight type: (default: 1)
	" 1: Highlight all types (SpellBad, SpellCap, SpellRare, SpellLocal).
	" 2: Highlight only SpellBad.
	" FYI: https://vim-jp.org/vimdoc-en/spell.html#spell-quickstart
let g:spelunker_highlight_type = 2
let g:enable_spelunker_vim = 1
