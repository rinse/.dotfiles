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
import XMonad.Hooks.ManageDocks (docks, avoidStruts)
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Layout.BoringWindows (boringWindows, focusUp, focusDown)
import XMonad.Layout.Minimize
    ( minimize
    , minimizeWindow
    , MinimizeMsg (RestoreNextMinimizedWin)
    )
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.ResizableTile
    ( ResizableTall (ResizableTall)
    , MirrorResize (MirrorShrink, MirrorExpand)
    )
import XMonad.Util.EZConfig (additionalKeysP, removeKeysP)


myLayout = avoidStruts . boringWindows . minimize
    $ tiled ||| Mirror tiled ||| noBorders Full
        where
        tiled = ResizableTall 1 (3 % 100) (1 / phi) [1, 6 % 5]
        phi = 8 % 5

myStartupHook :: X ()
myStartupHook = setWMName "LG3D"

myTerminal :: String
myTerminal = "lxterminal"

configKeys :: XConfig l -> XConfig l
configKeys c = c `additionalKeysP` myAdditionalKeys `removeKeysP` myRemovedKeys
    where
    myAdditionalKeys :: [(String, X ())]
    myAdditionalKeys =
        [ ("M4-l", spawn "lxlock")
        , ("M1-C-t", spawn myTerminal)
        , ("M-a", sendMessage MirrorShrink)
        , ("M-z", sendMessage MirrorExpand)
        , ("M-m", withFocused minimizeWindow)
        , ("M-S-m", sendMessage RestoreNextMinimizedWin)
        , ("M-j", focusDown)
        , ("M-k", focusUp)
        ]
    myRemovedKeys :: [String]
    myRemovedKeys =
        [ "M-S-q"
        ]

myConfig = docks . ewmh . configKeys $ def
    { borderWidth = 3 :: Dimension
    , focusFollowsMouse = False
    , layoutHook = myLayout
    , modMask = mod1Mask :: KeyMask
    , startupHook = myStartupHook
    , terminal = myTerminal
    }

main :: IO ()
main = xmobar myConfig >>= xmonad
