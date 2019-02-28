{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE GADTs                 #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE TypeOperators         #-}

module TensorSafe.Layers.MaxPooling where

import           Data.Kind         (Type)
import           GHC.TypeLits

import           TensorSafe.Core
import           TensorSafe.Layers
import           TensorSafe.Shape


data MaxPooling :: Nat -> Nat -> Nat -> Nat -> Type where
    MaxPooling :: MaxPooling kernelRows kernelColumns strideRows strideColumns

instance Show (MaxPooling k k' s s') where
    show MaxPooling = "MaxPooling"


instance (KnownNat k, KnownNat k', KnownNat s, KnownNat s') => LayerComponent (MaxPooling k k' s s') where
    layer = MaxPooling


instance ( KnownNat kernelRows
         , KnownNat kernelColumns
         , KnownNat strideRows
         , KnownNat strideColumns
         , KnownNat inputRows
         , KnownNat inputColumns
         , KnownNat outputRows
         , KnownNat outputColumns
         , (NatMult (outputRows - 1) strideRows) ~ (inputRows - kernelRows)
         , (NatMult (outputColumns - 1) strideColumns) ~ (inputColumns - kernelColumns)
         ) => Layer
              (MaxPooling kernelRows kernelColumns strideRows strideColumns)
              ('D2 inputRows inputColumns)
              ('D2 outputRows outputColumns) where
    type Tape
         (MaxPooling kernelRows kernelColumns strideRows strideColumns)
         ('D2 inputRows inputColumns)
         ('D2 outputRows outputColumns) = ()

    seal _ _ = ()

instance ( KnownNat kernelRows
         , KnownNat kernelColumns
         , KnownNat strideRows
         , KnownNat strideColumns
         , KnownNat inputRows
         , KnownNat inputColumns
         , KnownNat outputRows
         , KnownNat outputColumns
         , KnownNat channels
         , (NatMult (outputRows - 1) strideRows) ~ (inputRows - kernelRows)
         , (NatMult (outputColumns - 1) strideColumns) ~ (inputColumns - kernelColumns)
         ) => Layer
              (MaxPooling kernelRows kernelColumns strideRows strideColumns)
              ('D3 inputRows inputColumns channels)
              ('D3 outputRows outputColumns channels) where
    type Tape
         (MaxPooling kernelRows kernelColumns strideRows strideColumns)
         ('D3 inputRows inputColumns channels)
         ('D3 outputRows outputColumns channels) = ()

    seal _ _ = ()
