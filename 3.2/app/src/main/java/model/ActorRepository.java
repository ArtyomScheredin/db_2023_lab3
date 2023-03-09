package model;

import org.hibernate.Session;

public class ActorRepository {
    public static void save(Iterable<Actor> iterable) {
        if (iterable == null) {
            throw new IllegalArgumentException("Collection cannot be null");
        }

        try (Session session = HibernateConfiguration.getSessionFactory().openSession()) {
            for (Actor actor : iterable) {
                System.out.println("Save to base: " + actor);
                session.save(actor);
            }
        }
    }
}
