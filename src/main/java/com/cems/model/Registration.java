package com.cems.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "registrations",
       uniqueConstraints = {@UniqueConstraint(columnNames = {"event_id", "user_id"})})
public class Registration implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ticket_code", length = 50, unique = true, nullable = false)
    private String ticketCode;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "event_id", nullable = false)
    private Event event;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "registration_date", nullable = false)
    private LocalDateTime registrationDate = LocalDateTime.now();

    @Enumerated(EnumType.STRING)
    @Column(name = "attendance_status", length = 30, nullable = false)
    private AttendanceStatus attendanceStatus = AttendanceStatus.REGISTERED;

    @Column(name = "qr_data", length = 500)
    private String qrData;

    // team registration details
    @Column(name = "team_name", length = 150)
    private String teamName;

    @Column(name = "team_members", length = 500)
    private String teamMembers;

    // score and merit ranking
    @Column(name = "score", length = 50)
    private String score;

    @Column(name = "merit_rank", length = 50)
    private String meritRank;

    // certificate unique reference code
    @Column(name = "certificate_code", length = 80)
    private String certificateCode;

    public Registration() {
    }

    public Registration(String ticketCode, Event event, User user, String qrData) {
        this.ticketCode = ticketCode;
        this.event = event;
        this.user = user;
        this.qrData = qrData;
        this.registrationDate = LocalDateTime.now();
        this.attendanceStatus = AttendanceStatus.REGISTERED;
    }

    // constructor with team details
    public Registration(String ticketCode, Event event, User user, String qrData, String teamName, String teamMembers) {
        this.ticketCode = ticketCode;
        this.event = event;
        this.user = user;
        this.qrData = qrData;
        this.teamName = teamName;
        this.teamMembers = teamMembers;
        this.registrationDate = LocalDateTime.now();
        this.attendanceStatus = AttendanceStatus.REGISTERED;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTicketCode() {
        return ticketCode;
    }

    public void setTicketCode(String ticketCode) {
        this.ticketCode = ticketCode;
    }

    public Event getEvent() {
        return event;
    }

    public void setEvent(Event event) {
        this.event = event;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public LocalDateTime getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(LocalDateTime registrationDate) {
        this.registrationDate = registrationDate;
    }

    public AttendanceStatus getAttendanceStatus() {
        return attendanceStatus;
    }

    public void setAttendanceStatus(AttendanceStatus attendanceStatus) {
        this.attendanceStatus = attendanceStatus;
    }

    public String getQrData() {
        return qrData;
    }

    public void setQrData(String qrData) {
        this.qrData = qrData;
    }

    // getter and setter for team name
    public String getTeamName() {
        return teamName;
    }

    public void setTeamName(String teamName) {
        this.teamName = teamName;
    }

    // getter and setter for team members
    public String getTeamMembers() {
        return teamMembers;
    }

    public void setTeamMembers(String teamMembers) {
        this.teamMembers = teamMembers;
    }

    // getter and setter for score
    public String getScore() {
        return score;
    }

    public void setScore(String score) {
        this.score = score;
    }

    // getter and setter for merit rank
    public String getMeritRank() {
        return meritRank;
    }

    public void setMeritRank(String meritRank) {
        this.meritRank = meritRank;
    }

    // getter and setter for certificate code
    public String getCertificateCode() {
        if (certificateCode == null && ticketCode != null) {
            return "CU-CERT-" + (event != null ? event.getId() : "0") + "-" + ticketCode.replace("CEMS-TKT-", "");
        }
        return certificateCode;
    }

    public void setCertificateCode(String certificateCode) {
        this.certificateCode = certificateCode;
    }

    // check if student attended and is eligible for certificate
    public boolean isEligibleForCertificate() {
        return attendanceStatus == AttendanceStatus.ATTENDED;
    }

    // check if this is a team registration
    public boolean isTeam() {
        return teamName != null && !teamName.trim().isEmpty();
    }
}
