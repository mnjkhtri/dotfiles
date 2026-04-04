" Shared Obsidian Vim config.
" Requires built-in Vim mode plus the community plugin: obsidian-vimrc-support

let mapleader = " "

" Exit insert mode with the same muscle memory as VS Code Vim.
imap kj <Esc>

" Move by visual lines, not wrapped logical lines.
nmap j gj
nmap k gk

" Keep common line motions ergonomic.
nmap H ^
nmap L $

" Clear search highlighting quickly.
nmap <leader>h :nohl<CR>

" Match common navigation habits from the plugin's supported examples.
exmap back obcommand app:go-back
nmap <C-o> :back<CR>
exmap forward obcommand app:go-forward
nmap <C-i> :forward<CR>

" Useful Obsidian-specific motions and actions.
exmap save obcommand editor:save-file
nmap <leader>w :save<CR>
exmap cmd obcommand app:open-command-palette
nmap <leader>p :cmd<CR>
