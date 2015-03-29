import ceylon.language.meta.model {
    ClassOrInterface
}
import ceylon.logging {
    LoggerFactory,
    Logger,
    Category
}
import ceylon.interop.java {
    javaClass
}

shared
object log4jLoggerFactory satisfies LoggerFactory {

    shared actual
    Logger logger<Wrapper>(
            Category category,
            ClassOrInterface<Wrapper>? wrapper)
            given Wrapper satisfies Object
        =>  Log4jLoggerWrapper(category,
                (wrapper exists) then javaClass<Wrapper>().name);
}
