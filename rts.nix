
let

  pkgs = import <nixpkgs> {};

  rts = pkgs.runCommand "rts" {} ''
    ${pkgs.ghc}/bin/ghc ${./rts.hs} -o $out
  '';

in {
  
  read = world: {
    inherit world;
    result = builtins.exec [ rts world "read" ];
  };

  write = string: world: {
    inherit world;
    result = builtins.exec [ rts world "write" string ];
  };

  sleep = microseconds: world: {
    inherit world;
    result = builtins.exec [ rts world "sleep" (toString microseconds) ];
  };
  
  bind = a: f: world: let
    a' = a world;
  in builtins.seq a'.result (f a'.result a'.world);

  pure = value: world: {
    world = world;
    result = value;
  };
    
  runIO = io: builtins.seq rts (builtins.seq (io "").result "<Exited>");
}
