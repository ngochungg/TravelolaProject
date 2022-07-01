package com.bezkoder.springjwt.services;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.boot.context.properties.bind.DefaultValue;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.mail.javamail.MimeMessagePreparator;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;

import javax.mail.MessagingException;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import java.io.File;
import java.util.Map;
import org.thymeleaf.context.Context;

@Service
public class EmailSenderService {
    @Autowired
    private JavaMailSender mailSender;
    @Autowired
    private TemplateEngine templateEngine;

    public void sendSimpleMessage(String to, String subject, String body) {
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
    public void sendTemplateMessage(String to, @DefaultValue(value = "") String from, String subject, String text) {
        MimeMessagePreparator messagePreparator = mimeMessage -> {
            MimeMessageHelper messageHelper = new MimeMessageHelper(mimeMessage);
            messageHelper.setFrom("aptechdhtv292001@gmail.com");
            messageHelper.setTo(to);
            messageHelper.setSubject(subject);
            messageHelper.setText(text, true);
        };

        mailSender.send(messagePreparator);
        System.out.printf("An email has been sent to " + to);
    }
    public String templateResolve(String templateName, Map<String, Object> map){
        Context ctx = new Context();
        if (map != null) {
            for (Map.Entry<String, Object> stringObjectEntry : map.entrySet()) {
                Map.Entry pair = (Map.Entry) stringObjectEntry;
                ctx.setVariable(pair.getKey().toString(), pair.getValue());
            }
        }
        return templateEngine.process(templateName, ctx);
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
