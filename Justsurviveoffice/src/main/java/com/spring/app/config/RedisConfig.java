package com.spring.app.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.StringRedisSerializer;

@Configuration
public class RedisConfig {
    
    // application.yml에서 값 주입받기
    @Value("${spring.data.redis.host}")
    private String redisHost;
    
    @Value("${spring.data.redis.port}")
    private int redisPort;
    
    /**
     * Redis 연결을 위한 ConnectionFactory 설정
     * Lettuce 라이브러리 사용 (Spring Boot 기본)
     */
    @Bean
    public RedisConnectionFactory redisConnectionFactory() {
        // Redis 서버 연결 정보 설정
        return new LettuceConnectionFactory(redisHost, redisPort);
    }
    
    /**
     * Redis와 데이터를 주고받기 위한 RedisTemplate 설정
     */
    @Bean
    public RedisTemplate<String, Object> redisTemplate() {
        RedisTemplate<String, Object> redisTemplate = new RedisTemplate<>();
        
        // Redis 연결 설정
        redisTemplate.setConnectionFactory(redisConnectionFactory());
        
        // Key-Value 직렬화 방식 설정 (문자열로 저장)
        redisTemplate.setKeySerializer(new StringRedisSerializer());
        redisTemplate.setValueSerializer(new StringRedisSerializer());
        
        // Hash 사용시 직렬화 설정 (나중에 필요하면)
        redisTemplate.setHashKeySerializer(new StringRedisSerializer());
        redisTemplate.setHashValueSerializer(new StringRedisSerializer());
        
        return redisTemplate;
    }
}
