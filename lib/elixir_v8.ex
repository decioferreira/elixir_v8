defmodule ElixirV8 do
  use Application

  def start(_type, _args) do
    ElixirV8.Supervisor.start_link()
  end

  def stop(_state) do
    :ok
  end

  def start do
    :application.start(__MODULE__)
  end

  def stop do
    :application.stop(__MODULE__)
  end

  def create_pool(pool_name, size) do
    ElixirV8.Supervisor.create_pool(pool_name, size, [])
  end

  def create_pool(pool_name, size, args) do
    ElixirV8.Supervisor.create_pool(pool_name, size, args)
  end

  def delete_pool(pool_name) do
    ElixirV8.Supervisor.delete_pool(pool_name)
  end

  def eval(pool_name, source) do
    eval(pool_name, source, timeout())
  end

  def eval(pool_name, source, timeout) do
    :poolboy.transaction(pool_name, fn(vm) ->
      ElixirV8.VM.eval(vm, source, timeout)
    end)
  end

  def eval_function(pool_name, source, args) do
    eval_function(pool_name, source, args, timeout())
  end

  def eval_function(pool_name, source, args, timeout) do
    f = fn(worker) ->
      js_args = case JSX.encode(args) do
        { :ok, data } -> data
        { :error, _ } -> []
      end
      js_function = "(function(){ var data = arguments[0]; " <> source <> "}).apply(null, " <> js_args <> ");"
      ElixirV8.VM.eval(worker, js_function, timeout)
    end
    :poolboy.transaction(pool_name, f)
  end

  defp timeout do
    5000
  end
end
