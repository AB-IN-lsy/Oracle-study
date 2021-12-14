delimiter //
CREATE TRIGGER BOOK_NUMBER_INSERT
    AFTER INSERT
    ON COPY
    FOR EACH ROW
BEGIN
    UPDATE BOOK
    SET BOOK.BNUMBER = BOOK.BNUMBER + 1
    WHERE NEW.CSTATE = 0
      AND BOOK.BID = NEW.BID;
END//
delimiter ;

delimiter //
CREATE TRIGGER BOOK_NUMBER_UPDATE
    AFTER UPDATE
    ON COPY
    FOR EACH ROW
BEGIN
    IF (NEW.CSTATE = '0')
    THEN
        UPDATE BOOK
        SET BOOK.BNUMBER = BOOK.BNUMBER + 1
        WHERE BOOK.BID = NEW.BID;
    ELSE
        UPDATE BOOK
        SET BOOK.BNUMBER = BOOK.BNUMBER - 1
        WHERE BOOK.BID = NEW.BID;
    END IF;
END//
delimiter ;


delimiter //
CREATE TRIGGER BOOK_NUMBER_INSERT_RECORD
    AFTER INSERT
    ON RECORD
    FOR EACH ROW
BEGIN
    UPDATE COPY
    SET COPY.CSTATE = 1
    WHERE NEW.CID = COPY.CID
      AND NEW.BID = COPY.BID;
END//
delimiter ;


delimiter //
CREATE TRIGGER BOOK_NUMBER_UPDATE_RECORD
    AFTER UPDATE
    ON RECORD
    FOR EACH ROW
BEGIN
    IF (NEW.RSTATE = '1')
    THEN
        UPDATE COPY
        SET COPY.CSTATE = 0
        WHERE NEW.CID = COPY.CID
          AND NEW.BID = COPY.BID;
    ELSE
        UPDATE COPY
        SET COPY.CSTATE = 1
        WHERE NEW.CID = COPY.CID
          AND NEW.BID = COPY.BID;
    END IF;
END//
delimiter ;

create table PRESS
(
    PID         int auto_increment,
    PNAME       VARCHAR(20)                                                     not null,
    PADDRESS    VARCHAR(20)                                                     not null,
    PTEL        VARCHAR(20)                                                     not null,
    PCONTACT    VARCHAR(20)                                                     not null,
    CREATE_TIME timestamp default current_timestamp                             not null,
    UPDATE_TIME timestamp default current_timestamp on update current_timestamp not null,
    constraint PRESS_pk
        primary key (PID)
);

create table BOOK
(
    BID         int auto_increment,
    BNAME       varchar(50)                                                     not null,
    BAUTHOR     varchar(50)                                                     not null,
    BCLASS      varchar(20)                                                     not null,
    PID         int                                                             not null REFERENCES PRESS (PID),
    BPRICE      int                                                             not null,
    BNUMBER     int                                                             not null default (0),
    CREATE_TIME timestamp default current_timestamp                             not null,
    UPDATE_TIME timestamp default current_timestamp on update current_timestamp not null,
    constraint book_pk
        primary key (BID)
);

CREATE TABLE COPY
(
    CID         INT                                                             NOT NULL,
    BID         INT                                                             NOT NULL REFERENCES BOOK (BID),
    CSTATE      BOOL      DEFAULT 0                                             NOT NULL,
    CREATE_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP                             NOT NULL,
    UPDATE_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT DUPLICATE_pk PRIMARY KEY (BID, CID)
);

CREATE TABLE DEPT
(
    DEID        INT auto_increment,
    DENAME      VARCHAR(20)                                                     NOT NULL,
    DETEL       VARCHAR(20)                                                     NOT NULL,
    CREATE_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP                             NOT NULL,
    UPDATE_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT DEPT_pk PRIMARY KEY (DEID)
);

CREATE TABLE STAFF
(
    SID         INT auto_increment,
    DEID        INT                                                             NOT NULL REFERENCES DEPT (DEID),
    SNAME       VARCHAR(20)                                                     NOT NULL,
    SSEX        VARCHAR(20)                                                     NOT NULL,
    SBIRTH      VARCHAR(20)                                                     NOT NULL,
    CREATE_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP                             NOT NULL,
    UPDATE_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT STAFF_pk PRIMARY KEY (SID)
);

