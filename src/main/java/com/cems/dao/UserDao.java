package com.cems.dao;

import com.cems.model.Role;
import com.cems.model.User;
import com.cems.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDao {

    private static final Logger LOGGER = Logger.getLogger(UserDao.class.getName());

    public boolean save(User user) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            session.persist(user);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error saving user: " + user.getEmail(), e);
            return false;
        }
    }

    public boolean update(User user) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            session.merge(user);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error updating user ID: " + user.getId(), e);
            return false;
        }
    }

    public User findById(Long id) {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return null;
            return session.get(User.class, id);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding user by id: " + id, e);
            return null;
        }
    }

    public User findByEmail(String email) {
        if (email == null) return null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return null;
            Query<User> query = session.createQuery("FROM User WHERE LOWER(email) = :email", User.class);
            query.setParameter("email", email.trim().toLowerCase());
            return query.uniqueResult();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding user by email: " + email, e);
            return null;
        }
    }

    public User findByUid(String uid) {
        if (uid == null) return null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return null;
            Query<User> query = session.createQuery("FROM User WHERE LOWER(uid) = :uid", User.class);
            query.setParameter("uid", uid.trim().toLowerCase());
            return query.uniqueResult();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding user by uid: " + uid, e);
            return null;
        }
    }

    public List<User> getAllUsers() {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return Collections.emptyList();
            return session.createQuery("FROM User ORDER BY createdAt DESC", User.class).list();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching all users", e);
            return Collections.emptyList();
        }
    }

    public List<User> getUsersByRole(Role role) {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return Collections.emptyList();
            Query<User> query = session.createQuery("FROM User WHERE role = :role ORDER BY name ASC", User.class);
            query.setParameter("role", role);
            return query.list();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching users by role: " + role, e);
            return Collections.emptyList();
        }
    }

    public long countUsers() {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return 0;
            Long count = session.createQuery("SELECT COUNT(u) FROM User u", Long.class).uniqueResult();
            return count != null ? count : 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error counting users", e);
            return 0;
        }
    }

    public long countStudents() {
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return 0;
            Query<Long> query = session.createQuery("SELECT COUNT(u) FROM User u WHERE u.role = :role", Long.class);
            query.setParameter("role", Role.STUDENT);
            Long count = query.uniqueResult();
            return count != null ? count : 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error counting students", e);
            return 0;
        }
    }

    public boolean updateStatus(Long userId, String status) {
        Transaction tx = null;
        try (Session session = HibernateUtil.openSession()) {
            if (session == null) return false;
            tx = session.beginTransaction();
            User user = session.get(User.class, userId);
            if (user != null) {
                user.setStatus(status);
                session.merge(user);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Error updating status for user ID: " + userId, e);
            return false;
        }
    }
}
