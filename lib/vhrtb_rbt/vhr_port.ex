defmodule VhrPort do

  def hello do
    # port = Port.open({:spawn, "python3 hello.py"}, [:binary])
    port = Port.open({:spawn, "python3"}, [:binary])
    #    port = Port.open({:spawn, "python3"}, [])
    #    send(port, {self(), {:command, "hello"}})
    send(port, {self(), {:command, "print(\"world\");\n"}})
    #send(port, {self(), {:command, "quit()"}})
    #send(port, {self(), :close})

  end
end

