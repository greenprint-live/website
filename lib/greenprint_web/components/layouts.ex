defmodule GreenprintWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application with type specifications.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use GreenprintWeb, :controller` and
  `use GreenprintWeb, :live_view`.
  """
  use GreenprintWeb, :html

  embed_templates "layouts/*"
end
