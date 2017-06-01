# Sinatra Subdomain

[![Travis-CI](https://travis-ci.org/fnando/sinatra-subdomain.png)](https://travis-ci.org/fnando/sinatra-subdomain)
[![Code Climate](https://codeclimate.com/github/fnando/sinatra-subdomain/badges/gpa.svg)](https://codeclimate.com/github/fnando/sinatra-subdomain)
[![Test Coverage](https://codeclimate.com/github/fnando/sinatra-subdomain/badges/coverage.svg)](https://codeclimate.com/github/fnando/sinatra-subdomain/coverage)
[![Gem](https://img.shields.io/gem/v/sinatra-subdomain.svg)](https://rubygems.org/gems/sinatra-subdomain)
[![Gem](https://img.shields.io/gem/dt/sinatra-subdomain.svg)](https://rubygems.org/gems/sinatra-subdomain)

## Installation

```
gem install sinatra-subdomain
```

## Usage

```ruby
require "sinatra"
require "sinatra/subdomain"

# Specify which subdomain you want
subdomain :foo do
  get "/" do
    "render page for FOO"
  end
end

# If any subdomain is set
subdomain do
  get "/" do
    "render page for #{subdomain} subdomain"
  end
end
```

If you're not building a classic app, make sure to register Sinatra::Subdomain yourself:

```ruby
require "sinatra"
require "sinatra/subdomain"

# Specify which subdomain you want
class MyApp < Sinatra::Base
  register Sinatra::Subdomain

  subdomain :foo do
    get "/" do
      "render page for FOO"
    end
  end

  # If any subdomain is set
  subdomain do
    get "/" do
      "render page for #{subdomain} subdomain"
    end
  end
end
```

You can also pass an array or regular expressions to match subdomains:

```ruby
class MyApp < Sinatra::Base
  register Sinatra::Subdomain

  subdomain [:foo, :bar, :zaz] do
    get "/" do
      "render page for #{subdomain}"
    end
  end

  # Matches www, www1, www2, etc.
  subdomain /\Awww\d*\z/ do
    get "/" do
      "render page for #{subdomain} subdomain"
    end
  end
end
```

By default, sinatra-subdomain will consider 1 TLD as in <tt>example.com</tt>.
You can specify your TLD size for domains like <tt>example.com.br</tt> or <tt>example.co.uk</tt>.

```ruby
require "sinatra"
require "sinatra/subdomain"

set :tld_size, 2
```

# License

(The MIT License)

Copyright © 2010 - Nando Vieira (http://nandovieira.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
