module Main (main) where

import Options.Applicative

data CommandOpts = CommandOpts [String]

command_opts :: Parser CommandOpts
command_opts = CommandOpts
  <$> many (argument str
            (   metavar "TARGETS"
            <> help "What targets to build. If empty, uses the default target."))

data Command
  = BuildCommand CommandOpts
  | TestCommand CommandOpts
  | RunCommand CommandOpts

hex_opts :: Parser Command
hex_opts = subparser $
  (command "build" $
   info (BuildCommand <$> command_opts)
        (progDesc "Build a hex target"))
  <>
  (command "test" $ 
   info (TestCommand <$> command_opts)
        (progDesc "Test a hex target"))
  <>
  (command "run" $
   info (RunCommand <$> command_opts)
        (progDesc "Run a hex target"))

main :: IO ()
main = do
  command <- execParser $ info (hex_opts <**> helper)
    ( fullDesc
    <> progDesc "Buld, test and run hex projects"
    <> header "The hex build system")
  case command of 
    BuildCommand (CommandOpts targets) ->
      putStrLn $ "building targsts: " <> show targets
    TestCommand (CommandOpts targets) ->
      putStrLn $ "testing targsts: " <> show targets
    RunCommand (CommandOpts targets) ->
      putStrLn $ "running targsts: " <> show targets


  
