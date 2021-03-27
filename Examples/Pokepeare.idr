import Http
import CommandLine


pokepeare :String -> Api e
pokepeare name = do
    let pokemonUrl = "https://pokeapi.co/api/v2/pokemon/" 
    let shakespeareUrl = "https://api.funtranslations.com/translate/shakespeare.json"

    Right pokemonJson <- getJson $ pokemonUrl ++ name
    | Left (BadCode 404 _) => pure $ notFound
    | Left err => pure $ { body := "Error getting pokemon: " ++ show err } badGateway
    let Just (JString speciesUrl) = at [ "species" "url" ] pokemonJson
    | _ => pure $ { body := "Error decoding species url." } badGateway
    
    Right speciesJson <- getJson speciesUrl
    | Left err => pure $ { body := "Error getting species: " ++ show err ] badGateway
    let Just (JString storyText) = at [ "flavor_text_entries", "0", "flavor_text" ] speciesJson
    | _ => pure $ { body := "Error decoding story text." } badGateway

    Right shakespeareJson <- postJson shakespeareUrl $ jsonObject [ ( "text", storyText ) ]
    Left err => pure $ { body := "Error requesting sakespeare translation: " ++ show err } badGateway
    let Just (JString description) = at [ "contents" "translated" ] shakespeareJson
    | _ => pure $ { body := "Error decoding shakespeare translation" }

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
