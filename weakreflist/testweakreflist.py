import weakreflist

class Foo(object):
    pass

class Bar(object):
    pass

f = Foo()
p = Bar()
w = weakreflist.WeakList()
w.append(f)
w.append(p)

print w
