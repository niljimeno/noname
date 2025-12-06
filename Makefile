run:
	LD_LIBRARY_PATH=/usr/local/lib:$$LD_LIBRARY_PATH \
	guile src/main.scm

test-db:
	LD_LIBRARY_PATH=/usr/local/lib:$$LD_LIBRARY_PATH \
	GUILE_LOAD_PATH=/usr/local/share/guile/site/3.0:$$GUILE_LOAD_PATH \
	guile src/repository/db.scm
