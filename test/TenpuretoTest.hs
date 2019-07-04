{-# LANGUAGE QuasiQuotes #-}

module TenpuretoTest where

import           Test.Tasty
import           Test.Tasty.HUnit

import           Path

import           Tenpureto.Data
import           Tenpureto.Messages
import           Tenpureto.Effects.Git

import           Tenpureto

test_extractTemplateName :: [TestTree]
test_extractTemplateName =
    let cfg = FinalTemplateConfiguration { selectedTemplate = "foo/bar"
                                         , targetDirectory  = [absdir|/tmp|]
                                         }
    in  [ testCase "should extract from create message"
            $   extractTemplateName (commitCreateMessage "foo/bar")
            @?= Just (selectedTemplate cfg)
        , testCase "should extract from update message"
            $   extractTemplateName (commitUpdateMessage "foo/bar")
            @?= Just (selectedTemplate cfg)
        , testCase "should not extract from other messages"
            $   extractTemplateName "A\n\nTemplate foo/bar"
            @?= Nothing
        ]

test_buildRepositoryUrl :: [TestTree]
test_buildRepositoryUrl =
    [ testCase "should build from org/repo"
        $   buildRepositoryUrl "f_o-o/b_a-r.r"
        @?= RepositoryUrl "git@github.com:f_o-o/b_a-r.r.git"
    , testCase "should build from git url"
        $   buildRepositoryUrl "git@github.com:foo/bar.git"
        @?= RepositoryUrl "git@github.com:foo/bar.git"
    ]
