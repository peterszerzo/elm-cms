# elm-cms (wip)

A reliable content management dashboard that does and will subbornly resist overengineering.

## Use

* Declare your records, their fields, validations, form field types and more all in the ease and expressiveness of Elm's type system (types provided).
* Set up a rest API. Hold on to its URL.
* Authenticate the user. Set tokens and cookies. Remember that name.
* Pass this info to your Elm app as flags.
* Create that great content.

## Wait what?

Right, code examples are better..

```elm
module Main exposing (..)

import Cms exposing (programWithFlags, Model, Flags, Msg)
import Cms.Field exposing (Field, Type)

fields = []

main =
    programWithFlags
        [ ("todo", fields)
        ]
```

```js

```

## Run the example

Install elm-live: `npm i -g elm-live`

Then watch: `elm-live ./example/Main.elm --dir=./example --output example/elm.js --open --pushstate`
