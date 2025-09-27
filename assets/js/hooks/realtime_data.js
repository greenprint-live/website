// LiveView hook for handling real-time data updates
export const RealtimeData = {
  mounted() {
    console.log("🔌 RealtimeData hook mounted");
    
    // Listen for data source updates from the server
    this.handleEvent("data_source_updated", (payload) => {
      console.log("📊 Data source updated:", payload);
      
      // Dispatch a custom event that Svelte components can listen to
      const event = new CustomEvent("dataSourceUpdated", {
        detail: payload,
        bubbles: true
      });
      
      this.el.dispatchEvent(event);
    });
    
    // Listen for multiple data source updates
    this.handleEvent("data_sources_updated", (payload) => {
      console.log("📊 Multiple data sources updated:", payload);
      
      const event = new CustomEvent("dataSourcesUpdated", {
        detail: payload,
        bubbles: true
      });
      
      this.el.dispatchEvent(event);
    });
    
    // Handle connection status changes
    this.handleEvent("connection_status", (payload) => {
      console.log("🔗 Connection status:", payload);
      
      const event = new CustomEvent("connectionStatus", {
        detail: payload,
        bubbles: true
      });
      
      this.el.dispatchEvent(event);
    });
  },
  
  destroyed() {
    console.log("🔌 RealtimeData hook destroyed");
  }
};
