# README

* Ruby version 3.2.1

* Rails version 8.1.1

* Configuration and Installation please prefer to INSTALLATION.md

## About The Project
An Url shortening application which sole purpose is to shorten any long URL into short URL.

## Quick Start

Prefer to [INSTALLATION.md](INSTALLATION.md) for detailed installation and running instructions.

## API Documentation

### Endpoints

- `POST /encode` - Shorten a URL
- `POST /decode` - Retrieve original URL

For detailed setup instructions, see [INSTALLATION.md](INSTALLATION.md).

## Potential attack

### SQL inject
Rails with ActiveRecord is taking care of this.

### DDos attack
Endpoints can be flood with requests and the database will be fill with billions of URL
We can mitigate this by limiting the number of requests by using the access_count number and timestamp
We can also use the gem 'rack-attack' to limit the number of request per minutes, adding Captcha for suspicious activities.

### Cross-Site Scripting (XSS)
Attacker can encode URLs with JavaScript payloads
We have URL validation to accept only http and https to avoid `javascript:` 

## Scale up

### Redirect
People will want to visit the original URL directly upon using the short URL.

Implement the redirect mechanism and move the 2 endpoints to other path.

### Collision
Over time the number of URL will increase to 10 or over 100 millions the percentage of collision will increase. 
In the code we have the retry mechanism but if the percentage is too high it will pose problem.

Increase the number of characters to 7, 8 and more base on the number of URLs we predict will grow in the near future

