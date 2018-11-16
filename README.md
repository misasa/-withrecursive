# gem package -- WithRecursive

An ActiveRecord extension to add recursive association.

# Description

This extension helps to create hierarchical queries for
self-referential models and allows to traverse ancestors or
descendants, recursively.

See
[medusa](https://github.com/misasa/medusa "follow instruction")
that refers to this package.

# Installation

Install the package by yourself as:

    $ gem install with_recursive

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

# Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
