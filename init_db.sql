USE miwikipedia;

CREATE TABLE IF NOT EXISTS Users (
  userName VARCHAR(50) PRIMARY KEY,
  password VARCHAR(255),
  firstName VARCHAR(100),
  lastName VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Articles (
  title VARCHAR(200),
  owner VARCHAR(50),
  text TEXT,
  PRIMARY KEY (title, owner),
  FOREIGN KEY (owner) REFERENCES Users(userName) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
