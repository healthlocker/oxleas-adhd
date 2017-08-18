# Headscape Focus

## Getting started

You will need to have the following installed:
* [Elixir](https://elixir-lang.org/install.html)
* Hex - `mix local.hex`
* [Phoenix](https://github.com/dwyl/learn-phoenix-framework/blob/master/simple-server.md#first-step---installing-phoenix)
* [Postgres](https://wiki.postgresql.org/wiki/Detailed_installation_guides)
* [phantomjs](https://github.com/keathley/wallaby#phantomjs) for testing

* `git clone` the repo & cd into the project
* Ensure you have postgres running.
* In command line, run the following commands:
  * `mix deps.get`
  * `npm i`
  * `mix ecto.create`
  * `mix ecto.migrate`
  * `mix phoenix.server`

This will install dependencies, node modules, create the database and all the
tables, then start the server.

Tests can be run with `mix test` in the route of the project. This will run
tests for both applications under `apps/`.

## Why?
Following the latest version of [Healthlocker](https://github.com/healthlocker/healthlocker),
a team within [Oxleas NHS Foundation Trust](http://oxleas.nhs.uk/)
have decided that this would be a very useful tool to help them work with
the young people in their care due to both its features and the focus on collaboration
with the Service Users' guardians.

## What?
Given that Oxleas do not use the ePJS system, some modifications will be required
to ensure that Healthlocker will function as expected without ePJS.
In addition, the main additions requested by Oxleas can be summarised as:
+ User management, now controlled by a super admin within Oxleas as there will
be no system (such as ePJS) to verify identities of Service Users (SU), Clinicians or Carers
at this MVP stage [#23](https://github.com/healthlocker/oxleas-adhd/issues/23)
+ Medication form where Clinicians (Staff) can fill in an SU's medication (visible by SU)
+ 'About Me' form where both the SU and the Clinician can fill in information about
the SU
+ Content changes to make things clearer to the intended audience
+ Some changes to the branding and user interface to bring this more in line with
Oxleas' desired brand name.

## How?

Headscape Focus is made with a 'generic' version of the Healthlocker
application, with functionality specific to Headscape focus included in.

This is done with an [umbrella project](https://elixir-lang.org/getting-started/mix-otp/dependencies-and-umbrella-apps.html).
With this, we can create several sub-applications which work together. This
allows us to modularise & separate code, which makes the project more
maintainable with growth.
