package com.bezkoder.springjwt.payload.request;

import com.bezkoder.springjwt.models.User;
import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;


@Getter
@Setter
public class PostRequest {
    private String content;
    private String title;
    private String description;
    private MultipartFile imageUrl;
    private User userId;
}
