
import semidbm

'''
from libc.stddef cimport wchar_t

cdef extern from "Python.h":
    void Py_Initialize()
    int Py_FinalizeEx()
    int PyRun_SimpleString(const char *command)
    wchar_t* PyUnicode_AsWideCharString(object, Py_ssize_t *) except NULL
    void PyMem_Free(void *p)

cdef extern from "wchar.h":
    int wprintf(const wchar_t *, ...)

cdef public void _c_py_init():
    Py_Initialize()

cdef public int _c_py_exit():
    return Py_FinalizeEx()

cdef public int _c_py_run_simple_string(const char* command):
    return PyRun_SimpleString(command);

cdef public void _c_py_mem_free(void* p):
    PyMem_Free(p)
'''

cdef public semidbm_open(const char* filename, const char* flag, int mode, int verify_checksums):
    return semidbm.open(filename.decode('utf-8'), flag.decode('utf-8'), mode, int(verify_checksums))

cdef public int semidbm_close(dbm):
    try:
        close_method = dbm.__getattribute__('close')
        close_method()
        print("dbm closed.")
        return 0
    except AttributeError:
        print("[SEMIDBM] ERROR: This object or instance doesn't have the 'close' method.")
        return -1

cdef public size_t semidbm_count(dbm):
    try:
        keys_method = dbm.__getattribute__('keys')
        item_count = len(keys_method())
        return item_count           
    except AttributeError:
        print("[SEMIDBM] ERROR: This object or instance doesn't have the 'keys' method.")
        return 0

cdef public char* semidbm_keys(dbm):
    try:
        keys_method = dbm.__getattribute__('keys')
        dbm_keys = keys_method()    # binary(char*) dict
        #print(dbm_keys)
        str_keys = [key.decode('utf-8') for key in dbm_keys]    # string dict
        #print(json.dumps(str_keys))
        return str([i.decode() for i in dbm_keys]).encode('utf-8')  # binary(char*)
    except AttributeError:
        print("[SEMIDBM] ERROR: This object or instance doesn't have the 'keys' method.")
        return NULL


cdef public char* semidbm_values(dbm):
    try:
        values_method = dbm.__getattribute__('values')
        dbm_values = values_method()    # binary(char*) list
        #print(dbm_values)
        str_values = [value.decode('utf-8') for value in dbm_values]    # string list
        #print(json.dumps(str_keys))
        return str([i.decode('utf-8') for i in dbm_values]).encode('utf-8')  # binary(char*)
    except AttributeError:
        print("[SEMIDBM] ERROR: This object or instance doesn't have the 'values' method.")
        return NULL

cdef public int semidbm_sync(dbm):
    try:
        dbm.sync()
        return 0
    except semidbm.exceptions.DBMError:
        print("[SEMIDBM] ERROR: Cannot sync.")
        return -1

cdef public int semidbm_compact(dbm):
    try:
        dbm.compact()
        return 0
    except semidbm.exceptions.DBMError:
        print("[SEMIDBM] ERROR: Cannot compact.")
        return -1

cdef public char* semidbm_get(dbm, const char* key):
    try:
        get_method = dbm.__getattribute__('__getitem__')
        #print (dbm.__getitem__(key))
        return dbm.__getitem__(key)
    except AttributeError:
        print("[SEMIDBM] ERROR: This object or instance doesn't have the '__getitem__' method.")
        return NULL
    except KeyError: # not found!
        return NULL

cdef public int semidbm_store(dbm, const char* key, const char* value):
    try:
        get_method = dbm.__getattribute__('__setitem__')
        dbm.__setitem__(key, value)
        return 0
    except AttributeError:
        print("[SEMIDBM] ERROR: This object or instance doesn't have the '__setitem__' method.")
        return -1
    except semidbm.exceptions.DBMError:
        print("[SEMIDBM] ERROR: Cannot store key and value.")
        return -2

cdef public semidbm_iterkeys(dbm):
    return dbm.__iter__()

cdef public char* semidbm_next_key(itkey):
    try:
        return itkey.__next__()
    except StopIteration:
        return NULL

'''
cdef public char* dogma():
    return '가나다'.encode('utf-8')

cdef public wchar_t* monpetit():
    my_string = "가나다 도그마 Foobar\n"
    cdef Py_ssize_t length
    cdef wchar_t *my_wchars = PyUnicode_AsWideCharString(my_string, &length)
    return my_wchars

'''

