cdef extern from "Python.h":
    object PySlice_New(object start, object stop, object step)
    object PyWeakref_NewRef(object ob, object callback)
    object PyWeakref_GetObject(object ref)
    void Py_INCREF(object o)


cdef class WeakList(list):
    cdef object _callback