CREATE TABLE RECORD
(
    SID                 INT                                                             NOT NULL REFERENCES STAFF (SID),
    BID                 INT                                                             NOT NULL REFERENCES COPY (BID),
    CID                 INT                                                             NOT NULL REFERENCES COPY (CID),
    RSTATE              BOOL      DEFAULT 0                                             NOT NULL,
    RDATE_BORROW        TIMESTAMP                                                       NOT NULL,
    RDATE_SHOULD_RETURN TIMESTAMP                                                       NOT NULL,
    CREATE_TIME         TIMESTAMP DEFAULT CURRENT_TIMESTAMP                             NOT NULL,
    UPDATE_TIME         TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT RECORD_pk PRIMARY KEY (SID, BID, CID, RDATE_BORROW)
);



INSERT INTO PRESS(PNAME, PADDRESS, PTEL, PCONTACT)
VALUES ('SUN', 'BEIJING', '15954306653', 'ZHANG TIAN JIAO');
INSERT INTO PRESS(PNAME, PADDRESS, PTEL, PCONTACT)
VALUES ('MOON', 'BEIJING', '12345678900', 'WANG BO');
INSERT INTO PRESS(PNAME, PADDRESS, PTEL, PCONTACT)
VALUES ('CAT', 'HARBIN', '11111111111', 'LUO HUI');

INSERT INTO BOOK(BNAME, BAUTHOR, BCLASS, PID, BPRICE)
VALUES ('The old man and the sea', 'Hemingway', 'Long story', '1', '20');
INSERT INTO BOOK(BNAME, BAUTHOR, BCLASS, PID, BPRICE)
VALUES ('Gone with the wind', 'Mitchell', 'Long story', '3', '15');
INSERT INTO BOOK(BNAME, BAUTHOR, BCLASS, PID, BPRICE)
VALUES ('The Lady of the Camellias', 'Dumas Jr', 'Short story', '2', '16');
INSERT INTO BOOK(BNAME, BAUTHOR, BCLASS, PID, BPRICE)
VALUES ('The three Musketeers', 'Dumas', 'Long story', '1', '15');


INSERT INTO COPY(CID, BID, CSTATE)
VALUES ('1', '1', '0');
INSERT INTO COPY(CID, BID, CSTATE)
VALUES ('2', '1', '0');
INSERT INTO COPY(CID, BID, CSTATE)
VALUES ('3', '1', '0');
INSERT INTO COPY(CID, BID, CSTATE)
VALUES ('1', '2', '0');
INSERT INTO COPY(CID, BID, CSTATE)
VALUES ('2', '2', '0');
INSERT INTO COPY(CID, BID, CSTATE)
VALUES ('3', '2', '0');
INSERT INTO COPY(CID, BID, CSTATE)
VALUES ('1', '3', '0');
INSERT INTO COPY(CID, BID, CSTATE)
VALUES ('2', '3', '0');
INSERT INTO COPY(CID, BID, CSTATE)
VALUES ('3', '3', '0');


INSERT INTO DEPT(DENAME, DETEL)
VALUES ('JingDong', '15305438198');
INSERT INTO DEPT(DENAME, DETEL)
VALUES ('TaoBao', '15305438998');
INSERT INTO DEPT(DENAME, DETEL)
VALUES ('Alibaba', '15305438698');

INSERT INTO STAFF(DEID, SNAME, SSEX, SBIRTH)
VALUES ('1', 'Liu Siyuan', 'Male', '2001/8/31');
INSERT INTO STAFF(DEID, SNAME, SSEX, SBIRTH)
VALUES ('2', 'AB-IN', 'Male', '2001/8/31');
INSERT INTO STAFF(DEID, SNAME, SSEX, SBIRTH)
VALUES ('3', 'Liu Boya', 'Female', '2001/5/12');
INSERT INTO STAFF(DEID, SNAME, SSEX, SBIRTH)
VALUES ('3', 'Crystal', 'Female', '2001/2/18');


INSERT INTO RECORD(SID, BID, CID, RDATE_BORROW, RDATE_SHOULD_RETURN)
VALUES ('1', '1', '1', '2021-12-14 14:00:00', '2021-1-14 14:00:00');
INSERT INTO RECORD(SID, BID, CID, RDATE_BORROW, RDATE_SHOULD_RETURN)
VALUES ('2', '1', '3', '2021-12-13 11:00:00', '2021-1-13 11:00:00');
INSERT INTO RECORD(SID, BID, CID, RDATE_BORROW, RDATE_SHOULD_RETURN)
VALUES ('3', '2', '1', '2021-12-13 17:00:00', '2021-1-13 17:00:00');

UPDATE RECORD
SET RSTATE = 1
WHERE SID = 1
  AND BID = 1
  AND CID = 1
  AND RDATE_BORROW = '2021-12-14 14:00:00';