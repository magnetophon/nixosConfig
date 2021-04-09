{ config, pkgs, ... }:
with pkgs; {

    # make sure you do:
    # users.extraUsers.bart.extraGroups = [ "wheel" "audio" ];
    # set:
    # soundcardPciId
    # rtirq.nameList

    imports = [ # Include musnix: a meta-module for realtime audio.
        # todo: make submodule
        /home/bart/source/musnix/default.nix
    ];

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
            plugins = [ helmholtz timbreid maxlib zexy puremapping cyclone mrpeach ];
            # plugins = [ helmholtz timbreid maxlib zexy cyclone mrpeach ];
            fullPD = puredata-with-plugins plugins;
            qjackctl = pkgs.lib.overrideDerivation pkgs.qjackctl (oldAttrs: {
                configureFlags =
                    "--enable-jack-version --disable-xunique"; # fix bug for remote running
            });
            # faust = pkgs.lib.overrideDerivation pkgs.faust (oldAttrs: {
            # version = "unstable-2020-03-20";
            # src = fetchFromGitHub {
            # owner = "grame-cncm";
            # repo = "faust";
            # rev = "2782088d4485f1c572755f41e7a072b41cb7148a";
            # sha256 = "1l7bi2mq10s5wm8g4cdipg8gndd478x897qv0h7nqi1s2q9nq99p";
            # fetchSubmodules = true;
            # };
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
            # zita-dpl1
            AMB-plugins
            FIL-plugins
            adlplug
            aeolus
            ams-lv2
            artyFX
            avldrums-lv2
            bchoppr
            bitmeter
            bjumblr
            bristol
            bsequencer
            bshapr
            bslizr
            bschaffl
            bjumblr
            bchoppr
            calf
            caps
            csa
            distrho
            dragonfly-reverb
            drumgizmo
            drumkv1
            ensemble-chorus
            eq10q
            eteroj.lv2
            fluidsynth
            fmsynth
            fomp
            freqtweak
            fverb
            geonkick
            gxmatcheq-lv2
            gxplugins-lv2
            helm
            hybridreverb2
            hydrogen
            industrializer
            infamousPlugins
            ingen
            ir.lv2
            jaaa
            jack_oscrolloscope
            jackmeter
            japa
            ladspaH
            ladspaPlugins
            lsp-plugins
            mda_lv2
            molot-lite
            ninjas2
            noise-repellent
            nova-filters
            oxefmsynth
            padthv1
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
            stone-phaser
            string-machine # todo:uncomment when it gets in unstable
            swh_lv2
            synthv1
            tamgamp.lv2
            tetraproc
            uhhyou.lv2
            wolf-shaper
            x42-plugins
            yoshimi
            zam-plugins
            zynaddsubfx
            ###################################################################
            #                              faust                              #
            ###################################################################

            # magnetophonDSP.MBdistortion # ERROR : path '/MBdistortion/frequency_bands/low/Drive' is already used
            magnetophonDSP.CharacterCompressor
            # magnetophonDSP.CompBus # long build, not used
            magnetophonDSP.ConstantDetuneChorus
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
            ardour_5
            helio-workstation
            #beast
            carla
            audacity
            jalv
            mod-distortion
            petrifoo
            guitarix
            # i-score #error: Package ‘JamomaCore-1.0-beta.1’ in /nix/store/0grkglhhrfiy27sdhmpwsryid5hw9qnz-nixos-20.03pre212208.8130f3c1c2b/nixos/pkgs/development/libraries/audio/jamomacore/default.nix:18 is marked as broken, refusing to evaluate.
            ###################################################################
            #                            utilities                            #
            ###################################################################
            a2jmidid
            cadence
            cuetools
            jack2Full
            # jack1
            jack_capture
            lilv
            lv2bm
            mamba
            qjackctl
            sonic-lineup
            vmpk
            QmidiNet
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
            freewheeling
            # gigedit
            linuxband
            MMA
            #latencytop
            mixxx
            #pkgs.puredata-with-plugins.override { plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ]; }
            fullPD
            real_time_config_quick_scan
            supercollider_scel
            ( pkgs.fmit.override { jackSupport = true; })
            sooperlooper
            #vimpc  #A vi/vim inspired client for the Music Player Daemon (mpd)
            ###################################################################
            #                           develpoment                           #
            ###################################################################
            octave
            graphviz
            leiningen
            ladspa-sdk
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
