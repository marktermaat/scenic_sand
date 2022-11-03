defmodule ScenicSand.Service.SandField do
  use GenServer

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init_grain(pid, location) do
    GenServer.cast(pid, {:init_grain, location})
  end

  def update_grain(pid, old_location, new_location) do
    GenServer.cast(pid, {:update_grain, old_location, new_location})
  end

  def get_location(pid, location) do
    GenServer.call(pid, {:get_location, location})
  end

  # Server

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:init_grain, location}, state) do
    {:noreply, Map.put(state, location, 1)}
  end

  @impl true
  def handle_cast({:update_grain, old_location, new_location}, state) do
    state =
      state
      |> Map.delete(old_location)
      |> Map.put(new_location, 1)

    {:noreply, state}
  end

  @impl true
  def handle_call({:get_location, location}, _from, state) do
    {:reply, Map.get(state, location, 0), state}
  end
end
