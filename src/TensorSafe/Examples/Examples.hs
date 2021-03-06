{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-| This module wraps all examples in simple fuctions. -}
module TensorSafe.Examples.Examples (
    mnistExample,
    mnistExampleDense,
    simpleExample
) where

import           Data.Text.Lazy                    (unpack)

import           TensorSafe.Compile.Expr           (JavaScript (..), generate)
import           TensorSafe.Examples.MnistExample
import           TensorSafe.Examples.SimpleExample
import           TensorSafe.Network                (toCNetwork)


-- | Puts simple examples results to stdout
simpleExample :: IO ()
simpleExample =
    do
        putStrLn $ "Simple network example"
        putStrLn $ "----------------------"
        putStrLn $ show myNet
        putStrLn $ "Simple network example"
        putStrLn $ "----------------------"
        putStrLn $ show myNet2
        putStrLn $ "Simple network example"
        putStrLn $ "----------------------"
        putStrLn $ show myNet3
        putStrLn $ "Simple LSTM network example"
        putStrLn $ "----------------------"
        putStrLn $ show lstm

-- | Puts MNIST examples results to stdout
mnistExample :: IO ()
mnistExample =
    do
        putStrLn $ "MNIST example"
        putStrLn $ "-------------"
        putStrLn $ show mnist
        putStrLn $ "\n"
        putStrLn $ "MNIST compilation"
        putStrLn $ "-------------"
        putStrLn $ show (toCNetwork mnist)
        putStrLn $ "\n"
        putStrLn $ "MNIST generation"
        putStrLn $ "-------------"
        putStrLn $ unpack $ generate JavaScript (toCNetwork mnist)

-- | Puts MNIST Dense examples results to stdout
mnistExampleDense :: IO ()
mnistExampleDense =
    do
        putStrLn $ "MNIST Dense example"
        putStrLn $ "-------------"
        putStrLn $ show mnistDense
        putStrLn $ "\n"
        putStrLn $ "MNIST compilation"
        putStrLn $ "-------------"
        putStrLn $ show (toCNetwork mnistDense)
        putStrLn $ "\n"
        putStrLn $ "MNIST generation"
        putStrLn $ "-------------"
        putStrLn $ unpack $ generate JavaScript (toCNetwork mnistDense)

