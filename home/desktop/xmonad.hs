-- import System.Taffybar.Support.PagerHints
import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.BorderResize
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.PerWorkspace
import XMonad.Layout.PositionStoreFloat
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns

-- https://hackage.haskell.org/package/xmonad-0.17.1/docs/XMonad-Core.html
-- TODO: Font, border colors
main =
  xmonad $
    docks $
      ewmh $
        -- pagerHints
        defaultConfig
          { modMask = super,
            terminal = "terminal",
            focusFollowsMouse = False,
            borderWidth = 2,
            workspaces = ["dev", "web", "etc"],
            layoutHook = layouts,
            manageHook = myManageHook
          }
  where
    super = mod4Mask

myManageHook = className =? "Taffybar" --> hasBorder False

layouts =
  avoidStruts
    . smartSpacingWithEdge 3
    . smartBorders
    . devLayout
    . etcLayout
    $ (tall ||| Mirror tall ||| threecol ||| full)
  where
    -- https://hackage.haskell.org/package/xmonad-0.17.1/docs/XMonad-Layout.html
    tall = Tall 1 (3 / 100) (1 / 2)
    full = Full
    threecol = ThreeColMid 1 (3 / 100) (1 / 2)
    float = floatingDeco $ borderResize $ positionStoreFloat
    floatingDeco = noFrillsDeco shrinkText def

    devLayout = onWorkspace "dev" (full ||| tall)
    etcLayout = onWorkspace "etc" (full ||| tall ||| float)

-- https://hackage.haskell.org/package/xmonad-contrib-0.17.1/docs/XMonad-Layout-MultiToggle.html
-- fullScreenToggle = mkToggle (single NBFULL)
