cdef inline object _get_object(object x):
    return PyWeakref_GetObject(x)

cdef inline object _get_ref(object x, object callback):
    return PyWeakref_NewRef(x, callback)


cdef class WeakList(list):

    def __init__(self, l=[]):
        list.__init__(self, (_get_ref(x, self.remove) for x in l))

    def __contains__(self, item):
        return list.__contains__(self, _get_ref(item, self.remove))

    def __getitem__(self, *args):
        return _get_object(list.__getitem__(self, *args))

    def __getslice__(self, *args):
        return [_get_object(x) for x in list.__getslice__(self, *args)] #slow?

    def __iter__(self):
        for x in list.__iter__(self):
            yield _get_object(x)

    def __repr__(self):
        return "WeakList({!r})".format(list(self))

    def __reversed__(self, *args, **kwargs):
        for x in list.__reversed__(self, *args, **kwargs):
            yield _get_object(x)

    def __setitem__(self, i, value):
        list.__setitem__(self, i, _get_ref(value, self.remove))
        
    def __setslice__(self, i, j, values):
        list.__setslice__(self, i, j, (_get_ref(x, self.remove) for x in values))

    def append(self, value):
        list.append(self, _get_ref(value, self.remove))
        
    def count(self, value):
        return list.count(self, _get_ref(value, self.remove))
        
    def extend(self, values):
        list.extend(self, (_get_ref(x, self.remove) for x in values))

    def index(self, value):
        return list.index(self, _get_ref(value, self.remove))

    def insert(self, i, value):
        list.insert(self, i, _get_ref(value, self.remove))

    def remove(self, value):
        while list.__contains__(self, value):
            list.remove(self, _get_ref(value, self.remove))
