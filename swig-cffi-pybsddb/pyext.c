#include <Python.h>
#include <string.h>
#include <stdlib.h>

#define SAFEDEL(op) {if (op) Py_XDECREF(op); }

typedef struct __bsddb
{
	PyObject* db;
	int open;
} bsddb;


static PyObject* module = NULL;
static int isPythonOpen = 0;
// static bsddb* db = NULL;


int py_init(void) 
{
	if (!isPythonOpen) {
		Py_Initialize();
		isPythonOpen = 1;
		return 1;
	}
	else { /* already open */
		return 0;
	}
}

int py_close(void)
{
	if (isPythonOpen) {
		Py_Finalize();
		isPythonOpen = 0;
		return 1;
	}
	else { /* already closed */
		return 0;
	}
}

int py_runstr(const char *command)
{
	if (isPythonOpen)
		return PyRun_SimpleString(command);
	else
		return -1;
}

PyObject* py_none(void)
{
	if (isPythonOpen) {
		Py_INCREF(Py_None);
		return Py_None;
	}
	else {
		return NULL;
	}
}

void* null_pointer(void)
{
	return NULL;
}

PyObject* bdb_module(void)
{
    PyObject* pName;
	
	if (!isPythonOpen) return NULL;

	if (!module) {
		pName = PyString_FromString("bsddb3");
		module = PyImport_Import(pName);
		Py_DECREF(pName);
	}

	if (!module) return NULL;

	return module;
}


bsddb* db_open(const char* fname, const char* flags)
{
	PyObject *fn, *fg, *func, *args;
	bsddb* db = NULL;

	if ((!isPythonOpen) || (!module)) return NULL;

	db = (bsddb*) malloc (sizeof(bsddb));
	
	func = PyObject_GetAttrString(module, "hashopen");

	args = PyTuple_New(2);
	fn = PyString_FromString(fname);
	fg = PyString_FromString(flags);

	PyTuple_SetItem(args, 0, fn);
	PyTuple_SetItem(args, 1, fg);

	db->db = PyObject_CallObject(func, args);
	Py_DECREF(args);
	Py_DECREF(func);

	if (!db->db) {
		PyErr_Clear(); // printf("ERROR!\n");
		return NULL;
	}
	
	db->open = 1;
	return db;
}


bsddb* db_close(bsddb* db)
{
	PyObject *result, *func, *args;
	
	if ((!isPythonOpen) || (!db)) return NULL;

	func = PyObject_GetAttrString(db->db, "close");
	args = PyTuple_New(0);
	result = PyObject_CallObject(func, args);
	Py_DECREF(args);
	Py_DECREF(func);
	Py_DECREF(result);
	
	db->open = 0;
	Py_DECREF(db->db);
	free(db);
	db = NULL;
	return db;
}


int db_size(bsddb* db)
{
	if ((!isPythonOpen) || (!module) || (!db)) return -1;
	
	return (int) PyMapping_Length(db->db);

/*
	if (length == -1) {
		db_ = PyObject_GetAttrString(module, "db");
		dberror = PyObject_GetAttrString(db_, "DBError");
		if (!PyErr_ExceptionMatches(dberror))
            goto error;
		PyErr_Clear();
	}
error:
	Py_XDECREF(db_);
	Py_XDECREF(dberror);
	return length;
*/
}


int db_store(bsddb* db, char* key, char* value)
{
	int result;
	PyObject* v;
	
	if ((!isPythonOpen) || (!module) || (!db)) return -1;
	
	v = PyString_FromString(value);

	result = PyMapping_SetItemString(db->db, key, v);
	Py_DECREF(v);
		
	return result;
}


void db_sync(bsddb* db)
{
	PyObject *result, *func, *args;

	if ((!isPythonOpen) || (!module) || (!db)) return;

	func = PyObject_GetAttrString(db->db, "sync");
	args = PyTuple_New(0);
	result = PyObject_CallObject(func, args);
	Py_DECREF(args);
	Py_DECREF(func);
	Py_DECREF(result);
}

