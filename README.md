# gem package -- WithRecursive

An ActiveRecord extension to add recursive association.

# Description

This extension helps to create hierarchical queries for
self-referential models and allows to traverse ancestors or
descendants, recursively.

See [rails project -- medusa](https://github.com/misasa/medusa) that refers to this package.

# Installation

Add this line to your application's Gemfile:

    gem 'with_recursive'

And then execute:

    $ bundle



# Usage

Add this line to your model

    with_recursive

If foreign_key is not 'parent_id', use :foreign_key option.

    with_recursive foreign_key: :prev_id

If result records should be ordered, use :order option.

    with_recursive order: :name

Additional methods

    parent: get parent record.
    children: get children records.
    ancestors: get ancestors records.
    descendants: get descendants records.
    root: get root record.
    siblings: get same depth records.
    self_and_siblings: get self and same depth records.
    families: get self and ancestors and descendants records.
