<script lang="ts">
    import type { GPDataSource } from "$lib/model/Data";
    import { getSensorType } from "$lib/stores/sensorTypes";
    import TemperatureSensor from "./TemperatureSensor.svelte";
    import HumiditySensor from "./HumiditySensor.svelte";
    import CO2Sensor from "./CO2Sensor.svelte";
    import LightSensor from "./LightSensor.svelte";
    import MotionSensor from "./MotionSensor.svelte";
    import SoundSensor from "./SoundSensor.svelte";
    import BaseSensorCard from "./BaseSensorCard.svelte";

    interface Props {
        dataSource: GPDataSource;
    }

    let { dataSource }: Props = $props();

    // Use real data from dataSource or fallback to defaults (reactive)
    let currentValue = $derived(dataSource.currentValue ?? 0);
    let lastUpdated = $derived(dataSource.lastUpdated 
        ? new Date(dataSource.lastUpdated).toLocaleTimeString() 
        : "No data");
    let trend = $derived(dataSource.trend ?? "stable");
    let status = $derived(dataSource.status ?? "inactive");

    // Get sensor type info
    const sensorType = getSensorType(dataSource.type);

    // Component mapping
    const sensorComponents = {
        temperature: TemperatureSensor,
        humidity: HumiditySensor,
        co2: CO2Sensor,
        light: LightSensor,
        motion: MotionSensor,
        sound: SoundSensor
    };

    let SensorComponent = $derived(sensorComponents[dataSource.type as keyof typeof sensorComponents] || BaseSensorCard);
</script>

{#if sensorComponents[dataSource.type as keyof typeof sensorComponents]}
    <SensorComponent 
        {dataSource} 
        {currentValue}
        {lastUpdated}
        {trend} 
        {status} 
    />
{:else}
    <!-- Fallback for unknown sensor types -->
    <BaseSensorCard 
        {dataSource} 
        {sensorType} 
        currentValue={currentValue.toFixed(1)} 
        {lastUpdated}
        {trend} 
        {status}
    />
{/if}
