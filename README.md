# elm-cms (wip)

A reliable content management dashboard that does and will subbornly resist overengineering.

## Use

* Declare your records, their fields, validations, form field types and more all in the ease and expressiveness of Elm's type system (types provided).
* Set up a rest API. Hold on to its URL.
* Authenticate the user. Set tokens and cookies. Remember that name.
* Pass this info to your Elm app as flags.
* Create that great content.

## Come again?

Oh, right, code examples are better. Here's how you run the one in the `./example` folder (it's a todo list alright, but this time, you don't have to make it!):

* install some nice things: `npm i -g elm-live json-server`
* start a simple JSON file-based REST server: `json-server ./example/db.json --port 3001` (watch that file grow nice and chubby as you create records)
* run the Elm app: `elm-live ./example/Main.elm --dir=./example --output example/elm.js --open --pushstate`

### How works it?

Your client Elm program is as little as the following:

```elm
module Main exposing (..)

import Cms exposing (programWithFlags, Model, Flags, Msg)
import Cms.Field exposing (Field, Type(..))


todoFields : List Field
todoFields =
    [ { id = "task"
      , type_ = Text
      , showInListView = False
      , default = Nothing
      , validation = Nothing
      }
    , { id = "completed"
      , type_ = Radio [ "yes", "no" ]
      , showInListView = False
      , default = Just "no"
      , validation = Nothing
      }
    ]


main : Program Flags Model Msg
main =
    programWithFlags
        [ ( "todo", todoFields )
        ]
```

Notice how you didn't need to pass views, updates or inits. That's because `Cms.programWithFlags` already wraps `Navigation.programWithFlags`, and comes with views and updates of its own.

On the markup side, things are not any more complicated:

```html
<div id="root"></div>
<script>
  var app = Elm.Main.embed(document.getElementById('root'), {
    user: 'Alfred',
    apiUrl: 'http://localhost:3001'
  });
</script>
```

## The extras

### Images

You can upload images using the bottom-left widget - but you need to handle the heavy-lifting yourself. Here's how it works:

* when an image is uploaded, Elm sends a message to the `uploadFile` port with the id of the input element.
* in JavaScript, you can read the file, send it to a server, and get a hold of the URL it landed on.
* simply pass back this URL to the `fileUploaded` port, so the program can display it in the widget.

This is super useful if the markdown you're editing contains images. You can simply copy the URL that comes back and add it in a markdown image tag, like so: `![](i-got-this-from-js.jpg)`.
