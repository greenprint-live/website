<script lang="ts">
    import { Button } from "$lib/components/ui/button";
    import { Input } from "$lib/components/ui/input";
    import { Label } from "$lib/components/ui/label";
    import { Badge } from "$lib/components/ui/badge";
    import { Card, CardContent, CardHeader, CardTitle } from "$lib/components/ui/card";
    import { 
        Dialog, 
        DialogContent, 
        DialogHeader, 
        DialogTitle, 
        DialogDescription,
        DialogFooter 
    } from "$lib/components/ui/dialog/index.js";
    import { 
        Zap, 
        TrendingUp, 
        Activity, 
        AlertTriangle, 
        Shuffle,
        Clock,
        Target,
        Waves
    } from "@lucide/svelte";

    interface SimulationConfig {
        updateInterval: number;      // milliseconds between updates
        volatility: number;          // 0-100, how much values can change
        trendStrength: number;       // 0-100, how much trends persist
        anomalyChance: number;       // 0-100, chance of anomalous readings
        burstMode: boolean;          // enable burst updates
        burstIntensity: number;      // updates per burst
        enableSpikes: boolean;       // enable random spikes
        spikeIntensity: number;      // how extreme spikes can be
    }

    interface Props {
        open: boolean;
        onClose: () => void;
        onStart: (config: SimulationConfig) => void;
    }

    let { open, onClose, onStart }: Props = $props();

    // Default configuration
    let config = $state<SimulationConfig>({
        updateInterval: 2000,
        volatility: 30,
        trendStrength: 50,
        anomalyChance: 10,
        burstMode: false,
        burstIntensity: 3,
        enableSpikes: false,
        spikeIntensity: 200
    });

    // Preset configurations
    const presets = {
        gentle: {
            updateInterval: 5000,
            volatility: 15,
            trendStrength: 70,
            anomalyChance: 5,
            burstMode: false,
            burstIntensity: 2,
            enableSpikes: false,
            spikeIntensity: 150
        },
        normal: {
            updateInterval: 3000,
            volatility: 30,
            trendStrength: 50,
            anomalyChance: 10,
            burstMode: false,
            burstIntensity: 3,
            enableSpikes: false,
            spikeIntensity: 200
        },
        aggressive: {
            updateInterval: 1000,
            volatility: 60,
            trendStrength: 30,
            anomalyChance: 20,
            burstMode: true,
            burstIntensity: 5,
            enableSpikes: true,
            spikeIntensity: 300
        },
        chaotic: {
            updateInterval: 500,
            volatility: 90,
            trendStrength: 10,
            anomalyChance: 40,
            burstMode: true,
            burstIntensity: 8,
            enableSpikes: true,
            spikeIntensity: 500
        }
    };

    function applyPreset(presetName: keyof typeof presets) {
        config = { ...presets[presetName] };
    }

    function handleStart() {
        onStart(config);
        onClose();
    }

    function getIntensityColor(value: number) {
        if (value < 30) return "text-green-600";
        if (value < 60) return "text-yellow-600";
        return "text-red-600";
    }

    function getIntensityLabel(value: number) {
        if (value < 30) return "Gentle";
        if (value < 60) return "Moderate";
        if (value < 80) return "Aggressive";
        return "Chaotic";
    }
</script>

