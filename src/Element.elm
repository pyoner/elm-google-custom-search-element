port module Element
    exposing
        ( init
        , ready
        , render
        , go
        , getElement
        , aboutElement
        , execute
        , prefillQuery
        , getInputQuery
        , inputQuery
        , clearAllResults
        , Cx
        , Element
        , Gname
        , Query
        , Attributes
        )


type alias Cx =
    String


type alias Element =
    { gname : String
    , kind : String
    }


type alias Gname =
    String


type alias Query =
    String


type alias Attributes =
    { --General
      gname : Gname
    , autoSearchOnLoad : Bool
    , enableHistory : Bool
    , queryParameterName : String
    , resultsUrl : String
    , newWindow :
        Bool
        --Autocomplete
    , enableAutoComplete : Bool
    , autoCompleteMatchType : String
    , autoCompleteMaxCompletions : Int
    , autoCompleteMaxPromotions : Int
    , autoCompleteValidLanguages :
        String
        --Refinements
    , defaultToRefinement : String
    , refinementStyle :
        String
        -- Image search
    , enableImageSearch : Bool
    , defaultToImageSearch : Bool
    , imageSearchResultSetSize : Int
    , imageSearchLayout : String
    , image_cr : String
    , image_gl : String
    , image_as_sitesearch : String
    , image_as_oq : String
    , image_sort_by : String
    , image_filter :
        String
        --Web search
    , disableWebSearch : Bool
    , webSearchResultSetSize : Int
    , webSearchSafesearch : String
    , webSearchQueryAddition : String
    , cr : String
    , gl : String
    , as_sitesearch : String
    , as_oq : String
    , sort_by : String
    , filter :
        String
        --Search results
    , enableOrderBy : Bool
    , linkTarget : String
    , noResultsString : String
    , resultSetSize : Int
    , safeSearch :
        String
        --Ads
    , adchannel : String
    , adclient : String
    , adtest :
        String
        --Google Analytics
    , gaCategoryParameter : String
    , gaQueryParameter : String
    }


type alias Config =
    { div : String
    , tag : String
    , gname : Gname
    , attributes : Maybe Attributes
    }


port init : Cx -> Cmd msg


port ready : (Bool -> msg) -> Sub msg


port render : ( Config, Maybe Config ) -> Cmd msg


port go : String -> Cmd msg


port getElement : String -> Cmd msg


port aboutElement : (Element -> msg) -> Sub msg


port execute : ( Gname, Query ) -> Cmd msg


port prefillQuery : ( Gname, Query ) -> Cmd msg


port getInputQuery : Gname -> Cmd msg


port inputQuery : (( Gname, Query ) -> msg) -> Sub msg


port clearAllResults : Gname -> Cmd msg
