{ pkgs, ... }:

let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [ "35" ];
    includeEmulator = true;
    includeSystemImages = true;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = [ "x86_64" ];
    includeSources = false;
    includeNDK = false;
  };

  androidSdk = androidComposition.androidsdk;
in
{
  nixpkgs.config.android_sdk.accept_license = true;

  users.users.rxda.extraGroups = [
    "kvm"
  ];

  environment.systemPackages = with pkgs; [
    androidSdk
    android-tools
    scrcpy
  ];

  environment.sessionVariables = {
    ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
    ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
  };
}