<Dialog {open} onOpenChange={onClose}>
    <DialogContent class="max-w-2xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
            <DialogTitle class="flex items-center gap-2">
                <Zap class="w-5 h-5 text-blue-600" />
                Configure Data Simulation
            </DialogTitle>
            <DialogDescription>
                Customize how aggressively and randomly your sensor data will be simulated. Each sensor will update independently at randomized intervals!
            </DialogDescription>
        </DialogHeader>

        <div class="space-y-6">
            <!-- Presets -->
            <div class="space-y-3">
                <Label class="text-base font-semibold">Quick Presets</Label>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-2">
                    {#each Object.entries(presets) as [name, preset]}
                        <Button
                            variant="outline"
                            size="sm"
                            onclick={() => applyPreset(name as keyof typeof presets)}
                            class="flex flex-col h-auto p-3 text-center"
                        >
                            <div class="font-medium capitalize">{name}</div>
                            <div class="text-xs text-muted-foreground mt-1">
                                {preset.updateInterval}ms, {preset.volatility}% vol
                            </div>
                        </Button>
                    {/each}
                </div>
            </div>

            <!-- Current Intensity Indicator -->
            <Card class="border-2">
                <CardHeader class="pb-3">
                    <CardTitle class="text-sm flex items-center gap-2">
                        <Activity class="w-4 h-4" />
                        Simulation Intensity
                    </CardTitle>
                </CardHeader>
                <CardContent>
                    <div class="flex items-center justify-between">
                        <Badge 
                            variant="outline" 
                            class={`${getIntensityColor(config.volatility + config.anomalyChance)} border-current`}
                        >
                            {getIntensityLabel(config.volatility + config.anomalyChance)}
                        </Badge>
                        <div class="text-sm text-muted-foreground">
                            Updates every {config.updateInterval}ms
                        </div>
                    </div>
                </CardContent>
            </Card>

            <!-- Configuration Options -->
            <div class="grid md:grid-cols-2 gap-6">
                <!-- Timing Controls -->
                <div class="space-y-4">
                    <Label class="text-base font-semibold flex items-center gap-2">
                        <Clock class="w-4 h-4" />
                        Timing
                    </Label>
                    
                    <div class="space-y-2">
                        <Label for="updateInterval">Update Interval (ms)</Label>
                        <Input
                            id="updateInterval"
                            type="number"
                            bind:value={config.updateInterval}
                            min="100"
                            max="10000"
                            step="100"
                        />
                        <div class="text-xs text-muted-foreground">
                            Lower = more frequent updates
                        </div>
                    </div>
                </div>

                <!-- Volatility Controls -->
                <div class="space-y-4">
                    <Label class="text-base font-semibold flex items-center gap-2">
                        <TrendingUp class="w-4 h-4" />
                        Behavior
                    </Label>
                    
                    <div class="space-y-2">
                        <Label for="volatility">Volatility ({config.volatility}%)</Label>
                        <Input
                            id="volatility"
                            type="range"
                            bind:value={config.volatility}
                            min="0"
                            max="100"
                            class="w-full"
                        />
                        <div class="text-xs text-muted-foreground">
                            How much values can change between updates
                        </div>
                    </div>

                    <div class="space-y-2">
                        <Label for="trendStrength">Trend Persistence ({config.trendStrength}%)</Label>
                        <Input
                            id="trendStrength"
                            type="range"
                            bind:value={config.trendStrength}
                            min="0"
                            max="100"
                            class="w-full"
                        />
                        <div class="text-xs text-muted-foreground">
                            How much trends continue vs random changes
                        </div>
                    </div>
                </div>

                <!-- Anomaly Controls -->
                <div class="space-y-4">
                    <Label class="text-base font-semibold flex items-center gap-2">
                        <AlertTriangle class="w-4 h-4" />
                        Anomalies
                    </Label>
                    
                    <div class="space-y-2">
                        <Label for="anomalyChance">Anomaly Chance ({config.anomalyChance}%)</Label>
                        <Input
                            id="anomalyChance"
                            type="range"
                            bind:value={config.anomalyChance}
                            min="0"
                            max="50"
                            class="w-full"
                        />
                        <div class="text-xs text-muted-foreground">
                            Chance of unusual readings per update
                        </div>
                    </div>

                    <div class="flex items-center space-x-2">
                        <input
                            id="enableSpikes"
                            type="checkbox"
                            bind:checked={config.enableSpikes}
                            class="rounded"
                        />
                        <Label for="enableSpikes" class="text-sm">Enable Random Spikes</Label>
                    </div>

                    {#if config.enableSpikes}
                        <div class="space-y-2">
                            <Label for="spikeIntensity">Spike Intensity ({config.spikeIntensity}%)</Label>
                            <Input
                                id="spikeIntensity"
                                type="range"
                                bind:value={config.spikeIntensity}
                                min="150"
                                max="1000"
                                class="w-full"
                            />
                        </div>
                    {/if}
                </div>

                <!-- Burst Mode -->
                <div class="space-y-4">
                    <Label class="text-base font-semibold flex items-center gap-2">
                        <Waves class="w-4 h-4" />
                        Burst Mode
                    </Label>
                    
                    <div class="flex items-center space-x-2">
                        <input
                            id="burstMode"
                            type="checkbox"
                            bind:checked={config.burstMode}
                            class="rounded"
                        />
                        <Label for="burstMode" class="text-sm">Enable Burst Updates</Label>
                    </div>

                    {#if config.burstMode}
                        <div class="space-y-2">
                            <Label for="burstIntensity">Updates per Burst</Label>
                            <Input
                                id="burstIntensity"
                                type="number"
                                bind:value={config.burstIntensity}
                                min="2"
                                max="10"
                            />
                            <div class="text-xs text-muted-foreground">
                                Multiple rapid updates in succession
                            </div>
                        </div>
                    {/if}
                </div>
            </div>
        </div>

        <DialogFooter>
            <Button variant="outline" onclick={onClose}>
                Cancel
            </Button>
            <Button onclick={handleStart} class="bg-blue-600 hover:bg-blue-700">
                <Zap class="w-4 h-4 mr-2" />
                Start Simulation
            </Button>
        </DialogFooter>
    </DialogContent>
</Dialog>
