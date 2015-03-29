import ceylon.logging {
    Category,
    Logger
}
import ceylon.interop.java {
    javaClass
}

shared
Logger log4jLogger(Category category)
    =>  Log4jLoggerWrapper(category);

shared
FormattingLogger log4jFormattingLogger(Category category)
    =>  FormattingLogger(Log4jLoggerWrapper(
            category, javaClass<FormattingLogger>().name));
