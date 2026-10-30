package com.cems.web;

import com.cems.util.DatabaseInitializer;
import com.cems.util.HibernateUtil;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.logging.Level;
import java.util.logging.Logger;

@WebListener
public class AppContextListener implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(AppContextListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("CEMS Web Application starting up...");
        // Run database initialization in background thread to avoid blocking server boot
        Thread initThread = new Thread(() -> {
            try {
                DatabaseInitializer.initialize();
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Database initialization deferred (will initialize on first DB access): " + e.getMessage());
            }
        });
        initThread.setDaemon(true);
        initThread.start();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("CEMS Web Application shutting down...");
        HibernateUtil.shutdown();
    }
}
