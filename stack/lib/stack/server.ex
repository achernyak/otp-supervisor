defmodule Stack.Server do
  use GenServer

  # External API

  def start_link(stack) do
    GenServer.start_link(__MODULE__, stack, name: __MODULE__)
  end

  def pop do
    GenServer.call __MODULE__, :pop
  end

  def push(v) do
    GenServer.call __MODULE__, {:push, v}
  end

  # GenServer implementation

  def handle_call(:pop, _from, []), do: raise "Empty stack"
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  def handle_call({:push, v}, _from, stack) do
    new_stack = [v | stack]

    {:reply, new_stack, new_stack}
  end
end
