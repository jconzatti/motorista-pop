CREATE TABLE account (
    account_id        TEXT    PRIMARY KEY
                              NOT NULL,
    name              TEXT,
    email             TEXT,
    cpf               TEXT,
    car_plate         TEXT,
    is_passenger      INTEGER,
    is_driver         INTEGER,
    date              REAL,
    is_verified       INTEGER,
    verification_code TEXT,
    password          TEXT,
    algorithm         TEXT
);

CREATE TABLE ride (
    ride_id      TEXT PRIMARY KEY
                      NOT NULL,
    passenger_id TEXT,
    driver_id    TEXT,
    status       TEXT,
    fare         REAL,
    distance     REAL,
    from_lat     REAL,
    from_long    REAL,
    to_lat       REAL,
    to_long      REAL,
    date         REAL
);

CREATE TABLE position (
    position_id TEXT PRIMARY KEY,
    ride_id     TEXT,
    lat         REAL,
    long        REAL,
    date        REAL
);