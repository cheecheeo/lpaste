{-# OPTIONS -Wall -fno-warn-name-shadowing #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

-- | Reported page view.

module Hpaste.View.Reported
  (page)
  where

import Hpaste.Types
import Hpaste.View.Html
import Hpaste.View.Layout

import Data.Monoid.Operator ((++))
import Data.Time.Show       (showDateTime)
import Prelude              hiding ((++))
import Text.Blaze.Html5     as H hiding (map)
import Snap.App.Types

-- | Render the reported page.
page :: Pagination -> [Report] -> Html
page pn rs =
  layoutPage $ Page {
    pageTitle = "Reported pastes"
  , pageBody = reported pn rs
  , pageName = "reported"
  }

-- | View the paginated reports.
reported :: Pagination -> [Report] -> Html
reported pn rs = do
  darkSection "Reported pastes" $ do
    paginate pn $ do
      table ! aClass "latest-pastes" $ do
        tr $ mapM_ (th . toHtml) $ words "Date Paste Comments"
        reports rs

    where reports = mapM_ $ \Report{..} -> tr $ do
                      td $ toHtml $ showDateTime reportDate
                      td $ toHtml $ href ("/" ++ show reportPasteId) $ show reportPasteId
                      td $ toHtml reportComments
