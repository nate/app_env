defmodule AppEnv do
  def copy(env_var_name, app_name, config_key, format_and_merge_function) do
    with {:env_value, env_value} when not is_nil(env_value) <-
           {:env_value, System.get_env(env_var_name)},
         {:format_and_merge, {:ok, new_value}} <-
           {:format_and_merge,
            format_and_merge_function.(Application.get_env(app_name, config_key), env_value)} do
      Application.put_env(app_name, config_key, new_value)
    else
      {:env_value, nil} -> :ok
      {:format_and_merge, {:error, error}} -> {:error, error}
      {:format_and_merge, error} -> {:error, error}
    end
  end

  def copy(env_var_name, app_name, config_key) do
    copy(env_var_name, app_name, config_key, fn _, env_value -> {:ok, env_value} end)
  end
end
