defmodule Bme280Sensor do

  def read_sensor() do
   SendData.send_env(%{temp: 70, humid: 50})
  end

end

