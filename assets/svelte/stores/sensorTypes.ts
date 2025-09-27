import { 
    Thermometer, 
    Droplets, 
    Wind, 
    Lightbulb, 
    Volume2, 
    Eye,
    Activity
} from "@lucide/svelte";
import type { ComponentType } from "svelte";

export interface SensorType {
    id: string;
    displayName: string;
    description: string;
    icon: ComponentType;
    unit: string;
    colorClass: string;
    defaultSelected: boolean;
    category: 'environmental' | 'security' | 'utility';
}

export const SUPPORTED_SENSOR_TYPES: Record<string, SensorType> = {
    temperature: {
        id: "temperature",
        displayName: "Temperature Sensor",
        description: "Ambient temperature monitoring",
        icon: Thermometer,
        unit: "°C",
        colorClass: "bg-red-100 text-red-800",
        defaultSelected: true,
        category: 'environmental'
    },
    humidity: {
        id: "humidity",
        displayName: "Humidity Sensor", 
        description: "Relative humidity monitoring",
        icon: Droplets,
        unit: "%",
        colorClass: "bg-blue-100 text-blue-800",
        defaultSelected: true,
        category: 'environmental'
    },
    co2: {
        id: "co2",
        displayName: "CO2 Sensor",
        description: "Carbon dioxide level monitoring",
        icon: Wind,
        unit: "ppm",
        colorClass: "bg-green-100 text-green-800",
        defaultSelected: true,
        category: 'environmental'
    },
    light: {
        id: "light",
        displayName: "Light Sensor",
        description: "Ambient light level monitoring",
        icon: Lightbulb,
        unit: "lux",
        colorClass: "bg-yellow-100 text-yellow-800",
        defaultSelected: false,
        category: 'environmental'
    },
    motion: {
        id: "motion",
        displayName: "Motion Detector",
        description: "Movement detection sensor",
        icon: Eye,
        unit: "events/hr",
        colorClass: "bg-orange-100 text-orange-800",
        defaultSelected: false,
        category: 'security'
    },
    sound: {
        id: "sound",
        displayName: "Sound Level Meter",
        description: "Ambient noise level monitoring",
        icon: Volume2,
        unit: "dB",
        colorClass: "bg-purple-100 text-purple-800",
        defaultSelected: true,
        category: 'environmental'
    }
};

export const DEFAULT_SENSOR_TYPE: SensorType = {
    id: "unknown",
    displayName: "Unknown Sensor",
    description: "Unrecognized sensor type",
    icon: Activity,
    unit: "",
    colorClass: "bg-gray-100 text-gray-800",
    defaultSelected: false,
    category: 'utility'
};

// Helper functions
export function getSensorType(id: string): SensorType {
    return SUPPORTED_SENSOR_TYPES[id] || DEFAULT_SENSOR_TYPE;
}

export function getAllSensorTypes(): SensorType[] {
    return Object.values(SUPPORTED_SENSOR_TYPES);
}

export function getSensorTypesByCategory(category: SensorType['category']): SensorType[] {
    return getAllSensorTypes().filter(sensor => sensor.category === category);
}

export function getDefaultSelectedSensorTypes(): SensorType[] {
    return getAllSensorTypes().filter(sensor => sensor.defaultSelected);
}
