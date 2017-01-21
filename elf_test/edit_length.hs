#! /usr/bin/env stack
-- stack --resolver=lts-7.4 runghc --package=shelly

{-# LANGUAGE ExtendedDefaultRules, OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

import Shelly hiding (FilePath)
import qualified Data.Text as T

import Control.Exception
import Data.Char
import Data.List
import System.Directory
import System.Environment
import System.IO hiding (FilePath)

default (T.Text)


main :: IO ()
main = bracketOnError (openBinaryFile src ReadMode) hClose hFileSize
    >>= edit

src :: FilePath
src = "long_entry.bin"

dst :: FilePath
dst = "init.inc"

edit :: Integer -> IO ()
edit n = readFile dst >>= edit'
    where
        secnum = calc n

        calc x
            | m > 0 = r + 1
            | otherwise = r
            where
                (r, m) = x `divMod` 512

        edit' = useBracket . unlines . foldr ff [] . lines
            where
                ff x acc
                    | "NumEntrySector" `isPrefixOf` x = replace secnum x : acc
                    | otherwise = x : acc

                useBracket x = bracketOnError (openTempFile "." "tmp")
                                (\(tname, thandle)
                                    -> hClose thandle
                                    >> removeFile tname
                                )
                                (\(tname, thandle)
                                    -> hPutStr thandle x
                                    >> hClose thandle
                                    >> removeFile dst
                                    >> renameFile tname dst
                                )

        replace n = unwords . foldr ff [] . words
            where
                ff xxs@(x : _) acc
                    | isDigit x && read xxs < n = show n : acc
                    | otherwise = xxs : acc
                ff x acc = x : acc


{-
main = shelly shellyMain
    where
        shellyMain = undefined
-}
