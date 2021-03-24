module Examples.Model

import Language.Reflection

%language ElabReflection

Time : Type

Id : Type -> Type


record User where
    constructor MkUser
    id : Id User
    email, token, username, bio, image : String


record Article where
    constructor MkArticle
    id : Id Article
    slug, title, description, body : String
    createdAt, updatedAt : Time
    author : Id User


record Comment where
    constructor MkComment
    id : Id Comment
    createdAt, updatedAt : Time
    body : String
    author : Id User


record Favorite where
    constructor MkFavorite
    id : Id Favorite
    user : Id User
    article : Id Article


record Tag where
    constructor MkTag
    id : Id Tag
    article : Id Article
    tag : String


-- %runElab derive "User" [Generic, Meta, Eq, Ord, DecEq, Show, Db ]
-- %runElab derive "Profile" [Generic, Meta, Eq, Ord, DecEq, Show ]
-- %runElab derive "Article" [Generic, Meta, Eq, Ord, DecEq, Show, Db ]
-- %runElab derive "Comment" [Generic, Meta, Eq, Ord, DecEq, Show, Db ]
-- %runElab derive "Favorite" [Generic, Meta, Eq, Ord, DecEq, Show, Db ]
-- %runElab derive "Tag" [Generic, Meta, Eq, Ord, DecEq, Show, Db ]


interface Db t where
    get : Id t -> Db t
    create : t -> Db t 
    update : Id t -> t -> Db t
    delete : Id t -> Db ()


db : List String
db =
    [ "users", "articles", "comments" ]
