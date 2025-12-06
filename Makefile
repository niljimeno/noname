run:
	LD_LIBRARY_PATH=/usr/local/lib:$$LD_LIBRARY_PATH \
	guile main.scm

test-db:
	LD_LIBRARY_PATH=/usr/local/lib:$$LD_LIBRARY_PATH \
	guile db.scm
