package model;


import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.service.ServiceRegistry;

import java.io.FileReader;
import java.io.IOException;
import java.util.Properties;

public class HibernateConfiguration {
    public static SessionFactory sessionFactory;

    private static void init() {
        Properties properties = new Properties();

        ServiceRegistry serviceRegistry;
        try {
            properties.load(new FileReader("3.2/app/src/main/resources/application.properties"));
            System.out.println(properties);
            serviceRegistry = new StandardServiceRegistryBuilder().applySettings(properties).build();
        } catch (IOException e) {
            throw new RuntimeException("application properties file not found!");
        }
        sessionFactory = new Configuration()
                .setProperties(properties)
                .addAnnotatedClass(Actor.class)
                .buildSessionFactory(serviceRegistry);
    }

    public HibernateConfiguration() {
    }

    public static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            init();
        }
        return sessionFactory;
    }
}
