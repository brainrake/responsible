import Data.Result
import Control.App
import Http
import CommandLine


handleError : String -> App e (Result HttpError r) -> HasErr HttpError e => App e r
handleError _ (Ok x) = pure $ x
handleError _ (Err (BadCode 404 _)) = throwNotFound
handleError thing (Err err) = throwHttpError $ { body := "Error requesting " ++ thing ++ ": " ++ show err } badGateway


pokepeare : HasErr HttpError e => String -> Api e
pokepeare name = do
    let pokemonUrl = "https://pokeapi.co/api/v2/pokemon/" 
    let shakespeareUrl = "https://api.funtranslations.com/translate/shakespeare.json"
    
    speciesUrl <- handleError "pokemon" do
        getJson $ pokemonUrl ++ name $ at ["species" "url"] string
    
    storyText <- handleError "story text" $ do
        getJson speciesUrl $ at [ "flavor_text_entries", "0", "flavor_text" ] string

    description <- handleError "shakespeare translation" $ do
        postJson shakespeareUrl $ toJson [ ( "text", storyText ) ] $ at [ "contents", "transated" ] string

    pure $ ok $ jsonObject [ ( "name", name ), ( "description", description ) ]


main : IO
main =
    (host, port) <- 
        commandLine "Convert Pokemons to Hamlet" <$> (,) 
            <$> optional "i" "ip" $ IPv4Addr 127 0 0 1
            <*> optional "p" "port" 8000 
    nodeServer (host, port) do 
        route "pokemon" $ param \name => 
            get $ pokepeare name


namespace Test
    main : IO ()
    main = printLn $ do
        response <- run $ pokepeare "bulbasaur"
        putStrLn $ response.body == jsonObject [ ( "name", "bulbasaur" ), ( "description", "A strange seed wast planted on its back at birth. The plant sprouts and grows with this pokémon." )]
