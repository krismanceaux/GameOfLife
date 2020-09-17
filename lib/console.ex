defmodule Life.Console do
  alias Life.GameServer

  def run_game_for(_, _, 0) do
    {:done}
  end

  def run_game_for(live_cells, refresh_rate, iterations) do
    case next_gen = GameServer.run_game(live_cells, refresh_rate, __MODULE__) do
      [] -> run_game_for(next_gen, refresh_rate, 0)
      _ -> run_game_for(next_gen, refresh_rate, iterations - 1)
    end
  end

  def run_one_game_iteration([], _) do
    []
  end

  def run_one_game_iteration(live_cells, refresh_rate) do
    IEx.Helpers.clear()

    {x_pos_list, y_pos_list} = Enum.unzip(live_cells)
    x_range = (Enum.min(x_pos_list) - 5)..(Enum.max(x_pos_list) + 5)
    y_range = (Enum.min(y_pos_list) - 5)..(Enum.max(y_pos_list) + 5)

    matrix =
      for x <- x_range do
        for y <- y_range do
          if {x, y} in live_cells, do: "X", else: "  "
        end
      end

    for row <- matrix do
      IO.puts(
        for item <- row do
          item
        end
      )
    end

    :timer.sleep(refresh_rate)
    GameServer.get_next_generation(live_cells)
  end
end
