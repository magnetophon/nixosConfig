{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
  (vim_configurable.customize {
        name = "vim";
        vimrcConfig.customRC = ''

" General {
    set nocompatible
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8
    "use system clipboard
    set clipboard=unnamed,unnamedplus
    "automatically switch to the current file directory  when a new buffer is opened
    "autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
    set autochdir                       " sets the working directory to the current file.
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    " {block|insert|all|onemore} sets where the cursor can be positioned when there is no actual character.
    set virtualedit=block,insert,onemore
    set history=1000                    " Store a ton of history (default is 20)
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session

    function! ResCur()
        if line("'\"") <= line("$")
            normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END

    " Setting up the directories {
        set backup                  " Backups are nice ...
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
    "}
"}

" Vim UI {
"use the light solarized theme:
    "colorscheme solarized
    let g:solarized_termcolors=256
    color solarized             " Load a colorscheme
    set background=light
    highlight Normal ctermbg=white
    highlight  LineNr ctermbg=lightgrey ctermfg=None
    " Default Colors for CursorLine
    highlight  CursorLine ctermbg=lightgrey ctermfg=None
    set colorcolumn=80
    highlight ColorColumn ctermbg=lightgrey


    "hybrid line number:
    set number
    set relativenumber

        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode

        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=%{fugitive#statusline()} " Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode
    set cursorline                  " Highlight current line
    set backspace=indent,eol,start  " Backspace for dummies
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set gdefault                    " makes the s% flag global by default. Use /g to turn the global option off.
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" }

" Formatting {

    set wrap                        " Wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F2>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> call StripTrailingWhitespace()

" }

" Key (re)Mappings {

    " The default leader is '\', but many people prefer ',' as it's in a standard
    " location.
    let mapleader = ','

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " End/Start of line motion keys act relative to row/wrap width in the
    " presence of `:set wrap`, and relative to line for `:set nowrap`.
    " Same for 0, home, end, etc
    function! WrapRelativeMotion(key, ...)
        let vis_sel=""
        if a:0
            let vis_sel="gv"
        endif
        if &wrap
            execute "normal!" vis_sel . "g" . a:key
        else
            execute "normal!" vis_sel . a:key
        endif
    endfunction

    " Map g* keys in Normal, Operator-pending, and Visual+select
    noremap $ :call WrapRelativeMotion("$")<CR>
    noremap <End> :call WrapRelativeMotion("$")<CR>
    noremap 0 :call WrapRelativeMotion("0")<CR>
    noremap <Home> :call WrapRelativeMotion("0")<CR>
    noremap ^ :call WrapRelativeMotion("^")<CR>
    " Overwrite the operator pending $/<End> mappings from above
    " to force inclusive motion with :execute normal!
    onoremap $ v:call WrapRelativeMotion("$")<CR>
    onoremap <End> v:call WrapRelativeMotion("$")<CR>
    " Overwrite the Visual+select mode mappings from above
    " to ensure the correct vis_sel flag is passed to function
    vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
    " Stupid shift key fixes
            command! -bang -nargs=* -complete=file E e<bang> <args>
            command! -bang -nargs=* -complete=file W w<bang> <args>
            command! -bang -nargs=* -complete=file Wq wq<bang> <args>
            command! -bang -nargs=* -complete=file WQ wq<bang> <args>
            command! -bang Wa wa<bang>
            command! -bang WA wa<bang>
            command! -bang Q q<bang>
            command! -bang QA qa<bang>
            command! -bang Qa qa<bang>

        cmap Tabe tabe

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    "go to first and last char of line
    nnoremap H ^
    nnoremap L g_
    vnoremap H ^
    vnoremap L g_

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>


"set modeline
" the biggest key for the most used function
noremap <Space> :
" redraw screen, also turn off search highlighting, and reload the
" file if it changed (works in conjunction with `set autoread`)
nnoremap <C-L> :nohlsearch<CR>:redraw<CR>:checktime<CR> <C-L>
"faust
autocmd BufNewFile,BufRead *.dsp set filetype=faust
autocmd BufNewFile,BufRead *.lib set filetype=faust

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

" Automatically jump to end of text you pasted:
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

"Prevent replacing paste buffer on paste:
" vp doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ' '
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()


" }

" Plugins {

  " Fugitive {
            nnoremap <silent> <leader>gs :Gstatus<CR>
            nnoremap <silent> <leader>gd :Gdiff<CR>
            nnoremap <silent> <leader>gc :Gcommit<CR>
            nnoremap <silent> <leader>gb :Gblame<CR>
            nnoremap <silent> <leader>gl :Glog<CR>
            nnoremap <silent> <leader>gp :Git push<CR>
            nnoremap <silent> <leader>gr :Gread<CR>
            nnoremap <silent> <leader>gw :Gwrite<CR>
            nnoremap <silent> <leader>ge :Gedit<CR>
            " Mnemonic _i_nteractive
            nnoremap <silent> <leader>gi :Git add -p %<CR>
            nnoremap <silent> <leader>gg :SignifyToggle<CR>
    "}

    " rainbow_parentheses {
        nnoremap <Leader>r :RainbowParenthesesToggle<CR>
        au Syntax * RainbowParenthesesLoadRound
        au Syntax * RainbowParenthesesLoadSquare
        au Syntax * RainbowParenthesesLoadBraces
    "}

    " Tabularize {
            nmap <Leader>a& :Tabularize /&<CR>
            vmap <Leader>a& :Tabularize /&<CR>
            nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
            vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
            nmap <Leader>a=> :Tabularize /=><CR>
            vmap <Leader>a=> :Tabularize /=><CR>
            nmap <Leader>a: :Tabularize /:<CR>
            vmap <Leader>a: :Tabularize /:<CR>
            nmap <Leader>a:: :Tabularize /:\zs<CR>
            vmap <Leader>a:: :Tabularize /:\zs<CR>
            nmap <Leader>a, :Tabularize /,<CR>
            vmap <Leader>a, :Tabularize /,<CR>
            nmap <Leader>a,, :Tabularize /,\zs<CR>
            vmap <Leader>a,, :Tabularize /,\zs<CR>
            nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
            vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    " }

  " ctrlp {
    let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
  "}


  " UndoTree {
    nnoremap <leader>u :UndotreeToggle<CR>
    nnoremap <Leader>u :UndotreeToggle<CR>
    " If undotree is opened, it is likely one wants to interact with it.
    let g:undotree_SetFocusWhenToggle=1

  "}


    " YouCompleteMe {
            let g:acp_enableAtStartup = 0

            " enable completion from tags
            let g:ycm_collect_identifiers_from_tags_files = 1

            " remap Ultisnips for compatibility for YCM
            let g:UltiSnipsExpandTrigger = '<C-j>'
            let g:UltiSnipsJumpForwardTrigger = '<C-j>'
            let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

            " Enable omni completion.
            autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
            autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
            autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
            autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
            autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
            autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
            autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

            " Haskell post write lint and check with ghcmod
            " $ `cabal install ghcmod` if missing and ensure
            " ~/.cabal/bin is in your $PATH.
            if !executable("ghcmod")
                autocmd BufWritePost *.hs GhcModCheckAndLintAsync
            endif

            " For snippet_complete marker.
                    set conceallevel=2 concealcursor=i

            " Disable the neosnippet preview candidate window
            " When enabled, there can be too much visual noise
            " especially when splits are used.
            set completeopt-=preview
    " }

    " vim-airline {
        " Set configuration options for the statusline plugin vim-airline.
        " Use the powerline theme and optionally enable powerline symbols.
        " To use the symbols , , , , , , and .in the statusline
        " segments add the following to your .vimrc.before.local file:
        "   let g:airline_powerline_fonts=1
        " If the previous symbols do not render for you then install a
        " powerline enabled font.

        " See `:echo g:airline_theme_map` for some more choices
        " Default in terminal vim is 'dark'
                "let g:airline_theme = 'solarized'
        " Automatically displays all buffers when there's only one tab open.
            let g:airline#extensions#tabline#enabled = 1

    " }

" }

        " Specify a different directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories, add the following to
        set backupdir=~/.vim/backup//
        set directory=~/.vim/swap//
        set undodir=~/.vim/undo//

    " Strip whitespace {
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    " }





"writes current mappings to a file
redir! > ~/.vim/vim_keys.txt
silent verbose map
redir END

        '';

        vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
        vimrcConfig.vam.pluginDictionaries = [
          { names = [
            "airline"
            "colors-solarized"
            "ctrlp"
            "fugitive"
            "nerdcommenter"
            "nerdtree"
            "rainbow_parentheses"
            "Tabular"
            "undotree"
            "vim-addon-nix"
            "VimOutliner"
            "vimwiki"
            "youcompleteme"
            ]; }
            #{ name = "github:gmoe/vim-faust"; ft_regex = "^faust\$"; }
        ];
      })
  ];
}
