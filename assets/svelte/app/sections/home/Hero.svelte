<script lang="ts">
    import { Badge } from "$lib/components/ui/badge";
    import { Button } from "$lib/components/ui/button";
</script>

<section class="bg-background py-20 px-4 sm:px-6 lg:px-8">
	<div class="max-w-7xl mx-auto">
		<div class="text-center">
			<!-- Logo -->
			<div class="mb-8">
				<img src="/images/full-logo.png" alt="GreenPrint Logo" class="h-16 mx-auto" />
			</div>
			
			<!-- Headline -->
			<h1 class="text-4xl sm:text-5xl lg:text-6xl font-bold text-foreground mb-6">
				Transform Your Business with 
				<span class="text-primary">Sustainable Solutions</span>
			</h1>
			
			<!-- Subheadline -->
			<p class="text-xl text-muted-foreground mb-8 max-w-3xl mx-auto">
				Powerful analytics and insights to help your business reduce environmental impact while increasing profitability. Join thousands of companies making a difference.
			</p>
			
			<!-- CTA Buttons -->
			<div class="flex flex-col sm:flex-row gap-4 justify-center items-center mb-12">
				<Button size="lg" class="text-lg px-8 py-3">
					Start Free Trial
				</Button>
				<Button variant="outline" size="lg" class="text-lg px-8 py-3">
					Watch Demo
				</Button>
			</div>
			
			<!-- Trust Indicators -->
			<div class="flex flex-wrap justify-center items-center gap-4 text-sm text-muted-foreground">
				<Badge variant="secondary">✓ 14-day free trial</Badge>
				<Badge variant="secondary">✓ No credit card required</Badge>
				<Badge variant="secondary">✓ Cancel anytime</Badge>
			</div>
		</div>
	</div>
</section>