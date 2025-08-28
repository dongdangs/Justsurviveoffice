package com.spring.app.comment.controller;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.comment.service.CommentService;
import com.spring.app.pointlog.model.PointLogDAO;
import com.spring.app.users.domain.CommentDTO;
import com.spring.app.users.domain.UsersDTO;
import com.spring.app.users.service.UsersService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/comment")
@RequiredArgsConstructor
public class CommentController {
	
	private final CommentService commentService;
	private final UsersService usersService;
	private final PointLogDAO pointLogDao;
	
	// 댓글 작성
	@PostMapping("writeComment")
	public String writeComment(ModelAndView modelview, 
								CommentDTO comment,
								Map<String, String> paraMap,
	                         	HttpSession session) {

	    UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
	    if (loginUser == null) {
	        return "redirect:/login";
	    }
	    
	    comment.setFk_id(loginUser.getId());
	    comment.setFk_name(loginUser.getName());

	    commentService.insertComment(comment);
	    
	    int cnt = pointLogDao.getCreatedAtLogCommentCnt(loginUser.getId());
	    if(cnt < 3) { // 유저가 하루동안 쓴 댓글이 3개 이하면 포인트 추가해주기!
	    	paraMap.put("id", loginUser.getId());
			paraMap.put("point", "300");
			
			// paraMap에 저장한 해쉬맵정보는, users용이기 때문에... 레포지토리로 보내야함.
			usersService.getPoint(paraMap); // 300point만큼 user 업데이트!
			pointLogDao.insertPointLogComment(paraMap); // log 도 남기기!
			
			// DB에 각각 update, insert가 끝났다면, 세션까지 포인트 바꿔주기!
			loginUser.setPoint(loginUser.getPoint()+300);
			session.setAttribute("loginUser", loginUser);
			
			System.out.println(loginUser.getPoint());
		} 
		else System.out.println(cnt+"만큼 작성하셨네요! 포인트 stop");
	    
	    return "redirect:/board/view?boardNo="+comment.getFk_boardNo();
	}

	
    //댓글삭제
    @PostMapping("deleteComment")
    @ResponseBody
    public ModelAndView deleteComment(ModelAndView modelview, 
    								 CommentDTO commentDto, HttpSession session) {
    	
        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        
        if(loginUser.getId().equals(commentDto.getFk_id())) {
        	
        	int n = commentService.deleteComment(commentDto.getCommentNo());
        	
        	if(n == 1) {
        		modelview.addObject("message", "댓글이 삭제되었습니다");
        	} else {
        		modelview.addObject("message", "이미 삭제된 댓글입니다.");
        	}
            String ctxPath = session.getServletContext().getContextPath();
        	
            modelview.addObject("loc", ctxPath + "/board/view?boardNo=" + commentDto.getFk_boardNo());
            modelview.setViewName("msg");

        	
        } else {
        	modelview.addObject("message", "접근 불가능한 경로입니다.");
			modelview.addObject("loc", "javascript:history.back()");
			modelview.setViewName("msg");

		}
        return modelview;  
	    
    }
    

    // 댓글 수정
    @PostMapping("/updateComment")
    public String updateComment( @RequestParam(name="commentNo") Long commentNo,
						            @RequestParam(name="content") String content,
		                            @RequestParam(name = "fk_boardNo") Long fkBoardNo,
						            HttpSession session) {

        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "login";
        }

        boolean result = commentService.updateComment(commentNo, content, loginUser.getId());
	 
        return "redirect:/board/view?boardNo=" + fkBoardNo;
        
    }
}
   
	
	

