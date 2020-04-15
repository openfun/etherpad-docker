# Etherpad-lite docker

A stateless Dockerfile for the etherpad-lite application.

## Getting started

To build the image run the following command:

```
$ make build
```

And then you can run a local etherpad instance using postgresql with:

```
$ make run
```

More commands are available, for reference, see:

```
$ make help
```

## Advanced configuration

### Health checks

Our docker image embeds the [lightship](https://github.com/gajus/lightship)
application as an etherpad-lite plugin. It provides health check status
endpoints to a running etherpad instance. The following environment variable
can be injected in the container to configure its behavior:

- `EP_LIGHTSHIP_DETECT_KUBERNETES`: a boolean-like string to choose whether
  `lightship` should detect its environment and assign a random port to listen
  to while not in k8s environment (default: `false`),

- `EP_LIGHTSHIP_PORT`: the fixed port to listen to
  (default: `9002`). Note that if `EP_LIGHTSHIP_DETECT_KUBERNETES` is `true`
  and you are running in a non-k8s environment, this setting has no effect.

## Contributing

This project is intended to be community-driven, so please, do not hesitate to
get in touch if you have any question related to our implementation or design
decisions.

We try to raise our code quality standards and expect contributors to follow
the recommandations from our
[handbook](https://openfun.gitbooks.io/handbook/content).

## License

This work is released under the MIT License (see [LICENSE](./LICENSE)).
