import ceylon.logging {
    levelInfo=info,
    levelDebug=debug,
    levelTrace=trace,
    Priority,
    levelError=error,
    Category,
    levelWarn=warn,
    Logger,
    levelFatal=fatal,
    logger
}

shared
class FormattingLogger(Logger delegate) {

    Integer precedingSlashes(String s, Integer index) {
        variable value count = 0;
        for (character in s[index-1..-1]) {
            if (character == '\\') {
                count++;
            }
            else {
                break;
            }
        }
        return count;
    }

    String render(String format, Anything* args) {
        if (args.empty) {
            return format;
        }
        value result = StringBuilder();
        value indexes = format.inclusions("{}").iterator();
        variable value prev = -1;
        for (arg in args) {
            while (!is Finished index = indexes.next()) {
                value slashes = precedingSlashes(format, index);
                if (slashes.even) {
                    // placeholder is not escaped; drop half of the slashes
                    result.append(format[prev..index-1-(slashes/2)]);
                    result.append(arg?.string else "<null>"); // try/catch
                    prev = index + 2;
                    break;
                }
                else {
                    // drop the final slash, and half of the others
                    result.append(format[prev..index-2-(slashes/2)]);
                    // don't consume the {}; append to result next time
                    prev = index;
                }
            }
        }
        result.append(format.spanFrom(prev));
        return result.string;
    }

    shared
    Category category => delegate.category;

    shared
    void log(Priority priority, String format, Anything* args) {
        if (enabled(priority)) {
            if (nonempty args) {
                if (is Throwable throwable = args.last) {
                    if (args.size == 1) {
                        delegate.log(priority, format, throwable);
                    }
                    else {
                        delegate.log(priority,
                            render(format, *args[0:args.size-1]), throwable);
                    }
                }
                else {
                    delegate.log(priority, render(format, *args));
                }
            }
            else {
                delegate.log(priority, format);
            }
        }
    }

    shared
    Priority priority => delegate.priority;

    assign priority => delegate.priority = priority;

    shared
    Boolean enabled(Priority priority)
        =>  delegate.enabled(priority);

    shared
    void fatal(String format, Anything* args)
        =>  log(levelFatal, format, *args);

    shared
    void error(String format, Anything* args)
        =>  log(levelError, format, *args);

    shared
    void warn(String format, Anything* args)
        =>  log(levelWarn, format, *args);

    shared
    void info(String format, Anything* args)
        =>  log(levelInfo, format, *args);

    shared
    void debug(String format, Anything* args)
        =>  log(levelDebug, format, *args);

    shared
    void trace(String format, Anything* args)
        =>  log(levelTrace, format, *args);
}

shared
FormattingLogger formattingLogger(Category category)
    =>  FormattingLogger(logger(category));
