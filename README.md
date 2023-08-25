# BentoHanami

[![CircleCI](https://circleci.com/gh/pulibrary/bento_hanami.svg?style=svg)](https://circleci.com/gh/pulibrary/bento_hanami)

Requires:
- Ruby 3.2

## Getting started
1. Clone the repository - `git clone git@github.com:pulibrary/bento_hanami.git`
1. Go to the repository directory - `cd bento_hanami`
1. Install the required gems - `bundle install`
1. Start the application server on localhost:2300 - `bundle exec hanami server`
1. See the application running at http://localhost:2300/

## Run tests
### RSpec
```bash
bundle exec rspec
```

### Rubocop
```bash
bundle exec rubocop
```

### Debugger
Uses ruby/debug gem. Currently only required in the `spec_helper.rb`, so if you want to use it in non-rspec contexts, you'll need to require it elsewhere.

Add `debugger` where you want the debugger to stop. For more options, see [the gem's readme](https://github.com/ruby/debug#how-to-use).

## Create a new service
```bash
bundle exec hanami generate action search.catalog
```