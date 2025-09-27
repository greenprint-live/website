<script lang="ts">
    import { Card, CardHeader, CardTitle, CardDescription } from "$lib/components/ui/card";
</script>

<section class="py-20 px-4 sm:px-6 lg:px-8 bg-white dark:bg-gray-900">
	<div class="max-w-7xl mx-auto">
		<div class="text-center mb-16">
			<h2 class="text-3xl sm:text-4xl font-bold text-gray-900 dark:text-white mb-4">
				Everything you need to go green
			</h2>
			<p class="text-xl text-gray-600 dark:text-gray-300 max-w-2xl mx-auto">
				Comprehensive tools and insights to help your business become more sustainable and profitable.
			</p>
		</div>
		
		<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
			<Card class="text-center hover:shadow-lg transition-shadow">
				<CardHeader>
					<div class="w-12 h-12 bg-green-100 dark:bg-green-900 rounded-lg flex items-center justify-center mx-auto mb-4">
						<svg class="w-6 h-6 text-green-600 dark:text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
						</svg>
					</div>
					<CardTitle>Carbon Tracking</CardTitle>
					<CardDescription>
						Monitor and track your carbon footprint in real-time with detailed analytics
					</CardDescription>
				</CardHeader>
			</Card>
			
			<Card class="text-center hover:shadow-lg transition-shadow">
				<CardHeader>
					<div class="w-12 h-12 bg-blue-100 dark:bg-blue-900 rounded-lg flex items-center justify-center mx-auto mb-4">
						<svg class="w-6 h-6 text-blue-600 dark:text-blue-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
						</svg>
					</div>
					<CardTitle>Energy Optimization</CardTitle>
					<CardDescription>
						AI-powered recommendations to reduce energy consumption and costs
					</CardDescription>
				</CardHeader>
			</Card>
			
			<Card class="text-center hover:shadow-lg transition-shadow">
				<CardHeader>
					<div class="w-12 h-12 bg-purple-100 dark:bg-purple-900 rounded-lg flex items-center justify-center mx-auto mb-4">
						<svg class="w-6 h-6 text-purple-600 dark:text-purple-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
						</svg>
					</div>
					<CardTitle>Compliance Reports</CardTitle>
					<CardDescription>
						Automated sustainability reports for regulatory compliance and certifications
					</CardDescription>
				</CardHeader>
			</Card>
			
			<Card class="text-center hover:shadow-lg transition-shadow">
				<CardHeader>
					<div class="w-12 h-12 bg-orange-100 dark:bg-orange-900 rounded-lg flex items-center justify-center mx-auto mb-4">
						<svg class="w-6 h-6 text-orange-600 dark:text-orange-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"/>
						</svg>
					</div>
					<CardTitle>Cost Savings</CardTitle>
					<CardDescription>
						Identify opportunities to save money while becoming more sustainable
					</CardDescription>
				</CardHeader>
			</Card>
			
			<Card class="text-center hover:shadow-lg transition-shadow">
				<CardHeader>
					<div class="w-12 h-12 bg-teal-100 dark:bg-teal-900 rounded-lg flex items-center justify-center mx-auto mb-4">
						<svg class="w-6 h-6 text-teal-600 dark:text-teal-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
						</svg>
					</div>
					<CardTitle>Team Collaboration</CardTitle>
					<CardDescription>
						Collaborate with your team on sustainability initiatives and goals
					</CardDescription>
				</CardHeader>
			</Card>
			
			<Card class="text-center hover:shadow-lg transition-shadow">
				<CardHeader>
					<div class="w-12 h-12 bg-red-100 dark:bg-red-900 rounded-lg flex items-center justify-center mx-auto mb-4">
						<svg class="w-6 h-6 text-red-600 dark:text-red-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
						</svg>
					</div>
					<CardTitle>Real-time Dashboards</CardTitle>
					<CardDescription>
						Beautiful, intuitive dashboards with real-time data and insights
					</CardDescription>
				</CardHeader>
			</Card>
		</div>
	</div>
</section>