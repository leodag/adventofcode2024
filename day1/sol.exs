#!/usr/bin/env elixir

defmodule Aoc do
  def part1 do
    {left, right} =
      File.stream!("input")
      |> Enum.map(fn line ->
        line
        |> String.trim()
        |> String.split()
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)
      |> Enum.unzip()

    left = Enum.sort(left)
    right = Enum.sort(right)

    Enum.zip(left, right)
    |> Enum.map(fn {l, r} -> abs(l - r) end)
    |> Enum.sum()
    |> IO.puts()
  end

  def part2 do
    {left, right} =
      File.stream!("input")
      |> Enum.map(fn line ->
        line
        |> String.trim()
        |> String.split()
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)
      |> Enum.unzip()

      freq = Enum.frequencies(right)

      Enum.reduce(left, 0, fn n, acc ->
        acc + n * Map.get(freq, n, 0)
      end)
      |> IO.puts()
  end
end

Aoc.part1()

Aoc.part2()
