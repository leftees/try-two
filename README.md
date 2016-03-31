# Web application consuming try-one Proto forum API Mysterious Ruby Backend

[![Code Climate](https://codeclimate.com/github/vassiliy/try-two/badges/gpa.svg)](https://codeclimate.com/github/vassiliy/try-two)
[![Test Coverage](https://codeclimate.com/github/vassiliy/try-two/badges/coverage.svg)](https://codeclimate.com/github/vassiliy/try-two/coverage)
[![Issue Count](https://codeclimate.com/github/vassiliy/try-two/badges/issue_count.svg)](https://codeclimate.com/github/vassiliy/try-two)
[![Build Status](https://travis-ci.org/vassiliy/try-two.svg?branch=master)](https://travis-ci.org/vassiliy/try-two)

First, assemble try-one backend on `localhost:5000` if you wish _(Puma manuals state that its running on 5000 port despite configurations is a mystery, I haven't solved it yet either)._

If not, this backend is accessible at [Heroku](http://try-catch-vassiliy-pimkin.herokuapp.com): `http://try-catch-vassiliy-pimkin.herokuapp.com`.

Application itself runs at `index.html`.

Jasmine specs live in `jasmine/spec/SpecHelper.html`.

To run them headless, touch the project **npm** with `npm install`, then `grunt jasmine` will give you a thing.