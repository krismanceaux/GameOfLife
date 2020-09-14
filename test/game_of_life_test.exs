defmodule GameOfLifeTest do
  use ExUnit.Case
  doctest GameOfLife

  test "greets the world" do
    assert GameOfLife.hello() == :world
  end

  test "is alive and 2 live neighbors" do
    assert GameOfLife.will_live(true, 2) == true
  end

  test "is alive and 3 live neighbors" do
    assert GameOfLife.will_live(true, 3) == true
  end

  test "is dead and 2 live neighbors" do
    assert GameOfLife.will_live(false, 2) == false
  end

  test "is dead and 3 live neighbors" do
    assert GameOfLife.will_live(false, 3) == true
  end

  test "is alive and 5 live neighbors" do
    assert GameOfLife.will_live(true, 5) == false
  end

  test "is dead and 5 live neighbors" do
    assert GameOfLife.will_live(false, 5) == false
  end

  test "generate signals at position { 0, 0 }" do
    assert Enum.sort(GameOfLife.generate_signals({0, 0})) ==
             Enum.sort([
               {1, 0},
               {0, 1},
               {1, 1},
               {-1, 0},
               {0, -1},
               {1, -1},
               {-1, 1},
               {-1, -1}
             ])
  end

  test "get all signals with   0,0   1,0   0,-1" do
    live_cells = [{0, 0}, {1, 0}, {0, -1}]

    assert Enum.sort(GameOfLife.get_all_signals(live_cells)) ==
             Enum.sort([
               {-1, -1},
               {0, -1},
               {1, -1},
               {-1, 0},
               {1, 0},
               {-1, 1},
               {0, 1},
               {1, 1},
               {0, -1},
               {1, -1},
               {2, -1},
               {0, 0},
               {2, 0},
               {0, 1},
               {1, 1},
               {2, 1},
               {-1, -2},
               {0, -2},
               {1, -2},
               {-1, -1},
               {1, -1},
               {-1, 0},
               {0, 0},
               {1, 0}
             ])
  end

  test "count signals" do
    signals = [{1, 1}, {2, 3}, {1, 2}, {2, 3}, {1, 1}, {1, 1}]

    assert GameOfLife.count_signals(signals) ==
             [
               [{1, 1}, 3],
               [{2, 3}, 2],
               [{1, 2}, 1]
             ]
  end

  test "get next gen" do
    live_cells = [{0, -1}, {0, 0}, {0, 1}]

    assert GameOfLife.get_next_generation(live_cells) ==
             [{-1, 0}, {0, 0}, {1, 0}]
  end
end
