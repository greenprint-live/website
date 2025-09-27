defmodule Greenprint.Data do
  @moduledoc """
  The Data context with comprehensive type specifications.

  This module provides a unified interface for all data-related operations
  including GPHubs, GPDataSources, GPDataPoints, and GPDataSourceConfigurations.
  """

  import Ecto.Query, warn: false
  alias Greenprint.Repo
  alias Greenprint.Types

  alias Greenprint.Data.{GPHub, GPDataSource, GPDataPoint, GPDataSourceConfiguration}
  alias Greenprint.Users.User

  ## GPHub operations

  @doc """
  Gets a single GPHub by ID.

  ## Examples

      iex> get_gp_hub!(123)
      %GPHub{}

      iex> get_gp_hub!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_gp_hub!(Types.gp_hub_id()) :: GPHub.t()
  def get_gp_hub!(id), do: Repo.get!(GPHub, id)

  @doc """
  Gets a single GPHub by ID, returns nil if not found.

  ## Examples

      iex> get_gp_hub(123)
      %GPHub{}

      iex> get_gp_hub(456)
      nil

  """
  @spec get_gp_hub(Types.gp_hub_id()) :: GPHub.t() | nil
  def get_gp_hub(id), do: Repo.get(GPHub, id)

  @doc """
  Gets a GPHub by serial number.

  ## Examples

      iex> get_gp_hub_by_serial_number("GP-001")
      %GPHub{}

      iex> get_gp_hub_by_serial_number("unknown")
      nil

  """
  @spec get_gp_hub_by_serial_number(Types.serial_number()) :: GPHub.t() | nil
  def get_gp_hub_by_serial_number(serial_number) when is_binary(serial_number) do
    Repo.get_by(GPHub, serial_number: serial_number)
  end

  @doc """
  Lists all GPHubs for a given user.

  ## Examples

      iex> list_user_gp_hubs(user_id)
      [%GPHub{}, ...]

  """
  @spec list_user_gp_hubs(Types.user_id()) :: [GPHub.t()]
  def list_user_gp_hubs(user_id) when is_binary(user_id) do
    from(h in GPHub, where: h.owner_user_id == ^user_id, order_by: [desc: h.inserted_at])
    |> Repo.all()
  end

  @doc """
  Lists all GPHubs with optional preloading.

  ## Examples

      iex> list_gp_hubs()
      [%GPHub{}, ...]

      iex> list_gp_hubs(preload: [:owner_user])
      [%GPHub{owner_user: %User{}}, ...]

  """
  @spec list_gp_hubs(Types.opts()) :: [GPHub.t()]
  def list_gp_hubs(opts \\ []) do
    query = from(h in GPHub, order_by: [desc: h.inserted_at])

    case Keyword.get(opts, :preload) do
      nil -> Repo.all(query)
      preloads -> Repo.all(query) |> Repo.preload(preloads)
    end
  end

  @doc """
  Creates a GPHub.

  ## Examples

      iex> create_gp_hub(%{field: value})
      {:ok, %GPHub{}}

      iex> create_gp_hub(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_gp_hub(Types.attrs()) :: Types.repo_result(GPHub.t())
  def create_gp_hub(attrs \\ %{}) do
    %GPHub{}
    |> GPHub.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a GPHub.

  ## Examples

      iex> update_gp_hub(gp_hub, %{field: new_value})
      {:ok, %GPHub{}}

      iex> update_gp_hub(gp_hub, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_gp_hub(GPHub.t(), Types.attrs()) :: Types.repo_result(GPHub.t())
  def update_gp_hub(%GPHub{} = gp_hub, attrs) do
    gp_hub
    |> GPHub.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a GPHub.

  ## Examples

      iex> delete_gp_hub(gp_hub)
      {:ok, %GPHub{}}

      iex> delete_gp_hub(gp_hub)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_gp_hub(GPHub.t()) :: Types.repo_result(GPHub.t())
  def delete_gp_hub(%GPHub{} = gp_hub) do
    Repo.delete(gp_hub)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking GPHub changes.

  ## Examples

      iex> change_gp_hub(gp_hub)
      %Ecto.Changeset{data: %GPHub{}}

  """
  @spec change_gp_hub(GPHub.t(), Types.attrs()) :: Types.changeset(GPHub.t())
  def change_gp_hub(%GPHub{} = gp_hub, attrs \\ %{}) do
    GPHub.changeset(gp_hub, attrs)
  end

  ## GPDataSource operations

  @doc """
  Gets a single GPDataSource by ID.

  ## Examples

      iex> get_gp_data_source!(123)
      %GPDataSource{}

      iex> get_gp_data_source!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_gp_data_source!(Types.gp_data_source_id()) :: GPDataSource.t()
  def get_gp_data_source!(id), do: Repo.get!(GPDataSource, id)

  @doc """
  Gets a single GPDataSource by ID, returns nil if not found.

  ## Examples

      iex> get_gp_data_source(123)
      %GPDataSource{}

      iex> get_gp_data_source(456)
      nil

  """
  @spec get_gp_data_source(Types.gp_data_source_id()) :: GPDataSource.t() | nil
  def get_gp_data_source(id), do: Repo.get(GPDataSource, id)

  @doc """
  Lists all GPDataSources for a given GPHub.

  ## Examples

      iex> list_gp_hub_data_sources(gp_hub_id)
      [%GPDataSource{}, ...]

  """
  @spec list_gp_hub_data_sources(Types.gp_hub_id()) :: [GPDataSource.t()]
  def list_gp_hub_data_sources(gp_hub_id) when is_binary(gp_hub_id) do
    from(ds in GPDataSource,
         where: ds.owner_gp_hub_id == ^gp_hub_id,
         order_by: [asc: ds.display_name])
    |> Repo.all()
  end

  @doc """
  Lists all GPDataSources with optional filtering and preloading.

  ## Examples

      iex> list_gp_data_sources()
      [%GPDataSource{}, ...]

      iex> list_gp_data_sources(type: "temperature", preload: [:owner_gp_hub])
      [%GPDataSource{owner_gp_hub: %GPHub{}}, ...]

  """
  @spec list_gp_data_sources(Types.opts()) :: [GPDataSource.t()]
  def list_gp_data_sources(opts \\ []) do
    query = from(ds in GPDataSource, order_by: [asc: ds.display_name])

    query = case Keyword.get(opts, :type) do
      nil -> query
      type -> from(ds in query, where: ds.type == ^type)
    end

    case Keyword.get(opts, :preload) do
      nil -> Repo.all(query)
      preloads -> Repo.all(query) |> Repo.preload(preloads)
    end
  end

  @doc """
  Creates a GPDataSource.

  ## Examples

      iex> create_gp_data_source(%{field: value})
      {:ok, %GPDataSource{}}

      iex> create_gp_data_source(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_gp_data_source(Types.attrs()) :: Types.repo_result(GPDataSource.t())
  def create_gp_data_source(attrs \\ %{}) do
    %GPDataSource{}
    |> GPDataSource.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a GPDataSource.

  ## Examples

      iex> update_gp_data_source(gp_data_source, %{field: new_value})
      {:ok, %GPDataSource{}}

      iex> update_gp_data_source(gp_data_source, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_gp_data_source(GPDataSource.t(), Types.attrs()) :: Types.repo_result(GPDataSource.t())
  def update_gp_data_source(%GPDataSource{} = gp_data_source, attrs) do
    gp_data_source
    |> GPDataSource.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a GPDataSource.

  ## Examples

      iex> delete_gp_data_source(gp_data_source)
      {:ok, %GPDataSource{}}

      iex> delete_gp_data_source(gp_data_source)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_gp_data_source(GPDataSource.t()) :: Types.repo_result(GPDataSource.t())
  def delete_gp_data_source(%GPDataSource{} = gp_data_source) do
    Repo.delete(gp_data_source)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking GPDataSource changes.

  ## Examples

      iex> change_gp_data_source(gp_data_source)
      %Ecto.Changeset{data: %GPDataSource{}}

  """
  @spec change_gp_data_source(GPDataSource.t(), Types.attrs()) :: Types.changeset(GPDataSource.t())
  def change_gp_data_source(%GPDataSource{} = gp_data_source, attrs \\ %{}) do
    GPDataSource.changeset(gp_data_source, attrs)
  end

  ## GPDataPoint operations

  @doc """
  Gets a single GPDataPoint by ID.

  ## Examples

      iex> get_gp_data_point!(123)
      %GPDataPoint{}

      iex> get_gp_data_point!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_gp_data_point!(Types.gp_data_point_id()) :: GPDataPoint.t()
  def get_gp_data_point!(id), do: Repo.get!(GPDataPoint, id)

  @doc """
  Gets a single GPDataPoint by ID, returns nil if not found.

  ## Examples

      iex> get_gp_data_point(123)
      %GPDataPoint{}

      iex> get_gp_data_point(456)
      nil

  """
  @spec get_gp_data_point(Types.gp_data_point_id()) :: GPDataPoint.t() | nil
  def get_gp_data_point(id), do: Repo.get(GPDataPoint, id)

  @doc """
  Lists GPDataPoints for a given data source with optional time filtering.

  ## Examples

      iex> list_data_source_points(data_source_id)
      [%GPDataPoint{}, ...]

      iex> list_data_source_points(data_source_id, limit: 100, since: ~U[2024-01-01 00:00:00Z])
      [%GPDataPoint{}, ...]

  """
  @spec list_data_source_points(Types.gp_data_source_id(), Types.opts()) :: [GPDataPoint.t()]
  def list_data_source_points(data_source_id, opts \\ []) when is_binary(data_source_id) do
    query = from(dp in GPDataPoint,
                 where: dp.owner_gp_data_source_id == ^data_source_id,
                 order_by: [desc: dp.inserted_at])

    query = case Keyword.get(opts, :since) do
      nil -> query
      since_time -> from(dp in query, where: dp.inserted_at >= ^since_time)
    end

    query = case Keyword.get(opts, :until) do
      nil -> query
      until_time -> from(dp in query, where: dp.inserted_at <= ^until_time)
    end

    query = case Keyword.get(opts, :limit) do
      nil -> query
      limit -> from(dp in query, limit: ^limit)
    end

    Repo.all(query)
  end

  @doc """
  Creates a single GPDataPoint.

  ## Examples

      iex> create_gp_data_point(%{value: 23.5, owner_gp_data_source_id: data_source_id})
      {:ok, %GPDataPoint{}}

      iex> create_gp_data_point(%{value: "invalid"})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_gp_data_point(Types.attrs()) :: Types.repo_result(GPDataPoint.t())
  def create_gp_data_point(attrs \\ %{}) do
    %GPDataPoint{}
    |> GPDataPoint.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates multiple GPDataPoints in a single transaction for better performance.

  ## Examples

      iex> create_gp_data_points([
      ...>   %{value: 23.5, owner_gp_data_source_id: data_source_id},
      ...>   %{value: 24.1, owner_gp_data_source_id: data_source_id}
      ...> ])
      {:ok, [%GPDataPoint{}, %GPDataPoint{}]}

      iex> create_gp_data_points([%{value: "invalid"}])
      {:error, %Ecto.Changeset{}}

  """
  @spec create_gp_data_points([Types.attrs()]) :: {:ok, [GPDataPoint.t()]} | {:error, Types.changeset(GPDataPoint.t())}
  def create_gp_data_points(data_points_attrs) when is_list(data_points_attrs) do
    changesets = Enum.map(data_points_attrs, fn attrs ->
      %GPDataPoint{}
      |> GPDataPoint.changeset(attrs)
    end)

    if Enum.all?(changesets, &(&1.valid?)) do
      now = DateTime.utc_now() |> DateTime.truncate(:second)

      entries = Enum.map(changesets, fn changeset ->
        changeset.changes
        |> Map.put(:id, Ecto.UUID.generate())
        |> Map.put(:inserted_at, now)
        |> Map.put(:updated_at, now)
      end)

      case Repo.insert_all(GPDataPoint, entries, returning: true) do
        {_count, data_points} -> {:ok, data_points}
        error -> error
      end
    else
      invalid_changeset = Enum.find(changesets, &(!&1.valid?))
      {:error, invalid_changeset}
    end
  end

  @doc """
  Gets the latest GPDataPoint for a given data source.

  ## Examples

      iex> get_latest_data_point(data_source_id)
      %GPDataPoint{}

      iex> get_latest_data_point("nonexistent")
      nil

  """
  @spec get_latest_data_point(Types.gp_data_source_id()) :: GPDataPoint.t() | nil
  def get_latest_data_point(data_source_id) when is_binary(data_source_id) do
    from(dp in GPDataPoint,
         where: dp.owner_gp_data_source_id == ^data_source_id,
         order_by: [desc: dp.inserted_at],
         limit: 1)
    |> Repo.one()
  end

  @doc """
  Gets recent data points for trend analysis.

  ## Examples

      iex> get_recent_data_points("data_source_id", 10)
      [%GPDataPoint{}, ...]

  """
  @spec get_recent_data_points(Types.gp_data_source_id(), integer()) :: [GPDataPoint.t()]
  def get_recent_data_points(data_source_id, limit \\ 10) when is_binary(data_source_id) do
    from(dp in GPDataPoint,
         where: dp.owner_gp_data_source_id == ^data_source_id,
         order_by: [desc: dp.inserted_at],
         limit: ^limit)
    |> Repo.all()
  end

  @doc """
  Gets data source with its latest data point and recent trend.

  ## Examples

      iex> get_data_source_with_latest("data_source_id")
      %{data_source: %GPDataSource{}, latest: %GPDataPoint{}, trend: "up"}

  """
  @spec get_data_source_with_latest(Types.gp_data_source_id()) ::
    %{data_source: GPDataSource.t() | nil, latest: GPDataPoint.t() | nil, trend: String.t()}
  def get_data_source_with_latest(data_source_id) when is_binary(data_source_id) do
    data_source = get_gp_data_source(data_source_id)
    latest = get_latest_data_point(data_source_id)
    recent_points = get_recent_data_points(data_source_id, 5)

    trend = calculate_trend(recent_points)

    %{
      data_source: data_source,
      latest: latest,
      trend: trend
    }
  end

  defp calculate_trend([]), do: "stable"
  defp calculate_trend([_single]), do: "stable"
  defp calculate_trend([latest, previous | _]) do
    cond do
      latest.value > previous.value -> "up"
      latest.value < previous.value -> "down"
      true -> "stable"
    end
  end

  @doc """
  Gets aggregated statistics for data points within a time range.

  ## Examples

      iex> get_data_point_stats(data_source_id, ~U[2024-01-01 00:00:00Z], ~U[2024-01-02 00:00:00Z])
      %{min: 20.1, max: 25.3, avg: 22.7, count: 144}

  """
  @spec get_data_point_stats(Types.gp_data_source_id(), DateTime.t(), DateTime.t()) ::
    %{min: float() | nil, max: float() | nil, avg: float() | nil, count: integer()}
  def get_data_point_stats(data_source_id, start_time, end_time)
      when is_binary(data_source_id) do
    from(dp in GPDataPoint,
         where: dp.owner_gp_data_source_id == ^data_source_id,
         where: dp.inserted_at >= ^start_time,
         where: dp.inserted_at <= ^end_time,
         select: %{
           min: min(dp.value),
           max: max(dp.value),
           avg: avg(dp.value),
           count: count(dp.id)
         })
    |> Repo.one()
  end

  @doc """
  Deletes old data points beyond a certain age to manage storage.

  ## Examples

      iex> cleanup_old_data_points(days: 30)
      {1250, nil}

  """
  @spec cleanup_old_data_points(Types.opts()) :: {integer(), nil}
  def cleanup_old_data_points(opts \\ []) do
    days = Keyword.get(opts, :days, 90)
    cutoff_date = DateTime.utc_now() |> DateTime.add(-days, :day)

    from(dp in GPDataPoint, where: dp.inserted_at < ^cutoff_date)
    |> Repo.delete_all()
  end

  ## GPDataSourceConfiguration operations

  @doc """
  Gets a GPDataSourceConfiguration by data source ID.

  ## Examples

      iex> get_data_source_configuration(data_source_id)
      %GPDataSourceConfiguration{}

      iex> get_data_source_configuration("nonexistent")
      nil

  """
  @spec get_data_source_configuration(Types.gp_data_source_id()) :: GPDataSourceConfiguration.t() | nil
  def get_data_source_configuration(data_source_id) when is_binary(data_source_id) do
    Repo.get_by(GPDataSourceConfiguration, data_source_id: data_source_id)
  end

  @doc """
  Creates or updates a GPDataSourceConfiguration.

  ## Examples

      iex> upsert_data_source_configuration(data_source_id, %{alarms: %{high: 30.0, low: 10.0}})
      {:ok, %GPDataSourceConfiguration{}}

  """
  @spec upsert_data_source_configuration(Types.gp_data_source_id(), Types.attrs()) ::
    Types.repo_result(GPDataSourceConfiguration.t())
  def upsert_data_source_configuration(data_source_id, attrs) when is_binary(data_source_id) do
    attrs_with_id = Map.put(attrs, :data_source_id, data_source_id)

    case get_data_source_configuration(data_source_id) do
      nil ->
        %GPDataSourceConfiguration{}
        |> GPDataSourceConfiguration.changeset(attrs_with_id)
        |> Repo.insert()

      existing_config ->
        existing_config
        |> GPDataSourceConfiguration.changeset(attrs)
        |> Repo.update()
    end
  end

  @doc """
  Deletes a GPDataSourceConfiguration.

  ## Examples

      iex> delete_data_source_configuration(config)
      {:ok, %GPDataSourceConfiguration{}}

  """
  @spec delete_data_source_configuration(GPDataSourceConfiguration.t()) ::
    Types.repo_result(GPDataSourceConfiguration.t())
  def delete_data_source_configuration(%GPDataSourceConfiguration{} = config) do
    Repo.delete(config)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking GPDataSourceConfiguration changes.

  ## Examples

      iex> change_data_source_configuration(config)
      %Ecto.Changeset{data: %GPDataSourceConfiguration{}}

  """
  @spec change_data_source_configuration(GPDataSourceConfiguration.t(), Types.attrs()) ::
    Types.changeset(GPDataSourceConfiguration.t())
  def change_data_source_configuration(%GPDataSourceConfiguration{} = config, attrs \\ %{}) do
    GPDataSourceConfiguration.changeset(config, attrs)
  end

  ## Specialized query helpers

  @doc """
  Gets all data sources with their latest data points for a given hub.

  ## Examples

      iex> get_hub_data_sources_with_latest_points(hub_id)
      [%{data_source: %GPDataSource{}, latest_point: %GPDataPoint{}}, ...]

  """
  @spec get_hub_data_sources_with_latest_points(Types.gp_hub_id()) ::
    [%{data_source: GPDataSource.t(), latest_point: GPDataPoint.t() | nil}]
  def get_hub_data_sources_with_latest_points(hub_id) when is_binary(hub_id) do
    data_sources = list_gp_hub_data_sources(hub_id)

    Enum.map(data_sources, fn data_source ->
      latest_point = get_latest_data_point(data_source.id)
      %{data_source: data_source, latest_point: latest_point}
    end)
  end

  @doc """
  Gets data points for multiple data sources within a time range.
  Useful for dashboard views showing multiple sensors.

  ## Examples

      iex> get_multi_source_data_points([ds1_id, ds2_id], ~U[2024-01-01 00:00:00Z], ~U[2024-01-02 00:00:00Z])
      %{ds1_id => [%GPDataPoint{}, ...], ds2_id => [%GPDataPoint{}, ...]}

  """
  @spec get_multi_source_data_points([Types.gp_data_source_id()], DateTime.t(), DateTime.t()) ::
    %{Types.gp_data_source_id() => [GPDataPoint.t()]}
  def get_multi_source_data_points(data_source_ids, start_time, end_time)
      when is_list(data_source_ids) do
    from(dp in GPDataPoint,
         where: dp.owner_gp_data_source_id in ^data_source_ids,
         where: dp.inserted_at >= ^start_time,
         where: dp.inserted_at <= ^end_time,
         order_by: [asc: dp.inserted_at])
    |> Repo.all()
    |> Enum.group_by(& &1.owner_gp_data_source_id)
  end

  @doc """
  Checks if a user owns a specific GPHub.

  ## Examples

      iex> user_owns_hub?(user_id, hub_id)
      true

      iex> user_owns_hub?(user_id, other_hub_id)
      false

  """
  @spec user_owns_hub?(Types.user_id(), Types.gp_hub_id()) :: boolean()
  def user_owns_hub?(user_id, hub_id) when is_binary(user_id) and is_binary(hub_id) do
    from(h in GPHub, where: h.id == ^hub_id and h.owner_user_id == ^user_id)
    |> Repo.exists?()
  end

  @doc """
  Checks if a GPHub owns a specific GPDataSource.

  ## Examples

      iex> hub_owns_data_source?(hub_id, data_source_id)
      true

      iex> hub_owns_data_source?(hub_id, other_data_source_id)
      false

  """
  @spec hub_owns_data_source?(Types.gp_hub_id(), Types.gp_data_source_id()) :: boolean()
  def hub_owns_data_source?(hub_id, data_source_id)
      when is_binary(hub_id) and is_binary(data_source_id) do
    from(ds in GPDataSource,
         where: ds.id == ^data_source_id and ds.owner_gp_hub_id == ^hub_id)
    |> Repo.exists?()
  end
end
