package com.cems.dao;

import com.cems.model.Event;
import com.cems.model.EventStatus;
import com.cems.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EventDao {

    private static final Logger LOGGER = Logger.getLogger(EventDao.class.getName());

    public boolean save(Event event) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            session.persist(event);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error saving event: " + event.getTitle(), e);
            return false;
        }
    }

    public boolean update(Event event) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            session.merge(event);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error updating event: " + event.getId(), e);
            return false;
        }
    }

    public boolean delete(Long id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            Event event = session.get(Event.class, id);
            if (event != null) {
                event.setStatus(EventStatus.CANCELLED);
                session.merge(event);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error cancelling event: " + id, e);
            return false;
        }
    }

    public Event findById(Long id) {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return null;
            return session.get(Event.class, id);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding event by id: " + id, e);
            return null;
        }
    }

    public List<Event> getAllEvents() {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return Collections.emptyList();
            return session.createQuery("FROM Event ORDER BY eventDate DESC, startTime ASC", Event.class).list();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching all events", e);
            return Collections.emptyList();
        }
    }

    public List<Event> getUpcomingApprovedEvents() {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return Collections.emptyList();
            Query<Event> query = session.createQuery(
                "FROM Event e WHERE e.status = :status AND e.eventDate >= :today ORDER BY e.eventDate ASC, e.startTime ASC",
                Event.class
            );
            query.setParameter("status", EventStatus.APPROVED);
            query.setParameter("today", LocalDate.now());
            return query.list();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching upcoming events", e);
            return Collections.emptyList();
        }
    }

    public List<Event> getPastApprovedEvents() {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return Collections.emptyList();
            Query<Event> query = session.createQuery(
                "FROM Event e WHERE (e.status = :approved OR e.status = :completed) AND e.eventDate < :today ORDER BY e.eventDate DESC",
                Event.class
            );
            query.setParameter("approved", EventStatus.APPROVED);
            query.setParameter("completed", EventStatus.COMPLETED);
            query.setParameter("today", LocalDate.now());
            return query.list();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching past events", e);
            return Collections.emptyList();
        }
    }

    public List<Event> getPendingProposals() {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return Collections.emptyList();
            Query<Event> query = session.createQuery(
                "FROM Event e WHERE e.status = :status ORDER BY e.createdAt ASC",
                Event.class
            );
            query.setParameter("status", EventStatus.PENDING_APPROVAL);
            return query.list();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching pending proposals", e);
            return Collections.emptyList();
        }
    }

    public List<Event> getEventsByOrganizer(Long organizerId) {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return Collections.emptyList();
            Query<Event> query = session.createQuery(
                "FROM Event e WHERE e.organizer.id = :organizerId ORDER BY e.eventDate DESC",
                Event.class
            );
            query.setParameter("organizerId", organizerId);
            return query.list();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching events by organizer: " + organizerId, e);
            return Collections.emptyList();
        }
    }

    public List<Event> searchAndFilter(String keyword, String category, LocalDate fromDate, LocalDate toDate) {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return Collections.emptyList();
            StringBuilder hql = new StringBuilder("FROM Event e WHERE e.status = :status ");
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append("AND (LOWER(e.title) LIKE :kw OR LOWER(e.description) LIKE :kw OR LOWER(e.venue.name) LIKE :kw) ");
            }
            if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
                hql.append("AND e.category = :category ");
            }
            if (fromDate != null) {
                hql.append("AND e.eventDate >= :fromDate ");
            }
            if (toDate != null) {
                hql.append("AND e.eventDate <= :toDate ");
            }
            hql.append("ORDER BY e.eventDate ASC, e.startTime ASC");

            Query<Event> query = session.createQuery(hql.toString(), Event.class);
            query.setParameter("status", EventStatus.APPROVED);

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            }
            if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
                query.setParameter("category", category.trim().toUpperCase());
            }
            if (fromDate != null) {
                query.setParameter("fromDate", fromDate);
            }
            if (toDate != null) {
                query.setParameter("toDate", toDate);
            }

            return query.list();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error searching events", e);
            return Collections.emptyList();
        }
    }

    public boolean updateStatus(Long eventId, EventStatus newStatus, String rejectionReason) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            Event event = session.get(Event.class, eventId);
            if (event != null) {
                event.setStatus(newStatus);
                if (rejectionReason != null) {
                    event.setRejectionReason(rejectionReason);
                }
                session.merge(event);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error updating event status: " + eventId, e);
            return false;
        }
    }

    public synchronized boolean incrementRegistration(Long eventId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            Event event = session.get(Event.class, eventId);
            if (event != null) {
                if (event.getCurrentRegistrations() >= event.getMaxCapacity()) {
                    tx.rollback();
                    return false;
                }
                event.setCurrentRegistrations(event.getCurrentRegistrations() + 1);
                session.merge(event);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error incrementing registration count for event: " + eventId, e);
            return false;
        }
    }

    public synchronized boolean decrementRegistration(Long eventId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            Event event = session.get(Event.class, eventId);
            if (event != null && event.getCurrentRegistrations() > 0) {
                event.setCurrentRegistrations(event.getCurrentRegistrations() - 1);
                session.merge(event);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error decrementing registration count for event: " + eventId, e);
            return false;
        }
    }

    public long countTotalEvents() {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return 0;
            Long count = session.createQuery("SELECT COUNT(e) FROM Event e", Long.class).uniqueResult();
            return count != null ? count : 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error counting total events", e);
            return 0;
        }
    }

    public long countPendingProposals() {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return 0;
            Query<Long> query = session.createQuery(
                "SELECT COUNT(e) FROM Event e WHERE e.status = :status",
                Long.class
            );
            query.setParameter("status", EventStatus.PENDING_APPROVAL);
            Long count = query.uniqueResult();
            return count != null ? count : 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error counting pending proposals", e);
            return 0;
        }
    }
}
