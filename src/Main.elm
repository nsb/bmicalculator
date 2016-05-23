module Main exposing (..)

-- underweight (BMI less than 18.5)
-- normal weight (BMI between 18.5 & 24.9)
-- overweight (BMI between 25.0 & 29.9)
-- obese (BMI 30.0 and above)
--

-- giphy
-- http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=american+psycho

import Html exposing (Html, button, div, text, select)
import Html.Events exposing (onClick, on, targetValue)
import Html.Attributes exposing (class, src)
import Html.App as Html
import String
import Json.Decode as Json
import Http
import Task


type alias Model =
  { weight : Int
  , height : Int
  , gifUrl : String
  }


init : String -> (Model, Cmd Msg)
init topic =
  ( Model 0 0 topic
  , getRandomGif topic
  )


type Msg
  = NoOp
  | WeightChanged Int
  | HeightChanged Int
  | FetchSucceed String
  | FetchFail Http.Error


type Status
  = UnderWeight
  | NormalWeight
  | OverWeight
  | Obese



{-| Round a `Float` to a given number of decimal places.
-}
roundTo : Int -> Float -> Float
roundTo places =
  let
    factor =
      10 ^ places
  in
    (*) factor >> round >> toFloat >> (\n -> n / factor)


bmi : Model -> Float
bmi model =
  -- weight in kilograms / height in meters^2
  let
    h =
      toFloat model.height / 100
  in
    roundTo 2 (toFloat model.weight / (h * h))



-- bmiStatus : Model -> Status
-- bmiStatus model =
--   let result = bmi model
--   in case result of
--     18.5 ->
--       UnderWeight


view : Model -> Html.Html Msg
view model =
  let

    onChanged message =
      on "change" (Json.map (\str -> message (String.toInt str |> Result.toMaybe |> Maybe.withDefault 0)) targetValue)

    onWeightChanged =
      onChanged WeightChanged

    onHeightChanged =
      onChanged HeightChanged

    makeOption val =
      Html.option [] [ Html.text val ]

    makeOptions xs =
      xs |> List.map toString |> List.map makeOption

    bmiVal =
      (bmi model)
  in
    Html.div
      [ class "mx-auto" ]
      [ Html.div
          []
          [ Html.h1
              []
              [Html.text (if (isInfinite bmiVal) || (isNaN bmiVal) then
                "--"
               else
                toString bmiVal
              )]
          ]
      , Html.select
          [ onWeightChanged ]
          (makeOption "Weight" :: makeOptions [50..100])
      , Html.select
          [ onHeightChanged ]
          (makeOption "Height" :: makeOptions [150..200])
      , Html.div
           []
           [ Html.img [src model.gifUrl] [] ]
      ]


update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    WeightChanged weight ->
      ({ model | weight = weight }, getRandomGif "overweight")

    HeightChanged height ->
      ({ model | height = height }, getRandomGif "underweight")

    FetchSucceed url ->
      ({ model | gifUrl = url }, Cmd.none)

    FetchFail error ->
      (model, Cmd.none)

    NoOp ->
      (model, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string


main =
  Html.program
    { init = init "overweight"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
