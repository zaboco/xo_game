# XoGame

Tic-Tac-Toe game written in Elixir, for fun and learning.

### Usage

> have [elixir installed](http://elixir-lang.org/install.html) (or just erlang, it is sufficient for running the app)

```sh
$ git clone https://github.com/zaboco/xo_game.git && cd xo_game
$ mix deps.get
$ mix escript.build
$ ./xo_game
```

You can optionally clear the screen between each round, feature disabled by default:
```sh
./xo_game --clear
```
