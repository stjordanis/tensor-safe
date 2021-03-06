{-# LANGUAGE CPP                  #-}
{-# LANGUAGE DataKinds            #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE GADTs                #-}
{-# LANGUAGE KindSignatures       #-}
{-# LANGUAGE StandaloneDeriving   #-}
{-# LANGUAGE TypeFamilies         #-}
{-# LANGUAGE TypeOperators        #-}
{-# LANGUAGE UndecidableInstances #-}
{-| This module declares all Shape related functions and data structures, as well as all singleton
-- instances for the Shape data type. This module was highly influenciated by Grenade, a Haskell
-- library for deep learning with dependent types. See: https://github.com/HuwCampbell/grenade
-}
module TensorSafe.Shape where

import           Data.Singletons
import           GHC.TypeLits    as N

import           TensorSafe.Core

--
-- Shape definition as in Haskell's Grenade library
--

-- | The current shapes we accept.
--   at the moment this is just one, two, and three dimensional
--   Vectors/Matricies.
--
--   These are only used with DataKinds, as Kind `Shape`, with Types 'D1, 'D2, 'D3.
data Shape
    = D1 Nat
    -- ^ One dimensional vector
    | D2 Nat Nat
    -- ^ Two dimensional matrix. Row, Column.
    | D3 Nat Nat Nat
    -- ^ Three dimensional matrix. Row, Column, Channels.

-- | Concrete data structures for a Shape.
--
--   All shapes are held in contiguous memory.
--   3D is held in a matrix (usually row oriented) which has height depth * rows.
data S (n :: Shape) where
    S1D :: ( KnownNat len )
        => R len
        -> S ('D1 len)

    S2D :: ( KnownNat rows, KnownNat columns )
        => L rows columns
        -> S ('D2 rows columns)

    S3D :: ( KnownNat rows
            , KnownNat columns
            , KnownNat depth
            , KnownNat (rows N.* depth))
        => L (rows N.* depth) columns
        -> S ('D3 rows columns depth)

deriving instance Show (S n)

-- Singleton instances.
-- Check: http://hackage.haskell.org/package/singletons
--
-- These could probably be derived with template haskell, but this seems
-- clear and makes adding the KnownNat constraints simple.
-- We can also keep our code TH free, which is great.
data instance Sing (n :: Shape) where
    D1Sing :: KnownNat a => Sing a -> Sing ('D1 a)
    D2Sing :: (KnownNat a, KnownNat b) => Sing a -> Sing b -> Sing ('D2 a b)
    D3Sing :: (KnownNat a, KnownNat b, KnownNat c) => Sing a -> Sing b -> Sing c -> Sing ('D3 a b c)

instance KnownNat a => SingI ('D1 a) where
    sing = D1Sing sing

instance (KnownNat a, KnownNat b) => SingI ('D2 a b) where
    sing = D2Sing sing sing

instance (KnownNat a, KnownNat b, KnownNat c) => SingI ('D3 a b c) where
    sing = D3Sing sing sing sing

-- | Compares two Shapes at kinds level and returns a Bool kind
type family ShapeEquals (sIn :: Shape) (sOut :: Shape) :: Bool where
    ShapeEquals s s = 'True
    ShapeEquals _ _ = 'False

-- | Same as ShapeEquals, which compares two Shapes at kinds level, but raises a TypeError exception
-- if the Shapes are not the equal.
type family ShapeEquals' (sIn :: Shape) (sOut :: Shape) :: Bool where
    ShapeEquals' s s = 'True
    ShapeEquals' s1 s2 =
        TypeError ( 'Text "Couldn't match the Shape "
              ':<>: 'ShowType s1
              ':<>: 'Text " with the Shape "
              ':<>: 'ShowType s2)
