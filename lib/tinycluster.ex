defmodule Tinycluster do
  use GenServer

  def start_link(options) do
    GenServer.start_link(__MODULE__, options)
  end

  @impl true
  def init(options) do
    verbose = Keyword.get(options, :verbose, :silent)
    interval = Keyword.get(options, :connect_interval, 5_000)

    host =
      to_string(node())
      |> String.split("@")
      |> List.last()
      |> String.to_atom()

    {:ok, %{host: host, verbose: verbose, interval: interval}, 0}
  end

  # On timeout, attempt to cluster, then schedule another timeout.
  @impl true
  def handle_info(:timeout, state) do
    %{host: host, verbose: verbose, interval: interval} = state
    connect(host, verbose)
    {:noreply, state, interval}
  end

  # Connect to all nodes registered with epmd on the host of this process
  defp connect(host, verbose) do
    :net_adm.world_list([host], verbose)
    |> Enum.each(&Node.connect/1)
  end
end
