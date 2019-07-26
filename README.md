# datap

## How to use this project

### Setup

During the `db:reset`, it will seed the database.  This will take a few minutes.

But why does it take so long?

1. It downloads a copy of the Alexa top 1 Million sites (9.3 MB).
2. These are used to build entropy, so that the dataset is real-ish for both:
  A. urls being hit, and
  B. referrers
3. Building this entropy takes 2-3 minutes, but
  A. having a data set that is realistic is helpful to notice bugs in data handling, especially with queries.
4. Importing the 1 million records tends to take around 60-90 seconds.

```bash
bundle install
bin/rake db:reset
RAILS_ENV=test bin/rake db:reset
bundle exec rspec
```

### Run

* Use [overmind][] to launch your processes in development. You just need to run
  - `overmind s -f Procfile.dev`

[overmind]: https://github.com/DarthSim/overmind
