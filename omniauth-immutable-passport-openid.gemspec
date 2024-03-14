# frozen_string_literal: true

require_relative 'lib/omniauth/immutable/passport_openid/version'

Gem::Specification.new do |gem|
  gem.name          = 'omniauth-immutable-passport-openid'
  gem.version       = Omniauth::Immutable::PassportOpenId::VERSION
  gem.authors       = ['Max Schridde']
  gem.email         = ['maxjschridde@gmail.com']

  gem.summary       = 'An Immutable Passport OmniAuth Strategy.'
  gem.description   = 'An Immutable Passport OmniAuth Strategy. This allows you to login to Immutable Passport with your ruby app.'
  gem.homepage      = 'https://github.com/maxschridde1494/omniauth-immutable-passport-openid'
  gem.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  gem.metadata['homepage_uri'] = gem.homepage
  gem.metadata['source_code_uri'] = gem.homepage
  gem.metadata['changelog_uri'] = "#{gem.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gem.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  gem.bindir        = 'exe'
  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_dependency 'omniauth-oauth2', '~> 1.8'

  gem.add_development_dependency 'rake', '~> 12.0'
  gem.add_development_dependency 'rspec', '~> 3.6'
  gem.add_development_dependency 'rubocop', '~> 0.49'
end
