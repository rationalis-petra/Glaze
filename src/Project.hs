module Project () where


data ProjectFile = ProjectFile Version


process_project_file :: String -> ProjectFile

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

process_build_file :: String -> 
