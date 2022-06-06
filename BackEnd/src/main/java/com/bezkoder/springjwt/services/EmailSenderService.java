package com.bezkoder.springjwt.services;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

@Service
public class EmailSenderService {
    @Autowired
    private JavaMailSender mailSender;
    public void sendEmail(String to, String subject, String body) {
        //MimeMessage is used to send email
        MimeMessage message = mailSender.createMimeMessage();

        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setFrom("aptechdhtv292001@gmail.com");
            helper.setTo(to);
            helper.setSubject(subject);
            message.setContent(body, "text/html");
            mailSender.send(message);
            System.out.println("Sending email...");
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
    //radom string 8 characters
    public String randomString() {
        StringBuilder sb = new StringBuilder();
        String characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        int len = characters.length();
        for (int i = 0; i < 8; i++) {
            double index = Math.random() * len;
            sb.append(characters.charAt((int) index));
        }
        return sb.toString();
    }
}
