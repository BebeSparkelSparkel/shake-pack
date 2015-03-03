-- | Pack given files into the target with tar and bzip. Uses bz2 C library on the system.
--
-- @
-- main :: IO ()
-- main = shakeArgs shakeOptions $ do
--     "pack.tar.bz2" *> pack ["ex.txt", "ex2.txt"]
-- @

module Development.Shake.Pack where

import qualified Codec.Archive.Tar      as Tar
import qualified Codec.Compression.BZip as BZip
import qualified Data.ByteString.Lazy   as BS
import           Development.Shake      (Action, liftIO, need)


-- | Pack files into a tar then compress with bzip. For static files,
-- be sure to use `Development.Shake.getDirectoryFiles` to track file
-- changes.
pack :: [FilePath] -- ^ Files to be included in package.
     -> FilePath   -- ^ Resulting package file name including extension. (ex: @"package.tar.bz2"@)
     -> Action ()
pack assets package = do
    need assets
    liftIO $ BS.writeFile package . BZip.compress . Tar.write =<< Tar.pack "" assets
