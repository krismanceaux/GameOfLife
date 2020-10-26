defmodule Life.GameServer do
  # Life.Console.run_game_for(initial_state = [{0, 1}, {1, 1}, {1, 0}, {2, 0}, {3, 0}, {3, 1}, {4, 1}], refresh_rate = 10, iterations = 1000)
  # Life.GameServer.get_next_generation [{28, 4},{26, 5},{27, 4},{29, 5},{27, 6},{30, 6},{30, 7},{30, 8},{29, 9},{27, 11},{21, 6},{21, 7},{22, 7},{22, 6},{21, 8},{22, 8},{22, 9},{23, 10},{22, 10},{22, 12},{23, 12},{24, 10},{26, 11},{25, 13},{26, 13},{25, 16},{26, 17},{27, 17},{23, 18},{26, 16},{24, 17},{23, 20},{24, 20},{22, 19},{22, 20},{21, 20},{20, 20},{19, 16},{19, 17},{21, 17},{19, 18},{20, 18},{20, 17},{19, 19},{18, 19},{18, 20},{35, 14},{34, 15},{35, 15},{34, 14},{17, 14},{17, 15},{15, 16},{16, 16},{18, 16},{18, 15},{16, 15},{17, 20},{17, 19},{14, 17},{15, 17},{14, 18},{15, 19},{15, 18},{34, 21},{35, 21},{36, 21},{18, 22},{20, 22},{18, 23},{19, 23},{22, 22},{22, 23},{19, 24},{19, 25},{20, 25},{21, 25},{20, 24},{17, 23},{17, 22},{21, 22},{19, 26},{23, 22},{23, 24},{24, 22},{24, 25},{26, 25},{27, 25},{17, 27},{18, 27},{18, 26},{17, 28},{15, 26},{16, 26},{16, 27},{14, 24},{15, 24},{15, 23},{14, 25},{15, 25},{25, 26},{26, 26},{22, 30},{23, 30},{22, 32},{23, 32},{24, 32},{22, 33},{25, 29},{26, 29},{26, 31},{27, 31},{29, 33},{35, 27},{34, 28},{35, 28},{34, 27},{22, 34},{21, 35},{22, 35},{21, 34},{21, 36},{22, 36},{30, 34},{26, 37},{27, 36},{27, 38},{28, 38},{29, 37},{30, 35},{30, 36}]
  @name :gol_server

  use GenServer

  @moduledoc """
    This GenServer module contains the basic logic to take in a set of live cells, generate the next generation, and store the next generation as its state.
  """

  # client api
  def start_link(_arg) do
    IO.puts("Starting Game of Life server...")
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def set_new_state(live_cells) do
    GenServer.cast(@name, {:set_new_state, live_cells})
  end

  def insert_cell(cell) do
    GenServer.cast(@name, {:insert_cell, cell})
  end

  def remove_cell(cell) do
    GenServer.cast(@name, {:remove_cell, cell})
  end

  # client interface to run one game iteration
  def run_game(live_cells, refresh_rate \\ 0, module \\ __MODULE__) do
    GenServer.call(@name, {:run_game, live_cells, refresh_rate, module})
  end

  def get_state do
    GenServer.call(@name, :get_state)
  end

  # server callbacks

  def init(state) do
    IO.inspect(state)
    {:ok, state}
  end

  def handle_call({:run_game, live_cells, refresh_rate, module}, _from, _state) do
    next_gen = module.run_one_game_iteration(live_cells, refresh_rate)
    {:reply, next_gen, next_gen}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:set_new_state, live_cells}, _state) do
    {:noreply, live_cells}
  end

  def handle_cast({:insert_cell, cell}, state) do
    new_state = [cell | state]
    {:noreply, new_state}
  end

  def handle_cast({:remove_cell, cell}, state) do
    new_state = remove_cell(state, cell)
    {:noreply, new_state}
  end

  # custom server code

  defp remove_cell(live_cells, cell_to_remove) do
    Enum.filter(live_cells, &(&1 != cell_to_remove))
  end

  def will_live(is_alive, num_of_live_neighbors)

  def will_live(true, 2) do
    true
  end

  def will_live(_is_alive, 3) do
    true
  end

  def will_live(_, _) do
    false
  end

  def generate_signals(position) do
    {x, y} = position

    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
  end

  def get_all_signals(live_cells) do
    Task.async_stream(live_cells, fn cell -> generate_signals(cell) end)
    |> Enum.flat_map(fn {:ok, signal} -> signal end)
  end

  def get_signal_count(signals, signal) do
    [signal, Enum.count(signals, &(&1 == signal))]
  end

  def count_signals(signals) do
    Task.async_stream(signals, &get_signal_count(signals, &1))
    |> Enum.into([], fn {:ok, res} -> res end)
    |> Enum.uniq()
  end

  def get_next_generation(live_cells) do
    # t1 = :erlang.timestamp()

    next_gen =
      live_cells
      |> get_all_signals
      |> count_signals
      |> evaluate_all_signals(live_cells)

    # t2 = :erlang.timestamp()

    # IO.inspect(:timer.now_diff(t2, t1))
    next_gen
  end

  def evaluate_all_signals(signals, live_cells) do
    signals
    |> Enum.flat_map(fn [cell, count] ->
      determine_if_next_gen_cell(
        cell,
        count,
        live_cells
      )
    end)
  end

  def determine_if_next_gen_cell(cell, count, live_cells) do
    case will_live(cell in live_cells, count) do
      true -> [cell]
      false -> []
    end
  end

  def run_one_game_iteration([], _) do
    []
  end

  def run_one_game_iteration(live_cells, 0) do
    get_next_generation(live_cells)
  end

  def run_one_game_iteration(live_cells, refresh_rate) do
    :timer.sleep(refresh_rate)
    get_next_generation(live_cells)
  end
end
