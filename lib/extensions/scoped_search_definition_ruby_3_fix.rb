require 'scoped_search'
if ScopedSearch::VERSION != "4.1.9"
  raise "Assess if fix is still nessecary"
end

module ScopedSearchDefinitionRuby3Fix
  def define(*args)
    options = args.extract_options!
    ScopedSearch::Definition::Field.new(self, *args, **options)
  end
end
ScopedSearch::Definition.prepend(ScopedSearchDefinitionRuby3Fix)
