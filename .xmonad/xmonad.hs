{-|
  This is xmonad.hs for me.
  You may want to run the following after installing xmonad.
  $ apt-get install dmenu xmobar
  $ xdg-mime default pcmanfm.desktop inode/directory
-}

import Data.Ratio ((%))
import XMonad
import XMonad.Hooks.DynamicLog (xmobar)
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (avoidStruts)
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.ResizableTile
    ( ResizableTall (ResizableTall)
    , MirrorResize (MirrorShrink, MirrorExpand)
    )
import XMonad.Util.EZConfig (additionalKeysP)


-- |my layout.
myLayout = avoidStruts $ tiled ||| Mirror tiled ||| noBorders Full
    where
    tiled = ResizableTall 1 (3 % 100) (1 / phi) [1, 6 % 5]
    phi = 8 % 5

-- |my key binds
myKeys :: [(String, X ())]
myKeys =
    [ ("M4-l", spawn "lxlock")
    , ("M1-C-t", spawn "lxterminal")
    , ("M-a", sendMessage MirrorShrink)
    , ("M-z", sendMessage MirrorExpand)
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
