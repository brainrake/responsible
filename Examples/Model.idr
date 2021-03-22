module Examples.Model

Time : Type


record User where
    constructor MkUser
    email, token, username, bio, image : String


record Profile where
    constructor MkProfile
    username, bio, image : String
    following : Bool


record Article where
    constructor MkArticle
    slug, title, description, body : String
    tagList : List String
    createdAt : Time
    updatedAt : Time
    favorited : Bool
    favoritesCount : Int
    author : Profile


record Comment where
    constructor MkComment
    id : Int
    createdAt : Time
    updatedAt : Time
    body : String
    author : Profile
