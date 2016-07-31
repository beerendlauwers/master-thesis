module Paths_s3720942_s3728420_Assignment05 (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName
  ) where

import Data.Version (Version(..))
import System.Environment (getEnv)

version :: Version
version = Version {versionBranch = [0,1], versionTags = []}

bindir, libdir, datadir, libexecdir :: FilePath

bindir     = "C:\\Program Files\\Haskell\\bin"
libdir     = "C:\\Program Files\\Haskell\\s3720942-s3728420-Assignment05-0.1\\ghc-7.0.3"
datadir    = "C:\\Program Files\\Haskell\\s3720942-s3728420-Assignment05-0.1"
libexecdir = "C:\\Program Files\\Haskell\\s3720942-s3728420-Assignment05-0.1"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = catch (getEnv "s3720942_s3728420_Assignment05_bindir") (\_ -> return bindir)
getLibDir = catch (getEnv "s3720942_s3728420_Assignment05_libdir") (\_ -> return libdir)
getDataDir = catch (getEnv "s3720942_s3728420_Assignment05_datadir") (\_ -> return datadir)
getLibexecDir = catch (getEnv "s3720942_s3728420_Assignment05_libexecdir") (\_ -> return libexecdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
