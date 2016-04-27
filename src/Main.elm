module Main where
-- underweight (BMI less than 18.5)
-- normal weight (BMI between 18.5 & 24.9)
-- overweight (BMI between 25.0 & 29.9)
-- obese (BMI 30.0 and above)
--

import Html
import Html.Events exposing (onClick, on, targetValue)
import String


type alias Model =
  { weight : Int
  , height : Int
  }


type Action =
    NoOp
  | WeightChanged Int
  | HeightChanged Int


type Status =
    UnderWeight
  | NormalWeight
  | OverWeight
  | Obese


bmi : Model -> Float
bmi model =
  -- weight in kilograms / height in meters^2
  let
    h = toFloat model.height / 100
  in
    toFloat model.weight / (h * h)


-- bmiStatus : Model -> Status
-- bmiStatus model =
--   let result = bmi model
--   in case result of
--     18.5 ->
--       UnderWeight


view : Signal.Address Action -> Model -> Html.Html
view address model =
  let
    onChanged action =
      on "change" targetValue (\str -> Signal.message address (action (String.toInt str |> Result.toMaybe |> Maybe.withDefault 0)))
    onWeightChanged = onChanged WeightChanged
    onHeightChanged = onChanged HeightChanged
    makeOption val = Html.option [] [ Html.text val ]
    makeOptions xs = xs |> List.map toString |> List.map makeOption
    bmiVal = (bmi model)

  in

    Html.div
      []
      [ Html.div [] [ Html.text (if (isInfinite bmiVal) || (isNaN bmiVal) then "--" else toString bmiVal) ]

      , Html.select [ onWeightChanged ]
        (makeOption "--" :: makeOptions [50..100])

      , Html.select [ onHeightChanged ]
        (makeOption "--" :: makeOptions [150..200])
        ]


update : Action -> Model -> Model
update action model =
  case action of
    WeightChanged weight ->
      { model | weight = weight }
    HeightChanged height ->
      { model | height = height }
    NoOp ->
      model


mb : Signal.Mailbox Action
mb =
  Signal.mailbox NoOp


modelSignal : Signal.Signal Model
modelSignal =
  Signal.foldp update (Model 0 0) mb.signal


main : Signal.Signal Html.Html
main =
  Signal.map (view mb.address) modelSignal
