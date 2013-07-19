[![Code Climate](https://codeclimate.com/github/joenas/preek.png)](https://codeclimate.com/github/joenas/preek)
[![Build Status](https://travis-ci.org/joenas/preek.png)](https://travis-ci.org/joenas/preek)
[![Dependency Status](https://gemnasium.com/joenas/preek.png)](https://gemnasium.com/joenas/preek)
[![Coverage Status](https://coveralls.io/repos/joenas/preek/badge.png?branch=master)](https://coveralls.io/r/joenas/preek?branch=master)


# Preek

For a pretty colorful output of [Reek](https://github.com/troessner/reek), which is an awesome gem!
This is just something I came up with while learning [Thor](https://github.com/wycats/thor).
As an exercise I also worked on getting Reek and Pelusa to stop whining when running them on the code.

## Installation

Install it yourself as:

    $ git clone git@github.com:joenas/preek.git

    $ cd preek

    $ rake install

or

    $ gem install preek


## Usage
```bash
Usage:
  preek smell FILE(S)|DIR

Options:
  -i, [--irresponsible]  # include IrresponsibleModule smell in output.


Commands:
  preek help [COMMAND]     # Describe available commands or one specific command
  preek smell FILE(S)|DIR  # Pretty format Reek output
  preek version            # Shows version
```

At the moment it only supports files, not stuff like this:

    $ echo "def x() true end" | reek


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
