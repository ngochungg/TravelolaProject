package com.bezkoder.springjwt.security.services;

import com.google.zxing.WriterException;

import java.io.IOException;

public interface QRCodeService {

    byte[] generateQRCode(String qrContent, int width, int height) throws WriterException, IOException;
    //convert byte array to image



}