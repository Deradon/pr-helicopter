
PR Helicopter
=============

__You__ have migrated Wimdu in a remarkable moment from Ruby to PL/SQL and your fingers are ready to press the button to __merge__ of your __pull request into master__ :neckbeard:. But wait you're not sure about potential __business impacts?__ :scream:

Dont worry anymore - __PR Helicopter__ comes __to the rescue!__ :sunglasses:


## About

The intent of _PR Helicopter_ is to monitor pull requests for potential risks. To do that it consumes web hooks from Github API each time somebody makes or updates a PR. When a important file contains changes, the service does notify everyone who is intersted in. For example the BI about database schema changes.

## How its working

When starting the service, it does the following:

1. Add web hook for pull requests
2. Start server to receive hooks from Github
3. Wait for incomming events
 - Grep the pull request's files
 - Send notification to receivers
4. Remove web hook on exit

## TODO

- All about notification
- Stable way to figure out the URI to use for (IP and Port propably)
- Auto-Restart image on crash
- Specs
- Changelog
- First release

## DevOps

PR Helicopter is written as a micro service using [docker][docker] build on top of [alpine linux][alpine].

Why _alpine linux_? Its a very lightweight Linux distribution. The whole PR Helicopter image is less than 18 MB in size. Making it usefull for building micro services.

```sh
bash-3.2$ docker images
REPOSITORY          TAG                 IMAGE ID            VIRTUAL SIZE
pr-helicopter       latest              7eefa50c895a        17.95 MB
alpine              3.2                 31f630c65071        5.254 MB
```

See the [Dockerfile][dockerfile] for more informations.

### Config

Before running the service, some config variables must be placed in. Rename [config.sample.yml][config] to _config.yml_ and adapt the settings to your needs.

| env | description | sample |
| --- | ----------- | ------ |
| repo | The Github repository to monitor for | wimdu/wimdu |
| secret | OAuth access token: https://github.com/settings/tokens | 0123456789... |
| hook | URL to which the payloads will be delivered | https://heli.wimdu.com |


### Build Scripts

The services comes with some tiny commands helpfull for development and operation.

| cmd | description |
| --- | ----------- |
| `./bin/build` | Builds the image or updates it when the Dockerfile contains changes. |
| `./bin/run` | Boots the image and starts the service as a deamon. |
| `./bin/dev` | Builds the images and starts the service. |
| `./bin/clean` | Cleans up shallow image copies created during development. |
| `./bin/ip` | Prints out the IP of the docker image. |


## Dev

The best starting point to get into the topic is the [service][service] script. It looks like this and should be self explaning. It follows the steps described above.

```ruby
#
# 1. Send postcard to Github
#

# Env config for selected environment
env  = YAML.load_file('config.yml')[ENV['ENV'] || 'development']
# Github v3 API endpoint for wimdu repo
repo = Github::Client.new(secret: env['secret']).repos[env['repo']]
# Adds web hook to wimdu
hook = repo.web_hooks.add(env['hook'], events: ['pull_request'])

#
# 2. Refuel the helicopter
#

heli = Helicopter.new on_pull: ->(id) {
    puts repo.pulls[id].files
}

#
# 3. Black Hawk Down
#

# Trap ^C and shutdown heli :'(
trap('INT') { heli.shutdown }
# Remove hook from repo on exit
at_exit { hook.delete }

#
# 3... 2... 1... GO!
#

heli.start
```

Taking a look into [Helicopter#grep_files_and_notify][heli] is also an good idea!

### Github Client

The client supports the [Github API v3][github]. To keep things as simple as possible the does only support things that are needed as listed below in the table.

1. Instantiate the client

    ```ruby
    client = Github::Client.new secret: 'my-40-digit-secret'
    ```

2. Access a repository

    ```ruby
    repo = client.repos['wimdu/wimdu']
    ```

3. Add web hook to a repository

    ```ruby
    repo.web_hooks.add 'https://dev.heli.wimdu.com', events: ['pull_request']
    ```

4. Remove web hook from repository

    ```ruby
    repo.web_hooks.delete(1234)
    ```

5. Access pull requested files

    ```ruby
    repo.pulls[4321].files
    ```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[docker]: https://www.docker.com
[alpine]: http://alpinelinux.org
[dockerfile]: https://github.com/wimdu/pr-helicopter/blob/master/Dockerfile
[service]: https://github.com/wimdu/pr-helicopter/blob/master/service
[config]: https://github.com/wimdu/pr-helicopter/blob/master/config.sample.yml
[heli]: https://github.com/wimdu/pr-helicopter/blob/master/lib/helicopter.rb
[github]: https://developer.github.com/v3/
