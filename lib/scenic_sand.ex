defmodule ScenicSand do
  def start(_type, _args) do
    main_viewport_config = Application.get_env(:scenic_sand, :viewport)

    children = [
      ScenicSand.PubSub.Supervisor,
      {Scenic, [main_viewport_config]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
