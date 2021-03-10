
let

  pkgs = import <nixpkgs> {};

  rts = pkgs.runCommand "rts" {} ''
    ${pkgs.ghc}/bin/ghc ${./rts.hs} -o $out
  '';

  iterateForever = trans:
    let
      iterateN = n: state: builtins.foldl' (state: _: builtins.seq state (trans state)) state (builtins.genList throw n);
      go = n: state: builtins.seq state (go (n * 2) (iterateN n state));
    in go 1;

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

  forever = a: iterateForever (world:
    let a' = a world;
    in builtins.seq a'.result a'.world
  );

  pure = value: world: {
    world = world;
    result = value;
  };
    
  runIO = io: builtins.seq rts (builtins.seq (io "").result "<Exited>");
}
