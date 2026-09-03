{
  description = "Logos AMM UI module";

  # The darwin build compiles the LEZ wallet stack (ring won't build under the
  # nix cc-wrapper on Apple Silicon), so the release CI needs this substituter.
  nixConfig = {
    extra-substituters = [ "https://logos-co.cachix.org" ];
    extra-trusted-public-keys = [
      "logos-co.cachix.org-1:12K8609ho1pCt0erUQrOrs/KmOuhWq/EhVwhzQRb35E="
    ];
  };

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    # The monorepo that actually builds this module — CI fetches it to build
    # `.#lgx-portable`. Pinned to a specific lez-programs main commit for a
    # reproducible release; bump the rev (and re-lock) to publish a newer build.
    lez_programs.url = "github:logos-blockchain/lez-programs?rev=9346106f44ba1c25801c066dfb93fb6d7b735c8a";
  };

  # Re-expose the monorepo's AMM UI-module LGX under the bare attribute names the
  # release action builds (`.#lgx-portable`; `.#lgx` is the dev variant). The
  # metadata.json at this repo root carries the module's name/version for the
  # catalog and is cross-checked against the built .lgx manifest.
  outputs = { flake-utils, lez_programs, ... }:
    flake-utils.lib.eachDefaultSystem (system: {
      packages = {
        lgx          = lez_programs.packages.${system}.amm-ui-lgx;
        lgx-portable = lez_programs.packages.${system}.amm-ui-lgx-portable;
      };
    });
}
