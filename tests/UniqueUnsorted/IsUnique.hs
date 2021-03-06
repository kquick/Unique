module UniqueUnsorted.IsUnique where

import Test.Hspec
import Test.QuickCheck
import Control.Exception (evaluate)
import Data.Maybe (isJust, isNothing)

import Data.List.UniqueUnsorted

isUniqueTests :: SpecWith ()
isUniqueTests =
  describe "Data.List.UniqueUnsorted.isUnique" $ do
  it "isUnique: should return Nothing with empty list" $ do
    isUnique (1 :: Int) [] 
    `shouldBe`
      Nothing

  it "isUnique: should return Nothing with empty list (quickCheck)" $
    property $
    \x -> isNothing $ isUnique (x :: Char) []

  it "isUnique: returns (Just True) when element is unique" $ do
    isUnique 'a' "foo bar"  `shouldBe` Just True

  it "isUnique: returns (Just False) when list has duplicate of element" $ do
    isUnique 'o' "foo bar" `shouldBe` Just False

  it "isUnique: is NOT a lazy function, 'undefined test'" $ do
    evaluate (isUnique 'g' ['g','a','g', undefined ])
      `shouldThrow`
      errorCall "Prelude.undefined"
    
  it "isRepeated: is reverse function to isUnique" $ do
    property $
      \ x xs
      -> isUnique (x :: Int) xs == fmap not (isRepeated x xs)

  it "isUnique: should return (Just ANY) when element is exist in the list" $
    property $
    \ ( NonEmpty ls@(x:_) )
    -> isJust (isUnique (x :: Char) ls)

  it "isUnique: should return Nothing when element is absent in the list" $
    property $
    \ x xs
    -> notElem x xs
       ==> isNothing (isUnique (x :: Char) xs)
      
  it "isUnique: and isRepeated should return Nothing when element is absent in the list" $
    property $
    \ x xs
    -> notElem x xs
       ==> isNothing (isUnique (x :: Char) xs)
       &&  isNothing (isRepeated x xs)
