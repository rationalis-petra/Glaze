{-# OPTIONS_GHC -Wno-orphans #-}
module Project
  ( ProjectFile(..)
  , BuildFile(..)
  , project_file
  , run_parser) where

import Data.Text (Text, pack, unpack)
import qualified Text.Megaparsec as Megaparsec
import qualified Text.Megaparsec.Char.Lexer as L
import Text.Megaparsec.Char
import Text.Megaparsec hiding (runParser)
import Prettyprinter

type Parser = Parsec Text Text

sc :: Parser () 
sc = L.space
  space1
  (L.skipLineComment "#")   
  (L.skipBlockComment "(#" "#)")

lexeme :: Parser a -> Parser a  
lexeme = L.lexeme sc

symbol :: Parser Text  
symbol = pack <$> some (satisfy (\v -> v /= '#' && v /= '(' && v /= ')')) 

data ProjectFile = ProjectFile { version :: (Int, Int, Int) }

project_file :: Parser ProjectFile
project_file = do
  sc
  vnum <- between (lexeme $ char '(') (lexeme $ char ')') version_num
  sc 
  pure $ ProjectFile vnum
  where 
    version_num :: Parser (Int, Int, Int)
    version_num = do
      s <- symbol
      if (s == "glaze-version") then
        lexeme $ (,,) <$> L.decimal <*> L.decimal <*> L.decimal
      else
        fail ("Expecting glaze-version, got: " <> unpack s)


  
data BuildFile
  = DocumentBulid
   { name :: Text
   , public_name :: Text
   , subcomponents :: [Text] -- sub-documents
   }

  | GlyphBulid
   { name :: Text
   , public_name :: Text
   , subcomponents :: [Text] -- libraries
   }

-- process_build_file :: Parser BuildFile
-- process_build_file = do 
  


run_parser :: Parser a -> Text -> Text -> Either (Doc ann) a
run_parser p file input = case Megaparsec.runParser p (unpack file) input of
  Left err -> Left $ pretty $ errorBundlePretty err
  Right val -> Right val

instance ShowErrorComponent Text where 
  showErrorComponent = unpack
