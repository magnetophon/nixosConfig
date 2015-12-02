{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
  (vim_configurable.customize {
        name = "vim";
        vimrcConfig.customRC = ''
set hidden
syntax on
filetype on
set mouse=a
set expandtab
set smarttab
set autoindent
set smartindent
set smartcase
set ignorecase
"set modeline
set mouse=a
set nocompatible
set encoding=utf-8
set incsearch
set hlsearch
set colorcolumn=80
"use system clipboard
set clipboard+=unnamedplus
"turn of spell-check
set nospell
" expand a tab to x spaces
set expandtab
" the biggest key for the most used function
noremap <Space> :
" redraw screen, also turn off search highlighting, and reload the 
" file if it changed (works in conjunction with `set autoread`)
nnoremap <C-L> :nohlsearch<CR>:redraw<CR>:checktime<CR> <C-L>
"faust
autocmd BufNewFile,BufRead *.dsp set filetype=faust
autocmd BufNewFile,BufRead *.lib set filetype=faust

set pastetoggle=<F2>

" <!----------------------------" gcc compile C files----------------------------------------!>
autocmd filetype c nnoremap <F5> :w <CR>:!gcc % -o %:r && ./%:r<CR>

" <!----------------------------" faust compile files----------------------------------------!>
autocmd filetype faust nnoremap <F5> :w <CR>:!faust2jack -osc % &&  ./%   <CR>
"autocmd filetype faust nnoremap <F6> :w <CR>:!faust2jack -osc % &&  ./%  & sleep 1 && jack_disconnect %:out_0 system:playback_1 && jack_disconnect %:out_1 system:playback_2 && jack_connect %:out_0 ardour:insert\ 1/audio_return\ 1 && jack_connect %:out_1 ardour:insert\ 1/audio_return\ 2 && jack_connect %:in_0 ardour:insert\ 1/audio_send\ 1 && jack_connect %:in_1 ardour:insert\ 1/audio_send\ 2 <CR>
autocmd filetype faust nnoremap <F7> :w <CR>:!faust2firefox % <CR>

"buffer navigation:
nmap <silent> <Left> :bp<CR>
nmap <silent> <Right> :bn<CR>

"center search results on the screen
nnoremap <silent> N Nzz
nnoremap <silent> n nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz


"hybrid line number:
set number
set relativenumber

"writes current mappings to a file
redir! > ~/.vim/vim_keys.txt
silent verbose map
redir END

"use the light solarized theme:
colorscheme solarized
set background=light
        '';
        vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
        vimrcConfig.vam.pluginDictionaries = [
          { names = [
            "airline"
            "colors-solarized"
            "ctrlp"
            "nerdcommenter"
            "nerdtree"
            "rainbow_parentheses"
            "Tabular"
            "undotree"
            "vim-addon-nix"
            "youcompleteme"
            ]; }
            #{ name = "github:gmoe/vim-faust"; ft_regex = "^faust\$"; }
        ];
      })
  ];
}
