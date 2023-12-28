set dotenv-load

_default:
  @just --list --unsorted  --list-heading '' --list-prefix=''

# Install the requirements & dependencies
install:
  asdf install
  mix deps.get

# Check code quality
quality: install
  mix quality

# Run the tests
test: install
  mix test

# Generate the documentation
docs: install
  mix docs
  @echo "Documentations available in docs/ directory"

# Is the application ready to commit?
ready: install quality test
  @echo "Ready to commit!"

# Run the monolith application in development mode
run: install
  mix run --no-halt

# Build the releases in production mode
build: install
  MIX_ENV=prod mix release monolith --overwrite
  MIX_ENV=prod mix release backend --overwrite
  MIX_ENV=prod mix release frontend --overwrite

# Deploy the application
deploy app:
  RELEASE_NAME=frontend MIX_ENV=prod _build/prod/rel/{{app}}/bin/{{app}} start

# Connect to the application
remote app:
  _build/prod/rel/{{app}}/bin/{{app}} remote
