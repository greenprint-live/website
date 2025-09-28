export interface GPHub {
    id: string;
    ownerUserId: string;
    serialNumber: string;
    displayName: string;
    description: string;
    location: string;
    insertedAt: string;
    updatedAt: string;
    agentMailInbox: string;
}

export interface GPDataSource {
    id: string;
    ownerGpHubId: string;
    displayName: string;
    description: string;
    type: string;
    insertedAt: string;
    updatedAt: string;
    // Real data fields (optional for backward compatibility)
    currentValue?: number | null;
    lastUpdated?: string | null;
    trend?: "up" | "down" | "stable";
    status?: "active" | "inactive" | "error";
    agentMailInbox: string;
}

export interface DetectedDataSource {
    type: string;
    displayName: string;
    description: string;
    selected: boolean;
}