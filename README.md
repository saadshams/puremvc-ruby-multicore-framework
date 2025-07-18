## [PureMVC](http://puremvc.github.com/) Ruby MultiCore Framework [![Ruby](https://github.com/PureMVC/puremvc-ruby-multicore-framework/actions/workflows/ruby.yml/badge.svg)](https://github.com/PureMVC/puremvc-ruby-multicore-framework/actions/workflows/ruby.yml)

PureMVC is a lightweight framework for creating applications based upon the classic [Model-View-Controller](http://en.wikipedia.org/wiki/Model-view-controller) design meta-pattern. It supports [modular programming](http://en.wikipedia.org/wiki/Modular_programming) through the use of [Multiton](http://en.wikipedia.org/wiki/Multiton) Core actors instead of the [Singletons](http://en.wikipedia.org/wiki/Singleton_pattern) used in the [Standard](https://github.com/PureMVC/puremvc-ruby-standard-framework/wiki) Version.

* [Ruby Gem](https://rubygems.org/gems/puremvc)
* [API Docs](http://puremvc.org/pages/docs/Ruby/multicore/)

## Installation
```ruby
gem install puremvc
```

## Platforms / Technologies
* [Ruby](https://en.wikipedia.org/wiki/Ruby_(programming_language))
* [Command-line interface](https://en.wikipedia.org/wiki/Command-line_interface)
* [Cross-platform software](https://en.wikipedia.org/wiki/Cross-platform_software)

## Reference
* [Ruby](https://www.ruby-lang.org/en)
* [RBS](https://github.com/ruby/rbs)
* [YARD: Yay! A Ruby Documentation Tool](https://rubydoc.info/gems/yard)

---
## Development

### Install Dependencies
`bundle install `

### Generate Documentation
```shell
yard doc lib/**/*.rb --protected --private
open doc/index.html
```

### Generate RBS Signatures
```shell
rbs prototype rb lib/**/*.rb --out-dir=sig
```

### Run Type Checking
```shell
steep check
```

### Test
```shell
ruby -Itest -e 'Dir["test/**/*_test.rb"].each { |file| require_relative file }'
RubyMine: Test file name mask: **/{*_test,test_*,*_spec}.rb
```

#### Publish
```shell
gem build puremvc.gemspec
gem push --host https://rubygems.pkg.github.com/puremvc puremvc-1.0.0.gem
```
---

## License
* PureMVC MultiCore Framework for Ruby 
* PureMVC - Copyright © 2025 [Saad Shams](https://www.linkedin.com/in/muizz/)
* PureMVC - Copyright © 2025 [Futurescale, Inc.](http://futurescale.com/)
* All rights reserved.

* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of Futurescale, Inc., PureMVC.org, nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
