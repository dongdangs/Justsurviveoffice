package com.spring.app.admin.controller;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.common.MyUtil;
import com.spring.app.entity.Users;
import com.spring.app.admin.service.AdminService;
import com.spring.app.users.domain.UsersDTO;
import com.spring.app.users.service.UsersService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor  // @RequiredArgsConstructor는 Lombok 라이브러리에서 제공하는 애너테이션으로, final 필드 또는 @NonNull이 붙은 필드에 대해 생성자를 자동으로 생성해준다.
@RequestMapping("admin/")
public class AdminController {
   
   // === 생성자 주입(Constructor Injection) === //
   private final AdminService adminService;
   private final UsersService usersService;
   
   @GetMapping("/adm")
   public String adminIndex() {
	   return "admin/adm";
   }
   
   // 회원목록 전체보기(페이징 처리)
   @GetMapping("usersList")
   public String userList(@RequestParam(name="searchType", defaultValue="")  String searchType,
                     @RequestParam(name="searchWord", defaultValue="")  String searchWord,
                     @RequestParam(value="pageno",    defaultValue="1") int currentShowPageNo   /* 현재 페이지번호 */,
                     @RequestParam(value = "sizePerPage", defaultValue = "5") int sizePerPage,   // 한 페이자당 보여질 행의 개수.
                     Model model,
                     HttpServletRequest request, HttpServletResponse response) {
      
      int totalPage = 0;        // 전체 페이지 개수
      long totalDataCount = 0;  // 전체 데이터의 개수
      String pageBar = "";      // 페이지바
      
      try {
         Page<UsersDTO> pageUsers = adminService.getPageUserList(searchType, searchWord, currentShowPageNo, sizePerPage);
         
         totalPage = pageUsers.getTotalPages();   // 전체 페이지수 개수
         
         if(currentShowPageNo > totalPage) {
            currentShowPageNo = totalPage;
            pageUsers = adminService.getPageUserList(searchType, searchWord, currentShowPageNo, sizePerPage);
         }
         
         totalDataCount = pageUsers.getTotalElements();   // 전체 데이터의 개수
         
         List<UsersDTO> UsersDtoList = pageUsers.getContent();   // 현재 페이지의 데이터 목록
      /*   
         // 현재 페이지의 데이터 목록인 List<Users> 를 List<UsersDTO> 로 변환한다.
         List<UsersDTO> UsersDtoList = usersList.stream()
                                    .map(Users::toDTO)
                                    .collect(Collectors.toList());
      */   
         model.addAttribute("UsersDtoList", UsersDtoList);
         
         if(!"".equals(searchType) && !"".equals(searchWord)) {
            model.addAttribute("searchType", searchType);   // view 단 페이지에서 검색타입 유지
            model.addAttribute("searchWord", searchWord);   // view 단 페이지에서 검색어 유지
         }
         
         
         // ================ 페이지바 만들기 시작 ================ //
         
         int blockSize = 10;
         // blockSize 는 1개 블럭(토막)당 보여지는 페이지번호의 개수이다.
         
         int loop = 1;
         /*
             loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[ 지금은 10개(== blockSize) ] 까지만 증가하는 용도이다.
         */
         
         int pageno = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
         // *** !! 공식이다. !! *** //
         
         String url = request.getContextPath() + "/admin/usersList";
         
         // === [맨처음][이전] 만들기 === //
         pageBar += "<li class='page-item'><a class='page-link' href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+ "&sizePerPage=" + sizePerPage + "&pageno=1'>⏪</a></li>";
         
         if(pageno != 1) {
            pageBar += "<li class='page-item'><a class='page-link' href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+ "&sizePerPage=" + sizePerPage + "&pageno="+(pageno-1)+"'>◀️</a></li>"; 
         }
         
         while( !(loop > blockSize || pageno > totalPage) ) {
            
            if(pageno == currentShowPageNo) {
               pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageno+"</a></li>";
            }
            else {
               pageBar += "<li class='page-item'><a class='page-link' href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+ "&sizePerPage=" + sizePerPage + "&pageno="+pageno+"'>"+pageno+"</a></li>"; 
            }
            
            loop++;
            pageno++;
         }// end of while------------------------
         
         // === [다음][마지막] 만들기 === //
         if(pageno <= totalPage) {
            pageBar += "<li class='page-item'><a class='page-link' href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+ "&sizePerPage=" + sizePerPage + "&pageno="+pageno+"'>▶️</a></li>";
         }
         
         pageBar += "<li class='page-item'><a class='page-link' href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+ "&sizePerPage=" + sizePerPage + "&pageno="+totalPage+"'>⏩</a></li>"; 
         
         model.addAttribute("pageBar", pageBar);
         
         // ================ 페이지바 만들기 끝 ================ //
         
         model.addAttribute("totalDataCount", totalDataCount); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임. 
         model.addAttribute("currentShowPageNo", currentShowPageNo); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
         model.addAttribute("sizePerPage", sizePerPage); // 페이징 처리시 보여주는 순번을 나타내기 위한 것임.
         
         // 페이징 처리되어진 후 특정 글제목을 클릭하여 상세내용을 본 이후
         // 사용자가 "검색된결과목록보기" 버튼을 클릭했을때 돌아갈 페이지를 알려주기 위해 현재 페이지 URL 주소를 쿠키에 저장한다.
         String listURL = MyUtil.getCurrentURL(request);
         
         Cookie cookie = new Cookie("listURL", listURL); 
         // new Cookie(쿠키명, 쿠키값); 
         // Cookie 클래스 임포트시 jakarta.servlet.http.Cookie 임.
         
         cookie.setMaxAge(24*60*60); // 쿠키수명은 1일로 함
         cookie.setPath("/admin/");  // 쿠키가 브라우저에서 전송될 URL 경로 범위(Path)를 지정하는 설정임
         /*
            Path를 /board/ 로 설정하면:
            /board/view_2, /board/view 등 /board/ 로 시작하는 경로에서만 쿠키가 전송된다.
             * /, /index, /login 등의 다른 경로에서는 이 쿠키는 사용되지 않음.   
         */
         response.addCookie(cookie); // 쿠키에 저장. 접속한 클라이언트 PC로 쿠키를 보내줌
         
      } catch (Exception e) {
         e.printStackTrace();
      }
      return "admin/usersList";
   }
   
   // 특정 회원 1명 상세보기
   @GetMapping("usersDetail")
   public String userdetail(@RequestParam(name = "id") String id,
                      Model model) {
      
      UsersDTO usersDto = adminService.getUsers(id);
      model.addAttribute("usersDto", usersDto);
      
      return "admin/usersDetail";
   }
   
   // 뷰 반환: /admin/chart
   @GetMapping("/chart")
   public String chart() {
       return "admin/chart";  // /WEB-INF/views/admin/chart.jsp
   }

   // JSON 반환: /admin/chart/registerChart
   @GetMapping(value = "/chart/registerChart", produces = "application/json; charset=UTF-8")
   @ResponseBody
   public List<Map<String,String>> registerChart(
           @RequestParam(name = "year", required = false) Integer year // ★ name 명시!
   ) {
       return (year == null) ? usersService.registerChart()
                             : usersService.registerChart(year);
   }
   
}
