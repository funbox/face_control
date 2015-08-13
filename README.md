[![Code Climate](https://img.shields.io/codeclimate/github/vassilevsky/face_control.svg)](https://codeclimate.com/github/vassilevsky/face_control/code)
[![Vexor](https://ci.vexor.io/projects/126da196-c8e6-46f0-8bc7-b5f8f4b49732/status.svg)](https://ci.vexor.io/ui/projects/126da196-c8e6-46f0-8bc7-b5f8f4b49732/builds)
[![Coveralls](https://img.shields.io/coveralls/vassilevsky/face_control.svg)](https://coveralls.io/github/vassilevsky/face_control)

# Face Control

Comment on added lines of pull requests in [Atlassian Stash][].
Take comments from static checkers reports.
(Currently supports [RuboCop][] and [CoffeeLint][].)

Inspired by [Hound][].

## Installation

    gem install face_control

## Usage

    face-control <project> <repository> <pull_request_id>

It's natural to run this on a continuous integration server.
For example, here's a [Jenkins][] project setup:

* Source Code Management
  * Git
    * Repositories
      * Refspec:

              +refs/pull-requests/*:refs/remotes/origin/pull-requests/*

        (make Jenkins fetch otherwise ignored Stash-created branches)

    * Branches to build
      * Branch Specifier:

              origin/pull-requests/*/merge

        (merge results of open non-conflicting pull requests)

* Build
  * Execute shell
    * Command

            export PULL_REQUEST_ID=`echo $GIT_BRANCH | cut -d / -f 3`

            gem install rubocop face_control
            npm install -g coffeelint

            face-control <project> <repository> $PULL_REQUEST_ID

If you don't want to receive RuboCop comments with certain severity level,
pass the severity in the `--skip-severity` option like so:

    face-control --skip-severity convention <project> <repository> <pull_request_id>

You can use just `-S`.
You can also pass multiple severity levels as a comma-separated list:

    face-control -S convention,refactor <project> <repository> <pull_request_id>

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
[Jenkins]: http://jenkins-ci.org
[Face control]: http://en.wikipedia.org/wiki/Face_control
