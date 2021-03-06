port module CustomSearch.Element
    exposing
        ( load
        , listen
        , render
        , execute
        , prefillQuery
        , getInputQuery
        , clearAllResults
        , clear
        )

import Json.Decode as Decode
import Json.Encode as Encode


--local import

import CustomSearch.Types
    exposing
        ( Cx
        , Query
        , Gname
        , Event(DecodeError)
        , ElementId
        , Component(..)
        )
import CustomSearch.Attributes exposing (Attributes)
import CustomSearch.Decode exposing (decoder)
import CustomSearch.Encode exposing (componentEncoder)


{-| Load a CSE script
-}
port load : Cx -> Cmd msg


port render_ : Encode.Value -> Cmd msg


{-| Renders a CSE element
-}
render : Component -> Attributes -> Cmd msg
render component attrs =
    render_ (componentEncoder component attrs)


{-| Executes a programmatic query
-}
port execute : ( Gname, Query ) -> Cmd msg


{-| Prefills the searchbox with a query string without executing the query
-}
port prefillQuery : ( Gname, Query ) -> Cmd msg


{-| Gets the current value displayed in the input box
-}
port getInputQuery : Gname -> Cmd msg


{-| Clears the control by hiding everything but the search box, if any
-}
port clearAllResults : Gname -> Cmd msg


{-| Clear dom by element id
-}
port clear : String -> Cmd msg



-- Subscriptions


port event : (Decode.Value -> msg) -> Sub msg


listen : (Event -> msg) -> Sub msg
listen tagger =
    event
        (\v ->
            tagger <|
                case (Decode.decodeValue decoder v) of
                    Ok event ->
                        event

                    Err err ->
                        DecodeError err
        )
