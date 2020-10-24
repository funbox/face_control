# Face Control

[![Gem Version](https://img.shields.io/gem/v/face_control.svg)](https://rubygems.org/gems/face_control)
[![Coveralls](https://img.shields.io/coveralls/funbox/face_control.svg)](https://coveralls.io/github/funbox/face_control)

Run static analysis of pull requests in [Bitbucket Server][] (formerly Stash)
and comment on problems in added lines.

Currently supports [RuboCop][] and [CoffeeLint][] and also checks for
TODOs and FIXMEs.

Inspired by [Hound][].

## Installation

```bash
gem install face_control
```

You also need to have CoffeeLint installed and available in `PATH`.

## Usage

```bash
face-control <project> <repository> <pull_request_id>
```

It's natural to run this on a continuous integration server (see “[Example](#example)” below).

If you don't want to receive RuboCop comments with certain severity level,
pass the severity in the `--skip-severity` option like so:

```bash
face-control --skip-severity convention <project> <repository> <pull_request_id>
```

Instead of `--skip-severity` you can use just `-S`.

You can also pass multiple severity levels as a comma-separated list:

```bash
face-control -S convention,refactor <project> <repository> <pull_request_id>
```

`face-control` uses the same configuration file (`~/.stashconfig.yml`)
as the official [Bitbucket Server Command Line Tools][]
to connect to your Stash instance.

## Example

Here's a [Jenkins][] project setup as an example:

_Source Code Management → Git → Repositories → Refspec:_

```
+refs/pull-requests/*:refs/remotes/origin/pull-requests/*
```

It makes Jenkins fetch otherwise ignored Stash-created branches.

_Source Code Management → Git → Branches to build → Branch Specifier:_

```
origin/pull-requests/*/merge
```

Merge results of open non-conflicting pull requests.

_Build → Execute shell → Command:_

```bash
export PULL_REQUEST_ID=`echo $GIT_BRANCH | cut -d / -f 3`

gem install rubocop face_control
npm install -g coffeelint

face-control <project> <repository> $PULL_REQUEST_ID
```

## Etymology

[Face control][] in Wikipedia.

[![Sponsored by FunBox](https://funbox.ru/badges/sponsored_by_funbox_centered.svg)](https://funbox.ru)

[Hound]: https://houndci.com
[Bitbucket Server]: https://www.atlassian.com/software/bitbucket/server
[Bitbucket Server Command Line Tools]: https://bitbucket.org/atlassian/bitbucket-server-cli
[RuboCop]: http://batsov.com/rubocop/
[CoffeeLint]: http://www.coffeelint.org
[Jenkins]: http://jenkins-ci.org
[Face control]: http://en.wikipedia.org/wiki/Face_control
