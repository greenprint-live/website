defmodule Greenprint.AgentMail.Client do
  use TypedStruct

  typedstruct do
    field :api_key, String.t(), enforce: true
    field :http_client, Tesla.Client.t(), enforce: true
  end

  @spec new(String.t()) :: t()
  def new(api_key) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.agentmail.to/v0"},
      {Tesla.Middleware.BearerAuth, token: api_key},
      Tesla.Middleware.JSON
    ]

    %__MODULE__{
      api_key: api_key,
      http_client: Tesla.client(middleware)
    }
  end
end
