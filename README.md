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
git clone https://github.com/1kgrice/6gc4d7e1d844d2238009a1037a3b9fa1e98960d40.git gumtective-demo
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

For the sake of efficiency, only a small subset of the data is included with the seeds. The actual app in production lists around 250,000 products from Gumroad creators and has been optimized accordingly.

Visit <http://localhost:3000> to access the local app.

For cleanup, run ```docker-compose down -v```

## Additional setup

This app uses wildcard subdomains for creator pages. They aren't always resolved by default on localhost.
This issue is known to be present on Safari on MacOS. If you run into it, you'll need to install an tool to resolve subdomains.
Here's an example using dnsmasq ([credit](https://gist.github.com/ogrrd/5831371)):

- Install

```bash
brew install dnsmasq
```

- Create config directory

```bash
mkdir -pv $(brew --prefix)/etc/
```

- Setup *.localhost

```bash
echo 'address=/.localhost/127.0.0.1' >> $(brew --prefix)/etc/dnsmasq.conf
```

- Change port (for older OS)

```bash
echo 'port=53' >> $(brew --prefix)/etc/dnsmasq.conf
```

- Autostart - now and after reboot

```bash
sudo brew services start dnsmasq
```

- Create resolver directory

```bash
sudo mkdir -v /etc/resolver
```

- Add your nameserver to resolvers

```bash
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/localhost'
```

## Test

This project utilizes RSpec for API testing. To run the tests:

```bash
docker-compose run --rm test
```

## Install without Docker

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
