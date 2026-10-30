package com.cems.dao;

import com.cems.model.Event;
import com.cems.model.Notification;
import com.cems.model.Registration;
import com.cems.model.User;
import com.cems.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class NotificationDao {

    private static final Logger LOGGER = Logger.getLogger(NotificationDao.class.getName());

    public boolean save(Notification notification) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            session.persist(notification);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error saving notification", e);
            return false;
        }
    }

    public List<Notification> getUserNotifications(Long userId) {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return Collections.emptyList();
            Query<Notification> query = session.createQuery(
                "FROM Notification n WHERE n.user.id = :userId ORDER BY n.createdAt DESC",
                Notification.class
            );
            query.setParameter("userId", userId);
            query.setMaxResults(50);
            return query.list();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching user notifications: " + userId, e);
            return Collections.emptyList();
        }
    }

    public long getUnreadCount(Long userId) {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return 0;
            Query<Long> query = session.createQuery(
                "SELECT COUNT(n) FROM Notification n WHERE n.user.id = :userId AND n.read = false",
                Long.class
            );
            query.setParameter("userId", userId);
            Long count = query.uniqueResult();
            return count != null ? count : 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting unread count: " + userId, e);
            return 0;
        }
    }

    public boolean markAsRead(Long notificationId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            Notification notif = session.get(Notification.class, notificationId);
            if (notif != null) {
                notif.setRead(true);
                session.merge(notif);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error marking notification as read: " + notificationId, e);
            return false;
        }
    }

    public boolean markAllAsRead(Long userId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            Query<?> query = session.createQuery(
                "UPDATE Notification n SET n.read = true WHERE n.user.id = :userId"
            );
            query.setParameter("userId", userId);
            query.executeUpdate();
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error marking all notifications as read for user: " + userId, e);
            return false;
        }
    }

    public void notifyEventAttendees(Long eventId, String title, String message, String type) {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return;
            Query<Registration> query = session.createQuery(
                "FROM Registration r WHERE r.event.id = :eventId",
                Registration.class
            );
            query.setParameter("eventId", eventId);
            List<Registration> registrations = query.list();

            Transaction tx = session.beginTransaction();
            for (Registration reg : registrations) {
                Notification n = new Notification(reg.getUser(), reg.getEvent(), title, message, type);
                session.persist(n);
            }
            tx.commit();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error broadcasting notification to attendees of event: " + eventId, e);
        }
    }
}
