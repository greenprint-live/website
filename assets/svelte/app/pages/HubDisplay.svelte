<script lang="ts">
    import type { User } from "$lib/model/User";
    import type { GPHub, GPDataSource } from "$lib/model/Data";
    import type { LiveSocket } from "phoenix_live_view";
    import Navbar from "../components/Navbar.svelte";
    import SensorCard from "../components/sensors/SensorCard.svelte";
    import SimulationConfigModal from "../components/dashboard/SimulationConfigModal.svelte";
    import { Card, CardContent } from "$lib/components/ui/card";
    import { Button } from "$lib/components/ui/button";
    import { Badge } from "$lib/components/ui/badge";
    import { ArrowLeft, Activity, Wifi, WifiOff, Play, Square, Settings, Zap } from "@lucide/svelte";
    import { onMount, onDestroy } from "svelte";

    interface Props {
        socket: typeof LiveSocket;
        current_user: User;
        hub: GPHub;
        data_sources: GPDataSource[];
    }

    let { socket, current_user, hub, data_sources }: Props = $props();

    // Simulation configuration interface
    interface SimulationConfig {
        updateInterval: number;
        volatility: number;
        trendStrength: number;
        anomalyChance: number;
        burstMode: boolean;
        burstIntensity: number;
        enableSpikes: boolean;
        spikeIntensity: number;
    }

    // Real-time state management
    let realtimeDataSources = $state([...data_sources]);
    let connectionStatus = $state<"connected" | "disconnected" | "connecting">("connected");
    let lastUpdateTime = $state<Date | null>(null);
    let isSimulating = $state(false);
    let sensorIntervals = $state<Map<string, number>>(new Map());
    let showConfigModal = $state(false);
    let currentConfig = $state<SimulationConfig | null>(null);
    let simulationStats = $state({
        totalUpdates: 0,
        anomaliesGenerated: 0,
        spikesGenerated: 0,
        startTime: null as Date | null
    });
    let sensorActivity = $state<Map<string, { lastUpdate: Date, updateCount: number }>>(new Map());

    function goBackToDashboard() {
        window.history.back();
    }

    function handleDataSourceUpdate(event: Event) {
        const customEvent = event as CustomEvent;
        const { data_source_id, data_source } = customEvent.detail;
        console.log("🔄 Updating data source:", data_source_id, data_source);
        
        // Find the old data source for comparison
        const oldDataSource = realtimeDataSources.find(ds => ds.id === data_source_id);
        console.log("📊 Old data:", oldDataSource?.currentValue, "New data:", data_source.currentValue);
        
        // Update the specific data source in our reactive array
        realtimeDataSources = realtimeDataSources.map(ds => 
            ds.id === data_source_id ? { ...ds, ...data_source } : ds
        );
        
        lastUpdateTime = new Date();
        
        // Show a brief visual feedback
        showUpdateFeedback(data_source_id);
    }

    function handleConnectionStatus(event: Event) {
        const customEvent = event as CustomEvent;
        const { status } = customEvent.detail;
        connectionStatus = status;
        console.log("🔗 Connection status changed:", status);
    }

    function showUpdateFeedback(dataSourceId: string) {
        // Add a brief highlight effect to the updated sensor card
        const cardElement = document.querySelector(`[data-sensor-id="${dataSourceId}"]`);
        if (cardElement) {
            cardElement.classList.add('sensor-updated');
            setTimeout(() => {
                cardElement.classList.remove('sensor-updated');
            }, 1000);
        }
    }

    function generateSensorValue(type: string, previousValue?: number, config?: SimulationConfig): number {
        if (!config) return previousValue || 0;

        // Base ranges for each sensor type
        const sensorRanges = {
            temperature: { min: 15, max: 35, typical: 22 },
            humidity: { min: 20, max: 80, typical: 45 },
            co2: { min: 350, max: 1000, typical: 420 },
            light: { min: 0, max: 1000, typical: 300 },
            motion: { min: 0, max: 50, typical: 5 },
            sound: { min: 20, max: 80, typical: 40 }
        };

        const range = sensorRanges[type as keyof typeof sensorRanges] || { min: 0, max: 100, typical: 50 };
        
        // Check for anomaly
        const isAnomaly = Math.random() * 100 < config.anomalyChance;
        if (isAnomaly) {
            simulationStats.anomaliesGenerated++;
            console.log(`🚨 Generating anomaly for ${type}`);
        }

        // Check for spike
        const isSpike = config.enableSpikes && Math.random() * 100 < (config.anomalyChance / 2);
        if (isSpike) {
            simulationStats.spikesGenerated++;
            console.log(`⚡ Generating spike for ${type}`);
        }

        let newValue: number;

        if (isSpike) {
            // Generate extreme spike
            const spikeMultiplier = config.spikeIntensity / 100;
            const direction = Math.random() > 0.5 ? 1 : -1;
            newValue = range.typical + (range.max - range.typical) * spikeMultiplier * direction;
        } else if (isAnomaly) {
            // Generate anomalous but not extreme value
            const anomalyRange = (range.max - range.min) * 0.3;
            newValue = range.min + Math.random() * (range.max - range.min);
        } else {
            // Normal value generation with volatility
            const volatilityFactor = config.volatility / 100;
            const trendFactor = config.trendStrength / 100;
            
            if (previousValue !== undefined && Math.random() < trendFactor) {
                // Continue trend
                const maxChange = (range.max - range.min) * volatilityFactor * 0.1;
                const change = (Math.random() - 0.5) * maxChange;
                newValue = previousValue + change;
            } else {
                // Random value within volatility range
                const centerPoint = range.typical;
                const volatilityRange = (range.max - range.min) * volatilityFactor;
                newValue = centerPoint + (Math.random() - 0.5) * volatilityRange;
            }
        }

        // Clamp to sensor limits
        return Math.max(range.min, Math.min(range.max, newValue));
    }

    function clampSensorValue(type: string, value: number): number {
        switch (type) {
            case "temperature": return Math.max(15.0, Math.min(35.0, value));
            case "humidity": return Math.max(20.0, Math.min(80.0, value));
            case "co2": return Math.max(350.0, Math.min(1000.0, value));
            case "light": return Math.max(0.0, Math.min(1000.0, value));
            case "motion": return Math.max(0.0, Math.min(50.0, value));
            case "sound": return Math.max(20.0, Math.min(80.0, value));
            default: return Math.max(0.0, value);
        }
    }

    async function simulateDataPoint(dataSource: GPDataSource, config: SimulationConfig) {
        const previousValue = dataSource.currentValue || undefined;
        const newValue = generateSensorValue(dataSource.type, previousValue, config);

        try {
            const response = await fetch(`/api/data_sources/${dataSource.id}/data_points`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.getAttribute("content") || ""
                },
                body: JSON.stringify({ value: newValue })
            });

            if (!response.ok) {
                console.error("Failed to simulate data point:", response.statusText);
            } else {
                simulationStats.totalUpdates++;
                
                // Update sensor activity tracking
                const activity = sensorActivity.get(dataSource.id) || { lastUpdate: new Date(), updateCount: 0 };
                activity.lastUpdate = new Date();
                activity.updateCount++;
                sensorActivity.set(dataSource.id, activity);
                
                console.log(`📊 ${dataSource.displayName}: ${newValue.toFixed(1)} (${activity.updateCount} updates)`);
            }
        } catch (error) {
            console.error("Error simulating data point:", error);
        }
    }

    function getRandomizedInterval(baseInterval: number, sensorType: string): number {
        // Different sensor types have different natural update frequencies
        const sensorMultipliers = {
            temperature: 1.2,    // Slower updates (temperature changes slowly)
            humidity: 1.1,       // Slightly slower
            co2: 0.8,           // Faster updates (CO2 can change quickly)
            light: 0.6,         // Very fast updates (light changes rapidly)
            motion: 0.4,        // Fastest updates (motion is event-based)
            sound: 0.5          // Fast updates (sound varies quickly)
        };
        
        const multiplier = sensorMultipliers[sensorType as keyof typeof sensorMultipliers] || 1.0;
        const adjustedInterval = baseInterval * multiplier;
        
        // Add significant randomness (±50% of the interval)
        const jitter = adjustedInterval * 0.5;
        const randomizedInterval = adjustedInterval + (Math.random() - 0.5) * jitter;
        
        // Ensure minimum interval of 100ms
        return Math.max(100, randomizedInterval);
    }

    function startSensorSimulation(dataSource: GPDataSource, config: SimulationConfig) {
        const simulateSensor = async () => {
            if (!isSimulating) return;
            
            if (config.burstMode && Math.random() < 0.3) {
                // 30% chance of burst mode for this sensor
                console.log(`💥 Burst mode for ${dataSource.displayName}`);
                for (let i = 0; i < config.burstIntensity; i++) {
                    await simulateDataPoint(dataSource, config);
                    if (i < config.burstIntensity - 1) {
                        await new Promise(resolve => setTimeout(resolve, 100 + Math.random() * 200));
                    }
                }
            } else {
                // Normal single update
                await simulateDataPoint(dataSource, config);
            }
            
            // Schedule next update for this sensor with randomized timing
            if (isSimulating) {
                const nextInterval = getRandomizedInterval(config.updateInterval, dataSource.type);
                const intervalId = window.setTimeout(simulateSensor, nextInterval);
                sensorIntervals.set(dataSource.id, intervalId);
            }
        };
        
        // Start with an initial random delay to stagger sensor starts
        const initialDelay = Math.random() * config.updateInterval;
        const intervalId = window.setTimeout(simulateSensor, initialDelay);
        sensorIntervals.set(dataSource.id, intervalId);
    }

    function startSimulationWithConfig(config: SimulationConfig) {
        if (isSimulating) return;
        
        currentConfig = config;
        isSimulating = true;
        simulationStats = {
            totalUpdates: 0,
            anomaliesGenerated: 0,
            spikesGenerated: 0,
            startTime: new Date()
        };
        
        // Clear any existing intervals
        sensorIntervals.forEach(intervalId => clearTimeout(intervalId));
        sensorIntervals.clear();
        sensorActivity.clear();
        
        console.log("🚀 Starting independent sensor simulation with config:", config);
        console.log("📊 Each sensor will update at its own randomized rate:");
        
        // Start independent simulation for each sensor
        realtimeDataSources.forEach(dataSource => {
            const expectedInterval = getRandomizedInterval(config.updateInterval, dataSource.type);
            console.log(`  • ${dataSource.displayName}: ~${Math.round(expectedInterval)}ms intervals`);
            startSensorSimulation(dataSource, config);
        });
    }

    function openSimulationConfig() {
        showConfigModal = true;
    }

    function stopSimulation() {
        isSimulating = false;
        
        // Clear all sensor intervals
        sensorIntervals.forEach(intervalId => clearTimeout(intervalId));
        sensorIntervals.clear();
        
        console.log("⏹️ Stopped all sensor simulations");
        console.log(`📈 Final stats: ${simulationStats.totalUpdates} total updates`);
        
        // Log per-sensor stats
        sensorActivity.forEach((activity, sensorId) => {
            const sensor = realtimeDataSources.find(ds => ds.id === sensorId);
            if (sensor) {
                console.log(`  • ${sensor.displayName}: ${activity.updateCount} updates`);
            }
        });
    }

    onMount(() => {
        // Listen for real-time updates
        const container = document.getElementById('hub-display-container');
        if (container) {
            container.addEventListener('dataSourceUpdated', handleDataSourceUpdate);
            container.addEventListener('connectionStatus', handleConnectionStatus);
        }

        // Initialize with current data
        realtimeDataSources = [...data_sources];
        
        console.log("🚀 HubDisplay mounted, listening for real-time updates");
    });

    onDestroy(() => {
        // Clean up event listeners
        const container = document.getElementById('hub-display-container');
        if (container) {
            container.removeEventListener('dataSourceUpdated', handleDataSourceUpdate);
            container.removeEventListener('connectionStatus', handleConnectionStatus);
        }
        
        // Stop simulation if running
        stopSimulation();
        
        console.log("🔌 HubDisplay destroyed, cleaned up listeners and simulation");
    });

    // Reactive values for display
    let activeDataSources = $derived(realtimeDataSources.filter(ds => ds.status === "active").length);
    let totalDataSources = $derived(realtimeDataSources.length);
