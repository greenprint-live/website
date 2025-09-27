<script lang="ts">
    import { Badge } from "$lib/components/ui/badge";
    import { Button } from "$lib/components/ui/button";
    import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "$lib/components/ui/card";
</script>

<section class="py-20 px-4 sm:px-6 lg:px-8 bg-gray-50 dark:bg-gray-800">
	<div class="max-w-7xl mx-auto">
		<div class="text-center mb-16">
			<h2 class="text-3xl sm:text-4xl font-bold text-gray-900 dark:text-white mb-4">
				Simple, transparent pricing
			</h2>
			<p class="text-xl text-gray-600 dark:text-gray-300 max-w-2xl mx-auto">
				Choose the plan that's right for your business. All plans include a 14-day free trial.
			</p>
		</div>
		
		<div class="grid grid-cols-1 md:grid-cols-3 gap-8">
			<!-- Starter Plan -->
			<Card class="relative hover:shadow-lg transition-shadow">
				<CardHeader class="text-center">
					<CardTitle class="text-2xl">Starter</CardTitle>
					<CardDescription>Perfect for small businesses</CardDescription>
					<div class="mt-4">
						<span class="text-4xl font-bold text-gray-900 dark:text-white">$29</span>
						<span class="text-gray-600 dark:text-gray-400">/month</span>
					</div>
				</CardHeader>
				<CardContent class="space-y-4">
					<ul class="space-y-2">
						<li class="flex items-center">
							<svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
								<path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
							</svg>
							Up to 10 team members
						</li>
						<li class="flex items-center">
							<svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
								<path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
							</svg>
							Basic carbon tracking
						</li>
						<li class="flex items-center">
							<svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
								<path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
							</svg>
							Monthly reports
						</li>
						<li class="flex items-center">
							<svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
								<path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
							</svg>
							Email support
						</li>
					</ul>
					<Button class="w-full mt-6" variant="outline">Get Started</Button>
				</CardContent>
			</Card>
			
			<!-- Professional Plan -->
			<Card class="relative hover:shadow-lg transition-shadow border-green-500 border-2">
				<div class="absolute -top-3 left-1/2 transform -translate-x-1/2">
					<Badge class="bg-green-500 text-white">Most Popular</Badge>
				</div>
				<CardHeader class="text-center">
					<CardTitle class="text-2xl">Professional</CardTitle>
					<CardDescription>For growing companies</CardDescription>
					<div class="mt-4">
						<span class="text-4xl font-bold text-gray-900 dark:text-white">$99</span>
						<span class="text-gray-600 dark:text-gray-400">/month</span>
					</div>
				</CardHeader>
				<CardContent class="space-y-4">
					<ul class="space-y-2">
						<li class="flex items-center">
							<svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
								<path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
							</svg>
							Up to 50 team members
						</li>
						<li class="flex items-center">
							<svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
								<path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
							</svg>
							Advanced analytics
						</li>
						<li class="flex items-center">
							<svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
								<path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
							</svg>
							Real-time dashboards
						</li>
						<li class="flex items-center">
							<svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
								<path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
							</svg>
							API access
						</li>
						<li class="flex items-center">
							<svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
								<path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
							</svg>
							Priority support
						</li>
					</ul>
					<Button class="w-full mt-6">Get Started</Button>
				</CardContent>
			</Card>
			
			<!-- Enterprise Plan -->
			<Card class="relative hover:shadow-lg transition-shadow">
				<CardHeader class="text-center">
					<CardTitle class="text-2xl">Enterprise</CardTitle>
					<CardDescription>For large organizations</CardDescription>
					<div class="mt-4">
						<span class="text-4xl font-bold text-gray-900 dark:text-white">$299</span>
						<span class="text-gray-600 dark:text-gray-400">/month</span>
					</div>
				</CardHeader>
				<CardContent class="space-y-4">
					<ul class="space-y-2">
						<li class="flex items-center">
							<svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
								<path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
							</svg>
							Unlimited team members
						</li>
						<li class="flex items-center">
							<svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
								<path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
							</svg>
							Custom integrations
						</li>
						<li class="flex items-center">
							<svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
								<path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
							</svg>
							White-label solutions
						</li>
						<li class="flex items-center">
							<svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
								<path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
							</svg>
							Dedicated account manager
						</li>
						<li class="flex items-center">
							<svg class="w-4 h-4 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
								<path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
							</svg>
							24/7 phone support
						</li>
					</ul>
					<Button class="w-full mt-6" variant="outline">Contact Sales</Button>
				</CardContent>
			</Card>
		</div>
	</div>
</section>