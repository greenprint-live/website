<script lang="ts">
    import { Button } from "$lib/components/ui/button";
</script>

<section class="bg-background min-h-screen flex items-center justify-center px-4 sm:px-6 lg:px-8">
	<div class="max-w-7xl mx-auto">
		<div class="text-center">
			<h1 class="text-4xl sm:text-5xl lg:text-6xl font-bold text-foreground mb-6">
				The <span class="from-primary to-primary/50 bg-gradient-to-r text-transparent bg-clip-text">Real-Time Superhero</span> for Your Safety and Sustainability
			</h1>
			
			<p class="text-xl text-muted-foreground mb-8 max-w-3xl mx-auto">
				It's not enough to be reactive when it comes to safety and sustainability.
				You must be proactive and fast to respond in emergencies.
				Sounds scary? It should.
				But <span class="text-primary">GreenPrint</span> is here to carry you through the storm.
			</p>
			
			<div class="flex justify-center">
				<Button size="lg" class="text-lg px-8 py-3">
					<a href="/dashboard" aria-label="Dashboard">
						Take Action
					</a>
				</Button>
			</div>
		</div>
	</div>
</section>