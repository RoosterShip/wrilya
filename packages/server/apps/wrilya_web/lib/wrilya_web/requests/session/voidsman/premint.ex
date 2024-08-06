defmodule WrilyaWeb.Requests.Session.Voidsman.Premint do
  use Request.Validator

  # Get the validation rules that apply to the incoming request.
  @impl Request.Validator
  def rules(_) do
    [
      portrait: [:required, :string, {:min, 7}, {:max, 8}],
      name: [:required, :string, {:min, 5}, {:max, 20}],
      home: [:required, :numeric, {:min, 1}, {:max, 10}]
    ]
  end

  # Determine if the user is authorized to make this request.
  @impl Request.Validator
  def authorize(_), do: true
end
