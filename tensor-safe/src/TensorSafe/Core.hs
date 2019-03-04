{-# LANGUAGE DataKinds            #-}
{-# LANGUAGE GADTs                #-}

{-# LANGUAGE KindSignatures       #-}
{-# LANGUAGE TypeFamilies         #-}
{-# LANGUAGE TypeOperators        #-}
{-# LANGUAGE UndecidableInstances #-}

module TensorSafe.Core where

import           Data.Typeable (typeOf)
import           GHC.TypeLits


-- | Natural number operations helpers
type family NatMult (a :: Nat) (b :: Nat) :: Nat where
    NatMult a 0 = 0
    NatMult a b = a + NatMult a (b - 1)


type family ShapeProduct (s :: [Nat]) :: Nat
type instance ShapeProduct '[] = 1
type instance ShapeProduct (m ': s) = NatMult m (ShapeProduct s)

-- | Wrapper for a Nat value
data R (n :: Nat) where
    R :: (KnownNat n) => R n

instance KnownNat n => Show (R n) where
    show = show . typeOf

-- | Wrapper for a tuple of 2 Nat values
data L (m :: Nat) (n :: Nat) where
    L :: (KnownNat m, KnownNat n) => L m n

instance (KnownNat m, KnownNat n) => Show (L m n) where
    show = show . typeOf

