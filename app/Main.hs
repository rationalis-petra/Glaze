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

glaze_opts :: Parser Command
glaze_opts = subparser $
  (command "build" $
   info (BuildCommand <$> command_opts)
        (progDesc "Build a glaze target"))
  <>
  (command "test" $ 
   info (TestCommand <$> command_opts)
        (progDesc "Test a glaze target"))
  <>
  (command "run" $
   info (RunCommand <$> command_opts)
        (progDesc "Run a glaze target"))

main :: IO ()
main = do
  command <- execParser $ info (glaze_opts <**> helper)
    ( fullDesc
    <> progDesc "Buld, test and run glaze projects"
    <> header "The glaze build system")
  case command of 
    BuildCommand (CommandOpts targets) ->
      putStrLn $ "building targsts: " <> show targets
    TestCommand (CommandOpts targets) ->
      putStrLn $ "testing targsts: " <> show targets
    RunCommand (CommandOpts targets) ->
      putStrLn $ "running targsts: " <> show targets


  
