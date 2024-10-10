defmodule Bittorrent.CLI do
  def main(argv) do
    case argv do
      ["decode" | [encoded_str | _]] ->
        # You can use print statements as follows for debugging, they'll be visible when running tests.
        # IO.puts("Logs from your program will appear here!")

        decoded_str = Bencode.decode(encoded_str)
        IO.puts(Jason.encode!(decoded_str))

      [command | _] ->
        IO.puts("Unknown command: #{command}")
        System.halt(1)

      [] ->
        IO.puts("Usage: your_bittorrent.sh <command> <args>")
        System.halt(1)
    end
  end
end

defmodule Bencode do
  def decode(encoded_value) when is_binary(encoded_value) do
    binary_data = :binary.bin_to_list(encoded_value)

    if encoded_number?(binary_data) do
      Enum.slice(binary_data, 1..(Enum.count(binary_data) - 2)) |> List.to_string()
    else
      case Enum.find_index(binary_data, fn char -> char == 58 end) do
        nil ->
          IO.puts("The ':' character is not found in the binary")

        index ->
          rest = Enum.slice(binary_data, (index + 1)..-1)
          List.to_string(rest)
      end
    end
  end

  def decode(_), do: "Invalid encoded value: not binary"

  defp encoded_number?(encoded_value) do
    List.first(encoded_value) == 105 && List.last(encoded_value) == 101
  end

  # Enum.slice(encoded_value, 1..Enum.count(encoded_value - 1)) |> List.to_string()
end
