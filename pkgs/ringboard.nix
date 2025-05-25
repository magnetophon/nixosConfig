let
  rust-overlay = import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz");
in
final: prev: {
  ringboard = with final;
    let
      rustPlatform = makeRustPlatform {
        cargo = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
        rustc = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
      };
    in
      rustPlatform.buildRustPackage rec {
        pname = "ringboard";
        version = "0.10.0";

        src = fetchFromGitHub {
          owner = "SUPERCILEX";
          repo = "clipboard-history";
          rev = version;
          sha256 = "sha256-e5cZQ0j4gvXlbLCHc6dUVStWzih9HbDAtnSW7v+PKCk=";
        };

        useFetchCargoVendor = true;
        cargoHash = "sha256-+E6BzfgUvpBZzkzvPvFfEt/IoVR/wU4uHECs4Dn5pIE=";

        nativeBuildInputs = [
          makeWrapper
        ];

        buildInputs = [
          libxkbcommon
          libGL
          wayland
          xorg.libXcursor
          xorg.libXrandr
          xorg.libXi
          xorg.libX11
        ];

        preBuild = ''
     local flagsArray=("-j $NIX_BUILD_CORES --target x86_64-unknown-linux-gnu --offline --release");
     concatTo flagsArray cargoBuildFlags;

     echo "Building package: clipboard-history-server"
     cargo build $flagsArray --package clipboard-history-server --no-default-features --features systemd
     echo "Building package: clipboard-history-x11"
     cargo build $flagsArray --package clipboard-history-x11 --no-default-features
     echo "Building package: clipboard-history-wayland"
     cargo build $flagsArray --package clipboard-history-wayland --no-default-features
     echo "Building package: clipboard-history"
     cargo build $flagsArray --package clipboard-history
     echo "Building package: clipboard-history-tui"
     cargo build $flagsArray --package clipboard-history-tui
     echo "Building package: clipboard-history-egui"
     cargo build $flagsArray --package clipboard-history-egui
    '';

        postInstall = ''
      wrapProgram  $out/bin/ringboard-egui --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"
    '';

        meta = with lib; {
          description = "A fast, efficient, and composable clipboard manager for Linux";
          homepage = "https://github.com/SUPERCILEX/clipboard-history";
          license = licenses.asl20;
          platforms = platforms.linux;
          maintainers = [ maintainers.magnetophon ];
        };
      };
}
