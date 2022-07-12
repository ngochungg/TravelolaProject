package com.bezkoder.springjwt.controllers;

import com.bezkoder.springjwt.models.Post;
import com.bezkoder.springjwt.payload.request.PostRequest;
import com.bezkoder.springjwt.payload.response.MessageResponse;
import com.bezkoder.springjwt.repository.PostRepository;
import com.bezkoder.springjwt.repository.UserRepository;
import com.bezkoder.springjwt.security.services.IStorageService;
import com.bezkoder.springjwt.services.EmailSenderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/posts")
public class PostController {
    @Autowired
    private PostRepository postRepository;
    @Autowired
    IStorageService storageService;

    @Autowired
    EmailSenderService emailSenderService;
    @Autowired
    private UserRepository userRepository;

    // add post
    @PostMapping("/add")
    public ResponseEntity<?> addPost(PostRequest postRequest) {
        if (postRepository.existsByTitle(postRequest.getTitle())) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Title is already in use!"));
        }
        //upload image
        String imageUrl = storageService.storeFile(postRequest.getImageUrl());
        //save post
        Post post = new Post();
        post.setTitle(postRequest.getTitle());
        post.setContent(postRequest.getContent());
        post.setDescription(postRequest.getDescription());
        post.setImageUrl(imageUrl);
        post.setUser(postRequest.getUserId());
        postRepository.save(post);
        return ResponseEntity.ok(new MessageResponse("Post added successfully!"));
    }

    // get all posts
    @GetMapping("/all")
    public List<Post> getAllPosts() {
        return postRepository.findAll();
    }
    // get post by id
    @GetMapping("/{id}")
    public Post getPostById(@PathVariable long id) {
        //increase view count
        Post post = postRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Invalid post Id:" + id));
        post.setViewCount(post.getViewCount() + 1);
        postRepository.save(post);
        return post;
    }
    //edit post
        @PutMapping("/edit/{id}")
    public ResponseEntity<?> editPost(@PathVariable long id, PostRequest postRequest) {
        Post post = postRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Invalid post Id:" + id));
        //if image not null
        if (postRequest.getImageUrl() != null) {
            //upload image
            String imageUrl = storageService.storeFile(postRequest.getImageUrl());
            post.setImageUrl(imageUrl);
        }
        //if title not null
        if (postRequest.getTitle() != null) {
            if (postRepository.existsByTitle(postRequest.getTitle())) {
                return ResponseEntity
                        .badRequest()
                        .body(new MessageResponse("Error: Title is already in use!"));
            }
            post.setTitle(postRequest.getTitle());
        }
        //if content not null
        if (postRequest.getContent() != null) {
            post.setContent(postRequest.getContent());
        }
        //if description not null
        if (postRequest.getDescription() != null) {
            post.setDescription(postRequest.getDescription());
        }
        postRepository.save(post);
        return ResponseEntity.ok(new MessageResponse("Post updated successfully!"));
    }

    //like post
    @PutMapping("/like/{id}")
    public ResponseEntity<?> likePost(@PathVariable long id) {
        Post post = postRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Invalid post Id:" + id));
        post.setLikeCount(post.getLikeCount() + 1);
        postRepository.save(post);
        return ResponseEntity.ok(new MessageResponse("Post liked successfully!"));
    }
    //unlike post
    @PutMapping("/unlike/{id}")
    public ResponseEntity<?> unlikePost(@PathVariable long id) {
        Post post = postRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Invalid post Id:" + id));
        post.setDislikeCount(post.getDislikeCount() + 1);
        postRepository.save(post);
        return ResponseEntity.ok(new MessageResponse("Post unliked successfully!"));
    }
    //lock post
    @PutMapping("/lock/{id}")
    public ResponseEntity<?> lockPost(@PathVariable long id) {
        Post post = postRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Invalid post Id:" + id));
        post.setStatus(true);
        postRepository.save(post);
        return ResponseEntity.ok(new MessageResponse("Post locked successfully!"));
    }
    //unlock post
    @PutMapping("/unlock/{id}")
    public ResponseEntity<?> unlockPost(@PathVariable long id) {
        Post post = postRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Invalid post Id:" + id));
        post.setStatus(false);
        postRepository.save(post);
        return ResponseEntity.ok(new MessageResponse("Post unlocked successfully!"));
    }
    //search post by title
    @GetMapping("/search/{title}")
    public List<Post> searchPostByTitle(@PathVariable String title) {
        List<Post> posts = postRepository.findAll();
        //filter posts by title
        posts = posts.stream().filter(post -> post.getTitle().toLowerCase().contains(title.toLowerCase())).collect(
                java.util.stream.Collectors.toList());
        return posts;
    }

}
