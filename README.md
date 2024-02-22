# [gumtective.com](https://gumtective.com)

![Example Image](app/assets/images/android-chrome-192x192.png)

This application is developed using Ruby on Rails and React, leveraging ESBuild for compilation and PostCSS (with TailwindCSS) for styling. The frontend is structured around multiple React entry points for different modules (landing, discover, creator). Redis is employed for caching in production. Background processes are managed with Sidekiq. To ensure a smooth user experience, cache pre-warming jobs are scheduled for frequently used requests.

## Prerequisites

- Ruby 3.2.x
- Node.js 20.x
- PostgreSQL 15.x
- Redis 7.x
- Docker and Docker Compose (for demo)

## Launch

A docker-compose.yml file is included for demonstration purposes, allowing to spin up the app with its services. To use:

Download the code

```bash
git clone git@github.com:1kgrice/6gc4d7e1d844d2238009a1037a3b9fa1e98960d40.git gumtective-demo
cd gumtective-demo
```

Set up containers

```bash
docker-compose up
```

## Populate database

Load the database schema

```bash
docker-compose run web rake db:schema:load
```

Import the data
(this will take some time)

```bash
docker-compose run web rake data:import:seeds
```

Generate tag associations for products
(the labels were extracted from product descriptions in advance using some basic language processing)

```bash
docker-compose run web rake data:tags:rebuild
```

For the sake of efficiency, only a small subset of the data is included with the seeds. The actual app in production lists around 250,000 products and has been optimized accordingly.

Visit <http://localhost:3000> to access the local app.

For cleanup, run ```docker-compose down -v```

## Test

This project utilizes RSpec for API testing. To run the tests:

```bash
docker-compose run --rm test
```

## Without Docker

If you prefer to run the project without Docker:

Setup

```bash
bundle install
yarn install
bin/rake db:create
bin/rake db:schema:load
bin/rake data:import:seeds
bin/rake data:tags:rebuild
```

Launch

```bash
bin/dev
```

Test

```bash
bundle exec rspec
```

## Note

This repository reflects the development state of the project. As such, it may contain parts of code that can be refactored or removed all together. Certain level of creative chaos is to be expected.

## Contact

Kirill Ragozin
[ragozin@hey.com](mailto:ragozin@hey.com)
