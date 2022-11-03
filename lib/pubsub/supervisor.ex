defmodule ScenicSand.PubSub.Supervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    [
      {Scenic.Sensor, nil}
    ]
    |> Supervisor.init(strategy: :one_for_one)
  end
end
