# Microservices in times of Elixir

For Martin Fowler, "the microservice architectural style is an approach to developing a single application as a suite of small services, each running in its own process and communicating with lightweight mechanisms."

This (public) repository is a personal exploration of monolith and service-based software architectures styles and how it can translate to the Elixir ecosystem. How hard or easy it is ? None of the code is meant to be working at any time or be put in production in any future. Basically, a draft notebook!

## Run

The repository is a demo showcasing the deployment of the same application using differents architecture styles. Language requirements are full defined in the [.tool-versions](.tool-versions) file. With [asdf](https://asdf-vm.com/) and [just](https://github.com/casey/just) installed,

```
just # List all available commands
```

```
install    # Install requirements & dependencies
quality    # Check code quality
test       # Run the tests
docs       # Generate the documentation
ready      # Is the application ready to commit?
run        # Run the monolith application in development mode
build      # Build the releases in production mode
deploy app # Deploy the application
remote app # Connect to the application
```

## Documentations

### Presentations

*Presentations are available in the [docs/ressources](docs/presentations/) folder. Send me a DM if you want me to give the presentation IRL or online for you or your team.*

- [Monolith or microservices ?](docs/presentations/monolith_or_microservices.png), a 10-20 minutes presentation, comparing the monolith and microservices approaches during the developement/build/deployment phases of a project, is available under the form of a PNG with an embedded [excalidraw](https://excalidraw.com/).

### Ressources

*Personal notes about ressources are available in the [docs/ressources](docs/ressources/) folder.*

- [Martin Fowler - Microservices](docs/ressources/microservices_martin_fowler.md)
- [Elixir in times of microservices, José Valim](docs/ressources/elixir_in_time_of_microservices_jose_valim.md)
- [Three real-world examples of distributed Elixir (pt. 1), bigardone.dev](https://bigardone.dev/blog/2021/05/22/three-real-world-examples-of-distributed-elixir-pt-1)

