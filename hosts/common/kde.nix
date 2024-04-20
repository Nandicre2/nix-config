{
  config,
  lib,
  pkgs,
  ...
}: {
  #---------------------------------------------------------------------
  # X11 Server and KDE Plasma Desktop Environment Configuration
  #---------------------------------------------------------------------
  services = {
    xserver = {
      enable = true;
      exportConfiguration = true;
      # Enable libinput driver for improved touchpad support (enabled by default in most desktop environments).
      libinput.enable = true;
    };
    #---------------------------------------------------------------------
    # Desktop Manager Configuration
    #---------------------------------------------------------------------
    desktopManager = {
      plasma6.enable = true;
    };
    #---------------------------------------------------------------------
    # Desktop Manager login screen settings
    #---------------------------------------------------------------------
    displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
      };
    };
  };
}