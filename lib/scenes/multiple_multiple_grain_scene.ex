defmodule ScenicSand.Scene.MultipleMultipleGrainScene do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Scenic.Sensor, as: PubSub

  @width 800
  @height 600
  @graph Graph.build()

  def init(scene, _param, _opts) do
    # Register a channel for new frames
    PubSub.register(:frame, "1.0", "New frames")

    # Set a timer every 20ms to send a new frame (50fps)
    :timer.send_interval(20, :tick)

    # Initialize x new grains in the scene
    graph =
      Enum.to_list(1..10)
      |> Enum.reduce(@graph, fn _, graph ->
        ScenicSand.Components.MultipleGrains.add_to_graph(graph, {@width, @height, 100})
      end)

    scene =
      scene
      |> assign(frame: 0)
      |> push_graph(graph)

    {:ok, scene}
  end

  def handle_info(:tick, %{assigns: %{frame: frame}} = scene) do
    Scenic.Sensor.publish(:frame, frame)
    {:noreply, assign(scene, frame: frame + 1)}
  end
end
