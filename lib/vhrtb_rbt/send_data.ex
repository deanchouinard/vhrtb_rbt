defmodule SendData do

use GenServer
  @vhr_web_url   Application.get_env(:vhrtb_rbt, :send_data_url)
  
  # Client

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end
  
  def send_data() do
    GenServer.call(__MODULE__, :send_data)
  end

  def send_photo() do
    GenServer.call(__MODULE__, :send_photo)
  end

  def send_env(env_data) do
    GenServer.call(__MODULE__, {:send_env, env_data})
  end

  # Server (callbacks)

  @impl true
  def init(stack) do
    HTTPoison.start
    {:ok, stack}
  end

  @impl true
  def handle_call(:send_data, _from, state) do
    response = HTTPoison.get! "#{@vhr_web_url}/hello77"

    {:reply, {response}, state}
  end

  @impl true
  def handle_call({:send_env, env_data}, _from, state) do
    %{:temp => temp, :humid => humid} = env_data
    body ="{\"temp\" : #{temp}, \"humid\": #{humid}}"
    url = "#{@vhr_web_url}/api/env"
    response = HTTPoison.post url, body,
      [{"Content-Type", "application/json"}]
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
end

