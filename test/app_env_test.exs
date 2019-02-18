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

  test "copies a new value" do
    :ok = AppEnv.copy("FOO", :app_env, :config)
    assert Application.get_env(:app_env, :config) == "1"
  end

  test "copies a new value with a custom merge function" do
    :ok =
      AppEnv.copy("FOO", :app_env, :config, fn old_value, env_value ->
        {new_value, _} = Integer.parse(env_value)
        {:ok, Map.put(old_value, "foo", new_value)}
      end)

    assert Application.get_env(:app_env, :config) == %{"foo" => 1}
  end

  test "copies a new value to a path" do
    :ok = AppEnv.copy_to("FOO", :app_env, :config, ["foo"])
    assert Application.get_env(:app_env, :config) == %{"foo" => "1"}
  end

  test "copies a new value to a path with a custom format function" do
    :ok =
      AppEnv.copy_to("FOO", :app_env, :config, ["foo"], fn env_value ->
        {new_value, _} = Integer.parse(env_value)
        {:ok, new_value}
      end)

    assert Application.get_env(:app_env, :config) == %{"foo" => 1}
  end

  test "handles errors in copying" do
    {:error, "error doing things"} =
      AppEnv.copy("FOO", :app_env, :config, fn _old_value, _env_value ->
        "error doing things"
      end)

    {:error, "another error doing things"} =
      AppEnv.copy("FOO", :app_env, :config, fn _old_value, _env_value ->
        {:error, "another error doing things"}
      end)

    {:error, "error doing things"} =
      AppEnv.copy_to("FOO", :app_env, :config, ["foo"], fn _env_value -> "error doing things" end)

    {:error, "another error doing things"} =
      AppEnv.copy_to("FOO", :app_env, :config, ["foo"], fn _env_value ->
        {:error, "another error doing things"}
      end)
  end
end
