# Face Control

Comment on added lines of pull requests in [Atlassian Stash](https://www.atlassian.com/software/stash).
Take comments from static checkers reports.
(Currently supports [RuboCop](http://batsov.com/rubocop/) and [CoffeeLint](http://www.coffeelint.org).)

Inspired by [Hound](https://houndci.com).

## Installation

    gem install face_control

## Usage

    rubocop -f json -o rubocop.json
    coffeelint --reporter raw app/assets/javascripts > coffeelint_report.json
    face-control <project> <repository> <pull_request_id>

`face-control` uses the same configuration file (`~/.stashconfig.yml`)
as the official [Atlassian Stash Command Line Tools](https://bitbucket.org/atlassian/stash-command-line-tools)
to connect to your Stash instance.
