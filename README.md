# RefactorErl docker container

This container is meant to provide a ready-to-go RefactorErl instance, including the right yaws version.

For more information about RefactorErl, please see [its wiki](http://pnyf.inf.elte.hu/trac/refactorerl/wiki).

## Build

    $ git clone https://github.com/srenatus/refactorerl-docker
    $ cd refactorerl-docker
		$ docker build -t referl .

## Use

To add _your code_ for RefactorErl's inspection capalibilies by adding a `referl_repo.erl` like this:

    
```
-module(referl_repo).

-export([start/0, load/0]).

start() ->
    rpc:call(refactorerl@localhost, referl_repo, load, []).

load() ->
    ri:reset(),

    [ ri:add("/code/apps", App) || App <- [app1, app2] ].
```

This file will be compiled and `referl_repo:start/0` is run when the container is started:

    $ docker run -v /path/to/repo/:/code -p 8001:8001 -it referl

The web UI can be accessed via http://localhost:8001.

Note that further RefactorErl calls can happen in `load/0`, for example executing semantic queries via

    ri:q("mods.funs[loc > 0].mccabe, [{out, "/code/mccabe.out"}])
