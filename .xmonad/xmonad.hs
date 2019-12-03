{-|
  - This is xmonad.hs for me. xmonad version: 0.13
  - You may want to run the following after installing xmonad.
    - $ apt-get install dmenu xmobar
    - $ xdg-mime default pcmanfm.desktop inode/directory
  - Export the following environment variable.
    - $ export _JAVA_AWT_WM_NONREPARENTING=1
-}

import Data.Ratio ((%))
import XMonad
import XMonad.Actions.CycleWS
    ( nextScreen
    , shiftNextScreen
    )
import XMonad.Hooks.DynamicLog (xmobar)
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (docks, avoidStruts)
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
import XMonad.Util.Run (safeSpawn, safeSpawnProg)
import qualified XMonad.StackSet as W


myLayout = avoidStruts . boringWindows . minimize $ tiles
    where
    tiles = tile ||| Mirror tile ||| noBorders Full
    tile = ResizableTall 1 (3 % 100) (1 / phi) [1, 6 % 5]
    phi = 8 % 5

myTerminal :: String
myTerminal = "lxterminal"

configKeys :: XConfig l -> XConfig l
configKeys c = c `additionalKeysP` myAdditionalKeys `removeKeysP` myRemovedKeys
    where
    myAdditionalKeys :: [(String, X ())]
    myAdditionalKeys =
        [ ("M4-l", safeSpawnProg "lxlock")
        , ("M1-C-t", safeSpawnProg myTerminal)
        , ("M-a", sendMessage MirrorShrink)
        , ("M-z", sendMessage MirrorExpand)
        , ("M-m", withFocused minimizeWindow)
        , ("M-S-m", sendMessage RestoreNextMinimizedWin)
        , ("M-j", focusDown)
        , ("M-k", focusUp)
        , ("M-r", nextScreen)
        , ("M-S-r", shiftNextScreen >> nextScreen)
        , ("M-i", windows W.swapMaster)
        , ("M-u a", safeSpawn "pactl" [ "set-sink-volume", "@DEFAULT_SINK@", "+10%" ])
        , ("M-u x", safeSpawn "pactl" [ "set-sink-volume", "@DEFAULT_SINK@", "-10%" ])
        , ("M-u m", safeSpawn "pactl" [ "set-sink-mute", "@DEFAULT_SINK@", "toggle" ])
        ]
    myRemovedKeys :: [String]
    myRemovedKeys =
        [ "M-S-q"
        , "M1-<Return>" -- For intellij idea. Use M-i instead
        ]

myConfig = docks . ewmh . configKeys $ def
    { borderWidth = 3 :: Dimension
    , focusFollowsMouse = False
    , layoutHook = myLayout
    , modMask = mod1Mask :: KeyMask
    , terminal = myTerminal
    }

main :: IO ()
main = xmobar myConfig >>= xmonad
