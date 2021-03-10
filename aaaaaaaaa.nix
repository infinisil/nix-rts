with import ./rts.nix;

let
  main = bind (write "a") (_: main);
in runIO main
