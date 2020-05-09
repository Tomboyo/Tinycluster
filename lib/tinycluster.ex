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

    schedule_connect(0)

    {:ok, %{host: host, verbose: verbose, interval: interval}}
  end

  defp schedule_connect(interval) do
    Process.send_after(self(), :connect, interval)
  end

  @impl true
  def handle_info(:connect, state) do
    %{host: host, verbose: verbose, interval: interval} = state
    connect(host, verbose)
    schedule_connect(interval)
    {:noreply, state}
  end

  # Connect to all nodes registered with epmd on the host of this process
  def connect(host, verbose \\ :silent) do
    :net_adm.world_list([host], verbose)
    |> Enum.each(&Node.connect/1)
  end
end
