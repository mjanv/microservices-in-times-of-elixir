_default:
  @just --list

# Check code quality
quality:
  mix deps.get
  mix format --check-formatted
  mix credo --strict

# Run the tests
test:
  mix deps.get
  mix test

# Run the monolith application locally
run:
  mix deps.get
  mix run --no-halt

# Build the releases
build:
  mix deps.get
  MIX_ENV=prod mix release monolith --overwrite
  MIX_ENV=prod mix release backend --overwrite
  MIX_ENV=prod mix release frontend --overwrite

# Deploy the application
deploy app:
  MIX_ENV=prod _build/prod/rel/{{app}}/bin/{{app}} start

# Connect to the application
remote app:
  _build/prod/rel/{{app}}/bin/{{app}} remote
