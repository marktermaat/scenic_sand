defmodule ScenicSand.Scene.SingleGrainScene do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Scenic.Sensor, as: PubSub
  alias ScenicSand.Service.SandField

  @width 800
  @height 600
  @graph Graph.build()

  def init(scene, _param, _opts) do
    # Register a channel for new frames
    PubSub.register(:frame, "1.0", "New frames")

    # Set a timer every 20ms to send a new frame (50fps)
    :timer.send_interval(20, :tick)

    # Initialize the SandField service
    {:ok, sand_field} = SandField.start_link({})

    # Initialize x new grains in the scene
    graph =
      Enum.to_list(1..100)
      |> Enum.reduce(@graph, fn _, graph ->
        ScenicSand.Components.Grain.add_to_graph(
          graph,
          {sand_field, @width, @height, :rand.uniform(@width), :rand.uniform(@height)}
        )
      end)

    scene =
      scene
      |> assign(frame: 0)
      |> assign(field: sand_field)
      |> push_graph(graph)

    {:ok, scene}
  end

  def handle_info(:tick, %{assigns: %{frame: frame}} = scene) do
    Scenic.Sensor.publish(:frame, frame)
    {:noreply, assign(scene, frame: frame + 1)}
  end
end
