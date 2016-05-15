module Main exposing (..)

-- underweight (BMI less than 18.5)
-- normal weight (BMI between 18.5 & 24.9)
-- overweight (BMI between 25.0 & 29.9)
-- obese (BMI 30.0 and above)
--

import Html exposing (Html, button, div, text, select)
import Html.Events exposing (onClick, on, targetValue)
import Html.Attributes exposing (class)
import Html.App as Html
import String
import Json.Decode as Json


type alias Model =
  { weight : Int
  , height : Int
  }


model : Model
model = Model 0 0


type Msg
  = NoOp
  | WeightChanged Int
  | HeightChanged Int


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
          (makeOption "--" :: makeOptions [50..100])
      , Html.select
          [ onHeightChanged ]
          (makeOption "--" :: makeOptions [150..200])
      ]


update : Msg -> Model -> Model
update message model =
  case message of
    WeightChanged weight ->
      { model | weight = weight }

    HeightChanged height ->
      { model | height = height }

    NoOp ->
      model


main =
  Html.beginnerProgram { model = model , view = view , update = update }
