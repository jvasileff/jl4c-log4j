import ceylon.collection {
    MutableMap,
    HashMap
}
import ceylon.interop.java {
    CeylonIterable
}

import java.util {
    JMap=Map
}

import org.apache.log4j {
    Log4jMdc=MDC
}

shared
object log4jMdc satisfies Mdc {

    shared actual
    void clear()
        =>  Log4jMdc.clear();

    shared actual
    MutableMap<String,String> clone()
        =>  HashMap {*this};

    shared actual
    Boolean defines(Object key)
        =>  get(key) exists;

    shared actual
    String? get(Object key)
        //https://github.com/ceylon/ceylon-compiler/issues/2058
        =>  if (is String key,
                exists val = Log4jMdc.get(key),
                is String val)
            then val
            else null;

    shared actual
    Iterator<String->String> iterator()
        //https://github.com/ceylon/ceylon-compiler/issues/2028
        =>  let(JMap<out Object, out Object>? ctx = Log4jMdc.context)
            if (exists set = ctx?.entrySet())
            then { for (entry in CeylonIterable(set))
                    if (is String key = entry.key,
                        is String item = entry.\ivalue)
                    key->item }.iterator()
            else emptyIterator;

    shared actual
    String? put(String key, String item) {
        value oldValue = get(key);
        Log4jMdc.put(key, item);
        return oldValue;
    }

    shared actual
    String? remove(String key) {
        value oldValue = get(key);
        Log4jMdc.remove(key);
        return oldValue;
    }

    shared actual
    Boolean equals(Object that)
        =>  (super of Mdc).equals(that);

    shared actual
    Integer hash
        =>  (super of Mdc).hash;
}
