{-|
  This is xmonad.hs for me.
  You may want to run the following after installing xmonad.
  $ apt-get install dmenu xmobar
  $ xdg-mime default pcmanfm.desktop inode/directory
-}

import XMonad
import XMonad.Hooks.DynamicLog (xmobar)
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (avoidStruts)
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Util.EZConfig (additionalKeysP)


-- |my layout. 5 / 8 stands for the golden ratio.
myLayout = avoidStruts $ tiled ||| Mirror tiled ||| noBorders Full
    where
    tiled = Tall 1 (3 / 100) (5 / 8)

-- |my key binds
myKeys :: [(String, X ())]
myKeys =
    [ ("M4-l", spawn "lxlock")
    , ("M1-C-t", spawn "lxterminal")
    ]

main :: IO ()
main = do
    let config = def
            { borderWidth = 3 :: Dimension
            , focusFollowsMouse = False
            , layoutHook = myLayout
            , modMask = mod1Mask :: KeyMask
            , terminal = "lxterminal"
            } `additionalKeysP` myKeys
    (xmobar . ewmh) config >>= xmonad
