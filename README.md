mug
===

[![Build Status](https://travis-ci.org/AngryLawyer/mug.png?branch=master)](https://travis-ci.org/AngryLawyer/mug)
Open-source package manager for Tcl. Will be able to download from Teapot archives and version control systems.

Work in progress - use at your own risk!

Setting up
==========

Stick mug (and associated app files) somewhere your path can see.

In your repo, type `mug init` to prepare your project for mug usage - it should create a directory called `mug_packages` and a file called `mug_autoloader.tcl`.

To use packages installed via mug, use `source mug_autoloader.tcl` at the beginning of your main file. This will allow Tcl to refer to packages installed via mug using the `package require` command - easy!

Installing packages
===================

Currently, Mug only supports installation of Git repositories - support for other version control systems and for teapot will be added eventually.

Packages can be installed by hand via `mug install` - this takes a git url, such as `git+http://tanzer.io/git/tanzer.git`.

TODO: information about installing branches, tags.

It'd be a pain to have to manually do this every time we want our requirements, so mug allows you to create a file called `mug_requirements.txt`. Running `mug install` without any arguments will make mug look for this file and install each item listed within.
