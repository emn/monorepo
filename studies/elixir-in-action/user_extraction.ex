defmodule UserExtraction do
  @spec extract_login(map) :: tuple
  defp extract_login(%{"login" => login}), do: {:ok, login}
  defp extract_login(_), do: {:error, "login missing"}

  @spec extract_email(map) :: tuple
  defp extract_email(%{"email" => email}), do: {:ok, email}
  defp extract_email(_), do: {:error, "email missing"}

  @spec extract_password(map) :: tuple
  defp extract_password(%{"password" => password}), do: {:ok, password}
  defp extract_password(_), do: {:error, "password missing"}

  @spec extract_user(map) :: tuple
  def extract_user(user) do
    with {:ok, login} <- extract_login(user),
         {:ok, email} <- extract_email(user),
         {:ok, password} <- extract_password(user) do
      {:ok, %{login: login, email: email, password: password}}
    end
  end

  @spec test_extract_user :: tuple
  def test_extract_user do
    data = %{
      "login" => "alice",
      "email" => "some_email",
      "password" => "password",
      "other_field" => "some_value",
      "yet_another_field" => "..."
    }

    extract_user(data)
  end
end
