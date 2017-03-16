# elm-cms

A small but sturdy content management dashboard that lets you make some records with wildly custom structure and validation. Make it into a Markdown editor, or a Yaml one. Upload some images. Rest your data in Elm's trusted hands.

## Use

Simpler than you think:
* Declare your records, their fields, validations, form field types and more all in the ease and expressiveness of Elm's type system (types provided).
* Set up a rest API. Hold on to its URL.
* Authenticate the user. Set tokens and cookies, and make sure they're verified on back-end.
* Pass authenticated user name and REST API url to your Elm app as flags.
* Your dashboard is now running. Go create that great content!

## Come again?

Oh, right, code examples are better. Here's how you run the one in the `./example` folder (it's a todo list alright, but this time, you don't have to make it!):

* install some nice things: `npm i -g elm-live json-server`
* run `./example/run.sh` (or just run its two commands in two separate tabs from the project root). The first one runs a simple JSON file-based REST server (watch that file grow nice and chubby as you create records), and the second one runs the Elm app via `elm-live`.

### How works it?

Your client Elm program is as little as the following:

```elm
module Main exposing (..)

import Cms exposing (programWithFlags, defaultConfig, Model, Flags, Msg)
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
        ] defaultConfig
```

Notice how you didn't need to pass views, updates or inits. That's because `Cms.programWithFlags` already wraps `Navigation.programWithFlags`, and comes with the view/update shenanigans of its own.

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

In the example above, we simply passed an argument `defaultConfig` into the library's program constructor. But that's just a bunch of `Nothing`'s. Let's add some somethings in there!

### File uploads

You can upload images using the bottom-left widget - but you need to handle the heavy-lifting yourself. First, define some ports and make your config argument a little more custom:

```elm
port uploadFile = String -> Cmd msg
port fileUploaded = (String -> msg) -> Sub msg

config =
    { fileUploads = Just { incomingPort = fileUploaded, outgoingPort = uploadFile }
    , customValidations = Nothing
    }

main = programWithFlags records config
```

Here's how it works from this point onwards:

* when an image is uploaded, Elm sends a message to the `uploadFile` port with the id of the `input[type="file"]` element.
* in JavaScript, you can read the file, send it to a server, and get a hold of the URL it got uploaded to.
* simply pass back this URL to the `fileUploaded` port, so the Elm program can display it in the file upload widget.

This is super useful if you're editing some Markdown that contains images. You can simply copy the URL that comes back and add it in a markdown image tag, like so: `![Some alt attribute](i-got-this-from-js.jpg)`.

### Custom validations

Remember I promised rambled about Markdown and Yaml? Is all that packaged into `elm-cms`?

Nope, it's not, it's part of a feature called custom validations. For a given field in a record, you can define a custom validation, which relies on a JS-through-port service to validate in whatever way your heart desired, and that also serves as custom way to preview your data inside the editor.

Once again, it starts with some ports:

```elm
port validateField : String -> Cmd msg
port fieldValidated : (String -> msg) -> Sub msg

config =
    { fileUploads = Nothing
    , customValidations = Just { incomingPort = fieldValidated, outgoingPort = validateField }
    }

main = programWithFlags records config
```

Say you specify that a given field has a validation `{ type_ = Custom "yaml", errorMessage = "Invalid yaml." }`. At this point, every time you make a change in this field, you get a message in the `validateField` port. In JavaScript, you're expected evaluate the new value and send back a validation including a custom message (see example for details, and stay tuned for more docs). This message can be the Yaml parser's error message, or if the Yaml is valid, the converted Json. This is then displayed in Elm if you pick the text area field.

So you just got yourself a Yaml editor for free. Or Toml. Or Cson.
