set number
set relativenumber

" puthon stuff
"" show existing tab with 4 spaces width
set tabstop=4
set softtabstop=4
"" On pressing tab, insert 4 spaces
set expandtab
"" when indenting with '>', use 4 spaces width
set shiftwidth=4
"" Automatically indent newlines. That is, if my current line is indented three spaces, and I hit [Enter], I want the next line to automatically be indented three spaces as well.
set autoindent
"" vim recognizes three file formats (unix, dos, mac) that determine what line ending characters (line terminators) are removed from each line when a file is read, or are added to each line when a file is written.
set fileformat=unix

"sugar
""Enable search highlighting.
set hlsearch
""Use an encoding that supports unicode.
set encoding=utf-8
""Enable syntax highlighting.
syntax enable
""Display command line’s tab complete options as a menu.
set wildmenu
""Set the window’s title, reflecting the file currently being edited.
set title
""Use colors that suit a dark background.
set background=dark
