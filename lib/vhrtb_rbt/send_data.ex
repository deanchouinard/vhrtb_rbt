defmodule SendData do

use GenServer
  @vhr_web_url   Application.get_env(:vhrtb_rbt, :send_data_url)
  
  # Client

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: :send_data)
  end

  def push(pid, element) do
    GenServer.cast(pid, {:push, element})
  end

  def get_data(pid) do
    GenServer.call(pid, :get_data)
  end

  def send_data(pid) do
    GenServer.call(pid, :send_data)
  end

  def send_photo(pid) do
    GenServer.call(pid, :send_photo)
  end

  def send_env(pid) do
    GenServer.call(pid, :send_env)
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  # Server (callbacks)

  @impl true
  def init(stack) do
    HTTPoison.start
    {:ok, stack}
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_call(:send_data, _from, state) do
    response = HTTPoison.get! "#{@vhr_web_url}/hello77"

    {:reply, {response}, state}
  end

  @impl true
  def handle_call(:send_env, _from, state) do
    url = "#{@vhr_web_url}/api/env"
    response = HTTPoison.post url, "{\"id\": \"89\", \"body\": \"test\"}", [{"Content-Type", "application/json"}]
    {:reply, {response}, state}
  end

  @impl true
  def handle_call(:send_photo, _from, state) do
    headers = ""
    options = ""
    url = "#{@vhr_web_url}/hello"
    file_name = "MembershipCard.png"
    #    response = HTTPoison.post url, "{\"body\": #{file_data}}", [{"Content-Type", "application/octet-stream" }]
    #    response = HTTPoison.post(url, {:file, "MembershipCard.png"})
    # response = HTTPoison.post!(url, 
    #  {:multipart, [{:file, file_name, 
    #    { ["form-data"], [name: "\"photo\"", 
    #      filename: "\"/path/to/file\""]},[]}]}, headers, options)

    #    response = HTTPoison.post!(url, {:multipart, [{:file, "MembershipCard.png"},
    # {"name", "value"}]})
    response = HTTPoison.post(url, {:multipart, [{"id", "87937"}, {:file, file_name, {"form-data", [{"name", "photo"}, {"filename", Path.basename(file_name)}]}, []}]})
    
    {:reply, {response}, state}
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

