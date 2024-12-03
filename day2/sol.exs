#!/usr/bin/env elixir

defmodule Aoc do
  def sign(x) when x > 0, do: :positive
  def sign(x) when x < 0, do: :negative
  def sign(x) when x == 0, do: :zero

  def part1 do
    File.stream!("input")
    |> Stream.map(fn line ->
      line
      |> String.trim()
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn report ->
      Enum.reduce(tl(report), {[], hd(report)}, fn val, {list, last_val} ->
        {[val - last_val | list], val}
      end)
      |> then(&elem(&1, 0))
      |> then(&(Enum.all?(&1, fn x -> sign(x) == :positive end) or Enum.all?(&1, fn x -> sign(x) == :negative end)) and Enum.all?(&1, fn x -> abs(x) >= 1 and abs(x) <= 3 end))
    end)
    |> Enum.count(&Function.identity/1)
    |> IO.puts()
  end

  def check_valid(sequence) do
    check_valid(:positive, sequence) or check_valid(:negative, sequence)
  end

  def check_valid(direction, sequence) do
    check_valid_aux(direction, sequence, 1) or check_valid_aux(direction, tl(sequence), 0)
  end

  defguard is_direction(direction, a, b) when (direction == :positive and a < b) or (direction == :negative and a > b)

  def check_valid_aux(_direction, _list, skips_allowed) when skips_allowed < 0, do: false

  def check_valid_aux(_direction, [_a], _skips_allowed), do: true

  def check_valid_aux(direction, [a, b | rest] = list, skips_allowed) when abs(b - a) >= 1 and abs(b - a) <= 3 and is_direction(direction, a, b) do
    check_valid_aux(direction, tl(list), skips_allowed) or check_valid_aux(direction, [a | rest], skips_allowed - 1)
  end

  def check_valid_aux(direction, [a, _b | rest], skips_allowed) do
    check_valid_aux(direction, [a | rest], skips_allowed - 1)
  end

  def check_valid_aux(_direction, _list, _skips_allowed), do: false

  def part2 do
    File.stream!("input")
    |> Stream.map(fn line ->
      line
      |> String.trim()
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(&check_valid/1)
    |> Enum.count(&Function.identity/1)
    |> IO.puts()
  end
end

Aoc.part1()

Aoc.part2()
