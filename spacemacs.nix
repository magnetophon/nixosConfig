{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ## The Big Show
    emacs
    emacs24Packages.cask

    silver-searcher

    ## Emacs helpers
    ghostscript
    poppler_utils

    ## Documentation
    zeal

    gtk-engine-murrine


    ## Flyspell
    aspell
    aspellDicts.en

    ## Magit
    git

    ## Misc
    opencv

    ## Lang
    ### Javascript
    nodejs
    npm2nix
    ### Python
    python27
    python27Packages.pip
    python27Packages.setuptools
    python27Packages.ipython
    python27Packages.numpy
  ];

  nixpkgs.config.packageOverrides = pkgs: rec {
    emacs = pkgs.emacs.overrideDerivation (args: rec {
      withGTK3 = true;
      withGTK2 = false;
      pythonPath = [];
      buildInputs = with pkgs; (args.buildInputs ++
      [
        makeWrapper
        python
        python27Packages.setuptools
        python27Packages.pip
        python27Packages.ipython
        python27Packages.numpy
      ]);

      postInstall = with pkgs.python27Packages; (args.postInstall + ''

      echo "This is PYTHONPATH: " $PYTHONPATH
      wrapProgram $out/bin/emacs \
      --prefix PYTHONPATH : "$(toPythonPath ${python}):$(toPythonPath ${ipython}):$(toPythonPath ${setuptools}):$(toPythonPath ${pip}):$(toPythonPath ${numpy}):$PYTHONPATH";
      '');
    });

    # service_factory = pkgs.buildPythonPackage (rec {
    #     name = "service_factory-0.1.2";

    #     buildInputs = [ pkgs.python27Packages.six ];

    #     src = pkgs.fetchurl {
    #         url = "http://pypi.python.org/packages/source/s/service_factory/${name}.tar.gz";
    #         sha256 = "1aqpjvvhb4rrpw3lb1ggqp46a0qpl6brkgpczs2g36bhqypijaqn";
    #     };

    #     meta = {
    #         homepage = https://github.com/proofit404/service-factory;
    #     };
    # });
  };
}
