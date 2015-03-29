import ceylon.interop.java {
    javaClass
}
import ceylon.logging {
    linfo=info,
    ldebug=debug,
    ltrace=trace,
    Priority,
    lerror=error,
    Category,
    lwarn=warn,
    Logger,
    lfatal=fatal
}

import org.apache.log4j {
    Log4jLevel=Level,
    Log4jLogger=Logger
}

shared
class Log4jLoggerWrapper(category, String? wrapperFqcn=null)
        satisfies Logger {

    shared actual
    Category category;

    String loggerFqcn = wrapperFqcn else package.log4jLoggerWrapperFqcn;

    value delegate = Log4jLogger.getLogger(category.qualifiedName);

    shared actual
    void log(
        Priority priority,
        String|String() message,
        Throwable? throwable) {

        value level = levelFrom(priority);
        if (delegate.isEnabledFor(level)) {
            String msg = if (is String() message)
                         then message()
                         else message;

            delegate.log(
                loggerFqcn, levelFrom(priority), msg, throwable);
        }
    }

    shared actual
    Priority priority
        =>  priorityFrom(delegate.level else delegate.rootLogger.level);

    assign priority
        =>  delegate.setPriority(levelFrom(priority));

    Log4jLevel levelFrom(Priority priority)
        =>  switch(priority)
            case(ltrace) Log4jLevel.\iTRACE
            case(ldebug) Log4jLevel.\iDEBUG
            case(linfo)  Log4jLevel.\iINFO
            case(lwarn)  Log4jLevel.\iWARN
            case(lerror) Log4jLevel.\iERROR
            case(lfatal) Log4jLevel.\iFATAL;

    Priority priorityFrom(Log4jLevel? level)
        =>  if (!exists level)                    then ltrace // null => trace
            else if (level == Log4jLevel.\iALL)   then ltrace // ALL  => trace
            else if (level == Log4jLevel.\iTRACE) then ltrace
            else if (level == Log4jLevel.\iDEBUG) then ldebug
            else if (level == Log4jLevel.\iINFO)  then linfo
            else if (level == Log4jLevel.\iWARN)  then lwarn
            else if (level == Log4jLevel.\iERROR) then lerror
            else if (level == Log4jLevel.\iFATAL) then lfatal
            else if (level == Log4jLevel.\iOFF)   then lfatal // OFF  => fatal
            else ltrace; // default trace
}

String log4jLoggerWrapperFqcn = javaClass<Log4jLoggerWrapper>().name;
