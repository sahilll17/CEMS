package com.cems.util;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.boot.Metadata;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;

import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class HibernateUtil {

    private static final Logger LOGGER = Logger.getLogger(HibernateUtil.class.getName());
    private static StandardServiceRegistry registry;
    private static SessionFactory sessionFactory;
    private static String lastErrorMessage = null;

    public static String getLastErrorMessage() {
        return lastErrorMessage;
    }

    public static synchronized SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            try {
                StandardServiceRegistryBuilder registryBuilder = new StandardServiceRegistryBuilder();
                registryBuilder.configure("hibernate.cfg.xml");

                // Load custom overrides from db.properties if present
                try (InputStream input = HibernateUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
                    if (input != null) {
                        Properties props = new Properties();
                        props.load(input);

                        if (props.containsKey("db.url")) {
                            registryBuilder.applySetting("hibernate.connection.url", props.getProperty("db.url"));
                        }
                        if (props.containsKey("db.username")) {
                            registryBuilder.applySetting("hibernate.connection.username", props.getProperty("db.username"));
                        }
                        if (props.containsKey("db.password")) {
                            registryBuilder.applySetting("hibernate.connection.password", props.getProperty("db.password"));
                        }
                        if (props.containsKey("db.driver")) {
                            registryBuilder.applySetting("hibernate.connection.driver_class", props.getProperty("db.driver"));
                        }
                    }
                } catch (Exception ex) {
                    LOGGER.log(Level.WARNING, "Could not load db.properties, using hibernate.cfg.xml defaults", ex);
                }

                // Check Environment Variables or System Properties if set
                String envDbUrl = System.getenv("CEMS_DB_URL");
                String envDbUser = System.getenv("CEMS_DB_USER");
                String envDbPass = System.getenv("CEMS_DB_PASS");
                if (envDbUrl != null && !envDbUrl.isBlank()) registryBuilder.applySetting("hibernate.connection.url", envDbUrl);
                if (envDbUser != null && !envDbUser.isBlank()) registryBuilder.applySetting("hibernate.connection.username", envDbUser);
                if (envDbPass != null) registryBuilder.applySetting("hibernate.connection.password", envDbPass);

                registry = registryBuilder.build();
                MetadataSources sources = new MetadataSources(registry);
                Metadata metadata = sources.getMetadataBuilder().build();
                sessionFactory = metadata.getSessionFactoryBuilder().build();
                lastErrorMessage = null;

                LOGGER.info("Hibernate SessionFactory initialized successfully.");
            } catch (Throwable t) {
                lastErrorMessage = t.getMessage();
                LOGGER.log(Level.SEVERE, "Initial SessionFactory creation failed: " + t.getMessage(), t);
                if (registry != null) {
                    try {
                        StandardServiceRegistryBuilder.destroy(registry);
                    } catch (Exception ignored) {}
                    registry = null;
                }
                sessionFactory = null;
                return null;
            }
        }
        return sessionFactory;
    }

    public static Session openSession() {
        SessionFactory sf = getSessionFactory();
        if (sf == null) {
            return null;
        }
        try {
            return sf.openSession();
        } catch (Throwable t) {
            lastErrorMessage = t.getMessage();
            LOGGER.log(Level.SEVERE, "Failed to open Hibernate session: " + t.getMessage(), t);
            return null;
        }
    }

    public static synchronized void shutdown() {
        if (sessionFactory != null && !sessionFactory.isClosed()) {
            sessionFactory.close();
        }
        if (registry != null) {
            StandardServiceRegistryBuilder.destroy(registry);
        }
        LOGGER.info("Hibernate SessionFactory closed.");
    }
}
