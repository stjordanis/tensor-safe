{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies          #-}
module TensorSafe.Layers.Flatten (Flatten) where

import           GHC.TypeLits
import           TensorSafe.Core   (NatMult)
import           TensorSafe.Layers
import           TensorSafe.Shape


data Flatten = Flatten deriving Show

instance LayerComponent Flatten where
    layer = Flatten

instance (KnownNat i) => Layer Flatten ('D1 i) ('D1 i)

instance ( KnownNat a
         , KnownNat i
         , KnownNat j
         , a ~ (NatMult i j)
         ) => Layer Flatten ('D2 i j) ('D1 a)

instance (KnownNat a
         , KnownNat i
         , KnownNat j
         , KnownNat k
         , a ~ (NatMult (NatMult i j) k)
         ) => Layer Flatten ('D3 i j k) ('D1 a)