void db_clear(bsddb* db)
{
	PyObject *result, *func, *args;

	if ((!isPythonOpen) || (!module) || (!db)) return;

	func = PyObject_GetAttrString(db->db, "clear");
	args = PyTuple_New(0);
	result = PyObject_CallObject(func, args);
	Py_DECREF(args);
	Py_DECREF(func);
	Py_DECREF(result);
}

PyObject* db_first_item(bsddb* db)
{
	PyObject *item, *func, *args;

	if ((!isPythonOpen) || (!module) || (!db)) return NULL;
	
	func = PyObject_GetAttrString(db->db, "first");
	args = PyTuple_New(0);
	item = PyObject_CallObject(func, args);
	Py_DECREF(args);
	Py_DECREF(func);

	return item;
}


PyObject* db_last_item(bsddb* db)
{
	PyObject *item, *func, *args;

	if ((!isPythonOpen) || (!module) || (!db)) return NULL;
	
	func = PyObject_GetAttrString(db->db, "last");
	args = PyTuple_New(0);
	item = PyObject_CallObject(func, args);
	Py_DECREF(args);
	Py_DECREF(func);

	return item;
}

char* tuple_key(PyObject* item)
{
	if ((!isPythonOpen) || (!module) || (!item)) return NULL;

	return PyString_AsString(PySequence_GetItem(item, 0));
}

char* tuple_value(PyObject* item)
{
	if ((!isPythonOpen) || (!module) || (!item)) return NULL;

	return PyString_AsString(PySequence_GetItem(item, 1));
}



PyObject* db_next_item(bsddb* db)
{
	PyObject *item, *func, *args;

	if ((!isPythonOpen) || (!module) || (!db)) return NULL;
	
	func = PyObject_GetAttrString(db->db, "next");
	args = PyTuple_New(0);
	item = PyObject_CallObject(func, args);
	if (!item) { 
		PyErr_Clear();
		Py_XDECREF(item);
	}
	Py_DECREF(args);
	Py_DECREF(func);

	return item;
}


PyObject* db_prev_item(bsddb* db)
{
	PyObject *item, *func, *args;

	if ((!isPythonOpen) || (!module) || (!db)) return NULL;
	
	func = PyObject_GetAttrString(db->db, "previous");
	args = PyTuple_New(0);
	item = PyObject_CallObject(func, args);
	if (!item) { 
		PyErr_Clear();
		Py_XDECREF(item);
	}
	Py_DECREF(args);
	Py_DECREF(func);

	return item;
}

char* db_get(bsddb* db, char* key)
{
	PyObject* value;

	if ((!isPythonOpen) || (!module) || (!db)) return NULL;
	
	value = PyMapping_GetItemString(db->db, key);
	if (!value) {
		PyErr_Clear();
		return NULL;
	}
	else
		return PyString_AsString(value);
}

int has_key(bsddb* db, char* key)
{
	if ((!isPythonOpen) || (!module) || (!db)) return 0;

	return PyMapping_HasKeyString(db->db, key);
}

int db_del(bsddb* db, char* key)
{
	int result;
	if ((!isPythonOpen) || (!module) || (!db)) return -1;

	result = PyMapping_DelItemString(db->db, key);
	if (result == -1)
		PyErr_Clear();

	return result;
}

PyObject* db_iterkeys(bsddb* db)
{
	PyObject *keys, *func, *args;

	if ((!isPythonOpen) || (!module) || (!db)) return NULL;
	
	func = PyObject_GetAttrString(db->db, "iterkeys");
	args = PyTuple_New(0);
	keys = PyObject_CallObject(func, args);
	if (!keys) { 
		PyErr_Clear();
		Py_XDECREF(keys);
	}
	Py_DECREF(args);
	Py_DECREF(func);

	return keys;
}

PyObject* db_itervalues(bsddb* db)
{
	PyObject *values, *func, *args;

	if ((!isPythonOpen) || (!module) || (!db)) return NULL;
	
	func = PyObject_GetAttrString(db->db, "itervalues");
	args = PyTuple_New(0);
	values = PyObject_CallObject(func, args);
	if (!values) { 
		PyErr_Clear();
		Py_XDECREF(values);
	}
	Py_DECREF(args);
	Py_DECREF(func);

	return values;
}


