[![Code Climate](https://codeclimate.com/github/joenas/preek.png)](https://codeclimate.com/github/joenas/preek)
[![Build Status](https://travis-ci.org/joenas/preek.png)](https://travis-ci.org/joenas/preek)

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

    $ preek . or file

At the moment it only supports files, not stuff like this:

    $ echo "def x() true end" | reek


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
