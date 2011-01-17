module Paths_uu_tc (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName
  ) where

import Data.Version (Version(..))
import System.Environment (getEnv)

version :: Version
version = Version {versionBranch = [2009,2,2], versionTags = []}

bindir, libdir, datadir, libexecdir :: FilePath

bindir     = "C:\\Program Files\\Haskell\\bin"
libdir     = "C:\\Program Files\\Haskell\\uu-tc-2009.2.2\\ghc-6.12.3"
datadir    = "C:\\Program Files\\Haskell\\uu-tc-2009.2.2"
libexecdir = "C:\\Program Files\\Haskell\\uu-tc-2009.2.2"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = catch (getEnv "uu_tc_bindir") (\_ -> return bindir)
getLibDir = catch (getEnv "uu_tc_libdir") (\_ -> return libdir)
getDataDir = catch (getEnv "uu_tc_datadir") (\_ -> return datadir)
getLibexecDir = catch (getEnv "uu_tc_libexecdir") (\_ -> return libexecdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
