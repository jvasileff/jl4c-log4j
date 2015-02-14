import ceylon.collection {
    MutableMap
}

shared
interface Mdc satisfies MutableMap<String, String> {}

shared variable
Mdc mdc = object satisfies Mdc {

    // The default implementation is a noop; actual implementations
    // should use a thread local.

    shared actual
    void clear() {}

    shared actual
    MutableMap<String,String> clone() => this;

    shared actual
    Boolean defines(Object key) => false;

    shared actual
    String? get(Object key) => null;

    shared actual
    Iterator<String->String> iterator() => emptyIterator;

    shared actual
    String? put(String key, String item) => null;

    shared actual
    String? remove(String key) => null;

    shared actual
    Integer hash => (this of Identifiable).hash;

    shared actual
    Boolean equals(Object that) => (this of Identifiable).equals(that);
};
