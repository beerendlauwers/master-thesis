module Paths_cco (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName
  ) where

import Data.Version (Version(..))
import System.Environment (getEnv)

version :: Version
version = Version {versionBranch = [0,0,4], versionTags = []}

bindir, libdir, datadir, libexecdir :: FilePath

bindir     = "C:\\Users\\Beerend\\AppData\\Roaming\\cabal\\bin"
libdir     = "C:\\Users\\Beerend\\AppData\\Roaming\\cabal\\cco-0.0.4\\ghc-7.2.1"
datadir    = "C:\\Users\\Beerend\\AppData\\Roaming\\cabal\\cco-0.0.4"
libexecdir = "C:\\Users\\Beerend\\AppData\\Roaming\\cabal\\cco-0.0.4"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = catch (getEnv "cco_bindir") (\_ -> return bindir)
getLibDir = catch (getEnv "cco_libdir") (\_ -> return libdir)
getDataDir = catch (getEnv "cco_datadir") (\_ -> return datadir)
getLibexecDir = catch (getEnv "cco_libexecdir") (\_ -> return libexecdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
