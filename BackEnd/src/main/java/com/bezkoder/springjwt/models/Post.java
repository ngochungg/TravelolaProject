package com.bezkoder.springjwt.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import java.time.Instant;

@Entity
@Table(name = "post")
@Getter
@Setter
public class Post {
    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "title", length = 150)
    private String title;
    @Column(name = "content", columnDefinition = "text")
    private String content;
    @Column(name = "created_at")
    @CreationTimestamp
    private Instant createdAt;
    @Column(name = "updated_at")
    @CreationTimestamp
    private Instant updatedAt;
    @Column(name = "status")
    private boolean status;
    @Column(name = "view_count")
    private int viewCount;
    @Column(name = "like_count")
    private int likeCount;
    @Column(name = "dislike_count")
    private int dislikeCount;
    @Column(name = "image_url")
    private String imageUrl;
    @Column(name = "description", columnDefinition = "text")
    private String description;
    //foreign key user
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    @JsonIgnoreProperties(value = {"posts"})
    private User user;

}
