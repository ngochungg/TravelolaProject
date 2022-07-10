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
        return postRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Invalid post Id:" + id));
    }


}
