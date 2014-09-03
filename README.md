[![Gem Version](https://badge.fury.io/rb/preek.png)](http://badge.fury.io/rb/preek)
[![Code Climate](https://codeclimate.com/github/joenas/preek.png)](https://codeclimate.com/github/joenas/preek)
[![Build Status](https://travis-ci.org/joenas/preek.png)](https://travis-ci.org/joenas/preek)
[![Dependency Status](https://gemnasium.com/joenas/preek.png)](https://gemnasium.com/joenas/preek)
[![Coverage Status](https://coveralls.io/repos/joenas/preek/badge.png?branch=master)](https://coveralls.io/r/joenas/preek?branch=master)


# Preek

For a pretty colorful output of [Reek](https://github.com/troessner/reek), which is an awesome gem!
This is just something I came up with while learning [Thor](https://github.com/wycats/thor).  
To make your refactoring life easier you can also use [Guard::Preek](https://github.com/joenas/guard-preek)!

## Installation

    $ gem install preek

From source

    $ git clone git@github.com:joenas/preek.git
    $ cd preek
    $ rake install




## Usage

### CLI
```bash
Usage:
  preek FILE(S)|DIR

Options:
  -i, [--irresponsible]  # Include IrresponsibleModule smell in output.
  -c, [--compact]        # Compact output.
  -v, [--verbose]        # Report files with no smells

Commands:
  preek git                # Run Preek on git changes
  preek help [COMMAND]     # Describe available commands or one specific command
  preek smell FILE(S)|DIR  # Pretty format Reek output
  preek version            # Shows version
```

At the moment it only supports files, not stuff like this:

    $ echo "def x() true end" | reek

### Ruby

```ruby
# Convenience method, prints all smells in files

filenames = Dir['**/*.rb']
Preek::Smell(filenames)

# To exclude certain smell classes

excludes = %w(IrresponsibleModule)
Preek::Smell(filenames, excludes)


```

### Git
To run preek on your code before commit, place this in `.git/hooks/pre-commit`

```bash
#!/bin/sh
exec bundle exec preek git
0
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
