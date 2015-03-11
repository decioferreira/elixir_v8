# ElixirV8

V8 engine for [Elixir](http://elixir-lang.org/) with pools.

## Examples

Application start:

```
ElixirV8.start
```
or add it in `application` section in mix:

```
def application do
  [mod: {Example, []},
   applications: [ :elixir_v8 ] ]
end
```

### Create pools

```
ElixirV8.create_pool(:default, 10)
```

Where `:default` is name of poll and `10` is size of pool.

Also you can configure ElixirV8 directly from configuration file to get pools automatically created at application startup. In `config/config.exs`, add :

```
config :elixir_v8, pools: [
  test_pool:   [{:size, 10}],
  test_pool_2: [{:size, 20}]
]
```

#### Load js libs to v8

You also can load js libs to each v8 engine in pool:

```
js_undescore_lib = Mix.Project.app_path <> "/priv/underscore-min.js"

ElixirV8.create_pool(:main, 10, [{:file, js_undescore_lib}])
```

Using config in mix:

```
js_undescore_lib = Mix.Project.app_path <> "/priv/underscore-min.js"
js_other_lib = Mix.Project.app_path <> "/priv/some-another-lib.js"

config :elixir_v8,
  pools: [
    main: [
      {:size, 10},
      {:max_overflow, 10},
      {:file, js_undescore_lib},
      {:file, js_other_lib}
    ]
  ]

```

### Delete pools

```
ElixirV8.delete_pool(:default)

ElixirV8.delete_pool(:test)
```

### Usage

Usage of pools (`eval` js code):

```
iex(2)> ElixirV8.eval({:global, :main}, "1+2")
{:ok, 3}
iex(3)> ElixirV8.eval({:global, :main}, "1+2+3")
{:ok, 6}
```

Method `eval_function` is execute function body with some arguments:

```
iex(4)> ElixirV8.eval_function({:global, :main}, "return data + 13", [13])
{:ok, 26}
iex(6)> ElixirV8.eval_function({:global, :main}, "return data * 13", [20])
{:ok, 260}
iex(8)> ElixirV8.eval_function({:global, :main}, "return arguments[0] * arguments[1]", [20, 5])
{:ok, 100}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
