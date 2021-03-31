-- It is generally a good idea to keep all your business logic in your library
-- and only use it in the executable. Doing so allows others to use what you
-- wrote in their libraries.
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

import GHC.Generics
import qualified Example
import Web.Scotty
import Data.Aeson (FromJSON, ToJSON)
import Database.MySQL.Base
import qualified System.IO.Streams as Streams


main :: IO ()
main = do
    conn <- connect
        defaultConnectInfo {ciUser = "haskell", ciPassword = "ax2", ciDatabase = "work"}
    (defs, is) <- query_ conn "SELECT * FROM EMPLOYEE"
    putStrLn defs
    print =<< Streams.toList is

--    putStrLn "Starting server..."
--    scotty 5555 $ do
--      get "/" $ do
--        text "Hello WORLD!"
--      get "/employees" $ do
--             conn <- connect
--              defaultConnectInfo {ciUser = "dev", ciPassword = "ax2", ciDatabase = "work"}
--               (defs, is) <- query_ conn "SELECT * FROM EMPLOYEE"
--                  json is
--      get "/employees/:id" $ do
--        id <- param "id"
--        json (filter (matchesId id) allEmployees)
--      post "/employees" $ do
--        employee <- jsonData :: ActionM Employee
--        json employee
--


data Employee = Employee { emp_id :: Int, name :: String, email :: String, phone :: Int } deriving (Show, Generic)

bob :: Employee
bob = Employee { emp_id = 1, name = "Bob Hansen", email = "Bob@mail.dk", phone = 12345678 }

john :: Employee
john = Employee { emp_id = 2, name = "John Madsen", email = "John@mail.dk", phone = 12312412 }

eva :: Employee
eva = Employee { emp_id = 3, name = "Eva Pedersen", email = "Eva@mail.dk", phone = 21214663 }


allEmployees :: [Employee]
allEmployees = [bob, john, eva]

instance ToJSON Employee
instance FromJSON Employee

matchesId :: Int -> Employee -> Bool
matchesId empId emp = emp_id emp == empId
