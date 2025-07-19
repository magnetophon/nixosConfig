{ config, pkgs, ... }:
with pkgs;
{

    # make sure you do:
    # users.extraUsers.bart.extraGroups = [ "wheel" "audio" ];
    # set:
    # soundcardPciId
    # rtirq.nameList

    # imports = [
        # Include musnix: a meta-module for realtime audio.
        # todo: make submodule
        # /home/bart/source/musnix/default.nix
    # ];

    musnix = {
        # enable = true;
        rtirq.highList = "snd_hrtimer";
        rtirq.resetAll = 1;
        rtirq.prioLow = 0;
        alsaSeq.enable = false;
    };

    nixpkgs = {
        config.packageOverrides = pkgs: rec {
            guitarix = pkgs.guitarix.override { optimizationSupport = true; }; # TODO: upstream
            plugins = [
                helmholtz
                timbreid
                maxlib
                zexy
                puremapping
                cyclone
                mrpeach
            ];
            # plugins = [ helmholtz timbreid maxlib zexy cyclone mrpeach ];
            fullPD = puredata-with-plugins plugins;
            qjackctl = pkgs.lib.overrideDerivation pkgs.qjackctl (oldAttrs: {
                configureFlags = "--enable-jack-version --disable-xunique"; # fix bug for remote running
            });

            faust = pkgs.lib.overrideDerivation pkgs.faust (oldAttrs: {
                version = "2.81.2";
                src = fetchFromGitHub {
                    owner = "grame-cncm";
                    repo = "faust";
                    rev = "b5f8d097b0ed005525eae7d8b2a8b15f20f58a62";
                    sha256 = "sha256-Hem8g7t9jGnwsrBaON0xVaBJa5UFPSzjYpztcip6e8Q=";
                    fetchSubmodules = true;
                };
            });
        };
        # overlays = lib.singleton (lib.const (super: {
            #     linuxPackages_4_19_rt = super.linuxPackages_4_19_rt.extend (lib.const (ksuper: {
        #         kernel = ksuper.kernel.override {
        #             structuredExtraConfig =
        #                 with import (pkgs.path + "/lib/kernel.nix")
        #                     {inherit lib; version = "4.19.75"; };
        #                 {
        #                     PREEMPT_VOLUNTARY = lib.mkForce no;
        #                     HUGETLB_PAGE = yes;
        #                     TRANSPARENT_HUGEPAGE_ALWAYS = yes;
        #                 };
        #         };
        #     }));
        # }));
    };

    environment = {
        systemPackages = [
            # #################################################################
            #                             plugins                             #
            ###################################################################
            # airwindows
            # foo-yc20 https://github.com/sampov2/foo-yc20/issues/7
            AMB-plugins
            CHOWTapeModel
            FIL-plugins
            adlplug
            aeolus
            aether-lv2
            # ams-lv2
            artyFX
            x42-avldrums
            bchoppr
            bespokesynth
            bitmeter
            bjumblr
            # bristol
            bsequencer
            bshapr
            bslizr
            bschaffl
            bjumblr
            bchoppr
            bolliedelayxt-lv2
            calf
            caps
            cardinal
            ChowKick
            ChowPhaser
            CHOWTapeModel
            ChowCentaur
            csa
            diopser
            # distrho-ports
            dragonfly-reverb
            drumgizmo
            drumkv1
            # ensemble-chorus
            eq10q
            # open-music-kontrollers.eteroj

            open-music-kontrollers.eteroj
            open-music-kontrollers.jit
            # open-music-kontrollers.mephisto
            open-music-kontrollers.midi_matrix
            open-music-kontrollers.moony
            open-music-kontrollers.orbit
            open-music-kontrollers.patchmatrix
            open-music-kontrollers.router
            # open-music-kontrollers.sherlock
            # open-music-kontrollers.synthpod
            open-music-kontrollers.vm

            fluidsynth
            # fmsynth
            fomp
            freqtweak
            fverb
            geonkick
            # gxmatcheq-lv2
            gxplugins-lv2
            helm
            hybridreverb2
            hydrogen
            # industrializer
            infamousPlugins
            # ingen
            ir.lv2
            jaaa
            jack_oscrolloscope
            jackmeter
            japa
            ladspaH
            ladspaPlugins
            lsp-plugins
            LibreArp
            LibreArp-lv2
            mda_lv2
            molot-lite
            mod-arpeggiator-lv2
            ninjas2
            noise-repellent
            nova-filters
            oxefmsynth
            padthv1
            quadrafuzz
            plugin-torture
            qsampler
            qsynth
            # rc-effect-playground # https://github.com/jpcima/rc-effect-playground/issues/4
            rkrlv2
            samplv1
            setbfree
            sfizz # pro sampler
            sorcer
            spectmorph
            speech-denoiser
            stochas
            stone-phaser
            master_me
            string-machine
            swh_lv2
            synthv1
            surge
            surge-XT
            tamgamp.lv2
            tetraproc
            # uhhyou.lv2
            vocproc
            wolf-shaper
            x42-plugins
            yoshimi
            zam-plugins
            # zynaddsubfx
            ###################################################################
            #                              faust                              #
            ###################################################################

            # magnetophonDSP.MBdistortion # ERROR : path '/MBdistortion/frequency_bands/low/Drive' is already used
            magnetophonDSP.CharacterCompressor
            # magnetophonDSP.CompBus # long build, not used
            # magnetophonDSP.ConstantDetuneChorus
            magnetophonDSP.LazyLimiter
            magnetophonDSP.RhythmDelay
            magnetophonDSP.VoiceOfFaust
            magnetophonDSP.faustCompressors # https://github.com/grame-cncm/faust/issues/406 # ERROR : path '/autoComp/fast_rel' is already used
            magnetophonDSP.pluginUtils
            magnetophonDSP.shelfMultiBand
            tambura
            faust
            faust2alqt
            faust2alsa
            faust2firefox
            faust2jack
            faust2jaqt
            faust2lv2
            kapitonov-plugins-pack
            mooSpace

            ###################################################################
            #                              hosts                              #
            ###################################################################

            ardour
            # helio-workstation
            #beast
            carla
            audacity
            jalv
            mod-distortion
            petrifoo
            guitarix
            # zrythm
            # i-score #error: Package ‘JamomaCore-1.0-beta.1’ in /nix/store/0grkglhhrfiy27sdhmpwsryid5hw9qnz-nixos-20.03pre212208.8130f3c1c2b/nixos/pkgs/development/libraries/audio/jamomacore/default.nix:18 is marked as broken, refusing to evaluate.
            bitwig-studio
            ###################################################################
            #                            utilities                            #
            ###################################################################
            a2jmidid
            cuetools
            jack2
            # jack1
            # jack_capture
            lilv
            lv2bm
            mamba # broken
            qjackctl
            # sonic-lineup
            vmpk
            qmidinet
            ###################################################################
            #                            analizers                            #
            ###################################################################
            squishyball
            shntool
            ###################################################################
            #                            converters                           #
            ###################################################################
            flac
            lame
            sox
            ###################################################################
            #                             various                             #
            ###################################################################
            polyphone # soundfont / sfz editor
            dfasma
            # freewheeling
            # gigedit
            MMA
            #latencytop
            mixxx
            # pkgs.puredata-with-plugins.override { plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ]; }
            fullPD
            real_time_config_quick_scan
            # supercollider_scel
            (pkgs.fmit.override { jackSupport = true; })
            sooperlooper
            vimpc  #A vi/vim inspired client for the Music Player Daemon (mpd)
            ###################################################################
            #                           develpoment                           #
            ###################################################################
            octave
            graphviz
            leiningen
            ladspa-sdk
            # nur-bandithedoge.hvcc
            ###################################################################
            #                              unfree                             #
            ###################################################################
            # m32edit # unfree
            # reaper # unfree
            # sunvox # unfree
            # airwave # VST bridge # unfree
            # linuxsampler # unfree
            # vcv-rack # unfree

        ];
    };

    systemd.services = {
        #   jack = {
        #     after = [ "sound.target" ];
        #     description = "Jack audio server";
        #     wantedBy = [ "multi-user.target" ];
        #     serviceConfig = {
        #       LimitRTPRIO = "infinity";
        #       LimitMEMLOCK = "infinity";
        #       Environment="JACK_NO_AUDIO_RESERVATION=1";
        #       ExecStart = ''
        #         ${pkgs.jack2}/bin/jackd -P71 -p1024 -dalsa -dhw:0 -r44100 -n2
        #       '';
        #       User = "bart";
        #       Group = "audio";
        #       KillSignal="SIGKILL";
        #       Restart="always";
        #       # ExecStartPre="${pkgs.pulseaudio}/bin/pulseaudio -k";
        #     };
        #   };

        # papillon = {
        #   after = [ "network-online.target" "jack.service" ];
        #   description = "Papillon liquidsoap stream";
        #   # wantedBy = [ "multi-user.target" ];
        #   path = [ pkgs.wget ];
        #   preStart = ''
        #     mkdir -p /var/log/liquidsoap
        #     chown bart -R /var/log/liquidsoap
        #   '';
        #   serviceConfig = {
        #     LimitRTPRIO = "infinity";
        #     LimitMEMLOCK = "infinity";
        #     PermissionsStartOnly="true";
        #     ExecStart = "${pkgs.liquidsoap}/bin/liquidsoap /home/bart/source/nixradio/papillon.liq";
        #     User = "bart";
        #     Group = "audio";
        #     KillSignal="SIGKILL";
        #     Restart="always";
        #   };
        # };

        # tunnel = {
        #   after = [ "network.target" ];
        #   description = "Creates a public reverse tunnel from a server to a port of this computer.";
        #   wantedBy = [ "multi-user.target" ];
        #   serviceConfig = {
        #     Environment="AUTOSSH_GATETIME=0";
        #     ExecStart = ''
        #       ${pkgs.autossh}/bin/autossh -M 0 -oStrictHostKeyChecking=no -oServerAliveInterval=60 -oServerAliveCountMax=3 -oExitOnForwardFailure=yes -N -R :666:localhost:666 magnetophon@81.7.19.118
        #     '';
        #     # Restart="always";
        #   };
        # };
    };

    security.sudo.extraConfig = ''
    bart  ALL=(ALL) NOPASSWD: ${pkgs.systemd}/bin/systemctl
  '';

    }
