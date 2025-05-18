require("mysqloo")
Mana.SQL = Mana.SQL or {}
local creationTable = [[CREATE TABLE IF NOT EXISTS muramana (
  steamid VARCHAR(22) NOT NULL,
  mana INT(16) NULL,
  maxmana INT(16) NULL,
  doublemana INT(1) NULL,
  resets INT(16) NULL,
  rerolls INT(16) NULL,
  magicset VARCHAR(45) NULL,
  double_stamp INT(32) NULL,
  stats TEXT NULL,
  PRIMARY KEY (steamid));
]]

local creds = {
    user = "u9283_B8vThPJRe4",
    pass = "ukmT@IdH2s3aA^FVf2LfN.hB",
    ip = "194.69.160.11",
    db = "s9283_mana_hexa1",
    port = 3306
}

if (Mana.SQL.DB) then
    Mana.SQL.DB:disconnect()
end

Mana.SQL.DB = mysqloo.connect(creds.ip, creds.user, creds.pass, creds.db, creds.port)

function Mana.SQL.DB:onConnected()
    Mana:Log("Connected to our DB server")
    Mana.SQL:Query(creationTable, function(data)
        MsgN(data)
    end)
end

function Mana.SQL.DB:onConnectionFailed(err)
    Mana:Log(err)
end

Mana.SQL.DB:connect()

function Mana.SQL.DB:onConnected()
    Mana:Log("Connected to our DB server")
    print("Connected to our DB server")
    Mana.SQL:Query(creationTable, function(data)
        MsgN(data)
    end)
end

function Mana.SQL.DB:onConnectionFailed(err)
    Mana:Log(err)
end

function Mana.SQL:Query(str, call, fail)
    local query = self.DB:query(str)

    query.onSuccess = function(q, data)
        if (call) then
            call(data)
        end
    end

    query.onError = function(q, err, sql)

        if (fail) then
            fail(err, sql)
        else
            Mana:Log("We got an issue with a query")
            MsgN(err)
            MsgN(sql)
        end
    end
    query:start()
end