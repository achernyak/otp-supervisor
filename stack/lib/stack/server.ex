defmodule Stack.Server do
  use GenServer

  # External API

  def start_link (stash_pid) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end

  def pop do
    GenServer.call __MODULE__, :pop
  end

  def push(v) do
    GenServer.call __MODULE__, {:push, v}
  end

  # GenServer implementation

  def init(stash_pid) do
    curren_stack = Stack.Stash.get_value stash_pid
    {:ok, {curren_stack, stash_pid}}
  end

  def handle_call(:pop, _from, {[], _stash_pid}) do
    raise "Empty stack"
  end

  def handle_call(:pop, _from, {[head | tail], stash_pid}) do
    {:reply, head, {tail, stash_pid}}
  end

  def handle_call({:push, v}, _from, {current_stack, stash_pid}) do
    new_stack = [v | current_stack]
    {:reply, new_stack, {new_stack, stash_pid}}
  end

  def terminate(_reason, {current_stack, stash_pid}) do
    Stack.Stash.save_value stash_pid, current_stack
  end
end
