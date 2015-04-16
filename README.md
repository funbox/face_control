# Face Control

Comment on added lines of pull requests in [Atlassian Stash][].
Take comments from static checkers reports.
(Currently supports [RuboCop][] and [CoffeeLint][].)

Inspired by [Hound][].

## Installation

    gem install face_control

## Usage

    rubocop -f json -o rubocop.json
    coffeelint --reporter raw app/assets/javascripts > coffeelint_report.json
    face-control <project> <repository> <pull_request_id>

`face-control` uses the same configuration file (`~/.stashconfig.yml`)
as the official [Atlassian Stash Command Line Tools][]
to connect to your Stash instance.

## Etymology

[Face control][] in Wikipedia

[Hound]: https://houndci.com
[Atlassian Stash]: https://www.atlassian.com/software/stash
[Atlassian Stash Command Line Tools]: https://bitbucket.org/atlassian/stash-command-line-tools
[RuboCop]: http://batsov.com/rubocop/
[CoffeeLint]: http://www.coffeelint.org
[Face control]: http://en.wikipedia.org/wiki/Face_control
