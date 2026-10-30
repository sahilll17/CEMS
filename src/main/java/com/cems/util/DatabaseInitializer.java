package com.cems.util;

import com.cems.dao.EventDao;
import com.cems.dao.NotificationDao;
import com.cems.dao.RegistrationDao;
import com.cems.dao.UserDao;
import com.cems.dao.VenueDao;
import com.cems.model.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DatabaseInitializer {

    private static final Logger LOGGER = Logger.getLogger(DatabaseInitializer.class.getName());

    public static void main(String[] args) {
        initialize();
        System.out.println("INITIALIZATION_COMPLETE");
    }

    public static void initialize() {
        try {
            UserDao userDao = new UserDao();
            VenueDao venueDao = new VenueDao();
            EventDao eventDao = new EventDao();
            RegistrationDao registrationDao = new RegistrationDao();
            NotificationDao notificationDao = new NotificationDao();

            // If users exist, update their passwords to ensure valid BCrypt hashes
            if (userDao.countUsers() > 0) {
                User adminUser = userDao.findByEmail("admin@cems.edu");
                if (adminUser != null) {
                    adminUser.setPasswordHash(PasswordUtil.hashPassword("admin123"));
                    userDao.update(adminUser);
                }
                User orgUser = userDao.findByEmail("organizer@cems.edu");
                if (orgUser != null) {
                    orgUser.setPasswordHash(PasswordUtil.hashPassword("organizer123"));
                    userDao.update(orgUser);
                }
                User stuUser = userDao.findByEmail("student@cems.edu");
                if (stuUser != null) {
                    stuUser.setPasswordHash(PasswordUtil.hashPassword("student123"));
                    userDao.update(stuUser);
                }

                // ensure past attended event with certificate exists for Sahil Sharma
                if (registrationDao.countTotalRegistrations() <= 1) {
                    User sahil = userDao.findByUid("26MCI10257");
                    User organizer = userDao.findByEmail("organizer@cems.edu");
                    List<Venue> venues = venueDao.getActiveVenues();
                    Venue lab = !venues.isEmpty() ? venues.get(0) : null;
                    if (sahil != null && organizer != null && lab != null) {
                        LocalDate today = LocalDate.now();
                        Event pastEvent = new Event(
                            "UIC Intra-College Web Innovation Hackathon 2025",
                            "HACKATHON",
                            "Intra-department innovation challenge where MCA students designed full-stack database web applications using Servlets and JSP.",
                            lab,
                            today.minusDays(8),
                            LocalTime.of(9, 0),
                            LocalTime.of(17, 0),
                            60,
                            EventStatus.APPROVED,
                            organizer,
                            "https://images.unsplash.com/photo-1531403009284-440f080d1e12?auto=format&fit=crop&w=1200&q=80"
                        );
                        pastEvent.setCurrentRegistrations(1);
                        pastEvent.setRules("1. Team size 2-4 members.\n2. Java MVC architecture required.");
                        pastEvent.setMaxTeamSize(3);
                        eventDao.save(pastEvent);

                        Registration pastReg = new Registration("CEMS-TKT-CU89A12", pastEvent, sahil, "CEMS_PASS|TICKET:CEMS-TKT-CU89A12|UID:26MCI10257|EVENT:" + pastEvent.getId() + "|NAME:Sahil Sharma", "AI Mavericks", "Sahil Sharma (26MCI10257), Aman Verma (26MC110245)");
                        pastReg.setAttendanceStatus(AttendanceStatus.ATTENDED);
                        pastReg.setMeritRank("WINNER (1ST PLACE)");
                        pastReg.setScore("96/100");
                        pastReg.setCertificateCode("CU-CERT-2025-WIN-26MCI10257");
                        pastReg.setRegistrationDate(LocalDateTime.now().minusDays(10));
                        registrationDao.save(pastReg);
                    }
                }

                LOGGER.info("Database users verified and BCrypt credentials updated.");
                return;
            }

            LOGGER.info("Starting initial seed data population for CEMS...");

            // 1. Seed Users
            // Admin user
            User admin = new User(
                "ADMIN001",
                "Head Administrator",
                "admin@cems.edu",
                PasswordUtil.hashPassword("admin123"),
                Role.ADMIN,
                "University Administration",
                "Faculty",
                "+91 98765 00001"
            );
            userDao.save(admin);

            // Faculty Organizer
            User organizer = new User(
                "ORG001",
                "Dr. Shruti Sharma",
                "organizer@cems.edu",
                PasswordUtil.hashPassword("organizer123"),
                Role.ORGANIZER,
                "University Institute of Computing",
                "Assistant Professor",
                "+91 98765 00002"
            );
            userDao.save(organizer);

            // Student User (Sahil Sharma)
            User student = new User(
                "26MCI10257",
                "Sahil Sharma",
                "26MCI10257@cuchd.in",
                PasswordUtil.hashPassword("Sahil@123"),
                Role.STUDENT,
                "MCA (AI ML)",
                "Section MAM-4B",
                "9876510257"
            );
            userDao.save(student);

            // Additional Student
            User student2 = new User(
                "26MC110245",
                "Aman Verma",
                "aman@cems.edu",
                PasswordUtil.hashPassword("student123"),
                Role.STUDENT,
                "MCA (AI ML)",
                "Section MAM-4B",
                "+91 98765 11025"
            );
            userDao.save(student2);

            // 2. Seed Venues
            Venue aud = new Venue(
                "University Main Auditorium (Block 3)",
                "Block 3, Ground Floor",
                600,
                "Central air-conditioned university auditorium equipped for major conventions, symposiums, and keynote ceremonies.",
                "Dual 4K Laser Projectors, High-end JBL Surround Sound, Stage Lighting, Podium & Wireless Mics, Wi-Fi 6"
            );
            venueDao.save(aud);

            Venue semHall = new Venue(
                "UIC Seminar Hall A",
                "UIC Academic Block, 2nd Floor",
                150,
                "Modern tiered auditorium designed for technical paper presentations, workshops, and faculty interactions.",
                "Interactive Smart Board, AC, High-speed LAN, Ceiling Speakers, Dual Lapel Mics"
            );
            venueDao.save(semHall);

            Venue aiLab = new Venue(
                "Advanced AI/ML Research Lab 4",
                "UIC Block, 3rd Floor",
                75,
                "Specialized computing laboratory with high-performance workstations for hackathons and coding marathons.",
                "75 High-end GPU Workstations, Gigabit LAN, Overhead Projector, Dedicated UPS Backup"
            );
            venueDao.save(aiLab);

            Venue sportsArena = new Venue(
                "Campus Sports Complex Arena",
                "Sports & Recreation Wing",
                1200,
                "Multi-purpose indoor sports stadium equipped for university tournaments and athletic competitions.",
                "Hardwood Sports Flooring, Electronic Scoreboard, Stadium Floodlights, Sound System"
            );
            venueDao.save(sportsArena);

            Venue oat = new Venue(
                "Open Air Theatre (OAT)",
                "Central Campus Lawn",
                800,
                "Vibrant amphitheatre environment for cultural fests, music concerts, and theatrical performances.",
                "Acoustic Sound Shell, Tiered Seating, Outdoor Stage Truss, Professional Audio Mixers"
            );
            venueDao.save(oat);

            // 3. Seed Events
            LocalDate today = LocalDate.now();

            Event event1 = new Event(
                "TechFusion 2026: 36-Hour National AI & ML Hackathon",
                "HACKATHON",
                "Chandigarh University presents TechFusion 2026! Bring your laptops and build cutting-edge solutions in Generative AI, Computer Vision, and Autonomous Systems. Mentorship by industry experts and prizes worth INR 2,50,000.",
                aiLab,
                today.plusDays(4),
                LocalTime.of(9, 30),
                LocalTime.of(18, 0),
                70,
                EventStatus.APPROVED,
                organizer,
                "https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=1200&q=80"
            );
            event1.setCurrentRegistrations(1);
            event1.setRules("1. Maximum 4 members per team.\n2. All source code must be created during the event.\n3. University ID card mandatory.");
            event1.setRegistrationDeadline(today.plusDays(2));
            event1.setMaxTeamSize(4);
            eventDao.save(event1);

            Event event2 = new Event(
                "Hands-on Workshop: Enterprise Cloud Microservices with Kubernetes",
                "WORKSHOP",
                "Master containerization and cloud orchestration. Learn Docker multi-stage builds, Kubernetes deployments, service discovery, and automated CI/CD pipelines with real-world hands-on labs.",
                semHall,
                today.plusDays(7),
                LocalTime.of(10, 0),
                LocalTime.of(16, 0),
                120,
                EventStatus.APPROVED,
                organizer,
                "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?auto=format&fit=crop&w=1200&q=80"
            );
            event2.setRules("1. Individual participation only.\n2. Laptop required with at least 8GB RAM.\n3. Docker pre-installed.");
            event2.setRegistrationDeadline(today.plusDays(5));
            event2.setMaxTeamSize(1);
            eventDao.save(event2);

            Event event3 = new Event(
                "CUGlitz 2026: Annual Inter-College Cultural Extravaganza",
                "CULTURAL",
                "Experience the biggest cultural festival of the year! Live performances, Battle of the Bands, folk dancing, drama competitions, and celebrity musical guest appearance.",
                oat,
                today.plusDays(12),
                LocalTime.of(17, 0),
                LocalTime.of(22, 30),
                750,
                EventStatus.APPROVED,
                admin,
                "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=1200&q=80"
            );
            event3.setRules("1. College ID mandatory at entry.\n2. Team registration allowed for dance and drama fests.");
            event3.setMaxTeamSize(6);
            eventDao.save(event3);

            Event event4 = new Event(
                "Inter-Department Badminton & Futsal Championship",
                "SPORTS",
                "Annual university sports tournament open to all undergraduate and postgraduate departments. Medals, trophies, and certificates awarded to all winners and finalists.",
                sportsArena,
                today.plusDays(18),
                LocalTime.of(8, 30),
                LocalTime.of(17, 0),
                500,
                EventStatus.APPROVED,
                organizer,
                "https://images.unsplash.com/photo-1517649763962-0c623266ddc0?auto=format&fit=crop&w=1200&q=80"
            );
            event4.setRules("1. Standard sports kit mandatory.\n2. Department representation required.");
            event4.setMaxTeamSize(5);
            eventDao.save(event4);

            Event event5 = new Event(
                "International Symposium on Quantum Computing & Cyber Security",
                "SEMINAR",
                "Proposed symposium featuring keynote addresses from distinguished IEEE researchers and industry pioneers on post-quantum cryptography, quantum algorithms, and future threat landscapes.",
                aud,
                today.plusDays(25),
                LocalTime.of(10, 0),
                LocalTime.of(16, 30),
                450,
                EventStatus.PENDING_APPROVAL,
                organizer,
                "https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=1200&q=80"
            );
            eventDao.save(event5);

            // past event for certificate generation demonstration
            Event pastEvent = new Event(
                "UIC Intra-College Web Innovation Hackathon 2025",
                "HACKATHON",
                "Intra-department innovation challenge where MCA students designed full-stack database web applications using Servlets and JSP.",
                aiLab,
                today.minusDays(8),
                LocalTime.of(9, 0),
                LocalTime.of(17, 0),
                60,
                EventStatus.APPROVED,
                organizer,
                "https://images.unsplash.com/photo-1531403009284-440f080d1e12?auto=format&fit=crop&w=1200&q=80"
            );
            pastEvent.setCurrentRegistrations(1);
            pastEvent.setRules("1. Team size 2-4 members.\n2. Java MVC architecture required.");
            pastEvent.setMaxTeamSize(3);
            eventDao.save(pastEvent);

            // 4. Seed Student Registrations for Sahil Sharma
            String ticketCode1 = "CEMS-TKT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            String qrData1 = "CEMS_PASS|TICKET:" + ticketCode1 + "|UID:" + student.getUid() + "|EVENT:" + event1.getId() + "|NAME:" + student.getName();
            Registration reg1 = new Registration(ticketCode1, event1, student, qrData1);
            reg1.setRegistrationDate(LocalDateTime.now().minusHours(2));
            registrationDao.save(reg1);

            // past attended event with Winner merit rank and certificate
            String ticketCode2 = "CEMS-TKT-CU89A12";
            String qrData2 = "CEMS_PASS|TICKET:" + ticketCode2 + "|UID:" + student.getUid() + "|EVENT:" + pastEvent.getId() + "|NAME:" + student.getName();
            Registration pastReg = new Registration(ticketCode2, pastEvent, student, qrData2, "AI Mavericks", "Sahil Sharma (26MCI10257), Aman Verma (26MC110245)");
            pastReg.setAttendanceStatus(AttendanceStatus.ATTENDED);
            pastReg.setMeritRank("WINNER (1ST PLACE)");
            pastReg.setScore("96/100");
            pastReg.setCertificateCode("CU-CERT-2025-WIN-26MCI10257");
            pastReg.setRegistrationDate(LocalDateTime.now().minusDays(10));
            registrationDao.save(pastReg);

            // 5. Seed Notifications
            Notification notif1 = new Notification(
                student,
                event1,
                "Registration Confirmed: TechFusion 2026",
                "Your registration for 'TechFusion 2026: 36-Hour National AI & ML Hackathon' has been confirmed! Your Digital Ticket Reference is " + ticketCode1 + ". Please bring your digital pass to UIC Computer Lab 4.",
                "REGISTRATION"
            );
            notificationDao.save(notif1);

            Notification notifWinner = new Notification(
                student,
                pastEvent,
                "Congratulations! Winner Awarded in Web Innovation Hackathon",
                "Congratulations Sahil Sharma! Your team AI Mavericks secured WINNER (1ST PLACE) with score 96/100 in UIC Intra-College Web Innovation Hackathon 2025. Your Certificate of Merit is now ready to download.",
                "ANNOUNCEMENT"
            );
            notificationDao.save(notifWinner);

            Notification notif2 = new Notification(
                student,
                null,
                "Welcome to Chandigarh University Event Portal",
                "Welcome to CEMS! Browse upcoming cultural, technical, and sports events. Register with one click and access your verifiable digital passes anytime.",
                "GENERAL"
            );
            notificationDao.save(notif2);

            LOGGER.info("CEMS database successfully populated with initial data!");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize sample database data", e);
        }
    }
}
