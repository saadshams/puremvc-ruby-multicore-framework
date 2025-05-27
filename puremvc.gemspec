Gem::Specification.new do |spec|
  spec.name          = "puremvc"
  spec.version       = "1.0.0"
  spec.summary       = "PureMVC Multicore Framework"
  spec.description   = "PureMVC is a lightweight framework for creating applications based upon the classic Model-View-Controller design meta-pattern. This is the specific implementation for the Ruby language based on the Multicore Version AS3 reference."
  spec.authors       = ["Saad Shams"]
  spec.email         = ["saad.shams@puremvc.org"]
  spec.homepage      = "https://github.com/puremvc/puremvc-ruby-multicore-framework"
  spec.license       = "BSD-3-Clause"

  spec.files         = Dir.glob("lib/**/*.rb") + %w[README.md LICENSE VERSION] + Dir.glob("sig/**/*.rbs")
  spec.require_paths = ["lib"]
  spec.metadata["steep_types"] = "sig"

  spec.required_ruby_version = ">= 3.0"
end
