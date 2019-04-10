with import <nixpkgs/lib>;
with import ./rts.nix;

let

  readWithPrompt = prompt: bind (write prompt) (_: read);

  readInt = bind (readWithPrompt "Enter integer: ") (input:
    let inherit (builtins.tryEval (toInt input)) result success;
    in if success then pure input else bind (write "Failed to parse integer, try again\n") readInt);

  select = question: answers: bind (readWithPrompt "${question} [${concatStringsSep ", " (attrNames answers)}]? ") (input:
    answers.${input} or (bind (write "Invalid answer, try again\n") (_: select question answers)));

  main = select "Your path splits, which way do you go" {
    left = bind (write "You walk for a while..\n") (_:
      bind (sleep 1000000) (_:
      write "You found a cake, you win!\n"));
    right = select "It's a dead end, do you want to go back" {
      yes = main;
      no = write "You're dead, I told you it was a dead end\n";
    };
  };

in runIO main
