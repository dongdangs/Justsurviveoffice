package com.spring.app.security.filter;

import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.atomic.AtomicReference;

import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

@Component
public class AdminOneTimeCode implements ApplicationRunner {
    private final AtomicReference<String> code = new AtomicReference<>();

    public String current() { return code.get(); }
    public void rotate() { code.set(String.format("%06d", ThreadLocalRandom.current().nextInt(0, 1_000_000))); }

    @Override
    public void run(ApplicationArguments args) {
        rotate();
        System.out.println("[ADMIN ONE-TIME CODE] " + current()); // 콘솔로만 공지
    }
}
