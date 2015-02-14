shared final
class MdcObtainableEntry
        (shared String key,
         shared String item)
        satisfies Obtainable {

    shared actual
    void obtain()
        =>  mdc.put(key, item);

    shared actual
    void release(Throwable? error)
        => mdc.remove(key);
}
