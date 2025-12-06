(use-modules (dbi dbi))


(define db-obj (dbi-open "sqlite3" "db"))

;; Create a table.
(dbi-query db-obj "create table hellotable(id int, name varchar(15))")

;; Look at the return status of the last SQL command
(display db-obj) (newline)

;; Populate the table with values.
(dbi-query db-obj "insert into hellotable ('id', 'name') values('33', 'ola')")
(dbi-query db-obj "insert into hellotable ('id', 'name') values('34', 'dzien dobre')")
(dbi-query db-obj "insert into hellotable ('id', 'name') values('44', 'annyong haseyo')")
(display db-obj) (newline)

;; Display each of the rows of the table, in turn.
(dbi-query db-obj "select * from hellotable")
(display db-obj) (newline)
(write (dbi-get_row db-obj)) (newline)
(write (dbi-get_row db-obj)) (newline)
(write (dbi-get_row db-obj)) (newline)
(write (dbi-get_row db-obj)) (newline)

;; Close the database.
(dbi-close db-obj)
(display db-obj) (newline)
(display "hello hello") (newline)