PyObject* db_iteritems(bsddb* db)
{
	PyObject *items, *func, *args;

	if ((!isPythonOpen) || (!module) || (!db)) return NULL;
	
	func = PyObject_GetAttrString(db->db, "iteritems");
	args = PyTuple_New(0);
	items = PyObject_CallObject(func, args);
	if (!items) { 
		PyErr_Clear();
		Py_XDECREF(items);
	}
	Py_DECREF(args);
	Py_DECREF(func);

	return items;
}

char* iter_next(PyObject* iterator)
{
	PyObject *next;
	char* nextstr;

	next = PyIter_Next(iterator);
	if (!next)
		return NULL;
	else {
		nextstr = PyString_AsString(next);
		Py_DECREF(next);
		return nextstr;
	}
}

/*

char* firstkey(PyObject* dbm)
{
	PyObject *key, *func, *args;
	
	func = PyObject_GetAttrString(dbm, "firstkey");
	args = PyTuple_New(0);
	key = PyObject_CallObject(func, args);
	Py_DECREF(args);
	Py_DECREF(func);

	return PyString_AsString(key);

}



char* nextkey(PyObject* dbm, char* key)
{
	PyObject *nkey, *keystring, *func, *args;
	
	func = PyObject_GetAttrString(dbm, "nextkey");
	args = PyTuple_New(1);
	keystring = PyString_FromString(key);
	PyTuple_SetItem(args, 0, keystring);
	Py_DECREF(keystring);

	nkey = PyObject_CallObject(func, args);
	Py_DECREF(args);
	Py_DECREF(func);

	return PyString_AsString(nkey);
}





char* getv(PyObject* dbm, char* key)
{
	PyObject* value;
	
	value = PyMapping_GetItemString(dbm, key);
	if (!value)
		return NULL;
	else
		return PyString_AsString(value);
}

int has_key(PyObject* dbm, char* key)
{
	return PyMapping_HasKeyString(dbm, key);
}

int delv(PyObject* dbm, char* key)
{
	return PyMapping_DelItemString(dbm, key);
}


PyObject* keys(PyObject* dbm)
{
	PyObject *keylist, *iterator;
	keylist = PyMapping_Keys(dbm);
	iterator = PyObject_GetIter(keylist);
	Py_DECREF(keylist);

	return iterator;
}


char* iternext(PyObject* iterator)
{
	return PyString_AsString(PyIter_Next(iterator));
}




PyObject* hashlib(void)
{
	PyObject* module;
    PyObject* pName = PyString_FromString("hashlib");

    module = PyImport_Import(pName);
    Py_DECREF(pName);

	return module;
}


PyObject* make_digest(PyObject* module, const char* modename)
{
	PyObject *func, *args, *mode, *digester;

	func = PyObject_GetAttrString(module, "new");
	args = PyTuple_New(1);
	mode = PyString_FromString(modename);
	PyTuple_SetItem(args, 0, mode);

	digester = PyObject_CallObject(func, args);
	Py_DECREF(args);
	Py_DECREF(func);

	if (!digester) {
		PyErr_Clear();
		Py_INCREF(Py_None);
		return Py_None;
	}

	return digester;
}


char* hex_digest(PyObject* digester)
{
	PyObject *digest, *func, *args;
	
	func = PyObject_GetAttrString(digester, "hexdigest");
	args = PyTuple_New(0);
	digest = PyObject_CallObject(func, args);
	Py_DECREF(args);
	Py_DECREF(func);

	return PyString_AsString(digest);
}


void update(PyObject* digester, const char* data)
{
	PyObject *result, *func, *args, *buffer;
	
	func = PyObject_GetAttrString(digester, "update");
	args = PyTuple_New(1);

	buffer = PyString_FromString(data);
	PyTuple_SetItem(args, 0, buffer);

	result = PyObject_CallObject(func, args);
	Py_DECREF(args);
	Py_DECREF(func);
	Py_DECREF(result);
}
*/

