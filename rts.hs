import           Control.Concurrent
import           System.Environment
import           System.IO
import           Data.Char

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


nixEscape :: String -> String
nixEscape input = "\"" ++ concatMap escapeChar input ++ "\"" where
  escapeChar c
    | isAlpha c = [c]
    | otherwise = ['\\', c]
