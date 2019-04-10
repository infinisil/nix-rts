import           Control.Concurrent
import           System.Environment
import           System.IO

main :: IO ()
main = do
  world:builtin:args <- getArgs
  case builtin of
    "read"  -> do
      line <- getLine
      putStrLn $ nixEscape line
    "write" -> do
      hPutStr stderr (head args)
      putStrLn "null"
    "sleep" -> do
      threadDelay (read (head args))
      putStrLn "null"


-- TODO: Actually do escaping properly
nixEscape :: String -> String
nixEscape input = "\"" ++ input ++ "\""
