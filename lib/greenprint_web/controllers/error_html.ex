defmodule GreenprintWeb.ErrorHTML do
  @moduledoc """
  This module is invoked by your endpoint in case of errors on HTML requests.
  Includes comprehensive type specifications.

  See config/config.exs.
  """
  use GreenprintWeb, :html

  alias Greenprint.Types

  # If you want to customize your error pages,
  # uncomment the embed_templates/1 call below
  # and add pages to the error directory:
  #
  #   * lib/greenprint_web/controllers/error_html/404.html.heex
  #   * lib/greenprint_web/controllers/error_html/500.html.heex
  #
  # embed_templates "error_html/*"

  # The default is to render a plain text page based on
  # the template name. For example, "404.html" becomes
  # "Not Found".
  @spec render(String.t(), Types.assigns()) :: String.t()
  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
