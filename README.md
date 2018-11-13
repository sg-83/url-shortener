# Setup

You should be able to simply clone the repo, run `bundle install` to install
dependencies, followed by `rake db:create`, and `rake db:migrate` to get the
database set up, assuming you have postgres installed.

You can start the app with `rails s` and everything should just work.

When deploying to hosting infrastructure, a DATABASE_URL environment variable
must be set, conforming to the spec [here](https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING),
and SITE_ROOT should match your site's root.


