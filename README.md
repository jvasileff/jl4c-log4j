jl4c Log4j
=================================

A Log4j adapter for `ceylon.logging`.

## Status

The implementation is complete. Some non-Log4j specific types including `Mdc`
and `MdcObtainableEntry` may be moved to a separate module in the future.

The source code must be compiled against the latest development version of
Ceylon, so a precompiled module will not be available until after Ceylon's
next release.

## Dependencies

The `aether` repository must be enabled in order to resolve `"log4j:log4j"
"1.2.17"`, which is a shared import of this module. For more information,
see <http://ceylon-lang.org/documentation/1.1/reference/repository/maven/>.

## Usage Example

```ceylon
import ceylon.logging {
    Logger,
    logger
}

import com.vasileff.jl4c.log4j {
    MdcObtainableEntry,
    useLog4jLogging
}

import org.apache.log4j {
    ConsoleAppender,
    PatternLayout,
    Level,
    JLog4jLogger=Logger
}

// initializeLogging() must be called before
// log is first accessed
Logger log = logger(`package`);

shared
void run() {
    initializeLogging();

    log.info("Initialization complete");

    try(MdcObtainableEntry("userId", "5150")) {
        log.info("Processing user request");
    }

    log.info("Goodbye!");
}

shared
void initializeLogging() {
    // include the MDC value "userId"
    value pattern = "%-5p [%t:%X{userId}] (%F:%L) - %m%n";

    // setup Log4j programmatically
    value console = ConsoleAppender();
    console.layout = PatternLayout(pattern);
    console.threshold = Level.\iTRACE;
    console.activateOptions();
    JLog4jLogger.rootLogger.addAppender(console);
    JLog4jLogger.rootLogger.setPriority(Level.\iINFO);

    // use log4j for:
    //      ceylon.logging::logger
    //      com.vasileff.jl4c.log4j::mdc
    useLog4jLogging();
}
```

Produces:

```
INFO  [main:] (run.ceylon:26) - Initialization complete
INFO  [main:5150] (run.ceylon:29) - Processing user request
INFO  [main:] (run.ceylon:32) - Goodbye!
```

## License

The content of this repository is released under the MIT License as provided in
the LICENSE file that accompanied this code.

By submitting a "pull request" or otherwise contributing to this repository,
you agree to license your contribution under the license mentioned above.
