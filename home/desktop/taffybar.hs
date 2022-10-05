import System.Taffybar.Information.CPU
import System.Taffybar.SimpleConfig
import System.Taffybar.Widget
import System.Taffybar.Widget.Generic.Graph
import System.Taffybar.Widget.Generic.PollingGraph

-- main :: IO ()
-- main = do
--   let workspaces = workspacesNew defaultWorkspacesConfig
--   defaultTaffybar $
--     defaultTaffybarConfig
--       { startWidgets = [workspaces]
--       }
--
cpuCallback = do
  (_, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

main :: IO ()
main = do
  let -- cpuCfg =
      -- defaultGraphConfig
      -- { graphDataColors = [(0, 1, 0, 1), (1, 0, 1, 0.5)],
      -- graphLabel = Just "cpu"
      -- }
      clock = textClockNewWith defaultClockConfig {clockFormatString = "%a %_d %b %r"}
      -- cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      workspaces = workspacesNew defaultWorkspacesConfig
      tray = sniTrayNew
      simpleConfig =
        defaultSimpleTaffyConfig
          { startWidgets = [workspaces],
            endWidgets = [tray, clock]
          }
  simpleTaffybar simpleConfig

-- main = do
--   startTaffybar exampleTaffybarConfig
