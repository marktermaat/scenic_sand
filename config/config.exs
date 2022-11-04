import Config

# connect the app's asset module to Scenic
config :scenic, :assets, module: ScenicSand.Assets

# Configure the main viewport for the Scenic application
config :scenic_sand, :viewport,
  name: :main_viewport,
  size: {800, 600},
  theme: :dark,
  default_scene: ScenicSand.Scene.MultipleMultipleGrainScene,
  drivers: [
    [
      module: Scenic.Driver.Local,
      name: :local,
      window: [resizeable: false, title: "scenic_sand"],
      on_close: :stop_system
    ]
  ]
