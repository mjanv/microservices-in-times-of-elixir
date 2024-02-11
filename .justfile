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

# Run the monolith application in development mode
run: install
  mix run --no-halt

# Build the release in production mode
build release: install
  MIX_ENV=prod mix release {{release}} --overwrite

# Deploy the application
deploy app name:
  RELEASE_NAME={{name}} MIX_ENV=prod _build/prod/rel/{{app}}/bin/{{app}} start

# Connect to the application
remote app name:
  RELEASE_NAME={{name}} MIX_ENV=prod _build/prod/rel/{{app}}/bin/{{app}} remote
