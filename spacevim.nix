{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
  (vim_configurable.customize {
        name = "vim";
        vimrcConfig.customRC = ''

        '';

        vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
        vimrcConfig.vam.pluginDictionaries = [
          { names = [
            "vim-gitgutter"
            #dbakker/vim-projectroot
            "vim-easymotion"
            #"github:lokaltog/vim-easymotion"
            # "github:junegunn/fzf.vim"
            # "fzf"
            #junegunn/gv.vim
            "undotree"
            "Syntastic"
            "commentary"
            "vim-eunuch"
            "fugitive"

            #haya14busa/incsearch.vim
            # "vim-leader-guide"
            #osyo-manga/vim-over
            #sheerun/vim-polyglot
            "surround"
            "vinegar"
            #Raimondi/delimitMate




            # "airline"
            # "colors-solarized"
            # "ctrlp"
            # "fugitive"
            # "nerdcommenter"
            # "nerdtree"
            # "rainbow_parentheses"
            # "Tabular"
            # "undotree"
            # "vim-addon-nix"
            # "vimwiki"
            # "youcompleteme"



            ]; }
            #{ name = "github:gmoe/vim-faust"; ft_regex = "^faust\$"; }
            #doesn't work:
            #"vim-addon-local-vimrc"
            #replaced by voom:
            #"VimOutliner"
            #doesn't work:
            #"YankRing"
            #gives error on startup:
            #"UltiSnips"
        ];
      })
  ];
}
