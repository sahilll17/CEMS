package com.cems.dao;

import com.cems.model.AttendanceStatus;
import com.cems.model.Event;
import com.cems.model.Registration;
import com.cems.model.User;
import com.cems.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RegistrationDao {

    private static final Logger LOGGER = Logger.getLogger(RegistrationDao.class.getName());

    public boolean save(Registration registration) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            session.persist(registration);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error saving registration", e);
            return false;
        }
    }

    public boolean update(Registration registration) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            session.merge(registration);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error updating registration ID: " + registration.getId(), e);
            return false;
        }
    }

    public Registration findById(Long id) {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return null;
            return session.get(Registration.class, id);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding registration by id: " + id, e);
            return null;
        }
    }

    public Registration findByTicketCode(String ticketCode) {
        if (ticketCode == null) return null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return null;
            Query<Registration> query = session.createQuery(
                "FROM Registration r WHERE r.ticketCode = :ticketCode",
                Registration.class
            );
            query.setParameter("ticketCode", ticketCode.trim());
            return query.uniqueResult();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding registration by ticket code: " + ticketCode, e);
            return null;
        }
    }

    public boolean isStudentRegistered(Long eventId, Long userId) {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            Query<Long> query = session.createQuery(
                "SELECT COUNT(r) FROM Registration r WHERE r.event.id = :eventId AND r.user.id = :userId AND r.attendanceStatus != :cancelled",
                Long.class
            );
            query.setParameter("eventId", eventId);
            query.setParameter("userId", userId);
            query.setParameter("cancelled", AttendanceStatus.CANCELLED);
            Long count = query.uniqueResult();
            return count != null && count > 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking if student is registered", e);
            return false;
        }
    }

    public List<Registration> getUserRegistrations(Long userId) {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return Collections.emptyList();
            Query<Registration> query = session.createQuery(
                "FROM Registration r WHERE r.user.id = :userId AND r.attendanceStatus != :cancelled ORDER BY r.event.eventDate DESC, r.event.startTime ASC",
                Registration.class
            );
            query.setParameter("userId", userId);
            query.setParameter("cancelled", AttendanceStatus.CANCELLED);
            return query.list();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching user registrations: " + userId, e);
            return Collections.emptyList();
        }
    }

    public List<Registration> getUpcomingUserRegistrations(Long userId) {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return Collections.emptyList();
            Query<Registration> query = session.createQuery(
                "FROM Registration r WHERE r.user.id = :userId AND r.attendanceStatus != :cancelled AND r.event.eventDate >= :today ORDER BY r.event.eventDate ASC, r.event.startTime ASC",
                Registration.class
            );
            query.setParameter("userId", userId);
            query.setParameter("cancelled", AttendanceStatus.CANCELLED);
            query.setParameter("today", LocalDate.now());
            return query.list();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching upcoming registrations: " + userId, e);
            return Collections.emptyList();
        }
    }

    public List<Registration> getPastUserRegistrations(Long userId) {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return Collections.emptyList();
            Query<Registration> query = session.createQuery(
                "FROM Registration r WHERE r.user.id = :userId AND r.attendanceStatus != :cancelled AND r.event.eventDate < :today ORDER BY r.event.eventDate DESC",
                Registration.class
            );
            query.setParameter("userId", userId);
            query.setParameter("cancelled", AttendanceStatus.CANCELLED);
            query.setParameter("today", LocalDate.now());
            return query.list();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching past registrations: " + userId, e);
            return Collections.emptyList();
        }
    }

    public List<Registration> getEventRegistrations(Long eventId) {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return Collections.emptyList();
            Query<Registration> query = session.createQuery(
                "FROM Registration r WHERE r.event.id = :eventId ORDER BY r.registrationDate ASC",
                Registration.class
            );
            query.setParameter("eventId", eventId);
            return query.list();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching event registrations: " + eventId, e);
            return Collections.emptyList();
        }
    }

    public boolean markAttendance(Long registrationId, AttendanceStatus status) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            Registration reg = session.get(Registration.class, registrationId);
            if (reg != null) {
                reg.setAttendanceStatus(status);
                session.merge(reg);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error marking attendance: " + registrationId, e);
            return false;
        }
    }

    // update attendance status, score, and merit rank for a student
    public boolean updateAttendanceAndScore(Long registrationId, AttendanceStatus status, String score, String meritRank) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            Registration reg = session.get(Registration.class, registrationId);
            if (reg != null) {
                if (status != null) {
                    reg.setAttendanceStatus(status);
                }
                if (score != null && !score.trim().isEmpty()) {
                    reg.setScore(score.trim());
                }
                if (meritRank != null && !meritRank.trim().isEmpty()) {
                    reg.setMeritRank(meritRank.trim());
                }
                session.merge(reg);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error updating score and rank: " + registrationId, e);
            return false;
        }
    }

    public boolean cancelRegistration(Long registrationId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            Registration reg = session.get(Registration.class, registrationId);
            if (reg != null && reg.getAttendanceStatus() != AttendanceStatus.CANCELLED) {
                reg.setAttendanceStatus(AttendanceStatus.CANCELLED);
                session.merge(reg);
                Event event = reg.getEvent();
                if (event != null && event.getCurrentRegistrations() > 0) {
                    event.setCurrentRegistrations(event.getCurrentRegistrations() - 1);
                    session.merge(event);
                }
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error cancelling registration: " + registrationId, e);
            return false;
        }
    }

    public long countTotalRegistrations() {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return 0;
            Query<Long> query = session.createQuery(
                "SELECT COUNT(r) FROM Registration r WHERE r.attendanceStatus != :cancelled",
                Long.class
            );
            query.setParameter("cancelled", AttendanceStatus.CANCELLED);
            Long count = query.uniqueResult();
            return count != null ? count : 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error counting registrations", e);
            return 0;
        }
    }

    public long countAttendedRegistrations() {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return 0;
            Query<Long> query = session.createQuery(
                "SELECT COUNT(r) FROM Registration r WHERE r.attendanceStatus = :attended",
                Long.class
            );
            query.setParameter("attended", AttendanceStatus.ATTENDED);
            Long count = query.uniqueResult();
            return count != null ? count : 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error counting attended registrations", e);
            return 0;
        }
    }

    public Map<String, Long> getEventsCountByCategory() {
        Map<String, Long> map = new LinkedHashMap<>();
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return map;
            List<Object[]> rows = session.createQuery(
                "SELECT e.category, COUNT(e) FROM Event e GROUP BY e.category",
                Object[].class
            ).list();
            for (Object[] row : rows) {
                map.put((String) row[0], (Long) row[1]);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching category counts", e);
        }
        return map;
    }

    public List<Event> getTopEventsByRegistrations(int limit) {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return Collections.emptyList();
            return session.createQuery(
                "FROM Event e WHERE e.status = :approved ORDER BY e.currentRegistrations DESC",
                Event.class
            ).setParameter("approved", com.cems.model.EventStatus.APPROVED)
             .setMaxResults(limit)
             .list();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching top events", e);
            return Collections.emptyList();
        }
    }
}
