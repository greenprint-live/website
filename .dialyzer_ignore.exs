[
  # Ignore issues in dependencies
  ~r{(dependencies|deps)},
  # Ignore generated files
  ~r{_build/},
  ~r{\.git/},
  # Common Elixir/Phoenix patterns that Dialyzer sometimes misunderstands
  {"lib/greenprint_web/components/core_components.ex", :no_return, 0},
  # Ignore issues with LiveView socket assigns
  {"lib/greenprint_web/", :unused_fun, 0},
]
