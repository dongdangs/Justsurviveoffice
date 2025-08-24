package com.spring.app.board.service;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import java.time.Duration;

@Service
public class RedisReadCountService {

		private final RedisTemplate<String, Object> redisTemplate;
	    private final BoardService boardService; // 기존 서비스 주입
	    // 생성자 주입 (@Autowired 생략)
	    public RedisReadCountService(RedisTemplate<String, Object> redisTemplate, 
	                           BoardService boardService) {
	        this.redisTemplate = redisTemplate;
	        this.boardService = boardService;
	    }
	    
	    /**
	     * Redis 중복 체크 후 DB 조회수 증가
	     */
	    public boolean increaseViewCount(String ipAddress, Long boardNo) {
	        
	        String redisKey = "view:" + ipAddress + ":" + boardNo;
	        
	        // Redis에서 중복 체크
	        Object existingRecord = redisTemplate.opsForValue().get(redisKey);
	        
	        if (existingRecord == null) {
	            // 24시간 내 첫 조회 → Redis에 기록 저장
	            redisTemplate.opsForValue().set(redisKey, "viewed", Duration.ofHours(24));
	            
	            // 기존 DB 조회수 증가 메소드 호출
	            int result = boardService.updateReadCount(boardNo);
	            
	            System.out.println("!!조회수 증가시킨 IP입니다 =>" + ipAddress + ", 게시글=" + boardNo);
	            return result == 1; // 성공시 true
	        } 
	        else {
	            System.err.println("!!24시간 내 중복 조회한 IP입니다 =>" + ipAddress + ", 게시글=" + boardNo);
	            return false; // 중복이므로 조회수 증가 안함
	        }
	    }
}

