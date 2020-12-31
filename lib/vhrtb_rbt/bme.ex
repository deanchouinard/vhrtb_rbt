defmodule Bme280Sensor do

use GenServer

  # Client

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: :bme)
  end

  def push(pid, element) do
    GenServer.cast(pid, {:push, element})
  end

  def get_data(pid) do
    GenServer.call(pid, :get_data)
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  # Server (callbacks)

  @impl true
  def init(stack) do
    {:ok, stack}
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_call(:get_data, _from, state) do
    {:reply, {70.0, 59.6, 44.2}, state}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end

end

