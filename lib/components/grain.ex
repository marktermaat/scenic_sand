defmodule ScenicSand.Components.Grain do
  use Scenic.Component

  alias Scenic.Graph
  alias Scenic.Sensor, as: PubSub
  alias ScenicSand.Service.SandField
  import Scenic.Primitives

  @graph Graph.build()

  @impl Scenic.Component
  def validate({sand_field, width, height, x, y}), do: {:ok, {sand_field, width, height, x, y}}
  def validate(_), do: {:error, "Give grain a coordinate tuple"}

  @impl Scenic.Scene
  def init(scene, {sand_field, _width, height, x, y}, _opts) do
    PubSub.subscribe(:frame)
    SandField.init_grain(sand_field, {x, y})

      graph = draw_grain(@graph, x, y)

    scene =
      scene
      |> assign(sand_field: sand_field)
      |> assign(max_y: height)
      |> assign(x: x, y: y)
      |> push_graph(graph)

    {:ok, scene}
  end

  @impl true
  def handle_info(
        {:sensor, :data, {:frame, _frame, _timestamp}},
        %{assigns: %{sand_field: sand_field, max_y: max_y, x: x, y: y}} = scene
      ) do
    below_grain = SandField.get_location(sand_field, {x, y + 1})

    if y < max_y && below_grain == 0 do
      y = y + 1

      graph = draw_grain(@graph, x, y)

      SandField.update_grain(sand_field, {x, y - 1}, {x, y})

      scene =
        scene
        |> assign(x: x, y: y)
        |> push_graph(graph)

      {:noreply, scene}
    else
      {:noreply, scene}
    end
  end

  defp draw_grain(graph, x, y) do
    graph
    |> rectangle({1, 1}, stroke: {1, :yellow}, translate: {x, y})
  end
end
