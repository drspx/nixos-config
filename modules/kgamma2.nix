{
  stdenv,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  pkg-config,
  wrapQtAppsHook,
  qtbase,
  qtdeclarative,
  kirigami,
  ki18n,
  kconfig,
  kcoreaddons,
  kcmutils,
  libkscreen,
  lcms2,
}:

stdenv.mkDerivation {
  pname = "kgamma2";
  version = "unstable-2026-08-13";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "davidedmundson";
    repo = "kgamma2";
    rev = "master";
    hash = "sha256-WskM8b/11B5pITOEsCvhGKSgGZH3cNXboHU199Mfjmo=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtdeclarative
    kirigami
    ki18n
    kconfig
    kcoreaddons
    kcmutils
    libkscreen
    lcms2
  ];
}
