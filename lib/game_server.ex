defmodule GameOfLife.GameServer do
  # GameOfLife.Console.run_game_for(initial_state = [{0, 0}, {1, 0}, {1, -1}, {2, -1}, {2, -2}, {3, -2}], refresh_rate = 100, iterations = 100)

  @name :gol_server

  use GenServer

  # client interface

  def start_link(_arg) do
    IO.puts("Starting Game of Life server...")
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def set_new_state(live_cells) do
    GenServer.cast(@name, {:set_new_state, live_cells})
  end

  # client interface to run one game iteration
  def run_game(live_cells, refresh_rate, module \\ __MODULE__) do
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

  # custom server code

  @spec will_live(any, any) :: boolean
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
    Enum.flat_map(live_cells, &generate_signals(&1))
  end

  def count_signals(signals) do
    list =
      for signal <- signals,
          do: [signal, Enum.count(signals, &(&1 == signal))]

    Enum.uniq(list)
  end

  def get_next_generation(live_cells) do
    signal_count_list =
      live_cells
      |> get_all_signals
      |> count_signals

    Enum.flat_map(signal_count_list, fn [cell, count] ->
      determine_if_next_gen_cell(cell, count, live_cells)
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

  def run_one_game_iteration(live_cells, refresh_rate) do
    :timer.sleep(refresh_rate)
    get_next_generation(live_cells)
  end
end
