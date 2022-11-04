defmodule ScenicSand.Components.MultipleGrains do
  use Scenic.Component

  alias Scenic.Graph
  alias Scenic.Sensor, as: PubSub
  import Scenic.Primitives

  @graph Graph.build()

  @impl Scenic.Component
  def validate({width, height, number_of_grains}), do: {:ok, {width, height, number_of_grains}}
  def validate(_), do: {:error, "Give grain a coordinate tuple"}

  @impl Scenic.Scene
  def init(scene, {width, height, number_of_grains}, _opts) do
    PubSub.subscribe(:frame)

    sand_field = init_sand_field(number_of_grains, width, height)

    graph = draw_sand_field(@graph, sand_field)

    scene =
      scene
      |> assign(sand_field: sand_field)
      |> assign(max_y: height)
      |> push_graph(graph)

    {:ok, scene}
  end

  @impl true
  def handle_info(
        {:sensor, :data, {:frame, _frame, _timestamp}},
        %{assigns: %{sand_field: sand_field, max_y: max_y}} = scene
      ) do
    sand_field = update_sand_field(sand_field, max_y)
    graph = draw_sand_field(@graph, sand_field)

    scene =
      scene
      |> assign(sand_field: sand_field)
      |> push_graph(graph)

    {:noreply, scene}
  end

  defp init_sand_field(number_of_grains, width, height) do
    Enum.to_list(1..number_of_grains)
    |> Enum.reduce(%{}, fn _, field ->
      location = {:rand.uniform(width), :rand.uniform(height)}
      Map.put(field, location, 1)
    end)
  end

  defp draw_sand_field(graph, sand_field) do
    sand_field
    |> Map.keys()
    |> Enum.reduce(graph, fn {x, y}, graph ->
      rectangle(graph, {1, 1}, stroke: {1, :yellow}, translate: {x, y})
    end)
  end

  defp update_sand_field(sand_field, max_y) do
    # Convert to keys, update locations, and create new map
    sand_field
    |> Map.keys()
    |> Enum.map(fn {x, y} ->
      if y < max_y && Map.get(sand_field, {x, y + 1}, 0) == 0 do
        {{x, y + 1}, 1}
      else
        {{x, y}, 1}
      end
    end)
    |> Enum.into(%{})
  end
end
