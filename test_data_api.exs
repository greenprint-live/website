# Test script to demonstrate the data publishing API
# Run with: mix run test_data_api.exs

alias Greenprint.{Data, Repo}
alias Greenprint.Users

# This script demonstrates how to:
# 1. Create a user, hub, and data sources
# 2. Publish data points via the API
# 3. See real-time updates in the hub display

IO.puts("🚀 Testing Data Publishing API")

# Create a test user if it doesn't exist
user_attrs = %{
  email: "test@example.com",
  password: "password123",
  confirmed_at: DateTime.utc_now()
}

user = case Users.get_user_by_email("test@example.com") do
  nil ->
    {:ok, user} = Users.register_user(user_attrs)
    IO.puts("✅ Created test user: #{user.email}")
    user
  existing_user ->
    IO.puts("✅ Using existing test user: #{existing_user.email}")
    existing_user
end

# Create a test hub
hub_attrs = %{
  owner_user_id: user.id,
  serial_number: "TEST-HUB-001",
  display_name: "Test Hub",
  description: "A test hub for API demonstration",
  location: "Test Lab"
}

{:ok, hub} = Data.create_gp_hub(hub_attrs)
IO.puts("✅ Created test hub: #{hub.display_name}")

# Create test data sources
data_sources = [
  %{
    owner_gp_hub_id: hub.id,
    display_name: "Temperature Sensor",
    description: "Ambient temperature monitoring",
    type: "temperature"
  },
  %{
    owner_gp_hub_id: hub.id,
    display_name: "Humidity Sensor",
    description: "Relative humidity monitoring",
    type: "humidity"
  },
  %{
    owner_gp_hub_id: hub.id,
    display_name: "CO2 Sensor",
    description: "Carbon dioxide level monitoring",
    type: "co2"
  }
]

created_data_sources = Enum.map(data_sources, fn attrs ->
  {:ok, ds} = Data.create_gp_data_source(attrs)
  IO.puts("✅ Created data source: #{ds.display_name}")
  ds
end)

IO.puts("\n📊 Publishing sample data points...")

# Simulate publishing data points
Enum.each(created_data_sources, fn ds ->
  # Generate sample data based on sensor type
  sample_values = case ds.type do
    "temperature" -> [22.5, 23.1, 22.8, 23.4, 23.0]
    "humidity" -> [45.2, 46.1, 44.8, 47.2, 46.5]
    "co2" -> [420, 425, 418, 430, 422]
    _ -> [50, 52, 48, 55, 51]
  end

  Enum.each(sample_values, fn value ->
    attrs = %{
      owner_gp_data_source_id: ds.id,
      value: value
    }

    {:ok, data_point} = Data.create_gp_data_point(attrs)

    # Simulate the PubSub broadcast that would happen in the API
    Phoenix.PubSub.broadcast(
      Greenprint.PubSub,
      "data_source:#{ds.id}",
      {:data_point_updated, ds.id}
    )

    IO.puts("  📈 #{ds.display_name}: #{value}")

    # Small delay to simulate real-time data
    Process.sleep(100)
  end)
end)

IO.puts("\n🎯 Test Results:")
IO.puts("Hub ID: #{hub.id}")
IO.puts("Hub URL: http://localhost:4000/dashboard/hub/#{hub.id}")
IO.puts("\n📡 API Endpoints:")
IO.puts("POST /api/data_sources/{data_source_id}/data_points")
IO.puts("Body: {\"value\": 25.5}")
IO.puts("\nExample curl command:")

temp_sensor = Enum.find(created_data_sources, &(&1.type == "temperature"))
IO.puts("""
curl -X POST http://localhost:4000/api/data_sources/#{temp_sensor.id}/data_points \\
  -H "Content-Type: application/json" \\
  -H "Authorization: Bearer YOUR_TOKEN" \\
  -d '{"value": 25.5}'
""")

IO.puts("\n✨ Open the hub URL in your browser to see real-time updates!")
IO.puts("   The sensor cards will show the latest data and trends.")
