defmodule Life.Console do
  alias Life.GameServer

  @moduledoc """
  This module is one way to create a rather basic example of an interface for the Life.GameServer module.
  """

  @doc """
  Calls `Live.GameServer.run_game/3` in a loop for the specified amount of `iterations`.
  Each iteration pauses for the amount of milliseconds specified by `refresh_rate`.

  Always returns a list of tuples as the set of new coordinates for the next generation of live cells.
  """
  def run_game_for(_, _, 0) do
    {:done}
  end

  def run_game_for(live_cells, refresh_rate, iterations) do
    case next_gen = GameServer.run_game(live_cells, refresh_rate, __MODULE__) do
      [] -> run_game_for(next_gen, refresh_rate, 0)
      _ -> run_game_for(next_gen, refresh_rate, iterations - 1)
    end
  end

  @doc """
  Required function that is called in `Live.GameServer.run_game/3`
  In this case, this function handles displaying the grid of cells in IEx
  Ends with a call to `GameServer.get_next_generation/1`

  Returns a list of tuples as the set of new coordinates for the next generation of live cells.
  """
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
