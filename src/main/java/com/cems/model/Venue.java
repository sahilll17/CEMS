package com.cems.model;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "venues")
public class Venue implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name", length = 150, nullable = false)
    private String name;

    @Column(name = "location", length = 200, nullable = false)
    private String location;

    @Column(name = "capacity", nullable = false)
    private int capacity;

    @Column(name = "description", length = 500)
    private String description;

    @Column(name = "facilities", length = 255)
    private String facilities; // Projector, AC, Sound System, etc.

    @Column(name = "is_active", nullable = false)
    private boolean active = true;

    public Venue() {
    }

    public Venue(String name, String location, int capacity, String description, String facilities) {
        this.name = name;
        this.location = location;
        this.capacity = capacity;
        this.description = description;
        this.facilities = facilities;
        this.active = true;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getFacilities() {
        return facilities;
    }

    public void setFacilities(String facilities) {
        this.facilities = facilities;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
