module Bingo where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp

import String exposing (toUpper, repeat, trimRight)

-- MODEL

newEntry phrase points id =
  {
    phrase = phrase,
    points = points,
    wasSpoken = False,
    id = id
  }

initialModel =
  { entries = [
     newEntry "Doing Agile" 400 2,
     newEntry "Learn Asana" 200 1,
     newEntry "Procastinate" 350 3
    ]}

-- UPDATE
type Aksi
  = NoOp
  | Sort
  | Delete Int

update action model =
  case action of
    NoOp ->
      model
    Sort ->
      { model | entries = List.sortBy .points model.entries }
    Delete id ->
      let remainingEntries =
        List.filter (\e -> e.id /= id) model.entries
      in
        { model | entries = remainingEntries }

-- VIEW

title message times =
  message ++ " "
  |> toUpper
  |> repeat times
  |> trimRight
  |> text


pageHeader =
  h1 [] [ title "Bingo!" 3 ]

pageFooter =
  footer [] [
            a [ href "http://citizenlab.co", target "_blank" ]
              [ text "CitizenLab" ]
           ]

listItem address entry =
  li [ ] [
        span [ class "phrase" ] [ text entry.phrase ],
        span [ class "point" ] [ text ( toString entry.points ) ],
        button [ class "delete", onClick address (Delete entry.id) ] [ ]
       ]

listEntries address entries =
  let
      listItems = List.map (listItem address) entries
  in
      ul [ ] listItems


view address model =
  div [ id "container" ]
        [ pageHeader,
          listEntries address model.entries,
          button
          [ class "sort",
            onClick address Sort
          ]
          [ text "sort" ],
          pageFooter
        ]


main =
  StartApp.start {
              model = initialModel,
              view = view,
              update = update
            }
