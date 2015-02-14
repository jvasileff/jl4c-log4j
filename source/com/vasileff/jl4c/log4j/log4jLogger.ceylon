import ceylon.logging {
    Category,
    Logger
}

shared
Logger log4jLogger(Category category)
    =>  Log4jLoggerWrapper(category);
