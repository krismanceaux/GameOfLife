# GameOfLife

## Source of truth...
This repo is being mirrored from: 
https://gitlab.com/kristophermanceaux/gameoflife

## Description
This is the contextual logic for [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life), which I will soon include as a dependency in a Phoenix LiveView project to create the web interface, but of course I included a module to play with it in the console. [You need to have Elixir installed](https://elixir-lang.org/install.html) to play, or you can spin up a Docker container with this app.

You can play the game immediately with the console interface by spinning it up in IEx
```bash
cd game_of_life
iex -S mix
```
### Alternatively, you can use Docker with:
```bash
cd game_of_life
docker container run --rm -it -v $(pwd):/app/game_of_life -w /app/game_of_life elixir iex -S mix
```
Note: if using Docker Desktop for Windows 10 replace `$(pwd)` with `${PWD}`

Then launch the supervisor process
```elixir
iex(1)> GameOfLife.Supervisor.start_link
```
That will launch the Game server process in it's supervisory tree. You can then start the game from the console interface by running
```elixir
iex(2)> GameOfLife.Console.run_game_for(initial_state = [{0, 0}, {1, 0}, {1, -1}, {2, -1}, {2, -2}, {3, -2}], refresh_rate = 100, iterations = 100)
```

The variable bindings in the function call are unnecessary, but I added them for readability purposes in this documentation.
The `initial_state` could be any set of coordinates for the starting set of cells.
`refresh_rate` is the number of milliseconds the game will pause before generating the next generation of live cells.
`iteration` is the upper limit on the amount of times the game will iterate.

If the game crashes at any point, the supervisory tree will spin it back up.

## Installation

If [available in Hex](https://hex.pm/docs/publish) (it's not.. yet), the package can be installed
by adding `game_of_life` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:game_of_life, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/game_of_life](https://hexdocs.pm/game_of_life).

