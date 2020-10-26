Gem::Specification.new do |spec|
  spec.name          = 'face_control'
  spec.version       = '0.9.1'
  spec.authors       = ['Ilya Vassilevsky']
  spec.email         = ['vassilevsky@gmail.com']

  spec.summary       = 'Checks Atlassian Stash pull requests and comments on issues in added code'
  spec.homepage      = 'https://github.com/vassilevsky/face_control'

  spec.files         = `git ls-files -z`.split("\x0").reject{|f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}){|f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'docopt'
  spec.add_runtime_dependency 'rubocop'
  spec.add_runtime_dependency 'httparty'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'coveralls'
end
