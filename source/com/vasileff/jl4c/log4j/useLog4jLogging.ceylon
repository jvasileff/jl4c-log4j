import ceylon.logging {
    loggerFactory
}

shared
void useLog4jLogging() {
    loggerFactory = log4jLoggerFactory;
    mdc = log4jMdc;
}