</script>

<style>
    :global(.sensor-updated) {
        animation: pulse-update 1s ease-in-out;
        border-color: rgb(34 197 94) !important;
    }

    @keyframes pulse-update {
        0% { 
            transform: scale(1);
            box-shadow: 0 0 0 0 rgba(34, 197, 94, 0.7);
        }
        50% { 
            transform: scale(1.02);
            box-shadow: 0 0 0 10px rgba(34, 197, 94, 0);
        }
        100% { 
            transform: scale(1);
            box-shadow: 0 0 0 0 rgba(34, 197, 94, 0);
        }
    }
</style>

<Navbar current_user={current_user} />

<div class="container mx-auto px-4 py-6">
    <div class="flex items-center gap-4 mb-6">
        <Button variant="ghost" size="sm" onclick={goBackToDashboard}>
            <ArrowLeft class="w-4 h-4 mr-2" />
            Back to Dashboard
        </Button>
    </div>

    <div class="mb-8">
        <div class="flex items-center justify-between mb-4">
            <div>
                <h1 class="text-3xl font-bold mb-2">{hub.displayName}</h1>
                <p class="text-muted-foreground">{hub.description}</p>
                <a class="text-sm text-muted-foreground underline" href={`mailto:${hub.agentMailInbox}`}>{hub.agentMailInbox}</a>
            </div>
            <div class="flex items-center gap-2">
                {#if connectionStatus === "connected"}
                    <Badge variant="outline" class="text-green-600 border-green-600">
                        <Wifi class="w-3 h-3 mr-1" />
                        Live
                    </Badge>
                {:else if connectionStatus === "connecting"}
                    <Badge variant="outline" class="text-yellow-600 border-yellow-600">
                        <Wifi class="w-3 h-3 mr-1" />
                        Connecting
                    </Badge>
                {:else}
                    <Badge variant="outline" class="text-red-600 border-red-600">
                        <WifiOff class="w-3 h-3 mr-1" />
                        Offline
                    </Badge>
                {/if}
                
                <!-- Simulation Controls -->
                {#if !isSimulating}
                    <Button 
                        variant="outline" 
                        size="sm" 
                        onclick={openSimulationConfig}
                        class="text-blue-600 border-blue-600 hover:bg-blue-50"
                    >
                        <Zap class="w-3 h-3 mr-1" />
                        Simulate Data
                    </Button>
                {:else}
                    <div class="flex items-center gap-2">
                        <Badge variant="outline" class="text-orange-600 border-orange-600 animate-pulse">
                            <Activity class="w-3 h-3 mr-1" />
                            Simulating
                        </Badge>
                        <Button 
                            variant="outline" 
                            size="sm" 
                            onclick={stopSimulation}
                            class="text-red-600 border-red-600 hover:bg-red-50"
                        >
                            <Square class="w-3 h-3 mr-1" />
                            Stop
                        </Button>
                    </div>
                {/if}
            </div>
        </div>
        
        <div class="flex gap-4 text-sm text-muted-foreground">
            <div>
                <strong>Location:</strong> {hub.location}
            </div>
            <div>
                <strong>Serial:</strong> {hub.serialNumber}
            </div>
            <div>
                <strong>Data Sources:</strong> {activeDataSources}/{totalDataSources} active
            </div>
            {#if lastUpdateTime}
                <div>
                    <strong>Last Update:</strong> {lastUpdateTime.toLocaleTimeString()}
                </div>
            {/if}
            {#if isSimulating && simulationStats.startTime}
                <div>
                    <strong>Simulation:</strong> {simulationStats.totalUpdates} updates
                </div>
                <div class="text-blue-600">
                    <strong>Active Sensors:</strong> {sensorActivity.size}/{realtimeDataSources.length}
                </div>
                {#if simulationStats.anomaliesGenerated > 0}
                    <div class="text-orange-600">
                        <strong>Anomalies:</strong> {simulationStats.anomaliesGenerated}
                    </div>
                {/if}
                {#if simulationStats.spikesGenerated > 0}
                    <div class="text-red-600">
                        <strong>Spikes:</strong> {simulationStats.spikesGenerated}
                    </div>
                {/if}
            {/if}
        </div>
    </div>

    {#if realtimeDataSources.length === 0}
        <Card>
            <CardContent class="text-center py-12">
                <Activity class="w-12 h-12 mx-auto mb-4 text-muted-foreground" />
                <h3 class="text-lg font-semibold mb-2">No Data Sources</h3>
                <p class="text-muted-foreground">This hub doesn't have any data sources configured yet.</p>
            </CardContent>
        </Card>
    {:else}
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {#each realtimeDataSources as dataSource (dataSource.id)}
                {@const activity = sensorActivity.get(dataSource.id)}
                <div 
                    data-sensor-id={dataSource.id} 
                    class="relative transition-all duration-300"
                >
                    <SensorCard {dataSource} />
                    
                    <!-- Individual sensor activity indicator -->
                    {#if isSimulating && activity}
                        <div class="absolute -top-2 -right-2 flex items-center gap-1">
                            <Badge 
                                variant="outline" 
                                class="text-xs px-1 py-0 bg-blue-50 text-blue-600 border-blue-200 animate-pulse"
                            >
                                {activity.updateCount}
                            </Badge>
                        </div>
                    {/if}
                </div>
            {/each}
        </div>
    {/if}
</div>

<!-- Simulation Configuration Modal -->
<SimulationConfigModal 
    open={showConfigModal} 
    onClose={() => showConfigModal = false}
    onStart={startSimulationWithConfig}
/>
