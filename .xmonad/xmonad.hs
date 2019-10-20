import XMonad
import XMonad.Hooks.DynamicLog (xmobar)
import XMonad.Util.EZConfig


myKeys :: [(String, X ())]
myKeys =
    [ ("M4-l", spawn "lxlock")
    ]


main :: IO ()
main = do
    let config = def
            { modMask = mod1Mask :: KeyMask
            , terminal = "lxterminal"
            , borderWidth = 3 :: Dimension
            } `additionalKeysP` myKeys
    xmobar config >>= xmonad
