defmodule AppEnv do
  @moduledoc """
  Copy environment variables to Application config. Intended to be used at runtime to override config values using environment variables.
  """

  @doc """
  Copies the value of the environment variable `env_var_name` to config
  `config_key` in in application `app_name`. It passes the current config value
  and the env var value through `format_and_merge_fn` to allow you to parse the
  new value and merge it into the existing config. This function must return
  `{:ok, new_value}`. Anything else will cause this function to return
  `{:error, error}`.
  """
  def copy(env_var_name, app_name, config_key, format_and_merge_fn) do
    with {:env_value, env_value} when not is_nil(env_value) <-
           {:env_value, System.get_env(env_var_name)},
         {:format_and_merge, {:ok, new_value}} <-
           {:format_and_merge,
            format_and_merge_fn.(Application.get_env(app_name, config_key), env_value)} do
      Application.put_env(app_name, config_key, new_value)
    else
      {:env_value, nil} -> :ok
      {:format_and_merge, {:error, error}} -> {:error, error}
      {:format_and_merge, error} -> {:error, error}
    end
  end

  @doc """
  Copies the value of the environment variable `env_var_name` to config
  `config_key` in in application `app_name`.
  """
  def copy(env_var_name, app_name, config_key) do
    copy(env_var_name, app_name, config_key, fn _, env_value -> {:ok, env_value} end)
  end

  @doc """
  Copies the value of the environment variable `env_var_name` to config
  `config_key` in in application `app_name` using Kernel.put_in/3 to put the new
  value in the `path` location. It passes the env var value through `format_fn`
  to allow you to parse the new value and merge it into the existing config.
  This function must return `{:ok, new_value}`. Anything else will cause this
  function to return `{:error, error}`.
  """
  def copy_to(env_var_name, app_name, config_key, path, format_fn) do
    with {:env_value, env_value} when not is_nil(env_value) <-
           {:env_value, System.get_env(env_var_name)},
         {:format, {:ok, new_value}} <- {:format, format_fn.(env_value)},
         {:old_value, old_value} <- {:old_value, Application.get_env(app_name, config_key)} do
      Application.put_env(app_name, config_key, put_in(old_value, path, new_value))
    else
      {:env_value, nil} ->
        :ok

      {:format, {:error, error}} ->
        {:error, error}

      {:format, error} ->
        {:error, error}

      {:old_value, nil} ->
        :ok
    end
  end

  @doc """
  Copies the value of the environment variable `env_var_name` to config
  `config_key` in in application `app_name` using Kernel.put_in/3 to put the new
  value in the `path` location.
  """
  def copy_to(env_var_name, app_name, config_key, path) do
    copy_to(env_var_name, app_name, config_key, path, fn v -> {:ok, v} end)
  end
end
