defmodule ExAws.ElastiCacheTest do
  use ExUnit.Case
  doctest ExAws.ElastiCache

  test "greets the world" do
    assert ExAws.ElastiCache.hello() == :world
  end
end
