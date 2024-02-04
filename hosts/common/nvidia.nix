{
  lib,
  config,
  pkgs,
  ...
}: {
  hardware = {
    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;
      nvidiaPersistenced = true;

      # Enable the nvidia settings menu
      nvidiaSettings = true;

      # Enable power management (do not disable this unless you have a reason to).
      # Likely to cause problems on laptops and with screen tearing if disabled.
      powerManagement.enable = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.beta;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;
    };

    # Direct Rendering Infrastructure (DRI) support, both for 32-bit and 64-bit, and
    # Make sure opengl is enabled
    opengl = {
      enable = true;
      driSupport = lib.mkDefault true;
      driSupport32Bit = lib.mkDefault true;

      # Install additional packages that improve graphics performance and compatibility.
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        libvdpau-va-gl
        nvidia-vaapi-driver
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        vulkan-validation-layers
      ];
    };
  };

  # Tell Xorg to use the nvidia driver (also valid for Wayland)
  services.xserver.videoDrivers = ["nvidia"];

  boot.extraModprobeConfig = "options nvidia " + lib.concatStringsSep " " [
    # nvidia assume that by default your CPU does not support PAT,
    # but this is effectively never the case in 2023
    "NVreg_UsePageAttributeTable=1"
    # This may be a noop, but it's somewhat uncertain
    "NVreg_EnablePCIeGen3=1"
    # This is sometimes needed for ddc/ci support, see
    # https://www.ddcutil.com/nvidia/
    #
    # Current monitor does not support it, but this is useful for
    # the future
    "NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100"
    # When (if!) I get another nvidia GPU, check for resizeable bar
    # settings
  ];

  environment.variables = {
    # Required to run the correct GBM backend for nvidia GPUs on wayland
    GBM_BACKEND = "nvidia-drm";
    # Apparently, without this nouveau may attempt to be used instead
    # (despite it being blacklisted)
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # Hardware cursors are currently broken on nvidia
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    __GL_THREADED_OPTIMIZATION = "1";
    __GL_SHADER_CACHE = "1";
  };

  environment.systemPackages = with pkgs; [
    clinfo
    virtualglLib
    vulkan-loader
    vulkan-tools
  ];
}