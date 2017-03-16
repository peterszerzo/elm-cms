json-server ./example/db.json --port 3001 &
elm-live ./example/Main.elm --dir=./example --output example/elm.js --open --pushstate
