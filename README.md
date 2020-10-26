# Game of Life

## Source of truth...
This repo is being mirrored from: 
https://gitlab.com/kristophermanceaux/life

## Description
This is the contextual logic for [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life), which I have included as a dependency in a Phoenix LiveView project to create a web interface, but of course I included a module to play with it in the console. [You need to have Elixir installed](https://elixir-lang.org/install.html) to play, or you can spin up a Docker container.

### Basic usage for your interface of choice
Assuming you have installed the package using Hex, and have a set of `live_cells` that you would like to run through one iteration of the game, you simply use
```elixir
live_cells = [{0, 0}, {1, 0}, {1, -1}, {2, -1}, {2, -2}, {3, -2}]
next_generation = Life.GameServer.run_game(live_cells)
```
The list of tuples that holds the set of live cells is the only REQUIRED parameter.

The following 2 OPTIONAL parameters are `refresh_rate` and the `module` where you can define your own `run_one_game_iteration/2` function, which will override the default implementation in the `GameServer` module. You may find that you do not need these parameters for your interface, ***as I show in the next section with the Phoenix LiveView interface***, but there are a few instances where you may want this flexibility. One example is demonstrated later with the ***console interface***, which does need to use these 2 optional parameters.

----------

 ### Practical example with Phoenix LiveView
 Suppose you have a button on your UI that is associated with a `phx-click="start_game"` event.

 You can handle that event with:
 ```elixir
  def handle_event("start_game", _params, socket) do
    {:ok, _tref} = :timer.send_interval(1000, self(), :tick)
    {:noreply, socket}
  end
 ```

 This will send the current process the message `:tick` every `1000` milliseconds, and can be handled with:
 ```elixir
  def handle_info(:tick, socket) do
    live_cells = Life.GameServer.get_state()

    next_generation = Life.GameServer.run_game(live_cells)

    # Output next_generation to the UI
    
    {:noreply, socket}
  end
 ```

  From here you can output to the UI to reflect the current set of live cells, and this updates every `1000` milliseconds. `Life` is running as it's own application with its own supervisory tree, and uses a GenServer to maintain the state of the live cells. 

-----------


### Testing with the built-in console interface
After cloning the repository, you can play the game immediately with the console interface by spinning it up in IEx
```bash
cd GameOfLife
iex -S mix
```
#### Alternatively, you can use Docker with:
```bash
cd GameOfLife
docker container run --rm -it -v $(pwd):/app/life -w /app/life elixir iex -S mix
```
Note: if using Docker Desktop for Windows 10 replace `$(pwd)` with `${PWD}`

Then launch the supervisor process
```elixir
iex(1)> Life.Supervisor.start_link
```
That will launch the Game server process in it's supervisory tree. You can then start the game from the console interface by running
```elixir
iex(2)> Life.Console.run_game_for(initial_state = [{0, 0}, {1, 0}, {1, -1}, {2, -1}, {2, -2}, {3, -2}], refresh_rate = 100, iterations = 100)
```

The variable bindings in the function call are unnecessary, but I added them for readability purposes in this documentation.
- `initial_state` could be any set of coordinates for the starting set of cells.
- `refresh_rate` is the number of milliseconds the game will pause before generating the next generation of live cells.
- `iteration` is the upper limit on the amount of times the game will iterate.

If you peep at the source code, you see that `Life.Console.run_game_for/3` calls `Life.GameServer.run_game/3` and passes the required `initial_state` parameter, then passes the 2 optional parameters: `refresh_rate` and `__MODULE__` (this `Console` module). 

If the game crashes at any point, the supervisory tree will spin it back up.

--------------

## Installation

The package can be installed
by adding `life` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:life, "~> 1.0.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/life](https://hexdocs.pm/life).

