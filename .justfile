build:
  mix deps.get
  MIX_ENV=prod mix release backend --overwrite
  MIX_ENV=prod mix release frontend --overwrite

monolith:
  mix deps.get
  MIX_ENV=prod mix release monolith --overwrite


start app:
  MIX_ENV=prod _build/prod/rel/{{app}}/bin/{{app}} start

remote app:
  _build/prod/rel/{{app}}/bin/{{app}} remote

app sname:
  iex --cookie secret --name {{sname}}@127.0.0.1 -S mix run --no-halt
