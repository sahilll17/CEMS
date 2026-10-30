package com.cems.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(name = "events")
public class Event implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "title", length = 200, nullable = false)
    private String title;

    @Column(name = "category", length = 50, nullable = false)
    private String category; // TECHNICAL, CULTURAL, SPORTS, WORKSHOP, SEMINAR, HACKATHON

    @Lob
    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "venue_id", nullable = false)
    private Venue venue;

    @Column(name = "event_date", nullable = false)
    private LocalDate eventDate;

    @Column(name = "start_time", nullable = false)
    private LocalTime startTime;

    @Column(name = "end_time", nullable = false)
    private LocalTime endTime;

    @Column(name = "max_capacity", nullable = false)
    private int maxCapacity;

    @Column(name = "current_registrations", nullable = false)
    private int currentRegistrations = 0;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 30, nullable = false)
    private EventStatus status = EventStatus.PENDING_APPROVAL;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "organizer_id", nullable = false)
    private User organizer;

    @Column(name = "banner_url", length = 500)
    private String bannerUrl;

    @Column(name = "rejection_reason", length = 500)
    private String rejectionReason;

    // event rules and guidelines
    @Lob
    @Column(name = "rules", columnDefinition = "TEXT")
    private String rules;

    // registration deadline date
    @Column(name = "registration_deadline")
    private LocalDate registrationDeadline;

    // maximum team size allowed (1 for individual)
    @Column(name = "max_team_size", nullable = false)
    private int maxTeamSize = 1;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    public Event() {
    }

    public Event(String title, String category, String description, Venue venue, LocalDate eventDate,
                 LocalTime startTime, LocalTime endTime, int maxCapacity, EventStatus status, User organizer, String bannerUrl) {
        this.title = title;
        this.category = category;
        this.description = description;
        this.venue = venue;
        this.eventDate = eventDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.maxCapacity = maxCapacity;
        this.status = status;
        this.organizer = organizer;
        this.bannerUrl = bannerUrl;
        this.currentRegistrations = 0;
        this.createdAt = LocalDateTime.now();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Venue getVenue() {
        return venue;
    }

    public void setVenue(Venue venue) {
        this.venue = venue;
    }

    public LocalDate getEventDate() {
        return eventDate;
    }

    public void setEventDate(LocalDate eventDate) {
        this.eventDate = eventDate;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public int getMaxCapacity() {
        return maxCapacity;
    }

    public void setMaxCapacity(int maxCapacity) {
        this.maxCapacity = maxCapacity;
    }

    public int getCurrentRegistrations() {
        return currentRegistrations;
    }

    public void setCurrentRegistrations(int currentRegistrations) {
        this.currentRegistrations = currentRegistrations;
    }

    public EventStatus getStatus() {
        return status;
    }

    public void setStatus(EventStatus status) {
        this.status = status;
    }

    public User getOrganizer() {
        return organizer;
    }

    public void setOrganizer(User organizer) {
        this.organizer = organizer;
    }

    public String getBannerUrl() {
        return bannerUrl;
    }

    public void setBannerUrl(String bannerUrl) {
        this.bannerUrl = bannerUrl;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    // getter and setter for rules
    public String getRules() {
        return rules;
    }

    public void setRules(String rules) {
        this.rules = rules;
    }

    // getter and setter for registration deadline
    public LocalDate getRegistrationDeadline() {
        return registrationDeadline;
    }

    public void setRegistrationDeadline(LocalDate registrationDeadline) {
        this.registrationDeadline = registrationDeadline;
    }

    // getter and setter for max team size
    public int getMaxTeamSize() {
        return maxTeamSize;
    }

    public void setMaxTeamSize(int maxTeamSize) {
        this.maxTeamSize = maxTeamSize;
    }

    // check if team registration is allowed
    public boolean isTeamAllowed() {
        return maxTeamSize > 1;
    }

    // Computed / Helper methods
    public int getRemainingSeats() {
        int remaining = maxCapacity - currentRegistrations;
        return Math.max(remaining, 0);
    }

    public boolean isFull() {
        return currentRegistrations >= maxCapacity;
    }

    public boolean isApproved() {
        return status == EventStatus.APPROVED;
    }

    public int getCapacityPercentage() {
        if (maxCapacity <= 0) return 100;
        return (int) Math.min(100, Math.round(((double) currentRegistrations / maxCapacity) * 100));
    }
}
