
#ifndef __PY_EXT_H__
#define __PY_EXT_H__

#include <Python.h>
#include <string.h>

typedef struct __bsddb
{
	PyObject* db;
	int open;
} bsddb;

void py_init(void);
void py_close(void);
int py_runstr(const char *command);
PyObject* py_none(void);
void* null_pointer(void);

PyObject* bdb_module(void);
bsddb* db_open(const char* fname, const char* flags);
bsddb* db_close(bsddb* db);
int db_size(bsddb* db);
int db_store(bsddb* db, char* key, char* value);
void db_sync(bsddb* db);
void db_clear(bsddb* db);
PyObject* db_first_item(bsddb* db);
PyObject* db_last_item(bsddb* db);
char* tuple_key(PyObject* item);
char* tuple_value(PyObject* item);
PyObject* db_next_item(bsddb* db);
PyObject* db_prev_item(bsddb* db);
char* db_get(bsddb* db, char* key);
int has_key(bsddb* db, char* key);
int db_del(bsddb* db, char* key);
PyObject* db_iterkeys(bsddb* db);
PyObject* db_itervalues(bsddb* db);
PyObject* db_iteritems(bsddb* db);
char* iter_next(PyObject* iterator);

#endif /* __PY_EXT_H__ */

