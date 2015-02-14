import ceylon.logging {
    logger
}

shared
void useLog4jLogging() {
    logger = log4jLogger;
    mdc = log4jMdc;
}
