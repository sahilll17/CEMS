package com.cems.dao;

import com.cems.model.Event;
import com.cems.model.EventStatus;
import com.cems.model.Venue;
import com.cems.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class VenueDao {

    private static final Logger LOGGER = Logger.getLogger(VenueDao.class.getName());

    public boolean save(Venue venue) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            session.persist(venue);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error saving venue: " + venue.getName(), e);
            return false;
        }
    }

    public boolean update(Venue venue) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            session.merge(venue);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error updating venue: " + venue.getId(), e);
            return false;
        }
    }

    public boolean delete(Long id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            Venue venue = session.get(Venue.class, id);
            if (venue != null) {
                venue.setActive(false);
                session.merge(venue);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error deleting/deactivating venue: " + id, e);
            return false;
        }
    }

    public Venue findById(Long id) {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return null;
            return session.get(Venue.class, id);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding venue by id: " + id, e);
            return null;
        }
    }

    public List<Venue> getAllVenues() {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return Collections.emptyList();
            return session.createQuery("FROM Venue ORDER BY name ASC", Venue.class).list();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching all venues", e);
            return Collections.emptyList();
        }
    }

    public List<Venue> getActiveVenues() {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return Collections.emptyList();
            return session.createQuery("FROM Venue WHERE active = true ORDER BY name ASC", Venue.class).list();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching active venues", e);
            return Collections.emptyList();
        }
    }

    public long countVenues() {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return 0;
            Long count = session.createQuery("SELECT COUNT(v) FROM Venue v WHERE v.active = true", Long.class).uniqueResult();
            return count != null ? count : 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error counting venues", e);
            return 0;
        }
    }

    public Event findConflictingEvent(Long venueId, LocalDate date, LocalTime startTime, LocalTime endTime, Long excludeEventId) {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return null;
            StringBuilder hql = new StringBuilder(
                "FROM Event e WHERE e.venue.id = :venueId " +
                "AND e.eventDate = :date " +
                "AND e.status NOT IN (:rejected, :cancelled) " +
                "AND e.startTime < :endTime " +
                "AND e.endTime > :startTime "
            );
            if (excludeEventId != null) {
                hql.append("AND e.id != :excludeEventId ");
            }

            Query<Event> query = session.createQuery(hql.toString(), Event.class);
            query.setParameter("venueId", venueId);
            query.setParameter("date", date);
            query.setParameter("rejected", EventStatus.REJECTED);
            query.setParameter("cancelled", EventStatus.CANCELLED);
            query.setParameter("startTime", startTime);
            query.setParameter("endTime", endTime);
            if (excludeEventId != null) {
                query.setParameter("excludeEventId", excludeEventId);
            }

            List<Event> conflicts = query.list();
            return conflicts.isEmpty() ? null : conflicts.get(0);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking venue double-booking conflict", e);
            return null;
        }
    }
}
