module Perms.PermCheck where

import Perms.Perms
import Data.List
import Test.QuickCheck
import System.Random

-- | 'allSmoothPerms' gives the property for comparing the results from the given 'smooth_perms'
-- function and our implementation using 'Tree a', 'smooth_perms_tree'.

-- Since smooth_perms has different results for empty input ([]) and empty results ([[]]), we filter its output
-- to match what is expected from our interpretation of the specification.
allSmoothPerms :: NonNegative Int -> SmallList Int -> Property
allSmoothPerms (NonNegative n) (SmallList xs) = validSmallInput n xs ==> collect xs $ ((sort $ smooth_perms_tree n xs) == (sort $ filter (not . null) $ smooth_perms n xs))

-- | 'validSmallInput' gives the restriction for testing:
-- -Length of the list should be small enough to be feasible to run smooth_perms on it;
-- -Length of the list should not be null to avoid repeatedly testing the empty list case;
-- -n should be non-negative;
-- -n should be, at most, the maximum value between the maximum and the minimum values in the list.
validSmallInput :: Int -> [Int] -> Bool
validSmallInput n xs = length xs < 5 && (not . null) xs && n <= 20

-- | 'SmallList a' provides lists of at most 5 elements between 1 and 20, to avoid testing
-- huge lists with very low probability of having a meaningful n value for smoothness.
newtype SmallList a = SmallList [a]
        deriving (Eq, Ord, Show)

instance (Arbitrary a, Ord a, Num a, Random a) => Arbitrary (SmallList a) where
         arbitrary = SmallList `fmap` ((listOf1 (choose (1,20))) `suchThat` ((<5) . length))

-- | Helper function for quickchecking our function
checkSmoothPerms = quickCheck allSmoothPerms

