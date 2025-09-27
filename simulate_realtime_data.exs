# Script to simulate real-time data updates for testing
# Run with: mix run simulate_realtime_data.exs

alias Greenprint.{Data, Repo}

IO.puts("🔄 Starting real-time data simulation...")

# Find existing data sources to simulate data for
data_sources = Data.list_gp_data_sources()

if Enum.empty?(data_sources) do
  IO.puts("❌ No data sources found. Please run test_data_api.exs first to create test data.")
  System.halt(1)
end

IO.puts("📊 Found #{length(data_sources)} data sources to simulate")

# Function to generate realistic sensor data
defp generate_sensor_value(type, previous_value \\ nil) do
  base_value = case type do
    "temperature" -> 22.0 + :rand.normal() * 2.0  # 20-24°C range
    "humidity" -> 45.0 + :rand.normal() * 5.0     # 35-55% range
    "co2" -> 420.0 + :rand.normal() * 20.0        # 380-460 ppm range
    "light" -> 300.0 + :rand.normal() * 100.0     # 100-500 lux range
    "motion" -> max(0, :rand.exponential(0.1))    # 0-20 events/hr
    "sound" -> 40.0 + :rand.normal() * 10.0       # 20-60 dB range
    _ -> 50.0 + :rand.normal() * 10.0
  end

  # Add some trend continuity if we have a previous value
  if previous_value do
    # 70% chance to trend toward previous value, 30% random
    if :rand.uniform() < 0.7 do
      previous_value + (base_value - previous_value) * 0.3
    else
      base_value
    end
  else
    base_value
  end
end

# Keep track of last values for trend continuity
last_values = %{}

# Simulate data updates every 2-5 seconds
simulate_data = fn ->
  Enum.each(data_sources, fn ds ->
    # Generate new value with some continuity
    previous = Map.get(last_values, ds.id)
    new_value = generate_sensor_value(ds.type, previous)

    # Clamp values to reasonable ranges
    clamped_value = case ds.type do
      "temperature" -> max(15.0, min(35.0, new_value))
      "humidity" -> max(20.0, min(80.0, new_value))
      "co2" -> max(350.0, min(1000.0, new_value))
      "light" -> max(0.0, min(1000.0, new_value))
      "motion" -> max(0.0, min(50.0, new_value))
      "sound" -> max(20.0, min(80.0, new_value))
      _ -> max(0.0, new_value)
    end

    # Update our tracking
    last_values = Map.put(last_values, ds.id, clamped_value)

    # Create the data point
    attrs = %{
      owner_gp_data_source_id: ds.id,
      value: clamped_value
    }

    case Data.create_gp_data_point(attrs) do
      {:ok, _data_point} ->
        # Broadcast the update (same as the API does)
        Phoenix.PubSub.broadcast(
          Greenprint.PubSub,
          "data_source:#{ds.id}",
          {:data_point_updated, ds.id}
        )

        IO.puts("📈 #{ds.display_name}: #{Float.round(clamped_value, 1)}")

      {:error, changeset} ->
        IO.puts("❌ Error creating data point: #{inspect(changeset)}")
    end
  end)
end

# Initialize last values with current data
Enum.each(data_sources, fn ds ->
  case Data.get_latest_data_point(ds.id) do
    nil -> :ok
    latest -> last_values = Map.put(last_values, ds.id, latest.value)
  end
end)

IO.puts("🚀 Simulation started! Press Ctrl+C to stop.")
IO.puts("📱 Open your hub display page to see real-time updates")

# Run simulation loop
Stream.repeatedly(fn ->
  simulate_data.()

  # Random delay between 2-5 seconds
  delay = 2000 + :rand.uniform(3000)
  Process.sleep(delay)

  :continue
end)
|> Enum.take_while(fn _ -> true end)
