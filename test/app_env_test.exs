defmodule AppEnvTest do
  use ExUnit.Case
  # doctest AppEnv

  setup do
    Application.put_env(:app_env, :config, %{"foo" => "bar"})
    System.put_env("FOO", "1")
  end

  test "has a config value" do
    assert Application.get_env(:app_env, :config) == %{"foo" => "bar"}
  end

  test "accepts a new value" do
    :ok = AppEnv.copy("FOO", :app_env, :config)
    assert Application.get_env(:app_env, :config) == "1"
  end

  test "accepts a new value with a custom merge function" do
    :ok =
      AppEnv.copy("FOO", :app_env, :config, fn old_value, env_value ->
        case Integer.parse(env_value) do
          {new_value, _} -> {:ok, Map.put(old_value, "foo", new_value)}
          :error -> {:error, "unable to parse as integer"}
        end
      end)

    assert Application.get_env(:app_env, :config) == %{"foo" => 1}
  end

  test "handles errors" do
    {:error, "error doing things"} =
      AppEnv.copy("FOO", :app_env, :config, fn _old_value, _env_value ->
        "error doing things"
      end)

    {:error, "another error doing things"} =
      AppEnv.copy("FOO", :app_env, :config, fn _old_value, _env_value ->
        {:error, "another error doing things"}
      end)
  end
end
