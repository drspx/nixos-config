(final: prev: {
  lutris-unwrapped =
    let
      noOverride = prev.lib.versionAtLeast prev.lutris-unwrapped.version "0.5.23";
    in
    prev.lib.warnIf noOverride
      ''
        lutris-unwrapped >= 0.5.23 is now in nixpkgs, the override can be removed
      ''
      (
        if noOverride then
          prev.lutris-unwrapped
        else
          prev.lutris-unwrapped.overrideAttrs (old: {
            version = "nightly-master";
            src = prev.fetchFromGitHub {
              owner = "lutris";
              repo = "lutris";
              rev = "5d873cc11608d46a5b873436639b95d26b3c4ebe";
              fetchSubmodules = true;
              hash = "sha256-LdgYje8bsmkQu6Qduy+Sf/e1aGdMmci7aCrwYExnDTk=";
            };
            # This nixpkgs patch targets the older Lutris source and no longer applies.
            patches = prev.lib.filter
              (patch: !(prev.lib.hasSuffix "fix-GnomeDesktop-AttributeError.patch" (toString patch)))
              (old.patches or [ ]);
          })
      );
})
