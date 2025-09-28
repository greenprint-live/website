defmodule Greenprint.AgentMail do
  alias Greenprint.AgentMail.Client

  defmodule CreateInboxResponse do
    use TypedStruct

    typedstruct do
      field :inbox_id, String.t()
      field :display_name, String.t()
      field :updated_at, String.t()
      field :created_at, String.t()
      field :client_id, String.t() | nil
    end
  end

  @spec create_inbox(Client.t(), String.t()) :: {:ok, CreateInboxResponse.t()} | {:error, String.t()}
  def create_inbox(%Client{} = client, device_id) do
    client.http_client
    |> Tesla.post("/inboxes", %{username: device_id, domain: "greenprint.live"})
    |> case do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        response = %CreateInboxResponse{
          inbox_id: body["inbox_id"],
          display_name: body["display_name"],
          updated_at: body["updated_at"],
          created_at: body["created_at"],
          client_id: body["client_id"]
        }
        {:ok, response}
      {:ok, %Tesla.Env{status: status, body: body}} -> {:error, "Request failed with status #{status}: #{inspect(body)}"}
      {:error, reason} -> {:error, "Request failed: #{inspect(reason)}"}
    end
  end

  @spec send_email(Client.t(), String.t(), String.t(), String.t(), String.t()) :: {:ok, map()} | {:error, String.t()}
  def send_email(%Client{} = client, inbox_id, targets, subject, body) do
    client.http_client
    |> Tesla.post("/inboxes/#{inbox_id}/messages/send", %{to: targets, subject: subject, text: body})
    |> case do
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, body}
      {:ok, %Tesla.Env{status: status, body: body}} -> {:error, "Request failed with status #{status}: #{inspect(body)}"}
      {:error, reason} -> {:error, "Request failed: #{inspect(reason)}"}
    end
  end
end
