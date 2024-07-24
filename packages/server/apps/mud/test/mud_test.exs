defmodule MUDTest do
  use ExUnit.Case
  doctest MUD

  test "greets the world" do
    assert MUD.hello() == :world
  end
end
