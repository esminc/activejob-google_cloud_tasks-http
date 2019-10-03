
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_job/google_cloud_tasks/http/version"

Gem::Specification.new do |spec|
  spec.name          = "activejob-google_cloud_tasks-http"
  spec.version       = ActiveJob::GoogleCloudTasks::HTTP::VERSION
  spec.authors       = ["hibariya"]
  spec.email         = ["hibariya@gmail.com"]

  spec.summary       = %q{ActiveJob adapter for Google Cloud Tasks HTTP targets.}
  spec.description   = %q{ActiveJob adapter for Google Cloud Tasks HTTP targets.}
  spec.homepage      = "https://github.com/esminc/activejob-google_cloud_tasks-http"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activejob"
  spec.add_runtime_dependency "google-cloud-tasks"
  spec.add_runtime_dependency "rack"
  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
