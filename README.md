# datap


## Philosophy

During the `db:reset`, it will seed the database.  This will take a few minutes.

But why does it take so long?

* It downloads a copy of the Alexa top 1 million sites (9.3 MB).
* These are used to build entropy, so that the dataset is real-ish for both:
  - urls being hit, and
  - referrers
* Building this entropy takes several minutes, but
  - having a data set that is realistic is helpful to notice bugs in data handling, especially with queries.
* Importing the 1 million records tends to take around 60-120 seconds, depending on the speed of the computer.

## How to use this project

### Setup

```bash
bundle install
bin/rake db:reset
RAILS_ENV=test bin/rake db:reset
bundle exec rspec
```

### Run

* Use [overmind][] to launch your processes in development. You just need to run
  - `overmind s -f Procfile.dev`

## NOTE

The DB must be seeded every day, to keep the leading edge of the data fresh.
This test suite validates a "production prototype", so it has to be "realistic".
Timecop can't be used to fake it because the DB queries use SQL magic like this:

```sql
CURRENT_DATE - INTERVAL '#{days_ago} days'
```

[overmind]: https://github.com/DarthSim/overmind
