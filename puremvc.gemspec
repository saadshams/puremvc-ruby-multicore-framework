Gem::Specification.new do |spec|
  spec.name          = 'puremvc'
  spec.version       = '1.0.0'
  spec.summary       = 'PureMVC Multicore Framework'
  spec.description   = 'PureMVC is a lightweight framework for Model-View-Controller app development.'
  spec.authors       = ['Saad Shams']
  spec.email         = ['saad.shams@puremvc.org']
  spec.homepage      = 'https://github.com/puremvc/puremvc-ruby-multicore-framework'
  spec.license       = 'BSD-3-Clause'

  spec.files         = Dir.glob('lib/**/*.rb') + %w[README.md LICENSE CHANGELOG.md] + Dir.glob('sig/**/*.rbs')
  spec.require_paths = ['lib']
  spec.metadata = {
    'steep_types' => 'sig',
    'github_repo' => 'https://github.com/puremvc/puremvc-ruby-multicore-framework',
    'source_code_uri' => spec.homepage,
    'bug_tracker_uri' => "#{spec.homepage}/issues"
  }

  spec.required_ruby_version = '>= 3.0'
end
