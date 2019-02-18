# AppEnv

Copy environment variables to Application config. Intended to be used at runtime to override config values using environment variables.

## Examples

Copying a value wholesale.

```elixir
%{"foo" => "bar"} = Application.get_env(:my_app, :my_config)
"1" = System.get_env("FOO")

:ok = AppEnv.copy("FOO", :my_app, :my_config)

"1" = Application.get_env(:my_config, :my_config)
```

Copying a value with custom parsing and merging.

```elixir
%{"foo" => "bar"} = Application.get_env(:my_app, :my_config)
"1" = System.get_env("FOO")

:ok = AppEnv.copy("FOO", :my_app, :my_config, fn old_value, env_value ->
  case Integer.parse(env_value) do
    {new_value, ""} -> {:ok, Map.put(old_value, "foo", new_value)}
    error -> {:error, "error parsing FOO: #{inspect(error)}"}
  end
end)

%{"foo" => 1} = Application.get_env(:my_config, :my_config)
```

Copying a value to a Kernel.put\_in/3-style path.

```elixir
%{"foo" => "bar"} = Application.get_env(:my_app, :my_config)
"1" = System.get_env("FOO")

:ok = AppEnv.copy_to("FOO", :my_app, :my_config, ["foo"])

%{"foo" => "1"} = Application.get_env(:my_config, :my_config)
```

Copying a value to a Kernel.put\_in/3-style path with custom formatting.


```elixir
%{"foo" => {"bar" => "baz"}} = Application.get_env(:my_app, :my_config)
"1" = System.get_env("FOO_BAR")

:ok = AppEnv.copy_to("FOO_BAR", :my_app, :my_config, ["foo", "bar"], fn env_value ->
  case Integer.parse(env_value) do
    {new_value, ""} -> {:ok, new_value}
    error -> {:error, "error parsing FOO: #{inspect(error)}"}
  end
end)

%{"foo" => {"bar" => 1}} = Application.get_env(:my_config, :my_config)
```

## Installation

The package can be installed by adding `app_env` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:app_env, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/app_env](https://hexdocs.pm/app_env).

