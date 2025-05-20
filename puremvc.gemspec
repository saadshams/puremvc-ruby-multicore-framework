Gem::Specification.new do |spec|
  spec.name          = "puremvc"
  spec.version       = "2.0.0"
  spec.summary       = "PureMVC Multicore Framework"
  spec.description   = "A Ruby implementation of the PureMVC framework"
  spec.authors       = ["Saad Shams"]
  spec.email         = ["saad.shams@puremvc.org"]
  spec.homepage      = "https://github.com/puremvc/puremvc-ruby-multicore-framework"
  spec.license       = "BSD-3-Clause"

  spec.files         = Dir.glob("src/**/*.rb") + %w[README.md LICENSE]
  spec.require_paths = ["src"]

  spec.required_ruby_version = ">= 2.5"
end
