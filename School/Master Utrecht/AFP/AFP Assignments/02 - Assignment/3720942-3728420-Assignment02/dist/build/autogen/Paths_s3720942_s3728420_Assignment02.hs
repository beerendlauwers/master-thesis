module Paths_s3720942_s3728420_Assignment02 (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName
  ) where

import Data.Version (Version(..))
import System.Environment (getEnv)

version :: Version
version = Version {versionBranch = [0,1], versionTags = []}

bindir, libdir, datadir, libexecdir :: FilePath

bindir     = "C:\\Users\\Beerend\\AppData\\Roaming\\cabal\\bin"
libdir     = "C:\\Users\\Beerend\\AppData\\Roaming\\cabal\\s3720942-s3728420-Assignment02-0.1\\ghc-7.0.3"
datadir    = "C:\\Users\\Beerend\\AppData\\Roaming\\cabal\\s3720942-s3728420-Assignment02-0.1"
libexecdir = "C:\\Users\\Beerend\\AppData\\Roaming\\cabal\\s3720942-s3728420-Assignment02-0.1"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = catch (getEnv "s3720942_s3728420_Assignment02_bindir") (\_ -> return bindir)
getLibDir = catch (getEnv "s3720942_s3728420_Assignment02_libdir") (\_ -> return libdir)
getDataDir = catch (getEnv "s3720942_s3728420_Assignment02_datadir") (\_ -> return datadir)
getLibexecDir = catch (getEnv "s3720942_s3728420_Assignment02_libexecdir") (\_ -> return libexecdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
