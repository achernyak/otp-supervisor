defmodule Stack.Supervisor do
  use Supervisor

  @initial_stack []

  def start_link do
    result = {:ok, sup} = Supervisor.start_link(__MODULE__, [])
    start_workers(sup)
    result
  end

  def start_workers(sup) do
    {:ok, stash} =
      Supervisor.start_child(sup, worker(Stack.Stash, [@initial_stack]))
    Supervisor.start_child(sup, supervisor(Stack.SubSupervisor, [stash]))
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end
